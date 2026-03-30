<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DiasNoAgrupados"
	Default="Reporte Días no agrupados"
	returnvariable="titulo"/>

<html>
<head>
<cfoutput><title>#titulo#</title></cfoutput>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><cfinclude template="/rh/marcas/consultas/DiasNoAgrupados-form.cfm"></td>
		</tr>
	</table>	
</cfoutput>
</body>
</html>
