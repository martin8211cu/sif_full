<cfif isdefined('Alta_E')>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnValidaConfigVariablesDinamicas">
		<cfinvokeargument name="RHEVDtipo"  		value="#form.RHEVDtipo#">
	</cfinvoke>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnAltaEVariablesDinamicas" returnvariable="lvarRHEVDid">
		<cfinvokeargument name="RHEVDcodigo" 		value="#form.RHEVDcodigo#">
		<cfinvokeargument name="RHEVDdescripcion" 	value="#form.RHEVDdescripcion#">
		<cfinvokeargument name="RHEVDtipo"  		value="#form.RHEVDtipo#">
	</cfinvoke>
<cfelseif isdefined('Cambio_E')>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnValidaConfigVariablesDinamicas">
		<cfinvokeargument name="RHEVDtipo"  		value="#form.RHEVDtipo#">
	</cfinvoke>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnCambioEVariablesDinamicas" returnvariable="lvarRHEVDid">
		<cfinvokeargument name="RHEVDid" 			value="#form.RHEVDid#">
		<cfinvokeargument name="RHEVDcodigo" 		value="#form.RHEVDcodigo#">
		<cfinvokeargument name="RHEVDdescripcion" 	value="#form.RHEVDdescripcion#">
		<cfinvokeargument name="RHEVDtipo"  		value="#form.RHEVDtipo#">
	</cfinvoke>
<cfelseif isdefined('Baja_E')>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnBajaEVariablesDinamicas">
		<cfinvokeargument name="RHEVDid" 			value="#form.RHEVDid#">
	</cfinvoke>
<cfelseif isdefined('Alta_D')>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnAltaDVariablesDinamicas" returnvariable="lvarRHDVDid">
			<cfinvokeargument name="RHEVDid" 			value="#form.RHEVDid#">
			<cfinvokeargument name="RHDVDcodigo" 		value="#form.RHDVDcodigo#">
			<cfinvokeargument name="RHDVDdescripcion" 	value="#form.RHDVDdescripcion#">
			<cfinvokeargument name="RHDVDnivel" 		value="#form.RHDVDnivel#">
			<cfinvokeargument name="RHDVDtipo" 			value="#form.RHDVDtipo#">
		<cfif form.RHDVDtipo eq '2'>
			<cfinvokeargument name="RHDVDconceptoA" 	value="#form.RHDVDidV1#">
			<cfinvokeargument name="RHDVDconceptoB" 	value="#form.RHDVDidV2#">
			<cfinvokeargument name="RHDVDoperacion" 	value="#form.RHDVDoperacion#">
		<cfelseif form.RHDVDtipo eq '3'>
			<cfinvokeargument name="RHDVDconstante" 	value="#replace(form.RHDVDconstante,',','','ALL')#">
		</cfif>
	</cfinvoke>
	<cfset lvarRHEVDid = form.RHEVDid>
<cfelseif isdefined('Cambio_D')>
	<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnCambioDVariablesDinamicas" returnvariable="lvarRHDVDid">
			<cfinvokeargument name="RHDVDid" 			value="#form.RHDVDid#">
			<cfinvokeargument name="RHEVDid" 			value="#form.RHEVDid#">
			<cfinvokeargument name="RHDVDcodigo" 		value="#form.RHDVDcodigo#">
			<cfinvokeargument name="RHDVDdescripcion" 	value="#form.RHDVDdescripcion#">
			<cfinvokeargument name="RHDVDnivel" 		value="#form.RHDVDnivel#">
			<cfinvokeargument name="RHDVDtipo" 			value="#form.RHDVDtipo#">
		<cfif form.RHDVDtipo eq '2'>
			<cfinvokeargument name="RHDVDconceptoA" 	value="#form.RHDVDidV1#">
			<cfinvokeargument name="RHDVDconceptoB" 	value="#form.RHDVDidV2#">
			<cfinvokeargument name="RHDVDoperacion" 	value="#form.RHDVDoperacion#">
		<cfelseif form.RHDVDtipo eq '3'>
			<cfinvokeargument name="RHDVDconstante" 	value="#replace(form.RHDVDconstante,',','','ALL')#">
		</cfif>
	</cfinvoke>
	<cfset lvarRHEVDid = form.RHEVDid>
<cfelseif isdefined('Baja_D')>
	<cftransaction>
		<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnBajaDVariablesDinamicas">
			<cfinvokeargument name="RHDVDid" 			value="#form.RHDVDid#">
		</cfinvoke>
	</cftransaction>
	<cfset lvarRHEVDid = form.RHEVDid>
<cfelseif isdefined('Nuevo_D')>
	<cfset lvarRHEVDid = form.RHEVDid>
<cfelseif isdefined('Boton') and Boton eq 'GUARDAR_F'>
	<cfset rsFVD.recordcount = 0>
	<cfif isdefined('form.RHDVDid') and len(trim(form.RHDVDid)) gt 0>
		<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnGetFVariablesDinamicas" returnvariable="rsFVD">
			<cfinvokeargument name="RHDVDid" 			value="#form.RHDVDid#">
		</cfinvoke>
	</cfif>
	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
	<cftransaction>
		<cfset presets_text = RH_Calculadora.get_presets()>
		<cfset values = RH_Calculadora.calculate( presets_text & ";" & form.formulas)>
		<cfif IsDefined("values")>
			<cfset RH_Calculadora.validate_result( values )>
		</cfif>
	</cftransaction>
    <cfset calc_error = RH_Calculadora.getCalc_error()>
	
	<cfif rsFVD.recordcount gt 0 and Len(calc_error) EQ 0>
		<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnCambioFVariablesDinamicas" returnvariable="lvarRHFVDid">
				<cfinvokeargument name="RHDVDid" 			value="#form.RHDVDid#">
			<cfif isdefined("form.LIMITAR")>
				<cfinvokeargument name="RHFVDcantidad" 		value="#form.CIcantidad#">
			</cfif>
				<cfinvokeargument name="RHFVDtipo" 			value="#form.CItipo#">
				<cfinvokeargument name="RHFVDcalculo" 		value="#form.formulas#">
			<cfif IsDefined("form.AjustarDiaMes")>
				<cfinvokeargument name="RHFVDdia" 			value="#form.CIdia#">
				<cfinvokeargument name="RHFVDmes" 			value="#form.CImes#">
			</cfif>
			<cfif Len(form.CIrango) gt 0 and form.rango NEQ '1'>
				<cfinvokeargument name="RHFVDrango" 		value="#form.CIrango#">
			</cfif>
			<cfif IsDefined("form.mesesoperiodos") and LEN(TRIM(form.mesesoperiodos))>
				<cfinvokeargument name="RHFVDspcantidad" 	value="#form.SPDPeriodos#">
				<cfinvokeargument name="RHFVDsprango" 		value="#form.mesesoperiodos#">
			</cfif>
			<cfif IsDefined("form.MesCompleto")>
				<cfinvokeargument name="RHFVDmescompleto" 	value="1">
			</cfif>
		</cfinvoke>
	<cfelseif Len(calc_error) EQ 0>
		<cfinvoke component="rh.Componentes.RH_VariablesDinamicas" method="fnAltaFVariablesDinamicas" returnvariable="lvarRHFVDid">
				<cfinvokeargument name="RHDVDid" 			value="#form.RHDVDid#">
			<cfif isdefined("form.LIMITAR")>
				<cfinvokeargument name="RHFVDcantidad" 		value="#form.CIcantidad#">
			</cfif>
				<cfinvokeargument name="RHFVDtipo" 			value="#form.CItipo#">
				<cfinvokeargument name="RHFVDcalculo" 		value="#form.formulas#">
			<cfif IsDefined("form.AjustarDiaMes")>
				<cfinvokeargument name="RHFVDdia" 			value="#form.CIdia#">
				<cfinvokeargument name="RHFVDmes" 			value="#form.CImes#">
			</cfif>
			<cfif Len(form.CIrango) gt 0 and form.rango NEQ '1'>
				<cfinvokeargument name="RHFVDrango" 		value="#form.CIrango#">
			</cfif>
			<cfif IsDefined("form.mesesoperiodos") and LEN(TRIM(form.mesesoperiodos))>
				<cfinvokeargument name="RHFVDspcantidad" 	value="#form.SPDPeriodos#">
				<cfinvokeargument name="RHFVDsprango" 		value="#form.mesesoperiodos#">
			</cfif>
			<cfif IsDefined("form.MesCompleto")>
				<cfinvokeargument name="RHFVDmescompleto" 	value="1">
			</cfif>
		</cfinvoke>
	</cfif>
	<cfset lvarRHEVDid = form.RHEVDid>
	<cfset lvarRHDVDid = form.RHDVDid>
	<cfset form.formular = '1'>
</cfif>
<html><head></head><body>
<cfoutput>
<form name="form1" method="post" action="VariablesDinamicas.cfm">
	<cfif isdefined('lvarRHEVDid')>
	<input type="hidden" id="RHEVDid" name="RHEVDid" value="#lvarRHEVDid#"/>
	</cfif>
	<cfif isdefined('lvarRHDVDid')>
	<input type="hidden" id="RHDVDid" name="RHDVDid" value="#lvarRHDVDid#"/>
	</cfif>
	<cfif isdefined('form.formular') and form.formular eq '1'>
	<input type="hidden" id="formular" name="formular" value="1"/>
	</cfif>
	<cfif isdefined('Nuevo_E')>
	<input type="hidden" id="btnNuevo" name="btnNuevo" value="1"/>
	</cfif>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	document.form1.submit();
</script>
</body></html>