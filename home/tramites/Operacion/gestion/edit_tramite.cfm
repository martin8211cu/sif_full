<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfparam name="form.id_tramite" default="#url.id_tramite#">
</cfif>
<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>
<cfif isdefined("url.id_instancia") and not isdefined("form.id_instancia")>
	<cfparam name="form.id_instancia" default="#url.id_instancia#">
</cfif>

<cfif not isdefined("form.id_tramite")>
<cfthrow message="Error. No se ha definido el tramite.">
</cfif>
<cfif not isdefined("form.id_persona")>
<cfthrow message="Error. No se ha definido la persona.">
</cfif>

<cf_template>
<cf_templatearea name=title>Tr&aacute;mite</cf_templatearea>
<cf_templatearea name=body>
<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Detalle del Trámite" >

<table width="700" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><cfinclude template="hdr_persona.cfm"></td>
  </tr>
  <tr>
    <td><cfinclude template="hdr_tramite.cfm"></td>
  </tr>

	<cfquery name="instancia" datasource="#session.tramites.dsn#">
		select 	it.id_instancia, 
				it.id_tramite, 
				ir.fecha_registro, 
				ir.completado, 
				p.nombre || ' ' || ' ' || apellido1 || '' || apellido2 as nombre,
				rt.id_requisito, 
				rt.numero_paso, 
				r.codigo_requisito, 
				r.nombre_requisito,
				r.es_pago,
				r.es_capturable
		from TPInstanciaTramite it
		
		inner join TPInstanciaRequisito ir
		on ir.id_instancia = it.id_instancia
		
		left join TPFuncionario f
		on f.id_funcionario = ir.id_funcionario
		
		left join TPPersona p
		on p.id_persona = f.id_persona
		
		inner join TPRReqTramite rt
		on rt.id_requisito = ir.id_requisito
		and rt.id_tramite=it.id_tramite
		
		inner join TPRequisito r
		on r.id_requisito=rt.id_requisito
		
		where it.id_tramite=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
		and it.id_persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		and it.id_funcionario=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
		
		order by rt.numero_paso
	</cfquery>

	<tr><td>&nbsp;</td></tr>

	<cfquery name="institucion" datasource="#session.tramites.dsn#">
		select f.id_inst, id_tipoinst
		from TPFuncionario f
		
		inner join TPInstitucion i
		on i.id_inst = f.id_inst
		
		left join TPRTipoInst ti
		on ti.id_inst = i.id_inst
		
		where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">
	</cfquery>

	<cfset completo = '' >
	<cfset funcionario = '' >
	<cfset otro = '' >
	<cfoutput query="instancia">
		<cfif instancia.completado eq 1 >
			<cfsavecontent variable="tmp">
				<tr bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>" >
				<td>#instancia.numero_paso#</td>
				<td>#trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#</td>
				<td><img border="0" src="../../images/check-verde.gif"></td>
				<td><cfif len(trim(instancia.fecha_registro))>#LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</cfif></td>
				<td>#instancia.nombre#</td>
			</tr>
			</cfsavecontent>
			<cfset completo = completo & tmp >
		<cfelseif instancia.permisos >
			<cfsavecontent variable="tmp">
				<tr bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>" >
				<td>#instancia.numero_paso#</td>
				<td>#trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#</td>
				<td>
					<cfif instancia.es_pago eq 1>	
						<a href="javascript:location.href='req_pago.cfm.cfm?id_persona=#form.id_persona#&id_tramite=#form.id_tramite#&id_instancia=#instancia.id_instancia#&id_requisito=#instancia.id_requisito#'">Pagar</a>
					<cfelseif instancia.es_capturable eq 1>	
						Autorizaci&oacute;n
					<cfelse>
						No esta en expediente	
				</cfif>
				</td>
				<td><cfif len(trim(instancia.fecha_registro))>#LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</cfif></td>
				<td>#instancia.nombre#</td>
			</tr>
			</cfsavecontent>
			<cfset funcionario = funcionario & tmp >
		<cfelse>
			<cfsavecontent variable="tmp">
				<tr bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>" >
				<td>#instancia.numero_paso#</td>
				<td>#trim(instancia.codigo_requisito)# - #instancia.nombre_requisito#</td>
				<td>
					<cfif instancia.es_pago eq 1>	
						Pagar
					<cfelseif instancia.es_capturable eq 1>	
						Autorizaci&oacute;n
					<cfelse>
						No esta en expediente	
				</cfif>
				</td>
				<td><cfif len(trim(instancia.fecha_registro))>#LSDateFormat(instancia.fecha_registro,'dd/mm/yyyy')#</cfif></td>
				<td>#instancia.nombre#</td>
			</tr>
			</cfsavecontent>
			<cfset otro = otro & tmp >
		</cfif>
	</cfoutput>

	<cfoutput>
	<cfif len(trim(completo))>
		<tr><td class="subTitulo">Requisitos Completados</td></tr>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr bgcolor="##F5F5F5">
						<td width="29%"><strong>N&uacute;m</strong></td>
						<td width="8%"><strong>Requisito</strong></td>
						<td width="17%"><strong>Estado</strong></td>
						<td width="15%"><strong>Fecha</strong></td>
						<td width="31%"><strong>Recibido por</strong></td>
					</tr>
					<tr>#completo#</tr>
				</table>
			</td>
		</tr>
	</cfif>

	<cfif len(trim(funcionario))>
		<tr><td class="subTitulo">Hacer aqui</td></tr>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr bgcolor="##F5F5F5">
						<td><strong>N&uacute;m</strong></td>
						<td><strong>Requisito</strong></td>
						<td><strong>Estado</strong></td>
						<td><strong>Fecha</strong></td>
						<td><strong>Recibido por</strong></td>
					</tr>
					<tr>#funcionario#</tr>
				</table>
			</td>
		</tr>
	</cfif>
	
	<cfif len(trim(otro))>
		<tr><td class="subTitulo">Ir a otro lado</td></tr>
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr bgcolor="##F5F5F5">
						<td><strong>N&uacute;m</strong></td>
						<td><strong>Requisito</strong></td>
						<td><strong>Estado</strong></td>
						<td><strong>Fecha</strong></td>
						<td><strong>Recibido por</strong></td>
					</tr>
					<tr>#otro#</tr>
				</table>
			</td>
		</tr>
	</cfif>	
	</cfoutput>

	<tr><td>&nbsp;</td></tr>

	<tr><td align="center"><input name="Submit" type="submit" onClick="location.href='gestion.cfm'" value="Regresar"></td></tr>
	<tr><td>&nbsp;</td></tr>
</table>

<cf_web_portlet_end>
</cf_templatearea>
</cf_template>