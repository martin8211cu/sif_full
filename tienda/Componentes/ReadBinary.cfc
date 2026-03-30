<cfcomponent>

<cffunction name="BinaryString" returntype="string">
	<cfargument name="binaryValue" type="binary">
	
	<cfset var ret_value = '0x'>
	<cfloop from="1" to="#Len(binaryValue)#" index="i">
		<cfif binaryValue[i] GE 0 AND binaryValue[i] LE 15>
			<cfset ret_value = ret_value & "0" & FormatBaseN((binaryValue[i]+256)mod 256,16)>
		<cfelseif binaryValue[i] GT 0 >
			<cfset ret_value = ret_value & FormatBaseN(binaryValue[i],16)>
		<cfelse>
			<cfset ret_value = ret_value & FormatBaseN(binaryValue[i]+256,16)>
		</cfif>
	</cfloop>
	<cfreturn ret_value>
</cffunction>

<cffunction name="upload" returntype="binary">
	<cfargument name="fileField" type="string">
	
	<cfset var ret_value = "">
	<!--- realizar upload --->
	<cffile action="Upload" fileField="#fileField#"
		destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*">
	<!--- guardar foto en una variable --->
	<cffile action="readbinary" file="#GetTempDirectory()##cffile.serverFile#" variable="ret_value" >
	<cffile action="delete" file="#gettempdirectory()##cffile.serverFile#" >
	<cfreturn ret_value>
</cffunction>

</cfcomponent>