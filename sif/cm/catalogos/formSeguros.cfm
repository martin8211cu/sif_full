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
	<cfif isdefined("form.CMSid") and len(trim(form.CMSid))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>
		<cfquery name = "rsdata" datasource="#session.DSN#">
			select CMSid, CMSdescripcion, Costos, Fletes, Seguros, Gastos, Impuestos,
			       ESporcadic, ESporcmult, ts_rversion
			from   CMSeguros
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMSid#">
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="SQLSeguros.cfm">
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="CMSid" value="#rsdata.CMSid#">
		</cfif>	
		<table width="98%" border="0" cellpadding="0" cellspacing="2%">			
			<tr>
				<td width="24%" align="right" nowrap><strong>Descripción: </strong> </td>	
				<td colspan="5">
					<input name="CMSdescripcion" type="text" size="50" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.CMSdescripcion#</cfif>">
				</td>	
			</tr>
			<tr>
				<td width="24%" align="right" nowrap><strong>Porcentaje Adicional: </strong> </td>	
			  <td colspan="3">
					<input name="ESporcadic" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#rsdata.ESporcadic#</cfif>" 
						onBlur="javascript:fm(this,2)"  onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
						alt="Porcentaje Adicional"> %	
			    </td>	
			</tr>
			<tr>
				<td width="24%" align="right" nowrap><strong>Porcentaje Multip.: </strong> </td>	
				<td colspan="5">
					<input name="ESporcmult" type="text" size="10" maxlength="10" value="<cfif modo neq 'ALTA'>#rsdata.ESporcmult#</cfif>" 
						onBlur="javascript:fm(this,4)"  onFocus="javascript:this.value=qf(this); this.select();"  
						onKeyUp="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
						alt="Porcentaje Multiplicador"> %
				</td>	
			</tr>
			<tr>
				<td  align="right" nowrap>
					<strong><label for="Costos">Costos</label></strong>
				</td>		
				<td width="3%">					
					<input type="checkbox" name="Costos" <cfif modo neq 'ALTA' and rsdata.Costos EQ 1> checked </cfif>>					
				</td>
				<td width="12%"  align="right" nowrap>
					<strong><label for="Costos">Fletes</label></strong>
				</td>		
				<td width="5%">					
					<input type="checkbox" name="Fletes" <cfif modo neq 'ALTA' and rsdata.Fletes EQ 1> checked </cfif>>					
				</td>									
			</tr>
			<tr>
				<td  align="right" nowrap>
					<strong><label for="Costos">Seguros</label></strong>
				</td>		
				<td>					
					<input type="checkbox" name="Seguros" <cfif modo neq 'ALTA' and rsdata.Seguros EQ 1> checked </cfif>>					
				</td>	
				<td  align="right" nowrap>
					<strong><label for="Costos">Gastos</label></strong>
				</td>		
				<td>					
					<input type="checkbox" name="Gastos" <cfif modo neq 'ALTA' and rsdata.Gastos EQ 1> checked </cfif>>					
				</td>	
				<td width="15%"  align="right" nowrap>
					<strong><label for="Costos">Impuestos</label></strong>
				</td>		
				<td width="41%">					
					<input type="checkbox" name="Impuestos" <cfif modo neq 'ALTA' and rsdata.Impuestos EQ 1> checked </cfif>>					
				</td>								
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="6" align="center">
					<cfinclude template="../../portlets/pBotones.cfm">
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
	
	// Funcion para validar que el porcentaje digitado no sea mayor a100
	function _mayor(){	
		if ( new Number(qf(this.value)) > 100 ){
			this.error = 'El campo no puede ser mayor a 100';
			this.value = '';
		}
	}
	
	// Validaciones para los campos de % no sean mayores a 100 		
	_addValidator("ismayor", _mayor);
	
	objForm.ESporcmult.validatemayor();	
	objForm.ESporcmult.validate = true;
	
	objForm.ESporcadic.validatemayor();	
	objForm.ESporcadic.validate = true;
	
	//Validaciones de los campos requeridos	
	objForm.CMSdescripcion.required = true;
	objForm.CMSdescripcion.description="Descripción";
	
	objForm.ESporcadic.required = true;
	objForm.ESporcadic.description="Porcentaje Adicional";
	
	objForm.ESporcmult.required = true;
	objForm.ESporcmult.description="Porcentaje Multiplicador";
									
	function deshabilitarValidacion(){
		objForm.CMSdescripcion.required = false;
		objForm.ESporcadic.required = false;
		objForm.ESporcmult.required = false;
	}
</script>
</cfoutput>
			


