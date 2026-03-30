<!---
<cfif isdefined("Url.CGARid") and not isdefined("Form.CGARid")>
	<cfparam name="Form.CGARid" default="#Url.CGARid#">
</cfif>

<cfif isdefined("Url.PCDvalor") and not isdefined("Form.PCDvalor")>
	<cfparam name="Form.PCDvalor" default="#Url.PCDvalor#">
</cfif>
<cfif isdefined("Url.PCDdescripcion") and not isdefined("Form.PCDdescripcion")>
	<cfparam name="Form.PCDdescripcion" default="#Url.PCDdescripcion#">
</cfif>

<cfif isdefined("Url.PCDvalor") and isdefined("Form.PCDvalor") and url.PCDvalor neq form.PCDvalor>
	<cfset Url.PCDvalor = form.PCDvalor>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfif isdefined("Url.PCDdescripcion") and isdefined("Form.PCDdescripcion") and url.PCDdescripcion neq form.PCDdescripcion >
	<cfset Url.PCDdescripcion = form.PCDdescripcion>
	<cfset url.PAGENUM_LISTA = 1>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.CGARid") and Len(Trim(Form.CGARid)) NEQ 0>
	<cfset navegacion = "&CGARid=" & Form.CGARid>
</cfif>

<cfif isdefined("Form.PCDvalor") and Len(Trim(Form.PCDvalor)) NEQ 0>
	<cfset navegacion = "&PCDvalor=" & Form.PCDvalor>
</cfif>
<cfif isdefined("Form.PCDdescripcion") and Len(Trim(Form.PCDdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & "&PCDdescripcion=" & Form.PCDdescripcion>
</cfif>
--->

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("url.CGARid") and Len(Trim(url.CGARid)) NEQ 0>
	<cfset navegacion = "&CGARid=" & url.CGARid>
</cfif>

<cfif isdefined("url.PCDvalor") and Len(Trim(url.PCDvalor)) NEQ 0>
	<cfset navegacion = "&PCDvalor=" & url.PCDvalor>
</cfif>
<cfif isdefined("url.PCDdescripcion") and Len(Trim(url.PCDdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & "&PCDdescripcion=" & url.PCDdescripcion>
</cfif>

<html>
<head>
<title>Lista de Valores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>

<style type="text/css">
<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
.ar1 {background-color:#D4DBF2;cursor:pointer;}
.ar2 {background-color:#ffffff;cursor:pointer;}
</style>


<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, codigo, desc) {
	if (window.opener != null) {
		window.opener.document.form2.PCDcatid.value = id;
		window.opener.document.form2.PCDvalor.value = trim(codigo);
		window.opener.document.form2.PCDdescripcion.value = desc;
		window.close();
	}
}
</script>
</head>
<body>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
<tr><td valign="top"> 

</td><td valign="top" width="20">
</td><td valign="top">
	<cfoutput>
	<form name="filtro" method="get" >

	<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr>
			<td align="right" nowrap><strong>C&oacute;digo</strong></td>
			<td> 
				<input name="PCDvalor" type="text" id="name" size="10" maxlength="20" value="<cfif isdefined("url.PCDvalor")>#url.PCDvalor#</cfif>">
			</td>

			<td align="right"><strong>Descripci&oacute;n</strong></td>
			<td> 
				<input name="PCDdescripcion" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("url.PCDdescripcion")>#url.PCDdescripcion#</cfif>">
			</td>
			<td align="center">
				<input type="hidden" name="CGARid" value="#url.CGARid#"/>
				<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
			</td>
		</tr>
	</table>
	</form>
	</cfoutput>	

	<cfquery name="rsLista"  datasource="#session.DSN#">
		select #url.CGARid# as CGARid, PCDcatid, PCDvalor, PCDdescripcion

		from CGAreaResponsabilidad a
		
		inner join PCDCatalogo b
		on b.PCEcatid = a.PCEcatid
		
		<cfif isdefined("url.PCDvalor") and len(trim(url.PCDvalor))>
			and upper(b.PCDvalor) = '#ucase(url.PCDvalor)#'
		</cfif>
		<cfif isdefined("url.PCDdescripcion") and len(trim(url.PCDdescripcion))>
			and upper(b.PCDdescripcion) like '%#ucase(url.PCDdescripcion)#%'
		</cfif>

		where a.CGARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CGARid#" >
		
		order by b.PCDvalor
	</cfquery>		
		
	<cfinvoke 

	 component="sif.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsLista#"/>
		<cfinvokeargument name="desplegar" value="PCDvalor, PCDdescripcion"/>
		<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value=""/>
		<cfinvokeargument name="formName" value="lista"/>
		<cfinvokeargument name="MaxRows" value="25"/>
		<cfinvokeargument name="funcion" value="Asignar"/>
		<cfinvokeargument name="fparams" value="PCDcatid, PCDvalor, PCDdescripcion"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		<cfinvokeargument name="debug" value="N"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="form_method" value="get"/>
	</cfinvoke>
</td></tr>
</table>

</body>
</html>