<cfcomponent>
	<cfproperty name="ActivityId"            type="numeric"   displayname="ActivityId"           hint="">
	<cfproperty name="ProcessId"             type="numeric"   displayname="ProcessId"            hint="">
	<cfproperty name="ApplicationName"       type="string"    displayname="ApplicationName"      hint="">
	<cfproperty name="Execution"             type="string"    displayname="Execution"            hint="">

	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfInvocation">
		<cfset This.ActivityId = 0>
		<cfset This.ProcessId = 0>
		<cfset This.ApplicationName = 0>
		<cfset This.Execution = 'SYNCHR'><!--- SYNCHR/ASYNCHR --->
		<cfset This.RecordCount = 0>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addActualParameter" access="public">
		<cfargument name="ParameterName" type="string" required="yes">
		<cfargument name="Datatype"      type="string" required="yes">
		<cfargument name="Value"         type="string" required="no">
		<cfargument name="DataFieldName" type="string" required="no">
		
		<cfinvoke component="WfActualParameter" method="init" returnvariable="actual_1" />
		<cfset actual_1.ActivityId = This.ActivityId>
		<cfset actual_1.ProcessId = This.ProcessId>
		<cfset actual_1.ApplicationName = This.ApplicationName>
		<cfset actual_1.ParameterName = Arguments.ParameterName>
		<cfset actual_1.Datatype = Arguments.Datatype>
		<cfif IsDefined('Arguments.Value')>
			<cfset actual_1.Value = Arguments.Value>
		</cfif>
		<cfif IsDefined('Arguments.DataFieldName')>
			<cfset actual_1.DataFieldName = Arguments.DataFieldName>
		</cfif>
		<cfset actual_1.update()>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfInvocation" access="public">
		<cfargument name="ActivityId"    type="numeric" required="yes">
		<cfargument name="ApplicationName" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfInvocation
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityId#">
			  and ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ApplicationName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfquery datasource="#session.dsn#" name="existe">
			select ApplicationName
			from  WfInvocation
			WHERE ActivityId = <cfqueryparam value='#This.ActivityId#' cfsqlType='cf_sql_numeric'>
			  AND ApplicationName = <cf_jdbcquery_param value='#This.ApplicationName#' cfsqlType='cf_sql_varchar' len='20'>
		</cfquery>
		<cfif existe.RecordCount>
			<cfquery datasource="#session.dsn#">
				UPDATE WfInvocation
				   SET ProcessId = <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
					   Execution = <cfqueryparam value='#This.Execution#' cfsqlType='cf_sql_varchar'>
				 WHERE ActivityId = <cfqueryparam value='#This.ActivityId#' cfsqlType='cf_sql_numeric'>
				   AND ApplicationName = <cfqueryparam value='#This.ApplicationName#' cfsqlType='cf_sql_varchar'>
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfInvocation
					   ( ActivityId
					   , ProcessId
					   , ApplicationName
					   , Execution
					   )
				VALUES ( <cfqueryparam value='#This.ActivityId#' cfsqlType='cf_sql_numeric'>
					   , <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
					   , <cf_jdbcquery_param value='#This.ApplicationName#' cfsqlType='cf_sql_varchar' len='20'>
					   , <cfqueryparam value='#This.Execution#' cfsqlType='cf_sql_varchar'>
					   )
			</cfquery>
			<cfset This.RecordCount = 1>
		</cfif>
	</cffunction>

</cfcomponent>