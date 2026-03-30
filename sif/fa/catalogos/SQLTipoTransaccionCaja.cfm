
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="UsuariosCaja" datasource="#Session.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				if not exists
				(
					select *
					from TipoTransaccionCaja
					where
						FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
						and CCTcodigo=<cfqueryparam cfsqltype="cf_char" value="#Form.CCTcodigo#">
						and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				)
					insert TipoTransaccionCaja
						(FCid, CCTcodigo, Ecodigo, Tid,FMT01COD)
					values
						(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfif Form.Tid GT 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">,
						<cfelse>
							null,
						</cfif>
						<cfif Len(Trim(Form.FMT01COD)) neq 0>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#">
						<cfelse>
							null
						</cfif>
						)
				select 1
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				Update TipoTransaccionCaja
				set Tid=
					<cfif Form.Tid GT 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#"><cfelse>null</cfif>,
					FMT01COD =
					<cfif Len(Trim(Form.FMT01COD)) neq 0>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FMT01COD#"><cfelse>null</cfif>
				where
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and CCTcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)

				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Baja")>
				delete from TipoTransaccionCaja
				where
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and CCTcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
					and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
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
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="EUcodigo" type="hidden" value="<cfif isdefined("Form.CCTcodigo")><cfoutput>#Form.CCTcodigo#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>