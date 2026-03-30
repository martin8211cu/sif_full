<table width="99%" align="center" cellpadding="2" cellspacing="0"><tr><td width="99%" align="center">
	<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
		Default="Cursos Llevados" Key="LB_Cursos_Llevados" returnvariable="LB_Cursos_Llevados"/>	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Cursos_Llevados#">
	<table width="100%" border="0" cellspacing="0" align="center">
	  <tr>
		<td valign="top">
			<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
				<cfset form.DEid = url.DEid >
			</cfif>
			<cfset est = "">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td bgcolor="#CCCCCC" style="padding:3px; " colspan="9" ><strong><cf_translate key="LB_Cursos_llevados">Cursos llevados</cf_translate></strong></td></tr> 
				<tr>
					<td width="2%" class="tituloListas">&nbsp;</td>
				    <td colspan="3" class="tituloListas">&nbsp;</td>					
				    <td width="15%" class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
					<td width="13%" class="tituloListas"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
					<td width="18%" class="tituloListas"><cf_translate key="LB_Institucion">Institución</cf_translate></td>
					<td width="18%" class="tituloListas"><cf_translate key="LB_Nota">Nota</cf_translate></td>
					<td width="18%" class="tituloListas"><cf_translate key="LB_Horas">Horas</cf_translate></td>
				</tr>
				<!---<cfset rsCAprobados = expediente.cursosLlevados(form.DEid, session.Ecodigo) >--->
				<cfif rsCAprobados.recordcount gt 0>
					<cfoutput query="rsCAprobados">
						<cfif est NEQ rsCAprobados.estado>
							<tr class="<cfif rsCAprobados.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td align="left">&nbsp;</td>
								<td width="2%">&nbsp;</td>
								<td colspan="7"><strong>#rsCAprobados.estado#</strong></td>
							</tr>				
							<cfset est = rsCAprobados.estado>	
						</cfif>
						
						<tr class="<cfif rsCAprobados.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
							<td align="left">&nbsp;</td>
							<td width="2%" align="left">&nbsp;</td>
							<td width="2%" align="left">&nbsp;</td>
							<td width="48%">#trim(rsCAprobados.RHCcodigo)# - #rsCAprobados.Mnombre#</td>
							<td align="left"><cf_locale name="date" value="#rsCAprobados.inicio#"/></td>
							<td align="left"><cf_locale name="date" value="#rsCAprobados.fin#"/></td>
							<td align="left">#rsCAprobados.institucion#</td>
							<td align="left">#rsCAprobados.nota#</td>
							<td align="right">#rsCAprobados.tiempo#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr><td colspan="9" align="center">-<cf_translate key="LB_El_colaborador_no_ha_llevado_ningun_curso">El colaborador no ha llevado ningun curso</cf_translate>-</td></tr>
				</cfif>
			</table>						 
		</td>

		<!---
		<td valign="top" with="50%">
			<cfinclude template="RHEmpleadoCurso-form.cfm">
		</td>
		--->
		
	  </tr>
	</table>
	<cf_web_portlet_end>
</td></tr></table>

