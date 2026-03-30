<cfif isdefined("url.tabidname") and isdefined("url.tabid")> 
	<cf_navegacion name="#url.tabidname#" value="#url.tabid#" session="tabs" navegacion>
</cfif>