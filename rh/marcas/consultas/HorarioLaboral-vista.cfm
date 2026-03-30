<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_HorarioLaboral"
				Default="Reporte de Horario Laboral"
				returnvariable="titulo1"/>
				
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_HorarioLaboralConDetalleCosto"
	Default="Reporte de Horario Laboral con detalle de costo"
	returnvariable="titulo2"/>

<cfif isdefined("form.Costo") and form.Costo eq 'S'>
	<cfset titulo = titulo2>
<cfelse>
	<cfset titulo = titulo1>
</cfif>	
				  
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
			<td><cfinclude template="/rh/marcas/consultas/HorarioLaboral-form.cfm"></td>
		</tr>
	</table>	
</cfoutput>
</body>
</html>
