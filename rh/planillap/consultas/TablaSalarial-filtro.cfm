	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Reporte de Tabla Salarial">			
			<script type="text/javascript" language="javascript1.2">
				function funcValida(){
					if (document.form1.RHVTid.value == ''){
						alert("Se presentaron los siguientes errores:\n - El campo Tabla Salarial es requerido.");
						return false;
					}
					
					if (document.form1.base){
						document.form1.base.disabled = false;
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
					<form name="form1" action="TablaSalarial.cfm" method="post">
						<table width="98%" cellpadding="2" cellspacing="0">
							<tr>
								<td width="50%" valign="top">															
									<cf_web_portlet_start border="true" titulo="Reporte de Tabla Salarial" skin="info1">
										<div align="justify">
										  <p>Reporte de Tablas Salariales.</p>
										</div>
									<cf_web_portlet_end>
								</td>
								<td width="50%" valign="top">
									<table width="98%" cellpadding="3" cellspacing="0">
										<tr>
											<td width="26%" align="left"><strong>Tabla Salarial:&nbsp;</strong></td>
											<td width="74%">                            
												<cf_conlis 
													campos="RHVTid,RHVTcodigo,RHVTdescripcion"
													asignar="RHVTid,RHVTcodigo,RHVTdescripcion"
													size="0,10,25"
													desplegables="N,S,S"
													modificables="N,S,N"						
													title="Lista de Tablas Salariales"
													tabla=" RHVigenciasTabla a
															 inner join RHTTablaSalarial b
																on a.RHTTid = b.RHTTid "
													columnas="RHVTid,RHVTcodigo,RHVTdescripcion,RHTTcodigo,RHTTdescripcion,RHVTfecharige,RHVTfechahasta"
													filtro="a.Ecodigo = #Session.Ecodigo# "
													filtrar_por="RHVTcodigo,RHVTdescripcion,RHTTcodigo,RHTTdescripcion,RHVTfecharige,RHVTfechahasta"
													desplegar="RHVTcodigo,RHVTdescripcion,RHTTcodigo,RHTTdescripcion,RHVTfecharige,RHVTfechahasta"
													etiquetas="C&oacute;digo Vigencia, Descripci&oacute;n, C&oacute;digo Tabla, Tabla,Fecha desde, Fecha hasta"
													formatos="S,S,S,S,D,D"
													align="left,left,left,left,left,left"								
													asignarFormatos="S,S,S"
													form="form1"
													width="850"	
													left="100"	
													top="70"											
													showEmptyListMsg="true"
													EmptyListMsg=" --- No se encontraron registros --- "
												/>
										  </td>
										</tr>										
										<tr><td>&nbsp;</td></tr>
										<tr>
											<td colspan="2" align="center">
												<input type="submit" name="btn_consultar" value="Consultar" onclick="javascript: return funcValida();"/>
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
			
			<script language="javascript1.2" type="text/javascript">
				function desmarcar(obj){
					if ( document.form1.chkTodos ){
						if (!obj.checked){
							document.form1.chkTodos.checked = false;
						}
					}
				}

				function marcar_todos( obj ){
					for ( var i=0; i<document.form1.chk.length; i++ ){
						document.form1.chk[i].checked = (obj.checked) ? true : false;
					}
				}
			</script>
			
		<cf_web_portlet_end>
	<cf_templatefooter>	
