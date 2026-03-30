<cfif modo neq 'ALTA' and isdefined('form.PTid') and len(trim('form.PTid'))>
	<cfquery name="rsSelectDatosTurnos" datasource="#session.dsn#">
		select PTid, PTcodigo, PThoraini, PThorafin, ts_rversion
		from PTurnos
		where PTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PTid#"> and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset PTid=rsSelectDatosTurnos.PTid>
	<cfset PTcodigo=rsSelectDatosTurnos.PTcodigo>
	<cfset PThoraini=rsSelectDatosTurnos.PThoraini>
	<cfset PThorafin=rsSelectDatosTurnos.PThorafin>
<cfelse>
	<cfset PTid="">
	<cfset PTcodigo="">
	<cfset PThoraini="0">
	<cfset PThorafin="0">
</cfif>
<cfform action="turnos_SQL.cfm" method="post" name="form1" onsubmit="return validarHoras();">
	<table align="center">
		<tr> 
      		<td nowrap align="right">C&oacute;digo Turnos:</td>
      		<td>
				<cfinput id="codTurno" name="codTurno" type="text" maxlength="28" width="28" value="#PTcodigo#">
			</td>
    	</tr>
		<tr> 
      		<td nowrap align="right">Hora Inicio:</td>
      		<td>
				<cf_hora name="hInicial" form="form1" value="#PThoraini#">
			</td>
	  </tr>
		<tr> 
      		<td nowrap align="right">Hora Final:</td>
			<td>
				<cf_hora name="hFinal" form="form1" value="#PThorafin#">
			</td>
		</tr>
		<tr> 
      		<td colspan="2">
				<cf_botones modo="#modo#">
			</td>
    	</tr>
		<tr> 
      		<td colspan="1">
				<input type="hidden" id="modo" name="modo" value="<cfoutput>#modo#</cfoutput>" />
				<input type="hidden" id="Ecodigo" name="Ecodigo" value="<cfoutput>#session.Ecodigo#</cfoutput>" />
				<input type="hidden" id="MBUsucodigo" name="MBUsucodigo" value="<cfoutput>#session.usucodigo#</cfoutput>" />
				<cfset ts = "">
				<cfif modo neq "ALTA">
				<input type="hidden" id="PTid" name="PTid" value="<cfoutput>#form.PTid#</cfoutput>" />
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosTurnos.ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</td>
    	</tr>
  	</table>
</cfform>
<cfoutput>
<cf_qforms form='form1'>
<script language="javascript1.2" type="text/javascript">
	
	objForm.codTurno.description = "#JSStringFormat('Código del Turno')#";
	objForm.hInicial.description = "#JSStringFormat('Hora Inicial')#";
	objForm.hFinal.description = "#JSStringFormat('Hora Final')#";
	objForm.codTurno.required = <cfoutput>#iif(modo neq 'ALTA',true,false)#</cfoutput>;
	objForm.codTurno.required= true;
	objForm.hInicial.required= true;
	objForm.hFinal.required = true;
	
</script>
</cfoutput>