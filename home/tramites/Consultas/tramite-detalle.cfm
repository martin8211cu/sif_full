<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Informaci&oacute;n De Tr&aacute;mites</title>
</head>

<body>
	<cf_templatecss>
<style type="text/css">
	.tituloMantenimiento2 {
		font-weight: bolder;
		text-align: center;
		vertical-align: middle;
		font-size: small;
		padding: 2px;
		background-color: #CCE3F8;
		border: 1px solid #356595;
	}	
</style>	
	

	<!--- FALTA filtrar por el id_tramite --->
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select t.id_tramite, 
			   t.codigo_tramite, 
			   t.nombre_tramite, 
			   t.descripcion_tramite ,
			   it.id_instancia	
		from TPTramite t
		
		inner join TPInstanciaTramite it
		on it.id_tramite=t.id_tramite
		and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
		and id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
		
		where t.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">		
	</cfquery>
	
	<cfquery name="docs" datasource="#session.tramites.dsn#">
		select td.nombre_archivo,
			   td.tipo_mime, 
			   td.contenido,
			   td.resumen
		from TPTramiteDoc td
 		where td.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
	</cfquery>

	<cfquery name="reqs" datasource="#session.tramites.dsn#">
		select rq.nombre_requisito,
			   rq.codigo_requisito,
			   r.numero_paso,
			   rq.descripcion_requisito,
			   rq.id_requisito
		from TPRequisito rq
			join TPRReqTramite r
				on r.id_requisito = rq.id_requisito
 		where r.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
		order by r.numero_paso
	</cfquery>

	<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
		select id_inst, nombre_inst, codigo_inst
		from TPInstitucion
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	</cfquery>

	<tr style="background-color:#ededed" >
		<td colspan="4" style="border-bottom:1px solid black">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr style="background-color:#ededed">
					<td rowspan="2"><cfoutput><img src="/cfmx/home/tramites/public/logo_inst.cfm?id_inst=#rsInstitucion.id_inst#" width="146" height="59"></cfoutput></td>
				  	<td style="font-size:16px">&nbsp;</td>
				  	<td colspan="4" style="font-size:16px"><cfoutput>#rsInstitucion.nombre_inst#</cfoutput></td>
				</tr>
				
				<tr style="background-color:#ededed">
					<td style="font-size:14px">&nbsp;</td>
				  	<td colspan="4" style="font-size:14px; "><strong>Detalle de Tr&aacute;mite&nbsp;</strong></td>
				</tr>
			</table>
		</td>
	</tr>
	
	
	<table width="100%">
		<tr><td><cfinclude template="../Operacion/gestion/hdr_persona.cfm"></td></tr>
	</table>

	<table width="100%" cellpadding="4" cellspacing="0" >
		<tr>
		  <td class="tituloCorte" colspan="2" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" ><font size="2">Informaci&oacute;n del Tr&aacute;mite</font></td>
		</tr>
		<cfoutput>
		<tr><td  colspan="2"><font size="2"><strong>No. Tr&aacute;mite:&nbsp;</strong>#data.id_instancia#</font></td></tr>
		<tr><td  colspan="2"><font size="2"><strong>Tr&aacute;mite:&nbsp;</strong> #trim(data.codigo_tramite)#-#data.nombre_tramite#</font></td></tr>
		<cfif len(data.descripcion_tramite) >
		<tr><td  colspan="2" style="padding-bottom:0px;"><font size="2"><strong>Descripci&oacute;n:</strong></font></td></tr>
		<tr><td  colspan="2"><font size="2">#trim(data.descripcion_tramite)#</font></td></tr>
		</cfif>
		</cfoutput>
		
		<cfif docs.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td  colspan="2" class="tituloCorte" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><font size="2">Lista de Documentaci&oacute;n adicional</font></td></tr>
			<cfoutput query="docs">
				<tr>
					<td width="30%" valign="top"><font size="2"><a href="##">#docs.nombre_archivo#</a></font></td>
					<td valign="top"><font size="2">#docs.resumen#</font></td>
				</tr>
			</cfoutput>
		</cfif>
		
		<cfif reqs.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td  colspan="2" class="tituloCorte" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><font size="2">Requisitos del Tr&aacute;mite</font></td></tr>
			<tr><td colspan="2"><table width="100%" border="0">
			<cfoutput query="reqs">
				<!--- =================================================================== --->			
				<!--- =================================================================== --->
				<cfquery name="datorequisito" datasource="#session.tramites.dsn#" >
					select 	tc.id_tipo, 
							dr.id_requisito, 
							tc.nombre_campo,
							tc.nombre_campo,
							cam.valor as valor,
							ir.id_funcionario,
							ir.id_ventanilla,
							ir.fecha_registro,
							ir.completado
					from TPRequisito dr
						join TPDocumento d
							on d.id_documento = dr.id_documento
						join DDTipoCampo tc
							on tc.id_tipo = d.id_tipo
						join DDTipo tp
							on tp.id_tipo = tc.id_tipocampo
							
						join DDVista v
							on v.id_vista = dr.id_vista
						join DDVistaCampo vc
							on vc.id_vista = dr.id_vista
							and vc.id_campo = tc.id_campo
						left join TPInstanciaRequisito ir
							on ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_instancia#">
							and ir.id_requisito = dr.id_requisito
						left join DDRegistro reg
							on reg.id_registro = ir.id_registro
						left join DDCampo cam
							on cam.id_registro = reg.id_registro
							and cam.id_campo = tc.id_campo
					where dr.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#reqs.id_requisito#">
				</cfquery>
				<!--- =================================================================== --->			
				<!--- =================================================================== --->
			
				<tr>
					<td width="3%" valign="top"><font size="2">#CurrentRow#.</font></td>
					<td valign="top">
						<font size="2"><strong>#nombre_requisito#</strong></font></td>
				</tr>
				<cfif Len(Trim(descripcion_requisito)) GT 0 and Trim(descripcion_requisito) NEQ '&nbsp;'>
				<tr>
					<td></td>
					<td valign="top">#descripcion_requisito#</td>
				</tr>
				</cfif>
				
				<tr>
					<td ></td>
					<td >
						<table bgcolor="##FAFAFA" style="border:1px solid gray; " width="98%" align="center" cellpadding="2" cellspacing="0">
							<tr>
								<td><strong><font size="2">Informaci&oacute;n de Registro</font></strong></td>
								<td><strong><font size="2">Informaci&oacute;n Adicional</font></strong></td>
							</tr>
								
							<tr>
								<td valign="top" width="50%">
									<table width="100%" cellpadding="1">
										<tr>
											<td ><strong>Estado:</strong>&nbsp;</td>
											<td ><cfif datorequisito.completado eq 1 >Terminado<cfelseif len(trim(datorequisito.fecha_registro))>En Proceso<cfelse>Pendiente</cfif></td>
										</tr>
										<tr>
											<td width="1%" nowrap><strong>Fecha de Registro:</strong>&nbsp;</td>
											<td>#datorequisito.fecha_registro#</td>
										</tr>
			
										<cfif len(trim(datorequisito.id_ventanilla))>
											<cfquery name="ventanilla" datasource="#session.tramites.dsn#">
												select v.nombre_ventanilla, v.id_sucursal, s.nombre_sucursal
												from TPVentanilla v
												
												inner join TPSucursal s
												on s.id_sucursal=v.id_sucursal
												
												where v.id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datorequisito.id_ventanilla#">
											</cfquery>
										</cfif>
			
										<tr>
											<td ><strong>Sucursal:</strong>&nbsp;</td>
											<td ><cfif len(trim(datorequisito.id_ventanilla))>#ventanilla.nombre_sucursal#</cfif></td>
										</tr>
			
										<tr>
											<td ><strong>Ventanilla:</strong>&nbsp;</td>
											<td ><cfif len(trim(datorequisito.id_ventanilla))>#ventanilla.nombre_ventanilla#</cfif></td>
										</tr>
			
										<cfif len(trim(datorequisito.id_funcionario))>
											<cfquery name="funcionario" datasource="#session.tramites.dsn#">
												select nombre, apellido1, apellido2
												from TPFuncionario f
												
												inner join TPPersona p
												on p.id_persona=f.id_persona
												
												where f.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datorequisito.id_funcionario#">
											</cfquery>
										</cfif>
										<tr>
											<td nowrap><strong>Funcionario que registro:</strong></td>
											<cfif len(trim(datorequisito.id_funcionario))>#funcionario.nombre# #funcionario.apellido1# #funcionario.apellido2#</cfif>
										</tr>
									</table>
								</td>
								<td valign="top" width="50%">
									<table width="100%" cellpadding="1" cellspacing="0">
										<cfif datorequisito.recordcount gt 0 >
											<cfloop query="datorequisito" >
												<tr>
													<td width="1%" nowrap><strong>#datorequisito.nombre_campo#:</strong>&nbsp;</td>
													<td><cfif len(trim(datorequisito.valor)) >#datorequisito.valor#<cfelse>-</cfif></td>
												</tr>
											</cfloop>
										<cfelse>
											<tr><td colspan="2">No existe informaci&oacute;n adicional</td></tr>
										</cfif>
									</table>
								</td>
							</tr>	
						
						</table>
					</td>
				</tr>
			</cfoutput>
			</table></td></tr>
		</cfif>
		<tr><td align="center">--- Fin del reporte ---</td></tr>
	</table>
</body>
</html>