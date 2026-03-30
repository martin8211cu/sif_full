<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#url.id_persona#"
	id_tramite="#url.id_tramite#"
	id_funcionario="#session.tramites.id_funcionario#"
	returnvariable="instancia" />

<script type="text/javascript">
<!--
var popUpWin = 0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin){
		if(!popUpWin.closed) popUpWin.close();
	}
	popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function infoRequisito(requisito,tramite) {
	var params ="";
	params = "?id_requisito="+requisito;
	params += "&id_tramite="+tramite;
	popUpWindow("/cfmx/home/tramites/Operacion/gestion/infoRequisito.cfm"+params,250,200,650,400);
}

function agregarCita(per,inst,tram,req){
	var params ="";
	params = "?id_persona="+per;
	params += "&id_instancia="+inst;
	params += "&id_tramite="+tram;
	params += "&id_requisito="+req;
			 
	popUpWindow("/cfmx/bancovirtual/paginas/req_cita_form.cfm"+params,250,200,650,450);
}

-->
</script>


<cfoutput>

<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	
<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr>
		<!--- REQUISITOS --->
		<td valign="top" width="50%">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
				<tr><td bgcolor="##ECE9D8" colspan="2" class="bajada" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Requisitos</strong></td></tr>

				<cfset datos_variables_mostrado = false>
				<!--- este include pinta los tr/td necesarios--->
				<tr><td colspan="2">
				<cfset iconos = false >
				<cfinclude template="lista-requisitos.cfm">
				</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</td>
		
		<!--- FORMULARIOS DE DATOS VARIABLES --->
		<td valign="top" width="50%">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			
			<cfset titulo = instancia.nombre_requisito >
			<cfif isdefined("instancia.id_requisito") and len(trim(instancia.id_requisito))>
				<cfquery name="requisito" dbtype="query">
					select nombre_requisito
					from instancia
					where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
				</cfquery>
				<cfset titulo = requisito.nombre_requisito >
			</cfif>
			
			<tr><td id="titulo" bgcolor="##ECE9D8" colspan="2" class="bajada" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Requisito: #titulo#</strong></td></tr>
			<tr><td width="50%">
				<cfset requisitos = '' >
				<cfset campos = '' >

				<cfset datos_variables_mostrado = false>

				<cfloop query="instancia">
					<cfset vinstancia = instancia.id_instancia >
					<div id="info_req_#instancia.id_requisito#" style="width:100%px; elevation:above; display: <cfif instancia.currentrow eq 1>block<cfelse>none</cfif>;" >
					<table border="0" cellpadding="2" cellspacing="0" width="100%">
					
						<cfset tiene_cita = '' >
						<cfset tiene_conexion = '' >
						<cfif instancia.es_cita>
									
							<cfsavecontent variable="tiene_cita">
								<cfif len(trim(instancia.id_cita))>
									<cfquery name="cita" datasource="tramites_cr">
										select fecha,id_agenda from TPCita where id_cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_cita#">
									</cfquery>  
									<cfif isdefined('cita') and cita.recordCount GT 0>
										<cfquery datasource="tramites_cr" name="citainf">
											select a.id_agenda,ciudad ||' ' || estado as direccion ,direccion1,direccion2,hora_desde,hora_hasta,cupo,
											codigo_tiposerv,nombre_tiposerv,descripcion_tiposerv ,nombre_inst,codigo_inst 
												from TPAgenda a
												join  TPDirecciones c			
													on a.id_direccion   = c.id_direccion 
												join  TPTipoServicio d			
													on a.id_tiposerv   = d.id_tiposerv
												join  TPInstitucion e		
													on d.id_inst  = e.id_inst
												where  a.id_agenda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cita.id_agenda#">
										</cfquery>

										<table>
											<tr>
												<td width="1%"><img src="/cfmx/bancovirtual/images/cita.gif" border="0"></td>
												<td class="bajada" align="left">Cita programada para el dia #LSDateFormat(cita.fecha,'dd/mm/yyyy')#, #LSTimeFormat(cita.fecha, 'h:mm tt')#</td>
											</tr>
											<tr>
												<td class="bajada" nowrap  style="padding:3px;"><strong>Servicio Solicitado </strong></td>
												<td  class="bajada" style="padding:3px;">#citainf.codigo_tiposerv#-#citainf.nombre_tiposerv#</td>		
											</tr>	
											<tr>
												<td class="bajada"  style="padding:3px;">&nbsp;</td>
												<td class="bajada"  style="padding:3px;">#citainf.descripcion_tiposerv#</td>		
											</tr>				
											<tr>
												<td class="bajada" nowrap  style="padding:3px;"><strong>Servicio ofrecido por:</strong></td>
												<td class="bajada" style="padding:3px;">#citainf.codigo_inst#-#citainf.nombre_inst#</td>		
											</tr>									
											<tr>
												<td class="bajada" style="padding:3px;"><strong>Horario</strong></td>
												<td class="bajada" style="padding:3px;">De #LSTimeFormat(citainf.hora_desde, "hh:mm tt")# a  #LSTimeFormat(citainf.hora_hasta, "hh:mm tt")#</td>		
											</tr>		
											<tr>
												<td class="bajada"  style="padding:3px;"><strong>Lugar de la cita </strong></td>
												<td  class="bajada" style="padding:3px;">#citainf.direccion#</td>		
											</tr>		
											<tr>
												<td class="bajada"  style="padding:3px;">&nbsp;</td>
												<td  class="bajada" style="padding:3px;">#citainf.direccion1#</td>		
											</tr>	
											<tr>
												<td class="bajada" style="padding:3px;">&nbsp;</td>
												<td  class="bajada" style="padding:3px;">#citainf.direccion2#</td>		
											</tr>								
										</table>	
									</cfif>							
								<cfelse>	<!--- No existe tramite --->
										<table align="center" border="0" cellpadding="5" cellspacing="0">
											<tr>
												<td style="padding:3px;" class="bajada" align="left">
													<a href="javascript: agregarCita(#url.id_persona#,#url.id_instancia#,#url.id_tramite#,#instancia.id_requisito#);"><strong>Agregar Cita</strong></a>
												</td>		
											</tr>								
										</table>
										 <form name="form#id_requisito#" action="" style="margin:0;" method="get">
											<input type="hidden" name="id_persona" value="#url.id_persona#">
											<input type="hidden" name="id_instancia" value="#url.id_instancia#">
											<input type="hidden" name="id_tramite" value="#url.id_tramite#">
											<input type="hidden" name="id_requisito" value="#instancia.id_requisito#">
										</form>	
									
								</cfif>
							</cfsavecontent>	
						</cfif>
						
						<cfif instancia.es_conexion and len(trim(instancia.id_documento)) >
							<cfset institucion = '' >
							<cfquery name="doc" datasource="tramites_cr">
								select id_inst
								from TPDocumento
								where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_documento#">
							</cfquery>
							<cfquery name="inst" datasource="tramites_cr">
								select id_inst, nombre_inst
								from TPInstitucion
								where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#doc.id_inst#">
							</cfquery>
							<cfset institucion = inst.nombre_inst >
				
							<cfif len(trim(institucion))>
							<cfsavecontent variable="tiene_conexion">
								<table>
								<tr>
									<td width="1%" class="bajada"><a href="javascript:sbEjecutaWS('#instancia.id_requisito#')"><img src="/cfmx/bancovirtual/images/conexion.gif" border="0"></a></td>
									<td align="left" class="bajada"><a href="javascript:sbEjecutaWS('#instancia.id_requisito#')">Conectarse a #institucion#</a></td>
								</tr>
								</table>
							</cfsavecontent>
							</cfif>
						</cfif>
						
						<cfif instancia.permisos eq 1 >
							<cfset datos_var = ''>
							
							<cfquery name="datorequisito" datasource="tramites_cr" >
								select 	tc.id_tipo, 
										dr.id_requisito, 
										tc.nombre_campo,
										tc.id_campo,
										tc.nombre_campo,
										tc.id_tipocampo, 
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
										dr.id_vista,
										dr.id_vistapopup,
										dr.es_vistapopup,
										<cfif Len(instancia.id_instancia)>
											cam.valor
										<cfelse>
											null
										</cfif> as valor,
										<cfif Len(instancia.id_instancia)>
											cam.id_registro
										<cfelse>
											null
										</cfif> as id_registro
							
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
									<cfif Len(instancia.id_instancia)>
									left join TPInstanciaRequisito ir
										on ir.id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_instancia#">
										and ir.id_requisito = dr.id_requisito
									left join DDRegistro reg
										on reg.id_registro = ir.id_registro
									left join DDCampo cam
										on cam.id_registro = reg.id_registro
										and cam.id_campo = tc.id_campo
									</cfif>
								where dr.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
							</cfquery>
							
							
							<CFIF datorequisito.RECORDCOUNT GT 0>
								<cfsavecontent variable="datos_var"> 
								<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
									<tr><td colspan="3"><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td class="bajada">#estado#</cfoutput></td></tr></table> </td></tr>
									<cfif len(tiene_cita)>
										<cfoutput><tr><td colspan="3">#tiene_cita#</td></tr></cfoutput>
									</cfif>
									<cfif len(tiene_conexion)>
										<cfoutput><tr><td colspan="3">#tiene_conexion#</td></tr></cfoutput>
									</cfif>
									
									<cfif not (len(tiene_cita) and len(tiene_conexion)) >
										<cfquery name="req" datasource="tramites_cr">
											select texto_completado 
											from TPRequisito
											where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
										</cfquery>
									
										<cfif len(trim(req.texto_completado))>
											 <form name="form#id_requisito#" action="completar-sql.cfm" style="margin:0;" method="get">
												<input type="hidden" name="id_persona" value="#url.id_persona#">
												<input type="hidden" name="id_instancia" value="#url.id_instancia#">
												<input type="hidden" name="id_tramite" value="#url.id_tramite#">
												<input type="hidden" name="id_requisito" value="#instancia.id_requisito#">

												<tr>
													<td colspan="3">
														<table align="center" border="0" cellpadding="0" cellspacing="0">
															<tr>
																<td width="1%" align="right"><input type="checkbox" name="completar" ><td>
																<td class="bajada" align="left">#req.texto_completado#</td>
															</tr>
															<tr><td colspan="3">
																<input type="submit" name="Aceptar" value="Aceptar">
															</td></tr>
														</table>
													</td>			
												</tr>
											</form>
										</cfif>
									</cfif>
									
									
								</table>
								</cfsavecontent>
							</CFIF>
							
							<cfif Len(datos_var) > <!--- datos var--->
								<tr id="reqlista_det_#CurrentRow#" style="display:;" 
									bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
									<td colspan="2">
										#datos_var#
									</td>
								</tr>
							<cfelse> <!---and instancia.es_impedimento eq 0--->
								<cfif instancia.es_pago eq 0 and instancia.permisos eq 1 >
									<tr id="reqlista_det_#CurrentRow#" style="display:;" bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
										<td colspan="2">
											<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray;">
												<tr><td colspan="2"><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td class="bajada">#estado#</td></cfoutput></tr></table> </td></tr>
												<tr><td colspan="2" class="bajada">#tiene_cita#</td></tr>
												<tr><td colspan="2" class="bajada">#tiene_conexion#</td></tr>
											</table>
										</td>
									</tr>
								<cfelse >
									<tr id="reqlista_det_#CurrentRow#" style="display:;" bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
										<td colspan="2">
											<cfif instancia.es_pago eq 1 >
													<cfquery name="tramite" datasource="tramites_cr">
														select nombre_tramite
														from TPTramite
														where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tramite#">
													</cfquery>
													<cfquery name="requisito" datasource="tramites_cr">
														select nombre_requisito, coalesce(costo_requisito, 100) as costo, coalesce(moneda, 'USD') as moneda
														from TPRequisito
														where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
													</cfquery>
													
													<cfset cuentas = querynew('persona,cuenta')>
													
													<cfset temp = QueryAddRow(cuentas)>
													<cfset Temp = QuerySetCell(cuentas, 'persona', '108440115')>
													<cfset Temp = QuerySetCell(cuentas, 'cuenta', 'CH-012548955')>
													<cfset temp = QueryAddRow(cuentas)>
													<cfset Temp = QuerySetCell(cuentas, 'persona', '108440115')>
													<cfset Temp = QuerySetCell(cuentas, 'cuenta', 'CH-8524563')>
													<cfset temp = QueryAddRow(cuentas)>
													<cfset Temp = QuerySetCell(cuentas, 'persona', '108440115')>
													<cfset Temp = QuerySetCell(cuentas, 'cuenta', 'CC-2214785')>
													
												 <form name="form#id_requisito#" action="<cfif instancia.es_pago eq 1 >pago-sql.cfm<cfelse>datos-variables-sql.cfm</cfif>" style="margin:0;" method="get">
													<input type="hidden" name="id_persona" value="#url.id_persona#">
													<input type="hidden" name="id_instancia" value="#url.id_instancia#">
													<input type="hidden" name="id_tramite" value="#url.id_tramite#">
													<input type="hidden" name="id_requisito" value="#instancia.id_requisito#">
													<input type="hidden" name="monto" value="#requisito.costo#">
													
													<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
														<TR>
														<td colspan="2" class="bajada">
															<B><font color="##595959">Referencia: #url.id_tramite#</font></B><BR>
															<B><font color="##595959">Tr&aacute;mite: #tramite.nombre_tramite#<br>Requisito: #requisito.nombre_requisito#</font></B><BR>
															</td>	
														</TR>
														<tr><td colspan="2"><hr size="1" color="##595959"></td></tr>
														<tr>
															<td width="1%" nowrap class="bajada"><strong><font color="##595959">Cancelar con la cuenta:&nbsp;</font></strong></td>
															<td>
																<select name="cuenta">
																	<cfloop query="cuentas">
																		<option value="#cuentas.cuenta#">#cuentas.cuenta#</option>
																	</cfloop>
																</select>
															</td>
														</tr>
														
														<tr>
															<td class="bajada"><strong><font color="##595959">Monto:&nbsp;</font></strong></td>
															<td class="bajada"><strong><font color="##595959">#LSNumberFormat(requisito.costo,',9.00')#, #requisito.moneda#</font></strong></td>
														</tr>
														
														<tr><td>&nbsp;</td></tr>
														
														<tr>
															<td colspan="2" align="center">
																<input type="submit" name="Pagar" value="Pagar" onClick="this.form.action='../paginas/pagar_confirmar.cfm'">
</td>
														</tr>

													</table>
													</form>
													
											<cfelse>
												<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
													<tr><td><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td class="bajada">#estado#</td></cfoutput></tr></table> </td></tr>
													<tr><td>&nbsp;</td></tr>
													<tr><td align="center" class="bajada">No se han registrado datos adicionales para este requisito</td></tr>
													<tr><td>&nbsp;</td></tr>
												</table>
											</cfif>	
										</td>	
									</tr>
								</cfif>
							</cfif> <!--- datos var --->
						<cfelse>
							<tr id="reqlista_det_#CurrentRow#" style="display:;" 
								bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
								<td colspan="2">
									<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
										<cfif instancia.completado eq 1 >
											<tr><td colspan="3" align="center"><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td class="bajada">#estado#</cfoutput></td></tr></table> </td></tr>
										<cfelse>
											<tr><td>&nbsp;</td></tr>	
										</cfif>
										<tr><td align="center" class="bajada">No tiene permisos para ver este requisito</td></tr>
										<tr><td>&nbsp;</td></tr>	
									</table>
								</td>
							</tr>

						</cfif> <!--- permisos --->
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					</div>
				</cfloop>
			</td></tr>
			</table>	
		</td>
	</tr>
</table>
<iframe name="ifrWS" id="ifrWS" src="" width="0" height="0">
</iframe>
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function informacion(id, titulo){
		<cfloop query="instancia">
			document.getElementById('img<cfoutput>#instancia.id_requisito#</cfoutput>').style.display = 'none';
			document.getElementById('info_req_<cfoutput>#instancia.id_requisito#</cfoutput>').style.display = 'none';
			document.getElementById('tr_<cfoutput>#instancia.id_requisito#</cfoutput>').bgColor = <cfif instancia.currentrow mod 2>'#FAFAFA'<cfelse>'#FFFFFF'</cfif>;
		</cfloop>
		document.getElementById('img'+id).style.display = '';
		document.getElementById('tr_'+id).bgColor = '#E4E8F3';
		document.getElementById('info_req_'+id).style.display = '';
		document.getElementById('titulo').innerHTML  = '<strong>Requisito: '+titulo+'<strong>';
	}
	function sbEjecutaWS(LvarIdRequisito)
	{	
		<cfoutput>
		document.getElementById("ifrWS").src = "";
		document.getElementById("ifrWS").src = "WSejecutar.cfm?R=" + LvarIdRequisito + "&I=#url.id_instancia#&P=#url.id_persona#";
		</cfoutput>
	}
</script>