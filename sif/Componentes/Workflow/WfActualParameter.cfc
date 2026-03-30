<cfcomponent>
	<cfproperty name="ProcessId"             type="numeric"  displayname="ProcessId"             hint="">
	<cfproperty name="ActivityId"            type="numeric"  displayname="ActivityId"            hint="">
	<cfproperty name="ApplicationName"       type="string"   displayname="ApplicationName"       hint="">
	<cfproperty name="ParameterName"         type="string"   displayname="ParameterName"         hint="">
	<cfproperty name="Value"                 type="string"   displayname="Value"                 hint="">
	<cfproperty name="DataFieldName"         type="string"   displayname="DataFieldName"         hint="">
	<cfproperty name="Datatype"              type="string"   displayname="Datatype"              hint="">

	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfActualParameter">
		<cfset This.ProcessId = 0>
		<cfset This.ActivityId = 0>
		<cfset This.ApplicationName = ''>
		<cfset This.ParameterName = ''>
		<cfset This.Value = ''>
		<cfset This.DataFieldName = ''>
		<cfset This.Datatype = 'STRING'> <!--- STRING/NUMERIC/XML/FILE --->
		<cfset This.RecordCount = 0>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfActualParameter" access="public">
		<cfargument name="ActivityId"      type="numeric" required="yes">
		<cfargument name="ApplicationName" type="string" required="yes">
		<cfargument name="ParameterName"   type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfActualParameter
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityId#">
			  and ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ApplicationName#">
			  and ParameterName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ParameterName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfif This.RecordCount>
			<cfquery datasource="#session.dsn#">
				UPDATE WfActualParameter
				   SET Value = <cfqueryparam value='#This.Value#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Value)) is 0#'>
					 , DataFieldName = <cfqueryparam value='#This.DataFieldName#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.DataFieldName)) is 0#'>
					 , Datatype = <cfqueryparam value='#This.Datatype#' cfsqlType='cf_sql_varchar'>
				 WHERE WfActualParameter.ActivityId = <cfqueryparam value='#This.ActivityId#' cfsqlType='cf_sql_numeric'> 
				   AND WfActualParameter.ApplicationName = <cfqueryparam value='#This.ApplicationName#' cfsqlType='cf_sql_varchar'>
				   AND WfActualParameter.ParameterName = <cfqueryparam value='#This.ParameterName#' cfsqlType='cf_sql_varchar'>
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfActualParameter
					   ( ProcessId
					   , ActivityId
					   , ApplicationName
					   , ParameterName
					   , Value
					   , DataFieldName
					   , Datatype
					   )
				VALUES ( <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
					   , <cfqueryparam value='#This.ActivityId#' cfsqlType='cf_sql_numeric'>
					   , <cf_jdbcquery_param value='#This.ApplicationName#' cfsqlType='cf_sql_varchar' len='20'>
					   , <cfqueryparam value='#This.ParameterName#' cfsqlType='cf_sql_varchar'>
					   , <cfqueryparam value='#This.Value#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Value)) is 0#'>
					   , <cfqueryparam value='#This.DataFieldName#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.DataFieldName)) is 0#'>
					   , <cfqueryparam value='#This.Datatype#' cfsqlType='cf_sql_varchar'>
					   )
			</cfquery>
			<cfset This.RecordCount = 1>
		</cfif>
	</cffunction>

</cfcomponent>