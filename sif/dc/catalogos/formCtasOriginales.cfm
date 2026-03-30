<cfif isdefined("url.IDgd") and len(trim(url.IDgd)) and not isdefined("form.IDgd")>			
	<cfset form.IDgd = url.IDgd>
</cfif>
<cfif isdefined("url.IDdistribucion") and len(trim(url.IDdistribucion)) and not isdefined("form.IDdistribucion") and form.tab eq 2>
	<cfset form.IDdistribucion = url.IDdistribucion>
</cfif>
<cfif isdefined("url.Id") and len(trim(url.Id)) and not isdefined("form.id") and form.tab eq 2>
	<cfset form.id = url.id>
</cfif>

<cfset modo="ALTA">
<cfif isdefined("form.Id") and len(trim(form.Id)) and form.tab eq 2>
	<cfset modo="CAMBIO">
</cfif>


<table width="100%"  border="0" cellspacing="2" cellpadding="0">
  <tr>
	<td valign="top" nowrap>
					
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td valign="top" width="45%">
					<cfif isdefined("usaConductor") and usaConductor eq 1>
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							tabla="DCCtasOrigen A, DCDistribucion B, Oficinas C, CGConductores D"
							columnas="A.Id,	A.IDdistribucion, C.Oficodigo as Oficodigo1, CDformato as CDformato1, CDcomplemento, CGCdescripcion"
							desplegar="Oficodigo1, CDformato1, CDcomplemento, CGCdescripcion"
							etiquetas="Oficina, Cuenta, Complemento, Conductor"
							formatos="S,S,S,S"
							filtro=" A.IDdistribucion = B.IDdistribucion 
							        and A.Ecodigo = B.Ecodigo 
									and A.Ocodigo = C.Ocodigo 
									and A.Ecodigo = C.Ecodigo 
									and A.CGCid   = D.CGCid
									and A.Ecodigo = D.Ecodigo									
									and A.Ecodigo = #session.Ecodigo# 
									and A.IDdistribucion = #Form.IDdistribucion# 
									Order By Id"
							align="left,left,left,left"
							checkboxes="N"
							keys="Id"
							MaxRows="6"
							pageindex="2"
							filtrar_automatico="true"
							mostrar_filtro="true"
							filtrar_por="Oficodigo, CDformato, CDcomplemento, CGCdescripcion"
							formName="lista1"
							ira="Distribuciones.cfm?tab=2&IDgd=#form.IDgd#"
							QueryString_lista="tab=2&IDdistribucion=#form.IDdistribucion#&IDgd=#form.IDgd#"
							showEmptyListMsg="true">

					
					<cfelse>
                    <cf_dbfunction name="to_char" args="CDporcentaje" returnvariable="LvarPorcentaje">
					<cf_dbfunction name="concat" args="#LvarPorcentaje# + '%'" returnvariable="LvarCDporcentaje" delimiters="+">
                    
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							tabla="DCCtasOrigen A, DCDistribucion B, Oficinas C"
							columnas="A.Id,	A.IDdistribucion, C.Oficodigo as Oficodigo1, CDformato as CDformato1, CDcomplemento,#LvarCDporcentaje# as CDporcentaje1"
							desplegar="Oficodigo1, CDformato1, CDcomplemento, CDporcentaje1"
							etiquetas="Oficina, Cuenta, Complemento, Porcentaje"
							formatos="S,S,S,S"
							filtro=" A.IDdistribucion = B.IDdistribucion and A.Ecodigo = B.Ecodigo and A.Ocodigo = C.Ocodigo and A.Ecodigo = C.Ecodigo and A.Ecodigo = #session.Ecodigo# and A.IDdistribucion = #Form.IDdistribucion# Order By Id"
							align="left,left,left,right"
							checkboxes="N"
							keys="Id"
							MaxRows="6"
							pageindex="2"
							filtrar_automatico="true"
							mostrar_filtro="true"
							filtrar_por="Oficodigo, CDformato, CDcomplemento, CDporcentaje"
							formName="lista1"
							ira="Distribuciones.cfm?tab=2&IDgd=#form.IDgd#"
							QueryString_lista="tab=2&IDdistribucion=#form.IDdistribucion#&IDgd=#form.IDgd#"
							showEmptyListMsg="true">
			
					</cfif>
				</td>					
				<td width="3%">&nbsp;</td>
				<td valign="top" width="52%">
					
					<cfquery datasource="#Session.DSN#" name="rsOrigenes">
					select Oorigen,Odescripcion from Origenes 
					</cfquery>
					
					<cfif modo neq "ALTA">
						<cfquery name="rsForm1" datasource="#Session.DSN#">
							Select	A.Id,	
								A.IDdistribucion, 
								C.Oficodigo,	
								CDformato, 
								CDcomplemento, 
								CDcomplementoOrg,
								CDporcentaje,	
								A.CGCid, 
								A.ts_rversion
							from DCCtasOrigen A, DCDistribucion B, Oficinas C
							where A.IDdistribucion = B.IDdistribucion
							  and A.Ecodigo = B.Ecodigo
							  and A.Ocodigo = C.Ocodigo
							  and A.Ecodigo = C.Ecodigo
							  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							  and A.IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
							  and A.Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Id#">
						</cfquery>
					</cfif>
										
					<cfoutput>

					<form action="sqlDistribuciones.cfm" method="post" name="form2">
						<input type="hidden" name="tab" value="2">
						<input type="hidden" name="IDgd" value="#form.IDgd#">
						<input type="hidden" name="IDdistribucion" value="#Form.IDdistribucion#">
						
						<cfif isdefined("usaConductor") and usaConductor eq 1>
							<input type="hidden" name="usaConductor" value="1">
						</cfif>
						
						<cfif modo neq "ALTA">
							<input type="hidden" name="Id" value="#rsForm1.Id#">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" arTimeStamp = "#rsForm1.ts_rversion#"/>
							<input type="hidden" name="ts_rversion" value="#ts#">
						</cfif>
						<br>
						<table width="100%"  border="0" cellspacing="2" cellpadding="0">
						<tr>
							<td colspan="2" class="subTitulo">Cuentas Origen </td>
						</tr>
						<tr>
							<td><strong> Oficina:&nbsp;</strong></td>
							<td>
								<cfquery datasource="#Session.DSN#" name="Verificar_oficina">
									Select distinct a.Ocodigo, b.Oficodigo, b.Odescripcion
									from DCCtasOrigen a 
										inner join Oficinas b
											 on b.Ecodigo = a.Ecodigo
											and b.Ocodigo = a.Ocodigo
									where IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
								</cfquery>
								
								<cfif Verificar_oficina.recordcount gt 0>
									<cfoutput>#Verificar_oficina.Oficodigo# - #Verificar_oficina.Odescripcion#</cfoutput>
									<input type="hidden" name="txtOcodigoOrigen" value="<cfoutput>#Verificar_oficina.Ocodigo#</cfoutput>">
								<cfelse>
									<select name="txtOcodigoOrigen" id="txtOcodigoOrigen">
									<cfloop query="rsOficinas">
										<option value="#rsOficinas.Ocodigo#" <cfif modo neq "ALTA" and rsOficinas.Ocodigo eq rsForm1.Ocodigo>selected</cfif>>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</option>
									</cfloop>
									</select>
									
								</cfif>
							</td>
						</tr>
						<tr>
							<td><strong> Cuenta del Monto a Distribuir:&nbsp;</strong></td>
							<td>	
							
								<cfif modo EQ "ALTA">
						
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td nowrap>
											<input type="text" name="txt_Cmayororg" maxlength="4" size="4" width="100%" 
													onfocus="this.select();"
													onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajasorg(this.value);if (this.value == '0000'){this.value='';};"
											>
										</td>
										<td>
											<iframe marginheight="0" 
													marginwidth="0" 
													scrolling="no" 
													name="cuentasIframeorg" 
													id="cuentasIframeorg" 
													width="100%" 
													height="25" 
													frameborder="0"></iframe>
											<input type="hidden" name="CtaFinal">
										</td>
									</tr>	
									</table>
									
								<cfelse>	
										<cfif find("-",rsForm1.CDformato,1) eq 0>
											<cfset Param_Cmayor ="#rsForm1.CDformato#">
										<cfelse>
											<cfset Param_Cmayor ="#Mid(rsForm1.CDformato,1,find("-",rsForm1.CDformato,1)-1)#">
										</cfif>
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td nowrap>
												<input type="text" name="txt_Cmayororg" maxlength="4" size="4" width="100%" 
														onfocus="this.select()"	
														onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajasorg(this.value); if (this.value == '0000'){this.value='';}" 
														value="<cfif modo neq "ALTA"><cfoutput>#trim(Param_Cmayor)#</cfoutput></cfif>"
												>
											</td>
											<td>
												<iframe marginheight="0" 
														marginwidth="0" 
														scrolling="no" 
														name="cuentasIframeorg" 
														id="cuentasIframeorg" 
														width="100%" 
														height="25" 
														frameborder="0" 
														src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsForm1.CDformato#&Vform=form2</cfoutput>">
														</iframe>
												<input type="hidden" name="CtaFinal" value="<cfoutput>#trim(rsForm1.CDformato)#</cfoutput>">
											</td>
										</tr>	
										</table>
										
								</cfif>								
							</td>
						</tr>
						
						<tr>
							<td><strong><cfif isdefined("usaConductor") and usaConductor eq 1>Comp. (Credito)<cfelse>Cuenta Origen (Complemento)</cfif>:&nbsp;</strong></td>
							<td>	
							
								<cfif modo EQ "ALTA">
						
									<table width="100%" cellpadding="0" cellspacing="0" border="0">
									<tr>
										<td nowrap>
											<input type="text" name="txt_Cmayorcmp" maxlength="4" size="4" width="100%" 
													onfocus="this.select();"
													onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajasorgcmp(this.value);if (this.value == '0000'){this.value='';}"
											>
										</td>
										<td>
											<iframe marginheight="0" 
													marginwidth="0" 
													scrolling="no" 
													name="cuentasIframecmp" 
													id="cuentasIframecmp" 
													width="100%" 
													height="25" 
													frameborder="0"></iframe>
											<input type="hidden" name="CtaFinalcmp">
										</td>
									</tr>	
									</table>
									
								<cfelse>	
										<cfif find("-",rsForm1.CDcomplemento,1) eq 0>
											<cfset Param_Cmayor ="#rsForm1.CDcomplemento#">
										<cfelse>
											<cfset Param_Cmayor ="#Mid(rsForm1.CDcomplemento,1,find("-",rsForm1.CDcomplemento,1)-1)#">
										</cfif>
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td nowrap>
												<input type="text" name="txt_Cmayorcmp" maxlength="4" size="4" width="100%" 
														onfocus="this.select()"	
														onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajasorgcmp(this.value);if (this.value == '0000'){this.value='';}" 
														value="<cfif modo neq "ALTA"><cfoutput>#trim(Param_Cmayor)#</cfoutput></cfif>"
												>
											</td>
											<td>
												<iframe marginheight="0" 
														marginwidth="0" 
														scrolling="no" 
														name="cuentasIframecmp" 
														id="cuentasIframecmp" 
														width="100%" 
														height="25" 
														frameborder="0" 
														src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsForm1.CDcomplemento#&Vform=form2&VCta=CtaFinalcmp</cfoutput>">
														</iframe>
												<input type="hidden" name="CtaFinalcmp" value="<cfoutput>#trim(rsForm1.CDcomplemento)#</cfoutput>">
											</td>
										</tr>	
										</table>
										
								</cfif>								
							</td>
						</tr>							
						
						<!--- Si el Tipo es 5 no se usa Complemento, solo se elige el conductor --->
						<cfif isdefined("usaConductor") and usaConductor eq 1>
							<tr>
								<td><strong> Comp. (Debito):&nbsp;</strong></td>
								<td>	
							
									<cfif modo EQ "ALTA">
						
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td nowrap>
												<input type="text" name="txt_CmayorcmpD" maxlength="4" size="4" width="100%" 
													onfocus="this.select();"
													onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajasorgcmpD(this.value);if (this.value == '0000'){this.value='';}"
												>
											</td>
											<td>
												<iframe marginheight="0" 
													marginwidth="0" 
													scrolling="no" 
													name="cuentasIframecmpD" 
													id="cuentasIframecmpD" 
													width="100%" 
													height="25" 
													frameborder="0"></iframe>
												<input type="hidden" name="CtaFinalcmpD">
											</td>
										</tr>	
										</table>
									
									<cfelse>	
										<cfif find("-",rsForm1.CDcomplementoOrg,1) eq 0>
											<cfset Param_Cmayor ="#rsForm1.CDcomplementoOrg#">
										<cfelse>
											<cfset Param_Cmayor ="#Mid(rsForm1.CDcomplementoOrg,1,find("-",rsForm1.CDcomplementoOrg,1)-1)#">
										</cfif>
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<td nowrap>
												<input type="text" name="txt_CmayorcmpD" maxlength="4" size="4" width="100%" 
														onfocus="this.select()"	
														onBlur="javascript:this.value = fnRight('0000' + this.value, 4); CargarCajasorgcmpD(this.value);if (this.value == '0000'){this.value='';}" 
														value="<cfif modo neq "ALTA"><cfoutput>#trim(Param_Cmayor)#</cfoutput></cfif>"
												>
											</td>
											<td>
												<iframe marginheight="0" 
														marginwidth="0" 
														scrolling="no" 
														name="cuentasIframecmpD" 
														id="cuentasIframecmpD" 
														width="100%" 
														height="25" 
														frameborder="0" 
														src="<cfoutput>/cfmx/sif/Utiles/generacajas.cfm?Cmayor=#Param_Cmayor#&MODO=#modo#&formatocuenta=#rsForm1.CDcomplementoOrg#&Vform=form2&VCta=CtaFinalcmpD</cfoutput>">
														</iframe>
												<input type="hidden" name="CtaFinalcmpD" value="<cfoutput>#trim(rsForm1.CDcomplementoOrg)#</cfoutput>">
											</td>
										</tr>	
										</table>
										
									</cfif>								
								</td>
							</tr>	


							<cfquery name="rsConductores" datasource="#session.dsn#">
							Select CGCid, CGCdescripcion
							from CGConductores
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
							</cfquery>						
						
							<tr>
								<td><strong> Conductor:&nbsp;</strong></td>
								<td>
									<select name="cboConductor" id="cboConductor">
									<cfloop query="rsConductores">
										<option value="<cfoutput>#rsConductores.CGCid#</cfoutput>" <cfif modo neq "ALTA" and rsform1.CGCid eq rsConductores.CGCid>selected</cfif>><cfoutput>#rsConductores.CGCdescripcion#</cfoutput></option>
									</cfloop>
									</select>
								</td>
							</tr>
						
						<cfelse>
							<tr>
								<td><strong> Porcentaje a Distribuir:&nbsp;</strong></td>
								<td>	
									<input name="txtCDporcentajeorg" type="text" id="txtCDporcentajeorg" <cfif modo NEQ 'Alta'> value="#LSNumberFormat(rsForm1.CDporcentaje,',9.00')#"<cfelse> value="100"</cfif> style="text-align: right" size="4" maxlength="18" tabindex="4" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">%
								</td>
							</tr>
						</cfif>	
																			
						</table>
						<br>
						<cfif modo eq "ALTA">
							<cfset funcbtnorg = "return funcAltaorg()">
						<cfelse>
							<cfset funcbtnorg = "return funcCambioorg()">
						</cfif>
						<cf_botones modo="#modo#" functions="#funcbtnorg#">						
					</form>

					<script language="javascript" type="text/javascript">
					<!--//						
						document.form2.txtOcodigoOrigen.description = "#JSStringFormat('Nombre')#";
						<cfif not isdefined("usaConductor")>
							document.form2.txtCDporcentajeorg.description = "#JSStringFormat('Porcentaje')#";
						</cfif>
						document.form2.CtaFinal.description = "#JSStringFormat('Cuenta')#";
						function habilitarValidacion(){		
							document.form2.txtOcodigoOrigen.required = true;
							<cfif not isdefined("usaConductor")>
								document.form2.txtCDporcentajeorg.required = true;
							</cfif>
							document.form2.txt_Cmayororg.required = true;
						}
						function desahabilitarValidacion(){
							document.form2.txtOcodigoOrigen.required = false;
							<cfif not isdefined("usaConductor")>
								document.form2.txtCDporcentajeorg.required = false;
							</cfif>
							document.form2.txt_Cmayororg.required = false;
						}
						
						habilitarValidacion();
						
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
	function validarorg()
	{

		document.form2.CtaFinal.value="";	
		if (document.form2.txt_Cmayororg.value.length == 0)
		{
			alert('Se presentaron los siguientes errores:\n - El campo Formato de Cuenta es requerido.');
			return false;		
		}
		else
		{
			FrameFunctionorg();
		}
		document.form2.CtaFinalcmp.value="";	
		//En caso de haber un complemento verificar la cuenta mayor		
		if (document.form2.txt_Cmayorcmp.value.length > 0 && document.form2.txt_Cmayorcmp.value != '')
		{
			if (document.form2.txt_Cmayorcmp.value != document.form2.txt_Cmayororg.value)
			{
				alert('Se presentaron los siguientes errores:\n - La cuenta mayor del Complemento es diferente a la cuenta mayor de la Cuenta.');
				return false;					
			}
		}
		<cfif not isdefined("usaConductor")>
			if (document.form2.txt_Cmayorcmp.value.length == 0)
			{
				alert('Se presentaron los siguientes errores:\n - El campo Complemento es requerido.');
				return false;		
			}
		</cfif>

		if (document.form2.txt_Cmayorcmp.value.length > 0)
		{
			FrameFunctioncmp();
		}

		<cfif isdefined("usaConductor") and usaConductor eq 1>
			document.form2.CtaFinalcmpD.value="";	
			//En caso de haber un complemento verificar la cuenta mayor		
			if (document.form2.txt_CmayorcmpD.value.length > 0 && document.form2.txt_CmayorcmpD.value != '')
			{
				if (document.form2.txt_CmayorcmpD.value != document.form2.txt_Cmayororg.value)
				{
					alert('Se presentaron los siguientes errores:\n - La cuenta mayor del Complemento de Débito es diferente a la cuenta mayor de la Cuenta.');
					return false;					
				}
			}
			if (document.form2.txt_CmayorcmpD.value.length > 0)
			{
				FrameFunctioncmpD();
			}
		</cfif>
		return true;
	}

	function CargarCajasorg(Cmayor)
	{				
		var fr = document.getElementById("cuentasIframeorg");					
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA&Vform=form2"<!--- <cfoutput>#modo#</cfoutput> --->
	}
	function CargarCajasorgcmp(Cmayor)
	{	
		var fr = document.getElementById("cuentasIframecmp");					
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA&Vform=form2&VCta=CtaFinalcmp"<!--- <cfoutput>#modo#</cfoutput> --->
	}
	function CargarCajasorgcmpD(Cmayor)
	{	
		var fr = document.getElementById("cuentasIframecmpD");
		fr.src = "/cfmx/sif/Utiles/generacajas.cfm?Cmayor="+Cmayor+"&MODO=ALTA&Vform=form2&VCta=CtaFinalcmpD"<!--- <cfoutput>#modo#</cfoutput> --->
	}
	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunctioncmp()
	{
		// RetornaCuenta2() retorna máscara completa, rellena con comodin
		window.parent.cuentasIframecmp.RetornaCuenta2();	
	}
	function FrameFunctioncmpD()
	{
		// RetornaCuenta2() retorna máscara completa, rellena con comodin
		window.parent.cuentasIframecmpD.RetornaCuenta2();
	}
	function FrameFunctionorg()
	{
		// RetornaCuenta2() retorna máscara completa, rellena con comodin
		window.parent.cuentasIframeorg.RetornaCuenta2();
	}
	function funcAltaorg()
	{			
		return validarorg();
	}
	function funcCambioorg()
	{		
		return validarorg();
	}
	function funcFiltrar2()
	{
		document.lista1.action='Distribuciones.cfm?tab=2&IDdistribucion=<cfoutput>#form.IDdistribucion#</cfoutput>&IDgd=<cfoutput>#form.IDgd#</cfoutput>'; 
		return true;
	}											
	
</script>