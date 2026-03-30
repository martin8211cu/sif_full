<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="rsValidaCodigo" datasource="#session.dsn#">
			select RIserie from Talonarios
			where RIserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RIserie#">
				and Ecodigo = #Session.Ecodigo#
				and Tid <> <cfif isdefined("Form.Tid")>#form.Tid# <cfelse> -1 </cfif>
		</cfquery>
		<cfif isdefined("rsValidaCodigo") and rsValidaCodigo.recordCount eq 0>
			<cfquery name="Talonarios" datasource="#Session.DSN#">
				set nocount on
				<cfif isdefined("Form.Alta")>
					declare @Tid numeric(9)
					select @Tid = isnull(max(Tid),0)+1 from Talonarios where Ecodigo = #Session.Ecodigo#
					select @Tid

					Insert Talonarios (Tid, Ecodigo, RIini, RIfin, RIsig, RIserie, Tdescripcion)
					values
					(
						@Tid,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RIini#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RIfin#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RIini#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RIserie#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.Tdescripcion)#">
					)
					select 1
					<cfset modo="ALTA">

				<cfelseif isdefined("Form.Baja")>
					if not exists(select * from TipoTransaccionCaja
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Tid = <cfqueryparam value="#Form.Tid#" cfsqltype="cf_sql_numeric">
					)
						delete from Talonarios
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and Tid = <cfqueryparam value="#Form.Tid#" cfsqltype="cf_sql_numeric">
					<cfset modo="BAJA">

				<cfelseif isdefined("Form.Cambio")>
					update Talonarios set
							Tdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.Tdescripcion)#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Tid = <cfqueryparam value="#Form.Tid#" cfsqltype="cf_sql_numeric">
					  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
					<cfset modo="ALTA">

				</cfif>
				set nocount off
			</cfquery>
		<cfelse>
			<cf_errorcode code="30000101" msg="Codigo duplicado">
		</cfif>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="Talonarios.cfm" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Tid" type="hidden" value="<cfif isdefined("Form.Tid")><cfoutput>#Form.Tid#</cfoutput></cfif>">
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>