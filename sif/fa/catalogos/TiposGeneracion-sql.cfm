<cfparam name="param" default="?">
<cfif isdefined('form.ALTA')>
	<cfinvoke component="sif.Componentes.FAGeneracionAuto" method="ALTAGFATipos" returnvariable="GFAid">
    	<cfinvokeargument name="GFACodigo" 			value="#form.GFACodigo#">
        <cfinvokeargument name="GFADescripcion" 	value="#form.GFADescripcion#">
        <cfinvokeargument name="GFAMetodo" 			value="#form.GFAMetodo#">
        <cfinvokeargument name="GFAPeriodicidad" 	value="#form.GFAPeriodicidad#">
        <cfinvokeargument name="GFAPorcentaje" 		value="#form.GFAPorcentaje#">
    </cfinvoke>
    <cfset param = param&"GFAid="&GFAid>
<cfelseif isdefined('form.CAMBIO')>
	<cfinvoke component="sif.Componentes.FAGeneracionAuto" method="CAMBIOGFATipos" returnvariable="GFAid">
    	<cfinvokeargument name="GFAid" 				value="#form.GFAid#">
        <cfinvokeargument name="GFACodigo" 			value="#form.GFACodigo#">
        <cfinvokeargument name="GFADescripcion" 	value="#form.GFADescripcion#">
        <cfinvokeargument name="GFAMetodo" 			value="#form.GFAMetodo#">
        <cfinvokeargument name="GFAPeriodicidad" 	value="#form.GFAPeriodicidad#">
        <cfinvokeargument name="GFAPorcentaje" 		value="#form.GFAPorcentaje#">        
    </cfinvoke>
    <cfset param = param&"GFAid="&form.GFAid>    
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="sif.Componentes.FAGeneracionAuto" method="BAJAGFATipos">
    	<cfinvokeargument name="GFAid" 				value="#form.GFAid#">
    </cfinvoke>
</cfif>
<cflocation addtoken="no" url="TiposGeneracion.cfm#param#">