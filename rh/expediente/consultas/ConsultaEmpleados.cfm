<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>

	<cfset titulo = "">
	<cfset titulo = 'Consulta de Empleados Activos'>
		
	<cf_templatearea name="body">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#titulo#" >
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			
			<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
			<script language="JavaScript" type="text/JavaScript">
				<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				//-->
			</script>			

			
			<cfoutput>
				<form method="post" name="form1" action="ConsultaEmpleados-rep.cfm">
					<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td width="50%" valign="top">
								<table width="100%" >
									<tr>
										<td valign="top">	
											<cf_web_portlet_start border="true" titulo="Consulta de Empleados Activos" skin="info1">
												<div align="justify">
													<p>El siguiente reporte,  muestra informaci&oacute;n por cortes de Tipos de N&oacute;mina de los Empleados Activos de la Empresa.</p>
												</div>
											<cf_web_portlet_end>
										</td>
									</tr>
								</table>  
							</td>
						
							<td width="50%" valign="top">
								<table width="100%" cellpadding="0" cellspacing="2" align="center">
									<tr>
										<td align="right" nowrap><strong>Tipo N&oacute;mina Inicial:</strong>&nbsp;</td>
								  	  	<td nowrap>								      
							  	        	<input type="text" size="5"  name="Tcodigo1"  	  value="" onBlur="javascript:traerTiposNomina(this.value,1);">                              
											<input type="text" size="40" name="Tdescripcion1" value="" readonly="" disabled >        
											<a href="##" tabindex="-1">
												<img src="/cfmx/rh/imagenes/Description.gif" 
													alt="Lista de Tipos de N&oacute;mina" 
													name="OCimagen" 
													width="18" 
													height="14" 
													border="0" 
													align="absmiddle" 
													onClick='javascript: doConlisTiposNomina(1);'>
											</a>
									  </td>
									</tr>
									<tr>
									  	<td align="right" nowrap><strong>Tipo N&oacute;mina Final:</strong>&nbsp;</td>
 									  	<td nowrap>
							  	        	<input type="text" size="5"  name="Tcodigo2"  	  value="" onBlur="javascript:traerTiposNomina(this.value,2);">                              
											<input type="text" size="40" name="Tdescripcion2" value="" readonly="" disabled >        
											<a href="##" tabindex="-1">
												<img src="/cfmx/rh/imagenes/Description.gif" 
													alt="Lista de Tipos de N&oacute;mina" 
													name="OCimagen" 
													width="18" 
													height="14" 
													border="0" 
													align="absmiddle" 
													onClick='javascript: doConlisTiposNomina(2);'>
											</a>										
										</td>
									</tr>
									<tr>
										<td align="right" nowrap><strong>Centro Funcional:</strong>&nbsp;</td>
										<td nowrap><cf_rhcfuncional></td>
									</tr>
									<!---<tr>
										<td align="right" nowrap><strong>Formato:</strong>&nbsp;</td>
										<td nowrap>
											<select name="formato">
												<option value="html">En l&iacute;nea (HTML)</option>
												<option value="pdf">Adobe PDF</option>
												<option value="xls">Microsoft Excel</option>
											</select>
										</td>
									</tr>--->
									<tr>
									<td colspan="2">
									</td>
										<td colspan="2" align="center">&nbsp;</td>
									</tr>
									<tr>
										<td colspan="2" align="center">
											<input type="submit" value="Generar" name="Reporte">
											<input type="reset" value="Limpiar" name="Limpiar">
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</form>
			</cfoutput>	
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
			
			<script language='javascript1.2' type='text/JavaScript' >
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");
	
				objForm.Tcodigo1.required = true;
				objForm.Tcodigo1.description="Tipo Nómina Inicial";

				objForm.Tcodigo2.required = true;
				objForm.Tcodigo2.description="Tipo Nómina Final";

				function deshabilitarValidacion(){
					objForm.Tcodigo1.required = false;
					objForm.Tcodigo2.required = false;
				}

				var popUpWin = 0;
		 
				function popUpWindow(URLStr, left, top, width, height){
					if(popUpWin){
						if(!popUpWin.closed) popUpWin.close();
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				
				function doConlisTiposNomina(value){
					popUpWindow("/cfmx/rh/expediente/consultas/ConlisTiposNomina.cfm?formulario=form1&idx="+value,30,100,600,400);
				}
				
				function traerTiposNomina(value, index) {
					if (value != ''){	   
						document.getElementById("fr").src = 'TiposNominaQuery.cfm?formulario=form1&codigo='+value+'&index='+index;
					}
					else{
						eval("document.form1.Tcodigo"+index+".value = ''");
						eval("document.form1.Tdescripcion"+index+".value = ''");
					}
				}
			</script>
		
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
