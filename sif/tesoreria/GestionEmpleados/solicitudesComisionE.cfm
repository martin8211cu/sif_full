<!------>
<cfset LvarSAporComision = true>	
<cfset LvarSAporEmpleado = true>	
<cfset LvarSAporEmpleadoCFM = "solicitudesComisionE.cfm">
<cfset LvarSAporEmpleadoSQL = "ComisionE">
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cfset titulo = 'Preparación de Solicitudes de Viaticos por Comisión'>
<cf_templateheader title="#titulo#"> 
	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
	
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
	


