<cfcomponent>
	<cffunction name="nextVal" access="remote" returntype="string">
		<cfargument name="ORI"				type="string"	required="yes">
		<cfargument name="REF"				type="string"	required="yes">
		<cfargument name="Ecodigo"			type="numeric"	required="yes">
		<cfargument name="datasource"		type="string"	required="yes">

		<cftry>
			<cfinvoke 	component		= "sif.Componentes.OriRefNextVal"
						method			= "nextVal"
						returnvariable	= "LvarNextVal"
						
						ORI				= "#Arguments.ORI#"
						REF				= "#Arguments.REF#"
						Ecodigo			= "#Arguments.Ecodigo#"
						datasource		= "#Arguments.datasource#"
						otraTransaccion	= "False"
			/>
			
			<cfreturn numberFormat(LvarNextVal,"__________________")>
		<cfcatch type="any">
			<cfset LvarWSsec = createobject("component","sif.Componentes.WS.WSsecurity")>
			<cfthrow object="#LvarWSsec.setWSerror(cfcatch)#"> 
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>

