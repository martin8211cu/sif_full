<!--- Recibe conexion, form, name y desc --->
 <!---03/1/2014 cambio en el orden de clasificaciones en consulta general de articulos--->
<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo,desc) {
	if (window.opener != null) {
		<cfoutput>
		var descAnt = window.opener.document.#Url.form#.#Url.desc#.value;
		window.opener.document.#Url.form#.#Url.id#.value = id;
		window.opener.document.#Url.form#.#Url.name#.value = trim(codigo);
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		</cfoutput>
		window.close();
	}
}
</script>

<cfif isdefined("Url.Ccodigoclas") and not isdefined("Form.Ccodigoclas")>
	<cfparam name="Form.Ccodigoclas" default="#Url.Ccodigoclas#">
</cfif>
<cfif isdefined("Url.Cdescripcion") and not isdefined("Form.Cdescripcion")>
	<cfparam name="Form.Cdescripcion" default="#Url.Cdescripcion#">
</cfif>

<cfif isdefined("Url.Ccodigoclas") and isdefined("Form.Ccodigoclas") and url.Ccodigoclas neq form.Ccodigoclas >
	<cfset Url.Ccodigoclas = form.Ccodigoclas>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfif isdefined("Url.Cdescripcion") and isdefined("Form.Cdescripcion") and url.Cdescripcion neq form.Cdescripcion >
	<cfset Url.Cdescripcion = form.Cdescripcion>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.Ccodigoclas") and Len(Trim(Form.Ccodigoclas)) NEQ 0>
	<cfset filtro = filtro & " and upper(Ccodigoclas) like '%" & #UCase(Form.Ccodigoclas)# & "%'">
	<cfset navegacion = "&Ccodigoclas=" & Form.Ccodigoclas>
</cfif>
<cfif isdefined("Form.Cdescripcion") and Len(Trim(Form.Cdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Cdescripcion) like '%" & #UCase(Form.Cdescripcion)# & "%'">
	<cfset navegacion = navegacion & "&Cdescripcion=" & Form.Cdescripcion>
</cfif>

<html>
<head>
<title>Lista de Clasificaciones</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>

<table width="98%" border="0" cellpadding="0" cellspacing="0">
	<form name="filtroClasificacion" method="post">
		<tr><td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
					<td align="right"><strong>C&oacute;digo</strong></td>
					<td> 
						<input name="Ccodigoclas" type="text" id="name" size="10" onFocus="this.select();" maxlength="10" value="<cfif isdefined("Form.Ccodigoclas")>#Form.Ccodigoclas#</cfif>">
					</td>
					<td align="right"><strong>Descripci&oacute;n</strong></td>
					<td> 
						<input name="Cdescripcion" type="text" id="desc" size="40" onFocus="this.select();" maxlength="80" value="<cfif isdefined("Form.Cdescripcion")>#Form.Cdescripcion#</cfif>">
					</td>
					<td align="center">
						<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
					</td>
				</tr>
			</table>
		</td></tr>
	</form>

	<tr><td colspan="5">
		<!--- consulta general de articulos --->
		<cfset select = "Ccodigo, Ccodigoclas, Cdescripcion " >
		<cfset from = "Clasificaciones">
		<cfset where = "Ecodigo=#session.Ecodigo# " >
		<cfset where = where & filtro & " order by Ccodigo ">  <!---" order by upper(Ccodigoclas) "--->
		
		</cfoutput>
		
		<cfquery name="rsLista" datasource="#session.DSN#">
			select Ccodigo, Ccodigoclas, Cdescripcion 
			from Clasificaciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			<cfif len(trim(filtro))>
				#preservesinglequotes(filtro)#
			</cfif>
			order by Ccodigo    <!---" order by upper(Ccodigoclas) "--->
		</cfquery>
		
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="desplegar" value="Ccodigoclas, Cdescripcion"/>
			<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="conlisClasificacion.cfm"/>
			<cfinvokeargument name="formName" value="listaClasificacion"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="Ccodigo, Ccodigoclas, Cdescripcion"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="Conexion" value="#url.conexion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		</cfinvoke>

	</td></tr>
</table>


</body>
</html>