<cf_templateheader title="Consulta de Lista de Precios">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Lista de Precios'>
		
		
	<cfoutput>
		<form method="post" name="form1" action="ListaPrecio-form.cfm"> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="40%" valign="top">
						<table width="100%">
							<tr valign="top">
								<td valign="top">	
									<cf_web_portlet_start border="true" titulo="Consulta Detallada de Listas de Precios" skin="info1">
										<div align="justify">
										  <p>Esta consulta muestra el detalle de todas las Lista de Precios definidas en Facturaci&oacute;n.</p>
								    	</div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="60%" valign="top">
						<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
							<tr>
                            	<td width="11%" align="right" nowrap><strong>Ctro.Funcional :</strong>&nbsp;</td>
                              	<td width="21%" nowrap class="fileLabel">
                                	<cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
                                  		<cfquery name="rscfuncional" datasource="#Session.DSN#">
                                        	select CFid as fCFid, CFcodigo, CFdescripcion 
                                        	from CFuncional where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                            and CFid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
                                  		</cfquery>
                                    	<cf_rhcfuncional id="fCFid" form="form1" query="#rscfuncional#">
                                  	<cfelse>
                                    	<cf_rhcfuncional id="fCFid" form="form1">
                                	</cfif>
                              	</td>
							</tr>
                            
                            <tr>
                            	<td width="11%" align="right" nowrap><strong>Zona de Venta :</strong>&nbsp;</td>
                              	<cfquery datasource="#Session.DSN#" name="Zona">
                                	select id_zona, codigo_zona, Ecodigo, nombre_zona
                                    from ZonaVenta
                                    where Ecodigo = #session.Ecodigo#
                                </cfquery>
                                
                                <td width="21%" nowrap class="fileLabel">
                                	<select tabindex="1" id="Zona" name="Zona">
										<option value="-1">-- Todas --</option>
                                        <cfloop query="Zona">
                                        	<option value="#Zona.id_zona#">#Zona.nombre_zona#</option>
                                        </cfloop>
				                    </select>
                                </td>
                            </tr>
                            
                            <tr>
                            	<td width="11%" align="right" nowrap><strong>Lista de Precios :</strong>&nbsp;</td>
                              	<cfquery datasource="#Session.DSN#" name="ListaP">
                                	select LPid, LPdescripcion
                                    from EListaPrecios
                                    where Ecodigo = #session.Ecodigo#
                                </cfquery>
                                <td width="21%" nowrap class="fileLabel">
                                	<select tabindex="1" id="LPid" name="LPid">
										<option value="-1">-- Todas --</option>
					 					<cfloop query="ListaP">
                                        	<option value="#ListaP.LPid#">#ListaP.LPdescripcion#</option>
                                        </cfloop>
				                    </select>
                                </td>
                            </tr>
                            
                            <tr>
								<td align="right" nowrap><strong>Articulo :</strong>&nbsp;</td>						
							 	<td nowrap width="1%">	
                                	<cf_conlis
                                        Campos="Aid,Acodigo,Adescripcion"
                                        Desplegables="N,S,S"
                                        Modificables="N,S,N"
                                        Size="0,10,40"
                                        tabindex="5"
                                        Title="Lista de Artículos"
                                        Tabla="Articulos a"
                                        Columnas="a.Aid, a.Adescripcion, a.Acodigo"
                                        Filtro="a.Ecodigo = #Session.Ecodigo# order by a.Acodigo"
                                        Desplegar="Acodigo,Adescripcion"
                                        Etiquetas="Codigo,Descripcion"
                                        Formatos="S,S"
                                        enterAction="Articulo"
										fparams="Aid"
                                        Align="left,left"
                                        form="form1"
                                        Asignar="Aid,Acodigo,Adescripcion"
                                        Asignarformatos="S,S,S"											
                                    /> 	
								</td>
							</tr>

                            <tr>
								<td align="right" nowrap><strong>Concepto :</strong>&nbsp;</td>						
							 	<td nowrap width="1%">							
		                           <cf_conlis
                                        Campos="Cid2,Ccodigo2,Cdescripcion2"
                                        Desplegables="N,S,S"
                                        Modificables="N,S,N"
                                        Size="0,10,40"
                                        tabindex="5"
                                        Title="Lista de Ingresos"
                                        Tabla="Conceptos"
                                        Columnas="Cid as Cid2, Ccodigo as Ccodigo2, Cdescripcion as Cdescripcion2"
                                        Filtro=" Ecodigo = #Session.Ecodigo#"
                                        Desplegar="Ccodigo2,Cdescripcion2"
                                        Etiquetas="Codigo,Descripcion"
                                        filtrar_por="Ccodigo,Cdescripcion"
                                        Formatos="S,S"
                                        Align="left,left"
                                        form="form1"
                                        Asignar="Cid2,Ccodigo2,Cdescripcion2"
                                        Asignarformatos="S,S,S"											
                                    /> 	 
								</td>
							</tr>
                        
							<tr align="left">
							  <td width="50%" nowrap align="right"><strong>Fecha Inicial :</strong>&nbsp;</td>
							  <td width="50%" nowrap><cf_sifcalendario name="fechai" value="" tabindex="1"></td>
							  <td width="1%">&nbsp;</td>
						    </tr>

							<tr align="left">
							  <td nowrap align="right"><strong>Fecha Final :</strong>&nbsp;</td>
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="fechaf" value="" tabindex="1"></div></td>
							  <td width="1%">&nbsp;</td>
						    </tr>

                           	<tr>
								<td align="right" nowrap><strong>Moneda :</strong>&nbsp;</td>
								<td align="left">
	          				    <cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" tabindex="1" Todas="S" onChange="Cmoneda();">
    	                        </td> 
						  	</tr>
                            
                            <tr>
								<td align="right" nowrap><strong>Descuento :</strong>&nbsp;</td>
								<td align="left">
	          				    	<input type="checkbox" tabindex="6" id="Descuento" name="Descuento" onclick="javascript: Descuentos();">
                                    <select tabindex="1" id="TDescuento" name="TDescuento" style="display:none">
                                        <option value="P"> Porcentaje (%) </option>
                                        <option value="M"> Monto (CRC)</option>
                                    </select>
                                    <input type="text" tabindex="6" id="VDescuento" name="VDescuento" value="" style="display:none">
    	                        </td> 
						  	</tr>
                            
                            <tr>
								<td align="right" nowrap><strong>Recargo :</strong>&nbsp;</td>
								<td align="left">
	          				    	<input type="checkbox" tabindex="6" id="Recargo" name="Recargo" onclick="javascript: Recargos();"> 
                                    <select tabindex="1" id="TRecargo" name="TRecargo" style="display:none">
                                        <option value="P"> Porcentaje (%) </option>
                                        <option value="M"> Monto (CRC)</option>
                                    </select>
                                	<input type="text" tabindex="6" id="VRecargo" name="VRecargo" value="" style="display:none"> 
                                </td> 
						  	</tr>
                            
                            <tr>
                            	<td>&nbsp;</td>
                            </tr>
                             	
							<tr>
							  <td colspan="3" align="center"><input type="submit" value="Consultar" name="Reporte" id="Reporte">
							    <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();">
                                <input type="hidden" name="indice" id="indice" value="" />
                              </td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		 </form>
        <script type="text/javascript" src="jquery-1.3.2.js"></script>
		<script language="JavaScript" type="text/javascript">
			
			function Articulo(aid) {
				alert (aid);
			}
			
			function limpiar() {
				document.form1.ubicacion.value = "";
				document.form1.Cid.value = "";
				document.form1.Ccodigo.value = "";
				document.form1.Cdescripcion.value = "";
				document.form1.Cid2.value = "";
				document.form1.Ccodigo2.value = "";
				document.form1.Cdescripcion2.value = "";
				document.form1.CFdescripcion.value = "";
				document.form1.CFcodigo.value = "";
				document.form1.fechai.value = "";
				document.form1.fechaf.value = "";
				document.form1.fCFid.value = "";
			}
			Cmoneda();
			function Cmoneda(){
				var indice = document.form1.Mcodigo.selectedIndex;
				var texto = document.form1.Mcodigo.options[indice].text;
				document.form1.indice.value = indice;
				document.form1.TRecargo.options[1].text = "Monto ("+texto+")";
				document.form1.TDescuento.options[1].text = "Monto ("+texto+")";
			}
			
			function Recargos(){	
				var recar = document.getElementById("Recargo");	
				if(recar.checked == true){
					$("##TRecargo").css("display", "relative");
					$("##TRecargo").fadeIn(500);
					
					$("##VRecargo").css("display", "relative");
					$("##VRecargo").fadeIn(500);
				}
				if(recar.checked == false){
					$('##TRecargo').fadeOut(500);
					$('##VRecargo').fadeOut(500);
				}
			}
			
			function Descuentos(){	
				var desc = document.getElementById("Descuento");	
				if(desc.checked == true){
					$("##TDescuento").css("display", "relative");
					$("##TDescuento").fadeIn(500);
					
					$("##VDescuento").css("display", "relative");
					$("##VDescuento").fadeIn(500);	
				}
				if(desc.checked == false){
					$('##TDescuento').fadeOut(500);
					$('##VDescuento').fadeOut(500);
				}
			}
			
			function limpiarDetalleTr() {
				document.form1.Cmayor_CcuentaTransitoria.value = "";
				document.form1.CformatoTransitoria.value = "";
				document.form1.CdescripcionTransitoria.value = "";
				document.form1.CcuentaTransitoria.value = "";
				document.form1.CFcuenta_CcuentaTransitoria.value = "";
			}
		</script>
		
		 
		 </cfoutput>	
		<cf_web_portlet_end>
	<cf_templatefooter>