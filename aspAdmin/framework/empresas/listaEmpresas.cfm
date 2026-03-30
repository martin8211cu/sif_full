<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtro.fcliente_empresarial.value  = "";
		document.filtro.fNombreC.value = "";
		document.filtro.fCuenta.value  = "";
	}

</script>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<cfquery name="rsCuentas" datasource="sdc">
	select cliente_empresarial, nombre from CuentaClienteEmpresarial
	where (agente = 1
	  and agente_loc = '00')
	  or exists (select id from UsuarioPermiso
	  where rol = 'sys.pso'
	  and Usucodigo = 1
	  and Ulocalizacion = '00')
	  and rtrim(nombre) != ' '
	  and activo = 1
	order by upper(nombre)
</cfquery>

<cfif ( isdefined("form.cliente_empresarial") and len(trim(form.cliente_empresarial)) gt 0 ) and not isdefined("form.fcliente_empresarial")>
	<cfset form.fcliente_empresarial = form.cliente_empresarial>
</cfif>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Empresas</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="filtro" style="margin:0;" action="listaEmpresas.cfm" method="post">
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right"><b>Nombre:&nbsp;</b></td>
						<td>
							<select name="fcliente_empresarial">
								<option value="" selected>--- Todas ---</option>
								<cfloop query="rsCuentas">
									<option value="#rsCuentas.cliente_empresarial#" <cfif isdefined("form.fcliente_empresarial") and form.fcliente_empresarial eq rsCuentas.cliente_empresarial>selected</cfif> >#rsCuentas.nombre#</option>
								</cfloop>
							</select>
						</td>

						<td align="right"><b>Nombre Comercial:&nbsp;</b></td>
						<td><input name="fNombreC" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fNombreC") and len(trim(form.fNombreC)) gt 0>#form.fNombreC#</cfif>" ></td>
						<td align="right"><b>Cuenta:&nbsp;</b></td>
						<td><input name="fCuenta" type="text" size="10" maxlength="10" value="<cfif isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>#form.fCuenta#</cfif>" ></td>
						<td><input type="submit" name="Filtrar" value="Filtrar"></td>
						<td><input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
					</tr>
				</table>
			</form>
			</cfoutput>

			<cfset select = "convert(varchar, e.Ecodigo) as Ecodigo2, convert(varchar, u.Usucuenta) as Usucuenta, e.nombre_comercial, cce.nombre" >
			<cfset from   = "Empresa e, CuentaClienteEmpresarial cce, Usuario u" >
			<!--- Descomentar para websdc
			<cfset where = "e.Usucodigo = u.Usucodigo
			  			and e.Ulocalizacion = u.Ulocalizacion
					    and e.cliente_empresarial = cce.cliente_empresarial
						and e.activo = 1
						and ((cce.agente = #session.Usucodigo#
						and cce.agente_loc = '#session.Ulocalizacion#')
						or exists (select id from UsuarioPermiso
						where rol = 'sys.pso'
						and Usucodigo = #session.Usucodigo#
						and Ulocalizacion = '#session.Ulocalizacion#'))" >
			--->

			<cfset where = "e.Usucodigo = u.Usucodigo
			  			and e.Ulocalizacion = u.Ulocalizacion
					    and e.cliente_empresarial = cce.cliente_empresarial
						and e.activo = 1
						and ((cce.agente = 1
						and cce.agente_loc = '00')
						or exists (select id from UsuarioPermiso
						where rol = 'sys.pso'
						and Usucodigo = 1
						and Ulocalizacion = '00'))" >

			<!---
			<cfif isdefined("form.cliente_empresarial") and len(trim(form.cliente_empresarial)) gt 0>
				<cfset where = where & " and cce.cliente_empresarial = #form.cliente_empresarial# ">
			</cfif>
			--->

			<cfif isdefined("form.fcliente_empresarial") and len(trim(form.fcliente_empresarial)) gt 0>
				<cfset where = where & " and cce.cliente_empresarial = #form.fcliente_empresarial#" >
			</cfif> 

			<cfif isdefined("form.Filtrar") and isdefined("form.fNombreC") and len(trim(form.fNombreC)) gt 0>
				<cfset where = where & " and upper(e.nombre_comercial) like upper('%#form.fNombreC#%')" >
			</cfif> 

			<cfif isdefined("form.Filtrar") and isdefined("form.fCuenta") and len(trim(form.fCuenta)) gt 0>
				<cfset where = where & " and upper(u.Usucuenta) like upper('%#form.fCuenta#%')" >
			</cfif> 
			
			<cfset where = where & " order by upper(cce.nombre), upper(e.nombre_comercial) " >
			
			<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pLista"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="#from#"/>
				<cfinvokeargument name="columnas" value="#select#"/>
				<cfinvokeargument name="desplegar" value="nombre,nombre_comercial,Usucuenta"/>
				<cfinvokeargument name="etiquetas" value="Cuenta Empresarial,Empresa,Cuenta"/>
				<cfinvokeargument name="formatos" value="V,V,V"/>
				<cfinvokeargument name="filtro" value="#where#"/>
				<cfinvokeargument name="align" value="left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Empresas.cfm"/>
				<cfinvokeargument name="Conexion" value="sdc"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<!---<cfinvokeargument name="keys" value="Ecodigo2"/>--->
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<!---<cfinvokeargument name="Cortes" value="nombre"/>--->
				<cfinvokeargument name="showEmptyListMsg" value="true"/> 
				<cfinvokeargument name="botones" value="Regresar"/> 
			</cfinvoke>
		</td>
	</tr>
</table>