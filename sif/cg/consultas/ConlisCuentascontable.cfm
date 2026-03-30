<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Buscar" Default="Buscar" 
returnvariable="BTN_Buscar" xmlfile = "/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Lista de Cuentas Contables" 
returnvariable="LB_Titulo" xmlfile = "ConlisCuentascontable.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CuentaMayor" Default="Cuenta Mayor" 
returnvariable="LB_CuentaMayor" xmlfile = "ConlisCuentascontable.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Formato" Default="Formato" 
returnvariable="LB_Formato" xmlfile = "ConlisCuentascontable.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descripcion" Default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile = "ConlisCuentascontable.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AceptaMov" Default="Acepta Mov." 
returnvariable="LB_AceptaMov" xmlfile = "ConlisCuentascontable.xml"/>
<html>
<head>
<title><cfoutput>#LB_Titulo#</cfoutput></title>
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

<cfif isdefined("Url.Campo") and not isdefined("Form.Campo")>
	<cfparam name="Form.Campo" default="#Url.Campo#">
	<cfset Form.Campo = Url.Campo>
</cfif>

<cfif isdefined("Form.Campo")>
	<cfset purl = purl & "&Campo=" & #Form.Campo#>	
<cfelse>
	<cfset Form.Campo = 0>
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(v1, v2, v3,v4) {
	if (window.opener != null) {
		<cfif #Form.Campo# EQ 0>
		<cfoutput>
			window.opener.document.form1.Ccuenta.value=v1;
			window.opener.document.form1.Cmayor.value=v2;
			window.opener.document.form1.Cformato.value=v3.substring(5,v3.length);
			window.opener.document.form1.Cdescripcion.value=v4;
		</cfoutput>			
		<cfelseif #Form.Campo# EQ 1>
		<cfoutput>
			window.opener.document.form1.Ccuenta1.value=v1;
			window.opener.document.form1.Cmayor1.value=v2;
			window.opener.document.form1.Cformato1.value=v3.substring(5,v3.length);
			window.opener.document.form1.Cdescripcion1.value=v4;
		</cfoutput>
		<cfelse>
		<cfoutput>
			window.opener.document.form1.Ccuenta2.value=v1;
			window.opener.document.form1.Cmayor2.value=v2;
			window.opener.document.form1.Cformato2.value=v3.substring(5,v3.length);
			window.opener.document.form1.Cdescripcion2.value=v4;
		</cfoutput>			
		</cfif>
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
   	<td colspan="5">&nbsp;</td>
   </tr>
  <tr> 
    <td align="left">#LB_CuentaMayor#</td>
	 <td align="left">#LB_Formato#</td>
    <td align="left">#LB_Descripcion#</td>
	<td align="left" colspan="2">#LB_AceptaMov#</td>
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
      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Buscar#">
    </td>
  </tr>  
  <input name="Campo" type="hidden" value="#Form.Campo#">
</table>
</form>
</cfoutput>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N">
	<cfinvokeargument name="tabla" value="CContables"/>
	<cfinvokeargument name="columnas" value="Ccuenta,Cmayor,Cformato,Cdescripcion,Cmovimiento"/>
	<cfinvokeargument name="desplegar" value="Cmayor,Cformato,Cdescripcion,Cmovimiento"/>
	<cfinvokeargument name="etiquetas" value="#LB_CuentaMayor#,#LB_Formato#,#LB_Descripcion#,#LB_AceptaMov#"/>
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
	<cfinvokeargument name="fparams" value="Ccuenta,Cmayor,Cformato,Cdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>