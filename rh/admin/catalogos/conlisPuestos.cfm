<!--- Modificado por:               --->
<!--- Rodolfo Jimenez Jara          --->
<!--- Fecha: 11/05/2005  4:30 p.m.  --->

<cfif isdefined("Url.form") and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.name") and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.nameExt") and not isdefined("Form.nameExt")>
	<cfparam name="Form.nameExt" default="#Url.nameExt#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.HYERVid") and not isdefined("Form.HYERVid")>
	<cfparam name="Form.HYERVid" default="#Url.HYERVid#">
</cfif>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>
<cfif isdefined("Url.RHPcodigoext") and not isdefined("Form.RHPcodigoext")>
	<cfparam name="Form.RHPcodigoext" default="#Url.RHPcodigoext#">
</cfif>

<cfif isdefined("Url.RHPdescpuesto") and not isdefined("Form.RHPdescpuesto")>
	<cfparam name="Form.RHPdescpuesto" default="#Url.RHPdescpuesto#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>
<cfif isdefined("Form.nameExt") and Len(Trim(Form.nameExt)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nameExt=" & Form.nameExt>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.HYERVid") and Len(Trim(Form.HYERVid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HYERVid=" & Form.HYERVid>
</cfif>

<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
</cfif>

<cfif isdefined("Form.RHPcodigoext") and Len(Trim(Form.RHPcodigoext)) NEQ 0>
	<cfset filtro = filtro & " and upper(coalesce(ltrim(rtrim(RHPcodigoext)),ltrim(rtrim(RHPcodigo)))) like '%" & #UCase(Form.RHPcodigoext)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigoext=" & Form.RHPcodigoext>
</cfif>

<cfif isdefined("Form.RHPdescpuesto") and Len(Trim(Form.RHPdescpuesto)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHPdescpuesto) like '%" & #UCase(Form.RHPdescpuesto)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescpuesto=" & Form.RHPdescpuesto>
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(name,nameExt,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.form#.#Form.name#.value = name;
		window.opener.document.#Form.form#.#Form.nameExt#.value = nameExt;
		window.opener.document.#Form.form#.#Form.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<html>
<head>
<title><cf_translate key="LB_ListaDePuestos">Lista de Puestos</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post" action="#GetFileFromPath(GetTemplatePath())#">
	<input name="HYERVid" type="hidden" size="10" maxlength="10" value="<cfif isdefined("Form.HYERVid")>#Form.HYERVid#</cfif>">
	<input name="form" type="hidden" size="10" maxlength="10" value="<cfif isdefined("Form.form")>#Form.form#</cfif>">
	<input name="name" type="hidden" size="10" maxlength="10" value="<cfif isdefined("Form.name")>#Form.name#</cfif>">
	<input name="nameExt" type="hidden" size="10" maxlength="10" value="<cfif isdefined("Form.nameExt")>#Form.nameExt#</cfif>">
	<input name="RHPcodigo" type="hidden" id="name"value="<cfif isdefined("Form.RHPcodigo")>#Form.RHPcodigo#</cfif>">
	<input name="desc" type="hidden" size="10" maxlength="10" value="<cfif isdefined("Form.desc")>#Form.desc#</cfif>">
	<!--- <table width="98%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
		<tr>
			<td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
			<td> 
				<input name="RHPcodigoext" type="text" id="nameExt" tabindex="1" size="10" maxlength="10" value="<cfif isdefined("Form.RHPcodigoext")>#Form.RHPcodigoext#</cfif>">
			</td>
			<td align="right"><strong><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
			<td> 
				<input name="RHPdescpuesto" type="text" id="desc" tabindex="1" size="40" maxlength="80" value="<cfif isdefined("Form.RHPdescpuesto")>#Form.RHPdescpuesto#</cfif>">
			</td>
			<td align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Filtrar"
					Default="Filtrar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Filtrar"/>

				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="1">
			</td>
		</tr>
	</table> --->
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
	<cfinvokeargument name="tabla" value="RHPuestos a"/>
	<cfinvokeargument name="columnas" value=" RHPcodigo, coalesce(ltrim(rtrim(a.RHPcodigoext)),ltrim(rtrim(a.RHPcodigo))) as RHPcodigoext, a.RHPdescpuesto"/>
	<cfinvokeargument name="desplegar" value="RHPcodigoext, RHPdescpuesto"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value="S,S"/>
	<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# 
											and not exists (
												select 1
												from HYDRelacionValoracion b
												where b.HYERVid = #Form.HYERVid#
												and b.RHPcodigo = a.RHPcodigo
												and b.Ecodigo = a.Ecodigo
											)
											and a.RHPactivo = 1 
										   #filtro# 
										   "/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="formName" value="listaPuesto"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHPcodigo,RHPcodigoext, RHPdescpuesto"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
	<cfinvokeargument name="filtrar_automatico" value="true"/>
	<cfinvokeargument name="mostrar_filtro" value="true"/>
</cfinvoke>
</body>
</html>
