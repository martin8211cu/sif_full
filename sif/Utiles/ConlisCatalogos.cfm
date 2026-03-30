<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(id,codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.name#.value = id;
			window.opener.document.#Url.form#.#Url.codigo#.value = codigo;
			window.opener.document.#Url.form#.#Url.desc#.value = desc;
		</cfoutput>
		
		<cfif len(trim(url.funcion)) gt 0> 
			//window.opener.<cfoutput>#url.funcion#</cfoutput>;
			eval('window.opener.<cfoutput>#url.funcion#</cfoutput>('+id+')');
		</cfif>	
		window.opener.document.<cfoutput>#Url.form#.#Url.codigo#</cfoutput>.focus();
		window.close();
	}
}
</script>

<cfif isdefined("Url.PCEdescripcion") and not isdefined("Form.PCEdescripcion")>
	<cfparam name="Form.PCEdescripcion" default="#Url.PCEdescripcion#">
</cfif>

<cfif isdefined("Url.PCEcodigo") and not isdefined("Form.PCEcodigo")>
	<cfparam name="Form.PCEcodigo" default="#Url.PCEcodigo#">
</cfif>

<cfset filtro = "">

<cfif isdefined("form.PCEdescripcion") and Len(Trim(form.PCEdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(PCEdescripcion) like '%" & #UCase(form.PCEdescripcion)# & "%'">
</cfif>
<cfif isdefined("form.PCEcodigo") and Len(Trim(form.PCEcodigo)) NEQ 0>
 	<cfset filtro = filtro & " and upper(PCEcodigo) like '%" & #UCase(form.PCEcodigo)# & "%'">
</cfif>

<cfif ( isdefined("url.llave") and len(trim(url.llave)) gt 0 ) and not isdefined("form.llave")>
	<cfset filtro = filtro & " and PCEref = 1 and not PCEcatid = #url.llave#">
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Codigo" returnvariable="LB_Codigo" default = "C&oacute;digo">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" returnvariable="LB_Descripcion" default = "Descripci&oacute;n">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LstCat" returnvariable="LB_LstCat" default = "Lista de Cat&aacute;logos">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Filtrar" returnvariable="BTN_Filtrar" default = "Filtrar" xmlfile="/sif/generales.xml">

<html>
<head>
<title><cfoutput>#LB_LstCat#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

</head>
<body>
<cfoutput>
<form name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right" width="1%"><strong>#LB_Codigo#</strong></td>
		<td> 
			<input name="PCEcodigo" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PCEcodigo")>#Form.PCEcodigo#</cfif>">
		</td>
		<td align="right" width="1%"><strong>#LB_Descripcion#</strong></td>
		<td> 
			<input name="PCEdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.PCEdescripcion")>#Form.PCEdescripcion#</cfif>">
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
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="PCECatalogo"/>
	<cfinvokeargument name="columnas" value="PCEcatid, PCEcodigo, PCEdescripcion"/>
	<cfinvokeargument name="desplegar" value="PCEcodigo, PCEdescripcion"/>
	<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# and PCEactivo=1 #filtro#"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisCatalogos.cfm"/>
	<cfinvokeargument name="formName" value="listaCatalogos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="PCEcatid,PCEcodigo,PCEdescripcion"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>