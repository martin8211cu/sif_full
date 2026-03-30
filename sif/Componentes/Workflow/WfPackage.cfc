<cfcomponent>
	<cfproperty name="PackageId"             type="numeric"   displayname="PackageId"             hint="">
	<cfproperty name="Name"                  type="string"    displayname="Name"                  hint="">
	<cfproperty name="Description"           type="string"    displayname="Description"           hint="">
	<cfproperty name="GraphConformance"      type="string"    displayname="GraphConformance"      hint="">
	<cfproperty name="Created"               type="date"      displayname="Created"               hint="">
	<cfproperty name="CostUnit"              type="string"    displayname="CostUnit"              hint="">
	<cfproperty name="Author"                type="string"    displayname="Author"                hint="">
	<cfproperty name="Version"               type="string"    displayname="Version"               hint="">
	<cfproperty name="PublicationStatus"     type="string"    displayname="PublicationStatus"     hint="">
	<cfproperty name="Icon"                  type="string"    displayname="Icon"                  hint="">
	<cfproperty name="Documentation"         type="string"    displayname="Documentation"         hint="">
	<cfproperty name="Ecodigo"               type="numeric"   displayname="Ecodigo"               hint="">
	<cfproperty name="CFdestino"             type="numeric"   displayname="PermiteCFdestino"      hint="">

 	<cfset utils = CreateObject("component", "utils")>
	
	<cffunction name="init" access="public" returntype="WfPackage">
		<cfset This.PackageId = 0>
		<cfset This.Name = ''>
		<cfset This.Description = ''>
		<cfset This.GraphConformance = 'NON_BLOCKED'>
		<cfset This.Created = Now()>
		<cfset This.CostUnit = 'USD'>
		<cfset This.Author = session.usuario>
		<cfset This.Version = '1.0'>
		<cfset This.PublicationStatus = 'UNDER_REVISION'>
		<cfset This.Icon = ''>
		<cfset This.Documentation = ''>
		<cfset This.Ecodigo = session.Ecodigo>
		<cfset This.CFdestino = 0>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="findByName" output="true" returntype="WfPackage" access="public">
		<cfargument name="Name" type="string" required="yes">
	
		<cfquery datasource="#session.dsn#" name="data" maxrows="1">
			select *
			from WfPackage
			where Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Name#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>
	
	<cffunction name="findById" output="true" returntype="WfPackage" access="public">
		<cfargument name="PackageId" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from WfPackage
			where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PackageId#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction>

	<cffunction name="update" output="true" access="public">
		<cfif This.PackageId>
			<cfquery datasource="#session.dsn#">
				update WfPackage
				set Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Name#">,
				    Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Description#">,
				    GraphConformance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.GraphConformance#">,
				    Created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.Created#">,
				    CostUnit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.CostUnit#">,
				    Author = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Author#">,
				    Version = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Version#">,
				    PublicationStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.PublicationStatus#">,
				    Icon = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Icon#" null="#Len(This.Icon) Is 0#">,
				    Documentation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Documentation#" null="#Len(This.Documentation) Is 0#">,
				    Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#This.Ecodigo#">
					 , CFdestino = <cfqueryparam value='#This.CFdestino#' cfsqlType='cf_sql_bit'>
				where PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.PackageId#">
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#" name="inserted">
			  insert INTO WfPackage (
				Name, Description, GraphConformance, Created,
				CostUnit, Author, Version, PublicationStatus,
				Icon, Documentation, Ecodigo, CFdestino)
			  values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Description#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.GraphConformance#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.Created#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.CostUnit#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Author#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Version#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.PublicationStatus#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Icon#" null="#Len(This.Icon) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.Documentation#" null="#Len(This.Documentation) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#This.Ecodigo#">
				,<cfqueryparam cfsqlType='cf_sql_bit'    value='#This.CFdestino#'>)
			  <cf_dbidentity1 verificar_transaccion="false" datasource="#session.dsn#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" datasource="#session.dsn#" name="inserted">
			<cfset This.PackageId = inserted.identity>
		</cfif>
	</cffunction>

</cfcomponent>
