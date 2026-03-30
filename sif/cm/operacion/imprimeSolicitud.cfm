<!--- PROCESO DE IMPRESIÓN DE LA SOLICITUD --->
<cfif isdefined("url.ESidsolicitud") and len(trim(url.ESidsolicitud))>
	<!--- Busca el formato según el tipo de transacción que se le ha asignado --->
	<cfquery name="rsTipoSolicitud" datasource="#Session.DSN#">
		select a.ESnumero, a.CMSid, rtrim(b.FMT01COD) as formato
		from ESolicitudCompraCM a 
			 inner join CMTiposSolicitud b
				on a.Ecodigo = b.Ecodigo
				and a.CMTScodigo = b.CMTScodigo 
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
			and a.ESestado in (10,20,25,50)
	</cfquery>
			 
	<!--- Si la tipo de transacción de la factura tiene asignado un formato de impresión genera el reporte PDF en pantalla  --->
	<cfif rsTipoSolicitud.RecordCount GT 0>
		
		<cfquery datasource="#session.DSN#">
			update ESolicitudCompraCM
			set ESImpresion='I'
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
		</cfquery>
	
		<!---- Se selecciona el archivo html (si es que tiene) para pintarlo ----->
		<cfquery name="rsFormato" datasource="#session.DSN#">
			select FMT01tipfmt, FMT01cfccfm
			from FMT001
			where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
			  and FMT01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoSolicitud.formato)#">
		</cfquery>
		
		<!--- Si hay una direccion para el archivo, verifica que exista el mismo ----->
		<cfif rsFormato.FMT01tipfmt eq 1 or rsFormato.FMT01tipfmt eq 0 >
			<cfset continuar = true >	
			<cfif rsFormato.FMT01tipfmt eq 0 and len(trim(rsFormato.FMT01cfccfm)) eq 0 >
				<cfset LvarOK = true >
				<cfset continuar = false >
			</cfif>

			<cfif continuar >
				<cfset LvarArchivo = trim(rsFormato.FMT01cfccfm) >
				<cfinclude template="../../Utiles/validaUri.cfm">
				<cfset LvarOk = validarUrl( trim(rsFormato.FMT01cfccfm) ) >
				<cfif not LvarOK ><cf_errorCode	code = "50274"
				                  				msg  = "No existe el archivo indicado para el formato estático: @errorDat_1@"
				                  				errorDat_1="#LvarSPhomeuri#"
				                  ></cfif>
			</cfif>
		</cfif>  

		<!---- Si hay definido un archivo HTML ----->
		<cfif isdefined("LvarArchivo") >
			<cfset parametros = "">
			<cfif isdefined("rsTipoSolicitud.ESnumero") and len(trim(rsTipoSolicitud.ESnumero))>
				<cfset url.ESnumero = rsTipoSolicitud.ESnumero>
				<cfset url.CMSid = rsTipoSolicitud.CMSid>
				<cfset parametros = parametros & "&ESnumero=" & rsTipoSolicitud.ESnumero & "&CMSid=" & rsTipoSolicitud.CMSid>
			</cfif>

			<cfif rsFormato.FMT01tipfmt eq 1>
				<cf_rhimprime datos="#LvarArchivo#" paramsuri="#parametros#"> 
				<cfinclude template="#LvarArchivo#">			
				<br>
				<DIV align="center"><input name="btnCerrar" type="button" value="Cerrar" onClick="javascript: window.close();" ></DIV>
				<br>					
			<cfelse>
				<!--- NO BORRAR PROBAR EN EL MOMENTO QUE SEA NECESARIO --->
				<!--- se supone que el archivo debe tener los mismos parametros que el estatico y el jasper que esta aqui --->
				<!---
				<cf_jasperreport datasource="#session.DSN#"
						 output_format="html"
						 jasper_file="#LvarArchivo#">
				<cf_jasperparam name="Ecodigo" value="#session.Ecodigo#">
				<cf_jasperparam name="ESnumero" value="#rsTipoSolicitud.ESnumero#">
				<cf_jasperparam name="CMSid" value="#rsTipoSolicitud.CMSid#">
				</cf_jasperreport>
				--->
			</cfif>
		<cfelse>
			<cfquery datasource="#session.DSN#">
				update ESolicitudCompraCM
				set ESImpresion='I'
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
			</cfquery>
		<cfinclude template="/sif/reportes/#session.Ecodigo#_#rsTipoSolicitud.Formato#.cfm">
			<!---<cfset tipoFormato = "/sif/reportes/#session.Ecodigo#_#rsTipoSolicitud.Formato#.jasper" >
			<cf_jasperreport datasource="#session.DSN#"
							 output_format="html"
							 jasper_file="#tipoFormato#">
				<cf_jasperparam name="Ecodigo" value="#session.Ecodigo#">
				<cf_jasperparam name="ESnumero" value="#rsTipoSolicitud.ESnumero#">
				<cf_jasperparam name="CMSid" value="#rsTipoSolicitud.CMSid#">
							
			</cf_jasperreport>--->
		</cfif>	
	<cfelse>
		<script>alert('No hay Formato de Impresión para esta Solicitud.');</script>
	</cfif>
</cfif>
		
		



