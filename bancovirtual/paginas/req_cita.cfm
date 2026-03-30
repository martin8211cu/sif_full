<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Solicitud de cita</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<cfif isdefined("url.id_persona")>
	<cfset form.id_persona =  #url.id_persona#>
</cfif>
<cfif isdefined("url.id_tramite")>
	<cfset form.id_tramite =  #url.id_tramite#>
</cfif>
<cfif isdefined("url.id_instancia")>
	<cfset form.id_instancia =  #url.id_instancia#>
</cfif>
<cfif isdefined("url.id_requisito")>
	<cfset form.id_requisito =  #url.id_requisito#>
</cfif> 


<cfif isdefined("form.id_tramite")>
	<cfif not isdefined("form.id_instancia") >
		<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
		<cfset form.id_instancia = instancia.obtener_instancia(form.id_persona, form.id_tramite) >
	<cfelseif  isdefined("form.id_instancia") and len(trim(form.id_instancia)) eq 0>
		<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
		<cfset form.id_instancia = instancia.obtener_instancia(form.id_persona, form.id_tramite) >
	<cfelseif  isdefined("form.id_instancia") and  form.id_instancia eq 0>
		<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
		<cfset form.id_instancia = instancia.obtener_instancia(form.id_persona, form.id_tramite) >
	</cfif>
</cfif>

<table width="510" border="0" align="center">
	<tr>
		<td>
			<cfinclude template="req_cita_form.cfm">
		</td>
	</tr>
</table>

</body></html>