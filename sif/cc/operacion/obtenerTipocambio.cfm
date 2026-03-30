<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  and tc.Mcodigo = <cfqueryparam value="#Url.Mcodigo#" cfsqltype="cf_sql_numeric">
	  and tc.Hfecha <= <cfqueryparam value="#Url.EPfecha#" cfsqltype="cf_sql_date">
	  and tc.Hfechah > <cfqueryparam value="#Url.EPfecha#" cfsqltype="cf_sql_date">
</cfquery>
<cfset tc = TCsug.TCcompra>

<script language="JavaScript" type="text/javascript">
	window.parent.setTipoCambio(window.parent.document.<cfoutput>#Url.form#</cfoutput>, '<cfoutput>#tc#</cfoutput>');
</script>

</body>
</html>
