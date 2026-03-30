<cf_templateheader title="Cuestionarios">
<cf_web_portlet_start titulo="Registro de Cuestionarios">

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

--->
<cfset session.DSN = 'minisif'>
<cfset session.EcodigoSDC = 2>
<cfset session.Ecodigo = 1>

<cfset form.RHEEid = 911 >
<cfset form.DEid = 4839 >
<cfset form.DEideval = 4839 >
<cfset form.RHPcodigo = 'ANP1' >
<cfset form.tipo = 'auto' >
<cfset form.RHEDtipo = 'A' >
<cfset form.Usucodigo = 27 >
<cfset form.Usucodigoeval = 27 >

<cfset tipo_evaluacion = 1 >
<cfif isdefined("form.PCid") and len(trim(form.PCid))>
	<cfset tipo_evaluacion = 2 >
</cfif>

<link type="text/css" rel="stylesheet" href="/cfmx/asp/css/asp.css">
<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top"><cfinclude template="pccontestar-form.cfm"></td>
	</tr>
</table>
<cf_web_portlet_end><cf_templatefooter>
