<!------>
<cfset LvarSAporEmpleado = true>	
<cfset LvarSAporEmpleadoCFM = "solicitudesAnticipoE.cfm">
<cfset LvarSAporEmpleadoSQL = "AnticipoE">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cf_templateheader title="Preparaci&oacute;n de Solicitudes de Anticipo"> 
	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
	<cfset titulo = 'Preparaci&oacute;n de Solicitudes de Anticipo'>
	
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfif isdefined ('url.GEAid') and len(trim(url.GEAid)) gt 0>
			<cfset form.GEAid=#url.GEAid#>
		</cfif>
			<cfif (isdefined('form.GEAid') and len(trim(form.GEAid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo'))>
				 <cfinclude template="solicitudesAnticipo_form.cfm">
			<cfelseif isdefined ('url.lista')>
				<cfinclude template="solicitudesAnticipo_lista.cfm">			
			<cfelse>
				<cfinclude template="solicitudesAnticipo_lista.cfm">
			</cfif>
	
	<cf_web_portlet_end>
<cf_templatefooter>
	


