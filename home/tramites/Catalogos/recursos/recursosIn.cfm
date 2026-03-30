<cfif not isdefined("form.fid_inst") and isdefined("url.id_inst") and len(trim(url.id_inst))>
	<cfset form.id_inst = url.id_inst>
</cfif>
<cfif not isdefined("form.id_recurso") and isdefined("url.id_recurso") and len(trim(url.id_recurso))>
	<cfset form.id_recurso = url.id_recurso>
</cfif>
<cfif not isdefined("form.btnNuevo") and isdefined("url.btnNuevo") and len(trim(url.btnNuevo))>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr> 
		<td valign="top" width="40%">	
			<cfif isdefined('form.id_recurso') and len(trim(form.id_recurso)) or isdefined('form.btnNuevo') or isdefined('form.btnNuevo_REC')>
				<cfif IsDefined('url.tabreq')>
					<cfset form.tabreq = url.tabreq>
				<cfelse>
					<cfparam name="form.tabreq" default="req1">
				</cfif>
				
				<table width="80%" align="center" border="0" cellspacing="0" cellpadding="0">
					<cfif isdefined("form.id_recurso") and len(trim(form.id_recurso))>
						<cfquery name="rsRecurso" datasource="#session.tramites.dsn#">
							select codigo_recurso, nombre_recurso
							from TPRecurso
							where id_recurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_recurso#">
						</cfquery>				
						<cfif isdefined('rsRecurso') and rsRecurso.recordCount GT 0>
							<tr>
								<td>
									<table width="100%"  border="0" cellspacing="0" cellpadding="0"  bgcolor="#CACACA" style="border:1px solid black">
									  <tr>
										<td align="center" valign="middle">
											<font size="3" color="#003399">
												<strong>
													<cfoutput>
														Recurso:&nbsp;#trim(rsRecurso.codigo_recurso)# - #rsRecurso.nombre_recurso#										
													</cfoutput>									
												</strong>								  
											</font>
										</td>
									  </tr>
								  </table>
								</td>
							</tr>			
						</cfif>
					<cfelse>
						<tr>
							<td>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0"  bgcolor="#CACACA" style="border:1px solid black">
								  <tr>
									<td align="center" valign="middle">
										<font size="3" color="#003399">
											<strong>
												Nuevo Recurso
											</strong>								  
										</font>
									</td>
								  </tr>
							  </table>
							</td>
						</tr>									
					</cfif>
				  <tr><td>&nbsp;</td></tr>									
				  <tr>
					<td nowrap>
						<cf_tabs>
							<cf_tab text="Recurso" id="req1" selected="#form.tabreq is 'req1'#">
								<cfinclude template="recursosIn-form.cfm">						
							</cf_tab>
							
							<cfif isdefined('form.id_recurso') and len(trim(form.id_recurso))>
								<cf_tab text="Agenda" id="req2" selected="#form.tabreq is 'req2'#">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									  <tr>
									  	<td>
											<cfinclude template="agendaIn-form.cfm">
										</td>
									  </tr>									
									  <tr>
										<td valign="top">
											<cfinvoke 
											component="sif.Componentes.pListas"
											method="pLista"
											returnvariable="pListaRet">
												<cfinvokeargument name="columnas" value="
													id_recurso
													, a.id_inst												
													, id_sucursal
													, id_agenda
													, vigente_desde
													, vigente_hasta
													, dia_semana as numDia
													, case dia_semana 
														when 0 then 'Domingo'
														when 1 then 'Lunes'
														when 2 then 'Martes'
														when 3 then 'Miercoles'
														when 4 then 'Jueves'
														when 5 then 'Viernes'
														when 6 then 'Sabado'
													end dia_semana
													, ('(' || rtrim(codigo_tiposerv) || ') ' || rtrim(nombre_tiposerv)) as tipoServ
													, convert(varchar,hora_desde,108) as hora_desde
													, convert(varchar,hora_hasta,108) as hora_hasta											
													, 2 as tab
													, 'req2' as tabreq
													, 'suc3' as tabsuc"/>
												<cfinvokeargument name="tabla" value="TPAgenda a
																				left outer join TPTipoServicio ts
																					on ts.id_tiposerv=a.id_tiposerv
																						and ts.id_inst=a.id_inst"/>				
												<cfinvokeargument name="filtro" value="a.id_inst=#form.id_inst#
																						and id_sucursal = #form.id_sucursal#
																						and id_recurso=#form.id_recurso#
																						order by numDia"/>
												<cfinvokeargument name="desplegar" value="vigente_desde,vigente_hasta,hora_desde,hora_hasta"/>												
												<cfinvokeargument name="etiquetas" value="Fecha Desde,Fecha Hasta,Hora Desde,Hora Hasta"/>												
												<cfinvokeargument name="formatos" value="D,D,S,S"/>
												<cfinvokeargument name="align" value="left,left,left,left"/>
												<cfinvokeargument name="ajustar" value="N"/>
												<cfinvokeargument name="conexion" value="#session.tramites.dsn#"/>
												<cfinvokeargument name="irA" value="instituciones.cfm"/>
												<cfinvokeargument name="showEmptyListMsg" value="true"/>
												<cfinvokeargument name="mostrar_filtro" value="false"/>
												<cfinvokeargument name="filtrar_automatico" value="false"/>
												<cfinvokeargument name="keys" value="id_recurso,id_agenda"/>
												<cfinvokeargument name="formName" value="listaAgendas"/>
											</cfinvoke>										
										</td>
									  </tr>
									</table>
								</cf_tab>
							</cfif>
						</cf_tabs>					
					</td>
				  </tr>
				</table>
			<cfelse>
				<cfinvoke 
				component="sif.Componentes.pListas"
				method="pLista"
				returnvariable="pListaRet">
					<cfinvokeargument name="columnas" value="id_recurso
															, r.id_tiporecurso
															, s.id_sucursal
															, i.id_inst
															, codigo_recurso
															, nombre_recurso
															, nombre_sucursal
															, ('Tipo de Recurso: ' || Nombre_Recurso) as nameTipoRec
															, r.vigente_desde
															, r.vigente_hasta
															, 2 as tab
															, 'req1' as tabreq
															, 'suc3' as tabsuc"/>
					<cfinvokeargument name="tabla" value="TPRecurso r
														inner join TPTipoRecurso tr
															on tr.id_tiporecurso=r.id_tiporecurso
													
														inner join TPSucursal s
															on s.id_sucursal=r.id_sucursal
													
														inner join TPInstitucion i
															on i.id_inst=s.id_inst
																and i.id_inst=#Form.id_inst#"/>				
					<cfinvokeargument name="filtro" value="
															r.id_sucursal = #form.id_sucursal#
															and getDate() between r.vigente_desde and r.vigente_hasta
															order by id_tiporecurso,id_sucursal"/>
					<cfinvokeargument name="desplegar" value="codigo_recurso,nombre_recurso"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Recurso"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="conexion" value="#session.tramites.dsn#"/>
					<cfinvokeargument name="irA" value="instituciones.cfm"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="botones" value="Nuevo"/>		
					<cfinvokeargument name="formName" value="listaRecursos"/>
					<cfinvokeargument name="Cortes" value="nameTipoRec"/>										
					<cfinvokeargument name="keys" value="id_recurso"/>
				</cfinvoke>

				<script language="javascript" type="text/javascript">
					function funcNuevo(){
						document.listaRecursos.TAB.value = 2;
						document.listaRecursos.TABSUC.value = 'suc3';
						document.listaRecursos.ID_SUCURSAL.value = <cfoutput>#form.id_sucursal#</cfoutput>;						
						document.listaRecursos.ID_INST.value = <cfoutput>#form.id_inst#</cfoutput>;		
					}				
					function funcFiltrar() {
						document.listaRecursos.TAB.value = 2;
						document.listaRecursos.TABSUC.value = 'suc3';
						document.listaRecursos.ID_SUCURSAL.value = <cfoutput>#form.id_sucursal#</cfoutput>;				
						document.listaRecursos.ID_INST.value = <cfoutput>#form.id_inst#</cfoutput>;
					}
				</script>
				
			</cfif>
		</td>
	</tr>
	<tr> 
		<td>&nbsp;</td>
	</tr> 
	</table>
<script language="javascript" type="text/javascript">
<!--
	function tab_set_current_suc (n){
	<cfoutput>
		<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
			location.href='instituciones.cfm?id_inst=#JSStringFormat(form.id_inst)#&tab=#JSStringFormat(form.tab)#&tabsuc='+escape(n);
		<cfelse>
			alert('Debe agregar o seleccionar una institución.');
		</cfif>
	</cfoutput>
	}
	//-->
</script>
