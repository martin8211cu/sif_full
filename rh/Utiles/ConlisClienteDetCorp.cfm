<!--- parametros para llamado del conlis --->
<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfparam name="Form.formulario" default="#Url.formulario#">
</cfif>
<cfif isdefined("Url.id") and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.desc") and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfparam name="Form.codigo" default="#Url.codigo#">
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
		window.opener.document.#form.formulario#.#form.codigo#.value = codigo;
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}		
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->

<cfif isdefined("Url.CDCidentificacion") and not isdefined("Form.CDCidentificacion")>
	<cfparam name="Form.CDCidentificacion" default="#Url.CDCidentificacion#">
</cfif>

<cfif isdefined("Url.CDCnombre") and not isdefined("Form.CDCnombre")>
	<cfparam name="Form.CDCnombre" default="#Url.CDCnombre#">
</cfif>

<!---<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >--->

<cfset navegacion = "">
<cfif isdefined("Form.CDCidentificacion") and Len(Trim(Form.CDCidentificacion)) NEQ 0>
	<cfset navegacion = navegacion & "&CDCidentificacion=" & Form.CDCidentificacion>
</cfif>
<cfif isdefined("Form.CDCnombre") and Len(Trim(Form.CDCnombre)) NEQ 0>
	<cfset navegacion = navegacion & "&CDCnombre=" & Form.CDCnombre>
</cfif>
<cfif isdefined("Form.formulario") and Len(Trim(Form.formulario)) NEQ 0>
	<cfset navegacion = navegacion & "&formulario=" & Form.formulario>
</cfif>
<cfif isdefined("Form.id") and Len(Trim(Form.id)) NEQ 0>
	<cfset navegacion = navegacion & "&id=" & Form.id>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & "&desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.codigo") and Len(Trim(Form.codigo)) NEQ 0>
	<cfset navegacion = navegacion & "&codigo=" & Form.codigo>
</cfif>
<cfif isdefined("Form.excluir") and Len(Trim(Form.excluir)) NEQ 0>
	<cfset navegacion = navegacion & "&excluir=" & Form.excluir>
</cfif>

<html>
<head>
<title>Lista de Clientes Detallistas Corporativos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
<tr>
	<td>
		<cfoutput>
			<form style="margin:0;" name="filtroClinteDetCorp2" method="post" action="ConlisClienteDetCorp.cfm" >
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
					<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="CDCidentificacion" type="text" id="codigo" size="20" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.CDCidentificacion")>#Form.CDCidentificacion#</cfif>">
				</td>
					
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="CDCnombre" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.CDCnombre")>#Form.CDCnombre#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
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
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#" maxrows="200">
			select CDCcodigo, CDCidentificacion, CDCnombre
			from ClientesDetallistasCorp 
			where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_integer">
			
			<cfif isdefined("Form.CDCidentificacion") and Len(Trim(Form.CDCidentificacion)) >
				and CDCidentificacion like '%#trim(form.CDCidentificacion)#%'
			</cfif>
			<cfif isdefined("Form.CDCnombre") and Len(Trim(Form.CDCnombre))>
				and upper(CDCnombre) like '%#trim(ucase(form.CDCnombre))#%'
			</cfif>
			order by CDCidentificacion, CDCnombre
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="CDCidentificacion, CDCnombre"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripción"/>
			<cfinvokeargument name="formatos" value="V, V"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisClienteDetCorp.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CDCcodigo, CDCidentificacion, CDCnombre"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>
