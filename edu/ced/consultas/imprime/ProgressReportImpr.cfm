<html>
<head>
<title>Reporte de Progreso</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
</head>

<body>
	<cfif isdefined("url.SPEcodigo") and not isdefined("Form.SPEcodigo")>
		<cfset Form.SPEcodigo = Url.SPecodigo>
	</cfif>
	<cfif isdefined("url.GRcodigo") and not isdefined("Form.GRcodigo")>
		<cfset Form.GRcodigo = Url.GRcodigo>
	</cfif>
	<cfif isdefined("url.PEcodigo") and not isdefined("Form.PEcodigo")>
		<cfset Form.PEcodigo = Url.PEcodigo>
	</cfif>
	<cfif isdefined("url.Ecodigo") and not isdefined("Form.Ecodigo")>
		<cfset Form.Ecodigo = Url.Ecodigo>
	</cfif>
	<cfif isdefined("url.checkCurso") and not isdefined("Form.checkCurso")>
		<cfset Form.checkCurso = Url.checkCurso>
	</cfif>
	<cfif isdefined("url.checkTabla") and not isdefined("Form.checkTabla")>
		<cfset Form.checkTabla = Url.checkTabla>
	</cfif>
	<cfif isdefined("url.firmaEncargado") and not isdefined("Form.firmaEncargado")>
		<cfset Form.firmaEncargado = Url.firmaEncargado>
	</cfif>
	<cfif isdefined("url.firmaAlumno") and not isdefined("Form.firmaAlumno")>
		<cfset Form.firmaAlumno = Url.firmaAlumno>
	</cfif>
	<cfif isdefined("url.firmaProfesor") and not isdefined("Form.firmaProfesor")>
		<cfset Form.firmaProfesor = Url.firmaProfesor>
	</cfif>
	<cfif isdefined("url.firmaDirector") and not isdefined("Form.firmaDirector")>
		<cfset Form.firmaDirector = Url.firmaDirector>
	</cfif>
	<cfif isdefined("url.firmaAdicional") and not isdefined("Form.firmaAdicional")>
		<cfset Form.firmaAdicional = Url.firmaAdicional>
	</cfif>
	<cfif isdefined("url.nombreAdicional") and not isdefined("Form.nombreAdicional")>
		<cfset Form.nombreAdicional = Url.nombreAdicional>
	</cfif>
	<cfif isdefined("url.filtroNota") and not isdefined("Form.filtroNota")>
		<cfset Form.filtroNota = Url.filtroNota>
	</cfif>
	<cfif isdefined("url.filtroPorcentaje") and not isdefined("Form.filtroPorcentaje")>
		<cfset Form.filtroPorcentaje = Url.filtroPorcentaje>
	</cfif>
	<cfif isdefined("url.preguntasText") and not isdefined("Form.preguntasText")>
		<cfset Form.preguntasText = Url.preguntasText>
	</cfif>
	<cfif isdefined("url.ckTE") and not isdefined("Form.ckTE")>
		<cfset Form.ckTE = 1>
	</cfif>
	<cfif isdefined("url.ckTG") and not isdefined("Form.ckTG")>
		<cfset Form.ckTG = 1>
	</cfif>
	<cfif isdefined("url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfset Form.rdCortes = Url.rdCortes>
	</cfif>
	<cfif isdefined("url.enPantalla") and not isdefined("Form.enPantalla")>
		<cfset Form.enPantalla = 0>
	</cfif>
	<cfif isdefined("url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfset Form.btnGenerar = 1>
	</cfif>
	<cfif isdefined("url.FechaRep") and not isdefined("Form.FechaRep")>
		<cfset Form.FechaRep = Url.FechaRep>
	</cfif>
	<cfinclude template="/edu/ced/consultas/ResultProgressReport.cfm">
</body>
</html>
