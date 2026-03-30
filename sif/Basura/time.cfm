<cfset x = Now()>
<cfoutput>#x.getTime()#</cfoutput>

<cfquery datasource="asp" name="x">select getdate() as x</cfquery>
<br>
<cfset x=x.x>
<cfdump var="#x.x.getTime()*1#">