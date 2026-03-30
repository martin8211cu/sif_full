<cfif isdefined("form.QPidLote") and len(trim(form.QPidLote))>
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
			a.QPidLote,
			a.QPLcodigo, 
			a.QPLdescripcion,
			a.QPLfechaProduccion, 
			a.QPLfechaFinVigencia,
			BMfecha,
			BMUsucodigo,
			ts_rversion,
			(( select count(1) from QPassTag t where t.QPidLote = a.QPidLote )) as CantidadTags
		from QPassLote a
		where a.Ecodigo = #session.Ecodigo#
		and  a.QPidLote=#form.QPidLote#
		order by QPLcodigo
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfoutput>
	<fieldset>
	<legend><strong>Lote</strong>&nbsp;</legend>
		<form action="QPassLote_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); " onSubmit="return validar(this);"> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="right"><strong>C&oacute;digo:</strong></td>
					<td colspan="2">
					<input type="text" name="QPLcodigo" maxlength="20" size="20" id="QPLcodigo" tabindex="0" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.QPLcodigo)#</cfif>" <cfif modo NEQ 'ALTA'>disabled="disabled"</cfif>/>
				</tr>			
				<tr>
					<td align="right"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
						<input type="text" name="QPLdescripcion" maxlength="40" size="40" id="QPLdescripcion" tabindex="0" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.QPLdescripcion)#</cfif>" />
				</tr>			
				<tr>
					<td align="right"><strong>Producci&oacute;n:</strong></td>
					<td colspan="2">
						<cfset QPLfechaProduccion =DateFormat(Now(),'DD/MM/YYYY')>
							<cfif modo NEQ 'ALTA'>
								<cfset QPLfechaProduccion  = DateFormat(#rsForm.QPLfechaProduccion#,'DD/MM/YYYY') >
							</cfif>
						<cf_sifcalendario form="form1" value="#QPLfechaProduccion#" name="QPLfechaProduccion" tabindex="1"></td> 
				</tr>	
				<tr>
					 <td align="right"><strong>Vencimiento:</strong></td>
					 <td colspan="2">
						<cfif modo NEQ 'ALTA'>
							<cfset QPLfechaFinVigencia  = DateFormat(rsForm.QPLfechaFinVigencia,'DD/MM/YYYY') >
						<cfelse>
							<cfset QPLfechaFinVigencia  ='01/01/2015'>	
						</cfif>
					<cf_sifcalendario form="form1" value="#QPLfechaFinVigencia#" name="QPLfechaFinVigencia" tabindex="1"></td> 
				</tr>	
				<tr>
					 <td align="left" colspan="2"><strong>Cantidad de Tags:</strong>
				  <cfif modo NEQ 'ALTA'>#rsForm.CantidadTags#</cfif></td> 
				</tr>	
				<tr><td colspan="3"></td></tr>
			
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.QPidLote") and isdefined("form.QPLcodigo")> 
							<cf_botones modo="#modo#" tabindex="1">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="1">
						</cfif> 
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<cfset ts = "">
						<cfif modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
							</cfinvoke>
							<input type="hidden" name="QPidLote" value="#rsForm.QPidLote#" >
							<input type="hidden" name="ts_rversion" value="#ts#" >
						</cfif>
							<input type="hidden" name="Pagina3" 
							value="
								<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
									#form.pagenum3#
								<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
									#url.PageNum_lista3#
								</cfif>">
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.QPLcodigo.description = "Código";
		objForm.QPLdescripcion.description = "Descripción";
		
	function habilitarValidacion() 
	{
		objForm.QPLcodigo.required = true;
		objForm.QPLdescripcion.required = true;
	}
	
	
	function fnFechaYYYYMMDD (LvarFecha)
		{
			return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
		}
	
	function validar(formulario){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
		if (fnFechaYYYYMMDD(document.form1.QPLfechaProduccion.value) > fnFechaYYYYMMDD(document.form1.QPLfechaFinVigencia.value))
		{
			alert ("La Fecha de Fabricación debe ser menor a la Fecha de Vencimiento");
			return false;
		}

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}    
</script>
</cfoutput>