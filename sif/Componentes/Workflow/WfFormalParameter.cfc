<cfcomponent>
	<cfproperty name="ApplicationName"       type="string"    displayname="ApplicationName"       hint="">
	<cfproperty name="ParameterName"         type="string"    displayname="ParameterName"         hint="">
	<cfproperty name="ParameterNumber"       type="numeric"   displayname="ParameterNumber"       hint="">
	<cfproperty name="Description"           type="string"    displayname="Description"           hint="">
	<cfproperty name="ParameterMode"                  type="string"    displayname="ParameterMode"                  hint="">
	<cfproperty name="Datatype"              type="string"    displayname="Datatype"              hint="">

	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfFormalParameter">
		<cfset This.ApplicationName = ''>
		<cfset This.ParameterName = ''>
		<cfset This.ParameterNumber = 0>
		<cfset This.Description = ''>
		<cfset This.ParameterMode = 'IN'><!--- IN/OUT/INOUT --->
		<cfset This.Datatype = 'STRING'><!--- STRING/NUMERIC/XML/FILE --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setName" access="public">
		<cfargument name="Name"        type="string" required="yes">
		<cfargument name="Description" type="string" required="yes">
		<cfset This.Name        = Arguments.Name>
		<cfset This.Description = Arguments.Description>
	</cffunction>
		
	<cffunction name="findById" output="true" returntype="WfFormalParameter" access="public">
		<cfargument name="ApplicationName"    type="string" required="yes">
		<cfargument name="ParameterName"      type="string" required="yes">
	
		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfFormalParameter
			where ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ApplicationName#">
			  and ParameterName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ParameterName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfquery datasource="#session.dsn#" name="existe">
			select ApplicationName
			from WfFormalParameter
			 WHERE ApplicationName = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#This.ApplicationName#" len='20'>
			   and ParameterName = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#This.ParameterName#">
		</cfquery>
		<cfif existe.RecordCount>
			<cfquery datasource="#session.dsn#">
				UPDATE WfFormalParameter
				   SET ParameterNumber = <cfqueryparam value='#This.ParameterNumber#' cfsqlType='cf_sql_integer'>
					 , Description = <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
					 , ParameterMode = <cfqueryparam value='#This.ParameterMode#' cfsqlType='cf_sql_varchar'>
					 , Datatype = <cfqueryparam value='#This.Datatype#' cfsqlType='cf_sql_varchar'>
				 WHERE ApplicationName = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#This.ApplicationName#" len='20'>
				   AND ParameterName = <cfqueryparam value='#This.ParameterName#' cfsqlType='cf_sql_varchar'>
	
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfFormalParameter
					   ( ApplicationName
					   , ParameterName
					   , ParameterNumber
					   , Description
					   , ParameterMode
					   , Datatype
					   )
				VALUES ( <cf_jdbcquery_param value='#This.ApplicationName#' cfsqlType='cf_sql_varchar' len='20'>
					   , <cfqueryparam value='#This.ParameterName#' cfsqlType='cf_sql_varchar'>
					   , <cfqueryparam value='#This.ParameterNumber#' cfsqlType='cf_sql_integer'>
					   , <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
					   , <cfqueryparam value='#This.ParameterMode#' cfsqlType='cf_sql_varchar'>
					   , <cfqueryparam value='#This.Datatype#' cfsqlType='cf_sql_varchar'>
					   )
			</cfquery>
		</cfif>
	</cffunction>

</cfcomponent>