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
<cfif isdefined("Url.FAM01COD") and not isdefined("Form.FAM01COD")>
	<cfparam name="Form.FAM01COD" default="#Url.FAM01COD#">
</cfif>
<cfif isdefined("Url.excluir") and not isdefined("Form.excluir")>
	<cfparam name="Form.excluir" default="#Url.excluir#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc, FAM01COD) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = trim(desc);
		window.opener.document.#form.formulario#.#form.FAM01COD#.value = trim(FAM01COD);
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.FAM01CODD_f") and not isdefined("Form.FAM01CODD_f")>
	<cfparam name="Form.FAM01CODD_f" default="#Url.FAM01CODD_f#">
</cfif>
<cfif isdefined("Url.FAM01DES_f") and not isdefined("Form.FAM01DES_f")>
	<cfparam name="Form.FAM01DES_f" default="#Url.FAM01DES_f#">
</cfif>

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#&excluir=#form.excluir#&FAM01COD=#form.FAM01COD#" >
<cfif isdefined("Form.FAM01CODD_f") and Len(Trim(Form.FAM01CODD_f)) NEQ 0>
	<cfset navegacion = navegacion & "&FAM01CODD_f=" & Form.FAM01CODD_f>
</cfif>
<cfif isdefined("Form.FAM01DES_f") and Len(Trim(Form.FAM01DES_f)) NEQ 0>
	<cfset navegacion = navegacion & "&FAM01DES_f=" & Form.FAM01DES_f>
</cfif>

<html>
<head>
<title>Lista de Cajas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtro" method="post" action="ConlisCajas.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="FAM01CODD_f" type="text" id="FAM01CODD_f" size="10" maxlength="10" onFocus="this.select();" value="<cfif isdefined("Form.FAM01CODD_f")>#Form.FAM01CODD_f#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="FAM01DES_f" type="text" id="FAM01DES_f" size="40" maxlength="80"  onFocus="this.select();" value="<cfif isdefined("Form.FAM01DES_f")>#Form.FAM01DES_f#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="document.filtro.FAM01CODD_f.value=''; document.filtro.FAM01DES_f.value='';" >
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
					<cfif isdefined("form.FAM01COD") and len(trim(form.FAM01COD))>
						<input type="hidden" name="FAM01COD" value="#form.FAM01COD#">
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
			Select Ocodigo, FAM01CODD, FAM01DES, FAM01COD
			from FAM001
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("Form.FAM01CODD_f") and Len(Trim(Form.FAM01CODD_f)) >
				and upper(FAM01CODD) like '%#trim(ucase(form.FAM01CODD_f))#%'
			</cfif>
			<cfif isdefined("Form.FAM01DES_f") and Len(Trim(Form.FAM01DES_f))>
				and upper(FAM01DES) like '%#trim(ucase(form.FAM01DES_f))#%'
			</cfif>
			
			<cfif isdefined("form.excluir") and len(trim(form.excluir))>
				and Ocodigo not in (#form.Excluir#)
			</cfif>
			order by FAM01CODD,FAM01DES
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#conlis#"/>
			<cfinvokeargument name="desplegar" value="FAM01CODD,FAM01DES"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisCajas.cfm"/>
			<cfinvokeargument name="formName" value="lista"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Ocodigo,FAM01CODD,FAM01DES,FAM01COD"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>