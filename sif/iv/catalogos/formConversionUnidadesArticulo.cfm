<cfset modo="ALTA">
<cfif isdefined('form.CUAUcodigo') and len(trim(form.CUAUcodigo)) >
	<cfset modo="CAMBIO">
</cfif>
	
<cfquery name="rsArticulo" datasource="#Session.DSN#">
	select Acodigo, Adescripcion, Ucodigo
	from Articulos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
</cfquery>

<cfquery name="rsDescripcion" datasource="#Session.DSN#">
	select Udescripcion 
	from Unidades 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsArticulo.Ucodigo#">
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsConversion" datasource="#Session.DSN#">
		select Aid, Ucodigo, Ecodigo, CUAfactor, ts_rversion
		from ConversionUnidadesArt
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CUAUcodigo#">
	</cfquery>
	
	<cfquery name="rsUnidad2" datasource="#Session.DSN#">
		select  Ucodigo, Udescripcion
		from Unidades
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CUAUcodigo)#">
	</cfquery>
<cfelse>
	<!--- Consulta que llena el combo Unidad de Conversión --->	
	<cfquery name="rsUnidades" datasource="#Session.DSN#">
		select Ucodigo, Udescripcion 
		from Unidades u
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ucodigo not in (
				Select cu.Ucodigo
				from ConversionUnidadesArt cu
				where cu.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
					and cu.Ecodigo=u.Ecodigo
					and cu.Ucodigo=u.Ucodigo
			)
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
<form action="SQLConversionUnidadesArticulo.cfm" method="post" name="form1" onSubmit="return validar(); " >
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="Pagina2" type="hidden" tabindex="-1" value="#form.Pagina2#">		
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
			<td align="right" nowrap><strong>Unidad Inventario:</strong>&nbsp;</td>
			<td nowrap><strong>#rsDescripcion.Udescripcion#</strong></td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>Unidad Conversi&oacute;n:</strong>&nbsp;</td>
			<td>
 				<cfif modo EQ 'ALTA'>
					<select name="CUAUcodigo" tabindex="1">
						<option value=""></option>
						<cfloop query="rsUnidades">
							<option value="#rsUnidades.Ucodigo#" <cfif modo neq 'ALTA' and  rsConversion.Ucodigo eq rsUnidades.Ucodigo >selected</cfif> >#rsUnidades.Udescripcion#</option>
						</cfloop>
					</select>
 				<cfelseif isdefined('rsUnidad2')>
					<strong>#rsUnidad2.Udescripcion#<strong>
					<input type="hidden" name="CUAUcodigo" value="<cfif modo neq 'ALTA'>#rsUnidad2.Ucodigo#</cfif>" >
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>Factor:</strong>&nbsp;</td>
			<td nowrap>
				<input tabindex="1" type="text" name="CUAfactor" size="20" maxlength="20" value="<cfif modo neq 'ALTA'>#numberFormat(rsConversion.CUAfactor,",0.0000000000")#<cfelse>0.0000000000</cfif>" style="text-align:right;" onBlur="javascript:fm(this,10);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}">
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
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsConversion.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>

	</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
	
	objForm.CUAUcodigo.required = true;
	objForm.CUAUcodigo.description="Unidad de Conversión";				

	objForm.CUAfactor.required = true;
	objForm.CUAfactor.description="Factor de Conversión";				

	function deshabilitarValidacion(){
		objForm.CUAUcodigo.required = false;
		objForm.CUAfactor.required = false;
	}

	function validar(){
		document.form1.CUAfactor.value = qf(document.form1.CUAfactor.value);
		return true;
	}
	
	function funcRegresar(){
		deshabilitarValidacion();
	}
	objForm.CUAUcodigo.focus();
</script>
