<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos	</cf_templatearea>
	<cf_templatearea name="body">

<cf_templatecss>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
			<cfset Form.Tcodigo = Url.Tcodigo>
		</cfif>
		<!--- Consulta Relación de Cálculo --->
		<cfquery name="rsRelacionCalculo" datasource="#Session.DSN#">
			select a.RCNid, 
			rtrim(a.Tcodigo) as Tcodigo, 
			a.RCDescripcion, 
			a.RCdesde, 
			a.RChasta,
			(case a.RCestado 
			when 0 then 'Proceso'
			when 1 then 'Cálculo'
			when 2 then 'Terminado'
			when 3 then 'Pagado'
			else ''
			end) as RCestado,
			a.Usucodigo, 
			a.Ulocalizacion, 
			a.ts_rversion,
			b.Tdescripcion,
			b.Mcodigo,
			c.CPcodigo
			from RCalculoNomina a, TiposNomina b, CalendarioPagos c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPid#">
			and a.Ecodigo = b.Ecodigo
			and a.Tcodigo = b.Tcodigo
			and a.RCNid = c.CPid
		</cfquery>
		
		<!--- Pasa algunos valores de la consulta al Form para poder utilizarlos posteriormente --->
		<cfif rsRelacionCalculo.RecordCount gt 0>
			<cfset Form.RCTcodigo = rsRelacionCalculo.Tcodigo>
			<cfset Form.RCdesde = LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')>
			<cfset Form.RChasta = LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')>
			<cfset Form.RCestado = rsRelacionCalculo.RCestado>
			<cfset Form.RCMcodigo = rsRelacionCalculo.Mcodigo>
		</cfif>
		
		<cfset pagina = GetFileFromPath(GetTemplatePath()) >		
		
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
						Default="Tipos de Deducciones a Excluir"
						VSgrupo="103"
						returnvariable="nombre_proceso"/>
					<cf_web_portlet_start titulo="#nombre_proceso#" skin="#Session.Preferences.Skin#" border="true">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<cfset regresar = "/cfmx/rh/nomina/operacion/ResultadoCalculo-lista.cfm?RCNid=#form.CPid#&RCTcodigo=#form.Tcodigo#">
									<cfinclude template="/rh/portlets/pNavegacion.cfm">								
								</td>
							</tr>
							
							<tr>
								<td>
									<!--- Pinta Info de Relación de Cálculo --->
									<cfoutput>
										<table width="95%" border="0" cellspacing="2" cellpadding="2" align="center">
											<tr valign="bottom">
												<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Descripcion">Descripci&oacute;n: </cf_translate></td>
												<td colspan ="3" nowrap>#rsRelacionCalculo.RCDescripcion#</td> 
								  			</tr>
											
											<tr> 
												<td width="21%" align="right" nowrap class="fileLabel"><cf_translate key="LB_Tipo_de_Nomina">Tipo de N&oacute;mina:</cf_translate></td>
												<td width="22%" nowrap> #rsRelacionCalculo.Tdescripcion# </td>
												<td width="9%" align="right" nowrap class="fileLabel">&nbsp;</td>
												<td width="9%" nowrap>&nbsp;</td>
												<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Desde">Fecha Desde:</cf_translate></td>
												<td nowrap> #LSDateFormat(rsRelacionCalculo.RCdesde,'dd/mm/yyyy')# </td>
											</tr>
											
											<tr> 
												<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Calendario_de_Pago">Calendario de Pago:</cf_translate></td>
												<td nowrap>
													<cfif trim(pagina) eq 'ResultadoCalculo-lista.cfm' >
														<table>
															<tr>
																<td><a href="javascript:funcDeducciones();">#rsRelacionCalculo.CPcodigo#</a></td>
																<td><a href="javascript:funcDeducciones();"><img border="0" src="/cfmx/rh/imagenes/Documentos2.gif"></a></td>
															</tr>
														</table>
													<cfelse>
														#rsRelacionCalculo.CPcodigo#
													</cfif>
												</td>
								  				<td align="right" nowrap class="fileLabel">&nbsp;</td>
											  	<td nowrap>&nbsp;</td>
											  	<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Hasta">Fecha Hasta: </cf_translate></td>
											  	<td nowrap> #LSDateFormat(rsRelacionCalculo.RChasta,'dd/mm/yyyy')# </td>
											</tr>
										</table>
									</cfoutput>
								</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td>
									<table width="80%" align="center" cellpadding="2" cellspacing="0">
										
										<tr><td>
										<cf_web_portlet_start titulo="Tipos de Deducciones a Excluir" skin="#Session.Preferences.Skin#" border="true">
										<cfinclude template="formcalendarioPagos_relacion.cfm">
										<cf_web_portlet_end>														
										</td></tr>

									</table>
								</td>
							</tr>
						</table>
					<cf_web_portlet_end>				
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>
