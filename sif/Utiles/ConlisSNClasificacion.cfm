<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 08 de marzo del 2006
	Motivo: Se agregó un focus, cuado asigna los datos a los campos para q no se perdiera en la navegacion.
 --->

<!--- Recibe conexion, form, name, desc, id y peso --->

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

<cfif isdefined("Url.SNCEcodigo") and not isdefined("Form.fSNCEcodigo")>
	<cfparam name="Form.fSNCEcodigo" default="#Url.SNCEcodigo#">
</cfif>
<cfif isdefined("Url.SNCEdescripcion") and not isdefined("Form.fSNCEdescripcion")>
	<cfparam name="Form.fSNCEdescripcion" default="#Url.SNCEdescripcion#">
</cfif>
<!--- <cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif> --->



<cfset navegacion = "empresa=" & LvarEmpresa>


<cfif isdefined("Form.fSNCEcodigo") and Len(Trim(Form.fSNCEcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(SNCEcodigo) like '%" & #UCase(trim(Form.fSNCEcodigo))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNCEcodigo=" & Form.fSNCEcodigo>
</cfif>
<cfif isdefined("Form.fSNCEdescripcion") and Len(Trim(Form.fSNCEdescripcion)) NEQ 0>
 	<cfset filtro = filtro & " and upper(SNCEdescripcion) like '%" & #UCase(trim(Form.fSNCEdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNCEdescripcion =" & Form.fSNCEdescripcion>
</cfif>
<html>
<head>
<title>Clasificaci&oacute;n&nbsp;de&nbsp;Socios&nbsp;de&nbsp;Negocios</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form name="filtroSNClasificacion" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="fSNCEcodigo" type="text" id="name" size="6" maxlength="4" value="<cfif isdefined("Form.fSNCEcodigo")>#Form.fSNCEcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="fSNCEdescripcion" type="text" id="desc" size="60" maxlength="80" value="<cfif isdefined("Form.fSNCEdescripcion")>#Form.fSNCEdescripcion#</cfif>">
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
	<cfinvokeargument name="tabla" value="SNClasificacionE"/>
	<cfinvokeargument name="columnas" value="SNCEid, SNCEcodigo, SNCEdescripcion"/>
	<cfinvokeargument name="desplegar" value="SNCEcodigo, SNCEdescripcion"/>
	<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
	<cfinvokeargument name="formatos" value="S, S"/>
    <cfinvokeargument name="filtro" value="CEcodigo = #session.CEcodigo# #filtro# and PCCEactivo = 1 order by SNCEcodigo"/> 
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="ConlisSNClasificacion.cfm"/>
	<cfinvokeargument name="formName" value="form1"/><!---  --->
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/> 
	<cfinvokeargument name="fparams" value="SNCEcodigo, SNCEdescripcion, SNCEid"/> 
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="showEmptyListMsg" value="1">		

</cfinvoke>
</body>
</html>
