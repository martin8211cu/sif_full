<cfcomponent output="no">

<cffunction name="preview">
	<cfargument name="texto">	
	<cfargument name="id" type="numeric" required="yes">
	<cfargument name="attach" type="query" required="yes">
	
	<cfset ret = texto>
	<cfset ret = REReplaceNoCase(ret, '.*<body>', '', 'all')>
	<cfset ret = REReplaceNoCase(ret, '</body>.*', '', 'all')>
	<cfloop query="attach">
	<cfif Len(attach.SMTPcontentid)>
	<cfset ret = REReplaceNoCase(ret, 'cid:' & HTMLEditFormat( attach.SMTPcontentid ),
		'?id=#id#&amp;nom=#HTMLEditFormat( URLEncodedFormat( attach.SMTPnombre))#', 'all')>
	</cfif>
	</cfloop>
	<cfset ret = REReplaceNoCase(ret, 'cid:[A-Za-z0-9_-]*' , '', 'all')>
	<cfoutput>#ret#</cfoutput>
	
</cffunction>
</cfcomponent>