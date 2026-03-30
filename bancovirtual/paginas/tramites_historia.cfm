<cfset url.id_persona = 108440115 >
<cfquery name="rsTramites" datasource="tramites_cr">
	select fecha_inicio, nombre_tramite, it.id_tramite
	from TPInstanciaTramite it 
	left outer join TPTramite t
	  on it.id_tramite = t.id_tramite
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_persona#">
	  and completo = 1
</cfquery>

<table width="530" align="center" c style=" border:1px solid #595959 ">
	<tr><td bgcolor="#595959"><font size="2" color="#FFFFFF" face="Geneva, Arial, Helvetica, sans-serif"><strong>Tr&aacute;mites Conclu&iacute;dos</strong></font></td></tr>

	<tr>
		<td>
			<table width="515" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="right"><b>TRAMITE</b></div></td>
					<td align="center" bgcolor="#FFFFFF" width="100" class="bajada" id=color8 height="15" nowrap><div align="center"><b>INICIO</b></div></td>
				</tr>
				
				<cfif rsTramites.recordcount gt 0 >
					<cfoutput query="rsTramites">
						<tr> 
							<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left">#rsTramites.nombre_tramite#</div></td>
							<td align="center" bgcolor="<cfif rsTramites.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="center">#LSDateFormat(rsTramites.fecha_inicio,'dd/mm/yyyy')#</div></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="2" align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7><div align="left">No hay registro de tr&aacute;mites conclu&iacute;dos</div></td>
					</tr>
				</cfif>
				
<!---
				<tr> 
					<td bgcolor="#EEEEEE" class="bajada" height="15">&nbsp;&nbsp;D&oacute;lar</td>
					<td align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7><div align="center">2.8350</div></td>
					<td align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7><div align="center">2.9150</div></td>
					<td align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7>&nbsp;</td>
				</tr>
				<tr> 
					<td bgcolor="#FFFFFF" class="bajada" height="15">&nbsp;&nbsp;Euro</td>
					<td align="center" bgcolor="#FFFFFF" class="bajada" height="15" id=color7><div align="center">3.5200</div></td>
					<td align="center" bgcolor="#FFFFFF" class="bajada" height="15" id=color7><div align="center">3.6200</div></td>
					<td align="center" bgcolor="#FFFFFF" class="bajada" height="15" id=color7>&nbsp;</td>
				</tr>
--->				
			</table> 
		</td>
	</tr>
	
</table>
<!---
						<table width="500" align="center" border="0" cellpadding="0" cellspacing="0" width="171">
							<tr><td colspan="6"><img src="/cfmx/bancovirtual/images/cotizador_r1_c1.gif" width="171" height="17" border="0"></td></tr>
							<tr> 
								<td rowspan="3" bgcolor="#575757" width="2"></td>
								<td align="center" bgcolor="#FFFFFF" width="48" height="15">&nbsp;</td>
								<td align="center" bgcolor="#FFFFFF" width="54" class="bajada" id=color8 height="15"><div align="right"><b>COMPRA</b></div></td>
								<td align="center" bgcolor="#FFFFFF" width="44" class="bajada" id=color8 height="15"><div align="right"><b>VENTA</b></div></td>
								<td align="center" bgcolor="#FFFFFF" width="5" class="bajada" id=color8 height="15">&nbsp;</td>
								<td align="center" bgcolor="#575757" rowspan="3" class="bajada" id=color8 width="2"></td>
							</tr>
							
							<tr> 
								<td bgcolor="#EEEEEE" class="bajada" height="15">&nbsp;&nbsp;D&oacute;lar</td>
								<td align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7><div align="center">2.8350</div></td>
								<td align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7><div align="center">2.9150</div></td>
								<td align="center" bgcolor="#EEEEEE" class="bajada" height="15" id=color7>&nbsp;</td>
							</tr>
							
							<tr> 
								<td bgcolor="#FFFFFF" class="bajada" height="15">&nbsp;&nbsp;Euro</td>
								<td align="center" bgcolor="#FFFFFF" class="bajada" height="15" id=color7><div align="center">3.5200</div></td>
								<td align="center" bgcolor="#FFFFFF" class="bajada" height="15" id=color7><div align="center">3.6200</div></td>
								<td align="center" bgcolor="#FFFFFF" class="bajada" height="15" id=color7>&nbsp;</td>
							</tr>
							
							<tr> 
								<td valign=top colspan="6">
									<a href="#" onclick="Javascript:loadPopCoti()"><img src="/cfmx/bancovirtual/images/bottom2.gif" width="171" height="31" border="0"></a>
								</td>
							</tr>
						</table>
--->						
