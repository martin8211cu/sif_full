<cfinclude template="/Application.cfm">
<cfinclude template="/sif/Utiles/SIFfunciones.cfm">
<cfsetting enablecfoutputonly="yes">
<cfsavecontent variable="__MM__">
	<cfset Session.CEcodigo = Session.sitio.CEcodigo>
	<cfinclude template="/sif/portlets/pEmpresas2.cfm">

	<!--- Obtener la iglesia del Administrador --->
	<cfquery datasource="asp" name="_mi_iglesia">
		select u.llave, a.Ecodigo, a.Ereferencia, b.Ccache, a.Enombre, c.CEnombre
		from UsuarioReferencia u, Empresa a, Caches b, CuentaEmpresarial c
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and u.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="MEPersona">
		  and u.Ecodigo = a.Ecodigo
		  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		  and a.Cid = b.Cid
		  and a.CEcodigo = c.CEcodigo
	</cfquery>
	<cfset Session.Iglesia_a_la_que_asisto = _mi_iglesia.Enombre>
	
	<!--- insertar empresa session.Ecodigo si no existe en MEServicioEmpresa --->
	<cfinclude template="crear_meservicioempresa.cfm">
	<cfquery datasource="#session.dsn#" name="MEServicioEmpresa">
		select METSid, MESid from MEServicioEmpresa
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfset session.METSid = MEServicioEmpresa.METSid>
	<cfset session.MESid  = MEServicioEmpresa.MESid>
	
</cfsavecontent>
<cfsetting enablecfoutputonly="no">
<cfset session.publico = false>
