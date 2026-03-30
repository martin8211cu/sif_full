<cfparam name="URL.RHJid" 	 default="-1">
<cfparam name="URL.readonly" default="false">
<cfparam name="URL.width" 	 default="auto">
<cfparam name="URL.onchange" default="">

<cfif isdefined('URL.btnGuardarJor') and isdefined('URL.NewJorCorrecto') and URL.NewJorCorrecto>
	
    <cfinvoke component="rh.Componentes.Jornada" method="AltaJornada" returnvariable="NewRHJid">
            <cfinvokeargument name="RHJcodigo" 		value="#URL.NewRHJcodigo#">
            <cfinvokeargument name="RHJdescripcion" value="#URL.NewRHJdescripcion#">
        <cfif isdefined('URL.RHJsun')>
        	<cfinvokeargument name="RHJsun" value="#URL.RHJsun#">
        </cfif>
		<cfif isdefined('URL.RHJmon')>
       		<cfinvokeargument name="RHJmon" value="#URL.RHJmon#">
        </cfif>
		<cfif isdefined('URL.RHJtue')>
        	<cfinvokeargument name="RHJtue" value="#URL.RHJtue#">
        </cfif>
		<cfif isdefined('URL.RHJwed')>
       		<cfinvokeargument name="RHJwed" value="#URL.RHJwed#">
        </cfif>
		<cfif isdefined('URL.RHJthu')>
        	<cfinvokeargument name="RHJthu" value="#URL.RHJthu#">
        </cfif>
		<cfif isdefined('URL.RHJfri')>
        	<cfinvokeargument name="RHJfri" value="#URL.RHJfri#">
        </cfif>
		<cfif isdefined('URL.RHJsat')>
        	<cfinvokeargument name="RHJsat" value="#URL.RHJsat#">
        </cfif>
    </cfinvoke>
    <script>
		refreshtheDivPrintJor('<cfoutput>#NewRHJid#</cfoutput>');
		ColdFusion.Window.hide('newJornada');
	</script>
</cfif>
<cfif isdefined('url.Print') and url.Print>
    <select name="RHJid" onchange="<cfoutput>#URL.onchange#</cfoutput>" style="width:<cfoutput>#URL.width#</cfoutput>" <cfif URL.readonly>disabled</cfif>>
        <cfinvoke component="rh.Componentes.Jornada" method="GetJornada" returnvariable="rsJor">
        </cfinvoke>
        <cfoutput query="rsJor">
            <option value="#rsJor.RHJid#" <cfif URL.RHJid EQ rsJor.RHJid>selected</cfif>>#rsJor.RHJdescripcion#</option>
        </cfoutput>
        <optgroup label="-------------------------">
            <option value="" style="color:##999" onclick="javascript:ColdFusion.Window.show('newJornada')">Nueva Jornada</option>
        </optgroup>
    </select>
</cfif>