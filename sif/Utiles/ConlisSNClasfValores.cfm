<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 08 de marzo del 2006
	Motivo: Se agregó un focus, cuado asigna los datos a los campos para q no se perdiera en la navegacion.
 --->

<!--- Recibe conexion, form, name, desc, id y peso --->

<cfif not isdefined("url.SNCEid") or len(trim(url.SNCEid)) LTE 0>
	<cf_errorCode	code = "50804" msg = "La Clasificación no ha sido Escogida.">
</cfif>

<script language="JavaScript" type="text/javascript">
function Asignar(name,desc,id) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.name#.value = name;
		window.opener.document.#Url.form#.#Url.desc#.value = desc;
		window.opener.document.#Url.form#.#Url.id#.value = id;

		if (window.opener.func#Url.name#) {window.opener.func#Url.name#()}
		window.opener.document.#Url.form#.#Url.name#.focus();
		</cfoutput>
		window.close();
	}
}
</script>
<cfset filtro = "">
<cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
</cfquery>
<cfif isdefined('session.Ecodigo') and 
	  isdefined('session.Ecodigocorp') and
	  session.Ecodigo NEQ session.Ecodigocorp and
	  rsConsultaCorp.RecordCount GT 0>
	  <cfset filtro = " and Ecodigo=#session.Ecodigo#">
<cfelse>
	  <cfset filtro = " and Ecodigo is null">								  
</cfif>

<cfset LvarEmpresa = Session.Ecodigo>

<cfif isdefined("Url.SNCDvalor") and not isdefined("Form.fSNCDvalor")>
	<cfparam name="Form.fSNCDvalor" default="#Url.SNCDvalor#">
</cfif>
<cfif isdefined("Url.SNCDdescripcion") and not isdefined("Form.fSNCDdescripcion")>
	<cfparam name="Form.fSNCDdescripcion" default="#Url.SNCDdescripcion#">
</cfif>
<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>


<cfset navegacion = "empresa=" & LvarEmpresa>

<cfset filtro = filtro & " and a.SNCEid= b.SNCEid and a.SNCEid = " & #url.SNCEid#>
<cfif isdefined("Form.fSNCDvalor") and Len(Trim(Form.fSNCDvalor)) NEQ 0>
	<cfset filtro = filtro & " and upper(SNCDvalor) like '%" & #UCase(trim(Form.fSNCDvalor))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNCDvalor=" & Form.fSNCDvalor>
</cfif>
<cfif isdefined("Form.fSNCDdescripcion") and Len(Trim(Form.fSNCDdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(SNCDdescripcion) like '%" & #UCase(trim(Form.fSNCDdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNCDdescripcion =" & Form.fSNCDdescripcion>
</cfif>
<html>
<head>
<title>Valores&nbsp;Clasificaci&oacute;</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroSNClasfValores" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="fSNCDvalor" type="text" id="name" size="6" maxlength="4" value="<cfif isdefined("Form.fSNCDvalor")>#Form.fSNCDvalor#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="fSNCDdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.fSNCDdescripcion")>#Form.fSNCDdescripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cfinvoke 
 component="sif.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="SNClasificacionE a, SNClasificacionD b"/>
	<cfinvokeargument name="columnas" value="b.SNCDid, b.SNCDvalor, b.SNCDdescripcion"/>
	<cfinvokeargument name="desplegar" value="SNCDvalor, SNCDdescripcion"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value="S, S"/>
	<cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# #filtro#
											and SNCDactivo = 1 order by SNCDvalor"/> 
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ConlisSNClasfValores.cfm"/>
	<cfinvokeargument name="formName" value="form1"/><!---  --->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> 
	<cfinvokeargument name="fparams" value="SNCDvalor, SNCDdescripcion, SNCDid"/> 
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>


