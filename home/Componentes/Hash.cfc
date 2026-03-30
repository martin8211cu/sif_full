<cfcomponent>

	<!--- funciones auxiliares a la implementación --->
	
	<cffunction name="hashPassword" access="package" returntype="string" output="false">
		<cfargument name="hashMethod"   type="string"  required="yes">
		<cfargument name="passwd"     type="string"  required="yes">
		<cfargument name="uid"          type="string"  required="yes">
		<cfargument name="CEcodigo"     type="numeric" required="yes">
		<cfargument name="passwdSalt" type="string"  required="yes">
		
		<cfif Arguments.CEcodigo GT 1>
			<!--- este if existe para que los passwords que migremos del framework viejo sirvan --->
			<cfset Arguments.uid = Arguments.uid & '##' & CEcodigo>
		</cfif>
		<cfset instr = Arguments.passwd & "$$" & Arguments.uid & "$$" & Arguments.passwdSalt>
		<cfreturn this.__hash( instr, Arguments.hashMethod )>
	</cffunction>
	
	<cffunction name="__hash" access="package" returntype="string" output="false">
		<cfargument name="data"       type="string" required="yes">
		<cfargument name="hashMethod" type="string" required="yes">

		<cfset md = CreateObject("java", "java.security.MessageDigest")>
		<cfset md = md.getInstance(Arguments.hashMethod)>
		<cfset md.update(Arguments.data.getBytes())>
		<cfreturn this.__decodeHexStr( md.digest() )>
	</cffunction>
	
	<cffunction name="__decodeHexStr" access="package" returntype="string" output="false">
		<cfargument name="byte_array" type="any" required="true">
		
		<cfset var Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f")>
		<cfset var miarreglo=#ListtoArray(ArraytoList(#arguments.byte_array#,","),",")#>
		<cfset var arreglo_ret=ArrayNew(1)>

		<cfif not isArray(arguments.byte_array)>
			<cfreturn "">
		</cfif>

		<cfloop index="i" from="1" to="#ArrayLen(miarreglo)#">
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
			<cfif miarreglo[i] LT 16>
				<cfset arreglo_ret[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
			<cfelse>
				<cfset arreglo_ret[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
			</cfif>
		</cfloop>
		<cfreturn ArraytoList(arreglo_ret,"")>
	</cffunction>
</cfcomponent>