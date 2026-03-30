<cfoutput>
<cfparam name="session.CajasNo" default="false">
<cfset LvarCajasNo = session.CajasNo>
<cfset LvarChkCajasNo = find("?","#left(rsForm.CFcuentac,4)##left(rsForm.CFcuentainventario,4)##left(rsForm.CFcuentainversion,4)##left(rsForm.CFcuentaaf,4)##left(rsForm.CFcuentaingreso,4)##left(rsForm.CFcuentaingresoretaf,4)##left(rsForm.CFcuentagastoretaf,4)##left(rsForm.CFcuentaobras,4)##left(rsForm.CFcuentaPatri,4)##left(rsForm.CFComplementoCtaGastoCS,4)#")>
<cfif not LvarCajasNo>
	<cfset LvarCajasNo = LvarChkCajasNo>
</cfif>

<!---►►Activar Transaccionabilidad de Actividad Empresarial◄◄--->
<cfquery name="rsAE" datasource="#session.dsn#">
    select Coalesce(Pvalor,'N') as Pvalor 
        from Parametros 
      where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and Pcodigo = 2200
</cfquery>

<table width="100%">
		<tr><td align="center">
			<table width="100%" border="0">
			<tr> 
				<td align="left" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeGasto1">Cuenta de Gasto o Compras de Servicios</cf_translate>:
				</td>
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentac" value="#rsForm.CFcuentac#" />
					<cfelse>	
						<cf_cajascuenta index="1" tabindex="1" objeto="CFcuentac" query="#rsForm#" >					
					</cfif>
			  </td>
			</tr>
			
			<tr> 
				<td align="left" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeInventario1">Cuenta de Gasto por Consumo de Inventario</cf_translate>:
				</td>
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentainventario" value="#rsForm.CFcuentainventario#" />
					<cfelse>
							<cf_cajascuenta index="2" tabindex="1" objeto="CFcuentainventario" query="#rsFormCI#" >
					</cfif>
				</td>
			</tr> 

			<tr> 
				<td align="left" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeInversion1">Cuenta de Inversión o Compras de Activos Fijos</cf_translate>:
				</td>
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentainversion" value="#rsForm.CFcuentainversion#" />
					<cfelse>
 							<cf_cajascuenta index="3" tabindex="1" objeto="CFcuentainversion" query="#rsFormAF#" >
					</cfif>
				</td>
			</tr> 

			<tr>
				<td align="rigth" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeActivos1">Cuenta de Gasto por Depreciación de Activos Fijos</cf_translate>:
				</td>	
				<td align="rigth">			
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentaaf" value="#rsForm.CFcuentaaf#" />
					<cfelse>	
						<cf_cajascuenta index="4" tabindex="1" objeto="CFcuentaaf" query="#rsActivoFijo#" >
					</cfif>
				</td>	
			</tr>

			<tr>
				<td align="rigth" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeOtrosIngresos">Cuenta de Ingresos por Retiro de Activos Fijos<BR>(cuando no hay Motivo de Retiro)</cf_translate>:
				</td>	
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentaingresoretaf" value="#rsForm.CFcuentaingresoretaf#" />
					<cfelse>	
						<cf_cajascuenta index="6" tabindex="1" objeto="CFcuentaingresoretaf" query="#rsRetiroIngreso#" >
					</cfif>
				</td>
			</tr> 
			<tr> 
				<td align="left" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeOtrosGastos">Cuenta de Gastos por Retiro de Activos Fijos<BR>(cuando no hay Motivo de Retiro)</cf_translate>:
				</td>
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentagastoretaf" value="#rsForm.CFcuentagastoretaf#" />
					<cfelse>	
						<cf_cajascuenta index="7" tabindex="1" objeto="CFcuentagastoretaf" query="#rsRetiroGasto#" >
					</cfif>
			  </td>
			</tr>
			<tr>
				<td align="rigth" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeObras1">Cuenta de Obras en Procesos</cf_translate>:
				</td>	
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentaobras" value="#rsForm.CFcuentaobras#" />
					<cfelse>	
						<cf_cajascuenta index="8" tabindex="1" objeto="CFcuentaobras" query="#rsObras#" >
					</cfif>
				</td>
			</tr>
			
			<tr>
				<td align="rigth" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeIngreso">Cuenta de Ingreso</cf_translate>:
				</td>	
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentaingreso" value="#rsForm.CFcuentaingreso#" />
					<cfelse>	
						<cf_cajascuenta index="5" tabindex="1" objeto="CFcuentaingreso" query="#rsFormING#" >
					</cfif>
				</td>
			</tr>

			<tr>
				<td align="rigth" width="5%" nowrap>
					<cf_translate key="LB_CuentaDeObras">Cuenta de Ingreso por Patrimonio</cf_translate>:
				</td>	
				<td align="rigth">
					<cfif LvarCajasNo>
						<input type="text" size="60" name="CFcuentaPatri" value="#rsForm.CFcuentaPatri#" />
					<cfelse>	
						<cf_cajascuenta index="9" tabindex="1" objeto="CFcuentaPatri" query="#rsPatrimonio#" >
					</cfif>
				</td>
			</tr>
			
			<tr>
				<td align="rigth" width="5%" nowrap>
					<cf_translate key="LB_CFComplementoCtaGastoCS">Complemento Contable</cf_translate>:
				</td>	
				<td align="rigth">
					<input type="text" size="15" name="CFComplementoCtaGastoCS" value="#rsForm.CFComplementoCtaGastoCS#"/> Complemento a usar en la cuenta de gastos del concepto de Servicio.
				</td>
			</tr>
            <cfif rsAE.Pvalor EQ 'S'>
            	<tr>
                	<td>Actividad Empresarial:</td>
                    <td>
						 <cfif isdefined('rsForm.FPAEid') and isdefined('rsForm.CFComplemento') and LEN(TRIM(rsForm.FPAEid)) and LEN(TRIM(rsForm.CFComplemento))>
                                <cf_ActividadEmpresa etiqueta="" formname="form1" idActividad="#rsForm.FPAEid#" valores="#rsForm.CFComplemento#">
                         <cfelse>
                                <cf_ActividadEmpresa etiqueta="" formname="form1">
                         </cfif>
                    </td>                    
                </tr>
            </cfif>
            
            <tr>
				<td align="rigth" width="5%" nowrap>
					<input type="checkbox" id="CTAtransitoria" name="CTAtransitoria" onClick="javascript: cambioCuentaTran(); limpiarDetalleTr();" <cfif isdefined('rsForm.CFACTransitoria') and rsForm.CFACTransitoria eq 1> checked</cfif>/>
                    <cf_translate key="LB_CuentaTran">Aplica Cuenta Transitoria para Venta a Cr&eacute;dito</cf_translate>:
				</td>	
				<td align="rigth" <cfif isdefined('rsForm.CFACTransitoria') and rsForm.CFACTransitoria eq 0>style="visibility:hidden;"</cfif>>
                	<cfif isdefined('rsForm.CFcuentatransitoria') and LEN(TRIM(rsForm.CFcuentatransitoria)) >
                    	<cfquery name="rsCFcuenta" datasource="#Session.DSN#">
                            select 
                                coalesce(c.Ccuenta,0) as Ccuenta
                            from CFinanciera c
                            where c.CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFcuentatransitoria#">
                              and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
                        </cfquery>
                        
                        <cfquery name="rsCuenta" datasource="#Session.DSN#">
                            select 
                                c.Ccuenta as Ccuenta, 
                                c.Cdescripcion as Cdescripcion, 
                                c.Cformato as Cfformato
                            from CContables c
                            where c.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFcuenta.Ccuenta#">
                              and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
                        </cfquery>
                    	<cf_cuentas Conexion="#Session.DSN#" query="#rsCuenta#" Conlis="S" auxiliares="N" movimiento="S" frame="frame6" ccuenta="CcuentaTransitoria" cdescripcion="CdescripcionTransitoria" cformato="CformatoTransitoria">
                    <cfelse>
                    	<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" frame="frame6" ccuenta="CcuentaTransitoria" cdescripcion="CdescripcionTransitoria" cformato="CformatoTransitoria">
                    </cfif>
				</td>
			</tr>
            
			</table>
			
			</td></tr>
			<cfif modo NEQ 'ALTA'>
				<tr>
				  	<td colspan="2" align="center"> 
				  		<strong><cf_translate key="LB_ComplementosContables">Complementos Contables</cf_translate> </strong> 
					</td>
				</tr>
				<tr><td colspan="2" valign="top" align="center">
				<cf_sifcomplementofinanciero tabindex="1" action='display'
						tabla="CFuncional"
						form = "form1"
						llave="#form.CFpk#"/>	
				</td></tr>
			</cfif>	
			
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr> 
				<td colspan="2"><div align="center"> 
					<cfif modo NEQ "ALTA">
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Guardar"
							Default="Guardar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Guardar"/>

						<input type="submit" name="Cambio" id="btnCambio" value="#BTN_Guardar#" class="btnGuardar" tabindex="1">
					</cfif>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Regresar"
							Default="Regresar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Regresar"/>
					<input type="button" name="Regresar" value="#BTN_Regresar#" class="btnAnterior" tabindex="1" onClick="javascript: regresa();">
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		
  </cfoutput>
</form>
<cfif NOT LvarChkCajasNo>
	<input type="checkbox" <cfif NOT session.CajasNo>checked</cfif>
		onclick="
			var btn = document.getElementById('btnCambio');
			if (!this.checked)
				btn.form.action=btn.form.action + '?CajasNo=1';
			else
				btn.form.action=btn.form.action + '?CajasNo=0';
			btn.click();
		"
	/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="chkCajas"
		Default="Asistente de Formato de Cuenta"
		XmlFile="/rh/generales.xml"
		returnvariable="chkCajas"/>
	<cfoutput>#chkCajas#</cfoutput>
</cfif>

<script language="javascript1.2" type="text/javascript">
	
	function isDefined( object) {
		 return (typeof(eval(object)) == "undefined")? false: true;
	}

	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction(){
		// RetornaCuenta2() es máscara completa, rellena con comodín
		if( isDefined(window.cuentasIframe1) )
			window.cuentasIframe1.RetornaCuenta2();
		if( isDefined(window.cuentasIframe2) )
			window.cuentasIframe2.RetornaCuenta2();
		if( isDefined(window.cuentasIframe3) )
			window.cuentasIframe3.RetornaCuenta2();
		if( isDefined(window.cuentasIframe4) )
			window.cuentasIframe4.RetornaCuenta2();
		if( isDefined(window.cuentasIframe5) )
			window.cuentasIframe5.RetornaCuenta2();
		if( isDefined(window.cuentasIframe6) )
			window.cuentasIframe6.RetornaCuenta2();
		if( isDefined(window.cuentasIframe7) )
			window.cuentasIframe7.RetornaCuenta2();
		if( isDefined(window.cuentasIframe8) )
			window.cuentasIframe8.RetornaCuenta2();
		if( isDefined(window.cuentasIframe9) )
			window.cuentasIframe9.RetornaCuenta2();
		}
	try{
		document.form1.CFcuentac.focus();
	}catch(e){
	}
	
	function cambioCuentaTran(){	
		var ctran = document.getElementById("CTAtransitoria");	
		if(ctran.checked == true){
			document.getElementById("Cmayor_CcuentaTransitoria").style.visibility = "visible";
			document.getElementById("CformatoTransitoria").style.visibility = "visible";
			document.getElementById("CdescripcionTransitoria").style.visibility = "visible";
			document.getElementById("hhref_CcuentaTransitoria").style.visibility = "visible";
		}
		if(ctran.checked == false){
			document.getElementById("Cmayor_CcuentaTransitoria").style.visibility = "hidden";
			document.getElementById("CformatoTransitoria").style.visibility = "hidden";
			document.getElementById("CdescripcionTransitoria").style.visibility = "hidden";
			document.getElementById("hhref_CcuentaTransitoria").style.visibility = "hidden";
		}
	}
	
	function limpiarDetalleTr() {
		document.form1.Cmayor_CcuentaTransitoria.value = "";
		document.form1.CformatoTransitoria.value = "";
		document.form1.CdescripcionTransitoria.value = "";
		document.form1.CcuentaTransitoria.value = "";
		document.form1.CFcuenta_CcuentaTransitoria.value = "";
	}
</script>