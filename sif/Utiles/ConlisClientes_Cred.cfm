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

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc,limite, utilizado) {
	if (window.opener != null) {
		<cfoutput>		
		
		window.opener.document.#form.formulario#.#form.id#.value = trim(codigo);//id;
		window.opener.document.#form.formulario#.#form.codigo#.value = id;//trim(codigo);
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

<cfset filtro = "">
<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >
<cfif isdefined("Form.CDCidentificacion") and Len(Trim(Form.CDCidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and CDCidentificacion like '%" & Form.CDCidentificacion & "%'">
	<cfset navegacion = navegacion & "&CDCidentificacion=" & Form.CDCidentificacion>
</cfif>
<cfif isdefined("Form.CDCnombre") and Len(Trim(Form.CDCnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CDCnombre) like '%" & UCase(Form.CDCnombre) & "%'">
	<cfset navegacion = navegacion & "&CDCnombre=" & Form.CDCnombre>
</cfif>

<html>
<head>
<title>Lista de Clientes</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<!---<tr><td><table width="100%"><tr><td class="tituloMantenimiento" align="center"><font size="2">Conceptos de Servicio</font></td></tr></table></td></tr>--->
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisClientesDetallistasCorp.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>N&uacute;mero</strong></td>
				<td> 
					<input name="CDCidentificacion" type="text" id="codigo" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.CDCidentificacion")>#Form.CDCidentificacion#</cfif>">
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

	<cfquery name="lista" datasource="#session.DSN#">
		select 
        	a.CDCcodigo,
            a.SNcodigo,
            CDCnombre,
            CDCidentificacion,
            SNnombre,
            SNidentificacion
		from FACSnegocios a
		inner join ClientesDetallistasCorp b
			on b.CDCcodigo=a.CDCcodigo
			and b.CEcodigo=a.Ecodigo
		inner join SNegocios c
			on c.SNcodigo=a.SNcodigo
			and c.Ecodigo=a.Ecodigo
		where a.Ecodigo= #session.Ecodigo#
		order by CDCidentificacion
	</cfquery>

	<tr><td>
 		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="CDCidentificacion, CDCnombre"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="irA" value="ConlisClientes_Cred.cfm"/>
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
