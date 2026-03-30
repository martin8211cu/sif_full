<cfparam name="workload" type="query">
<cfparam name="request.lista_actividades_superuser" type="boolean" default="false">
<form name="form1" method="post" action="<cfoutput>#CGI.SCRIPT_NAME#</cfoutput>"> 
	<table border="0" cellspacing="0" cellpadding="3" width="100%">
		<tr>
			<td colspan="7">	
				<table border="0" cellspacing="0" cellpadding="0" width="100%">
					<tr>
						<td>
							<img src="/cfmx/sif/imagenes/Page_Load.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >
							<font style="font-size:10px"><cf_translate key="LB_Detalle">Detalle</cf_translate></font>
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/stop2.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >
							<font style="font-size:10px"><cf_translate key="LB_Iniciar">Iniciar</cf_translate></font>
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/stop.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >
							<font style="font-size:10px"><cf_translate key="LB_Completar">Completar</cf_translate></font>
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/stop3.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >
							<font style="font-size:10px"><cf_translate key="LB_Seguimiento">Seguimiento</cf_translate></font>
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/w-check.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >						
							<font style="font-size:10px"><cf_translate key="LB_Aceptar">Aceptar</cf_translate></font>
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/w-close.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >						
							<font style="font-size:10px"><cf_translate key="LB_Rechazar">Rechazar</cf_translate></font>
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/forw.gif" 
							name="imagen" 
							border="0" 
							align="absmiddle" >						
							<font style="font-size:10px"><cf_translate key="LB_Otros">Otros</cf_translate></font>
						</td>
					</tr>
				</table>
			<td>	
		</tr>
		<cfoutput>
			<tr class="tituloListas">
				<td><strong><font style="font-size:10px"><cf_translate key="LB_Numero">N&uacute;mero</cf_translate></font></strong></td>
				<td><strong><font style="font-size:10px"><cf_translate key="LB_TipoTramite">Tipo Tr&aacute;mite</cf_translate></font></strong></td>
				<td><strong><font style="font-size:10px"><cf_translate key="LB_Nombre">Nombre</cf_translate></font></strong></td>
				<td><strong><font style="font-size:10px"><cf_translate key="LB_Asignado">Asignado</cf_translate></font></strong></td>
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr class="tituloListas">
				<td>
					<cfparam name="form.F_numero" default="">
					<input type="text" name="F_numero"	id="F_numero"	value="#form.F_numero#"	style="font-size:10px; width:80;">
				</td>
				<td>
					<cfparam name="form.F_tipo" default="">
					<input type="text" name="F_tipo"	id="F_tipo"	value="#form.F_tipo#"	style="font-size:10px; width:280;">
				</td>
				<td>
					<cfparam name="form.F_nombre" default="">
					<input type="text" name="F_nombre"	id="F_nombre"	value="#form.F_nombre#"	style="font-size:10px; width:250;">
				</td>
				<td>
					<cfparam name="form.F_asignado" default="">
					<cf_sifcalendario name="F_asignado" value="#form.F_asignado#"	style="font-size:10px">
				</td>
				<td colspan="3">
					<input type="submit" name="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</cfoutput>

		<cfif form.F_numero NEQ "" OR form.F_tipo NEQ "" OR form.F_nombre NEQ "" OR form.F_asignado NEQ "">
			<cfquery name="workload" dbtype="query">
				select * 
				  from workload
				 where 1=1
				<cfif form.F_numero NEQ "">
					and cast(workload.ProcessInstanceId as varchar) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.F_numero#">
				</cfif>
				<cfif form.F_tipo NEQ "">
					and ( UPPER(workload.ProcessDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_tipo)#%">
					<cfif workload.Ecodigo neq session.Ecodigo or true>
					   OR UPPER(workload.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_tipo)#%">
					</cfif>
					    )
				</cfif>
				<cfif form.F_nombre NEQ "">
					and ( UPPER(workload.ProcessInstanceDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_nombre)#%">
					   OR UPPER(workload.ActivityDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.F_nombre)#%">
					    )
				</cfif>
				<cfif form.F_asignado NEQ "">
					and workload.StartTime between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.F_asignado)#">
											   and <cfqueryparam cfsqltype="cf_sql_date" value="#dateAdd('d',1,LSParseDateTime(form.F_asignado))#">
				</cfif>
			</cfquery>

		</cfif>
		<cfflush interval="64">
		<cfoutput query="workload" group="ActivityInstanceId">
			<!--- Esto es para guardar el id de la actividad y en cual línea está --->
			<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
				onMouseMove="style.backgroundColor='##E4E8F3';" 
				onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		
				<td nowrap valign="top"><font style="font-size:10px">#workload.ProcessInstanceId#</font></td>
				<td nowrap valign="top"><font style="font-size:10px">#workload.ProcessDescription#
					<cfif workload.Ecodigo neq session.Ecodigo or true> <br> #workload.Edescripcion#</cfif></font>
				</td>
				<td valign="top">
					<font style="font-size:10px">
					#workload.ProcessInstanceDescription#<br>
					#workload.ActivityDescription#
					</font>
				</td>
				<td nowrap valign="top">
					<font style="font-size:10px">
					#LSDateFormat(workload.StartTime,'dd/mm/yyyy')# #LSTimeFormat(workload.StartTime, 'hh:mmtt')#
					</font>
					<!--- ver los responsables --->
					<cfset soy_responsable = false>
					<cfset hay_responsables = false>
					<cfoutput>
						<cfif workload.ParticipantUsucodigo is session.Usucodigo>
							<cfset soy_responsable = true>
						</cfif>
						<cfif Len(workload.ParticipantUsucodigo)>
							<cfset hay_responsables = true>
						</cfif>
					</cfoutput>
					
				</td>
				<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Seguimiento"
						Default="Seguimiento"
						returnvariable="BTN_Seguimiento"/>
				<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Detalle"
						Default="Detalle"
						returnvariable="BTN_Detalle"/>
				<td valign="top">
					<!--- <input type="button" value="#BTN_Detalle#" tabindex="1"
						   onClick="showlink(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#)" > --->
				
					<a href="##" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Page_Load.gif" 
						title="#BTN_Detalle#" 
						name="imagen" 
						border="0" 
						align="absmiddle" 
						onClick='javascript: showlink(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#);'>	
					</a>	   
				</td>
						
				
				<td valign="top">
					<!--- <input type="button" value="#BTN_Seguimiento#" tabindex="1" 
						   onClick="detalle(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#)" > --->
					<a href="##" tabindex="-1">
					<img src="/cfmx/sif/imagenes/stop3.gif"
						title="#BTN_Seguimiento#" 
						name="imagen" 
						border="0" 
						align="absmiddle" 
						onClick='javascript: detalle(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#);'>	
					</a>	
						   
				</td>
				<td align="center" valign="top" nowrap>&nbsp;
					<cfif soy_responsable or request.lista_actividades_superuser>
						<!--- Botones de Acciones a ejecutar para las actividades del responsable --->			&nbsp;
						<cfif workload.State EQ "INACTIVE" or State EQ "SUSPENDED">
							<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Iniciar"
									Default="Iniciar"
									returnvariable="BTN_Iniciar"/>

							<!--- <input type="button" name="btnIniciar" value="#BTN_Iniciar#" tabindex="1"
							onClick="javascript: set_state(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#,'start');"> --->
							
							<a href="##" tabindex="-1">
							<img src="/cfmx/sif/imagenes/stop2.gif" 
								title="#BTN_Iniciar#" 
								name="imagen" 
								border="0" 
								align="absmiddle" 
								onClick='javascript: set_state(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#,"start");'>	
							</a>	&nbsp;						
							
							
						<cfelseif workload.State EQ "ACTIVE">
							<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Completar"
									Default="Completar"
									returnvariable="BTN_Completar"/>
							<!--- <input type="button" name="btnCompletar" value="#BTN_Completar#" tabindex="1"
							onClick="javascript: set_state(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#,'finish');" >&nbsp; --->	
							
							<a href="##" tabindex="-1">
							<img src="/cfmx/sif/imagenes/stop.gif" 
								title="#BTN_Completar#" 
								name="imagen" 
								border="0" 
								align="absmiddle" 
								onClick='javascript: set_state(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#,"finish");'>	
							</a>	&nbsp;	
							
										
						<cfelseif workload.State EQ "COMPLETED">
							<cfinvoke component="sif.Componentes.Workflow.Management" 
									  method="getAllowedTransitions" 
									  returnvariable="rsTrans">
								<cfinvokeargument name="ActivityInstanceId" value="#workload.ActivityInstanceId#">
							</cfinvoke>
							<cfset workload_ProcessInstanceId = workload.ProcessInstanceId>
							<cfset workload_ActivityInstanceId = workload.ActivityInstanceId>
							<cfloop query="rsTrans">
								<!--- <input type="button" name="btnTrans" value="#Ucase(Name)# &gt;&gt;" tabindex="1"
									   onClick="javascript: do_transition(#workload_ProcessInstanceId#,
												#workload_ActivityInstanceId#,#rsTrans.TransitionId#);">
								&nbsp; --->
							<cfset imagen ="">
							<cfif findNoCase("ACEPTA",name)
							   OR findNoCase("APROB",name)
							   OR findNoCase("APRUEB",name)
							   OR findNoCase("APLICA",name)
							   OR findNoCase("AUTORI",name)
							   OR findNoCase("RATIFIC",name)
							   OR findNoCase("CONCEN",name)
							   OR findNoCase("POSITIV",name)
							   OR findNoCase("CONFIRM",name)
							   OR name EQ "OK"
							   OR findNoCase("ACCEPT",name)
							   OR findNoCase("APPROV",name)
							   OR findNoCase("AGREE",name)
							   OR findNoCase("PASS",name)
							>
								<cfset imagen ="/cfmx/sif/imagenes/w-check.gif">	
							<cfelseif findNoCase("RECHAZ",Name)
							   OR findNoCase("CANCEL",name)
							   OR findNoCase("ANULA",name)
							   OR findNoCase("CLOSE",name)
							   OR findNoCase("STOP",name)
							   OR findNoCase("DISALLOW",name)
							   OR findNoCase("REJECT",name)
							>
								<cfset imagen ="/cfmx/sif/imagenes/w-close.gif">	
							<cfelseif TRIM(Ucase(Name)) eq 'APROBACIONJEFE'>
								<cfset imagen ="/cfmx/sif/imagenes/w-check.gif">	
							<cfelseif	TRIM(Ucase(Name)) eq 'RECHAZOJEFE'>
								<cfset imagen ="/cfmx/sif/imagenes/w-close.gif">
							<cfelse>
								<cfset imagen ="/cfmx/sif/imagenes/forw.gif">	
							</cfif>	
							

							<cfinvoke 	component="sif.Componentes.Translate"
										method="Translate"
										Key="MSG_Actual"
										Default="ACTIVIDAD"
										returnvariable="MSG_Actual"
							/>
							<cfinvoke 	component="sif.Componentes.Translate"
										method="Translate"
										Key="MSG_Accion"
										Default="Acción a tomar"
										returnvariable="MSG_Accion"
							/>
							<cfinvoke 	component="sif.Componentes.Translate"
										method="Translate"
										Key="MSG_Enviar"
										Default="Enviar a actividad"
										returnvariable="MSG_Enviar"
							/>

							<a href="##" tabindex="-1">
							<img src="#imagen#"  title="#Ucase(Name)#"
								title="#Ucase(Name)#" 
								name="imagen" 
								border="0" 
								align="absmiddle" 
								onClick='javascript: if (confirm("#MSG_Actual# #workload.ActivityDescription#\n\n#MSG_Accion#:\t#Ucase(Name)#\n#MSG_Enviar#:\t#toName#<cfif toName NEQ toDescription> - #toDescription#</cfif>")) do_transition(#workload_ProcessInstanceId#,#workload_ActivityInstanceId#,#rsTrans.TransitionId#); else return false;'
							></a>
							&nbsp;	
								
							</cfloop>
						</cfif>
					</cfif><!--- soy_responsable --->
				</td>
			</tr>
		</cfoutput>
		<cfoutput>
			<cfif workload.RecordCount GT 0>
				<tr><td colspan="8" align="center">&nbsp;</td></tr>
				<tr><td colspan="8" align="center">----------------- <cf_translate key="MSG_FinDeLaConsulta">FIN DE LA CONSULTA</cf_translate> ----------------</td></tr>	
			<cfelse>
				<tr>
				  <td colspan="8" align="center">----------------- <cf_translate key="MSG_NoHayTramitesPorAprobar">NO HAY TR&Aacute;MITES POR APROBAR</cf_translate> ----------------</td>
				</tr>
			</cfif>
		</cfoutput>  
	</table>
</form>

<cfset CurrentPageForURL = JSStringFormat(URLEncodedFormat(Replace(GetFileFromPath(CGI.SCRIPT_NAME),'.cfm','')))>
<cfif request.lista_actividades_superuser>
	<cfset LvarAprobacionDetalle = "consola-aprob-det.cfm">
<cfelse>
	<cfset LvarAprobacionDetalle = "aprobacion-detalle.cfm">
</cfif>
<cfoutput>
	<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/sinbotones.js"></script>

	<script language="JavaScript1.2">
		function set_state (ProcessInstanceId, ActivityInstanceId, action) {
			sinbotones();
			location.href = 'aprobacion-apply.cfm?from=#CurrentPageForURL#&ProcessInstanceId=' + escape (ProcessInstanceId) +
				'&ActivityInstanceId=' + escape (ActivityInstanceId) +
				'&action=' + escape (action);
		}
		
		function do_transition (ProcessInstanceId, ActivityInstanceId, TransitionId) {
			sinbotones();
			location.href = 'aprobacion-apply.cfm?from=#CurrentPageForURL#&ProcessInstanceId=' + escape (ProcessInstanceId) +
				'&ActivityInstanceId=' + escape (ActivityInstanceId) +
				'&TransitionId=' + escape (TransitionId);
		}
	
		function detalle(ProcessInstanceId, ActivityInstanceId) {
			sinbotones();
			location.href = '#LvarAprobacionDetalle#?from=#CurrentPageForURL#&ProcessInstanceId=' + escape (ProcessInstanceId) +
				'&ActivityInstanceId=' + escape (ActivityInstanceId);
		}
	
		function showlink(ProcessInstanceId, ActivityInstanceId) {
			sinbotones();
			location.href = 'aprobacion-showlink.cfm?from=#CurrentPageForURL#&ProcessInstanceId=' + escape (ProcessInstanceId) +
				'&ActivityInstanceId=' + escape (ActivityInstanceId);
		}
	</script>
</cfoutput>