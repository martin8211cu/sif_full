<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfoutput>
	<cfset modo='ALTA'>
	<cfif isdefined("form.Turno_id") and len(trim(form.Turno_id))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>
		<cfquery name = "rsdata" datasource="#session.DSN#">
			select Turno_id,Codigo_turno, Tdescripcion, HI_turno, HF_turno, ts_rversion
			from   Turnos
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				and Turno_id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Turno_id#">
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="SQLTurnos.cfm"><!----onSubmit="javascript: return funcValidaHoras()">----->
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_Codigo_turno" value="<cfif isdefined('form.filtro_Codigo_turno') and form.filtro_Codigo_turno NEQ ''>#form.filtro_Codigo_turno#</cfif>">
		<input type="hidden" name="filtro_Tdescripcion" value="<cfif isdefined('form.filtro_Tdescripcion') and form.filtro_Tdescripcion NEQ ''>#form.filtro_Tdescripcion#</cfif>">		
			
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="Turno_id" value="#rsdata.Turno_id#">
		</cfif>	
		<table width="100%" border="0">
			<tr>
				<td  width="31%" align="right" nowrap><strong>C&oacute;digo:</strong></td>	
				<td>
					<input tabindex="1" onFocus="this.select();" name="Codigo_turno" type="text" size="10" maxlength="5" value="<cfif modo neq 'ALTA'>#trim(rsdata.Codigo_turno)#</cfif>">
					<input name= "Codigo_turno2" type="hidden" value="<cfif modo neq 'ALTA'>#trim(rsdata.Codigo_turno)#</cfif>">
				</td>	
			</tr>
			<tr>
				<td align="right" nowrap><strong>Descripción: </strong> </td>	
				<td>
					<input tabindex="1" onFocus="this.select();" name="Tdescripcion" type="text" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.Tdescripcion#</cfif>">
				</td>	
			</tr>			
						
			<tr>
				<td align="right" nowrap><strong>Hora inicio:</strong> </td>	
				<td>
					<table>
						<tr>
							<td>
								<select name="HI_turnoH" id="HI_turnoH" tabindex="1">
									<cfloop from="00" to="23" index="i">
										<option value="#i#" <cfif modo neq 'ALTA' and Hour(rsdata.HI_turno) EQ #i#>selected</cfif>>#Right('0'&i,2)#</option>
									</cfloop>	
								</select>								
							</td>	
							<td width="1"><strong>&nbsp;:</strong></td>
							<td>
								<select name="HI_turnoM" id="HI_turnoM" tabindex="1">								
									<cfloop from="00" to="59" index="i">
										<option value="#i#" <cfif modo neq 'ALTA' and Minute(rsdata.HI_turno) EQ #i#>selected</cfif>>#Right('0'&i,2)#</option>
									</cfloop>	
								</select>
							</td>
							<td><strong>GTMS</strong></td>
							<td width="1">&nbsp;</td>
						</tr>
					</table>
				</td>
			</tr>
						
			<tr>
				<td align="right" nowrap><strong>Hora fin: </strong></td>	
				<td>
					<table>
						<tr>
							<td>
								<select name="HF_turnoH" id="HF_turnoH" tabindex="1">
									<cfloop from="0" to="23" index="i">
										<option value="#i#" <cfif modo neq 'ALTA' and Hour(rsdata.HF_turno) EQ #i#>selected</cfif>>#Right('0'&i,2)#</option>
									</cfloop>	
								</select>	
							</td>	
							<td width="1"><strong>&nbsp;:</strong></td>
							<td>
								<select name="HF_turnoM" id="HF_turnoM" tabindex="1">								
									<cfloop from="0" to="59" index="i">
										<option value="#i#" <cfif modo neq 'ALTA' and Minute(rsdata.HF_turno) EQ #i#>selected</cfif>>#Right('0'&i,2)#</option>
									</cfloop>	
								</select>
							</td>
							<td><strong>GTMS</strong></td>
							<td width="1">&nbsp;</td>							
						</tr>
					</table>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<cf_Botones modo="#modo#" tabindex="1">
				</td>	
		   </tr>
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
		</cfinvoke>
           <input type="hidden" name = "ts_rversion" value ="#ts#">
	</cfif>
	
</form> 
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
				
	objForm.Codigo_turno.required = true;
	objForm.Codigo_turno.description="Código";
	
	objForm.HI_turnoH.required = true;
	objForm.HI_turnoH.description="Hora de Inicio";
	
	objForm.HI_turnoM.required = true;
	objForm.HI_turnoM.description="Minutos de Inicio";
		
	objForm.HF_turnoH.required = true;
	objForm.HF_turnoH.description="Hora fin";
	
	objForm.HF_turnoM.required = true;
	objForm.HF_turnoM.description="Minutos fin";
	
	objForm.Tdescripcion.required = true;
	objForm.Tdescripcion.description="Descripción";
			
				
	function deshabilitarValidacion(){
		objForm.Codigo_turno.required = false;
		objForm.Tdescripcion.required = false;
		objForm.HI_turnoH.required = false;
		objForm.HI_turnoM.required = false;
		objForm.HF_turnoH.required = false;
		objForm.HF_turnoM.required = false;
	}
	document.form1.Codigo_turno.focus();
</script>
</cfoutput>


<!----
	//Función para validar que la hora de inicio no sea mayor que la de finalización del turno
	function funcValidaHoras(){				
		if (parseInt(document.form1.HI_turnoH.value) > parseInt(document.form1.HF_turnoH.value)){
			alert('La hora de inicio no puede ser mayor a la de salida');
			document.form1.HI_turnoH.value = ''
			return false;
		}
		else{
			if (parseInt(document.form1.HI_turnoM.value) > parseInt(document.form1.HF_turnoM.value)){
				alert('La hora de inicio no puede ser mayor a la de salida')
				document.form1.HI_turnoM.value = ''
				return false;
			}
			else{				
				 return true;
			}
		}							
	}	
------>

