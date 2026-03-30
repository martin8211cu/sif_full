<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<br>

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="1%" valign="top"><cfinclude template="/sif/menu.cfm"></td>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Resumen de Resultados por Secci&oacute;n'>
									
					<cfset navBarItems[1]  = "Calificaciones del Empleado">
					<cfset navBarLinks[1]  = "/cfmx/home/menu/pNavegacion.cfm">
					<cfset navBarStatusText[1]  = "Calificaciones del Empleado">
					<!--- <cfset Regresar  = "/cfmx/home/menu/modulo.cfm?s=RH&m=EVAL"> --->
					
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<form name="form8" id="form8">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center">Seleccione la relaci&oacute;n que desea imprimir</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
							<td align="center">
								<strong>Formato:</strong> 
								<select name="format" id="format">
									<option value="html">En l&iacute;nea (HTML)</option>
									<option value="pdf">Adobe PDF</option>
									<option value="xls">Microsoft Excel</option>
								</select>
								</td>
							</tr>
						</table>
					</form>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td colspan="3">
								<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaRH"
									 returnvariable="pListaRHRet">
										<cfinvokeargument name="tabla" value="RHEEvaluacionDes a"/>
										<cfinvokeargument name="columnas" value="a.RHEEid, a.RHEEdescripcion, convert(varchar,a.RHEEfecha,103) as RHEEfecha"/>
										<cfinvokeargument name="desplegar" value="RHEEdescripcion, RHEEfecha "/>
										<cfinvokeargument name="etiquetas" value="Descripción, Fecha"/>
										<cfinvokeargument name="formatos" value="S, S"/>
										<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo# and a.RHEEestado in (3)"/>
										<cfinvokeargument name="align" value="left, center"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="funcion" value="reporte"/>
										<cfinvokeargument name="fparams" value="RHEEid"/>
										<cfinvokeargument name="checkboxes" value="N">
	<!--- 												<cfinvokeargument name="keys" value="RHEEid"> 
													<cfinvokeargument name="formName" value="listaEvaluaciones">
													<cfinvokeargument name="incluyeform" value="false">--->
										<!--- <cfinvokeargument name="cortes" value="RHPdescpuesto"> --->
										<cfinvokeargument name="showEmptyListMsg" value="true">
										<cfinvokeargument name="EmptyListMsg" value="*** NO SE HA REGISTRADO NINGUNA EVALUACION ***">
										<!--- <cfinvokeargument name="navegacion" value="#navegacion#"> --->
							  </cfinvoke>
							</td>
						</tr>
					</table>
					<script type="text/javascript">
						function reporte(RHEEid){
							location.href='ResumenCal-rep.cfm?format='+document.form8.format.value+'&RHEEid='+RHEEid;
						}
					</script>
				<cf_web_portlet_end>	
			</td>	
		</tr>
	</table>	
<cf_templatefooter>