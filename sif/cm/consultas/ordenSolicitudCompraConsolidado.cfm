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

<cf_templateheader title="Saldos por Orden y Solicitud de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Saldos por Orden y Solicitud de Compra'>
		
		
	<cfoutput>
		<form method="post" name="form1" action="ordenSolicitudCompraConsolidado-form.cfm"> 
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
									<cf_web_portlet_start border="true" titulo="Consulta de Saldos por Orden y Solicitud de Compra" skin="info1">
										<div align="justify">
										  <p>Esta consulta muestra la informaci&oacute;n de las Ordenes de Compra que tienen items a&uacute;n pendientes de surtir.</p>
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
                            <tr>
							<td align="right" nowrap><strong>Moneda :</strong>&nbsp;</td>
							<td align="left">
          				    <cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1" Todas="S">
                            </td> 
						  	</tr>
							<tr>
							  <td align="right" nowrap><strong>Del Proveedor:</strong>&nbsp;</td>
							  <td nowrap><cf_sifsociosnegocios2  sntiposocio="P" tabindex="1" sncodigo="SNcodigoi" snnumero="SNnumeroi" snnombre="SNnombrei" frame="frame1"></td>
							  <td width="1%">&nbsp;</td>
						  	</tr>

							<tr>
							  <td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
							  <td nowrap> <cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" sncodigo="SNcodigof" snnumero="SNnumerof" snnombre="SNnombref" frame="frame2"></td>
							  <td width="1%">&nbsp;</td>
						  	</tr>

							<tr align="left">
							  <td width="50%" nowrap align="right"><strong>De la Fecha:</strong></div></td>
							  <td width="50%" nowrap><cf_sifcalendario name="fechai" value="" tabindex="1"></td>
							  <td width="1%">&nbsp;</td>
						    </tr>

							<tr align="left">
							  <td nowrap align="right"><strong>Hasta:</strong>&nbsp;</td>
							  <td width="50%" nowrap><div align="left"><cf_sifcalendario name="fechaf" value="" tabindex="1"></div></td>
							  <td width="1%">&nbsp;</td>
						    </tr>

							<tr align="left">
							  <td width="50%" nowrap align="right"><strong>De la Orden:</strong></td>
							  <td width="50%" nowrap>
								    <input type="hidden" name="EOidorden1" value="">
									<input type="text" size="10" name="EOnumero1" value="" onblur="javascript:traerOrdenHasta(this.value,1);">
									<input type="text" size="40" readonly name="Observaciones1" value="" >									
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(1);'></a>																		
								&nbsp;
							  </td>
							  <td width="1%">&nbsp;</td>
						    </tr>	

							<tr align="left">
							  <td nowrap align="right"><strong>&nbsp;Hasta:</strong>&nbsp;</td>
							  <td width="50%" nowrap>
									<input type="hidden" name="EOidorden2" value="">
									<input type="text" size="10" name="EOnumero2" value="" onblur="javascript:traerOrdenHasta(this.value,2);">
									<input type="text" size="40" readonly name="Observaciones2" value="" >									
									<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(2);'></a>
							  </td>
							  <td width="1%">&nbsp;</td>
                                
						    </tr>
                            <tr>
                             <td colspan="2%" align="center"><input type="CHECKBOX" name="sinCortes">Mostrar sin Cortes<BR></td>
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
			
			function doConlisOrdenesHasta(valor) {
				popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraHasta.cfm?idx="+valor+"&Estado=0",30,100,900,500);
			}
			
			function traerOrdenHasta(value, index){
			  if (value!=''){	   
			   document.getElementById("fr").src = 'traerOrdenHasta.cfm?EOnumero='+value+'&index='+index;
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
			 
			 function limpiar() {
				document.form1.SNcodigoi.value = "";
				document.form1.SNcodigof.value = "";
				document.form1.fechai.value = "";
				document.form1.fechaf.value = "";
				document.form1.SNnumeroi.value = "";
				document.form1.SNnumerof.value = "";
				document.form1.SNnombrei.value = "";
				document.form1.SNnombref.value = "";
				document.form1.EOidorden1.value = "";
				document.form1.EOnumero1.value = "";
				document.form1.Observaciones1.value="";
				document.form1.EOidorden2.value = "";
				document.form1.EOnumero2.value = "";
				document.form1.Observaciones2.value="";
			
			}
		</script>
		
		 <iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		 </cfoutput>	
		<cf_web_portlet_end>
	<cf_templatefooter>

