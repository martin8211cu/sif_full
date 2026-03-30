<cfinvoke key="CMB_Enero" 			default="Enero" 			returnvariable="CMB_Enero" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Febrero" 		default="Febrero"			returnvariable="CMB_Febrero"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Marzo" 			default="Marzo" 			returnvariable="CMB_Marzo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Abril" 			default="Abril"				returnvariable="CMB_Abril"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Mayo" 			default="Mayo"				returnvariable="CMB_Mayo"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Junio" 			default="Junio" 			returnvariable="CMB_Junio" 				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Julio" 			default="Julio"				returnvariable="CMB_Julio"				component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Agosto" 			default="Agosto" 			returnvariable="CMB_Agosto" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Setiembre"		default="Setiembre"			returnvariable="CMB_Setiembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Octubre" 		default="Octubre"			returnvariable="CMB_Octubre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Noviembre" 		default="Noviembre" 		returnvariable="CMB_Noviembre" 			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="CMB_Diciembre" 		default="Diciembre"			returnvariable="CMB_Diciembre"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BRN_Generar" 		default="Generar"			returnvariable="BRN_Generar"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="BTN_Actualizar" 		default="Actualizar"		returnvariable="BTN_Actualizar"			component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>


<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---►►►Cantidad de Cuentas Mayores de la Empresa y Cuentas Mayores Configuradas◄◄◄--->
<cfquery name="TotalMayores" datasource="#Session.DSN#">
	select count(1) cantidad, sum(case CTCconversion when 0 then 0 else 1 end) as cantidadConfig
      from CtasMayor 
    where Ecodigo = #session.Ecodigo#
</cfquery>
<!---►►►Periodo Contable Actual◄◄◄--->
<cfquery name="rsParam1" datasource="#Session.DSN#">
	select Pvalor
	  from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 30
</cfquery>
<!---►►►Mes Contable Actual◄◄◄--->
<cfquery name="rsParam2" datasource="#Session.DSN#">
	select Pvalor
	 from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 40
</cfquery>
<!---►►►Periodo/Mes Contable Anterio Cerrado◄◄◄--->
<cfset UltimoPeriodo = rsParam1.Pvalor>
<cfset UltimoMes 	 = rsParam2.Pvalor - 1>
<cfif UltimoMes EQ 0>
	<cfset UltimoPeriodo = rsParam1.Pvalor - 1>
	<cfset UltimoMes 	 = 12>
</cfif>
<!---►►►Cuenta de Diferencial Cambiario Primera conversión de estados B15◄◄◄--->
<cfquery name="rsCuentaDCCE_P" datasource="#Session.DSN#">
    select CFdescripcion, CFcuenta, CFformato,Ccuenta
    from CFinanciera
     where CFcuenta = (select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#">
                        from Parametros
                       where Ecodigo = #Session.Ecodigo#  
                         and Pcodigo = 3600)
</cfquery>
<cfif NOT rsCuentaDCCE_P.recordcount>
	<cfthrow message="No se ha definido la Cuenta de Diferencial Cambiario Primera conversión de estados B15">
</cfif>	
<!---►►►Cuenta de Diferencial Cambiario segunda conversión de estados B15◄◄◄--->
<cfquery name="rsCuentaDCCE_S" datasource="#Session.DSN#">
    select CFdescripcion, CFcuenta, CFformato,Ccuenta
    from CFinanciera
     where CFcuenta = (select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#">
                        from Parametros
                       where Ecodigo = #Session.Ecodigo#  
                         and Pcodigo = 3700)
</cfquery>
<cfif NOT rsCuentaDCCE_S.recordcount>
    <cfthrow message="No se ha definido la Cuenta de Diferencial Cambiario segunda conversión de estados B15">
</cfif>	
<!---►►►Primera Conversión de Moneda de Estados Financieros B15◄◄◄--->
<cfquery name="rsParamConversion_P" datasource="#Session.DSN#">
    select Pvalor
      from Parametros
    where Ecodigo = #Session.Ecodigo#
      and Pcodigo = 3810
</cfquery>
<cfif rsParamConversion_P.Recordcount>
    <cfquery name="rsMonedaConversion_P" datasource="#Session.DSN#">
        select Mcodigo, Mnombre #_Cat# ' (' #_Cat# Miso4217 #_Cat# ') ' as Mnombre
         from Monedas
        where Ecodigo = #Session.Ecodigo#
          and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion_P.Pvalor#">
    </cfquery>
</cfif>
<!---►►►Segunda Conversión de Moneda de Estados Financieros B15◄◄◄--->
<cfquery name="rsParamConversion_S" datasource="#Session.DSN#">
    select Pvalor
      from Parametros
    where Ecodigo = #Session.Ecodigo#
      and Pcodigo = 3900
</cfquery>
<cfif rsParamConversion_S.Recordcount>
    <cfquery name="rsMonedaConversion_S" datasource="#Session.DSN#">
        select Mcodigo, Mnombre #_Cat# ' (' #_Cat# Miso4217 #_Cat# ') ' as Mnombre
          from Monedas
        where Ecodigo = #Session.Ecodigo#
          and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParamConversion_S.Pvalor#">
    </cfquery>
</cfif>
<!---►►►Todas las Monedas de la empresa◄◄◄--->
<cfquery name="rsMonedas" datasource="#Session.DSN#">
    select Mcodigo, Mnombre #_Cat# ' (' #_Cat# Miso4217 #_Cat# ') ' as Mnombre
     from Monedas
    where Ecodigo = #Session.Ecodigo#
    order by Miso4217
</cfquery>
<!---►►►Verifica si ya existen Historicos para los Tipos de cambio para la conversion--->
<cfquery name="tiposcambioconversion" datasource="#Session.DSN#">
	select count(1) as cantidad
	  from HtiposcambioConversionB15
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<!---►►►Si existen Historicos de cambios de conversion de moneda◄◄◄--->
<cfif tiposcambioconversion.cantidad GT 0>
	<cfquery name="rsNextPeriodoConversion" datasource="#Session.DSN#">
		select coalesce(max(Speriodo * 100 + Smes), 0) as Next
		from HtiposcambioConversionB15 tc
		where tc.Ecodigo   = #Session.Ecodigo#
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
<!---►►►Si NO existen historicos de cambios de conversion de moneda se obtiene el mínimo de Saldos Contables◄◄◄--->
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


<!---►►►Valida que existan tipo de cambio por Generar◄◄◄--->
<cfif NextPeriodo EQ 0 OR NextMes EQ 0>
	<p align="center">
		<strong>No hay más tipos de cambio para generar por el momento</strong>
	</p><br><cfabort>
</cfif>
<!---►►►Meses◄◄◄--->
<cfset Meses = "#CMB_Enero#,#CMB_Febrero#,#CMB_Marzo#,#CMB_Abril#,#CMB_Mayo#,#CMB_Junio#,#CMB_Julio#,#CMB_Agosto#,#CMB_Setiembre#,#CMB_Octubre#,#CMB_Noviembre#,#CMB_Diciembre#">
<!---►►►JS Necesarios◄◄◄--->
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</script>
	
<cfif rsParamConversion_P.recordCount and rsParamConversion_S.recordCount>
	<cfoutput>
		<form name="form1" method="post" action="ConversionEstFin_B15-sql.cfm" style="margin: 0;" onSubmit="javascript: validar(this);">
			<!---►►►Pintado del Encabezado◄◄◄--->
            <table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  		<tr>
                    <td colspan="5">
                        <input type="hidden" name="Speriodo"  value="#NextPeriodo#">
                        <input type="hidden" name="Smes" 	  value="#NextMes#">
                    </td>
		 	 	</tr>
		  		<tr><td colspan="5" class="tituloAlterno"><cf_translate key=LB_TituloA>GENERAR TIPOS DE CAMBIO PARA LAS MONEDAS DE CONVERSIÓN B15 PARA ESTADOS FINANCIEROS</cf_translate></td></tr>
		  		<tr><td colspan="5">&nbsp;</td></tr>
		  		<tr>
					<td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="2" align="center">
                        	<tr>
                           		<td><strong><cf_translate key=LB_PeriodoContable>Período Contable</cf_translate>:</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            	<td>#NextPeriodo#&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            	<td><strong><cf_translate key=LB_MesContable>Mes Contable</cf_translate>:</strong>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            	<td>#ListGetAt(meses, NextMes, ',')#</td>
                          	</tr>
                        </table>
					</td>
		  		</tr>
             <tr><td colspan="5">
           <!---►►►Primera Conversión B15◄◄◄--->
             <fieldset>
               <legend><strong><cf_translate key=LB_PrimeraConversionB15>Primera Conversión B15</cf_translate></strong></legend>
             	<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
		  		<tr>
					<td colspan="5">
                        <table border="0" cellspacing="0" cellpadding="2" align="center" width="100%">
                    		<tr>
                                <td><strong><cf_translate key=LB_CuentaDiffCamb>Cta Diferencial Cambiario</cf_translate>:</strong></td>
                                <td>
                                    <cf_cuentas conexion="#Session.DSN#" 
                                        conlis	   ="S" 
                                        query	   ="#rsCuentaDCCE_P#" 
                                        auxiliares ="N" 
                                        movimiento ="S" 
                                        form	   ="form1"
                                        frame      ="frame1"
                                        descwidth  ="50"
                                        Ccuenta    ="CCuentaDifCambAsi"
                                        Cformato   ="FCDifCambAsi" 
                                        Cmayor	   ="MCDifCambAsi"
                                        readOnly   = "true">
                                </td>
							</tr>
						</table>
					</td>
		  		</tr>
		 	    <tr><td colspan="5">&nbsp;</td></tr>
              	<tr bgcolor="##CCCCCC">
                    <td align="center" style="border-left:   1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong><cf_translate key=LB_MonedaOrigen>Moneda Origen</cf_translate></strong></td>
                    <td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_MonedaConversion>Moneda Conversi&oacute;n</cf_translate></strong></td>
                    <td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_tipoCambioVenta>Tipo de Cambio (Venta)</cf_translate></strong></td>
                    <td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_TipoCambioCompra>Tipo de Cambio (compra)</cf_translate></strong></td>
                    <td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_TipoCambioPromedio>Tipo de Cambio (promedio)</cf_translate></strong></td>
              	</tr>
		  		<cfloop query="rsMonedas">
		  		<tr>
                    <td align="left">#rsMonedas.Mnombre#</td>
                    <td align="center">#rsMonedaConversion_P.Mnombre#</td>
                    <td align="left">
                        <input name="P_TCambioV_#rsMonedas.Mcodigo#" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion_P.Mcodigo>1.00000<cfelse>0.00000</cfif>" <cfif rsMonedas.Mcodigo EQ rsMonedaConversion_P.Mcodigo> disabled</cfif>>
                    </td>
                    <td align="center">
                        <input name="P_TCambioC_#rsMonedas.Mcodigo#" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion_P.Mcodigo>1.00000<cfelse>0.00000</cfif>" <cfif rsMonedas.Mcodigo EQ rsMonedaConversion_P.Mcodigo> disabled</cfif>>
                    </td>
                    <td align="center">
                        <input name="P_TCambioP_#rsMonedas.Mcodigo#" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion_P.Mcodigo>1.00000<cfelse>0.00000</cfif>" <cfif rsMonedas.Mcodigo EQ rsMonedaConversion_P.Mcodigo> disabled</cfif>>
                    </td>
		  		</tr>
		  		</cfloop>
                </table>
                </fieldset>
               	</td></tr>
                <tr><td align="center" colspan="5">&nbsp;</td> </tr>
                <tr><td align="center" colspan="5">
          		<!---►►►Segunda Conversión B15◄◄◄--->
                 <fieldset>
               		<legend><strong><cf_translate key=LB_SegundaConversionB15> Segunda Conversión B15</cf_translate></strong></legend>
                <table border="0" cellspacing="0" cellpadding="2" align="center" width="100%">
          		<tr>
                	<td colspan="5">
                    	<table border="0" cellspacing="0" cellpadding="2" align="center" width="100%">
          					<tr><td><strong><cf_translate key=LB_CuentaDiffCamb>Cta Diferencial Cambiario</cf_translate>:</strong></td>
			  					<td>
                                     <cf_cuentas 
                                        conexion	="#Session.DSN#" 
                                        conlis		="S" 
                                        query		="#rsCuentaDCCE_S#" 
                                        auxiliares	="N" 
                                        movimiento	="S" 
                                        form		="form1"
                                        frame		="frame1"
                                        descwidth	="50"
                                        Ccuenta		="CCuentaDifCambAsi_S"
                                        Cformato	="FCDifCambAsi_S" 
                                        Cmayor		="MCDifCambAsi_S" 
                                        readOnly   	= "true">
							</td>
						</tr>
               	 	</table>
				</td>
		  	</tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		  <tr bgcolor="##CCCCCC">
			<td align="center" style="border-left:   1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;"><strong><cf_translate key=LB_MonedaOrigen>Moneda Origen</cf_translate></strong></td>
			<td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_MonedaConversion>Moneda Conversi&oacute;n</cf_translate></strong></td>
			<td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_TipoCambioVenta>Tipo de Cambio (Venta)</cf_translate></strong></td>
			<td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_TipoCambioCompra>Tipo de Cambio (compra)</cf_translate></strong></td>
			<td align="center" style="border-bottom: 1px solid black; border-right:  1px solid black; border-top:   1px solid black;"><strong><cf_translate key=LB_TipoCambioPromedio>Tipo de Cambio (promedio)</cf_translate></strong></td>
		  </tr>
		  <tr>
			<td align="left">#rsMonedaConversion_P.Mnombre#</td>
			<td align="left">#rsMonedaConversion_S.Mnombre#</td>
			<td align="center">
				<input name="S_TCambioV_#rsMonedaConversion_P.Mcodigo#" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsMonedaConversion_P.Mcodigo EQ rsMonedaConversion_S.Mcodigo>1.00000<cfelse>0.00000</cfif>" <cfif rsMonedaConversion_P.Mcodigo EQ rsMonedaConversion_S.Mcodigo> readonly="true" style=" text-align:right; border: none;" <cfelse> style="text-align: right;"</cfif>>
			</td>
			<td align="center">
				<input name="S_TCambioC_#rsMonedaConversion_P.Mcodigo#" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsMonedaConversion_P.Mcodigo EQ rsMonedaConversion_S.Mcodigo>1.00000<cfelse>0.00000</cfif>" <cfif rsMonedaConversion_P.Mcodigo EQ rsMonedaConversion_S.Mcodigo> readonly="true" style=" text-align:right; border: none;" <cfelse> style="text-align: right;"</cfif>>
			</td>
			<td align="center">
				<input name="S_TCambioP_#rsMonedaConversion_P.Mcodigo#" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);"  onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" value="<cfif rsMonedaConversion_P.Mcodigo EQ rsMonedaConversion_S.Mcodigo>1.00000<cfelse>0.00000</cfif>" <cfif rsMonedaConversion_P.Mcodigo EQ rsMonedaConversion_S.Mcodigo> readonly="true" style=" text-align:right; border: none;" <cfelse> style="text-align: right;"</cfif>>
			</td>
		  </tr>
          </table>
          </fieldset>
          </td></tr>
		  <!---►►►Validaciones y Botones◄◄◄--->
          <tr>
			<td align="center" colspan="5">
				<cfif TotalMayores.cantidadConfig GT 0 and TotalMayores.cantidadConfig NEQ TotalMayores.cantidad>
					<img src="../../imagenes/deletestop.gif" width="16" height="16" />
					<font color="##FF0000">Existen Mayores sin el parámetro “TC en Conversión de Estados Financieros” configurado. Debe configurarlas para poder continuar.</font>
				<cfelse>
					<cfoutput><input type="submit" class="btnAplicar" name="btnGenerar" value="#BRN_Generar#"></cfoutput>
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="center" colspan="5">&nbsp;</td>
		  </tr>
	  </table>
	</form>
	</cfoutput>

	<script type="text/javascript" language="javascript">
		function validar(f) {
		  <cfoutput query="rsMonedas">
			f.obj.P_TCambioC_#rsMonedas.Mcodigo#.value = qf(f.obj.P_TCambioC_#rsMonedas.Mcodigo#.value);
			f.obj.P_TCambioV_#rsMonedas.Mcodigo#.value = qf(f.obj.P_TCambioV_#rsMonedas.Mcodigo#.value);
			f.obj.P_TCambioP_#rsMonedas.Mcodigo#.value = qf(f.obj.P_TCambioP_#rsMonedas.Mcodigo#.value);
			
			f.obj.P_TCambioC_#rsMonedas.Mcodigo#.disabled = false;
			f.obj.P_TCambioV_#rsMonedas.Mcodigo#.disabled = false;
			f.obj.P_TCambioP_#rsMonedas.Mcodigo#.disabled = false;
		  </cfoutput>
		  <cfoutput>
		    f.obj.P_TCambioC_#rsMonedaConversion_P.Mcodigo#.value = qf(f.obj.P_TCambioC_#rsMonedaConversion_P.Mcodigo#.value);
			f.obj.P_TCambioV_#rsMonedaConversion_P.Mcodigo#.value = qf(f.obj.P_TCambioV_#rsMonedaConversion_P.Mcodigo#.value);
			f.obj.P_TCambioP_#rsMonedaConversion_P.Mcodigo#.value = qf(f.obj.P_TCambioP_#rsMonedaConversion_P.Mcodigo#.value);
			
			f.obj.P_TCambioC_#rsMonedaConversion_P.Mcodigo#.disabled = false;
			f.obj.P_TCambioV_#rsMonedaConversion_P.Mcodigo#.disabled = false;
			f.obj.P_TCambioP_#rsMonedaConversion_P.Mcodigo#.disabled = false;
		 </cfoutput> 
		}
	
		function __isNotCero() {
			if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
				this.error = "El campo " + this.description + " no puede ser cero!";
			}
		}

		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		_addValidator("isNotCero", __isNotCero);

	  <cfoutput query="rsMonedas">
		<!---►►►Validaciones Primera Conversión B15◄◄◄--->
		objForm.P_TCambioC_#rsMonedas.Mcodigo#.required = true;
		objForm.P_TCambioC_#rsMonedas.Mcodigo#.description = "TC(compra) para #rsMonedas.Mnombre#(Primera Conversión)";
		objForm.P_TCambioC_#rsMonedas.Mcodigo#.validateNotCero();
		
		objForm.P_TCambioV_#rsMonedas.Mcodigo#.required = true;
		objForm.P_TCambioV_#rsMonedas.Mcodigo#.description = "TC(Venta) para #rsMonedas.Mnombre#(Primera Conversión)";
		objForm.P_TCambioV_#rsMonedas.Mcodigo#.validateNotCero();
		
		objForm.P_TCambioP_#rsMonedas.Mcodigo#.required = true;
		objForm.P_TCambioP_#rsMonedas.Mcodigo#.description = "TC(promedio) para #rsMonedas.Mnombre#(Primera Conversión)";
		objForm.P_TCambioP_#rsMonedas.Mcodigo#.validateNotCero();
	  </cfoutput>
	  <cfoutput>	
		<!---►►►Validaciones Segunda Conversión B15◄◄◄--->
		objForm.S_TCambioC_#rsMonedaConversion_P.Mcodigo#.required = true;
		objForm.S_TCambioC_#rsMonedaConversion_P.Mcodigo#.description = "TC(compra) para #rsMonedas.Mnombre#(Segunda Conversión)";
		objForm.S_TCambioC_#rsMonedaConversion_P.Mcodigo#.validateNotCero();
		
		objForm.S_TCambioV_#rsMonedaConversion_P.Mcodigo#.required = true;
		objForm.S_TCambioV_#rsMonedaConversion_P.Mcodigo#.description = "TC(Venta) para #rsMonedas.Mnombre#(Segunda Conversión)";
		objForm.S_TCambioV_#rsMonedaConversion_P.Mcodigo#.validateNotCero();
		
		objForm.S_TCambioP_#rsMonedaConversion_P.Mcodigo#.required = true;
		objForm.S_TCambioP_#rsMonedaConversion_P.Mcodigo#.description = "TC(promedio) para #rsMonedas.Mnombre#(Segunda Conversión)";
		objForm.S_TCambioP_#rsMonedaConversion_P.Mcodigo#.validateNotCero();
		
	    objForm.CCuentaDifCambAsi.required      = true;
	    objForm.CCuentaDifCambAsi_S.required    = true;
	    objForm.CCuentaDifCambAsi.description   = "Cuenta de diferencial cambiario";
	    objForm.CCuentaDifCambAsi_S.description = "Cuenta de diferencial cambiario";
	</cfoutput>	
	</script>
<!---►►►Configuración de las Monedas para generar los Tipos de Cambio◄◄◄--->	
<cfelse>
	<cfoutput>
		<form name="form1" method="post" action="ConversionEstFin_B15-sql.cfm" style="margin: 0;" onSubmit="javascript: validar(this);">
			<table width="90%"  border="0" cellspacing="0" cellpadding="2" align="center">
				<tr>
					<td colspan="5">
						<input type="hidden" name="Speriodo" value="#NextPeriodo#">
						<input type="hidden" name="Smes" value="#NextMes#">
					</td>
				</tr>
				<tr><td colspan="5" class="tituloAlterno"><cf_translate key=LB_TituloA>GENERAR TIPOS DE CAMBIO PARA LAS MONEDAS DE CONVERSIÓN PARA ESTADOS FINANCIEROS</cf_translate></td></tr>
				<tr><td colspan="2" align="center" width="50%"><strong><cf_translate key=LB_SeleccioneMoneda>Seleccione una moneda de conversión para estados financieros</cf_translate></strong></td></tr>
				<tr>
                	<td align="right"><cf_translate key=LB_PrimeraConversionB15>Primera Conversion B15</cf_translate></td>
                	<td>
                        <select name="Mcodigo_P">
                        <cfloop query="rsMonedas">
                            <option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
                        </cfloop>
                        </select>
					</td>
				</tr>
			<tr>
				<td align="right"><cf_translate key=LB_SegundaConversionB15>Segunda Conversión B15</cf_translate></td>
				<td>
					<select name="Mcodigo_S">
					<cfloop query="rsMonedas">
						<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
					</cfloop>
					</select>
				</td>
		  	<tr>
				<td colspan="5">&nbsp;</td>
		  	</tr>
		  	<tr><td align="center" colspan="5"><cfoutput><input type="submit" name="btnActualizar" value="#BTN_Actualizar#"></cfoutput></td></tr>
		</table>
	</form>
	</cfoutput>	
</cfif>