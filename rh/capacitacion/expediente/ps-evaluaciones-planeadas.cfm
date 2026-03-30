<!----
<cfquery name="evaluaciones" datasource="#session.DSN#">	
	select RHEEdescripcion as relacion, RHEEfdesde as inicio, RHEEfhasta as fin
	from RHEEvaluacionDes a
	
	inner join RHListaEvalDes b
	on a.RHEEid=b.RHEEid
	and b.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> < RHEEfdesde
	and a.PCid is null
	and a.RHEEestado < 3
	order by inicio
</cfquery>
---->

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC"  style="padding:3;"><strong>Evaluaciones Planeadas</strong></td>
	</tr>

	<tr><td>
		<!--- Cursos que llevara el colaborador en el futuro --->
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td class="tituloListas">Evaluación</td>
				<td class="tituloListas">Fecha Inicio</td>
				<td class="tituloListas">Fecha Final</td>
			</tr>
			<cfset rsEvalProgramadas = expediente.evalprogramadas(form.DEid, session.Ecodigo) >
			<cfif rsEvalProgramadas.recordcount gt 0>
				<cfoutput query="rsEvalProgramadas">
					<tr class="<cfif rsEvalProgramadas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td>#rsEvalProgramadas.relacion#</td>
						<td align="left"><cf_locale name="date" value="#rsEvalProgramadas.inicio#"/></td>
						<td align="left"><cf_locale name="date" value="#rsEvalProgramadas.fin#"/></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="2" align="center">-El colaborador no tiene evaluaciones programadas-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>