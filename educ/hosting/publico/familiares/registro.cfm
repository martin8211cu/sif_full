<cf_template template="#session.sitio.template#">
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
	<cfset Regresar = "familiares.cfm">
	<cfinclude template="../pNavegacion.cfm">
	<div align="right"><img src="../images/Paso1.gif"></div>
	<cfinclude template="form.cfm">
</cf_templatearea>
<cf_templatearea name="title">
	<cfoutput>#TITULO#</cfoutput>
</cf_templatearea>
</cf_template>