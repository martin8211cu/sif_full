<cfquery name="rsAyuda" datasource="#session.DSN#">
	select 
		ASE.Usulogin as UsuarioAsesor,FechaModAsesor,
		CF.Usulogin  as UsuarioJefeCF,FechaModJefeCF,   
		JF.Usulogin  as UsuarioJefeAsesor,FechaModJefeAsesor,
		RHPcodigo
	from RHDescripPuestoP
	left outer join Usuario ASE
		on UsuarioAsesor = ASE.Usucodigo
	left outer join Usuario CF
		on UsuarioJefeCF = CF.Usucodigo
	left outer join Usuario JF
		on UsuarioJefeAsesor = JF.Usucodigo
	where RHDPPid = <cfqueryparam value="#form.RHDPPid#" cfsqltype="cf_sql_numeric">
	and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset Puesto = rsAyuda.RHPcodigo>



<cfquery name="RSJEFEASESOR" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as CFID  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 700				
</cfquery>

<cfset EL_PUESTO_ES_DEL_JEFEASESOR = true>
<cfif RSJEFEASESOR.recordCount GT 0>
	<cfquery name="RSCFPUESTO" datasource="#session.DSN#">
		select coalesce (CFid ,-1) as CFid   from RHPuestos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and RHPcodigo = '#Puesto#'
	</cfquery>
	<cfif RSJEFEASESOR.CFID eq RSCFPUESTO.CFID>
		<cfset EL_PUESTO_ES_DEL_JEFEASESOR = true>
	<cfelse>
		<cfset EL_PUESTO_ES_DEL_JEFEASESOR = false>
	</cfif>	
<cfelse>
	<cfset EL_PUESTO_ES_DEL_JEFEASESOR = false>
</cfif>					






<!--- <cfdump var="#data#"> --->
<table width="100%" border="0">
  <tr>
    <td><fieldset>
		<table width="100%" border="0">
			<cfif form.USUARIO eq 'ASESOR' OR  form.USUARIO eq 'ASESORM'>
				
				
				
				<cfif isdefined("rsAyuda.UsuarioAsesor") and len(trim(rsAyuda.UsuarioAsesor))>
					<tr>
						<td><li><cf_translate key="LB_Asesor" >Asesor :</cf_translate></td>
						<td><strong><cfoutput>#rsAyuda.UsuarioAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;<cf_translate key="LB_UltimaModificacion" >&Uacute;ltima modificaci&oacute;n:</cf_translate></td>
						<td><strong><cfoutput>#LSDateFormat(rsAyuda.FechaModAsesor, "dd/mm/yyyy")#</cfoutput></strong></li></td>
					</tr>
				</cfif>
				<cfif isdefined("rsAyuda.UsuarioJefeCF") and len(trim(rsAyuda.UsuarioJefeCF))>
					<tr>
						<td nowrap><li><cf_translate key="LB_JefeCentroFuncional" >Jefe Centro Funcional :</cf_translate></td>
						<td><strong><cfoutput>#rsAyuda.UsuarioJefeCF#</cfoutput></strong></td>
						<td nowrap>&nbsp;<cf_translate key="LB_UltimaModificacion" >&Uacute;ltima modificaci&oacute;n:</cf_translate></td>
						<td><strong><cfoutput>#LSDateFormat(rsAyuda.FechaModJefeCF, "dd/mm/yyyy")#</cfoutput></strong></li></td>
					</tr>
				</cfif>
				<cfif isdefined("rsAyuda.UsuarioJefeAsesor") and len(trim(rsAyuda.UsuarioJefeAsesor))>
					<tr>
						<td><li><cf_translate key="LB_JefeAsesor" >Jefe Asesor :</cf_translate></td>
						<td><strong><cfoutput>#rsAyuda.UsuarioJefeAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;<cf_translate key="LB_UltimaModificacion" >&Uacute;ltima modificaci&oacute;n:</cf_translate></td>
						<td><strong><cfoutput>#LSDateFormat(rsAyuda.FechaModJefeAsesor, "dd/mm/yyyy")#</cfoutput></strong></li></td>
					</tr>
				</cfif>
				<cfif isdefined("data.CFid") and len(trim(data.CFid)) and data.CFid eq -1>
					<tr>
						<td colspan="4"><li><font style="color:#FF0000"><cf_translate key="LB_El_Puesto_no_tiene_centro_funcional_asignado" >El puesto no tiene centro funcional asignado</cf_translate></font></li></td>
					</tr>
					<tr>
						<td colspan="4"><li><cf_translate key="LB_El_ciclo_de_aprobacion_normal_requiere_un_centro_funcional_asociado_al_puesto" >El ciclo de aprobaci&oacute;n normal, requiere un centro funcional asociado al puesto</cf_translate></li></td>
					</tr>
				</cfif>
				<cfif EL_PUESTO_ES_DEL_JEFEASESOR>
					<tr>
						<td colspan="4"><li><font <!--- style="color:#FF0000" --->><cf_translate key="LB_Cuando_el_puesto_pertenece_al_centro_funcional_del_jefe_asesor_aparece_solamente_el_boton_del_aprobacion_no_relevante" >Cuando el puesto pertenece al centro funcional del jefe asesor aparece solamente el bot&oacute;n del aprobaci&oacute;n no relevante.</cf_translate></font></li></td>
					</tr>				
				</cfif>

			<cfelseif form.USUARIO eq 'ASESORSP'>
				<cfquery name="rsAsesor" datasource="#session.DSN#">
					select 
						CF.Usulogin  as UsuarioJefeAsesor, <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> as FechaModJefeAsesor  
					from Usuario CF
						where  CF.Usucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfif isdefined("rsAsesor.UsuarioJefeAsesor") and len(trim(rsAsesor.UsuarioJefeAsesor))>
					<tr>
						<td nowrap><li><cf_translate key="LB_Modificado_directamente_por_el_jefe_asesor" >Modificado directamente por el jefe asesor :</cf_translate></td>
						<td><strong><cfoutput>#rsAsesor.UsuarioJefeAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</cfif>			
			
				
			<cfelseif form.USUARIO eq 'JEFECF' or  USUARIO eq 'JEFECFNM'>
				<cfif isdefined("rsAyuda.UsuarioAsesor") and len(trim(rsAyuda.UsuarioAsesor))>
					<tr>
						<td><li><cf_translate key="LB_Asesor" >Asesor :</cf_translate></td>
						<td><strong><cfoutput>#rsAyuda.UsuarioAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;<cf_translate key="LB_UltimaModificacion" >&Uacute;ltima modificaci&oacute;n:</cf_translate></td>
						<td><strong><cfoutput>#LSDateFormat(rsAyuda.FechaModAsesor, "dd/mm/yyyy")#</cfoutput></strong></li></td>
					</tr>
				</cfif>

				<cfquery name="rsjefeCF" datasource="#session.DSN#">
					select 
						CF.Usulogin  as UsuarioJefeCF, <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> as FechaModJefeCF  
					from Usuario CF
						where  CF.Usucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
				
				<cfif isdefined("rsjefeCF.UsuarioJefeCF") and len(trim(rsjefeCF.UsuarioJefeCF))>
					<tr>
						<td nowrap><li><cf_translate key="LB_JefeCentroFuncional" >Jefe Centro Funcional :</cf_translate></td>
						<td><strong><cfoutput>#rsjefeCF.UsuarioJefeCF#</cfoutput></strong></td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</cfif>
			<cfelseif form.USUARIO eq 'JEFEASESOR'>
				<cfif isdefined("rsAyuda.UsuarioAsesor") and len(trim(rsAyuda.UsuarioAsesor))>
					<tr>
						<td><li><cf_translate key="LB_Asesor" >Asesor :</cf_translate></td>
						<td><strong><cfoutput>#rsAyuda.UsuarioAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;<cf_translate key="LB_UltimaModificacion" >&Uacute;ltima modificaci&oacute;n:</cf_translate></td>
						<td><strong><cfoutput>#LSDateFormat(rsAyuda.FechaModAsesor, "dd/mm/yyyy")#</cfoutput></strong></li></td>
					</tr>
				</cfif>
				
				
				<cfif isdefined("rsAyuda.UsuarioJefeCF") and len(trim(rsAyuda.UsuarioJefeCF))>
					<tr>
						<td nowrap><li><cf_translate key="LB_JefeCentroFuncional" >Jefe Centro Funcional :</cf_translate></td>
						<td><strong><cfoutput>#rsAyuda.UsuarioJefeCF#</cfoutput></strong></td>
						<td nowrap>&nbsp;<cf_translate key="LB_UltimaModificacion" >&Uacute;ltima modificaci&oacute;n:</cf_translate></td>
						<td><strong><cfoutput>#LSDateFormat(rsAyuda.FechaModJefeCF, "dd/mm/yyyy")#</cfoutput></strong></li></td>
					</tr>
				</cfif>
				
				<cfquery name="rsAsesor" datasource="#session.DSN#">
					select 
						CF.Usulogin  as UsuarioJefeAsesor, <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> as FechaModJefeAsesor  
					from Usuario CF
						where  CF.Usucodigo = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfif EL_PUESTO_ES_DEL_JEFEASESOR>
					<tr>
						<td nowrap><li><cf_translate key="LB_JefeCentroFuncional" >Jefe Centro Funcional :</cf_translate></td>
						<td><strong><cfoutput>#rsAsesor.UsuarioJefeAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</cfif>				
				<cfif isdefined("rsAsesor.UsuarioJefeAsesor") and len(trim(rsAsesor.UsuarioJefeAsesor))>
					<tr>
						<td nowrap><li><cf_translate key="LB_JefeAsesor" >Jefe Asesor :</cf_translate></td>
						<td><strong><cfoutput>#rsAsesor.UsuarioJefeAsesor#</cfoutput></strong></td>
						<td nowrap>&nbsp;</td>
						<td nowrap>&nbsp;</td>
					</tr>
				</cfif>
				<cfif isdefined("data.CFid") and len(trim(data.CFid)) and data.CFid eq -1>

					<tr>
						<td colspan="4"><li><font style="color:#FF0000"><cf_translate key="LB_El_Puesto_no_tiene_centro_funcional_asignado" >El puesto no tiene centro funcional asignado</cf_translate></font></li></td>
					</tr>
					<tr>
						<td colspan="4"><li><cf_translate key="LB_El_ciclo_de_aprobacion_normal_requiere_un_centro_funcional_asociado_al_puesto" >El ciclo de aprobaci&oacute;n normal, requiere un centro funcional asociado al puesto</cf_translate></li></td>
					</tr>
				</cfif> 
			</cfif>	
			<cfif not isdefined("RSJEFEASESOR") or (isdefined("RSJEFEASESOR") and len(trim(RSJEFEASESOR.CFID)) eq 0)>
				<tr>
					<td colspan="4"><li><font style="color:#FF0000"><cf_translate key="LB_No_se_ha_definido_el_jefe_asesor" >No se ha definido el jefe asesor</cf_translate></font></li></td>
				</tr>
			</cfif>			
		</table>
		</fieldset>
  </tr>
</table>
