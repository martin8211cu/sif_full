<cfquery name="cursosllevando" datasource="#session.DSN#">
	select 	c.RHCcodigo, 
			i.RHIAnombre as institucion, 
			c.RHCfdesde as inicio,
			c.RHCfhasta as fin,
			c.RHCnombre as Mnombre
		   
	from RHEmpleadoCurso ec
	
	inner join RHCursos c
	on ec.Ecodigo=c.Ecodigo
	and ec.RHCid=c.RHCid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCfdesde and RHCfhasta
	
	inner join RHOfertaAcademica oa
	on c.Ecodigo=oa.Ecodigo
	and c.RHIAid=oa.RHIAid
	and c.Mcodigo=oa.Mcodigo
	
	inner join RHInstitucionesA i
	on oa.Ecodigo=i.Ecodigo
	and oa.RHIAid=i.RHIAid
	
	where ec.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ec.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	and ec.RHEMestado=0
	order by inicio, RHCcodigo
</cfquery>

<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center" bgcolor="#CCCCCC" style="padding:3; " ><strong><cf_translate key="LB_Cursando_actualmente">Cursando actualmente</cf_translate></strong></td>
	</tr>

	<tr><td>
		<!--- Cursos que llevara el colaborador en el futuro --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td class="tituloListas"><cf_translate key="LB_Curso">Curso</cf_translate></td>
				<td class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
				<td class="listaCorte"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
				<td class="tituloListas"><cf_translate key="LB_Institucion">Instituci&oacute;n</cf_translate></td>
			</tr>
			<cfif cursosllevando.recordcount gt 0>
				<cfoutput query="cursosllevando">
					<tr class="<cfif cursosllevando.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td>#trim(cursosllevando.RHCcodigo)# - #cursosllevando.Mnombre#</td>
						<td align="left"><cf_locale name="date" value="#cursosllevando.inicio#"/></td>
						<td align="left"><cf_locale name="date" value="#cursosllevando.fin#"/></td>
						<td align="left">#cursosllevando.institucion#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="2" align="center">-<cf_translate key="LB_El_colaborador_no_tiene_cursos_programados">El colaborador no tiene cursos programados</cf_translate>-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>