<cfif modo EQ "CAMBIO">
	<!--- Consulta del encabezado de la Orden ---> 
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select	CAcodigo,
				Icodigo,
				CAdescripcion,
				porcCIF,
				porcFOB,
				porcSegLoc,
				porcFletLoc,
				porcAgeAdu,
				ts_rversion
		from CodigoAduanal
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAid#">
	</cfquery>
	
	<cfif modo neq "ALTA">
		<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsEncabezado.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversionE" value="<cfoutput>#ts#</cfoutput>">
	</cfif>
</cfif>
<!---Pintado del form--->
<cfoutput>
  <table width="100%" border="0" cellspacing="1" cellpadding="1">
    <tr>
      <td width="27%"><strong>C&oacute;digo</strong></td>
      <td width="39%"><strong>Descripci&oacute;n</strong></td>
      <td width="34%">&nbsp;</td>
    </tr>
    <tr>
      <td>
		<input tabindex="1" onFocus="this.select()" type="text" name="CAcodigo" size="20"  onBlur="javascript: validaExiste(this);" value="<cfif (modo EQ "CAMBIO")>#trim(rsEncabezado.CAcodigo)#<cfelse></cfif>">
		<cfif modo neq 'ALTA'><input type="hidden" name="_CAcodigo" value="#trim(rsEncabezado.CAcodigo)#"></cfif>	  
	  </td>
      <td colspan="2"><input tabindex="1" onFocus="this.select()" type="text" name="CAdescripcion" size="70" maxlength="120" value="<cfif (modo EQ "CAMBIO")>#trim(rsEncabezado.CAdescripcion)#<cfelse></cfif>"></td>
    </tr>
    <tr>
      <td><strong>% Gastos y Fletes CIF</strong></td>
      <td><strong>% Gastos y Fletes FOB</strong></td>
      <td><strong>% Seguros Locales</strong></td>
    </tr>
    <tr>
      <td><input tabindex="1" type="text" name="porcCIF" size="10" maxlength="5" value="<cfif (modo EQ "CAMBIO")>#LSCurrencyFormat(rsEncabezado.porcCIF,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Gastos y Fletes CIF"></td>
      <td><input tabindex="1" type="text" name="porcFOB" size="10" maxlength="5" value="<cfif (modo EQ "CAMBIO")>#LSCurrencyFormat(rsEncabezado.porcFOB,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Gastos y Fletes FOB"></td>
      <td><input tabindex="1" type="text" name="porcSegLoc" size="10" maxlength="5" value="<cfif (modo EQ "CAMBIO")>#LSCurrencyFormat(rsEncabezado.porcSegLoc,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2);porcentaje(this); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Seguros Locales"></td>
    </tr>
    <tr>
      <td><strong>% Fletes Locales</strong></td>
      <td><strong>% Gastos Agencia Aduanal</strong></td>
      <td><strong>Impuestos</strong></td>
    </tr>
    <tr>
      <td><input tabindex="1" type="text" name="porcFletLoc" size="10" maxlength="5" value="<cfif (modo EQ "CAMBIO")>#LSCurrencyFormat(rsEncabezado.porcFletLoc,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2);porcentaje(this); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Fletes Locales"></td>
      <td><input tabindex="1" type="text" name="porcAgeAdu" size="10" maxlength="5" value="<cfif (modo EQ "CAMBIO")>#LSCurrencyFormat(rsEncabezado.porcAgeAdu,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Gastos de Agencia Aduanal"></td>
      <td>
        <cfquery name="rsImpuestos" datasource="#Session.DSN#">
		  select Icodigo, Idescripcion 
		  from Impuestos 
		  where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>
	  
	  	<select  name="LImpuestos" id="LImpuestos" tabindex="1">
			<option value="">- No especificado -</option>
			<cfloop query="rsImpuestos">
			  <option value="#rsImpuestos.Icodigo#" <cfif modo NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsEncabezado.Icodigo>selected</cfif>>#HTMLEditFormat(rsImpuestos.Idescripcion)#</option>
			</cfloop>
      	</select>
	  </td>
    </tr>
  </table>
</cfoutput>