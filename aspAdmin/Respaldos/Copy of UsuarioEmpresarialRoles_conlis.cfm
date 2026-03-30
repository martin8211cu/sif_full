<cfif isdefined("Url.paramUsucodigo") and not isdefined("Form.paramUsucodigo")>
	<cfparam name="Form.paramUsucodigo" default="#Url.paramUsucodigo#">
</cfif>
<cfif isdefined("Url.paramUlocalizacion") and not isdefined("Form.paramUlocalizacion")>
	<cfparam name="Form.paramUlocalizacion" default="#Url.paramUlocalizacion#">
</cfif>
<cfif isdefined("Url.paramClienteEmpresarial") and not isdefined("Form.paramClienteEmpresarial")>
	<cfparam name="Form.paramClienteEmpresarial" default="#Url.paramClienteEmpresarial#">
</cfif>
<cfif isdefined("Url.paramNewForm") and not isdefined("Form.paramNewForm")>
	<cfparam name="Form.paramNewForm" default="#Url.paramNewForm#">
</cfif>
<cfif isdefined("Url.paramEmpresa") and not isdefined("Form.paramEmpresa")>
	<cfparam name="Form.paramEmpresa" default="#Url.paramEmpresa#">
</cfif>
<cfif isdefined("Url.filtro_Empresa") and not isdefined("Form.filtro_Empresa")>
	<cfparam name="Form.filtro_Empresa" default="#Url.filtro_Empresa#">
</cfif>
<cfif isdefined("Url.filtro_Roles") and not isdefined("Form.filtro_Roles")>
	<cfparam name="Form.filtro_Roles" default="#Url.filtro_Roles#">
</cfif>

<cfquery name="rsRolesXEmpresaAll" datasource="#session.DSN#">
	Select distinct (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo) + '~' + r.sistema + '~' + nombre_comercial) as CodRol
		, convert(varchar,e.Ecodigo)  as Ecodigo
		,nombre_comercial
		,rtrim(r.rol) as rol
		, r.descripcion
	from Empresa e,
		EmpresaModulo em,
		Modulo m,
		Rol r
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.paramClienteEmpresarial#">
		<cfif isdefined("Form.paramEmpresa") and form.paramEmpresa NEQ ''>
			and e.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.paramEmpresa#">
		</cfif>	
		and e.Ecodigo=em.Ecodigo
		and em.modulo=m.modulo
		and m.sistema=r.sistema
		and (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo))  not in (
			Select (rtrim(up.rol) + '~' + convert(varchar,emp.Ecodigo))
			from UsuarioPermiso up,
				Empresa emp,
				Rol r
			where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.paramUsucodigo#">
				and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.paramUlocalizacion#">
				and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.paramClienteEmpresarial#">
				and up.Ecodigo=emp.Ecodigo
				and up.rol=r.rol
		)
	order by nombre_comercial,descripcion
</cfquery>

<cfif isdefined('rsRolesXEmpresaAll') and rsRolesXEmpresaAll.recordCount GT 0>
	<cfquery name="rsEmpresasAll" dbtype="query">
		select distinct Ecodigo,nombre_comercial
		from rsRolesXEmpresaAll
		order by nombre_comercial	
	</cfquery>
	<cfquery name="rsRolesAll" dbtype="query">
		select distinct rol,descripcion
		from rsRolesXEmpresaAll
		order by descripcion	
	</cfquery>
</cfif>

<cfset filtro = "cliente_empresarial = #Form.paramClienteEmpresarial#">
<cfif isdefined('form.paramEmpresa') and form.paramEmpresa NEQ ''>
	<cfset filtro = filtro & " and e.Ecodigo=#Form.paramEmpresa#">
</cfif> 
	
<cfset filtro = filtro & "
				and e.Ecodigo=em.Ecodigo
				and em.modulo=m.modulo
				and m.sistema=r.sistema
				and (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo))  not in (
					Select (rtrim(up.rol) + '~' + convert(varchar,emp.Ecodigo))
					from UsuarioPermiso up,
						Empresa emp,
						Rol r
					where up.Usucodigo = #Form.paramUsucodigo#
						and up.Ulocalizacion = '#Form.paramUlocalizacion#'
						and up.cliente_empresarial = #Form.paramClienteEmpresarial#
						and up.Ecodigo=emp.Ecodigo
						and up.rol=r.rol
				)">
<cfset navegacion = "">
<cfif isdefined("Form.filtro_Empresa") and Len(Trim(Form.filtro_Empresa)) NEQ 0 and Form.filtro_Empresa NEQ '-1'>
	<cfset filtro = filtro & " and e.Ecodigo=" & #Form.filtro_Empresa#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtro_Empresa=" & Form.filtro_Empresa>
</cfif>
<cfif isdefined("Form.filtro_Roles") and Len(Trim(Form.filtro_Roles)) NEQ 0 and Form.filtro_Roles NEQ '-1'>
 	<cfset filtro = filtro & " and r.rol='" & #Form.filtro_Roles# & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtro_Roles=" & Form.filtro_Roles>
</cfif>
<cfif isdefined("Form.paramUlocalizacion") and Len(Trim(Form.paramUlocalizacion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paramUlocalizacion=" & Form.paramUlocalizacion>
</cfif>
<cfif isdefined("Form.paramClienteEmpresarial") and Len(Trim(Form.paramClienteEmpresarial)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paramClienteEmpresarial=" & Form.paramClienteEmpresarial>
</cfif>
<cfif isdefined("Form.paramUsucodigo") and Len(Trim(Form.paramUsucodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paramUsucodigo=" & Form.paramUsucodigo>
</cfif>



<html>
<head>
<title>Lista de Roles</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/sif.css" rel="stylesheet" type="text/css">

<script language="JavaScript" type="text/javascript">
function Asignar(key, desc, empre) {
	if (window.opener != null) {
		<cfif not isdefined('form.paramNewForm')>
			var varTodoCorrecto = true;
			<cfoutput>
				window.opener.document.formEmpresasHabil.valueNuevoPermiso.value = key;		
				window.opener.document.formEmpresasHabil.nuevoPermiso.value = desc;					
				window.opener.document.formEmpresasHabil.LabelEmpresa.value = empre;								
				window.opener.document.formEmpresasHabil.Agregar.value = '1';
			</cfoutput>
			if(window.opener.document.formEmpresasHabil.valueNuevoPermiso.value != '') {
				window.opener.cambioPermiso(window.opener.document.formEmpresasHabil.valueNuevoPermiso);
				if(window.opener.banderaValida)
					varTodoCorrecto = window.opener.valida();
			} else {
				window.status = 'not value';
			}
			
		//	if(varTodoCorrecto)
		//		window.opener.document.formEmpresasHabil.submit();										
		<cfelse>
			<cfoutput>
				window.opener.document.formRolesXUsuario.valueNuevoPermiso.value = key;		
				window.opener.document.formRolesXUsuario.Agregar.value = '1';
			</cfoutput>
			if(window.opener.document.formRolesXUsuario.valueNuevoPermiso.value != '') {
				window.opener.cambioPermiso(window.opener.document.formRolesXUsuario.valueNuevoPermiso);
			} else {
				window.status = 'not value';
			}			
			
			window.opener.document.formRolesXUsuario.submit();		
		</cfif>
		
		
		window.close();
	} else {
		window.status = 'no opener';
	}
}
</script>
</head>
<body>
<cfoutput>
	<form name="formFiltroRoles" action="UsuarioEmpresarialRoles_conlis.cfm" method="post">
		<input type="hidden" name="paramUsucodigo" id="paramUsucodigo" value="<cfif isdefined('form.paramUsucodigo') and form.paramUsucodigo NEQ ''>#form.paramUsucodigo#</cfif>">
		<input type="hidden" name="paramUlocalizacion" id="paramUlocalizacion" value="<cfif isdefined('form.paramUlocalizacion') and form.paramUlocalizacion NEQ ''>#form.paramUlocalizacion#</cfif>">		
		<input type="hidden" name="paramClienteEmpresarial" id="paramClienteEmpresarial" value="<cfif isdefined('form.paramClienteEmpresarial') and form.paramClienteEmpresarial NEQ ''>#form.paramClienteEmpresarial#</cfif>">				
		<cfif isdefined('form.paramNewForm') and form.paramNewForm NEQ ''>
			<input type="hidden" name="paramNewForm" id="paramNewForm" value="#form.paramNewForm#">
		</cfif>
		<input type="hidden" name="paramEmpresa" id="paramEmpresa" value="<cfif isdefined('form.paramEmpresa') and form.paramEmpresa NEQ ''>#form.paramEmpresa#</cfif>">						
	
		<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td width="11%" align="right"><strong>Empresa</strong></td>
				<td width="20%"> 
					<select name="filtro_Empresa" <cfif isdefined('form.paramNewForm') and form.paramNewForm NEQ ''> disabled</cfif>>
						<option value="-1">-- TODAS --</option>			
						<cfif isdefined('rsEmpresasAll') and rsEmpresasAll.recordCount GT 0>							
							<cfloop query="rsEmpresasAll">
							  <option value="#rsEmpresasAll.Ecodigo#" <cfif isdefined('form.filtro_Empresa') and form.filtro_Empresa EQ rsEmpresasAll.Ecodigo> selected</cfif>>#rsEmpresasAll.nombre_comercial#</option>
							</cfloop>
						</cfif>							
					</select>
				</td>
				<td width="10%" align="right"><strong>Rol</strong></td>
				<td width="47%"> 
					<select name="filtro_Roles">
						<option value="-1">-- TODOS --</option>			
						<cfif isdefined('rsRolesAll') and rsRolesAll.recordCount GT 0>
							<cfloop query="rsRolesAll">
							  <option value="#rsRolesAll.rol#" <cfif isdefined('form.filtro_Roles') and form.filtro_Roles EQ rsRolesAll.rol> selected</cfif>>#rsRolesAll.descripcion#</option>
							</cfloop>					
						</cfif>
					</select>
				</td>
				<td width="12%" align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
</cfoutput> 

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pLista"
 returnvariable="pListaMarcasMod">
	<cfinvokeargument name="tabla" value="Empresa e,
			EmpresaModulo em,
			Modulo m,
			Rol r"/>
	<cfinvokeargument name="columnas" value="
		distinct (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo) + '~' + r.sistema + '~' + nombre_comercial) as CodRol
		,nombre_comercial
		, r.descripcion	
	"/>
	<cfinvokeargument name="desplegar" value="descripcion"/>
	<cfinvokeargument name="etiquetas" value="Descripción de los roles no asignados al usuario"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
				#filtro# 
			order by nombre_comercial,descripcion"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="UsuarioEmpresarialRoles_conlis.cfm"/>
	<cfinvokeargument name="formName" value="listaRoles"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CodRol,descripcion,nombre_comercial"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#session.DSN#"/>
	<cfinvokeargument name="Cortes" value="nombre_comercial"/>	
	<cfinvokeargument name="debug" value="N"/>		
	
</cfinvoke>
</body>
</html>