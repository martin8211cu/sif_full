<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Par&aacute;metros
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr><td><cfinclude template="pNavegacion.cfm"></td></tr>
		<tr><td><cfinclude template="formParametros.cfm"></td></tr>
	</table>

</cf_templatearea>
</cf_template>