<cfparam name="URL.CFid" 		default="-1">
<cfparam name="URL.Ocodigo" 	default="-1">
<cfparam name="URL.Dcodigo" 	default="-1">
<cfparam name="URL.readonly"	default="false">
<cfparam name="URL.width" 	    default="auto">

<cfif isdefined('URL.btnGuardarCF') and isdefined('URL.NewCFCorrecto') and URL.NewCFCorrecto>
	<cfinvoke component="rh.Componentes.CentroFuncional" method="AltaCentroFuncional" returnvariable="NewCFid">
    	<cfinvokeargument name="CFcodigo" 		value="#URL.NewCFcodigo#">
        <cfinvokeargument name="Dcodigo" 		value="#URL.NewCFDcodigo#">
        <cfinvokeargument name="Ocodigo" 		value="#URL.NewCFOcodigo#">
        <cfinvokeargument name="CFdescripcion" 	value="#URL.NewCFdescripcion#">
    </cfinvoke>
    <script>
		refreshtheDivPrintCF('<cfoutput>#NewCFid#</cfoutput>', -1);
		ColdFusion.Window.hide('newCentroFuncional');
	</script>
</cfif>
<cfif isdefined('url.print') and url.print>
<select id="CFid" style="width:<cfoutput>#URL.width#</cfoutput>" name="CFid" <cfif URL.readonly>disabled</cfif> <cfif isdefined('URL.onChange') and len(trim(URL.onChange))>onchange="<cfoutput>#URL.onChange#</cfoutput>"</cfif>>
	<cfinvoke component="rh.Componentes.CentroFuncional" method="getCentroFuncional" returnvariable="rsCf"></cfinvoke>
	<cfoutput query="rsCf">
    	<option value="#rsCf.CFid#" <cfif URL.CFid EQ rsCf.CFid>selected</cfif>>#rsCf.CFdescripcion#</option>
    </cfoutput>
    <cfif isdefined('Attributes.Agregar') and Attributes.Agregar>
        <optgroup label="-------------------------">
            <option value="" style="color:##999" onclick="javascript:ColdFusion.Window.show('newCentroFuncional')">Nuevo Centro Funcional</option>
        </optgroup>
    </cfif>
</select>
</cfif>
