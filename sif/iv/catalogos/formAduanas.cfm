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
	<cfif isdefined("form.CMAid") and len(trim(form.CMAid))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>
		<cfquery name = "rsdata" datasource="#session.DSN#">
			select CMAid,CMAcodigo,CMAdescripcion,ts_rversion
			from   CMAduanas
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
				and CMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMAid#">
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="SQLAduanas.cfm">
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_CMAcodigo" value="<cfif isdefined('form.filtro_CMAcodigo') and form.filtro_CMAcodigo NEQ ''>#form.filtro_CMAcodigo#</cfif>">
		<input type="hidden" name="filtro_CMAdescripcion" value="<cfif isdefined('form.filtro_CMAdescripcion') and form.filtro_CMAdescripcion NEQ ''>#form.filtro_CMAdescripcion#</cfif>">		
	
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="CMAid" value="#rsdata.CMAid#">
		</cfif>	
		<table width="100%" border="0">
			<tr>
				<td  width="31%" align="right" nowrap><strong>C&oacute;digo:</strong></td>	
				<td>
					<input tabindex="1" name="CMAcodigo" type="text" size="10" maxlength="5" value="<cfif modo neq 'ALTA'>#trim(rsdata.CMAcodigo)#</cfif>">
					<input name= "CMAcodigo2" type="hidden" value="<cfif modo neq 'ALTA'>#trim(rsdata.CMAcodigo)#</cfif>">
				</td>	
			</tr>
			<tr>
				<td align="right" nowrap><strong>Descripción: </strong> </td>	
				<td>
					<input tabindex="1" name="CMAdescripcion" type="text" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.CMAdescripcion#</cfif>">
				</td>	
			</tr>			
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
	// Valida que el campo no sea mayor que 100
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
				
	objForm.CMAcodigo.required = true;
	objForm.CMAcodigo.description="Código";
			
	objForm.CMAdescripcion.required = true;
	objForm.CMAdescripcion.description="Descripción";
			
				
	function deshabilitarValidacion(){
		objForm.CMAcodigo.required = false;
		objForm.CMAdescripcion.required = false;
	}
	document.form1.CMAcodigo.focus();
</script>
</cfoutput>
			


