<cfparam name="modo" default="ALTA">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo1 		= t.Translate('LB_Titulo1','Tiendas Full')>
<cfset LB_Titulo2		= t.Translate('LB_Titulo2','Reporte de Clientes')>
<cfset LB_Titulo3		= t.Translate('LB_Titulo3','Generado el')>

<cfset LB_SNIdentificacion		= t.Translate('LB_SNIdentificacion', 'SN Identificacion')>
<cfset LB_SNnombre				= t.Translate('LB_SNnombre', 'SN Nombre')>
<cfset LB_ctaD					= t.Translate('LB_ctaD', 'Distribuidor')>
<cfset LB_ctaTC					= t.Translate('LB_ctaTC', 'Tarjetahabiente')>
<cfset LB_ctaTM					= t.Translate('LB_ctaTM', 'Mayorista')>
<cfset LB_SNCidentificacion		= t.Translate('LB_SNCidentificacion', 'Cliente Identificacion')>
<cfset LB_SNCnombre				= t.Translate('LB_SNCnombre', 'Cliente Nombre')>
<cfset LB_SNCdireccion			= t.Translate('LB_SNCdireccion', 'Cliente Direccion')>
<cfset LB_SNCtelefono			= t.Translate('LB_SNCtelefono', 'Cliente Telefono')>
<cfset LB_SNCfax				= t.Translate('LB_SNCfax', 'Cliente Fax')>
<cfset LB_SNCemail				= t.Translate('LB_SNCemail', 'Cliente Email')>


<cfset prevPag="reporteClientes.cfm">
<cfset targetAction="reporteClientes_sql.cfm">
<cfinclude template="imprimirReporte.cfm" >


<cfquery name="q_DatosReporte" datasource="ldcom">
	select distinct top 3000 Curp_Clave, Curp_Nombre, concat(Curp_Apellido1, ' ', Curp_Apellido2) CURP_Apellidos, Curp_Fecha_Nacimiento,
		case Curp_Sexo when 1 then 'Hombre' else 'Mujer' end Sexo, Curp_Email, 
		CURP_Calle, CURP_Codigo_Postal, concat(Curp_Telefono1, ', ', Curp_Telefono2) CURP_TELEFONOS,
		n1.Nivel1_Nombre Estado, n2.Nivel2_Nombre Ciudad, n3.Nivel3_Nombre Colonia
	from curp c
	inner join Nivel1 n1 on c.NIvel1_Id = n1.Nivel1_id
	inner join Nivel2 n2 on c.NIvel1_Id = n2.Nivel1_id and c.NIvel2_Id = n2.Nivel2_id
	inner join Nivel3 n3 on c.NIvel1_Id = n3.Nivel1_id and c.NIvel2_Id = n3.Nivel2_id and c.NIvel3_Id = n3.Nivel3_id
	where 1 = 1
	<cfif isdefined("form.Nombre") and trim(form.Nombre) neq "">
			and upper(Curp_Nombre) like upper('%#form.nombre#%')
	</cfif>
	<cfif isdefined("form.Apellido1") and trim(form.Apellido1) neq "">
			and upper(Curp_Apellido1) like upper('%#form.Apellido1#%')
	</cfif>
	<cfif isdefined("form.Apellido2") and trim(form.Apellido2) neq "">
			and upper(Curp_Apellido2) like upper('%#form.Apellido2#%')
	</cfif>
	<cfif isdefined("form.sexo") and trim(form.sexo) neq "">
			and Curp_Sexo = #form.sexo#
	</cfif>
	<cfif isdefined("Form.nacimiento") && Form.nacimiento neq "">
		<cfset form.nacimiento = ListToArray(form.nacimiento,'/')>
		<cfset form.nacimiento = "#form.nacimiento[3]#-#form.nacimiento[2]#-#form.nacimiento[1]#">
		and datediff(day,Curp_Fecha_Nacimiento,<cfqueryparam cfsqltype="cf_sql_date" value="#form.nacimiento#">) = 0
	</cfif>
	<cfif isdefined("form.Curp") and trim(form.Curp) neq "">
			and upper(Curp_Clave) like upper('%#form.Curp#%')
	</cfif>
	<cfif isdefined("form.direccion") and trim(form.direccion) neq "">
			and upper(CURP_Calle) like upper('%#form.direccion#%')
	</cfif>
	<cfif isdefined("form.cp") and trim(form.cp) neq "">
			and upper(CURP_Codigo_Postal) like upper('%#form.cp#%')
	</cfif>
	<cfif isdefined("form.telefono") and trim(form.telefono) neq "">
			and (upper(Curp_Telefono1) like upper('%#form.telefono#%') or upper(Curp_Telefono2) like upper('%#form.telefono#%'))
	</cfif>
	<cfif isdefined("form.email") and trim(form.email) neq "">
			and upper(Curp_Email) like upper('%#form.email#%')
	</cfif>
	<cfif isdefined("form.estado") and trim(form.estado) neq "">
			and upper(Nivel1_Nombre) like upper('%#form.estado#%')
	</cfif>
	<cfif isdefined("form.ciudad") and trim(form.ciudad) neq "">
			and upper(Nivel2_Nombre) like upper('%#form.ciudad#%')
	</cfif>
	<cfif isdefined("form.colonia") and trim(form.colonia) neq "">
			and upper(Nivel3_Nombre) like upper('%#form.colonia#%')
	</cfif>
</cfquery>

<cfset modo="ALTA">


<cfoutput>
<!--- Tabla para mostrar resultados del reporte generado --->
<div id="#printableArea#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
			
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="4">&nbsp;</td></tr>
					
					<tr>
						<td height="22" align="center" width="40%">
							<span class="style1" style="font-family: verdana; font-size: 200%">#LB_Titulo1#</span><br>
							<span style="font-family: verdana; font-size: 100%"><strong>#LB_Titulo2#</strong><br></span>
							<strong>#LB_Titulo3# #LSDateFormat(Now(),'dd/mm/yyyy')#</strong><br>
						</td>
					</tr>
					<tr height="22" align="center"></tr>
					<tr>
						<table width="100%" border="0">
							<tr>
								<td colspan="11" align="right">
									Filtros:
									[Cliente]
									<cfif isdefined("form.Nombre") and trim(form.Nombre) neq "">
										[Nombre = #Form.Nombre#]
									</cfif>
									<cfif isdefined("form.Apellido1") and trim(form.Apellido1) neq "">
										[Apellido1 = #Form.Apellido1#]
									</cfif>
									<cfif isdefined("form.Apellido2") and trim(form.Apellido2) neq "">
										[Apellido2 = #Form.Apellido2#]
									</cfif>
									<cfif isdefined("form.sexo") and trim(form.sexo) neq "">
										[Sexo = #Form.sexo#]
									</cfif>
									<cfif isdefined("Form.nacimiento") && Form.nacimiento neq "">
										[Fecha nacimiento = #Form.nacimiento#]
									</cfif>
									<cfif isdefined("form.Curp") and trim(form.Curp) neq "">
										[Curp = #Form.curp#]
									</cfif>
									<cfif isdefined("form.direccion") and trim(form.direccion) neq "">
										[Direccion = #Form.direccion#]
									</cfif>
									<cfif isdefined("form.cp") and trim(form.cp) neq "">
										[CP = #Form.cp#]
									</cfif>
									<cfif isdefined("form.telefono") and trim(form.telefono) neq "">
										[Telefono = #Form.telefono#]
									</cfif>
									<cfif isdefined("form.email") and trim(form.email) neq "">
										[Correo = #Form.email#]
									</cfif>
									<cfif isdefined("form.estado") and trim(form.estado) neq "">
										[Estado = #Form.estado#]
									</cfif>
									<cfif isdefined("form.ciudad") and trim(form.ciudad) neq "">
										[Ciudad = #Form.ciudad#]
									</cfif>
									<cfif isdefined("form.colonia") and trim(form.colonia) neq "">
										[Colonia = #Form.colonia#]
									</cfif>
								</td>
							</tr>
							<tr style="background-color: ##A9A9A9;">
								<td>CURP</td>
								<td>Nombre</td>
								<td>Apellidos</td>
								<td>Fecha nacimiento</td>
								<td>Direcci&oacute;n</td>
								<td>Estado</td>
								<td>Ciudad</td>
								<td>Colonia</td>
								<td>CP</td>
								<td>Tel&eacute;fonos</td>
								<td>Correo</td>
							</tr>
							<cfif q_DatosReporte.RecordCount gt 0>
								<cfloop query="q_DatosReporte">
									<tr>
										<td>#ucase(q_DatosReporte.Curp_Clave)#</td>
										<td>#ucase(q_DatosReporte.Curp_Nombre)#</td>
										<td>#ucase(q_DatosReporte.CURP_Apellidos)#</td>
										<td>#DateFormat(q_DatosReporte.Curp_Fecha_Nacimiento,"DD/MM/YYYY")#</td>
										<td>#ucase(q_DatosReporte.CURP_Calle)#</td>
										<td>#ucase(q_DatosReporte.Estado)#</td>
										<td>#ucase(q_DatosReporte.Ciudad)#</td>
										<td>#ucase(q_DatosReporte.COlonia)#</td>
										<td>#q_DatosReporte.CURP_Codigo_Postal#</td>
										<td>#q_DatosReporte.CURP_TELEFONOS#</td>
									</tr>
								</cfloop>
							<cfelse>
									<tr><td colspan="9">&nbsp;</td></tr>
									<tr><td colspan="9" align="center"><font color="red"><span style="text-align: center;">--- No se encontraron resultados ---</span></font></td></tr>
							</cfif>
						</table>
					</tr>
				</table>
			</td>	
		</tr>
	</table>
</div>
</cfoutput>

