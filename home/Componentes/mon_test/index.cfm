<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>

<style type="text/css">
body { font-size: 10px; font-family:Verdana, Arial, Helvetica, sans-serif}
</style>
</head>

<body>

<div style="float:right;border:1px solid gray;background-color:#FFFF99">
	<h2>espera.cfm</h2>
	<table border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td><a href="espera.cfm?sec=10" target="xx">Esperar 10 segundos</a> </td>
    <td><a href="espera.cfm?sec=10&amp;loc=1" target="xx">cflocation</a></td>
  </tr>
  <tr>
    <td><a href="espera.cfm?sec=60" target="xx">Esperar 60 segundos</a></td>
    <td><a href="espera.cfm?sec=60&amp;loc=1" target="xx">cflocation </a></td>
  </tr>
  <tr>
    <td><a href="espera.cfm?sec=600" target="xx">Esperar 600 segundos</a></td>
    <td><a href="espera.cfm?sec=600&amp;loc=1" target="xx">cflocation</a></td>
  </tr>
  <tr>
    <td colspan="2"><a href="espera.cfm?qti=1" target="xx">QuitarThreadsInactivos</a></td>
  </tr>
  <tr>
    <td colspan="2"><a href="espera.cfm?borrar=1" target="xx">Borrar Estructuras</a></td>
  </tr>
  <tr>
    <td colspan="2"><a href="espera.cfm?gc=1" target="xx">System.gc</a></td>
  </tr>
  <tr>
    <td colspan="2"><a href="/cfmx/sif/tasks/monitor_accesos.cfm" target="xx">Task mon_accesos</a></td>
  </tr>
  <tr>
    <td colspan="2">
	<iframe src="about:blank" name="xx" frameborder="0" width="250" height="500"></iframe></td>
  </tr>
</table>
</div>
<iframe src="status.cfm" name="status" frameborder="0" width="900" height="720"></iframe>

</body>
</html>
