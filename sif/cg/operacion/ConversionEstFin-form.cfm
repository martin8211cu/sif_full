<cfinvoke  key="BTN_TCAdicional" default="TC Adicional" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_TCAdicional" xmlfile="ConversionEstFin-form.xml"/>
<cfinvoke  key="BTN_Generar" default="Generar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Generar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Actualizar" default="Actualizar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Actualizar" xmlfile="/sif/generales.xml"/>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Averiguar el Primer Mes Contable Cerrado que no exista en HtiposcambioConversion --->
<cfquery name="TotalMayores" datasource="#Session.DSN#">
	select count(1) cantidad from CtasMayor where Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="TotalMayoresConfig" datasource="#Session.DSN#">
	select count(1) cantidad from CtasMayor where CTCconversion > 0 and Ecodigo = #session.Ecodigo#
</cfquery>
<cfquery name="rsParam1" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 30
</cfquery>

<cfquery name="rsParam2" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 40
</cfquery>

<cfquery name="rsParamTCpres" datasource="#Session.DSN#">
	select Pvalor 
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	and Pcodigo = 1150
</cfquery>

<cfif rsParamTCpres.recordcount gt 0>
	<cfset UtilizaTCpres = rsParamTCpres.Pvalor>
</cfif>

<cfif (isdefined('UtilizaTCpres') and UtilizaTCpres eq 'N') and isdefined('LvarCPConsolidacionPresupuesto')>
	<cf_errorCode	code = "0" msg = "No se ha defindo el parametro Tipos de cambio de conversion en control de presupuesto de Parametros Adicionales">
</cfif>

<cfset UltimoPeriodo = rsParam1.Pvalor>
<cfset UltimoMes = rsParam2.Pvalor - 1>
<cfif UltimoMes EQ 0>
	<cfset UltimoPeriodo = rsParam1.Pvalor - 1>
	<cfset UltimoMes = 12>
</cfif>

<cfquery name="tiposcambioconversion" datasource="#Session.DSN#">
	select count(1) as cantidad
	from HtiposcambioConversion
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Si existen historicos de cambios de conversion de moneda --->
<cfif tiposcambioconversion.cantidad GT 0>
	<cfquery name="rsNextPeriodoConversion" datasource="#Session.DSN#">
		select coalesce(max(Speriodo * 100 + Smes), 0) as Next
		from HtiposcambioConversion tc
		where tc.Ecodigo = #Session.Ecodigo#
		  and tc.Speriodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#UltimoPeriodo#">
		  and (tc.Speriodo * 100 + tc.Smes) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#(UltimoPeriodo * 100) + UltimoMes#">
	</cfquery>
	<cfset NextMes = Mid(rsNextPeriodoConversion.Next, 5, 2)>
	<cfset NextMes = NextMes + 1>
	<cfif NextMes EQ 13>
		<cfset NextPeriodo = Mid(rsNextPeriodoConversion.Next, 1, 4) + 1>
		<cfset NextMes = 1>
	<cfelse>
		<cfset NextPeriodo = Mid(rsNextPeriodoConversion.Next, 1, 4)>
	</cfif>

<!--- Si NO existen historicos de cambios de conversion de moneda se obtiene el mínimo de Saldos Contables --->
<cfelse>
	<cfquery name="rsNextPeriodoConversion" datasource="#Session.DSN#">
		select coalesce(min(Speriodo * 100 + Smes), 0) as Next
		from SaldosContables s
		where s.Ecodigo = #Session.Ecodigo#
		  and s.Speriodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#UltimoPeriodo#">
		  and (s.Speriodo * 100 + s.Smes) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#(UltimoPeriodo * 100) + UltimoMes#">
	</cfquery>

	<cfset NextMes = Mid(rsNextPeriodoConversion.Next, 5, 2)>
	<cfset NextPeriodo = Mid(rsNextPeriodoConversion.Next, 1, 4)>
</cfif>
<cfif not (rsNextPeriodoConversion.recordCount and rsNextPeriodoConversion.Next NEQ 0)>
	<cfset NextPeriodo = 0>
	<cfset NextMes = 0>
</cfif>

<cfif NextPeriodo NEQ 0 and NextMes NEQ 0>
	<!--- Averiguar si existe la moneda de conversión en la tabla de Parametros --->
	<cfquery name="rsParamConversion" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 660
	</cfquery>
	
	<cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo, Mnombre #_Cat# ' (' #_Cat# Miso4217 #_Cat# ') ' as Mnombre
		 from Monedas
		where Ecodigo = #Session.Ecodigo#
		order by Miso4217
	</cfquery>
	
	<cfset Meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
<!---verifica que exista Cuenta de diferencial cambiario para conversión de estados---->
	<cfquery name="rsCuentaDCCE" datasource="#Session.DSN#">
		select Pvalor
		  from Parametros 
		where Ecodigo = #Session.Ecodigo#  
		 and Pcodigo = 810
		 and Pvalor is not null
	</cfquery>
	
	<script src="/cfmx/sif/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="javascript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	</script>
	
	<!--- Si la moneda de conversión sí existe en la tabla de parámetros, entonces capturar los tipos de cambio para el primer mes cerrado que no exista en HtiposcambioConversion --->
	<cfif rsParamConversion.recordCount>
		<cfquery name="rsMonedaConversion" datasource="#Session.DSN#">
			select Mcodigo, {fn concat ( {fn concat ( {fn concat ( Mnombre, ' (' )}, Miso4217)}, ') ')} as Mnombre
			from Monedas
			where Ecodigo = #Session.Ecodigo#
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion.Pvalor#">
		</cfquery>
		<cfoutput>
		<form name="form1" method="post" action="ConversionEstFin-sql.cfm" style="margin: 0;" onSubmit="javascript: validar(this);">
			<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td colspan="5">
					<input type="hidden" name="Speriodo" value="#NextPeriodo#">
					<input type="hidden" name="Smes" value="#NextMes#">
					<input type="hidden" name="Mcodigo" value="#rsMonedaConversion.Mcodigo#">
					<cfif isdefined('UtilizaTCpres') and UtilizaTCpres eq 'S'>	
						<input type="hidden" name="UtilizaTCpres" value="#UtilizaTCpres#">	
					</cfif>
					<cfif isdefined('LvarCPConsolidacionPresupuesto')>
						<input type="hidden" name="LvarCPConsolidacionPresupuesto" value="#LvarCPConsolidacionPresupuesto#">	
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td colspan="5" class="tituloAlterno"><cf_translate key=LB_TituloA>GENERAR TIPOS DE CAMBIO PARA LAS MONEDAS DE CONVERSI&Oacute;N PARA ESTADOS FINANCIEROS</cf_translate></td>
			  </tr>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="5">
					<table border="0" cellspacing="0" cellpadding="2" align="center">
					  <tr>
						<td><strong><cf_translate key=LB_PeriodoContable>Per&iacute;odo Contable</cf_translate>:</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>#NextPeriodo#&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><strong><cf_translate key=LB_MesContable>Mes Contable</cf_translate>:</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>#ListGetAt(meses, NextMes, ',')#</td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
			  	<td colspan="5">
					<table border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
							<td><strong><cf_translate key=LB_CuentaDiffCamb>Cuenta de diferencial cambiario</cf_translate>:&nbsp;</strong></td>
							<td>
								<cfif isdefined('rsCuentaDCCE') and rsCuentaDCCE.recordCount>
									<cfquery name="rsCuentaDifCambAs" datasource="#Session.DSN#">
										select CFdescripcion, CFcuenta, CFformato, Ccuenta
										 from CFinanciera
										where CFcuenta =(select coalesce(<cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#">,-1)
														   from Parametros
														  where Ecodigo = #Session.Ecodigo#  
															and Pcodigo = 810)
									</cfquery>
								</cfif>
									
									<cfif isdefined('rsCuentaDifCambAs') and rsCuentaDifCambAs.RecordCount GT 0 and rsCuentaDifCambAs.CFcuenta NEQ ''>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										query="#rsCuentaDifCambAs#" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="CCuentaDifCambAsi"
										Cformato="FCDifCambAsi" 
										Cmayor="MCDifCambAsi">
									<cfelse>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="CCuentaDifCambAsi"
										Cformato="FCDifCambAsi" 
										Cmayor="MCDifCambAsi" 												
										>							
									</cfif> 
							</td>
						</tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>			  
			  <cf_tabs width="100%" onclick="tab_set_current_param">
			  	<cf_tab text="Consolidaci&oacute;n Contable" id="0">
						<table>
							<tr bgcolor="##CCCCCC">
								<td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_MonedaOrigen>Moneda Origen</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_MonedaConversion>Moneda Conversi&oacute;n</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_TipoCambioVenta>Tipo de Cambio (Venta)</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_LB_TipoCambiocompra>Tipo de Cambio (Compra)</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_LB_TipoCambioPromedio>Tipo de Cambio (promedio)</cf_translate></strong>
								</td>
						  </tr>
						  <cfloop query="rsMonedas">
						  <tr>  
								<td align="center"> #rsMonedas.Mnombre# </td>
								<td align="center"> #rsMonedaConversion.Mnombre# </td>
								<td align="center">
									<input name="TCambioV_#rsMonedas.Mcodigo#_0" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" 
										   onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
										   value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000<cfelse>0.00000</cfif>" 
											<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  readonly="true" style=" text-align:right; border: none;"  
										   <cfelse> style="text-align: right;" </cfif>>
								</td>
								<td align="center">
									<input name="TCambioC_#rsMonedas.Mcodigo#_0" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" 
										   onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
										   value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000<cfelse>0.00000</cfif>" 
										   <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  readonly="true" style=" text-align:right; border: none;"  
										   <cfelse> style="text-align: right;" </cfif>>
								</td>
								<td align="center">
									<input name="TCambioP_#rsMonedas.Mcodigo#_0" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
									value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000<cfelse>0.00000</cfif>" 
									<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  readonly="true" style=" text-align:right; border: none;"  
									<cfelse> style="text-align: right;" </cfif>>
								</td>
						  </tr>
						  
						  </cfloop>
						  </table>
				</cf_tab>
				<cfif isdefined('UtilizaTCpres') and UtilizaTCpres eq 'S'>
					<cf_tab text="Consolidaci&oacute;n Presupuestal" id="1">
						<table>
							<tr bgcolor="##CCCCCC">
								<td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_MonedaOrigen>Moneda Origen</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_MonedaConversion>Moneda Conversi&oacute;n</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_TipoCambioVenta>Tipo de Cambio (Venta)</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_TipoCambioCompra>Tipo de Cambio (compra)</cf_translate></strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong><cf_translate key=LB_TipoCambioPromedio>Tipo de Cambio (promedio)</cf_translate></strong>
								</td>
							</tr>
							<cfloop query="rsMonedas">
							<tr>
								<td align="center"> #rsMonedas.Mnombre# </td>
								<td align="center"> #rsMonedaConversion.Mnombre# </td>
								<td align="center">
									<input name="TCambioV_#rsMonedas.Mcodigo#_1" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" 
										   onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
										   value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000<cfelse>0.00000</cfif>" 
										   <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  readonly="true" style=" text-align:right; border: none;"  
											   <cfelse> style="text-align: right;" </cfif>>
								</td>
								<td align="center">
									<input name="TCambioC_#rsMonedas.Mcodigo#_1" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" 
										   onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
										   value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000<cfelse>0.00000</cfif>" 
										   <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  readonly="true" style=" text-align:right; border: none;"  
											   <cfelse> style="text-align: right;" </cfif>>
								</td>
								<td align="center">
									<input name="TCambioP_#rsMonedas.Mcodigo#_1" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" 
									value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000<cfelse>0.00000</cfif>" 
									<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>  readonly="true" style=" text-align:right; border: none;"  
											   <cfelse> style="text-align: right;" </cfif>>
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
							<cfif TotalMayoresConfig.cantidad GT 0 and TotalMayoresConfig.cantidad NEQ TotalMayores.cantidad>
								<img src="../../imagenes/deletestop.gif" width="16" height="16" />
								<font color="##FF0000">Existen Mayores sin el parámetro “TC en Conversión de Estados Financieros” configurado. Debe configurarlas para poder continuar.</font>
							<cfelse>
								<input type="submit" name="btnGenerar" value="#BTN_Generar#">
								<input type="button" name="btnTCHistoricos" value="#BTN_TCAdicional#" onClick="TCHist();">
							</cfif>
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
			function validar(f) {
		  	<cfloop list="0,1" index="LvarTipo">
			  <cfoutput query="rsMonedas">
				f.obj.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.value = qf(f.obj.TCambioC_#rsMonedas.Mcodigo#.value);
				f.obj.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.value = qf(f.obj.TCambioV_#rsMonedas.Mcodigo#.value);
				f.obj.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.value = qf(f.obj.TCambioP_#rsMonedas.Mcodigo#.value);
				
				f.obj.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.disabled = false;
				f.obj.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.disabled = false;
				f.obj.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.disabled = false;
			  </cfoutput>
			</cfloop>
			}
			
			function TCHist() {
				document.form1.action='TCHistoricos.cfm';
				document.form1.submit();
				return false;
			}
	
			function __isNotCero() {
				if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
					this.error = "El campo " + this.description + " no puede ser cero!";
				}
			}
	
			qFormAPI.errorColor = "#FFFFCC";
			objForm = new qForm("form1");
			_addValidator("isNotCero", __isNotCero);
			
		<cfif isdefined('UtilizaTCpres') and UtilizaTCpres eq 'S'>
			<cfset ListTCContaPres = "0,1">
		<cfelse>
			<cfset ListTCContaPres = "0">			
		</cfif>
	  	<cfloop list=#ListTCContaPres# index="LvarTipo">
		  <cfoutput query="rsMonedas">
				<cfif LvarTipo EQ "0">
					<cfset LvarLblTipo = "Contable">
				<cfelse>
					<cfset LvarLblTipo = "Presupuestal">
				</cfif>
				objForm.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.required = true;
				objForm.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.description = "Tipo de Cambio #LvarLblTipo# (Compra) para #rsMonedas.Mnombre#";
				objForm.TCambioC_#rsMonedas.Mcodigo#_#LvarTipo#.validateNotCero();
				
				objForm.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.required = true;
				objForm.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.description = "Tipo de Cambio #LvarLblTipo# (Venta) para #rsMonedas.Mnombre#";
				objForm.TCambioV_#rsMonedas.Mcodigo#_#LvarTipo#.validateNotCero();
				
				objForm.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.required = true;
				objForm.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.description = "Tipo de Cambio #LvarLblTipo# (Promedio) para #rsMonedas.Mnombre#";
				objForm.TCambioP_#rsMonedas.Mcodigo#_#LvarTipo#.validateNotCero();
		  </cfoutput>
		</cfloop>			
		  objForm.CCuentaDifCambAsi.required = true;
		  objForm.CCuentaDifCambAsi.description = "Cuenta de diferencial cambiario";
			
		</script>
		
	<cfelse>

		<cfoutput>
		<form name="form1" method="post" action="ConversionEstFin-sql.cfm" style="margin: 0;" onSubmit="javascript: validar(this);">
			<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr>
				<td colspan="5">
					<input type="hidden" name="Speriodo" value="#NextPeriodo#">
					<input type="hidden" name="Smes" value="#NextMes#">
				</td>
			  </tr>
			  <tr>
				<td colspan="5" class="tituloAlterno">GENERAR TIPOS DE CAMBIO PARA LAS MONEDAS DE CONVERSI&Oacute;N PARA ESTADOS FINANCIEROS</td>
			  </tr>
			  <tr>
				<td colspan="2" align="right" width="50%"><strong><cf_translate key=LB_SeleccioneMoneda>Seleccione una moneda de conversión para estados financieros</cf_translate>:</strong></td>
				<td>
					<select name="Mcodigo">
					<cfloop query="rsMonedas">
						<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
					</cfloop>
					</select>
				</td>
			  </tr>
			  <tr>
				<td colspan="5">&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center" colspan="5">
					<cfoutput><input type="submit" name="btnActualizar" value="#BTN_Actualizar#"></cfoutput>
				</td>
			  </tr>
			</table>
		</form>
		</cfoutput>			
	</cfif>
	

<!--- No hay más tipos de cambio por actualizar ---->
<cfelse>
	<p align="center">
		<strong>No hay más tipos de cambio para generar por el momento</strong>
	</p>
	<br>
</cfif>
<script type="text/javascript" language="javascript">
	function validar(f){
	
	}
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
</script>
