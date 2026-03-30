<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>
	
	<cfif isdefined('url.modo')> 
		<cfset modo=#url.modo#>
	<cfelse>
		<cfset modo='ALTA'>
	</cfif>	
	
	<cfif isdefined("form.TCHid") and len(trim(form.TCHid))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA' and isdefined("form.TCHid") and len(trim(form.TCHid))>
		<cfquery name = "rsData" datasource="#session.DSN#">
			select 	TCHid,Ecodigo,TCHcodigo,TCHdescripcion,ts_rversion
            from    HtiposcambioConversionE   
            where   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#">
            and     TCHid   = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#form.TCHid#">
		</cfquery>
        
        <cfquery name = "rsdataDContable" datasource="#session.DSN#">
			select 	TCHid,Ecodigo,Speriodo,Smes,Mcodigo,TCHvalor,BMfecha
            from    HtiposcambioConversionD   
            where   Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#">
            and     TCHid    = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#form.TCHid#">
            and     Speriodo = #form.Speriodo#
            and     Smes     = #form.Smes#
			and 	TCHtipo = 0			
		</cfquery>
		<cfquery name = "rsdataDPresupuesto" datasource="#session.DSN#">
			select 	TCHid,Ecodigo,Speriodo,Smes,Mcodigo,TCHvalor,BMfecha
            from    HtiposcambioConversionD   
            where   Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#">
            and     TCHid    = <cfqueryparam cfsqltype="cf_sql_numeric" value = "#form.TCHid#">
            and     Speriodo = #form.Speriodo#
            and     Smes     = #form.Smes#
			and 	TCHtipo = 1
		</cfquery>
	</cfif>
    
    <cfquery name="rsMonedas" datasource="#Session.DSN#">
        select Mcodigo, Mnombre #_Cat# ' (' #_Cat# Miso4217 #_Cat# ') ' as Mnombre
         from Monedas
        where Ecodigo = #Session.Ecodigo#
        order by Miso4217
    </cfquery>
    
    <cfquery name="rsMonedaConversion" datasource="#Session.DSN#">
        select Mcodigo, {fn concat ( {fn concat ( {fn concat ( Mnombre, ' (' )}, Miso4217)}, ') ')} as Mnombre
        from Monedas
        where Ecodigo = #Session.Ecodigo#
        and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
    </cfquery>
	
	<cfif isdefined('LvarTCHpresupuesto')>
		<cfset action= "../../cg/operacion/TCHistoricos-SQL.cfm">
	<cfelse>
		<cfset action= "TCHistoricos-SQL.cfm">
	</cfif>
        
	<form name="form1" method="post" action="#action#">
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="TCHid" value="#form.TCHid#">
		</cfif>	
        <input type="hidden" name="SperiodoD" value="#form.Speriodo#">
        <input type="hidden" name="SmesD" value="#form.Smes#">
        <input type="hidden" name="McodigoD" value="#form.Mcodigo#">
		<cfif isdefined('LvarTCHpresupuesto')>
			 <input type="hidden" name="LvarTCHpresupuesto" value="#LvarTCHpresupuesto#">
		</cfif>
			
		<cfif IsDefined('url.tab')>
			<cfset form.tab = url.tab>
		<cfelse>
			<cfparam name="form.tab" default="0">
		</cfif>
		<input type="hidden" name="TCHtipo" value="#form.tab#">
					
		<table width="98%" border="0" cellpadding="0" cellspacing="2%">			
			<tr>
				<td width="24%" align="right" nowrap><strong>C&oacute;digo: </strong> </td>	
			  	<td colspan="3">
					<input name="TCHcodigo" type="text" size="10" maxlength="4" value="<cfif modo neq 'ALTA'>#rsData.TCHcodigo#</cfif>" alt="Codigo"> 	
			    </td>	
			</tr>
            <tr>
				<td width="24%" align="right" nowrap><strong>Descripci&oacute;n: </strong> </td>	
				<td colspan="5">
					<input name="TCHdescripcion" type="text" size="50" maxlength="30" value="<cfif modo neq 'ALTA'>#rsData.TCHdescripcion#</cfif>">
				</td>	
			</tr>
            
            <tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="6" align="center">
					<cfinclude template="../../portlets/pBotones.cfm">
				</td>	
		   </tr>
           <tr><td>&nbsp;</td></tr>
           <tr><td>&nbsp;</td></tr>
           <tr><td>&nbsp;</td></tr>
           <cfif modo NEQ 'ALTA'>
		    <cf_tabs width="100%" onclick="tab_set_current_param">
			  	<cf_tab text="Consolidaci&oacute;n Contable" id="0" selected="#form.tab is '0'#">
					<cfif form.tab eq 0>
						<table>
						   <tr>
						   		<td colspan="6">
							   		<table  width="100%" cellspacing="0">
										<tr>
											<td align="center" class="tituloListas">Lista de Monedas y Tipos de Cambio:</td>
										</tr>
							   		</table>
				   				</td>
							</tr>	
						   <tr bgcolor="##CCCCCC">
								<td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Moneda Origen</strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Moneda Conversi&oacute;n</strong>
								</td>
								<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
									<strong>Tipo de Cambio</strong>
								</td>	
				   		   </tr>
						   <cfloop query="rsMonedas">
							   <tr>
								   <td align="center" nowrap="nowrap">
										#rsMonedas.Mnombre#
								   </td>
								   <td align="center">
										#rsMonedaConversion.Mnombre#
								   </td>
											  <td align="center">
								<input name="TCambio_#rsMonedas.Mcodigo#" id="val" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);" onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000
								<cfelseif rsdataDContable.recordcount gt 0><cfloop query="rsdataDContable"><cfif rsdataDContable.Mcodigo eq rsMonedas.Mcodigo>#rsdataDContable.TCHvalor#</cfif></cfloop><cfelse>0.00000</cfif>" <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo> disabled</cfif>>
							   </td>
							   </tr>
				   		</cfloop>
				  </table> 
				  </cfif>
				 </cf_tab>  
				 <cf_tab text="Consolidaci&oacute;n Presupuestal" id="1" selected="#form.tab is '1'#">
				 <cfif form.tab eq 1>
				 	<table>
 					   <tr>
					   		<td colspan="6">
					   			<table  width="100%" cellspacing="0">
									<tr>
										<td align="center" class="tituloListas">Lista de Monedas y Tipos de Cambio:</td>
									</tr>
					   			</table>
				   			</td>
						</tr>	
				   
				  	  <tr bgcolor="##CCCCCC">
							<td align="center" style="border-left: 1px solid black; border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Moneda Origen</strong>
							</td>
							<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Moneda Conversi&oacute;n</strong>
							</td>
							<td align="center" style="border-bottom: 1px solid black; border-right: 1px solid black; border-top: 1px solid black;">
								<strong>Tipo de Cambio</strong>
							</td>	
	    			  </tr>
					  <cfloop query="rsMonedas">
						   <tr>
							   <td align="center" nowrap="nowrap">
									#rsMonedas.Mnombre#
							   </td>
							   <td align="center">
									#rsMonedaConversion.Mnombre#
							   </td>
							     <td align="center">
								<input name="TCambio_#rsMonedas.Mcodigo#" id="val" type="text" size="17" maxlength="17"  onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,10);" onKeyUp="if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo>1.00000
								<cfelseif rsdataDPresupuesto.recordcount gt 0><cfloop query="rsdataDPresupuesto"><cfif rsdataDPresupuesto.Mcodigo eq rsMonedas.Mcodigo>#rsdataDPresupuesto.TCHvalor#</cfif></cfloop><cfelse>0.00000</cfif>" <cfif rsMonedas.Mcodigo EQ rsMonedaConversion.Mcodigo> disabled</cfif>>
							   </td>
						   </tr>
					  </cfloop>				 
				   </table>
				   </cfif>
				 </cf_tab>
			</cf_tabs>	 
           	   <cf_botones modo="ALTA" sufijo="TC" values="Modificar,Limpiar" names="Cambio,Limpiar">
           </cfif>
			  <tr>
				<td align="center" colspan="5">&nbsp;</td>
			  </tr>
              
	</table>
	<cfif modo NEQ "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsData.ts_rversion#" returnvariable="ts">
		</cfinvoke>
           <input type="hidden" name = "ts_rversion" value ="#ts#">
	</cfif>
</form> 
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">					
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	//Validaciones de los campos requeridos	
	objForm.TCHcodigo.required = true;
	objForm.TCHcodigo.description="Codigo";
	
	objForm.TCHdescripcion.required = true;
	objForm.TCHdescripcion.description="Descripción";
									
	function __isNotCero() {
				if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
					this.error = "El campo " + this.description + " no puede ser cero!";
				}
			}
	
	_addValidator("isNotCero", __isNotCero);

  <cfoutput query="rsMonedas">
	objForm.TCambio_#rsMonedas.Mcodigo#.required = true;
	objForm.TCambio_#rsMonedas.Mcodigo#.description = "Tipo de Cambio para #rsMonedas.Mnombre#";
	objForm.TCambio_#rsMonedas.Mcodigo#.validateNotCero();
  </cfoutput>
  
  function deshabilitarValidacion(){
		objForm.TCHcodigo.required = false;
		objForm.TCHdescripcion.required = false;
  }
  function tab_set_current_param (n){
		location.href='TCHistoricos.cfm?Speriodo=<cfoutput>#form.Speriodo#</cfoutput>&Smes=<cfoutput>#form.Smes#</cfoutput>&Mcodigo=<cfoutput>#form.Mcodigo#</cfoutput>&modo=<cfoutput>#modo#</cfoutput><cfif isdefined('form.TCHid')>&TCHid=<cfoutput>#form.TCHid#</cfoutput></cfif>&tab='+escape(n);
	}
</script>