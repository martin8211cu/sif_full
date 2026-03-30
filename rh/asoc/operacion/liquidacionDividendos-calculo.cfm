<!--- Pintado de la Pantalla --->
<cfoutput>
<form name="form1" method="post" action="liquidacionDividendos-sql.cfm" style="margin:0; ">			
	<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<!--- Línea No. 1 --->
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<!--- Línea No. 2 --->
		<tr>
			<td >&nbsp;</td>
			<td bgcolor="##FAFAFA" align="center">
				<hr size="0"><font size="2" color="##000000"><strong>#LB_LiquidacionDividendos#</strong></font>
			</td>
			<td>&nbsp;</td>
		</tr>
		<!--- Línea No. 3 --->
		<tr>
			<td >&nbsp;</td>
			<td>
				<table width="40%" border="0" align="center" cellpadding="2" cellspacing="0" >
					<tr>
						<td>
							<fieldset>
								<legend><strong>#LB_FechasDeCorte#</strong></legend>
								<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
									
									<tr>
										<td nowrap="nowrap" align="right" width="45%"><strong>#LB_PeriodoCierre#:</strong>&nbsp;</td>
										<td>
											<input name="Periodo" type="text" style="text-align: right;" tabindex="1"
												onfocus="javascript:this.value=qf(this); this.select();" 
												onBlur="javascript:fm(this,-1);"
												onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
												value="<cfif rsPeriodo.RecordCount GT 0 and len(trim(rsPeriodo.Pvalor)) gt 0>#rsPeriodo.Pvalor#</cfif>" 
												size="5" 
												maxlength="4" 
												disabled 
											>
										</td>
									</tr>
									<tr>
										<td nowrap="nowrap" align="right" width="45%"><strong>#LB_MesCierre#:</strong>&nbsp;</td>
										<td>
											<cfif rsMes.RecordCount GT 0 and len(trim(rsMes.Pvalor)) gt 0>
												<cf_meses name="Mes" value="#rsMes.Pvalor#" readonly="true" tabindex="1" >
											<cfelse>
												<cf_meses name="Mes" tabindex="1" >
											</cfif>
										</td>
									</tr>
																	
								</table>
							</fieldset>
						</td>
					<tr>
				</table>
			</td>
			<td >&nbsp;</td>
		</tr>
		<!--- Línea No. 4 --->
		<tr>
			<td >&nbsp;</td>
			<td>
				<table width="40%" border="0" align="center" cellpadding="2" cellspacing="0" >
					
					<cfif isdefined("rsTipoFactorCalculo") and trim(rsTipoFactorCalculo.Pvalor) EQ 1>				
						<!--- Obtenemos los Días del Año de ACParametros --->						
						<cfset lastDateYear = createDate(#rsPeriodo.Pvalor#-1,#rsMes.Pvalor#+1,1)>
						<cfset lastDayMonth = DaysInMonth(createDate(#rsPeriodo.Pvalor#,#rsMes.Pvalor#,1))>
						<cfset newsDateYear = createDate(#rsPeriodo.Pvalor#,#rsMes.Pvalor#,#lastDayMonth#)>
						
						<cfquery name="rsDiasDelAnio" datasource="#Session.DSN#">			
							select sum(PEcantdias) as Pvalor
							from ACAsociados a
       							inner join HPagosEmpleado b
       								on b.DEid = a.DEid
       								and b.PEdesde >= ACAfechaIngreso
       								and b.PEdesde >= #lastDateYear#
							where a.ACAestado = 1
								and ACAfechaIngreso <= #newsDateYear#
						</cfquery>			
						
						<!--- Línea No. 4.1.a --->
						<tr>
							<td nowrap="nowrap" align="right" width="45%"><strong>#LB_DiasDelAnio#:</strong>&nbsp;</td>
							<td>					
								<input name="ACDfactor" type="text" style="text-align: right;" tabindex="1"
								   onfocus="javascript:this.value=qf(this); this.select();" 
								   onBlur="javascript:fm(this,-1);"  
								   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
								   value="<cfif rsDiasDelAnio.RecordCount GT 0 and len(trim(rsDiasDelAnio.Pvalor)) GT 0 >#rsDiasDelAnio.Pvalor#</cfif>" 
								   size="8" 
								   maxlength="8"
								   readonly="true" 
								>
							</td>
						</tr>
					<cfelse>
						<!--- Obtenemos el Monto Total de Ahorros --->
						<cfquery name="rsSaldoAhorros" datasource="#Session.DSN#">
							select sum(a.ACAAsaldoInicial + a.ACAAaporteMes) as Ahorros
							from ACAportesSaldos a
								inner join ACAportesAsociado b
									on b.ACAAid  = a.ACAAid
									inner join ACAportesTipo c
										on c.ACATid = b.ACATid      
							where a.ACASperiodo = #rsPeriodo.Pvalor#
							    and a.ACASmes = #rsMes.Pvalor#
							    and c.ACATtipo = 'O'
							    and c.ACATorigen = 'O'
						</cfquery>
						<!--- Línea No. 4.1.b --->
						<tr>
							<td nowrap="nowrap" align="right" width="45%"><strong>#LB_SaldoTotalAhorros#:</strong>&nbsp;</td>
							<td>
								<cfif rsSaldoAhorros.RecordCount GT 0 and len(trim(rsSaldoAhorros.Ahorros)) GT 0><cfset Ahorro = rsSaldoAhorros.Ahorros></cfif>
								<cf_inputNumber name="ACDfactor" value="#Ahorro#" enteros="9" decimales="2" readonly="true">
							</td>
						</tr>
					</cfif>
					
					<!--- Línea No. 4.2--->
					<tr>
						<td nowrap="nowrap" align="right" width="45%"><strong>#LB_MontoDistribuir#:</strong>&nbsp;</td>
						<td>
							<cfif rsDatos.RecordCount GT 0 and len(trim(rsDatos.ACDmonto)) GT 0>
								<cfset monto = rsDatos.ACDmonto>
							<cfelse>
								<cfset monto = ''>
							</cfif>
							<cf_inputNumber name="ACDmonto" value="#monto#" enteros="9" decimales="2">
						</td>
					</tr>
					<!--- Línea No. 4.3 --->
					<tr>
						<td nowrap="nowrap" align="right" width="45%"><strong>Fecha de Pago:</strong>&nbsp;</td>
						<td><cf_sifcalendario name="ACDfechaPago" value="#LSDateFormat(Now(),'DD/MM/YYYY')#"></td>
					</tr>									
				</table>
			</td>
			<td >&nbsp;</td>
		</tr>

		<cfif rsVerificaAplicados.RecordCount EQ 0 >
			<cfset botones = "">
			<cfset botones = ListAppend(botones,'Calcular')>
			<cfif rsVerificaCapturados.RecordCount GT 0 >
				<cfset botones = ListAppend(botones,'Aplicar')>
			</cfif>	
			<!--- Línea No. 5 --->
			<tr>
				<td colspan="3">&nbsp;</td>
			</tr>
			<!--- Línea No. 6 --->		
			<tr>
				<td >&nbsp;</td>
				<td align="center">
					<cf_botones values="#botones#">
				</td>
				<td>&nbsp;</td>
			</tr>
		</cfif>
		<input type="hidden" name="ACDmes" value="#rsMes.Pvalor#">
		<input type="hidden" name="ACDperiodo" value="#rsPeriodo.Pvalor#">
		<input type="hidden" name="TipoFactorCalculo" value="#rsTipoFactorCalculo.Pvalor#">	
		<cfif rsDatos.RecordCount GT 0 and len(trim(rsDatos.ACDid)) GT 0>
			<input type="hidden" name="ACDid" value="#rsDatos.ACDid#">
		</cfif>
						
	</table>
</form>
<cf_qforms>
	<cf_qformsrequiredfield name="ACDmonto" description="#LB_MontoDistribuir#">
</cf_qforms>	
</cfoutput>

<script language="javascript" type="text/javascript">

	//Funcion para validar un rango
	function _Field_isRango(low, high){
		var low = _param(arguments[0], 0, "number");
    	var high = _param(arguments[1], 9999999, "number");
      	var iValue = parseInt(qf(this.value));
      	if(isNaN(iValue))iValue=0;
      	if((low>iValue)||(high<iValue)){
      		this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
		}
	}

	// Sentencia que agrega la funcion _Field_isRango al API
	_addValidator("isRango", _Field_isRango);

	// Forma de invocacion de la función de validar rango
	objForm.ACDmonto.validateRango('1','999999999');
	
	// Funcion para Aplicar los Dividendos
	function funcAplicar(){
		if(confirm("Esta seguro(a) que desea aplicar...")){
			return true;
		}
	}

</script>


