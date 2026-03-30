<cfcomponent displayname="ComprasToken" rest="true" restPath="/common" produces="application/json">

	<cffunction name="obtenerToken" restPath="/token" access="remote"   httpMethod="GET" returntype="struct" returnformat="JSON" produces="application/json">
		<cfargument name="usuario"  required="no"  type="string" restArgName="usuario"  restArgSource="query" default="">
 		<cfargument name="password" required="no"  type="string" restArgName="password" restArgSource="query" default="">

 		<cfset WSGetToken = createObject("component","crc.Componentes.compra.WSGetToken")>
 		<cfreturn WSGetToken.getToken(usuario=arguments.usuario, password= arguments.password)>

	</cffunction>

 

</cfcomponent>