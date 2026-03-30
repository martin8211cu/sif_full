<cfparam name="Param" default="">
<cfparam name="irA" default="ConceptoGI.cfm?">
<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="AltaConcepto" returnvariable="FPCid">
		<cfinvokeargument name="FPCCid" 			value="#form.FPCCid#">
		<cfinvokeargument name="FPCcodigo" 			value="#form.FPCcodigo#">
		<cfinvokeargument name="FPCdescripcion"  	value="#form.FPCdescripcion#">
	</cfinvoke>
	<cfset Param = "FPCCid=#form.FPCCid#&FPCid=#FPCid#">
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="CambioConcepto" returnvariable="FPCid">
		<cfinvokeargument name="FPCCid" 			value="#form.FPCCid#">
		<cfinvokeargument name="FPCid" 				value="#form.FPCid#">
		<cfinvokeargument name="FPCcodigo" 			value="#form.FPCcodigo#">
		<cfinvokeargument name="FPCdescripcion"  	value="#form.FPCdescripcion#">
		<cfinvokeargument name="ts_rversion" 		value="#form.ts_rversion#">
	</cfinvoke>
	<cfset Param = "FPCCid=#form.FPCCid#&FPCid=#form.FPCid#">
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="BajaConcepto" returnvariable="FPCid">
		<cfinvokeargument name="FPCid" 			value="#form.FPCid#">
		<cfinvokeargument name="ts_rversion" 	value="#form.ts_rversion#">
	</cfinvoke>
	<cfset Param = "FPCCid=#form.FPCCid#">
<cfelseif isdefined('form.IrCla') and len(trim(form.IrCla))>
	<cfset irA = form.IrCla>
</cfif>
<cflocation url="#irA##param#" addtoken="no">