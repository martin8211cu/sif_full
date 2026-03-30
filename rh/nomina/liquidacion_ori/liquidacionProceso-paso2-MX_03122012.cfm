<!--- anterior --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Anterior"
	Default="Anterior"
	xmlfile="/rh/generales.xml"				
	returnvariable="vAnterior"/>		

<!--- Siguiente --->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Siguiente"
	Default="Siguiente"
	xmlfile="/rh/generales.xml"				
	returnvariable="vSiguiente"/>
	
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnExisteLF" returnvariable="existeLF">
	<cfinvokeargument name="DLlinea" 	value="#form.DLlinea#">
	<cfinvokeargument name="DEid" 		value="#form.DEid#">
	<cfinvokeargument name="Fecha" 		value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
</cfinvoke>

<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
	<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
	<cfinvokeargument name="DEid" value="#form.DEid#">
</cfinvoke>

<!--- Inicia: Cargas Sociales --->
<cfset rsMontoAportesRealizados = rsMontoAportesRealizados(form.DEid)>
<cfset MontoCargas = 0>
<cfif rsMontoAportesRealizados.recordcount gt 0>
	<cfset MontoCargas = rsMontoAportesRealizados.monto>
</cfif>
<!--- Finaliza: Cargas Sociales --->

<cfset Modificado = false>
<!--- Inicia: Proceso Finiquito --->

<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetMontoEG" returnvariable="rsMontoEGF">
	<cfinvokeargument name="DLlinea" value="#DLlinea#">
	<cfinvokeargument name="Tipo" value="F">
</cfinvoke>

<cfset IRcodigoN1 = fnGetDato(30)>
<cfif len(IRcodigoN1) EQ 0>
	<cfquery name="rsCodIRcodigo" datasource="#Session.DSN#">
		select IRcodigo
			from TiposNomina a
			inner join DLaboralesEmpleado  b
			on a.Tcodigo = b.Tcodigo
			and a.Ecodigo = b.Ecodigo
			and b.DLlinea = #form.DLlinea#
	</cfquery>
   	<cfset IRcodigoN1 = rsCodIRcodigo.IRcodigo>
    <cfset IRcodigoMensual = 'MEX'>
</cfif>

<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaISPT" returnvariable="ISPTF">
	<cfinvokeargument name="Monto" value="#rsMontoEGF.Grabado#">
	<cfinvokeargument name="IRcodigo" 		value="#IRcodigoN1#">
</cfinvoke>

<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR113F">
	<cfinvokeargument name="Monto" 			value="#rsMontoEGF.Grabado#">
	<cfinvokeargument name="IRcodigo" 		value="#IRcodigoN1#">
</cfinvoke>
<cfquery name="rsIRcodigoN2" datasource="#Session.DSN#">
	select IRcodigo
		from ImpuestoRenta 
		where IRcodigoPadre = '#IRcodigoMensual#'
</cfquery>
<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR115F">
	<cfinvokeargument name="Monto" 			value="#rsMontoEGF.Grabado#">
	<cfinvokeargument name="IRcodigo" 		value="#rsIRcodigoN2.IRcodigo#">
</cfinvoke>
<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaSubsidio" returnvariable="SubsidioF">
	<cfinvokeargument name="Monto" 		value="#rsMontoEGF.Grabado#">
	<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
</cfinvoke>
<!---ERBG Cambio para que calcule el Infonavit solo si en el finiquito o liquidación existen conceptos de salario Inicia--->
<cfset Infonavit = 0>
<cfquery name="rsConceptosSueldo" datasource="#Session.DSN#">
    select COUNT(*)	as CompSalario			
    from RHLiqIngresos a
        inner join CIncidentes b
            on b.CIid = a.CIid
        inner join ComponentesSalariales c
            on b.CSid = c.CSid
            and  CSsalariobase = 1
    where DLlinea = #form.DLlinea#
</cfquery>
<cfif rsConceptosSueldo.CompSalario GT 0>
    <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaInfonavit" returnvariable="Infonavit">
        <cfinvokeargument name="DEid" value="#form.DEid#">
        <cfinvokeargument name="Fecha" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
    </cfinvoke>
</cfif>
<!---ERBG Cambio para que calcule el Infonavit solo si en el finiquito o liquidación existen conceptos de salario Fin--->
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="getLiqIngresosPorDLlinea"  returnvariable="rsLiqIngresosF">
	<cfinvokeargument name="DLlinea" value="#DLlinea#">
	<cfinvokeargument name="RHLIFiniquito" value="1">
</cfinvoke>
<cfset MontoGrabadoF = rsMontoEGF.Grabado>
<cfset MontoExentoF = rsMontoEGF.Exento>
<cfset TotalF = MontoGrabadoF + MontoExentoF>
<cfset TotalGeneralF = TotalF - ISPTF>
<cfset TotalRealF = TotalGeneralF - Infonavit>

<!---ISPTF:	<cfdump var="#ISPTF#"><br/>
MontoGrabadoF: <cfdump var="#MontoGrabadoF#"><br>
MontoExentoF : <cfdump var="#MontoExentoF#"> <br>
TotalF: <cfdump var="#TotalF#"><br>
TotalGeneralF: <cfdump var="#TotalGeneralF#"> <br>
TotalRealF: <cfdump var="#TotalRealF#">--->


<!--- Finaliza: Proceso Finiquito --->

<!--- Inicia: Proceso Liquidación --->
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetMontoEG" returnvariable="rsMontoEGL">
	<cfinvokeargument name="DLlinea" value="#DLlinea#">
	<cfinvokeargument name="Tipo" value="L">
</cfinvoke>
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetSalarioMensual" returnvariable="SalarioMensual">
	<cfinvokeargument name="DEid" value="#form.DEid#">
	<cfinvokeargument name="Fecha" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
</cfinvoke>
<!---Modificacion Sandra--->
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaISPT" returnvariable="ISPTSL">
	<cfinvokeargument name="Monto" value="#SalarioMensual#">
	<cfinvokeargument name="IRcodigo" 		value="#IRcodigoMensual#">
</cfinvoke>
<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR113L">
	<cfinvokeargument name="Monto" 			value="#SalarioMensual#">
	<cfinvokeargument name="IRcodigo" 		value="#IRcodigoMensual#">
</cfinvoke>
<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnGetProyeccionImpuesto" returnvariable="LISR115L">
	<cfinvokeargument name="Monto" 			value="#SalarioMensual#">
	<cfinvokeargument name="IRcodigo" 		value="#rsIRcodigoN2.IRcodigo#">
</cfinvoke>
<cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaSubsidio" returnvariable="SubsidioL">
	<cfinvokeargument name="Monto" 		value="#SalarioMensual#">
	<cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
</cfinvoke>
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnEjecutarCalculoLoco"  returnvariable="CalculoLoco">
	<cfinvokeargument name="DEid" value="#form.DEid#">
	<cfinvokeargument name="DLlinea" value="#DLlinea#">
	<cfinvokeargument name="Fecha" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
</cfinvoke>
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="getLiqIngresosPorDLlinea"  returnvariable="rsLiqIngresosL">
	<cfinvokeargument name="DLlinea" value="#DLlinea#">
	<cfinvokeargument name="RHLIFiniquito" value="0">
</cfinvoke>
<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="getConfigvariablesDinamicas"  returnvariable="rsNivelesCL">
	<cfinvokeargument name="RHEVDtipo" value="2">
</cfinvoke>

<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnRetencionISPT" returnvariable="ParteExenta">
	<cfinvokeargument name="DEid" value="#form.DEid#">
</cfinvoke>

<cfset MontoGrabadoL = rsMontoEGL.Grabado>
<!---<cfthrow message="#SalarioMensual#">--->
<cfset MontoExentoL = rsMontoEGL.Exento>
<cfset TotalL = MontoGrabadoL + MontoExentoL>
<cfset TotalRealL = TotalL - ISPTSL - Infonavit>
<cfset Factor = fnFormatMoney((SalarioMensual - LISR113L.DIRinf) * (LISR113L.DIRporcentaje / 100) + LISR113L.DIRmontofijo)/ SalarioMensual>
<cfset ParteEx = ParteExenta>
<cfset BaseImp = MontoGrabadoL - ParteEx>
<cfset ISPTL = BaseImp * Factor>
<cfset TotalRealLiquidacion = #fnRedondear(BaseImp)# * #fnRedondear(Factor*100)#>


<!---<cfset Neto = TotalRealF - ISPTF + MontoGrabadoL - ISPTL - MontoCargas>--->
<cfset Neto = TotalF - ISPTF + MontoGrabadoL - TotalRealLiquidacion/100 - MontoCargas>
<cfset btnTitulo = "Calcular Datos y Guardar">
<cfset btnName = "Calcular">
<cfif existeLF neq 'false'>
	<cfset btnTitulo = "Recalcular Datos y Guardar">
	<cfset btnName = "Recalcular">
</cfif>
<!--- Finaliza: Proceso Liquidación --->

<!---DLlinea: <cfdump var="#DLlinea#"><br>
MontoExentoL : <cfdump var="#MontoExentoL#"> <br>
MontoGrabadoF: <cfdump var="#MontoGrabadoF#"><br>
rsLF.RHLFLtGrabadoF: <cfdump var="#rsLF.RHLFLtGrabadoF#"><br/>
MontoExentoF : <cfdump var="#MontoExentoF#"> <br>
rsLF.RHLFLtExentoF: <cfdump var="#rsLF.RHLFLtExentoF#"><br/>
ISPTF:	<cfdump var="#ISPTF#"><br/>
rsLF.RHLFLisptF: <cfdump var="#rsLF.RHLFLisptF#"><br/>
MontoExentoF : <cfdump var="#MontoExentoF#"> <br>
rsLF.RHLFLtExentoF: <cfdump var="#rsLF.RHLFLtExentoF#"><br/>
TotalL: <cfdump var="#TotalL#"><br/>
rsLF.RHLFLtotalL: <cfdump var="#rsLF.RHLFLtotalL#"><br/>
SalarioMensual: <cfdump var="#SalarioMensual#"><br/>
rsLF.RHLFLsalarioMensual: <cfdump var="#rsLF.RHLFLsalarioMensual#"><br/>
ISPTSL: <cfdump var="#ISPTSL#"><br/>
rsLF.RHLFLisptSalario: <cfdump var="#rsLF.RHLFLisptSalario#"><br/>
CalculoLoco.Resultado: <cfdump var="#CalculoLoco.Resultado#"><br/>
rsLF.RHLFLisptL: <cfdump var="#rsLF.RHLFLisptL#"><br/>--->

<cfif TotalL LTE 0>
	<cfset TotalRealLiquidacion = 0>
</cfif>  
<cfset Neto = TotalF - ISPTF + MontoGrabadoL - TotalRealLiquidacion/100 - MontoCargas>

<!---TotalF: <cfdump var="#TotalF#"><br>
ISPTF: <cfdump var="#ISPTF#"><br>
MontoGrabadoL: <cfdump var="#MontoGrabadoL#"><br>
TotalRealLiquidacion: <cfdump var="#TotalRealLiquidacion#/100"><br>
MontoCargas: <cfdump var="#MontoCargas#"><br>
Neto: <cfdump var="#Neto#"><br/>
rsLF.RHLFLresultado: <cfdump var="#rsLF.RHLFLresultado#"><br/>--->

<!--- Inicia: validacion de modificacion--->
<cfif rsLF.recordcount gt 0>
	<cfset fnValidaModificacion(rsLF.RHLFLtGrabadoF, MontoGrabadoF)>
<!---Modificado 1: <cfdump var="#Modificado#"><br/>--->    
	<cfset fnValidaModificacion(rsLF.RHLFLtExentoF, MontoExentoF)>
<!---Modificado 2: <cfdump var="#Modificado#"><br/>--->    
	<cfset fnValidaModificacion(rsLF.RHLFLisptF, ISPTF)>
<!---Modificado 3: <cfdump var="#Modificado#"><br/>--->    
    <cfif rsConceptosSueldo.CompSalario GT 0>
		<cfset fnValidaModificacion(rsLF.RHLFLinfonavit, Infonavit)>
    </cfif>
	<cfset fnValidaModificacion(rsLF.RHLFLtotalL, TotalL)>
<!---Modificado 4: <cfdump var="#Modificado#"><br/> ---> 
   <!--- <cfif TotalL LTE 0>
    	<!---<cfthrow message="#SalarioMensual#">--->
    	<cfset SalarioMensual = #SalarioMensual#>
    </cfif>  
	<cfset fnValidaModificacion(rsLF.RHLFLsalarioMensual, SalarioMensual)>--->
<!---Modificado 5: <cfdump var="#Modificado#"><br/> ---> 
	<cfset fnValidaModificacion(rsLF.RHLFLisptSalario, ISPTSL)>
<!---Modificado 6: <cfdump var="#Modificado#"><br/>--->    
	<cfset fnValidaModificacion(rsLF.RHLFLisptL, CalculoLoco.Resultado)>
<!---Modificado 7: <cfdump var="#Modificado#"><br/>--->
	<cfset fnValidaModificacion(rsLF.RHLFLresultado, Neto)>
<!---Modificado 8: <cfdump var="#Modificado#"><br/>--->    
</cfif>
<!--- Finaliza: validacion de modificacion--->
<!---<cf_dump var rsLF>--->

<style type="text/css">
<!--
.money {		text-align:right;
		white-space:nowrap;	
}
-->
</style>
<cfoutput>
<!--- Inicia: Pintado --->
<style type="text/css">
	.money{
		text-align:right;
		white-space:nowrap;	
	}
	.moneyTotal{
		text-align:right;
		white-space:nowrap;	
		border-top:ridge;
		font-weight:bold;
	}
</style>
<form action="#CurrentPage#" method="post" name="form1" onsubmit="">
	<input type="hidden" name="paso" value="#Gpaso#">
	<input type="hidden" name="DEid" value="#form.DEid#">
	<cfif DLlinea NEQ 0>
	<input name="DLlinea" type="hidden" value="#DLlinea#">
	</cfif>

<table align="center" width="100%" border="0" cellspacing="0" cellpadding="3">
	<tr>
		<td colspan="3">
			<cfset Modo = "Cambio">
			<cf_botones modo="#Modo#" names="Anterior,#btnName#,Siguiente" values="<< #vAnterior#,#btnTitulo#,#vSiguiente# >>" >	
		</td>
	</tr>
	<cfif existeLF eq 'false'>
	<tr>
		<td colspan="3" style="color:##FF0000" align="center">Los Datos no han Sido Guardados, debe de presionar el boton "#btnTitulo#"</td>
	</tr>
	<cfelseif Modificado>
	<tr>
		<td colspan="3" style="color:##FF0000" align="center">Los Datos han Sido Modificados, debe de presionar el boton "#btnTitulo#"</td>
	</tr>
	</cfif>	
</table>
<table align="center" width="60%" border="0" cellspacing="0" cellpadding="3">
	<tr>
		<td align="center" colspan="3"><strong style="font-size:18px">Conceptos de Finiquito</strong></td>
	</tr>
	<tr>
		<td align="center" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" width="50%"><strong>Conceptos</strong></td>
		<td align="center"><strong>Importe</strong></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>Percepciones Gravables</td>
		<td class="money">#fnFormatMoney(MontoGrabadoF)#<input type="hidden" name="MontoGrabadoF" value="#fnRedondear(MontoGrabadoF)#"></td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Gravable</strong></td>
			</tr>">
		<cfloop query="rsLiqIngresosF">
			<cfset MSG = MSG & "
			<tr>
				<td nowrap>#rsLiqIngresosF.RHLPdescripcion#</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(rsLiqIngresosF.RHLIgrabado)#</td>
			</tr>">
		</cfloop>
		<cfset MSG = MSG & "
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(MontoGrabadoF)#</td>
			</tr>">
		<cfset MSG = MSG & "
		</table>">
		<cfset fnPopUp("Percepciones Gravables","#MSG#",1)>
	</tr>
	<tr>
		<td>Percepciones Exentas</td>
		<td class="money">#fnFormatMoney(MontoExentoF)#<input type="hidden" name="MontoExentoF" value="#fnRedondear(MontoExentoF)#"></td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Exento</strong></td>
			</tr>">
		<cfloop query="rsLiqIngresosF">
			<cfset MSG = MSG & "
				<tr>
					<td nowrap>#rsLiqIngresosF.RHLPdescripcion#</td>
					<td>+</td>
					<td class='money'>#fnFormatMoney(rsLiqIngresosF.RHLIexento)#</td>
				</tr>">
		</cfloop>
		<cfset MSG = MSG & "
		<tr>
			<td class='moneyTotal' colspan='2'>TOTAL</td>
			<td class='moneyTotal'>#fnFormatMoney(MontoExentoF)#</td>
		</tr>">
		<cfset MSG = MSG & "
		</table>">
		<cfset fnPopUp("Percepciones Exentas","#MSG#",2)>
	</tr>
	<tr>
		<td><strong>Total</strong></td>
		<td class="money">#fnFormatMoney(TotalF)#</td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Monto</strong></td>
			</tr>
			<tr>
				<td nowrap>Percepciones Gravables</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(MontoGrabadoF)#</td>
			</tr>
			<tr>
				<td nowrap>Percepciones Exentas</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(MontoExentoF)#</td>
			</tr>
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(TotalF)#</td>
			</tr>
		</table>">
		<cfset fnPopUp("Total","#MSG#",3)>
	</tr>
	<tr>
	

		<td>ISPT</td>
		<td class="money">#fnFormatMoney(ISPTF)#<input type="hidden" name="ISPTF" value="#fnRedondear(ISPTF)#"></td>
		<!---
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Importe</strong></td>
			</tr>
			<tr>
				<td nowrap>Total Gravable</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(MontoGrabadoF)#</td>
			</tr>
			<tr>
				<td nowrap>Limite Inferior (113 LISR)</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(LISR113F.DIRinf)#</td>
			</tr>
			<tr>
				<td nowrap>% Sobre Excedente (113 LISR)</td>
				<td>*</td>
				<td class='money'>#fnFormatMoney(LISR113F.DIRporcentaje)#</td>
			</tr>
			<tr>
				<td class='moneyTotal'>Impuesto Marginal</td>
				<td class='moneyTotal'>&nbsp;</td>

				<td class='moneyTotal'>#fnFormatMoney((MontoGrabadoF - LISR113F.DIRinf) * (LISR113F.DIRporcentaje / 100))#</td>
			</tr>
			<tr>
				<td colspan='3'>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap>Cuota Fija (113 LISR)</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(LISR113F.DIRmontofijo)#</td>
			</tr>
			<tr>
				<td nowrap>Impuesto Marginal</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney((MontoGrabadoF - LISR113F.DIRinf) * (LISR113F.DIRporcentaje / 100))#</td>
			</tr>
			<tr>
				<td nowrap>Subsidio Empleado (115 LISR)</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(SubsidioF)#</td>
			</tr>
			<tr>
				<td class='moneyTotal'>Impuesto Sobre Tarifa</td>
				<td class='moneyTotal'>&nbsp;</td>
				<td class='moneyTotal'>#fnFormatMoney(((MontoGrabadoF - LISR113F.DIRinf) * (LISR113F.DIRporcentaje / 100) + LISR113F.DIRmontofijo) - SubsidioF)#</td>
			</tr>
		</table>">--->
		<cfset fnPopUp("ISPT","#MSG#",4)>
	</tr>
	<tr>
		<td><strong>Total Finiquito</strong></td>
		<td class="money">#fnFormatMoney(TotalGeneralF)#</td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Monto</strong></td>
			</tr>
			<tr>
				<td nowrap>Percepciones</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(TotalF)#</td>
			</tr>
			<tr>
				<td nowrap>ISPT</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(ISPTF)#</td>
			</tr>
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(TotalGeneralF)#</td>
			</tr>
		</table>">
		<cfset fnPopUp("Total Finiquito","#MSG#",5)>
	</tr>
    
	<tr>
		<td>Infonavít</td>
		<td class="money">#fnFormatMoney(Infonavit)#<input type="hidden" name="Infonavit" value="#fnRedondear(Infonavit)#"></td>
		<td>&nbsp;</td>
	</tr>
    
	<tr>
		<td><strong>Total Real</strong></td>
		<td class="money">#fnFormatMoney(TotalRealF)#</td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Monto</strong></td>
			</tr>
			<tr>
				<td nowrap>Total Finiquito</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(TotalGeneralF)#</td>
			</tr>
			<tr>
				<td nowrap>Infonavít</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(Infonavit)#</td>
			</tr>
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(TotalGeneralF)#</td>
			</tr>
		</table>">
		<cfset fnPopUp("Total Real","#MSG#",7)>
	</tr>
	<tr>
		<td align="center" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" colspan="3"><strong style="font-size:18px">Conceptos de Liquidación</strong></td>
	</tr>
	<tr>
		<td align="center" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td width="50%"><strong>Conceptos</strong></td>
		<td align="center"><strong>Importe</strong></td>
		<td>&nbsp;</td>
	</tr>
	<cfset MSG = "
	<table align='center' border='0' cellspacing='0' cellpadding='2'>
		<tr>
			<td width='50' colspan='2'><strong>Conceptos</strong></td>
			<td class='money'><strong>Monto</strong></td>
		</tr>
	">
	<cfloop query="rsLiqIngresosL">
	<tr>
		<td>#rsLiqIngresosL.RHLPdescripcion#</td>
		<td class="money">#fnFormatMoney(rsLiqIngresosL.importe)#</td>
		<td>&nbsp;</td>
	</tr>
	<cfset MSG = MSG & "
	<tr>
		<td>#rsLiqIngresosL.RHLPdescripcion#</td>
		<td>+</td>
		<td class='money'>#fnFormatMoney(rsLiqIngresosL.importe)#</td>
	</tr>">
	</cfloop>
	<tr>
		<td><strong>Total</strong></td>
		<td class="money">#fnFormatMoney(TotalL)#<input type="hidden" name="TotalL" value="#fnRedondear(TotalL)#"></td>
		<cfset MSG = MSG & "
		<tr>
			<td class='moneyTotal' colspan='2'>TOTAL</td>
			<td class='moneyTotal'>#fnFormatMoney(TotalL)#</td>
		</tr>
		</table>">
		<cfset fnPopUp("Total","#MSG#",8)>
	</tr>
	<tr>
    <cfif TotalL LTE 0>
     <cfset SalarioMensualLiq = 0>
        		<td>Salario Mensual</td>
		<td class="money">#fnFormatMoney(SalarioMensualLiq)#<input type="hidden" name="SalarioMensual" value="#fnRedondear(SalarioMensual)#"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
    <cfelse>
    <td>Salario Mensual</td>
		<td class="money">#fnFormatMoney(SalarioMensual)#<input type="hidden" name="SalarioMensual" value="#fnRedondear(SalarioMensual)#"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
    </cfif>
		
    <cfif TotalL LTE 0>
     <cfset LimiteInferior = 0>
    <cfset SobreExcedente = 0>
    <cfset ImpuestoMarginal = 0>
    <cfset CuotaFija = 0>
    <cfset ISPTSalario = 0>
    <cfelse>
    <cfset LimiteInferior = LISR113L.DIRinf>
    <cfset SobreExcedente = (LISR113L.DIRporcentaje)>
    <cfset ImpuestoMarginal = ((SalarioMensual - LISR113L.DIRinf) * (LISR113L.DIRporcentaje / 100))>
    <cfset CuotaFija =  LISR113L.DIRmontofijo>
    <cfset ISPTSalario = (CuotaFija+ImpuestoMarginal)>
    </cfif>
		<td>ISPT Salario </td>
		<td class="money">#fnFormatMoney(ISPTSalario)#<input type="hidden" name="ISPTSL" value="#fnRedondear(ISPTSL)#"></td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Importe</strong></td>
			</tr>
			<tr>
				<td nowrap>Salario Mensual</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(SalarioMensual)#</td>
			</tr>
			<tr>
				<td nowrap>Limite Inferior (113 LISR)</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(LimiteInferior)#</td>
			</tr>
			<tr>
				<td nowrap>% Sobre Excedente (113 LISR)</td>
				<td>*</td>
				<td class='money'>#fnFormatMoney(SobreExcedente)#</td>
			</tr>
			<tr>
				<td class='moneyTotal'>Impuesto Marginal</td>
				<td class='moneyTotal'>&nbsp;</td>
				<td class='moneyTotal'>#fnFormatMoney(ImpuestoMarginal)#</td>
			</tr>
			<tr>
				<td colspan='3'>&nbsp;</td>
			</tr>
			<tr>
				<td nowrap>Cuota Fija (113 LISR)</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(CuotaFija)#</td>
			</tr>
			<tr>
				<td nowrap>Impuesto Marginal</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(ImpuestoMarginal)#</td>
			</tr>
			<tr>
				<!---<td nowrap>Subsidio Empleado (115 LISR)</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(SubsidioL)#</td>--->
			</tr>
			<tr>
				<td class='moneyTotal'>ISPT Sueldo</td>
				<td class='moneyTotal'>&nbsp;</td>
				<td class='moneyTotal'>#fnFormatMoney(ISPTSalario)#</td><!--- - SubsidioL)--->
			</tr>
		</table>">
		<cfset fnPopUp("ISPT Salario","#MSG#",10)>
	</tr>
	<tr>
    <cfif TotalL LTE 0>
    <cfset Factor = 0>
    </cfif>
		<td>Factor</td>
		<td class="money">#fnFormatMoney(Factor*100)#%</td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Monto</strong></td>
			</tr>
			<tr>
				<td nowrap>ISPT Sueldo</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(ISPTSalario)#</td>
			</tr>
			<tr>
				<td nowrap>Salario Mensual</td>
				<td>/</td>
				<td class='money'>#fnFormatMoney(SalarioMensual)#</td>
			</tr>
			<tr>
				<td class='moneyTotal' colspan='2'>Factor</td>
				<td class='moneyTotal'>#fnFormatMoney(Factor*100)#%</td>
			</tr>
		</table>">
		<cfset fnPopUp("Factor","#MSG#",11)>
	</tr>
	<tr>
		<!---<td><strong>ISPT</strong></td>--->
		<!---<td class="money">#fnFormatMoney(CalculoLoco.Resultado)#---><input type="hidden" name="ISPTL" value="#fnRedondear(CalculoLoco.Resultado)#"></td>
		<!---<cfset MSG = '
		<table align="center" width="70%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="33%" style="border-right:ridge" nowrap="nowrap"><strong>Concepto</strong></td>
				<td width="33%" align="center" style="border-right:ridge"><strong>Formula</strong></td>
				<td width="33%" align="center" style="border-right:ridge"><strong>Total</strong></td>
			</tr>'>
		<cfloop query="rsNivelesCL">
			<cfset MSG = MSG & '<tr>
				<td width="33%" style="border-right:ridge" nowrap="nowrap">#rsNivelesCL.RHDVDdescripcion#</td>
				<td width="33%" style="border-right:ridge" class="money">#StructFind(CalculoLoco.OperacionNivel,rsNivelesCL.RHDVDid)#</td>
				<td width="33%" style="border-right:ridge" class="money">#fnFormatMoney(StructFind(CalculoLoco.ResultadoNivel,rsNivelesCL.RHDVDid))#</td>
			</tr>'>
		</cfloop>
		<cfset MSG = MSG & '
		</table>'>
		<cfset fnPopUp("ISPT","#MSG#",12)>--->
	</tr>
	<tr>
    <cfif TotalL LTE 0>
    <cfset BaseImp = 0>
    <cfset ParteExenta = 0>
    </cfif>
		<td width="50%"><strong>Base Impuesto</strong></td>
		<td class="money">#fnFormatMoney(BaseImp)#</td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Monto</strong></td>
			</tr>
			<tr>
				<td nowrap>Total Liquidación</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(TotalL)#</td>
			</tr>
			<tr>
				<td nowrap>Parte ISPT Exenta</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(ParteExenta)#</td>
			</tr>
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(BaseImp)#</td>
			</tr>
		</table>">
		<cfset fnPopUp("Base Impuesto","#MSG#",15)>
	</tr>
	<tr>
		<td align="center" colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td align="center" colspan="2"><strong style="font-size:18px">Operación General</strong></td>
	</tr>
	<tr>
		<td align="center" width="50%"><strong>Conceptos</strong></td>
		<td align="center"><strong>Importe</strong></td>
	</tr>
	<tr>
		<td width="50%">Total Real Finiquito</td>
		<td class="money">#fnFormatMoney(TotalF)#</td>
		<!---<td class="money">#fnFormatMoney(TotalRealF)#</td>--->
	</tr>
	<tr>
		<td width="50%">ISPT Finiquito</td>
		<td class="money">#fnFormatMoney(ISPTF)#</td>
	</tr>
	<tr>
		<td width="50%">Total Liquidación</td>
		<td class="money">#fnFormatMoney(TotalL)#</td>
	</tr>
	<tr>
		<cfif TotalL LTE 0>
            <cfset TotalRealLiquidacion = 0>
        </cfif>
		<td width="50%">ISPT Real Liquidación</td>
		<td class="money">#fnFormatMoney(TotalRealLiquidacion/100)#<input type="hidden" name="ISPTRealL" value="#TotalRealLiquidacion#"></td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Monto</strong></td>
			</tr>
			<tr>
				<td nowrap>Base Impuesto</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(BaseImp)#</td>
			</tr>
			<tr>
				<td nowrap>Factor</td>
				<td>*</td>
				<td class='money'>#fnFormatMoney(Factor*100)#%</td>
			</tr>
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(TotalRealLiquidacion/100)#</td>
			</tr>
		</table>">
		<cfset fnPopUp("ISPT Liquidación","#MSG#",16)>
	</tr>
	<tr>
		<td align="center" colspan="2">&nbsp;</td>
	</tr>
	<tr>
    <cfset Neto = TotalF - ISPTF + MontoGrabadoL - TotalRealLiquidacion/100 - MontoCargas>
		<td width="50%"><strong style="font-size:15px">Neto a recibir</strong></td>
		<td class="money"><u><strong>#fnFormatMoney(Neto)#</strong></u><input type="hidden" name="Neto" value="#fnRedondear(Neto)#"></td>
		<cfset MSG = "
		<table align='center' border='0' cellspacing='0' cellpadding='2'>
			<tr>
				<td width='50' colspan='2'><strong>Conceptos</strong></td>
				<td class='money'><strong>Importe</strong></td>
			</tr>
			<tr>
				<td nowrap>Total Real Finiquito</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(TotalF)#</td>
			</tr>
			<tr>
				<td nowrap>ISPT Finiquito</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(ISPTF)#</td>
			</tr>
			<tr>
				<td nowrap>Total Real Liquidación</td>
				<td>+</td>
				<td class='money'>#fnFormatMoney(MontoGrabadoL)#</td>
			</tr>
			<tr>
				<td nowrap>ISPT Liquidación</td>
				<td>-</td>
				<td class='money'>#fnFormatMoney(TotalRealLiquidacion/100)#</td>
			</tr>">
			<cfif rsMontoAportesRealizados.recordcount gt 0>
				<cfset MSG = MSG & "
					<tr>
						<td nowrap>Cargas Sociales</td>
						<td>-</td>
						<td class='money'>#fnFormatMoney(rsMontoAportesRealizados.monto)#</td>
					</tr>">
			</cfif>
		<cfset MSG = MSG & "
			<tr>
				<td class='moneyTotal' colspan='2'>TOTAL</td>
				<td class='moneyTotal'>#fnFormatMoney(Neto)#</td>
			</tr>
		</table>">
		<cfset fnPopUp("Neto a recibir","#MSG#",17)>
	</tr>
</table>
</form>
<!--- Finaliza: Pintado --->
<script language="javascript1.2" type="text/javascript">
	function funcAnterior() {
		document.form1.paso.value = 1;
	}

	function funcSiguiente() {
		<cfif existeLF eq 'false'>
			alert("Los Datos no han Sido Guardados, debe de presionar el boton Calcular Datos y Guardar");
			document.form1.paso.value = 2;
		<cfelseif Modificado>
			alert("Los Datos no han Sido Guardados, debe de presionar el boton Recalcular Datos y Guardar");
			document.form1.paso.value = 2;
		<cfelse>
			document.form1.paso.value = 3;
		</cfif>
	}
</script>
</cfoutput>
<cffunction name="fnFormatMoney" access="private" returntype="Any">
	<cfargument name="Monto" type="any">
	<cfargument name="Decimales" type="numeric" default="2">

	<cfreturn LsCurrencyFormat(fnRedondear(Arguments.Monto,Arguments.Decimales),'none')>
</cffunction>

<cffunction name="fnRedondear" access="private" returntype="Any">
	<cfargument name="Monto" type="any">
	<cfargument name="Decimales" type="numeric" default="2">
	<cfreturn NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#")>
</cffunction>

<cffunction name="fnPopUp" access="private" output="true">
	<cfargument name="Titulo" type="string">
	<cfargument name="MSG" type="string">
	<cfargument name="pageIndex" type="string">
	<td><cf_notas link="<img src='../../imagenes/help_small.gif' border='0'>" titulo="#Arguments.Titulo#" msg="#Arguments.MSG#" width="400" pageIndex="#Arguments.pageIndex#"></td>
</cffunction>


<!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
<cffunction name="fnGetDato" access="private" returntype="string">
	<cfargument name="Pcodigo" 	type="numeric" required="true">
	
	<cfquery name="rsParam" datasource="#session.dsn#">
		select Pvalor
		from RHParametros
		where Ecodigo = #session.Ecodigo# 
		  and Pcodigo = #Arguments.Pcodigo#
	</cfquery>
	<cfreturn #rsParam.Pvalor#>
</cffunction>

<!--- Obtiene los datos de la tabla de Parámetros segun el pcodigo --->
<cffunction name="fnValidaModificacion" access="private">
	<cfargument name="Monto1" 	type="numeric" required="true">
	<cfargument name="Monto2" 	type="numeric" required="true">
	
	<cfif fnRedondear(Arguments.Monto1) neq fnRedondear(Arguments.Monto2)>
		<cfset Modificado = true>
	</cfif>
</cffunction>
<cffunction name="rsMontoAportesRealizados" returntype="query">
	<cfargument name="DEid" 	type="numeric" required="true">
	
	<cfquery name="rsDetAportesRealizados" datasource="#Session.DSN#">
		select coalesce(sum(a.importe),0) as monto
		from RHLiqCargas a
		inner join DCargas   b
			on a.DClinea = b.DClinea
			and coalesce(DCSumarizarLiq,0) = 0
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	</cfquery>
	<cfreturn rsDetAportesRealizados>
</cffunction>

