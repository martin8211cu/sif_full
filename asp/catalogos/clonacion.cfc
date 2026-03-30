
<cfcomponent>
	<cffunction name="getDSND" access="remote" returntype="array">
	    <cfargument name="EcodigoO" type="string" required="yes">
		<cfargument name="lista" type="string" required="yes">
		
		<cfset var result=ArrayNew(2)>
        <cfset var i=1>
	  	
		<cfset result[1][1]= ''>
		<cfset result[1][2]= '-- Seleccione --'>	
			
			<cfif len(trim(arguments.EcodigoO))>
				<cfloop index="i" from="1" to="#listlen(arguments.lista,',')#">
					<cfset result[i+1][1]= listGetAt(arguments.lista,i,',')>
					<cfset result[i+1][2]= listGetAt(arguments.lista,i,',')>
				</cfloop>
			</cfif>
		  	<cfreturn result>	
	</cffunction>
	
	<cffunction name="getED" access="remote" returntype="array">
	    <cfargument name="CEcodigoO" type="string" required="yes">
		<cfargument name="DSNO" type="string" required="yes">
		<cfargument name="EcodigoO" type="string" required="yes">
		<cfargument name="DSND" type="string" required="yes">
		<cfargument name="CEcodigoD" type="string" required="yes">
	  	
		<cfset var rsED="">
        <cfset var result=ArrayNew(2)>
        <cfset var i=0>
	  	
		<cfset result[1][1]= ''>
		<cfset result[1][2]= '-- Seleccione --'>

		<cfif isdefined('Arguments.CEcodigoO') and len(trim(Arguments.CEcodigoO))
			and isdefined('Arguments.DSNO') and len(trim(Arguments.DSNO))
			and isdefined('Arguments.EcodigoO') and len(trim(Arguments.EcodigoO))
			and isdefined('Arguments.DSND') and len(trim(Arguments.DSND))>
				
			<cfquery name="rsED" datasource="#Arguments.DSND#">
				select Ecodigo, Edescripcion
					from Empresas
						where cliente_empresarial = #Arguments.CEcodigoD#
					order by Edescripcion
			</cfquery>
       	
			<!--- Convert results to array --->
			<cfloop index="i" from="1" to="#rsED.RecordCount#">
				<cfset result[i+1][1]=rsED.Ecodigo[i]>
				<cfset result[i+1][2]=rsED.Edescripcion[i]>
			</cfloop>
		</cfif>
		<cfreturn result>	
	</cffunction>
	
	<cffunction name="getEO" access="remote" returntype="array">
	    <cfargument name="DSNO" type="string" required="no" default="">
		<cfargument name="CEcodigoO" type="string" required="yes">
	  	
		<cfset var rsEO="">
        <cfset var result=ArrayNew(2)>
        <cfset var i=0>
	  		
		<cfset result[1][1]= ''>
		<cfset result[1][2]= '-- Seleccione --'>
		
		<cfif isdefined('Arguments.DSNO') and len(trim(Arguments.DSNO))>	
		
			<cfquery name="rsEO" datasource="#Arguments.DSNO#">
				select Ecodigo, Edescripcion
					from Empresas
						where cliente_empresarial = #Arguments.CEcodigoO#
					order by Edescripcion
			</cfquery>
			
			<cfloop index="i" from="1" to="#rsEO.RecordCount#">
				<cfset result[i+1][1]=rsEO.Ecodigo[i]>
				<cfset result[i+1][2]=rsEO.Edescripcion[i]>
			</cfloop>
		</cfif>			
		<cfreturn result>	
	</cffunction>
	
	<cffunction name="getSSO" access="remote" returntype="array">
	  <cfargument name="DSN" type="any" required="no" default="asp">
	  	<cfset var rsSSO="">
        <cfset var result=ArrayNew(2)>
        <cfset var i=0>
	  	
		<cfset result[1][1]= ''>
		<cfset result[1][2]= '-- Seleccione --'>
		
		<cftry>
			<cfquery name="rsSSO" datasource="#ARGUMENTS.DSN#">
				select SScodigo, SSdescripcion
					from SSistemas
					order by SScodigo
			</cfquery>
			
        	<!--- Convert results to array --->
			<cfloop index="i" from="1" to="#rsSSO.RecordCount#">
				<cfset result[i+1][1]=rsSSO.SScodigo[i]>
				<cfset result[i+1][2]=rsSSO.SSdescripcion[i]>
			</cfloop>
			
		  	<cfreturn result>
		<cfcatch type="any">
			<cfset result[1][1]= ''>
			<cfset result[1][2]= '-- Seleccione --'>
						
		</cfcatch>
		</cftry>	
	</cffunction>
	
	<cffunction name="getCED" access="remote" returntype="array">
	  <cfargument name="CEcodigoO" type="string" required="no" default="">
	  <cfargument name="EcodigoO" type="string" required="no" default="">
	  <cfargument name="DSNO" type="string" required="no" default="">
	  <cfargument name="DSND" type="string" required="no" default="">
	  	
		<cfset var rsCED="">
        <cfset var result=ArrayNew(2)>
        <cfset var i=1>
		
		<cfset result[1][1]= ''>
		<cfset result[1][2]= '-- Seleccione --'>
						
			<cfif  isdefined('Arguments.DSNO') and len(trim(Arguments.DSNO))
			and isdefined('Arguments.DSND') and len(trim(Arguments.DSND))>	
					
					<cftry>
						<cfquery name="rsCED" datasource="asp">
							select CEcodigo, CEnombre
								from CuentaEmpresarial
									where CEcodigo in (select cliente_empresarial from <cf_dbdatabase table="Empresas" datasource="#Arguments.DSND#">)
								order by CEnombre
						</cfquery>	
						
						
						
						<cfloop index="i" from="1" to="#rsCED.RecordCount#">
							<cfset result[i+1][1]=rsCED.CEcodigo[i]>
							<cfset result[i+1][2]=rsCED.CEnombre[i]>
						</cfloop>
					<cfcatch type="any">
						<cfset result[1][1]= ''>
						<cfset result[1][2]= '-- Seleccione --'>
					</cfcatch>
					</cftry>
			</cfif>
			
		<cfreturn result>
	</cffunction>
	
	<cffunction name="getCEO" access="remote" returntype="array">
	  <cfargument name="DSNO" type="string" required="no" default="">
	  	
		<cfset var rsCEO="">
        <cfset var result=ArrayNew(2)>
        <cfset var i=1>
		
		<cfset result[1][1]= ''>
		<cfset result[1][2]= '-- Seleccione --'>
		
			<cfif isdefined("Arguments.DSNO") and len(trim(Arguments.DSNO)) GT 0>
				<cftry>
						<cfquery name="rsCEO" datasource="asp">
							select CEcodigo, CEnombre
								from CuentaEmpresarial
									where CEcodigo in (select cliente_empresarial from <cf_dbdatabase table="Empresas" datasource="#Arguments.DSNO#">)
								order by CEnombre
						</cfquery>

						<cfloop index="i" from="1" to="#rsCEO.RecordCount#">
							<cfset result[i+1][1]=rsCEO.CEcodigo[i]>
							<cfset result[i+1][2]=rsCEO.CEnombre[i]>
						</cfloop>
					<cfcatch type="any">
						<cfset result[1][1]= ''>
						<cfset result[1][2]= '-- Seleccione --'>
					</cfcatch>
				</cftry>
				
			</cfif>
			
		<cfreturn result>
	</cffunction>	
</cfcomponent>