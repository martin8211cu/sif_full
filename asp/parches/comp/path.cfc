<cfcomponent>
	<cffunction name="concat" access="public" returntype="string">
		<cfargument name="dir" type="string" required="yes">
		<cfargument name="file" type="string" required="yes">
		<cfargument name="separator" type="string" required="yes" default="">
		
		<cfset thedir = arguments.dir>
		<cfif Not ListFind('/,\', Right(thedir,1))>
			<cfif Len(arguments.separator)>
				<cfset thedir = thedir & Arguments.separator>
			<cfelse>
				<cfset props = CreateObject("java", "java.lang.System")>
				<cfset thedir = thedir & props.getProperty('file.separator')>
			</cfif>
		</cfif>
		<cfset thefile = arguments.file>
		<cfif ListFind('/,\', thefile)>
			<cfset thefile = ''>
		<cfelseif ListFind('/,\', Left(thefile,1))>
			<cfset thefile = right(thefile,Len(thefile)-1)>
		</cfif>
		
		<cfreturn thedir & thefile>
	</cffunction>

	<cffunction name="concatURL" access="public" returntype="string">
		<cfargument name="dir" type="string" required="yes">
		<cfargument name="file" type="string" required="yes">
		<cfreturn This.concat(dir,file,'/')>
	</cffunction>

</cfcomponent>