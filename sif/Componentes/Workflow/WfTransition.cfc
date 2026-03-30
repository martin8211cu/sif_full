<cfcomponent>
	<cfproperty name="TransitionId"          type="numeric"   displayname="TransitionId"          hint="">
	<cfproperty name="ProcessId"             type="numeric"   displayname="ProcessId"             hint="">
	<cfproperty name="FromActivity"          type="numeric"   displayname="FromActivity"          hint="">
	<cfproperty name="ToActivity"            type="numeric"   displayname="ToActivity"            hint="">
	<cfproperty name="Name"                  type="string"    displayname="Name"                  hint="">
	<cfproperty name="Description"           type="string"    displayname="Description"           hint="">
	<cfproperty name="Label"                 type="string"    displayname="Label"                 hint="">
	<cfproperty name="Loop"                  type="string"    displayname="Loop"                  hint="">
	<cfproperty name="Type"                  type="string"    displayname="Type"                  hint="">
	<cfproperty name="Condition"             type="string"    displayname="Condition"             hint="">
	<cfproperty name="SymbolData"            type="string"    displayname="SymbolData"            hint="">
	<cfproperty name="ReadOnly"              type="boolean"   displayname="ReadOnly"              hint="">
	<cfproperty name="NotifyEveryone"        type="boolean"   displayname="NotifyEveryone"        hint="">
	<cfproperty name="AskForComments"        type="boolean"   displayname="AskForComments"        hint="">
	<cfproperty name="NotifyRequester"       type="boolean"   displayname="AskForComments"        hint="">

 	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfTransition">
		<cfset This.TransitionId = 0>
		<cfset This.ProcessId = 0>
		<cfset This.FromActivity = 0>
		<cfset This.ToActivity = 0>
		<cfset This.Name = ''>
		<cfset This.Description = ''>
		<cfset This.Label = ''>
		<cfset This.Loop = 'NOLOOP'><!--- NOLOOP/TOLOOP/FROMLOOP --->
		<cfset This.Type = 'MANUAL'><!--- CONDITION/OTHERWISE/MANUAL --->
		<cfset This.Condition = ''>
		<cfset This.ReadOnly = false>
		<cfset This.SymbolData = ''>

		<cfset This.NotifyEveryone = false>
		<cfset This.AskForComments = false>
		<cfset This.NotifyRequester = false>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="findByName" output="true" returntype="WfTransition" access="public">
		<cfargument name="ProcessId" type="numeric" required="yes">
		<cfargument name="FromActivity" type="numeric" required="yes">
		<cfargument name="Name" type="string" required="yes">
	
		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfTransition
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessId#">
			  and FromActivity = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FromActivity#">
			  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Name#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfTransition" access="public">
		<cfargument name="TransitionId" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfTransition
			where TransitionId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TransitionId#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfif Len(Trim(This.Description)) Is 0>
			<cfset This.Description = This.Name>
		</cfif>
		<cfif Len(Trim(This.Label)) Is 0>
			<cfset This.Label = This.Name>
		</cfif>
		<cfif This.TransitionId>
			<cfquery datasource="#session.dsn#">
				UPDATE WfTransition
			   SET ProcessId = <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
				 , FromActivity = <cfqueryparam value='#This.FromActivity#' cfsqlType='cf_sql_numeric'>
				 , ToActivity = <cfqueryparam value='#This.ToActivity#' cfsqlType='cf_sql_numeric'>
				 , Name = <cfqueryparam value='#This.Name#' cfsqlType='cf_sql_varchar'>
				 , Description = <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
				 , Label = <cfqueryparam value='#This.Label#' cfsqlType='cf_sql_varchar'>
				 , Loop = <cfqueryparam value='#This.Loop#' cfsqlType='cf_sql_varchar'>
				 , Type = <cfqueryparam value='#This.Type#' cfsqlType='cf_sql_char'>
				 , Condition = <cfqueryparam value='#This.Condition#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Condition)) is 0#'>
				 , ReadOnly = <cfqueryparam value='#This.ReadOnly#' cfsqlType='cf_sql_bit'>
				 , SymbolData = <cfqueryparam value='#This.SymbolData#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.SymbolData)) is 0#'>
				 , NotifyEveryone = <cfqueryparam value='#This.NotifyEveryone#' cfsqlType='cf_sql_bit'>
				 , AskForComments = <cfqueryparam value='#This.AskForComments#' cfsqlType='cf_sql_bit'>
				 , NotifyRequester = <cfqueryparam value='#This.NotifyRequester#' cfsqlType='cf_sql_bit'>
			 WHERE WfTransition.TransitionId = <cfqueryparam value='#TransitionId#' cfsqlType='cf_sql_numeric'>
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfTransition
			   ( ProcessId , FromActivity , ToActivity , Name
			   , Description , Label , Loop , Type
			   , Condition , ReadOnly , SymbolData, NotifyEveryone, AskForComments, NotifyRequester )
			VALUES ( <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
			   , <cfqueryparam value='#This.FromActivity#' cfsqlType='cf_sql_numeric'>
			   , <cfqueryparam value='#This.ToActivity#' cfsqlType='cf_sql_numeric'>
			   , <cfqueryparam value='#This.Name#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Label#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Loop#' cfsqlType='cf_sql_varchar'>
			   , <cfqueryparam value='#This.Type#' cfsqlType='cf_sql_char'>
			   , <cfqueryparam value='#This.Condition#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Condition)) is 0#'>
			   , <cfqueryparam value='#This.ReadOnly#' cfsqlType='cf_sql_bit'>
			   , <cfqueryparam value='#This.SymbolData#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.SymbolData)) is 0#'>
			   , <cfqueryparam value='#This.NotifyEveryone#' cfsqlType='cf_sql_bit'>
			   , <cfqueryparam value='#This.AskForComments#' cfsqlType='cf_sql_bit'>
			   , <cfqueryparam value='#This.NotifyRequester#' cfsqlType='cf_sql_bit'>
			   )
			  <cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="inserted">
			<cfset This.ActivityId = inserted.identity>
		</cfif>
	</cffunction>
</cfcomponent>