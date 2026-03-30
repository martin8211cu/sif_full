<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Test Horario</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {color: white;background-color:navy;font-weight:bold}
-->
</style>
</head>

<body>
<cfset horario = CreateObject("component", "home.Componentes.Horario")>
<cfparam name="form.horario" default="L-V0800-1500,M0600-1200">
<cfparam name="form.horario2" default="L-V1300-1700">
<cfparam name="form.escala" default="30">
<cfparam name="form.action" default="parse">
<cfoutput>

<form name="parse" id="parse" action="" method="post">
<table width="316" border="0" cellpadding="4" cellspacing="0">
  <tr>
    <th colspan="2" class="style1">Componente Horario
  </tr>
  <tr>
    <td width="100">Horario</td>
    <td width="200"><input name="horario" type="text" id="horario" value="#HTMLEditFormat(form.horario)#" size="30" maxlength="30"></td>
  </tr>
  <tr>
    <td width="100">Horario 2</td>
    <td width="200"><input name="horario2" type="text" id="horario2" value="#HTMLEditFormat(form.horario2)#" size="30" maxlength="30"></td>
  </tr>
  <tr>
    <td width="100">Escala</td>
    <td width="200"><input name="escala" type="text" id="escala" value="#HTMLEditFormat(form.escala)#" size="30" maxlength="30"></td>
  </tr>
  <tr align="center">
    <td rowspan="5" align="left" valign="top">Operaci&oacute;n:</td>
    <td align="left"><input name="action" type="radio" value="parse" <cfif form.action is 'parse'>checked</cfif>>
      parse</td>
  </tr>
  <tr align="center">
    <td align="left"><input name="action" type="radio" value="union" <cfif form.action is 'union'>checked</cfif>> 
      union</td>
  </tr>
  <tr align="center">
    <td align="left"><input name="action" type="radio" value="subtract" <cfif form.action is 'subtract'>checked</cfif>> 
      subtract</td>
  </tr>
  <tr align="center">
    <td align="left"><input name="action" type="radio" value="intersect" <cfif form.action is 'intersect'>checked</cfif>> 
      intersect</td>
  </tr>
  <tr align="center">
    <td align="left"><input name="action" type="radio" value="fragment" <cfif form.action is 'fragment'>checked</cfif>> 
      fragment</td>
  </tr>
  <tr align="center">
    <td colspan="2"><input type="submit" name="Submit" value="Go"></td>
  </tr>
</table>
</form>

	<cfif Len(form.horario)>
	  <cfset h = horario.parse(form.horario)></cfif>
	<cfif Len(form.horario2)>
	  <cfset h2 = horario.parse(form.horario2)></cfif>
	<cfif form.action is "parse">
          <code>Parse('#HTMLEditFormat(h.getString())#'): <br>
          #ListChangeDelims(h.getString(),'<br>')#</code>
	<cfelseif form.action is "union">
		<code>Union('#HTMLEditFormat(h.getString())#', '#HTMLEditFormat(h2.getString())#'): <br>
		#ListChangeDelims(h.Union(h2).getString(),'<br>')#</code>
	<cfelseif form.action is "subtract">
		<code>Subtract('#HTMLEditFormat(h.getString())#', '#HTMLEditFormat(h2.getString())#'): <br>
		#ListChangeDelims(h.Subtract(h2).getString(),'<br>')#</code>
	<cfelseif form.action is "intersect">
		<code>Intersect('#HTMLEditFormat(h.getString())#', '#HTMLEditFormat(h2.getString())#'): <br>
		#ListChangeDelims(h.Intersect(h2).getString(),'<br>')#</code>
	<cfelseif form.action is "fragment">
		<code>Fragment('#HTMLEditFormat(h.getString())#', '#HTMLEditFormat(form.escala)#'): <br>
		#ListChangeDelims(h.fragment(escala).getString(),'<br>')#</code>
	</cfif>

</cfoutput>

</body>
</html>
