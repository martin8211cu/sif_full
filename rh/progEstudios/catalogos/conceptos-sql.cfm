<cfif isdefined('form.AltaE')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaEC" returnvariable="RHECBid">
        <cfinvokeargument name="RHECBcodigo" 		value="#trim(form.RHECBcodigo)#">
        <cfinvokeargument name="RHECBdescripcion" 	value="#form.RHECBdescripcion#">
        <cfinvokeargument name="RHECBfecha" 		value="#LSDateFormat(form.RHECBfecha)#">
        <cfif isdefined('form.RHECBesMultiple')>
       		<cfinvokeargument name="RHECBesMultiple" value="1">
        </cfif>
        <cfif isdefined('form.RHECBbeneficio')>
       		<cfinvokeargument name="RHECBbeneficio" value="1">
        </cfif>
        <cfif len(trim(form.RHECBreporte)) gt 0>
       		<cfinvokeargument name="RHECBreporte" value="#form.RHECBreporte#">
        </cfif>
    </cfinvoke>
<cfelseif isdefined('form.CambioE')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioEC" returnvariable="RHECBid">
    	<cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
        <cfinvokeargument name="RHECBcodigo" 		value="#trim(form.RHECBcodigo)#">
        <cfinvokeargument name="RHECBdescripcion" 	value="#form.RHECBdescripcion#">
        <cfinvokeargument name="RHECBfecha" 		value="#LSDateFormat(form.RHECBfecha)#">
        <cfif isdefined('form.RHECBesMultiple')>
       		<cfinvokeargument name="RHECBesMultiple" value="1">
        </cfif>
        <cfif isdefined('form.RHECBbeneficio')>
       		<cfinvokeargument name="RHECBbeneficio" value="1">
        </cfif>
        <cfif len(trim(form.RHECBreporte)) gt 0>
       		<cfinvokeargument name="RHECBreporte" value="#form.RHECBreporte#">
        </cfif>
    </cfinvoke>
<cfelseif isdefined('form.BajaE')>
	<cftransaction>
    	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaDC">
    		<cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
        </cfinvoke>
        <cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaEC">
            <cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
        </cfinvoke>
    </cftransaction>
<cfelseif isdefined('form.AltaD')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnAltaDC" returnvariable="RHDCBid">
    	<cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
        <cfinvokeargument name="RHDCBcodigo" 		value="#trim(form.RHDCBcodigo)#">
        <cfinvokeargument name="RHDCBdescripcion" 	value="#form.RHDCBdescripcion#">
        <cfinvokeargument name="RHDCBfecha" 		value="#LSDateFormat(form.RHDCBfecha)#">
        <cfinvokeargument name="RHDCBtipo" 			value="#form.RHDCBtipo#">
        <cfif ListFind('2,3', form.RHDCBtipo) gt 0 and isdefined('form.RHDCBnegativos')>
        	<cfinvokeargument name="RHDCBnegativos" 	value="1">
        </cfif>
    </cfinvoke>
<cfelseif isdefined('form.CambioD')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnCambioDC" returnvariable="RHDCBid">
    	<cfinvokeargument name="RHDCBid" 			value="#form.RHDCBid#">
    	<cfinvokeargument name="RHECBid" 			value="#form.RHECBid#">
        <cfinvokeargument name="RHDCBcodigo" 		value="#trim(form.RHDCBcodigo)#">
        <cfinvokeargument name="RHDCBdescripcion" 	value="#form.RHDCBdescripcion#">
        <cfinvokeargument name="RHDCBfecha" 		value="#LSDateFormat(form.RHDCBfecha)#">
        <cfinvokeargument name="RHDCBtipo" 			value="#form.RHDCBtipo#">
        <cfif ListFind('2,3', form.RHDCBtipo) gt 0 and isdefined('form.RHDCBnegativos')>
        	<cfinvokeargument name="RHDCBnegativos" 	value="1">
        </cfif>
    </cfinvoke>
<cfelseif isdefined('form.BajaD')>
	<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnBajaDC">
    	<cfinvokeargument name="RHDCBid" 			value="#form.RHDCBid#">
    </cfinvoke>
</cfif>
<body>
	<cfoutput>
	<form name="form1" action="conceptos.cfm" method="post">
    	<cfif isdefined('RHECBid') and not isdefined('form.NuevoE') and not isdefined('form.BajaE')>
        	<input type="hidden" name="RHECBid" value="#RHECBid#"/>
        </cfif>
        <cfif isdefined('form.NuevoE')>
        	<input type="hidden" name="btnNuevo" value="btnNuevo"/>
        </cfif>
    </form>
    </cfoutput>
	<script language="javascript1.2" type="text/javascript">
    	document.form1.submit();
    </script>
</body>