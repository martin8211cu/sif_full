
<!---
	Ver documentación para Seguridad.cfc
--->
<cfcomponent extends="SeguridadASP">

	<cfset This.HashMethod = "MD5">

	<cffunction name="autenticar" access="remote" returntype="boolean" output="false">
		<!--- override, mantener privado --->
		<cfargument name="Usucodigo" type="numeric" required="true">
		<cfargument name="passwordtext"  type="string"  required="true">

        <cfreturn _AUTENTICAR_BACKEND( Usucodigo=arguments.Usucodigo, passwordtext=arguments.passwordtext)>
        
	</cffunction>

	


</cfcomponent>

