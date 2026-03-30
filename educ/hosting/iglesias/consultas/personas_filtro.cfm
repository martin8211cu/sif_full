<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.Pnombre") and not isdefined("Form.Pnombre")>
	<cfparam name="Form.Pnombre" default="#Url.Pnombre#">
</cfif>
<cfif isdefined("Url.Pcasa") and not isdefined("Form.Pcasa")>
	<cfparam name="Form.Pcasa" default="#Url.Pcasa#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.Pnombre") and Len(Trim(Form.Pnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.Papellido1 + ' ' + a.Papellido2 + ', ' + a.Pnombre) like '%" & #UCase(Form.Pnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pnombre=" & Form.Pnombre>
</cfif>
<cfif isdefined("Form.Pcasa") and Len(Trim(Form.Pcasa)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Pcasa) like '%" & #UCase(Form.Pcasa)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Pcasa=" & Form.Pcasa>
</cfif>

<cfoutput>
<form name="filtroPersona" method="post" action="#CurrentPage#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td align="right">Nombre</td>
    <td> 
      <input name="Pnombre" type="text" id="Pnombre" size="60" maxlength="60" value="<cfif isdefined("Form.Pnombre")>#Form.Pnombre#</cfif>">
    </td>
    <td align="right">Teléfono</td>
    <td> 
      <input name="Pcasa" type="text" id="Pcasa" size="20" maxlength="30" value="<cfif isdefined("Form.Pcasa")>#Form.Pcasa#</cfif>">
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>