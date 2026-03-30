<cf_templateheader title="Consulta de Control de Ventas por Agente">
	<cf_web_portlet_start titulo="Consulta de Control de Ventas por Agente">
		<cfoutput>
			<form method="get" name="form1" action="ctrlVentas-sql.cfm" onSubmit="javascript: return validarFiltros(this);">
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
					  <td width="43%">
							<table width="100%">
								<tr>
									<td valign="top">	
										<cf_web_portlet_start tipo="box" titulo="Consulta de Control de Ventas por Agente">
											<div align="justify">
												&Eacute;ste reporte permite visualizar las ventas generales realizadas
												por cada agente, separadas por paquete y contratos para 
												un determinado rango de días y de meses.
											</div>
										<cf_web_portlet_end> 
									</td>
								</tr>
							</table>  
					  </td>
						<td width="57%" valign="top">
							<table width="100%"  border="0" cellspacing="2" cellpadding="0">
							  <tr>
								<td width="21%" align="right"><strong>Agente</strong>:</td>
								<td colspan="3">
									<cf_identificacion 
										soloAgentes="true"
										ocultarPersoneria="true"
										editable="false"
										pintaEtiq="false">
								</td>
							  </tr>										
							  <tr>
								<td width="21%" align="right"><strong>Modo:</strong></td>
								<td colspan="3">
									<input name="rbModo" type="radio" value="1" onClick="javascript: prendeFiltros(1);" <cfif isdefined('form.rbModo') and form.rbModo EQ 1> checked<cfelse> checked</cfif>>
									Mensual 
									<input name="rbModo" type="radio" value="2" onClick="javascript: prendeFiltros(2);" <cfif isdefined('form.rbModo') and form.rbModo EQ 1> checked</cfif>>
									Diario
								</td>
							  </tr>							  
							  <tr id="mesIni">
								<td width="21%" align="right" nowrap><strong>Mes Inicial:</strong></td>
								<td width="36%">
									<cfif not isdefined('form.mesIni')>
										<cfset form.mesIni = Month(Now())>
									</cfif>
								
									<select name="mesIni">
									  <option value="01" <cfif isdefined('form.mesIni') and form.mesIni EQ '01'> selected</cfif>>Enero</option>
									  <option value="02" <cfif isdefined('form.mesIni') and form.mesIni EQ '02'> selected</cfif>>Febrero</option>
									  <option value="03" <cfif isdefined('form.mesIni') and form.mesIni EQ '03'> selected</cfif>>Marzo</option>
									  <option value="04" <cfif isdefined('form.mesIni') and form.mesIni EQ '04'> selected</cfif>>Abril</option>
									  <option value="05" <cfif isdefined('form.mesIni') and form.mesIni EQ '05'> selected</cfif>>Mayo</option>
									  <option value="06" <cfif isdefined('form.mesIni') and form.mesIni EQ '06'> selected</cfif>>Junio</option>
									  <option value="07" <cfif isdefined('form.mesIni') and form.mesIni EQ '07'> selected</cfif>>Julio</option>
									  <option value="08" <cfif isdefined('form.mesIni') and form.mesIni EQ '08'> selected</cfif>>Agosto</option>
									  <option value="09" <cfif isdefined('form.mesIni') and form.mesIni EQ '09'> selected</cfif>>Setiembre</option>
									  <option value="10" <cfif isdefined('form.mesIni') and form.mesIni EQ '10'> selected</cfif>>Octubre</option>
									  <option value="11" <cfif isdefined('form.mesIni') and form.mesIni EQ '11'> selected</cfif>>Noviembre</option>
									  <option value="12" <cfif isdefined('form.mesIni') and form.mesIni EQ '12'> selected</cfif>>Diciembre</option>
								  	</select>
								</td>
							  	<td width="17%" nowrap align="right"><strong>A&ntilde;o Inicial:</strong></td>
							  	<td width="26%">
									<cfset valAnoIniMes = 0>
									<cfif isdefined('form.anoIniMes') and form.anoIniMes NEQ ''>
										<cfset valAnoIniMes = form.anoIniMes>
									<cfelse>
										<cfset valAnoIniMes = Year(Now()) - 1>
									</cfif>
									<cf_campoNumerico 
										readonly="false" 
										name="anoIniMes" 
										decimales="0" 
										size="7" 
										maxlength="4" 								
										value="#HTMLEditFormat(valAnoIniMes)#" 
										tabindex="1">										
								</td>
							  </tr>												  
							  <tr id="mesFin">
								<td width="21%" align="right"><strong>Mes Final:</strong></td>
								<td width="36%">
									<cfif not isdefined('form.mesFin')>
										<cfset form.mesFin = Month(Now())>
									</cfif>
																	
									<select name="mesFin">
									  <option value="01" <cfif isdefined('form.mesFin') and form.mesFin EQ '01'> selected</cfif>>Enero</option>
									  <option value="02" <cfif isdefined('form.mesFin') and form.mesFin EQ '02'> selected</cfif>>Febrero</option>
									  <option value="03" <cfif isdefined('form.mesFin') and form.mesFin EQ '03'> selected</cfif>>Marzo</option>
									  <option value="04" <cfif isdefined('form.mesFin') and form.mesFin EQ '04'> selected</cfif>>Abril</option>
									  <option value="05" <cfif isdefined('form.mesFin') and form.mesFin EQ '05'> selected</cfif>>Mayo</option>
									  <option value="06" <cfif isdefined('form.mesFin') and form.mesFin EQ '06'> selected</cfif>>Junio</option>
									  <option value="07" <cfif isdefined('form.mesFin') and form.mesFin EQ '07'> selected</cfif>>Julio</option>
									  <option value="08" <cfif isdefined('form.mesFin') and form.mesFin EQ '08'> selected</cfif>>Agosto</option>
									  <option value="09" <cfif isdefined('form.mesFin') and form.mesFin EQ '09'> selected</cfif>>Setiembre</option>
									  <option value="10" <cfif isdefined('form.mesFin') and form.mesFin EQ '10'> selected</cfif>>Octubre</option>
									  <option value="11" <cfif isdefined('form.mesFin') and form.mesFin EQ '11'> selected</cfif>>Noviembre</option>
									  <option value="12" <cfif isdefined('form.mesFin') and form.mesFin EQ '12'> selected</cfif>>Diciembre</option>
								  	</select>								
								</td>
							  	<td width="17%" align="right"><strong>A&ntilde;o Final:</strong></td>
							    <td width="26%">
									<cfset valAnoFinMes = 0>
									<cfif isdefined('form.anoFinMes') and form.anoFinMes NEQ ''>
										<cfset valAnoFinMes = form.anoFinMes>
									<cfelse>
										<cfset valAnoFinMes = Year(Now())>										
									</cfif>
									<cf_campoNumerico 
										readonly="false" 
										name="anoFinMes" 
										decimales="0" 
										size="7" 
										maxlength="4" 								
										value="#HTMLEditFormat(valAnoFinMes)#" 
										tabindex="1">									
								</td>
							  </tr>					
							  <tr id="diaIni">
								<td width="21%" align="right" nowrap><strong>D&iacute;a Inicial:</strong></td>
								<td width="36%">
									<cfset valDiaIni = 1>
									<cfif isdefined('form.diaIni') and form.diaIni NEQ ''>
										<cfset valDiaIni = form.diaIni>
									<cfelse>
										<cfset valDiaIni = Day(Now())>															
									</cfif>
									<cf_campoNumerico 
										readonly="false" 
										name="diaIni" 
										decimales="0" 
										size="7" 
										maxlength="4" 								
										value="#HTMLEditFormat(valDiaIni)#" 
										tabindex="1">								
								</td>
							  	<td width="17%" nowrap align="right"><strong>A&ntilde;o Inicial:</strong></td>
							  	<td width="26%">
									<cfset valAnoIniDia = 0>
									<cfif isdefined('form.anoIniDia') and form.anoIniDia NEQ ''>
										<cfset valAnoIniDia = form.anoIniDia>
									<cfelse>
										<cfset valAnoIniDia = Year(Now()) - 1>										
									</cfif>
									<cf_campoNumerico 
										readonly="false" 
										name="anoIniDia" 
										decimales="0" 
										size="7" 
										maxlength="4" 								
										value="#HTMLEditFormat(valAnoIniDia)#" 
										tabindex="1">								
								</td>
							  </tr>												  
							  <tr id="diaFin">
								<td width="21%" align="right"><strong>D&iacute;a Final:</strong></td>
								<td width="36%">
									<cfset valDiaFin = 1>
									<cfif isdefined('form.diaFin') and form.diaFin NEQ ''>
										<cfset valDiaFin = form.diaFin>
									<cfelse>
										<cfset valDiaFin = Day(Now())>											
									</cfif>
									<cf_campoNumerico 
										readonly="false" 
										name="diaFin" 
										decimales="0" 
										size="7" 
										maxlength="4" 								
										value="#HTMLEditFormat(valDiaFin)#" 
										tabindex="1">								
								</td>
							  	<td width="17%" align="right"><strong>A&ntilde;o Final:</strong></td>
							    <td width="26%">
									<cfset valAnoFinDia = 0>
									<cfif isdefined('form.anoFinDia') and form.anoFinDia NEQ ''>
										<cfset valAnoFinDia = form.anoFinDia>
									<cfelse>
										<cfset valAnoFinDia = Year(Now())>															
									</cfif>
									<cf_campoNumerico 
										readonly="false" 
										name="anoFinDia" 
										decimales="0" 
										size="7" 
										maxlength="4" 								
										value="#HTMLEditFormat(valAnoFinDia)#" 
										tabindex="1">								
								</td>
							  </tr>							  			  
							  <tr>
								<td width="21%" align="right"><strong>Nivel:</strong></td>
								<td colspan="3"><input name="rbNivel" type="radio" value="1" <cfif isdefined('form.rbNivel') and form.rbNivel EQ 1> checked<cfelse> checked</cfif>>
								  Agente
								  <input name="rbNivel" type="radio" value="2" <cfif isdefined('form.rbNivel') and form.rbNivel EQ 1> checked</cfif>>
								  Paquete
								  <input name="rbNivel" type="radio" value="3" <cfif isdefined('form.rbNivel') and form.rbNivel EQ 1> checked</cfif>>
								  Contrato</td>
							  </tr>										  
							  <tr>
								<td></td>
							  </tr>
							  <tr>
								<td align="right"><strong>Formato:</strong></td>
								<td colspan="3">
									<select name="formato">
										<option value="1">Flash Paper</option>
										<option value="2">Adobe PDF</option>
										<option value="3">Microsoft Excel</option>
									</select>
								</td>
							  </tr>
							  <tr>
								<td colspan="4" align="center">&nbsp;</td>
							  </tr>
							  <tr>
								<td colspan="4" align="center"><input type="submit" value="Consultar" name="Reporte"></td>
							  </tr>
							</table>
					  </td>
					</tr>
				</table>
			</form>
		</cfoutput>
	<cf_web_portlet_end> 
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	function validarFiltros(f){
		if(f.rbModo[0].checked){	// Por Mes
			if(f.anoIniMes.value == ""){
				alert('Error, el año inicial es requerido.');
				return false;
			}else{
				if(f.anoFinMes.value == ""){
					alert('Error, el año final es requerido.');
					return false;
				}else{
					if(f.mesIni.value > f.mesFin.value){
						alert('Error, el mes inicial no debe ser mayor que el final.');
						return false;						
					}else{
						if(f.anoIniMes.value > f.anoFinMes.value){
							alert('Error, el año inicial no debe ser mayor que el final.');
							return false;							
						}
					}				
				}
			}
		}else{	// Por Dia
			if(f.anoIniDia.value == ""){
				alert('Error, el año inicial es requerido.');
				return false;				
			}else{
				if(f.anoFinDia.value == ""){
					alert('Error, el año final es requerido.');
					return false;					
				}else{
					if(f.rbModo[1].checked){	// Por Mes
						if(f.diaIni.value > f.diaFin.value){
							alert('Error, el día inicial no debe ser mayor que el final.');
							return false;							
						}else{
							if(f.anoIniDia.value > f.anoFinDia.value){
								alert('Error, el año inicial no debe ser mayor que el final.');
								return false;								
							}
						}
					}				
				}
			}
		}
		
		return true;
	}
	
	function prendeFiltros(tipo){
		if(tipo == 1){	// Filtros por Mes
			document.getElementById("mesIni").style.display = '';
			document.getElementById("mesFin").style.display = '';
			document.getElementById("diaIni").style.display = 'none';
			document.getElementById("diaFin").style.display = 'none';
		}else{	// Filtros por Dia
			document.getElementById("diaIni").style.display = '';
			document.getElementById("diaFin").style.display = '';					
			document.getElementById("mesIni").style.display = 'none';
			document.getElementById("mesFin").style.display = 'none';		
		}
	}
	prendeFiltros(1);
	
	
</script>