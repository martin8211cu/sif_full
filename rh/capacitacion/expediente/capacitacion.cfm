<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
				Default="Cursos Programados" Key="LB_Cursos_Programados" returnvariable="LB_Cursos_Programados"/>	
			<cf_web_portlet_start border="true" titulo="#LB_Cursos_Programados#" skin="#Session.Preferences.Skin#">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center"></td></tr>	
					<tr><td><cfinclude template="curProgramados.cfm"></td></tr>					
				</table>				
			<cf_web_portlet_end>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr>
		<!---Cursos en proceso--->		
		<td>
			<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
				Default="Cursos en proceso" Key="LB_Cursos_en_proceso" returnvariable="LB_Cursos_en_proceso"/>	
			<cf_web_portlet_start border="true" titulo="#LB_Cursos_en_proceso#" skin="#Session.Preferences.Skin#">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center"></td></tr>	
					<tr><td>
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr><td>
								<!--- Cursos que llevara el colaborador en el futuro --->
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td class="tituloListas"><cf_translate key="LB_Curso">Curso</cf_translate></td>
										<td class="tituloListas"><cf_translate key="LB_Fecha_Inicio">Fecha Inicio</cf_translate></td>
										<td class="tituloListas"><cf_translate key="LB_Fecha_Final">Fecha Final</cf_translate></td>
										<td class="tituloListas"><cf_translate key="LB_Institucion">Instituci&oacute;n</cf_translate></td>
									</tr>
									<cfif cursosporllevar.recordcount gt 0>
										<cfoutput query="cursosporllevar">
											<tr class="<cfif cursosporllevar.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
												<!---<td>#trim(cursosporllevar.RHCcodigo)# - #cursosporllevar.Mnombre#</td>--->
												<td>#trim(cursosporllevar.descripcion)#</td>
												<td align="left"><cf_locale name="date" value="#cursosporllevar.inicio#"/></td>
												<td align="left"><cf_locale name="date" value="#cursosporllevar.fin#"/></td>
												<td align="left">#cursosporllevar.institucion#</td>
											</tr>
										</cfoutput>
									<cfelse>
										<tr><td colspan="2" align="center">-<cf_translate key="LB_El_colaborador_no_tiene_cursos_programados">El colaborador no tiene cursos programados</cf_translate>-</td></tr>
									</cfif>
								</table>
							</td></tr>
						</table>
					</td></tr>
				</table>
			<cf_web_portlet_end>
		</td>
	</tr>		
	<cfif !isDefined("LvarAuto")>
		<tr><td>&nbsp;</td></tr>	
		<tr>      
			<!---Evaluaciones Programadas---->		
			<td>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Evaluaciones Programadas" Key="LB_Evaluaciones_Programadas" returnvariable="LB_Evaluaciones_Programadas"/>	
				<cf_web_portlet_start border="true" titulo="#LB_Evaluaciones_Programadas#" skin="#Session.Preferences.Skin#">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr><td align="center"></td></tr>	
						<tr><td><cfinclude template="evalProgramadas.cfm"></td></tr>
					</table>
				<cf_web_portlet_end>
			</td>		
		</tr>	
	</cfif>
</table> 
