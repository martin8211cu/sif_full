<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
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
			select Codigo_turno, Tdescripcion, HI_turno, HF_turno, ts_rversion
			from   Turnos
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				and Codigo_turno = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Codigo_turno#">
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="SQLTurnos.cfm">
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="Codigo_turno" value="#rsdata.Codigo_turno#">
		</cfif>	
		<table width="100%" border="0">
			<tr>
				<td  width="31%" align="right" nowrap><strong>C&oacute;digo:</strong></td>	
				<td>
					<input name="Codigo_turno" type="text" size="10" maxlength="5" value="<cfif modo neq 'ALTA'>#trim(rsdata.Codigo_turno)#</cfif>">
					<input name= "Codigo_turno2" type="hidden" value="<cfif modo neq 'ALTA'>#trim(rsdata.Codigo_turno)#</cfif>">
				</td>	
			</tr>
			<tr>
				<td align="right" nowrap><strong>Descripción: </strong> </td>	
				<td>
					<input name="Tdescripcion" type="text" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.Tdescripcion#</cfif>">
				</td>	
			</tr>			
			
			<tr>
				<td align="right" nowrap><strong>Hora inicio</strong> </td>	
				<td>
					<table>
						<tr>
							<td width="1">&nbsp;</td>
							<td align="right" nowrap><strong>Horas:</strong></td>	
							<td>
								<input name="HI_turnoH" type="text" size="5" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.HI_turno#</cfif>">
							</td>	
							<td align="right" nowrap><strong>Minutos:</strong></td>	
							<td>
								<input name="HI_turnoM" type="text" size="5" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.HI_turno#</cfif>">
							</td>
							<td align="right" nowrap><strong>Segundos:</strong></td>	
							<td>
								<input name="HI_turnoS" type="text" size="5" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.HI_turno#</cfif>">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
			<!---- Crear una variable que contiene la hora en formato dateTime  ---->
			<!----<CFSET yourDate = CreateDateTime(#Year(now())#, #Month(now())#, #Day(now())#,form.hour, form.minute, form.second)>---->
			<input name="HI_turno" type="hidden" value="">
			
			<tr>
				<td align="right" nowrap><strong>Hora fin</strong> </td>	
				<td>
					<table>
						<tr>
							<td width="1">&nbsp;</td>
							<td align="right" nowrap><strong>Horas:</strong></td>	
							<td>
								<input name="HI_turnoH" type="text" size="5" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.HI_turno#</cfif>">
							</td>	
							<td align="right" nowrap><strong>Minutos:</strong></td>	
							<td>
								<input name="HI_turnoM" type="text" size="5" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.HI_turno#</cfif>">
							</td>
							<td align="right" nowrap><strong>Segundos:</strong></td>	
							<td>
								<input name="HI_turnoS" type="text" size="5" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.HI_turno#</cfif>">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			
			<input name="HF_turno" type="hidden" value="">
			
			<tr>
				<td colspan="2" align="center">
					<cfinclude template="../../portlets/pBotones.cfm">
					<!---<input name="btnRegresar" type="button" value="Regresar" onClick="javascript:location.href='Socios.cfm'" >--->
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
	objForm.HI_turnoM.description="Hora de Inicio";
	
	objForm.HI_turnoS.required = true;
	objForm.HI_turnoS.description="Hora de Inicio";
	
	objForm.HF_turnoH.required = true;
	objForm.HF_turnoH.description="Hora fin";
	
	objForm.HF_turnoM.required = true;
	objForm.HF_turnoM.description="Hora fin";
	
	objForm.HF_turnoS.required = true;
	objForm.HF_turnoS.description="Hora fin";
	
	objForm.Tdescripcion.required = true;
	objForm.Tdescripcion.description="Descripción";
			
				
	function deshabilitarValidacion(){
		objForm.Codigo_turno.required = false;
		objForm.Tdescripcion.required = false;
		objForm.HI_turnoH.required = false;
		objForm.HI_turnoM.required = false;
		objForm.HI_turnoS.required = false;
		objForm.HF_turnoH.required = false;
		objForm.HF_turnoM.required = false;
		objForm.HF_turnoS.required = false;
	}
	
</script>
</cfoutput>
			


