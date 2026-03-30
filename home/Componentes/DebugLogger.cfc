<cfcomponent output="no">
	<cfset This.templateRootPath = Replace( ExpandPath  ('/'), '\', '/', 'all')>

	<cffunction name="install" access="public" returntype="void" output="false">
		<cfset debugInvocation = '<cfinvoke component="home.Componentes.DebugLogger" method="logDebug"/>'>
		<cffile file="#ExpandPath('/WEB-INF/debug/soin-logger.cfm')#"
			action="write" output='#debugInvocation#'>
	</cffunction>
	
	<cffunction name="newDate" access="public" returntype="date" output="false">
		<cfargument name="millis">
		
		<cfif IsNumeric(Arguments.millis)>
			<cfreturn CreateObject('java', 'java.sql.Timestamp').init(millis)>
		<cfelse>
			<cfreturn CreateDate(2006, 1, 1)>
		</cfif>
	</cffunction>
	
	<cffunction name="elapsedTime" access="public" returntype="numeric" output="false">
		<cfargument name="startTime">
		<cfargument name="endTime">
		
		<cfif IsNumeric(Arguments.startTime) And IsNumeric(Arguments.endTime)>
			<cfreturn Arguments.endTime - Arguments.startTime>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="formatSqlText" access="public" returntype="string" output="false">
		<cfargument name="sqlText" type="string" required="yes">

			<cfset var sqlFormatted = sqlText>
			<cfset sqlFormatted = REReplace( sqlFormatted, '(?m)^[#Chr(9)# ]+', '', 'all' )>
			<cfset sqlFormatted = Replace( sqlFormatted, Chr(13)&Chr(10)&Chr(13)&Chr(10), Chr(13)&Chr(10), 'all' )>
			<cfset sqlFormatted = Replace( sqlFormatted, Chr(13)&Chr(13), Chr(13), 'all' )>
			
			<cfif Len(sqlFormatted) GT 1000>
				<cfset sqlFormatted = Left(sqlFormatted, 1000)>
			</cfif>

		<cfreturn sqlFormatted>
	</cffunction>
	
	<cffunction name="removeBasePath" output="false" returntype="string">
		<cfargument name="templateName" type="string" required="yes">
		<cfargument name="maxLength" type="numeric" default="255">
		<cfargument name="checkComponent" type="boolean" default="true">
	
		<cfset var retval = Replace( Replace(Arguments.templateName, '\', '/', 'all'), This.templateRootPath, '', 'all')>
		<cfif Arguments.checkComponent And retval.startsWith('CFC[ ' )>
			<cfset fromPos = Find('] from ', retval)>
			<cfif fromPos>
				<cfset retval = Mid(retval, 6, fromPos - 7)>
			</cfif>
			<cfloop list="Translate.cfc | Translate,TranslateDB.cfc | Translate,Hash.cfc | hashPassword,Hash.cfc | __hash" index="method">
				<cfif Find(method, retval & '(')>
					<cfset pos1 = Find(method, retval) + Len(method)>
					<cfif pos1 GT 0>
						<cfset pos2 = Find(')', retval, pos1 + 1)>
						<cfif pos2 GT pos1>
							<cfset retval = Left(retval, pos1) & '...' & Right(retval, Len(retval) - pos2 + 1)>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfif Len(retval) GT Arguments.maxLength>
			<cfset retval = Left(retval, Arguments.maxLength)>
		</cfif>
		<cfreturn retval>
	</cffunction>
	
	<cffunction name="saveScopeVars" access="public" returntype="numeric" output="false">
		<cfargument name="debugid" type="numeric">
		<cfargument name="scopeName" type="string">
		<cfset rowsIns = 0>
		<cfif IsDefined(Arguments.scopeName)>
			<cfset myStruct = Evaluate(Arguments.scopeName)>
			<cfset SKeys = StructKeyArray(myStruct)>
			<cfset ArraySort(SKeys, 'text')>
			<cfif ArrayLen(SKeys)>
				<cfloop from="1" to="#ArrayLen(SKeys)#" index="ikey">
					<cfif IsSimpleValue(myStruct[SKeys[ikey]])>
						<cfset rowsIns = rowsIns + 1>
						<cfif FindNoCase('pass', SKeys[ikey])>
							<cfset myValue = '****'>
						<cfelse>
							<cfset myValue = myStruct[SKeys[ikey]]>
						</cfif>
						<cfquery datasource="aspmonitor" debug="false">
							insert into MonDebugIScopeVars
								(debugid, scope, name, value)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.debugid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.scopeName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#SKeys[ikey]#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#myValue#">)
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfreturn rowsIns>
	</cffunction>
	
	<cffunction name="saveRequest" access="public" output="false" returntype="numeric">
		<cfargument name="executionTime">
		<cfargument name="template_mode">
	
		<cfset var memoryDelta = 0>
		<cfset var mySessionid = 0>
		<cfset var myRequestid = 0>
		<cfset var myArgs = ''>
		<cfset var mySrvprocid = 0>
		<cfset var myLogin = ''>
		<cfset var myIpaddr = ''>
		
		<cfif IsDefined('Request.MonPacket.usedMemory')>
			<cfinvoke component="aspmonitor" method="GetUsedMemory" returnvariable="newMemory"/>
			<cfset memoryDelta = newMemory - Request.MonPacket.usedMemory>
		</cfif>
		<cfif IsDefined('session') and IsDefined('session.monitoreo.sessionid') And session.monitoreo.sessionid Neq 0>
			<cfset mySessionid = session.monitoreo.sessionid>
		</cfif>
		<cfif IsDefined('request.MonPacket.requestid') >
			<cfif Len(request.MonPacket.requestid) is 0 Or request.MonPacket.requestid eq 0>
				<cfinvoke component="aspmonitor" method="ProcesaPacket" MonPacket="#Request.MonPacket#"/>
			</cfif>
			<cfif Len(request.MonPacket.requestid) neq 0 And request.MonPacket.requestid Neq 0>
				<cfset myRequestid = request.MonPacket.requestid>
			</cfif>
		</cfif>
		<cfif IsDefined('request.MonPacket.QueryString')>
			<cfset myArgs =request.MonPacket.QueryString>
		<cfelse>
			<cfinvoke component="aspmonitor" method="GetQueryString" returnvariable="myQueryString"/>
			<cfset myArgs = myQueryString>
		</cfif>
		<cfif IsDefined('application') And IsDefined('application.srvprocid') And Len(application.srvprocid) And application.srvprocid Neq 0>
			<cfset mySrvprocid = application.srvprocid>
		</cfif>
		<cfif IsDefined('request.MonPacket.login')>
			<cfset myLogin = request.MonPacket.login>
		</cfif>
		<cfif IsDefined('request.MonPacket.ipaddr')>
			<cfset myIpaddr = request.MonPacket.ipaddr>
		</cfif>
	
		<cfquery datasource="aspmonitor" name="MonDebugIRequest" debug="false">
			insert into MonDebugIRequest
				( sessionid, requestid, method, uri,
				args, requested, executionTime, memoryDelta, 
				srvprocid, ip, login, template_mode)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#mySessionid#" null="#mySessionid eq 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#myRequestid#" null="#myRequestid eq 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REQUEST_METHOD#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.SCRIPT_NAME#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArgs#" null="#Len(myArgs) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.executionTime#" null="#Len(Arguments.executionTime) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#memoryDelta#" null="#memoryDelta is 0#">,
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#mySrvprocid#" null="#mySrvprocid is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#myIpaddr#" null="#Len(myIpaddr) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#myLogin#" null="#Len(myLogin) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.template_mode#">
			)
			<cf_dbidentity1 datasource="aspmonitor" name="MonDebugIRequest" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="aspmonitor" name="MonDebugIRequest" verificar_transaccion="false">
		<cfreturn MonDebugIRequest.identity>
	</cffunction>

	<cffunction name="saveSummary" access="public" output="false" returntype="numeric">
		<cfargument name="debugid" type="numeric">
		<cfargument name="qEvents" type="query">
		<!--- MonDebugISummary: sumarizar el tiempo por template --->
		<cfquery dbType="query" name="MonDebugISummary" debug="false">
			SELECT 
				template, sum(endTime - startTime) AS totalExecutionTime,
				count(template) AS instanceCount
			FROM Arguments.qEvents
			WHERE type = 'Template'
			group by template
			order by totalExecutionTime DESC
		</cfquery>
		<cfloop query="MonDebugISummary">
			<cfquery datasource="aspmonitor">
			insert into MonDebugISummary 
				(debugid, debugline, template, totalExecutionTime, instanceCount, avgExecutionTime)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.debugid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MonDebugISummary.CurrentRow#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.removeBasePath(MonDebugISummary.template)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MonDebugISummary.totalExecutionTime#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MonDebugISummary.instanceCount#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#MonDebugISummary.totalExecutionTime/MonDebugISummary.instanceCount#">)
			</cfquery>
		</cfloop>
		<cfreturn MonDebugISummary.RecordCount>
	</cffunction>

	<cffunction name="saveTemplate" access="public" output="false" returntype="numeric">
		<cfargument name="debugid" type="numeric">
		<cfargument name="qEvents" type="query">
		<!--- MonDebugITemplate: Tiempo de ejecución por cada template --->
		<cfset debugline = 0>
		<cfloop query="Arguments.qEvents">
			<cfif qEvents.Type is 'Template'>
			<cfset debugline = debugline + 1>
			<cfset attributeValues = ''>
			<cfquery datasource="aspmonitor" debug="false">
			insert into MonDebugITemplate
				(debugid, debugline, template, line, parent, fecha, startTime, endTime, executionTime)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.debugid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#debugline#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.removeBasePath(qEvents.template)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qEvents.line#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.removeBasePath(qEvents.parent)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#qEvents.timestamp#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.newDate(qEvents.startTime)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.newDate(qEvents.endTime)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#This.elapsedTime(qEvents.startTime, qEvents.endTime)#">
			)
			</cfquery></cfif>
		</cfloop>
		<cfreturn debugline>
	</cffunction>

	<cffunction name="saveSQL" access="public" output="false" returntype="numeric">
		<cfargument name="debugid" type="numeric">
		<cfargument name="qEvents" type="query">
		<!--- MonDebugISQL: body/sqltext, datasource, attributes/arguments, rowcount --->
		<cfset debugline = 0>
		<cfloop query="Arguments.qEvents">
			<cfif qEvents.Type is 'SqlQuery'>
			<cfset debugline = debugline + 1>
			<cfset qAttributes = qEvents.Attributes>
			<cfset attributeValues = ''>
			<cfif IsArray(qAttributes) And ArrayLen(qAttributes)>
				<cfloop from="1" to="#ArrayLen(qAttributes)#" index="i">
					<cfset attributeValues = ListAppend(attributeValues , '@p#i#: (' & 
						Replace(qAttributes[i].sqlType, 'cf_sql_', '') & ')' & 
						qAttributes[i].value, Chr(13) )>
				</cfloop>
			</cfif>
			<cfquery datasource="aspmonitor" debug="false">
			insert into MonDebugISQL
				(debugid, debugline, template, line, fecha, startTime, endTime, executionTime,
				queryName, datasource, sqlText, queryParams, totalRows)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.debugid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#debugline#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.removeBasePath(qEvents.template, 60)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qEvents.line#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#qEvents.timestamp#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.newDate(qEvents.startTime)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.newDate(qEvents.endTime)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#This.elapsedTime(qEvents.startTime, qEvents.endTime)#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#qEvents.name#" null="#Len(qEvents.name) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#qEvents.datasource#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.formatSqlText(qEvents.body)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(attributeValues, 255)#" null="#Len(attributeValues) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qEvents.rowcount#" null="#Len(qEvents.rowcount) is 0#">
			)
			</cfquery></cfif>
		</cfloop>
		<cfreturn debugline>
	</cffunction>

	<cffunction name="saveException" access="public" output="false" returntype="numeric">
		<cfargument name="debugid" type="numeric">
		<cfargument name="qEvents" type="query">
		<!--- MonDebugIException: name/extype, message, java stacktrace, template stacktrace --->
		<cfset debugline = 0>
		<cfloop query="Arguments.qEvents">
			<cfif qEvents.Type is 'Exception'>
			<cfset debugline = debugline + 1>
			<cfset javaStackTrace = ''>
			<cfset templateStackTrace = ''>
			<cfset qStack = qEvents.stacktrace>
			<cfif IsDefined('qStack.StackTrace')>
				<cfset javaStackTrace = removeBasePath(qStack.StackTrace, 900, false)>
			</cfif>
			<cfif IsDefined('qStack.TagContext')>
				<cfloop from="1" to="#ArrayLen(qStack.TagContext)#" index="i">
					<cfset templateStackTrace = templateStackTrace & 
						qStack.TagContext[i].ID & ' @ ' &
						removeBasePath(qStack.TagContext[i].Template) & ' (' & 
						qStack.TagContext[i].line & ',' & 
						qStack.TagContext[i].column & ')' & Chr(13) & Chr(10)>
				</cfloop>
				<cfset templateStackTrace = Left(templateStackTrace, 400)>
			</cfif>
			<cfquery datasource="aspmonitor" debug="false">
			insert into MonDebugIException
				(debugid, debugline, template, line, fecha, startTime, endTime, executionTime,
				exceptionType, message, javaStackTrace, templateStackTrace)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.debugid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#debugline#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#This.removeBasePath(qEvents.template)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#qEvents.line#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#qEvents.timestamp#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.newDate(qEvents.startTime)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#This.newDate(qEvents.endTime)#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#This.elapsedTime(qEvents.startTime, qEvents.endTime)#">,
				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(qEvents.name,60)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(qEvents.message,300)#">,
				<cfqueryparam cfsqltype="cf_sql_clob" value="#javaStackTrace#" null="#Len(javaStackTrace) is 0#">,
				<cfqueryparam cfsqltype="cf_sql_clob" value="#templateStackTrace#" null="#Len(templateStackTrace) is 0#">
			)
			</cfquery></cfif>
		</cfloop>
		<cfreturn debugline>
	</cffunction>

	<cffunction name="logDebug" access="public" returntype="string" output="false">
		<cfif IsDebugMode()>
			<cfsilent>
			<cfsetting enablecfoutputonly="Yes">
			<cftry>
			
				<cfset debugStartTime = getTickCount()>

				
				<cfapplication name="SIF_ASP" 
					sessionmanagement="Yes"
					clientmanagement="No"
					setclientcookies="Yes"
					sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
	
				<cfinvoke component="home.Componentes.DbUtils"
					method="generate_dsinfo" datasource="aspmonitor" />
					
				<cfinvoke component="home.Componentes.Politicas"
					method="trae_parametro_global" parametro="debug.expira"
					returnvariable="debug_expira"/>
					
				<cfif Not IsDate(debug_expira)>
					<cfreturn>
				</cfif>
				<cfif debug_expira LT Now()>
					<cfreturn>
				</cfif>

				<cfset factory = CreateObject('java', 'coldfusion.server.ServiceFactory')>
				<cfset cfdebugger = factory.getDebuggingService()>
				<cfset qEvents = cfdebugger.getDebugger().getData()>
	
				<cfquery dbtype="query" name="qEvents" debug="false">
					select * from qEvents
				</cfquery>
				
				<cfquery dbtype="query" name="executionTime" maxrows="1" debug="false">
					select (endTime - startTime) as executionTime
					from qEvents
					where type = 'ExecutionTime'
				</cfquery>
				<cfset debugid = This.saveRequest(executionTime.executionTime, cfdebugger.settings.template_mode)>
				<cfset rowsInserted = 1>
				<cfset rowsInserted = rowsInserted + This.saveSummary(debugid, qEvents)>
				<cfset rowsInserted = rowsInserted + This.saveTemplate(debugid, qEvents)>
				<cfset rowsInserted = rowsInserted + This.saveSQL(debugid, qEvents)>
				<cfset rowsInserted = rowsInserted + This.saveException(debugid, qEvents)>
				
				
				<!--- MonDebugIVariables: session, form, url variables --->
				<cfset rowsInserted = rowsInserted + This.saveScopeVars(MonDebugIRequest.identity, "session")>
				<cfset rowsInserted = rowsInserted + This.saveScopeVars(MonDebugIRequest.identity, "form")>
				<cfset rowsInserted = rowsInserted + This.saveScopeVars(MonDebugIRequest.identity, "url")>
				
				<cfset debugTime = getTickCount() - debugStartTime>
				<cflog file="debug-logger" text="Debug time: #debugTime# ms, #rowsInserted# rows, debugid=#debugid#, #CGI.SCRIPT_NAME#">
			<cfcatch type="any">
				<cfset position = "">
				<cfif IsDefined('cfcatch.TagContext') And ArrayLen(cfcatch.TagContext)>
					<cfset position = position & "at #cfcatch.TagContext[1].Template#:#cfcatch.TagContext[1].Line#">
				</cfif>
				<cfif IsDefined('cfcatch.sql') And Len(cfcatch.sql)>
					<cfset position = position & " sql=#cfcatch.sql#">
				</cfif>
				<cflog file="debug-logger" text="Excepcion: #cfcatch.Message# #cfcatch.Detail# #position#, uri=#CGI.SCRIPT_NAME#">
			</cfcatch>
			</cftry>
			</cfsilent>
		</cfif>
	</cffunction>
	
	<cffunction name="transferQ2I">
		<cfargument name="cantidad" type="numeric" default="100">
		<cfset var firstID = 0>
		<cfset var lastID = 0>
		<cfset var columnas = ArrayNew(1)>
		<cfset var tablas = ListToArray("Request,Summary,Template,Exception,SQL,ScopeVars")>
		
		<cfquery datasource="aspmonitor" name="minid">
			select min(debugid) as debugid
			from MonDebugIRequest
		</cfquery>
		<cfset firstID = minID.debugid>
		<cfset lastID = minID.debugid+Arguments.cantidad>
		<cfset tablas = ListToArray("Request,Summary,Template,Exception,SQL,ScopeVars")>
		<cfset ArrayAppend(columnas,"debugid, sessionid, requestid, method, uri, args, requested, executionTime, memoryDelta, srvprocid, ip, login, template_mode")>
		<cfset ArrayAppend(columnas,"debugid, debugline, template, totalExecutionTime, instanceCount, avgExecutionTime")>
		<cfset ArrayAppend(columnas,"debugid, debugline, template, line, parent, fecha, startTime, endTime, executionTime")>
		<cfset ArrayAppend(columnas,"debugid, debugline, template, line, fecha, startTime, endTime, executionTime, exceptionType, message, javaStackTrace, templateStackTrace")>
		<cfset ArrayAppend(columnas,"debugid, debugline, template, line, fecha, startTime, endTime, executionTime, queryName, datasource, sqlText, queryParams, totalRows")>
		<cfset ArrayAppend(columnas,"debugid, scope, name, value")>
		
		<cftransaction>
			<cfloop from="1" to="#ArrayLen(columnas)#" index="i">
				<cfquery datasource="aspmonitor">
					insert into MonDebugQ#tablas[i]# (#columnas[i]#)
					select  #columnas[i]#
					from MonDebugI#tablas[i]#
					where debugid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#firstID#">
						and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lastID#">
				</cfquery>
				<cfquery datasource="aspmonitor">
					delete from MonDebugI#tablas[i]#
					where debugid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#firstID#">
						and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lastID#">
				</cfquery>
			</cfloop>
		</cftransaction>
		
	</cffunction>
	
</cfcomponent>