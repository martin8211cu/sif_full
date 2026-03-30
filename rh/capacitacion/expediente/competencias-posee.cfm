<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC"><strong><font size="2">Competencias que posee</font></strong></td>
	</tr>

	<tr><td>
		<!--- Competencias poseidas por el colaborador asociadas al puesto--->
		<table width="100%" cellpadding="2" cellspacing="0" style="border:1px solid gray; ">
			<tr><td class="tituloCorte" colspan="2">Competencias asociadas al puesto</td></tr>
			<tr>
				<td class="listaCorte">Habilidad</td>
				<td class="listaCorte">Dominio</td>
			</tr>
			<cfif isdefined("habilidades_poseidas") and habilidades_poseidas.recordcount gt 0 >
				<cfquery name="minimo" datasource="#session.DSN#">
					select RHNnotamin 
					from RHHabilidadesPuesto 
					where Ecodigo=1 
					and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
					and RHHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#habilidades_poseidas.RHHid#">
				</cfquery>
			
				<cfoutput query="habilidades_poseidas">
					<tr>
						<td>#trim(habilidades_poseidas.RHHcodigo)# - #habilidades_poseidas.RHHdescripcion#</td>
						<td align="right">#LSNumberFormat(habilidades_poseidas.nota,',9.00')#%</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2" align="center">- No posee habilidades referentes al puesto -</td>
				</tr>
			</cfif>
			
			<tr>
				<td class="listaCorte">Conocimiento</td>
				<td class="listaCorte">Dominio</td>
			</tr>
			<cfif isdefined("conocimientos_poseidos") and conocimientos_poseidos.recordcount gt 0 >
				<cfoutput query="conocimientos_poseidos">
					<tr>
						<td>#trim(conocimientos_poseidos.RHCcodigo)# - #conocimientos_poseidos.RHCdescripcion#</td>
						<td align="right">#LSNumberFormat(conocimientos_poseidos.nota,',9.00')#%</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="2" align="center">- No posee conocimientos referentes al puesto -</td>
				</tr>
			</cfif>	

			
		</table>
	</td></tr>
</table>
