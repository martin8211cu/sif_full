<cfcomponent>
	<cfproperty name="DataFieldName"         type="string"    displayname="DataFieldName"         hint="">
	<cfproperty name="ProcessId"             type="numeric"   displayname="ProcessId"             hint="">
	<cfproperty name="Description"           type="string"    displayname="Description"           hint="">
	<cfproperty name="Label"                 type="string"    displayname="Label"                 hint="">
	<cfproperty name="InitialValue"          type="string"    displayname="InitialValue"          hint="">
	<cfproperty name="Prompt"                type="boolean"   displayname="Prompt"                hint="">
	<cfproperty name="Length"                type="numeric"   displayname="Length"                hint="">
	<cfproperty name="Datatype"              type="string"    displayname="Datatype"              hint="">

	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfDataField">
		<cfset This.DataFieldName = ''>
		<cfset This.ProcessId = 0>
		<cfset This.Description = ''>
		<cfset This.Label = ''>
		<cfset This.InitialValue = '?'>
		<cfset This.Prompt = true>
		<cfset This.Length = 30>
		<cfset This.DataType = 'STRING'><!--- STRING/NUMERIC/XML/FILE --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setName" access="public">
		<cfargument name="DataFieldName" type="string" required="yes">
		<cfargument name="Description"   type="string" required="yes">
		<cfset This.DataFieldName = Arguments.DataFieldName>
		<cfset This.Description   = Arguments.Description>
	</cffunction>
	
	<cffunction name="setType" access="public">
		<cfargument name="DataType" type="string" required="yes">
		<cfargument name="Length"   type="numeric" default="30">
		<cfset This.DataType  = Arguments.DataType>
		<cfset This.Length    = Arguments.Length>
	</cffunction>
	
	<cffunction name="setLabel" access="public">
		<cfargument name="Label"  type="string" required="yes">
		<cfargument name="Prompt" type="boolean" required="yes" default="true">
		<cfset This.Label   = Arguments.Label>
		<cfset This.Prompt  = Arguments.Prompt>
	</cffunction>
	
	<cffunction name="findByName" output="true" returntype="WfDataField" access="public">
		<cfargument name="ProcessId" type="numeric" required="yes">
		<cfargument name="DataFieldName" type="string" required="yes">
	
		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfDataField
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">
			  and DataFieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DataFieldName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfDataField" access="public">
		<cfargument name="ProcessId" type="numeric" required="yes">
		<cfargument name="DataFieldName" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfDataField
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">
			  and DataFieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.DataFieldName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfquery datasource="#session.dsn#" name="existe">
			select DataFieldName
			from WfDataField
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.ProcessId#">
			  and DataFieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.DataFieldName#">
		</cfquery>
		<cfif existe.RecordCount>
			<cfquery datasource="#session.dsn#">
				UPDATE WfDataField
				   SET Description = <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
					 , Label = <cfqueryparam value='#This.Label#' cfsqlType='cf_sql_varchar'>
					 , InitialValue = <cfqueryparam value='#This.InitialValue#' cfsqlType='cf_sql_varchar'>
					 , Prompt = <cfqueryparam value='#This.Prompt#' cfsqlType='cf_sql_bit'>
					 , Length = <cfqueryparam value='#This.Length#' cfsqlType='cf_sql_integer'>
					 , Datatype = <cfqueryparam value='#This.Datatype#' cfsqlType='cf_sql_varchar'>
				 WHERE ProcessId = <cfqueryparam value='#This.ProcessId#' cfsqltype="cf_sql_numeric">
				   and DataFieldName = <cfqueryparam value='#This.DataFieldName#' cfsqlType='cf_sql_varchar'>
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfDataField
				   ( ProcessId , DataFieldName , Description , Label
				   , InitialValue , Prompt , Length , Datatype )
			VALUES ( <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
				   , <cfqueryparam value='#This.DataFieldName#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
				   , substring(<cfqueryparam value='#This.Label#' cfsqlType='cf_sql_varchar'>,1,20)
				   , <cfqueryparam value='#This.InitialValue#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.Prompt#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.Length#' cfsqlType='cf_sql_integer'>
				   , <cfqueryparam value='#This.Datatype#' cfsqlType='cf_sql_varchar'>
				   )
			</cfquery>
		</cfif>
	</cffunction>
	
</cfcomponent>