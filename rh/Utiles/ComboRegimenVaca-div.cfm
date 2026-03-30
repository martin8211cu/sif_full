<cfparam name="URL.RVid" 		default="-1">
<cfparam name="URL.readonly" 	default="false">
<cfparam name="URL.width" 	    default="auto">
<cfparam name="URL.onchange"    default="">

<cfif isdefined('URL.btnGuardarReg') and isdefined('URL.NewRegCorrecto') and URL.NewRegCorrecto>
	<!---<cfinvoke component="rh.Componentes.Oficina" method="AltaOficina" returnvariable="NewOcodigo">
    	<cfinvokeargument name="Oficodigo" 		value="#URL.NewOficodigo#">
        <cfinvokeargument name="Odescripcion" 	value="#URL.NewOdescripcion#">
    </cfinvoke>--->
    <script>
		<!---refreshtheDivPrintOfi('<cfoutput>#NewOcodigo#</cfoutput>');--->
		ColdFusion.Window.hide('newOficina');
	</script>
</cfif>
<cfif isdefined('url.Print') and url.Print>
    <select name="RVid" onchange="<cfoutput>#URL.onchange#</cfoutput>" style="width:<cfoutput>#URL.width#</cfoutput>" <cfif URL.readonly>disabled</cfif>>
        <cfinvoke component="rh.Componentes.RegimenVaca" method="GetRegimen" returnvariable="rsReg"/>
        <cfoutput query="rsReg">
            <option value="#rsReg.RVid#" <cfif URL.RVid EQ rsReg.RVid>selected</cfif>>#rsReg.Descripcion#</option>
        </cfoutput>
        <optgroup label="-------------------------">
            <option value="" style="color:##999" onclick="javascript:ColdFusion.Window.show('newRegimen')">Nuevo Regimen de Vacaciones</option>
        </optgroup>
    </select>
</cfif>