<cfparam name="url.EDfecha" type="date" default="#now()#">

<html>
<head>
<title>Obtiene Tipo de Cambio</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Mcodigo = <cfqueryparam value="#Url.Mcodigo#" cfsqltype="cf_sql_numeric">
	  and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(url.EDfecha)#">
	  and tc.Hfechah  > <cfqueryparam cfsqltype="cf_sql_date" value="#LSparseDateTime(url.EDfecha)#"> 
</cfquery>
<cfset tc = TCsug.TCventa>
<cfdump var="#url#">
<cfdump var="#TCsug#">

<script language="JavaScript" type="text/javascript">
	window.parent.setTipoCambio(window.parent.document.<cfoutput>#Url.form#</cfoutput>, '<cfoutput>#tc#</cfoutput>');
</script>

</body>
</html>
