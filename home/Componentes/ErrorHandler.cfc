<cfcomponent output="false" hint="Funciones auxiliares para el error handler de home/public/error/handler.cfm">
<!---
	El componente se hizo para poder atrapar varios errores en un request.
	Permita guardar los errores que hayan ocurrido dentro de un cfcatch,
	sin necesidad de hacer cfinclude y el enredo, además de su uso habitual
	uso dentro del home/public/error/handler.cfm para el <cferror>.
	Invóquese así dentro de un cfcatch:
	<cfcatch type="any">
		<cfinvoke component="home.Componentes.ErrorHandler" method="guardarError" 
			error="#cfcatch#" returnvariable="errorid"/>
	</cfcatch>
--->
	<!---addStackTrace--->
	<cffunction name="addStackTrace" access="public" output="false" returntype="string">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="exclude" type="string" default="">
		<cfargument name="Values" type="struct" required="no">
		<cfset var Keys = "">
		<cfset var _retvalue = "">
		<cfif IsDefined(Arguments.Name) Or IsDefined('Arguments.Values')>
			<cfif Not IsDefined('Arguments.Values')>
				<cfset Arguments.Values = Evaluate(Arguments.Name)>
			</cfif>
			<cfset keys = StructKeyArray(Arguments.Values)>
			<cfset ArraySort(keys,'text')>
			<cfif ArrayLen(keys)>
				<cfset _retvalue = _retvalue &
						"<strong>" & HTMLEditFormat(Name) & ":</strong><br>">
				<cfloop from="1" to="#ArrayLen(keys)#" index="ikey">
					<cfif IsSimpleValue(Arguments.Values[keys[ikey]]) And (ListFindNoCase(Arguments.Exclude, keys[ikey]) EQ 0)>
						<cfset _retvalue = _retvalue &
								LCase( keys[ikey] ) & "=" & SimpleValueFormat(Arguments.Values[keys[ikey]]) & "<br>">
					<cfelseif IsStruct(Arguments.Values[keys[ikey]]) And (ListFindNoCase(Arguments.Exclude, keys[ikey]) EQ 0)>
						<cfset _retvalue = _retvalue &
								addStackTraceStruct(LCase( keys[ikey] ) , Arguments.Values[keys[ikey]] )>
					<cfelse>
						<cfset _retvalue = _retvalue &
								LCase( keys[ikey] ) & "= ... <br>">
					</cfif>
				</cfloop>
				<cfset _retvalue = _retvalue & "<br>">
			</cfif>
		</cfif>
		<cfreturn _retvalue>
	</cffunction>
	<!---addStackTraceStruct--->
	<cffunction name="addStackTraceStruct" access="public" output="false" returntype="string">
		<cfargument name="SName"     required="yes">
		<cfargument name="SValues"    required="yes">
		
		<cfset var SKeys = StructKeyArray(Arguments.SValues)>
		<cfset var _retvalue2 = "">
		<cfset ArraySort(SKeys,'text')>
		<cfif ArrayLen(SKeys)>
			<cfloop from="1" to="#ArrayLen(SKeys)#" index="ikey">
				<cfif IsSimpleValue(Arguments.SValues[SKeys[ikey]])>
					<cfset _retvalue2 = _retvalue2 &
							HTMLEditFormat(SName) & "." & LCase( SKeys[ikey] ) & "=" & SimpleValueFormat(Arguments.SValues[SKeys[ikey]]) & "<br>">
				</cfif>
			</cfloop>
		</cfif>
		<cfreturn _retvalue2>
	</cffunction>
	<!---SimpleValueFormat--->
	<cffunction name="SimpleValueFormat" access="public" output="false" returntype="string">
		<cfargument name="value" type="string" required="yes">
		<cfif Len(Arguments.Value) GE 100 And 
			Not Find(' ', Arguments.Value) And Find(';', Arguments.Value)>
			<cfreturn HTMLEditFormat(Replace(Arguments.value, ';', '; ', 'all'))>
		<cfelseif Len(Arguments.Value) GE 100 And 
			Not Find(' ', Arguments.Value) And Find('&', Arguments.Value)>
			<cfreturn HTMLEditFormat(Replace(Arguments.value, '&', '& ', 'all'))>
		<cfelse>
			<cfreturn HTMLEditFormat(Arguments.Value)>
		</cfif>
	</cffunction>
	<!---addWhere--->
	<cffunction name="addWhere" access="public" output="false" returntype="string">
		<cfargument name="where" type="string" required="yes">
		
		<cfset var _retvalue3 = "">
		<cfset _retvalue3 = _retvalue3 & "<strong>SQL Params</strong>:<br>">
		<cfset start_position = 1>
		<cfset addWhere_re = "\(param ([0-9]+)\) = \[type=\'([^],]+)\'(?:, class=\'([^],]+)\')?(?:, value=\'([^],]*)\')?, sqltype=\'([^],]+)\'((?:,[^]]+)?)\]">
		<cfloop condition="true">
			<cfset ref = REFind(addWhere_re,Arguments.where,start_position,true)>
			<cfif ref.pos[1] Is 0 or ref.len[1] Is 0>
				<cfbreak>
			</cfif>
			<cfif start_position Is 1>
				<cfset _retvalue3 = _retvalue3 & "<table border=1 cellpadding=2 cellspacing=0 style=margin-left:12px><tr><td>##</td><td>type</td><td>class</td><td>value</td><td colspan=2>sqltype</td></tr>">
			</cfif>
			<cfset _retvalue3 = _retvalue3 & "<tr>">
			<cfloop from="2" to="#ArrayLen(ref.pos)#" index="i">
				<cfif ref.pos[i] Neq 0 and ref.len[i] Neq 0>
					<cfset _retvalue3 = _retvalue3 & "<td>" & Mid(where, ref.pos[i], ref.len[i])& "</td>">
				<cfelse>
					<cfset _retvalue3 = _retvalue3 & "<td>" & "&nbsp;</td>">
				</cfif>
			</cfloop>
			<cfset _retvalue3 = _retvalue3 & "</tr>">
			<cfset start_position = ref.pos[1] + ref.len[1] + 1>
		</cfloop>
		<cfif start_position neq 1>
			<cfset _retvalue3 = _retvalue3 & "</table>">
		</cfif>
		<cfreturn _retvalue3>
	</cffunction>
	<!---getErrorInfo--->
	<cffunction name="getErrorInfo" returntype="struct" output="false" access="public">
		<cfargument name="error" type="any" required="no">
		<cfset var _ErrorInfo = StructNew()>
		<cfset addRequestInfo(_ErrorInfo, Arguments.error)>
		<cfset addParametersInfo(_ErrorInfo, Arguments.error)>
		<cfreturn _ErrorInfo>
	</cffunction>
	<!---addRequestInfo--->
	<cffunction name="addRequestInfo" returntype="void" output="false" access="public">
		<cfargument name="_ErrorInfo" type="struct">
		<cfargument name="error" type="any">

		<!--- GetHTTPRequestData puede regresar nulo, cuando no se trate de
			una aplicación web, sino de un event gateway siendo invocado --->
		<cftry>
		<cfset httpRequestData = GetHTTPRequestData()>
		<cfcatch type="any"><!--- no hay, queda null y sigue ---></cfcatch></cftry>
		<cfif IsDefined('httpRequestData')>
			<cfset headers = httpRequestData.headers>
		</cfif>
		<!--- Obtener dirección IP del host y del solicitante --->
		<cfset _ErrorInfo.Server = CGI.SERVER_NAME & ":" & CGI.SERVER_PORT>
		<cfset _ErrorInfo.IPAddress = CGI.REMOTE_ADDR>
		<cfif IsDefined('headers')>
			<cfif StructKeyExists(headers,"X-Forwarded-Host")>
				<cfset _ErrorInfo.Server = headers["X-Forwarded-Host"]>
			</cfif>
			<cfif Len(_ErrorInfo.Server) EQ 0>
				<cfset _ErrorInfo.Server = headers["Host"]>
			</cfif>
			<cfif StructKeyExists(headers,"X-Forwarded-For")>
				<cfset _ErrorInfo.IPAddress = headers["X-Forwarded-For"]>
			</cfif>
			<cfif Len(_ErrorInfo.IPAddress) EQ 0>
				<cfset _ErrorInfo.IPAddress = headers["Host"]>
			</cfif>
		</cfif>
		<!--- Resolver dirección IP del solicitante --->
		<!---		Se guarda el ip sin el hostname
		<cftry>
			<cfif not IsDefined('Application.ResolveAddressCache')>
				<cfset Application.ResolveAddressCache = StructNew()>
			</cfif>
			<cfif StructKeyExists(Application.ResolveAddressCache, _ErrorInfo.IPAddress)>
				<cfset _ErrorInfo.IPAddress = _ErrorInfo.IPAddress & "/" 
					& Application.ResolveAddressCache[_ErrorInfo.IPAddress]>
			<cfelse>
				<cfif REFind('^[12]?[0-9]{1,2}(\.[12]?[0-9]{1,2}){3}$', _ErrorInfo.IPAddress )>
					<cfset _ErrorInfo.NumericAddress = ListToArray(_ErrorInfo.IPAddress, ".")>
					<cfobject action="create" type="java" name="InetAddress" class="java.net.InetAddress">
					<cfset HostAddr = InetAddress.getByAddress(_ErrorInfo.NumericAddress)>
					<cfset HostName = HostAddr.getHostName()>
					<cfif _ErrorInfo.IPAddress neq HostName and Len(HostName) Neq 0>
						<cfset StructInsert(Application.ResolveAddressCache, _ErrorInfo.IPAddress, HostName)>
						<cfset _ErrorInfo.IPAddress = _ErrorInfo.IPAddress & "/" & HostName>
					</cfif>
				</cfif>
			</cfif>
		<cfcatch type="any">
		</cfcatch>
		</cftry>
		--->		
		<cfset _ErrorInfo.Login = "anonymous">
		<cfif IsDefined("session.Usuario")>
			<cfset _ErrorInfo.Login = session.Usuario>
		</cfif>
		
		<cfset _ErrorInfo.URL = "//" & _ErrorInfo.Server & CGI.SCRIPT_NAME >
		<cfif Len(CGI.QUERY_STRING)>
			<cfset _ErrorInfo.URL = _ErrorInfo.URL & "?" & CGI.QUERY_STRING>
		</cfif>
	</cffunction>
	<!---addParametersInfo--->
	<cffunction name="addParametersInfo" returntype="void" output="false" access="public">
		<cfargument name="_ErrorInfo" type="struct">
		<cfargument name="error" type="any">

		<cfset var TemplateRoot = Replace(ExpandPath(""), "\", "/",'all')>
		<cfset var _CurLine = ''>
		<cfset _ErrorInfo.StackTrace = "">
		
		<cfif IsDefined("Error.DataSource") and Error.DataSource NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<strong>DataSource</strong>: ">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "#Error.DataSource#<br><br>">
		<cfelseif isDefined("Error.RootCause.DataSource") and Error.RootCause.DataSource NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<strong>DataSource</strong>: ">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "#Error.RootCause.DataSource#<br><br>">
		</cfif>
	
		<cfif IsDefined("Error.SQL") and Error.SQL NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<strong>SQL Statement</strong>:">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<div style=""margin-left:12px;font-family:'Courier New', Courier, mono"">#Error.SQL#</div><br>">
		<cfelseif isDefined("Error.RootCause.SQL") and Error.RootCause.SQL NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<strong>SQL Statement</strong>:">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<div style=""margin-left:12px;font-family:'Courier New', Courier, mono"">#Error.RootCause.SQL#</div><br>">
		<cfelseif isDefined("request.jdbcquerySQL") and request.jdbcquerySQL NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<strong>SQL Statement</strong>:">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<div style=""margin-left:12px;font-family:'Courier New', Courier, mono"">#request.jdbcquerySQL#</div><br>">
		</cfif>
		
		<cfif IsDefined("Error.where") and Error.where NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & addWhere(Error.where)>
		<cfelseif isDefined("Error.RootCause.where") and Error.RootCause.where NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & addWhere(Error.RootCause.where)>
		</cfif>
		
		<cfif _ErrorInfo.StackTrace NEQ "">
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<br>">
		</cfif>
		
		<cfif IsDefined("Error.TagContext") and IsArray(Error.TagContext) and ArrayLen(Error.TagContext) NEQ 0>
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<strong>Template Stack Trace</strong>: (#Error.type#)<br>">
			<cfloop from="1" to="#ArrayLen(error.TagContext)#" index="i">
				<cfset _CurLine = Error.TagContext[i].Template>
				<cfset _CurLine = Replace(_CurLine, "\", "/", 'all')>
				<cfset _CurLine = ReplaceNoCase(_CurLine, TemplateRoot, "")>
				<cfif StructKeyExists(Error.TagContext[i], 'Line')>
					<cfset _CurLine = _CurLine & ":" & Error.TagContext[i].Line>
				</cfif>
				<cfif StructKeyExists(Error.TagContext[i], 'ID')>
					<cfset _CurLine = _CurLine & " (" & Error.TagContext[i].ID & ")">
				</cfif>
				<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & " at " & _CurLine & "<br>" >
			</cfloop>
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<br id=tssend>">
		</cfif>
		
		<!--- se excluye fieldnames por claridad, y cookie y urltoken por seguridad --->
		<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & addStackTrace('url', '')>
		<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & addStackTrace('form', 'fieldnames')>
		<cfif IsDefined('Headers')>
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & addStackTrace('headers', 'cookie', headers)>
		</cfif>
		<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & addStackTrace('session', 'urltoken')>
		
		<cfif IsDefined("Error.StackTrace") and Len(Error.StackTrace) NEQ 0>
			<cfset _ErrorInfo.StackTrace = _ErrorInfo.StackTrace & "<br>" &
				"<strong>Java Stack Trace:</strong><br>" & Error.StackTrace>
		</cfif>
				
		<cfset _ErrorInfo.Message = "Mensaje de error">
		<cfif IsDefined("Error.Message") and Len(Trim(Error.Message))>
			<cfset _ErrorInfo.Message = Error.Message>
			<cfif IsDefined("Error.RootCause.NativeErrorCode") And Len(Error.RootCause.NativeErrorCode) NEQ 0 And Error.RootCause.NativeErrorCode NEQ 0>
				<cfset _ErrorInfo.Message = _ErrorInfo.Message & " [NativeErrorCode " & Error.RootCause.NativeErrorCode & "]">
			</cfif>
		<cfelseif IsDefined("Error.Diagnostics")>
			<cfset _ErrorInfo.Message = Error.Diagnostics>
			<cfif IsDefined("Error.RootCause.NativeErrorCode") And Len(Error.RootCause.NativeErrorCode) NEQ 0 And Error.RootCause.NativeErrorCode NEQ 0>
				<cfset _ErrorInfo.Message = _ErrorInfo.Message & " [NativeErrorCode " & Error.RootCause.NativeErrorCode & "]">
			</cfif>
		</cfif>
		
		<cfset _ErrorInfo.DateTime = Now()>
		<cfif IsDefined("Error.DateTime")>
			<cfset _ErrorInfo.DateTime = Error.DateTime>
		</cfif>
		
		<cfset _ErrorInfo.Diagnostics = "Reporte de error">
		<cfif IsDefined("Error.Diagnostics")>
			<cfset _ErrorInfo.Diagnostics = Error.Diagnostics>
		<cfelseif IsDefined("Error.Message") And IsDefined("Error.Detail")><!--- cuando se incluye dentro de un cfcatch --->
			<cfset _ErrorInfo.Diagnostics = Error.Message & ' ' & Error.Detail>
		</cfif>
		
		<cfif IsDefined("session.monitoreo.SScodigo")>
			<cfset _ErrorInfo.Componente = session.monitoreo.SScodigo & ',' & session.monitoreo.SMcodigo & ',' & session.monitoreo.SPcodigo>
		<cfelse>
			<cfset _ErrorInfo.Componente = ''>
		</cfif>
	</cffunction>
    
    <!---guardarError--->
    <cffunction name="guardarError" output="false" returntype="numeric" access="public">
        <cfargument name="error" type="any" required="no">
        <cfargument name="_ErrorInfo" type="struct" required="no">
        <cfif Not IsDefined('Arguments._ErrorInfo')>
            <cfset Arguments._ErrorInfo = getErrorInfo(Arguments.error)>
        </cfif>

		<cfset Lvardetalle_extra = _ErrorInfo.Diagnostics & "<br>" & _ErrorInfo.StackTrace>
		<!--- Se asume que todas los esquemas estan en una misma base de datos (sybase, oracle, slqserver o db2) por eso solo se pregunta por minisif --->
	    <cfif Application.dsinfo['aspmonitor'].type is 'oracle'>
            <cfset Lvardetalle_extra = replace(Lvardetalle_extra, "'", " ", "all")>
            <cfset LvarStrSize = 2048>
            <cfset Lvardetalle1 = left(Lvardetalle_extra, LvarStrSize)>
            <cfset Lvarlongitud = len(Lvardetalle_extra)>
            <cftransaction>
                <cfquery datasource="aspmonitor" name="data">
                insert into MonErrores (sessionid, componente, titulo, cuando, ip, url, login, detalle, detalle_extra)
                values (
                    <cfif IsDefined('session.monitoreo.sessionid')>
                        <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.monitoreo.sessionid#">
                    <cfelse> 
                        0 
                    </cfif>,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_ErrorInfo.Componente, 40)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_ErrorInfo.Message, 60)#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#_ErrorInfo.DateTime#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_ErrorInfo.IPAddress, 30)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_ErrorInfo.URL, 254)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_ErrorInfo.Login, 40)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Left (_ErrorInfo.Diagnostics, 254)#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar"   value="#Lvardetalle1#">
                    )
                <cf_dbidentity1 datasource="aspmonitor">
                </cfquery>
                <cf_dbidentity2 datasource="aspmonitor" name="data">
            </cftransaction>
            <cfset LvarLlave = -1>
            <cfif isdefined('data.identity')>
                <cfset LvarLlave = data.identity>
                <cfif len(Lvardetalle_extra) GT LvarStrSize>
                    <cfset LvarPosicion = 1>
                    <cfloop condition="LvarPosicion LT Lvarlongitud">
                        <cfset LvarPosicion = LvarPosicion + LvarStrSize>
                        <cfquery datasource="aspmonitor" name="data">
                            update MonErrores 
                            set detalle_extra = {fn concat(detalle_extra, '#mid(Lvardetalle_extra, Lvarposicion, LvarStrSize)#')}
                            where errorid = #LvarLlave#
                        </cfquery>
                    </cfloop>
                </cfif>
            </cfif>
		<cfelse>
            <cftransaction>
				<cfquery datasource="aspmonitor" name="data">
                    insert into MonErrores (sessionid, componente, titulo, ip, url, login, detalle, detalle_extra,cuando)
                    values (
                        <cfif IsDefined('session.monitoreo.sessionid')>
                        	<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#session.monitoreo.sessionid#">,
                        <cfelse> 
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="0">, 
						</cfif>
						<cf_dbfunction name="sPart"	args="'#_ErrorInfo.Componente#'°1°40"  	 datasource="aspmonitor" delimiters="°">,
                     	<cf_dbfunction name="sPart"	args="'#_ErrorInfo.Message#'°1°60"     	 datasource="aspmonitor" delimiters="°">,
						<cf_dbfunction name="sPart"	args="'#_ErrorInfo.IPAddress#'°1°30"   	 datasource="aspmonitor" delimiters="°">,
						<cf_dbfunction name="sPart"	args="'#_ErrorInfo.URL#'°1°255"   		 datasource="aspmonitor" delimiters="°">,
						<cf_dbfunction name="sPart"	args="'#_ErrorInfo.Login#'°1°40"   		 datasource="aspmonitor" delimiters="°">,
						<cf_dbfunction name="sPart"	args="'#_ErrorInfo.Diagnostics#'°1°255"  datasource="aspmonitor" delimiters="°">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Lvardetalle_extra#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#_ErrorInfo.DateTime#">
						)
                    <cf_dbidentity1 datasource="aspmonitor">
                </cfquery>
                <cf_dbidentity2 datasource="aspmonitor" name="data">
            </cftransaction>
             <cfset LvarLlave = data.identity>
        </cfif>
    	<cfreturn LvarLlave>
	</cffunction>
</cfcomponent>