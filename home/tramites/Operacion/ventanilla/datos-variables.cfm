<cfset criterios = createobject('component', 'home.tramites.componentes.criterios' ) >

<cfinvoke component="home.tramites.componentes.tramites"
	method="detalle_tramite"
	id_persona="#form.id_persona#"
	id_tramite="#tramite.id_tramite#"
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
			 
	popUpWindow("/cfmx/home/tramites/Operacion/gestion/req_cita_form.cfm"+params,250,200,650,450);
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
				<tr><td bgcolor="##ECE9D8" colspan="2" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Requisitos</strong></td></tr>

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
			<cfif isdefined("url.id_requisito") and len(trim(url.id_requisito))>
				<cfquery name="requisito" dbtype="query">
					select nombre_requisito
					from instancia
					where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_requisito#">
				</cfquery>
				<cfset titulo = requisito.nombre_requisito >
			</cfif>
			
			<tr><td id="titulo" bgcolor="##ECE9D8" colspan="2" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Requisito: #titulo#</strong></td></tr>
			<tr><td>
				<cfset requisitos = '' >

				<cfset datos_variables_mostrado = false>

				<cfloop query="instancia">
					<cfset campos = '' >
					<div id="info_req_#instancia.id_requisito#" style="display:block; width:100%px; elevation:above; display: <cfif isdefined("url.id_requisito")><cfif url.id_requisito eq instancia.id_requisito>block<cfelse>none</cfif><cfelseif instancia.currentrow eq 1>block<cfelse>none</cfif>;" >
					 <form name="form#id_requisito#" action="<cfif instancia.es_pago eq 1 >pago-sql.cfm<cfelse>datos-variables-sql.cfm</cfif>" style="margin:0;" method="post">
					<table border="0" cellpadding="2" cellspacing="0" width="100%">
						<cfparam name="url.msg_requisito" default="">
						<cfif isdefined("url.id_requisito") and len(trim(url.id_requisito))>
						<cfif Len(Trim(url.msg_requisito)) and url.id_requisito eq instancia.id_requisito>
						<tr><td colspan="2" style="font-weight:bold;color:white;background-color:red;">
							#HTMLEditFormat(url.msg_requisito)# </td></tr>
						</cfif>
						</cfif>
						
						<input type="hidden" name="loc" value="gestion">
						<input type="hidden" name="id_tramite" value="#tramite.id_tramite#">
						<input type="hidden" name="id_persona" value="#data.id_persona#">
						<input type="hidden" name="id_instancia" value="#form.id_instancia#">
						<input type="hidden" name="id_requisito" value="#instancia.id_requisito#">
						<cfset tiene_cita = '' >
						<cfset tiene_conexion = '' >
						<cfif instancia.es_cita>
									
							<cfsavecontent variable="tiene_cita">
								<cfif len(trim(instancia.id_cita))>
									<cfquery name="cita" datasource="#session.tramites.dsn#">
										select fecha,id_agenda from TPCita where id_cita = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_cita#">
									</cfquery>  
									<cfif isdefined('cita') and cita.recordCount GT 0>
										<cfquery datasource="#session.tramites.dsn#" name="citainf">
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
												<td width="1%"><img src="../../images/cita.gif" border="0"></td>
												<td align="left">Cita programada para el dia #LSDateFormat(cita.fecha,'dd/mm/yyyy')#, #LSTimeFormat(cita.fecha, 'h:mm tt')#</td>
											</tr>
											<tr>
												<td  nowrap  style="padding:3px;"><strong>Servicio Solicitado </strong></td>
												<td   style="padding:3px;">#citainf.codigo_tiposerv#-#citainf.nombre_tiposerv#</td>		
											</tr>	
											<tr>
												<td   style="padding:3px;">&nbsp;</td>
												<td   style="padding:3px;">#citainf.descripcion_tiposerv#</td>		
											</tr>				
											<tr>
												<td  nowrap  style="padding:3px;"><strong>Servicio ofrecido por:</strong></td>
												<td  style="padding:3px;">#citainf.codigo_inst#-#citainf.nombre_inst#</td>		
											</tr>									
											<tr>
												<td  style="padding:3px;"><strong>Horario</strong></td>
												<td  style="padding:3px;">De #LSTimeFormat(citainf.hora_desde, "hh:mm tt")# a  #LSTimeFormat(citainf.hora_hasta, "hh:mm tt")#</td>		
											</tr>		
											<tr>
												<td   style="padding:3px;"><strong>Lugar de la cita </strong></td>
												<td   style="padding:3px;">#citainf.direccion#</td>		
											</tr>		
											<tr>
												<td   style="padding:3px;">&nbsp;</td>
												<td   style="padding:3px;">#citainf.direccion1#</td>		
											</tr>	
											<tr>
												<td  style="padding:3px;">&nbsp;</td>
												<td   style="padding:3px;">#citainf.direccion2#</td>		
											</tr>								
										</table>	
									</cfif>							
								<cfelse>	<!--- No existe tramite --->
										<table align="center" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td>&nbsp;</td>		
											</tr>
											<tr>
												<td style="padding:3px;">
													<a href="javascript: agregarCita(#data.id_persona#,#form.id_instancia#,#tramite.id_tramite#,#instancia.id_requisito#);"><strong>Agregar Cita</strong></a>
												</td>		
											</tr>								
											<tr>
												<td>&nbsp;</td>		
											</tr>											
										</table>									
									
								</cfif>
							</cfsavecontent>	
						</cfif>
						
						<cfif instancia.es_conexion and len(trim(instancia.id_documento)) >
							<cfset institucion = '' >
							<cfquery name="doc" datasource="#session.tramites.dsn#">
								select id_inst
								from TPDocumento
								where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_documento#">
							</cfquery>
							<cfif Len(trim(doc.id_inst))>
								<cfquery name="inst" datasource="#session.tramites.dsn#">
									select id_inst, nombre_inst
									from TPInstitucion
									where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#doc.id_inst#">
								</cfquery>
								<cfset institucion = inst.nombre_inst >
				
								<cfquery name="WSreq" datasource="#session.tramites.dsn#">
									select rm.id_metodo
									  from TPRequisitoWSMetodo rm
										inner join WSMetodo m
											 on m.id_metodo = rm.id_metodo
											and m.activo = 1
									 where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.id_requisito#">
								</cfquery>
					
								<cfif len(trim(institucion)) AND len(trim(WSreq.id_metodo))>
								<cfsavecontent variable="tiene_conexion">
									<table>
									<tr>
										<td width="1%"><a href="javascript:sbEjecutaWS('#instancia.id_requisito#')"><img src="../../images/conexion.gif" border="0"></a></td>
										<td align="left"><a href="javascript:sbEjecutaWS('#instancia.id_requisito#')">Conectarse a #institucion#</a></td>
									</tr>
									</table>
								</cfsavecontent>
								</cfif>
							</cfif>
						</cfif>
						
						<cfif instancia.permisos eq 1 >
							<cfinclude template="/home/tramites/vistas/datos-variables.cfm">		
							<cfif Len(datos_var)>
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
												<!---
												<tr><td colspan="2">
													<input type="checkbox" name="completado_#instancia.id_requisito#" id="completado_#instancia.id_requisito#" value="1" <cfif instancia.completado>checked</cfif> >
													<label for="completado_#instancia.id_requisito#"><strong>Marcar el requisito como completado</strong></label>
												</td></tr>
												--->
												<tr><td colspan="2"><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td>#estado#</td></cfoutput></tr></table> </td></tr>
												<tr><td colspan="2">#tiene_cita#</td></tr>
												<tr><td colspan="2">#tiene_conexion#</td></tr>
												<tr><td colspan="2">
													<table cellpadding="0" cellspacing="0">
														<tr>
															<td width="1%">
																<input type="checkbox" name="completado" id="completado_#instancia.id_requisito#"
																	<cfif instancia.rechazado EQ 0 and instancia.completado EQ 1>checked</cfif> >
															</td>
															<td><label for="completado_#instancia.id_requisito#">#instancia.texto_completado#</label></td>
														</tr>
													

													</table> 
												</td></tr>
												
												<!--- ====================================== --->
												<tr><td colspan="2"><cfinclude template="flujo.cfm"></td></tr>
												<!--- ====================================== --->
												
												<tr><td colspan="2">&nbsp;</td></tr>
												<tr><td colspan="2" align="center">
													<input type="submit" name="Aceptar" value="Guardar" class="boton"
													<cfif instancia.rechazado EQ 1>
														onClick="if (!confirm('El requisito ya ha sido rechazado, ¿desea cambiar su estado a completado?')) {return false;}"
													</cfif>
													>
													<cfif instancia.rechazado EQ 0>
														<input type="submit" name="Rechazar" value="Rechazar" class="boton"
														<cfif instancia.completado EQ 1>
														  onClick="if (!confirm('El requisito ya ha sido completado, ¿desea cambiar su estado a rechazado?')) return false;"
														</cfif>
														>
													</cfif>
												</td></tr>
											</table>
										</td>
									</tr>
								<cfelse>
									<tr id="reqlista_det_#CurrentRow#" style="display:;" bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
										<td colspan="2">
											<cfif instancia.es_pago eq 1 >
												<cfinclude template="pago.cfm">
											<!---
											<cfelseif instancia.es_impedimento eq 1 >
												<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
													<tr><td>&nbsp;</td></tr>
													<tr><td align="center">Es impedimento</td></tr>
													<tr><td>&nbsp;</td></tr>
												</table>
												--->
											<cfelse>
												<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
													<tr><td><table><tr><td><cfoutput><img src="/cfmx/home/tramites/images/#img#" width="16" height="16" border="0" alt="#img#" title="#estado#">&nbsp;</td><td>#estado#</td></cfoutput></tr></table> </td></tr>
													<tr><td>&nbsp;</td></tr>
													<tr><td align="center">No se han registrado datos adicionales para este requisito</td></tr>
													<tr><td>&nbsp;</td></tr>
												</table>
											</cfif>	
										</td>	
									</tr>
								</cfif>
							</cfif>
						<cfelse>
							<tr id="reqlista_det_#CurrentRow#" style="display:;" 
								bgcolor="<cfif instancia.currentrow mod 2>##FAFAFA</cfif>">
								<td colspan="2">
									<table width="100%" cellpadding="2" cellspacing="0" border="0"  style="border:1px solid gray; ">
										<tr><td>&nbsp;</td></tr>	
										<tr><td align="center">No tiene permisos para ver este requisito</td></tr>
										<tr><td>&nbsp;</td></tr>	
									</table>
								</td>
							</tr>

						</cfif> <!--- permisos --->
						<input type="hidden" name="id_campo" value="<cfoutput>#campos#</cfoutput>">
						<tr><td colspan="2">&nbsp;</td></tr>
					</table>
					</form>
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
		document.getElementById("ifrWS").src = "WSejecutar.cfm?R=" + LvarIdRequisito + "&I=#form.id_instancia#&P=#form.id_persona#";
		</cfoutput>
	}
</script>