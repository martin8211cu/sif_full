<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document">
	<cffunction name="normalizar_ip" output="false" returntype="string">
		 <cfargument name="direccion" type="string" required="Yes"  displayname="Direccion">
		
		<cfif Len(Arguments.direccion) EQ 0>
			<cfreturn Arguments.direccion>
		</cfif>
		
		<cfset partes = ListToArray(Arguments.direccion, '.')>
		<cfif ArrayLen(partes) NEQ 4>
			<cfthrow message="Dirección IPv4 inválida: #Arguments.direccion#.  Debe estar en formato numérico 0.0.0.0">
		</cfif>
		
		<cfloop from="1" to="#ArrayLen(partes)#" index="i">
			<cfif Len(partes[i]) LT 3>
				<cfset partes[i] = RepeatString('0', 3 - Len(partes[i])) & partes[i]>
			</cfif>
			<cfif Len(partes[i]) GT 3>
				<cfthrow message="Dirección IPv4 inválida: #Arguments.direccion#.  Debe estar en formato numérico 0.0.0.0">
			</cfif>
		</cfloop>
		
		<cfreturn ArrayToList(partes, '.')>
		
	</cffunction>
	
</cfcomponent>