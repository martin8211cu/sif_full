<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><cf_translate key="LB_BeneficiosporEmpleado">Beneficios por Empleado</cf_translate></title>
<link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">
</head>

<body>
	<cfif isdefined("Url.DEid") and Len(Trim(Url.DEid))>
		<cfset Form.DEid = Url.DEid>
		<cfinclude template="tabNames.cfm">
		<cfinclude template="consultas-frame-header.cfm">
		<cfinclude template="expediente-beneficios.cfm">
		<script language="javascript" type="text/javascript">
			window.print();
		</script>
	</cfif>
</body>
</html>
