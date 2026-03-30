
<script language="JavaScript" type="text/javascript">
	function Asignar(SPcodigo,SPproceso) {
		window.opener.document.form1.SPcodigo.value=SPcodigo;
		window.opener.document.form1.SPproceso.value=SPproceso;
		window.close();
	}

</script>

<cfif isdefined("url.SPcodigo") and not isdefined("form.SPcodigo")>
	<cfparam name="form.SPcodigo" default="#url.SPcodigo#">
</cfif>
<cfif isdefined("url.SPdescripcion") and not isdefined("form.SPdescripcion")>
	<cfparam name="form.SPdescripcion" default="#url.SPdescripcion#">
</cfif>

<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo")>
	<cfparam name="form.SScodigo" default="#url.SScodigo#">
</cfif>

<cfif isdefined("url.SMcodigo") and not isdefined("form.SMcodigo")>
	<cfparam name="form.SMcodigo" default="#url.SMcodigo#">
</cfif>

<cfset filtro = '' >
<cfset navegacion = '' >

<cfif isdefined("form.SPcodigo") and Len(Trim(form.SPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SPcodigo=" & form.SPcodigo>
</cfif>

<cfif isdefined("form.SPdescripcion") and Len(Trim(form.SPdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SPdescripcion=" & Form.SPdescripcion>
</cfif>

<cfif isdefined("form.SScodigo") and Len(Trim(form.SScodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SScodigo=" & form.SScodigo>
</cfif>

<cfif isdefined("form.SMcodigo") and Len(Trim(form.SMcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SMcodigo=" & Form.SMcodigo>
</cfif>


<html>
<head>
<title>Lista de Procesos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfoutput>
<form style="margin:0; " name="filtroEmpleado" method="post" action="conlisProcesos.cfm">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<tr>
			<td ><strong>Proceso:&nbsp;</strong></td>
			<td><input name="SPcodigo" type="text" size="15" maxlength="10" onFocus="this.select();" value="<cfif isdefined('form.SPcodigo') and len(trim(form.SPcodigo)) >#form.SPcodigo#</cfif>"></td>
			<td ><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input name="SPdescripcion" type="text" size="60" maxlength="255" onFocus="this.select();" value="<cfif isdefined('form.SPdescripcion') and len(trim(form.SPdescripcion)) >#form.SPdescripcion#</cfif>"></td>
			<td width="1%" ><input type="submit" name="Filtrar" value="Filtrar"></td>
		</tr>
	</tr>
</table>
	<input type="hidden" name="SScodigo" value="#form.SScodigo#">
	<input type="hidden" name="SMcodigo" value="#form.SMcodigo#">

</form>

	<cfquery name="rsLista" datasource="asp">
		select SPcodigo, SPdescripcion
		from SProcesos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SScodigo)#">
		  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMcodigo)#">

		<cfif isdefined("form.SPcodigo") and Len(Trim(form.SPcodigo)) NEQ 0>
			and upper(rtrim(ltrim(SPcodigo))) like '%#UCase(trim(form.SPcodigo))#%'
		</cfif>
		
		<cfif isdefined("form.SPdescripcion") and Len(Trim(form.SPdescripcion)) NEQ 0>
			and upper(rtrim(ltrim(SPdescripcion))) like '%#UCase(trim(form.SPdescripcion))#%'
		</cfif>

		order by SPcodigo
	</cfquery>

</cfoutput>
<cfinvoke 
 component="commons.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsLista#"/>
	<cfinvokeargument name="desplegar" value="SPcodigo, SPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Proceso, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisProcesos.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="SPcodigo, SPdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="asp"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="ShowEmptyListMsg" value="true"/>
</cfinvoke>
</body>
</html>