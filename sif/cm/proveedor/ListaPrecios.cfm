<cf_templateheader title="Compras - Listas de Precios">
	
		<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Listas de Precios'>
			<!--- establecimiento de los modos (ENC y DET)--->	
			<cfset modoE = 'ALTA'>
			<cfset modoD = 'ALTA'>
			<cfif isdefined("form.ELPid") and len(trim(form.ELPid))>
				<cfset modoE = 'CAMBIO'>
				<cfif isdefined("form.DLPlinea") and len(trim(form.DLPlinea))>
					<cfset modoD = 'CAMBIO'>
				</cfif>
			</cfif>
 
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfinclude template="pNavegacion.cfm">
					</td>
				</tr>

				<form action="ListaPrecios-sql.cfm" method="post" name="form1" onSubmit="return valida();" >
					<tr> 
						<td valign="top"> 
							<table width="99%" cellpadding="0" cellspacing="0" align="center">
								<tr>
									<td class="subTitulo" align="center" ><font size="2">Encabezado de la Lista de Precios</font></td>
								</tr>
								
								<tr>
									<td align="center"><cfinclude template="ListaPreciosEnc-form.cfm"></td>
								</tr>

								<cfif modoE NEQ "ALTA">
									<tr>
										<td class="subTitulo" align="center"><font size="2">Detalle de la Lista de Precios</font></td>
									</tr>
									<tr>
										<td><cfinclude template="ListaPreciosDet-form.cfm"></td>
									</tr>
								</cfif>		
								
								<!-------------------------->
								<!---  Lista de Botones  --->
								<!-------------------------->		
								<tr>
									<td align="center" valign="baseline" colspan="8">
										<!-- Caso 1: Alta de Encabezados -->
										<cfif modoE EQ 'ALTA'>
											<input type="submit" name="AgregarEnc" value="Agregar" >
										</cfif>

										<!-- Caso 2: Cambio de Encabezados / Alta de Detalles -->
										<cfif modoE NEQ 'ALTA' and modoD EQ 'ALTA' >
											<input type="submit" name="AgregarDet" value="Agregar">
											<input type="submit" name="BorrarEnc"  value="Borrar la Lista" onClick="javascript:if ( confirm('Está seguro de que desea eliminar esta lista de precios?') ){validar=false; return true;} return false;" >
										</cfif>

										<!-- Caso 3: Cambio de Encabezados / Cambio de Detalle -->		
										<cfif modoE NEQ 'ALTA' and modoD NEQ 'ALTA' >
											<input type="submit" name="CambiarDet" value="Cambiar" >
											<input type="submit" name="BorrarDet"  value="Borrar L&iacute;nea" onClick="javascript:if ( confirm('Está seguro de que desea eliminar este detalle?') ){validar=false; return true;} return false;" >
											<input type="submit" name="BorrarEnc"  value="Borrar la Lista" onClick="javascript:if ( confirm('Está seguro de que desea eliminar esta lista de precios?') ){validar=false; return true;} return false;" >
											<input type="submit" name="NuevoDet"   value="Nueva L&iacute;nea" onClick="javascript:validar=false;" >
										</cfif>
									
										<input type="reset" name="Limpiar" value="Limpiar" >
										<input name="Regresar" type="button" value="Regresar" onClick="javascript:RegresarLista();">						
									</td>							
								</tr>
								<!------------------------------------>
								<!---  Fin de la Lista de Botones  --->
								<!------------------------------------>		
							
							</table>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>						
				</form>

				<!------------------------------------------------------------->
				<!---  Inicia a mostrar las líneas de detalle en una lista  --->
				<!------------------------------------------------------------->		
				<tr>
					<td align="center">
						<table width="99%" align="center" >
							<tr>
								<td>
									<cfif modoE NEQ 'ALTA' >
										<cfquery name="rsListaDetalle" datasource="sifpublica">
											select DLPlinea, ELPid, DLPcodigo, DLPdescripcion, DLPgarantia, DLPplazoentrega, DLPplazocredito, DLPprecio
											from DListaPrecios 
											where ELPid=#form.ELPid#
											order by DLPcodigo
										</cfquery>
									</cfif>

									<cfif modoE NEQ 'ALTA' >
										<cfinvoke 
								 		 component="sif.Componentes.pListas"
								 		 method="pListaQuery"
								 		 returnvariable="pListaRet">
											<cfinvokeargument name="query" value="#rsListaDetalle#"/>
											<cfinvokeargument name="desplegar" value="DLPcodigo, DLPdescripcion, DLPgarantia, DLPplazoentrega, DLPplazocredito, DLPprecio "/>
											<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Garant&iacute;a, Plazo Entrega, Plazo Cr&eacute;dito, Precio"/>
											<cfinvokeargument name="formatos" value="V, V, M, M, M, M"/>
											<cfinvokeargument name="align" value="left, left, right, right, right, right"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="n"/>
											<cfinvokeargument name="irA" value="ListaPrecios.cfm"/>
											<cfinvokeargument name="showEmptyListMsg" value="true"/>
											<cfinvokeargument name="keys" value="DLPlinea"/>
										</cfinvoke>
									<cfelse>
										<cfif not isdefined('Form.btnNuevo')>mjkjhk
											<cflocation addtoken="no" url='ListaPrecios-lista.cfm'>
										</cfif>	
									</cfif>
								</td>		
							</tr>					
						</table>
					</td>
				</tr>
				<!---------------------------------------------------------------->
				<!---  Finaliza de mostrar las líneas de detalle en una lista  --->
				<!---------------------------------------------------------------->		
				
			</table>
			
			<!---------------------------------------------------->
			<!---  Inicia la validación de la Lista de Precios --->
			<!---------------------------------------------------->		
			<script language="javascript1.2" type="text/javascript">
				var validar = true;
				var datos = document.form1;
				
				function valida(){
					if (validar){
						var error = false;
						var mensaje = "Se presentaron los siguientes errores:\n";
						
						// Validación de los campos del Emcabezado
						if ( trim(datos.ELPfdesde.value) == '' ){
							error = true;
							mensaje += " - El campo Fecha desde es requerido.\n";
						}
	
						if ( trim(datos.ELPfhasta.value) == '' ){
							error = true;
							mensaje += " - El campo Fecha hasta es requerido.\n";
						}
						
						if ( trim(datos.Estado.value) == '' ){
							error = true;
							mensaje += " - El campo Estado es requerido.\n";
						}
	
						if ( trim(datos.ELPdescripcion.value) == '' ){
							error = true;
							mensaje += " - El campo Descripción es requerido.\n";
						}
						
						// Validación de los campos del Detalle
						<cfif modoE NEQ 'ALTA'>
							if ( trim(datos.DLPcodigo.value) == '' ){
								error = true;
								mensaje += " - El campo Código es requerido.\n";
							}
	
							if ( trim(datos.DLPdescripcion.value) == '' ){
								error = true;
								mensaje += " - El campo Descripción del Detalle es requerido.\n";
							}
	
							if ( trim(datos.DLPgarantia.value) == '' ){
								error = true;
								mensaje += " - El campo Garantía es requerido.\n";
							}
	
							if ( trim(datos.DLPplazoentrega.value) == '' ){
								error = true;
								mensaje += " - El campo Plazo Entrega es requerido.\n";
							}
							
							if ( trim(datos.DLPplazocredito.value) == '' ){
								error = true;
								mensaje += " - El campo Plazo Crédito es requerido.\n";
							}
							
							if ( trim(datos.DLPprecio.value) == '' ){
								error = true;
								mensaje += " - El campo Precio es requerido.\n";
							}
						</cfif>
	
						if ( error ){
							alert(mensaje);
							return false;
						}
						else{
							<cfif modoE neq 'ALTA'>
								datos.DLPgarantia.value = qf(datos.DLPgarantia.value);
								datos.DLPplazoentrega.value = qf(datos.DLPplazoentrega.value);
								datos.DLPplazocredito.value = qf(datos.DLPplazocredito.value);
								datos.DLPprecio.value = qf(datos.DLPprecio.value);
							</cfif>
							return true;
						}
					}
					else {
						return true;
					}
				}
				
				function RegresarLista(){
					document.form1.action='ListaPrecios-lista.cfm';
					document.form1.submit();
				}
			
			</script>
			<!------------------------------------------------------>
			<!---  Finaliza la validación de la Lista de Precios --->
			<!------------------------------------------------------>		

		<cf_web_portlet_end>	
	<cf_templatefooter>