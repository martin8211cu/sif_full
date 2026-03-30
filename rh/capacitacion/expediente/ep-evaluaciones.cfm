<table width="100%" align="center" cellpadding="0" cellspacing="0" >
	<TR>
		<TD>
			<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
				Default="Evaluaciones" Key="LB_Evaluaciones" returnvariable="LB_Evaluaciones"/>	
			<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Evaluaciones#">
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td class="tituloCorte" colspan="3"><cf_translate key="LB_Evaluaciones_360">Evaluaciones 360</cf_translate></td></tr>
					<tr>
						<td class="tituloListas"><cf_translate key="LB_Evaluacion">Evaluación</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
						<td  class="tituloListas"><cf_translate key="LB_Nota">Nota</cf_translate></td>
					</tr>
					<cfif evaluacion360.recordcount gt 0>
						<cfoutput query="evaluacion360" >
							<tr class="<cfif evaluacion360.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td>#evaluacion360.RHEEdescripcion#</td>
								<td><cf_locale name="date" value="#evaluacion360.RHEEfdesde#"/></td>
								<td><cfif len(trim(evaluacion360.promglobal))>#LSNumberFormat(evaluacion360.promglobal,',9.00')#<cfelse>-</cfif></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr><td colspan="3">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
					</cfif>

					<tr><td>&nbsp;</td></tr>
					<tr><td class="tituloCorte" colspan="3"><cf_translate key="LB_Otras_Evaluaciones">Otras Evaluaciones</cf_translate></td></tr>
					<tr>
						<td class="tituloListas"><cf_translate key="LB_Evaluacion">Evaluación</cf_translate></td>
						<td class="tituloListas"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
						<td  class="tituloListas"><cf_translate key="LB_Nota">Nota</cf_translate></td>
					</tr>
					<cfif otrasevaluaciones.recordcount gt 0>
						<cfoutput query="otrasevaluaciones" >
							<tr class="<cfif otrasevaluaciones.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
								<td>#otrasevaluaciones.RHEEdescripcion#</td>
								<td><cf_locale name="date" value="#otrasevaluaciones.RHEEfdesde#"/></td>
								<td><cfif len(trim(otrasevaluaciones.promglobal))>#LSNumberFormat(otrasevaluaciones.promglobal,',9.00')#<cfelse>-</cfif></td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr><td colspan="3" align="center">-<cf_translate key="LB_No_se_encontraron_registros">No se encontraron registros</cf_translate>-</td></tr>
					</cfif>
					<tr><td>&nbsp;</td></tr>
				</table>
			<cf_web_portlet_end>
		</TD>
	</TR>		
</table>	