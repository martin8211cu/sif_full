<cfset session.CEcodigo = session.sitio.CEcodigo>
<cfparam name="session.EcodigoSDC" default="0">
<cfparam name="session.sitio.Ecodigo" default="0">
<cfparam name="session.sitio.cliente_empresarial" default="0">
<cfparam name="session.Idioma" default="es">

<cfquery name="rs" datasource="asp">
	select Ecodigo, Ereferencia, b.Ccache, a.Enombre, c.CEnombre, c.LOCIdioma
	from Empresa a, Caches b, CuentaEmpresarial c
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	and a.Cid = b.Cid
	and a.CEcodigo = c.CEcodigo
</cfquery>

<cfif rs.RecordCount EQ 0>
	<cfinclude template="invalid/index.cfm"><cfabort>
<cfelse>
	<cfset Session.EcodigoSDC = rs.Ecodigo>
	<cfset Session.Ecodigo = rs.Ereferencia>
	<cfset Session.DSN = Trim(rs.Ccache)>
	<cfset Session.Enombre = rs.Enombre>
	<cfset Session.CEnombre = rs.CEnombre>
	<cfset Session.Idioma = rs.LOCIdioma>
</cfif>

<cfif isdefined("Session.Usucodigo")>
	<cfparam name="session.MEpersona" default="">
	<cfquery datasource="asp" name="soyyo">
		select u.llave, a.Ecodigo, a.Ereferencia, b.Ccache, a.Enombre, c.CEnombre
		from UsuarioReferencia u, Empresa a, Caches b, CuentaEmpresarial c
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and u.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="MEPersona">
		  and u.Ecodigo = a.Ecodigo
		  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and a.Cid = b.Cid
		  and a.CEcodigo = c.CEcodigo
	</cfquery>
	
	<cfif soyyo.RecordCount GT 0 and soyyo.llave NEQ 0>
		<cfset Session.MEpersona = soyyo.llave>
		<cfset Session.EcodigoSDC = soyyo.Ecodigo>
		<cfset Session.Ecodigo = soyyo.Ereferencia>
		<cfset Session.DSN = Trim(soyyo.Ccache)>
		<cfset Session.Enombre = soyyo.Enombre>
		<cfset Session.CEnombre = soyyo.CEnombre>
	</cfif>
</cfif>

<cfinclude template="../iglesias/crear_meservicioempresa.cfm">

<cfquery datasource="#session.dsn#" name="MEServicioEmpresa">
	select METSid, MESid from MEServicioEmpresa
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#" null="#Len(session.Ecodigo) EQ 0#">
</cfquery>
<cfset session.METSid = MEServicioEmpresa.METSid>
<cfset session.MESid  = MEServicioEmpresa.MESid>