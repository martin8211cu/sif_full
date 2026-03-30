<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeConcursosTerminados"
	Default="Lista de Concursos Terminados"
	returnvariable="LB_ListaDeConcursosTerminados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>	
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

function Asignar(id,codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#form.formulario#.#form.id#.value = id;
		window.opener.document.#form.formulario#.#form.codigo#.value = trim(codigo);
		window.opener.document.#form.formulario#.#form.desc#.value = desc;
		if (window.opener.func#form.codigo#) {window.opener.func#form.codigo#()}
		</cfoutput>
		window.close();
	}
}
</script>

<!--- Filtro --->
<cfif isdefined("Url.RHCcodigo") and not isdefined("Form.RHCcodigo")>
	<cfparam name="Form.RHCcodigo" default="#Url.RHCcodigo#">
</cfif>
<cfif isdefined("Url.RHCdescripcion") and not isdefined("Form.RHCdescripcion")>
	<cfparam name="Form.RHCdescripcion" default="#Url.RHCdescripcion#">
</cfif>

<cfset filtro = "">

<cfset navegacion = "&formulario=#form.formulario#&id=#form.id#&codigo=#form.codigo#&desc=#form.desc#" >
<cfif isdefined("Form.RHCcodigo") and Len(Trim(Form.RHCcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(RHCcodigo) like '%" & UCase(Form.RHCcodigo) & "%'">
	<cfset navegacion = navegacion & "&RHCcodigo=" & Form.RHCcodigo>
</cfif>
<cfif isdefined("Form.RHCdescripcion") and Len(Trim(Form.RHCdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(RHCdescripcion) like '%" & UCase(Form.RHCdescripcion) & "%'">
	<cfset navegacion = navegacion & "&RHCdescripcion=" & Form.RHCdescripcion>
</cfif>

<html>
<head>
<title><cfoutput>#LB_ListaDeConcursosTerminados#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr><td>
		<cfoutput>
		<form style="margin:0;" name="filtroEmpleado" method="post" action="conlisConcursos.cfm" >
		<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>#LB_Codigo#</strong></td>
				<td> 
					<input name="RHCcodigo" type="text" id="codigo" size="10" maxlength="10" onClick="this.select();" value="<cfif isdefined("Form.RHCcodigo")>#Form.RHCcodigo#</cfif>">
				</td>
				<td align="right"><strong>#LB_Descripcion#</strong></td>
				<td> 
					<input name="RHCdescripcion" type="text" id="desc" size="40" maxlength="80" onClick="this.select();" value="<cfif isdefined("Form.RHCdescripcion")>#Form.RHCdescripcion#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
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
		<cfquery name="rsLista" datasource="#session.DSN#">
			select RHCconcurso, RHCcodigo, RHCdescripcion
			from RHConcursos
			where Ecodigo=#session.Ecodigo# 
			and RHCestado = 70
				<cfif isdefined("filtro") and len(trim(filtro))>
					#preservesinglequotes(filtro)#
				</cfif>
			order by RHCcodigo
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="RHCcodigo,RHCdescripcion"/>
			<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="conlisConcursos.cfm"/>
			<cfinvokeargument name="formName" value="form1"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="RHCconcurso,RHCcodigo,RHCdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>
	</td></tr>	
</table>

</body>
</html>