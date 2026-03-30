<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Recursos_Humanos"
			Default="Recursos Humanos"
			returnvariable="LB_Recursos_Humanos"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Administracion_de_Concursos"
			Default="Administraci&oacute;n de Concursos"
			returnvariable="LB_Administracion_de_Concursos"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
				Key="LB_Concurso"
			Default="Concurso"
			returnvariable="LB_Concurso"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CFuncional"
			Default="C. Funcional"
			returnvariable="LB_CFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Puesto"
			Default="Puesto"
			returnvariable="LB_Puesto"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha_Apertura"
			Default="Fecha Apertura"
			returnvariable="LB_Fecha_Apertura"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Solicitante"
			Default="Solicitante"
			returnvariable="LB_Solicitante"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Fecha_Cierre"
			Default="Fecha de Cierre"
			returnvariable="LB_Fecha_Cierre"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Estado"
			Default="Estado"
			returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Codigo"
			Default="C&oacute;digo"
			returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Plazas"
			Default="Plazas"
			returnvariable="LB_Plazas"/>
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Aplica_para"
			Default="Aplica para"
			returnvariable="LB_Aplica_para"/>

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			returnvariable="BTN_Filtrar"/>
            
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Todos"
			Default="Todos"
			returnvariable="LB_Todos"/>

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Externo"
			Default="Externo"
			returnvariable="LB_Externo"/>

<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Interno"
			Default="Interno"
			returnvariable="LB_Interno"/>
            
<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_TipoConcurso"
			Default="Tipo de Concurso"
			returnvariable="LB_TipoConcurso"/>            
            
<cfset t=createObject("component","sif.Componentes.Translate")>
<cfset LB_EnProceso=t.translate('LB_EnProceso','En Proceso','/rh/generales.xml')>
<cfset LB_Solicitado=t.translate('LB_Solicitado','Solicitado','/rh/generales.xml')>
<cfset LB_Desierto=t.translate('LB_Desierto','Desierto','/rh/generales.xml')>
<cfset LB_Cerrado=t.translate('LB_Cerrado','Cerrado','/rh/generales.xml')>
<cfset LB_Verificado=t.translate('LB_Verificado','Verificado','/rh/generales.xml')>
<cfset LB_EnRevision=t.translate('LB_EnRevision','En Revisión','/rh/generales.xml')>
<cfset LB_Publicado=t.translate('LB_Publicado','Publicado')>
<cfset LB_Evaluando=t.translate('LB_Evaluando','Evaluando','/rh/generales.xml')>
<cfset LB_Terminado=t.translate('LB_Terminado','Terminado','/rh/generales.xml')>
<cfset LB_Adjudicado=t.translate('LB_Adjudicado','Adjudicado','/rh/generales.xml')>

            
<cfif isdefined('url.fRHCcodigo') and not isdefined('form.fRHCcodigo') >
	<cfset form.fRHCcodigo = url.fRHCcodigo >
</cfif>
<cfif isdefined('url.fRHCdescripcion') and not isdefined('form.fRHCdescripcion') >
	<cfset form.fRHCdescripcion = url.fRHCdescripcion >
</cfif>
<cfif isdefined("url.fCFid") and not isdefined("form.fCFid")>
	<cfset form.fCFid = url.fCFid >
</cfif>
<cfif isdefined("url.fRHPcodigo") and not isdefined("form.fRHPcodigo")>
	<cfset form.fRHPcodigo = url.fRHPcodigo >
</cfif>
<cfif isdefined("url.fRHCfapertura") and not isdefined("form.fRHCfapertura")>
	<cfset form.fRHCfapertura = url.fRHCfapertura >
</cfif>
<cfif isdefined("url.fRHCfcierre") and not isdefined("form.fRHCfcierre")>
	<cfset form.fRHCfcierre = url.fRHCfcierre >
</cfif>
<cfif isdefined("url.fsolicitante") and not isdefined("form.fsolicitante")>
	<cfset form.fsolicitante = url.fsolicitante >
</cfif>

<cfset navegacion = '' >
<cfset campos_extra = '' >
<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo))>
	<cfset navegacion = navegacion & '&fRHCcodigo=#trim(form.fRHCcodigo)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fRHCcodigo)#' as fRHCcodigo" >	
</cfif>
<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion))>
	<cfset navegacion = navegacion & '&fRHCdescripcion=#trim(form.fRHCdescripcion)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fRHCdescripcion)#' as fRHCdescripcion" >	
</cfif>
<cfif isdefined("form.fCFid") and len(trim(form.fCFid))>
	<cfset navegacion = navegacion & '&fCFid=#trim(form.fCFid)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fCFid)#' as fCFid" >	
</cfif>
<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo))>
	<cfset navegacion = navegacion & '&fRHPcodigo=#trim(form.fRHPcodigo)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fRHPcodigo)#' as fRHPcodigo" >	
</cfif>
<cfif isdefined("form.fRHCfapertura") and len(trim(form.fRHCfapertura))>
	<cfset navegacion = navegacion & '&fRHCfapertura=#trim(form.fRHCfapertura)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fRHCfapertura)#' as fRHCfapertura" >	
</cfif>
<cfif isdefined("form.fRHCfcierre") and len(trim(form.fRHCfcierre))>
	<cfset navegacion = navegacion & '&fRHCfcierre=#trim(form.fRHCfcierre)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fRHCfcierre)#' as fRHCfcierre" >	
</cfif>
<cfif isdefined("form.fsolicitante") and len(trim(form.fsolicitante))>
	<cfset navegacion = navegacion & '&fsolicitante=#trim(form.fsolicitante)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fsolicitante)#' as fsolicitante" >	
</cfif>
<cfif isdefined("form.fexterno") and len(trim(form.fexterno))>
	<cfset navegacion = navegacion & '&fexterno=#trim(form.fexterno)#' >
	<cfset campos_extra = campos_extra & ", '#trim(form.fexterno)#' as fexterno" >	
</cfif>

<cf_templateheader title = "#LB_Recursos_Humanos#">
		<cf_web_portlet_start border="true" titulo="#LB_Administracion_de_Concursos#" skin="#Session.Preferences.Skin#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">

					<cfinclude template="ConcursosMng-config.cfm">
					
					<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
					<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">
					<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
					<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
					<cf_translatedata name="get" tabla="CFuncional" col="CFdescripcion" returnvariable="LvarCFdescripcion">
					<cfquery name="rsListaConcursos" datasource="#session.DSN#">
						select a.RHCconcurso, 
							   a.RHCcodigo as codigo,
							   #LvarRHCdescripcion# as descripcion,
							   a.RHCfapertura as fechaapertura,
							   a.RHCfcierre as fechacierre,
							   a.RHCcantplazas as cantidadplazas,
							   a.RHPcodigo, 
							   #LvarRHPdescpuesto# as RHPdescpuesto,
							   case a.RHCestado 
									when 0	then '#LB_EnProceso#'
									when 10	then '#LB_Solicitado#'
									when 20 then '#LB_Desierto#'
									when 30 then '#LB_Cerrado#'
									when 15 then '#LB_Verificado#'
									when 40 then '#LB_EnRevision#'
									when 50 then '#LB_Publicado#'
									when 60 then '#LB_Evaluando#'
									when 70 then '#LB_Terminado#'
                                    when 80 then '#LB_Adjudicado#'
									else ''
							   end as Estado,
							   #LvarCFdescripcion# as CFdescripcion,
							   u.Usulogin as solicitante
							   #preservesinglequotes(campos_extra)#
                               ,case coalesce(a.RHCexterno,0) when 1 then'#checked#' else '#unchecked#' end  as Externo
							   <!---dp.Pnombre + ' ' + dp.Papellido1 + ' ' + dp.Papellido2 as solicitante--->
						from RHConcursos a 
						
							inner join RHPuestos b
								on b.RHPcodigo = a.RHPcodigo
								and b.Ecodigo = a.Ecodigo
								
							inner join CFuncional c
								on c.CFid = a.CFid
								and c.Ecodigo = a.Ecodigo
							
							left outer join Usuario u
								on u.Usucodigo = a.Usucodigo
							
							left outer join DatosPersonales dp
								on dp.datos_personales = u.datos_personales
							
						where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHCestado in (10, 15, 40, 50, 60)
						<cfif isdefined("form.flag")>
						  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						</cfif>
						<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0>
						  and upper(a.RHCcodigo) like '%#Ucase(trim(form.fRHCcodigo))#%'
						</cfif>
						<cfif isdefined("form.fRHCdescripcion") and len(trim(form.fRHCdescripcion)) gt 0>
						  and upper(a.RHCdescripcion) like '%#Ucase(trim(form.fRHCdescripcion))#%'
						</cfif>
						<cfif isdefined("form.fCFid") and len(trim(form.fCFid)) gt 0> 
						  and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
						</cfif> 
						<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0> 
						  and upper(a.RHPcodigo) like '%#Ucase(trim(form.fRHPcodigo))#%'
						</cfif> 
						<cfif isdefined("Form.fRHCfapertura") and Len(Trim(Form.fRHCfapertura))>
						  and a.RHCfapertura >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fRHCfapertura)#">
						</cfif>
						<cfif isdefined("Form.fRHCfcierre") and Len(Trim(Form.fRHCfcierre))>
						  and a.RHCfcierre <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fRHCfcierre)#">
						</cfif>
						<cfif isdefined("Form.fsolicitante") and Len(Trim(Form.fsolicitante)) and Form.fsolicitante NEQ -1>
						  and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fsolicitante#">
						</cfif>
                        <cfif isdefined("Form.fexterno") and Len(Trim(Form.fexterno)) and Form.fexterno NEQ -1>
						  and coalesce(a.RHCexterno,0) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fexterno#">
						</cfif>
                        
                        
						order by fechacierre desc, fechaapertura,RHCcodigo
					</cfquery> 
					
					<!--- Solicitantes que han ingresado concursos --->
					<cfquery name="rsSolicitantes" datasource="#Session.DSN#">
						select distinct a.Usucodigo as Codigo, b.Usulogin, 
						{fn concat(rtrim(c.Papellido1), {fn concat(' ', {fn concat( rtrim(c.Papellido2), {fn concat(', ', rtrim(c.Pnombre))})})})} as Nombre
						from RHConcursos a
							inner join Usuario b
								on b.Usucodigo = a.Usucodigo
							inner join DatosPersonales c
								on c.datos_personales = b.datos_personales
						where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHCestado in (10, 15, 40, 50, 60)
					</cfquery>
					
					<script language="javascript" type="text/javascript">
						function NuevoConcurso() {
							location.replace('<cfoutput>#currentPage#</cfoutput>');
						}
					
						function goSelected(v) {
							document.formConcursos.RHCconcurso.value = v;
							document.formConcursos.submit();
						}
						
						function showSearchBox() {
							/*
							var v = !(document.getElementById("trFiltro").style.display == '');
							var a = document.getElementById("trFiltro");
							var b = document.getElementById("trAdmConcursos");
							var c = document.getElementById("trLinea1");
							var d = document.getElementById("trLinea2");
							
							if (v) {
								if (a) a.style.display = '';
								if (b) b.style.display = 'none';
								if (c) c.style.display = '';
								if (d) d.style.display = 'none';
							} else {
								if (a) a.style.display = 'none';
								if (b) b.style.display = '';
								if (c) c.style.display = 'none';
								if (d) d.style.display = '';
							}
							*/
						}
					</script>
					
					<cfoutput>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						
						  <!--- SECCION DE FILTROS DE ADMINISTRACION DE CONCURSOS --->
						  <!---
						  <tr id="trLinea1" style="display: none;">
							<td align="right">
								<a href="javascript: showSearchBox();"><strong>[Mostrar Concursos...]</strong></a>
							</td>
						  </tr>
						  <tr id="trLinea2">
							<td align="right">
								<a href="javascript: showSearchBox();"><strong>[Buscar Concursos...]</strong></a>
							</td>
						  </tr>
						  --->

						  <tr >
							<td align="center">
									<cfoutput>
									<form name="formFiltro" method="post" action="#currentPage#" style="margin: 0;">
										<table width="100%"  border="0" cellspacing="0" cellpadding="4" class="areaFiltro">
										  <tr>
											<td align="right" class="fileLabel">#LB_Concurso#:</td>
											<td>
												<input name="fRHCcodigo" type="text" size="6" value="<cfif isdefined('form.fRHCcodigo') and len(trim(form.fRHCcodigo))>#form.fRHCcodigo#</cfif>">
												<input name="fRHCdescripcion" type="text" size="40" value="<cfif isdefined('form.fRHCdescripcion') and len(trim(form.fRHCdescripcion))>#form.fRHCdescripcion#</cfif>">
											</td>
											<td align="right" class="fileLabel">#LB_CFuncional#:</td>
											<td>
												<cfif isdefined("form.fCFid") and len(trim(form.fCFid))>
													<cfquery name="rsCF" datasource="#session.DSN#">
														select CFid as fCFid, CFcodigo, #LvarCFdescripcion# as CFdescripcion
														from CFuncional
														where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fCFid#">
														  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													</cfquery>
													<cf_rhcfuncional form="formFiltro" id="fCFid" query="#rsCF#">
												<cfelse>
													<cf_rhcfuncional form="formFiltro" id="fCFid">
												</cfif>

											</td>
										  </tr>
										  <tr>
											<td align="right" class="fileLabel">#LB_Puesto#:</td>
											<td>
												<!---<cf_rhpuesto form="formFiltro" name="fRHPcodigo">--->
												
												
												<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo))>
													<cfquery name="rsPuesto" datasource="#session.DSN#">
														select RHPcodigoext,RHPcodigo as fRHPcodigo, RHPdescpuesto
														from RHPuestos
														where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fRHPcodigo#">
														  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
													</cfquery>
													<cf_rhpuesto form="formFiltro" name="fRHPcodigo" query="#rsPuesto#">
												<cfelse>
													<cf_rhpuesto form="formFiltro" name="fRHPcodigo">
												</cfif>
											</td>
											<td align="right" class="fileLabel">#LB_Fecha_Apertura#:</td>
											<td>
												<cfset vFechaApertura = '' >
												<cfif isdefined("form.fRHCfapertura") and len(trim(form.fRHCfapertura)) >
													<cfset vFechaApertura = form.fRHCfapertura >
												</cfif>
												<cf_sifcalendario form="formFiltro" name="fRHCfapertura" value="#vFechaApertura#">
											</td>
										  </tr>
										  <tr>
											<td align="right" class="fileLabel">#LB_Solicitante#:</td>
											<td>
												<select name="fsolicitante">
													<option value="-1">#LB_Todos#</option>
													<cfloop query="rsSolicitantes">
														<option value="#rsSolicitantes.Codigo#" <cfif isdefined("form.fsolicitante") and trim(form.fsolicitante) eq rsSolicitantes.Codigo>selected</cfif> >#rsSolicitantes.Nombre# (#rsSolicitantes.usulogin#)</option>
													</cfloop>
												</select>
											</td>
											<td align="right" class="fileLabel">#LB_Fecha_Cierre#:</td>
											<td>
												<cfset vFechaCierre = '' >
												<cfif isdefined("form.fRHCfcierre") and len(trim(form.fRHCfcierre)) >
													<cfset vFechaCierre = form.fRHCfcierre >
												</cfif>
												<cf_sifcalendario form="formFiltro" name="fRHCfcierre" value="#vFechaCierre#">
											</td>
										  </tr>
                                          
                                          
                                          <tr>
											<td align="right" class="fileLabel">#LB_TipoConcurso#:</td>
											<td>
												<select name="fexterno">
													<option value="-1"<cfif isdefined("form.fexterno") and trim(form.fexterno) eq -1>selected</cfif>>#LB_Todos#</option>
                                                    <option value="0" <cfif isdefined("form.fexterno") and trim(form.fexterno) eq 0>selected</cfif>>#LB_Interno#</option>
                                                    <option value="1" <cfif isdefined("form.fexterno") and trim(form.fexterno) eq 1>selected</cfif>>#LB_Externo#</option>
												</select>
											</td>
										  </tr>
                                          
                                          
										  <tr>
											<td colspan="6" align="center">
												<input type="submit" class="btnFiltrar" name="btnBuscar" value="#BTN_Filtrar#">
											</td>
										  </tr>
										</table>
									</form>
									</cfoutput>
							</td>
						  </tr>
						  
						  <!--- SECCION DE ADMINISTRACION DE CONCURSOS --->
						  <tr id="trAdmConcursos">
							<td>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								  <!---
								  <tr>
									<td style="color:##333333; background-color:##CCCCCC; font-family:'Times New Roman', Times, serif; font-variant:small-caps; font-size:14px; font-weight:bold;">
										&nbsp;LISTA DE CONCURSOS&nbsp;
										<cfif modoAdmConcursos EQ "CAMBIO">
											<font color="##000099">[#rsRHConcursos.RHCcodigo# &nbsp; #rsRHConcursos.RHCdescripcion#]</font>
										<cfelse>
											<font color="##000099">[SELECCIONE UN CONCURSO]</font>
										</cfif>
									</td>
									<td align="right" style="color:##333333; background-color:##CCCCCC; font-family:'Times New Roman', Times, serif; font-variant:small-caps; font-size:14px; font-weight:bold;">
										<cfif modoAdmConcursos EQ "CAMBIO">
											<a href="javascript: NuevoConcurso();" style="font-size:12px;"><img src="/cfmx/rh/imagenes/file.png" border="0" title="Nuevo Concurso" align="absmiddle">[Nuevo Concurso]</strong></a>&nbsp;
										<cfelse>
											&nbsp;
										</cfif>
									</td>
								  </tr>
								  --->
					
								<!---	
								  <tr>
									<td colspan="2" style="background-color:##F3F4F8; border-bottom: 2px solid ##CCCCCC;">
										<table width="950" border="0" cellspacing="0" cellpadding="2">
										  <tr>
											<td class="tituloListas" width="25" nowrap>&nbsp;</td>
											<td class="tituloListas" width="50" nowrap>C&oacute;digo</td>
											<td class="tituloListas" width="225" nowrap>Concurso</td>
											<td class="tituloListas" width="75" align="center" nowrap>Apertura</td>
											<td class="tituloListas" width="75" align="center" nowrap>Cierre</td>
											<td class="tituloListas" width="160" align="left" nowrap>Puesto</td>
											<td class="tituloListas" width="170" align="left" nowrap>C.Funcional</td>
											<td class="tituloListas" width="50" align="center" nowrap>Plazas</td>
											<td class="tituloListas" width="120" nowrap>Solicitante</td>
										  </tr>
										</table>
										<form name="formConcursos" method="post" action="#currentPage#" style="margin: 0;">
											<cfinclude template="ConcursosMng-hiddens.cfm">
											<table width="950" border="0" cellspacing="0" cellpadding="2">
											  <cfloop query="rsListaConcursos">
											  <tr <cfif currentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="javascript: this.style.cursor = 'pointer';this.className='listaParSel';" onMouseOut="this.className='<cfif currentRow MOD 2>listaNon<cfelse>listaPar</cfif>';" style="height: 30;" onClick="javascript: goSelected('#rsListaConcursos.RHCconcurso#');">
												<td width="25" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<img src="/cfmx/rh/imagenes/addressGo.gif" border="0" title="Editando Concurso">
													<cfelse>
														&nbsp;
													</cfif>
												</td>
												<td width="50" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#rsListaConcursos.codigo#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="225" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
														#rsListaConcursos.descripcion#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="75" align="center" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#LSDateFormat(rsListaConcursos.fechaapertura, 'dd/mm/yyyy')#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="75" align="center" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#LSDateFormat(rsListaConcursos.fechacierre, 'dd/mm/yyyy')#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="160" align="left" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#rsListaConcursos.RHPdescpuesto#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="170" align="left" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#rsListaConcursos.CFdescripcion#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="50" align="center" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#rsListaConcursos.cantidadplazas#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
												<td width="120" nowrap>
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														<font color="##000099"><strong>
													</cfif>
													#rsListaConcursos.solicitante#
													<cfif modoAdmConcursos EQ "CAMBIO" and Form.RHCconcurso EQ rsListaConcursos.RHCconcurso>
														</strong></font>
													</cfif>
												</td>
											  </tr>
											  </cfloop>
											</table>
											</form>
									</td>
								  </tr>
								  --->
								  
								  	<tr>
										<td colspan="2">
											<cfinvoke 
													component="rh.Componentes.pListas"
													method="pListaQuery"
													returnvariable="pListaRet">
												<cfinvokeargument name="query" value="#rsListaConcursos#"/>
												<cfinvokeargument name="desplegar" value="codigo, descripcion, fechaapertura, fechacierre,Estado, RHPdescpuesto, CFdescripcion, cantidadplazas ,solicitante,Externo"/>
												<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Concurso#,#LB_Fecha_Apertura#,#LB_Fecha_Cierre#,#LB_Estado#,#LB_Puesto#,#LB_CFuncional#,#LB_Plazas#,#LB_Solicitante#,#LB_Externo#"/>
												<cfinvokeargument name="formatos" value="V,V,D,D,V,V,V,I,V,V"/>
												<cfinvokeargument name="align" value="left, left,left, left, left, left, left,center,left,center"/>
												<cfinvokeargument name="ajustar" value="S"/>
												<cfinvokeargument name="irA" value="ConcursosMng.cfm"/>
												<cfinvokeargument name="botones" value="Nuevo"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="keys" value="RHCconcurso"/>
												<cfinvokeargument name="navegacion" value="#navegacion#"/>
											</cfinvoke>
										</td>
									</tr>
								  <tr>
									<td colspan="2">&nbsp;</td>
								  </tr>
								</table>
							</td>
						  </tr>
						</table>
					
					</cfoutput>
		<cf_web_portlet_end>
<cf_templatefooter>
