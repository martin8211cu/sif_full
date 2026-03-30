<cffunction name="fnDateDiff" output="false" returntype="numeric">
	<cfargument name="LvarPart" type="string">
	<cfargument name="LvarDate1" type="date">
	<cfargument name="LvarDate2" type="date">
	<cfif LvarPart EQ "l">
		<cfobject action="create" type="java" class="java.util.GregorianCalendar" name="LvarDateJ1">
		<cfset LvarDateJ1.init()>
		<cfset LvarDateJ1.setTime(LvarDate1)>
		<cfobject action="create" type="java" class="java.util.GregorianCalendar" name="LvarDateJ2">
		<cfset LvarDateJ2.init()>
		<cfset LvarDateJ2.setTime(LvarDate2)>
		<cfreturn LvarDateJ2.getTimeInMillis()-LvarDateJ1.getTimeInMillis()>
	<cfelse>
		<cfreturn datediff(LvarPart,Lvardate1,Lvardate2)>
	</cfif>
</cffunction>
