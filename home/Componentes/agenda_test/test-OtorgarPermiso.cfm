<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cfinclude template="test-nav.cfm">

<cfparam name="form.agenda" default="">
<cfparam name="form.Usucodigo" default="">
<cfparam name="form.permiso" default="">
<cfoutput>

<form name="form1" method="post" action=""><input type="hidden" name="go">
  <table border="1">
    <tr align="center">
      <th colspan="2"><strong>Otorgar Permiso</strong></th>
    </tr>
    <tr>
      <td align="left">Agenda</td>
      <td align="left"><input type="text" name="agenda" value="#form.agenda#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td align="left">Usucodigo</td>
      <td align="left"><input type="text" name="Usucodigo" value="#form.Usucodigo#" onFocus="this.select()"></td>
    </tr>
    <tr align="center">
      <td align="left">Permiso</td>
      <td align="left"><select name="permiso">
        <option value="propietario" <cfif form.permiso is 'propietario'>selected</cfif> >propietario</option>
        <option value="lectura"     <cfif form.permiso is 'lectura'>    selected</cfif> >lectura</option>
        <option value="escritura"   <cfif form.permiso is 'escritura'>  selected</cfif> >escritura</option>
        <option value="citar"       <cfif form.permiso is 'citar'>      selected</cfif> >citar</option>
      </select></td>
    </tr>
    <tr align="center">
      <td colspan="2"><input name="go" type="submit" id="go" value="Otorgar Permiso"></td>
    </tr>
  </table>
</form>

<cfif isdefined("form.go")>
	<strong>Otorgar Permiso #form.agenda#</strong><br>
	<code>#agenda.OtorgarPermiso(form.agenda,form.Usucodigo,form.permiso)#</code><br><br>
</cfif>

<script type="text/javascript">
<!--
document.form1.agenda.focus();
//-->
</script>

</cfoutput>
</body>
</html>
