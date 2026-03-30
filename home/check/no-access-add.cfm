<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>No autorizado</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body style="margin:0 ">

<cfheader name="Expires" value="0">

Insertando registro... <br><cfflush>

<cfquery datasource="asp">
	insert into SComponentes (SScodigo, SMcodigo, SPcodigo, SCuri, SCtipo, SCauto, BMfecha, BMUsucodigo)
	values (
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.SScodigo)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.SMcodigo)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.SPcodigo)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.SCuri)#">,
		'P', 1,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
</cfquery>
Registro insertado... <br><cfflush>
<cfif isdefined("form.actualizar")>
Probando acceso... <br><cfflush>
<script type="text/javascript">
	setTimeout('window.parent.location.reload()', 200);
</script>
<cfelse>
	Listo...<br>
	<a href="javascript:window.parent.location.reload()">Actualizar</a>
</cfif>
</body></html>