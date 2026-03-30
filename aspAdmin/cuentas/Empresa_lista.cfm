<cfparam name="url.Ecodigo2" default="">
<cfparam name="form.Ecodigo2" default="#url.Ecodigo2#">

<cfif form.Ecodigo2 EQ "" OR isdefined("form.modo") and form.modo EQ "LISTA">
	<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
		<cfinclude template="Empresa_form.cfm">
		<cfexit> 
	</cfif>
<cfelse>
	<cfparam name="form.modo" default="CAMBIO">
	<cfinclude template="Empresa_form.cfm">
	<cfexit> 
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtroEmpresas.fNombreC.value = "";
	}

</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Empresas</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="filtroEmpresas" style="margin:0;" action="CuentaPrincipal_tabs.cfm" method="post">
				<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr> 
              <td align="right"><b>Nombre Comercial:&nbsp;</b></td>
						
              <td><input name="fNombreC" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fNombreC") and len(trim(form.fNombreC)) gt 0>#form.fNombreC#</cfif>" > 
              </td>

						
              <td align="right"><b>Identificacion:&nbsp;</b></td>
						<td><input name="fidentificacion" type="text" size="20" maxlength="30" value="<cfif isdefined("form.fidentificacion") and len(trim(form.fidentificacion)) gt 0>#form.fidentificacion#</cfif>" >
              </td>
						<td align="right"></td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td><input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
					</tr>
				</table>
			</form>
			</cfoutput>

			<cfset select = "convert(varchar, e.cliente_empresarial) as cliente_empresarial, e.identificacion, convert(varchar, e.Ecodigo) as Ecodigo2, e.nombre_comercial" >
			<cfset from   = "CuentaClienteEmpresarial cce, Empresa e" >

			<cfset where = "cce.cliente_empresarial = #form.cliente_empresarial#
					    and e.cliente_empresarial = cce.cliente_empresarial
						and e.activo = 1">

			<cfif session.tipoRolAdmin EQ "">
				<cfabort>
			<cfelseif session.tipoRolAdmin EQ "sys.agente">
				<cfset where = where & " and cce.agente = #session.Usucodigo#
										 and cce.agente_loc = '#session.Ulocalizacion#'">
			<cfelseif session.tipoRolAdmin EQ "sys.adminCuenta">
				<cfset where = where & " and exists (select 1 from UsuarioEmpresarial ue
										 			  where ue.cliente_empresarial = cce.cliente_empresarial
													    and ue.Usucodigo = #session.Usucodigo#
														and ue.Ulocalizacion = '#session.Ulocalizacion#'
														and ue.admin = 1)">
			</cfif>

            <cfif isdefined("form.Filtrar") and isdefined("form.fNombreC") and len(trim(form.fNombreC)) gt 0>
				<cfset where = where & " and upper(e.nombre_comercial) like upper('%#form.fNombreC#%')" >
			</cfif> 

            <cfif isdefined("form.Filtrar") and isdefined("form.fidentificacion") and len(trim(form.fidentificacion)) gt 0>
				<cfset where = where & " and upper(e.identificacion) like upper('%#form.fidentificacion#%')" >
			</cfif> 

			<cfset where = where & " order by upper(cce.nombre), upper(e.nombre_comercial) " >
			
			<cfinvoke 
			 component="aspAdmin.Componentes.pListasASP"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
				<cfinvokeargument name="desplegar" value="nombre_comercial,identificacion"/>
				<cfinvokeargument name="etiquetas" value="Empresa,Identificacion"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="formName" value="formListaEmpresas"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="CuentaPrincipal_tabs.cfm"/>
				<cfinvokeargument name="Conexion" value="#session.DSN#"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<!---<cfinvokeargument name="keys" value="Ecodigo2"/>--->
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<!---<cfinvokeargument name="Cortes" value="nombre"/>--->
				<cfinvokeargument name="showEmptyListMsg" value="true"/> 
				<cfinvokeargument name="botones" value="Agregar"/> 
			</cfinvoke>
		</td>
	</tr>
</table>
<script language="JavaScript1.2" type="text/javascript">
	function funcAgregar(){
		document.formListaEmpresas.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
	}
</script>
