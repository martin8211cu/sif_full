<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.RHPEcodigo") and not isdefined("Form.RHPEcodigo")>
	<cfparam name="Form.RHPEcodigo" default="#Url.RHPEcodigo#">
</cfif>
<cfif isdefined("Url.RHPEdescripcion") and not isdefined("Form.RHPEdescripcion")>
	<cfparam name="Form.RHPEdescripcion" default="#Url.RHPEdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.RHPEcodigo") and Len(Trim(Form.RHPEcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHPEcodigo) like '%" & #UCase(Form.RHPEcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPEcodigo=" & Form.RHPEcodigo>
</cfif>
<cfif isdefined("Form.RHPEdescripcion") and Len(Trim(Form.RHPEdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHPEdescripcion) like '%" & #UCase(Form.RHPEdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPEdescripcion=" & Form.RHPEdescripcion>
</cfif>
<html>
<head>
<title><cf_translate  key="LB_ListaDePuestosExternos">Lista de Puestos Externos</cf_translate></title>
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
			<input name="RHPEcodigo" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.RHPEcodigo")>#Form.RHPEcodigo#</cfif>">
		</td>
		<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
		<td> 
			<input name="RHPEdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.RHPEdescripcion")>#Form.RHPEdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHPuestosExternos"/>
	<cfinvokeargument name="columnas" value="RHPEid, rtrim(RHPEcodigo) as RHPEcodigo, RHPEdescripcion"/>
	<cfinvokeargument name="desplegar" value="RHPEcodigo, RHPEdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="1 = 1 #filtro# order by RHPEcodigo"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisPuestoExterno.cfm"/>
	<cfinvokeargument name="formName" value="listaPuestoExterno"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHPEid, RHPEcodigo, RHPEdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>