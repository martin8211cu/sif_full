<cfif isdefined("url.PCid") and not isdefined("form.PCid")>
	<cfset form.PCid = url.PCid >
</cfif>	

<cfif isdefined("url.PCUid") and not isdefined("form.PCUid")>
	<cfset form.PCUid = url.PCUid >
</cfif>	

<!--- 
	El pintado del cuestionario depende del tipo de evaluacion. 
	Hay dos tipos de evaluacion:
		1. Por habilidades: esta opcion significa que por cada habilidad asociada al puesto
							se va a pintar un cuestionario
		2. Por Cuestionario: para esta opcion solo se pinta el cuestionario que se selecciono
		   para la relacion de evaluacion.	
		3. Por Conocimientos: esta opcion significa que por cada conocimiento asociada al puesto
							se va a pintar un cuestionario
		4. Por Habilidades y Conocimientos: esta opcion significa que por cada conocimiento y habilidad asociada al puesto
							se va a pintar un cuestionario
		0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS
--->
<cfif isdefined("form.PCid") and form.PCid EQ -1 >
	<cfset tipo_evaluacion = 1 >
<cfelseif isdefined("form.PCid") and form.PCid EQ -2>
	<cfset tipo_evaluacion = 4 >
<cfelseif isdefined("form.PCid") and form.PCid EQ 0>
	<cfset tipo_evaluacion = 3 >
<cfelse>
	<cfset tipo_evaluacion = 2 >
</cfif>

<link type="text/css" rel="stylesheet" href="/cfmx/asp/css/asp.css">
<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top"><cfinclude template="pccontestar-form.cfm"></td>
	</tr>
</table>