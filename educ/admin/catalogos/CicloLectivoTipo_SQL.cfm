<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_tiposCiclos" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.Alta")>
					insert CicloLectivoTipo 
					(Ecodigo, CLTcicloEvaluacion, CLTciclos, CLTsemanas, CLTvacaciones)
					values (
					<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					, rtrim(ltrim(<cfqueryparam value="#form.CLTcicloEvaluacion#" cfsqltype="cf_sql_varchar">))
					, <cfqueryparam value="#CLTciclos#" cfsqltype="cf_sql_tinyint">
					, <cfqueryparam value="#CLTsemanas#" cfsqltype="cf_sql_tinyint">
					, <cfqueryparam value="#CLTvacaciones#" cfsqltype="cf_sql_tinyint">)				

					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Baja")>
					delete CicloLectivoTipo
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						and CLTcicloEvaluacion = rtrim(ltrim(<cfqueryparam value="#Form.CLTcicloEvaluacion#" cfsqltype="cf_sql_varchar">))
					   	and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					   
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.Cambio")>
					update CicloLectivoTipo set
						CLTciclos = <cfqueryparam value="#CLTciclos#" cfsqltype="cf_sql_tinyint">,
						CLTsemanas = <cfqueryparam value="#CLTsemanas#" cfsqltype="cf_sql_tinyint">,
						CLTvacaciones = <cfqueryparam value="#CLTvacaciones#" cfsqltype="cf_sql_tinyint">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  and CLTcicloEvaluacion  = rtrim(ltrim(<cfqueryparam value="#Form.CLTcicloEvaluacion#" cfsqltype="cf_sql_varchar">))
					  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					  
					<cfset modo="CAMBIO">
				</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="CicloLectivoTipo.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CLTcicloEvaluacion" type="hidden" value="<cfif isdefined("Form.CLTcicloEvaluacion") and modo NEQ 'ALTA'>#Form.CLTcicloEvaluacion#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>