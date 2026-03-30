<cfsilent>
	<cfset misc = CreateObject("component", "asp.parches.comp.misc")>

	<cfquery datasource="asp" name="data">
		select i.instalacion, i.fecha, p.parche, s.hostname, s.ipaddr, s.cliente
		from APInstalacion i
			join APParche p
				on i.parche = p.parche
			join APServidor s
				on s.servidor = i.servidor
		where i.instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	</cfquery>
	
	<cfquery datasource="asp" name="msglist">
		select t.num_tarea, t.datasource, t.ruta, t.tipo,
			m.num_msg, m.fecha, m.nombre, m.severidad,
			m.msg_corto, m.msg_largo
		from APTareas t 
			join APMensajes m
				on t.instalacion = m.instalacion
				and t.num_tarea = m.num_tarea
		where t.instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
		order by t.num_tarea, m.num_msg
	</cfquery>

</cfsilent><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>[Parche instalado] # HTMLEditFormat( session.instala.nombre ) #</title>
<style type="text/css">
.titulo {
	background-color:#333333;
	color:white;
}
.corte {
	background-color:#999999;
	color:#FFFFFF;
}
</style>
</head>
<body>
<h1>Reporte de instalación</h1>

<cfoutput><p>El parche 
  # HTMLEditFormat( session.instala.nombre ) # ha sido instalado. </p>
  <h2>Datos Generales</h2>
<table width="509" border="0" cellspacing="0" cellpadding="2">
  <tr>
    <td width="279">Fecha de instalación: </td>
    <td width="222">#DateFormat(data.fecha,'yyyy-mm-dd')# #TimeFormat(data.fecha,'HH:mm:ss')#</td>
  </tr>
  <tr>
    <td>Checksum de archivo JAR: </td>
    <td>No disponible </td>
  </tr>
  <tr>
    <td>Cliente: </td>
    <td>#HTMLEditFormat(data.cliente)#</td>
  </tr>
  <tr>
    <td>Servidor: </td>
    <td>#HTMLEditFormat(data.hostname)#</td>
  </tr>
  <tr>
    <td>Dirección IP: </td>
    <td>#HTMLEditFormat(data.ipaddr)#</td>
  </tr>
  <tr>
    <td>UUID de parche instalado: </td>
    <td>#HTMLEditFormat(data.parche)#</td>
  </tr>
  <tr>
    <td>UUID de instalación: </td>
    <td>#HTMLEditFormat(data.instalacion)#</td>
  </tr>
</table></cfoutput>
<h2>Errores reportados</h2>
<table border="0" cellspacing="0" cellpadding="2">
<cfoutput group="num_tarea" query="msglist">
  <tr class="corte">
    <td valign="top">&nbsp;</td>
    <td colspan="4" valign="top"># HTMLEditFormat( num_tarea )#.
	# HTMLEditFormat( datasource )# 
	[# HTMLEditFormat( tipo )#]
	# HTMLEditFormat( ruta )#
	</td>
    </tr>
  <tr class="titulo">
    <td valign="top">&nbsp;</td>
    <td valign="top">Hora</td>
    <td valign="top">Objeto</td>
    <td valign="top">Severidad </td>
    <td valign="top">Mensaje</td>
  </tr><cfoutput>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top"># HTMLEditFormat( TimeFormat( fecha, 'HH:mm:ss') )#</td>
    <td valign="top"># HTMLEditFormat( nombre )#</td>
    <td valign="top"># HTMLEditFormat( misc.sev2sevname(severidad) )# </td>
    <td valign="top"># HTMLEditFormat( msg_corto )# # HTMLEditFormat( msg_largo )# </td>
  </tr></cfoutput></cfoutput>
</table>
</body>
</html>