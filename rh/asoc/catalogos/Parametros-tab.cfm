<!--- Pintado de la pantalla de Parámetros de la Asociación. --->			
<cfoutput>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
	<!--- Línea No. 1 --->
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<!--- Línea No. 2 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" colspan="2" bgcolor="##FAFAFA" align="center">
			<hr size="0"><font size="2" color="##000000"><strong>#LB_AhorroCredito#</strong></font>
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 3 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_Periodo#:&nbsp;</td>
		<td>
			<cfset anio = year(now())>
			<input name="Periodo" type="text" style="text-align: right;" tabindex="1"
				   onfocus="javascript:this.value=qf(this); this.select();" 
				   onblur="javascript:fm(this,-1);"  
				   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
				   value="<cfif PvalorPeriodo.RecordCount GT 0 and len(trim(PvalorPeriodo.Pvalor)) gt 0>#PvalorPeriodo.Pvalor#<cfelse>#anio#</cfif>" 
				   size="5" 
				   maxlength="4" 
				   <cfif PvalorPeriodo.RecordCount GT 0 and len(trim(PvalorPeriodo.Pvalor)) gt 0>disabled</cfif> >
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 4 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_Mes#:&nbsp;</td>
		<td>
			<cfif PvalorMes.RecordCount GT 0 and len(trim(PvalorMes.Pvalor)) gt 0>
				<cf_meses name="Mes" value="#PvalorMes.Pvalor#" readonly="true" tabindex="1" >
			<cfelse>
				<cf_meses name="Mes" tabindex="1" >
			</cfif>

		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 5 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_FactorDiasAnio#:&nbsp;</td>
		<td>
			<input name="FactorDiasAnio" type="text" style="text-align: right;" tabindex="1"
				   onfocus="javascript:this.value=qf(this); this.select();" 
				   onblur="javascript:fm(this,-1);"  
				   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
				   value="<cfif PvalorFactorDiasAnio.RecordCount GT 0 >#PvalorFactorDiasAnio.Pvalor#</cfif>" 
				   size="5" 
				   maxlength="3" >
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 6 --->
	<tr>
		<td width="5%">&nbsp;</td> 
		<td width="40%" align="right">#LB_OrdenAplicacionAdelantoPago#:&nbsp;</td>
		<td>
			<select name="AdelantoPago" tabindex="1">
				<option value="1" <cfif PvalorAdelantoPago.Pvalor eq '1' >selected</cfif> ><cf_translate key="CMB_SiguientesPagosDelPlan">Siguientes Pagos del Plan</cf_translate></option>
				<option value="2" <cfif PvalorAdelantoPago.Pvalor eq '2' >selected</cfif> ><cf_translate key="CMB_UltimosPagosDelPlan">&Uacute;ltimos Pagos del Plan</cf_translate></option>
			</select>
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 7 --->
	<tr>
		<td width="5%">&nbsp;</td> 
		<td width="40%" align="right">#LB_MetodoCalculoDividendos#:&nbsp;</td>
		<td>
			<select name="CalculoDividendos" tabindex="1">
				<option value="1" <cfif PvalorCalculoDividendos.Pvalor eq '1' >selected</cfif> ><cf_translate key="CMB_UtilizandoFactorDias">Utilizando Factor de D&iacute;as</cf_translate></option>
				<option value="2" <cfif PvalorCalculoDividendos.Pvalor eq '2' >selected</cfif> ><cf_translate key="CMB_UtilizandoFactorSaldoAhorros">Utilizando Factor de Saldo de Ahorros</cf_translate></option>
			</select>
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 8 --->
	<tr>
		<td width="5%">&nbsp;</td> 
		<td width="40%" align="right">#LB_SocioNegocio#:&nbsp;</td>
		<td>
			<cfif len(trim(PvalorSocioNegocio.Pvalor)) GT 0>
				<cf_rhsociosnegociosFA query="#rsSNegocio#"> 							
			<cfelse>
				<cf_rhsociosnegociosFA> 
			</cfif> 
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 9 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_PeriodoCalculoDividendo#:&nbsp;</td>
		<td>
			
			<input name="PeriodoAsociado" type="text" style="text-align: right;" tabindex="1"
				   onfocus="javascript:this.value=qf(this); this.select();" 
				   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
				   value="<cfif PvalorPeriodoAsociado.RecordCount GT 0 and len(trim(PvalorPeriodoAsociado.Pvalor)) gt 0>#PvalorPeriodoAsociado.Pvalor#</cfif>" 
				   size="5" 
				   maxlength="4" >
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 10 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_MesCalculoDividendo#:&nbsp;</td>
		<td>
			<cfif PvalorMesAsociado.RecordCount GT 0 and len(trim(PvalorMesAsociado.Pvalor)) gt 0>
				<cf_meses name="MesAsociado" value="#PvalorMesAsociado.Pvalor#" readonly="false" tabindex="1" >
			<cfelse>
				<cf_meses name="MesAsociado" tabindex="1" >
			</cfif>
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 11 --->
		<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		select 1
		from Empresa e
			inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'GT'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>
	<cfif rsEmpresa.RecordCount>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_CreditoSilvacano#:&nbsp;</td>
		<td>
			<cfset valuesArray = ArrayNew(1)>
			<cfif PvalorCredSilva.RecordCount GT 0 and len(trim(PvalorCredSilva.Pvalor)) gt 0>
				<cfquery name="rsCredito" datasource="#session.DSN#">
					select ACCTid,ACCTcodigo,ACCTdescripcion
					from ACCreditosTipo
					where ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCredSilva.Pvalor#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, rsCredito.ACCTid)>
				<cfset ArrayAppend(valuesArray, rsCredito.ACCTcodigo)>
				<cfset ArrayAppend(valuesArray, rsCredito.ACCTdescripcion)>
			</cfif>
			<cf_conlis 
					campos="ACCTid, ACCTcodigo, ACCTdescripcion"
					asignar="ACCTid, ACCTcodigo, ACCTdescripcion"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"						
					title="#LB_TiposDeCredito#"
					tabla="ACCreditosTipo"
					columnas="ACCTid, ACCTcodigo, ACCTdescripcion"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="ACCTcodigo,ACCTdescripcion"
					desplegar="ACCTcodigo,ACCTdescripcion"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#" 					
				/>  	
			
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_CreditoElectrodomesticos#:&nbsp;</td>
		<td>
			<cfset valuesArray = ArrayNew(1)>
			<cfif PvalorCredElectro.RecordCount GT 0 and len(trim(PvalorCredElectro.Pvalor)) gt 0>
				<cfquery name="rsCredito" datasource="#session.DSN#">
					select ACCTid as ACCTidE,ACCTcodigo as ACCTcodigoE,ACCTdescripcion as ACCTdescripcionE
					from ACCreditosTipo
					where ACCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PvalorCredElectro.Pvalor#">
				</cfquery>
				<cfset ArrayAppend(valuesArray, rsCredito.ACCTidE)>
				<cfset ArrayAppend(valuesArray, rsCredito.ACCTcodigoE)>
				<cfset ArrayAppend(valuesArray, rsCredito.ACCTdescripcionE)>
			</cfif>
			<cf_conlis 
					campos="ACCTidE, ACCTcodigoE, ACCTdescripcionE"
					asignar="ACCTidE, ACCTcodigoE, ACCTdescripcionE"
					size="0,8,30"
					desplegables="N,S,S"
					modificables="N,S,N"						
					title="#LB_TiposDeCredito#"
					tabla="ACCreditosTipo"
					columnas="ACCTid as ACCTidE, ACCTcodigo as ACCTcodigoE, ACCTdescripcion as ACCTdescripcionE"
					filtro="Ecodigo = #Session.Ecodigo#"
					filtrar_por="ACCTcodigoE,ACCTdescripcionE"
					desplegar="ACCTcodigoE,ACCTdescripcionE"
					etiquetas="#LB_Codigo#,#LB_Descripcion#"
					formatos="S,S"
					align="left,left"								
					asignarFormatos="S,S,S"
					form="form1"
					showEmptyListMsg="true"
					EmptyListMsg=" --- #MSG_NoHayRegistrosRelacionados# --- "
					valuesArray="#valuesArray#" 					
				/>  	
			
		</td>
		<td>&nbsp;</td>
	</tr>
	</cfif>
		<!--- Línea No. 12 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_PeriodoInt#:&nbsp;</td>
		<td>
			<cfset anio = year(now())>
			<input name="PeriodoInt" type="text" style="text-align: right;" tabindex="1"
				   onfocus="javascript:this.value=qf(this); this.select();" 
				   onblur="javascript:fm(this,-1);"  
				   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
				   value="<cfif PvalorPeriodoInt.RecordCount GT 0 and len(trim(PvalorPeriodoInt.Pvalor)) gt 0>#PvalorPeriodoInt.Pvalor#<cfelse>#anio#</cfif>" 
				   size="5" 
				   maxlength="4" 
				   <cfif PvalorPeriodoInt.RecordCount GT 0 and len(trim(PvalorPeriodoInt.Pvalor)) gt 0>disabled</cfif> >
		</td>
		<td>&nbsp;</td>
	</tr>
	<!--- Línea No. 13 --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="40%" align="right">#LB_MesInt#:&nbsp;</td>
		<td>
			<cfif PvalorMesInt.RecordCount GT 0 and len(trim(PvalorMesInt.Pvalor)) gt 0>
				<cf_meses name="MesInt" value="#PvalorMesInt.Pvalor#" readonly="true" tabindex="1" >
			<cfelse>
				<cf_meses name="MesInt" tabindex="1" >
			</cfif>

		</td>
		<td>&nbsp;</td>
	</tr>

	<!--- Línea No. 14 --->
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<!--- Línea No. 15 --->
	<tr>
		<td colspan="4">
			<table width="70%" border="0" align="center" cellpadding="2" cellspacing="0" >
				<tr>
					<td>
						<fieldset>
						<legend ><strong>#LB_ParaFomulaPlanPagos#</strong></legend>
							<table width="80%" border="0" align="center" cellpadding="2" cellspacing="0" >	
								<!--- Línea No. 12.1 --->
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="40%" align="right" nowrap="true">#LB_FactorDiasTipoNominaMensual#:&nbsp;</td>
									<td>
										<input name="NominaMensual" type="text" style="text-align: right;" tabindex="1"
									   		onfocus="javascript:this.value=qf(this); this.select();" 
									   		onblur="javascript:fm(this,-1);"  
									   		onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
									   		value="<cfif PvalorNominaMensual.RecordCount GT 0 >#PvalorNominaMensual.Pvalor#</cfif>" 
									   		size="5" 
									   		maxlength="2" >
									</td>
									<td>&nbsp;</td>
								</tr>
								<!--- Línea No. 12.2 --->
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="40%" align="right" nowrap="true">#LB_FactorDiasTipoNominaQuincenal#:&nbsp;</td>
									<td>
										<input name="NominaQuincenal" type="text" style="text-align: right;" tabindex="1"
											   onfocus="javascript:this.value=qf(this); this.select();" 
											   onblur="javascript:fm(this,-1);"  
											   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
											   value="<cfif PvalorNominaQuincenal.RecordCount GT 0 >#PvalorNominaQuincenal.Pvalor#</cfif>" 
											   size="5" 
											   maxlength="2" >
									</td>
									<td>&nbsp;</td>
								</tr>
								<!--- Línea No. 12.3 --->
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="40%" align="right" nowrap="true">#LB_FactorDiasTipoNominaBisemanal#:&nbsp;</td>
									<td>
										<input name="NominaBisemanal" type="text" style="text-align: right;" tabindex="1"
											   onfocus="javascript:this.value=qf(this); this.select();" 
											   onblur="javascript:fm(this,-1);"  
											   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
											   value="<cfif PvalorNominaBisemanal.RecordCount GT 0 >#PvalorNominaBisemanal.Pvalor#</cfif>" 
											   size="5" 
											   maxlength="2" >
									</td>
									<td>&nbsp;</td>
								</tr>
								<!--- Línea No. 12.4 --->
								<tr>
									<td width="5%">&nbsp;</td>
									<td width="40%" align="right" nowrap="true">#LB_FactorDiasTipoNominaSemanal#:&nbsp;</td>
									<td>
										<input name="NominaSemanal" type="text" style="text-align: right;" tabindex="1"
											   onfocus="javascript:this.value=qf(this); this.select();" 
											   onblur="javascript:fm(this,-1);"  
											   onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
											   value="<cfif PvalorNominaSemanal.RecordCount GT 0 >#PvalorNominaSemanal.Pvalor#</cfif>" 
											   size="5" 
											   maxlength="2" >
									</td>
									<td>&nbsp;</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>					
			</table>
		</td>
	</tr>	
	<!--- Línea No. 16 --->
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<!--- Línea No. 17 --->
	<tr>
		<td colspan="4" align="center">
			<input type="submit" name="btnAceptar" value="#BTN_Agregar#" tabindex="1">
		</td>
	</tr>
</table>
<cf_qforms>
	<cf_qformsrequiredfield name="Periodo" description="#LB_Periodo#">
	<cf_qformsrequiredfield name="FactorDiasAnio" description="#LB_FactorDiasAnio#">
	<cf_qformsrequiredfield name="NominaMensual" description="#LB_FactorDiasTipoNominaMensual#">
	<cf_qformsrequiredfield name="NominaQuincenal" description="#LB_FactorDiasTipoNominaQuincenal#">
	<cf_qformsrequiredfield name="NominaBisemanal" description="#LB_FactorDiasTipoNominaBisemanal#">
	<cf_qformsrequiredfield name="NominaSemanal" description="#LB_FactorDiasTipoNominaSemanal#">
	<cf_qformsrequiredfield name="PeriodoAsociado" description="#LB_PeriodoCalculoDividendo#">
	<cf_qformsrequiredfield name="PeriodoInt" description="#LB_PeriodoInt#">
	<cf_qformsrequiredfield name="MesInt" description="#LB_MesInt#">
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
	objForm.FactorDiasAnio.validateRango('1','365');
	objForm.NominaMensual.validateRango('1','99');
	objForm.NominaQuincenal.validateRango('1','99');
	objForm.NominaBisemanal.validateRango('1','99');
	objForm.NominaSemanal.validateRango('1','99');
	

</script>