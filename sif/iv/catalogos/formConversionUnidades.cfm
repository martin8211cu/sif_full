<cfset modo="ALTA">
<cfif isdefined('form.CUlinea') and len(trim(form.CUlinea)) >
	<cfset modo="CAMBIO">
</cfif>

<!--- Llena el primer combo de Unidades --->	
<cfquery name="rsUnidades" datasource="#Session.DSN#">
	select Ucodigo, Udescripcion 
	from Unidades 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
	
<cfquery name="rsUnidadesSel" datasource="#Session.DSN#">
	select Ucodigo,Ucodigoref
	from ConversionUnidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsdata" datasource="#Session.DSN#">
		select CUlinea, Ecodigo, Ucodigo, Ucodigoref, CUfactor, CUconvarticulo, Usucodigo, fechaalta, ts_rversion
		from ConversionUnidades
		where CUlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CUlinea#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsUdescripcion" dbtype="query">
		select  Ucodigo, Udescripcion
		from rsUnidades
		where Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Ucodigo)#">
	</cfquery>

	<cfquery name="rsUdescripcionRef" dbtype="query">
		select  Ucodigo, Udescripcion
		from rsUnidades
		where Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Ucodigoref)#">
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
<form action="SQLConversionUnidades.cfm" method="post" name="form1" onSubmit="return validar(); " >
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
	<input type="hidden" name="filtro_descripcion" value="<cfif isdefined('form.filtro_descripcion') and form.filtro_descripcion NEQ ''>#form.filtro_descripcion#</cfif>">
	<input type="hidden" name="filtro_descripcionRef" value="<cfif isdefined('form.filtro_descripcionRef') and form.filtro_descripcionRef NEQ ''>#form.filtro_descripcionRef#</cfif>">	
	<input type="hidden" name="filtro_CUfactor" value="<cfif isdefined('form.filtro_CUfactor') and form.filtro_CUfactor NEQ ''>#form.filtro_CUfactor#</cfif>">

	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td align="right" nowrap><strong>Unidad Or&iacute;gen:</strong>&nbsp;</td>
			<td nowrap>
 				<cfif modo EQ 'ALTA'>
					<select tabindex="1" name="Ucodigo" onchange="cambioCombo(this.value,<cfif modo neq 'ALTA' and data.Ucodigo NEQ ''>#data.Ucodigo#<cfelse>-1</cfif>)">
					<option value=""></option>
 						<cfloop query="rsUnidades">
							<option value="#Trim(rsUnidades.Ucodigo)#" <cfif modo neq 'ALTA' and  data.Ucodigo eq rsUnidades.Ucodigo >selected</cfif> >#rsUnidades.Udescripcion#</option>
						</cfloop> 
					</select>
 				<cfelse>
					<strong>#rsUdescripcion.Udescripcion#<strong>
					<input type="hidden" name="Ucodigo" value="<cfif modo neq 'ALTA'>#rsUdescripcion.Ucodigo#</cfif>" >
					<input type="hidden" name="CUlinea" value="<cfif modo neq 'ALTA'>#rsdata.CUlinea#</cfif>">
				</cfif>
			</td>
		</tr>		
		<tr>
			<td align="right" nowrap><strong>Unidad Conversi&oacute;n:</strong>&nbsp;</td>
			<td>
 				<cfif modo EQ 'ALTA'>
					<select name="Ucodigoref" tabindex="1">
					</select>
 				<cfelse>
					<strong>#rsUdescripcionRef.Udescripcion#<strong>
					<input type="hidden" name="Ucodigoref" value="<cfif modo neq 'ALTA'>#rsUdescripcionRef.Ucodigo#</cfif>" >
				</cfif>
			</td>
		</tr>		
		<tr>
			<td align="right" nowrap><strong>Factor:</strong>&nbsp;</td>
			<td nowrap>
				<input tabindex="1" type="text" name="CUfactor" size="20" maxlength="20" value="<cfif modo neq 'ALTA'>#numberFormat(rsdata.CUfactor,",0.0000000000")#<cfelse>0.0000000000</cfif>" style="text-align:right;" onBlur="javascript:fm(this,10);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,10)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>
			  	<input tabindex="1" type="checkbox" name="CUconvarticulo" value="<cfif modo NEQ "ALTA">#rsdata.CUconvarticulo#</cfif>" <cfif modo NEQ "ALTA" and rsdata.CUconvarticulo EQ "1">checked</cfif> >
			</td>
			<td nowrap><strong>Conversi&oacute;n por Art&iacute;culo</strong>&nbsp;</td>
		</tr>
		<tr><td colspan="2" >&nbsp;</td></tr>
		<tr align="center">
			<td colspan="2" >
				<cf_Botones modo="#modo#" tabindex="1">
			</td>
		</tr>    	
		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdata.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>
	</table>
</form>
</cfoutput>

<script language="JavaScript" type="text/JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");	
	
	objForm.Ucodigo.required = true;
	objForm.Ucodigo.description="Unidad Origén";				

	objForm.Ucodigoref.required = true;
	objForm.Ucodigoref.description="Unidad de Conversión";				

	objForm.CUfactor.required = true;
	objForm.CUfactor.description="Factor de Conversión";				

	function deshabilitarValidacion(){
		objForm.Ucodigo.required = false;
		objForm.Ucodigoref.required = false;
		objForm.CUfactor.required = false;
	}

	function validar(){
		document.form1.CUfactor.value = qf(document.form1.CUfactor.value);
		return true;
	}

	function cambioCombo(valor,selected) {
 		if ( valor!= "" ) {
			document.form1.Ucodigoref.length = 0;
			i = 0;
			var quitar = false;
			<cfoutput query="rsUnidades">
				var unidad = '#Trim(rsUnidades.Ucodigo)#';
				
				if ( unidad != valor ){
					<cfloop query="rsUnidadesSel">
						if ( valor == '#Trim(rsUnidadesSel.Ucodigo)#' && unidad == '#Trim(rsUnidadesSel.Ucodigoref)#' )
							quitar = true;
					</cfloop>
					
					if(!quitar){
						document.form1.Ucodigoref.length = i+1;
						document.form1.Ucodigoref.options[i].value = unidad;
						document.form1.Ucodigoref.options[i].text  = '#rsUnidades.Udescripcion#';
						if (selected != -1 && (selected == unidad)){
							document.form1.Ucodigoref.options[i].selected=true;
						} 
						i++;
					}
				};
				quitar = false;				
			</cfoutput>
		}
		
		return;
	}	
	<cfif modo neq "ALTA">
		document.form1.CUfactor.focus();
	<cfelse>
		document.form1.Ucodigo.focus();
	</cfif>
</script>
<iframe name="unidad" id="unidad" width="0" height="0" />