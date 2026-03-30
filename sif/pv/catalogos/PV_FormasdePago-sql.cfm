<cfif IsDefined("form.Cambio")>

		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAP000"
				redirect="Parametros.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#Session.Ecodigo#">
	
	<cfset hilera = ArrayNew(1)>

	<cfset hilera[1] = "0">
	<cfset hilera[2] = "0">
	<cfset hilera[3] = "0">
	<cfset hilera[4] = "0">	
	<cfset hilera[5] = "0">	
	<cfset hilera[6] = "0">	
	<cfset hilera[7] = "0">	
	<cfset hilera[8] = "0">	
	<cfset hilera[9] = "0">	
	<cfset hilera[10] = "0">							
	
				
	<cfloop list="#form.FAPFOPG#" delimiters="," index="indice">
		<cfset hilera[indice] = "1">
	</cfloop>
	
		
	<cfset ValorFinal = "">
	<cfloop from="1" to="#arraylen(hilera)#" index="ind1">
		<cfset ValorFinal = #trim(ValorFinal)# & #trim(hilera[ind1])#>
	</cfloop>	
					
	<cfquery name="update" datasource="#session.DSN#">
	
		update FAP000 
		set
			FAPFOPG = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ValorFinal#">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				
	</cfquery> 

	<cflocation url="Parametros.cfm?o=3">

</cfif>