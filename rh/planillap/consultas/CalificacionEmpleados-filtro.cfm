<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	<cf_templatearea name="body">
			<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js" type="text/javascript"></script>
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Calificaciones de Empleados">
			<script type="text/javascript" language="javascript1.2">								
				function funcValidaciones(){
					if (document.form1.desde.value =='' || document.form1.hasta.value ==''){
						alert("Debe seleccionar la fecha desde y la fecha hasta");
						return false;
					}
					return true;
				}
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
					<form name="form1" action="CalificacionEmpleados.cfm" method="post" onsubmit="javascript: return funcValidaciones();">
						<table width="100%" cellpadding="1" cellspacing="0">
							<tr>
								<td width="36%" valign="top">															
									<cf_web_portlet_start border="true" titulo="Calificaciones de Empleados" skin="info1">
										<div align="justify">
										  <p>Reporte de calificaciones de empleados en un per&iacute;odo dado.</p>
										</div>
									<cf_web_portlet_end>
							  </td>
								<td width="64%">
									<table width="99%" cellpadding="1" cellspacing="0">
										<tr>
											<td width="63%" align="right"><strong>Fecha desde:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="desde" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">
								  	  	  </td>
										</tr>
										<tr>
											<td width="63%" align="right"><strong>Fecha hasta:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_sifcalendario conexion="#session.DSN#" form="form1" name="hasta" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1">	
								  	 	  </td>
										</tr>
										<tr>
											<td width="63%" align="right"><strong>C&eacute;dula desde:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_rhempleado size="30" form="form1" tabindex="3" index="1"  DEid="DEid_desde" DEidentificacion="identificacion_desde" Nombre="Nombre_desde" TipoId="-1" > 
							  	 	  	  </td>
										</tr>
										<tr>
											<td width="63%" align="right"><strong>C&eacute;dula hasta:&nbsp;</strong></td>
											<td width="37%">                            
												<cf_rhempleado size="30" form="form1" tabindex="4" index="1" DEid="DEid_hasta" DEidentificacion="identificacion_hasta" Nombre="Nombre_hasta" TipoId="-1" >	
								  	 	  </td>
										</tr>
										<tr>
											<td width="63%" align="right">
												<input type="checkbox" name="chk_nota" tabindex="1" 
												onclick="javascript: if(this.checked){document.form1.nota_inferior.disabled = false;}else{document.form1.nota_inferior.value = ''; document.form1.nota_inferior.disabled = true;}"/>
											  <strong>Mostrar s&oacute;lo con nota inferior a:&nbsp;</strong>												
											</td>
											<td>
												<input name="nota_inferior" onFocus="javascript:this.select();" type="text" tabindex="1" style="text-align:right" onBlur="javascript:fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="" size="6" maxlength="6">												
											</td>
										</tr>
										<tr>
											<td align="right"><strong>Formato:&nbsp;</strong></td>
											<td>
												<select name="formato" tabindex="1">
													<option value="FlashPaper">FlashPaper</option>
													<option value="pdf">Adobe PDF</option>
													<option value="Excel">Microsoft Excel</option>
												</select>
											</td>
										</tr>
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<input type="submit" tabindex="1" name="btn_consultar" value="Consultar" />
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
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>
