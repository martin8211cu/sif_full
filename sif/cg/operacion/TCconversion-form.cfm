<cfset form.Smes= 	ListFind(arrayToList(VarMeses),form.SMes)>

<!---Parametro de TC en control de presupuesto --->
<cfquery name="rsParamTCpres" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 1150
</cfquery>

<cfif rsParamTCpres.recordcount gt 0>
	<cfset UtilizaTCpres = rsParamTCpres.Pvalor>
</cfif>
 
<cfoutput>	

	<cfif isdefined('LvarTCPres')>
		<cfset action="../../cg/operacion/TCconversion-sql.cfm">
		<cfset LbelBtonTCH="TC Adicionales">
	<cfelse>
		<cfset action="TCconversion-sql.cfm">
		<cfset LbelBtonTCH="TC Hist&oacute;rico">
	</cfif>
	
	<form name="form2" method="post" action="#action#" style="margin: 0;" onSubmit="javascript: validar(this);">
		<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
			<td colspan="5">
				&nbsp;
				<input type="hidden" name="Speriodo" value="#form.Speriodo#">
				<input type="hidden" name="Smes" value="#form.Smes#">		
				<cfif isdefined('LvarTCPres')>
					<input type="hidden" name="LvarTCPres" value="#LvarTCPres#">		
				<cfelseif isdefined('LvarTCConta')>
					<input type="hidden" name="LvarTCConta" value="#LvarTCConta#">		
				</cfif>			
			</td>
		  </tr>			  
		  <cf_tabs width="100%" onclick="tab_set_current_param">
		  		<cfif <!---(isdefined('UtilizaTCpres') and UtilizaTCpres eq 'S') or---> isdefined('LvarTCConta')>
					<cf_tab text="Consolidaci&oacute;n Contable" id="0">
						<table>
							<tr bgcolor="##CCCCCC">
								<td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Moneda Origen</strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Moneda Conversi&oacute;n</strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Tipo de Cambio (Venta)</strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Tipo de Cambio (compra)</strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Tipo de Cambio (promedio)</strong>
								</td>
						  </tr>
						  <cfloop query="rsMonedas">
							<cfquery name="rsTCconversion" datasource="#Session.dsn#">
								select  TCcompra, 
										TCventa,
										TCpromedio
								from HtiposcambioConversion  tc
								where tc.Ecodigo = #Session.Ecodigo#
									  and tc.Speriodo = #form.Speriodo#	
									  and tc.Smes = #form.Smes#
									  and Mcodigo = #rsMonedas.Mcodigo#
									  and TCtipo =0
							</cfquery>
						  <tr>  
								<td align="center"> #rsMonedas.Mnombre# </td>
								<td align="center"> #rsMonedaConversion.Mnombre# </td>
								<td align="center">
									<input name="TCambioV_#rsMonedas.Mcodigo#_0" type="text" size="17" maxlength="17"   
										   value="<cfoutput>#NumberFormat(rsTCconversion.TCventa,",0.0000000")#</cfoutput>" 
										   readonly="true"
										   style=" text-align:right; border: none;">
								</td>
								<td align="center">
									<input name="TCambioC_#rsMonedas.Mcodigo#_0" type="text" size="17" maxlength="17"  
										   value="<cfoutput>#NumberFormat(rsTCconversion.TCcompra,",0.0000000")#</cfoutput>"
										   readonly="true"   
										   style=" text-align:right; border: none;" >
								</td>
								<td align="center">
									<input name="TCambioP_#rsMonedas.Mcodigo#_0" type="text" size="17" maxlength="17"
										   value="<cfoutput>#NumberFormat(rsTCconversion.TCpromedio,",0.0000000")#</cfoutput>"  
										   readonly="true" 
										   style=" text-align:right; border: none;" >
								</td>
						  </tr>
						</cfloop>
					</table>
				</cf_tab>
			</cfif>	
			<cfif <!---(isdefined('UtilizaTCpres') and UtilizaTCpres eq 'S') or---> isdefined('LvarTCPres')>
				<cf_tab text="Consolidaci&oacute;n Presupuestal" id="1" >
					<table>
						<tr bgcolor="##CCCCCC">
							<td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Moneda Origen</strong>
							</td>
							<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Moneda Conversi&oacute;n</strong>
							</td>
							<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Tipo de Cambio (Venta)</strong>
							</td>
							<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Tipo de Cambio (compra)</strong>
							</td>
							<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Tipo de Cambio (promedio)</strong>
							</td>
						</tr>
							<cfloop query="rsMonedas">
								<cfquery name="rsTCconversion" datasource="#Session.dsn#">
									select  TCcompra, 
											TCventa,
											TCpromedio
									from HtiposcambioConversion  tc
									where tc.Ecodigo = #Session.Ecodigo#
										  and tc.Speriodo = #form.Speriodo#	
										  and tc.Smes = #form.Smes#
										  and Mcodigo = #rsMonedas.Mcodigo#
										  and TCtipo =1
								</cfquery>
						<tr>
							<td align="center"> #rsMonedas.Mnombre# </td>
							<td align="center"> #rsMonedaConversion.Mnombre# </td>
							<td align="center">
								<input name="TCambioV_#rsMonedas.Mcodigo#_1" type="text" size="17" maxlength="17"  
									   onFocus="this.value=qf(this); this.select();" 
									   onBlur="javascript: fm(this,10);"  
									   onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
									   value="<cfoutput>#rsTCconversion.TCventa#</cfoutput>" 
									   <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  
											readonly="true" style=" text-align:right; border: none;"  
										<cfelse> 
											style="text-align: right;" 
										</cfif>>
							</td>
							<td align="center">
								<input name="TCambioC_#rsMonedas.Mcodigo#_1" type="text" size="17" maxlength="17"  
									   onFocus="this.value=qf(this); this.select();" 
									   onBlur="javascript: fm(this,10);"  
									   onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
									   value="<cfoutput>#rsTCconversion.TCcompra#</cfoutput>"  
									   <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  
											readonly="true" style=" text-align:right; border: none;"  
										<cfelse> 
										   style="text-align: right;" 
										</cfif>>
							</td>
							<td align="center">
								<input name="TCambioP_#rsMonedas.Mcodigo#_1" type="text" size="17" maxlength="17"  
									   onFocus="this.value=qf(this); this.select();" 
									   onBlur="javascript: fm(this,10);"  
									   onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
									   value="<cfoutput>#rsTCconversion.TCpromedio#</cfoutput>" 
									   <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  
											readonly="true" style=" text-align:right; border: none;"  
									   <cfelse> 
											style="text-align: right;" 
										</cfif>>
							</td>
						 </tr>
					  </cfloop> 
					</table>
				</cf_tab>
		  </cfif>
		  </cf_tabs>
		  <table align="center">
			  <tr>
					<td align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center" >
						<cfif isdefined('LvarTCPres') <!---or (isdefined('UtilizaTCpres') and UtilizaTCpres eq 'S')--->>
							<input type="submit" name="btnModificar" value="Modificar" onclick="FuncModi();">
						</cfif>
						<input type="button" name="btnTCHistoricos" value="#LbelBtonTCH#" 
							   onClick="javascript:document.form2.action='TCHistoricos.cfm?Speriodo=<cfoutput>#form.Speriodo#</cfoutput>&Smes=<cfoutput>#form.Smes#</cfoutput>&Mcodigo=<cfoutput>#rsMonedaConversion.Mcodigo#</cfoutput>';
								document.form2.submit();">
				</td>
			</tr>
			<tr>
				<td align="center">&nbsp;</td>
			</tr>
		 </table>  		
	  </table>
	</form>
</cfoutput>

<script type="text/javascript" language="javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form2");
	_addValidator("isNotCero", __isNotCero);
	
	<cfloop list="1" index="LvarTipo">
		<cfoutput query="rsMonedas">
			<cfif LvarTipo EQ "0">
				<cfset LvarLblTipo = "Contable">
			<cfelse>
				<cfset LvarLblTipo = "Presupuestal">
			</cfif>
			<cfif rsMonedaConversion.Mcodigo neq rsMonedas.Mcodigo>
				objForm.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.required = true;
				objForm.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.description = "Tipo de Cambio #LvarLblTipo# (Compra) para #rsMonedas.Mnombre#";
				objForm.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.validateNotCero();
				
				objForm.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.required = true;
				objForm.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.description = "Tipo de Cambio #LvarLblTipo# (Venta) para #rsMonedas.Mnombre#";
				objForm.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.validateNotCero();
				
				objForm.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.required = true;
				objForm.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.description = "Tipo de Cambio #LvarLblTipo# (Promedio) para #rsMonedas.Mnombre#";
				objForm.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.validateNotCero();
			</cfif>
		</cfoutput>
	</cfloop>
		
	function tab_set_current_param (n){
		if (n == 0)
		{
			document.getElementById("tab0c").style.display = "";
			document.getElementById("tab1c").style.display = "none";

			document.getElementById("tab0l").setAttribute("class", "tab_sel_l");
			document.getElementById("tab0m").setAttribute("class", "tab_sel_m");
			document.getElementById("tab0r").setAttribute("class", "tab_sel_r");

			document.getElementById("tab1l").setAttribute("class", "tab_nor_l");
			document.getElementById("tab1m").setAttribute("class", "tab_nor_m");
			document.getElementById("tab1r").setAttribute("class", "tab_nor_r");
		}
		else
		{
			document.getElementById("tab0c").style.display = "none";
			document.getElementById("tab1c").style.display = "";

			document.getElementById("tab0l").setAttribute("class", "tab_nor_l");
			document.getElementById("tab0m").setAttribute("class", "tab_nor_m");
			document.getElementById("tab0r").setAttribute("class", "tab_nor_r");

			document.getElementById("tab1l").setAttribute("class", "tab_sel_l");
			document.getElementById("tab1m").setAttribute("class", "tab_sel_m");
			document.getElementById("tab1r").setAttribute("class", "tab_sel_r");
		}
	}
	function validar(f) {
		<cfloop list="0,1" index="LvarTipo">
		  <cfoutput query="rsMonedas">
			fm(TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#,10);
			f.obj.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.value = qf(f.obj.TCambioC_#rsMonedas.Mcodigo#.value);
			f.obj.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.value = qf(f.obj.TCambioV_#rsMonedas.Mcodigo#.value);
			f.obj.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.value = qf(f.obj.TCambioP_#rsMonedas.Mcodigo#.value);
			
			f.obj.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.disabled = false;
			f.obj.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.disabled = false;
			f.obj.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.disabled = false;
		  </cfoutput>
		</cfloop>
			}
		function __isNotCero() { 
			if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
				this.error = "El campo " + this.description + " no puede ser cero!";
			}
		}		
</script>
			
	


