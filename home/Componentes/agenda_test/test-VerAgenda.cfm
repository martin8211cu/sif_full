<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Prueba de agenda</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style2 {color: #FFFFFF}
-->
</style>
</head>

<body>

<cfinclude template="test-nav.cfm">
<cfquery datasource="asp" name="agendas" maxrows="10">
	select agenda, nombre_agenda, tipo_agenda, horario_habil, escala,
		lectura_publico, escritura_publico, citar_publico
	from ORGAgenda
	order by agenda desc
</cfquery>

<table border="0" cellpadding="2" cellspacing="0">
  <tr bgcolor="#333333">
    <td><span class="style2"></span></td>
    <td><span class="style2"></span></td>
    <td><span class="style2"></span></td>
    <td><span class="style2"></span></td>
    <td><span class="style2"></span></td>
    <td colspan="3"><span class="style2">Permisos</span><span class="style2"></span><span class="style2"></span></td>
  </tr>
  <tr bgcolor="#333333">
    <td><span class="style2">Agenda</span></td>
    <td><span class="style2">Nombre</span></td>
    <td><span class="style2">Tipo</span></td>
    <td><span class="style2">Horario h&aacute;bil</span></td>
    <td><span class="style2">Escala</span></td>
    <td><span class="style2">Lectura</span></td>
    <td><span class="style2">Escritura</span></td>
    <td><span class="style2">Citar</span></td>
  </tr>
  <cfoutput query="agendas">
    <tr>
      <td>#agendas.agenda#</td>
      <td>#agendas.nombre_agenda#</td>
      <td>#agendas.tipo_agenda#</td>
      <td>#agendas.horario_habil#</td>
      <td>#agendas.escala#</td>
      <td>#agendas.lectura_publico#</td>
      <td>#agendas.escritura_publico#</td>
      <td>#agendas.citar_publico#</td>
    </tr>
  </cfoutput>
</table>
</body>
</html>
