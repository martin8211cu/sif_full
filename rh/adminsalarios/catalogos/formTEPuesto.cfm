<cfif isdefined("Form.EPid") and form.EPid NEQ ''>  
  <cfset modo="CAMBIO">
<cfelse>  
    <cfset modo="ALTA">
</cfif>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="sifpublica">
		select *
		from EncuestaPuesto
		where EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPid#">
	</cfquery>
</cfif>

<cfquery  name="rsArea" datasource="sifpublica">
	select EEid, EAid, EAdescripcion 
	from EmpresaArea 
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
	order by EAid, EAdescripcion
</cfquery>

<script language="JavaScript">
	function deshabilitarValidacion(){
		if (document.formPuesto.botonSel.value == 'Baja' || document.formPuesto.botonSel.value == 'Nuevo' ){
			objFormPuesto.EPcodigo.required = false;
			objFormPuesto.EPdescripcion.required = false;
		}
	}
</script>

<form method="post" name="formPuesto" action="SQLTEPuesto.cfm">
	<cfoutput>
		<input type="hidden" name="EEid" value="#form.EEid#">
		<cfif modo neq "ALTA">
			<input type="hidden" name="EPid" value="#rsform.EPid#">
			<input type="hidden" name="EPcodigoCambio" value="#rsform.EPcodigo#">
		</cfif>
		<table align="center" border="0">
			<tr >
				<td nowrap align="right"><strong>Código:</strong></td>
				<td colspan="3">
				
					<input type="text" name="EPcodigo"
						   value="<cfif modo NEQ 'ALTA'>#trim(rsForm.EPcodigo)#</cfif>" 
						   size="10" maxlength="10" onFocus="this.select();"  >
				</td>
			</tr>
			<tr >
				<td nowrap align="right"><strong>Descripción:</strong></td>
				<td colspan="3">
					<input type="text" name="EPdescripcion" 
						   value="<cfif modo NEQ 'ALTA'>#rsForm.EPdescripcion#</cfif>" 
						   size="60" maxlength="60" onFocus="this.select();"  >
				</td>
			</tr>
	
			<tr>
				<td nowrap align="right"><strong>&Aacute;rea:</strong></td>
				<td colspan="3">
					<select name="EAid">
						<option value="" >-- seleccionar &aacute;rea --</option>
						<cfloop query="rsArea">
							<option value="#rsArea.EAid#"
							<cfif modo NEQ 'ALTA' and rsForm.EAid EQ rsArea.EAid>selected</cfif>>#rsArea.EAdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			
			<tr valign="baseline">
				<td colspan="4" align="right" nowrap>
					<cf_botones modo="#modo#">
				</td>
			</tr>
	  </table>
	</cfoutput>		   
</form>

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objFormPuesto = new qForm("formPuesto");

	objFormPuesto.EPcodigo.required = true;
	objFormPuesto.EPcodigo.description="Código del Puesto";
	objFormPuesto.EPdescripcion.required = true;
	objFormPuesto.EPdescripcion.description="Descripción del Puesto";
	objFormPuesto.EEid.required = true;
	objFormPuesto.EEid.description="Empresa Encuestadora";
	objFormPuesto.EAid.required = true;
	objFormPuesto.EAid.description="Area";
</script>