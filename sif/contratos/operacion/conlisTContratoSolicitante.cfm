<cfif isdefined("url.CTTCcodigo") and not isdefined("form.CTTCcodigo")>
	<cfset form.CTTCcodigo= url.CTTCcodigo >
</cfif>
<cfif isdefined("url.CTTCdescripcion") and not isdefined("form.CTTCdescripcion")>
	<cfset form.CTTCdescripcion= url.CTTCdescripcion >
</cfif>

<cfif isdefined("Url.formulario") and not isdefined("Form.formulario")>
	<cfset form.formulario= url.formulario >
</cfif>

<script language="JavaScript" type="text/javascript">
//La funcion recibe el CMTScodigo y CMTSdescripcion
function Asignar(id,descripcion){
	if (window.opener != null) {
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CTTCcodigo.value   = id;
		window.opener.document.<cfoutput>#form.formulario#</cfoutput>.CTTCdescripcion.value = descripcion;
		window.close();
	}
}
</script>

<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.CTTCcodigo") and not isdefined("Form.CTTCcodigo")>
	<cfparam name="Form.CTTCcodigo" default="#Url.CTTCcodigo#">
</cfif>
<cfif isdefined("Url.CTTCdescripcion") and not isdefined("Form.CTTCdescripcion")>
	<cfparam name="Form.CTTCdescripcion" default="#Url.CTTCdescripcion#">
</cfif>

<!---- Se establecen las variables de navegacion y filtros ----->
<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CTTCcodigo") and Len(Trim(Form.CTTCcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CTTCcodigo) like '%" & #UCase(Form.CTTCcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CTTCcodigo=" & Form.CTTCcodigo>
</cfif>
<cfif isdefined("Form.CTTCdescripcion") and Len(Trim(Form.CTTCdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CTTCdescripcion) like '%" & #UCase(Form.CTTCdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CTTCdescripcion=" & Form.CTTCdescripcion>
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
			<input name="CTTCcodigo" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CTTCcodigo")>#Form.CTTCcodigo#</cfif>" onFocus="javascript:this.select();" >
		</td>
		<td width="1%" align="right"><strong>Descripción</strong></td>
		<td> 
			<input name="CTTCdescripcion" type="text" id="name" size="30" maxlength="30" value="<cfif isdefined("Form.CTTCdescripcion")>#Form.CTTCdescripcion#</cfif>" onFocus="javascript:this.select();" >
		</td>

		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsTOrdenes" datasource="#session.DSN#">
	select a.CTTCcodigo, a.CTTCdescripcion
	from CTTipoContrato a	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	#preservesinglequotes(filtro)#	
	order by CTTCdescripcion
</cfquery>

<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		returnvariable="pListaRet"> 
	<cfinvokeargument name="query" value="#rsTOrdenes#"/> 
	<cfinvokeargument name="desplegar" value="CTTCcodigo, CTTCdescripcion"/> 
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/> 
	<cfinvokeargument name="formatos" value="V,V"/> 
	<cfinvokeargument name="align" value="left,left"/> 
	<cfinvokeargument name="ajustar" value="N"/> 
	<cfinvokeargument name="checkboxes" value="N"/> 
	<cfinvokeargument name="irA" value="conlisTOrdenesSolicitante.cfm"/> 
	<cfinvokeargument name="formname" value="listaSol"/> 
	<cfinvokeargument name="maxrows" value="15"/> 				
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CTTCcodigo,CTTCdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="yes"/>
</cfinvoke> 

</body>
</html>