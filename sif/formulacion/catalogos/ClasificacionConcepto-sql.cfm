<cfparam name="Param" default="">
<cfif isdefined('form.FPCCidPadre') and len(trim(form.FPCCidPadre)) EQ 0>
	<cfset form.FPCCidPadre = -1>
</cfif>
<cfif form.FPCCconcepto EQ 'F'>
	<cfset FPCCTablaC = form.AClaId >
<cfelseif form.FPCCconcepto EQ 'A'>
	<cfset FPCCTablaC = form.Ccodigo >
<cfelseif ListFind('S,P', form.FPCCconcepto)>
	<cfset FPCCTablaC = form.CCid>
</cfif>
<cfif not isdefined('form.FPCCExigeFecha')>
	<cfset form.FPCCExigeFecha = 0>
</cfif>


<cfif isdefined("form.EspecificaCuenta")>
	<cfset LvarECuenta = 1>
<cfelse>
	<cfset LvarECuenta = 0>
</cfif>

<cfif isdefined('ALTA')>
	<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="AltaClasificacionConcepto" returnvariable="FPCCid">
		<cfinvokeargument name="FPCCcodigo" 		value="#form.FPCCcodigo#">
		<cfinvokeargument name="FPCCdescripcion"  	value="#form.FPCCdescripcion#">
		<cfinvokeargument name="FPCCtipo" 			value="#form.FPCCtipo#">
		<cfinvokeargument name="FPCCconcepto" 		value="#form.FPCCconcepto#">
	  <cfif isdefined('form.FPCCcomplementoC') and LEN(TRIM(form.FPCCcomplementoC))>
		<cfinvokeargument name="FPCCcomplementoC" 	value="#form.FPCCcomplementoC#">
	  </cfif>
	  <cfif isdefined('form.FPCCcomplementoP') and LEN(TRIM(form.FPCCcomplementoP))>
		<cfinvokeargument name="FPCCcomplementoP"	value="#form.FPCCcomplementoP#">
	  </cfif>
		<cfinvokeargument name="FPCCidPadre" 		value="#form.FPCCidPadre#">
	  <cfif isdefined('FPCCTablaC') and LEN(TRIM(FPCCTablaC))>
		<cfinvokeargument name="FPCCTablaC" 		value="#FPCCTablaC#">
	  </cfif>
	  <cfinvokeargument name="FPCCExigeFecha" 		value="#form.FPCCExigeFecha#">
	  
	  <cfif isdefined('form.CFormato') and LEN(TRIM(form.CFormato))>
		<cfinvokeargument name="FormatoCuenta" 	value="#form.CMayor#-#form.CFormato#">
	  </cfif>
		<cfinvokeargument name="EspecificaCuenta" 		value="#LvarECuenta#">
	  
	  <cfif isdefined('form.CFcuenta') and LEN(TRIM(form.CFcuenta))>
		<cfinvokeargument name="CFcuenta" 		value="#form.CFcuenta#">
	  </cfif>
	  
	</cfinvoke>
	<cfset Param = "FPCCid=#FPCCid#">
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="CambioClasificacionConcepto" returnvariable="FPCCid">
		<cfinvokeargument name="FPCCid" 			value="#form.FPCCid#">
		<cfinvokeargument name="FPCCcodigo" 		value="#form.FPCCcodigo#">
		<cfinvokeargument name="FPCCdescripcion"  	value="#form.FPCCdescripcion#">
		<cfinvokeargument name="FPCCtipo" 			value="#form.FPCCtipo#">
		<cfinvokeargument name="FPCCconcepto" 		value="#form.FPCCconcepto#">
	  <cfif isdefined('form.FPCCcomplementoC') and LEN(TRIM(form.FPCCcomplementoC))>
		<cfinvokeargument name="FPCCcomplementoC" 	value="#form.FPCCcomplementoC#">
	  </cfif>
	  <cfif isdefined('form.FPCCcomplementoP') and LEN(TRIM(form.FPCCcomplementoP))>
		<cfinvokeargument name="FPCCcomplementoP"	value="#form.FPCCcomplementoP#">
	  </cfif>
		<cfinvokeargument name="FPCCidPadre" 		value="#form.FPCCidPadre#">
		<cfinvokeargument name="ts_rversion" 		value="#form.ts_rversion#">
	  <cfif isdefined('FPCCTablaC') and len(trim(FPCCTablaC))>
		<cfinvokeargument name="FPCCTablaC" 		value="#FPCCTablaC#">
	  </cfif>
	   <cfinvokeargument name="FPCCExigeFecha" 		value="#form.FPCCExigeFecha#">
		
	  <cfif isdefined('form.CFormato') and LEN(TRIM(form.CFormato))>
		<cfinvokeargument name="FormatoCuenta" 	value="#form.CMayor#-#form.CFormato#">
	  </cfif>
		<cfinvokeargument name="EspecificaCuenta" 		value="#LvarECuenta#">
	  
	  <cfif isdefined('form.CFcuenta') and LEN(TRIM(form.CFcuenta))>
		<cfinvokeargument name="CFcuenta" 		value="#form.CFcuenta#">
	  </cfif>
		
	</cfinvoke>
	<cfset Param = "FPCCid=#FPCCid#&idTree=#idTree#">
<cfelseif isdefined('BAJA')>
	<cfinvoke component="sif.Componentes.PCG_ConceptoGastoIngreso" method="BajaClasificacionConcepto" returnvariable="FPCCid">
		<cfinvokeargument name="FPCCid" 			value="#form.FPCCid#">
		<cfinvokeargument name="ts_rversion" 		value="#form.ts_rversion#">
	</cfinvoke>
</cfif>
<cflocation url="ClasificacionConcepto.cfm?#param#">