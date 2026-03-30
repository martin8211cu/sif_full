<!--- Recibe conexion, form, name, desc, id y cobrador --->

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

<cfif isdefined("Url.ZCSNcodigo") and not isdefined("Form.ZCSNcodigo")>
	<cfparam name="Form.ZCSNcodigo" default="#Url.ZCSNcodigo#">
</cfif>
<cfif isdefined("Url.ZCSNdescripcion") and not isdefined("Form.ZCSNdescripcion")>
	<cfparam name="Form.ZCSNdescripcion" default="#Url.ZCSNdescripcion#">
</cfif>
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<cfset filtro = "">
<cfset navegacion = "empresa=" & LvarEmpresa>

<cfif isdefined("Form.ZCSNcodigo") and Len(Trim(Form.ZCSNcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(ZCSNcodigo) like '%" & #UCase(trim(Form.ZCSNcodigo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ZCSNcodigo=" & Form.ZCSNcodigo>
</cfif>
<cfif isdefined("Form.ZCSNdescripcion") and Len(Trim(Form.ZCSNdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(ZCSNdescripcion) like '%" & #UCase(trim(Form.ZCSNdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ZCSNdescripcion =" & Form.ZCSNdescripcion>
</cfif>
<html>
<head>
<title>Lista Zona de Cobros de Socios de Negocios</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroEmpleado2" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="ZCSNcodigo" type="text" id="name" size="6" maxlength="4" value="<cfif isdefined("Form.ZCSNcodigo")>#Form.ZCSNcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="ZCSNdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.ZCSNdescripcion")>#Form.ZCSNdescripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="ZonaCobroSNegocios"/>
	<cfinvokeargument name="columnas" value="ZCSNid, ZCSNcodigo, ZCSNdescripcion"/>
	<cfinvokeargument name="desplegar" value="ZCSNcodigo, ZCSNdescripcion"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value="S, S"/>
	<cfinvokeargument name="filtro" value="Ecodigo = #LvarEmpresa# #filtro#"/> <!--- analizar--->
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ConlisZonaCobro.cfm"/>
	<cfinvokeargument name="formName" value="form1"/> <!--- analizar--->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> <!--- analizar--->
	<cfinvokeargument name="fparams" value="ZCSNcodigo, ZCSNdescripcion, ZCSNid"/> <!--- analizar--->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>
