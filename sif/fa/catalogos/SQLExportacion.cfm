<cfparam name="LvarPagina" default="Exportacion.cfm">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<!--- SML18082022 Valida si ya existe un Tipo de Exportacion por default para al insertar o actualizar solo se pueda tener un default--->
		<cfif isdefined("Form.default")>
			<cfquery name="rsExportacion" datasource="#Session.DSN#">
				select IdExportacion
				from CSATExportacion
				where CSATdefault = 1
			</cfquery>

			<cfif isdefined("rsExportacion") and rsExportacion.RecordCount GT 0>
				<cfquery datasource="#Session.DSN#">
					update CSATExportacion
					set CSATdefault = 0
					where IdExportacion = #rsExportacion.IdExportacion#
				</cfquery>
			</cfif>
		</cfif>

		<cfquery name="Exportacion" datasource="#Session.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				Insert 	into CSATExportacion(CSATcodigo,CSATdescripcion,CSATfechaVigencia,CSATestatus,BMUsucodigo,CSATdefault)
						values	(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codSAT#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descSAT#">,
						<cfif isdefined("Form.fechaVigencia") and len(trim(Form.fechaVigencia))>
							<cfqueryparam cfsqltype="cf_sql_date" value="#Form.fechaVigencia#">,
						<cfelse>
							 convert(varchar(10),GETDATE(),120),
						</cfif>
						<cfif isdefined("Form.estatus")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfif isdefined("Form.default")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>
						)
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				
				Update 	CSATExportacion
					set  CSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codSAT#">,
					CSATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descSAT#">,
					<cfif isdefined("Form.fechaVigencia") and len(trim(Form.fechaVigencia))>
						CSATfechaVigencia=<cfqueryparam cfsqltype="cf_sql_date" value="#Form.fechaVigencia#">,
					<cfelse>
						CSATfechaVigencia = convert(varchar(10),GETDATE(),120),
					</cfif>
					<cfif isdefined("Form.estatus")>
						CSATestatus=<cfqueryparam cfsqltype="cf_sql_integer" value="1">,
					<cfelse>
						CSATestatus=<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					</cfif>
					<cfif isdefined("Form.default")>
						CSATdefault=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
						CSATdefault=<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					where IdExportacion = <cfqueryparam value="#Form.IdExportacion#" cfsqltype="cf_sql_integer">
				      
				<cfset modo="CAMBIO">
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
	<input name="IdExportacion" type="hidden" value="<cfif isdefined("Form.IdExportacion")><cfoutput>#Form.IdExportacion#</cfoutput></cfif>">
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