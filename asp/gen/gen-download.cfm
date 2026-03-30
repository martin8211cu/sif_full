<cfprocessingdirective suppresswhitespace="no"
><cfoutput>#'<'#cfparam name="url.f" default="">
<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="j"><cfif i mod 4 is 1>
</cfif>#'<'#cfparam name="url.#metadata.pk.cols[j].code#"></cfloop>
<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif metadata.cols[i].type EQ 'image' And Not ListFind('Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].name)>#
'<'#cfif url.f EQ '#metadata.cols[i].code#'>
	#'<'#cfquery datasource="##session.dsn##" name="download_query">
		select #metadata.cols[i].code#
		from #metadata.code#
		<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="j"><cfif i mod 4 is 1>
		</cfif><cfif j gt 1>  and <cfelse>where </cfif>#metadata.pk.cols[j].code# = #createqueryparam_for_where(metadata.pk.cols[j], true, 'url')#</cfloop>
	#'<'#/cfquery>
	#'<'#cfcontent variable="##download_query.#metadata.cols[i].code###" reset="yes" type="image/gif">
#'<'#/cfif></cfif></cfloop>
#'<'#cfheader statuscode="404" statustext="Download Not Found (#metadata.code#)">
</cfoutput>
</cfprocessingdirective>