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
<cfif isdefined("Url.siglas") and not isdefined("Form.siglas")>
	<cfparam name="Form.siglas" default="#Url.siglas#">
</cfif>

<cfinclude template="sifConcat.cfm">
<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, desc, siglas) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		window.opener.document.#form.formulario#.#form.siglas#.value = siglas;
		if (window.opener.func#form.id#) {window.opener.func#form.id#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.Mnombre") and not isdefined("Form.Mnombre")>
	<cfparam name="Form.Mnombre" default="#Url.Mnombre#">
</cfif>

<cfset filtro = "">
<cfset descripcion = "Materias" >

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&desc=#form.desc#" >
<cfif isdefined("Form.Mnombre") and Len(Trim(Form.Mnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Msiglas)#_Cat#'-'#_Cat#upper(Mnombre) like '%" & UCase(Form.Mnombre) & "%'">
	<cfset navegacion = navegacion & "&Mnombre=" & Form.Mnombre>
</cfif>

<html>
<head>
<title>Lista de <cfoutput>#descripcion#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="ConlisMaterias.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="Mnombre" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.Mnombre")>#Form.Mnombre#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					<cfif isdefined("form.formulario") and len(trim(form.formulario))>
						<input type="hidden" name="formulario" value="#form.formulario#">
					</cfif>
					<cfif isdefined("form.id") and len(trim(form.id))>
						<input type="hidden" name="id" value="#form.id#">
					</cfif>
					<cfif isdefined("form.desc") and len(trim(form.desc))>
						<input type="hidden" name="desc" value="#form.desc#">
					</cfif>
					<cfif isdefined("form.siglas") and len(trim(form.siglas))>
						<input type="hidden" name="siglas" value="#form.siglas#">
					</cfif>
				</td>
			</tr>
		</table>
		</form>
		</cfoutput>
	</td></tr>
	
	<tr><td>
		<cfquery name="rsLista" datasource="#session.DSN#">
			select Mcodigo, Msiglas#_Cat#'-'#_Cat#Mnombre as materia, Msiglas
			from RHMateria
			where CEcodigo=#session.CEcodigo# 
				<cfif isdefined("filtro") and len(trim(filtro))>
					#preservesinglequotes(filtro)#
				</cfif>
			order by Mnombre
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="materia"/>
			<cfinvokeargument name="etiquetas" value="Descripci&oacute;n"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisMaterias.cfm"/>
			<cfinvokeargument name="formName" value="form#form.id#"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Mcodigo, materia, Msiglas"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>