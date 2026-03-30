
<!-- Establecimiento del modo -->
<cfset modo = 'ALTA'>
<cfif isdefined("url.arbol_pos") and len(trim(url.arbol_pos))>
	<cfset modo = 'CAMBIO'>
	<cfset form.AFCcodigo = url.arbol_pos>
</cfif>

<!-- Consultas -->
<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.DSN#" name="rsForm">
		select 	AFCcodigo, rtrim(AFCcodigoclas) as AFCcodigoclas, AFCdescripcion, 
				coalesce(AFCcodigopadre,-1) as AFCcodigopadre, ts_rversion 
		from AFClasificaciones
		where Ecodigo = #Session.Ecodigo#	 	
			and AFCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.arbol_pos#" >
	</cfquery>
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select 	AFCcodigo as AFCcodigopadre, AFCcodigoclas as AFCcodigoclaspadre, 
				AFCdescripcion as Cdescpadre, AFCnivel as Nnivel
		from AFClasificaciones
		where Ecodigo =  #session.Ecodigo#
		and AFCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.AFCcodigopadre#">		
	</cfquery>
</cfif>

<cfquery name="rsProfundidad" datasource="#session.DSN#">
	select coalesce(Pvalor,'1') as Pvalor
	from Parametros
	where Ecodigo= #session.Ecodigo#
	and Pcodigo=530
</cfquery>
<cfif modo NEQ 'ALTA'>
	<cfset tituloPorlet = "#rsForm.AFCcodigoclas# - #rsForm.AFCdescripcion#">
<cfelse>
	<cfset tituloPorlet = "Nueva Clasificación">
</cfif>
<!--- Pintado de la pantalla --->
<cfoutput>
	<form action="SQLTipoactivo.cfm" method="post" name="form1">
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr><td colspan="2"></tr>
			<tr>
				<td align="right" width="1%">C&oacute;digo:&nbsp;</td>
				<td>
					<input type="text" name="AFCcodigoclas" tabindex="1" size="25" <cfif modo NEQ 'ALTA'>readonly="true"</cfif> maxlength="20" value="<cfif modo NEQ 'ALTA'>#rsForm.AFCcodigoclas#</cfif>" alt="C&oacute;digo de la Clasificaci&oacute;n" onFocus="javascript:this.select();" >
				</td>
			</tr>
			<tr>
				<td align="right">Descripci&oacute;n:&nbsp;</td>
				<td>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><input type="text" name="AFCdescripcion" tabindex="1" size="60"  maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsForm.AFCdescripcion#</cfif>" alt="La descripci&oacute;n de la Clasificaci&oacute;n" onFocus="javascript:this.select();"></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right" nowrap valign="middle">Clasificaci&oacute;n Padre:&nbsp;</td>
				<td>
					<cfif modo neq 'ALTA'>
						<cf_siftipoactivo query="#rsClasificacion#" id="AFCcodigopadre" name="AFCcodigoclaspadre" desc="Cdescpadre" tabindex="1">
					<cfelse>
						<cf_siftipoactivo id="AFCcodigopadre" name="AFCcodigoclaspadre" desc="Cdescpadre" tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td align="center" valign="baseline" colspan="2" nowrap>
					<cf_botones modo="#modo#" tabindex="1">
				</td>	
			</tr>			
		</table>

		<cfif modo neq 'ALTA'>
			<cfset ts = "">	
			<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="AFCcodigo" value="#rsForm.AFCcodigo#" >
			<input type="hidden" name="_AFCcodigoclas" value="#rsForm.AFCcodigoclas#" >
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="_AFCcodigopadre" value="#rsForm.AFCcodigopadre#" >
		</cfif>
	    <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">
	</form>
	<cf_qforms>
            <cf_qformsRequiredField name="AFCcodigoclas" description="Código">
			<cf_qformsRequiredField name="AFCdescripcion" description="Descripción">
	</cf_qforms>
</cfoutput>
<script language="JavaScript" type="text/JavaScript">
	function funcCcodigoclaspadre(){
		if( document.form1.profundidad.value <= (parseInt(document.form1.Nnivel.value))+1 ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			document.form1.AFCcodigopadre.value = '';
			document.form1.AFCcodigoclaspadre.value = '';
			document.form1.AFCdescpadre.value = '';
			document.form1.Nnivel.value = '';
		}
	}	
</script>