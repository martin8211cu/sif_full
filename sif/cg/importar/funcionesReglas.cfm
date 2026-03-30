<cffunction name="agregarGuiones" access="public" output="false" returntype="string">
	<cfargument name="Cmascara" type="string" required="yes">
	<cfargument name="PCRregla" type="string" required="yes">
	<cfargument name="Cmayor" type="string" required="yes">
	<cfargument name="Conexion" type="string" required="no" default="#Session.DSN#">
	
	<!---<cfset result = Arguments.Cmayor>
	<cfset hilera = Arguments.PCRregla>
	<!--- Se asume que la mascara al menos tiene un guión y se elimina el segmento de la máscara que corresponde a la cuenta mayor --->
	<cfset cmascara_rest = Mid(Arguments.Cmascara, FindNoCase("-", Arguments.Cmascara)+1, Len(Arguments.Cmascara))>
	<cfset pos = FindNoCase("-", cmascara_rest)>
	<cfloop condition="pos GT 0">
		<cfset result = result & "-" & Mid(hilera, 1, pos-1)>
		<cfset hilera = Mid(hilera, pos, Len(hilera))>
		<cfset cmascara_rest = Mid(cmascara_rest, pos+1, Len(cmascara_rest))>
		<cfset pos = FindNoCase("-", cmascara_rest)>
	</cfloop>
	<cfset result = result & "-" & hilera>--->
	<cfreturn PCRregla>
</cffunction>
