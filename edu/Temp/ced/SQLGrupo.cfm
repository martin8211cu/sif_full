<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_Grupo" datasource="#Session.DSN#">
				insert into Grupo(Ncodigo, Gcodigo, GRnombre)
				values (
					<cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#Form.GRnombre#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="ABC_Grupo" datasource="#Session.DSN#">
				delete Grupo
				from Nivel a
				where GRcodigo = <cfqueryparam value="#Form.GRcodigo#" cfsqltype="cf_sql_numeric">
				and Grupo.Ncodigo = a.Ncodigo
				and a.CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Grupo" datasource="#Session.DSN#">
				update Grupo 
				   set GRnombre = <cfqueryparam value="#Form.GRnombre#" cfsqltype="cf_sql_varchar">,
					   Gcodigo = <cfqueryparam value="#Form.Gcodigo#" cfsqltype="cf_sql_numeric">,
					   Ncodigo = <cfqueryparam value="#Form.Ncodigo#" cfsqltype="cf_sql_numeric">
				where GRcodigo = <cfqueryparam value="#Form.GRcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo="CAMBIO">
	</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="Grupo.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="Ncodigo" type="hidden" value="<cfif isdefined("Form.Ncodigo")><cfoutput>#Form.Ncodigo#</cfoutput></cfif>">
	<input name="Gcodigo" type="hidden" value="<cfif isdefined("Form.Gcodigo")><cfoutput>#Form.Gcodigo#</cfoutput></cfif>">
	<input name="GRcodigo" type="hidden" value="<cfif isdefined("Form.GRcodigo")><cfoutput>#Form.GRcodigo#</cfoutput></cfif>">
	<cfif isdefined("Form.FNcodigo") and isdefined("Form.FGcodigo")>
		<input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
		<input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
