<script language="JavaScript" type="text/javascript">
	function Asignar(SMcodigo, SPcodigo, SPproceso) {
		window.opener.document.form1.SMcodigo.value=SMcodigo;
		window.opener.document.form1.SPcodigo.value=SPcodigo;
		window.opener.document.form1.SPproceso.value=SPproceso;
		window.close();
	}

</script>

<cfif isdefined("url.SMdescripcion") and not isdefined("form.SMdescripcion")>
	<cfparam name="form.SMdescripcion" default="#url.SMdescripcion#">
</cfif>
<cfif isdefined("url.SPcodigo") and not isdefined("form.SPcodigo")>
	<cfparam name="form.SPcodigo" default="#url.SPcodigo#">
</cfif>

<cfif isdefined("url.SPdescripcion") and not isdefined("form.SPdescripcion")>
	<cfparam name="form.SPdescripcion" default="#url.SPdescripcion#">
</cfif>

<cfif isdefined("url.SScodigo") and not isdefined("form.SScodigo")>
	<cfparam name="form.SScodigo" default="#url.SScodigo#">
</cfif>

<cfif isdefined("url.SRcodigo") and not isdefined("form.SRcodigo")>
	<cfparam name="form.SRcodigo" default="#url.SRcodigo#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SRcodigo=" & form.SRcodigo>

<cfif isdefined("form.SScodigo") and Len(Trim(form.SScodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.SScodigo) like '%" & #UCase(form.SScodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SScodigo=" & form.SScodigo>
</cfif>

<cfif isdefined("form.SMdescripcion") and Len(Trim(form.SMdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.SMdescripcion) like '%" & #UCase(form.SMdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SMdescripcion=" & form.SMdescripcion>
</cfif>

<cfif isdefined("form.SPcodigo") and Len(Trim(form.SPcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.SPcodigo) like '%" & #UCase(form.SPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SPcodigo=" & form.SPcodigo>
</cfif>

<cfif isdefined("form.SPdescripcion") and Len(Trim(form.SPdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.SPdescripcion) like '%" & #UCase(form.SPdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SPdescripcion=" & Form.SPdescripcion>
</cfif>

<html>
<head>
<title>Lista de Procesos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfoutput>
<form style="margin:0; " name="filtroEmpleado" method="post">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<tr>
			<td bgcolor="##336699" class="subTitulo"><font color="##FFFFFF">M&oacute;dulo</font></td>
			<td bgcolor="##336699" class="subTitulo"><font color="##FFFFFF">Proceso</font></td>
			<td bgcolor="##336699" colspan="2" class="subTitulo"><font color="##FFFFFF">Descripci&oacute;n</font></td>
		</tr>

		<tr>
			<td><input name="SMdescripcion"  value="<cfif isdefined("form.SMdescripcion") and Len(Trim(form.SMdescripcion)) NEQ 0>#form.SMdescripcion#</cfif>" type="text" size="15" maxlength="10"></td>
			<td><input name="SPcodigo" value="<cfif isdefined("form.SPcodigo") and Len(Trim(form.SPcodigo)) NEQ 0>#form.SPcodigo#</cfif>"type="text" size="15" maxlength="10"></td>
			<td><input name="SPdescripcion" value="<cfif isdefined("form.SPdescripcion") and Len(Trim(form.SPdescripcion)) NEQ 0>#form.SPdescripcion#</cfif>"type="text" size="60" maxlength="255"></td>
			<td width="1%" ><input type="submit" name="Filtrar" value="Filtrar"></td>
		</tr>
	</tr>
</table>
</form>

	<!---
	<cfset where =  "a.SScodigo = '#trim(url.SScodigo)#' 
					and rtrim(a.SScodigo)||'~'||rtrim(a.SMcodigo)||'~'||rtrim(a.SPcodigo) not in (select rtrim(SScodigo)||'~'||rtrim(SMcodigo)||'~'||rtrim(SPcodigo) 
																								  from SProcesosRol 
																								  where SScodigo = '#trim(url.SScodigo)#' 
																								  and SRcodigo = '#trim(url.SRcodigo)#')" >
	--->																								  
	<cfset where =  "a.SScodigo = '#trim(url.SScodigo)#' 
					and {fn concat({fn concat({fn concat({fn concat(rtrim(a.SScodigo),'~')}, rtrim(a.SMcodigo))}, '~')}, rtrim(a.SPcodigo))} not in (select {fn concat({fn concat({fn concat({fn concat(rtrim(SScodigo),'~')}, rtrim(SMcodigo))}, '~')}, rtrim(SPcodigo))} 
																								  from SProcesosRol 
																								  where SScodigo = '#trim(url.SScodigo)#' 
																								  and SRcodigo = '#trim(url.SRcodigo)#')" >
																								  
	<cfif len(trim(filtro )) gt 0>
		<cfset where = where & filtro >
	</cfif>

	<cfset where = where & " and a.SMcodigo = b.SMcodigo " >

	<cfset where = where & " order by b.SMdescripcion, a.SPcodigo, a.SPdescripcion" >	

</cfoutput>
<cfinvoke 
 component="commons.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="SProcesos a, SModulos b"/>
	<cfinvokeargument name="columnas" value="a.SScodigo, a.SMcodigo, a.SPcodigo, a.SPdescripcion, b.SMdescripcion"/>
	<cfinvokeargument name="desplegar" value="SMdescripcion, SPcodigo, SPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="M&oacute;dulo, Proceso, Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="#where#"/>
	<cfinvokeargument name="align" value="left, left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisProcesos.cfm"/>
	<cfinvokeargument name="formName" value="lista"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="SMcodigo, SPcodigo, SPdescripcion"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="asp"/>
	<cfinvokeargument name="debug" value="N"/>
	<!---<cfinvokeargument name="Cortes" value="SPdescripcion"/>--->
	<cfinvokeargument name="ShowEmptyListMsg" value="true"/>
</cfinvoke>
</body>
</html>