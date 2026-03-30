<cfparam name="URL.RHPcodigo"	default="-1">
<cfparam name="URL.readonly"	default="false">
<cfparam name="URL.width" 	    default="auto">
<cfparam name="URL.onchange"    default="">

<cfif isdefined('URL.btnGuardarPues') and isdefined('URL.NewPuesCorrecto') and URL.NewPuesCorrecto>
	<cfinvoke component="rh.Componentes.Puesto" method="AltaPuesto" returnvariable="RHPcodigo">
    	<cfinvokeargument name="RHPcodigo" 		value="#URL.NewRHPcodigo#">
        <cfinvokeargument name="RHPdescpuesto" 	value="#URL.NewRHPdescpuesto#">
    </cfinvoke>
    <script>
		refreshtheDivPrintPues('<cfoutput>#NewRHPcodigo#</cfoutput>');
		ColdFusion.Window.hide('newPuesto');
	</script>
</cfif>
<cfif isdefined('url.Print') and url.Print>
    <select name="RHPcodigo" onchange="<cfoutput>#URL.onchange#</cfoutput>" style="width:<cfoutput>#URL.width#</cfoutput>" <cfif url.readonly>disabled</cfif>>
        <cfinvoke component="rh.Componentes.Puesto" method="GetPuesto" returnvariable="rsPues"/>
        <cfoutput query="rsPues">
            <option value="#TRIM(rsPues.RHPcodigo)#" <cfif TRIM(URL.RHPcodigo) EQ TRIM(rsPues.RHPcodigo)>selected</cfif>>#rsPues.RHPdescpuesto#</option>
        </cfoutput>
        <optgroup label="-------------------------">
            <option value="" style="color:##999" onclick="javascript:ColdFusion.Window.show('newPuesto')">Nuevo Puesto</option>
        </optgroup>
    </select>
</cfif>