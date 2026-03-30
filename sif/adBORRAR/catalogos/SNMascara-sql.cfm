<cfparam name="param" default="">
<cfif isdefined('form.Alta')>
	<cfinvoke component="sif.Componentes.SocioNegocios" method="AltaSNMascaras" returnvariable="SNMid">
    	<cfinvokeargument name="SNtipo" 		value="#form.SNtipo#">
        <cfinvokeargument name="SNMDescripcion" value="#form.SNMDescripcion#">
        <cfinvokeargument name="SNMascara" 		value="#form.SNMascara#">
    </cfinvoke>
    <cfset param = "SNMid="&SNMid>
<cfelseif isdefined('form.Cambio')>
	<cfinvoke component="sif.Componentes.SocioNegocios" method="CambioSNMascaras">
    	<cfinvokeargument name="SNMid" 			value="#form.SNMid#">
        <cfinvokeargument name="SNtipo" 		value="#form.SNtipo#">
        <cfinvokeargument name="SNMDescripcion" value="#form.SNMDescripcion#">
        <cfinvokeargument name="SNMascara" 		value="#form.SNMascara#">
        <cfinvokeargument name="ts_rversion" 	value="#form.ts_rversion#">
    </cfinvoke>
    <cfset param = "SNMid="&form.SNMid>
<cfelseif isdefined('form.Baja')>
	<cfinvoke component="sif.Componentes.SocioNegocios" method="BajaSNMascaras">
    	<cfinvokeargument name="SNMid" 			value="#form.SNMid#">
        <cfinvokeargument name="ts_rversion" 	value="#form.ts_rversion#">
    </cfinvoke>
</cfif>
<cflocation addtoken="no" url="SNMascara.cfm?#Param#">