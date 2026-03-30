<html>
<head>
<title>Listado de Notas de Preescolar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../../css/edu.css" type="text/css">
</head>

<cfif isdefined("Url.rdTipoRep") and not isdefined("Form.rdTipoRep")>
	<cfparam name="Form.rdTipoRep" default="#Url.rdTipoRep#">
</cfif> 

<body>
	<cfif isdefined("form.rdTipoRep") and form.rdTipoRep EQ 'AA'>						
		<cfinclude template="/edu/ced/consultas/formListaAAplazados.cfm">				
	<cfelse>
		<cfinclude template="/edu/ced/consultas/formListaMejoresPromedios.cfm">		
	</cfif>
</body>
</html>