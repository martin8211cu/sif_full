<cfparam name="Param" default="">
<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="AltaActividadEmpresarial" returnvariable="FPAEid">
		<cfinvokeargument name="FPAECodigo" 	 value="#form.FPAECodigo#">
		<cfinvokeargument name="FPAEDescripcion" value="#form.FPAEDescripcion#">
		<cfinvokeargument name="FPAETipo"  	     value="#form.FPAETipo#">
	</cfinvoke>
	<cfset Param = "FPAEid=#FPAEid#">
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="CambioActividadEmpresarial">
		<cfinvokeargument name="FPAEid" 	 	 value="#form.FPAEid#">
		<cfinvokeargument name="FPAECodigo" 	 value="#form.FPAECodigo#">
		<cfinvokeargument name="FPAEDescripcion" value="#form.FPAEDescripcion#">
		<cfinvokeargument name="FPAETipo"  	     value="#form.FPAETipo#">
		<cfinvokeargument name="ts_rversion" 	 value="#form.ts_rversion#">
	</cfinvoke>
	<cfset Param = "FPAEid=#form.FPAEid#">
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="BajaActividadEmpresarial">
		<cfinvokeargument name="FPAEid" 	 	 value="#form.FPAEid#">
		<cfinvokeargument name="ts_rversion" 	 value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif isdefined('NUEVO')>
	<cfset Param = "btnNuevo=true">
<cfelseif isdefined('ALTANivel')>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="AltaActividadNivel" returnvariable="FPADNivel">
		<cfinvokeargument name="FPAEid" 	 		value="#form.FPAEid_key#">
		<cfinvokeargument name="FPADDescripcion" 	value="#form.FPADDescripcion#">
		<cfinvokeargument name="FPADDepende"  	    value="#form.FPADDepende#">
		<cfinvokeargument name="FPADIndetificador"  value="#form.FPADIndetificador#">
		<cfif len(trim(form.PCEcatid))>
			<cfinvokeargument name="PCEcatid"  	   	 	value="#form.PCEcatid#">
		</cfif>
		<cfif isdefined('form.FPADEquilibrio') and form.FPADDepende EQ 'C'>
			<cfinvokeargument name="FPADEquilibrio"  value="#form.FPADEquilibrio#">
		</cfif>
	</cfinvoke>
	<cfset Param = "FPAEid=#form.FPAEid_key#&FPADNivel=#FPADNivel#">
<cfelseif isdefined('CAMBIONivel')>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="CambioActividadNivel">
		<cfinvokeargument name="FPAEid" 	 		value="#form.FPAEid_key#">
		<cfinvokeargument name="FPADNivel" 	 		value="#form.FPADNivel_key#">
		<cfinvokeargument name="FPADDescripcion" 	value="#form.FPADDescripcion#">
		<cfinvokeargument name="FPADDepende"  	    value="#form.FPADDepende#">
		<cfinvokeargument name="FPADIndetificador"  value="#form.FPADIndetificador#">
		<cfif len(trim(form.PCEcatid))>
			<cfinvokeargument name="PCEcatid"  	   	 	value="#form.PCEcatid#">
		</cfif>
		<cfif isdefined('form.FPADEquilibrio') and form.FPADDepende EQ 'C'>
			<cfinvokeargument name="FPADEquilibrio"  value="#form.FPADEquilibrio#">
		</cfif>
	</cfinvoke>
	<cfset Param = "FPAEid=#form.FPAEid_key#&FPADNivel=#form.FPADNivel_key#">
<cfelseif isdefined('BAJANivel')>
	<cfinvoke component="sif.Componentes.FPRES_ActividadEmpresarial" method="BajaActividadNivel">
		<cfinvokeargument name="FPAEid" 	 		value="#form.FPAEid_key#">
		<cfinvokeargument name="FPADNivel" 	 		value="#form.FPADNivel_key#">
	</cfinvoke>
	<cfset Param = "FPAEid=#form.FPAEid_key#">
<cfelseif isdefined('NuevoNivel')>
	<cfset Param = "FPAEid=#form.FPAEid_key#">
</cfif>
<cflocation url="ActividadesEmpresa.cfm?#param#" addtoken="no">