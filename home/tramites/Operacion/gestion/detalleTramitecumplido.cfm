<!--- 
	Creado por: Ana Villavicencio
	Fecha: 09 de Agosto del 2005
	Motivo: Terminar el proceso de diseño de la forma q muestra los datos de un requisito cumplido.
			Nuevo fuente q muestra en detalle los datos asociados a un requerimiento cumplido
 --->
<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfparam name="form.id_tramite" default="#url.id_tramite#">
</cfif>

<cfif isdefined('url.id_persona') and not isdefined('form.id_persona')>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>

<cfinvoke component="home.tramites.componentes.tramites"
	method="obtener_instancia"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
	returnvariable="instancia" />

<cfquery name="rsdata" datasource="#session.tramites.dsn#">
	select nombre || ' ' || apellido1  || ' ' || apellido2 as Funcionario, V.codigo_ventanilla, V.nombre_ventanilla,
		R.es_pago, num_autorizacion, num_referencia, monto_pagado, Pg.moneda, null as fecha_cita, 
		coalesce(fecha_registro, IR.BMfechamod) as fecha, codigo_sucursal, nombre_sucursal
	from TPInstanciaRequisito IR 
	
	left outer join TPFuncionario F
	on IR.id_funcionario = F.id_funcionario
	
	left outer join TPPersona P
	on F.id_persona = P.id_persona
	
	left outer join TPVentanilla V
	on IR.id_ventanilla = V.id_ventanilla
	
	left outer join TPRequisito R
	on IR.id_requisito = R.id_requisito
	
	left outer join TPPago Pg
	on IR.id_instancia = Pg.id_instancia and 
	   IR.id_requisito = Pg.id_requisito

	left outer join TPSucursal S
	on Pg.id_sucursal = Pg.id_sucursal	

	where IR.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia#">
	  and IR.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
</cfquery>

<cfquery name="rsMoneda" datasource="asp">
	select Mnombre 
	from Moneda 
	where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsdata.moneda#">
</cfquery>

<!--- query igual que en la otra pantalla --->
<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
	select 	tc.id_tipo, 
			dr.id_requisito, 
			tc.nombre_campo,
		    tc.id_campo,	 
		    tc.nombre_campo, 
			tp.tipo_dato,
			tp.formato,
			tp.mascara,
		    tp.clase_tipo, 
		    tp.tipo_dato, 
		    tp.mascara, 
		    tp.formato, 
		    tp.valor_minimo, 
		    tp.valor_maximo, 
		    tp.longitud, 
		    tp.escala, 
		    tp.nombre_tabla,

			<cfif Len(instancia)>
				cam.valor 
			<cfelse>
				null
			</cfif> as valor
	from TPRequisito dr
		join TPDocumento d
			on d.id_documento = dr.id_documento
		join DDTipoCampo tc
			on tc.id_tipo = d.id_tipo
		join DDTipo tp
			on tp.id_tipo = tc.id_tipocampo
		<cfif Len(instancia)>
		left join TPInstanciaRequisito ir
			on ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia#">
			and ir.id_requisito = dr.id_requisito
		left join DDRegistro reg
			on reg.id_registro = ir.id_registro
		left join DDCampo cam
			on cam.id_registro = reg.id_registro
			and cam.id_campo = tc.id_campo
		</cfif>
	where dr.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
</cfquery>

<table width="520" cellpadding="0" cellspacing="0">
	<cfoutput>
	<tr><td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Detalle del Requisito</strong></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<cfif LEN(TRIM(rsdata.Funcionario))>
		<tr>
			<td><strong>Atendido por:</strong>&nbsp;</td>
		  <td>#rsdata.Funcionario#</td>
		</tr>
	</cfif>
	<cfif LEN(TRIM(rsdata.fecha))>
		<tr>
			<td><strong>Fecha:</strong>&nbsp;</td>
			<td>#LSDateFormat(rsdata.fecha,'dd/mm/yyyy')#</td>
		</tr>
	</cfif>
	<cfif rsdata.es_pago>
		<cfif LEN(TRIM(rsdata.codigo_sucursal))>
			<tr>
				<td><strong>Sucursal:</strong>&nbsp;</td>
				<td>#rsdata.codigo_sucursal# - #rsdata.nombre_sucursal#</td>
			</tr>
		</cfif>
	</cfif>
	<cfif LEN(TRIM(rsdata.codigo_ventanilla))>
	<tr>
		<td><strong>Ventanilla:</strong>&nbsp;</td>
		<td>#rsdata.codigo_ventanilla# - #rsdata.nombre_ventanilla#</td>
	</tr>
	</cfif>
	<cfif rsdata.es_pago>
		<cfif rsdata.monto_pagado EQ 0>
			<tr>
				<td><strong>Monto Pagado:</strong>&nbsp;</td>
				<td>#NumberFormat(rsdata.monto_pagado,'999,999,999.99')# #rsdata.moneda# #rsMoneda.Mnombre#</td>
			</tr>
			<tr>
				<td><strong>N&uacute;mero de autorizaci&oacute;n:</strong>&nbsp;</td>
				<td>#rsdata.num_autorizacion#</td>
			</tr>
			<tr>
				<td><strong>N&uacute;mero de referencia:</strong>&nbsp;</td>
				<td>#rsdata.num_referencia#</td>
			</tr>
		</cfif>
	</cfif>
	<cfif LEN(TRIM(rsdata.fecha_cita))>
		<tr>
			<td><strong>Fecha de la cita:</strong>&nbsp;</td>
			<td>#LSDateFormat(rsdata.fecha_cita,'dd/mm/yyyy')#</td>
		</tr>
	</cfif>
	</cfoutput>
	<cfif datorequisito.RecordCount>
		<cfoutput query="datorequisito">
			<cfif LEN(TRIM(datorequisito.valor))>
				<tr>
					<td nowrap>
					<strong>#datorequisito.nombre_dato#:</strong>&nbsp;</td>
					<td>
						#valor#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfif>
</table>
