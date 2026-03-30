<!---Componente para el manejo de los Widgets--->
<cfcomponent>
	
	<cffunction name="ObtenerValor"  access="remote" returntype="string">
		<cfargument name="Widget" 	type="string"    required="yes">
		<cfargument name="Pcodigo" 	type="string"    required="yes">
		<cfargument name="Ecodigo" 	type="string"    required="no"	default="#Session.Ecodigo#">
		
		<cfset result="">

		<cfquery name="rsWidget" datasource="asp">
			select WidID, WidParentId from Widget
			where WidID = (select WidID from Widget where WidCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Widget)#">)
		</cfquery>	

		<cfquery name="rsParam" datasource="asp">
			select Pvalor from WidgetParametros
			where WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsWidget.WidID#">
				and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Pcodigo)#">
				<!--- and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Arguments.Ecodigo)#"> --->
		</cfquery>

		<cfif rsParam.recordCount EQ 0 and rsWidget.WidParentId NEQ "">
			<cfquery name="rsParam2" datasource="asp">
				select Pvalor from WidgetParametros
				where WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsWidget.WidParentId#">
					and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.Pcodigo)#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Arguments.Ecodigo)#">
			</cfquery>
			<cfif rsParam.recordCount GT 0>
				<cfset result=rsParam2.Pvalor>
			</cfif>
		<cfelse>
			<cfset result=rsParam.Pvalor>
		</cfif>
		<cfreturn result>		 
	</cffunction>

	<cffunction name="GetURLConfig" access="remote" returntype="string">
		<cfargument name="WidID" 	type="string"    required="yes">

		<cfset varWidID = #Arguments.WidID#>
		
		<cfset result = ''>

		<!---Valida si es copia u original--->
		<cfquery name="rsValidaOriginal" datasource = "asp">
			SELECT ltrim(rtrim(WidParentId)) as WidParentId, WidCodigo
			FROM Widget
			WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
		</cfquery>

		<cfif isdefined('rsValidaOriginal') and rsValidaOriginal.WidParentId EQ ''>
			<cfset result = #rsValidaOriginal.WidCodigo#>
		<cfelse>
			<cfset varWidParentId = #rsValidaOriginal.WidParentId#>

			<cfquery name="rsValidaOriginal" datasource = "asp">
				SELECT ltrim(rtrim(WidParentId)) as WidParentId, WidCodigo
				FROM Widget
				WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidParentId#">
			</cfquery>

			<cfset result = #rsValidaOriginal.WidCodigo#>
		</cfif>

		<cfset result ="../../../commons/widgets/#result#/config.cfm">

		<cfreturn result>
	</cffunction>

</cfcomponent>