<cfdump var="#ThisTag#">
<cfoutput>#ThisTag.toString()#
<cfif ListFindNoCase(GetBaseTagList(),'cftransaction') is 0><cf_errorCode	code = "50722" msg = "Deben llamarme desde una trasaccion"></cfif>

</cfoutput>

