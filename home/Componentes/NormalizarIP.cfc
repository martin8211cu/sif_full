<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document">
	<cffunction name="NormalizarIP" output="false" returntype="string">
		<cfargument name="direccion">
		
		<cfset var i = 0>
		
		<cfif Len(direccion) EQ 0>
			<cfreturn direccion>
		</cfif>
		
		<cfset partes = ListToArray(direccion, '.:')>
		<cfif ArrayLen(partes) is 4>
			<cfset separador = '.'>
			<cfset longitud = 3>
		<cfelseif ArrayLen(partes) is 8>
			<cfset separador = ':'>
			<cfset longitud = 4>
		<cfelse>
			<cfthrow message="La dirección es inválida: #Arguments.direccion#.  Debe estar en formato numérico 0.0.0.0 (IPv4) ó 0:0:0:0:0:0:0:0 (IPv6)">
		</cfif>
		
		<cfloop from="1" to="#ArrayLen(partes)#" index="i">
			<cfif Len(partes[i]) LT longitud>
				<cfset partes[i] = RepeatString('0', longitud - Len(partes[i])) & partes[i]>
			</cfif>
			<cfif Len(partes[i]) GT longitud>
				<cfthrow message="Los dígitos son inválidos: #Arguments.direccion#.  Debe estar en formato numérico 0.0.0.0 (IPv4) ó 0:0:0:0:0:0:0:0 (IPv6)">
			</cfif>
		</cfloop>
		
		<cfreturn ArrayToList(partes, separador)>
		
	</cffunction>
	
</cfcomponent>