<cf_templateheader template="#session.sitio.template#">

	<table width="100%" border="0" cellspacing="0">
	  <tr>
		<td valign="top">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
		</td>
	  </tr>
	  <tr>
		<td valign="top">
			<cfset parametros = "&RHVTid=#form.RHVTid#" >
			<cf_rhimprime datos="/rh/planillap/consultas/TablaSalarial-form.cfm" paramsuri="#parametros#"> 
			<cfinclude template="TablaSalarial-form.cfm">
		</td>
	  </tr>
	</table>		
<cf_templatefooter template="#session.sitio.template#">
