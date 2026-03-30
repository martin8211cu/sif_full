<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.RHOcodigo") and not isdefined("Form.RHOcodigo")>
	<cfparam name="Form.RHOcodigo" default="#Url.RHOcodigo#">
</cfif>
<cfif isdefined("Url.RHOdescripcion") and not isdefined("Form.RHOdescripcion")>
	<cfparam name="Form.RHOdescripcion" default="#Url.RHOdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHOcodigo") and Len(Trim(Form.RHOcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHOcodigo) like '%" & #UCase(Form.RHOcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOcodigo=" & Form.RHOcodigo>
</cfif>
<cfif isdefined("Form.RHOdescripcion") and Len(Trim(Form.RHOdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHOdescripcion) like '%" & #UCase(Form.RHOdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOdescripcion=" & Form.RHOdescripcion>
</cfif>
<html>
<head>
<title><cf_translate  key="LB_ListaDeOcupaciones">Lista de Ocupaciones</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CODIGO"
Default="C&oacute;digo"
XmlFile="/rh/generales.xml"
returnvariable="LB_CODIGO"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DESCRIPCION"
Default="Descripci&oacute;n"
XmlFile="/rh/generales.xml"
returnvariable="LB_DESCRIPCION"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Filtrar"
Default="Filtrar"
XmlFile="/rh/generales.xml"
returnvariable="BTN_Filtrar"/>

<form name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_CODIGO#</strong></td>
		<td> 
			<input name="RHOcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.RHOcodigo")>#Form.RHOcodigo#</cfif>">
		</td>
		<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
		<td> 
			<input name="RHOdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHOdescripcion")>#Form.RHOdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHOcupaciones"/>
	<cfinvokeargument name="columnas" value="RHOcodigo, RHOdescripcion"/>
	<cfinvokeargument name="desplegar" value="RHOcodigo, RHOdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="1 = 1 #filtro# "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisOcupacion.cfm"/>
	<cfinvokeargument name="formName" value="listaOcupacion"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHOcodigo, RHOdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>