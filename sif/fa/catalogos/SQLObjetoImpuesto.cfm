<cfparam name="LvarPagina" default="ObjetoImpuesto.cfm">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
	
		<cfquery name="ObjetoImpuesto" datasource="#Session.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				Insert 	into CSATObjImpuesto(CSATcodigo,CSATdescripcion,CSATfechaVigencia,CSATestatus,BMUsucodigo)
						values	(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codSAT#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descSAT#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Form.fechaVigencia#">,
						<cfif isdefined("Form.estatus")>
						<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						)
				
				Update 	CSATObjImpuesto
				set CSATfechaVigencia = convert(varchar(10),GETDATE(),120) where 
				CSATfechaVigencia is null
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Cambio")>
				Update 	CSATObjImpuesto
					set  CSATdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descSAT#">,
					CSATfechaVigencia=<cfqueryparam cfsqltype="cf_sql_date" value="#Form.fechaVigencia#">,
					<cfif isdefined("Form.estatus")>
						CSATestatus=<cfqueryparam cfsqltype="cf_sql_integer" value="1">
						<cfelse>
						CSATestatus=<cfqueryparam cfsqltype="cf_sql_integer" value="0">
						</cfif>
					where IdObjImp = <cfqueryparam value="#Form.IdObjImp#" cfsqltype="cf_sql_integer">
				      
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
	<input name="IdObjImp" type="hidden" value="<cfif isdefined("Form.IdObjImp")><cfoutput>#Form.IdObjImp#</cfoutput></cfif>">
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