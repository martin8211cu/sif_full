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
	<cfset modo='ALTA'>
	<cfif isdefined("form.CPDCid") and len(trim(form.CPDCid))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>
		<cfquery name = "rsdata" datasource="#session.DSN#">
			select CPDCid, CPDCcodigo, CPDCdescripcion, 
            	   CPDCactivo, CPDCporcTotal, ts_rversion
			from   CPDistribucionCostos
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				and CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="TipoDistribucionSQL.cfm">
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="CPDCid" value="#rsdata.CPDCid#">
		</cfif>	
		<table width="98%" border="0" cellpadding="0" cellspacing="2%">			
			<tr>
				<td width="24%" align="right" nowrap><strong>Codigo: </strong> </td>	
			  	<td colspan="3">
					<input name="CPDCcodigo" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#rsdata.CPDCcodigo#</cfif>" alt="Codigo"> 	
			    </td>	
			</tr>
            <tr>
				<td width="24%" align="right" nowrap><strong>Descripción: </strong> </td>	
				<td colspan="5">
					<input name="CPDCdescripcion" type="text" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.CPDCdescripcion#</cfif>">
				</td>	
			</tr>
            <tr>
				<td  align="right" nowrap>
					<strong><label for="Activo">Activo: </label></strong>
				</td>		
				<td>					
					<input type="checkbox" name="Activo" <cfif modo neq 'ALTA' and rsdata.CPDCactivo EQ 1> checked </cfif>>
				</td>	
			</tr>
			<tr>
				<td width="24%" align="right" nowrap><strong>Por Distribuir: </strong> </td>	
				<td colspan="5">
					<input name="CPDCporcDis" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#100 - rsdata.CPDCporcTotal#<cfelse>100</cfif>" 
						onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
						alt="Porcentaje Distribuir" disabled> %
                	<input type="hidden" name = "CPDCporcDis" value ="<cfif modo neq 'ALTA'>#rsdata.CPDCporcTotal#<cfelse>0</cfif>">
				</td>	
			</tr>
            <tr>
				<td width="24%" align="right" nowrap><strong>Distribuido: </strong> </td>	
				<td colspan="5">
					<input name="CPDCporcTotal" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#rsdata.CPDCporcTotal#</cfif>" 
						onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
						alt="Porcentaje Distribuir" disabled> %
				</td>	
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="6" align="center">
					<cfinclude template="../../portlets/pBotones.cfm">
				</td>	
		   </tr>
           <tr><td>&nbsp;</td></tr>
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
	
	// Funcion para validar que el porcentaje digitado no sea mayor a100
	function _mayor(){	
		if ( new Number(qf(this.value)) > 100 ){
			this.error = 'El campo no puede ser mayor a 100';
			this.value = '';
		}
	}
	
	// Validaciones para los campos de % no sean mayores a 100 		
	_addValidator("ismayor", _mayor);
	
	objForm.CPDCporcDis.validatemayor();	
	objForm.CPDCporcDis.validate = true;
	
	//Validaciones de los campos requeridos	
	objForm.CPDCcodigo.required = true;
	objForm.CPDCcodigo.description="Codigo";
	
	objForm.CPDCdescripcion.required = true;
	objForm.CPDCdescripcion.description="Descripción";
									
	function deshabilitarValidacion(){
		objForm.CPDCcodigo.required = false;
		objForm.CPDCdescripcion.required = false;
	}
</script>
</cfoutput>
			


