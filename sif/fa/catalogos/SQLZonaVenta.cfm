<cfparam name="LvarPagina" default="ZonaVenta.cfm">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ZonaVenta" datasource="#Session.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				Insert 	ZonaVenta(codigo_zona,pais,nombre_zona,BMfechamod,Ecodigo,BMUsucodigo)
						values	(
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.codigo_zona#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.pais#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_zona#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
						)
				Select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	ZonaVenta
					set  codigo_zona = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.codigo_zona#">,
					     pais =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.pais#">,
						 nombre_zona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.nombre_zona#">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				      and id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_zona#">
				<cfset modo="CAMBIO">
			<cfelseif isdefined("Form.Baja")>
				delete ZonaVenta
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				     and id_zona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_zona#">
				<cfset modo="BAJA">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="id_zona" type="hidden" value="<cfif isdefined("Form.id_zona")><cfoutput>#Form.id_zona#</cfoutput></cfif>">
	<!---
	<input name="LPid" type="hidden" value="<cfif isdefined("Form.LPid")><cfoutput>#Form.LPid#</cfoutput></cfif>">
	<input name="LPlinea" type="hidden" value="<cfif isdefined("Form.LPlinea")><cfoutput>#Form.LPlinea#</cfoutput></cfif>">
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
	--->
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>