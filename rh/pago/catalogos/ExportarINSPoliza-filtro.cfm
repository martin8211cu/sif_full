<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ExportacionDeRiesgosDelTrabajo"
Default="Exportación de Riesgos del Trabajo"
returnvariable="LB_ExportacionDeRiesgosDelTrabajo"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="BTN_Siguiente"
Default="Siguiente"
returnvariable="BTN_Siguiente"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_El_campo_Poliza_es_requerido"
Default="El campo Póliza es requerido"
returnvariable="MSG_poliza"/> 

<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cfoutput>#LB_ExportacionDeRiesgosDelTrabajo#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start titulo="#LB_ExportacionDeRiesgosDelTrabajo#">
				<form action="ExportarINSPoliza.cfm" method="post" name="filtro">

					<table width="100%"  border="0" cellspacing="4" cellpadding="4">
						<tr>
							<td align="right" width="37%"></td>
							<td><strong><cf_translate key="LB_Seleccione_el_tipo_de_poliza_que_desea_generar">Seleccione el tipo de p&oacute;liza que desea generar</cf_translate>:&nbsp;</strong></td>
						</tr>
						<tr>
							<td align="right" width="37%"></td>
							<td>
								<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Seleccionar"
									Default="Seleccionar"
									XmlFile="/rh/generales.xml"
									returnvariable="LB_Seleccionar"/>
							
								<cfquery name="rs_poliza" datasource="#session.DSN#">
									select a.RHEDVid, a.RHEDVcodigo, a.RHEDVdescripcion, b.RHDDVlinea, b.RHDDVcodigo, b.RHDDVdescripcion, b.RHDDVvalor
									from RHEDatosVariables a, RHDDatosVariables b
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and a.RHEDVtipo = 1
									  and b.RHEDVid=a.RHEDVid
									order by a.RHEDVcodigo	, b.RHDDVcodigo					
								</cfquery>
								<select name="RHDDVlinea">
									<option value=""><cfoutput>-#LB_Seleccionar#-</cfoutput></option>
									<cfoutput query="rs_poliza" group="RHEDVcodigo">
									<optgroup label="#trim(rs_poliza.RHEDVcodigo)# - #rs_poliza.RHEDVdescripcion#" >
										<cfoutput>
										<option value="#rs_poliza.RHDDVlinea#" <cfif isdefined("rsForm.RHDDVlinea") and rsForm.RHDDVlinea eq rs_poliza.RHDDVlinea>selected</cfif> >#trim(rs_poliza.RHDDVcodigo)# - #rs_poliza.RHDDVdescripcion#</option>
										</cfoutput>
									</optgroup>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="submit" class="btnSiguiente" name="btnSiguiente" value="<cfoutput>#BTN_Siguiente#</cfoutput>" />
							</td>
						</tr>

					</table>
				</form>				
				
				<cf_qforms form="filtro">
				<script language="javascript1.5" type="text/javascript">
					objForm.RHDDVlinea.required = true;
					objForm.RHDDVlinea.description = '<cfoutput>#MSG_poliza#</cfoutput>';
				</script>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>