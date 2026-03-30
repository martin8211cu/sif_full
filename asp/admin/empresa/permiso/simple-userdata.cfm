<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>User Data</title>
</head>

<cfquery datasource="asp" name="data">
	select
		u.Usucodigo, u.Usulogin,
		d.Pnombre, d.Papellido1, d.Papellido2, d.Pemail1
	from Usuario u
		left join DatosPersonales d
			on u.datos_personales = d.datos_personales
	where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.u#">
	  and u.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._ctaemp#">
</cfquery>

<body>

<cfoutput>
<script type="text/javascript">
window.parent.loadUser(
	'#JSStringFormat(data.Usucodigo)#',
	'#JSStringFormat(data.Usulogin)#',
	'#JSStringFormat(data.Pnombre)#',
	'#JSStringFormat(data.Papellido1)#',
	'#JSStringFormat(data.Papellido2)#',
	'#JSStringFormat(data.Pemail1)#')
</script>
</cfoutput>	
</body>
</html>
