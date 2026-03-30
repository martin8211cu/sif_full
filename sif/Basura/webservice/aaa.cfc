<cfcomponent>
	<cffunction name="mult" access="remote" returntype="numeric">
		<cfargument name="x" type="numeric">
		<cfargument name="y" type="numeric">
		
		<cfreturn x*y>
	</cffunction>

	<cffunction name="msg" access="remote" returntype="string">
		<cfargument name="x" type="string">
		
		<cfreturn "msg=#x#">
	</cffunction>

	<cffunction name="msg2" access="remote" returntype="string">
		<cfreturn "OK">
	</cffunction>
	
	<cffunction name="q" access="remote" returntype="query">
	
		<cfquery datasource="asp" name="xxx">
			select SScodigo,SSdescripcion, ts_rversion from SSistemas
		</cfquery>
		
		<cfreturn xxx>
		
	</cffunction>

	
	<cffunction name="s" access="remote" returntype="query">
	
		<cfquery datasource="asp" name="xxx">
			select SScodigo,SSdescripcion, SSlogo from SSistemas
		</cfquery>
		
		<cfreturn xxx>
		
	</cffunction>
	

	
	<cffunction name="wf" access="remote" returntype="query">
	
		<cfquery datasource="nacion" name="xxx">
			select * from WfActivity where ProcessId = 23
		</cfquery>
		
		<cfreturn xxx>
		
	</cffunction>
	
	<cffunction name="st" access="remote" returntype="struct">
	
		<cfset LvarRes.primero = "1">
		<cfset LvarRes.segundo = 2>
		<cfset LvarRes.tercero = 3.5>
		<cfset LvarRes.cuarto = 4>
		<cfset LvarRes.quinto = "">
		<cfset LvarRes.hora = now()>
		
		<cfreturn LvarRes>
		
	</cffunction>

</cfcomponent>