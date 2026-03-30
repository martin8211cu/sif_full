<cfif isdefined("form.btnSolicitar")>
	<cftransaction>
		<cfquery name="rsinsert" datasource="#session.dsn#">
			insert into CertificacionesEmpleado 
			(EFid, DEid, Ecodigo, CSEfrecoge, 
			BMfechaalta, BMUsucodigo, CSEatendida,RHEBEid)
			values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.CSEfrecoge)#">, 
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,1,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEBEid#">)
			<cf_dbidentity1 datasource="#session.dsn#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="rsinsert">
	</cftransaction>
	<cfset Lvar_CSEid = rsinsert.identity>
<cfelseif isdefined("form.chk")>
	<cfquery name="rsupdate" datasource="#session.dsn#">
		update CertificacionesEmpleado 
		set CSEatendida = 1
		where CSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#">
	</cfquery>
	<cfset Lvar_CSEid = form.chk>
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorAlProcesarUnaCertificacionNoSePudoObtenerElNoDeCertfSolicitadaProcesoCancelado"
	Default="Error al procesar una certificación. No se pudo obtener el No. de Certf. Solicitada. Proceso Cancelado!"
	returnvariable="MSG_ErrorAlProcesarUnaCertificacionNoSePudoObtenerElNoDeCertfSolicitadaProcesoCancelado"/>
	
	
	<cfthrow message="#MSG_ErrorAlProcesarUnaCertificacionNoSePudoObtenerElNoDeCertfSolicitadaProcesoCancelado#">
</cfif>
<cflocation url="generarFormato-result.cfm?CSEid=#Lvar_CSEid#">