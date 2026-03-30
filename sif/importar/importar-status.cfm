<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<!---
	Muestra el resultado de una importacion
	Parámetros:
		url.id   ( requerido ) Número de importación en bitácora. IBitacora.IBid
		url.hash ( requerido ) Hash calculado en importar-avance.  Se solicita por seguridad.
--->
<head>
<title>Importaci&oacute;n concluida</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body style="margin:0">

<cfparam name="url.id"   default="0" type="numeric">
<cfparam name="url.hash" default="0" type="string">

<cfquery datasource="sifcontrol" name="bt">
	select * from IBitacora
	where IBid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
	  and IBhash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hash#">
</cfquery>
<cfif bt.RecordCount EQ 0><h1>404 - Not found</h1><cfabort></cfif>
<!--- Mostrar el status --->

<cfif bt.IBinvalidos EQ 0>
	<script language="javascript">
		if (window.parent.cf_ImportarCompleto)
		{
			window.parent.cf_ImportarCompleto();
		}
	</script>
</cfif>

<cfoutput>
	<table border="0" cellspacing="2" cellpadding="2">
    <tr>
        <td valign="top" bgcolor="##CCCCCC">N&uacute;mero de referencia</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">#url.id#</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Proceso completado</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC"><cfif bt.IBcompletada EQ 1>S&iacute;<cfelse>No</cfif></td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">SQL ejecutado</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC"><cfif bt.IBejecutado EQ 1>S&iacute;<cfelse>No</cfif></td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Registros en el archivo</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">#bt.IBregistros#</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Errores en el archivo</td>
        <td valign="top" bgcolor="##CCCCCC">-</td>
        <td valign="top" bgcolor="##CCCCCC">#bt.IBinvalidos#
	<cfif bt.IBinvalidos NEQ 0>
		[ <a href="/cfmx/sif/importar/importar-errores.cfm?id=#url.id#&amp;hash=#url.hash#" 
		    style="text-decoration:underline;color:##0066cc;background-color:##cccccc"
			target="_blank">Ver listado</a> ]
		</cfif></td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Registros por procesar </td>
        <td valign="top" bgcolor="##CCCCCC">=</td>
        <td valign="top" bgcolor="##CCCCCC">#bt.IBinsertados#</td>
    </tr>
	<cfif bt.IBrechazados NEQ 0>
	<tr>
		<td valign="top" bgcolor="##CCCCCC" style="color:##FF0000:font:bold;">Errores en los datos </td>
		<td valign="top" bgcolor="##CCCCCC">-</td>
		<td valign="top" bgcolor="##CCCCCC">#bt.IBrechazados#
		[ <a href="/cfmx/sif/importar/importar-rechazo.cfm?id=#url.id#&hash=#url.hash#" 
		    style="text-decoration:underline;color:##0066cc;background-color:##cccccc"
			target="_blank">Ver listado</a> ] 
		</td>
	</tr></cfif>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Tiempo transcurrido</td>
		<td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
		<cfset secs = DateDiff("s", bt.IBfechaini, bt.IBfechafin)>
        <td valign="top" bgcolor="##CCCCCC">#secs# s</td>
    </tr>
	<cfif (bt.IBinsertados) NEQ 0>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Promedio</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC"># Round( secs * 10000 / (bt.IBinsertados) ) / 10# ms
			por registro insertado</td>
    </tr>
	</cfif>
</table>
</cfoutput>


</body>
</html>
