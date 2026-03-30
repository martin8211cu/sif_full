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
<cfif isdefined("Url.f_EPDnumero") and not isdefined("Form.f_EPDnumero")>
	<cfparam name="Form.f_EPDnumero" default="#Url.f_EPDnumero#">
</cfif>
<cfif isdefined("Url.f_EPDdescripcion") and not isdefined("Form.f_EPDdescripcion")>
	<cfparam name="Form.f_EPDdescripcion" default="#Url.f_EPDdescripcion#">
</cfif>

<html>
<head>
<title>Lista de P&oacute;lizas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtro" method="post" action="ConlisPoliza.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="f_EPDnumero" type="text" id="f_EPDnumero" size="10" maxlength="10" onFocus="this.select();" value="<cfif isdefined("Form.f_EPDnumero")>#Form.f_EPDnumero#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="f_EPDdescripcion" type="text" id="f_EPDdescripcion" size="40" maxlength="80"  onFocus="this.select();" value="<cfif isdefined("Form.f_EPDdescripcion")>#Form.f_EPDdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="document.filtro.f_EPDnumero.value=''; document.filtro.f_EPDdescripcion.value='';" >
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
		<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&excluir=#form.excluir#" >	
		<cfquery name="conlis" datasource="#session.DSN#">
			Select EPDid, EPDnumero, EPDdescripcion
			from EPolizaDesalmacenaje
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
			<cfif isdefined("Form.f_EPDnumero") and Len(Trim(Form.f_EPDnumero)) >
				and upper(EPDnumero) like '%#trim(ucase(form.f_EPDnumero))#%'
				<cfset navegacion = navegacion & "&f_EPDnumero=" & Form.f_EPDnumero>
			</cfif>
			<cfif isdefined("Form.f_EPDdescripcion") and Len(Trim(Form.f_EPDdescripcion)) >
				and upper(EPDdescripcion) like '%#trim(ucase(form.f_EPDdescripcion))#%'
				<cfset navegacion = navegacion & "&f_EPDdescripcion=" & Form.f_EPDdescripcion>
			</cfif>
			
			<cfif isdefined("form.excluir") and len(trim(form.excluir))>
				and EPDid not in (#form.Excluir#)
			</cfif>
			order by EPDdescripcion
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfinvokeargument name="desplegar" value="EPDnumero, EPDdescripcion"/>
			<cfinvokeargument name="etiquetas" value="N&uacute;mero, Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisPoliza.cfm"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="EPDid, EPDnumero, EPDdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>