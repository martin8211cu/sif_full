<cf_templateheader title="Compras - Consulta Seguimiento de Solicitudes">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Seguimiento de Solicitudes'>
											
			<cfif isdefined("form.ESnumero") and len(trim(form.ESnumero)) and not(isdefined("form.ESidsolicitud") and len(trim(form.ESidsolicitud)))>				
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select ESidsolicitud,ESnumero, ESobservacion
					from ESolicitudCompraCM
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">		
						and ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero#">	
				</cfquery>	
				<cfif rsDatos.RecordCount EQ 0>
			  		<cfset form.ESnumero = ''>
					<cf_errorCode	code = "50276" msg = "El número de Solicitud no existe">	
			  	<!---<cflocation url="SeguimientoSolicitudes-lista.cfm">--->
				</cfif>
				<cfset form.ESidsolicitud = rsDatos.ESidsolicitud>
				<cfset form.ESobservacion = rsDatos.ESobservacion>
			</cfif>
									
			<cfoutput>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td></tr>						
						<tr><td>&nbsp;</td></tr>
						<tr><td><cf_rhimprime datos="/sif/cm/consultas/SeguimientoSolicitudes-Imprime.cfm" paramsuri=""></td></tr>
						<tr><td><cfinclude template="SeguimientoSolicitudes-Imprime.cfm"></td></tr>	 		
					</table>						
			</cfoutput>						
		<cf_web_portlet_end>
	<cf_templatefooter>


