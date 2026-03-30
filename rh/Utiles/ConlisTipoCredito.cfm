
<!--- Recibe conexion, form, name y desc --->
<cfif isdefined("Url.form") and Len(Trim(Url.form)) and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.name") and Len(Trim(Url.name)) and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.id") and Len(Trim(Url.id)) and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.index") and not isdefined("Form.index")>
	<cfparam name="Form.index" default="#Url.index#">
</cfif>
<cfif isdefined("Url.desc") and Len(Trim(Url.desc)) and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.conexion") and Len(Trim(Url.conexion)) and not isdefined("Form.conexion")>
	<cfparam name="Form.conexion" default="#Url.conexion#">
</cfif>
<script 
language="JavaScript" type="text/javascript">
function Asignar(id,name,desc,plazo,tasa,tasamora,modif) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.form#.#Form.id#.value = id;
		window.opener.document.#Form.form#.#Form.name#.value = name;
		window.opener.document.#Form.form#.#Form.desc#.value = desc;
		
		window.opener.document.#Form.form#._plazo#Form.index#.value = plazo;		
		window.opener.document.#Form.form#._tasa#Form.index#.value = tasa;
		window.opener.document.#Form.form#._tasamora#Form.index#.value = tasamora;
		window.opener.document.#Form.form#._modificable#Form.index#.value = modif;						

		if (window.opener.func#Form.name#) {window.opener.func#Form.name#()}
		</cfoutput>
		window.close();
	};
}
</script>
<cfset LvarEmpresa = Session.Ecodigo>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.ACCTcodigo")>
	<cfparam name="Form.ACCTcodigo" default="#Url.ACCTcodigo#">
</cfif>
<cfif isdefined("Url.RHPcodigoext") and not isdefined("Form.RHPcodigoext")>
	<cfparam name="Form.RHPcodigoext" default="#Url.RHPcodigoext#">
</cfif>
<cfif isdefined("Url.RHPdescpuesto") and not isdefined("Form.RHPdescpuesto")>
	<cfparam name="Form.RHPdescpuesto" default="#Url.RHPdescpuesto#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.ACCTcodigo") and Len(Trim(Form.ACCTcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(ACCTcodigo) like '%" & #UCase(Form.ACCTcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ACCTcodigo=" & Form.ACCTcodigo>
</cfif>
<cfif isdefined("Form.ACCTdescripcion") and Len(Trim(Form.ACCTdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(ACCTdescripcion) like '%" & #UCase(Form.ACCTdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ACCTdescripcion=" & Form.ACCTdescripcion>
</cfif>

<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>
<cfif isdefined("Form.id") and Len(Trim(Form.id)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "id=" & Form.id>
</cfif>
<cfif isdefined("Form.name") and Len(Trim(Form.name)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "name=" & Form.name>
</cfif>
<cfif isdefined("Form.index") >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "index=" & Form.index>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.conexion") and Len(Trim(Form.conexion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "conexion=" & Form.conexion>
</cfif>

<html>
<head>
<title><cf_translate key="LB_ListaDePuestos">Lista de Tipos de Cr&eacute;dito</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post" action="#GetFileFromPath(GetTemplatePath())#">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<input type="hidden" name="form" value="#Form.form#">
<input type="hidden" name="id" value="#Form.id#">
<input type="hidden" name="name" value="#Form.name#">
<input type="hidden" name="index" value="#Form.index#">
<input type="hidden" name="desc" value="#Form.desc#">
<input type="hidden" name="conexion" value="#Form.conexion#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
	<tr>
		<td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
		<td> 
			<input name="ACCTcodigo" type="text" id="name" size="10" maxlength="10" tabindex="1"
				value="<cfif isdefined("Form.ACCTcodigo")>#Form.ACCTcodigo#</cfif>">
		</td>
		<td align="right"><strong><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
		<td> 
			<input name="ACCTdescripcion" type="text" id="desc" size="40" maxlength="80" tabindex="1"
				value="<cfif isdefined("Form.ACCTdescripcion")>#Form.ACCTdescripcion#</cfif>">
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

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="ACCreditosTipo"/>
	<cfinvokeargument name="columnas" value="ACCTid,ACCTcodigo, ACCTdescripcion, ACCTplazo, ACCTtasa, ACCTtasaMora, ACCTmodificable"/>
	<cfinvokeargument name="desplegar" value="ACCTcodigo, ACCTdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro# order by ACCTcodigo, ACCTdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisTipoCredito.cfm"/>
	<cfinvokeargument name="formName" value="listaCreditos"/>
	<cfinvokeargument name="MaxRows" value="25"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="ACCTid,ACCTcodigo, ACCTdescripcion, ACCTplazo, ACCTtasa, ACCTtasamora, ACCTmodificable"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#Form.conexion#"/>	
</cfinvoke>
</body>
</html>
