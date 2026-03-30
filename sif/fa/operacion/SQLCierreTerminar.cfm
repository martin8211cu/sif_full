<cfparam name="action" default="CierreCaja.cfm">
<cfif isdefined("form.btnTerminar") >
	<cftransaction>
		<cftry>
			<!--- update al tabla de cierres para actualizar los datos --->
			<cfquery name="sql_dcierre" datasource="#session.DSN#">
				set nocount on
				delete FCajasActivas where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">

				update FACierres 
				set FACestado = <cfqueryparam cfsqltype="cf_sql_char" value="T">
				where FACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				set nocount off
			</cfquery>
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>
</cfif>	

<cfset StructDelete(session, "Caja")>

<cfoutput>
<form action="CierreCaja.cfm" method="post" name="sql">
	<input type="hidden" name="FACid" value="-1">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>