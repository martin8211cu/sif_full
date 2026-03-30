
<cfcomponent extends="crc.Componentes.transacciones.CRCTransaccion">
    <cffunction  name="AplicarIncidencia">
        <cfargument name="ID_Incidencia"    required="yes"   type="string">
        <cfargument name="DSN"              required="no"    type="string" default="#session.DSN#">
        <cfargument name="Ecodigo"          required="no"    type="string" default="#session.ecodigo#">

        <cfset Super.init(arguments.DSN,arguments.Ecodigo)>

        <cfquery name="q_Incidencia" datasource="#arguments.DSN#">
            select * from CRCIncidenciasCuenta where id = #arguments.ID_Incidencia# and ecodigo = #arguments.ecodigo#
        </cfquery>
        <cfquery name="q_Corte" datasource="#arguments.DSN#">
            select co.Codigo 
            from CRCCortes co
                inner join CRCCuentas c
                    on c.tipo = co.tipo 
                inner join CRCIncidenciasCuenta i
                    on i.CRCCuentasid = c.id
            where
                '#DateFormat(Now(),"yyyy-mm-dd")#' between co.FechaInicio and co.FechaFin
                and i.id = #arguments.ID_Incidencia#
                and co.ecodigo = #arguments.ecodigo#
        </cfquery>

        <cfset idTransaccion = crearTransaccion(
                        CuentaID            = q_Incidencia.CRCCUENTASID,
                        Tipo_TransaccionID  = q_Incidencia.CRCTIPOTRANSACCIONID,
                        Fecha_Transaccion   = Now(),
                        Monto               = q_Incidencia.MONTO,
                        Observaciones       = q_Incidencia.OBSERVACIONES,
                        AfectaMovCuenta     = true
                )>
<!---
        <cfquery name="q_Afectacion" datasource="#This.DSN#">
            update CRCCuentas set SaldoActual = (ISNull(SaldoActual,0 ) + #q_Incidencia.MONTO#) where id = #q_Incidencia.CRCCuentasid#;
        </cfquery>
--->

    </cffunction>

    <cffunction  name="crearIncidencia">
        <cfargument  name="CuentaID" required="true">
        <cfargument  name="Mensaje" required="true">

        <cfargument  name="CRCTipoTransaccionid" default="null">
        <cfargument  name="Monto" default="0">
        <cfargument  name="TransaccionPendiente" default="1">

        <cfargument  name="usucodigo" default="#session.usucodigo#">
        <cfargument  name="dsn" default="#session.dsn#">
        <cfargument  name="ecodigo" default="#session.ecodigo#">


        <cfquery name="q_cuenta" datasource="#session.DSN#">
            select rtrim(ltrim(Tipo)) as Tipo from CRCCuentas 
                where id = #arguments.CuentaID#
        </cfquery>

        <cfset Cortes = createObject('component', 'crc.Componentes.cortes.CRCCortes')>
        <cfset currentCorte = Cortes.GetCorte(Now(), "#q_cuenta.tipo#","#arguments.dsn#",arguments.ecodigo)>

        <cfquery name="q_usuario" datasource="#session.DSN#">
            select A.llave,B.isAbogado,B.isCobrador from UsuarioReferencia A 
                inner join DatosEmpleado B 
                    on A.llave = B.DEid 
            where A.Usucodigo = #arguments.usucodigo# and STabla = 'DatosEmpleado';
        </cfquery>
        
        <cfset tipoEmpleado = "">
        <cfif q_usuario.isAbogado eq 1>
            <cfset tipoEmpleado = "AB">
        <cfelseif q_usuario.isCobrador eq 1>
            <cfset tipoEmpleado = "GE">
        </cfif>

        <cfquery datasource="#session.dsn#" name="q_inci">
            insert into CRCIncidenciasCuenta (
                CRCCuentasid,Corte,Observaciones, TipoEmpleado, CRCTipoTransaccionid, Monto,TransaccionPendiente,
                DatosEmpleadoDEid, Ecodigo,Usucrea,createdat,Usumodif
                ) values(
                #arguments.CuentaID#,
                '#currentCorte#',
                '#arguments.Mensaje#',
                '#tipoEmpleado#',
                #arguments.CRCTipoTransaccionid#,
                #Arguments.Monto#,
                #Arguments.TransaccionPendiente#,
                '#q_usuario.llave#',
                #arguments.ecodigo#, 
                #arguments.usucodigo#, 
                CURRENT_TIMESTAMP, 
                #arguments.usucodigo#		
                );
            <cf_dbidentity1 datasource="#session.dsn#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.dsn#" name="q_inci" returnvariable="inciID">
        <cfreturn inciID>
    </cffunction>


</cfcomponent>