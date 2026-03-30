<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>
<table width="100%" border="1">
  <tr>
    <td colspan="2" align="center"><h1><strong>Exportador de Archivos (Ayuda)</strong></h1></td>

  </tr>
  <tr>
    <td valign="top" width="50%">
		<table width="100%" border="0" cellspacing="0" cellpadding="5">
			<tr>
				<td><font size="2"  color="#0000FF" face="Verdana, Arial, Helvetica, sans-serif"><strong>Características para crear el CFM de parámetros</strong></font></td>
			</tr>
			<tr><td>No debe tener FORM, ya que se encuentra incluido dentro de uno (form1).</td></tr>
			<tr><td>No debe tener botones. (El TAG maneja  los botones)</td></tr>
			<tr><td>Se recomienda que los parámetros estén incluidos dentro de una tabla (TABLE). 
					Con el fin de que la información aparezca ordenada.</td></tr>

		</table>
	</td>
    <td valign="top" width="52%">
		<table width="100%" border="0" cellspacing="0" cellpadding="5">
		  <tr>
			<td><font size="2" color="#0000FF" face="Verdana, Arial, Helvetica, sans-serif"><strong>Como mostrar la lista de exportadores en el menú </strong></font> ? </td>
		  </tr>
		  <tr><td>Ingresar a la seguridad  e incluya  un proceso que contenga la siguiente dirección
				<strong><em>/sif/importar/IMP_ListaExportadores.cfm?Modulo=XXX</em></strong>  
				y sustituir el valor de las "equis" por el módulo del que se desea visualizar la lista de 
				exportadores,o indicar TODOS si lo que se desea  es ver todos los exportadores del sistema.</td></tr>
		   <tr><td>En el parametro módulo se debe indicar el módulo tal y como aparece en el 
				combo que se encuentra en la pantalla de "Definiciones de Importación" en PSO
				ejemplo "sif.inv,sif.cg,rh.nomina o TODOS"</td></tr>
		   <tr><td>En esta lista de exportadores solamente aparecen 
				 los exportadores a lo que el usuario tiene derechos de ejecución</td></tr>
		</table>
	</td>
  </tr>
  <tr>
    <td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="5">
		  <tr>
			<td><font size="2" color="#0000FF" face="Verdana, Arial, Helvetica, sans-serif"><strong>Manejo de valores enviados por el TAG en el cfm de parámetros </strong></font></td>
		  </tr>
		  <tr><td>Los valores tipo parámetros que envía el TAG se envían en un vector de la siguiente manera:
				"<em>EcodigoASP=2|Bid=14|ERNid=540</em>". en un campo form llamado PARAMETROS.</td></tr>
		   <tr><td>El desarrollador del CFM de parámetros se encargara de manejar estos datos
		   		 y mostrarlos en la pantalla. </td></tr>
		   <tr><td>Se recomienda que los parámetros que se envían ya cargados se muestren 
		   		en la pantalla de parámetros como campos ocultos y/o etiquetas, 
				para que no se puedan modificar.</td></tr>
		</table>
	</td>
    <td valign="top">
		<table width="100%" border="0" cellspacing="0" cellpadding="5">
		  <tr>
			<td><font size="2" color="#0000FF" face="Verdana, Arial, Helvetica, sans-serif"><strong>Ejemplos de invocación del TAG de Exportación </strong></font></td>
		  </tr>
		  <tr><td><strong>Invocación de la manera anterior</strong><br>
				 &lt;cf_sifimportar <br>
				&nbsp;&nbsp; EIcodigo="EX_BCR"<br>
				&nbsp;&nbsp; EIid="1207"<br> 
				&nbsp;&nbsp; mode="out"&gt;<br>
				&nbsp;&nbsp; &lt; cf_sifimportarparam name="Bid" value="14"&gt;<br>
				&nbsp;&nbsp; &lt;cf_sifimportarparam name="ERNid" value="540"&gt;<br>
				 &lt;/cf_sifimportar&gt;
		  </td>
		  </tr>
		  <tr><td><strong>Invocación con las nuevas mejoras</strong><br>
				&lt;cf_sifimportar 
				&nbsp;&nbsp;EIcodigo="EX_BCR" <br>
				&nbsp;&nbsp;EIid="1207"<br>
				&nbsp;&nbsp;Nuevo="true" <br>
				&nbsp;&nbsp;mode="out"&gt; <br>
				&nbsp; &lt;cf_sifimportarparam name="Bid" value="14"&gt; <br>
				&nbsp;&nbsp;&lt; cf_sifimportarparam name="ERNid" value="540"&gt; <br>
				&lt;/cf_sifimportar&gt;</td>
		  </tr>
		  <tr><td><strong>Invocación para mostrar la lista </strong><br>
&lt; cf_sifimportar<br>  
&nbsp;&nbsp;mode="out"<br> 
&nbsp;&nbsp;Nuevo="true"<br> 
&nbsp;&nbsp;Modulo = "rh.reppag"<br> 
&nbsp;&nbsp;ListaDeExportacion ="true"&gt;<br>	
&lt; /cf_sifimportar&gt;	  
		  </td>
		  </tr>
		</table>
	</td>
  </tr>
</table>
</body>
</html>
