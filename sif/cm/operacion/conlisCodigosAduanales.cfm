<cfif isdefined("url.CAcodigo") and not isdefined("form.CAcodigo")>
	<cfset form.CAcodigo= url.CAcodigo>
</cfif>
<cfif isdefined("url.CAdescripcion") and not isdefined("form.CAdescripcion")>
	<cfset form.CAdescripcion= url.CAdescripcion >
</cfif>
<cfif isdefined("url.formulario") and not isdefined("form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>

<script language="JavaScript" type="text/javascript">
//La funcion recibe el CMTScodigo y CMTSdescripcion
function Asignar(id, codigo, descripcion){
	if (window.opener != null) {
		<cfoutput>
			window.opener.document.#form.formulario#.CAid.value   = id;
			window.opener.document.#form.formulario#.CAcodigo.value   = codigo;
			window.opener.document.#form.formulario#.CAdescripcion.value = descripcion;
			if (window.opener.funcImpuesto) {window.opener.funcImpuesto()}
			window.opener.document.#form.formulario#.CAcodigo.focus();
			window.opener.document.#form.formulario#.CAcodigo.select();
		</cfoutput>	
		window.close();
	}
}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.CAcodigo") and not isdefined("Form.CAcodigo")>
	<cfparam name="Form.CAcodigo" default="#Url.CAcodigo#">
</cfif>
<cfif isdefined("Url.CAdescripcion") and not isdefined("Form.CAdescripcion")>
	<cfparam name="Form.CAdescripcion" default="#Url.CAdescripcion#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CAcodigo") and Len(Trim(Form.CAcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CAcodigo) like '%" & #UCase(Form.CAcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CAcodigo=" & Form.CAcodigo>
</cfif>
<cfif isdefined("Form.CAdescripcion") and Len(Trim(Form.CAdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CAdescripcion) like '%" & #UCase(Form.CAdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CAdescripcion=" & Form.CAdescripcion>
</cfif>
<cfif isdefined("Form.formulario") and Len(Trim(Form.formulario)) NEQ 0>	
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "formulario=" & Form.formulario>
</cfif>


<html>
<head>
<title>Lista de Códigos Aduanales</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtro" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" align="right"><strong>Código</strong></td>
		<td> 
			<input name="CAcodigo" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CAcodigo")>#Form.CAcodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Descripción</strong></td>
		<td> 
			<input name="CAdescripcion" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CAdescripcion")>#Form.CAdescripcion#</cfif>" onfocus="javascript:this.select();" >
		</td>

		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsCodAduanales" datasource="#session.DSN#">
	select CAid, ltrim(rtrim(a.CAcodigo)) as CAcodigo, ltrim(rtrim(a.CAdescripcion)) as CAdescripcion
	from CodigoAduanal a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		#preservesinglequotes(filtro)#
	order by CAcodigo, CAdescripcion
</cfquery>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsCodAduanales#"/> 
	<cfinvokeargument name="desplegar" value="CAcodigo, CAdescripcion"/> 
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/> 
	<cfinvokeargument name="formatos" value="V,V"/> 
	<cfinvokeargument name="align" value="left,left"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="conlisCodigosAduanales.cfm"/> 
	<cfinvokeargument name="formname" value="listaSol"/> 
	<cfinvokeargument name="maxrows" value="15"/> 				
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CAid, CAcodigo, CAdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke> 

</body>
</html>