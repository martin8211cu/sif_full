<cfparam name="param" default="">
<cfif isdefined('form.ALTA')>
	<cfinvoke component="sif.Componentes.FPRES_VariacionPresupuestal" method="AltaTipoVariacion" returnvariable="FPTVid">
		<cfinvokeargument name="FPTVCodigo" 		value="#form.FPTVCodigo#">
		<cfinvokeargument name="FPTVDescripcion" 	value="#form.FPTVDescripcion#">
		<cfinvokeargument name="FPTVTipo"  	    	value="#form.FPTVTipo#">
	</cfinvoke>
<cfset param &="FPTVid="&FPTVid>
<cfelseif isdefined('form.CAMBIO')>
	<cfinvoke component="sif.Componentes.FPRES_VariacionPresupuestal" method="CambioTipoVariacion" returnvariable="FPTVid">
		<cfinvokeargument name="FPTVCodigo" 		value="#form.FPTVCodigo#">
		<cfinvokeargument name="FPTVDescripcion" 	value="#form.FPTVDescripcion#">
		<cfinvokeargument name="FPTVTipo"  	    	value="#form.FPTVTipo#">
		<cfinvokeargument name="FPTVid"  	    	value="#form.FPTVid#">
		<cfinvokeargument name="ts_rversion"  	    value="#form.ts_rversion#">
	</cfinvoke>
<cfset param &="FPTVid="&FPTVid>
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="sif.Componentes.FPRES_VariacionPresupuestal" method="BajaTipoVariacion">
		<cfinvokeargument name="FPTVid"  	    	value="#form.FPTVid#">
		<cfinvokeargument name="ts_rversion"  	    value="#form.ts_rversion#">
	</cfinvoke>
</cfif>
<cflocation addtoken="no" url="TipoVariacion.cfm?#param#">