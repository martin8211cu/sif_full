<!--- Definición de la Consulta --->
<cfquery name="rsDatosEmpleado" datasource="#Session.DSN#">
	select
		coalesce(cf.CFcodigo,' ') 			as cfcodigo, 
		coalesce(b.DEidentificacion,' ') 	as cedula,
		coalesce(e.NTIdescripcion,' ') 		as tipocedula ,
		coalesce(b.DEnombre,' ') 			as nombre,
		coalesce(b.DEapellido1,' ') 		as apellido1,
		coalesce(b.DEapellido2,' ') 		as apellido2,
		coalesce(b.DEdireccion,' ') 		as direccion,
		coalesce(b.DEtelefono1,' ') 		as telresidencia,
		coalesce(b.DEtelefono2,' ') 		as telcelular,
		coalesce(b.DEemail,' ') 			as email,
		a.ECFdesde			 				as fechadesde,
		a.ECFhasta							as fechahasta,
		coalesce(cf.CFdescripcion,' ') 		as centrofuncional,
		case when (<cf_dbfunction name="now"> between a.ECFdesde and a.ECFhasta) then 'Activo' else 'Inactivo' end as estado
		
	from EmpleadoCFuncional a
		inner join CFuncional cf 
			on a.CFid = cf.CFid
		inner join DatosEmpleado b 
			on a.DEid = b.DEid			
		left outer join Monedas c 
			on b.Mcodigo 	= c.Mcodigo 
			and b.Ecodigo 	= c.Ecodigo
		left outer join Bancos d 
			on b.Bid 		= d.Bid 
			and b.Ecodigo 	= d.Ecodigo
		left outer join NTipoIdentificacion e 
			on b.NTIcodigo = e.NTIcodigo
		left outer join EmpleadosTipo f 
			on b.DEid 		= f.DEid
		left outer join TiposEmpleado g 
			on f.TEid 		= g.TEid 
			and b.Ecodigo 	= g.Ecodigo
		left outer join Pais h 
		 	on b.Ppais 	= h.Ppais
			
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.DEid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	  and a.CFid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>

<cf_templateheader title="Datos Empleado">
		<cf_web_portlet_start titulo="Datos del Empleado">
			<cfif rsDatosEmpleado.recordCount eq 1>
				<cfoutput>
				<br>
				<fieldset>
					<legend><strong>Empleado&nbsp;</strong></legend>			
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="15%">Nombre:&nbsp;</td>
							<td><input type="text" name="nombre" value="#rsDatosEmpleado.nombre#" readonly="true"></td>
							<td width="11%">Primer Apellido:&nbsp;</td>
							<td><input type="text" name="apellido1" value="#rsDatosEmpleado.apellido1#" readonly="true"></td>
							<td width="13%">Segundo Apellido:&nbsp;</td>
							<td><input type="text" name="apellido2" value="#rsDatosEmpleado.apellido2#" readonly="true"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>#rsDatosEmpleado.tipocedula#:&nbsp;</td>
							<td><input type="text" name="cedula" value="#rsDatosEmpleado.cedula#" readonly="true"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>Centro Funcional:&nbsp;</td>
							<td colspan="6"><input type="text" name="centrofuncional" value="#trim(rsDatosEmpleado.cfcodigo)# - #trim(rsDatosEmpleado.centrofuncional)#" readonly="true" size="123"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>Direcci&oacute;n:&nbsp;</td>
							<td colspan="6"><input type="text" name="direccion" value="#rsDatosEmpleado.direccion#" readonly="true" size="123"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>Tel&eacute;fono:&nbsp;</td>
							<td><input type="text" name="telresidencia" value="#rsDatosEmpleado.telresidencia#" readonly="true"></td>
							<td>Celular:&nbsp;</td>
							<td><input type="text" name="telcelular" value="#rsDatosEmpleado.telcelular#" readonly="true"></td>
							<td>Email:&nbsp;</td>
							<td><input type="text" name="email" value="#rsDatosEmpleado.email#" readonly="true"></td>
						</tr>
					</table>
				</fieldset>
				<br>
				<fieldset>
					<legend><strong>Vigencia&nbsp;</strong></legend>			
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="15%">Inicio Vigencia:&nbsp;</td>
							<td width="20%"><input type="text" name="fechadesde" value="#LSDateFormat(rsDatosEmpleado.fechadesde,'dd/mm/yyyy')#" readonly="true"></td>
							<td width="11%">Fin Vigencia:&nbsp;</td>
							<td><input type="text" name="fechahasta" value="#LSDateFormat(rsDatosEmpleado.fechahasta,'dd/mm/yyyy')#" readonly="true"></td>
							<td width="13%">&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td>Estado:&nbsp;</td>
							<td colspan="6"><input type="text" name="estado" value="#rsDatosEmpleado.estado#" readonly="true"></td>
						</tr>
					</table>
				</fieldset>			
				<br>
				<form method="post" action="datosEmpleado.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="center"><input type="submit" name="lista" value="Ir a Lista Empleados"></td>
						</tr>
					</table>
				</form>
				</cfoutput>
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>