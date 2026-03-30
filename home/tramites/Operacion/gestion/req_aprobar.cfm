<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">


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
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Recaudaci&oacute;n por Sucursal</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">


<table width="510" border="0" align="center">
<tr>
  <td colspan="2"><cfinclude template="hdr_persona.cfm"></td>
</tr>
<tr>
  <td width="313" valign="top"><cfinclude template="hdr_tramite.cfm"></td>
<td width="163" valign="top"><cfinclude template="hdr_requisito.cfm"></td>
</tr>
<tr>
  <td colspan="2">&nbsp;</td>
</tr>
<tr>
  <td colspan="2">Usted puede aprobar este requisito utilizando el bot&oacute;n de &quot;Aprobar&quot; de esta pantalla. <br>
    Verifique si el usuario cumple con los requisitos del tr&aacute;mite, y seleccione la opci&oacute;n adecuada</td>
</tr>
<tr>
  <td colspan="2">&nbsp;</td>
</tr>
<tr>
  <td colspan="2" align="center">
  <form action="req_aprobar_sql.cfm" method="post">
  <cfoutput>
  <input type="hidden" name="id_instancia" value="#url.id_instancia#">
  <input type="hidden" name="id_requisito" value="#url.id_requisito#">
  <input type="hidden" name="id_persona" value="#url.id_persona#">
  <input type="hidden" name="id_tramite" value="#url.id_tramite#">
  </cfoutput>
  	<input name="Submit" type="submit" value="Aprobar">  
	&nbsp;
	<cfoutput>
	<input name="Button" type="button" onClick="location.href=('gestion-form.cfm?identificacion_persona=#
		HTMLEditFormat(data_persona.identificacion_persona)
		#&id_tramite=#HTMLEditFormat(url.id_tramite)
		#&id_requisito=#HTMLEditFormat(url.id_requisito)
		#&id_tipoident=#HTMLEditFormat(url.id_tipoident)#');" value="Regresar">
	</cfoutput>
	</form>
	</td>
  </tr>
</table>
</body></html>
