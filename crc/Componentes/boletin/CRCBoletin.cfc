<cfcomponent displayname="CRCBoletin" hint="Componente para gestionar boletines de clientes" output="false" access="public">
    <cffunction name="getBoletin" access="remote" returntype="array" returnFormat="json" output="false">
        <cfargument name="CURP" type="string" required="true">

        <cftry>
            <cfquery name="q_DatosReporte" datasource="ldcom">
                select distinct Curp_Clave, Curp_Nombre, Curp_Apellido1, Curp_Apellido2
                from curp
                where 1 = 1
                    and upper(Curp_Clave) like upper('%#form.Curp#%')
            </cfquery>

            <cfif q_DatosReporte.recordcount GT 0>
                <cfloop query="q_DatosReporte">
                    <cfset insertBoletin(   
                        CURP_Clave,
                        Curp_Nombre,
                        Curp_Apellido1,
                        Curp_Apellido2,
                        '',
                        0,
                        '',
                        '',
                        session.Usucodigo,
                        'INICIAL',
                        0,
                        "false"
                    )>
                </cfloop> 
            </cfif>

        <cfcatch>
            <!--- Manejo de errores --->
        </cfcatch>
        </cftry>
            

        <cfquery name="q_Boletin" datasource="#session.DSN#">
            SELECT 
                id,
                CURP as ClientCURP,
                Nombre,
                ApellidoPaterno,
                ApellidoMaterno,
                Estado,
                Boletinado,
                BoletinadoSolicitado,
                Motivo,
                Monto,
                Distribuidor,
                Observaciones
            FROM CRCBoletinCliente WHERE CURP like '%#arguments.CURP#%'
        </cfquery>
        
        <cfset resultArray = []>
        <cfloop query="q_Boletin">
            <cfset registro = {
                "id": id,
                "CURP": ClientCURP,
                "Nombre": Nombre,
                "ApellidoPaterno": ApellidoPaterno,
                "ApellidoMaterno": ApellidoMaterno,
                "Estado": Estado,
                "Boletinado": Boletinado,
                "BoletinadoSolicitado": BoletinadoSolicitado,
                "Motivo": Motivo,
                "Monto": Monto,
                "Distribuidor": Distribuidor,
                "Observaciones": Observaciones
            }>
            <cfset arrayAppend(resultArray, registro)>
        </cfloop>
        <cfreturn resultArray>
    </cffunction>

    <cffunction name="getBoletinById" access="remote" returnType="struct" returnFormat="json" output="false">
        <cfargument name="id" type="numeric" required="true">
        
        <cfquery name="q_Boletin" datasource="#session.DSN#">
            SELECT 
                b.*,
                (
                    select CONCAT(dp.Pnombre, ' ', dp.Papellido1, ' ', dp.Papellido2)
                    from Usuario u
                    inner join DatosPersonales dp
                        on u.datos_personales = dp.datos_personales
                    where u.Usucodigo = b.UsuarioActualizacion
                ) as UsuarioSolicita
            FROM CRCBoletinCliente b 
            WHERE b.id = #arguments.id#
        </cfquery>
        
        <cfif q_Boletin.recordCount GT 0>
            <cfset datos = {
                "id": q_Boletin.id,
                "CURP": q_Boletin.CURP,
                "Nombre": q_Boletin.Nombre & " " & q_Boletin.ApellidoPaterno & " " & q_Boletin.ApellidoMaterno,
                "Estado": q_Boletin.Estado,
                "Boletinado": q_Boletin.Boletinado,
                "BoletinadoSolicitado": q_Boletin.BoletinadoSolicitado,
                "Motivo": q_Boletin.Motivo,
                "Monto": q_Boletin.Monto,
                "Distribuidor": q_Boletin.Distribuidor,
                "Observaciones": q_Boletin.Observaciones,
                "UsuarioSolicita": q_Boletin.UsuarioSolicita
            }>
            <cfreturn datos>
        <cfelse>
            <cfreturn {}>
        </cfif>
    </cffunction>

    <cffunction name="getBoletinHistorico" access="remote" returnType="array" returnFormat="json" output="false">
        <cfargument name="id" type="numeric" required="true">

        <cfquery name="q_BoletinHistorico" datasource="#session.DSN#">
            SELECT 
                h.id,
                h.CRCBoletinClienteid,
                h.BoletinadoAnterior,
                h.BoletinadoNuevo,
                h.EstadoAnterior,
                h.EstadoNuevo,
                h.Motivo,
                h.Distribuidor,
                h.Observaciones,
                h.FechaRegistro,
                (
                    select CONCAT(dp.Pnombre, ' ', dp.Papellido1, ' ', dp.Papellido2)
                    from Usuario u
                    inner join DatosPersonales dp
                        on u.datos_personales = dp.datos_personales
                    where u.Usucodigo = h.UsuarioRegistro
                ) as UsuarioRegistro
            FROM CRCBoletinClienteHistorico h
            WHERE h.CRCBoletinClienteid = #arguments.id#
            ORDER BY FechaRegistro DESC
        </cfquery>
        <cfset data = [] />
        
        <cfloop query="q_BoletinHistorico">
            <cfset historial = {
                "id": id,
                "CRCBoletinClienteid": CRCBoletinClienteid,
                "BoletinadoAnterior": BoletinadoAnterior,
                "BoletinadoNuevo": BoletinadoNuevo,
                "EstadoAnterior": EstadoAnterior,
                "EstadoNuevo": EstadoNuevo,
                "Motivo": Motivo,
                "Distribuidor": Distribuidor,
                "Observaciones": Observaciones,
                "FechaRegistro": DateFormat(FechaRegistro, "yyyy-mm-dd") & " " & TimeFormat(FechaRegistro, "HH:mm:ss"),
                "UsuarioRegistro": UsuarioRegistro
            } />
            <cfset ArrayAppend(data, historial) />
        </cfloop>
        
        <cfreturn data>
    </cffunction>

    <cffunction name="getBoletinesPendientes" access="remote" returntype="query" output="false">
        <cfquery name="q_Boletin" datasource="#session.DSN#">
            SELECT 
                b.*,
                (
                    select CONCAT(dp.Pnombre, ' ', dp.Papellido1, ' ', dp.Papellido2)
                    from Usuario u
                    inner join DatosPersonales dp
                        on u.datos_personales = dp.datos_personales
                    where u.Usucodigo = b.UsuarioActualizacion
                ) as UsuarioSolicita
            FROM CRCBoletinCliente b 
            WHERE b.Estado = 'PENDIENTE'
            ORDER BY b.FechaActualizacion DESC
        </cfquery>
        <cfreturn q_Boletin>    
    </cffunction>    

    <cffunction name="insertBoletin"  access="remote"  returnFormat="plain">
        <cfargument name="CURP" type="string" required="true">
        <cfargument name="Nombre" type="string" required="true">
        <cfargument name="ApellidoPaterno" type="string" required="true">
        <cfargument name="ApellidoMaterno" type="string" required="true">
        <cfargument name="Motivo" type="string" required="true">
        <cfargument name="Monto" type="numeric" required="true">
        <cfargument name="Distribuidor" type="string" required="false" default="">
        <cfargument name="Observaciones" type="string" required="true">
        <cfargument name="UsuarioRegistro" type="numeric" required="true">
        <cfargument name="Estado" type="string" required="true">
        <cfargument name="BoletinadoSolicitado" type="numeric" required="true">
        <cfargument name="Update" type="boolean" default="true">
        <cfquery name="q_ExisteBoletin" datasource="#session.dsn#">
            SELECT * FROM CRCBoletinCliente WHERE CURP = '#arguments.CURP#'
        </cfquery>
        <cfif q_ExisteBoletin.recordcount GT 0>
            <cfquery name="q_Boletin" datasource="#session.dsn#">
                UPDATE CRCBoletinCliente SET 
                    Nombre = '#arguments.Nombre#',
                    ApellidoPaterno = '#arguments.ApellidoPaterno#',
                    ApellidoMaterno = '#arguments.ApellidoMaterno#',
                    <cfif arguments.Update>
                        Estado = '#arguments.Estado#',
                        BoletinadoSolicitado = #arguments.BoletinadoSolicitado#,
                        Motivo = '#arguments.Motivo#',
                        Monto = '#arguments.Monto#',
                        Distribuidor = '#arguments.Distribuidor#',
                        Observaciones = '#arguments.Observaciones#',
                    </cfif>
                    UsuarioActualizacion = '#arguments.UsuarioRegistro#'
                WHERE CURP = '#arguments.CURP#'
            </cfquery>
        <cfelse>
            <cfquery name="q_Boletin" datasource="#session.dsn#">
                INSERT INTO CRCBoletinCliente (
                    CURP, 
                    Nombre, 
                    ApellidoPaterno, 
                    ApellidoMaterno, 
                    Monto, 
                    Motivo, 
                    Distribuidor,
                    Observaciones,
                    Estado,
                    BoletinadoSolicitado,
                    UsuarioRegistro, 
                    UsuarioActualizacion
                    )
                VALUES (
                    '#arguments.CURP#',

                    '#arguments.Nombre#',
                    '#arguments.ApellidoPaterno#',
                    '#arguments.ApellidoMaterno#',
                    '#arguments.Monto#',
                    '#arguments.Motivo#',
                    '#arguments.Distribuidor#',
                    '#arguments.Observaciones#',
                    '#arguments.Estado#',
                    #arguments.BoletinadoSolicitado#,
                    '#arguments.UsuarioRegistro#',
                    '#arguments.UsuarioRegistro#'
                )
            </cfquery>
        </cfif>
        <cfreturn "OK">
    </cffunction>

    <cffunction name="aprobarBoletin" access="remote" returnformat="plain">
        <cfargument name="id" type="number" required="true">
        <cfquery name="q_Boletin" datasource="#session.dsn#">
            UPDATE CRCBoletinCliente SET 
                Boletinado = BoletinadoSolicitado,
                Estado = 'APROBADO', 
                UsuarioActualizacion = '#session.Usucodigo#' 
            WHERE id = '#arguments.id#'
        </cfquery>
        <cfreturn "OK">
    </cffunction>

    <cffunction name="rechazarBoletin" access="remote" returnformat="plain">
        <cfargument name="id" type="number" required="true">
        <cfquery name="q_Boletin" datasource="#session.dsn#">
            UPDATE CRCBoletinCliente SET 
                BoletinadoSolicitado = Boletinado,
                Estado = 'RRECHAZADO', 
                UsuarioActualizacion = '#session.Usucodigo#' 
            WHERE id = '#arguments.id#'
        </cfquery>
        <cfreturn "OK">
    </cffunction>

    <cffunction name="cancelarBoletin" access="remote" returnformat="plain">
        <cfargument name="id" type="number" required="true">
        <cfquery name="q_Boletin" datasource="#session.dsn#">
            UPDATE CRCBoletinCliente SET 
                BoletinadoSolicitado = Boletinado,
                Estado = 'CANCELADO', 
                UsuarioActualizacion = '#session.Usucodigo#' 
            WHERE id = '#arguments.id#'
        </cfquery>
        <cfreturn "OK">
    </cffunction>
    
    <cffunction name="desboletinar" access="remote" returnformat="plain">
        <cfargument name="id" type="number" required="true">
        <cfargument name="Observaciones" type="string" required="true">
        <cfargument name="UsuarioRegistro" type="numeric" required="true">
        <cfquery name="q_Boletin" datasource="#session.dsn#">
            UPDATE CRCBoletinCliente SET 
                BoletinadoSolicitado = 0,
                Estado = 'PENDIENTE', 
                UsuarioActualizacion = '#session.Usucodigo#' 
            WHERE id = '#arguments.id#'
        </cfquery>
        <cfreturn "OK">
    </cffunction>

    
</cfcomponent>