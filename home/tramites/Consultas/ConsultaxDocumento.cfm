<cfif isdefined("Form.id_vista1") and Len(Trim(Form.id_vista1))>
	<cfset a = ListToArray(Form.id_vista1, '|')>
	<cfset Form.id_vista = a[1]>
	<cfset Form.id_tipo = a[2]>
</cfif>


<cfquery name="rsVistas" datasource="#session.tramites.dsn#">
	select a.id_vista, a.id_tipo, a.nombre_vista, a.titulo_vista, a.es_interna
	from DDVista a
		inner join DDTipo b
			on b.id_tipo = a.id_tipo
			and b.clase_tipo = 'C'
		where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.vigente_desde and a.vigente_hasta
		and a.es_interna = 0
		and a.nombre_vista not like ' REG-%'
	order by a.nombre_vista
</cfquery>

<cfif isdefined("Form.id_vista") and Len(Trim(Form.id_vista))>
	<cfquery name="rsNombresCampos" datasource="#session.tramites.dsn#">
		select a.id_campo 
		from DDVistaCampo a
			inner join DDTipoCampo b
			on b.id_campo = a.id_campo
			and b.es_descripcion = 1
		where a.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
		order by b.orden_campo, b.id_campo
	</cfquery>
</cfif>

<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->

<cfif isdefined("form.FechaI") and len(trim(form.FechaI)) and isdefined("form.FechaF") and len(trim(form.FechAF))>
	<cfset form.FechaI = form.FechaI >
	<cfset form.FechaF = form.FechaF >
	<cfif LSParseDateTime(FechaI) gt LSParseDateTime(FechaF)>
		<cfset tmp = form.FechaI >
		<cfset form.FechaI = form.FechaF >
		<cfset form.FechaF = tmp >
	</cfif>
</cfif>

<cf_template>
	<cf_templatearea name="title">
		Consulta por Documento
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="Consulta por Documento">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfoutput>
				<form name="frmVista" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td colspan="2">&nbsp;</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td class="fileLabel" align="right" width="15%" nowrap>Seleccione el documento que desea consultar:</td>
						<td>
							<select name="id_vista1" onChange="javascript: if (this.value != '-1') { this.form.submit(); }">
								<option value="-1">[Seleccionar Documento...]</option>
							<cfloop query="rsVistas">
								<option value="#rsVistas.id_vista#|#rsVistas.id_tipo#"<cfif isdefined("Form.id_vista") and Form.id_vista EQ rsVistas.id_vista> selected</cfif>>#rsVistas.nombre_vista# - #rsVistas.titulo_vista#</option>
							</cfloop>
							</select>
						</td>
					  </tr>
					  <tr>
						<td colspan="2">&nbsp;</td>
					  </tr>
					</table>
				</form>
			</cfoutput>
				
				
			<!--- Si ya se ha seleccionado una vista --->
			<cfif isdefined("Form.id_vista") and Len(Trim(Form.id_vista)) and Form.id_vista NEQ "-1">
				<form name="form1" method="post" action="ConsultaxDocumentoDetalle.cfm" style="margin: 0;">
					<input type="hidden" name="id_vista" value="<cfoutput>#form.id_vista#</cfoutput>">
					<input type="hidden" name="id_tipo" value="">
					<input type="hidden" name="id_registro" value="">
					<input type="hidden" name="id_persona" value="">
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
						<tr>
							<td bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;">
								<strong>
									Lista de personas que poseen este documento
								</strong>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<cfquery name="listaCatalogos" datasource="#session.tramites.dsn#">
									select a.id_vista, b.id_tipo, b.id_registro, b.BMfechamod, tc.orden_campo, tc.nombre_campo, tc.id_campo, 
									   d.nombre, d.apellido1, d.apellido2, d.id_persona, d.identificacion_persona,
									   (case when tc.es_descripcion = 1 then c.valor else '' end) as valor
									from DDVista a
										inner join DDRegistro b
											on b.id_tipo = a.id_tipo
											<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
												and b.BMfechamod >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaI#">
											</cfif> 
											<cfloop query="rsNombresCampos">
												<cfset nombre_campo = "campo_" & rsNombresCampos.id_campo>
												<cfif IsDefined("Form.#nombre_campo#") and Len(Trim(Evaluate("Form.#nombre_campo#")))>
												  and b.id_registro in (
													  select x.id_registro from DDCampo x
													  where x.id_campo = #rsNombresCampos.id_campo#
														and upper(x.valor) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Evaluate('Form.#nombre_campo#'))#%">
												  )
												</cfif>
											</cfloop>
										inner join DDVistaCampo vc
											on vc.id_vista = a.id_vista
										inner join DDTipoCampo tc
											on tc.id_tipo = a.id_tipo
											and tc.id_campo = vc.id_campo
											and tc.es_descripcion = 1
										left outer join DDCampo c
											on c.id_registro = b.id_registro
											and c.id_campo = vc.id_campo
										left outer join TPPersona d
											on d.id_persona = b.id_persona
										
									where a.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_vista#">
									<cfif isdefined("form.campo_nombre") and len(trim(form.campo_nombre))>
										and upper(d.nombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Trim(form.campo_nombre))#%">
									</cfif>
									<cfif isdefined("form.campo_identificacion") and len(trim(form.campo_identificacion))>
										and d.identificacion_persona >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.campo_identificacion#">
									</cfif>
								
									order by a.id_vista, b.id_tipo, b.id_registro, tc.orden_campo, tc.id_campo
								</cfquery>
								<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
									<tr class="tituloListas">
										<td width="40%">&nbsp;</td>
									</tr>
								 </table>
								 <!---Prueba rebeca Filtros --->
								 <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
									<tr>
										<td class="tituloListas"><strong>Desde:</strong>
											<cfif IsDefined("Form.FechaI") and Len(Trim(Form.FechaI))>
												<cfset fecha = LSDateFormat(Form.FechaI,'dd/mm/yyyy')>
											<cfelse>
												<cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
											</cfif>
											<cf_sifcalendario name="FechaI" form="form1" value="#fecha#">
										</td>
										<cfoutput>
											<td class="tituloListas"><input type="text" name="campo_identificacion" value="<cfif IsDefined("form.campo_identificacion") and Len(Trim("form.campo_identificacion"))>#form.campo_identificacion#</cfif>"></td>
											<td class="tituloListas"><input type="text" name="campo_nombre" value="<cfif IsDefined("form.campo_nombre") and Len(Trim("form.campo_nombre"))>#form.campo_nombre#</cfif>"></td>
										</cfoutput>
										<cfoutput query="rsNombresCampos">
											<td class="tituloListas"><input type="text" name="campo_#id_campo#" value="<cfif IsDefined("Form.campo_#id_campo#") and Len(Trim(Evaluate("Form.campo_#id_campo#")))>#Evaluate('form.campo_#id_campo#')#</cfif>"></td>
										</cfoutput>
										<td class="tituloListas"><input type="button" name="btnFiltrar" value="Filtrar" onClick="javascript: funcFiltrar();"></td>
									</tr>
									<!------------------------------------------------------> 
									<cfif listaCatalogos.recordCount>
										<cfoutput query="listaCatalogos" group="id_registro">
											<!--- Titulo de la Lista --->
											<cfif listaCatalogos.currentrow EQ 1>
												<tr>
													<td class="tituloListas">Fecha de Registro</td>
													<td class="tituloListas">Identificaci&oacute;n</td>
													<td class="tituloListas">Nombre</td>
													<cfoutput>
														<td class="tituloListas">#nombre_campo#</td>
													</cfoutput>
													<td class="tituloListas">&nbsp;</td>
												</tr>
											</cfif>
											<tr <cfif listaCatalogos.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> onMouseOver="javascript: this.style.cursor = 'pointer'; this.className='listaParSel';" onMouseOut="this.className='<cfif listaCatalogos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';" onClick="javascript: return funcEditar('#listaCatalogos.id_registro#','#listaCatalogos.id_persona#');">
												<cfset cuenta = 0>
												<cfset cols = 0>
												<td>#LSDateFormat(listaCatalogos.BMfechamod,'dd/mm/yyyy')#</td>
												<td>#listaCatalogos.identificacion_persona#</td>
												<td>#listaCatalogos.nombre#  #listaCatalogos.apellido1# #listaCatalogos.apellido2#</td>
												<cfoutput>
													<td>
														<cfif Len(Trim(listaCatalogos.valor))>
															<cfset cuenta = cuenta + 1>
															#listaCatalogos.valor#
														<cfelse>
															&nbsp;
														</cfif>
													</td>
													<cfset cols = cols + 1>
												</cfoutput>
												<td>&nbsp;</td>
												<!---<cfif cuenta EQ 0>
													<td colspan="#cols#">
														Haga Click Aqui
													</td>
												</cfif>--->
											</tr>
										</cfoutput>
									<cfelse>
										<cfoutput>
										<tr>
											<td align="center" colspan="#rsNombresCampos.recordCount + 4#" class="tituloListas">--- No se encontraron Registros ---</td>
										</tr>
										</cfoutput>
									</cfif>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					</table>
				</form>
				<cfoutput>
					<script language="javascript" type="text/javascript">
						function funcEditar(id_registro, id_persona) {
							document.form1.id_vista.value = '#Form.id_vista#';
							document.form1.id_tipo.value = '#Form.id_tipo#';
							document.form1.id_registro.value = id_registro;
							document.form1.id_persona.value = id_persona;
							document.form1.submit();
						} 
					
						function funcFiltrar(){
							document.form1.action='ConsultaxDocumento.cfm';		
							document.form1.submit();
						}
					</script>
				</cfoutput>
			</cfif>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>