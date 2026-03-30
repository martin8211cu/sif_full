<link href="../css/sec.css" rel="stylesheet" type="text/css">

<!--- Update 1---> 
<!--- Consulta de sistemas --->
<cfquery name="dataSistemas" datasource="sdc">
	select rtrim(sistema) as sistema, nombre
	from Sistema
	where activo = 1
	order by orden, upper(sistema)
</cfquery>

<!--- Update 2 ---> 
<cfif isdefined("form.sistema")>
	<cfset sistemaActual = form.sistema >
<cfelseif not isdefined("form.sistema") and dataSistemas.RecordCount gt 0>
	<cfset sistemaActual = dataSistemas.sistema>
</cfif>

<!--- 3. Consulta de modulos --->
<cfif isdefined("sistemaActual")>
	<cfquery name="dataModulos" datasource="sdc">
		select rtrim(modulo) as modulo, nombre,
		  nomModulo = case when charindex(rtrim(sistema) + '.', modulo) > 0 then
		  rtrim(substring(modulo, charindex(rtrim(sistema) + '.', modulo) + char_length(rtrim(sistema)) + 1,
			char_length(modulo) - charindex(rtrim(sistema) + '.', modulo) - char_length(rtrim(sistema))))
		  else modulo end
		from Modulo
		where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#">
		  and activo = 1
		order by orden, upper (modulo)
	</cfquery>

	<cfif isdefined("form.modulo") and len(trim(form.modulo)) gt 0>
		<cfset moduloActual = form.modulo >
	<cfelseif ( not isdefined("form.modulo") ) and dataModulos.RecordCount gt 0>
		<cfset moduloActual = dataModulos.modulo >
	</cfif>	
</cfif>

<!--- 4. Consulta de Roles - Servicios --->
<cfif isdefined("moduloActual")>
	<!--- Consulta de roles --->
	<cfquery name="dataRoles" datasource="sdc">
		select rtrim(rol) as rol, nombre, rtrim(sistema) as sistema
		from Rol
		where sistema in ('sys', <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
		  and activo = 1
		order by case when sistema = 'sys' then 1 else 0 end, rol
	</cfquery>
	
	<!--- Consulta de servicios --->
	<cfquery name="data" datasource="sdc">
		select rtrim(s.servicio) as servicio, s.nombre, s.menu, s.home, s.agregacion,
			existeRol = case when sr.rol is null then 0 else 1 end, rtrim(r.rol) as rol, s.orden
		from Servicios s, Rol r, ServiciosRol sr
		where s.servicio *= sr.servicio
		  and r.rol *= sr.rol
		  and s.modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
		  and s.activo = 1
		  and r.sistema in ('sys', <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
		  and r.activo = 1

		union

		select rtrim(s.servicio) as servicio, s.nombre, s.menu, s.home, s.agregacion,
			existeRol = 0, null as rol, s.orden
		from Servicios s
		where s.modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
		  and s.activo = 1
		and not exists (select rol from Rol
		  where sistema in ('sys', <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
		  and activo = 1)

		<cfif not isdefined("form.servicio")>
			union
			select null as servicio, null as nombre, convert(bit,1) as menu, 
			  convert(bit,1) as home, '2' as agregacion,
			  existeRol=0, rtrim(r.rol) as rol,
			  (select max(orden) + 1 from Servicios 
				where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
				and activo = 1) as orden
			from Rol r
			where r.sistema in ('sys', <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
			  and r.activo = 1
			union
			select null as servicio, null as nombre, convert(bit,1) as menu,
			  convert(bit,1) as home, '2' as agregacion,
			  existeRol=0, null as rol, (select max(orden) + 1 from Servicios 
				where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
				and activo = 1) as orden
			where not exists (select rol from Rol
			  where sistema in ('sys', <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
			  and activo = 1)
		</cfif>
		order by orden, servicio, rol
	
	</cfquery>
</cfif>

<table class="contenido" width="100%" border="1">
	<cfoutput>
	<form name="formEncabezado" action="" method="post" style="margin:0">
		<tr class="itemtit">
			<td colspan="6" align="left"><strong>Sistema</strong>
				<select name="sistema" onChange="javascript:document.formEncabezado.modulo.value='';  document.formEncabezado.submit();">
					<cfloop query="dataSistemas">
						<option value="#dataSistemas.sistema#" <cfif sistemaActual eq dataSistemas.sistema>selected</cfif>>#dataSistemas.sistema#</option>
						<cfif sistemaActual eq dataSistemas.sistema>
							<cfset nombreSistema = dataSistemas.nombre >
						</cfif>
					</cfloop>
				</select>
				<cfif isdefined("nombreSistema")>#nombreSistema#<cfelse>No hay sistemas definidos</cfif>
			</td>

			<cfif isdefined("moduloActual") and dataRoles.RecordCount gt 0>
				<cfloop query="dataRoles">
					<td rowspan="3" style="text-align: center;writing-mode:tb-rl; <cfif dataRoles.sistema neq sistemaActual>background-color:##eee</cfif>" ><strong>#dataRoles.nombre#</strong></td>
				</cfloop>
			</cfif>
		</tr>

		<tr class="itemtit">
			<td colspan="6" align="left"><strong>M&oacute;dulo</strong>
				<select name="modulo" onChange="javascript:document.formEncabezado.submit();">
					<cfloop query="dataModulos">
						<option value="#dataModulos.modulo#" <cfif moduloActual eq dataModulos.modulo>selected</cfif> >#dataModulos.nomModulo#</option>					
						<cfif moduloActual eq dataModulos.modulo>
							<cfset nombreModulo = dataModulos.nombre >
						</cfif>
					</cfloop>
				</select>	
				<cfif isdefined("nombreModulo")>#nombreModulo#<cfelse>No hay m&oacute;dulos definidos</cfif>
			</td>
		</tr>
	</form>
	</cfoutput>

	<cfif isdefined("moduloActual")> <!--- cfif 1 --->
		<cfoutput>

		<cfif modo NEQ 'ALTA' >
			<cfquery name="rsForm" dbtype="query" maxrows="1">
				select servicio, nombre, orden, home, menu, agregacion from data where servicio = '#form.servicio#'
			</cfquery>
		</cfif>

		<form name="formServicio" action="SQLServicio.cfm" method="post">
			<input type="hidden" name="sistema" value="#sistemaActual#">
			<input type="hidden" name="modulo"  value="#moduloActual#">
			<input type="hidden" name="editar"  value="#modo#">

			<tr class="itemtit">
				<td align="left" width="1%" <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> ><strong>Orden</strong></td>
				<td align="left" <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> ><strong>Servicio</strong></td>
				<td align="left" <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif>><strong>Nombre</strong></td>
				<td <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> style="text-align: center;"><strong>Men&uacute;</strong></td>
				<td <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> style="text-align: center;"><strong>Home</strong></td>
				<td <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> style="text-align: center;"><strong>Agregaci&oacute;n</strong></td>
			</tr>

<!--- ==================================================================== --->
<!---                       form Insercion-Modificacion					   --->	
<!--- ==================================================================== --->
			<tr>
				<cfif modo eq 'ALTA'>
					<cfquery name="rsMaximo" dbtype="query">
						select max(orden) as orden from data
					</cfquery>
					<cfif rsMaximo.orden lte 0 >
						<cfset maximo = 1 >
					<cfelse>
						<cfset maximo = rsMaximo.orden >
					</cfif>
				</cfif>
				<td width="1%">
					<input type="text" name="orden" size="4" maxlength="4" value="<cfif modo neq 'ALTA'>#rsForm.orden#<cfelse>#maximo#</cfif>" style="text-align: right;" onblur="javascript:fm(this,0); servicio_orden();"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
					<input type="hidden" name="horden" value="<cfif modo neq 'ALTA'>#rsForm.orden#<cfelse>#maximo#</cfif>" >
				</td>

				<td width="1%" nowrap>
					<cfif modo neq 'ALTA'><strong>#form.servicio#</strong>
						<input type="hidden" name="servicio" value="#trim(rsForm.servicio)#">
					<cfelse>	
						<cfif isdefined("form.modulo")>
							#form.modulo#.
						<cfelse>	
							#moduloActual#.
						</cfif>
						<input type="text" name="servicio" size="20" maxlength="20" value="" onFocus="this.select();">
					</cfif>
				</td>

				<td width="1%" nowrap>
					<input type="text" name="nombre" size="40" maxlength="100" value="<cfif modo neq 'ALTA'>#trim(rsForm.nombre)#</cfif>" onFocus="this.select();">
				</td>
				
				<td width="1%" align="center"><input type="checkbox" name="menu" value="1" <cfif modo neq 'ALTA' and rsForm.menu eq 1>checked</cfif>></td>
				<td width="1%" align="center"><input type="checkbox" name="home" value="1" <cfif modo neq 'ALTA' and rsForm.home eq 1>checked</cfif>></td>

				<td width="1%">
					<select name="agregacion">
						<option value="2" <cfif modo neq 'ALTA' and rsForm.agregacion eq '2'>selected</cfif>>Autom&aacute;tica</option>
						<option value="0" <cfif modo neq 'ALTA' and rsForm.agregacion eq '0'>selected</cfif>>Opcional</option>
						<option value="1" <cfif modo neq 'ALTA' and rsForm.agregacion eq '1'>selected</cfif>>Fija</option>
					</select>
				</td>
				
				<cfloop query="dataRoles">
					<cfif modo neq 'ALTA'>
						<!--- Roles que tiene asignados --->		
						<cfquery name="rsformRoles" dbtype="query" >
							select servicio, rol, existeRol 
							from data
							where servicio = '#form.servicio#'
							and rol = '#dataRoles.rol#'
						</cfquery>
					</cfif>
				
					<td align="center"><input type="checkbox" 
											  name="rol" 
											  value="#dataRoles.rol#" <cfif modo neq 'ALTA' and rsformRoles.RecordCount gt 0><cfif rsformRoles.existeRol eq 1>checked</cfif></cfif> >
					</td>
				</cfloop>
				
			</tr>
			
			<tr>
				<cfset rowspan = 6 + dataRoles.RecordCount >
				<td colspan="#rowspan#" style="text-align: right;">
					<input type="submit" name="btnGuardar" value="Guardar">
					<cfif modo neq 'ALTA' >
						<input type="submit" name="btnBorrar" value="Eliminar" onClick="return confirmarBorrado(form)">
						<input type="submit" name="btnNuevo" value="Nuevo">
					</cfif>
				</td>
			</tr>
<!--- ==================================================================== --->

<!--- ==================================================================== --->
<!---                          lista de datos 							   --->
<!--- ==================================================================== --->
			<tr>
				<cfset colspan = 6 + dataRoles.RecordCount>
				<td bgcolor="##F5F5F5" colspan="#colspan#" align="center" class="subTitulo">Listado de Servicios</td>
			</tr>

			<cfset corte = "">
			<cfset cont  = 0>
			<cfloop query="data" >
				<cfif data.servicio neq corte and len(trim(data.servicio)) gt 0 >
					<tr bgcolor="<cfif not (cont mod 2) >##FAFAFA</cfif>" >
						<td nowrap onClick="javascript:cargarServicio('#data.servicio#');" ><a href="javascript:cargarServicio('#data.servicio#')">#data.orden#</a></td>
						<td nowrap onClick="javascript:cargarServicio('#data.servicio#');"><a href="javascript:cargarServicio('#data.servicio#')">#data.servicio#</a></td>
						<td nowrap onClick="javascript:cargarServicio('#data.servicio#');"><a href="javascript:cargarServicio('#data.servicio#')">#data.nombre#</a></td>
						<td nowrap onClick="javascript:cargarServicio('#data.servicio#');" align="center">
							<cfif data.menu eq 1>
								<a href="javascript:cargarServicio('#data.servicio#')"><img src="../imagenes/checked.gif" border="0" ></a>
							<cfelse>
								<a href="javascript:cargarServicio('#data.servicio#')"><img src="../imagenes/unchecked.gif" border="0"></a>
							</cfif>
						</td>

						<td nowrap onClick="javascript:cargarServicio('#data.servicio#');" align="center">
							<cfif data.home eq 1>
								<a href="javascript:cargarServicio('#data.servicio#')"><img src="../imagenes/checked.gif" border="0" ></a>
							<cfelse>
								<a href="javascript:cargarServicio('#data.servicio#')"><img src="../imagenes/unchecked.gif" border="0"></a>
							</cfif>
						</td>

						<td nowrap onClick="javascript:cargarServicio('#data.servicio#');" style="text-align: center;">
							<a href="javascript:cargarServicio('#data.servicio#')">
								<cfif data.agregacion eq 0  >
									Opcional
								<cfelseif data.agregacion eq 1>
									Fija
								<cfelseif data.agregacion eq 2>
									Autom&aacute;tica
								</cfif>
							</a>
						</td>

						<!--- Roles que tiene asignados --->		
						<cfquery name="roles" dbtype="query" >
							select servicio, rol, existeRol 
							from data
							where servicio = '#trim(data.servicio)#'
						</cfquery>

						<!--- pinta los roles que tiene asignados --->
						<cfif roles.RecordCount gt 0 >
							<cfloop query="roles">
								<td nowrap onClick="javascript:cargarServicio('#data.servicio#');" align="center">
									<cfif roles.existeRol eq 1>
										<a href="javascript:cargarServicio('#data.servicio#')"><img src="../imagenes/checked.gif" border="0" ></a>
									<cfelse>
										<a href="javascript:cargarServicio('#data.servicio#')"><img src="../imagenes/unchecked.gif" border="0"></a>
									</cfif>
								</td>
							</cfloop>
						</cfif>

					</tr>
					<cfset cont = cont + 1>
				</cfif>
				
				<cfset corte = data.servicio>				
			</cfloop>
		</form>
		</cfoutput>

	<cfelse>
		<tr><td align="center"><b>Debe definir los modulos para este Sistema</b></td></tr>
	</cfif> <!--- cfif 1 --->
</table>

<cfif isdefined("moduloActual")>
	<script type="text/javascript">
		objForm = new qForm("formServicio");
	
		objForm.orden.required = true;
		objForm.orden.description="Orden";
		objForm.servicio.required = true;
		objForm.servicio.description="Servicio";
		objForm.nombre.required = true;
		objForm.nombre.description="Nombre";
	
		function cargarServicio(servicio) {
			document.formServicio.servicio.value = servicio;
			document.formServicio.action = '';
			document.formServicio.submit();
		}
		
		function confirmarBorrado(f){
			if (confirm("Seguro de que desea eliminar el servicio " + f.servicio.value + "?")) {
				objForm._allowSubmitOnError = true;
				objForm._showAlerts = false;
				return true;
			}
			return false;
		}
		
		function servicio_orden(){
			if (trim(document.formServicio.orden.value) == '' ){
				document.formServicio.orden.value = document.formServicio.horden.value;
			}	
		}
	</script>
</cfif>