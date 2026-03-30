

<cfquery name="rsTramites" datasource="tramites_cr">
	select fecha_inicio, nombre_tramite, it.id_tramite, it.id_instancia, it.id_persona
	from TPInstanciaTramite it 
	left outer join TPTramite t
	  on it.id_tramite = t.id_tramite
	where id_persona = <cfif isdefined("url.id_persona") and len(trim(url.id_persona))><cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#"><cfelse><cfqueryparam cfsqltype="cf_sql_numeric" value="#session.user#"></cfif>
	  and completo = 0
</cfquery>

<table width="530" align="center"  style=" border:1px solid #595959 ">
	<tr><td bgcolor="#595959"><font size="2" color="#FFFFFF" face="Geneva, Arial, Helvetica, sans-serif"><strong>Tr&aacute;mites Pendientes</strong></font></td></tr>
	<tr>
		<td>
			<table width="515" align="center" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td align="center" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="left"><b>TRAMITE</b></div></td>
					<td align="center" bgcolor="#FFFFFF" width="100" class="bajada" id=color8 height="15" nowrap><div align="center"><b>INICIO</b></div></td>
					<td></td>
				</tr>
				
				<cfif rsTramites.recordcount gt 0>
				<cfoutput query="rsTramites">
					<tr> 
						<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left"><a style="color:##666666" href="/cfmx/bancovirtual/ventanilla/tramite.cfm?id_persona=#rsTramites.id_persona#&id_instancia=#rsTramites.id_instancia#&id_tramite=#rsTramites.id_tramite#">#rsTramites.nombre_tramite#</a></div></td>
						<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="center"><a style="color:##666666" href="/cfmx/bancovirtual/ventanilla/tramite.cfm?id_persona=#rsTramites.id_persona#&id_instancia=#rsTramites.id_instancia#&id_tramite=#rsTramites.id_tramite#">#LSDateFormat(rsTramites.fecha_inicio,'dd/mm/yyyy')#</a></div></td>
						<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="center"><a style="color:##666666" href="/cfmx/bancovirtual/ventanilla/tramite.cfm?id_persona=#rsTramites.id_persona#&id_instancia=#rsTramites.id_instancia#&id_tramite=#rsTramites.id_tramite#"><img src="../images/bullet_flecha2.gif" border="0"></a></div></td>
					</tr>
				</cfoutput>
				<cfelse>	
					<tr> 
						<td align="center" colspan="3" bgcolor="" class="bajada" height="15" id=color7><div align="left">No existen tramites pendientes</div></td>
					</tr>
				</cfif>
			</table> 
		</td>
	</tr>
</table>