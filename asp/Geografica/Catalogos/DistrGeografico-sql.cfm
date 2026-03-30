<cfparam name="param" default="">

<cfif isdefined('ALTA')>
    <cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnAltaDistribucion" returnvariable="DGid">
    		<cfinvokeargument name="NGid" 			value="#form.NGid#">
        <cfif isdefined('form.DGidPadre') and LEN(TRIM(form.DGidPadre))>
        	<cfinvokeargument name="DGidPadre" 		value="#form.DGidPadre#">
        </cfif>
            <cfinvokeargument name="DGcodigo" 		value="#TRIM(form.DGcodigo)#">
            <cfinvokeargument name="DGDescripcion" 	value="#TRIM(form.DGDescripcion)#">
			<cfinvokeargument name="DGcodigoPostal" value="#TRIM(form.DGcodigoPostal)#">
    </cfinvoke>
	<cfset param = "?DGid="&DGid>
<cfelseif isdefined('CAMBIO')>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnCambioDistribucion">
    		<cfinvokeargument name="DGid" 			value="#form.DGid#">
            <cfinvokeargument name="NGid" 			value="#form.NGid#">
        <cfif isdefined('form.DGidPadre') and LEN(TRIM(form.DGidPadre))>
        	<cfinvokeargument name="DGidPadre" 		value="#form.DGidPadre#">
        </cfif>
            <cfinvokeargument name="DGcodigo" 		value="#TRIM(form.DGcodigo)#">
            <cfinvokeargument name="DGDescripcion" 	value="#TRIM(form.DGDescripcion)#">
            <cfinvokeargument name="ts_rversion" 	value="#TRIM(form.ts_rversion)#">
            <cfinvokeargument name="Action" 		value="DistrGeografico.cfm?DGid=#form.DGid#">
			<cfinvokeargument name="DGcodigoPostal" value="#TRIM(form.DGcodigoPostal)#">
    </cfinvoke>
	<cfset param = "?DGid="&form.DGid>
<cfelseif isdefined('BAJA')>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnBajaDistribucion">
    		<cfinvokeargument name="DGid" 			value="#form.DGid#">
            <cfinvokeargument name="ts_rversion" 	value="#TRIM(form.ts_rversion)#">
            <cfinvokeargument name="Action" 		value="DistrGeografico.cfm">
    </cfinvoke>
    <cfset param = "?NGid="&form.NGid>
<cfelseif isdefined('Nuevo')>
    <cfset param = "?NGid="&form.NGid>
</cfif>

<cflocation url="DistrGeografico.cfm#param#">
