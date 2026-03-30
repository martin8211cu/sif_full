<cfoutput>
	<form name="formRepresentantes" method="get" action="#GetFileFromPath(GetTemplatePath())#">
		<cfinclude template="vendedor-hiddens.cfm">
		
		<cfparam  name="url.PageNum_lista"default="1">
		<cfset PageNum = url.PageNum_lista>
		
		<cfset formName="formRepresentantes">
		<cfinclude template="/saci/vendedor/venta/representante-lista.cfm">
	</form>
</cfoutput>
