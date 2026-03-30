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
	<cfif isdefined("form.CMAAid") and len(trim(form.CMAAid))>
		<cfset modo = 'CAMBIO'> 
	</cfif>
	<cfif modo NEQ 'ALTA'>
		<cfquery name = "rsdata" datasource="#session.DSN#">
			select CMAAid,CMAAcodigo,CMAAdescripcion,SNcodigo,ts_rversion
			from   CMAgenciaAduanal
			where  CMAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMAAid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
		</cfquery>
	</cfif>
	<form name="form1" method="post" action="SQLAgenciaAduanal.cfm">
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_CMAAcodigo" value="<cfif isdefined('form.filtro_CMAAcodigo') and form.filtro_CMAAcodigo NEQ ''>#form.filtro_CMAAcodigo#</cfif>">
		<input type="hidden" name="filtro_CMAAdescripcion" value="<cfif isdefined('form.filtro_CMAAdescripcion') and form.filtro_CMAAdescripcion NEQ ''>#form.filtro_CMAAdescripcion#</cfif>">		
		<input type="hidden" name="filtro_SNnombre" value="<cfif isdefined('form.filtro_SNnombre') and form.filtro_SNnombre NEQ ''>#form.filtro_SNnombre#</cfif>">				
		
		<cfif modo NEQ 'ALTA'>
			<input type = "hidden" name="CMAAid" value="#rsdata.CMAAid#">
		</cfif>	
		<table width="100%" border="0">
			<tr>
				<td  width="31%" align="right" nowrap><strong>C&oacute;digo:</strong></td>	
				<td>
					<input tabindex="1" name="CMAAcodigo" onFocus="this.select();" type="text" size="25" maxlength="20" value="<cfif modo neq 'ALTA'>#trim(rsdata.CMAAcodigo)#</cfif>">
					<input name= "CMAAcodigo2" type="hidden" value="<cfif modo neq 'ALTA'>#trim(rsdata.CMAAcodigo)#</cfif>">
				</td>	
			</tr>
			
			<tr>
				<td align="right" nowrap><strong>Descripción: </strong> </td>	
				<td>
					<input tabindex="1" onFocus="this.select();" name="CMAAdescripcion" type="text" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.CMAAdescripcion#</cfif>">
				</td>	
			</tr>			
			
			<tr>
				<td align="right" nowrap><strong>Socio Negocio: </strong> </td>	
				<td>
					<cfif modo neq 'ALTA'>
						<cf_sifsociosnegocios2 tabindex="1" idquery="#rsdata.SNcodigo#">
					<cfelse>
						<cf_sifsociosnegocios2 tabindex="1">
					</cfif>
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
			<!---<input type="hidden" name = "SNcodigo" value ="#form.SNcodigo#">--->
</form> 
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
				
	objForm.CMAAcodigo.required = true;
	objForm.CMAAcodigo.description="Código";
			
	objForm.CMAAdescripcion.required = true;
	objForm.CMAAdescripcion.description="Descripción";

	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="Socio Negocio";
				
	function deshabilitarValidacion(){
		objForm.CMAAcodigo.required = false;
		objForm.CMAAdescripcion.required = false;
		objForm.SNcodigo.required = false;
	}
	document.form1.CMAAcodigo.focus();
</script>
</cfoutput>
			


