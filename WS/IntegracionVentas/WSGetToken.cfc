<!---
  --- WSGetToken
  --------------
  --- Description WS que servira como seguridad de acceso a WSClientesVentas.cfc
  --- Author Ing. Oscar Orlando Parrales Villanueva
  --- Date   2018/09/06
 --->
<cfcomponent>

	<cffunction name="getToken" access="remote" returntype="string">
		<cfargument name="usuario" default="SampleUserLD" required="false" Type="String">
		<cfargument name="password" default="UnPassSample015O1NLD" required="FALSE" Type="String">
		<cfreturn #tokenPrivado(unUsu=usuario,unPass=password)#>
	</cffunction>

	<cffunction name="tokenPrivado" access="private" returntype="string">
		<cfargument name="unUsu" required="true" Type="String">
		<cfargument name="unPass" required="true" Type="String">
		<cfset token = hash(LSTimeFormat(now(),'HH')&unUsu&unPass,"MD5","utf-8")>
		<cfreturn token>
	</cffunction>

</cfcomponent>