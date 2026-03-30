<cfparam name="LvarFiltroPorUsuario" default="false">
<cfif #LvarFiltroPorUsuario#>
	<cfset titulo="Preparación de Solicitudes de Pago Manuales por Centro Funcional (Usuario)">
<cfelse>
	<cfset titulo="Preparación de Solicitudes de Pago Manuales por Centro Funcional">
</cfif>

<cf_templateheader title="#titulo#">
	<cf_navegacion name="TESSPid" navegacion="">
	
	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
    <cfif not #LvarFiltroPorUsuario#>
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
    </cfif>
	<cf_navegacion name="TESOPid" navegacion="">
	<cfif isdefined("form.TESOPid")>
		<cfset Session.Tesoreria.ordenesPagoIrLista = "../Solicitudes/#Session.Tesoreria.solicitudesCFM#">
		<cflocation url="../Pagos/ordenesPago.cfm?TESOPid=#form.TESOPid#&PASO=10">
	</cfif>

	<cfinclude template="TESid_Ecodigo.cfm">

	<cfset LvarPorCFuncional = true>
    <cfparam name="LvarFiltroPorUsuario" default="false">
	<!---<cfset titulo = "#titulo#">--->
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">				
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td valign="top">
				<cfif (isdefined('form.TESSPid') and len(trim(form.TESSPid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))>
					<cfinclude template="solicitudesManual_form.cfm">			
				<cfelse>
					<cfinclude template="solicitudesManual_lista.cfm">
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


