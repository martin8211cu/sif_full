<cfquery name="rsPersonas" datasource="tramites_cr">
	select pr.id_persona_relacionada, pr.relacion, p.nombre, p.apellido1, p.apellido2, p.identificacion_persona
	from PersonasRelacionadas pr
	inner join TPPersona p
	on p.id_persona=pr.id_persona_relacionada
	where pr.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.user#">
</cfquery>

<table width="530" align="center"  style=" border:1px solid #595959 ">
	<tr><td bgcolor="#595959"><font size="2" color="#FFFFFF" face="Geneva, Arial, Helvetica, sans-serif"><strong>Personas a las que puedo tramitar</strong></font></td></tr>
	<tr>
		<td>
			<table width="515" align="center" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="right"><b>IDENTIFICACION</b></div></td>
					<td align="left" bgcolor="#FFFFFF" width="60" class="bajada" id=color8 height="15"><div align="right"><b>PERSONA</b></div></td>
				</tr>
				
				<cfoutput query="rsPersonas">
					<tr> 
						<td width="1%" nowrap align="center" bgcolor="<cfif rsPersonas.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left"><a style="color:##666666" href="tramites-autorizados.cfm?id_persona=#rsPersonas.id_persona_relacionada#">#rsPersonas.identificacion_persona#</a></div></td>
						<td  align="center" bgcolor="<cfif rsPersonas.currentrow mod 2>##EEEEEE<cfelse>##FFFFFF</cfif>" class="bajada" height="15" id=color7><div align="left"><a style="color:##666666" href="tramites-autorizados.cfm?id_persona=#rsPersonas.id_persona_relacionada#">#rsPersonas.nombre# #rsPersonas.apellido1# #rsPersonas.apellido2#</a></div></td>
					</tr>
				</cfoutput>
			</table> 
		</td>
	</tr>
</table>