<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Asignar(key, name,desc) {
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#Url.form#.#Url.keyClas#.value = key;
			window.opener.document.#Url.form#.#Url.nameClas#.value = name;		
			window.opener.document.#Url.form#.#Url.descClas#.value = desc;
			if (window.opener.func#Url.keyClas#) window.opener.func#Url.keyClas#(window.opener.document.#Url.form#.#Url.keyClas#);
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.catACcodigodesc_filtro") and not isdefined("Form.catACcodigodesc_filtro")>
	<cfparam name="Form.catACcodigodesc_filtro" default="#Url.catACcodigodesc_filtro#">
</cfif>
<cfif isdefined("Url.catACdescripcion_filtro") and not isdefined("Form.catACdescripcion_filtro")>
	<cfparam name="Form.catACdescripcion_filtro" default="#Url.catACdescripcion_filtro#">
</cfif>


<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.catACcodigodesc_filtro") and Len(Trim(Form.catACcodigodesc_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(ACcodigodesc) like '%" & #UCase(Form.catACcodigodesc_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "catACcodigodesc_filtro=" & Form.catACcodigodesc_filtro>
</cfif>
<cfif isdefined("Form.catACdescripcion_filtro") and Len(Trim(Form.catACdescripcion_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(ACdescripcion) like '%" & #UCase(Form.catACdescripcion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "catACdescripcion_filtro=" & Form.catACdescripcion_filtro>
</cfif>
<html>
<head>
<title>Lista de Clases</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloAlterno">
	  <tr>
		<td><font size="3"><strong>Lista de Clases</strong></font></td>
	  </tr>
	  <tr>
		<td><font size="3"><strong>#Url.descCat#</strong></font></td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>	  
	</table>

<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">	
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="catACcodigodesc_filtro" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.catACcodigodesc_filtro")>#Form.catACcodigodesc_filtro#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="catACdescripcion_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.catACdescripcion_filtro")>#Form.catACdescripcion_filtro#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaModelos">
	<cfinvokeargument name="tabla" value="AClasificacion"/>
	<cfinvokeargument name="columnas" value="ACid, ACcodigodesc, ACdescripcion"/>
	<cfinvokeargument name="desplegar" value="ACcodigodesc, ACdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#Session.Ecodigo#
		and ACcodigo=#url.KeyCat#
				#filtro# 
			order by ACdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisClase.cfm"/>
	<cfinvokeargument name="formName" value="listaModelos"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="ACid, ACcodigodesc, ACdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>