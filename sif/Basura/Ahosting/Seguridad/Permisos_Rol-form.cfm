<!--- hacer una funcion con esto, para no tener los dos querys --->
<cfquery name="rsEmpresas" datasource="asp">
	select Ecodigo, Enombre 
	from Empresa 
	where CEcodigo=#session.progreso.CEcodigo#
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
	where CEcodigo=#session.progreso.CEcodigo#
	<cfif isdefined("form.fEmpresa") and len((form.fEmpresa)) gt 0>
		and Ecodigo=#form.fEmpresa#
	</cfif>
	order by Enombre
</cfquery>

<!--- Modulos por Cuenta Empresarial --->
<cfquery name="rsModulos" datasource="asp">
	select a.SScodigo, a.SMcodigo, SMdescripcion
	from ModulosCuentaE a, SModulos b
	where a.CEcodigo = #session.progreso.CEcodigo#
	  and a.SMcodigo = b.SMcodigo
	  and exists (
          select 1 from SProcesos c
            where c.SScodigo = b.SScodigo
              and c.SMcodigo = b.SMcodigo
              and c.SPinterno = 0)
	group by a.SScodigo, a.SMcodigo, SMdescripcion
	order by SMdescripcion
</cfquery>

<!--- Modulos por Cuenta Empresarial --->
<cfquery name="rsModulos2" datasource="asp">
	select a.SScodigo, a.SMcodigo, SMdescripcion
	from ModulosCuentaE a, SModulos b
	where a.CEcodigo = #session.progreso.CEcodigo#
	  and a.SMcodigo = b.SMcodigo
	  and a.SScodigo = b.SScodigo
	  and  (
      	select count(1) 
        from SProcesos c
		where c.SScodigo = b.SScodigo
		  and c.SMcodigo = b.SMcodigo
		  and c.SPinterno = 0) > 0
	<cfif isdefined("form.fModulo") and len((form.fModulo)) gt 0>
		<cfset data = ListToArray(form.fModulo,'|')>
		and a.SScodigo = '#data[1]#'
		and a.SMcodigo = '#data[2]#'
	</cfif>
	group by a.SScodigo, a.SMcodigo, SMdescripcion
	order by SMdescripcion
</cfquery>

<cfquery name="rsUsuario" datasource="asp">
	select a.Pnombre, a.Papellido1, a.Papellido2
	from DatosPersonales a, Usuario b
	where a.datos_personales = b.datos_personales
	and b.Usucodigo = #form.Usucodigo#
</cfquery>
<cfoutput>

<script language="javascript1.2" type="text/javascript">
	function check(obj, empresa, sistema, modulo, cantidad){
		for ( var i=1; i<=cantidad; i++ ){
			var objeto = empresa + '|' + sistema + '|' + modulo + '|' + i;
			
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

	function check_sistema(obj, empresa, sistema, modulo, cantidad){
		// nada que ver con esta funcion pero se pone aqui
		//borrar(obj);

		var objeto = empresa + '|' + sistema + '|' + modulo;		// check de modulo
		var empresa2 = "empresa_" + empresa;		// check de modulo
		
		if (obj.checked){
			// VERIFICA LOS DEMAS OBJETOS PARA ESA EMPRESA Y MODULO ACTUAL
			for ( var i=1; i<=cantidad; i++ ){
				var objeto2 = empresa + '|' + sistema + '|' + modulo + '|' + i;		// check de procesos
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
					else{
						f.elements[i].checked = false;
					}
				}
			}
		}
	}

	function check_empresa2(obj, empresa){
	// RESULTADO
	// Marca el check de empresa si todas sus empresas y procesos estan marcados

		f = obj.form;
		
		for ( var i=0; i< f.elements.length; i++ ){
			if (f.elements[i].type == 'checkbox' || f.elements[i].name == 'modulo' ){
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

	function filtrar(){
		document.form1.action = '';
		document.form1.submit();
	}

	function prueba(empresa, sistema, modulo, modo){
		document.getElementById(empresa+'|'+sistema+'|'+modulo+'|div').style.display = modo;
	}
	
	function imagen(obj, empresa, sistema, modulo){
		if (obj.name == 'mas'){
			obj.name = 'menos';
			obj.src = '../imagenes/menos.gif';
			prueba(empresa,sistema,modulo, '');
		}
		else{
			obj.name = 'mas';
			obj.src = '../imagenes/mas.gif';
			prueba(empresa,sistema,modulo,'none');
		}
	}
	
	function borrar(obj){
		// agrega el codigo del registro a borrar
		if (!obj.checked){
			document.form1.procesos_borrar.value = document.form1.procesos_borrar.value + obj.value + '*';
		}
	}
	
</script>

<form name="form1" method="post" action="Permisos-sql.cfm" >
	<input type="hidden" name="ACCION" value="1">
	<input type="hidden" name="Usucodigo" value="#form.Usucodigo#">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="3">
			<table width="100%" cellpadding="3" cellspacing="0">
				<tr><td class="tituloPersona" align="center" bgcolor="##CCCCCC">
					<font size="3"><b><div align="center">Asignando Permisos a:&nbsp;#rsUsuario.Pnombre# #rsUsuario.Papellido1# #rsUsuario.Papellido2#</div></b></font>
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
			<b>Asignaci&oacute;n de Permisos</b><br>
			Para asignar permisos al Usuario, primero seleccione la empresa en la que va a trabajar. Luego marque el o los procesos que desea asociar al usuario y haga click al botón <font color="##0000FF">Aceptar</font>.<br><br>
			<b>Revocar Permisos</b><br>
			Para quitar permisos al Usuario, desmarque el ó los procesos que va a revocar y haga click al botón <font color="##0000FF">Aceptar</font>.<br><br>
			<b>Trabajar con Cuenta o Usuarios diferentes al actual</b><br>
			Si desea trabajar una Cuenta Empresarial o un Usuario diferente al actual, haga click al botón <font color="##0000FF">Ver Lista de Usuarios</font>.<br><br>
			Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
		</td>

		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
			<table border="0" width="100%" cellpadding="0" cellspacing="0" >

				<tr><td colspan="3">
					<table border="0" width="100%" class="areaFiltro">

						<tr>
							<td nowrap width="1%" class="label">Trabajar con:&nbsp;</td>
							<td>
								<table>
									<tr>
										<td><input style="background-color:##E8E8E8; border:0"  type="radio" name="opcion" value="P" id="opcion1" checked >										  <label for="opcion1"><b>Permisos</b></label></td>
										<td><input style="background-color:##E8E8E8; border:0" type="radio" name="opcion" value="R"  id="opcion2" onClick="javascript:document.form1.action=''; document.form1.submit();" ><label for="opcion2">Grupos de Procesos</label></td>
									</tr>
								</table>
							</td>
						</tr>	

						<tr>
							<td nowrap width="1%" class="label">Mostrar Empresa:&nbsp;</td>
							<td>
								<select name="fEmpresa" onChange="javascript:filtrar();" class="label">
									<!---<option value="">Todas</option>--->
									<cfloop query="rsEmpresas">
										<option value="#rsEmpresas.Ecodigo#" <cfif isdefined("form.fEmpresa") and form.fEmpresa eq rsEmpresas.Ecodigo >selected</cfif> >#HTMLEditFormat(rsEmpresas.Enombre)#</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
						<td nowrap width="1%" class="label">Mostrar M&oacute;dulos:&nbsp;</td>
						<td class="label">
							<select name="fModulo" onChange="javascript:filtrar();"  class="label" >
								<option value="">Todos</option>
								<cfloop query="rsModulos">
									<cfset modulo = (rsModulos.SScodigo) & "|" & (rsModulos.SMcodigo) >
									<option value="#(rsModulos.SScodigo)#|#(rsModulos.SMcodigo)#" <cfif isdefined("form.fModulo") and form.fModulo eq modulo >selected</cfif> >#HTMLEditFormat(rsModulos.SMdescripcion)#</option>
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
					<td class="label"><b>M&oacute;dulo</b></td>
					<td class="label"><b>Proceso</b></td>
				</tr>
			
				<cfset empresa_old = ''>
			
				<cfif rsEmpresas2.RecordCount gt 0 > <!--- Empresas --->
			
					<cfif rsModulos2.RecordCount gt 0 > <!--- Modulos 2--->
			
						<cfloop query="rsEmpresas2"> <!--- Empresas 2--->
			
							<cfset empresa = rsEmpresas2.Ecodigo>
							<cfset nombre_empresa = rsEmpresas2.Enombre>
			
							<cfloop query="rsModulos2">  <!--- modulos 2--->

								<cfset sistema = (rsModulos2.SScodigo)>
								<cfset modulo  = (rsModulos2.SMcodigo)>

								<cfquery name="rsProcesos" datasource="asp">
									select b.Ecodigo, a.SScodigo, a.SMcodigo, a.SPcodigo, b.Usucodigo, a.SPdescripcion
									from SProcesos a left outer join UsuarioProceso b
										on a.SScodigo 	= b.SScodigo
										and a.SMcodigo 	= b.SMcodigo
										and a.SPcodigo 	= b.SPcodigo
										and b.Ecodigo=#empresa#										
										and b.Usucodigo = #form.Usucodigo#										
									where a.SScodigo = '#(rsModulos2.SScodigo)#'
									and a.SMcodigo = '#(rsModulos2.SMcodigo)#'
									and a.SPanonimo=0
									and a.SPpublico=0
									and a.SPinterno=0							
								</cfquery>
			
								<!--- Corte por empresa--->
								<cfif empresa neq empresa_old>
									<tr><td colspan="3" class="corte" nowrap>
										<input type="hidden" id="empresa_#empresa#" name="empresa_#empresa#" value="true">
										<input style="border:0;" name="empresa" id="#empresa#" type="checkbox" value="" onClick="javascript:check_empresa(this, '#empresa#');"><b>#HTMLEditFormat(nombre_empresa)#</b>
									</td></tr>
								</cfif>
			
			
								<tr>
									<td >&nbsp;</td>
									<td colspan="2" class="label" nowrap>
										<table width="100%" border="0">
											<tr>
												<td width="1%">
													<cfif rsProcesos.RecordCount gt 0>
														<img name="mas" src="../imagenes/mas.gif" style="cursor:hand; " border="0" onClick="javascript:imagen(this,'#empresa#','#sistema#','#modulo#')" alt="Mostrar los procesos asociados a este Módulo.">
													<cfelse>
														<img name="nada" src="../imagenes/menos.gif" style="cursor:hand; " border="0"  alt="Módulo no tiene porcesos asignados.">
													</cfif>
												</td>
			
												<td width="1%">
													<cfif rsProcesos.RecordCount gt 0>
														<input style="border:0;" name="modulo" id="#empresa#|#sistema#|#modulo#" type="checkbox" value="#session.Usucodigo#|#empresa#|#sistema#|#modulo#" onClick="javascript:check(this, '#empresa#', '#sistema#', '#modulo#', '#rsProcesos.RecordCount#'); borrar(this);">
													<cfelse>
													<input style="border:0;" disabled name="blanco" type="checkbox" >
													</cfif>
												</td>
			
												<td nowrap>
													#rsModulos2.SMdescripcion#
												</td>
												<!---<td align="right"><a href="javascript:prueba('#empresa#','#sistema#','#modulo#', '')">abrir</a> | <a href="javascript:prueba('#empresa#','#sistema#','#modulo#', 'none')">cerrar</a></td>--->
										</tr>
										</table>
									</td>
								</tr>
					
								<cfif rsProcesos.RecordCount gt 0>
									<tr>
										<td colspan="2">&nbsp;</td>
										<td width="75%">
											<div style="display:none;" id="#empresa#|#sistema#|#modulo#|div">
											<table width="100%" border="0" cellpadding="0" cellspacing="0">
			
												<cfloop query="rsProcesos">
													<cfset id = "#empresa#|#(rsProcesos.SScodigo)#|#(rsProcesos.SMcodigo)#|#rsProcesos.CurrentRow#" >
													<tr ><td class="label" nowrap><input style="border:0;" onClick="javascript:check_sistema(this, '#empresa#', '#sistema#','#modulo#', '#rsProcesos.RecordCount#'); borrar(this);" name="permisos" id="#empresa#|#(rsProcesos.SScodigo)#|#(rsProcesos.SMcodigo)#|#rsProcesos.CurrentRow#" type="checkbox" <cfif len(trim(rsProcesos.Usucodigo)) gt 0>checked</cfif> value="#session.Usucodigo#|#empresa#|#(rsProcesos.SScodigo)#|#(rsProcesos.SMcodigo)#|#(rsProcesos.SPcodigo)#">#rsProcesos.SPdescripcion#</td></tr>
												</cfloop>
			
											</table>
											</div>
										</td>
									</tr>						
									
									<cfif rsProcesos.RecordCount gt 0>
										<script language="javascript1.2" type="text/javascript">
											var id = '#id#';
											var obj = document.getElementById(id);
											check_sistema(obj, '#empresa#', '#sistema#','#modulo#', '#rsProcesos.RecordCount#');
										</script>
									</cfif>
			
								<cfelse>
									<tr><td colspan="2">&nbsp;</td><td align="left"><i>No se han definido Procesos para este M&oacute;dulo</i></td></tr>
								</cfif>
							
								<cfset empresa_old = empresa>
			
							</cfloop> <!--- modulos 2--->
			
			
							<!--- verifica si debe marcar la empresa  --->
							<cfif rsModulos2.RecordCount gt 0>
								<script language="javascript1.2" type="text/javascript">
									var id = '#empresa#';
									var obj = document.getElementById(id);
									check_empresa2(obj, '#empresa#' );
								</script>
							</cfif>
			
						</cfloop> <!--- Empresas 2--->
					
			
			
					<cfelse> <!--- Modulos 2--->
						<tr><td colspan="3" class="corte" align="center"><b>No se han definido M&oacute;dulos para la Cuenta Empresarial</b></td></tr>
					</cfif>	<!--- Modulos 2 --->
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