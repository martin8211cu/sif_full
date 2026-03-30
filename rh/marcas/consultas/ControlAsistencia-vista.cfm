<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_RepCtrlAsistencia"
				Default="Reporte Control de Asistencia"
				returnvariable="titulo"/>
				  
<html>
<head>
<cfoutput><title>#titulo#</title></cfoutput>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<!---<cfdump var="#paramsuri#">--->
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td><cfinclude template="/rh/marcas/consultas/ControlAsistencia-form.cfm"></td>
		</tr>
	</table>	
</cfoutput>
</body>
</html>
