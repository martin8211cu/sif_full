<cfquery datasource="asp" name="rs">
select distinct moduloDebug from APParche where ltrim(rtrim(pnum)) in ('025','026')	
</cfquery>
<!----
 
<cfoutput query="rs">
	<cfif listLen(rs.moduloDebug)>
		<cfloop list="#rs.moduloDebug#" index="i">
			<cfset inser(i)>
		</cfloop>
	<cfelse>
		<cfset inser(rs.moduloDebug)>
	</cfif>
</cfoutput>

<cffunction name="inser">
	<cfargument name="ori" type="string">
	<cfquery datasource="asp">
		insert into ParchePase (ori) values('#arguments.ori#')
	</cfquery>
</cffunction>
---->