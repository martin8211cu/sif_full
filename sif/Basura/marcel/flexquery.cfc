<cfcomponent>
	<cffunction name="dEmpresasxml"  access="remote" output="true" returntype="string">
		<cfquery name="rs" datasource="minisif">
			select * from Empresas
		</cfquery>
		<cfset rsxml = "">
		<cfxml casesensitive="yes" variable="rsxml">
		<empresas>
			<empresa>
				<cfoutput query="rs">
					<nombre>
						#Edescripcion#
					</nombre>
				</cfoutput> 
			</empresa>
		</empresas>	
		</cfxml>
		<cfreturn rsxml>
	</cffunction>
	
	<cffunction name="dEmpresas"  access="remote" output="true" returntype="query">
		<cfquery name="rs" datasource="minisif">
			select * from Empresas
		</cfquery>
		<cfreturn rs>
	</cffunction>


	
</cfcomponent>