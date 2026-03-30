<cfif isdefined("Url.Usucodigo") and not isdefined("Form.Usucodigo")>
	<cfparam name="Form.Usucodigo" default="#Url.Usucodigo#">
</cfif>
<cfif isdefined("Url.Ulocalizacion") and not isdefined("Form.Ulocalizacion")>
	<cfparam name="Form.Ulocalizacion" default="#Url.Ulocalizacion#">
</cfif>
<cfif isdefined("Url.cliente_empresarial") and not isdefined("Form.cliente_empresarial")>
	<cfparam name="Form.cliente_empresarial" default="#Url.cliente_empresarial#">
</cfif>

<cfif isdefined("Url.paramNewForm") and not isdefined("Form.paramNewForm")>
	<cfparam name="Form.paramNewForm" default="#Url.paramNewForm#">
</cfif>
<cfif isdefined("Url.paramEmpresa") and not isdefined("Form.paramEmpresa")>
	<cfparam name="Form.paramEmpresa" default="#Url.paramEmpresa#">
</cfif>
<cfif isdefined("Url.paramIdentifEmpleado") and not isdefined("Form.paramIdentifEmpleado")>
	<cfparam name="Form.paramIdentifEmpleado" default="#Url.paramIdentifEmpleado#">
</cfif>
<cfif isdefined("Url.filtro_Empresa") and not isdefined("Form.filtro_Empresa")>
	<cfparam name="Form.filtro_Empresa" default="#Url.filtro_Empresa#">
</cfif>
<cfif isdefined("Url.filtro_Roles") and not isdefined("Form.filtro_Roles")>
	<cfparam name="Form.filtro_Roles" default="#Url.filtro_Roles#">
</cfif>

<cfif isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ ''>
	<cfquery name="rsRolesConRef" datasource="#session.DSN#">
		Select distinct rtrim(r.rol) as rol, referencia,etiqueta_referencia
		from Empresa e,
			EmpresaModulo em,
			Modulo m,
			Rol r
		where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
			and e.Ecodigo=em.Ecodigo
			and em.modulo=m.modulo
			and m.sistema=r.sistema
			and r.referencia in ('N','I')
		order by rol
	</cfquery>
</cfif>

<cfquery name="rsRolesXEmpresaAll" datasource="#session.DSN#">
	Select distinct (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo) + '~' + r.sistema + '~' + nombre_comercial + '~' + referencia + '~*') as CodRol
		, convert(varchar,e.Ecodigo)  as Ecodigo
		,nombre_comercial
		,rtrim(r.rol) as rol
		, r.descripcion
	from Empresa e,
		EmpresaModulo em,
		Modulo m,
		Rol r
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cliente_empresarial#">
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
			where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
				and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ulocalizacion#">
				and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cliente_empresarial#">
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
</cfif>

<cfset filtro = "cliente_empresarial = #Form.cliente_empresarial#">
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
					where up.Usucodigo = #Form.Usucodigo#
						and up.Ulocalizacion = '#Form.Ulocalizacion#'
						and up.cliente_empresarial = #Form.cliente_empresarial#
						and up.Ecodigo=emp.Ecodigo
						and up.rol=r.rol
				)">
<cfset navegacion = "">
<cfif isdefined("Form.filtro_Empresa") and Len(Trim(Form.filtro_Empresa)) NEQ 0 and Form.filtro_Empresa NEQ '-1'>
	<cfset filtro = filtro & " and e.Ecodigo=" & #Form.filtro_Empresa#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtro_Empresa=" & Form.filtro_Empresa>
</cfif>
<cfif isdefined("Form.filtro_Roles") and Len(Trim(Form.filtro_Roles)) NEQ 0 and Form.filtro_Roles NEQ '-1'>
 	<cfset filtro = filtro & " and upper(r.descripcion) like upper('%" & Form.filtro_Roles & "%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtro_Roles=" & Form.filtro_Roles>
</cfif>
<cfif isdefined("Form.Ulocalizacion") and Len(Trim(Form.Ulocalizacion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ulocalizacion=" & Form.Ulocalizacion>
</cfif>
<cfif isdefined("Form.cliente_empresarial") and Len(Trim(Form.cliente_empresarial)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "cliente_empresarial=" & Form.cliente_empresarial>
</cfif>
<cfif isdefined("Form.Usucodigo") and Len(Trim(Form.Usucodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usucodigo=" & Form.Usucodigo>
</cfif>
<cfif isdefined("Form.paramIdentifEmpleado") and Len(Trim(Form.paramIdentifEmpleado)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "paramIdentifEmpleado=" & Form.paramIdentifEmpleado>
</cfif>



<html>
<head>
<title>Lista de Roles</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../../css/sif.css" rel="stylesheet" type="text/css">


</head>
<body>
<cfoutput>
	<form name="formFiltroRoles" action="UsuarioEmpresarialRoles_conlis.cfm" method="post">
		<input type="hidden" name="Usucodigo" id="Usucodigo" value="<cfif isdefined('form.Usucodigo') and form.Usucodigo NEQ ''>#form.Usucodigo#</cfif>">
		<input type="hidden" name="Ulocalizacion" id="Ulocalizacion" value="<cfif isdefined('form.Ulocalizacion') and form.Ulocalizacion NEQ ''>#form.Ulocalizacion#</cfif>">		
		<input type="hidden" name="cliente_empresarial" id="cliente_empresarial" value="<cfif isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ ''>#form.cliente_empresarial#</cfif>">				
		<input type="hidden" name="paramIdentifEmpleado" id="paramIdentifEmpleado" value="<cfif isdefined('form.paramIdentifEmpleado') and form.paramIdentifEmpleado NEQ ''>#form.paramIdentifEmpleado#</cfif>">						
		<input type="hidden" value="" name="num_int_referencia" id="num_int_referencia">
		<input type="hidden" value="" name="referencia" id="referencia">
		
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
					<input name="filtro_Roles" type="text" id="filtro_Roles" value="<cfif isdefined('form.filtro_Roles') and form.filtro_Roles NEQ ''>#form.filtro_Roles#</cfif>">
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
		distinct (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo) + '~' + r.sistema + '~' + nombre_comercial + '~' + referencia + '~*') as CodRol
		,nombre_comercial
		, r.descripcion
		, '' as Usucodigo
		, '' as Ulocalizacion
		, '' as cliente_empresarial
		, '' as identifEmpleado			
	"/>
	<cfinvokeargument name="desplegar" value="descripcion"/>
	<cfinvokeargument name="etiquetas" value="Descripción de los roles no asignados al usuario"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="
				#filtro# 
			order by nombre_comercial,descripcion"/>
	<cfinvokeargument name="align" value="left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="UsuarioEmpresarialRoles_sql.cfm"/>
	<cfinvokeargument name="formName" value="listaRoles"/>
	<cfinvokeargument name="MaxRows" value="13"/>
<!--- 	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="CodRol,descripcion,nombre_comercial"/> --->
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#session.DSN#"/>
	<cfinvokeargument name="Cortes" value="nombre_comercial"/>	
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="botones" value="Agregar,Cerrar"/>	
	<cfinvokeargument name="showLink" value="false"/>
	<cfinvokeargument name="checkboxes" value="S"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/> 
</cfinvoke>
</body>
</html>

<script language="JavaScript1.2" type="text/javascript">
	function funcCerrar(){
		window.close();
	}
	function funcAgregar(){
		<cfif isdefined('form.cierraWin') and form.cierraWin NEQ -1>
			window.close();
		</cfif>

		if ( checkeados() ){
			if ( confirm('Va a agregar los roles para el usuario seleccionado. Desde continuar?' ) ){
				document.listaRoles.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.listaRoles.USUCODIGO.value = '<cfoutput>#form.Usucodigo#</cfoutput>';				
				document.listaRoles.ULOCALIZACION.value = '<cfoutput>#form.Ulocalizacion#</cfoutput>';				
				<cfif isdefined('form.paramIdentifEmpleado') and form.paramIdentifEmpleado NEQ ''>
					document.listaRoles.IDENTIFEMPLEADO.value = '<cfoutput>#form.paramIdentifEmpleado#</cfoutput>';
				</cfif>

				return true;
			}
		}
		else{
			alert('No hay roles seleccionados para el proceso.');
		}	

		return false;
	}
	
	function checkeados(){
		var form = eval('listaRoles');
		
		if (existe(form, "chk")){
			if (form.chk.length){
				for (var i=0; i<form.chk.length; i++){
					if (form.chk[i].checked){
						return true;
					}
				}
				return false;
			}
			else{
				if (form.chk.checked){
					return true;
				}
				else{	
					return false;
				}	
			}
		}
	}	
	
	function existe(form, name){
	// RESULTADO
	// Valida la existencia de un objecto en el form
	
		if (form[name] != undefined) {
			return true
		}
		else{
			return false
		}
	}	
	<cfif isdefined('form.bandera') and form.bandera EQ 1>
		//window.opener.location.reload();
		//var LvarFrm = window.opener.document.forms.length - 2;
		//window.opener.document.forms[LvarFrm].action = "";
		//window.opener.document.forms[LvarFrm].submit();
		window.opener.fnRefrescar();
		funcCerrar();
	</cfif>	
</script>
