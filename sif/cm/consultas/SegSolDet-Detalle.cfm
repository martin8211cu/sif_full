		<!--- <cfparam name="url.ProcessInstanceId" type="numeric"> --->
		<cfset url.ProcessInstanceId = rsSolicitud.ProcessInstanceId>
		

		<!--- <cfset url.ProcessInstanceId = rsOrdenes.EOnumero> --->
		
		<!--- <cfparam name="url.ActivityInstanceId" type="numeric"> --->
		<!---
		<cfinvoke component="sif.Componentes.Workflow.Management" method="getProcessHistory" returnvariable="workload">
		<cfinvokeargument name="ProcessInstanceId" value="#url.ProcessInstanceId#">
		</cfinvoke>
		--->
		<cfquery datasource="#session.dsn#" name="hdr">
			select xp.ProcessInstanceId, xp.ProcessId,
				p.Description AS ProcessDescription,
				p.Name AS ProcessName,
				xp.Description AS ProcessInstanceDescription, e.Edescripcion,
				xp.RequesterId
			from WfxProcess xp
				join WfProcess p
					on p.ProcessId = xp.ProcessId
				join Empresas e
					on e.Ecodigo = xp.Ecodigo
			where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
		</cfquery>
		
		<cfif Len(hdr.RequesterId)>
        	<cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery datasource="asp" name="requester">
				select u.Usulogin, dp.Pnombre #_Cat# ' ' #_Cat# dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 as FullName
				from Usuario u join DatosPersonales dp
				  on u.datos_personales = dp.datos_personales
				where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.RequesterId#">
			</cfquery>
		</cfif>
		
		<cfquery datasource="#session.dsn#" name="detalle">
			select xa.ProcessInstanceId, xa.ActivityInstanceId,
				   a.Name AS ActivityName, xt.TransitionInstanceId,
				   t.Name AS TransitionName,
				   xa.StartTime, xa.FinishTime, xt.TransitionTime,
				   xap.Name As ParticipantName, xap.Description as ParticipantDescription,
                                   case xap.HasTransition
					when 0 then ''
 					when 1 then 'X'
				   end as Aprobadopor,
				   a.ActivityId,
				   case xa.State
					when 'INACTIVE' then 'Inactivo'
					when 'SUSPENDED' then 'Suspendido'
					when 'COMPLETED' then 'Completado'
					when 'ACTIVE' then 'Activo'
				   end State
			from WfxActivity xa join WfActivity a
			  on xa.ActivityId = a.ActivityId left join (WfxTransition xt join WfTransition t
													 on t.TransitionId = xt.TransitionId )
			  on xt.FromActivityInstance = xa.ActivityInstanceId left join WfxActivityParticipant xap
			  on xap.ActivityInstanceId = xa.ActivityInstanceId
			where xa.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
			order by xa.StartTime, xa.ActivityInstanceId, xt.TransitionTime, xt.TransitionInstanceId
		</cfquery>	
		<!---<cfdump var ="#detalle#">
		<cfabort> --->
		<cfset rsRegs = QueryNew("activityId,actividad,respon,accion")>
		<cfset varActivitys = ValueList(detalle.ActivityId)>
		<cfset salir = false>
		<cfloop index = "LoopCount" from = "1" to = "100"> 
			<cfquery datasource="#session.dsn#" name="detalle2">
				Select a.ActivityId, a.Name as nombreActiv, b.ParticipantId, c.Name, c.Description
				from WfActivity a 
				  left outer join WfActivityParticipant b
					on  a.ProcessId = b.ProcessId
					and a.ActivityId = b.ActivityId
				  left outer join WfParticipant c
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
					<cfset QueryAddRow(rsRegs,1)>
					<cfset QuerySetCell(rsRegs,"activityId",ActivityId)>
					<cfset QuerySetCell(rsRegs,"actividad",nombreActiv)>
					<cfset QuerySetCell(rsRegs,"respon",Name & '  ' & Description)>					
					<cfset QuerySetCell(rsRegs,"accion",'= Pendiente =')>
				</cfloop>
			</cfif>
			<cfif salir EQ true>
				<cfbreak>
			</cfif>
		</cfloop> 
		
		

<!--- 		<cfquery datasource="#session.dsn#" name="DataField">
			select b.Name, b.Description, b.Label, b.InitialValue, 
				   b.Prompt, b.Length, b.Datatype, xdf.Value
			from WfDataField b left join WfxDataField xdf
			  on b.DataFieldId = xdf.DataFieldId
			where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.ProcessId#">
			  and xdf.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessInstanceId#">
			order by Name
		</cfquery>SS
 --->		
		<!--- <cfquery datasource="#session.dsn#" name="DataField">
			select b.Name, b.Description, b.Label, b.InitialValue, 
				   b.Prompt, b.Length, b.Datatype
			from WfDataField b 
			where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hdr.ProcessId#">
			order by Name
		</cfquery> --->
		
		<cfif not isdefined("Url.Imprimir")>
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</cfif>
		
		<form name="form1" method="post" action="javascript:void(0)" style="margin:0; "> 
			<cfoutput>
				<table width="80%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="50%" valign="top">
							<table width="426"  border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top"><strong>Tr&aacute;mite N&uacute;mero </strong></td>
									<td valign="top">#hdr.ProcessInstanceId#</td>
								</tr>
								<tr>
									<td width="119" valign="top"><strong>Tipo Tr&aacute;mite </strong></td>
									<td width="307" valign="top">#hdr.ProcessName#<br>
									  #hdr.ProcessDescription#</td>
								</tr>
								<!--- <cfif IsDefined('requester')>
									<tr>
										<td><strong>Solicitado por </strong></td>
										<td>#requester.FullName#</td>
									</tr>
								</cfif> --->
								<tr>
									<td valign="top"><strong>Nombre</strong></td>
									<td valign="top"><strong>#hdr.ProcessInstanceDescription#</strong></td>
								</tr>					
							</table>
						</td>
						<td width="50%" valign="top">
							<cfif isdefined('url.dataitem')>
								<table width="472"  border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td colspan="4"><strong>Valores para el tr&aacute;mite </strong></td>
									</tr>
									<tr class="tituloListas">
										<td width="31">&nbsp;</td>
										<td width="179"><em>Dato</em></td>
										<td width="16">&nbsp;</td>
										<td width="246"><em>Valor</em></td>
									</tr>
									<!--- <cfloop query="DataField">
										<tr>
											<td>&nbsp;</td>
											<td>#Description#</td>
											<td>&nbsp;</td>
											<td>#Value#</td>
										</tr>
									</cfloop> --->
								</table>
							<cfelse><!-- no mostrar sin url.dataitem -->
							</cfif>
						</td>
					</tr>
					<tr>
						<td valign="top" colspan="3">&nbsp;</td>
					</tr>
				</table>
			</cfoutput>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;">&nbsp;</td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong>Actividad</strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong>Acci&oacute;n</strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong>Fecha Asignaci&oacute;n </strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong>Fecha Acci&oacute;n </strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong>Responsables</strong></td>
					<td style="border-top: 1px solid gray; border-bottom: 1px solid gray;"><strong>Aprobaci&oacute;n</strong></td>
				</tr>
			
				
				<cfoutput query="detalle" group="ActivityInstanceId">
					<cfset row_for_activity = 0>
					<cfoutput group="TransitionInstanceId">
						<cfset row_for_activity = row_for_activity + 1>
						<tr class="<cfif detalle.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>" 
							onmousemove="window.status='#detalle.ActivityInstanceId#,#detalle.TransitionInstanceId#'">
						<td valign="top">&nbsp;</td>
						<td valign="top"><cfif row_for_activity is 1>#detalle.ActivityName#</cfif></td>
						<td valign="top"><cfif Len(detalle.TransitionName)>#detalle.TransitionName#<cfelse>#detalle.State#</cfif></td>
						<td valign="top">#DateFormat(detalle.StartTime,'dd/mm/yyyy')# #TimeFormat(detalle.StartTime,'HH:mm:ss')#</td>
						<td valign="top">
							<cfif len(trim(detalle.TransitionTime))>
								#DateFormat(detalle.TransitionTime,'dd/mm/yyyy')#  #TimeFormat(detalle.TransitionTime,'HH:mm:ss')#
							<cfelse>
							 	 &nbsp;
							</cfif>
						</td>
						<td valign="top">
							 <cfif len(trim(detalle.ParticipantName)) and len(trim(detalle.ParticipantDescription))> 
								<cfoutput>#detalle.ParticipantName# #detalle.ParticipantDescription# &nbsp; <br> </cfoutput>
							<cfelse>
								&nbsp;
							</cfif> 
						</td>	
						<!--- <td valign="top"><cfoutput>#detalle.ParticipantName# #detalle.ParticipantDescription# &nbsp; <br></cfoutput></td>
						<td valign="top"><cfoutput>#detalle.Aprobadopor# &nbsp; <br></cfoutput></td>	--->						
						<td valign="top" align="center">
							<cfoutput><strong>#detalle.Aprobadopor#</strong><br></cfoutput>
						</td>
						</tr>
					</cfoutput>
				</cfoutput>
				<cfset row_for_activity2 = 0>
				<cfoutput query="rsRegs" group="ActivityId">
 					<cfset row_for_activity2 = 0>
					<cfoutput group="ActivityId">
						<cfset row_for_activity2 = row_for_activity2 + 1>
						<tr class="<cfif rsRegs.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>">
							<td valign="top">&nbsp;</td>
							<td valign="top"><cfif row_for_activity2 is 1>#actividad#<cfelse>&nbsp;</cfif></td>
							<td valign="top">#accion#</td>
							<td valign="top">&nbsp;</td>
							<td valign="top">&nbsp;</td>
							<td valign="top">
								<cfif len(trim(respon))> 
									<cfoutput>#respon# <br> </cfoutput> 
								<cfelse>
									&nbsp;
								</cfif> 
							</td>
							<td valign="top">&nbsp;</td>
						</tr>
					</cfoutput>				
				</cfoutput>
			</table>
		</form>