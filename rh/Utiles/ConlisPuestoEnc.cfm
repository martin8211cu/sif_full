<!--- Recibe conexion, form, name y desc --->
<cfif isdefined("Url.form") and Len(Trim(Url.form)) and not isdefined("Form.form")>
	<cfparam name="Form.form" default="#Url.form#">
</cfif>
<cfif isdefined("Url.name") and Len(Trim(Url.name)) and not isdefined("Form.name")>
	<cfparam name="Form.name" default="#Url.name#">
</cfif>
<cfif isdefined("Url.desc") and Len(Trim(Url.desc)) and not isdefined("Form.desc")>
	<cfparam name="Form.desc" default="#Url.desc#">
</cfif>
<cfif isdefined("Url.id") and Len(Trim(Url.id)) and not isdefined("Form.id")>
	<cfparam name="Form.id" default="#Url.id#">
</cfif>
<cfif isdefined("Url.conexion") and Len(Trim(Url.conexion)) and not isdefined("Form.conexion")>
	<cfparam name="Form.conexion" default="#Url.conexion#">
</cfif>
<cfif isdefined("Url.EEid") and Len(Trim(Url.EEid)) and not isdefined("Form.EEid")>
	<cfparam name="Form.EEid" default="#Url.EEid#">
</cfif>
<cfif isdefined("Url.EPcodigo_F") and not isdefined("Form.EPcodigo_F")>
	<cfparam name="Form.EPcodigo_F" default="#Url.EPcodigo_F#">
</cfif>
<cfif isdefined("Url.EPdescripcion_F") and not isdefined("Form.EPdescripcion_F")>
	<cfparam name="Form.EPdescripcion_F" default="#Url.EPdescripcion_F#">
</cfif>

<script language="JavaScript" type="text/javascript">
	function Asignar(id,name,desc) {
		if (window.opener != null) {
			<cfoutput>
				window.opener.document.#Form.form#.#Form.id#.value = id;
				window.opener.document.#Form.form#.#Form.name#.value = name;				
				window.opener.document.#Form.form#.#Form.desc#.value = desc;
				if (window.opener.func#Form.name#) {window.opener.func#Form.name#()}
			</cfoutput>
			window.close();
		};
	}
</script>

<cfset filtro = "">
<cfset navegacion = "EEid=" & form.EEid>
<cfif isdefined("Form.form") and Len(Trim(Form.form)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "form=" & Form.form>
</cfif>
<cfif isdefined("Form.name") and Len(Trim(Form.name)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "name=" & Form.name>
</cfif>
<cfif isdefined("Form.desc") and Len(Trim(Form.desc)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "desc=" & Form.desc>
</cfif>
<cfif isdefined("Form.conexion") and Len(Trim(Form.conexion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "conexion=" & Form.conexion>
</cfif>


<html>
<head>
<title>Lista de Puestos por Empresa Encuestadora</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
	<form name="filtroEmpleado" method="post" action="#GetFileFromPath(GetTemplatePath())#">
		<input type="hidden" name="EEid" 	value="#form.EEid#">
		<input type="hidden" name="form" 	value="#Form.form#">
		<input type="hidden" name="name" 	value="#Form.name#">
		<input type="hidden" name="desc" 	value="#Form.desc#">
		<input type="hidden" name="id" 		value="#Form.id#">
		<input type="hidden" name="conexion" value="#Form.conexion#">
		
		<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>C&oacute;digo</strong></td>
				<td> 
					<input name="EPcodigo_F" type="text" id="name" size="10" maxlength="10" value="<cfif isdefined("Form.EPcodigo_F")>#Form.EPcodigo_F#</cfif>">
				</td>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td> 
					<input name="EPdescripcion_F" type="text" id="desc" size="40" maxlength="80" value="<cfif isdefined("Form.EPdescripcion_F")>#Form.EPdescripcion_F#</cfif>">
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>

	<cfquery name="lista" datasource="#form.conexion#">
		select EPid,a.EEid,rtrim(ltrim(a.EPcodigo)) as EPcodigo,a.EPdescripcion, ea.EAdescripcion, ea.EAid
		from EncuestaPuesto a 
				inner join EncuestaEmpresa b
					on a.EEid = b.EEid		
			inner join EmpresaArea ea
				on ea.EAid = a.EAid
		where a.EEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
			<cfif isdefined("Form.EPcodigo_F") and Len(Trim(Form.EPcodigo_F)) NEQ 0>
				 and upper(EPcodigo) like '%#UCase(Form.EPcodigo_F)#%'
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EPcodigo_F=" & Form.EPcodigo_F>
			</cfif>
					
			<cfif isdefined("Form.EPdescripcion_F") and Len(Trim(Form.EPdescripcion_F)) NEQ 0>
				 and upper(EPdescripcion) like '%#UCase(Form.EPdescripcion_F)#%'
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EPdescripcion_F=" & Form.EPdescripcion_F>
			</cfif>
		order by ea.EAid,a.EPcodigo,a.EPdescripcion		
	</cfquery>

	<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
		query="#lista#"
		desplegar="EPcodigo,EPdescripcion"
		etiquetas=" ,Puesto"
		formatos="S,S"
		align="left,left"
		ira="ConlisPuestoEnc.cfm"
		showEmptyListMsg="true"
		cortes="EAdescripcion"
		keys="EPid"
		navegacion="#navegacion#"
		formName="listaPuestoEnc"
		MaxRows="15"
		funcion="Asignar"
		fparams="EPid, EPcodigo, EPdescripcion"
		Conexion="#Form.conexion#"
	/>		
</body>
</html>
