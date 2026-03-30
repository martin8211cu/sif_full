<!--- Recibe conexion, form, id y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(id,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.TDdescripcion") and not isdefined("Form.TDdescripcion")>
	<cfparam name="Form.TDdescripcion" default="#Url.TDdescripcion#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.TDdescripcion") and Len(Trim(Form.TDdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(TDdescripcion) like '%" & #UCase(Form.TDdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDdescripcion=" & Form.TDdescripcion>
</cfif>
<html>
<head>
<title>Lista de Tipos de Deducciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>


		
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

<cfoutput>
<form name="filtro" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>#LB_DESCRIPCION#</strong></td>
		<td> 
			<input name="TDdescripcion" type="text" id="desc" size="40" maxlength="60" value="<cfif isdefined("Form.TDdescripcion")>#Form.TDdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="TDeduccion"/>
	<cfinvokeargument name="columnas" value="TDid, TDdescripcion"/>
	<cfinvokeargument name="desplegar" value="TDdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_DESCRIPCION#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# "/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisTipoDeduccion.cfm"/>
	<cfinvokeargument name="formName" value="listaTipoDeduccion"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="TDid, TDdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
</cfinvoke>
</body>
</html>