
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>


<cf_templateheader title="Compras - Consulta Seguimiento de Solicitudes Detallada">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Seguimiento de Solicitudes Detallada General'>
			
			<cfoutput>
			<cfset solicitante = -1 >
			<cfif isdefined("session.compras.solicitante") and len(trim(session.compras.solicitante))>
				<cfset solicitante = session.compras.solicitante >
			</cfif>	
            <form name="form1" method="post" action="SegSolDetGen-form.cfm" style="margin: 0"><!----onSubmit="return Valida()">----->
				 <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" >
				<input name="ESidsolicitud1" type="hidden" value="">
				<input name="ESidsolicitud2" type="hidden" value="">
				  <tr><td colspan="6"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				  <tr><td>&nbsp;
				  </td></tr>
				  <tr>
				  	<td>
				  		<table width="99%" align="center" border="0" cellspacing="2" cellpadding="2" class="areaFiltro">			
						  <tr>
                          	<td align="right" nowrap><strong> Solicitantes:</strong>&nbsp;</td>
                            <td>
                                <cf_conlis
                                campos="CMSid,CMScodigo,CMSnombre"
                                desplegables="N,S,S"
                                modificables="N,S,N"
                                size="0,15,40"
                                title="No hay listas"					
                                tabla="CMSolicitantes"
                                columnas="CMSid,CMScodigo,CMSnombre,Ecodigo"
                                filtro="Ecodigo = #session.Ecodigo#
                                		and CMSestado = 1
                                        order by CMSnombre"
                                desplegar="CMScodigo,CMSnombre"
                                filtrar_por="CMScodigo,CMSnombre"
                                etiquetas="Código,Nombre"
                                formatos="S,S"
                                align="left,left"
                                asignar="CMSid,CMScodigo,CMSnombre"
                                asignarformatos="I,S,S"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No hay solicitantes --"
                                tabindex="1"
                                form="form1"
                                conexion="#session.DSN#">	
                          	</td>
                          </tr>
                          <tr>
						    <td align="right" nowrap><strong> Desde:</strong>&nbsp;</td>
						    <td nowrap>
                              <input name="ESnumero1" type="text" value="" size="10" 
									onblur="javascript:traeSolicitud(this.value,1); fm(this,-1)"
									onFocus="javascript:this.value=qf(this); this.select();"  
									onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo N&deg; Solicitud">
                              <input name="ESobservacion1" type="text" value="" size="50" readonly="" disabled>
                            <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitudes" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOCHasta(1);'></a>                            </td>
						    <td align="right" nowrap><strong> Hasta:</strong>&nbsp;</td>
						    <td nowrap>
                              <input name="ESnumero2" type="text" value="" size="10" 
									onblur="javascript:traeSolicitud(this.value,2); fm(this,-1)"
									onFocus="javascript:this.value=qf(this); this.select();"  
									onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El campo N&deg; Solicitud">
                              <input name="ESobservacion2" type="text" value="" size="50" readonly="" disabled>
                            </td>
						    <td> <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitudes" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOCHasta(2);'></a> </td>
					      </tr>
						  <tr>
							<td align="right" nowrap class="fileLabel" ><strong>Fecha Desde:</strong></td>
							<td class="areaFiltro">
							  <table border="0">
								<tr>
								  <td nowrap>
									<cfif isdefined('form.fechaD')>
									  <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
									  <cfelse>
									  <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="">
									</cfif>
								  </td>
								  <td align="right" nowrap class="fileLabel">Fecha Hasta:</td>
								  <td nowrap>
									<cfif isdefined('form.fechaH')>
									  <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
									  <cfelse>
									  <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="">
									</cfif>
								  </td>
								</tr>
							</table>                    
							<td align="right" class="fileLabel" nowrap><label for="LEstado"><strong>Estado:</strong></label></td>
							<td nowrap class="fileLabel">
							  <select name="LEstado" id="LEstado">
								<option value="">- No especificado -</option>
								<!---<cfif isdefined('session.compras.solicitante') and len(trim(session.compras.solicitante))> --->
								<option value="0" <cfif isdefined('form.LEstado') and form.LEstado EQ 0>selected</cfif>>Pendiente</option>
								<option value="-10" <cfif isdefined('form.LEstado') and form.LEstado EQ -10>selected</cfif>>Rechazada por presupuesto</option>
								<option value="10" <cfif isdefined('form.LEstado') and form.LEstado EQ 10>selected</cfif>>En tr&aacute;mite de aprobaci&oacute;n</option>
								<!---</cfif> --->
								<option value="20" <cfif isdefined('form.LEstado') and form.LEstado EQ 20>selected</cfif>>Aplicada</option>
								<option value="25" <cfif isdefined('form.LEstado') and form.LEstado EQ 25>selected</cfif>>Orden de Compra Directa</option>
								<!---<option value="30" <cfif isdefined('form.LEstado') and form.LEstado EQ 30>selected</cfif>>Incluida en Publicaci&oacute;n</option>--->
								<option value="40" <cfif isdefined('form.LEstado') and form.LEstado EQ 40>selected</cfif>>Parcialmente Surtida</option>
								<option value="50" <cfif isdefined('form.LEstado') and form.LEstado EQ 50>selected</cfif>>Surtida</option>
								<option value="60" <cfif isdefined('form.LEstado') and form.LEstado EQ 60>selected</cfif>>Cancelada</option>
							  </select>
							</td>
							<td>&nbsp;</td>
						  </tr>
						  <tr>
							<td align="right" nowrap class="fileLabel">
							  <label for="fCFid"><strong>Ctro.Funcional:</strong></label>
							</td>
							<td nowrap class="fileLabel">
<!--- 							 <cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
								<cfquery name="rscfuncional" datasource="#Session.DSN#">
									select CFid as fCFid, CFcodigo, CFdescripcion 
									from CFuncional 
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									  and CFid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
								</cfquery>
									<cf_rhcfuncional id="fCFid" form="form1" query="#rscfuncional#">
							  <cfelse>
									<cf_rhcfuncional id="fCFid" form="form1">
							  </cfif> 
---> 							  
 						<table width="64%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<cfif isdefined("Form.fCFid") and Len(Trim(Form.fCFid))>
									<cfquery name="dataCF" datasource="#session.DSN#">
										select CFcodigo, CFdescripcion
										from CFuncional
										where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
									</cfquery>
									<td width="15%">#dataCF.CFcodigo# - #dataCF.CFdescripcion#</td>
									<input type="hidden" name="fCFid" value="#Form.fCFid#">
								<cfelse>
									<td width="16%">
										<input tabindex="1" type="text" name="CFcodigo" id="CFcodigo" value="" onblur="javascript: TraeCFuncional(this); " size="10" maxlength="10" onfocus="javascript:this.select();">
										<input type="hidden" name="fCFid" value="" >
									</td>
									<td width="47%">
										<input type="text" name="CFdescripcion" id="CFdescripcion" disabled value="" 
											size="30" maxlength="80" tabindex="1">
									</td>
									<TD width="22%"><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCFuncional();'></a></TD>
								</cfif>
							</tr>
						</table>	 					  
							  
							</td>
							<td align="right" nowrap class="fileLabel"><label for="fTipoSolicitud"><strong>Tipo:</strong></label></td>
							<td class="areaFiltro"><table>
								<tr>
								  <td width="73%" nowrap> <cfoutput>
									  <input name="fCMTScodigo" type="text" value="<cfif isDefined("form.fCMTScodigo")><cfoutput>#form.fCMTScodigo#</cfoutput></cfif>"  id="fCMTScodigo" size="5" maxlength="5" tabindex="-1" onBlur="javascript:traerTSolicitud(this.value,1);">
									  <input name="fCMTSdescripcion" type="text" id="fCMTSdescripcion" value="<cfif isDefined("form.fCMTSdescripcion")><cfoutput>#form.fCMTSdescripcion#</cfoutput></cfif>" size="40" readonly>
									  <a href="##" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de tipos de solicitud" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTSolicitudes();"> </a> </cfoutput> </td>
							  </tr>
								</table></td>
							<td>
								<input type="submit" name="btnFiltro" value="Filtrar">
								<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript:limpiar()">
							</td>
						  </tr>
						</table>
					</td>  
				</tr>
			</table>

			</form>
			</cfoutput>		
			
			<script language="JavaScript" type="text/javascript">	
				function doConlisCFuncional() {
					var params ="";
					params = "?CMSid=<cfoutput>#solicitante#</cfoutput>&form=form1&id=fCFid&name=CFcodigo&desc=CFdescripcion";
					popUpWindow2("/cfmx/sif/cm/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
				}
				//Obtiene la descripción con base al código
				function TraeCFuncional(dato) {
					var params ="";
					params = "&CMCid=<cfoutput>#session.compras.comprador#</cfoutput>&id=fCFid&name=CFcodigo&desc=CFdescripcion";
					if (dato.value != "") {
						document.getElementById("fr").src="/cfmx/sif/cm/operacion/cfuncionalquery.cfm?dato="+dato.value+"&form=form1"+params;
					}
					else{
						document.form1.fCFid.value = "";
						document.form1.CFcodigo.value = "";
						document.form1.CFdescripcion.value = "";
					}
					return;
				}					
				/*function Valida(){					
					if(document.form1.ESnumero1.value == ''){
						alert("El campo  N°. Solicitud Desde es requerido");
						return false;
					}
				}*/
			
				 var popUpWin2 = 0;
				 function popUpWindow2(URLStr, left, top, width, height){
				  if(popUpWin2){
				   if(!popUpWin2.closed) popUpWin2.close();
				  }
				  popUpWin2 = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				 }
				
				//Funcion del conlis de tipos de solicitud
				function doConlisTSolicitudes() {
					popUpWindow2("../operacion/conlisTSolicitudesSolicitante.cfm?formulario=form1",250,150,550,400);
				}
				function doConlisOCHasta(valor) {
					var CMSid = document.form1.CMSid.value;
					popUpWindow2("/cfmx/sif/cm/consultas/ConlisSolicitudesDet.cfm?idx="+valor+"&CMSid="+CMSid,10,150,1000,450);
				}
				 
				function traeSolicitud(value,valor){
				  if (value!=''){
				 	   document.getElementById("fr").src = 'traerSolicitudDetGen.cfm?ESnumero='+value+'&idx='+valor;
				 }
				  else{
						if (valor == 1){
						   document.form1.ESidsolicitud1.value = '';
						   document.form1.ESnumero1.value = '';
						   document.form1.ESobservacion1.value = '';
						}
						else {
							document.form1.ESidsolicitud2.value = '';
							document.form1.ESnumero2.value = '';
							document.form1.ESobservacion2.value = '';
						}
				  }
				 }
				 
				 function limpiar(){
					document.form1.ESidsolicitud1.value = '';
					document.form1.ESnumero1.value = '';
					document.form1.ESobservacion1.value = '';
					document.form1.ESidsolicitud2.value = '';
					document.form1.ESnumero2.value = '';
					document.form1.ESobservacion2.value = '';
					document.form1.fechaD.value = '';
					document.form1.fechaH.value = '';
					document.form1.LEstado.value = '';
					document.form1.fCFid.value = '';
					document.form1.CFcodigo.value = '';
					document.form1.CFdescripcion.value = '';
					document.form1.fCMTScodigo.value = '';
					document.form1.fCMTSdescripcion.value = '';
				 }
				 
			</script>	
			<!--- Iframe que contiene el sql que trae los datos de la solicitud cuando se ha digitado No seleccionado un ESnumero --->
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>