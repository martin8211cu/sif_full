
<!---
validar la seguridad
--->
<cfset tabAccess = ArrayNew(1)>
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >
<!---<cfif  Session.Params.ModoDespliegue EQ 1>--->
	<cfset tabAccess[1] = true>
	<cfset tabAccess[2] = true>
	<cfset tabAccess[3] = true>
	<cfset tabAccess[4] = true>	
	<cfset tabAccess[5] = true>	
	<cfset tabAccess[6] = true>	
	<cfset tabAccess[7] = true>	
<!---
<cfelse>
	<cfset tabAccess[1] = acceso_uri(proceso & '/dp')>
	<cfset tabAccess[2] = acceso_uri(proceso & '/df')>
	<cfset tabAccess[3] = acceso_uri(proceso & '/an')>
	<cfset tabAccess[4] = acceso_uri(proceso & '/pc')>
	<cfset tabAccess[5] = acceso_uri(proceso & '/pc')>
</cfif>
--->	

<cfif not tabAccess[form.tab]>
	<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
		<cfif tabAccess[i]>
			<cfset tabChoice = i>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>