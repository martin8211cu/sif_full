<cffunction name="sustituir_uno" access="private" output="false" returntype="string">
	<cfargument name="sqlstring" type="string" required="yes">
	<cfargument name="variable_name" type="string" required="yes">
	<cfargument name="value" type="string" required="yes">
	<cfargument name="datatype" type="string" required="yes">
	
	<cfif ListFind('numeric,int,float,money,datetime',Arguments.datatype )>
		<cfset formatted_value = Arguments.value >
	<cfelseif ListFind('varchar', Arguments.datatype )>
		<cfset formatted_value = "'" & Replace(Arguments.value, "'", "''", "all") & "'">
	<cfelse>
		<cfthrow message="datatype inválido para sustitución: #Arguments.variable_name# #Arguments.datatype#">
	</cfif>
	
	<cfset ret_value = Replace(ret_value, "##" & Arguments.variable_name & "##", formatted_value, 'all')>
	<cfset ret_value = Replace(ret_value, "@" & Arguments.variable_name, formatted_value, 'all')>
	<cfreturn ret_value>
</cffunction>

<cffunction name="sustituir" access="public" output="false" returntype="string">
	<cfargument name="sql_string" type="string" required="yes">
	<cfargument name="param_values" type="struct" required="yes">
	<cfargument name="param_info" type="query" required="yes">

	<cfset ret_value = Arguments.sql_string>
	<cfloop query="param_info">
		<cfif Not StructKeyExists(Arguments.param_values, param_info.DInombre)>
			<cfthrow message="Parámetro sin definir: #param_info.DInombre#">
		<cfelse>
			<cfset the_value = Arguments.param_values[param_info.DInombre] >
			<cfif (param_info.DItipo EQ "numeric" or 
				   param_info.DItipo EQ "int" or  
				   param_info.DItipo EQ "float" or  
				   param_info.DItipo EQ "money") and 
				   not IsNumeric(the_value)>
				<cfthrow message="El parámetro ""#param_info.DInombre#"" debe ser numérico, y su valor es ""#the_value#""">
			<cfelseif param_info.DItipo EQ "datetime" and Not IsDate(the_value)>
				<cfthrow message="El parámetro ""#param_info.DInombre#"" debe ser fecha, y su valor es ""#the_value#""">
			</cfif>
		</cfif>
		<cfset ret_value = sustituir_uno(ret_value, param_info.DInombre, the_value, param_info.DItipo)>
	</cfloop>
	
	<cfset ret_value = sustituir_uno(ret_value, "Ecodigo", session.Ecodigo, "int")>

	<cfset ret_value = sustituir_uno(ret_value, "Usulogin", session.usuario, "varchar")>

	<cfset ret_value = sustituir_uno(ret_value, "Usucodigo", session.Usucodigo, "numeric")>
	
	<cfset ret_value = sustituir_uno(ret_value, "Ulocalizacion", "00", "varchar")>
	
	<cfreturn ret_value>
</cffunction>
