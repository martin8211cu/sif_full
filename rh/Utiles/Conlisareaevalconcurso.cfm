<!--- Recibe conexion, form, name, desc, id y peso --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc,id,peso) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.peso#.value = (peso);

		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>
<cfset LvarEmpresa = Session.Ecodigo>
<cfif isdefined("Url.RHEApeso") and not isdefined("Form.RHEApeso")>
	<cfparam name="Form.RHEApeso" default="#Url.RHEApeso#">
</cfif>
<cfif isdefined("Url.RHEAcodigo") and not isdefined("Form.RHEAcodigo")>
	<cfparam name="Form.RHEAcodigo" default="#Url.RHEAcodigo#">
</cfif>
<cfif isdefined("Url.RHEAdescripcion") and not isdefined("Form.RHEAdescripcion")>
	<cfparam name="Form.RHEAdescripcion" default="#Url.RHEAdescripcion#">
</cfif>
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<cfset filtro = "">
<cfset navegacion = "empresa=" & LvarEmpresa>

<cfif isdefined("Form.RHEApeso") and Len(Trim(Form.RHEApeso)) NEQ 0>
	<cfset filtro = filtro & " and RHEApeso = #Form.RHEApeso#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEApeso=" & Form.RHEApeso>
</cfif> 

<cfif isdefined("Form.RHEAcodigo") and Len(Trim(Form.RHEAcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHEAcodigo) like '%" & #UCase(Form.RHEAcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEAcodigo=" & Form.RHEAcodigo>
</cfif>
<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="Lvar_RHEAdescripcion">

<cfif isdefined("Form.RHEAdescripcion") and Len(Trim(Form.RHEAdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(#Lvar_RHEAdescripcion#) like '%" & #UCase(Form.RHEAdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEAdescripcion =" & Form.RHEAdescripcion>
</cfif>
<html>
<head>
<title><cf_translate key="LB_ListaDeAreasDeEvaluacion">Lista de &Aacute;reas de Evaluaci&oacute;n</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
		<td> 
			<input name="RHEAcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.RHEAcodigo")>#Form.RHEAcodigo#</cfif>">
		</td>
		<td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
		<td> 
			<input name="RHEAdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHEAdescripcion")>#Form.RHEAdescripcion#</cfif>">
		</td>
		<td align="center">
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Filtrar"
				Default="Filtrar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Filtrar"/>
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
		</td>
	</tr>
</table>
</form>
</cfoutput>
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
	Key="LB_Peso"
	Default="Peso"
	returnvariable="LB_Peso"/>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="RHEAreasEvaluacion"/>
	<cfinvokeargument name="columnas" value="RHEAid, RHEAcodigo, #Lvar_RHEAdescripcion# as RHEAdescripcion, RHEApeso"/>
	<cfinvokeargument name="desplegar" value="RHEAcodigo, RHEAdescripcion, RHEApeso"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #LB_Peso#"/>
	<cfinvokeargument name="formatos" value="S, S, S"/>
	<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro#"/> <!--- analizar--->
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="Conlisareaevalconcurso.cfm"/>
	<cfinvokeargument name="formName" value="form1"/> <!--- analizar--->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> <!--- analizar--->
	<cfinvokeargument name="fparams" value="RHEAcodigo, RHEAdescripcion, RHEAid, RHEApeso"/> <!--- analizar--->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>
