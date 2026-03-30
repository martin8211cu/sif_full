<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>
	<script language="javascript" type="text/javascript">
	<cfif Compare(Session.tipoRolAdmin, 'sys.admin') EQ 0>
		location.href = "admin/index.cfm";
	<cfelseif Compare(Session.tipoRolAdmin, 'sys.agente') EQ 0>
		location.href = "agente/index.cfm";
	<cfelseif Compare(Session.tipoRolAdmin, 'sys.adminCuenta') EQ 0>
		location.href = "admCta/index.cfm";
	</cfif>
	</script>
</body>
</html>
