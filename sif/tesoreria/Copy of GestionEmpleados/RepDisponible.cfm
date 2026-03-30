<cf_templateheader title="Disponible en Caja Chica"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Disponible en Caja Chica'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.CCHid') and len(trim(form.CCHid)) and not isdefined('url.regresar'))>					
					<cfinclude template="RepDisponible_form.cfm">
				<cfelse>
					<cfinclude template="RepDisponible_filtro.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
