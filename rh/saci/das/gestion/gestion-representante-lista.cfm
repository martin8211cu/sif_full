<cfoutput>
	
	<form name="form1" method="get" action="#GetFileFromPath(GetTemplatePath())#">	
		
		<input type="hidden" name="Pquien" value="#form.cli#"/>
		
		<cfparam  name="url.PageNum_lista"default="1">
		<cfparam  name="url.PageNum"default="1">
		<cfset PageNum = url.PageNum>
		<cfinclude template="gestion-hiddens.cfm">
		
		<cfset formName="form1">
		<cfinclude template="/saci/vendedor/venta/representante-lista.cfm">
		<cf_botones names="Nuevo" values="Nuevo">
	
	</form>
	
</cfoutput>
