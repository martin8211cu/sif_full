<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.IDArt") and not isdefined("Form.IDArt")>
	<cfparam name="Form.IDArt" default="#Url.IDArt#">
</cfif>
<cfif isdefined("Url.codigoArticulo") and not isdefined("Form.codigoArticulo")>
	<cfparam name="Form.codigoArticulo" default="#Url.codigoArticulo#">
</cfif>
<cfif isdefined("Url.NombreArticulo") and not isdefined("Form.NombreArticulo")>
	<cfparam name="Form.NombreArticulo" default="#Url.NombreArticulo#">
</cfif>
<cfif isdefined("Url.CodigoArt") and not isdefined("Form.CodigoArt")>
	<cfparam name="Form.CodigoArt" default="#Url.CodigoArt#">
</cfif>
<cfparam name="url.Ecodigo" default="#session.Ecodigo#">
<cfif isdefined("url.Ecodigo") and len(trim("url.Ecodigo"))>
	<cfset form.Ecodigo = url.Ecodigo>
</cfif>

<cfparam name="url.Empresas" default="#session.Ecodigo#">
<cfif isdefined("url.Empresas") and len(trim("url.Empresas"))>
	<cfset form.Empresas = url.Empresas>
</cfif>

<!--- Filtros --->
<cfif isdefined("url.NombreArt") and not isdefined("form.NombreArt")>
	<cfset form.NombreArt = url.NombreArt >
</cfif>
<cfif isdefined("url.CodigoArt") and not isdefined("form.CodigoArt")>
	<cfset form.CodigoArt = url.CodigoArt >
</cfif>

<cfoutput>
<script language="JavaScript" type="text/javascript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function Asignar(ArtID,ArtCodigo,ArtNombre) {
		if (window.opener != null) {
			window.opener.document.#form.formulario#.#form.IDArt#.value = ArtID;
			window.opener.document.#form.formulario#.#form.codigoArticulo#.value = ArtCodigo;
			<!---window.opener.document.#form.formulario#.codigoArticulo2.value = ArtID;--->
			window.opener.document.#form.formulario#.#form.NombreArticulo#.value = trim(ArtNombre);
			
			if (window.opener.func#form.IDArt#) {
				window.opener.func#form.IDArt#();
			}
			window.close();
		}
	}
</script>
</cfoutput>

<!--- Filtro --->
<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#&IDArt=#form.IDArt#&codigoArticulo=#form.codigoArticulo#&NombreArticulo=#form.NombreArticulo#&Ecodigo=#form.Ecodigo#">
<cfif isdefined("Form.NombreArt") and Len(Trim(Form.NombreArt)) neq 0>
 	<cfset filtro = filtro & " and upper(Adescripcion) like '%" & ucase(Form.NombreArt) & "%'">
	<cfset navegacion = navegacion & "&Adescripcion=" & Form.NombreArt>
</cfif>
<cfif isdefined("Form.CodigoArt") and Len(Trim(Form.CodigoArt)) neq 0>
 	<cfset filtro = filtro & " and upper(Acodigo) like '%" & ucase(Form.CodigoArt) & "%'">
	<cfset navegacion = navegacion & "&codigoArticulo=" & Form.CodigoArt>
</cfif>

<html>
<head>
<title>Lista de Compradores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroArticulos" method="post" action="ConlisArticulosConsulta.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td width="1%" align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="CodigoArt" type="text" id="CodigoArt" size="25" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.CodigoArt")>#Form.CodigoArt#</cfif>">
				</td>
				<td width="1%" align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="NombreArt" type="text" id="NombreArt" size="25" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.NombreArt")>#Form.NombreArt#</cfif>">
				</td>

				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.IDArt") and len(trim(form.IDArt))>
						<input type="hidden" name="IDArt" value="#form.IDArt#">
					</cfif>
					<cfif isdefined("form.codigoArticulo") and len(trim(form.codigoArticulo))>
						<input type="hidden" name="codigoArticulo" value="#form.codigoArticulo#">
					</cfif>
					<cfif isdefined("form.NombreArticulo") and len(trim(form.NombreArticulo))>
						<input type="hidden" name="NombreArticulo" value="#form.NombreArticulo#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfset select = " a.Aid, rtrim(a.Acodigo) as Acodigo, a.Adescripcion " >
		<cfset from = " Articulos a " >
		<cfset where = " a.Ecodigo in(#form.Empresas#) " >
		<cfset where = where & filtro & " order by a.Acodigo, a.Adescripcion">

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="#from#"/>
			<cfinvokeargument name="columnas" value="#select#"/>
			<cfinvokeargument name="desplegar" value="Acodigo,Adescripcion"/>
			<cfinvokeargument name="etiquetas" value="Código,Art&iacute;culo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="#where#"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisArticulosConsulta.cfm"/>
			<cfinvokeargument name="formName" value="listaArticulos"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Aid,Acodigo,Adescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>