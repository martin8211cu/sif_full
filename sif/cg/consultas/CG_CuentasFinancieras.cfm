

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Consulta de Cuentas Financieras" 
returnvariable="LB_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" 
returnvariable="BTN_Consultar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar"/>

<cfinvoke key="Msg_CmpIniReq" default="- El campo fecha inicial  es requerido.\n" 
returnvariable="Msg_CmpIniReq" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_CmpFinReq" default="- El campo fecha final es requerido.\n" 
returnvariable="Msg_CmpFinReq" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>
<cfinvoke key="Msg_SigErrores" default="Se presentaron los siguientes errores:\n" 
returnvariable="Msg_SigErrores" component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaContform.xml"/>

	<cf_templateheader title="#LB_Titulo#">
    	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
			<form name="form1" method="get" action="CG_CuentasFinancieras-sql.cfm" onSubmit="return validar();">
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr> 
						<td colspan="6"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
					</tr>
					<tr> 
						<td  width="45%" rowspan="4">
							<cf_web_portlet_start border="true" titulo="#LB_Titulo#" skin="info1">
							<table border="0" cellpadding="2" cellspacing="0" align="center">
								<tr>
									<td>
										<div align="justify" style="font-size:12px;">
										<br />
										<cf_translate  key="LB_Mensaje">
											En &eacute;ste reporte se muestran todas aquellas cuentas financieras
											que fueron creadas en el rango de fechas seleccionado
										</cf_translate>
										<br />
										</div>
									</td>
								</tr>
							</table>
							<cf_web_portlet_end>
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<cf_translate key = LB_FechaIni>Fecha Inicio</cf_translate>:&nbsp;
		        </td>
						<td  nowrap>
							<cf_sifcalendario name="fechaini" tabindex="1">							  
						</td> 
						<td nowrap>&nbsp;</td>
						<td align="right" nowrap><cf_translate key=LB_FechaFin>Fecha final</cf_translate>:&nbsp;
					  </td>
						<td align="left" nowrap>
							<cf_sifcalendario name="fechafin" tabindex="2">							  
						</td>
					</tr>
					<tr>
						<td align="right" nowrap>
							<cf_translate key=LB_Formato>
                            Formato</cf_translate>:&nbsp;
						</td>
						<td  colspan="3" nowrap>
							<select name="formato">
								<option value="FlashPaper">FlashPaper</option>
								<option value="pdf">Adobe PDF</option>
								<option value="excel">Microsoft Excel</option>
								</select>						  
						</td> 
						
					</tr>
					
					
					<tr>
						<td colspan="5" align="center"><cfoutput>
							<input type="submit" name="Submit" value="#BTN_Consultar#" onClick="this.form.btnGenerar2.value=0" tabindex="3">							    
							<input type="Reset" name="Limpiar" value="#BTN_Limpiar#" tabindex="18">	</cfoutput>
						</td>
					</tr>
					<tr> 
						<td colspan="5" align="center">&nbsp;							  
						</td>
					</tr>
				</table>
			</form>
        <cfoutput>    
		<script language="javascript1.2" type="text/javascript">
			function validar(){
				var mensaje = '';
				if ( document.form1.fechaini.value == '' ){
					mensaje += ' #Msg_CmpIniReq#';
				}
				if ( document.form1.fechafin.value == '' ){
					mensaje += ' #Msg_CmpFinReq#';
				}

				if ( mensaje != '' ){
					alert('#Msg_SigErrores#' + mensaje)
					return false;
				}
				sinbotones();
				return true;
			}
		</script>
        </cfoutput>
        <cf_web_portlet_end>
	<cf_templatefooter>