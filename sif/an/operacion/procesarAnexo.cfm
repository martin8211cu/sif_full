<html>
<head>
<title>ProcesaAnexo</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="pragma" content="no-cache">
</head>
<body>

<!--- Leer --->
<cfif isdefined("url.AnexoId") and url.AnexoId neq "">
	<cfquery name="rsLeer" datasource="#Session.DSN#">
		select AnexoDef 
		from Anexoim 
		where AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AnexoId#">
	</cfquery>	
	<cfif rsLeer.RecordCount NEQ 0>
		<script language="JavaScript">
				parent.form1.grid.activeworkbook.unprotect();
				parent.form1.grid.XMLdata="<cfoutput>#JSStringFormat(rsLeer.AnexoDef)#</cfoutput>";
		</script>
	<cfelse>
	</cfif>
</cfif>

<!--- Calcular --->

<cfif isdefined("url.AnexoId") and url.AnexoId neq "" and not isdefined("url.Leer")>
	<cfinclude template="AnexoLogic.cfm">
</cfif>

</body>
</html>