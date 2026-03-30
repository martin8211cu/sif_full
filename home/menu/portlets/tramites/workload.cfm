<cfinvoke component="sif.Componentes.Workflow.Management" method="getWorkload" returnvariable="workload">
	<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
</cfinvoke>
<cfset CurrentPageForURL = JSStringFormat(URLEncodedFormat(Replace(GetFileFromPath(CGI.SCRIPT_NAME),'.cfm','')))>
<cfif workload.RecordCount GT 0>
	<table width="<cfif isdefined("portlets.w_portlet")><cfoutput>#portlets.w_portlet-12#px</cfoutput>631px</cfif>" align="center" border="1" cellspacing="1" cellpadding="1">
		<cfoutput>
			<tr class="tituloListas">
				<td width="1%"><strong>N&uacute;m/Asignado</strong></td>
				<td width="100%"><strong>Nombre</strong></td>
				<td width="1%">&nbsp;</td>
				<td width="1%">&nbsp;</td>
			</tr>
		</cfoutput>
		<cfoutput query="workload" group="ActivityInstanceId">
			<!--- Esto es para guardar el id de la actividad y en cual línea está --->
			<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
				onMouseMove="style.backgroundColor='##E4E8F3';" 
				onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
		
				<td nowrap valign="top" onClick="location.href='/cfmx/sif/tr/consultas/aprobacion.cfm'" style="cursor:pointer;">
					#workload.ProcessInstanceId#<br>
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
				<td valign="top" onClick="location.href='/cfmx/sif/tr/consultas/aprobacion.cfm'" style="cursor:pointer;">
					#workload.ProcessInstanceDescription#<br>
					#workload.ActivityDescription#
				</td>
				
				<td valign="top">
					<a href="/cfmx/sif/tr/consultas/aprobacion-detalle.cfm?from=#CurrentPageForURL#&amp;ProcessInstanceId=#workload.ProcessInstanceId#&amp;ActivityInstanceId=#workload.ActivityInstanceId#">
					<img src="portlets/tramites/hojas.gif" border="0"
						alt="Seguimiento" width="17" height="28"
						title="Mostrar seguimiento del tr&aacute;mite"></a>
				</td>
				<td valign="top">
					<a href="/cfmx/sif/tr/consultas/aprobacion-showlink.cfm?from=#CurrentPageForURL#&amp;ProcessInstanceId=#workload.ProcessInstanceId#&amp;ActivityInstanceId=#workload.ActivityInstanceId#">
					<img src="portlets/tramites/detalle.gif"
						alt="Detalle" width="17" height="28"
						title="Mostrar detalle de la operaci&oacute;n" border="0"></a>
				</td>
			</tr>
		</cfoutput>
		<cfoutput>
		</cfoutput>  
	</table> 
<cfelse>
	<cf_translate key="no_hay_tramites_pendientes" xmlFile="/home/menu/general.xml">No hay tr&aacute;mites pendientes</cf_translate>
</cfif>