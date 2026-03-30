<cfinvoke key="LB_Planes_de_Sucesion" default="Planes de Sucesión" returnvariable="LB_Planes_de_Sucesion" component="sif.Componentes.Translate" method="Translate"/>

<cf_web_portlet_start border="true" titulo="#LB_Planes_de_Sucesion#" skin="#Session.Preferences.Skin#">
	<cfquery name="rsPlan" datasource="#session.dsn#">
			select B.RHPcodigo, coalesce(ltrim(rtrim(B.RHPcodigoext)),ltrim(rtrim(B.RHPcodigo))) as RHPcodigoext,
			RHPdescpuesto 
			from RHEmpleadosPlan A, RHPuestos B
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
			and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and A.Ecodigo = B.Ecodigo
			and A.RHPcodigo  = B.RHPcodigo 		
			order by  A.RHPcodigo 
	</cfquery>
	
	<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="exp">
	
	<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
		<tr>
			<td class="listaCorte" with="80%"><cf_translate key="LB_Plan_de_Sucesion">Plan de Sucesión</cf_translate></td>
			<td class="listaCorte" align="right" width="20%"><cf_translate key="LB_Progreso">Progreso</cf_translate></td>
		</tr>
		<cfif rsPlan.recordcount gt 0>
			<cfoutput query="rsPlan">

				<cfset ps = rsPlan.RHPcodigo>
				<cfset ps_habilidades_requeridas = exp.competenciasRequeridas(ps, Session.Ecodigo, 'H')>
				<cfset ps_conocimientos_requeridos = exp.competenciasRequeridas(ps, Session.Ecodigo, 'C')>
			
				<cfset ps_total_competencias = 0 >
				<cfif ps_habilidades_requeridas.recordcount gt 0>
					<cfloop query="ps_habilidades_requeridas">
						<cfset ps_total_competencias = ps_total_competencias + ps_habilidades_requeridas.peso>
					</cfloop>
				</cfif>
				<cfif ps_conocimientos_requeridos.recordcount gt 0>
					<cfloop query="ps_conocimientos_requeridos">
						<cfset ps_total_competencias = ps_total_competencias + ps_conocimientos_requeridos.peso>
					</cfloop>
				</cfif>

				<cfquery name="ps_habilidades_obtenidas_pct" datasource="#Session.DSN#">
					select coalesce(sum(b.RHCEdominio * a.RHHpeso / 100.0), 0.0) as nota
					from RHHabilidadesPuesto a
						inner join RHCompetenciasEmpleado b
							on b.idcompetencia = a.RHHid
							and b.Ecodigo = a.Ecodigo
							and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
							and b.tipo = 'H'
							and b.RHCEfdesde >= (
												 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
												 where c.DEid = b.DEid
												   and c.Ecodigo = b.Ecodigo 
												   and c.tipo = b.tipo
												   and c.idcompetencia = b.idcompetencia
												 )
				
					where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
					  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
	
				<cfquery name="ps_conocimientos_obtenidos_pct" datasource="#Session.DSN#">
					select coalesce(sum(b.RHCEdominio * a.RHCpeso / 100.0), 0.0) as nota
					from RHConocimientosPuesto a
						inner join RHCompetenciasEmpleado b
							on b.idcompetencia = a.RHCid
							and b.Ecodigo = a.Ecodigo
							and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
							and b.tipo = 'C'
							and b.RHCEfdesde >= (
												 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
												 where c.DEid = b.DEid
												   and c.Ecodigo = b.Ecodigo 
												   and c.tipo = b.tipo
												   and c.idcompetencia = b.idcompetencia
												 )
				
					where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
					  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfset ps_total_competencias_obtenidas = ps_habilidades_obtenidas_pct.nota + ps_conocimientos_obtenidos_pct.nota>

				<!--- cálculo del avance --->
				<!---
				<cfset ps = rsPlan.RHPcodigo>
				<cfinclude template="ps-competencias-querys.cfm">
				<cfset ps_total_competencias_faltantes = 0>
				<cfset ps_total_competencias = 0 >
				<cfloop query="ps_habilidades_faltantes">
					<cfif len(trim(nota))>
						<cfset ps_total_competencias_faltantes = ps_total_competencias_faltantes + ps_habilidades_faltantes.nota>
					</cfif>
				</cfloop>
				<cfloop query="ps_conocimientos_faltantes">
					<cfif len(trim(nota))>
					<cfset ps_total_competencias_faltantes = ps_total_competencias_faltantes + ps_conocimientos_faltantes.nota>
					</cfif>
				</cfloop>
				<cfloop query="ps_habilidades_requeridas">
					<cfif len(trim(nota))>
					<cfset ps_total_competencias = ps_total_competencias + ps_habilidades_requeridas.nota >
					</cfif>
				</cfloop>
				<cfloop query="ps_conocimientos_requeridos">
					<cfif len(trim(nota))>
					<cfset ps_total_competencias = ps_total_competencias + ps_conocimientos_requeridos.nota >
					</cfif>
				</cfloop>
				<cfif ps_total_competencias gt 0 >
					<cfset falta = (100*ps_total_competencias_faltantes)/ps_total_competencias >
					<cfset tiene = 100-falta >
				<cfelse>
					<cfset falta = (100*ps_total_competencias_faltantes) >
					<cfset tiene = 0 >
				</cfif>
				--->
				<cfif ps_total_competencias gt 0 >
					<cfset tiene = (100 * ps_total_competencias_obtenidas) / ps_total_competencias>
					<cfset falta = 100 - tiene>
				<cfelse>
					<cfset tiene = (100 * ps_total_competencias_obtenidas) >
					<cfset falta = 0 >
				</cfif>
				<!--- /cálculo del avance --->			
				<tr style="cursor:pointer;" onClick="javascript:location.href='expediente.cfm?DEid=#form.DEid#&tab=6&plan=#rsPlan.RHPcodigo#';" class="<cfif rsPlan.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td with="80%">#trim(rsPlan.RHPcodigoext)#-#rsPlan.RHPdescpuesto#</td>
					<td width="20%" align="right">#NumberFormat(tiene,'9.00')# %</td>
				</tr>	
			</cfoutput>
		<cfelse>
			<tr><td align="center" colspan="2"><cf_translate key="LB_El_empleado_no_tiene_planes_de_sucesion">El empleado no tiene planes de sucesión</cf_translate> </td></tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
 <cf_web_portlet_end>
 
 
 
