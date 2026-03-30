<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_EmpleadosASerEvaluados"
		Default="Empleados a ser evaluados"
		returnvariable="LB_EmpleadosASerEvaluados"/>
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_EmpleadosASerEvaluados#">
		<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js" type="text/javascript"></script>
		<script src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			qFormAPI.include("*");
		</script>
		<table width="100%" border="0" cellspacing="0">			  
			<tr><td valign="top"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
		  	<tr><td>&nbsp;</td></tr>
		  	<tr>
				<td valign="top">
					<form name="form1" action="EmpleadosEvaluar.cfm" method="get">
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="49%" valign="top">															
									<cf_web_portlet_start border="true" titulo="#LB_EmpleadosASerEvaluados#" skin="info1">
										<div align="justify">
									  		<p><cf_translate key="AYUDA_ReporteDeEmpleadosQueCumplanEstrictamenteUnaCantidadDeMesesDeLaborarEnUnRangoDeFechas">Reporte de empleados que cumplan (estrictamente) una cantidad de meses de laborar en un rango de fechas.</cf_translate></p>
										</div>
									<cf_web_portlet_end>
							  	</td>
								<td width="51%">
									<table width="99%" cellpadding="1" cellspacing="0">
										<tr>
											<td width="51%" align="right"><strong><cf_translate key="LB_CantidadDeMesesACumplir">Cantidad de meses a cumplir</cf_translate>:&nbsp;</strong></td>
											<td width="49%">                            
												<input name="meses" onFocus="javascript:this.select();" type="text" tabindex="1" style="text-align:right" onBlur="javascript:fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="" size="10" maxlength="10">
					  	 	  	  	  		</td>
										</tr>
										<tr>
											<td width="51%" align="right"><strong><cf_translate key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</strong></td>
											<td width="49%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="desde" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">
							  	  	 		</td>
										</tr>
										<tr>
											<td width="51%" align="right"><strong><cf_translate key="LB_FechaHasta">Fecha hasta</cf_translate>:&nbsp;</strong></td>
											<td width="49%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="hasta" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">	
						  		 	  		</td>
										</tr>
										<tr>
											<td width="51%" align="right"><strong><cf_translate key="LB_Criterio">Criterio</cf_translate>:&nbsp;</strong></td>
											<td width="49%">                            
												<select name="criterio" tabindex="1">
													<option value="CN"><cf_translate key="CMB_ConNota">Con nota</cf_translate></option>
													<option value="SN"><cf_translate key="CMB_SinNota">Sin nota</cf_translate></option>
													<option value="AM"><cf_translate key="CMB_Ambos">Ambos</cf_translate></option>
												</select>
							  	 	  	 	</td>
										</tr>									
										<tr>
											<td align="right"><strong><cf_translate key="LB_Formato" XmlFile="/rh/generales.xml">Formato</cf_translate>:&nbsp;</strong></td>
											<td>
												<select name="formato" tabindex="1">
													<option value="FlashPaper"><cf_translate key="LB_" XmlFile="/rh/generales.xml">FlashPaper</cf_translate></option>
													<option value="pdf"><cf_translate key="LB_AdobePDF" XmlFile="/rh/generales.xml">Adobe PDF</cf_translate></option>
													<option value="Excel"><cf_translate key="LB_MicrosoftExcel" XmlFile="/rh/generales.xml">Microsoft Excel</cf_translate></option>
												</select>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="BTN_Consultar"
													Default="Consultar"
													XmlFile="/rh/generales.xml"
													returnvariable="BTN_Consultar"/>
												<input type="submit" name="btn_consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>" />
											</td>
										</tr>
							  		</table>
						  		</td>
							</tr>
				  		</table>
					</form>
				</td>
		  	</tr>
		  	<tr><td>&nbsp;</td></tr>
		</table>
		<!--- VARIABLES DE TRADUCCION --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_CantidadDeMeses"
			Default="Cantidad de meses"
			returnvariable="LB_CantidadDeMeses"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaDesde"
			Default="Fecha desde"
			returnvariable="LB_FechaDesde"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FechaHasta"
			Default="Fecha hasta"
			returnvariable="LB_FechaHasta"/>

		<script language="JavaScript" type="text/javascript">	
			qFormAPI.errorColor = "#FFFFCC";
			<cfoutput>
			objForm = new qForm("form1");			
			objForm.meses.required = true;
			objForm.meses.description="#LB_CantidadDeMeses#";								
			objForm.desde.required = true;
			objForm.desde.description="#LB_FechaDesde#";				
			objForm.hasta.required= true;
			objForm.hasta.description="#LB_FechaHasta#";		
			</cfoutput>			
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>
