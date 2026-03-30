<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Registro de Encuestas Salariales
	</cf_templatearea>
	
	<cf_templatearea name="body">
	  <cf_web_portlet_start border="true" titulo="Habilidades" skin="#Session.Preferences.Skin#">
		<cfparam name="filtro" default=" ">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>          
			</tr>					
			<tr>
				<td valign="top" width="50%">
					<cfif not isdefined("Form.Eid")>
						<cfset modo = 'ALTA'>
					</cfif>
					<cfif not isdefined("Form.EPCodigo")>
						<cfset modoD = 'ALTA'>
					</cfif>
					<cfif isdefined("url.modo")>
						<cfset modo = url.modo>
					</cfif>
					<cfif isdefined("Form.Cambio")>
						<cfset modo="CAMBIO">
					</cfif>
					<cfif isdefined("Form.EPCodigo")>
						<cfset modoD ="CAMBIO">
					</cfif>
					<cfif isdefined("Url.EEid") and not isdefined("Form.EEid")>
						<cfparam name="Form.EEid" default="#Url.EEid#">
					</cfif>
					<cfif isdefined("Url.Eid") and not isdefined("Form.Eid")>
						<cfparam name="Form.Eid" default="#Url.Eid#">
						<cfset form.modo = 'CAMBIO'>
					</cfif>
					
					<cfif modo EQ "ALTA" and not isdefined("BtnNueva")>
							<cflocation addtoken="no" url="../../adminsalarios/operacion/listaEncuestasSal.cfm">							
					</cfif> 
										
					<cfset navegacion = "&Eid=#form.Eid#&modo=#modo#" >
										
					<table border="0" cellpadding="0" cellspacing="0">													
						<tr>
							<td valign="top" align="center" width="50%">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">							
									<form name="formFiltro" method="post" action="EncuestasSal.cfm">										
										<cfoutput>					
											<input type="hidden" name="Eid" value="<cfif isdefined("form.Eid") and len(trim(form.Eid))>#form.Eid#</cfif>">
											<input type="hidden" name="Cambio" value="Cambio">
											<cfset modo = 'CAMBIO'>
											<tr class="areaFiltro">
												<td align="right" nowrap><strong>C&oacute;digo:</strong></td>
												<td>
													<table>
														<tr>
															<td>
																<input type="text" name="EPcodigo" size="6" maxlength="10" value="<cfif isdefined('form.EPcodigo') and Len(trim(form.EPcodigo))>#trim(form.EPcodigo)#</cfif>" onfocus="this.select();" >
															</td>
															<td>&nbsp;</td>
															<td align="right"><strong>Descripci&oacute;n:</strong></td>
															<td>
																<input type="text" name="EPdescripcion" size="40" maxlength="80" value="<cfif isdefined('form.EPdescripcion') and Len(trim(form.EPdescripcion))>#trim(form.EPdescripcion)#</cfif>" onfocus="this.select();">
															</td>
														</tr>
													</table>
												</td>												
											</tr>											
											<tr class="areaFiltro">
												<td align="right"><strong>Tipo:</strong></td>
												<td>
													<table width="100%">
														<tr>
															<td width="69%">													
																<input type="text" name="ETdescripcion" size="40" maxlength="80" value="<cfif isdefined('form.ETdescripcion') and Len(trim(form.ETdescripcion))>#trim(form.ETdescripcion)#</cfif>" onfocus="this.select();">
															</td>
															<td width="31%"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
														</tr>
													</table>
												</td>
											</tr>											
										</cfoutput>
									</form>
								</table>
							</td>	
						</tr>
						<tr>
							<td colspan="3" width="50%">
								<cfset filtro = "">
								<cfif isdefined("form.EPcodigo") and len(trim(form.EPcodigo))>
									<cfset filtro = filtro & " and upper(b.EPcodigo) like '%" & UCase(Form.EPcodigo) & "%'">
								</cfif>
								<cfif isdefined("form.EPdescripcion") and len(trim(form.EPdescripcion))>
									<cfset filtro = filtro & " and upper(b.EPdescripcion) like '%" & Ucase(form.EPdescripcion) & "%'">
								</cfif>
								<cfif isdefined("form.ETdescripcion") and len(trim(form.ETdescripcion))>
									<cfset filtro = filtro & " and upper(d.ETdescripcion) like '%" & Ucase(form.ETdescripcion) & "%'">
								</cfif>								
								<cfif modo neq 'ALTA'>
									<cfquery name="rsPuestos" datasource="sifpublica">
										select 	distinct(EPcodigo),
												a.Eid, 
												b.EPid, 
												b.EEid,
												b.EPdescripcion, 
												c.EAid, 
												c.EAdescripcion, 
												d.ETdescripcion
												<!--- ,
												a.ESid  --->
										
										from EncuestaSalarios a 
																	
										left outer join EncuestaPuesto b
										on a.EEid =  b.EEid and
										   a.EPid =  b.EPid 
														
										left outer join EmpresaArea c
										on b.EEid = c.EEid and
										   b.EAid = c.EAid  
																	 
										left outer join EmpresaOrganizacion d   
										on a.EEid = d.EEid and
										   a.ETid = d.ETid
										   
										<cfif modo NEQ "ALTA">
											where a.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
										</cfif>
										#preservesinglequotes(filtro)#
																			
										order by b.EAid, a.ETid, b.EPcodigo
									</cfquery>
	
									<!---<td valign="top" nowrap width="50%">---->
										<cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rsPuestos#"/>
										<cfinvokeargument name="desplegar" value="EPcodigo, EPdescripcion, ETdescripcion"/>
										<cfinvokeargument name="etiquetas" value="C&oacute;digo, Puesto, Tipo Organizaci&oacute;n"/>
										<cfinvokeargument name="formatos" value="V,V,V"/>
										<cfinvokeargument name="align" value="left,left, left"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="cortes" value="EAdescripcion"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="EncuestasSal.cfm"/>
										<cfinvokeargument name="keys" value="EAid,EPid,ETid"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/>
										<cfinvokeargument name="conexion" value="sifpublica"/>
										<cfinvokeargument name="navegacion" value="#navegacion#"/>
										<cfinvokeargument name="keys" value="EPid"/>
										</cfinvoke>							
								</cfif> 
							</td>
						</tr>	
					</table>
				</td>	
				<td width="50%" valign="top" align="center"><cfinclude template="formEncuestasSal.cfm"></td>							
			</tr>
		</table>	
	  <cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

<script language="JavaScript1.2">

	function Editar(data) {
		if (data!="") {
			document.form2.action='EncuestasSal.cfm';
			document.form2.datos.value=data;
			document.form2.submit();
		}
		return false;
	}
</script>