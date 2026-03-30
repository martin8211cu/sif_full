<!---    Combo de tipos de solicitud de compra --->
<cfquery name="rsTiposSolicitud" datasource="#session.DSN#">
	select CMTScodigo, CMTSdescripcion
	from 	CMTiposSolicitud
	where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Mcodigo, Mnombre 
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}
			
			function doConlisOrdenesHasta(valor) {
				popUpWindow("/cfmx/sif/cm/consultas/ConlisOCHastaNoAplic.cfm?idx="+valor+"&Estado=0",30,100,900,500);
			}
						
		</script>
<script language="JavaScript">
	function limpiar() {
		document.form1.Usucodigo.value = '';
		document.form1.fEDRnumeroD.value = '';
		document.form1.fEDRnumeroH.value = '';
		document.form1.EOnumero1.value = '';
		document.form1.EOnumero2.value = '';
		document.form1.fechaD.value = '';
		document.form1.fechaH.value = '';
		document.form1.Nombre.value = '';
		document.form1.fTDRtipo.value = 'T';
		document.form1.Observaciones1 .value = '';
		document.form1.Observaciones2.value = '';
	}
</script>

<cf_templateheader title="Consulta de Recepción de Mercaderia (por lote)">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recepci&oacute;n de Mercadería (por Aplicar)'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
			<!---****  Si los filtros vienen por URL (cambio de pagina) los carga en el form ---->
			<cfif isdefined("url.fEDRnumeroD") and not isdefined("form.fEDRnumeroD") >
				<cfset form.fEDRnumeroD = url.fEDRnumeroD >
			</cfif>
			<cfif isdefined("url.fEDRnumeroH") and not isdefined("form.fEDRnumeroH") >
				<cfset form.fEDRnumeroH = url.fEDRnumeroH >
			</cfif>
			<cfif isdefined("url.fechaD") and not isdefined("form.fechaD") >
				<cfset form.fechaD = url.fechaD >
			</cfif>
			
			<cfif isdefined("url.fechaH") and not isdefined("form.fechaH") >
				<cfset form.fechaH = url.fechaH >
			</cfif>
			
			<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo") >
				<cfset form.Mcodigo = url.Mcodigo >
			</cfif>
			
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
      				<td>
						<form style="margin: 0" action="RecepMerc-vistaNoAplic.cfm" name="form1" method="post">
					      <table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                            <tr>
                              <td align="right" nowrap><strong>Del N&uacute;mero:</strong></td>
                              <td align="left" nowrap>
                                  <input type="text" name="fEDRnumeroD" size="20" maxlength="100" value="<cfif isdefined('form.fEDRnumeroD')><cfoutput>#form.fEDRnumeroD#</cfoutput></cfif>" onFocus='this.select();' >
							  </td>
                              <td align="right" nowrap>
                                <strong>Hasta:</strong>
                              </td>
                              <td colspan="2" align="left" nowrap>
                                    <input type="text" name="fEDRnumeroH" size="20" maxlength="100" value="<cfif isdefined('form.fEDRnumeroH')><cfoutput>#form.fEDRnumeroH#</cfoutput></cfif>" onFocus='this.select();' >
                              </td>
                              <td align="center">&nbsp;</td>
                            </tr>
                            <tr>
                              <td align="right" nowrap><div align="right"><strong>De la Orden:</strong></div></td>
                              <td align="left" nowrap>
                                <div align="left">
                                  <input type="hidden" name="EOidorden1" value="">
                                  <input type="text" size="10" name="EOnumero1" value="" onBlur="javascript:traerOrdenHasta(this.value,1);" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus='this.select();'>
                                  <input type="text" size="40" readonly name="Observaciones1" value="" >
                                  <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(1);'></a> &nbsp; </div></td>
                              <td align="right" nowrap><div align="right"><strong>&nbsp;Hasta:</strong></div></td>
                              <td colspan="2" align="left" nowrap>
                                <div align="left">
                                  <input type="hidden" name="EOidorden2" value="">
                                  <input type="text" size="10" name="EOnumero2" value="" onBlur="javascript:traerOrdenHasta(this.value,2);" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus='this.select();'>
                                  <input type="text" size="40" readonly name="Observaciones2" value="" >
                                  <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(2);'></a></div></td>
                              <td align="center">&nbsp;</td>
                            </tr>
                            <tr>
                              <td align="right" nowrap><div align="right"><strong>Fecha Desde:</strong></div></td>
                              <td align="right" nowrap>
                                <div align="left">
                                  <cfif isdefined('form.fechaD')>
                                    <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
                                    <cfelse>
                                    <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="">
                                  </cfif>
                              </div></td>
                              <td align="right"  nowrap><div align="right"><strong>Fecha Hasta:</strong></div></td>
                              <td colspan="1" align="right" nowrap>
                                <div align="left">
                                  <cfif isdefined('form.fechaH')>
                                    <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
                                    <cfelse>
                                    <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="">
                                  </cfif>
                              </div></td>
							  <td align="right"><strong>Moneda:</strong></td>
                              <td align="center" nowrap class="fileLabel">
							  	<cfoutput>
								<select name="Mcodigo" id="Mcodigo">
									<option value="">--- Todas ---</option> 
										<cfloop query="rsMonedas">
											<option value="#rsMonedas.Mcodigo#" <cfif isdefined("form.Mcodigo") and rsMonedas.Mcodigo EQ form.Mcodigo>selected</cfif>>#HTMLEditFormat(rsMonedas.Mnombre)#</option>
										</cfloop>
								</select>
								</cfoutput>
							  </td>
                            </tr>
							  <tr>
								<td align="right"><strong>Solicitante</strong></td>
								<td>
								  <cfif not isdefined("form.Usucodigo")>
									<cf_sifusuarioE conlis="true" form="form1" idusuario="#session.Usucodigo#" size="40"  frame="frame1">
									<cfelse>
									<cf_sifusuarioE form="form1" idusuario="#form.Usucodigo#" size="40"  frame="frame1">
								  </cfif>
								</td>
								<td align="right" nowrap><strong>Tipo:&nbsp;</strong></td>
								  <td nowrap>
									<select name="fTDRtipo" >
									  <option value="T" <cfif isdefined("form.fTDRtipo") and form.fTDRtipo eq 'T'>selected</cfif> >Todos</option>
									  <option value="R" <cfif isdefined("form.fTDRtipo") and form.fTDRtipo eq 'R'>selected</cfif> >Recepci&oacute;n</option>
									  <option value="D" <cfif isdefined("form.fTDRtipo") and form.fTDRtipo  eq 'D'>selected</cfif>>Devoluci&oacute;n</option>
									</select>      </td>
								  <td align="right" nowrap>&nbsp;</td>
								  <td align="center" nowrap class="fileLabel">&nbsp;</td>
							  </tr>
							  <tr>
								<td id="socio" colspan="6">
								  <input type="hidden" name="socio" value="<cfif isdefined('form.socio')>#form.socio#</cfif>" >
								</td>
							  </tr>
							  <tr>
								<td colspan="6" align="center">
								  <input type="submit" name="btnFiltro"  value="Consultar">
								  <input name="btnLimpiar" type="button" id="btnLimpiar3" value="Limpiar" onClick="javascript:limpiar();">
								</td>
							  </tr>
							  <tr>
							  	<td>&nbsp;</td>
							  </tr>
                          </table>
						</form>
					</td>
				</tr>
			</table>
			 <script language="JavaScript" type="text/javascript">		 			
			function traerOrdenHasta(value, index){
			  if (value!=''){	   
			   document.getElementById("fr").src = 'traerOrdenHastaNoAplic.cfm?EOnumero='+value+'&index='+index;
			  }
			  else{
			   document.form1.EOidorden1.value = '';
			   document.form1.EOnumero1.value = '';
			   document.form1.Observaciones1.value = '';
			   document.form1.EOidorden2.value = '';
			   document.form1.EOnumero2.value = '';
			   document.form1.Observaciones2.value = '';
			  }
			 }	 
		</script>	
			<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>

