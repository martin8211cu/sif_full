<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="url.s" default="1" type="numeric">
<cfquery name="user" datasource="asp" maxrows="20">
	select c.CEnombre, u.CEcodigo, u.Usucodigo, u.Usulogin, u.Utemporal, u.Uestado, u.admin
	from Usuario u, CuentaEmpresarial c
	where c.CEcodigo = u.CEcodigo
	<cfif url.s is 2>
	order by u.CEcodigo , u.Usucodigo desc
	<cfelse>
	order by u.Usucodigo desc
	</cfif>
</cfquery>

<table cellpadding="4" cellspacing="0" border="1" bordercolor="#000099">
<tr>
<th colspan="2"><a href="test-listuser.cfm?s=1">Usuario</a></th>
<th colspan="2"><a href="test-listuser.cfm?s=2">Empresa</a></th>
<th>Temp</th><th>activo</th><th>admin</th></tr>
<cfoutput query="user">
<tr><td class="mf">#Usucodigo#</td><td>#Usulogin#</td><td>#CEcodigo#</td><td>#CEnombre#</td><td>#Utemporal#</td><td>#Uestado#</td><td>#admin#</td></tr>
</cfoutput>
</table>

</body>
</html>
