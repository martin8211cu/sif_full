<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid >
</cfif>
<cfif isdefined("url.plansucesion") and not isdefined("form.plansucesion")>
	<cfset form.plansucesion = url.plansucesion >
</cfif>

<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center" class="tituloListas"><strong>#session.Enombre#</strong></td></tr>
	<!--- <tr><td>&nbsp;</td></tr> --->
	<tr><td align="center"  class="tituloListas"><strong><cf_translate key="LB_CompetenciasPorColaborador">Competencias por Colaborador</cf_translate></strong></td></tr>
</table>

<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="data">
<cfset puesto = data.puestoEmpleado(form.DEid, session.Ecodigo)>
<!--- Nombre del Empleado--->
<cfquery name="empleado" datasource="#session.DSN#">
	select DEidentificacion, DEnombre, DEapellido1, DEapellido2
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<!--- Empleado, Puesto --->
<br>
<table width="99%" align="center" cellpadding="2" cellspacing="0" >
	<tr>
		<td width="1%" nowrap><font size="2"><strong><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>:&nbsp;</strong></font></td>
		<td><font size="2"><strong>#trim(empleado.DEidentificacion)# - #trim(empleado.DEnombre)# #trim(empleado.DEapellido1)# #trim(empleado.DEapellido2)#</strong></font></td>
	</tr>
	<tr>
		<td width="1%" nowrap><font size="2"><strong><cf_translate key="LB_Puesto" XmlFile="/rh/generales.xml">Puesto</cf_translate>:&nbsp;</strong></font></td>
		<td><font size="2"><strong>#trim(puesto.RHPcodigoext)# - #trim(puesto.RHPdescpuesto)#</strong></font></td>
	</tr>
</table>

<!--- Datos --->
<!--- habilidades requeridas--->
<cfset habilidades_requeridas = data.competenciasRequeridas(puesto.RHPcodigo, session.Ecodigo, 'h')>
<cfset habilidades_puesto = valuelist(habilidades_requeridas.RHHid) >
<cfset conocimientos_requeridos = data.competenciasRequeridas(puesto.RHPcodigo, session.Ecodigo, 'c')>
<cfset conocimientos_puesto = valuelist(conocimientos_requeridos.RHCid) >
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr><td>
		<!--- Competencias requeridas por el puesto --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr><td colspan="4" style="padding:3px" bgcolor="##E3EDEF" ><strong><font size="2"><cf_translate key="LB_CompetenciasRequeridasPorElPuesto">Competencias Requeridas por el puesto</cf_translate></font></strong></td></tr>
			<tr>
				<td class="listaCorte"><cf_translate key="LB_Habilidades">Habilidades</cf_translate></td>
				<td class="listaCorte" align="right"><cf_translate key="LB_Dominio">Dominio</cf_translate></td>
				<td class="listaCorte" align="center" nowrap><cf_translate key="LB_FechaUltimaRevision">Fecha &uacute;ltima revisi&oacute;n</cf_translate></td>
				<td class="listaCorte" align="left" nowrap><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate></td>
			</tr>
			<cfset total_competencias = 0 >
			<cfset total_competencias_tiene = 0 >
			<cfif habilidades_requeridas.recordcount gt 0>
				<cfloop query="habilidades_requeridas">
					<cfquery name="data_posee" datasource="#session.DSN#">
						select a.RHCEdominio as nota, a.RHCEfdesde as revision, a.RHCEjustificacion as justificacion
						from RHCompetenciasEmpleado a
						
						inner join RHHabilidadesPuesto b
						on a.Ecodigo=b.Ecodigo
						and a.idcompetencia=b.RHHid
						and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
						
						where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and tipo= 'H'
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
						and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#habilidades_requeridas.RHHid#">
					</cfquery>
					<cfset posee = data_posee.nota >
					<cfif len(trim(posee)) eq 0><cfset posee = 0 ></cfif>
				
					<tr class="<cfif habilidades_requeridas.currentrow mod 2>listaNon<cfelse>listaPar</cfif> ">
						<td width="40%">#trim(habilidades_requeridas.RHHcodigo)# - #habilidades_requeridas.RHHdescripcion#</td>
						<td align="right" width="10%">#LSNumberFormat(posee,',9.00')#%</td>
						<td align="center" width="15%"><cfif len(trim(data_posee.revision))>#LSDateFormat(data_posee.revision,'dd/mm/yyyy')#<cfelse>-</cfif></td>
						<td align="left"><cfif len(trim(data_posee.justificacion))>#data_posee.justificacion#<cfelse>-</cfif></td>
					</tr>
				</cfloop>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="listaCorte"><cf_translate key="LB_Conocimientos">Conocimientos</cf_translate></td>
				<td class="listaCorte" align="right"><cf_translate key="LB_Dominio">Dominio</cf_translate></td>
				<td class="listaCorte" align="center" nowrap><cf_translate key="LB_FechaUltimaRevision">Fecha &uacute;ltima revisi&oacute;n</cf_translate></td>
				<td class="listaCorte" align="left" nowrap><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate></td>
			</tr>
			<cfif conocimientos_requeridos.recordcount gt 0>
				<cfloop query="conocimientos_requeridos">
					<cfquery name="data_posee" datasource="#session.DSN#">
						select a.RHCEdominio as nota, a.RHCEfdesde as revision, a.RHCEjustificacion as justificacion
						from RHCompetenciasEmpleado a
						
						inner join RHConocimientosPuesto b
						on a.Ecodigo=b.Ecodigo
						and a.idcompetencia=b.RHCid
						and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#puesto.RHPcodigo#">
						
						where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and tipo= 'C'
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between RHCEfdesde and RHCEfhasta
						and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#conocimientos_requeridos.RHCid#">
					</cfquery>

					<cfset posee = data_posee.nota >
					<cfif len(trim(posee)) eq 0><cfset posee = 0 ></cfif>			
					<tr class="<cfif conocimientos_requeridos.currentrow mod 2>listaNon<cfelse>listaPar</cfif> ">
						<td>#trim(conocimientos_requeridos.RHCcodigo)# - #conocimientos_requeridos.RHCdescripcion#</td>
						<td align="right">#LSNumberFormat(posee,',9.00')#%</td>
						<td align="center"><cfif len(trim(data_posee.revision))>#LSDateFormat(data_posee.revision,'dd/mm/yyyy')#<cfelse>-</cfif></td>
						<td align="left"><cfif len(trim(data_posee.justificacion))>#data_posee.justificacion#<cfelse>-</cfif></td>
					</tr>
				</cfloop>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_NoSeEncontraronRegistro">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>

<!--- Otras competencias --->
<cfset otras_habilidades = data.competencias(form.DEid, 'h', habilidades_puesto, session.Ecodigo)>
<cfset otros_conocimientos = data.competencias(form.DEid, 'c', conocimientos_puesto, session.Ecodigo)>
<br>
<table width="99%" align="center" cellpadding="0" cellspacing="0">
	<tr><td>
		<!--- Competencias requeridas por el puesto --->
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr><td colspan="4" style="padding:3px" bgcolor="##E3EDEF" ><strong><font size="2"><cf_translate key="LB_OtrasCompetencias">Otras Competencias</cf_translate></font></strong></td></tr>
			<tr>
				<td class="listaCorte"><cf_translate key="LB_Habilidad">Habilidad</cf_translate></td>
				<td class="listaCorte" align="right"><cf_translate key="LB_Dominio">Dominio</cf_translate></td>
				<td class="listaCorte" >&nbsp;</td>
			</tr>
			<cfif otras_habilidades.recordcount gt 0>
				<cfloop query="otras_habilidades">
					<tr class="<cfif otras_habilidades.currentrow mod 2>listaNon<cfelse>listaPar</cfif> ">
						<td width="40%">#trim(otras_habilidades.codigo)# - #otras_habilidades.descripcion#</td>
						<td align="right" width="10%">#LSNumberFormat(otras_habilidades.nota,',9.00')#%</td>
						<td >&nbsp;</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_NoSeEcontraronRegistros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="listaCorte"><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate></td>
				<td class="listaCorte" align="right"><cf_translate key="LB_Dominio">Dominio</cf_translate></td>
				<td class="listaCorte" >&nbsp;</td>
			</tr>
			<cfif otros_conocimientos.recordcount gt 0>
				<cfloop query="otros_conocimientos">
					<tr class="<cfif otros_conocimientos.currentrow mod 2>listaNon<cfelse>listaPar</cfif> ">
						<td width="40%">#trim(otros_conocimientos.codigo)# - #otros_conocimientos.descripcion#</td>
						<td align="right" width="10%">#LSNumberFormat(otros_conocimientos.nota,',9.00')#%</td>
						<td >&nbsp;</td>
					</tr>
				</cfloop>
			<cfelse>
				<tr><td colspan="4" align="center">-<cf_translate key="LB_NoSeEcontraronRegistros">No se encontraron registros</cf_translate>-</td></tr>
			</cfif>
		</table>
	</td></tr>
</table>
<br>

<cfif isdefined("form.plansucesion")>
	<cfinclude template="plan-sucesion.cfm">
</cfif>

<br>
<table width="100%"><tr><td align="center">------------ <cf_translate key="LB_FinDelReporte">Fin del Reporte</cf_translate> ------------</td></tr></table> 
<br>




</cfoutput>