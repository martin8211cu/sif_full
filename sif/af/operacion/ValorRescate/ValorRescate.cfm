<cf_templateheader title="Valores Activo"> 
	<cf_navegacion name="AFTRdescripcion" navegacion="">
		<cfset titulo = 'Cambio Valores Activo'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<cfif isdefined("url.AFTRid") and len(trim(url.AFTRid)) gt 0 and not isdefined("form.AFTRid")>
			<cfset form.AFTRid = url.AFTRid>
		</cfif>
		<table width="100%">
		  <tr>
			<td valign="top">
			<cfif (isdefined('form.AFTRid') and len(trim(form.AFTRid))) OR (isdefined('form.Nuevo')) OR (isdefined('url.Nuevo')) or (isdefined('url.AFTRid'))>
				<cfinclude template="ValorRescate_form.cfm">
			<cfelse>
				<cfinclude template="ValorRescate_lista.cfm">				
			</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
