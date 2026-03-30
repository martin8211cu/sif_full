<cfcomponent>
	<cffunction name="toTimeStamp" output="false" access="public" returntype="string">
		<cfargument name="arTimeStamp" type="any" required="true">
		<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>

		<cfif not isArray(arTimeStamp)>
			<cfset ts = "0x00">
			<cfreturn ts>
			<cfexit>
		</cfif>
		<cfset miarreglo=#ListtoArray(ArraytoList(#arguments.arTimeStamp#,","),",")#>
		<cfset miarreglo2=ArrayNew(1)>
		<cfset temp=ArraySet(miarreglo2,1,8,"")>

		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
		</cfloop>

		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 10>
				<cfset miarreglo2[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
			<cfelse>
				<cfset miarreglo2[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
			</cfif>
		</cfloop>
		<cfset temp = #ArrayPrepend(miarreglo2,"0x")#>
		<cfset ts = #ArraytoList(miarreglo2,"")#>
		<cfreturn #ts#>
	</cffunction>
</cfcomponent>