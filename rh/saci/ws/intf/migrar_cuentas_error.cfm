<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<link href="migrar_cuentas.css" rel="stylesheet" type="text/css" />
</head>

<body>
<cfparam name="url.cedula" default="">
<cfparam name="url.msg" default="">
<cfparam name="url.linea" default="">
<cfquery datasource="#session.dsn#" name="errores">
	select top 50 cedula, msg, stack 
	from migra_error
	where 1=1
	<cfif Len(url.cedula)>
		and upper(cedula) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase( cedula )#%">
	</cfif>
	<cfif Len(url.msg)>
		and upper(msg) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase( msg )#%">
	</cfif>
	<cfif Len(url.linea)>
		and upper(stack) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase( linea )#%">
	</cfif>
	order by cedula desc
</cfquery>
<form action="migrar_cuentas_error.cfm" method="get">
<table border="0" width="875">
  <tr>
    <td width="87"><strong>C&eacute;dula</strong></td>
    <td width="630"><strong>Msg</strong></td>
    <td width="149"><strong>L&iacute;nea</strong></td>
  </tr><cfoutput>
  <tr>
    <td><input type="text" name="cedula" value="# HTMLEditFormat( url.cedula ) #" size="10" onfocus="this.select()"></td>
    <td><input type="text" name="msg" value="# HTMLEditFormat( url.msg ) #" size="30" onfocus="this.select()">
	<input type="submit" value="Buscar" /></td>
    <td><input type="text" name="linea" value="# HTMLEditFormat( url.linea ) #" size="20" onfocus="this.select()"></td>
  </tr></cfoutput>
<cfoutput query="errores">
  <tr>
    <td># HTMLEditFormat( errores.cedula ) #</td>
    <td># HTMLEditFormat( errores.msg ) #</td>
    <td># HTMLEditFormat( ListFirst(errores.stack, Chr(10)) ) #</td>
  </tr>
</cfoutput>
</table>
</form>

</body>
</html>
