<!------>
<!---<cfset LvarSAporEmpleado=true>--->
<cfset LvarSAporEmpleadoCFM = "solicitudesAnticipo.cfm">
<cfset LvarSAporEmpleadoSQL = "Anticipo">
<cf_templateheader title="Preparaci&oacute;n de Solicitudes de Anticipo"> 
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
                        
	<cfset titulo = 'Preparaci&oacute;n de Solicitudes de Anticipo'>
 <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfinclude template="TESid_Ecodigo.cfm">
	<cfif isdefined ('url.regresar')>
		<cfset form.GEAid=''>
		<cfset form.DEid=''>
		<cfinclude template="solicitudesAnticipo_lista.cfm">
	<cfelse>
  		<cfif isdefined ('url.Aprobar')>
			<cfinclude template="AprobacionAnticipos.cfm">
		<cfelseif (isdefined('form.GEAid') and len(trim(form.GEAid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.GEAid'))>
	 		 <cfinclude template="solicitudesAnticipo_form.cfm">			
		<cfelse>
			<cfinclude template="solicitudesAnticipo_lista.cfm">
		</cfif>
	</cfif>
  <cf_web_portlet_end>
<cf_templatefooter>
	


