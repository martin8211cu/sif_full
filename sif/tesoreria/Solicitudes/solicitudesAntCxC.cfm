<cfset LvarTipoAnticipo = "CxC">

<cf_templateheader title="Solicitudes Manuales">
	<cf_navegacion name="TESSPid" navegacion="">
	<cf_navegacion name="TESDPid" navegacion="">
	
	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
	<cf_navegacion name="TESOPid" navegacion="">
	<cfif isdefined("form.TESOPid")>
		<cfset Session.Tesoreria.ordenesPagoIrLista = "../Solicitudes/#Session.Tesoreria.solicitudesCFM#">
		<cflocation url="../Pagos/ordenesPago.cfm?TESOPid=#form.TESOPid#&PASO=10">
	</cfif>

	<cfinclude template="TESid_Ecodigo.cfm">

	<cfset titulo = "">
	<cfset titulo = 'Preparacion de Solicitudes de Devolucion de Anticipos a Clientes de CxC'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">				
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td valign="top">
				<cfif (isdefined('form.TESSPid') and len(trim(form.TESSPid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))>
					<cfinclude template="solicitudesAnticipos_form.cfm">			
				<cfelse>
					<cfinclude template="solicitudesAnticipos_lista.cfm">
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


