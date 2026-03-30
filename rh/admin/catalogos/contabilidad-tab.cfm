     <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >

		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_Contabilizacion">Contabilizaci&oacute;n</cf_translate></strong></font>			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td >
				<input name="IContable" type="checkbox" tabindex="1" <cfif existeIContable eq '1' and trim(PvalorIContable.Pvalor) neq '0' >checked</cfif>
						onclick="if (!this.checked) document.form1.CHK_ControlPresupuestoNominas.checked=false;">
				<cf_translate key="CHK_InterfazConContabilidad">Interfaz con Contabilidad</cf_translate>			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td colspan="2"><!--- Pvalor 541--->
				&nbsp;&nbsp;&nbsp;
				<input name="CHK_ControlPresupuestoNominas"
					type="checkbox" onclick="if (!document.form1.IContable.checked) document.form1.CHK_ControlPresupuestoNominas.checked=false;"
					<cfif PvalorValidaControlPresupuestoNomina.RecordCount GT 0 and PvalorValidaControlPresupuestoNomina.Pvalor eq '1'
						and
						  existeIContable eq '1' and trim(PvalorIContable.Pvalor) neq '0'>
					checked
					</cfif> >
				<cf_translate key="LB_ControlPresupuestoNomina">Control de Presupuesto al Aplicar y Finalizar N?mina</cf_translate>:
				<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- En Aplicar Relaci?n C?lculo N&oacute;mina genera Compromiso
				<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- En Finalizar Pago de N&oacute;mina genera Descompromiso y Ejecucion
				</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>
				<input name="ACUnificado" type="checkbox" tabindex="1"
						<cfif PvalorACUnificado.RecordCount GT 0 and PvalorACUnificado.Pvalor eq '1'>checked</cfif> >
				<cf_translate key="CHK_AsientoContableUnificado">Asiento Contable Unificado</cf_translate>			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2"><!--- Pvalor 545--->
				<input name="CHK_IntegracionModuloTesoreria" type="checkbox" tabindex="1" <cfif trim(PvalorIntegracionTesoreria.Pvalor) eq '1' >checked</cfif>>
				<cf_translate key="CHK_IntegracionConModuloTesoreria">Integración con módulo de tesoreria</cf_translate>
				<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_IntegracionconTesoreria"   Default="Integración con tesoreria"    returnvariable="LB_IntegracionconTesoreria"/>
				<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_IntegracionconTesoreriaExplica"   Default="Si se marca este parámetro, desde tesoreria se generará la salida de bancos del Salario liquido y generará las solicitudes de Pago de retenciones."    returnvariable="LB_IntegracionconTesoreriaExplica"/>
				<cf_notas titulo="#LB_IntegracionconTesoreria#" link="#helpimg#" pageIndex="2" msg = "#LB_IntegracionconTesoreriaExplica#" animar="true">
			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_ConfiguracionDePagoDeNomina">Configuraci&oacute;n de Pago de N&oacute;mina</cf_translate>:&nbsp;</td>
			<td>
				<select name="PagoNomina" tabindex="1">
					<option value="1" <cfif existePagoNomina and PvalorPagoNomina.Pvalor eq '1' >selected</cfif> ><cf_translate key="CMB_RHsinConexionalBanco">RH sin Conexion al Banco</cf_translate></option>
					<option value="2" <cfif existePagoNomina and PvalorPagoNomina.Pvalor eq '2' >selected</cfif> ><cf_translate key="CMB_RHconConexionalBanco">RH con Conexion al Bancov</cf_translate></option>
					<option value="3" <cfif existePagoNomina and PvalorPagoNomina.Pvalor eq '3' >selected</cfif> ><cf_translate key="CMB_SinRHsinConexionalBanco">Sin RH sin Conexion al Banco</cf_translate></option>
					<option value="4" <cfif existePagoNomina and PvalorPagoNomina.Pvalor eq '4' >selected</cfif> ><cf_translate key="CMB_SinRHconConexionalBanco">Sin RH con Conexion al Banco</cf_translate></option>
				</select>			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>	<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0"><font size="2" color="#000000"></font></td> <td>&nbsp;</td>
		</tr>



		<!---Parametro Utilizar Tamblas de renta segun el tipo de nomina ljimenez--->
        <tr>
				<td align="right" nowrap>&nbsp;</td>
				<td align="right" nowrap></td>
				<td>
					<input name="RentaTipoNomina" id="RentaTipoNomina" type="checkbox" tabindex="3" onchange="TRRenta();" <cfif PvalorRentaTipoNomina.RecordCount GT 0 and trim(PvalorRentaTipoNomina.Pvalor) eq '1' > checked </cfif> >
				<cf_translate key="CHK_RentaTipoNomina">Utilizar Tabla de Renta por Tipo N&oacute;mina</cf_translate>
        </td></tr>
		<!---Fin Parametro Utilizar Tamblas de renta segun el tipo de nomina ljimenez --->


		<tr  id="trTablaRenta" >
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_TablaDeImpuestoDeRenta">Tabla de Impuesto de Renta</cf_translate>:&nbsp;</td>
			<td>
				<!--- trae la descripcion del impuesto de renta --->
				<cfset values = ''>
				<cfif PvalorIRenta.RecordCount GT 0 >
					<cfif len(trim(PvalorIRenta.Pvalor)) GT 0 >
						<cfquery name="rsTraeIRenta" datasource="#session.DSN#">
							select IRcodigo, rtrim(ltrim(IRdescripcion)) as IRdescripcion
							from ImpuestoRenta
							where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(PvalorIRenta.Pvalor)#">
						</cfquery>
						<cfset values = '#rsTraeIRenta.IRcodigo#,#rsTraeIRenta.IRdescripcion#'>
					</cfif>
				</cfif>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_ListadeTablasdeRenta"
					default="Lista de Tablas de Renta"
					returnvariable="LB_ListadeTablasdeRenta"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Codigo"
					default="C&oacute;digo"
					returnvariable="LB_Codigo"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Descripcion"
					default="Descripci&oacute;n"
					returnvariable="LB_Descripcion"/>

				<cf_conlis title="#LB_ListadeTablasdeRenta#"
					campos = "IRcodigo,IRdescripcion"
					desplegables = "S,S"
					size = "10,50"
					values="#values#"
					tabla="ImpuestoRenta"
					columnas="IRcodigo,IRdescripcion"
					filtro=""
					desplegar="IRcodigo,IRdescripcion"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					conexion="#session.DSN#"
					form = "form1"
					tabindex="1">			</td>
			<td></td>
		</tr>






		<!--- trae el nombre de los archivos componentes de renta ljimenez --->
				<tr>
				<td align="right" nowrap>&nbsp;</td>
				<td align="right" nowrap><cf_translate key="LB_ComponenteDeRenta">Componente de Renta</cf_translate>:&nbsp;</td>
				<td>
					<cfoutput>
					<select name="ComponenteRenta" tabindex="RH_CalculoNominaRentaCR.cfc">
						<option value="RH_CalculoNominaRentaCR.cfc"  <cfif PvalorComponenteRenta.Pvalor eq 'RH_CalculoNominaRentaCR.cfc' >selected</cfif>> <cf_translate key="CMB_RH_CalculoNominaRentaCR"> Componente para Costa Rica</cf_translate></option>
						<option value="RH_CalculoNominaRentaMEX.cfc" <cfif PvalorComponenteRenta.Pvalor eq 'RH_CalculoNominaRentaMEX.cfc'>selected</cfif>> <cf_translate key="CMB_RH_CalculoNominaRentaMEX"> Componente para M&eacute;xico</cf_translate></option>
						<option value="RH_CalculoNominaRentaPR.cfc"  <cfif PvalorComponenteRenta.Pvalor eq 'RH_CalculoNominaRentaPR.cfc' >selected</cfif>> <cf_translate key="CMB_RH_CalculoNominaRentaPR"> Componente para Puerto Rico</cf_translate></option>
						<option value="RH_CalculoNominaRentaSLV.cfc" <cfif PvalorComponenteRenta.Pvalor eq 'RH_CalculoNominaRentaSLV.cfc'>selected</cfif>> <cf_translate key="CMB_RH_CalculoNominaRentaSLV"> Componente para EL Salvador</cf_translate></option>
						<option value="RH_CalculoNominaRentaNIC.cfc" <cfif PvalorComponenteRenta.Pvalor eq 'RH_CalculoNominaRentaNIC.cfc'>selected</cfif>> <cf_translate key="CMB_RH_CalculoNominaRentaNIC"> Componente para Nicaragua</cf_translate></option>
					</select>
				</cfoutput>				</td></tr>

				<tr><!---Parametro Calculo de renta Retroactivo ljimenez TEC--->
				<td align="right" nowrap>&nbsp;</td>
				<td align="right" nowrap></td>
				<td>
					<input name="CalculoRentaRetroactivo" type="checkbox" tabindex="3" <cfif PvalorCalculoRentaRetroactivo.RecordCount GT 0 and trim(PvalorCalculoRentaRetroactivo.Pvalor) eq '1' > checked </cfif> >
				<cf_translate key="CHK_CalculoRentaRetroactivo">Calculo de Renta Retroactivo</cf_translate>
                </td></tr><!---Fin Parametro Calculo de renta Retroactivo ljimenez TEC--->
        <!---Parámetro Pcodigo 35 Tabla Mensual para Liquidación y Finiquito Inicia--->
        <tr>
            <td align="right" nowrap>&nbsp;</td>
            <td align="right" nowrap><cf_translate key="LB_TablaMensualLiqFin">Tabla Mensual para Liquidación y Finiquito</cf_translate>:&nbsp;</td>
            <td>
                <cfquery name="rsImpuestoRenta" datasource="#Session.DSN#">
                    select IRcodigo,IRdescripcion
                    from ImpuestoRenta
                    where coalesce(IRcodigoPadre,'') = ''
                    order by IRcodigo
                </cfquery>
                <cfoutput>
					<select name="ImpuestoRenta" tabindex="1">
						<option value="">- <cf_translate key="CMB_Ninguna">Ninguna</cf_translate> -</option>
						<cfloop query="rsImpuestoRenta">
							<option value="#rsImpuestoRenta.IRcodigo#"
						  		<cfif trim(PvalorTablaMensualLiqFin.Pvalor) eq trim(rsImpuestoRenta.IRcodigo) >
									selected
								</cfif> >
								#rsImpuestoRenta.IRcodigo# - #rsImpuestoRenta.IRdescripcion#
							</option>
						</cfloop>
				  	</select>
                </cfoutput>
            </td>
		<tr>
        <!---Parámetro Pcodigo 35 Tabla Mensual para Liquidación y Finiquito Fin--->
		<tr>
			<td>&nbsp;</td>	<td colspan="2" bgcolor="#FAFAFA" align="center"><hr size="0"><font size="2" color="#000000"></font></td> <td>&nbsp;</td>
		</tr>
        <!---Parámetro Pcodigo 45 Régimen Fiscal para Facturación CFDI Inicia--->
        <tr>
            <td align="right" nowrap>&nbsp;</td>
            <td align="right" nowrap><cf_translate key="LB_TablaMensualLiqFin">Régimen Fiscal para Facturación CFDI</cf_translate>:&nbsp;</td>
            <td>
                <cfquery name="rsRegFiscal" datasource="#Session.DSN#">
                    select id_RegFiscal,codigo_RegFiscal,nombre_RegFiscal,persona_Fisica
                    from FARegFiscal
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    order by codigo_RegFiscal
                </cfquery>

                <cfoutput>
					<select name="RegFiscal" id="RegFiscal" tabindex="1">
						<option value="">- <cf_translate key="CMB_Ninguno">Ninguno</cf_translate> -</option>
						<cfloop query="rsRegFiscal">
							<option value="#rsRegFiscal.id_RegFiscal#"<cfif trim(PvalorRegFiscalCFDI.Pvalor) eq trim(rsRegFiscal.id_RegFiscal)>selected</cfif>>
								#rsRegFiscal.codigo_RegFiscal# - #rsRegFiscal.nombre_RegFiscal#
							</option>
						</cfloop>
						<cfloop query="rsRegFiscal">
							<input type="hidden" name="tipoP_#rsRegFiscal.id_RegFiscal#" id="tipoP_#rsRegFiscal.id_RegFiscal#" value="#rsRegFiscal.persona_Fisica#"/>
						</cfloop>
				  	</select>
                </cfoutput>
            </td>
		</tr>
		<!--- oparrales 08/06/2017 --->
		<tr>
			<cfoutput>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_TablaMensualLiqFin">CURP Persona F&iacute;sica</cf_translate>:&nbsp;</td>
			<td align="left" nowrap><input onKeyUp="ToUpper(this);" name="CurpPFisica" id="CurpPFisica" type="text" maxlength="18" value="#PvalorCurpPFisica.Pvalor#"></td>
			<td>&nbsp;</td>
			</cfoutput>
		</tr>
        <!---Parámetro Pcodigo 45 Régimen Fiscal para Facturación CFDI Fin--->


		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_CantidadDeDiasParaGeneracionDeCalendarioSemanal">Cantidad de d&iacute;as para generaci&oacute;n de Calendario Semanal</cf_translate>:&nbsp;</td>
			<td>
				<input name="TPSemanal" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); asignar(this, 'S');"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorTPSemanal.RecordCount GT 0 ><cfoutput>#PvalorTPSemanal.Pvalor#</cfoutput><cfelse>7</cfif>"
					   size="8" maxlength="5" >			</td>
			<td>&nbsp;</td>
		</tr>


		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_CantidadDeDiasParaGeneracionDeCalendarioBiSemanal">Cantidad de d&iacute;as para generaci&oacute;n de Calendario Bisemanal</cf_translate>:&nbsp;</td>
			<td>
				<input name="TPBisemanal" type="text" style="text-align: right;"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); asignar(this, 'B');"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorTPBisemanal.RecordCount GT 0 ><cfoutput>#PvalorTPBisemanal.Pvalor#</cfoutput><cfelse>14</cfif>"
					   size="8" maxlength="5" >			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap>
				<cf_translate key="LB_CantidadDeDiasParaGeneracionDeCalendarioQuincenal">Cantidad de d&iacute;as para generaci&oacute;n de Calendario Quincenal</cf_translate>:&nbsp;</td>
			<td>
				<input name="TPQuincenal" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); asignar(this, 'Q');"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorTPQuincenal.RecordCount GT 0 ><cfoutput>#PvalorTPQuincenal.Pvalor#</cfoutput><cfelse>15</cfif>"
					   size="8" maxlength="5" >			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_CantidadDeDiasParaGeneracionDeCalendarioMensual">Cantidad de d&iacute;as para generaci&oacute;n de Calendario Mensual</cf_translate>:&nbsp;</td>
			<td>
				<input name="TPMensual" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); asignar(this, 'M');"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorTPMensual.RecordCount GT 0 ><cfoutput>#PvalorTPMensual.Pvalor#</cfoutput><cfelse>30</cfif>"
					   size="8" maxlength="5" >			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap>
				<cf_translate key="LB_IndicadorDeDiasDeNoPagoPorTipoNomina">Indicador de d&iacute;as de no pago por Tipo de N&oacute;mina</cf_translate>:&nbsp;</td>
			<td>
				<select name="DiasTipoNomina" tabindex="1">
					<option value="N" <cfif existeDiasTipoNomina and PvalorDiasTipoNomina.Pvalor eq 'N' >selected</cfif> ><cf_translate key="CMB_No">No</cf_translate></option>
					<option value="S" <cfif existeDiasTipoNomina and PvalorDiasTipoNomina.Pvalor eq 'S' >selected</cfif> ><cf_translate key="CMB_Si">S&iacute;</cf_translate></option>
				</select>
		<td>		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_FactordeDiasParaSalarioDiario">Factor de d&iacute;as para salario diario</cf_translate>:&nbsp;</td>
			<td>
				<input name="CNMensual" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,4); asignar(this, 'M');"
					   onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorCNMensual.RecordCount GT 0 ><cfoutput>#PvalorCNMensual.Pvalor#</cfoutput><cfelse>30</cfif>"
					   size="8" maxlength="7" >			</td>
			<td>&nbsp;</td>
		</tr>


		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_RedondeoaMonto">Redondeo a Monto</cf_translate>:&nbsp;</td>
			<td>
				<input name="RedondeoMonto" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,2);"
					   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorCNMensual.RecordCount GT 0 ><cfoutput>#LSCurrencyFormat(PvalorRedondeoMonto.Pvalor, 'none')#</cfoutput><cfelse>0.00</cfif>"
  					   size="8" maxlength="8" >			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_TipoDeRedondeo">Tipo de Redondeo</cf_translate>:&nbsp;</td>
			<td>
				<select name="TipoRedondeo" tabindex="1">
						<option value="1"
							<cfif PvalorTipoRedondeo.RecordCount GT 0 and PvalorTipoRedondeo.Pvalor EQ 1>
								<cfoutput>selected</cfoutput>
							</cfif>>
							<cf_translate key="CMB_AlMasCercano">Al M&aacute;s Cercano</cf_translate>
						</option>
						<option value="2"
							<cfif PvalorTipoRedondeo.RecordCount GT 0 and PvalorTipoRedondeo.Pvalor EQ 2>
								<cfoutput>selected</cfoutput>
							</cfif>>
							<cf_translate key="CMB_Superior">Superior</cf_translate>
						</option>
				</select>			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_SalarioMinimoMensual">Salario m&iacute;nimo mensual</cf_translate>:&nbsp;</td>
			<td>
				<input name="SMmensual" type="text" style="text-align: right;" tabindex="1"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,2); asignar(this, 'M');"
					   onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorSMmensual.RecordCount GT 0 ><cfoutput>#LSCurrencyFormat(PvalorSMmensual.Pvalor,'none')#</cfoutput><cfelse>0.00</cfif>"
						size="16" maxlength="16" >			</td>
			<td>&nbsp;</td>
		</tr>


		<tr>
		  	<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_CuentaContabledeRenta">Cuenta Contable de Renta</cf_translate>:&nbsp;</td>
			<cfif existeCuentaRenta eq 1 and len(trim(PvalorCuentaRenta.Pvalor)) GT 0 >
				<cfset cuentaRenta = PvalorCuentaRenta.Pvalor >
			<cfelse>
				<cfset cuentaRenta = -1 >
			</cfif>
			<cfquery name="rsCuentaRenta" datasource="#session.DSN#">
				select Ccuenta, Cmayor, Cformato, Cdescripcion
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaRenta#">
			</cfquery>
			<td>
				<cfif rsCuentaRenta.RecordCount GT 0>
					<cf_cuentas frame="frCuentaRenta" Ccuenta="CuentaRenta" Cformato="FCuentaRenta"
								Cmayor="MCuentaRenta" Cdescripcion="DCuentaRenta" form="form1" query="#rsCuentaRenta#" tabindex="1">
				<cfelse>
					<cf_cuentas frame="frCuentaRenta" Ccuenta="CuentaRenta" Cformato="FCuentaRenta"
								Cmayor="MCuentaRenta" Cdescripcion="DCuentaRenta" form="form1" tabindex="1">
				</cfif>			
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td><!--- existeCuentaAsimilados,PvalorCuentaAsimilados --->
			<td align="right" nowrap><cf_translate key="LB_CuentaContabledeAsimilados">Cuenta Contable de Asimilados</cf_translate>:&nbsp;</td>
			<cfif existeCuentaAsimilados eq 1 and len(trim(PvalorCuentaAsimilados.Pvalor)) GT 0 >
				<cfset cuentaAsimilados = PvalorCuentaAsimilados.Pvalor >
			<cfelse>
				<cfset cuentaAsimilados = -1 >
			</cfif>
			<cfquery name="rsCuentaAsimilados" datasource="#session.DSN#">
				select Ccuenta, Cmayor, Cformato, Cdescripcion
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaAsimilados#">
			</cfquery>
			<td>
				<cfif rsCuentaAsimilados.RecordCount GT 0>
					<cf_cuentas frame="frCuentaAsimilados" Ccuenta="CuentaAsimilados" Cformato="FCuentaAsimilados"
								Cmayor="MCuentaAsimilados" Cdescripcion="DCuentaAsimilados" form="form1" query="#rsCuentaAsimilados#" tabindex="1">
				<cfelse>
					<cf_cuentas frame="frCuentaAsimilados" Ccuenta="CuentaAsimilados" Cformato="FCuentaAsimilados"
								Cmayor="MCuentaAsimilados" Cdescripcion="DCuentaAsimilados" form="form1" tabindex="1">
				</cfif>			
			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><cf_translate key="LB_CuentaContabledePagosnoRealizado">Cuenta Contable de Pagos no Realizados</cf_translate>:&nbsp;</td>
			<cfif existeCuentaPagos eq 1 and len(trim(PvalorCuentaPagos.Pvalor)) GT 0 >
				<cfset cuentaPagos = PvalorCuentaPagos.Pvalor >
			<cfelse>
				<cfset cuentaPagos = -1 >
			</cfif>
			<cfquery name="rsCuentaPagos" datasource="#session.DSN#">
				select Ccuenta, Cmayor, Cformato, Cdescripcion
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaPagos#">
			</cfquery>
			<td>
				<cfif rsCuentaRenta.RecordCount GT 0>
					<cf_cuentas frame="frCuentaPagos" Ccuenta="CuentaPagos" Cformato="FCuentaPagos"
								Cmayor="MCuentaPagos" Cdescripcion="DCuentaPagos" form="form1" query="#rsCuentaPagos#" tabindex="2">
				<cfelse>
					<cf_cuentas frame="frCuentaPagos" Ccuenta="CuentaPagos" Cformato="FCuentaPagos"
								Cmayor="MCuentaPagos" Cdescripcion="DCuentaPagos" form="form1"  tabindex="2">
				</cfif>			</td>
			<td>&nbsp;</td>
		</tr>

		<tr>
<!--- JC --->
<!--- Hace un combo que permite elegir si es meses o periodos --->
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap>
			<cf_translate key="LB_CantidadDe">Cantidad de </cf_translate>

				<select id="mesesoperiodos" name="mesesoperiodos">
					<option value='0' <cfif TiposDePeriodos eq '0' >selected</cfif> ><cf_translate key="CMB_Periodos">Periodos</cf_translate></option>
					<option value='1' <cfif TiposDePeriodos eq '1' >selected</cfif> ><cf_translate key="CMB_Meses">Meses</cf_translate> </option>
				</select>
			<cf_translate key="LB_ParaCalculoDeSalarioPromedioDiario">para c&aacute;lculo de salario promedio diario</cf_translate>:&nbsp;</td>
<!--- fin de cambios JC --->
			<td>
				<input name="SPDPeriodos" type="text" style="text-align: right;" tabindex="3"
					   onfocus="javascript:this.value=qf(this); this.select();"
					   onblur="javascript:fm(this,-1); if ( trim(this.value) == '' ){ this.value = 0; }"
					   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}"
					   value="<cfif PvalorPeriodos.RecordCount GT 0 ><cfoutput>#PvalorPeriodos.Pvalor#</cfoutput><cfelse>0</cfif>"
					   size="8" maxlength="5" >			</td>
			<td>&nbsp;</td>
		</tr>

		<tr><td colspan="4"><hr size="0"><td>&nbsp;</td></tr>

		<tr><td colspan="4" align="center"><b>Distribuci&oacute;n Contable</b></td></tr>
				<tr><td></td></tr>
		<tr>
			<td colspan="2"></td>
			<td colspan="2">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input name="Check_DistribuyeCargas" type="checkbox" tabindex="4"
							<cfif PvalorCheckDistribuyeCargasIncidencias.recordcount GT 0
									 and trim(PvalorCheckDistribuyeCargasIncidencias.Pvalor) eq '1'> checked </cfif> ></td>
						<td><cf_translate key="CHK_DistribuyeCargasIncidencias">Distribuir Cargas Patronales seg&uacute;n gasto por Centro Funcional</cf_translate></td>
					</tr>
				</table>
			</td>

  		</tr>

		<tr><td colspan="4"><hr size="0"><td>&nbsp;</td></tr>

		<tr>
			<td nowrap colspan="2">&nbsp;</td>
			<td colspan="2">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input name="CorreoPago" type="checkbox" tabindex="3" <cfif existeCorreoPago eq '1' and trim(PvalorCorreoPago.Pvalor) neq '0' > checked </cfif> ></td>
						<td><cf_translate key="CHK_EnviarCorreodeBoletadePagoAlAdministrador">Enviar Correo de Boleta de Pago al Administrador</cf_translate></td>
					</tr>
				</table>			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_UsuarioAdministrador">Usuario Administrador</cf_translate>:&nbsp;</td>
			<td colspan="2">
				<cfif existeAdministrador eq 1 >
					<cfquery name="rsAdministrador" datasource="asp">
						select
						{fn concat(b.Pnombre,
						{fn concat(' ',
						{fn concat(b.Papellido1,
						{fn concat(' ',b.Papellido2)})})})}  as Pnombre
						from Usuario a inner join DatosPersonales b
						on a.datos_personales = b.datos_personales
						where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorAdministrador.Pvalor#">
					</cfquery>
				</cfif>
				<input name="Administrador" type="text" id="Administrador" size="40" maxlength="80" readonly tabindex="-1"
					   value="<cfif existeAdministrador eq 1 ><cfoutput>#rsAdministrador.Pnombre#</cfoutput></cfif>" >
				<a href="#" tabindex="-1">
					<img src="/cfmx/rh/imagenes/Description.gif" alt="Seleccionar Administrador" name="imagen"
						 width="18" height="14" border="0" align="absmiddle" onclick="javascript:doAdministrador();">
					<img src="/cfmx/rh/imagenes/Borrar01_S.gif" alt="Seleccionar Administrador" name="imagen" width="18"
						 height="14" border="0" align="absmiddle"
						 onclick="document.form1.Administrador.value=''; document.form1.Adm_Usucodigo.value='';">				</a>
				<input name="Adm_Usucodigo" type="hidden" id="Adm_Usucodigo" value="<cfoutput>#trim(PvalorAdministrador.Pvalor)#</cfoutput>">			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_CuentaCorreoDEenboletaPago">Cuenta de Correo (DE:) en boleta de Pago</cf_translate>:&nbsp;</td>
			<td colspan="2">
				<input name="CorreoBoleta" type="text" onfocus="javascript:this.select();" tabindex="3"
					   value="<cfif PvalorCorreoBoleta.RecordCount GT 0 ><cfoutput>#PvalorCorreoBoleta.Pvalor#</cfoutput></cfif>"
					   size="60" maxlength="60" >
				<a href="#" tabindex="-1">
					<img src="/cfmx/rh/imagenes/Borrar01_S.gif" alt="Limpiar" name="imagen" width="18" height="14" border="0"
						 align="absmiddle" onclick="document.form1.CorreoBoleta.value=''; document.form1.CorreoBoleta.value='';">				</a>			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_AgendaMedica">Agenda M&eacute;dica</cf_translate>:&nbsp;</td>
		  <td colspan="2">
				<cfquery name="rsAgenda"	 datasource="asp">
					select agenda, nombre_agenda
					from ORGAgenda
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					and tipo_agenda = 'R'
			</cfquery>
				<select name="agenda_medica" tabindex="3">
                  <option value="">-
                    <cf_translate key="CMB_Ninguna">Ninguna</cf_translate>
                    -</option>
                  <cfoutput query="rsAgenda">
                    <option value="#rsAgenda.agenda#"<cfif PvalorAgendaMedica.RecordCount GT 0 and trim(PvalorAgendaMedica.Pvalor) EQ trim(rsAgenda.agenda)>selected</cfif>> #rsAgenda.nombre_agenda# </option>
                  </cfoutput>E

		    </select></td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_IncidenciaSalariosRecibidos">Incidencia por Salarios Recibidos</cf_translate>:&nbsp;</td>
			<td colspan="2">
				<cfif PvalorIncidenciasSalRec.recordCount GT 0 and len(trim(PvalorIncidenciasSalRec.Pvalor))>
					<cfquery name="rhIncidencia" datasource="#session.DSN#">
						select CIid, CIcodigo, CIdescripcion
						from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorIncidenciasSalRec.Pvalor#">
					</cfquery>
					<cf_rhcincidentes query="#rhIncidencia#" tabindex="3">
				<cfelse>
					<cf_rhcincidentes tabindex="3">
				</cfif>			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_ScriptExportacionPagoNomina">Script de exportaci&oacute;n de pago de n&oacute;mina</cf_translate>:&nbsp;</td>
			<td colspan="2">
				<cfquery name="rsScriptPagoNomina" datasource="sifcontrol">
					select EIcodigo, EIdescripcion
					from EImportador
					where EImodulo = 'rh.reppag'
					order by EIdescripcion
				</cfquery>
	            <cfoutput>
					<select name="ScriptPagoNomina">
						<option value="">-<cf_translate key="CMB_Ninguno">Ninguno</cf_translate>-</option>
						<cfloop query="rsScriptPagoNomina" >
							<option value="#rsScriptPagoNomina.EIcodigo#"
								<cfif PvalorScriptPagoNomina.recordCount GT 0
									and trim(PvalorScriptPagoNomina.Pvalor) eq trim(rsScriptPagoNomina.EIcodigo)>
									selected</cfif> >
									#rsScriptPagoNomina.EIdescripcion#							</option>
						</cfloop>
					</select>
				</cfoutput>			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="RequiereCF" tabindex="3"
					   type="checkbox"
					   		<cfif  PvalorRequiereCFConta.RecordCount GT 0 and trim( PvalorRequiereCFConta.Pvalor) neq '0' >
								checked
							</cfif> >
							<cf_translate key="CHK_RequerirCentroFuncionalDeContabilizacion">Requerir Centro Funcional de Contabilizaci&oacute;n</cf_translate>			</td>
		</tr>




		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="CentroCostos" tabindex="4"
					   type="checkbox"
						<cfif  PvalorCentroCosto.RecordCount GT 0 and trim(PvalorCentroCosto.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="CHK_CentroDeCostosEquivaleACentroFuncional">Centro de Costos equivale a Centro Funcional</cf_translate>			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="chkLiquidaIntereses" tabindex="4"
					   type="checkbox"
						<cfif  PLiquidaIntereses.RecordCount GT 0 and trim(PLiquidaIntereses.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="CHK_LiquidaIntereses">
							Guardar Informaci&oacute;n para calcular intereses de detalles de Cargas (Cesant&iacute;a)
							al Finalizar N&oacute;mina y permitir generarla al Liquidar un Empleado.						</cf_translate>			</td>
		</tr>
		<!--- PARAMETRO PARA INDICAR SI SE QUIERE HABILITAR EN LOS CATALOGOS CON LA INTERFAZ DE SAP (OE) --->
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="chkInterfazCatSAP" tabindex="4"
					   type="checkbox"
						<cfif  PInterfazCatSAP.RecordCount GT 0 and trim(PInterfazCatSAP.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="CHK_InterfazCatSAP">
							Habilitar Interfaz en Cat&aacute;logos con SAP (OE)						</cf_translate>			</td>
		</tr>

		<!--- PARAMETRO Parmetro General para Validar que los Pagos Ordinarios de una Nmina correspondan a Centros de Costos Activos, si se est utilizando uno inactivo la nmina no puede aplicarse. --->
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="chkVerificacionContable" tabindex="4"
					   type="checkbox"
						<cfif  PvalorVerificaCFConta.RecordCount GT 0 and trim(PvalorVerificaCFConta.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="chk_VerificacionContable">
							Validaci&oacute;n De Centros Funcionales Activos. <!---Verificaci&oacute;n Contable de Centros Funcionales (Pagos Ordinarios)--->
						</cf_translate>			</td>
		</tr>

		<cfquery name="rsIncidenciaLiquidacion" datasource="#session.DSN#">
			select CIid, CIcodigo, CIdescripcion
			from CIncidentes
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CItipo=2
			and CInegativo > 0
			and CIcarreracp = 0
			order by CIcodigo, CIdescripcion
		</cfquery>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_Incidencia_para_calculo_de_liquidacion_de_cesantia">Incidencia para c&aacute;lculo de liquidaci&oacute;n de cesant&iacute;a</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHCesantiaLiquidacion" tabindex="1">
					<option value="">- <cf_translate key="CMB_Ninguna">ninguna</cf_translate> -</option>
					<cfoutput query="rsIncidenciaLiquidacion">
						<option value="#rsIncidenciaLiquidacion.CIid#"
							<cfif PvalorIncidenciaLiquidacion.RecordCount GT 0
								  and trim(PvalorIncidenciaLiquidacion.Pvalor) EQ trim(rsIncidenciaLiquidacion.CIid)>
								selected
							</cfif> >
							#rsIncidenciaLiquidacion.CIcodigo# - #rsIncidenciaLiquidacion.CIdescripcion#						</option>
					</cfoutput>
				</select>			</td>
		</tr>
		<!----======= Incidencias para calculo cesantia por renuncia (940)===========--->
		<cfquery name="rsIncidenciaCesantiaRenuncia" datasource="#session.DSN#">
			select CIid, CIcodigo, CIdescripcion
			from CIncidentes
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CItipo=3
			order by CIcodigo, CIdescripcion
		</cfquery>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_Concepto_de_Pago_para_calculo_de_Cesantia_por_Renuncia">Concepto de Pago para c&aacute;lculo de Cesant&iacute;a por Renuncia</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHIncidenciaRenuncia" tabindex="1">
					<option value="">- <cf_translate key="CMB_Ninguna">Ninguna</cf_translate> -</option>
					<cfoutput query="rsIncidenciaCesantiaRenuncia">
						<option value="#rsIncidenciaCesantiaRenuncia.CIid#"
							<cfif PvalorIncidenciaRenuncia.RecordCount GT 0
								  and trim(PvalorIncidenciaRenuncia.Pvalor) EQ trim(rsIncidenciaCesantiaRenuncia.CIid)>
								selected
							</cfif> >
							#rsIncidenciaCesantiaRenuncia.CIcodigo# - #rsIncidenciaCesantiaRenuncia.CIdescripcion#						</option>
					</cfoutput>
				</select>			</td>
		</tr>
		<!----======= Tipo accion calculo cesantia por renuncia (950)=======---->
		<cfquery name="rsTipoAccionCesantiaRenuncia" datasource="#session.DSN#">
			select RHTid, RHTcodigo, RHTdesc
			from RHTipoAccion
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and RHTcomportam =2
		</cfquery>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_Tipo_de_Accion_para_calculo_de_Cesantia_por_Renuncia">Tipo de Acci&oacute;n para c&aacute;lculo de Cesant&iacute;a por Renuncia</cf_translate>:&nbsp;</td>
			<td>
				<select name="RHTipoAccionRenuncia" tabindex="1">
					<option value="">- <cf_translate key="CMB_Ninguna">Ninguna</cf_translate> -</option>
					<cfoutput query="rsTipoAccionCesantiaRenuncia">
						<option value="#rsTipoAccionCesantiaRenuncia.RHTid#"
							<cfif PvalorTipoAccionRenuncia.RecordCount GT 0
								  and trim(PvalorTipoAccionRenuncia.Pvalor) EQ trim(rsTipoAccionCesantiaRenuncia.RHTid)>
								selected
							</cfif> >
							#rsTipoAccionCesantiaRenuncia.RHTcodigo# - #rsTipoAccionCesantiaRenuncia.RHTdesc#						</option>
					</cfoutput>
				</select>			</td>
		</tr>
		<!----Asientos de cesantia--->
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_AsientosDeCesantia">Asientos de Cesant&iacute;a</cf_translate></strong></font>			</td>
			<td>&nbsp;</td>
		</tr>
		<!--- 870 = Cuenta resumen de acumulacion de cesantia---->
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_CuentaResumenDeAcumulacionDeCesantia">Cuenta Resumen De Acumulaci&oacute;n de Cesant&iacute;a</cf_translate>:&nbsp;</td>
			<cfif existeCuentaResCesantia eq 1 and len(trim(PvalorCtaResCesantia.Pvalor)) GT 0 >
				<cfset cuentaResCesantia = PvalorCtaResCesantia.Pvalor >
			<cfelse>
				<cfset cuentaResCesantia = -1 >
			</cfif>
			<cfquery name="rsCuentaResCesantia" datasource="#session.DSN#">
				select Ccuenta, Cmayor, Cformato, Cdescripcion
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaResCesantia#">
			</cfquery>
			<td>
				<cfif rsCuentaResCesantia.RecordCount GT 0>
					<cf_cuentas frame="frCuentaResCesantia" Ccuenta="CuentaResCesantia" Cformato="FCuentaResCesantia"
								Cmayor="MCuentaResCesantia" Cdescripcion="DCuentaResCesantia" form="form1" query="#rsCuentaResCesantia#" tabindex="1">
				<cfelse>
					<cf_cuentas frame="frCuentaResCesantia" Ccuenta="CuentaResCesantia" Cformato="FCuentaResCesantia"
								Cmayor="MCuentaResCesantia" Cdescripcion="DCuentaResCesantia" form="form1" tabindex="1">
				</cfif>			</td>
		</tr>
		<!---880 = Cuenta de intereses de cesantia---->
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_CuentaDeInteresesDeCesantia">Cuenta de Intereses de Cesant&iacute;a</cf_translate>:&nbsp;</td>
			<cfif existeCuentaIntCesantia eq 1 and len(trim(PvalorCtaIntCesantia.Pvalor)) GT 0 >
				<cfset cuentaIntCesantia = PvalorCtaIntCesantia.Pvalor >
			<cfelse>
				<cfset cuentaIntCesantia = -1 >
			</cfif>
			<cfquery name="rsCuentaIntCesantia" datasource="#session.DSN#">
				select Ccuenta, Cmayor, Cformato, Cdescripcion
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaIntCesantia#">
			</cfquery>
			<td>
				<cfif rsCuentaIntCesantia.RecordCount GT 0>
					<cf_cuentas frame="frCuentaIntCesantia" Ccuenta="CuentaIntCesantia" Cformato="FCuentaIntCesantia"
								Cmayor="MCuentaIntCesantia" Cdescripcion="DCuentaIntCesantia" form="form1" query="#rsCuentaIntCesantia#" tabindex="1">
				<cfelse>
					<cf_cuentas frame="frCuentaIntCesantia" Ccuenta="CuentaIntCesantia" Cformato="FCuentaIntCesantia"
								Cmayor="MCuentaIntCesantia" Cdescripcion="DCuentaIntCesantia" form="form1" tabindex="1">
				</cfif>			</td>
		</tr>

		<!---890 = Cuenta de Bancos para cesantia---->
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_CuentaDeBancosParaCesantia">Cuenta de Bancos para Cesant&iacute;a</cf_translate>:&nbsp;</td>
			<cfif existeCuentaBancoCesantia eq 1 and len(trim(PvalorCtaBancoCesantia.Pvalor)) GT 0 >
				<cfset cuentaBancoCesantia = PvalorCtaBancoCesantia.Pvalor >
			<cfelse>
				<cfset cuentaBancoCesantia = -1 >
			</cfif>
			<cfquery name="rsCuentaBancoCesantia" datasource="#session.DSN#">
				select Ccuenta, Cmayor, Cformato, Cdescripcion
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaBancoCesantia#">
			</cfquery>
			<td>
				<cfif rsCuentabancoCesantia.RecordCount GT 0>
					<cf_cuentas frame="frCuentaBancoCesantia" Ccuenta="CuentaBancoCesantia" Cformato="FCuentaBancoCesantia"
								Cmayor="MCuentaBancoCesantia" Cdescripcion="DCuentaBancoCesantia" form="form1" query="#rsCuentaBancoCesantia#" tabindex="1">
				<cfelse>
					<cf_cuentas frame="frCuentaBancoCesantia" Ccuenta="CuentaBancoCesantia" Cformato="FCuentaBancoCesantia"
								Cmayor="MCuentaBancoCesantia" Cdescripcion="DCuentaBancoCesantia" form="form1" tabindex="1">
				</cfif>			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td colspan="2" bgcolor="#FAFAFA" align="center">
				<hr size="0"><font size="2" color="#000000"><strong><cf_translate key="LB_Contabilizacion_de_Gastos">Contabilizaci&oacute;n de Gastos</cf_translate></strong></font>			</td>
			<td>&nbsp;</td>
		</tr>
<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="ContaGastosMes" tabindex="3"  onclick="javascript : muestracampos()"
					   type="checkbox"
						<cfif  PvalorContabilizaMes.RecordCount GT 0 and trim(PvalorContabilizaMes.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="CHK_ContabilizarGastosPorMes">Contabilizar Gastos por Mes</cf_translate>			</td>
		</tr>


		<tr id="trCuenta" style="display:none">
			<td>&nbsp;</td>
			<td align="right"><cf_translate key="LB_CuentaPasivoContabilizacionGastos">Cuenta de Pasivo para Contabilizaci&oacute;n de Gastos</cf_translate>:</td>
			<td colspan="2">
			<cfif existeCuentaPasivo eq 1 and len(trim(PvalorCuentaPasivo.Pvalor)) GT 0 >
				<cfquery name="rsCuentaPasivo" datasource="#session.DSN#">
					select Ccuenta, Cmayor, Cformato, Cdescripcion
					from CContables
					where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(PvalorCuentaPasivo.Pvalor)#">
				</cfquery>
				<cf_cuentas frame="frCuentaPasivo" Ccuenta="CuentaPasivo" Cformato="FCuentaPasivo" Cmayor="MCuentaPasivo"
					Cdescripcion="DCuentaPasivo" form="form1" query="#rsCuentaPasivo#" tabindex="3">
			<cfelse>
				<cf_cuentas frame="frCuentaPasivo" Ccuenta="CuentaPasivo" Cformato="FCuentaPasivo" Cmayor="MCuentaPasivo"
					Cdescripcion="DCuentaPasivo" form="form1" tabindex="3">
			</cfif>			</td>
		</tr>

		<tr id="trDistCargasPat" style="display:none">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="DistCargasPat" tabindex="3"
					   type="checkbox"
						<cfif  PvalorDistribucionCargasPatronales.RecordCount GT 0 and trim(PvalorDistribucionCargasPatronales.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="CHK_DistribucionCargasPatronalespormes">Distribuci&oacute;n de Cargas Patronales por Mes</cf_translate>			</td>
		</tr>
		<tr id="trDistCargasEmp" style="display:none">
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">
				<input name="DistCargasEmp" tabindex="3"
					   type="checkbox"
						<cfif  PvalorDistribucionCargasEmpleado.RecordCount GT 0 and trim(PvalorDistribucionCargasEmpleado.Pvalor) neq '0' >
							checked
						</cfif>>
						<cf_translate key="CHK_DistribucionCargasEmpleadoespormes">Distribuci&oacute;n de Cargas Empleado por Mes</cf_translate>			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td align="right"> <cf_translate key="LB_Exportar_Reporte_Asiento">Exportador para Reporte de Asientos : </cf_translate>	</td>
			<td colspan="2">

				<!--- trae las lista de exportadores de rh.nomina --->
				<cfset values = ''>

			    <cfif PExportadorReporteAsiento.RecordCount GT 0 >
					<cfif len(trim(PExportadorReporteAsiento.Pvalor)) GT 0 >
						<cfquery name="rsListaExportadores" datasource="sifcontrol">
							select   EIcodigo, EIdescripcion
							from EImportador
							where EIcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(PExportadorReporteAsiento.Pvalor)#">
						</cfquery>
						<cfset values = '#rsListaExportadores.EIcodigo#,#rsListaExportadores.EIdescripcion#'>
					</cfif>
				</cfif>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_ListadeExportadores"
					default="Lista de Exportadores de Nomina"
					returnvariable="LB_ListadeExportadores"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Codigo"
					default="C&oacute;digo"
					returnvariable="LB_Codigo"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="LB_Descripcion"
					default="Descripci&oacute;n"
					returnvariable="LB_Descripcion"/>

				<cf_conlis title="#LB_ListadeExportadores#"
					campos = "EIcodigo,EIdescripcion"
					desplegables = "S,S"
					size = "10,50"
					values="#values#"
					tabla="EImportador"
					columnas="EIcodigo,EIdescripcion"
					filtro="EImodulo='rh.reppag'"
					desplegar="EIcodigo,EIdescripcion"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					conexion="sifcontrol"
					form = "form1"
					tabindex="1">			</td>
		</tr>

		<tr><td colspan="4">&nbsp;</td></tr>

		<tr>
			<td colspan="4" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Agregar"
					default="Agregar"
					xmlfile="/rh/generales.xml"
					returnvariable="BTN_Agregar"/>
				<input type="submit" name="btnAceptar" value="<cfoutput>#BTN_Agregar#</cfoutput>" tabindex="4">			</td>
		</tr>
	</table>

<script type="text/javascript" language="javascript1.2">
	function muestracampos(){
			var trDistCargasPat  = document.getElementById("trDistCargasPat");
			var trDistCargasEmp  = document.getElementById("trDistCargasEmp");
			var trCuenta		 = document.getElementById("trCuenta");

			if (document.form1.ContaGastosMes.checked ==  true) {
				trDistCargasPat.style.display = '';
				trDistCargasEmp.style.display = '';
				trCuenta.style.display = '';
			} else {
				trDistCargasPat.style.display        = 'none';
				trDistCargasEmp.style.display        = 'none';
				trCuenta.style.display 			     = 'none';
				document.form1.CuentaPasivo.value 	     = "";
				document.form1.FCuentaPasivo.value 		 = "";
				document.form1.MCuentaPasivo.value 		 = "";
				document.form1.DCuentaPasivo.value	 = "";
				document.form1.DistCargasPat.checked = false;
				document.form1.DistCargasEmp.checked = false;
			}
		}

		function TRRenta(){
			var trTablaRenta	 = document.getElementById("trTablaRenta");
			if (document.form1.RentaTipoNomina.checked ==  true) {
				trTablaRenta.style.display = 'none';
				document.form1.IRcodigo.value	 = "";
				document.form1.IRdescripcion.value	 = "";
			} else {
				trTablaRenta.style.display        = '';
			}
		}

		function ToUpper(txt)
		{
			var mayusculas = txt.value.toUpperCase();
			txt.value = mayusculas;
		}

	muestracampos();
	TRRenta();
</script>