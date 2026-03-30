<cf_templateheader title="Reimpresión de Vales"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Reimpresión de Vales al Empleado'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		 
		<td valign="top">
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.CCHVid') and len(trim(form.CCHVid)) and not isdefined('url.regresar'))>					
					<cfinclude template="ReimpresionVales_form.cfm">
				<cfelse>
					<cfinclude template="ReimpresionVales_lista.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
