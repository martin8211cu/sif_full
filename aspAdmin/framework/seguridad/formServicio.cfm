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

<!---
	<cfquery name="dataRoles" datasource="sdc">
		select rtrim(rol) as rol, nombre, rtrim(sistema) as sistema
		from Rol
		where sistema in ('sys', <cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
		  and activo = 1
		order by case when sistema = 'sys' then 1 else 0 end, rol
	</cfquery>
--->	
	<cfquery name="dataRoles" datasource="sdc">
		select rtrim(rol) as rol, nombre, rtrim(sistema) as sistema
		from Rol
		where sistema in (<cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
		  and activo = 1
		order by rol
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
		  and r.sistema in (<cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
		  and r.activo = 1

		union

		select rtrim(s.servicio) as servicio, s.nombre, s.menu, s.home, s.agregacion,
			existeRol = 0, null as rol, s.orden
		from Servicios s
		where s.modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
		  and s.activo = 1
		and not exists (select rol from Rol
		  where sistema in (<cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
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
			where r.sistema in (<cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
			  and r.activo = 1
			union
			select null as servicio, null as nombre, convert(bit,1) as menu,
			  convert(bit,1) as home, '2' as agregacion,
			  existeRol=0, null as rol, (select max(orden) + 1 from Servicios 
				where modulo = <cfqueryparam cfsqltype="cf_sql_char" value="#moduloActual#">
				and activo = 1) as orden
			where not exists (select rol from Rol
			  where sistema in (<cfqueryparam cfsqltype="cf_sql_char" value="#sistemaActual#"> )
			  and activo = 1)
		</cfif>
		order by orden, servicio, rol
	
	</cfquery>
</cfif>

<table class="contenido" width="100%" border="1">
	<cfoutput>
	<form name="formEncabezado" action="" method="post" style="margin:0">
		<tr class="itemtit">
			<td colspan="5" align="left"><strong>Sistema</strong>
				<select name="sistema" onChange="javascript:document.formEncabezado.modulo.value='';  document.formEncabezado.submit();">
					<cfloop query="dataSistemas">
						<option value="#dataSistemas.sistema#" <cfif trim(sistemaActual) eq trim(dataSistemas.sistema) >selected</cfif>>#dataSistemas.sistema#</option>
						<cfif trim(sistemaActual) eq trim(dataSistemas.sistema)>
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
			<td colspan="5" align="left"><strong>M&oacute;dulo</strong>
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
				<!---<td align="left" width="1%" <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> ><strong>Orden</strong></td>--->
				<td align="left" <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> ><strong>Servicio</strong></td>
				<td align="left" <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif>><strong>Nombre</strong></td>
				<td <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> style="text-align: center;"><strong>Men&uacute;</strong></td>
				<td <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> style="text-align: center;"><strong>Home</strong></td>
				<td <cfif dataRoles.RecordCount gt 0>rowspan="1"</cfif> style="text-align: center;"><strong>Agregaci&oacute;n</strong></td>
			</tr>

<!--- ==================================================================== --->
<!---                          lista de datos 							   --->
<!--- ==================================================================== --->
			<tr>
				<cfset colspan = 5 + dataRoles.RecordCount>
				<td bgcolor="##F5F5F5" colspan="#colspan#" align="center" class="subTitulo">Listado de Servicios</td>
			</tr>

			<cfset corte = "">
			<cfset cont  = 0>
			<cfloop query="data" >
				<cfset servicio2 = data.servicio >
				<cfif data.servicio neq corte and len(trim(data.servicio)) gt 0 >
					<tr bgcolor="<cfif not (cont mod 2) >##FAFAFA</cfif>" >
						<!---<td nowrap >#data.orden#</td>--->
						<td nowrap >#data.servicio#</td>
						<td nowrap >#data.nombre#</td>

						<td nowrap onClick="" align="center">
							<cfif data.menu eq 1>
								<img  id="img_#data.servicio#_##" src="../imagenes/checked.gif" border="0" >
							<cfelse>
								<img src="../imagenes/unchecked.gif" border="0">
							</cfif>
						</td>

						<td nowrap align="center">
							<cfif data.home eq 1>
								<img src="../imagenes/checked.gif" border="0" >
							<cfelse>
								<img src="../imagenes/unchecked.gif" border="0">
							</cfif>
						</td>

						<td nowrap onClick="" style="text-align: center;">
							<cfif data.agregacion eq 0  >
								Opcional
							<cfelseif data.agregacion eq 1>
								Fija
							<cfelseif data.agregacion eq 2>
								Autom&aacute;tica
							</cfif>
						</td>

						<!--- Roles que tiene asignados --->		
						<cfquery name="roles" dbtype="query" >
							select servicio, rol, existeRol 
							from data
							where servicio = '#trim(data.servicio)#'
						</cfquery>

						<!--- pinta los roles que tiene asignados --->
						<cfif roles.RecordCount gt 0 and len(trim(roles.rol)) gt 0 >
							<cfloop query="roles">
								<td nowrap align="center">
									<cfif roles.existeRol eq 1>
										<img name="checked" style="cursor:hand;" onClick="src='SQLServicio2.cfm?servicio=#servicio2#&rol=#roles.rol#&name=' + this.name; this.name=(this.name == 'checked') ? 'unchecked' : 'checked'; " src="../imagenes/checked.gif" border="0" >
									<cfelse>
										<img name="unchecked"  style="cursor:hand;" onClick="src='SQLServicio2.cfm?servicio=#servicio2#&rol=#roles.rol#&name=' + this.name; this.name=(this.name == 'checked') ? 'unchecked' : 'checked'; " src="../imagenes/unchecked.gif" border="0">
									</cfif>
								</td>
							</cfloop>
						</cfif>

					</tr>
					<cfset cont = cont + 1>
				</cfif>
				
				<cfset corte = data.servicio>				
			</cfloop>

			<tr><td colspan="#colspan#" align="right"><input type="submit" name="btnRoles" value="Roles" onClick="javascript:roles();"></td></tr>	

		</form>
		</cfoutput>
	<cfelse>
		<tr><td align="center"><b>El Sistema no tiene m&oacute;dulos definidos</b></td></tr>
	</cfif> <!--- cfif 1 --->
</table>

<script type="text/javascript">
	function roles(){
		document.formServicio.action = 'Roles.cfm';
		document.formServicio.submit();
	}

</script>