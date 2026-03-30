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

<cfif isdefined("Url.PRJAcodigo") and not isdefined("Form.PRJAcodigo")>
	<cfparam name="Form.PRJAcodigo" default="#Url.PRJAcodigo#">
</cfif>
<cfif isdefined("Url.PRJAdescripcion") and not isdefined("Form.PRJAdescripcion")>
	<cfparam name="Form.PRJAdescripcion" default="#Url.PRJAdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.PRJAcodigo") and Len(Trim(Form.PRJAcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(PRJAcodigo) like '%" & #UCase(Form.PRJAcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRJAcodigo=" & Form.PRJAcodigo>
</cfif>
<cfif isdefined("Form.PRJAdescripcion") and Len(Trim(Form.PRJAdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(PRJAdescripcion) like '%" & #UCase(Form.PRJAdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRJAdescripcion=" & Form.PRJAdescripcion>
</cfif>
<html>
<head>
<title>Lista de Actividades</title>
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
			<input name="PRJAcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.PRJAcodigo")>#Form.PRJAcodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="PRJAdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PRJAdescripcion")>#Form.PRJAdescripcion#</cfif>" onfocus="javascript:this.select();">
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
	<cfinvokeargument name="tabla" value="PRJActividad"/>
	<cfinvokeargument name="columnas" value="PRJAid,PRJAcodigo,PRJAdescripcion"/>
	<cfinvokeargument name="desplegar" value="PRJAcodigo,PRJAdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# and PRJid=#url.proyecto# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisActividad.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PRJAid,PRJAcodigo,PRJAdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>
</body>
</html>