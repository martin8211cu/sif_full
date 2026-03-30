<cfparam name="session.simple" default="#StructNew()#">
<cfparam name="session.simple._ctaemp" default="#session.CEcodigo#">
<cfparam name="session.simple._buscar" default="">

<cfif session.CEcodigo is 1 and IsDefined('url.ce')>
	<cfset session.simple._ctaemp = url.ce>
</cfif>
<cfif IsDefined('url.buscar')>
	<cfset session.simple._buscar = url.buscar>
</cfif>

<cfquery datasource="asp" name="CuentaEmpresarial_Q">
	select CEnombre, CEcodigo
	from CuentaEmpresarial
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
</cfquery>

<cfquery datasource="asp" name="Empresa_Q">
	select Enombre, Ecodigo
	from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
	order by Enombre
</cfquery>
<cfif IsDefined('url.e') And ListFind(ValueList(Empresa_Q.Ecodigo), url.e)>
	<cfset session.simple._emp = url.e>
<cfelse>
	<cfset session.simple._emp = Empresa_Q.Ecodigo>
</cfif>