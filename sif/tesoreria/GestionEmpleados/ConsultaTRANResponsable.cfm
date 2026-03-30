<cfset GvarPorResponsable="true">
<cfset LvarCFM = "Responsable">
<cf_templateheader title="Consulta de Transacciones de Caja Chica por Responsable"> 
	<cf_navegacion name="CCHid" navegacion="">
		<cfset titulo = 'Transacciones de Caja Chica por Responsable'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.CCHid') and len(trim(form.CCHid)) and not isdefined('url.regresar'))>					
					<cfinclude template="ConsultaTRAN_form.cfm">
				<cfelse>
					<cfinclude template="ConsultaTRAN_filtro.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
