
<cfif isdefined("Form.xmldata") and len(trim(xmldata)) GT 0>
	<cfquery name="rsInsUp" datasource="#Session.DSN#">
		select count(1) as cantidad 
			from Anexoim 
				where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
				and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfif rsInsUp.cantidad GT 0>
		<cfquery datasource="#Session.DSN#">
			update Anexoim set 
				AnexoDef = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.xmldata#">
			where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#Session.DSN#">
			insert into Anexoim (Ecodigo,AnexoId, AnexoDef) values(
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">,' ')
		</cfquery>
	</cfif>
</cfif>

<form name="SQLAnexos" method="post" action="AnexosFinanc.cfm">
	<input type="hidden" name="AnexoId" value="<cfif isdefined('Form.AnexoId')><cfoutput>#Form.AnexoId#</cfoutput></cfif>">
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
