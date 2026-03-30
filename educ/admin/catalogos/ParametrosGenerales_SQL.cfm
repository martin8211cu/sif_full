<cftry>
	<cfquery name="ABC_conceptoEvaluac" datasource="#Session.DSN#">
		set nocount on
			<cfif isdefined("Form.Cambio")>
				update ParametrosGenerales set
				PGvalor = <cfqueryparam value="#Form.PGvalor#" cfsqltype="cf_sql_char">
				where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
				and PGnombre  = <cfqueryparam value="#Form.PGnombre#" cfsqltype="cf_sql_varchar">
				  
				<cfset modo="CAMBIO">
			</cfif>
		set nocount off
	</cfquery>
<cfcatch type="any">
	<cfinclude template="/educ/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>

<form action="ParametrosGenerales.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="PGnombre" type="hidden" value="<cfif isdefined("Form.PGnombre") and modo NEQ 'ALTA'>#Form.PGnombre#</cfif>">
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