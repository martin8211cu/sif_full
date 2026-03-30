<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">

<cfif isdefined("url.f_identificacion") and not isdefined("form.f_identificacion") >
	<cfset form.f_identificacion = url.f_identificacion >
</cfif>
<cfif isdefined("url.f_asociado") and not isdefined("form.f_asociado") >
	<cfset form.f_asociado = url.f_asociado >
</cfif>
<cfif isdefined("url.f_periodicidad") and not isdefined("form.f_periodicidad") >
	<cfset form.f_periodicidad = url.f_periodicidad >
</cfif>

<cfquery name="rs_parametros" datasource="#session.DSN#">
	select Pcodigo, Pvalor
	from ACParametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo in (30, 60, 70, 80, 90)
</cfquery>

<cfoutput>
<form name="form1" method="post" action="creditos-sql.cfm" onsubmit="javascript:return validar();" >
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
	<cfif modo neq 'ALTA'	>
		<input type="hidden" name="ACAid" value="#data.ACAid#">
		<input type="hidden" name="ACCAid" value="#data.ACCAid#">
	<cfelse>
		<tr><td width="50%" colspan="4"><strong>#LB_Asociado#</strong></td></tr>
		<tr><td colspan="4"><cf_rhasociado size="60" form="form1" tabindex="1"></td></tr>
  	</cfif>
  <tr>
    <td><strong>#LB_Tipo_Credito#</strong></td>
    <td><strong>#LB_Periodicidad#</strong></td>	
    <td><strong>#LB_Plazo#</strong></td>
    <td><strong>#LB_Fecha_Inicio#</strong></td>
  </tr>
  <tr>
    <td>
		<cfif modo NEQ "ALTA">
			<cfif modificable>
			<cf_rhtipocredito  query="#data_credito#" size="50">
			<cfelse>
				<input type="hidden" name="ACCTid" id="ACCTid" value="#data.ACCTid#" >
				#trim(data_credito.ACCTcodigo)# - #data_credito.ACCTdescripcion#
			</cfif>
		<cfelse>
			<cf_rhtipocredito size="50">
		</cfif> 
	</td>
	
    <td>
		<cfif modificable >
			<select name="ACCAperiodicidad" id="ACCAperiodicidad" tabindex="1" <cfif modo neq 'ALTA' and len(trim(data.Tcodigo))>disabled</cfif> >
				<option value="0" <cfif modo neq 'ALTA' and data.ACCAperiodicidad eq 0>selected</cfif>>#LB_Semanal#</option>
				<option value="1" <cfif modo neq 'ALTA' and data.ACCAperiodicidad eq 1>selected</cfif>>#LB_Bisemanal#</option>
				<option value="2" <cfif modo neq 'ALTA' and data.ACCAperiodicidad eq 2>selected</cfif>>#LB_Quincenal#</option>
				<option value="3" <cfif modo neq 'ALTA' and data.ACCAperiodicidad eq 3>selected</cfif>>#LB_Mensual#</option>
			</select>
		<cfelse>
			<cfif data.ACCAperiodicidad eq 0 >
				#LB_Semanal#
			<cfelseif data.ACCAperiodicidad eq 1 >
				#LB_Bisemanal#
			<cfelseif data.ACCAperiodicidad eq 2 >
				#LB_Quincenal#
			<cfelseif data.ACCAperiodicidad eq 3 >
				#LB_Mensual#
			</cfif>
			<input type="hidden" name="ACCAperiodicidad" id="ACCAperiodicidad" value="<cfif modo neq 'ALTA'>#data.ACCAperiodicidad#</cfif>"  >  			
		</cfif>	
		<input type="hidden" name="Tcodigo" id="Tcodigo" value="<cfif modo neq 'ALTA'>#data.Tcodigo#</cfif>"  >  
	</td>
    <td>
		<table width="50%" cellpadding="2" cellspacing="0">
			<tr>
				<cfif MODO EQ "ALTA">
					<td><cf_inputnumber name="ACCTplazo" decimales="0" enteros="4" tabindex="1" onBlur="plazo_meses()"></td><td>Meses</td>
					<td>
						<cf_inputnumber name="ACCTcuotas" decimales="0" enteros="4" tabindex="1" onblur="plazo_cuotas()">
						<!---
						<input	type		= "text"
								name		= "ACCTcuotas" id="ACCTcuotas"
								value		= ""
								style		= "text-align:right;"
								tabindex	= "1"
								onfocus		= "this.value=qf(this); this.select();"
								onkeypress	= "return _CFinputText_onKeyPress(this,event,4,0,false,true);"
								onkeyup		= "_CFinputText_onKeyUp(this,event,4,0,false,true);"
								onblur		= "fm(this,0,true,false,'');"
								onchange	= "plazo_cuotas()"
								size		= "5"
								maxlength	= "6"
							>
							--->						
					</td><td>Cuotas</td>
				<cfelse>
					<cfif modificable >
						<td><cf_inputnumber name="ACCTplazo" decimales="0" value="#data.ACCTplazo#" enteros="4" tabindex="1" onBlur="plazo_meses()"><td>Meses</td>
						<cfif data_credito.ACCTmodificable eq 0><script>document.form1.ACCTplazo.disabled = true;</script></cfif>
						<td>
							<cf_inputnumber  name="ACCTcuotas" decimales="0" value="#data.ACCTcuotas#" enteros="4" tabindex="1" onblur="plazo_cuotas()">
							<!---
							<input	type		= "text"
									name		= "ACCTcuotas" id="ACCTcuotas"
									value		= "#data.ACCTcuotas#"
									style		= "text-align:right;"
									tabindex	= "1"
									onfocus		= "this.value=qf(this); this.select();"
									onkeypress	= "return _CFinputText_onKeyPress(this,event,4,0,false,true);"
									onkeyup		= "_CFinputText_onKeyUp(this,event,4,0,false,true);"
									onblur		= "fm(this,0,true,false,'');"
									onchange	= "plazo_cuotas()"
									size		= "5"
									maxlength	= "6"
								>
								--->						
						</td>
						<td>Cuotas</td>
						<cfif data_credito.ACCTmodificable eq 0><script>document.form1.ACCTcuotas.disabled = true;</script></cfif>
					<cfelse>
						<td>#LSNumberFormat(data.ACCTplazo, ',9')#</td><td>Meses,</td>
						<td>#LSNumberFormat(data.ACCTcuotas, ',9')#</td><td>Cuotas</td>
						<input type="hidden" name="ACCTplazo" id="ACCTplazo" value="#data.ACCTplazo#">
						<input type="hidden" name="ACCTcuotas" id="ACCTcuotas" value="#data.ACCTcuotas#">
					</cfif>
				</cfif>
			</tr>
		</table>
	</td>
    <td>
		<cfif MODO EQ "ALTA">
			<cf_sifcalendario form="form1" name="ACCTfechaInicio" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
		<cfelse>
			<cfif modificable >
				<cfoutput>
					<cf_sifcalendario form="form1" name="ACCTfechaInicio" value="#LSDateFormat(data.ACCTfechaInicio,'dd/mm/yyyy')#" tabindex="1">
				</cfoutput>
			<cfelse>
				#LSDateFormat(data.ACCTfechaInicio,'dd/mm/yyyy')#
				<input type="hidden" name="ACCTfechaInicio" id="ACCTfechaInicio" value="#LSDateFormat(data.ACCTfechaInicio,'dd/mm/yyyy')#">
			</cfif>
		</cfif>		
	</td>
	
  </tr>
  <tr>
  </tr>
  <tr>
  </tr>
  <tr>
    <td><strong>#LB_Tasa#</strong></td>
    <td><strong>#LB_Tasa_mora#</strong></td>
    <td><strong>#LB_Monto#</strong></td>	
	<cfif modo neq 'ALTA'>
	    <td><strong>#LB_Saldo#</strong></td>		
	</cfif>
  </tr>
  <tr>
    <td>
		<cfif MODO EQ "ALTA">
			<cf_monto name="ACCTtasa" decimales="2" size="6" tabindex="1">	
		<cfelse>
			<cfif modificable >
				<cf_monto name="ACCTtasa" decimales="2" value="#data.ACCTtasa#" size="6" tabindex="1">	
				<cfif data_credito.ACCTmodificable eq 0><script>document.form1.ACCTtasa.disabled = true;</script></cfif>
			<cfelse>
				#LSNumberFormat(data.ACCTtasa, ',9.00')#					
				<input type="hidden" name="ACCTtasa" id="ACCTtasa" value="#data.ACCTtasa#">				
			</cfif>
		</cfif>
	</td>
    <td>
		<cfif MODO EQ "ALTA">
			<cf_monto name="ACPTtasamora" decimales="2" size="6" tabindex="1">	
		<cfelse>
			<cfif modificable>
				<cf_monto name="ACPTtasamora" decimales="2" value="#data.ACPTtasamora#" size="6" tabindex="1">	
				<cfif data_credito.ACCTmodificable eq 0><script>document.form1.ACPTtasamora.disabled = true;</script></cfif>
			<cfelse>
				#LSNumberFormat(data.ACPTtasamora, ',9.00')#					
				<input type="hidden" name="ACPTtasamora" id="ACPTtasamora" value="#data.ACPTtasamora#">				
			</cfif>
			
		</cfif>
	</td>
    <td>
		<cfif MODO EQ "ALTA">
			<cf_monto name="ACCTcapital" decimales="2" size="12" tabindex="1">	
		<cfelse>
			<cfif modificable>
				<cf_monto name="ACCTcapital" decimales="2" value="#data.ACCTcapital#" size="12" tabindex="1">	
			<cfelse>
				#LSNumberFormat(data.ACCTcapital, ',9.00')#	
				<input type="hidden" name="ACCTcapital" id="ACCTcapital" value="#data.ACCTcapital#">				
			</cfif>
		</cfif>
	</td>
	<cfif modo neq 'ALTA'>
		<td>
			#LSNumberFormat(data.ACCTcapital-data.ACCTamortizado, ',9.00')#	
		</td>
	</cfif>
	
  </tr>
  <tr>
    <td colspan="4" align="center">
	<cfset excluir = '' >
	<cfif not modificable>
		<cfset excluir = ',CAMBIO,BAJA' >
	</cfif>
		<cf_botones modo="#modo#" tabindex="1" include="Regresar" exclude="Limpiar#excluir#">
	</td>
  </tr>
</table>

<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
	<input type="hidden" name="f_identificacion" value="#form.f_identificacion#" >
</cfif>
<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
	<input type="hidden" name="f_asociado" value="#form.f_asociado#" >
</cfif>
<cfif isdefined("form.f_periodicidad") and len(trim(form.f_periodicidad)) >
	<input type="hidden" name="f_periodicidad" value="#form.f_periodicidad#" >
</cfif>

</form>

<cfif modo neq 'ALTA'>
	<cfset contador = 0 >
	<cfset rsPlan = plan.obtenerPlanPagos(data.ACCAid, session.DSN) >
	<table width="98%" align="center" cellspacing="0" cellpadding="2">
		<tr bgcolor="##CCCCCC"><tr><td colspan="10" bgcolor="##CCCCCC"><strong>Plan de Pagos</strong></td></tr></tr>
		<tr class="tituloListas">
			<td>Cuota</td>
			<td align="center">Fecha de Pago</td>
			<td align="center">Fecha registro de Pago</td>			
			<td align="right">Saldo</td>
			<td align="right">Intereses</td>
			<td align="right">Amortizacion</td>				
			<td align="right">Monto Cuota</td>
			<td align="center">Pagado</td>
			<td align="left">Tipo de Pago</td>
			<td align="left">Periodicidad</td>
		</tr>
		<cfloop query="rsPlan">
			<cfif rsPlan.ACPPtipo eq 'N' or rsPlan.ACPPtipo eq 'M'><cfset contador = contador+1></cfif>
			<tr class="<cfif rsPlan.currentrow mod 2>listaPar<cfelse>listaNon</cfif>" >
				<td><cfif rsPlan.ACPPtipo eq 'N' or rsPlan.ACPPtipo eq 'M'>#contador#<cfelse>*</cfif></td>
				<td align="center">#LSDateFormat(rsPlan.ACPPfecha,'dd/mm/yyyy')#</td>
				<td align="center">#LSDateFormat(rsPlan.ACPPfechaPago,'dd/mm/yyyy')#</td>
				<td align="right">#LSNumberFormat(rsPlan.ACPPsaldoAnterior, ',9.00')#</td>
				<td align="right">#LSNumberFormat(rsPlan.ACPPpagoInteres, ',9.00')#</td>
				<td align="right">#LSNumberFormat(rsPlan.ACPPpagoPrincipal, ',9.00')#</td>				
				<td align="right">#LSNumberFormat(rsPlan.ACPPcuota, ',9.00')#</td>
				<td align="center"><cfif rsPlan.ACPPestado eq 'S'><img src="/cfmx/rh/imagenes/checked.gif"><cfelse><img src="/cfmx/rh/imagenes/unchecked.gif"></cfif></td>
				<td align="left">
					<cfif rsPlan.ACPPtipo eq 'N'>
						N&oacute;mina
					<cfelseif rsPlan.ACPPtipo eq 'E'>
						Extraordinario
					<cfelseif rsPlan.ACPPtipo eq 'M'>
						Manual
					<cfelseif rsPlan.ACPPtipo eq 'L'>
						Liquidación
					</cfif>
				</td>
				<td align="left">
					<cfif rsPlan.ACPPperiodicidad eq '0'>
						#LB_Semanal#
					<cfelseif rsPlan.ACPPperiodicidad eq '1'>
						#LB_Bisemanal#
					<cfelseif rsPlan.ACPPperiodicidad eq '2'>
						#LB_Quincenal#
					<cfelseif rsPlan.ACPPperiodicidad eq '3'>
						#LB_Mensual#
					</cfif>
				</td>
			</tr>
		</cfloop>
	</table>
</cfif>

</cfoutput>

<cf_qforms form="form1">
<script language="javascript1.5" type="text/javascript">

	var parametros = new Object();
	var periodicidad = new Object();
	var dias_anno = 0;
	<cfoutput query="rs_parametros">
		parametros['#rs_parametros.Pcodigo#'] = '#rs_parametros.Pvalor#';
		<cfif rs_parametros.Pcodigo eq 30 >
			dias_anno = '#rs_parametros.Pvalor#';
		</cfif>
	</cfoutput>
	
	periodicidad['0'] = '90';
	periodicidad['1'] = '80';
	periodicidad['2'] = '70';
	periodicidad['3'] = '60';
	
	<cfoutput>
		objForm.ACAid.required = true;
		objForm.ACAid.description = '#LB_Asociado#';
		objForm.ACCTid.required = true;
		objForm.ACCTid.description = '#LB_Tipo_credito#';
		objForm.ACCTfechaInicio.required = true;
		objForm.ACCTfechaInicio.description = '#LB_Fecha_inicio#';
		objForm.ACCTplazo.required = true;
		objForm.ACCTplazo.description = '#LB_Plazo#';
		objForm.ACCTtasa.required = true;
		objForm.ACCTtasa.description = '#LB_Tasa#';
		objForm.ACPTtasamora.required = true;
		objForm.ACPTtasamora.description = '#LB_Tasa_mora#';
		objForm.ACCTcapital.required = true;
		objForm.ACCTcapital.description = '#LB_Monto#';
		
	</cfoutput>
	
	function habilitarValidacion(){
		objForm.ACAid.required = true;
		objForm.ACCTid.required = true;
		objForm.ACCTfechaInicio.required = true;
		objForm.ACCTplazo.required = true;
		objForm.ACCTtasa.required = true;
		objForm.ACPTtasamora.required = true;
		objForm.ACCTcapital.required = true;
	}
			
	function deshabilitarValidacion(){
		objForm.ACAid.required = false;
		objForm.ACCTid.required = false;
		objForm.ACCTfechaInicio.required = false;
		objForm.ACCTplazo.required = false;
		objForm.ACCTtasa.required = false;
		objForm.ACPTtasamora.required = false;
		objForm.ACCTcapital.required = false;		
	}
	
	function validar(){
		document.form1.Tcodigo.disabled = false;
		document.form1.ACCAperiodicidad.disabled = false;
		document.form1.ACCTplazo.disabled = false;
		document.form1.ACCTtasa.disabled = false;
		document.form1.ACPTtasamora.disabled = false;
		document.form1.ACCTfechaInicio.disabled = false;		
		document.form1.ACCTcapital.disabled = false;
		
		return true;
	}	
	
	function funcACAid(){
		if ( document.form1._Tcodigo.value != ''){
			document.getElementById("ACCAperiodicidad").disabled = true;
			document.getElementById("Tcodigo").disabled = true;
			document.getElementById("Tcodigo").value = document.form1._Tcodigo.value;
			document.getElementById("ACCAperiodicidad").value = document.form1._periodicidad.value;
		}
		else{
			document.getElementById("ACCAperiodicidad").disabled = false;
			document.getElementById("Tcodigo").disabled = true;
			document.getElementById("Tcodigo").value = '';
			document.getElementById("ACCAperiodicidad").value = 0;
		}
		plazo_meses();	
	}

	function funcACCTcodigo(){
		document.form1.ACCTplazo.value = document.form1._plazo.value;
		document.form1.ACCTtasa.value = document.form1._tasa.value;
		document.form1.ACPTtasamora.value = document.form1._tasamora.value;
		
		document.form1.ACCTplazo.disabled = false;
		document.form1.ACCTtasa.disabled = false;
		document.form1.ACPTtasamora.disabled = false;
		if (document.form1._modificable.value == '0'){
			document.form1.ACCTplazo.disabled = true;
			document.form1.ACCTtasa.disabled = true;
			document.form1.ACPTtasamora.disabled = true;
		}
		
		plazo_meses();
	}
	
	function funcNuevo(){
		location.href = 'creditos.cfm';
		return false;
	}

	function funcRegresar(){
		deshabilitarValidacion();
	}

	function plazo_meses(){
		if ( document.form1.ACCTplazo.value != '' && periodicidad[document.form1.ACCAperiodicidad.value] != '' && dias_anno != ''  ){
			var cuotas = calcularCuotas(document.form1.ACCTplazo.value, periodicidad[document.form1.ACCAperiodicidad.value]);
			document.form1.ACCTcuotas.value = cuotas;
		}
	}
	function plazo_cuotas(){
		if ( document.form1.ACCTcuotas.value != '' && periodicidad[document.form1.ACCAperiodicidad.value] != '' && dias_anno != ''  ){
			var meses  = calcularMeses(document.form1.ACCTcuotas.value, periodicidad[document.form1.ACCAperiodicidad.value]);
			document.form1.ACCTplazo.value = meses;
		}	
	}
	function calcularMeses(cuotas, parametro){
		return Math.round(parseFloat((12*parseFloat(parametros[parametro])*parseFloat(cuotas))/parseFloat(dias_anno)));
	}
	
	function calcularCuotas(meses, parametro){
		return Math.round((parseFloat(meses)*parseFloat(dias_anno))/(parseFloat(parametros[parametro])*12));
	}
</script>