<cfset modo = "ALTA">
  <cfif isdefined("form.CMTPCodigo") and len(trim(form.CMTPCodigo)) or  isdefined("form.CMTPid") and len(trim(form.CMTPid))>  
	    <cfset modo = "CAMBIO">
  </cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
	   select CMTPid,CMTPCodigo,CMTPDescripcion,CMTPMontoIni,CMTPMontoFin,Mcodigo, ts_rversion,TGidC,TGidP
		 from CMTipoProceso
		where Ecodigo    = #session.Ecodigo#
		 <cfif isdefined("form.CMTPCodigo")> and CMTPCodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMTPCodigo)#"></cfif>
		 <cfif isdefined("form.CMTPid")> and CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CMTPid)#"></cfif>
	</cfquery>
</cfif>

	<cfquery name="rsGarantiaP" datasource="#session.dsn#">
		select TGid,TGcodigo,TGporcentaje,
			TGdescripcion
		from TiposGarantia
		where TGtipo = 1
	</cfquery>
	
	<cfquery name="rsGarantiaC" datasource="#session.dsn#">
		select TGid,TGcodigo,TGporcentaje,
			TGdescripcion
		from TiposGarantia
		where TGtipo = 2
	</cfquery>


<form style="margin:0;" name="form1" action="TiposProcesosCompras-sql.cfm" method="post">
    <!---Id--->
	<cfif modo neq 'ALTA'>
	 <input type="hidden" name="CMTPid" value="<cfoutput>#data.CMTPid#</cfoutput>"/> 
	</cfif>

	<!---Codigo--->
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong>Código: </strong></td>
			<td nowrap>
				<input type="text" name="CMTPCodigo" size="8" maxlength="15" value="<cfif modo neq 'ALTA'><cfoutput>#data.CMTPCodigo#</cfoutput></cfif>" onfocus="this.select();" <cfif modo neq 'ALTA'>readonly</cfif> >
			</td>
		</tr>
	<!---Descripción--->	
		<tr>
			<td nowrap align="right"><strong>Descripción: </strong></td>
			<td nowrap>
				<input type="text" name="CMTPDescripcion" size="50" maxlength="80" value="<cfif modo neq 'ALTA'><cfoutput>#data.CMTPDescripcion#</cfoutput></cfif>" onfocus="this.select();">
			</td>
		</tr>
	<!-----Moneda----->
	    <tr>
			<td nowrap align="right">
				<strong>Moneda:</strong>			
			</td>
			<td nowrap>
				<cfif  modo NEQ 'ALTA' and data.Mcodigo neq '' >
					<cfquery name="rsMoneda" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						from Monedas
						where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#">
						and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cfset LvarMnombreSP = rsMoneda.Mnombre>					
					<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" tabindex="1" valueTC="#data.Mcodigo#">
				<cfelse>
					<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1">
				</cfif>   
			</td>
		</tr> 	
<!--- (ESTA COMENTADO PORQ AUN NO SE DESARROLLA, TAMBIEN ESTA PENDIENTE LA MONEDA. Requerimiento de BN-Valores)--->
		<tr>
			<td nowrap align="right"><strong>Monto Inicial: </strong></td>
			<td nowrap>
			<!---	<input type="text" name="CMTPMontoIni" size="20" maxlength="20" value="<cfif modo neq 'ALTA'><cfoutput>#LSNumberFormat(data.CMTPMontoIni,',9.00')#</cfoutput><cfelse>0.00</cfif>">--->
			<cfif modo neq 'ALTA'>
			     <cfset LvarValue= data.CMTPMontoIni>
			<cfelse>
				 <cfset LvarValue= 0.00>
			</cfif>
			    <cf_inputNumber name="CMTPMontoIni"  value="#LvarValue#" enteros="10" decimales="2" negativos="false" comas="yes">
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Monto Final: </strong></td>
			<td nowrap>
				<!---<input type="text" name="CMTPMontoFin" size="20" maxlength="20" value="<cfif modo neq 'ALTA'><cfoutput>#LSNumberFormat(data.CMTPMontoFin,',9.00')#</cfoutput><cfelse>0.00</cfif>">--->
			<cfif modo neq 'ALTA'>
			     <cfset LvarValue2= data.CMTPMontoFin>
			<cfelse>
				 <cfset LvarValue2= 0.00>
			</cfif>
			    <cf_inputNumber name="CMTPMontoFin"  value="#LvarValue2#" enteros="10" decimales="2" negativos="false" comas="yes">
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right"><strong>Garantía - Cumplimiento:</strong></td>                        
			<td align="left">
				<select name="TipoC" tabindex="1" id="TipoC">
				<option value="">-Seleccione-</option>
					<cfoutput query="rsGarantiaC">
					<option value="#rsGarantiaC.TGid#" <cfif modo neq 'ALTA' and  trim(rsGarantiaC.TGid) eq trim(data.TGidC)> selected </cfif>>#rsGarantiaC.TGdescripcion# - #rsGarantiaC.TGporcentaje#</option>
					</cfoutput>
				 </select>
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right"><strong>Garantía - Participación:</strong></td>                        
			<td align="left">
				<select name="TipoP" tabindex="1" id="TipoP">
					<option value="">-Seleccione-</option>
					<cfoutput query="rsGarantiaP">
					<option value="#rsGarantiaP.TGid#" <cfif modo neq 'ALTA' and trim(rsGarantiaP.TGid) eq trim(data.TGidP)> selected </cfif> >#rsGarantiaP.TGdescripcion# - #rsGarantiaP.TGporcentaje#</option>
					</cfoutput>
				 </select>
			</td>
		</tr>
		
		
	<!--- Portles de Botones --->
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfinclude template="../../portlets/pBotones.cfm">		
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfoutput>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		</cfoutput>
	</cfif>
</form>
<cf_qforms  form="form1" objForm="objForm1">
	    <cf_qformsRequiredField name="CMTPCodigo" description="Codigo" form="form1">
		<cf_qformsRequiredField name="CMTPDescripcion" description="Descripción"  form="form1">    
</cf_qforms>

