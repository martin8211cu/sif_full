<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDePruebas"
	Default="Lista de Pruebas"
	returnvariable="LB_ListaDePruebas"/>

<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>
<cfset LvarEmpresa = Session.Ecodigo>

<cfif isdefined("Url.RHPcodigopr") and not isdefined("Form.RHPcodigopr")>
	<cfparam name="Form.RHPcodigopr" default="#Url.RHPcodigopr#">
</cfif>
<cfif isdefined("Url.RHPdescripcionpr") and not isdefined("Form.RHPdescripcionpr")>
	<cfparam name="Form.RHPdescripcionpr" default="#Url.RHPdescripcionpr#">
</cfif>
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<cfset filtro = "">
<cfset navegacion = "empresa=" & LvarEmpresa>
<cfif isdefined("Form.RHPcodigopr") and Len(Trim(Form.RHPcodigopr)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHPcodigopr) like '%" & #UCase(Form.RHPcodigopr)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigopr=" & Form.RHPcodigopr>
</cfif>
<cfif isdefined("Form.RHPdescripcionpr") and Len(Trim(Form.RHPdescripcionpr)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHPdescripcionpr) like '%" & #UCase(Form.RHPdescripcionpr)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescripcionpr =" & Form.RHPdescripcionpr>
</cfif>
<html>
<head>
<title><cfoutput>#LB_ListaDePruebas#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_Codigo#</strong></td>
		<td> 
			<input name="RHPcodigopr" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.RHPcodigopr")>#Form.RHPcodigopr#</cfif>">
		</td>
		<td align="right"><strong>#LB_Descripcion#</strong></td>
		<td> 
			<input name="RHPdescripcionpr" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHPdescripcionpr")>#Form.RHPdescripcionpr#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="RHPruebas"/>
	<cfinvokeargument name="columnas" value="RHPcodigopr, RHPdescripcionpr"/>
	<cfinvokeargument name="desplegar" value="RHPcodigopr, RHPdescripcionpr"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro#"/> <!--- analizar--->
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="Conlispruebas.cfm"/>
	<cfinvokeargument name="formName" value="form"/> <!--- analizar--->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> <!--- analizar--->
	<cfinvokeargument name="fparams" value="RHPcodigopr, RHPdescripcionpr"/> <!--- analizar--->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>
