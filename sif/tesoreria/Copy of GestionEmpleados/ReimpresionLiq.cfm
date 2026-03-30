<cf_templateheader title="Reimpresión de Liquidaciones"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Reimpresión Liquidaciones de Empleados'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.GELid') and len(trim(form.GELid)) and not isdefined('url.regresar'))>					
					<cfinclude template="ReimpresionLiq_form.cfm">
				<cfelse>
					<cfinclude template="ReimpresionLiq_lista.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
