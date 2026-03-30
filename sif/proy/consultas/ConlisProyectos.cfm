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

<cfif isdefined("Url.PRJcodigo") and not isdefined("Form.PRJcodigo")>
	<cfparam name="Form.PRJcodigo" default="#Url.PRJcodigo#">
</cfif>
<cfif isdefined("Url.PRJdescripcion") and not isdefined("Form.PRJdescripcion")>
	<cfparam name="Form.PRJdescripcion" default="#Url.PRJdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.PRJcodigo") and Len(Trim(Form.PRJcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(PRJcodigo) like '%" & #UCase(Form.PRJcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRJcodigo=" & Form.PRJcodigo>
</cfif>
<cfif isdefined("Form.PRJdescripcion") and Len(Trim(Form.PRJdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(PRJdescripcion) like '%" & #UCase(Form.PRJdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "PRJdescripcion=" & Form.PRJdescripcion>
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
			<input name="PRJcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.PRJcodigo")>#Form.PRJcodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="PRJdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PRJdescripcion")>#Form.PRJdescripcion#</cfif>" onfocus="javascript:this.select();">
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
	<cfinvokeargument name="tabla" value="PRJproyecto"/>
	<cfinvokeargument name="columnas" value="PRJid,PRJcodigo,PRJdescripcion"/>
	<cfinvokeargument name="desplegar" value="PRJcodigo,PRJdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisProyectos.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PRJid,PRJcodigo,PRJdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>
</body>
</html>