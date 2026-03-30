<cfparam name="request.lista_actividades_superuser" type="boolean" default="false">
<cfparam name="workload" type="query">
<cfoutput>
    <cfquery name="workload" dbtype="query">
			select * 
			  from workload
			 where 1=1             
				and ( UPPER(workload.ProcessDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('recursos humanos')#%">
				   OR UPPER(workload.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('recursos humanos')#%"> OR
                   UPPER(workload.ProcessDescription) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('RH')#%">
				   OR UPPER(workload.Edescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase('RH')#%">
					)
	</cfquery>
</cfoutput>
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
					
<!---averiguo que botones voy a usar--->
 <cfset botonstart = false>
 <cfset botonfinish = false>
 <cfset botonaprobar = false>
 <cfset botonrechazar = false>
 <cfset botonotros = false>
<cfloop query="workload">
	<!--- No muestra los tramites q esten asociados a una SC con un NRP --->
    <cfquery name="rsExisteNRP" datasource="#session.dsn#">
        select count(1) as cantidad from ESolicitudCompraCM where NRP is not null and ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#workload.ProcessInstanceId#">
    </cfquery>
    <cfif rsExisteNRP.cantidad eq 0>
		<cfif soy_responsable or request.lista_actividades_superuser>
            <cfif workload.State EQ "INACTIVE" or State EQ "SUSPENDED">
                <cfset botonstart= true>
            <cfelseif workload.State EQ "ACTIVE">
                <cfset botonfinish= true>
            <cfelseif workload.State EQ "COMPLETED">
                <cfinvoke component="sif.Componentes.Workflow.Management" 
                          method="getAllowedTransitions" 
                          returnvariable="rsTrans">
                    <cfinvokeargument name="ActivityInstanceId" value="#workload.ActivityInstanceId#">
                </cfinvoke>
                <cfset workload_ProcessInstanceId = workload.ProcessInstanceId>
                <cfset workload_ActivityInstanceId = workload.ActivityInstanceId>
                <cfloop query="rsTrans">
                    <cfif findNoCase("ACEPTA",name) OR findNoCase("APROB",name) OR findNoCase("APRUEB",name) OR findNoCase("APLICA",name) OR findNoCase("AUTORI",name)
                       OR findNoCase("RATIFIC",name) OR findNoCase("CONCEN",name) OR findNoCase("POSITIV",name) OR findNoCase("CONFIRM",name)
                       OR name EQ "OK" OR findNoCase("ACCEPT",name) OR findNoCase("APPROV",name) OR findNoCase("AGREE",name)  OR findNoCase("PASS",name)>
                         <cfset botonaprobar = true>
                    <cfelseif findNoCase("RECHAZ",Name) OR findNoCase("CANCEL",name) OR findNoCase("ANULA",name) OR findNoCase("CLOSE",name)
                       OR findNoCase("STOP",name)  OR findNoCase("DISALLOW",name) OR findNoCase("REJECT",name) >
                         <cfset botonrechazar = true>
                    <cfelseif TRIM(Ucase(Name)) eq 'APROBACIONJEFE'>
                        <cfset botonaprobar = true>
                    <cfelseif	TRIM(Ucase(Name)) eq 'RECHAZOJEFE'>
                       <cfset botonrechazar = true>
                    <cfelse>
                        <cfset botonotros = true>
                    </cfif>	  
                </cfloop>
            </cfif>
       </cfif>
	</cfif>
</cfloop>
<form name="form1" method="post" action="<cfoutput>#CGI.SCRIPT_NAME#</cfoutput>"> 
	<table border="0" cellspacing="0" cellpadding="3" width="100%">
    	<tr>
        <td colspan="8">
		<cfoutput>
            <table border="0" cellspacing="0" cellpadding="0" align="center" width="100%" class="areaFiltro">
                <tr>
                    <td width="80"><strong><font style="font-size:10px"><cf_translate key="LB_Numero">N&uacute;mero</cf_translate></font></strong></td>
                    <td width="80"><strong><font style="font-size:10px"><cf_translate key="LB_TipoTramite">Tr&aacute;mite</cf_translate></font></strong></td>
                    <td width="80"><strong><font style="font-size:10px"><cf_translate key="LB_Asignado">Asignado</cf_translate></font></strong></td>
                    <td width="80">&nbsp;</td>
                    <td width="90">&nbsp;</td>
                </tr>
                <tr>
                    <td>
                        <cfparam name="form.F_numero" default="">
                        <input type="text" name="F_numero"	id="F_numero"	value="#form.F_numero#"	style="font-size:10px; width:40px;">
                    </td>
                    <td>
                        <cfparam name="form.F_tipo" default="">
                        <input type="text" name="F_tipo"	id="F_tipo"	value="#form.F_tipo#"	style="font-size:10px; width:200px;">
                    </td>
                    <td>
                        <cfparam name="form.F_asignado" default="">
                        <cf_sifcalendario name="F_asignado" value="#form.F_asignado#"	style="font-size:10px;width:100px;">
                    </td>
                    <td align="left">
                        <input type="submit" name="btnFiltrar" value="Filtrar" class="btnFiltrar">
                    </td>
                    <td >&nbsp;</td>
                </tr>
            </table>
		</cfoutput>
        </td>
		</tr>
			<tr class="tituloListas">
				<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Numero">N&uacute;mero</cf_translate></font></strong></td>
				<td width="100"><strong><font style="font-size:10px"><cf_translate key="LB_TipoTramite">Tr&aacute;mite</cf_translate></font></strong></td>
				<td width="200"><strong><font style="font-size:10px"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></font></strong></td>
				<td width="50"><strong><font style="font-size:10px"><cf_translate key="LB_Asignado">Asignado</cf_translate></font></strong></td>
				<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Detalle">Detalle</cf_translate></font></strong></td>
                <td width="50"><strong><font style="font-size:10px"><cf_translate key="LB_Seguimiento">Seguimiento</cf_translate></font></strong></td>
                <cfif botonstart>
                	<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Iniciar">Iniciar</cf_translate></font></strong></td>
                </cfif>
                <cfif botonfinish>
                	<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Iniciar">Completar</cf_translate></font></strong></td>
                </cfif>
                <cfif botonaprobar>
                	<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Aceptar">Aceptar</cf_translate></font></strong></td>
                </cfif>
                <cfif botonrechazar>
                	<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Rechazar">Rechazar</cf_translate></font></strong></td>
                </cfif>
                <cfif botonotros>
                	<td width="40"><strong><font style="font-size:10px"><cf_translate key="LB_Rechazar">Otros</cf_translate></font></strong></td>
                </cfif>
			</tr>
		<cfif form.F_numero NEQ "" OR form.F_tipo NEQ "" OR form.F_asignado NEQ "">
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
				<cfif form.F_asignado NEQ "">
					and workload.StartTime between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.F_asignado)#">
											   and <cfqueryparam cfsqltype="cf_sql_date" value="#dateAdd('d',1,LSParseDateTime(form.F_asignado))#">
				</cfif>
			</cfquery>

		</cfif>
		<cfflush interval="64">
		<cfoutput query="workload" group="ActivityInstanceId">
        	<!--- No muestra los tramites q esten asociados a una SC con un NRP --->
        	<cfquery name="rsExisteNRP" datasource="#session.dsn#">
            	select count(1) as cantidad from ESolicitudCompraCM where NRP is not null and ProcessInstanceid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#workload.ProcessInstanceId#">
            </cfquery>
            <cfif rsExisteNRP.cantidad eq 0>
			<!--- Esto es para guardar el id de la actividad y en cual línea está --->
			<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
				onMouseMove="style.backgroundColor='##E4E8F3';" 
				onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		
				<td nowrap valign="top" align="left" ><font style="font-size:10px">#workload.ProcessInstanceId#</font></td>
				<td nowrap valign="top" align="left" ><font style="font-size:10px">#workload.ProcessDescription#
					<cfif workload.Ecodigo neq session.Ecodigo or true> <br> #workload.Edescripcion#</cfif></font>
				</td>
				<td valign="top" align="left" >
					<font style="font-size:10px">
					#workload.ProcessInstanceDescription#<br>
					#workload.ActivityDescription#
					</font>
				</td>
				<td nowrap valign="top" align="left" >
					<font style="font-size:10px">
					#LSDateFormat(workload.StartTime,'dd/mm/yyyy')# #LSTimeFormat(workload.StartTime, 'hh:mmtt')#
					</font>
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
                   
                          
                    <cfquery datasource="#session.dsn#" name="hdr">
                        select xp.ProcessInstanceId, p.ProcessId, p.DetailURL
                        from WfxProcess xp
                            join WfProcess p
                                on p.ProcessId = xp.ProcessId
                        where xp.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#workload.ProcessInstanceId#">
                    </cfquery>    
                                  
				<td valign="top">
					
					<a href="##" tabindex="-1">
					<img src="/cfmx/sif/imagenes/Page_Load.gif" 
						title="#BTN_Detalle#" 
						name="imagen" 
						border="0" 
						align="absmiddle" 
						onClick='javascript: detalle(#hdr.ProcessInstanceId#,#hdr.ProcessId#);'>	
					</a>	   
				</td>
						
				
				<td valign="top">
                
					<a href="##" tabindex="-1">
					<img src="/cfmx/sif/imagenes/next_year.gif"
						title="#BTN_Seguimiento#" 
						name="imagen" 
						border="0" 
						align="absmiddle" 
						onClick='javascript: seguimiento(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#);'>	
					</a>	
						   
				</td>
				
					<cfif soy_responsable or request.lista_actividades_superuser>
						<!--- Botones de Acciones a ejecutar para las actividades del responsable --->			&nbsp;
						<cfif workload.State EQ "INACTIVE" or State EQ "SUSPENDED">
							<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Iniciar"
									Default="Iniciar"
									returnvariable="BTN_Iniciar"/>
						<td valign="top">
							<a href="##" tabindex="-1">
							<img src="/cfmx/sif/imagenes/stop2.gif" 
								title="#BTN_Iniciar#" 
								name="imagen" 
								border="0" 
								align="absmiddle" 
								onClick='javascript: set_state(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#,"start");'>	
							</a>	&nbsp;						
							
						</td>
						 <cfif botonfinish>
                         	<td></td>
                         </cfif>
                         <cfif botonaprobar>
                         	<td></td>
                         </cfif>
                         <cfif botonrechazar>
                         	<td></td>
                         </cfif>
                         <cfif botonotros>
                         	<td></td>
                         </cfif>
                         
						<cfelseif workload.State EQ "ACTIVE">
							<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Completar"
									Default="Completar"
									returnvariable="BTN_Completar"/>	
						<td valign="top">	
							<a href="##" tabindex="-1">
							<img src="/cfmx/sif/imagenes/stop.gif" 
								title="#BTN_Completar#" 
								name="imagen" 
								border="0" 
								align="absmiddle" 
								onClick='javascript: set_state(#workload.ProcessInstanceId#,#workload.ActivityInstanceId#,"finish");'>	
							</a>	&nbsp;	
							
						<td>	
                         <cfif botonstart>
                         	<td></td>
                         </cfif>
                         <cfif botonaprobar>
                         	<td></td>
                         </cfif>
                         <cfif botonrechazar>
                         	<td></td>
                         </cfif>
                         <cfif botonotros>
                         	<td></td>
                         </cfif>			
						<cfelseif workload.State EQ "COMPLETED">
							 <cfif botonstart>
                                <td></td>
                             </cfif>
                            <cfif botonfinish>
                                <td></td>
                             </cfif>
							<cfinvoke component="sif.Componentes.Workflow.Management" 
									  method="getAllowedTransitions" 
									  returnvariable="rsTrans">
								<cfinvokeargument name="ActivityInstanceId" value="#workload.ActivityInstanceId#">
							</cfinvoke>
							<cfset workload_ProcessInstanceId = workload.ProcessInstanceId>
							<cfset workload_ActivityInstanceId = workload.ActivityInstanceId>
							<cfloop query="rsTrans">
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
							<cfelseif TRIM(Ucase(Name)) eq 'APROBACIONJEFE'>
								<cfset imagen ="/cfmx/proyecto7/imagenes/aprobar.png">	
							<cfelseif	TRIM(Ucase(Name)) eq 'RECHAZOJEFE'>
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

							<td valign="top">
                            <a href="##" tabindex="-1">
							<img src="#imagen#"  title="#Ucase(Name)#" title="#Ucase(Name)#"  name="imagen" border="0" align="absmiddle" 
							 onClick='javascript: if (confirm("#MSG_Actual# #workload.ActivityDescription#\n\n#MSG_Accion#:\t#Ucase(Name)#\n#MSG_Enviar#:\t#toName#<cfif toName NEQ toDescription> - #toDescription#</cfif>")) do_transition(#workload_ProcessInstanceId#,#workload_ActivityInstanceId#,#rsTrans.TransitionId#); else return false;'>
                            </a>
                            </td>
							</cfloop>
						</cfif>
					</cfif>
			</tr>
           	</cfif>
		</cfoutput>
		<cfoutput>
			<cfif  not workload.RecordCount GT 0>
				<tr>
				  <td colspan="8" align="center">
	                  -----------------<cf_translate key="MSG_NoHayTramitesPorAprobar">NO HAY TR&Aacute;MITES POR APROBAR</cf_translate>----------------
                  </td>
				</tr>
			</cfif>
		</cfoutput>  
	</table>
</form>
    
<cf_Lightbox link="" Titulo="Detalle de la Compra" width="90" height="90" name="DetaSolicitudCom" url="detalleTramiteSolicitud.cfm"></cf_Lightbox>
<cf_Lightbox link="" Titulo="Ver Seguimiento" width="90" height="90" name="Seguimiento" url="/cfmx/proyecto7/justifiRechazo.cfm"></cf_Lightbox>
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
			document.form1.action= '/cfmx/proyecto7/aprobacion-apply.cfm?from=#CurrentPageForURL#&ProcessInstanceId=' + escape (ProcessInstanceId) + '&ActivityInstanceId=' + escape (ActivityInstanceId) +'&TransitionId=' + escape (TransitionId);
		     document.form1.submit();
<!---			location.href = 'aprobacion-apply.cfm?from=#CurrentPageForURL#&ProcessInstanceId=' + escape (ProcessInstanceId) +
				'&ActivityInstanceId=' + escape (ActivityInstanceId) +
				'&TransitionId=' + escape (TransitionId);--->
		}
	
		function seguimiento(ProcessInstanceId, ActivityInstanceId) {
			fnLightBoxSetURL_Seguimiento("#LvarAprobacionDetalle#?from=#CurrentPageForURL#&ProcessInstanceId="+ProcessInstanceId+"&ActivityInstanceId="+ActivityInstanceId);
			fnLightBoxOpen_Seguimiento();
		}
	
		function detalle(ProcessInstanceId,ActivityInstanceId) {
				fnLightBoxSetURL_DetaSolicitudCom("detalleTramiteSolicitudRH.cfm?ActivityInstanceId="+ActivityInstanceId+"&ProcessInstanceId=" +ProcessInstanceId);
				fnLightBoxOpen_DetaSolicitudCom();
		}
	</script>
</cfoutput>
