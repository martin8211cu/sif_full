<cfset LvarMayor = '320'>
<cfoutput>#LvarMayor#</cfoutput><br />

<cfset LvarMayor = right("0000" & trim(LvarMayor), 4)>
<cfoutput>#LvarMayor#</cfoutput><br />


<cfset LvarMayor = right("0320", 4)>
<cfoutput>#LvarMayor#</cfoutput><br />