<cfif isdefined("url.CMTOcodigo") and not isdefined("form.CMTOcodigo")>
	<cfset form.CMTOcodigo= url.CMTOcodigo >
</cfif>
<cfif isdefined("url.CMTOdescripcion") and not isdefined("form.CMTOdescripcion")>
	<cfset form.CMTOdescripcion= url.CMTOdescripcion >
</cfif>

<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>

<script language="JavaScript" type="text/javascript">
//La funcion recibe el CMTScodigo y CMTSdescripcion
function Asignar(id,descripcion){
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMTOcodigo.value   = id;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CMTOdescripcion.value = descripcion;
		window.close();
	}
}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.CMTOcodigo") and not isdefined("Form.CMTOcodigo")>
	<cfparam name="Form.CMTOcodigo" default="#Url.CMTOcodigo#">
</cfif>
<cfif isdefined("Url.CMTOdescripcion") and not isdefined("Form.CMTOdescripcion")>
	<cfparam name="Form.CMTOdescripcion" default="#Url.CMTOdescripcion#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CMTOcodigo") and Len(Trim(Form.CMTOcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CMTOcodigo) like '%" & #UCase(Form.CMTOcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTOcodigo=" & Form.CMTOcodigo>
</cfif>
<cfif isdefined("Form.CMTOdescripcion") and Len(Trim(Form.CMTOdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CMTOdescripcion) like '%" & #UCase(Form.CMTOdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTOdescripcion=" & Form.CMTOdescripcion>
</cfif>


<html>
<head>
<title>Lista de Tipos de Orden</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="filtroEmpleado" method="post">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" align="right"><strong>Código</strong></td>
		<td> 
			<input name="CMTOcodigo" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CMTOcodigo")>#Form.CMTOcodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Descripción</strong></td>
		<td> 
			<input name="CMTOdescripcion" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CMTOdescripcion")>#Form.CMTOdescripcion#</cfif>" onfocus="javascript:this.select();" >
		</td>

		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsTOrdenes" datasource="#session.DSN#">
	select a.CMTOcodigo, a.CMTOdescripcion
	from CMTipoOrden a	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	#preservesinglequotes(filtro)#	
	order by CMTOdescripcion
</cfquery>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsTOrdenes#"/> 
	<cfinvokeargument name="desplegar" value="CMTOcodigo, CMTOdescripcion"/> 
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/> 
	<cfinvokeargument name="formatos" value="V,V"/> 
	<cfinvokeargument name="align" value="left,left"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="conlisTOrdenesSolicitante.cfm"/> 
	<cfinvokeargument name="formname" value="listaSol"/> 
	<cfinvokeargument name="maxrows" value="15"/> 				
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CMTOcodigo,CMTOdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke> 

</body>
</html>