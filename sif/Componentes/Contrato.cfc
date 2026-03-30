<cfcomponent>

	<cffunction name="init" access="public" returntype="Contrato">
<!--- 		<cfset This.ApplicationName = ''>
		<cfset This.ECid = 0>
		<cfset This.ECestado = 0>
		<cfset This.Ecodigo = 0>
		<cfset This.MotivoCancelacion = ''>
		<cfset This.Tramite = ''>
		 --->
		<cfreturn this>
	</cffunction>

	<cffunction name="setEstado" access="public">
		<cfargument name="ECid"  	type="numeric" required="yes">
		<cfargument name="ECestado" type="any" required="no" default="4">
		<cfargument name="Ecodigo" 	type="Numeric" required="no" default="#session.Ecodigo#">
		<cfset This.ECid 	 = Arguments.ECid>
		<cfset This.ECestado = Arguments.ECestado>
		<cfset This.Ecodigo  = Arguments.Ecodigo>

		<cfquery datasource="#session.DSN#">
			UPDATE 	EcontratosCM
			SET 	ECestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECestado#">
			WHERE  	Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
			AND 	ECid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		</cfquery>
	</cffunction>

	<cffunction name="setMotivo" access="public">
		<cfargument name="ECid"  			 type="numeric" required="yes">
		<cfargument name="MotivoCancelacion" type="any" required="no" default="4">
		<cfargument name="Ecodigo" 			 type="Numeric" required="no" default="#session.Ecodigo#">
		<cfset This.ECid 	 		  = Arguments.ECid>
		<cfset This.MotivoCancelacion = Arguments.MotivoCancelacion>
		<cfset This.Ecodigo  		  = Arguments.Ecodigo>

		<cfquery datasource="#session.DSN#">
			UPDATE 	EcontratosCM
			SET 	MotivoCancelacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MotivoCancelacion#">
			WHERE  	Ecodigo  		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
			AND 	ECid 	 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		</cfquery>
	</cffunction>

	<cffunction name="setTramite" access="public">
		<cfargument name="ECid"  	type="numeric" required="yes">
		<cfargument name="Tramite" type="any" required="no" default="4">
		<cfargument name="Ecodigo" 	type="Numeric" required="no" default="#session.Ecodigo#">
		<cfset This.ECid 	= Arguments.ECid>
		<cfset This.Tramite = Arguments.Tramite>
		<cfset This.Ecodigo = Arguments.Ecodigo>

		<cfquery datasource="#session.DSN#">
			UPDATE 	EcontratosCM
			SET 	Tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Tramite#">
			WHERE  	Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
			AND 	ECid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		</cfquery>
	</cffunction>

	<!--- <cffunction name="addFormalParameter" access="public" returntype="string">
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
	</cffunction> --->

	<!--- <cffunction name="findById" output="true" returntype="WfApplication" access="public">
		<cfargument name="ApplicationName" type="string" required="yes">

		<cfquery datasource="#session.dsn#" name="data">
			select *
			from  WfApplication
			where ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ApplicationName#">
		</cfquery>
		<cfset ret = This.init()>
		<cfset utils.query2cfc(data,ret)>
		<cfreturn ret>
	</cffunction> --->

	<!--- <cffunction name="update" output="true" access="public">
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
	</cffunction> --->

</cfcomponent>