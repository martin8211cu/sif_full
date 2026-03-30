<!--- Recibe conexion, form, name y desc --->
<cfif isdefined("Url.form") and Len(Trim(Url.form)) and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.name") and Len(Trim(Url.name)) and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.desc") and Len(Trim(Url.desc)) and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.id") and Len(Trim(Url.id)) and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.conexion") and Len(Trim(Url.conexion)) and not isdefined("Form.conexion")>
	<cfparam name="Form.conexion" default="#Url.conexion#">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(id,name,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.form#.#Form.id#.value=id;
		window.opener.document.#Form.form#.#Form.name#.value = name;
		window.opener.document.#Form.form#.#Form.desc#.value = desc;	
		if (window.opener.func#Form.name#) {window.opener.func#Form.name#()}
		</cfoutput>
		window.close();
	};
}
</script>

<cfset LvarEmpresa = Session.Ecodigo>

<!---<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>

<cfif isdefined("Url.RHPdescripcion") and not isdefined("Form.RHPdescripcion")>
	<cfparam name="Form.RHPdescripcion" default="#Url.RHPdescripcion#">
</cfif>
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<cfset filtro = "">
<cfset navegacion = "empresa=" & LvarEmpresa>
<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(coalesce(RHPcodigoext,RHPcodigo)) like '%" & #UCase(Form.RHPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigoext=" & Form.RHPcodigo>
</cfif>
<cfif isdefined("Form.RHPdescpuesto") and Len(Trim(Form.RHPdescpuesto)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHPdescpuesto) like '%" & #UCase(Form.RHPdescpuesto)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescpuesto=" & Form.RHPdescpuesto>
</cfif>--->
<cfset navegacion = "empresa=" & LvarEmpresa>

<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>
<cfif isdefined("Form.name") and Len(Trim(Form.name)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "name=" & Form.name>
</cfif>
<cfif isdefined("Form.id") and Len(Trim(Form.id)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "id=" & Form.id>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.conexion") and Len(Trim(Form.conexion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "conexion=" & Form.conexion>
</cfif>


<html>
<head>
<title><cf_translate key="LB_ListaDePuestos">Lista de Puestos</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post" action="#GetFileFromPath(GetTemplatePath())#">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<input type="hidden" name="form" value="#Form.form#">
<input type="hidden" name="name" value="#Form.name#">
<input type="hidden" name="id" value="#Form.name#">
<input type="hidden" name="desc" value="#Form.desc#">
<input type="hidden" name="conexion" value="#Form.conexion#">

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
	<tr>
		<td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
		<td> 
			<input name="RHTPid" type="hidden" id="id" size="10" maxlength="10" tabindex="1"
				value="<cfif isdefined("Form.RHTPid")>#Form.RHTPid#</cfif>">
				
			<input name="RHTPcodigo" type="text" id="name" size="10" maxlength="10" tabindex="1"
				value="<cfif isdefined("Form.RHTPcodigo")>#Form.RHTPcodigo#</cfif>">
		</td>
		<td align="right"><strong><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
		<td> 
			<input name="RHTPdescripcion" type="text" id="desc" size="40" maxlength="80" tabindex="1"
				value="<cfif isdefined("Form.RHTPdescripcion")>#Form.RHTPdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="RHTPuestos"/>
	<cfinvokeargument name="columnas" value="RHTPid,RHTPcodigo, RHTPdescripcion"/>
	<cfinvokeargument name="desplegar" value="RHTPcodigo, RHTPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisTPuesto.cfm"/>
	<cfinvokeargument name="formName" value="listaPuesto"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHTPid,RHTPcodigo,RHTPdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#Form.conexion#"/>	
</cfinvoke>
</body>
</html>
