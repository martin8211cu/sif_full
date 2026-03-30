<cfinclude template="/Application.cfm">
<cfsetting enablecfoutputonly="yes">
<cfinclude template="/sif/Utiles/SIFfunciones.cfm">
<cfsetting enablecfoutputonly="no">

<cfif Len(Session.sitio.CEcodigo)>
	<cfset Session.CEcodigo = Session.sitio.CEcodigo>
</cfif>
<!---
<cfparam name="session.Idioma" default="es">
--->
<cfparam name="Session.Idioma" default="ES_CR">

<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
	<!---
	<cfsavecontent variable="__MM__">
		<cfinclude template="/sif/portlets/pEmpresas2.cfm">
	</cfsavecontent>
	---><!---
	<cfquery name="rs" datasource="asp">
		select Ecodigo, Ereferencia, b.Ccache, a.Enombre, c.CEnombre, c.LOCIdioma
		from Empresa a, Caches b, CuentaEmpresarial c
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		and a.Cid = b.Cid
		and a.CEcodigo = c.CEcodigo
	</cfquery>
	
	<cfif rs.RecordCount GT 0>
		<cfset Session.EcodigoSDC = rs.Ecodigo>
		<cfset Session.Ecodigo = rs.Ereferencia>
		<cfset Session.DSN = Trim(rs.Ccache)>
		<cfset Session.Enombre = rs.Enombre>
		<cfset Session.CEnombre = rs.CEnombre>
		<cfset Session.Idioma = rs.LOCIdioma>
	<cfelse>
		<!--- Lanzar un error --->
	</cfif>--->
	<cfinclude template="admin/defaults.cfm">
<cfelse><!---
	<cfquery name="rs" datasource="asp">
		select Ecodigo, Ereferencia, b.Ccache, a.Enombre, c.CEnombre, c.LOCIdioma
		from Empresa a, Caches b, CuentaEmpresarial c
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		and a.Cid = b.Cid
		and a.CEcodigo = c.CEcodigo
	</cfquery>
	
	<cfif rs.RecordCount GT 0>
		<cfset Session.EcodigoSDC = rs.Ecodigo>
		<cfset Session.Ecodigo = rs.Ereferencia>
		<cfset Session.DSN = Trim(rs.Ccache)>
		<cfset Session.Enombre = rs.Enombre>
		<cfset Session.CEnombre = rs.CEnombre>
		<cfset Session.Idioma = rs.LOCIdioma>
	<cfelse>
		<!--- Lanzar un error --->
	</cfif>--->

</cfif>
<cfset Session.CFroot = "/educ">
<cfset Session.JSroot = "/cfmx/educ">
<cfsetting enablecfoutputonly="no">
