<cfset LvarNumero = '000a123001'>
<cfset LvarBandera = true>
<cfset LvarC = 1>
<cfset LvarCadenaNueva = 'NADA'>


<cfloop condition="LvarBandera eq true">
	<cfset LvarStrip = FindNoCase(0,LvarNumero,LvarC)>
    
    <cfif LvarStrip eq 0>
    	<cfset LvarBandera = false>

        <cfoutput>LvarStrip: #LvarStrip#</cfoutput><br />

        <cfset LvarCadenaNueva = mid(LvarNumero,LvarC -1,Len(LvarStrip))>
        <cfoutput>#LvarCadenaNueva#</cfoutput><br />
    </cfif>
    
    <cfset LvarC = LvarC + 1>
</cfloop>

<cfoutput>#LvarCadenaNueva#</cfoutput>





