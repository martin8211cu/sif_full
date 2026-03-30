<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<form name="form1" method="post">
  <input name="campo1" type="text" id="campo1">
  <input name="campo2" type="text" id="campo2">
  <input name="Alta" type="submit" id="Alta" value="Alta">
</form>
<!---
<cfif isdefined("campo1")>
	<cfdump var="#campo1#">
</cfif>
<cfif isdefined("campo2")>
	<cfdump var="#campo2#">
</cfif>
<cfdump var="#CGI#">
<cfset Request.hola = 'mundo'>
<cfdump var="#Request#">
--->
<cfquery name="consulta" datasource="minisif">
	select *
	from Monedas
</cfquery>
<cfoutput>
<table>
	<cfloop query="consulta">
		<tr>
			<td>#Mnombre#</td>
			<td>#Msimbolo#</td>
		</tr>
	</cfloop>
</table>
<p>&nbsp;</p>
<form name="form2" method="post" action="">
  <select name="select">
    <option value="1">Casa</option>
    <option value="2">Perro</option>
    <option value="3">Gato</option>
  </select>
</form>
<p>&nbsp;</p>
</cfoutput>



<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
</table>

</body>
</html>
