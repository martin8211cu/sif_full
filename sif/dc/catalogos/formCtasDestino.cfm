<cfif isdefined("url.IDgd") and len(trim(url.IDgd)) and not isdefined("form.IDgd")>
	<cfset form.IDgd = url.IDgd>
</cfif>
<cfif isdefined("url.IDdistribucion") 
      and len(trim(url.IDdistribucion)) 
	  and not isdefined("form.IDdistribucion") 
	  and form.tab eq 3>
	<cfset form.IDdistribucion = url.IDdistribucion>
</cfif>
<cfif isdefined("url.Id") and len(trim(url.Id)) and not isdefined("form.id") and form.tab eq 3>
	<cfset form.id = url.id>
</cfif>

<cfset modo="ALTA">
<cfif isdefined("form.Id") and len(trim(form.Id)) and form.tab eq 3>
	<cfset modo="CAMBIO">
</cfif>


<cfquery datasource="#Session.DSN#" name="rsOrigenes">
select Oorigen,Odescripcion from Origenes 
</cfquery>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		Select	A.Id,	A.IDdistribucion, A.Ocodigo, C.Oficodigo,	CDformato, CDcomplemento, CDporcentaje,	CDexcluir,	A.ts_rversion, B.Tipo
		from DCCtasDestino A, DCDistribucion B, Oficinas C
		where A.IDdistribucion = B.IDdistribucion
		  and A.Ecodigo = B.Ecodigo
		  and A.Ocodigo = C.Ocodigo
		  and A.Ecodigo = C.Ecodigo
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and A.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
		  and A.Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
	</cfquery>
</cfif>


<table width="100%"  border="0" cellspacing="2" cellpadding="0">
  <tr>
	<td valign="top" nowrap>
					
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 

					<cfset checked = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
					<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
					<cfset LvarTam01 = 70>
					<cfset LvarTam02 = 25>
					<cfif rsForm.tipo eq 4>
						<cfset LvarTam01 = 50>
						<cfset LvarTam02 = 45>
					</cfif>

					<td valign="top" width="#LvarTam01#%">
										
					<cfif isdefined("rsForm") and rsForm.tipo eq 2>

						<cf_dbfunction name="to_char" args="CDporcentaje" returnvariable="LvarPorcentajeD">
                        <cf_dbfunction name="concat" args="#LvarPorcentajeD# + '%'" returnvariable="LvarCDporcentajeD" delimiters="+">	
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							tabla="DCCtasDestino A, DCDistribucion B, Oficinas C"
							columnas="A.Id,	A.IDdistribucion, C.Oficodigo, CDformato, CDcomplemento as CDcomplemento1, #LvarCDporcentajeD# as CDporcentaje,	case when CDexcluir = 1 then '#checked#' else '#unchecked#' end as CDexcluir"
							desplegar="Oficodigo, CDformato, CDcomplemento1, CDporcentaje, CDexcluir"
							etiquetas="Oficina, Cuenta, Complemento, Porcentaje, Excluir"
							formatos="S,S,S,S,U"
							filtro=" A.IDdistribucion = B.IDdistribucion and A.Ecodigo = B.Ecodigo and A.Ocodigo = C.Ocodigo and A.Ecodigo = C.Ecodigo and A.Ecodigo = #session.Ecodigo# and A.IDdistribucion = #Form.IDdistribucion# Order By Id"
							align="left,left,left,right,center"
							checkboxes="N"
							keys="Id"
							MaxRows="6"
							pageindex="1"
							filtrar_automatico="true"
							mostrar_filtro="true"
							filtrar_por="Oficodigo, CDformato, CDcomplemento, CDporcentaje, CDexcluir"
							ira="Distribuciones.cfm?tab=3&IDgd=#form.IDgd#"
							QueryString_lista="tab=3&IDdistribucion=#form.IDdistribucion#&IDgd=#form.IDgd#"
							showEmptyListMsg="true">
							
					<cfelseif isdefined("rsForm") and rsForm.tipo eq 4>
                    <cf_dbfunction name="to_char" args="CDporcentaje" returnvariable="LvarPorcentajeD">
					<cfset LvarCDporcentaje = LvarPorcentajeD>
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							tabla="DCCtasDestino A, DCDistribucion B, Oficinas C"
							columnas="A.Id,	A.IDdistribucion, C.Oficodigo, CDformato, #LvarCDporcentaje# as CDporcentaje,	case when CDexcluir = 1 then '#checked#' else '#unchecked#' end as CDexcluir"
							desplegar="Oficodigo, CDformato, CDporcentaje, CDexcluir"
							etiquetas="Oficina, Cuenta, Peso, Excluir"
							formatos="S,S,S,U"
							filtro=" A.IDdistribucion = B.IDdistribucion and A.Ecodigo = B.Ecodigo and A.Ocodigo = C.Ocodigo and A.Ecodigo = C.Ecodigo and A.Ecodigo = #session.Ecodigo# and A.IDdistribucion = #Form.IDdistribucion# Order By Id"
							align="left,left,right,center"
							checkboxes="N"
							keys="Id"
							MaxRows="6"
							pageindex="1"
							filtrar_automatico="true"
							mostrar_filtro="true"
							filtrar_por="Oficodigo, CDformato, CDporcentaje, CDexcluir"
							ira="Distribuciones.cfm?tab=3&IDgd=#form.IDgd#"
							QueryString_lista="tab=3&IDdistribucion=#form.IDdistribucion#&IDgd=#form.IDgd#"
							showEmptyListMsg="true">
					<cfelse>						

						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							tabla="DCCtasDestino A, DCDistribucion B, Oficinas C"
							columnas="A.Id,	A.IDdistribucion, C.Oficodigo, CDformato, CDcomplemento as CDcomplemento1,	case when CDexcluir = 1 then '#checked#' else '#unchecked#' end as CDexcluir"
							desplegar="Oficodigo, CDformato, CDcomplemento1, CDexcluir"
							etiquetas="Oficina, Cuenta, Complemento, Excluir"
							formatos="S,S,S,U"
							filtro=" A.IDdistribucion = B.IDdistribucion and A.Ecodigo = B.Ecodigo and A.Ocodigo = C.Ocodigo and A.Ecodigo = C.Ecodigo and A.Ecodigo = #session.Ecodigo# and A.IDdistribucion = #Form.IDdistribucion# Order By Id"
							align="left,left,left,center"
							checkboxes="N"
							keys="Id"
							MaxRows="6"
							pageindex="1"
							filtrar_automatico="true"
							mostrar_filtro="true"
							filtrar_por="Oficodigo, CDformato, CDcomplemento, CDexcluir"
							ira="Distribuciones.cfm?tab=3&IDgd=#form.IDgd#"
							QueryString_lista="tab=3&IDdistribucion=#form.IDdistribucion#&IDgd=#form.IDgd#"
							showEmptyListMsg="true">

					</cfif>
			
				</td>			
				<td valign="top" width="3%">		
				<td valign="top" width="#LvarTam02#%">
					<!---
					<cfquery datasource="#Session.DSN#" name="rsOrigenes">
					select Oorigen,Odescripcion from Origenes 
					</cfquery>
					
					<cfif modo neq "ALTA">
						<cfquery name="rsForm" datasource="#Session.DSN#">
							Select	A.Id,	A.IDdistribucion, C.Oficodigo,	CDformato, CDcomplemento, CDporcentaje,	CDexcluir,	A.ts_rversion, B.Tipo
							from DCCtasDestino A, DCDistribucion B, Oficinas C
							where A.IDdistribucion = B.IDdistribucion
							  and A.Ecodigo = B.Ecodigo
							  and A.Ocodigo = C.Ocodigo
							  and A.Ecodigo = C.Ecodigo
							  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							  and A.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
							  and A.Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
						</cfquery>
					</cfif>
					--->
										
					<cfoutput>

					<form action="sqlDistribuciones.cfm" method="post" name="form3">
						<input type="hidden" name="tab" value="3">
						<input type="hidden" name="IDdistribucion" value="#Form.IDdistribucion#">
						<input type="hidden" name="IDgd" value="#form.IDgd#">
						<cfif modo neq "ALTA">
							<input type="hidden" name="Id" value="#rsForm.Id#">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm.ts_rversion#"/>
							<input type="hidden" name="ts_rversion" value="#ts#">
						</cfif>
						<br>
						<table width="100%"  border="0" cellspacing="2" cellpadding="0">
						<tr>
							<td colspan="2" class="subTitulo">Cuentas Destino </td>
						</tr>
						<tr>
							<td><strong> Oficina:&nbsp;</strong></td>
							<td>							
								<select name="txtOcodigoDestino" id="txtOcodigoDestino">
								<cfloop query="rsOficinas">
									<option value="#rsOficinas.Ocodigo#" <cfif modo neq "ALTA" and rsOficinas.Ocodigo eq rsForm.Ocodigo>selected</cfif>>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</option>
								</cfloop>
								</select>																
							</td>
						</tr>
						<tr>
							<td>
							<cfif isdefined("rsForm") and (rsForm.tipo eq 3 or rsForm.tipo eq 4)>
								<strong> Cuenta&nbsp;Destino:&nbsp;</strong></td>
							<cfelse>
								<strong> Cuenta de Movimientos para la Distribución:&nbsp;</strong></td>
							</cfif>
							<td>	
							
								<cfif modo EQ "ALTA">
						
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td nowrap>
											<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
													onfocus="this.select();"
													onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value);if (this.value == '0000'){this.value='';}"
											>
										</td>
										<td>
											<iframe marginheight="0" 
													marginwidth="0" 
													scrolling="no" 
													name="cuentasIframe" 
													id="cuentasIframe" 
													width="100%" 
													height="25" 
													frameborder="0"></iframe>
											<input type="hidden" name="DCtaFinal">
										</td>
									</tr>	
									</table>
									
								<cfelse>	
										<cfif find("-",rsForm.CDformato,1) eq 0>
											<cfset Param_Cmayor ="#rsForm.CDformato#">
										<cfelse>
											<cfset Param_Cmayor ="#Mid(rsForm.CDformato,1,find("-",rsForm.CDformato,1)-1)#">
										</cfif>
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td nowrap>
												<input type="text" name="txt_Cmayor" maxlength="4" size="4" width="100%" 
														onfocus="this.select()"	
														onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajas(this.value);if (this.value == '0000'){this.value='';}" 
														value="<cfif modo neq "ALTA"><cfoutput>#trim(Param_Cmayor)#</cfoutput></cfif>"
												>
											</td>
											<td>
												<iframe marginheight="0" 
														marginwidth="0" 
														scrolling="no" 
														name="cuentasIframe" 
														id="cuentasIframe" 
														width="100%" 
														height="25" 
														frameborder="0" 
														src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsForm.CDformato#&Vform=form3&VCta=DCtaFinal</cfoutput>">
														</iframe>
												<input type="hidden" name="DCtaFinal" value="<cfoutput>#trim(rsForm.CDformato)#</cfoutput>">
											</td>
										</tr>	
										</table>
										
								</cfif>								
							</td>
						</tr>
					<cfif isdefined("rsForm") and (rsForm.tipo eq 3 or rsForm.tipo eq 4)>
						<tr style="display:none">
					<cfelse>
						<tr>
					</cfif>
							<td><strong> Cuenta Destino (Complemento):&nbsp;</strong></td>
							<td>	
							
							
							
							
							
								<cfif modo EQ "ALTA">
						
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td nowrap>
											<input type="text" name="txt_Cmayorcmpdest" maxlength="4" size="4" width="100%" 
													onfocus="this.select();"
													onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajascmp(this.value);if (this.value == '0000'){this.value='';}"
											>
										</td>
										<td>
											<iframe marginheight="0" 
													marginwidth="0" 
													scrolling="no" 
													name="cuentasIframecmpdest" 
													id="cuentasIframecmpdest" 
													width="100%" 
													height="25" 
													frameborder="0"></iframe>
											<input type="hidden" name="CtaFinalcmpdest">
										</td>
									</tr>	
									</table>
									
								<cfelse>	
										<cfif find("-",rsForm.CDcomplemento,1) eq 0>
											<cfset Param_Cmayor ="#rsForm.CDcomplemento#">
										<cfelse>
											<cfset Param_Cmayor ="#Mid(rsForm.CDcomplemento,1,find("-",rsForm.CDcomplemento,1)-1)#">
										</cfif>
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td nowrap>
												<input type="text" name="txt_Cmayorcmpdest" maxlength="4" size="4" width="100%" 
														onfocus="this.select()"	
														onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajascmp(this.value);if (this.value == '0000'){this.value='';}" 
														value="<cfif modo neq "ALTA"><cfoutput>#trim(Param_Cmayor)#</cfoutput></cfif>"
												>
											</td>
											<td>
												<iframe marginheight="0" 
														marginwidth="0" 
														scrolling="no" 
														name="cuentasIframecmpdest" 
														id="cuentasIframecmpdest" 
														width="100%" 
														height="25" 
														frameborder="0" 
														src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsForm.CDcomplemento#&Vform=form3&VCta=CtaFinalcmpdest</cfoutput>">
														</iframe>
												<input type="hidden" name="CtaFinalcmpdest" value="<cfoutput>#trim(rsForm.CDcomplemento)#</cfoutput>">
											</td>
										</tr>	
										</table>
										
								</cfif>	
								
								
								
															
							</td>
						</tr>
						<cfif isdefined("rsForm") and (rsForm.tipo eq 2 or rsForm.tipo eq 4)>
						<tr>
						<cfif rsForm.tipo eq 2>
							<td>
									<strong> Porcentaje a aplicar:&nbsp;</strong>
							</td>
							<td>	
								<input name="txtCDporcentaje" type="text" id="txtCDporcentaje" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.CDporcentaje,',9.00')#"<cfelse> value="100"</cfif> style="text-align: right" size="4" maxlength="18" tabindex="4" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);" >%
							</td>
						<cfelse>
							<td>
									<strong> Peso:&nbsp;</strong>
							</td>
							<td>	
								<input name="txtCDporcentaje" type="text" id="txtCDporcentaje" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm.CDporcentaje,',9.00')#"<cfelse> value="100"</cfif> style="text-align: right" size="15" maxlength="18" tabindex="4" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);" >
							</td>
						</cfif>
						</tr>
						<cfelse>
							<input name="txtCDporcentaje" type="hidden" id="txtCDporcentaje" value="0">
						</cfif>
						<cfif isdefined("rsForm") and NOT (rsForm.tipo EQ 3 OR rsForm.tipo EQ 4)>
							<tr>
								<td><strong> Excluir:&nbsp;</strong></td>
								<td>	
									<input tabindex="3" type="checkbox" name="chkCDexcluir" value="1" <cfif modo NEQ 'ALTA' and rsForm.CDexcluir EQ '1'> checked</cfif>>
								</td>
							</tr>
						</cfif>
						</table>
						<br>
						<cfif modo eq "ALTA">
							<cfset funcbtn = "return funcAltadest()">
						<cfelse>
							<cfset funcbtn = "return funcCambiodest()">
						</cfif>
						<cf_botones modo="#modo#" functions="#funcbtn#">
					</form>

					<script language="javascript" type="text/javascript">
					<!--//						
						//objForm.txtOcodigoDestino.description = "#JSStringFormat('Nombre')#";						
						document.form3.txtCDporcentaje.description = "#JSStringFormat('Porcentaje')#";
						document.form3.DCtaFinal.description = "#JSStringFormat('Cuenta')#";
						function habilitarValidacion1(){		
							document.form3.txtOcodigoDestino.required = true;
							document.form3.txtCDporcentaje.required = true;						
							document.form3.DCtaFinal.required = true;

						}
						function desahabilitarValidacion1(){
							document.form3.txtOcodigoDestino.required = false;
							document.form3.txtCDporcentaje.required = false;
							document.form3.DCtaFinal.required = false;
						}
						
						habilitarValidacion1();
					//-->
					</script>
					</cfoutput>	


					
				</td>
			</tr>
		</table>
		
	</td>	
  </tr>
</table>



<script language="JavaScript1.2">
/*
	function fnRight(LprmHilera, LprmLong)
	{
		var LvarTot = LprmHilera.length;
		return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
	}		*/ 


	if (document.fomdist.cboTipo.value == 4){
		document.form3.txt_Cmayorcmpdest.disabled ="true";
	}

	function validar(){
	
		document.form3.DCtaFinal.value="";	
		if (document.form3.txt_Cmayor.value.length == 0){
			alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.');
			return false;		
		}
		else
		{
			FrameFunction();
		}
		
		//En caso de haber un complemento verificar la cuenta mayor		
		if (document.form3.txt_Cmayor.value.length > 0 && document.form3.txt_Cmayorcmpdest.value != '')
		{
			if (document.form3.txt_Cmayorcmpdest.value != document.form3.txt_Cmayor.value)
			{
				alert('Se presentaron los siguientes errores:\n - La cuenta mayor del Complemento es diferente a la cuenta mayor de la Cuenta.');
				return false;					
			}
		}				
		
		document.form3.CtaFinalcmpdest.value="";	
		if (!document.fomdist.cboTipo.value == 4){
			if (document.form3.txt_Cmayorcmpdest.value.length == 0){
				alert('Se presentaron los siguientes errores:\n - El campo Complemento es requerido.');
				return false;		
			}
		}
		if (document.form3.txt_Cmayorcmpdest.value.length > 0){
			FrameFunctioncmpdest();
		}
		return true;
	}

	function CargarCajas(Cmayor)
	{				
		var fr = document.getElementById("cuentasIframe");					
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA&VCta=DCtaFinal&Vform=form3"<!--- <cfoutput>#modo#</cfoutput> --->		
	}
	function CargarCajascmp(Cmayor)
	{				
		var fr = document.getElementById("cuentasIframecmpdest");					
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA&VCta=CtaFinalcmpdest&Vform=form3"<!--- <cfoutput>#modo#</cfoutput> --->		
	}
	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunctioncmpdest()
	{
		// RetornaCuenta2() es máscara completa, rellena con comodín
		window.parent.cuentasIframecmpdest.RetornaCuenta2();	
	}
	function FrameFunction()
	{		
		// RetornaCuenta2() es máscara completa, rellena con comodín
		window.parent.cuentasIframe.RetornaCuenta2();
		
	}
	function funcAltadest()
	{
		return validar();
	}
	function funcCambiodest()
	{
		return validar();
	}
	function funcFiltrar1()
	{
		document.lista.action='Distribuciones.cfm?tab=3&IDdistribucion=<cfoutput>#form.IDdistribucion#</cfoutput>&IDgd=<cfoutput>#form.IDgd#</cfoutput>'; 
		return true;
	}		
</script>