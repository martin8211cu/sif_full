<!---
	Cierre de Contabilidad Presupuestal 
--->
<cfset Arguments.Conexion = #session.dsn#>

<cfquery name="rs_IDcontable" datasource="#Arguments.Conexion#">
    select IDcontable from PRECierreCont where EConsec=1
</cfquery>


<cfif isdefined("rs_IDcontable.IDcontable") and len(rs_IDcontable.IDcontable) gt 0>
	<cfset LvarFecha = createdate(form.periodo, 12, 01)>
    <cfquery name="rs_HEcontable" datasource="#Arguments.Conexion#">
        select Cconcepto, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, ECusucodigo, ECfechacreacion, ECtipo, 
        	#LvarFecha# as Efecha from HEContables
        where Ecodigo = #session.Ecodigo# and IDcontable=#rs_IDcontable.IDcontable#
    </cfquery>
    <cfif rs_HEcontable.recordCount eq 0>
		<cfset Msg = "Se debe cerrar primero la contabilidad presupuestal actual"> 
        <cflocation url="CierreContaPres.cfm?showMessage=#Msg#">       
    </cfif>
    
    <cfinvoke returnvariable="Edoc" component="sif.Componentes.Contabilidad" method="Nuevo_Asiento" 
        Ecodigo="#Session.Ecodigo#" 
        Cconcepto="#rs_HEcontable.Cconcepto#"
        Oorigen=" "
        Eperiodo="#form.periodo#"
        Emes="12">
    </cfinvoke>		    
	
    <cfquery name="ABC_NuevoAsiento" datasource="#Session.DSN#">
        insert into EContables (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario, ECusucodigo, ECfechacreacion, ECipcrea, ECestado, BMUsucodigo, ECtipo)
        values (
            #Session.Ecodigo#,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#rs_HEcontable.Cconcepto#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">, 
            <cfqueryparam cfsqltype="cf_sql_integer" value="12">,
            #Edoc#,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rs_HEcontable.Efecha#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_HEcontable.Edescripcion#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_HEcontable.Edocbase#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_HEcontable.Ereferencia#">,
            'N',
            '#Session.usuario#',
            #Session.Usucodigo#,
            <cf_dbfunction name="now">, 
            '#Session.sitio.ip#',
            0,
            #Session.Usucodigo#,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs_HEcontable.ECtipo#">
        )
    
      <cf_dbidentity1 datasource="#Session.DSN#">
    </cfquery>
    <cf_dbidentity2 datasource="#Session.DSN#" name="ABC_NuevoAsiento">
    
    <cfif isdefined("ABC_NuevoAsiento.identity")>
    	<cftry>
        <cftransaction action="begin">
		<!--- insertar relacion entre asiento origen y el asiento copiado --->
            <cfquery  datasource="#Session.DSN#">
                INSERT INTO REContablesInt 
                (IDcontableOri, IDcontableGen, RECdetalle)
                values 
                (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_IDcontable.IDcontable#">,
                #ABC_NuevoAsiento.identity#,
                '#rs_HEcontable.Ereferencia# - Copiado- Reversar')
            </cfquery>      
            <cfquery name="ABC_DetalleAsiento" datasource="#Session.DSN#">
                insert INTO DContables(Ecodigo, IDcontable, Dlinea, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio)
                    select #Session.Ecodigo#, 
                           #ABC_NuevoAsiento.identity#, 
                           Dlinea, 
                           Cconcepto, 
                           <cf_jdbcquery_param cfsqltype="cf_sql_smallint" value="#form.periodo#">, 
                           <cf_jdbcquery_param cfsqltype="cf_sql_smallint" value="#12#">,
                           #Edoc#, 
                           Ocodigo, Ddescripcion, 
                           case Dmovimiento
                                when 'D' then 'C'
                                when 'C' then 'D'
                                else ''
                           end, 
                           Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio
                    from HDContables
                    where Ecodigo = #Session.Ecodigo#
                    and IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_IDcontable.IDcontable#">
            </cfquery>
        </cftransaction>    
        <cfcatch type="database">
        	<cftransaction action="rollback"/>
			<cfset Msg = "Error en Reverso de Detalles!.">
            <cflocation url="CierreContaPres.cfm?showMessage=#Msg#">
        </cfcatch>
        
        </cftry> 
        
        <cfinvoke component="sif.Componentes.CG_AplicaAsiento"  method="CG_AplicaAsiento">
            <cfinvokeargument name="IDcontable" value="#ABC_NuevoAsiento.identity#">
            <cfinvokeargument name="CtlTransaccion" value="true">
        </cfinvoke>
        
    <cfelse>
        <cfset Msg = "Error en Reverso de Detalles!.">
        <cflocation url="CierreContaPres.cfm?showMessage=#Msg#">
    </cfif>
</cfif>

<cfinvoke component="sif.Componentes.PRES_Presupuesto" 
			method="CreaTablaIntPresupuesto" 
            conIdentity="yes" 
            ContaPresupuestaria="yes">
</cfinvoke>
<cfinvoke	component		= "sif.Componentes.PRES_ContaPresupuestaria" 
            method			= "AsientoCierre"
            returnvariable	= "IDcontable" 
            Ecodigo			= "#session.Ecodigo#"
            Periodo			= "#form.periodo#"	
            Mes				= "#12#"
            Conexion		= "#Arguments.Conexion#"
/>

<cfinvoke component="sif.Componentes.CG_AplicaAsiento"  method="CG_AplicaAsiento">
    <cfinvokeargument name="IDcontable" value="#IDcontable#">
    <cfinvokeargument name="CtlTransaccion" value="true">
</cfinvoke>

<cfset Msg = "Cierre de Mes Contable Finalizada Exitosamente">
<cflocation url="CierreContaPres.cfm?showMessage=#Msg#">
	


