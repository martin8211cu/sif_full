<cf_templatecss>
	<!--- FALTA filtrar por el id_tramite --->
	<cfquery name="data" datasource="tramites_cr">
		select t.id_tramite, 
			   t.codigo_tramite, 
			   t.nombre_tramite, 
			   t.descripcion_tramite 
		from TPTramite t
		where t.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite.id_tramite#">		
	</cfquery>
	
	<cfquery name="docs" datasource="tramites_cr">
		select td.nombre_archivo,
			   td.tipo_mime, 
			   td.contenido,
			   td.resumen
		from TPTramiteDoc td
 		where td.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite.id_tramite#">
	</cfquery>

	<cfquery name="reqs" datasource="tramites_cr">
		select rq.nombre_requisito,
			   rq.codigo_requisito,
			   r.numero_paso,
			   rq.descripcion_requisito,
			   rq.id_requisito
		from TPRequisito rq
			join TPRReqTramite r
				on r.id_requisito = rq.id_requisito
 		where r.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#tramite.id_tramite#">
		order by r.numero_paso
	</cfquery>

	<cfquery name="rsInstitucion" datasource="tramites_cr">
		select id_inst, nombre_inst, codigo_inst
		from TPInstitucion
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	</cfquery>

	<br>
	<table width="98%" align="center" cellpadding="4" cellspacing="0" >
		<tr>
		  <td class="tituloCorte" colspan="2" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" ><font size="2">Informaci&oacute;n del Tr&aacute;mite</font></td>
		</tr>
		<cfoutput>
		<tr><td  colspan="2"><font size="2"><strong>Tr&aacute;mite:</strong> #trim(data.codigo_tramite)#-#data.nombre_tramite#</font></td></tr>
		<cfif len(data.descripcion_tramite) >
		<tr><td  colspan="2" style="padding-bottom:0px;"><font size="2"><strong>Descripci&oacute;n:</strong></font></td></tr>
		<tr><td  colspan="2"><font size="2">#trim(data.descripcion_tramite)#</font></td></tr>
		</cfif>
		</cfoutput>
		
		<cfif reqs.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td  colspan="2" class="tituloCorte" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><font size="2">Requisitos del Tr&aacute;mite</font></td></tr>
			<tr><td colspan="2"><table width="100%" border="0">
			<cfoutput query="reqs">
				<!--- =================================================================== --->			
				<!--- =================================================================== --->
				<cfquery name="datorequisito" datasource="tramites_cr" >
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
							on ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
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
											<td><cfif len(trim(datorequisito.fecha_registro))>#LSDateFormat(datorequisito.fecha_registro,'dd/mm/yyyy')#</cfif></td>
										</tr>
			
										<cfif len(trim(datorequisito.id_ventanilla))>
											<cfquery name="ventanilla" datasource="tramites_cr">
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
											<cfquery name="funcionario" datasource="tramites_cr">
												select nombre, apellido1, apellido2
												from TPFuncionario f
												
												inner join TPPersona p
												on p.id_persona=f.id_persona
												
												where f.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datorequisito.id_funcionario#">
											</cfquery>
										</cfif>
										<tr>
											<td nowrap><strong>Funcionario que registro:</strong></td>
											<td><cfif len(trim(datorequisito.id_funcionario))>#funcionario.nombre# #funcionario.apellido1# #funcionario.apellido2#</cfif></td>
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