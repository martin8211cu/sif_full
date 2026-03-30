<html>
<head>
<title>Lista de Cuentas Contables</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfif isdefined("Url.Cmayor") and not isdefined("Form.Cmayor")>
	<cfparam name="Form.Cmayor" default="#Url.Cmayor#">
	<cfset Form.F_Cmayor = Url.Cmayor>
</cfif>

<cfset purl = "">
<cfif isdefined("Form.Cmayor")>
	<cfset purl = purl & "&Cmayor=" & #Form.Cmayor#>
	
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(v1, v2, v3,v4) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.form2.Cformato.value=v1;
			window.opener.document.form2.Cmayor.value=v2;
			window.opener.document.form2.CDetalle.value=v3.substring(5,v3.length);
			window.opener.document.form2.Cdescripcion.value=v4;
		</cfoutput>
		window.close();
	}
}
</script>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.F_Cmayor") and Len(Trim(Form.F_Cmayor)) NEQ 0>
	<cfset filtro = filtro & " and Cmayor = '" & #Form.F_Cmayor# & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cmayor=" & Form.F_Cmayor & #purl#>
</cfif>

<cfif isdefined("Form.F_Cformato") and Len(Trim(Form.F_Cformato)) NEQ 0>
 	<cfset filtro = filtro & " and Cformato like '%" & #Form.F_Cformato# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cformato=" & Form.F_Cformato & #purl#>
</cfif>

<cfif isdefined("Form.F_Cdescripcion") and Len(Trim(Form.F_Cdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Cdescripcion) like '%" & #UCase(Form.F_Cdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cdescripcion=" & Form.F_Cdescripcion & #purl#>
</cfif>

<cfif isdefined("Form.F_Cmovimiento") and Len(Trim(Form.F_Cmovimiento)) NEQ 0>
 	<cfset filtro = filtro & " and Cmovimiento = '" & #Form.F_Cmovimiento# & "'" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "F_Cmovimiento=" & Form.F_Cmovimiento & #purl#>
</cfif>


<cfoutput>
<form style="margin:0; " name="filtroUsuario" method="post" action="#CurrentPage#">

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
   <tr>
   	<td colspan="5">&nbsp; </td>
   </tr>
  <tr> 
    <td align="left">Cuenta Mayor</td>
	 <td align="left">Formato</td>
    <td align="left">Descripcion</td>
	<td align="left" colspan="2">Acepta Mov.</td>
  </tr>
  
  <tr> 
    <td> 
      <input name="F_Cmayor" type="text" id="F_Cmayor" size="5" maxlength="5" value="<cfif isdefined("Form.F_Cmayor")>#Form.F_Cmayor#</cfif>">
    </td>
    <td> 
      <input name="F_Cformato" type="text" id="F_Cformato" size="40" maxlength="100" value="<cfif isdefined("Form.F_Cformato")>#Form.F_Cformato#</cfif>">
    </td>
    <td> 
      <input name="F_CDescripcion" type="text" id="F_CDescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.F_CDescripcion")>#Form.F_CDescripcion#</cfif>">
    </td>
    <td> 
      <input name="F_Cmovimiento" type="text" id="F_Cmovimiento" size="1" maxlength="1" value="<cfif isdefined("Form.F_Cmovimiento")>#Form.F_Cmovimiento#</cfif>">
    </td>	
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar">
    </td>
  </tr>  
  
  
</table>
</form>
</cfoutput>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N">
	<cfinvokeargument name="tabla" value="CContables"/>
	<cfinvokeargument name="columnas" value="Cformato,Cmayor,Cformato,Cdescripcion,Cmovimiento"/>
	<cfinvokeargument name="desplegar" value="Cmayor,Cformato,Cdescripcion,Cmovimiento"/>
	<cfinvokeargument name="etiquetas" value="Cuenta Mayor,Formato,Descripcion,Acepta Mov."/>
	<cfinvokeargument name="formatos" value="S,S,S,S"/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# 
											#filtro#
											order by Cmayor,Cformato"/>
	<cfinvokeargument name="align" value="left, left,left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ConlisCuentascontable.cfm"/>
	<cfinvokeargument name="formName" value="listaUsuarios"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="MaxRowsQuery" value="500"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="Cformato,Cmayor,Cformato,Cdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>