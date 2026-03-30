
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
<title>Importaci&oacute;n concluida</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body style="margin:0">

<cfquery name="errores" datasource="#session.dsn#">
	select * from ErrorProceso where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
</cfquery>

<cfset ArrayLineas = ArrayNew(1)>
<cfloop query="errores">
	<cfset ArrayAppend(ArrayLineas, "#errores.Valor#")>
    <cfbreak >
</cfloop>
<cfset Listlineas = ArrayToList(ArrayLineas, "|")>

<cfset ArrayLineas = listtoarray(Listlineas , "|")>

<cfif errores.RecordCount EQ 0><h1>404 - Not found</h1><cfabort></cfif>

<cfoutput>
	<table border="0" cellspacing="2" cellpadding="2">
    <tr>
        <td valign="top" bgcolor="##CCCCCC">N&uacute;mero de referencia</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">1000</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Proceso completado</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">No</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">SQL ejecutado</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">No</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Registros en el archivo</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">#ArrayLineas[2]#</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Errores en el archivo</td>
        <td valign="top" bgcolor="##CCCCCC">-</td>
        <td valign="top" bgcolor="##CCCCCC">#errores.RecordCount#
	<cfif errores.RecordCount NEQ 0>
		[ <a href="/cfmx/sif/ce/importar/importar-errores.cfm"
		    style="text-decoration:underline;color:##0066cc;background-color:##cccccc"
			target="_blank">Ver listado</a> ]
		</cfif></td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Registros por procesar </td>
        <td valign="top" bgcolor="##CCCCCC">=</td>
        <td valign="top" bgcolor="##CCCCCC">#ArrayLineas[2]#</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Tiempo transcurrido</td>
		<td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">0 s</td>
    </tr>
    <tr>
        <td valign="top" bgcolor="##CCCCCC">Promedio</td>
        <td valign="top" bgcolor="##CCCCCC">&nbsp;</td>
        <td valign="top" bgcolor="##CCCCCC">0 ms
			por registro insertado</td>
    </tr>
</table>
</cfoutput>

<cfabort>

</body>
</html>
