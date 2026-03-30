<!--- hacer una funcion con esto, para no tener los dos querys --->
<cfquery name="rsEmpresas" datasource="asp">
	select Ecodigo, Enombre 
	from Empresa 
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.progreso.CEcodigo#">
	order by Enombre
</cfquery>

<!--- Selecciona la primer empresa por default --->
<cfif not isdefined("form.fEmpresa")>
	<cfif rsEmpresas.RecordCount gt 0>
		<cfset form.fEmpresa = rsEmpresas.Ecodigo>
	<cfelse>
		<cfset form.fEmpresa = -1>
	</cfif>
</cfif>

<cfquery name="rsEmpresas2" datasource="asp">
	select Ecodigo, Enombre 
	from Empresa 
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.progreso.CEcodigo#">
	<cfif isdefined("form.fEmpresa") and len((form.fEmpresa)) gt 0>
		and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEmpresa#">
	</cfif>
	order by Enombre
</cfquery>

<!--- Modulos por Cuenta Empresarial --->
<cfquery name="rsSistemas" datasource="asp">
	select distinct a.SScodigo, b.SSdescripcion
	from ModulosCuentaE a, SSistemas b
	where a.CEcodigo = #session.progreso.CEcodigo#
   	  and a.SScodigo=b.SScodigo
	  and exists (select 1 from SRoles c
		where c.SScodigo = b.SScodigo
		  and c.SRinterno = 0)
	order by SSdescripcion
</cfquery>

<!--- Sistemas por Cuenta Empresarial --->
<cfquery name="rsSistemas2" datasource="asp">
	select distinct a.SScodigo, b.SSdescripcion
	from ModulosCuentaE a, SSistemas b
	where a.CEcodigo = #session.progreso.CEcodigo#
	  and a.SScodigo = b.SScodigo
	  and exists (select 1 from SRoles c
		where c.SScodigo = b.SScodigo
		  and c.SRinterno = 0)
	<cfif isdefined("form.fSistema") and len((form.fSistema)) gt 0>
		and a.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#(form.fSistema)#">
	</cfif>
	
	order by SSdescripcion
</cfquery>

<cfquery name="rsUsuario" datasource="asp">
	select a.Pnombre, a.Papellido1, a.Papellido2
	from DatosPersonales a, Usuario b
	where a.datos_personales = b.datos_personales
	and b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
</cfquery>
<cfoutput>

<script language="javascript1.2" type="text/javascript">

	function check_empresa(obj, empresa){
	// RESULTADO
	// Marca los checks para todos los modulos y procesos de una empresa
		f = obj.form;
		
		for ( var i=0; i< f.elements.length; i++ ){
			if (f.elements[i].type == 'checkbox'){
				if ( f.elements[i].id.substring(0, f.elements[i].id.indexOf('|')) == empresa ){
					if (obj.checked){
						f.elements[i].checked = true;
					}
				}
			}
		}
	}

	function check(obj, empresa, sistema, cantidad){
		for ( var i=1; i<=cantidad; i++ ){
			var objeto = empresa + '|' + sistema + '|' +  i;
			
			if (obj.checked){
				document.getElementById(objeto).checked = true;
			}
			else{
				document.getElementById(objeto).checked = false;
			}
		}
		
		// verifica check de empresa
		var obj_empresa = document.getElementById(empresa);
		check_empresa2(obj_empresa,empresa);
		
	}

	function check_empresa2(obj, empresa){
	// RESULTADO
	// Marca el check de empresa si todas sus empresas y procesos estan marcados
		f = obj.form;
		
		for ( var i=0; i< f.elements.length; i++ ){
			if (f.elements[i].type == 'checkbox' || f.elements[i].name == 'sistema' ){
				if ( f.elements[i].id.substring(0, f.elements[i].id.indexOf('|')) == empresa){
					if ( !f.elements[i].checked){
						obj.checked=false;
						return;
					}
				}
			}
		}
		obj.checked=true;
		return
	}

	function check_sistema(obj, empresa, sistema, cantidad){
		// nada que ver con esta funcion pero se pone aqui
		//borrar(obj);

		var objeto = empresa + '|' + sistema;		// check de sistema
		var empresa2 = "empresa_" + empresa;		// empresa
		
		if (obj.checked){
			// VERIFICA LOS DEMAS OBJETOS PARA ESA EMPRESA Y SISTEMA ACTUAL
			for ( var i=1; i<=cantidad; i++ ){
				var objeto2 = empresa + '|' + sistema + '|' + i;		// check de roles
				if (!document.getElementById(objeto2).checked){
					document.getElementById(empresa2).value = "false";
					return;
				}
			}	
			document.getElementById(objeto).checked = true;
		}
		else{
			document.getElementById(objeto).checked = false;
			document.getElementById(empresa2).value = "false";
		}
		
		// verfica check de empresa
		var obj_empresa = document.getElementById(empresa);
		check_empresa2(obj_empresa,empresa );
		
	}

	function prueba(empresa, sistema, modo){
		document.getElementById(empresa+'|'+sistema+'|div').style.display = modo;
	}

	function imagen(obj, empresa, sistema){
		if (obj.name == 'menos'){
			obj.name = 'mas';
			obj.src = '../imagenes/mas.gif';
			prueba(empresa, sistema, 'none');
		}
		else{
			obj.name = 'menos';
			obj.src = '../imagenes/menos.gif';
			prueba(empresa, sistema, '');
		}
	}

	function filtrar(){
		document.form1.action = '';
		document.form1.submit();
	}

	function borrar(obj){
		// agrega el codigo del registro a borrar
		if (!obj.checked){
			document.form1.procesos_borrar.value = document.form1.procesos_borrar.value + obj.value + '*';
		}
	}

</script>

<form name="form1" method="post" action="Roles-sql.cfm" >
	<input type="hidden" name="ACCION" value="1">
	<input type="hidden" name="Usucodigo" value="#form.Usucodigo#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3">
			<table width="100%" cellpadding="3" cellspacing="0">
				<tr><td class="tituloPersona" align="center" bgcolor="##CCCCCC">
					<font size="3"><b><div align="center">Asignando Grupos de Procesos a:&nbsp;#rsUsuario.Pnombre# #rsUsuario.Papellido1# #rsUsuario.Papellido2#</div></b></font>
				</td></tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td colspan="3" bgcolor="##A0BAD3">
			<cfinclude template="frame-botones2.cfm">
		</td>
	  </tr>
	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>


	  <tr>
		<td width="20%" valign="top" class="textoAyuda">
			<b>Asignaci&oacute;n de Grupos de Procesos</b><br>
			Para asignar Grupos de Procesos al usuario, primero seleccione la empresa en la que va a trabajar. Luego marque el o los Grupos de Procesos que desea asociar al usuario y haga click al botón <font color="##0000FF">Aceptar</font>.<br><br>
			<b>Revocar Permisos</b><br>
			Para quitar Grupos de Procesos al usuario, desmarque el ó los Grupos de Procesos que va a revocar y haga click al botón <font color="##0000FF">Aceptar</font>.<br><br>
			<b>Trabajar con Cuenta o Usuarios diferentes al actual</b><br>
			Si desea trabajar una Cuenta Empresarial o un Usuario diferente al actual, haga click al botón <font color="##0000FF">Ver Lista de Usuarios</font>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		</td>

		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
			<table border="0" width="100%" cellpadding="0" cellspacing="0" >

				<tr><td colspan="3">
					<table border="0" width="100%" class="areaFiltro">
						<tr>
							<td nowrap width="1%" class="selectpicker">Trabajar con:&nbsp;</td>
							<td>
								<table>
									<tr>
										<td><input style="background-color:##E8E8E8; border:0"  type="radio" name="opcion" id="opcion1" value="P" onClick="javascript:document.form1.action=''; document.form1.submit();" ><label for="opcion1">Permisos</label></td>
										<td><input style="background-color:##E8E8E8; border:0" type="radio" name="opcion" id="opcion2" value="R" checked >										 <label for="opcion2"><b>Grupos de Procesos</b></label></td>
									</tr>
								</table>
							</td>
						</tr>	

						<tr>
							<td nowrap width="1%" class="selectpicker">Mostrar Empresa:&nbsp;</td>
							<td>
								<select name="fEmpresa" onChange="javascript:filtrar();"  class="selectpicker">
									<!---<option value="">Todas</option>--->
									<cfloop query="rsEmpresas">
										<option value="#rsEmpresas.Ecodigo#" <cfif isdefined("form.fEmpresa") and form.fEmpresa eq rsEmpresas.Ecodigo >selected</cfif> >#HTMLEditFormat(rsEmpresas.Enombre)#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
						<td nowrap width="1%"  class="selectpicker">Mostrar Sistemas:&nbsp;</td>
						<td  class="selectpicker">
							<select name="fSistema" onChange="javascript:filtrar();"  class="selectpicker">
								<option value="">Todos</option>
								<cfloop query="rsSistemas">
									<cfset sistema = (rsSistemas.SScodigo) >
									<option value="#(rsSistemas.SScodigo)#" <cfif isdefined("form.fSistema") and form.fSistema eq sistema >selected</cfif> >#HTMLEditFormat(rsSistemas.SSdescripcion)#</option>
								</cfloop>
							</select>
						</td>
						</tr>

					</table>
				</td></tr>
			
				<tr><td colspan="3">&nbsp;</td></tr>
	
				<!--- include de Procesos o Roles --->
				<tr class="tituloLista" >
					<td class="label"><b>Empresa</b></td>
					<td class="label"><b>Sistema</b></td>
					<td class="label"><b>Grupo de Procesos</b></td>
				</tr>
			
				<cfset empresa_old = ''>
			
				<cfif rsEmpresas2.RecordCount gt 0 > <!--- Empresas --->
			

					<cfif rsSistemas2.RecordCount gt 0 > <!--- Sistemas 2--->
			

						<cfloop query="rsEmpresas2"> <!--- Empresas 2--->
			
							<cfset empresa = rsEmpresas2.Ecodigo>
							<cfset nombre_empresa = rsEmpresas2.Enombre>
			

							<cfloop query="rsSistemas2">  <!--- Sistemas 2--->
								<cfset sistema = (rsSistemas2.SScodigo)>
							
								<!--- Roles por sistema e indic acuales tiene asigmadoel usuario--->
								<cfquery name="rsRoles" datasource="asp">
									select Ecodigo, b.SScodigo, b.SRcodigo, Usucodigo, b.SRdescripcion 
									from  SRoles b left outer join UsuarioRol a  
									on b.SScodigo=a.SScodigo 
										and b.SRcodigo=a.SRcodigo 
										and a.Ecodigo=#empresa#
										and a.Usucodigo=#form.Usucodigo#
									where b.SScodigo = '#(sistema)#'
									  and b.SRinterno = 0
									order by SRdescripcion
								</cfquery>

								<!--- Corte por empresa--->
								<cfif empresa neq empresa_old>
									<tr><td colspan="3" class="corte" nowrap>
										<input type="hidden" id="empresa_#empresa#" name="empresa_#empresa#" value="true">
										<input style="border:0;" name="empresa" id="#empresa#" type="checkbox" value="" onClick="javascript:check_empresa(this, '#empresa#');" ><b>#HTMLEditFormat(nombre_empresa)#</b>
									</td></tr>
								</cfif>
			
								<tr>
									<td >&nbsp;</td>
									<td colspan="2" class="label" nowrap>
										<table width="100%" border="0">
											<tr>
												<td width="1%">
													<cfif rsRoles.RecordCount gt 0>
														<img name="menos" src="../imagenes/menos.gif" style="cursor:hand; " border="0" onClick="javascript:imagen(this,'#empresa#','#sistema#')" alt="Mostrar los procesos asociados a este Módulo.">
													<cfelse>
														<img name="nada" src="../imagenes/menos.gif" style="cursor:hand; " border="0"  alt="Módulo no tiene porcesos asignados.">
													</cfif>
												</td>
			
												<td width="1%">
													<cfif rsRoles.RecordCount gt 0>
														<input style="border:0;" name="sistema" id="#empresa#|#sistema#" type="checkbox" value="#session.Usucodigo#|#empresa#|#sistema#" onClick="javascript:check(this, '#empresa#', '#sistema#', '#rsRoles.RecordCount#'); borrar(this);" >
													<cfelse>
														<input style="border:0;" disabled name="blanco" type="checkbox" >
													</cfif>
												</td>
			
												<td nowrap>
													#rsSistemas2.SSdescripcion#
												</td>
										</tr>
										</table>
									</td>
								</tr>

					 
								<cfif rsRoles.RecordCount gt 0>
									<tr>
										<td colspan="2">&nbsp;</td>
										<td width="75%">
											<div style="display:;" id="#empresa#|#sistema#|div">
											<table width="100%" border="0" cellpadding="0" cellspacing="0">
			
												<cfloop query="rsRoles">
													<cfset rol = (rsRoles.SRcodigo) >
													<cfset id = "#empresa#|#(sistema)#|#rsRoles.CurrentRow#" >
													<tr ><td  nowrap>
														<input style="border:0;" onClick="javascript:check_sistema(this, '#empresa#', '#sistema#', '#rsRoles.RecordCount#'); borrar(this);" name="roles" id="#empresa#|#sistema#|#rsRoles.CurrentRow#" type="checkbox" <cfif len((rsRoles.Usucodigo)) gt 0>checked</cfif> value="#session.Usucodigo#|#empresa#|#(sistema)#|#(rol)#">#rsRoles.SRdescripcion#
													</td></tr>
												</cfloop>
			
											</table>
											</div>
										</td>
									</tr>						
									
									<cfif rsRoles.RecordCount gt 0>
										<script language="javascript1.2" type="text/javascript">
											var id = '#id#';
											var obj = document.getElementById(id);
											check_sistema(obj, '#empresa#', '#sistema#', '#rsRoles.RecordCount#');
										</script>
									</cfif>
			
								<cfelse>
									<tr><td colspan="2">&nbsp;</td><td align="left"><i>No se han definido Grupos para este Sistema</i></td></tr>
								</cfif>
							

								<cfset empresa_old = empresa>
			

					
	 <!--- Sistemas 2--->
						</cfloop>
							<!--- verifica si debe marcar la empresa  --->
<!---									<cfif rsSistemas2.RecordCount gt 0>
								<script language="javascript1.2" type="text/javascript">
									var id = '#empresa#';
									var obj = document.getElementById(id);
									check_empresa2(obj, '#empresa#' );
								</script>
							</cfif>
					--->			
						<!--- Empresas 2--->
						</cfloop> 

			
					<cfelse> <!--- Sistemas 2--->
						<tr><td colspan="3" class="corte" align="center"><b>No se han definido M&oacute;dulos para la Cuenta Empresarial</b></td></tr>
					</cfif>	<!--- Sistemas 2 --->

				<cfelse> <!--- Empresas --->
					<tr><td colspan="3" class="corte" align="center"><b>No se han definido Empresas para la Cuenta Empresarial</b></td></tr>
				</cfif> <!--- Empresas --->

			</table>
		</td>
		<td width="1%" valign="top">
			<cfinclude template="frame-Progreso.cfm">
			<br>
			<cfinclude template="frame-Proceso.cfm">
		</td>
	  </tr>
	  <tr>
		<td colspan="3">&nbsp;</td>
	  </tr>
	
	  <tr>
		<td colspan="3" bgcolor="##A0BAD3" >
			<cfinclude template="frame-botones2.cfm">
		</td>
	  </tr>
	</table>

	<!--- Para saber que borrar --->
	<input type="hidden" name="procesos_borrar" value="">
</form>
</cfoutput>