<!---- Con lis Ordenes ---->
<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisOrdenesHasta(valor) {
		popUpWindow("/cfmx/sif/cm/consultas/ConlisOrdenCompraHasta.cfm?idx="+valor+"&Estado=1",30,100,900,500);
	}		
		
	function traerOrdenHasta(value, index){
		if (value!='')
		{
			document.getElementById("fr").src = 'traerOrdenHasta.cfm?EOnumero='+value+'&index='+index;
		}
		else{
			if(index == 1)
			{
				document.form1.EOidorden1.value = '';
				document.form1.EOnumero1.value = '';
				document.form1.Observaciones1.value = '';
			}
			else if(index == 2)
			{
				document.form1.EOidorden2.value = '';
				document.form1.EOnumero2.value = '';
				document.form1.Observaciones2.value = '';
			}
		}
	}
</script>

<cf_templateheader title="Consulta de Recepción de Mercaderia">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recepcion de Mercadería'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">

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
			
			<cfif isdefined("url.LEstado") and not isdefined("form.LEstado") >
				<cfset form.LEstado = url.LEstado >
			</cfif>
			
			<cfif isdefined("url.CFid") and not isdefined("form.CFid") >
				<cfset form.CFid = url.CFid >
			</cfif>		
			
			<cfif isdefined("url.Aid") and not isdefined("form.Aid") >
				<cfset form.Aid = url.Aid >
			</cfif>
			
			<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo") >
				<cfset form.SNcodigo = url.SNcodigo >
			</cfif>
			
			<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo") >
				<cfset form.Usucodigo = url.Usucodigo >
			</cfif>
			
			<cfif isdefined("url.EDRestado") and not isdefined("form.EDRestado") >
				<cfset form.EDRestado = url.EDRestado >
			</cfif>			
				
			<!----  Filtros del Conlis de Ordenes ----->
			<cfif isdefined("url.EOidorden1") and not isdefined("form.EOidorden1") >
				<cfset form.EOidorden1 = url.EOidorden1 >
			</cfif>
			
			<cfif isdefined("url.EOidorden2") and not isdefined("form.EOidorden2") >
				<cfset form.EOidorden2 = url.EOidorden2 >
			</cfif>
			
			<cfif isdefined("url.EOnumero1") and not isdefined("form.EOnumero1") >
				<cfset form.EOnumero1 = url.EOnumero1 >
			</cfif>
			
			<cfif isdefined("url.EOnumero2") and not isdefined("form.EOnumero2") >
				<cfset form.EOnumero2 = url.EOnumero2 >
			</cfif>
			
			<cfif isdefined("url.Observaciones1") and not isdefined("form.Observaciones1") >
				<cfset form.Observaciones1 = url.Observaciones1>
			</cfif>
			
			<cfif isdefined("url.Observaciones2") and not isdefined("form.Observaciones2") >
				<cfset form.Observaciones2 = url.Observaciones2 >
			</cfif>
			
			<!--- Filtros del Proveedor ---->
			<cfif isdefined("Url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
				<cfset form.SNcodigo = url.SNcodigo>				
			</cfif>
			
			<cfif isdefined("Url.SNnumero") and len(trim(url.SNnumero)) and not isdefined("form.SNnumero")>
				<cfset form.SNnumero = url.SNnumero>				
			</cfif>
			
			<cfif isdefined("Url.SNnombre") and len(trim(url.SNnombre)) and not isdefined("form.SNnombre")>
				<cfset form.SNnombre = url.SNnombre>								
			</cfif>
			
			<cfif isdefined("Url.Usucodigo") and len(trim(url.Usucodigo)) and not isdefined("form.Usucodigo")>
				<cfset form.Usucodigo = url.Usucodigo>								
			</cfif>
			
			<cfif isdefined("Url.fTDRtipo") and len(trim(url.fTDRtipo)) and not isdefined("form.fTDRtipo")>
				<cfset form.fTDRtipo = url.fTDRtipo>				
			</cfif>
												
			<!--- *** Asigna a la variable navegacion los filtros  --->
			<cfset navegacion = "">
			<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) >
				<cfset navegacion = navegacion & "&fEDRnumeroD=#form.fEDRnumeroD#">
			</cfif>
			
			<cfif isdefined("form.EDRestado") and len(trim(form.EDRestado)) >
				<cfset navegacion = navegacion & "&EDRestado=#form.EDRestado#">
			</cfif>
			
			<cfif isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH)) >
				<cfset navegacion = navegacion & "&fEDRnumeroH=#form.fEDRnumeroH#">
			</cfif>

			<cfif isdefined("Form.LTipos") and len(trim(form.LTipos)) >
				<cfset navegacion = navegacion & "&LTipos=#form.LTipos#">
			</cfif>

			<cfif isdefined("Form.fechaD") and len(trim(form.fechaD)) >
				<cfset navegacion = navegacion & "&fechaD=#form.fechaD#">
			</cfif>
			
			<cfif isdefined("Form.fechaH") and len(trim(form.fechaH)) >
				<cfset navegacion = navegacion & "&fechaH=#form.fechaH#">
			</cfif>
			
			<cfif isdefined("Form.LEstado") and len(trim(form.LEstado))>
				<cfset navegacion = navegacion & "&LEstado=#form.LEstado#">
			</cfif>

			<cfif isdefined("Form.CFid") and len(trim(form.CFid))>
				<cfset navegacion = navegacion & "&CFid=#form.CFid#">
			</cfif>
			
			<cfif isdefined("Form.Aid") and len(trim(form.Aid))>
				<cfset navegacion = navegacion & "&Aid=#form.Aid#">
			</cfif>
			
			<cfif isdefined("form.Usucodigo")>
				<cfset navegacion = navegacion & "&Usucodigo=#form.Usucodigo#">
			</cfif>
			
			<!--- Variables de navegacion de los conlis de Ordenes ---->
			<cfif isdefined("Form.EOidorden1") and len(trim(form.EOidorden1))>
				<cfset navegacion = navegacion & "&EOidorden1=#form.EOidorden1#">
			</cfif>
			
			<cfif isdefined("Form.EOidorden2") and len(trim(form.EOidorden2))>
				<cfset navegacion = navegacion & "&EOidorden2=#form.EOidorden2#">
			</cfif>
			
			<cfif isdefined("Form.EOnumero1") and len(trim(form.EOnumero1))>
				<cfset navegacion = navegacion & "&EOnumero1=#form.EOnumero1#">
			</cfif>
			
			<cfif isdefined("Form.EOnumero2") and len(trim(form.EOnumero2))>
				<cfset navegacion = navegacion & "&EOnumero2=#form.EOnumero2#">
			</cfif>
			
			<cfif isdefined("Form.Observaciones1") and len(trim(form.Observaciones1))>
				<cfset navegacion = navegacion & "&Observaciones1=#form.Observaciones1#">
			</cfif>
			
			<cfif isdefined("Form.Observaciones2") and len(trim(form.Observaciones2))>
				<cfset navegacion = navegacion & "&Observaciones2=#form.Observaciones2#">
			</cfif>
			
			<cfif isdefined("Form.fTDRtipo") and len(trim(form.fTDRtipo))>
				<cfset navegacion = navegacion & "&fTDRtipo=#form.fTDRtipo#">				
			</cfif>
			
			<!---- Navegacion de proveedores---->
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) >
				<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
			</cfif>
			
			<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero)) >
				<cfset navegacion = navegacion & "&SNnumero=#form.SNnumero#">
			</cfif>
				
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre)) >
				<cfset navegacion = navegacion & "&SNnombre=#form.SNnombre#">
			</cfif>		
									
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
      				<td>
						<form style="margin: 0" action="RecepMerc-lista.cfm" name="form1" method="post">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">									
								<tr>
									<td>
										<table width="98%">
											<tr>
									<!---- FILA NUMERO 1 ---->	  		
												<td width="110" nowrap align="right">
													<label for="Usucodigo"><strong>Usuario:&nbsp;</strong></label>
												</td>
												<td width="131">
													<cfif not isdefined("form.Usucodigo")>
                                              			<cf_sifusuarioE conlis="true" form="form1" idusuario="#session.Usucodigo#" size="40"  frame="frame1">
													<cfelseif len(trim(form.Usucodigo)) eq 0>
														<cf_sifusuarioE conlis="true" form="form1" size="40"  frame="frame1">
                                              		<cfelse>
                                              			<cf_sifusuarioE form="form1" idusuario="#form.Usucodigo#" size="40"  frame="frame1">
                                            		</cfif>
												</td>
												<td><table><tr>											
													<td nowrap class="fileLabel">
														<label for="fEDRnumeroD"><strong>Del N&uacute;mero:&nbsp;</strong></label>
														<input type="text" name="fEDRnumeroD" size="20" maxlength="100" value="<cfif isdefined('form.fEDRnumeroD')><cfoutput>#form.fEDRnumeroD#</cfoutput></cfif>" onFocus='this.select();' >
													</td>
													<td width="405"  nowrap class="fileLabel">
														<label for="fEDRnumeroH"><strong>Al N&uacute;mero:&nbsp;</strong></label>
														<input type="text" name="fEDRnumeroH" size="20" maxlength="100" value="<cfif isdefined('form.fEDRnumeroH')><cfoutput>#form.fEDRnumeroH#</cfoutput></cfif>" onFocus='this.select();' >
														&nbsp;&nbsp;<input type="submit" name="btnFiltro"  value="Filtrar">	
														&nbsp;&nbsp;<input name="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onClick="javascript:limpiar();">
													</td>
												</tr></table>	
												
                                       		</tr>
									<!---- FILA NUMERO 2 ------->
											<tr>
												<td width="110" nowrap align="right">
													<strong>&nbsp;&nbsp;Fecha Desde:&nbsp;</strong>
												</td>
												<td width="131" >
													<cfif isdefined('form.fechaD')>
													  <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="#form.fechaD#">
													  <cfelse>
													  <cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaD" value="">
													</cfif>
												</td>
												<td  nowrap>
												<table><tr>
													<td nowrap>
														<strong>Fecha Hasta:</strong>
													</td> 
													<td width="114" >
													  <cfif isdefined('form.fechaH')>
														<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="#form.fechaH#">
														<cfelse>
														<cf_sifcalendario conexion="#session.DSN#" form="form1" name="fechaH" value="">
													  </cfif>
													</td>
													<td nowrap>
														<label for="fCentroFuncional"><strong>Proveedor:&nbsp;</strong></label>
													</td>
													<td nowrap>
														<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>														
															<cfquery name="rsSocio" datasource="#session.DSN#">
																select SNcodigo, SNnumero, SNnombre
																from SNegocios 
																where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
																	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
															</cfquery>														
															<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="30" idquery="#rsSocio.SNcodigo#">																												
														<cfelse>
															<cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="30">
														</cfif>
													</td>

												</tr></table>																
												<td nowrap>
									 		</tr>	   
									<!---- FILA NUMERO 3---->			
											<TR>
												<td nowrap align="right">
													<label for="Almacen"><strong>Almac&eacute;n:&nbsp;</strong></label>
												</td>
												<td >
												  <cfif isdefined("form.Aid") and len(trim(form.Aid))>
													<cf_sifalmacen id="#form.Aid#"  size="20" Aid="Aid">
													<cfelse>
													<cf_sifalmacen size="20" Aid="Aid">
												  </cfif>
												</td>
												<td nowrap>
												  <table width="596">
												    <tr>
													<td width="19%">
														<label for="CFid"><strong>Ctro.Funcional:&nbsp;</strong></label>
													</td>
													<td width="53%" >
													  <cfif isdefined("form.CFid") and len(trim(form.CFid))>
														  <cfquery name="rsCtroFuncional" datasource="#session.DSN#">
															  select CFid, CFcodigo, CFdescripcion
																from CFuncional
																where Ecodigo = 
															  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																and CFid = 
																<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
														  </cfquery>
														  <cf_rhcfuncional id="CFid" tabindex="1" query="#rsCtroFuncional#" size="30">
														<cfelse>
														  <cf_rhcfuncional id="CFid" tabindex="1" size="30">
													  </cfif>
													</td>
													<td width="28%" nowrap >&nbsp;&nbsp;<strong>Tipo:&nbsp;</strong>
														<select name="fTDRtipo" >
														  <option value="T" <cfif isdefined("form.fTDRtipo") and form.fTDRtipo eq 'T'>selected</cfif> >Todos</option>
														  <option value="R" <cfif isdefined("form.fTDRtipo") and form.fTDRtipo eq 'R'>selected</cfif> >Recepci&oacute;n</option>
														  <option value="D" <cfif isdefined("form.fTDRtipo") and form.fTDRtipo  eq 'D'>selected</cfif>>Devoluci&oacute;n</option>
														</select>
													</td>
												  </tr></table>
												</td>	
												
											</tr>								
								<!---- FILA NUMERO 4 ------>
											<tr>										  
												<td nowrap align="right">
													<label for="fEDRnumeroD"><strong>De la Orden:&nbsp;</strong></label>
												</td>
												<td nowrap>
													<input type="hidden" name="EOidorden1" value="<cfif isdefined("form.EOidorden1")><cfoutput>#form.EOidorden1#</cfoutput></cfif>">
													<input type="text" size="10" name="EOnumero1" value="<cfif isdefined("form.EOnumero1")><cfoutput>#form.EOnumero1#</cfoutput></cfif>" 
														onblur="javascript:traerOrdenHasta(this.value,1);">
													<input type="text" size="30" readonly name="Observaciones1" value="<cfif isdefined("form.Observaciones1")><cfoutput>#form.Observaciones1#</cfoutput></cfif>" >
													<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(1);'></a>
												</td>
																								
												<td  nowrap colspan="2">
													<table width="422">
													  <tr>
														<td width="90" nowrap align="right">
															<label for="fEDRnumeroH"><strong>&nbsp;A la Orden:&nbsp;</strong></label>
														</td>
														<td width="320" nowrap>
															<input type="text" size="10" name="EOnumero2" value="<cfif isdefined("form.EOnumero2")><cfoutput>#form.EOnumero2#</cfoutput></cfif>" 
																onblur="javascript:traerOrdenHasta(this.value,2);">
															<input type="text" size="30" readonly name="Observaciones2" value="<cfif isdefined("form.Observaciones2")><cfoutput>#form.Observaciones2#</cfoutput></cfif>">
															<input type="hidden" name="EOidorden2" value="<cfif isdefined("form.EOidorden2")><cfoutput>#form.EOidorden2#</cfoutput></cfif>">
															<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisOrdenesHasta(2);'></a>
														</td>
														<td nowrap ><strong>Estado :&nbsp;</strong>
															<!--- Obtiene el valor del parámetro de Aprobación de Excesos de Tolerancia por Compradores --->
															<cfquery name="rsParametroTolerancia" datasource="#session.dsn#">
																select Pvalor
																from Parametros
																where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																	and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="760">
															</cfquery>
															<select name="EDRestado" >
															  <option value="T" selected>---  No Especificado  ---</option>
															  <option value="10" <cfif isdefined("form.EDRestado") and form.EDRestado eq '10'>selected</cfif> >Aplicadas</option>
															  <option value="0" <cfif isdefined("form.EDRestado") and form.EDRestado eq '0'>selected</cfif> >No Aplicadas</option>
															  <cfif rsParametroTolerancia.RecordCount gt 0 and rsParametroTolerancia.Pvalor eq 1>
																  <option value="-5" <cfif isdefined("form.EDRestado") and form.EDRestado eq '-5'>selected</cfif>>En Aprobación de Tolerancia</option>
																  <option value="5" <cfif isdefined("form.EDRestado") and form.EDRestado eq '5'>selected</cfif>>Tolerancia Aprobada</option>
															  </cfif>
															</select>
														</td>
												  </tr></table>
											  </td>
											</tr>
										</table>
									</td>
								</tr>		
							</table>
		  				</form>
                        <cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select	a.EDRid,
									a.EDRnumero,
									a.EDRfecharec,
									d.SNnumero #_Cat#'-'#_Cat# d.SNnombre as Socio,
									e.Mnombre,
									g.CPTdescripcion,
									f.EOnumero,
									f.DOconsecutivo,
									coalesce(b.DDRtotallincd, 0.00) + coalesce(b.DDRmtoimpfact, 0.00) as DDRtotallin,
									case	when tdr.TDRtipo = 'R' then 'Recepcion' 
											when tdr.TDRtipo = 'D' then 'Devolucion' end as tipo,
									g.CPTcodigo #_Cat# '-' #_Cat# g.CPTdescripcion as TipoDoc
									
							from EDocumentosRecepcion a			
												
								inner join TipoDocumentoR tdr
							    	on a.TDRcodigo = tdr.TDRcodigo
					 		    	and a.Ecodigo = tdr.Ecodigo
									
								inner join Monedas e
									on a.Mcodigo = e.Mcodigo
									and a.Ecodigo = e.Ecodigo	
							
								inner join SNegocios d
									on a.SNcodigo = d.SNcodigo
									and a.Ecodigo = d.Ecodigo
							
								left outer join CPTransacciones g
									on a.CPTcodigo = g.CPTcodigo
									and a.Ecodigo = g.Ecodigo
							
								left outer join DDocumentosRecepcion b
																		
									inner join DOrdenCM f														
										on b.DOlinea = f.DOlinea	
										
										inner join EOrdenCM eo
											on eo.EOidorden = f.EOidorden
						
								on a.EDRid = b.EDRid
								and a.Ecodigo = b.Ecodigo
							
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

							<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and (isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))) >
								<cfif form.fEDRnumeroD  GT form.fEDRnumeroH>
								 	and a.EDRnumero between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fEDRnumeroH#">
									and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fEDRnumeroD#">
								<cfelseif form.fEDRnumeroD EQ form.fEDRnumeroH>
									and a.EDRnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fEDRnumeroD#">
								<cfelse>
										and a.EDRnumero between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fEDRnumeroD#">
										and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fEDRnumeroH#">
								</cfif>
							</cfif>
							<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and not (isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))) >
									and a.EDRnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
							</cfif>
							<cfif isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH)) and not (isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD))) >
									and a.EDRnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
							</cfif>

							<!--- Filtros de conlises ---->														
							<cfif isdefined("Form.CFid") and len(trim(Form.CFid)) >
								and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
							</cfif>
							
							<cfif isdefined("Form.Aid") and len(trim(Form.Aid)) >
								and a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
							</cfif>
							
							<cfif isdefined("Form.Usucodigo") and len(trim(Form.Usucodigo))>
								and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
							<cfelseif not isdefined("Form.Usucodigo")>
								and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							</cfif>
							
							<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and (isdefined("form.EOnumero2") and len(trim(form.EOnumero2))) >
								<cfif form.EOnumero1 GT form.EOnumero2>
								 	and eo.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
									and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
								<cfelseif form.EOnumero1 EQ form.EOnumero2>
									and eo.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
								<cfelse>
										and eo.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
										and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
								</cfif>
							</cfif>
							<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and not (isdefined("form.EOnumero2") and len(trim(form.EOnumero2))) >
									and eo.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
							</cfif>
							<cfif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and not (isdefined("form.EOnumero1") and len(trim(form.EOnumero1))) >
									and eo.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
							</cfif>
							
							<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
								<cfif form.fechaD EQ form.fechaH>
									and a.EDRfecharec = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
								<cfelse>
									and a.EDRfecharec between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
									and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
								</cfif>
							</cfif>

							<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
								and a.EDRfecharec >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
							</cfif>

							<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
								and a.EDRfecharec <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
							</cfif>
							
							<cfif isdefined("Form.fTDRtipo") and Form.fTDRtipo  NEQ 'T'>
								and tdr.TDRtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fTDRtipo#">
							</cfif>
							
							<cfif isdefined("Form.EDRestado") and Form.EDRestado  NEQ 'T'>
								and a.EDRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EDRestado#">
							</cfif>
							
							<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) gt 0>
								and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
							</cfif>

							order by EDRfecharec desc, TipoDoc, EDRnumero
						</cfquery>
	
						<cfinvoke 
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="cortes" value="TipoDoc"/>
							<cfinvokeargument name="desplegar" value="EDRnumero, EOnumero, DOconsecutivo, EDRfecharec, tipo, Socio, DDRtotallin, Mnombre"/>
							<cfinvokeargument name="etiquetas" value="N&uacute;mero, Orden, Línea, Fecha de Recepci&oacute;n, Tipo, Proveedor, Monto, Moneda"/>
							<cfinvokeargument name="formatos" value="V, V, V, D, V, V, M, V"/>
							<cfinvokeargument name="align" value="left, left, left, left, left, left, right, right"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="RecepMerc-lista.cfm "/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="EDRid"/>
							<cfinvokeargument name="funcion" value="doConlis"/>
							<cfinvokeargument name="fparams" value="EDRid"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/> 
							<cfinvokeargument name="debug" value="N"/>
						</cfinvoke>
						
					</td>
				</tr>
			</table>

<script language='JavaScript' type='text/JavaScript' src='/cfmx/sif/js/qForms/qforms.js'></script>
<script language='javascript' type='text/JavaScript' >
	function limpiar(){
			document.form1.fEDRnumeroD.value = '';
			document.form1.fEDRnumeroH.value = '';
			document.form1.fechaD.value = '';
			document.form1.fechaH.value = '';
			document.form1.CFid.value = '';
			document.form1.CFcodigo.value = '';
			document.form1.CFdescripcion.value = '';
			document.form1.Aid.value = '';
			document.form1.Almcodigo.value = '';
			document.form1.Bdescripcion.value = '';
			document.form1.Usucodigo.value = '';
			document.form1.Nombre.value = '';
			document.form1.EOidorden1.value = '';
			document.form1.EOidorden2.value = '';
			document.form1.EOnumero1.value = '';
			document.form1.EOnumero2.value = '';
			document.form1.Observaciones1.value = '';
			document.form1.Observaciones2.value = '';
			document.form1.fTDRtipo.value = 'T';
			document.form1.SNnumero.value = '';
			document.form1.SNnombre.value = '';
			document.form1.SNcodigo.value = '';
			document.form1.EDRestado.value = 'T';
	}
</script>

<script language='javascript' type='text/JavaScript' >
<!--//
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis(valor) {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/RecepMerc-vista.cfm?&EDRid="+valor,20,20,950,600);
	}

	<cfif isdefined("Regresar")>
		function funcRegresar(){
			location.href = "<cfoutput>#Regresar#</cfoutput>";
			return true;
		}
	</cfif>
//-->
</script>
		<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>
		<cf_web_portlet_end>
	<cf_templatefooter>
