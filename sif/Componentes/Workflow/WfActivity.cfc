<cfcomponent>
	<cfproperty name="ActivityId"            type="numeric" displayname="ActivityId"            hint="">
	<cfproperty name="ProcessId"             type="numeric" displayname="ProcessId"             hint="">
	<cfproperty name="Name"                  type="string"  displayname="Name"                  hint="">
	<cfproperty name="Description"           type="string"  displayname="Description"           hint="">
	<cfproperty name="Limit"                 type="numeric" displayname="Limit"                 hint="">
	<cfproperty name="StartMode"             type="string"  displayname="StartMode"             hint="">
	<cfproperty name="FinishMode"            type="string"  displayname="FinishMode"            hint="">
	<cfproperty name="Priority"              type="numeric" displayname="Priority"              hint="">
	<cfproperty name="Icon"                  type="string"  displayname="Icon"                  hint="">
	<cfproperty name="ImplementationType"    type="string"  displayname="ImplementationType"    hint="">
	<cfproperty name="SplitType"             type="string"  displayname="SplitType"             hint="">
	<cfproperty name="JoinType"              type="string"  displayname="JoinType"              hint="">
	<cfproperty name="Documentation"         type="string"  displayname="Documentation"         hint="">
	<cfproperty name="Cost"                  type="numeric" displayname="Cost"                  hint="">
	<cfproperty name="Instantiation"         type="string"  displayname="Instantiation"         hint="">
	<cfproperty name="WaitingTimeEstimation" type="numeric" displayname="WaitingTimeEstimation" hint="">
	<cfproperty name="WorkingTimeEstimation" type="numeric" displayname="WorkingTimeEstimation" hint="">
	<cfproperty name="DurationEstimation"    type="numeric" displayname="DurationEstimation"    hint="">
	<cfproperty name="IsStart"               type="boolean" displayname="IsStart"               hint="">
	<cfproperty name="IsFinish"              type="boolean" displayname="IsFinish"              hint="">
	<cfproperty name="Ordering"              type="numeric" displayname="Ordering"              hint="">
	<cfproperty name="NotifySubjBefore"      type="boolean" displayname="NotifySubjBefore"      hint="">
	<cfproperty name="NotifySubjAfter"       type="boolean" displayname="NotifySubjAfter"       hint="">
	<cfproperty name="NotifyPartBefore"      type="boolean" displayname="NotifyPartBefore"      hint="">
	<cfproperty name="NotifyPartAfter"       type="boolean" displayname="NotifyPartAfter"       hint="">
	<cfproperty name="NotifyReqBefore"       type="boolean" displayname="NotifyReqBefore"       hint="">
	<cfproperty name="NotifyReqAfter"        type="boolean" displayname="NotifyReqAfter"        hint="">
	<cfproperty name="NotifyAllBefore"       type="boolean" displayname="NotifyAllBefore"       hint="">
	<cfproperty name="NotifyAllAfter"        type="boolean" displayname="NotifyAllAfter"        hint="">
	<cfproperty name="SymbolData"            type="string"  displayname="SymbolData"            hint="">
	<cfproperty name="ReadOnly"              type="boolean" displayname="ReadOnly"              hint="">

	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfActivity">
		<cfset This.ActivityId = 0>
		<cfset This.ProcessId = 0>
		<cfset This.Name = ''>
		<cfset This.Description = ''>
		<cfset This.Limit = 0>
		<cfset This.StartMode = 'AUTOMATIC'>
		<cfset This.FinishMode = 'AUTOMATIC'>
		<cfset This.Priority = 2>
		<cfset This.Icon = ''>
		<cfset This.ImplementationType = 'NONE'>
		<cfset This.SplitType = 'NONE'>
		<cfset This.JoinType = 'NONE'>
		<cfset This.Documentation = ''>
		<cfset This.Cost = 0>
		<cfset This.Instantiation = 'MULTIPLE'>
		<cfset This.WaitingTimeEstimation = 0>
		<cfset This.WorkingTimeEstimation = 0>
		<cfset This.DurationEstimation = 0>
		<cfset This.IsStart = false>
		<cfset This.IsFinish = false>
		<cfset This.Ordering = 0>
		<cfset This.NotifySubjBefore	= false>
		<cfset This.NotifySubjAfter		= false>
		<cfset This.NotifyPartBefore	= false>
		<cfset This.NotifyPartAfter		= false>
		<cfset This.NotifyReqBefore		= false>
		<cfset This.NotifyReqAfter		= false>
		<cfset This.NotifyAllBefore		= false>
		<cfset This.NotifyAllAfter		= false>
		<cfset This.ReadOnly = false>
		<cfset This.SymbolData = ''>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="findByName" output="true" returntype="WfActivity" access="public">
		<cfargument name="ProcessId" type="numeric" required="yes">
		<cfargument name="Name" type="string" required="yes">
	
		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfActivity
			where ProcessId = <cfqueryparam cfsqltype="cf_sql_numerid" value="#Arguments.ProcessId#">
			  and Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Name#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfProcess" access="public">
		<cfargument name="ActivityId" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfActivity
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ActivityId#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfif This.ActivityId>
			<cfquery datasource="#session.dsn#">
				UPDATE WfActivity
			   SET ProcessId = <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
				 , Name = <cfqueryparam value='#This.Name#' cfsqlType='cf_sql_varchar'>
				 , Description = <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
				 , Limit = <cfqueryparam value='#This.Limit#' cfsqlType='cf_sql_decimal' scale='4' null='#Trim(This.Limit) EQ ''#'>
				 , StartMode = <cfqueryparam value='#This.StartMode#' cfsqlType='cf_sql_varchar'>
				 , FinishMode = <cfqueryparam value='#This.FinishMode#' cfsqlType='cf_sql_varchar'>
				 , Priority = <cfqueryparam value='#This.Priority#' cfsqlType='cf_sql_tinyint'>
				 , Icon = <cfqueryparam value='#This.Icon#' cfsqlType='cf_sql_varchar' null='#Trim(This.Icon) EQ ''#'>
				 , ImplementationType = <cfqueryparam value='#This.ImplementationType#' cfsqlType='cf_sql_varchar'>
				 , SplitType = <cfqueryparam value='#This.SplitType#' cfsqlType='cf_sql_varchar'>
				 , JoinType = <cfqueryparam value='#This.JoinType#' cfsqlType='cf_sql_varchar'>
				 , Documentation = <cfqueryparam value='#This.Documentation#' cfsqlType='cf_sql_text' null='#Trim(This.Documentation) EQ ''#'>
				 , Cost = <cfqueryparam value='#This.Cost#' cfsqlType='cf_sql_decimal' scale='4'>
				 , Instantiation = <cfqueryparam value='#This.Instantiation#' cfsqlType='cf_sql_varchar'>
				 , WaitingTimeEstimation = <cfqueryparam value='#This.WaitingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
				 , WorkingTimeEstimation = <cfqueryparam value='#This.WorkingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
				 , DurationEstimation = <cfqueryparam value='#This.DurationEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
				 , IsStart = <cfqueryparam value='#This.IsStart#' cfsqlType='cf_sql_bit'>
				 , IsFinish = <cfqueryparam value='#This.IsFinish#' cfsqlType='cf_sql_bit'>
				 , Ordering = <cfqueryparam value='#This.Ordering#' cfsqlType='cf_sql_int' null='#Trim(This.Ordering) EQ ''#'>
				 , NotifySubjBefore	= <cfqueryparam value='#This.NotifySubjBefore#'	cfsqlType='cf_sql_bit'>
				 , NotifySubjAfter	= <cfqueryparam value='#This.NotifySubjAfter#'	cfsqlType='cf_sql_bit'>
				 , NotifyPartBefore = <cfqueryparam value='#This.NotifyPartBefore#'	cfsqlType='cf_sql_bit'>
				 , NotifyPartAfter	= <cfqueryparam value='#This.NotifyPartAfter#'	cfsqlType='cf_sql_bit'>
				 , NotifyReqBefore	= <cfqueryparam value='#This.NotifyReqBefore#'	cfsqlType='cf_sql_bit'>
				 , NotifyReqAfter	= <cfqueryparam value='#This.NotifyReqAfter#'	cfsqlType='cf_sql_bit'>
				 , NotifyAllBefore	= <cfqueryparam value='#This.NotifyAllBefore#'	cfsqlType='cf_sql_bit'>
				 , NotifyAllAfter	= <cfqueryparam value='#This.NotifyAllAfter#'	cfsqlType='cf_sql_bit'>
				 , ReadOnly = <cfqueryparam value='#This.ReadOnly#' cfsqlType='cf_sql_bit'>
				 , SymbolData = <cfqueryparam value='#This.SymbolData#' cfsqlType='cf_sql_varchar' null='#Trim(This.SymbolData) EQ ''#'>
			 WHERE WfActivity.ActivityId = <cfqueryparam value='#This.ActivityId#' cfsqlType='cf_sql_numeric'>
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfActivity
				   ( ProcessId , Name , Description , Limit
				   , StartMode , FinishMode , Priority , Icon
				   , ImplementationType , SplitType , JoinType , Documentation
				   , Cost , Instantiation , WaitingTimeEstimation , WorkingTimeEstimation
				   , DurationEstimation , IsStart , IsFinish , Ordering
				   
				   , NotifySubjBefore , NotifySubjAfter 
				   , NotifyPartBefore , NotifyPartAfter
				   
				   , NotifyReqBefore , NotifyReqAfter  
				   , NotifyAllBefore , NotifyAllAfter 
				   
				   , ReadOnly , SymbolData )
			VALUES ( <cfqueryparam value='#This.ProcessId#' cfsqlType='cf_sql_numeric'>
				   , <cfqueryparam value='#This.Name#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.Limit#' cfsqlType='cf_sql_decimal' scale='4' null='#Trim(This.Limit) EQ ''#'>
				   
				   , <cfqueryparam value='#This.StartMode#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.FinishMode#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.Priority#' cfsqlType='cf_sql_tinyint'>
				   , <cfqueryparam value='#This.Icon#' cfsqlType='cf_sql_varchar' null='#Trim(This.Icon) EQ ''#'>
				   
				   , <cfqueryparam value='#This.ImplementationType#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.SplitType#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.JoinType#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.Documentation#' cfsqlType='cf_sql_text' null='#Trim(This.Documentation) EQ ''#'>
				   
				   , <cfqueryparam value='#This.Cost#' cfsqlType='cf_sql_decimal' scale='4'>
				   , <cfqueryparam value='#This.Instantiation#' cfsqlType='cf_sql_varchar'>
				   , <cfqueryparam value='#This.WaitingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
				   , <cfqueryparam value='#This.WorkingTimeEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
				   
				   , <cfqueryparam value='#This.DurationEstimation#' cfsqlType='cf_sql_decimal' scale='4'>
				   , <cfqueryparam value='#This.IsStart#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.IsFinish#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.Ordering#' cfsqlType='cf_sql_integer' null='#Trim(This.Ordering) EQ ''#'>
				   
				   , <cfqueryparam value='#This.NotifySubjBefore#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.NotifySubjAfter#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.NotifyPartBefore#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.NotifyPartAfter#' cfsqlType='cf_sql_bit'>
				   
				   , <cfqueryparam value='#This.NotifyReqBefore#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.NotifyReqAfter#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.NotifyAllBefore#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.NotifyAllAfter#' cfsqlType='cf_sql_bit'>

				   , <cfqueryparam value='#This.ReadOnly#' cfsqlType='cf_sql_bit'>
				   , <cfqueryparam value='#This.SymbolData#' cfsqlType='cf_sql_varchar' null='#Trim(This.SymbolData) EQ ''#'>
				   )
			  <cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="inserted">
			<cfset This.ActivityId = inserted.identity>
		</cfif>
	</cffunction>
</cfcomponent>