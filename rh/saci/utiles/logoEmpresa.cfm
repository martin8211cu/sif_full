<cfparam name="url.EcodigoSDC">

<cfif isdefined('url.EcodigoSDC') and url.EcodigoSDC NEQ ''>
	<cfquery datasource="asp" name="download_query">
		Select Elogo
		from Empresa
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EcodigoSDC#" null="#Len(url.EcodigoSDC) Is 0#">
	</cfquery>
	<cfcontent variable="#download_query.Elogo#" reset="yes" type="image/gif">
	
	<cfheader statuscode="404" statustext="Imagen no encontrada (Logo_Empresa)">
<cfelse>
	<cfheader statuscode="404" statustext="El codigo de la cuenta empresarial es requerido">
</cfif>
