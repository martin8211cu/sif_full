<cfcomponent>
<cffunction name="Fecha" returntype="string">
	<cfargument name="Formato" type="any" default="dd/mm/yy">
	
	<cfset salida = DateFormat(Now(),"#Formato#" )>
	<cfreturn "#salida#">
</cffunction>
<cffunction name="Negrita" returntype="string">
	<cfargument name="Texto" type="String" default="">
	
	<cfset salida = "<strong>" & Texto & "</strong>">
	<cfreturn #salida#>
</cffunction>	
</cfcomponent>