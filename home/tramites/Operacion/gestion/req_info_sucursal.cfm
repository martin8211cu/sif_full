<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Informaci&oacute;n de Tr&aacute;mite</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">
<cfif not isdefined("url.id_instancia") >
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
	<cfset url.id_instancia = instancia.obtener_instancia(url.id_persona, url.id_tramite) >
<cfelseif  isdefined("url.id_instancia") and len(trim(url.id_instancia)) eq 0>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
	<cfset url.id_instancia = instancia.obtener_instancia(url.id_persona, url.id_tramite) >
<cfelseif  isdefined("url.id_instancia") and  url.id_instancia eq 0>
	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
	<cfset url.id_instancia = instancia.obtener_instancia(url.id_persona, url.id_tramite) >
</cfif>

<table width="540" border="0" align="center">
	<tr>
		<td>
			<cfinclude template="req_info_sucursal_form.cfm">
		</td>
	</tr>
</table>


</body></html>