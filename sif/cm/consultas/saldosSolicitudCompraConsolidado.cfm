<cfparam name="form.ubicacion" default="">
<cfparam name="form.Ocodigo" default="">
<cfparam name="form.GOid"    default="">
<cfparam name="form.GEid"    default="">
<cfparam name="form.AVid"    default="">

<!--- Oficinas de la Empresa --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = #session.ecodigo#
	order by Odescripcion
</cfquery>
<!--- Grupos de Empresas --->
<cfquery name="rsGE" datasource="#session.DSN#">
	select ge.GEid, ge.GEnombre
	from AnexoGEmpresa ge
		join AnexoGEmpresaDet gd
			on ge.GEid = gd.GEid
	where ge.CEcodigo = #session.CEcodigo#
	  and gd.Ecodigo = #session.ecodigo#
	order by ge.GEnombre
</cfquery>

<cf_templateheader title="Montos por Solicitud de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Montos por Solicitud de Compra'>
		
		
	<cfoutput>
		<form method="post" name="form1" action="saldosSolicitudCompraConsolidado-form.cfm"> 
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
									<cf_web_portlet_start border="true" titulo="Consulta de Montos por Solicitud de Compra" skin="info1">
										<div align="justify">
										  <p>Esta consulta muestra el detalle de las Solicitudes de Compra que tienen items a&uacute;n pendientes de surtir.</p>
								    	</div>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>  
					</td>
					<td width="60%" valign="top">
						<table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
							<tr>
							  	<td align="right" nowrap><strong>Empresa u Oficina :</strong>&nbsp;</td>
							  	<td nowrap>
							  		<select name="ubicacion" >
									<option value="-1" <cfif -1 eq form.Ocodigo> selected</cfif>> - Variables de Empresa - </option>
									<option value="1" > #session.enombre#</option>
									<cfif rsGE.RecordCount>
										<optgroup label="Grupos de Empresas">
									  	<option value="ge," <cfif form.ubicacion eq 'ge,'>selected</cfif> >(Todos los grupos de empresas)</option>
									  	<cfloop query="rsGE">
											<option value="ge,#rsGE.GEid#" <cfif rsGE.GEid EQ form.GEid> selected</cfif>> #rsGE.GEnombre#</option>
									  	</cfloop>
									  	</optgroup>
									</cfif>
									<optgroup label="Oficinas">
									<option value="of," <cfif form.ubicacion eq 'of,'>selected</cfif> >(Todas las oficinas)</option>
									<cfloop query="rsOficinas">
										<option value="of,#rsOficinas.Ocodigo#" <cfif rsOficinas.Ocodigo EQ form.Ocodigo> selected</cfif>> #rsOficinas.Odescripcion#</option>
									</cfloop>
									</optgroup>
								  </select>
								</td>
							  	<td width="1%">&nbsp;</td>
						  	</tr>
							<!----Solicitante--->
                            <tr>
								<td align="right" nowrap><strong>Solicitante:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="CMScodigo" maxlength="10" value="" size="15" onBlur="javascript:solicitante(1,this.value);" >
									<input type="text" name="CMSnombre" id="CMSnombre" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitantes" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisSolicitantes();'></a>
									<input type="hidden" name="CMSid" value="" >
								</td>
							</tr>
                            <tr>
								<td align="right" nowrap><strong>De la solicitud :</strong>&nbsp;</td>						
							 	<td nowrap width="1%">							
                                	<input name="ESidsolicitud1" type="hidden" value="">
									<input name="ESnumero1" type="text" value="" size="15" 
									onblur="javascript:traeSolicitud(this.value,1); fm(this,-1)"
									onFocus="javascript:this.value=qf(this); this.select();"  
									onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo N° Solicitud"><input name="ESobservacion1" type="text" value="" size="40" readonly="" disabled>								
								</td>
								<td width="8%">		
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitudes" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOC(1);'></a>
								</td>
							</tr>

                            <tr>
								<td align="right" nowrap><strong>Hasta :</strong>&nbsp;</td>						
							 	<td nowrap width="1%">							
		                            <input name="ESidsolicitud2" type="hidden" value="">
									<input name="ESnumero2" type="text" value="" size="15" 
									onblur="javascript:traeSolicitud(this.value,2); fm(this,-1)"
									onFocus="javascript:this.value=qf(this); this.select();"  
									onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo N° Solicitud"><input name="ESobservacion2" type="text" value="" size="40" readonly="" disabled>								
								</td>
								<td width="8%">		
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitudes" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOC(2);'></a>
								</td>
							</tr>
                        
							<tr align="left">
							  <td width="50%" nowrap align="right"><strong>De la Fecha :</strong>&nbsp;</td>
							  <td width="50%" nowrap><cf_sifcalendario name="fechai" value="" tabindex="1"></td>
							  <td width="1%">&nbsp;</td>
						    </tr>

							<tr align="left">
							  <td nowrap align="right"><strong>Hasta :</strong>&nbsp;</td>
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="fechaf" value="" tabindex="1"></div></td>
							  <td width="1%">&nbsp;</td>
						    </tr>
                            
                            <tr>
			                   	<td nowrap align="right"><strong>Estado :</strong>&nbsp;</td>
                                  <td width="19%" nowrap class="fileLabel">
                                    <select name="LEstado" id="LEstado">
                                      <option value="">- No especificado -</option>
                                      <!---<cfif isdefined('session.compras.solicitante') and len(trim(session.compras.solicitante))> --->
                                      <option value="-1" <cfif isdefined('form.LEstado') and form.LEstado EQ -1>selected</cfif>>Solicitudes sin Orden de Compra</option>
									  <option value="0" <cfif isdefined('form.LEstado') and form.LEstado EQ 0>selected</cfif>>Pendiente</option>
                                      <option value="-10" <cfif isdefined('form.LEstado') and form.LEstado EQ -10>selected</cfif>>Rechazada por presupuesto</option>
                                      <option value="10" <cfif isdefined('form.LEstado') and form.LEstado EQ 10>selected</cfif>>En trámite de aprobación</option>
                                      <!---</cfif> --->
                                      <option value="20" <cfif isdefined('form.LEstado') and form.LEstado EQ 20>selected</cfif>>Aplicada, en proceso de cotizaci&oacute;n</option>
                                      <option value="25" <cfif isdefined('form.LEstado') and form.LEstado EQ 25>selected</cfif>>Orden de Compra Directa</option>
                                      <!---<option value="30" <cfif isdefined('form.LEstado') and form.LEstado EQ 30>selected</cfif>>Incluida en Publicación</option>--->
                                      <option value="40" <cfif isdefined('form.LEstado') and form.LEstado EQ 40>selected</cfif>>Parcialmente Surtida</option>
                                      <option value="50" <cfif isdefined('form.LEstado') and form.LEstado EQ 50>selected</cfif>>Surtida</option>
                                      <option value="60" <cfif isdefined('form.LEstado') and form.LEstado EQ 60>selected</cfif>>Cancelada</option>
                                    </select>
                                  </td>
                            </tr>
                            
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
                                <td width="8%" align="right" nowrap><strong>Tipo :</strong>&nbsp;</td>
                      			<td width="21%" nowrap class="fileLabel">
                      				 <cfoutput>
				                    	<input name="fCMTScodigo" type="text" value="<cfif isDefined("form.fCMTScodigo")><cfoutput>#form.fCMTScodigo#</cfoutput></cfif>"  id="fCMTScodigo" size="5" maxlength="5" tabindex="-1" onBlur="javascript:traerTSolicitud(this.value,1);">
                				        <input name="fCMTSdescripcion" type="text" id="fCMTSdescripcion" value="<cfif isDefined("form.fCMTSdescripcion")><cfoutput>#form.fCMTSdescripcion#</cfoutput></cfif>" size="44" readonly>
				                        <a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTSolicitudes();"> </a> 
									 </cfoutput> 
                				</td>
			                </tr>
                           
                           	<tr>
								<td align="right" nowrap><strong>Moneda :</strong>&nbsp;</td>
								<td align="left">
	          				    <cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1" Todas="S">
    	                        </td> 
						  	</tr>
							 	<tr>
									<td align="right" nowrap><strong>Mostar columna<br/>de montos:</strong>&nbsp;</td>
									<td align="left">
									<input type="checkbox" name="mostrarMontos" value="1">
    	                        </td> 
						  	</tr>
							<tr>
							  <td colspan="3" align="center"><input type="submit" value="Consultar" name="Reporte" id="Reporte">
							    <input type="button" name="Limpiar" value="Limpiar" onClick="javascript: limpiar();"></td>
								</tr>
						</table>
					</td>
				</tr>
			</table>
		 </form>
		<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			
			//Funcion del conlis de tipos de solicitud
			function doConlisTSolicitudes() {
				popUpWindow("../operacion/conlisTSolicitudesSolicitante.cfm?formulario=form1",250,150,600,350);
			}
			//Funcion del conlis para los solicitantes
			function doConlisSolicitantes() {
				var params = "";
					params = "?formulario=form1&CMSid=CMSid&CMScodigo=CMScodigo&desc=CMSnombre";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisSolicitantesConsulta.cfm"+params,250,200,650,400);
			}
			//Funcion para obtener el solicitante con su codigo
			function solicitante(opcion, value){
				if ( value !='' ){
					document.getElementById("fr").src = "SolicitantesConsulta.cfm?CMScodigo="+value+"&opcion="+opcion;
				}
			}
			
			//Funcion para traer datos del tipo de solicitud cuando estos fueron digitados por el usuario
			function traerTSolicitud(value){
			  if (value!=''){	   
			   document.getElementById("fr").src = '../operacion/traerTSolicitudSolicitante.cfm?formulario=form1&fCMTScodigo='+value;
			  }
			  else{
			   document.form1.fCMTScodigo.value = '';
			   document.form1.fCMTSdescripcion.value = '';
			  }
			 }
			 
			function doConlisOC(valor) {
				popUpWindow("/cfmx/sif/cm/consultas/ConlisSolicitudesHasta.cfm?idx="+valor+"&Estado=0&index="+valor,100,150,800,450);
			}
			
			function traeSolicitud(value){
				if (value!=''){	   
					document.getElementById("fr").src = 'traerSolicitudHasta.cfm?ESnumero='+value+'&index='+value;
				}
				else{
					document.form1.ESidsolicitud1.value = '';
					document.form1.ESnumero1.value = '';
					document.form1.ESobservacion1.value = '';
					document.form1.ESidsolicitud2.value = '';
					document.form1.ESnumero2.value = '';
					document.form1.ESobservacion2.value = '';
				}
			}
			
			function limpiar() {
				document.form1.CMSid.value = "";
				document.form1.CMScodigo.value = "";
				document.form1.CMSnombre.value = "";
				document.form1.ESidsolicitud1.value = "";
				document.form1.ESnumero1.value = "";
				document.form1.ESobservacion1.value = "";
				document.form1.ESidsolicitud2.value = "";
				document.form1.ESnumero2.value = "";
				document.form1.ESobservacion2.value = "";
				document.form1.fechai.value = "";
				document.form1.fechaf.value = "";
				document.form1.fCFid.value = "";
				document.form1.LEstado.value = "";
				document.form1.CFcodigo.value = "";
				document.form1.CFdescripcion.value = "";
				document.form1.fCMTScodigo.value = "";
				document.form1.fCMTSdescripcion.value = "";				
				
			}
		</script>
		
		 <iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		 </cfoutput>	
		<cf_web_portlet_end>
	<cf_templatefooter>

