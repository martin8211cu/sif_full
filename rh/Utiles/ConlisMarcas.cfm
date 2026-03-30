<!--- Recibe conexion, form, name y desc --->

<script language="JavaScript" type="text/javascript">
function Asignar(key, name,desc) {
	if (window.opener != null) {
		<cfoutput>
			var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
					
			window.opener.document.#Url.form#.#Url.key#.value = key;
			window.opener.document.#Url.form#.#Url.name#.value = name;		
			window.opener.document.#Url.form#.#Url.desc#.value = desc;
			if(descAnt != window.opener.document.#Url.form#.#Url.desc#.value){
				window.opener.document.#Url.form#.#Url.keyMod#.value = '';
				window.opener.document.#Url.form#.#Url.nameMod#.value = '';		
				window.opener.document.#Url.form#.#Url.descMod#.value = '';			
			}			
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.AFMcodigo_filtro") and not isdefined("Form.AFMcodigo_filtro")>
	<cfparam name="Form.AFMcodigo_filtro" default="#Url.AFMcodigo_filtro#">
</cfif>
<cfif isdefined("Url.AFMdescripcion_filtro") and not isdefined("Form.AFMdescripcion_filtro")>
	<cfparam name="Form.AFMdescripcion_filtro" default="#Url.AFMdescripcion_filtro#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.AFMcodigo_filtro") and Len(Trim(Form.AFMcodigo_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(AFMcodigo) like '%" & #UCase(Form.AFMcodigo_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AFMcodigo_filtro=" & Form.AFMcodigo_filtro>
</cfif>
<cfif isdefined("Form.AFMdescripcion_filtro") and Len(Trim(Form.AFMdescripcion_filtro)) NEQ 0>
 	<cfset filtro = filtro & " and upper(AFMdescripcion) like '%" & #UCase(Form.AFMdescripcion_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "AFMdescripcion_filtro=" & Form.AFMdescripcion_filtro>
</cfif>
<html>
<head>
<title>Lista de Marcas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroMarcas" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="AFMcodigo_filtro" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.AFMcodigo_filtro")>#Form.AFMcodigo_filtro#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="AFMdescripcion_filtro" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.AFMdescripcion_filtro")>#Form.AFMdescripcion_filtro#</cfif>">
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
 returnvariable="pListaMarcasMod">
	<cfinvokeargument name="tabla" value="AFMarcas"/>
	<cfinvokeargument name="columnas" value="AFMid,AFMcodigo,AFMdescripcion"/>
	<cfinvokeargument name="desplegar" value="AFMcodigo, AFMdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="Ecodigo=#Session.Ecodigo#
				#filtro# 
			order by AFMdescripcion"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisMarcas.cfm"/>
	<cfinvokeargument name="formName" value="listaMarcas"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="AFMid, AFMcodigo, AFMdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
</cfinvoke>
</body>
</html>