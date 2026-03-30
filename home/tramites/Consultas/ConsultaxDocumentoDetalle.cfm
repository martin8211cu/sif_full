<cfif isdefined('form.id_persona') and len(trim(form.id_persona))>
	<cfquery name="Detalle" datasource="#session.tramites.dsn#">
		select identificacion_persona, nombre, apellido1, 
			   apellido2, nacimiento, id_direccion, sexo, casa, oficina,
			   celular, fax, email1, email2, nacionalidad, extranjero 
		from TPPersona
		where id_persona =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
	</cfquery>
</cfif>

<cfset MaxItems = 15>
<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
<cfset rsVista_titulo_vista = rsVista.titulo_vista>

<cf_template>
	<cf_templatearea name="title">
		Consulta por Documento
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="Consulta por Documento">
			<cfinclude template="/home/menu/pNavegacion.cfm">
					<cfset MaxItems = 15>
					<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
					<cfset rsVista_titulo_vista = rsVista.titulo_vista>
					
					<cfif isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
						<cfset modo = "CAMBIO">
						<cfquery name="rsRegistro" datasource="#session.tramites.dsn#">
							select id_campo, valor
							from DDCampo
							where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_registro#">
						</cfquery>
					<cfelse>
						<cfset modo = "ALTA">
					</cfif>
					<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
						<cfoutput>
							<tr>
								<td class="tituloProceso" align="center" nowrap>
									#rsVista.titulo_vista#
								</td>
							</tr>
						</cfoutput>
					</table>
					<table width="70%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<cfif isdefined('form.id_persona') and len(trim(form.id_persona))>
							<tr>
								<td>
									<cfoutput>
										<table width="70%" align="center" border="0" cellspacing="0" cellpadding="2">
											 <tr>
												<td>&nbsp;</td>
											 </tr>
											 <tr>
												<td align="center">
														<cfinclude template="../Operacion/gestion/hdr_persona.cfm">
												</td>
											 </tr>
											 <tr>
												<td>&nbsp;</td>
											 </tr>
										</table>
									</cfoutput>
								</td>
							</tr>
						</cfif>
						<!-----------------------------------------  ---------------------------------------------->
						<tr>
							<td>
								<table width="70%" align="center" border="0" cellspacing="0" cellpadding="2">
									<tr>
										<cfset current_id_vistagrupo = "">
										<cfoutput query="rsVista" group="columna">
											<td valign="top" <cfif columna gt 1>class="borderleft"</cfif>>
												<cfoutput group="id_vistagrupo">
													<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
														<tr><td colspan="2" align="center" style="border-top: 1px solid black; border-bottom: 1px solid black; padding: 3px;"  bgcolor="##ece9d8"><strong>#etiqueta#</strong></td></tr>
														<cfoutput>
														<cfset valorR = "">
														<cfset valoridR = "">
														<cfif modo EQ "CAMBIO">
															<cfquery name="rsRegistroValor" dbtype="query">
																select valor, valor_ref
																from rsRegistro
																where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVista.id_campo#">
															</cfquery>
															<cfset valorR = rsRegistroValor.valor>
															<cfset valoridR = rsRegistroValor.valor_ref>
														</cfif>
														<cfif rsVista.tipo_dato NEQ "B">
															<tr>
																<td width="1%" class="fileLabel" nowrap colspan="2" >
																	<cfif Len(Trim(valorR)) NEQ 0>#etiqueta_campo#</cfif>
																</td>
															</tr>
															<tr>
														<cfelseif rsVista.tipo_dato NEQ "B">
															<tr>
															<td width="1%" align="right" class="fileLabel" nowrap>
																	<cfif Len(Trim(valorR)) NEQ 0>#etiqueta_campo#</cfif>
															</td>
														</cfif>
															<td width="99%" align="left"  
																<cfif rsVista.tipo_dato NEQ "B">
																	colspan="2"
																<cfelseif  rsVista.tipo_dato EQ "B">
																	colspan="2"
																	class="FileLabel"
																</cfif>>
																
																<cf_tipo clase_tipo="#clase_tipo#" name="c_#id_campo#" id_tipo="#id_tipo#" 
																	id_tipocampo="#id_tipocampo#" tipo_dato="#tipo_dato#" mascara="#mascara#" 
																	formato="#formato#" valor_minimo="#valor_minimo#" valor_maximo="#valor_maximo#" 
																	longitud="#longitud#" escala="#escala#" nombre_tabla="#nombre_tabla#" value="#valorR#" valueid="#valoridR#" readonly = "true">
																<cfif rsVista.tipo_dato EQ "B">
																	<cfif Len(Trim(valorR)) NEQ 0>#etiqueta_campo#</cfif>
																</cfif>
															</td>
														  </tr>
														</cfoutput>
													</table>
												</cfoutput>
											</td>
										</cfoutput>
									</tr>
								</table>
							</td>
						</tr>
					</table>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>	