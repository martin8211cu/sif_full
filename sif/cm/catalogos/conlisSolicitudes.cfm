<cfif isdefined("url.CMTScodigo") and not isdefined("form.CMTScodigo")>
	<cfset form.CMTScodigo= url.CMTScodigo >
</cfif>
<cfif isdefined("url.CMTSdescripcion") and not isdefined("form.CMTSdescripcion")>
	<cfset form.CMTSdescripcion= url.CMTSdescripcion >
</cfif>

<script language="JavaScript" type="text/javascript">
//La funcion recibe el CMTScodigo y CMTSdescripcion
function Asignar(id,descripcion){
	if (window.opener != null) {
		window.opener.document.form1.CMTScodigo.value   = id;
		window.opener.document.form1.CMTSdescripcion.value = descripcion;
		window.close();
	}
}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.CMTScodigo") and not isdefined("Form.CMTScodigo")>
	<cfparam name="Form.CMTScodigo" default="#Url.CMTScodigo#">
</cfif>
<cfif isdefined("Url.CMTSdescripcion") and not isdefined("Form.CMTSdescripcion")>
	<cfparam name="Form.CMTSdescripcion" default="#Url.CMTSdescripcion#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CMTScodigo") and Len(Trim(Form.CMTScodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(CMTScodigo) like '%" & #UCase(Form.CMTScodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTScodigo=" & Form.CMTScodigo>
</cfif>
<cfif isdefined("Form.CMTSdescripcion") and Len(Trim(Form.CMTSdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(CMTSdescripcion) like '%" & #UCase(Form.CMTSdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CMTSdescripcion=" & Form.CMTSdescripcion>
</cfif>


<html>
<head>
<title>Lista de Tipos de Solicitud</title>
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
			<input name="CMTScodigo" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CMTScodigo")>#Form.CMTScodigo#</cfif>" onfocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Descripción</strong></td>
		<td> 
			<input name="CMTSdescripcion" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CMTSdescripcion")>#Form.CMTSdescripcion#</cfif>" onfocus="javascript:this.select();" >
		</td>

		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsSolicitudes" datasource="#session.DSN#">
	select CMTScodigo, CMTSdescripcion 
	from CMTiposSolicitud
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	#preservesinglequotes(filtro)#
	order by CMTSdescripcion
</cfquery>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsSolicitudes#"/> 
	<cfinvokeargument name="desplegar" value="CMTScodigo, CMTSdescripcion"/> 
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/> 
	<cfinvokeargument name="formatos" value="V,V"/> 
	<cfinvokeargument name="align" value="left,left"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="conlisSolicitudes.cfm"/> 
	<cfinvokeargument name="formname" value="listaSol"/> 
	<cfinvokeargument name="maxrows" value="15"/> 				
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CMTScodigo,CMTSdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke> 

</body>
</html>