
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ReporteDeEmpleadosPorAnnosLaborados"
Default="Reporte de Empleados por Años Laborados"
returnvariable="LB_ReporteDeEmpleadosPorAnnosLaborados"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_ReporteDeEmpleadosPorAnnosLaborados#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<form method="get" name="form1" action="EmpleadosAntiguedad_report.cfm"  onsubmit="JavaScript: return valida(this);" style="margin:0;" >
					<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="40%" valign="top">
								<table width="100%">
									<tr>
										<td valign="top">
											<cf_web_portlet_start border="true" titulo="#LB_ReporteDeEmpleadosPorAnnosLaborados#" skin="info1">
										  		<div align="justify">
										  			<p>
													<cf_translate key="Ayuda_ReporteDeEmpleadosPorAnnosLaborados">
													Reporte de Empleados por Años Laborados. El reporte muestra todos los empleados por Oficina o Centro funcional, por Fecha de corte del análisis, por Antiguedad máxima y Antiguedad mínima en años, por Corte cada cierta cantidad de años y por Antiguedad reconocida o Última acción de Nombramiento.
													</cf_translate>
													</p>
												</div>
											<cf_web_portlet_end>
										</td>
									</tr>
								</table>  
							</td>
							<td valign="top">
								<table width="100%" cellpadding="2" cellspacing="2" align="center">
									
									<tr>
										<td colspan="2" align="center">
										  
											<input name="radio" type="radio"  id="1" onclick="Javascritp: activa_desactiva(1);" value="1" checked="checked"/>
											<strong><cf_translate key="RAD_Oficina">Oficina</cf_translate>&nbsp;</strong>
										   
										</td>
										<td colspan="2">
											<input type="radio" name="radio" value="2"  id="2" onclick="Javascritp: activa_desactiva(2);"/>
											<strong><cf_translate key="RAD_CentroFuncional">Centro Funcional</cf_translate>&nbsp;</strong>
										</td>
									</tr>
									
									<tr  align="center">
										<td colspan="4" align="center">
											<table><tr><td>
												<Div id="Oficina"><cf_sifoficinas></Div>
												<Div id="centro"><cf_rhcfuncional></Div>
											</td></tr></table>
										</td>
									</tr> 
									
									<tr>
										<td align="right">
											<strong><cf_translate key="LB_FechaDeCorteDelAnalisis">Fecha de Corte del Análisis</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<cfset fecha = LSDateFormat(Now(), 'dd/mm/yyyy')>
											<cf_sifcalendario form="form1" value="#fecha#" name="fecha">
										</td>
									
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate key="LB_AntiguedadMinima">Antiguedad Mínima</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<input name="antiguedad_min" type="text" size="8"/>
										</td>
										
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate key="LB_AntiguedadMaxima">Antiguedad Máxima</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<input name="antiguedad_max" type="text"  size="8"/>
										</td>
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate key="LB_CorteCada">Corte cada</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<input name="rango_corte" type="text"  size="8"/><strong>&nbsp;<cf_translate key="LB_annos">años</cf_translate></strong>
										</td>
									</tr>
									<tr>
										<td align="right">
											<strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</strong>
										</td>
										<td colspan="3">
											<select name="tipo">
												<option value="1"><cf_translate key="CMB_AntiguedadReconocida">Antiguedad Reconocida</cf_translate></option>
												<option value="2"><cf_translate key="CMB_UltimaAccionDeNombramiento">Última Acción de Nombramiento</cf_translate></option>
											</select>
										</td>
									</tr>
									<tr>
										<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
										<td colspan="3">
											<select name="formato">
												<option value="flashpaper"><cf_translate key="CMB_Flashpaper">Flashpaper</cf_translate></option>
												<option value="pdf"><cf_translate key="CMB_PDF">PDF</cf_translate></option>
												<option value="excel"><cf_translate key="CMB_Excel">Excel</cf_translate></option>
											</select>
										</td>
								    </tr>
									<tr>
										<td align="center" colspan="4">
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Limpiar"
											Default="Limpiar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Limpiar"/>
											
											<cfinvoke component="sif.Componentes.Translate"
											method="Translate"
											Key="BTN_Consultar"
											Default="Consultar"
											XmlFile="/rh/generales.xml"
											returnvariable="BTN_Consultar"/>
											<input type="submit" name="Consultar" value="#BTN_Consultar#">										
											<input type="reset" name="Limpiar" value="#BTN_Limpiar#">											
										</td>
									</tr>
									<tr>
										<td colspan="4">&nbsp;</td>
									</tr>
								</table>
							</td>	
						</tr>
					</table>
				</form>
			</cfoutput>	
			
			
			<script language="JavaScript" type="text/javascript">
				
				function validaEntero(dato)
				{
					var notNum = false;
					var tam=0;
					
					tam= dato.length;

					for(i=0; i<tam; i++)
					{	if((dato.charAt(i)!='0')&&(dato.charAt(i)!='1')&&(dato.charAt(i)!='2')&&(dato.charAt(i)!='3')&&(dato.charAt(i)!='4')&&
							(dato.charAt(i)!='5')&&(dato.charAt(i)!='6')&&(dato.charAt(i)!='7')&&(dato.charAt(i)!='8')&&(dato.charAt(i)!='9'))
							notNum=true;
					}
					
					if (notNum)
						return false;  
					else 
						return true;  
						
				}
				
				function valida(f)
				{
					
					var mens="";
					var fec = f.fecha.value;
					var corte = f.rango_corte.value;
					var aMin = f.antiguedad_min.value;
					var aMax = f.antiguedad_max.value;
					
					if(fec == "")
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElCampoFechaDeCorteDelAnalisisEsRequerido"
						Default="El campo 'Fecha de Corte del Análisis' es requerido"
						returnvariable="MSG_ElCampoFechaDeCorteDelAnalisisEsRequerido"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElCampoCorteCadaEsRequerido"
						Default="El campo 'Corte cada' es requerido"
						returnvariable="MSG_ElCampoCorteCadaEsRequerido"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElCampoCorteCadaDebeSerUnValorNumericoYEntero"
						Default="El campo 'Corte cada' debe ser un valor numérico y entero"
						returnvariable="MSG_ElCampoCorteCadaDebeSerUnValorNumericoYEntero"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElCampoAntiguedadMinimaDebeSerUnValorNumericoYEntero"
						Default="El campo 'Antiguedad Mínima' debe ser un valor numérico y entero"
						returnvariable="MSG_ElCampoAntiguedadMinimaDebeSerUnValorNumericoYEntero"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ElCampoAntiguedadMaximaDebeSerUnValorNumericoYEntero"
						Default="El campo 'Antiguedad Máxima' debe ser un valor numérico y entero"
						returnvariable="MSG_ElCampoAntiguedadMaximaDebeSerUnValorNumericoYEntero"/>
						
						
						mens = mens + "<cfoutput>#MSG_ElCampoFechaDeCorteDelAnalisisEsRequerido#</cfoutput>.\n";
					
					if(corte == "")
					{	
						mens = mens + "<cfoutput>#MSG_ElCampoCorteCadaEsRequerido#</cfoutput>.\n";
					}
					else
					{	
						if(isNaN(aMax)){
						mens = mens + "<cfoutput>#MSG_ElCampoCorteCadaDebeSerUnValorNumericoYEntero#</cfoutput> .\n";
						}
					}
					if(aMin != "")
					{
						if(isNaN(aMax)){
						mens = mens + "<cfoutput>#MSG_ElCampoAntiguedadMinimaDebeSerUnValorNumericoYEntero#</cfoutput> .\n";
						}
					}
					if(aMax != "")
					{
						if ( isNaN(aMax) ) {
							mens = mens + "<cfoutput>#MSG_ElCampoAntiguedadMaximaDebeSerUnValorNumericoYEntero#</cfoutput> .\n";
						}	
						/*if(validaEntero(aMax)==false){
						mens = mens + "El campo 'Antiguedad Máxima' debe ser un valor numérico y entero .\n";
						}*/
					}
					
					if(mens != ""){
						alert(mens);
						return(false);
					}
					else 
						return(true);
				}
								
				function activa_desactiva(tip)
				{
					with (document)
					{
						if(tip == 1)			//activa los campos de oficina y desactiva y limpia los campos Centro Funcional
						{
								getElementById('Oficina').style.display='';
								form1.CFcodigo.value="";
								form1.CFdescripcion.value="";
								getElementById('centro').style.display='none';
						}
						else if(tip == 2)		//activa los campos de Centro Funcional y desactiva y limpia los campos Oficina
						{
								form1.Ocodigo.value="";
								form1.Odescripcion.value="";
								getElementById('Oficina').style.display='none';
								getElementById('centro').style.display='';		
						}
					}
					
				}	
				
				<!--- document.getElementById('Oficina').style.display='none'; --->
				document.getElementById('centro').style.display='none';
			</script>			
		<cf_web_portlet_end>
	<cf_templatefooter>
