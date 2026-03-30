<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Empleados a ser evaluados">
			<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js" type="text/javascript"></script>
			<script src="/cfmx/sif/js/qForms/qforms.js"></script>
			<script language="JavaScript" type="text/JavaScript">
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				qFormAPI.include("*");
			</script>
			<table width="100%" border="0" cellspacing="0">			  
			  <tr>
			  	<td valign="top">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				<td valign="top">
					<form name="form1" action="EmpleadosEvaluar.cfm" method="post">
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="49%" valign="top">															
									<cf_web_portlet_start border="true" titulo="Empleados a ser evaluados" skin="info1">
										<div align="justify">
										  <p>Reporte de empleados que cumplan (exigidamente) una cantidad de meses de laborar en un rango de fechas.</p>
										</div>
									<cf_web_portlet_end>
							  </td>
								<td width="51%">
									<table width="99%" cellpadding="1" cellspacing="0">
										<tr>
											<td width="51%" align="right"><strong>Cantidad de meses a cumplir:&nbsp;</strong></td>
											<td width="49%">                            
												<input name="meses" onFocus="javascript:this.select();" type="text" tabindex="1" style="text-align:right" onBlur="javascript:fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" value="" size="10" maxlength="10">
						  	 	  	  	  </td>
										</tr>
										<tr>
											<td width="51%" align="right"><strong>Fecha desde:&nbsp;</strong></td>
											<td width="49%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="desde" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="2">
							  	  	 	  </td>
										</tr>
										<tr>
											<td width="51%" align="right"><strong>Fecha hasta:&nbsp;</strong></td>
											<td width="49%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="hasta" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="3">	
							  	 	  	  </td>
										</tr>
										<tr>
											<td width="51%" align="right"><strong>Criterio:&nbsp;</strong></td>
											<td width="49%">                            
												<select name="criterio">
													<option value="CN">Con nota</option>
													<option value="SN">Sin nota</option>
													<option value="AM">Ambos</option>
												</select>
						  	 	  	 	  </td>
										</tr>										
										<tr>
											<td align="right"><strong>Formato:&nbsp;</strong></td>
											<td>
												<select name="formato">
													<option value="FlashPaper">FlashPaper</option>
													<option value="pdf">Adobe PDF</option>
													<option value="Excel">Microsoft Excel</option>
												</select>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<input type="submit" name="btn_consultar" value="Consultar" />
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
			<script language="JavaScript" type="text/javascript">	
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");			
				objForm.meses.required = true;
				objForm.meses.description="Cantiddad de meses";								
				objForm.desde.required = true;
				objForm.desde.description="Fecha desde";				
				objForm.hasta.required= true;
				objForm.hasta.description="Fecha hasta";					
			</script>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
