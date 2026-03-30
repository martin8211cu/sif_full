<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DiarioMarcasDetallado"
	Default="Reporte Diario de marcas (Detallado)"
	returnvariable="titulo1"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DiarioMarcasResumido"
	Default="Reporte Diario de marcas (Resumido)"
	returnvariable="titulo2"/>


<cfif not isdefined("form.resumido") >
	<cfset titulo = titulo1>
<cfelse>
	<cfset titulo = titulo2>
</cfif>

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
			<td><cfinclude template="/rh/marcas/consultas/MarcasDiarias-form.cfm"></td>
		</tr>
	</table>	
</cfoutput>
</body>
</html>
