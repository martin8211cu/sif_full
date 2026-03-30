	<cfinvoke component="rh.Componentes.RH_TiposIncidenciaLimiteFormular" method="fnGetCIncidentesDLimite" returnvariable="rsCIncidentesDLimite">
    	<cfinvokeargument name="CIid" value="#form.CIid#">
    </cfinvoke>
    
          
	<cfif isdefined("rsCIncidentesDLimite") and rsCIncidentesDLimite.RecordCount neq 0>
    	<cfinvoke component="rh.Componentes.RH_TiposIncidenciaLimiteFormular" method="fnCambioCIncidentesDLimite" returnvariable="rsCIncidentesDLimite">
    		<cfinvokeargument name="CIid"  			value="#form.CIid#">
            <cfinvokeargument name="CIcantidad"  	value="#form.CIcantidad#">
            <cfinvokeargument name="CItipo"  		value="#form.CItipo#">
            <cfinvokeargument name="CIcalculo"  	value="#form.formulas#">
            <cfinvokeargument name="CIdia"  		value="#form.CIdia#">
            <cfinvokeargument name="CImes"  		value="#form.CImes#">
            <cfinvokeargument name="CIrango"  		value="#form.CIrango#">
			<cfif isdefined('form.MesCompleto')>
                <cfinvokeargument name="CIspcantidad"  	value="#form.SPDPeriodos#">
                <cfinvokeargument name="CImescompleto"  value="#form.MesCompleto#">
                <cfinvokeargument name="CIsprango"  	value="#form.mesesoperiodos#">
            </cfif>
         </cfinvoke>
    <cfelse>
        <cfinvoke component="rh.Componentes.RH_TiposIncidenciaLimiteFormular" method="fnAltaCIncidentesDLimite">
           <cfinvokeargument name="CIid"  			value="#form.CIid#">
            <cfinvokeargument name="CIcantidad"  	value="#form.CIcantidad#">
            <cfinvokeargument name="CItipo"  		value="#form.CItipo#">
            <cfinvokeargument name="CIcalculo"  	value="#form.formulas#">
            <cfinvokeargument name="CIdia"  		value="#form.CIdia#">
            <cfinvokeargument name="CImes"  		value="#form.CImes#">
            <cfinvokeargument name="CIrango"  		value="#form.CIrango#">
			<cfif isdefined('form.MesCompleto')>
                <cfinvokeargument name="CIspcantidad"  	value="#form.SPDPeriodos#">
                <cfinvokeargument name="CImescompleto"  value="#form.MesCompleto#">
                <cfinvokeargument name="CIsprango"  	value="#form.mesesoperiodos#">
            </cfif>
         </cfinvoke>
    </cfif>

<html><head></head><body>
<cfoutput>
<form name="form1" method="post" action="TiposIncidencia.cfm">
	<cfif isdefined('lvarRHEVDid')>
	<input type="hidden" id="CIid" name="CIid" value="#lvarCIid#"/>
	</cfif>
	<cfif isdefined('lvarRHDVDid')>
	<input type="hidden" id="CIid" name="CIid" value="#lvarCIid#"/>
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