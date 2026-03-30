<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
		<!--- 	<cfquery name="ABC_PublicarNotas" datasource="#Session.Edu.DSN#">
				set nocount on	
				insert into PublicacionNotas ( PEcodigo, SPEcodigo,  PNestado, PNfechaInicio, PNfechaFin)
				values
					(
						<cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Form.SPEcodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Form.PNestado#" cfsqltype="cf_sql_smallint">,
						<!--- <cfqueryparam value="#Form.Ganual#" cfsqltype="cf_sql_smallint">, --->
						<cfif #Form.PNestado# NEQ 0 >
							<cfqueryparam value="#Form.PNfechaInicio#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#Form.PNfechaFin#" cfsqltype="cf_sql_date">
						<cfelse>
							null,null
						</cfif>
					)
				set nocount off
			</cfquery> --->
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_PublicarNotas" datasource="#Session.Edu.DSN#">
				set nocount on
				delete from PublicacionNotas
				where SPEcodigo = <cfqueryparam value="#Form.SPEcodigo#" cfsqltype="cf_sql_numeric">
				  and PEcodigo = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
				set nocount off
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_PublicarNotas" datasource="#Session.Edu.DSN#">
				set nocount on
				update PublicacionNotas
				set <cfif Form.PNestado EQ 1>
					PNestado = <cfqueryparam value="#Form.PNestado#" cfsqltype="cf_sql_smallint">,
					PNfechaInicio = convert(datetime,<cfqueryparam value="#Form.PNfechaInicio#" cfsqltype="cf_sql_varchar">,103),
					PNfechaFin = convert(datetime,<cfqueryparam value="#Form.PNfechaFin#" cfsqltype="cf_sql_varchar">,103)
				<cfelse>
					PNestado = <cfqueryparam value="#Form.PNestado#" cfsqltype="cf_sql_smallint">,
					PNfechaInicio = null,
					PNfechaFin = null
				</cfif>
				where SPEcodigo = <cfqueryparam value="#Form.SPEcodigo#" cfsqltype="cf_sql_numeric">
				  and PEcodigo = <cfqueryparam value="#Form.PEcodigo#" cfsqltype="cf_sql_numeric">
				
				set nocount off
				</cfquery>
				<cfset modo="CAMBIO">
	</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="PublicarNotas.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
<!--- 	<input name="SPEcodigo" type="hidden" value="<cfif isdefined("Form.SPEcodigo")><cfoutput>#Form.SPEcodigo#</cfoutput></cfif>">
	<input name="PEcodigo" type="hidden" value="<cfif isdefined("Form.PEcodigo")><cfoutput>#Form.PEcodigo#</cfoutput></cfif>"> --->
	<input name="PNcodigo" type="hidden" value="<cfif isdefined("Form.PNcodigo")><cfoutput>#Form.PNcodigo#</cfoutput></cfif>">
	<input name="Splaza" type="hidden" value="<cfif isdefined("Form.Splaza")><cfoutput>#Form.Splaza#</cfoutput></cfif>">
	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

