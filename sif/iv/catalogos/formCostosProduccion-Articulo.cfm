<cfset modo="ALTA">
<cfif isdefined('form.CTDid') and len(trim(form.CTDid)) >
	<cfset modo="CAMBIO">
</cfif>
	
<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select Acodigo, Adescripcion, Ucodigo
	from Articulos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsCosto" datasource="#Session.DSN#">
		select CTDid, Aid, Ecodigo, CTDcosto, CTDperiodo, CTDmes, ts_rversion
		from CostoProduccionSTD
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTDid#">
	</cfquery>

</cfif>

<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form action="SQLCostosProduccion-Articulo.cfm" method="post" name="form1" onSubmit="javascript: document.form1.CTDcosto.value = qf(document.form1.CTDcosto.value); return true;"><!----onSubmit="return validar(); " >---->
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="Pagina4" type="hidden" tabindex="-1" value="#form.Pagina4#">		
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
	<input type="hidden" name="filtro_Acodigo" value="<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>#form.filtro_Acodigo#</cfif>">
	<input type="hidden" name="filtro_Acodalterno" value="<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>#form.filtro_Acodalterno#</cfif>">
	<input type="hidden" name="filtro_Adescripcion" value="<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>#form.filtro_Adescripcion#</cfif>">		
	<input type="hidden" name="Aid" value="#form.Aid#">
	
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td align="right" nowrap><strong>Art&iacute;culo:</strong>&nbsp;</td>
			<td nowrap>
				<strong>#rsArticulo.Acodigo# - #rsArticulo.Adescripcion#</strong>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap><strong>Costo:</strong>&nbsp;</td>
			<td nowrap><input tabindex="1" name="CTDcosto" type="text"  value="<cfif modo NEQ 'ALTA'>#LSNumberFormat(rsCosto.CTDcosto,',9.0000')#<cfelse>0.000</cfif>" style="text-align:right;" onBlur="javascript:fm(this,4)" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"  size="18" maxlength="18">
		</tr>
		<tr>
			<td align="right" nowrap><strong>Per&iacute;odo:</strong>&nbsp;</td>
			<td nowrap>
				<cfif modo neq 'ALTA'>
					<cf_monto tabindex="1" decimales="0" size="4" name="CTDperiodo" form="form1" value="#rsCosto.CTDperiodo#">
				<cfelse>
					<cf_monto tabindex="1" decimales="0" size="4" name="CTDperiodo" form="form1">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>Mes:</strong>&nbsp;</td>
			<td>
				<select name="CTDmes" tabindex="1">
					<!---<option value=""></option>---->
					<option value="1" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '1'>selected</cfif> >Enero</option>
					<option value="2" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '2'>selected</cfif> >Febrero</option>
					<option value="3" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '3'>selected</cfif> >Marzo</option>
					<option value="4" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '4'>selected</cfif> >Abril</option>
					<option value="5" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '5'>selected</cfif> >Mayo</option>
					<option value="6" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '6'>selected</cfif> >Junio</option>
					<option value="7" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '7'>selected</cfif> >Julio</option>
					<option value="8" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '8'>selected</cfif> >Agosto</option>
					<option value="9" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '9'>selected</cfif> >Setiembre</option>
					<option value="10" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '10'>selected</cfif> >Octubre</option>
					<option value="11" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '11'>selected</cfif> >Noviembre</option>
					<option value="12" <cfif modo neq 'ALTA' and  rsCosto.CTDmes eq '12'>selected</cfif> >Diciembre</option>
				</select>
			</td>
		</tr>
		<tr><td colspan="2" >&nbsp;</td></tr>
		<tr align="center">
			<td colspan="2" >
				<cf_Botones modo="#modo#" include="Regresar" includevalues="Regresar" tabindex="1">	
			</td>
		</tr>
    	
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsCosto.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="CTDid" value="<cfif modo NEQ 'ALTA'>#rsCosto.CTDid#</cfif>">
    	</cfif>

	</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
	
	objForm.CTDcosto.required = true;
	objForm.CTDcosto.description="Costo";				

	objForm.CTDperiodo.required = true;
	objForm.CTDperiodo.description="Periódo";
	
	objForm.CTDmes.required = true;
	objForm.CTDmes.description="Mes";				

	function deshabilitarValidacion(){
		objForm.CTDcosto.required = false;
		objForm.CTDperiodo.required = false;
		objForm.CTDmes.required = false;
	}
	
	function funcRegresar(){
		deshabilitarValidacion();
	}
	objForm.CTDcosto.focus();	
</script>