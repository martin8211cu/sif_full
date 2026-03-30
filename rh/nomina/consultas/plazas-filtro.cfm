<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title"><cf_translate  key="LB_Recursos_Humanos">Recursos Humanos</cf_translate></cf_templatearea>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_de_Empleados_por_Plaza"
	Default="Reporte de Empleados por Plaza"
	returnvariable="LB_Reporte_de_Empleados_por_Plaza"/> 
	
	<cf_templatearea name="body">
		<cf_templatecss>
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Reporte_de_Empleados_por_Plaza#'>
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>

			<form name="form1" method="post" style="margin:0;" action="plazas.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="45%"><strong><cf_translate  key="LB_Centro_Funcional_Desde">Centro Funcional Desde</cf_translate>:</strong>&nbsp;</td>
						<td><cf_rhcfuncional id="CFpkdesde" name="CFcodigodesde" desc="CFdescdesde" tabindex="1"></td>
					</tr>

					<tr>
						<td align="right" width="45%"><strong><cf_translate  key="LB_Centro_Funcional_Hasta">Centro Funcional Hasta</cf_translate>:</strong>&nbsp;</td>
						<td><cf_rhcfuncional id="CFpkhasta" name="CFcodigohasta" desc="CFdeschasta" tabindex="1"></td>
					</tr>
					
					<tr>
						<td align="right" width="45%" ><strong><cf_translate  key="LB_Mostrar_plazas">Mostrar plazas</cf_translate>:</strong>&nbsp;</td>
						<td>
							<table width="70%" border="0" cellpadding="2" class="areaFiltro">
								<tr>
									<td width="1%"><input type="radio" name="mostrarplazas" value="T" checked="checked"></td>
									<td><label><cf_translate  key="LB_Todas">Todas</cf_translate></label></td>
									<td width="1%"><input type="radio" name="mostrarplazas" value="O"></td>
									<td><label><cf_translate  key="LB_Ocupadas">Ocupadas</cf_translate></label></td>
									<td width="1%"><input type="radio" name="mostrarplazas" value="V"></td>
									<td><label><cf_translate  key="LB_Vacantes">Vacantes</cf_translate></label></td>
								</tr>
							</table>
						</td>
					</tr>

					<tr>
						<td align="right" width="45%" ><strong><cf_translate  key="LB_Desplegar_nombre_por">Desplegar nombre por</cf_translate>:</strong>&nbsp;</td>
						<td>
							<table width="70%" border="0" cellpadding="2" class="areaFiltro">
								<tr>
									<td width="1%"><input type="radio" name="desplegarnombre" value="AN" checked="checked"></td>
									<td><label><cf_translate  key="LB_Apellido-Nombre">Apellido-Nombre</cf_translate></label></td>
									<td width="1%"><input type="radio" name="desplegarnombre" value="NA"></td>
									<td><label><cf_translate  key="LB_Nombre-Apellido">Nombre-Apellido</cf_translate></label></td>
								</tr>
							</table>
						</td>
					</tr>
                    
                    <!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
                    <tr>
						<td align="right" width="45%"><strong><cf_translate  key="LB_Mostrar_Dependencia">Mostrar Dependencia</cf_translate>:</strong>&nbsp;</td>
						<td><table width="70%" border="0" cellpadding="2" class="areaFiltro">
								<tr>
									<td width="1%"><input type="radio" name="mostrardependencia" value="Si" checked="checked"></td>
									<td><label><cf_translate  key="LB_Si_Mostrar">Si Mostrar</cf_translate></label></td>
									<td width="1%"><input type="radio" name="mostrardependencia" value="No"></td>
									<td><label><cf_translate  key="LB_Si_Mostrar">No Mostrar</cf_translate></label></td>
								</tr>
							</table></td>
					</tr>
					<!---SML. Se modifico para que se pueda se pueda exportar a Excel, sin tantos espacios entre celdas.--->
					<tr><td colspan="3" align="center"><cf_botones tabindex="1" include="Filtrar,Limpiar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		</cf_web_portlet>

		<cf_qforms>
		<!---
		<script type="text/javascript" language="javascript1.2">
			objForm.CFpk.required = true;
			objForm.CFpk.description = 'Centro Funcional';
			objForm.fecha.required = true;
			objForm.fecha.description = 'Fecha';
		</script>
		--->

	</cf_templatearea>
</cf_template>