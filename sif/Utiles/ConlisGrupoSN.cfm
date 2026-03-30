<!--- Recibe conexion, form, name, desc, id y peso --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_GrupoSociosNegocios" default = "Grupo de Socios de Negocios" returnvariable="LB_GrupoSociosNegocios" xmlfile = "ConlisGrupoSN.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" default = "C&oacute;digo" returnvariable="LB_Codigo" xmlfile = "ConlisGrupoSN.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "ConlisGrupoSN.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" default = "Filtrar" returnvariable="BTN_Filtrar" xmlfile = "ConlisGrupoSN.xml">

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc,id) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.#Url.id#.value = id;

		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>
<cfset LvarEmpresa = Session.Ecodigo>

<cfif isdefined("Url.GSNcodigo") and not isdefined("Form.GSNcodigo")>
	<cfparam name="Form.GSNcodigo" default="#Url.GSNcodigo#">
</cfif>
<cfif isdefined("Url.GSNdescripcion") and not isdefined("Form.GSNdescripcion")>
	<cfparam name="Form.GSNdescripcion" default="#Url.GSNdescripcion#">
</cfif>
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<cfset filtro = "">
<cfset navegacion = "empresa=" & LvarEmpresa>


<cfif isdefined("Form.GSNcodigo") and Len(Trim(Form.GSNcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(GSNcodigo) like '%" & #UCase(trim(Form.GSNcodigo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GSNcodigo=" & Form.GSNcodigo>
</cfif>
<cfif isdefined("Form.GSNdescripcion") and Len(Trim(Form.GSNdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(GSNdescripcion) like '%" & #UCase(trim(Form.GSNdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "GSNdescripcion =" & Form.GSNdescripcion>
</cfif>
<html>
<head>
<title><cfoutput>#LB_GrupoSociosNegocios#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroGrupoSN" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_Codigo#</strong></td>
		<td> 
			<input name="GSNcodigo" type="text" id="name" size="6" maxlength="4" value="<cfif isdefined("Form.GSNcodigo")>#Form.GSNcodigo#</cfif>">
		</td>
		<td align="right"><strong>#LB_Descripcion#</strong></td>
		<td> 
			<input name="GSNdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.GSNdescripcion")>#Form.GSNdescripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="GrupoSNegocios"/>
	<cfinvokeargument name="columnas" value="GSNid, GSNcodigo, GSNdescripcion"/>
	<cfinvokeargument name="desplegar" value="GSNcodigo, GSNdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value="S, S"/>
	<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro#"/> <!--- analizar--->
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisGrupoSN.cfm"/>
	<cfinvokeargument name="formName" value="form1"/> <!--- analizar--->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> <!--- analizar--->
	<cfinvokeargument name="fparams" value="GSNcodigo, GSNdescripcion, GSNid"/> <!--- analizar--->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>
