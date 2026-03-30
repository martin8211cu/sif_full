<!---  
	Creado por: Gabriel E. Sanchez Huerta.
	Fecha: 14 de Julio del 2010.
	Motivo: Seleccionar los Departamentos.
--->

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
		window.opener.document.#form.formulario#.#form.codigo#.focus();
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.Deptocodigo_f") and not isdefined("Form.Deptocodigo_f")>
	<cfparam name="Form.Deptocodigo_f" default="#Url.Deptocodigo_f#">
</cfif>
<cfif isdefined("Url.Ddescripcion_f") and not isdefined("Form.Ddescripcion_f")>
	<cfparam name="Form.Ddescripcion_f" default="#Url.Ddescripcion_f#">
</cfif>

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&excluir=#form.excluir#" >
<cfif isdefined("Form.Deptocodigo_f") and Len(Trim(Form.Deptocodigo_f)) NEQ 0>
	<cfset navegacion = navegacion & "&Deptocodigo_f=" & Form.Deptocodigo_f>
</cfif>
<cfif isdefined("Form.Ddescripcion_f") and Len(Trim(Form.Ddescripcion_f)) NEQ 0>
	<cfset navegacion = navegacion & "&Ddescripcion_f=" & Form.Ddescripcion_f>
</cfif>

<html>
<head>
<title>Lista de Departamentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtro" method="post" action="ConlisDepartamentos.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="Deptocodigo_f" type="text" id="Deptocodigo_f" size="10" maxlength="10" onFocus="this.select();" value="<cfif isdefined("Form.Deptocodigo_f")>#Form.Deptocodigo_f#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="Ddescripcion_f" type="text" id="Ddescripcion_f" size="40" maxlength="80"  onFocus="this.select();" value="<cfif isdefined("Form.Ddescripcion_f")>#Form.Ddescripcion_f#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="document.filtro.Deptocodigo_f.value=''; document.filtro.Ddescripcion_f.value='';" >
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
			Select Dcodigo, Deptocodigo, Ddescripcion
			from Departamentos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("Form.Deptocodigo_f") and Len(Trim(Form.Deptocodigo_f)) >
				and upper(Deptocodigo) like '%#trim(ucase(form.Deptocodigo_f))#%'
			</cfif>
			<cfif isdefined("Form.Ddescripcion_f") and Len(Trim(Form.Ddescripcion_f))>
				and upper(Ddescripcion) like '%#trim(ucase(form.Ddescripcion_f))#%'
			</cfif>
			
			<cfif isdefined("form.excluir") and len(trim(form.excluir))>
				and Dcodigo not in (#form.Excluir#)
			</cfif>
			order by Deptocodigo,Ddescripcion
		</cfquery>

		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfinvokeargument name="desplegar" value="Deptocodigo,Ddescripcion"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisDepartamentos.cfm"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Dcodigo,Deptocodigo,Ddescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>