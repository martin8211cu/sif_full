<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		window.opener.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.id#</cfoutput>.value   = id;
		window.opener.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.codigo#</cfoutput>.value = name;
		window.opener.document.<cfoutput>#url.formulario#</cfoutput>.<cfoutput>#url.desc#</cfoutput>.value = desc;
		window.close();
	}
}
</script>

<cfif isdefined("Url.PRJPOcodigo") and not isdefined("Form.PRJPOcodigo")>
	<cfparam name="Form.PRJPOcodigo" default="#Url.PRJPOcodigo#">
</cfif>
<cfif isdefined("Url.PRJPOdescripcion") and not isdefined("Form.PRJPOdescripcion")>
	<cfparam name="Form.PRJPOdescripcion" default="#Url.PRJPOdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.PRJPOcodigo") and Len(Trim(Form.PRJPOcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(PRJPOcodigo) like '%" & #UCase(Form.PRJPOcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRJPOcodigo=" & Form.PRJPOcodigo>
</cfif>
<cfif isdefined("Form.PRJPOdescripcion") and Len(Trim(Form.PRJPOdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(PRJPOdescripcion) like '%" & #UCase(Form.PRJPOdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRJPOdescripcion=" & Form.PRJPOdescripcion>
</cfif>
<html>
<head>
<title>Lista de Proyectos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="PRJPOcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.PRJPOcodigo")>#Form.PRJPOcodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="PRJPOdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PRJPOdescripcion")>#Form.PRJPOdescripcion#</cfif>" onfocus="javascript:this.select();">
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
	<cfinvokeargument name="tabla" value="PRJPobra"/>
	<cfinvokeargument name="columnas" value="PRJPOid,PRJPOcodigo,PRJPOdescripcion"/>
	<cfinvokeargument name="desplegar" value="PRJPOcodigo,PRJPOdescripcion"/>
	<cfinvokeargument name="etiquetas" value="CÃ³digo, DescripciÃ³n"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisObras.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PRJPOid,PRJPOcodigo,PRJPOdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>
</body>
</html>
