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
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = trim(desc);
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.Codigo_pista") and not isdefined("Form.Codigo_pista")>
	<cfparam name="Form.Codigo_pista" default="#Url.Codigo_pista#">
</cfif>
<cfif isdefined("Url.Descripcion_pista") and not isdefined("Form.Descripcion_pista")>
	<cfparam name="Form.Descripcion_pista" default="#Url.Descripcion_pista#">
</cfif>

<cfset filtro = "">

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&excluir=#form.excluir#" >
<cfif isdefined("Form.Codigo_pista") and Len(Trim(Form.Codigo_pista)) NEQ 0>
	<cfset filtro = filtro & " and upper(Codigo_pista) like '%" & UCase(Form.Codigo_pista) & "%'">
	<cfset navegacion = navegacion & "&Codigo_pista=" & Form.Codigo_pista>
</cfif>
<cfif isdefined("Form.Descripcion_pista") and Len(Trim(Form.Descripcion_pista)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Descripcion_pista) like '%" & UCase(Form.Descripcion_pista) & "%'">
	<cfset navegacion = navegacion & "&Descripcion_pista=" & Form.Descripcion_pista>
</cfif>

<html>
<head>
<title>Lista de Pistas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtro" method="post" action="ConlisPistas.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="Codigo_pista" type="text" id="Codigo_pista" size="10" maxlength="10" onFocus="this.select();" value="<cfif isdefined("Form.Codigo_pista")>#Form.Codigo_pista#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="Descripcion_pista" type="text" id="Descripcion_pista" size="40" maxlength="80"  onFocus="this.select();" value="<cfif isdefined("Form.Descripcion_pista")>#Form.Descripcion_pista#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="document.filtro.Codigo_pista.value=''; document.filtro.Descripcion_pista.value='';" >
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
			select Pista_id, Codigo_pista, Descripcion_pista
			from Pistas
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

			<cfif isdefined("Form.Codigo_pista") and Len(Trim(Form.Codigo_pista)) >
				and upper(Codigo_pista) like '%#trim(ucase(form.Codigo_pista))#%'
			</cfif>
			<cfif isdefined("Form.Descripcion_pista") and Len(Trim(Form.Descripcion_pista))>
				and upper(Descripcion_pista) like '%#trim(ucase(form.Descripcion_pista))#%'
			</cfif>
			
			<cfif isdefined("form.excluir") and len(trim(form.excluir))>
				and Pista_id not in (#form.Excluir#)
			</cfif>
			order by Codigo_pista
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfinvokeargument name="desplegar" value="Codigo_pista,Descripcion_pista"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisPistas.cfm"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Pista_id,Codigo_pista,Descripcion_pista"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>