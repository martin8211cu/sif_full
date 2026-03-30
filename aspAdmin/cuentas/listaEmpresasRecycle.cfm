<script language="JavaScript1.2" type="text/javascript">
	function limpiar(){
		document.filtroEmpresas.fNombre.value  = "";
		document.filtroEmpresas.fNombreC.value = "";
		document.filtroEmpresas.fCuenta.value  = "";
	}
</script>

<cfif isdefined("url.cliente_empresarial") and not isdefined("form.cliente_empresarial") >
	<cfset form.cliente_empresarial = url.cliente_empresarial >
</cfif>

<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">

<table width="100%" cellpadding="0" cellspacing="0">
	<tr class="itemtit"><td colspan="2"><font size="2"><b>Lista de Empresas Inactivas</b></font></td></tr>
	
	<tr><td colspan="2">&nbsp;</td></tr>

	<tr>				
		<td valign="top">
			<cfoutput>
			<form name="filtroEmpresas" style="margin:0;" action="listaEmpresasRecycle.cfm" method="post">
				<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
				<table width="100%" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
					<tr>
						<td align="right"><b>Nombre:&nbsp;</b></td>
						<td><input name="fNombre" type="text" size="40" maxlength="30" value="<cfif isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>#form.fNombre#</cfif>" ></td>
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

			<table width="100%">
				<tr>
					<td width="1%"><input type="checkbox" name="chkall" value="T" onClick="javascript:check_all( this );"></td>
				 	<td valign="middle"><b>Seleccionar Todo</b></td>
				</tr>	
			</table>

			<cfset select = "convert(varchar, e.Ecodigo) as Ecodigo2, convert(varchar, u.Usucuenta) as Usucuenta, e.nombre_comercial, cce.nombre, cce.cliente_empresarial, paramPrueba='Valor de prueba'">
			<cfset from   = "Empresa e, CuentaClienteEmpresarial cce, Usuario u" >
			<!--- Descomentar para websdc--->
			<cfset where = "e.Usucodigo = u.Usucodigo
			  			and e.Ulocalizacion = u.Ulocalizacion
					    and e.cliente_empresarial = cce.cliente_empresarial
						and e.activo = 0
						and ((cce.agente = #session.Usucodigo#
						and cce.agente_loc = '#session.Ulocalizacion#')
						or exists (select id from UsuarioPermiso
						where rol = 'sys.pso'
						and Usucodigo = #session.Usucodigo#
						and Ulocalizacion = '#session.Ulocalizacion#'))" >
			

			<!---<cfset where = "e.Usucodigo = u.Usucodigo
			  			and e.Ulocalizacion = u.Ulocalizacion
					    and e.cliente_empresarial = cce.cliente_empresarial
						and e.activo = 0
						and ((cce.agente = 1
						and cce.agente_loc = '00')
						or exists (select id from UsuarioPermiso
						where rol = 'sys.pso'
						and Usucodigo = 1
						and Ulocalizacion = '00'))" > --->

			<cfif isdefined("form.Filtrar") and isdefined("form.fNombre") and len(trim(form.fNombre)) gt 0>
				<cfset where = where & " and upper(cce.nombre) like upper('%#form.fNombre#%')" >
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
				<cfinvokeargument name="Conexion" value="sdc2"/>
				<cfinvokeargument name="MaxRows" value="30"/>
				<cfinvokeargument name="keys" value="Ecodigo2"/>
				<cfinvokeargument name="navegacion" value="botonSel=Buscar"/>
				<!---<cfinvokeargument name="Cortes" value="nombre"/>--->
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="showLink" value="false"/>
				<cfinvokeargument name="botones" value="Activar,Eliminar"/>
				<cfinvokeargument name="checkboxes" value="S"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">

	function funcActivar(){
		if ( checkeados() ){
			if (confirm('Va a activar a los usuarios seleccionados. Desde continuar?')){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';
				document.lista.action = 'Empresa_SQL.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay empresas seleccionados para el proceso.');
		}	

		return false;	
	}

	function funcEliminar(){
		if ( checkeados() ){
			if ( confirm('Va a eliminar permanentemente a las empresas seleccionados. Desde continuar?' ) ){
				document.lista.CLIENTE_EMPRESARIAL.value = '<cfoutput>#form.cliente_empresarial#</cfoutput>';			
				document.lista.action = 'Empresa_SQL.cfm';
				document.lista.submit();
				return true;
			}
		}
		else{
			alert('No hay empresas seleccionados para el proceso.');
		}	

		return false;
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

	function check_all(obj){
		var form = eval('lista');
		
		if (existe(form, "chk")){
			if (obj.checked){
				if (form.chk.length){
					for (var i=0; i<form.chk.length; i++){
						form.chk[i].checked = "checked";
					}
				}
				else{
					form.chk.checked = "checked";
				}
			}	
		}
	}

	function checkeados(){
		var form = eval('lista');
		
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

</script>