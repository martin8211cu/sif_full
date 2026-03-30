<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.excluir") and not isdefined("Form.excluir")>
	<cfparam name="Form.excluir" default="#Url.excluir#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.TraeAlmacen<cfoutput>#form.codigo#</cfoutput>(codigo);
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.Almcodigo") and not isdefined("Form.Almcodigo")>
	<cfparam name="Form.Almcodigo" default="#Url.Almcodigo#">
</cfif>
<cfif isdefined("Url.Bdescripcion") and not isdefined("Form.Bdescripcion")>
	<cfparam name="Form.Bdescripcion" default="#Url.Bdescripcion#">
</cfif>

<cfset filtro = "">

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&excluir=#form.excluir#" >
<cfif isdefined("Form.Almcodigo") and Len(Trim(Form.Almcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(Almcodigo) like '%" & UCase(Form.Almcodigo) & "%'">
	<cfset navegacion = navegacion & "&Almcodigo=" & Form.Almcodigo>
</cfif>
<cfif isdefined("Form.Bdescripcion") and Len(Trim(Form.Bdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Bdescripcion) like '%" & UCase(Form.Bdescripcion) & "%'">
	<cfset navegacion = navegacion & "&Bdescripcion=" & Form.Bdescripcion>
</cfif>

<html>
<head>
<title>Lista de Almac&eacute;nes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtro" method="post" action="ConlisAlmacen.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="Almcodigo" type="text" id="Almcodigo" size="10" maxlength="10" onFocus="this.select();" value="<cfif isdefined("Form.Almcodigo")>#Form.Almcodigo#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="Bdescripcion" type="text" id="Bdescripcion" size="40" maxlength="80"  onFocus="this.select();" value="<cfif isdefined("Form.Bdescripcion")>#Form.Bdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="document.filtro.Almcodigo.value=''; document.filtro.Bdescripcion.value='';" >
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.codigo") and len(trim(form.codigo))>
						<input type="hidden" name="codigo" value="#form.codigo#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
					<input type="hidden" name="excluir" value="#form.excluir#">
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="conlis" datasource="#session.DSN#">
			select Aid, Almcodigo, Bdescripcion
			from Almacen
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

			<cfif isdefined("Form.Almcodigo") and Len(Trim(Form.Almcodigo)) >
				and upper(Almcodigo) like '%#trim(ucase(form.Almcodigo))#%'
			</cfif>
			<cfif isdefined("Form.Bdescripcion") and Len(Trim(Form.Bdescripcion))>
				and upper(Bdescripcion) like '%#trim(ucase(form.Bdescripcion))#%'
			</cfif>
			
			<cfif isdefined("form.excluir") and len(trim(form.excluir))>
				and Aid not in (#form.Excluir#)
			</cfif>
			order by Almcodigo
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfinvokeargument name="desplegar" value="Almcodigo,Bdescripcion"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisAlmacen.cfm"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Aid,Almcodigo,Bdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>