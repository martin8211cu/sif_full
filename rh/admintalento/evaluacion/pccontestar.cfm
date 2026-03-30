<!--- 
	El pintado del cuestionario depende del tipo de evaluacion. 
	Hay dos tipos de evaluacion:
		1. Por Habilidades: para esta opcion solo se pinta los comportamientos asociados a las habilidades seleccionadas en la evaluación.
		2. Por Objetivos: para esta opcion solo se pinta los objetivos que se selecciono
		   para la relacion de evaluacion.	
--->
<cfset tipo_evaluacion = 1 >
<cfif isdefined("data_relacion.RHRStipo") and len(trim(data_relacion.RHRStipo)) and data_relacion.RHRStipo eq 'O' >
	<cfset tipo_evaluacion = 2 >
</cfif>


<link type="text/css" rel="stylesheet" href="/cfmx/asp/css/asp.css">
<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top"><cfinclude template="pccontestar-form.cfm"></td>
	</tr>
</table>