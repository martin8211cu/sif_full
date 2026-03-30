<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<cfparam name="request.lista_actividades_superuser" type="boolean" default="false">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<cfparam name="session.btnALL_PARTs" default="false">
	<cfif isdefined("url.btnALL_PARTs")>
		<cfset session.btnALL_PARTs = (url.btnALL_PARTs EQ "1")>
	</cfif>
	<strong><font style="font-size:20px"><cf_translate key="LB_SeguimientoDelTramite">Seguimiento del tr&aacute;mite</cf_translate></font></strong>
		<cfparam name="url.ProcessInstanceId" type="numeric">
		<cfquery datasource="#session.dsn#" name="hdr">
			select xp.ProcessInstanceId, xp.ProcessId,
				p.Description AS ProcessDescription,
				p.Name AS ProcessName,
				a.Description AS ActivityDescription,
				a.Name AS ActivityName,
				xp.Description AS ProcessInstanceDescription, e.Edescripcion,
				xp.RequesterId, xp.SubjectId,
				xp.State,
                 <cfif isdefined("url.ActivityInstanceId")>
				case 
					when (select count(1) from WfxTransition where FromActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">) > 0
						then 0
					when xa.State <> 'COMPLETED' 
						then -1
					else 1
				end as Procesar,
                </cfif>
                xa.ActivityInstanceId
			from WfxProcess xp
				join WfProcess p
					on p.ProcessId = xp.ProcessId
				join Empresas e
					on e.Ecodigo = xp.Ecodigo
				left join WfxActivity xa
					on xa.ProcessInstanceId = xp.ProcessInstanceId
                    <cfif isdefined("url.ActivityInstanceId")>
					  and xa.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">
                    </cfif>
				left join WfActivity a
					on a.ActivityId = xa.ActivityId
			where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
		</cfquery>
        <cfif not isdefined("url.ActivityInstanceId")>
        	<cfset url.ActivityInstanceId = hdr.ActivityInstanceId>
        </cfif>
        		<cfquery datasource="#session.dsn#" name="hdr">
			select xp.ProcessInstanceId, xp.ProcessId,
				p.Description AS ProcessDescription,
				p.Name AS ProcessName,
				a.Description AS ActivityDescription,
				a.Name AS ActivityName,
				xp.Description AS ProcessInstanceDescription, e.Edescripcion,
				xp.RequesterId, xp.SubjectId,
				xp.State,
                 <cfif isdefined("url.ActivityInstanceId")>
				case 
					when (select count(1) from WfxTransition where FromActivityInstance = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">) > 0
						then 0
					when xa.State <> 'COMPLETED' 
						then -1
					else 1
				end as Procesar,
                </cfif>
                xa.ActivityInstanceId
			from WfxProcess xp
				join WfProcess p
					on p.ProcessId = xp.ProcessId
				join Empresas e
					on e.Ecodigo = xp.Ecodigo
				left join WfxActivity xa
					on xa.ProcessInstanceId = xp.ProcessInstanceId
                    <cfif isdefined("url.ActivityInstanceId")>
					  and xa.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">
                    </cfif>
				left join WfActivity a
					on a.ActivityId = xa.ActivityId
			where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
		</cfquery>
		
		<cfif Len(hdr.RequesterId)>
			<cfquery datasource="asp" name="requester">
				select u.Usulogin, 
					{fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as FullName
				from Usuario u join DatosPersonales dp
				  on u.datos_personales = dp.datos_personales
				where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.RequesterId#">
			</cfquery>
		</cfif>
		
		<cfif Len(hdr.SubjectId) AND hdr.SubjectId NEQ 0>
			<cfquery datasource="asp" name="Subject">
				select u.Usulogin, 
					{fn concat(dp.Pnombre,{fn concat(' ',{fn concat(dp.Papellido1,{fn concat(' ',dp.Papellido2)})})})} as FullName
				from Usuario u join DatosPersonales dp
				  on u.datos_personales = dp.datos_personales
				where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.SubjectId#">
			</cfquery>
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="responsables">
			select xap.Name, xap.Description, xap.Usucodigo, u.Usulogin,
				   case xp.ParticipantType
					when 'HUMAN' 		then '<cf_translate key="LB_HUMAN">Usuario</cf_translate>'
					when 'ORGUNIT' 		then '<cf_translate key="LB_ORGUNIT">Jefatura de Centro Funcional</cf_translate>'
					when 'ADMIN' 		then '<cf_translate key="LB_ADMIN">Administrador de Támites</cf_translate>'
					when 'ROLE' 		then '<cf_translate key="LB_ROLE">Grupo de Permiso o Rol</cf_translate>'
					when 'BOSS' 		then '<cf_translate key="LB_BOSS">Jefatura paso anterior</cf_translate>'
					when 'BOSS1' 		then '<cf_translate key="LB_BOSS1">Jefatura Origen</cf_translate>'
					when 'BOSS2' 		then '<cf_translate key="LB_BOSS2">Jefatura Destino</cf_translate>'
					when 'BOSSES1' 		then '<cf_translate key="LB_BOSSES1">Rol Autorizador Oficina Origen</cf_translate>'
					when 'BOSSES2' 		then '<cf_translate key="LB_BOSSES2">Rol Autorizador Oficina Destino</cf_translate>'
				   end Type				   
			from WfxActivityParticipant xap
				left join Usuario u on u.Usucodigo = xap.Usucodigo
				left join WfParticipant xp
					on xp.ParticipantId = xap.ParticipantId
			where xap.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityInstanceId#">
			<cfif Len(hdr.SubjectId) AND hdr.SubjectId NEQ 0>
				and xap.Usucodigo <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.SubjectId#">
			</cfif>
			order by xap.ParticipantId, u.Usucodigo
		</cfquery>

		<cfif request.lista_actividades_superuser>
			<cfset LvarPermitirAcciones = true>
		<cfelse>
			<cfquery dbtype="query" name="rsResponsable">
				select count(1) as cantidad
				  from responsables
				 where Usucodigo = #session.Usucodigo#
			</cfquery>
			<cfset LvarPermitirAcciones = rsResponsable.cantidad NEQ "" AND rsResponsable.cantidad NEQ "0">
		</cfif>
				
		<cfinvoke component="sif.Componentes.Workflow.Management" 
				  method="getAllowedTransitions" 
				  returnvariable="rsTrans">
			<cfinvokeargument name="ActivityInstanceId" value="#url.ActivityInstanceId#">
		</cfinvoke>

		<cfquery datasource="#session.dsn#" name="detalle">
			select xa.ProcessInstanceId,
                   case xap.HasTransition
					when 0 then ' '
 					when 1 then 'X'
				   end as Aprobadopor,					
				   xa.ActivityInstanceId,
				   a.Name AS ActivityName, xt.TransitionInstanceId,
				   t.Name AS TransitionName,a.ActivityId,
				   xa.StartTime, xa.FinishTime, xt.TransitionTime,
				   xap.Name As ParticipantName, xap.Description as ParticipantDescription, u.Usulogin,
				   case xa.State
					when 'INACTIVE' 	then '<cf_translate key="LB_Inactivo">Inactivo</cf_translate>'
					when 'SUSPENDED' 	then '<cf_translate key="LB_Suspendido">Suspendido</cf_translate>'
					when 'COMPLETED' 	then '*_COMPLETED_*'
					when 'ACTIVE' 		then '<cf_translate key="LB_NoIniciado">No Iniciado</cf_translate>'
				   end State
			from WfxActivity xa 
				inner join WfActivity a
					on xa.ActivityId = a.ActivityId 
			  	left join WfxTransition xt 
					left join WfTransition t
						on t.TransitionId = xt.TransitionId
			  		on xt.FromActivityInstance = xa.ActivityInstanceId 
				left join WfxActivityParticipant xap
					left join Usuario u 
						on u.Usucodigo = xap.Usucodigo
			  		on xap.ActivityInstanceId = xa.ActivityInstanceId
			where xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
			order by xa.StartTime, xa.ActivityInstanceId, xt.TransitionTime, xt.TransitionInstanceId, xap.ParticipantId, u.Usucodigo
		</cfquery>

		<cfset rsPendientes = QueryNew("actividad,status,respon")>
		<cfset varActivitys = ValueList(detalle.ActivityId)>
		<cfset salir = false>
		<cfloop index = "LoopCount" from = "1" to = "100"> 
			<cfquery datasource="#session.dsn#" name="detalle2">
				Select a.ActivityId, a.Name as nombreActiv, b.ParticipantId, c.Name, c.Description, u.Usulogin, ParticipantType
				from WfActivity a 
				  left outer join WfActivityParticipant b
					on  a.ProcessId = b.ProcessId
					and a.ActivityId = b.ActivityId
				  left outer join WfParticipant c
				  	left outer join Usuario u on u.Usucodigo = c.Usucodigo
					 on b.ParticipantId = c.ParticipantId 
				Where a.ActivityId in (
						select ToActivity 
						from WfTransition 
						where FromActivity in (#varActivitys#))
				  and a.ActivityId not in (#varActivitys#)
			</cfquery>
			
			<cfif detalle2.recordCount EQ 0>
				<cfset salir = true>
			<cfelse>
				<cfset varActiv2 = ValueList(detalle2.ActivityId)>
				<cfset varActivitys = varActivitys & ',' & varActiv2>
				<cfloop query="detalle2">
					<cfset QueryAddRow(rsPendientes,1)>
					<cfset QuerySetCell(rsPendientes,"actividad",nombreActiv)>
					<cfif Usulogin NEQ "">
						<cfset QuerySetCell(rsPendientes,"respon", "<strong>#ParticipantType#</strong> #Name# (#Usulogin#)")>
					<cfelse>
						<cfset QuerySetCell(rsPendientes,"respon", "<strong>#ParticipantType#</strong> #Name#")>
					</cfif>
				</cfloop>
			</cfif>
			<cfif salir EQ true>
				<cfbreak>
			</cfif>
		</cfloop> 	

		<cfquery datasource="#session.dsn#" name="DataField">
			select b.DataFieldName, b.Description, b.Label, b.InitialValue, 
				   b.Prompt, b.Length, b.Datatype, xdf.Value
			from WfDataField b left join WfxDataField xdf
			  on b.DataFieldName = xdf.DataFieldName
			where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.ProcessId#">
			  and xdf.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
			order by b.DataFieldName
		</cfquery>

		<form name="form1" method="post" action="javascript:void(0)"> 
			<cfoutput>
				<table border="0" cellpadding="0" cellspacing="0" style="width:100%">
					<tr>
						<td  valign="top" align="right"><strong><cf_translate key="LB_TramiteNumero">Tr&aacute;mite N&uacute;mero :</cf_translate> </strong></td>
						<td  valign="top">#hdr.ProcessInstanceId#</td>
                        <td  valign="top" align="right"><strong><cf_translate key="LB_Empresa" XmlFile="/sif/generales.xml">Empresa</cf_translate> :</strong></td>
                        <td  valign="top">#hdr.Edescripcion#</td>
                     <tr>
                     </tr>
                        <td  valign="top" align="right"><strong><cf_translate key="LB_TipoTramite">Tipo Tr&aacute;mite :</cf_translate></strong></td>
						<td  valign="top">#hdr.ProcessName#   #hdr.ProcessDescription#</td>
                       <td  valign="top" align="right"><strong><cf_translate key="LB_Actividad">Actividad Actual :</cf_translate></strong></td>
					    <td  valign="top">#hdr.ActivityName#<cfif len(trim(hdr.ActivityDescription)) AND hdr.ActivityName NEQ hdr.ActivityDescription>: #hdr.ActivityDescription#</cfif> </td>
					</tr>
                    <tr>
                    	<td colspan="4">&nbsp;
                        </td>
                    </tr>
               </table>
               <table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top"><strong><cf_translate key="LB_Nombre">Nombre Tr&aacute;mite:</cf_translate></strong></td>
						<td valign="top" colspan="5"><strong>#hdr.ProcessInstanceDescription#</strong></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
                    <tr>
					<cfif IsDefined('requester')>
							<td><strong><cf_translate key="LB_SolicitadoPor">Solicitado por </cf_translate> </strong></td>
							<td colspan="3">#requester.FullName#</td>
					</cfif>
					<cfif IsDefined('subject')>
							<td olspan="2"><strong><cf_translate key="LB_Interesado">Usuario Beneficiado</cf_translate> </strong></td>
							<td colspan="2">#subject.FullName#</td>
						
					</cfif>
                    </tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td valign="top" nowrap="nowrap"><strong><cf_translate key="LB_Responsables">Responsables Asignados</cf_translate></strong>&nbsp;&nbsp;</td>
					<cfif hdr.Procesar EQ 0>
						<td colspan="7"><strong><cf_translate key="LB_ActividadTerminada">Actividad Terminada</cf_translate></strong></td>
					<cfelseif hdr.Procesar EQ -1>
						<td colspan="7"><strong><cf_translate key="LB_NoIniciado">Actividad no ha iniciado</cf_translate></strong></td>
					<cfelse>
						<td valign="top" colspan="4" nowrap="nowrap">
								<cfset LvarTypeAnt = "">
							<table border="0">
							<cfloop query="responsables">
								<cfif LvarTypeAnt NEQ responsables.Type>
									<tr>
										<td colspan="4">
										<strong>#responsables.Type#</strong>
										</td>
									</tr>
										<cfset LvarTypeAnt = responsables.Type>
								</cfif>
								<tr>
									<td>
									<cfset LvarStyle ="">
									<cfif responsables.Usucodigo is session.Usucodigo and responsables.RecordCount gt 1>
										<cfset LvarStyle ="font-weight:bolder">
										&rarr;
									</cfif>
									</td>
									<cfif trim(responsables.Usulogin) NEQ "">
										<td style="#LvarStyle#">#responsables.Usulogin#</td>
									</cfif>
									<td style="#LvarStyle#">#responsables.Name#</td>
									<td style="#LvarStyle#" nowrap>#responsables.Description#</td>
								</tr>
							</cfloop>
							</table>
						</td>
					</cfif>
					<td width="80%" valign="top">
						<cfif isdefined('url.dataitem')>
							<table  border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td colspan="9"><strong><cf_translate key="LB_ValoresParaElTramite">Valores para el tr&aacute;mite</cf_translate> </strong></td>
								</tr>
								<tr class="tituloListas">
									<td >&nbsp;</td>
									<td ><em><cf_translate key="LB_Dato">Dato</cf_translate></em></td>
									<td >&nbsp;</td>
									<td ><em><cf_translate key="LB_Valor">Valor</cf_translate></em></td>
								</tr>
								<cfloop query="DataField">
									<tr>
										<td>&nbsp;</td>
										<td>#DataField.Description#</td>
										<td>&nbsp;</td>
										<td>#DataField.Value#</td>
									</tr>
								</cfloop>
							</table>
						<cfelse><!-- no mostrar sin url.dataitem -->
						</cfif>
					</td>
				</tr>
			</table>
			</cfoutput>
			
			<cfoutput>
			<table width="80%" border="0" cellspacing="0" cellpadding="1">
				<cfif hdr.Procesar EQ 1>
					<tr>
						<td valign="top">&nbsp;</td>
					</tr>
					<tr>
						<cfif LvarPermitirAcciones>
							<td colspan="7" nowrap valign="top"><strong><cf_translate key="LB_Acciones">Acciones a tomar</cf_translate></strong>&nbsp;&nbsp;</td>
						<cfelse>
							<td colspan="7" nowrap valign="top"><strong><cf_translate key="LB_AccionesResponsables">Acciones que puede tomar un Responsable Asignado</cf_translate></strong>&nbsp;&nbsp;</td>
						</cfif>
					</tr>
					<tr>
						<td valign="top">&nbsp;</td>
					</tr>
					<tr>
						<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;">&nbsp;</td>
						<td colspan="3" style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></strong></td>
						<td colspan="3" nowrap="nowrap" style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_SendActividad">Enviar a Actividad</cf_translate></strong></td>
					</tr>
					<cfloop query="rsTrans">
						<tr>
							<td align="right">
								<cfif LvarPermitirAcciones>
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
										<cfset imagen ="/cfmx/proyecto7/imagenes/aprobar.png">	
									<cfelseif findNoCase("RECHAZ",Name)
									   OR findNoCase("CANCEL",name)
									   OR findNoCase("ANULA",name)
									   OR findNoCase("CLOSE",name)
									   OR findNoCase("STOP",name)
									   OR findNoCase("DISALLOW",name)
									   OR findNoCase("REJECT",name)
									>
										<cfset imagen ="/cfmx/proyecto7/imagenes/rechazar.png">	
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
                                        onclick=' javascript: if (confirm("#MSG_Actual# #hdr.ActivityDescription#\n\n#MSG_Accion#:\t#Ucase(Name)#\n#MSG_Enviar#:\t#toName#<cfif toName NEQ toDescription> - #toDescription#</cfif>")) do_transition(#url.ProcessInstanceId#,#url.ActivityInstanceId#,#rsTrans.TransitionId#); else  return false; '
										<!---onClick='javascript:if (confirm("#Ucase(Name)#")) {do_transition(#url.ProcessInstanceId#,#url.ActivityInstanceId#,#rsTrans.TransitionId#);} else return false;'--->
									></a>
								</cfif>
							</td>
							<td colspan="3">&nbsp;
								#Ucase(Name)#<cfif Name NEQ Description> = #Description#</cfif>
							</td>
							<td colspan="3">
								#toName#<cfif toName NEQ toDescription> = #toDescription#</cfif>
								<cfif IsFinish EQ "1">
									<strong>(<cf_translate key="LB_AccionFinal">Finaliza Trámite</cf_translate>)</strong>
								</cfif>
							</td>
						</tr>
					</cfloop>
				</cfif>
				<tr>
					<td valign="top">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="7" valign="top"><strong><cf_translate key="LB_Historia">Historia</cf_translate></strong>&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">&nbsp;</td>
				</tr>
			</cfoutput>
				<tr>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;">&nbsp;</td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Actividad">Actividad</cf_translate></strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Status">Status</cf_translate></strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_FechaAsignacion">Fecha Asignaci&oacute;n</cf_translate> </strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_GechaAccion">Fecha Acci&oacute;n</cf_translate> </strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Responsables">Responsables</cf_translate></strong></td>
					<td align="center" style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong><cf_translate key="LB_Accion">Acci&oacute;n</cf_translate></strong></td>
				</tr>
				<cfoutput query="detalle" group="ActivityInstanceId">
					<cfset row_for_activity = 0>
					<cfset LvarAprobador = false>
					<cfoutput group="TransitionInstanceId">
						<cfset row_for_activity = row_for_activity + 1>
						<tr class="<cfif detalle.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>" 
							onmousemove="window.status='#detalle.ActivityInstanceId#,#detalle.TransitionInstanceId#'">
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							<cfif detalle.ActivityInstanceId EQ url.ActivityInstanceId>
								&rarr;
								<cfset LvarBOLD1 = "<strong>">
								<cfset LvarBOLD2 = "</strong>">
							<cfelse>
								&nbsp;
								<cfset LvarBOLD1 = "">
								<cfset LvarBOLD2 = "">
							</cfif>
						</td>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							#LvarBOLD1#
							<cfif row_for_activity is 1>#detalle.ActivityName#</cfif>&nbsp;
							#LvarBOLD2#
						</td>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							#LvarBOLD1#
							<cfset LvarCompletado = false>
							<cfif Len(detalle.TransitionName) OR hdr.State EQ "COMPLETE">
								<cf_translate key="LB_Completado">Completado</cf_translate>
								<cfset LvarCompletado = true>
							<cfelseif State EQ "*_COMPLETED_*">
								<cf_translate key="LB_Asignado">Asignado</cf_translate>
							<cfelse>
								#State#
							</cfif>
							#LvarBOLD2#
						</td>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							#LvarBOLD1##DateFormat(detalle.StartTime,'dd/mm/yyyy')# #TimeFormat(detalle.StartTime,'HH:mm:ss')# &nbsp;#LvarBOLD2#
						</td>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							#LvarBOLD1##DateFormat(detalle.TransitionTime,'dd/mm/yyyy')# #TimeFormat(detalle.TransitionTime,'HH:mm:ss')#&nbsp;#LvarBOLD2#
						</td>

					<cfif NOT session.btnALL_PARTs>
							<cfset LvarUsuario = "&nbsp;">
							<cfset LvarAccion = "&nbsp;">
							<cfoutput>
								<cfif #detalle.Aprobadopor# EQ "X">
									<cfset LvarAprobador = true>
									<cfset LvarAccion = detalle.TransitionName>
									<cfif trim(detalle.Usulogin) NEQ "">
										<cfset LvarUsuario = detalle.Usulogin>
									<cfelse>
										<cfset LvarUsuario = detalle.ParticipantName>
									</cfif>
								</cfif>
							</cfoutput>
							<cfif LvarCompletado AND #detalle.ParticipantName# NEQ "" AND Not LvarAprobador>
								<cfset LvarUsuario = "ADMIN">
							</cfif>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							<strong>#LvarUsuario#</strong>
						</td>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC" align="center">
							<strong>&nbsp;#detalle.TransitionName#</strong>
						</td>
						</tr>
					<cfelse>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC">
							<cfoutput>
								<cfif #detalle.Aprobadopor# EQ "X">
								<cfset LvarAprobador = true>
								<strong>
								</cfif>
									<cfif trim(detalle.Usulogin) NEQ "">
										#detalle.Usulogin#
									<cfelse>
										#detalle.ParticipantName#
									</cfif>
									&nbsp; <br>
								<cfif #detalle.Aprobadopor# EQ "X">
								</strong>
								</cfif>
							</cfoutput>
							<cfif LvarCompletado AND #detalle.ParticipantName# NEQ "" AND Not LvarAprobador>
								<strong>ADMIN</strong>
							</cfif>
						</td>
						<td valign="top" style="border-bottom:solid 1px ##CCCCCC" align="center">
							<cfif #detalle.ParticipantName# NEQ "">
								<cfoutput><strong><cfif #detalle.Aprobadopor# EQ "X">#detalle.TransitionName#</cfif></strong><br></cfoutput>
								<cfif Not LvarAprobador>
									<strong>#detalle.TransitionName#</strong>
								</cfif>
							<cfelse>
								<strong>#detalle.TransitionName#</strong>
							</cfif>
						</td>
						</tr>
					</cfif>
					</cfoutput>
				</cfoutput>
				
				<cfoutput query="rsPendientes">
					<tr class="<cfif rsPendientes.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>">
						<td>&nbsp;</td>
						<td>#actividad#</td>
						<td>= <cf_translate key="LB_Pendiente">Pendiente</cf_translate> =</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>#respon#</td>
						<td>&nbsp;</td>
					</tr>
				</cfoutput>

				<tr><td colspan="7">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="5">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_VerParticipantes"
						Default="Ver Participantes"
						XmlFile="/sif/generales.xml"
						returnvariable="BTN_VerParticipantes"/>

						<cfset LvarParams = cgi.QUERY_STRING>
						<cfset LvarPto = find("&BTNALL_PARTS",ucase(LvarParams))>
						<cfif LvarPto GT 0>
							<cfset LvarParams = left(LvarParams,LvarPto-1)>
						</cfif>
						<cfif session.btnALL_PARTs>
							<cfset LvarParams = LvarParams & "&btnALL_PARTs=0">
						<cfelse>
							<cfset LvarParams = LvarParams & "&btnALL_PARTs=1">
						</cfif>

						<cfif request.lista_actividades_superuser>
							<input type="button" onClick="location.href='consola-aprob-det.cfm?<cfoutput>#LvarParams#</cfoutput>'" value="<cfoutput>#BTN_VerParticipantes#</cfoutput>" tabindex="1">
						<cfelse>
							<input type="button" onClick="location.href='aprobacion-detalle.cfm?<cfoutput>#LvarParams#</cfoutput>'" value="<cfoutput>#BTN_VerParticipantes#</cfoutput>" tabindex="1">
						</cfif>

					</td>
					<td>&nbsp;</td>
				</tr>
				<tr><td colspan="7"><cfoutput><cfoutput><cfoutput>#detalle.ParticipantDescription#</cfoutput></cfoutput></cfoutput></td>
				</tr>
			</table>
		</form>
		<cfif LvarPermitirAcciones>
			<script language="javascript">
				<cfoutput>
				function do_transition (ProcessInstanceId, ActivityInstanceId, TransitionId) {
						window.parent.do_transition(ProcessInstanceId, ActivityInstanceId, TransitionId);
				}
				</cfoutput>
			</script>
		</cfif>
</div>