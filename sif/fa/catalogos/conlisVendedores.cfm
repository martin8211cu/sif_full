<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name) {
	if (window.opener != null) {
		window.opener.document.form1.FVjefe.value   = id;
		window.opener.document.form1.FVjefenombre.value = name;
		window.close();
	}
}
</script>

<cfif isdefined("Url.fFVnombrejefe") and not isdefined("Form.fFVnombrejefe")>
	<cfparam name="Form.fFVnombrejefe" default="#Url.fFVnombrejefe#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.fFVnombrejefe") and Len(Trim(Form.fFVnombrejefe)) NEQ 0>
 	<cfset filtro = filtro & " and upper(FVnombre) like '%" & #UCase(Form.fFVnombrejefe)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fFVnombrejefe=" & Form.fFVnombrejefe>
</cfif>
<html>
<head>
<title>Lista de Vendedores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroVendedor" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>Vendedor</strong></td>
		<td> 
			<input name="fFVnombrejefe" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.fFVnombrejefe")>#Form.fFVnombrejefe#</cfif>" onFocus="javascript:this.select();">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="FVendedores"/>
	<cfinvokeargument name="columnas" value="FVid,FVnombre"/>
	<cfinvokeargument name="desplegar" value="FVnombre"/>
	<cfinvokeargument name="etiquetas" value="Vendedor"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#filtro# "/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisVendedores.cfm"/>
	<cfinvokeargument name="formName" value="formlista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="FVid,FVnombre"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
</body>
</html>