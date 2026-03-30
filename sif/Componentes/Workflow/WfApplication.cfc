<cfcomponent>
	<cfproperty name="ApplicationName"       type="string"    displayname="ApplicationName"       hint="">
	<cfproperty name="ProcessId"             type="numeric"   displayname="ProcessId"             hint="">
	<cfproperty name="Description"           type="string"    displayname="Description"           hint="">
	<cfproperty name="Type"                  type="string"    displayname="Type"                  hint="">
	<cfproperty name="Location"              type="string"    displayname="Location"              hint="">
	<cfproperty name="Command"               type="string"    displayname="Command"               hint="">
	<cfproperty name="Username"              type="string"    displayname="Username"              hint="">
	<cfproperty name="Password"              type="string"    displayname="Password"              hint="">
	<cfproperty name="Documentation"         type="string"    displayname="Documentation"         hint="">
	<cfproperty name="ProxyServer"           type="string"    displayname="ProxyServer"           hint="">
	<cfproperty name="TxMode"                type="string"    displayname="TxMode"                hint="">

 	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfApplication">
		<cfset This.ApplicationName = ''>
		<cfset This.ProcessId = 0>
		<cfset This.Description = ''>
		<cfset This.Type = ''><!--- APPLICATION,PROCEDURE,WEBSERVICE,SUBFLOW,EJB,CFC --->
		<cfset This.Location = ''>
		<cfset This.Command = ''>
		<cfset This.Username = ''>
		<cfset This.Password = ''>
		<cfset This.Documentation = ''>
		<cfset This.ProxyServer = ''>
		<cfset This.TxMode = 'REQUIRED'>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setName" access="public">
		<cfargument name="ApplicationName"  type="string" required="yes">
		<cfargument name="Description"      type="string" required="yes">
		<cfset This.ApplicationName  = Arguments.ApplicationName>
		<cfset This.Description      = Arguments.Description>
	</cffunction>
	
	<cffunction name="addFormalParameter" access="public" returntype="string">
		<cfargument name="ParameterNumber"       type="numeric" required="yes">
		<cfargument name="ParameterName"         type="string" required="yes">
		<cfargument name="Description"           type="string" required="yes">
		<cfargument name="Datatype"              type="string" required="yes" default="STRING">
		<cfargument name="ParameterMode"         type="string" required="yes" default="IN">
		
		<cfinvoke component="WfFormalParameter" method="init" returnvariable="formal_1" />
		<cfset formal_1.ApplicationName = This.ApplicationName>
		<cfset formal_1.ParameterNumber = Arguments.ParameterNumber>
		<cfset formal_1.ParameterName = Arguments.ParameterName>
		<cfset formal_1.Description = Arguments.Description>
		<cfset formal_1.Datatype = Arguments.Datatype>
		<cfset formal_1.ParameterMode = Arguments.ParameterMode>
		<cfset formal_1.update()>
		
		<cfreturn formal_1.ParameterName>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfApplication" access="public">
		<cfargument name="ApplicationName" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from  WfApplication
			where ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ApplicationName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfquery datasource="#session.dsn#" name="existe">
			select ApplicationName
			from WfApplication
			WHERE ApplicationName = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#This.ApplicationName#" len='20'>
		</cfquery>
		<cfif existe.RecordCount>
			<cfquery datasource="#session.dsn#">
				UPDATE WfApplication
				   SET Description = <cfqueryparam value='#This.Description#' cfsqlType='cf_sql_varchar'>
					 , Type = <cfqueryparam value='#This.Type#' cfsqlType='cf_sql_varchar'>
					 , Location = <cfqueryparam value='#This.Location#' cfsqlType='cf_sql_varchar'>
					 , Command = <cfqueryparam value='#This.Command#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Command)) EQ 0#'>
					 , Username = <cfqueryparam value='#This.Username#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Username)) EQ 0#'>
					 , Password = <cfqueryparam value='#This.Password#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Password)) EQ 0#'>
					 , Documentation = <cfqueryparam value='#This.Documentation#' cfsqlType='cf_sql_text' null='#Len(Trim(This.Documentation)) EQ 0#'>
					 , ProxyServer = <cfqueryparam value='#This.ProxyServer#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.ProxyServer)) EQ 0#'>
					 , TxMode = <cfqueryparam value='#This.TxMode#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.TxMode)) EQ 0#'>
				 WHERE ApplicationName = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#This.ApplicationName#" len='20'>
			</cfquery>
		<cfelse>
		
			<cfquery datasource="#session.dsn#" name="inserted">
			  INSERT INTO WfApplication
				   ( ApplicationName
				   , Description
				   , Type
				   , Location
				   , Command
				   , Username
				   , Password
				   , Documentation
				   , ProxyServer
				   , TxMode
				   )
			VALUES ( <cf_jdbcquery_param value='#This.ApplicationName#' cfsqlType='cf_sql_varchar' len='20'>
				   , <cf_jdbcquery_param value='#This.Description#' cfsqlType='cf_sql_varchar'>
				   , <cf_jdbcquery_param value='#This.Type#' cfsqlType='cf_sql_varchar'>
				   , <cf_jdbcquery_param value='#This.Location#' cfsqlType='cf_sql_varchar'>
				   , <cf_jdbcquery_param value='#This.Command#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Command)) EQ 0#'>
				   , <cf_jdbcquery_param value='#This.Username#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Username)) EQ 0#'>
				   , <cf_jdbcquery_param value='#This.Password#' cfsqlType='cf_sql_clob' null='#Len(Trim(This.Password)) EQ 0#'>
				   , <cf_jdbcquery_param value='#This.Documentation#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.Documentation)) EQ 0#'>					
				   , <cf_jdbcquery_param value='#This.ProxyServer#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.ProxyServer)) EQ 0#'>
				   , <cf_jdbcquery_param value='#This.TxMode#' cfsqlType='cf_sql_varchar' null='#Len(Trim(This.TxMode)) EQ 0#'>
				   )
			</cfquery>
		</cfif>
	</cffunction>

</cfcomponent>