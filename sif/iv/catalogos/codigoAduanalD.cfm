
<cfif dmodo EQ "CAMBIO">
	<cfquery name="rsImpuestos" datasource="#Session.DSN#">
		select 	Icodigo,
				Idescripcion
		from	Impuestos
		where  	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
	</cfquery>
	
	<cfquery name="rsDetalle" datasource="#Session.DSN#">
		select 	a.Ppaisori,
				a.Icodigo,
				a.porcCIF,
				a.porcFOB,
				a.porcSegLoc,
				a.porcFletLoc,
				a.porcAgeAdu,
				a.ts_rversion
		from ImpuestosCodigoAduanal a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAid#">
		  and a.Ppaisori = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Ppaisori)#">
	</cfquery>
	
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" 
		artimestamp="#rsDetalle.ts_rversion#" 
		returnvariable="tsD">
	</cfinvoke>
</cfif>

<cfquery name="rsPaises" datasource="#Session.DSN#">
	select Ppais, Pnombre
	from Pais 
	<cfif dmodo EQ 'ALTA'>
		where Ppais not in (
			Select Ppaisori
			from ImpuestosCodigoAduanal
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAid#">
			)
	<cfelse>
		where Ppais not in (
			Select Ppaisori
			from ImpuestosCodigoAduanal
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CAid#">
			)	
		union
			Select Ppais, Pnombre
			from Pais 
			where Ppais=<cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.Ppaisori)#">
	 </cfif>
	order by Pnombre
</cfquery>

<cfoutput>
   <cfif dmodo neq 'ALTA'>
	   <input type="hidden" name="ts_rversionD" value="#tsD#">
	   <input type="hidden" name="Ppais" value="#rsDetalle.Ppaisori#">
   </cfif>
   <table width="100%"  border="0" cellspacing="1" cellpadding="1">
     <tr>
       <td><strong>% Gastos y Fletes CIF</strong></td>
       <td><strong>% Gastos y Fletes FOB</strong></td>
       <td><strong>% Seguros Locales</strong></td>
     </tr>
     <tr>
       <td><input tabindex="1" type="text" name="DporcCIF" size="10" maxlength="10" value="<cfif (dmodo EQ "CAMBIO")>#LSCurrencyFormat(rsDetalle.porcCIF,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Gastos y Fletes CIF"></td>
       <td><input tabindex="1" type="text"  name="DporcFOB" size="10" maxlength="10" value="<cfif (dmodo EQ "CAMBIO")>#LSCurrencyFormat(rsDetalle.porcFOB,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Gastos y Fletes FOB"></td>
       <td><input tabindex="1" type="text" name="DporcSegLoc" size="10" maxlength="10" value="<cfif (dmodo EQ "CAMBIO")>#LSCurrencyFormat(rsDetalle.porcSegLoc,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Seguros Locales"></td>
     </tr>
     <tr>
       <td><strong>% Fletes Locales</strong></td>
       <td><strong>% Gastos Agencia Aduanal</strong></td>
       <td>&nbsp;</td>
     </tr>
     <tr>
       <td><input tabindex="1" type="text" name="DporcFletLoc" size="10" maxlength="10" value="<cfif (dmodo EQ "CAMBIO")>#LSCurrencyFormat(rsDetalle.porcFletLoc,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % de Fletes Locales"></td>
       <td><input tabindex="1" type="text" name="DporcAgeAdu" size="10" maxlength="10" value="<cfif (dmodo EQ "CAMBIO")>#LSCurrencyFormat(rsDetalle.porcAgeAdu,'none')#<cfelse></cfif>" style="text-align: right;" onBlur="javascript:fm(this,2); porcentaje(this);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" alt="El campo % Gastos de Agencia Aduanal"></td>
       <td>&nbsp;</td>
     </tr>
     <tr>
       <td><strong>Impuestos</strong></td>
       <td><strong>País</strong></td>
       <td>&nbsp;</td>
     </tr>
     <tr>
       <td><select  name="DLImpuestos" id="select4" tabindex="1">
         <option value="">- No especificado -</option>
         <cfloop query="rsImpuestos">
           <option value="#rsImpuestos.Icodigo#" <cfif dmodo NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsDetalle.Icodigo>selected</cfif>>#HTMLEditFormat(rsImpuestos.Idescripcion)#</option>
         </cfloop>
       </select></td>
       <td><select  name="LPaises" id="select3" <cfif dmodo NEQ 'ALTA'> disabled</cfif> tabindex="1">
         <option value="">- No especificado -</option>
         <cfloop query="rsPaises">
           <option value="#rsPaises.Ppais#" <cfif dmodo NEQ 'ALTA' and rsPaises.Ppais EQ rsDetalle.Ppaisori>selected</cfif>>#HTMLEditFormat(rsPaises.Pnombre)#</option>
         </cfloop>
       </select></td>
       <td>&nbsp;</td>
     </tr>
   </table>
</cfoutput>
