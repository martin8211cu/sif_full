<cfquery name="rsDatosAct" datasource="#session.DSN#">
	Select convert(varchar,up.id) as id,
		up.Ecodigo,
		referencia,
		etiqueta_referencia,	
		campoRef =
			case
				when referencia ='N' then num_referencia
				when referencia ='I' then int_referencia
--				when referencia='0' then 0
			end ,
		nombre_comercial,
		up.rol,
		r.descripcion
	from UsuarioPermiso up,
		Empresa e,
		Rol r	
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
		and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		and up.Ecodigo=e.Ecodigo
		and up.rol=r.rol
	order by up.Ecodigo,rol
</cfquery> 

<cfif isdefined('rsDatosAct') and rsDatosAct.recordCount GT 0>
	<cfquery dbtype="query" name="rsEmpreAct">
		Select distinct Ecodigo, nombre_comercial
		from rsDatosAct
	</cfquery>
</cfif>

<cfquery name="rsRolesXEmpresa" datasource="#session.DSN#">
	Select distinct (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo)) as CodRol
		,nombre_comercial,
		r.descripcion
	from Empresa e,
		EmpresaModulo em,
		Modulo m,
		Rol r
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		and e.Ecodigo=em.Ecodigo
		and em.modulo=m.modulo
		and m.sistema=r.sistema
		and (rtrim(r.rol) + '~' + convert(varchar,e.Ecodigo))  not in (
			Select (rtrim(up.rol) + '~' + convert(varchar,emp.Ecodigo))
			from UsuarioPermiso up,
				Empresa emp,
				Rol r
			where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
				and up.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
				and up.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
				and up.Ecodigo=emp.Ecodigo
				and up.rol=r.rol
				and r.referencia not in ('N','I')
		)
	order by nombre_comercial,descripcion
</cfquery>

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


<link href="../../css/sif.css" rel="stylesheet" type="text/css">

<link href="../../css/estilos.css" rel="stylesheet" type="text/css">
<form name="formEmpresasHabil" method="post" action="SQLEmpresasHabil.cfm" style="margin: 0;" onSubmit="return valida(this);">
		<cfoutput>
			<input type="hidden" name="Usucodigo" id="Usucodigo" value="#form.Usucodigo#">
			<input type="hidden" name="Ulocalizacion" id="Ulocalizacion" value="#form.Ulocalizacion#">	
			<input type="hidden" name="cliente_empresarial" id="cliente_empresarial" value="#form.cliente_empresarial#">	
		</cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		   <td width="5%" valign="top">&nbsp;</td>
			<td width="50%" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<cfif isdefined('rsEmpreAct') and rsEmpreAct.recordCount GT 0>
						<cfoutput>
								<tr>
									<td colspan="3" class="tituloAlterno">Roles Actuales</td>
								</tr>	
							<cfset etiqRef = ''>
							<cfset contPerm = 0>				
							<cfloop query="rsEmpreAct">
								<tr>
									<td colspan="3" class="subTitulo">
										#rsEmpreAct.nombre_comercial#
									</td>
								</tr>
								<cfquery dbtype="query" name="rsPermAct">
									Select id, rol, descripcion,etiqueta_referencia,campoRef
									from rsDatosAct
									where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpreAct.Ecodigo#">
								</cfquery>																		
								<cfif isdefined('rsPermAct') and rsPermAct.recordCount GT 0>						
									<cfloop query="rsPermAct">
										<cfset contPerm = contPerm + 1>
										
										<cfif rsPermAct.etiqueta_referencia NEQ ''>
											<cfset etiqRef = #rsPermAct.etiqueta_referencia# & ': '>
										<cfelse>
											<cfset etiqRef = ''>
									  </cfif>
	
										<tr>
											<td align="center" nowrap><!--- #rsPermAct.id# --  ---><input type="checkbox" name="permiso_#contPerm#" value="#rsPermAct.id#"></td>
											<td>#rsPermAct.descripcion#</td>
											<td>#etiqRef##rsPermAct.campoRef#</td>
										</tr>
									</cfloop>
								</cfif>
							</cfloop>
							
							<input type="hidden" name="totPermisos" id="totPermisos" value="#contPerm#">
							
						  <tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td colspan="3" align="center">
								<input type="submit" name="btnQuitar" value="Quitar" onclick="javascript: setBtn(this); if ( confirm('¿Desea Quitar el Permiso?') ){ return true; }else{ return false;}">								
							</td>
						  </tr>
					</cfoutput>
				  </cfif>				  				    
				</table>			
			</td>
			<td width="50%" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="3" align="center" class="tituloAlterno">Nuevo Rol</td>
				  </tr>
				  <tr>
					<td width="10%">&nbsp;</td>
					<td width="14%">&nbsp;</td>
				    <td width="76%">&nbsp;</td>
				  </tr>
				  <tr>
				    <td>&nbsp;</td>				  
					<td><strong>Permiso</strong></td>
					<td>
					<select name="nuevoPermiso" id="nuevoPermiso" onChange="javascript: cambioPermiso(this)">
						<cfoutput group="nombre_comercial" query="rsRolesXEmpresa">
							<optgroup label="#rsRolesXEmpresa.nombre_comercial#">
								<cfoutput>
								  	<option value="#rsRolesXEmpresa.CodRol#">#rsRolesXEmpresa.descripcion#</option>
								</cfoutput>
							</optgroup>
						</cfoutput>
				    </select></td>
				  </tr>
					  <tr id="divReferencia">
						<td>&nbsp;</td>
						<td><input name="LabelReferencia" class="cajasinbordeb" id="LabelReferencia" type="text" value="" size="40" maxlength="40"></td>
						<td>
							<input type="hidden" value="" name="referencia" id="referencia">
							
							<input tabindex="0" 
								name="num_int_referencia" 
								id="num_int_referencia"
								type="text" 
								style="text-align: right;" 
								onFocus="javascript:this.value=qf(this); this.select();" 
								onBlur="javascript: fm(this,-1);" 
								onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
								value="" 
								size="30" 
								maxlength="14">
						</td>
					  </tr>
				  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>					  
				  <tr>
					<td colspan="3" align="center"><input onClick="javascript: setBtn(this);" name="btnAgregar" type="submit" id="btnAgregar" value="Agregar"></td>
				  </tr>				  
				</table>
			</td>
		  </tr>
		</table>
</form>
<cfquery dbtype="query" name="rsPermAct_valida">
	Select Ecodigo, rol, campoRef
	from rsDatosAct
	where referencia in ('N','I')
</cfquery>

<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript">
	arrRolesConRef = new Array();	
	
	// Todos los roles que poseen referencia
	<cfoutput>
		<cfloop query="rsRolesConRef">	
			arrRolesConRef[arrRolesConRef.length] = '#rsRolesConRef.rol#'
													+ '~'
													+ '#rsRolesConRef.referencia#'
													+ '~'													
													+ '#rsRolesConRef.etiqueta_referencia#';
		</cfloop>
	</cfoutput>
//-------------------------------------------------------------------------------------------		
	// Para la validacion del campo de num_int_referencia de los roles con referencia = a N o I
	var banderaValida = false;
	
	function valida(f){
		if(botonActual=='btnAgregar' && banderaValida){
			if(f.num_int_referencia.value == ''){
				alert('Error, el campo ' + f.LabelReferencia.value + ' es requerido');
				f.num_int_referencia.focus;
				
				return false;
			}
			var arrNewPerm = f.nuevoPermiso.value.split('~');

			if(arrNewPerm.length > 0 && arrNewPerm[1] != ''){
				<cfif isdefined('rsPermAct_valida') and rsPermAct_valida.recordCount GT 0>
					<cfoutput query="rsPermAct_valida">
						if (#Trim(rsPermAct_valida.Ecodigo)# == arrNewPerm[1]) {					
							if (#Trim(rsPermAct_valida.campoRef)# == f.num_int_referencia.value) {
								alert('Error, el campo ' + f.LabelReferencia.value + ' ya existe para esta empresa, favor digitar uno diferente');
								return false;
							}
						}
					</cfoutput>				
				</cfif>
			}
		}
		
		return true;
	}
//-------------------------------------------------------------------------------------------		
	// Para Manejo de Botones
	var botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}	
//-------------------------------------------------------------------------------------------	
	function cambioPermiso(obj){
		var varDivReferencia  = document.getElementById('divReferencia');
		var p = null;
		var r = obj.value.split("~");
		var prende = false;
			
		for(var i=0;i<arrRolesConRef.length;i++){
			p = arrRolesConRef[i].split("~");
			
			if(r[0] == p[0]){ //si los roles son iguales, el seleccionado en el combo y el del arreglo de roles con referencia
				prende = true;
				obj.form.referencia.value = p[1];				
				obj.form.LabelReferencia.value = p[2];
				break;
			}
		}
				
		if(prende){
			banderaValida = true;
			varDivReferencia.style.display = '';
		}else{
			banderaValida = false;		
			varDivReferencia.style.display  = 'none';					
			obj.form.referencia.value = '0';
			obj.form.LabelReferencia.value = '';			
		}
	}
//-------------------------------------------------------------------------------------------	
	cambioPermiso(document.formEmpresasHabil.nuevoPermiso);
</script>
