<html>
<head>
<title><cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset vsFiltro = ''>
<cfif isdefined("url.FDEnombre") and Len(Trim(url.FDEnombre)) NEQ 0>   		
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & url.FDEnombre>
</cfif>
<cfif isdefined("url.FDEidentificacion") and Len(Trim(url.FDEidentificacion)) NEQ 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & url.FDEidentificacion>
</cfif>	
<cfif isdefined("url.fRHPcodigo") and Len(Trim(url.fRHPcodigo)) NEQ 0>
	<cfset vsFiltro = vsFiltro & Iif(Len(Trim(vsFiltro)) NEQ 0, DE("&"), DE("")) & "fRHPcodigo=" & url.fRHPcodigo>
</cfif>

<cf_rhimprime datos="/rh/evaluaciondes/consultas/RelacEvalEvaluadoresImp.cfm" paramsuri="&RHEEid=#url.RHEEid#&#vsFiltro#"> 
<form name="form1">
	<table width="98%">
		<tr><td><cfinclude template="RelacEvalEvaluadoresImp.cfm"></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cerrar"
					Default="Cerrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Cerrar"/>
				<input type="button" value="<cfoutput>#BTN_Cerrar#</cfoutput>" onClick="javascript: window.close();">
			</td>
		</tr>
	</table>
</form>
</body>
</html>
