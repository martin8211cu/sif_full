<!--- Liberacin del Plistas con Ajax:	3/NOV/2008 --->
<!---
	Name         : ajax
	Author       : Rob Gonda
	Created      : December 8, 2005
	Last Updated : January 16, 2006
	History      : Initial Alpha release (rg 12/8/05)
				 : Added error trapping for easier debugging (rg 12/9/05)
				 : Disabled debug output for ajax calls (rg 12/13/05)
				 : Added the ability to restrict to post, get, or both verbs (rg 12/18/05)
				 : Added debug mode methods (rg 12/18/05)
				 : Added http referer enforcement policy (rg 12/18/05)
				 : Reset content to remove application.cfm/cfc html code (rg 01/13/06)
				 : aborted immediately after request is complete to remove onRequestEnd html code (rg 01/13/06)
				 : abort after request is now optional --thru getters and setters-- and defaulted not to. (rg 01/16/06)
				 : added request debug mode  (rg 01/23/06)
				 : added StripCR() to the JS Return to fix bug in cfwddx (rg 01/31/06)
				 : modified invoking method to pass an argumentcollection on named vars (rg 3/5/06)
				 : fix in MetaData call for Blue Dragon (rg 5/22/06)
				 : urlDecode arguments only for Safari. Fixes error when & signs are sent (rg 6/25/06)
				 : if single object is passed as argument, is it passed to the invoked function as a collection (rg 6/25/06)
	Last Updated : July 2, 2007, Ing. scar Bonilla, MBA.
				 : return compressed Ajax data with Gzip
				 
	Purpose		 : extendable component for cf+ajax framework
--->

<cfcomponent displayname="ajax">
	<cfsetting showdebugoutput="yes">

	<cfscript>
		// note: script has to reside outside of the init function because instance variables can be overridden.
	
		// create structure to hold instance variables
		variables.instance = structNew();
		
		// set allowed verbs to support both get and post
		setAllowedVerbs('get,post');
		// set debug mode to disabled
		setDebugMode('');
		// set http referer check to disabled
		setCheckHTTPReferer(false);
		// do not abort after request
		setAbortAfterRequest(false);
	</cfscript>

	<!--- 
		function: init
		in: void
		out: outputs return to screen
		notes: automatically called by engine.js
	 --->
	<cffunction name="init" access="remote" output="yes" returntype="void">
		<cfscript>
			var result = '';
			var methodArgumentCollection = structNew();
			var methodParameters = '';
			var methodParametersLength = 0;
			var methodParameterName = '';
			var i = 0;
			if ( getDebugMode() eq 'init' ) {
				debug();
			}
			
			// check is http referer policy is enabled
			if (getCheckHTTPReferer() eq true) {
				if (CGI.SERVER_NAME neq GetHostFromURL(CGI.HTTP_REFERER)) {
					throw('ajaxCFC','http referer policy violated');
				}
			}
			
			// check if ajax request was submitted with post verb
			if (CGI.REQUEST_METHOD eq "POST") {
				// check if verb is allowed
				if (isVerbAllowed(CGI.REQUEST_METHOD) eq true) {
					variables.ajax = parseURL(FORM);
				} else {
					throw('ajaxCFC','POST method not allowed');
				}
				
			// check if ajax request was submitted with get verb
			} else if (CGI.REQUEST_METHOD eq "GET") {
				// check if verb is allowed
				if (isVerbAllowed(CGI.REQUEST_METHOD) eq true) {
					variables.ajax = parseURL(URL);
				} else {
					throw('ajaxCFC','GET method not allowed');
				}
			
			// this should never happen
			} else {
				return;
			}

			if ( getDebugMode() eq 'request' ) {
				debug(ajax);
			}
		</cfscript>
		
		<cftry>
			<cfif arrayLen(ajax.params) eq 1 and not isSimpleValue(ajax.params[1])>
				<cfinvoke method="#ajax.method#" returnvariable="result" argumentcollection="#ajax.params[1]#" />	
			<cfelse>
				<cfscript>
				// Gets the parameters from the function that will be invoked
				methodMetaDataDump = getMetaData(this).FUNCTIONS;
				for (i=1; i LTE arraylen(methodMetaDataDump); i = i + 1) {
					if (methodMetaDataDump[i].NAME eq ajax.method) {
						methodParameters = methodMetaDataDump[i].PARAMETERS;
					}
				}
				methodParametersLength = arraylen(methodParameters);
				//Build the arguments collection
				for (i = 1; i LTE arraylen(ajax.params); i = i + 1) {
					//When passing more arguments than are defined in the function we will give them a unique name
					if(i LTE methodParametersLength) {
						methodParameterName = methodParameters[i].name;
					}
					else {
						methodParameterName = 'unknown' & i;
					}
					structInsert(methodArgumentCollection, methodParameterName, ajax.params[i]);
				}
				</cfscript>
				<cfinvoke method="#ajax.method#" returnvariable="result" argumentcollection="#methodArgumentCollection#" />	
			</cfif>
		<cfcatch type="Any">
			<cfset alertError(cfcatch, ajax.id) /><cfabort />
		</cfcatch>
		</cftry>
		
		<cfset result = StripCR(convertResult(result, ajax.id))>
		
		<cfscript>
			returnAjax(result, ajax.id);

			if ( getDebugMode() eq 'result' ) {
				debug(result);
			}
		</cfscript>		
		<!--- if specifically requested to abort --->
		<cfif getAbortAfterRequest()><cfabort /></cfif>
	</cffunction>
	

	<!--- 
		function: parseURL
		in: ajax url with 'get' verb
		out: void
	 --->
	<cffunction name="parseURL" access="private" output="No">
		<cfargument name="objURL" required="Yes" type="struct" />
			
			<cfset var params = arrayNew(1) />
			<cfset var paramsArray = StructKeyArray(objURL) />
			<cfset var i = "" />
			<cfset var result = structNew() />
			
			<cfset arraySort(paramsArray, 'textnocase') />
			
			<cfloop from="1" to="#arrayLen(paramsArray)#" index="i">
				<cfif left(paramsArray[i], 8) eq "C0-PARAM">
					<cfset arrayAppend(params, parseParam( objURL[paramsArray[i]] ) ) />
				</cfif>
			</cfloop>
			
			<cfset result.method = duplicate(objURL['C0-METHODNAME']) />
			<cfset result.id = duplicate(objURL['C0-ID']) />
			<cfset result.params = params />

		<cfreturn result />
	</cffunction>
	
	<!--- 
		function: parseParam
		in: wddx encoded parameter 
		out: decoded parameter
	 --->
	<cffunction name="parseParam" access="private" output="No">
		<cfargument name="param" required="Yes" type="string" />
		
			<cfscript>
				param = removeChars(param, 1, 7);
				if (findNoCase(cgi.HTTP_USER_AGENT,"safari")) {
					param = urlDecode(param);
				}
				param = wddx('WDDX2CFML',param);
				
				return param;
			</cfscript>
			
	</cffunction>
	
	<!--- 
		function: debug
		in: optionally takes an input to dump
		out: void
	 --->
	<cffunction name="debug" access="private" output="No" returntype="void">
		<cfargument name="input" required="No" default="" />
		
		<cfset var debugFile = expandpath('debug.html') />
		<cfset var debungInfo = "" />

		<cfsavecontent variable="debungInfo">
			<cfdump var="#arguments.input#" label="custom">
			<cfdump var="#form#" label="form">
			<cfdump var="#url#" label="url">
			<cfdump var="#cgi#" label="cgi">
		</cfsavecontent>
		<cffile action="WRITE" file="#debugFile#" output="#debungInfo#" />
	</cffunction>
	
	<!--- 
		function: wddx
		in: action, input (wddx encoded)
		out: decoded
	 --->
	<cffunction name="wddx" access="private" output="No" hint="udf version of cfwddx">
		<cfargument name="action" required="Yes" />
		<cfargument name="input" required="Yes" />
		
		<cfset var r = "" />
		<cfwddx action="#arguments.action#" input="#arguments.input#" output="r" />
		<cfreturn r />		
	</cffunction>
	
	
	<!--- 
		function: returnAjax
		in: result and id
		out: void
		note: outputs result back to the screen
		Last Updated : July 2, 2007, Ing. scar Bonilla, MBA.
					 : return compressed Ajax data with Gzip
	 --->
	<cffunction name="returnAjax" access="private" output="Yes" returntype="void">
		<cfargument name="result" required="Yes" />
		<cfargument name="id" required="Yes" />

		<cfif cgi.HTTP_ACCEPT_ENCODING contains "gzip">
			<cfset LvarResult = Arguments.result & " DWREngine._handleResponse('#id#', _#id#);">
			<cfset LvarByte_os = createObject("java","java.io.ByteArrayOutputStream").init()>
			<cfset LvarGzip_os = createObject("java","java.util.zip.GZIPOutputStream").init(LvarByte_os)>
			<cfset LvarGzip_os.write(LvarResult.getBytes("utf-8"))>
			<cfset LvarGzip_os.close()>
			<cfset LvarByte_os.flush()>
			<cfset LvarByte_os.close()>
			<cfset LvarResult = LvarByte_os.toByteArray()>
			<cfheader name="Content-Encoding" value="gzip">
			<cfcontent reset="Yes" type="text/html; charset=utf-8" variable="#LvarResult#">
		<cfelse>
			<cfoutput><cfcontent reset="Yes">
				#result#
				DWREngine._handleResponse('#id#', _#id#);
			</cfoutput>
		</cfif>
	</cffunction>
	
	<!--- 
		function: alertError
		in: error and id
		out: void
		note: alerts cferror trapped by cfcatch to user
	 --->
	<cffunction name="alertError" access="private" output="Yes" returntype="void">
		<cfargument name="objError" required="Yes" />
		<cfargument name="id" required="Yes" />
		<cfoutput>
			alert('An error has occurred:\nMessage:#jsStringFormat(arguments.objError.message)#');
			var _#id# = null;
			DWREngine._handleResponse('#id#', _#id#);
		</cfoutput>
		
	</cffunction>

	<!--- 
		function: convertResult
		in: result and id
		out: string: wddx javascript with wddx encoded values
		note: helper function, converts results to javascript wddx
	 --->
	<cffunction name="convertResult" returntype="string" output="No" >
		<cfargument name="result" required="yes">
		<cfargument name="id" required="yes">
		<cfset var returnVar = "" />
		<cfwddx action="CFML2JS" input="#result#" toplevelvariable="_#id#" output="returnVar">
		<cfreturn returnVar />
	</cffunction>
	
	<!--- 
		function: getAllowedVerbs
		in: 
		out: string: get, post, or both
		note: 
	 --->
	<cffunction name="getAllowedVerbs" returntype="string" output="No">
		<cfreturn variables.instance.allowedVerbs />
	</cffunction>
	
	<!--- 
		function: setAllowedVerbs
		in: string: get, post, or both
		out: void
		note: 
	 --->
	<cffunction name="setAllowedVerbs" output="No" returntype="void">
		<cfargument name="verbs" default="" required="Yes" type="string" />
		
		<cfif arguments.verbs neq 'get' and arguments.verbs neq 'post' and arguments.verbs neq 'get,post' and arguments.verbs neq 'post,get'>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ajax1"
			Default="el argumento verbs , solo permite los valores get,post o una combinación de los mismos "
			returnvariable="LB_ajax1"/> 
			
			<cf_throw message="#LB_ajax1#" errorCode="12005">
		</cfif>
		
		<cfset variables.instance.allowedVerbs = arguments.verbs />
	</cffunction>
	
	<!--- 
		function: getDebugMode
		in: 
		out: string: ...
		note: 
	 --->
	<cffunction name="getDebugMode" returntype="string" output="No">
		<cfreturn variables.instance.debugMode />
	</cffunction>
	
	<!--- 
		function: setDebugMode
		in: string: get, post, or both
		out: void
		note: 
	 --->
	<cffunction name="setDebugMode" output="No" returntype="void">
		<cfargument name="mode" default="" required="Yes" type="string" />
		
		<cfif len(arguments.mode) and listFind('init,result,request',arguments.mode) eq 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ajax2"
			Default="el argumento mode , solo permite los valores init,result,request "
			returnvariable="LB_ajax2"/> 
			<cf_throw message="#LB_ajax2#" errorCode="12010">
		</cfif>
		
		<cfset variables.instance.debugMode = arguments.mode />
	</cffunction>

	<!--- 
		function: getCheckHTTPReferer
		in: 
		out: boolean
		note: 
	 --->
	<cffunction name="getCheckHTTPReferer" returntype="boolean" output="No">
		<cfreturn variables.instance.checkHTTPReferer />
	</cffunction>
	
	<!--- 
		function: setCheckHTTPReferer
		in: boolean
		out: void
		note: 
	 --->
	<cffunction name="setCheckHTTPReferer" output="No" returntype="void">
		<cfargument name="check" default="false" required="Yes" type="boolean" />
		
		<cfif isBoolean(arguments.check) eq false>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ajax3"
			Default="el argumento check , tiene un valor invalido "
			returnvariable="LB_ajax3"/> 
			<cf_throw message="#LB_ajax3#" errorCode="12015">
			
		</cfif>
		
		<cfset variables.instance.checkHTTPReferer = arguments.check />
	</cffunction>

	<!--- 
		function: setAbortAfterRequest
		in: boolean
		out: void
		note: 
	 --->
	<cffunction name="setAbortAfterRequest" output="No" returntype="void">
		<cfargument name="abortAfterRequest" default="false" required="Yes" type="boolean" />
		
		<cfif isBoolean(arguments.abortAfterRequest) eq false>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ajax4"
			Default="el argumento abortAfterRequest , tiene un valor invalido "
			returnvariable="LB_ajax4"/> 
			<cf_throw message="#LB_ajax4#" errorCode="12020">
			
		</cfif>
		
		<cfset variables.instance.abortAfterRequest = arguments.abortAfterRequest />
	</cffunction>

	<!--- 
		function: getAbortAfterRequest
		in: 
		out: boolean
		note: returns abortAfterRequest
	 --->
	<cffunction name="getAbortAfterRequest" output="No" returntype="boolean">
		<cfreturn variables.instance.abortAfterRequest />
	</cffunction>

	<!--- 
		function: isVerbAllowed
		in: verb
		out: boolean
		note: 
	 --->
	<cffunction name="isVerbAllowed" output="No" returntype="boolean">
		<cfargument name="verb" default="" required="Yes" type="string" />
		
		<cfif arguments.verb neq 'get' and arguments.verb neq 'post'>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ajax5"
			Default="el argumento verb , solo puede alojar get o  post"
			returnvariable="LB_ajax5"/> 
			<cf_throw message="#LB_ajax5#" errorCode="12025">
			
			
		</cfif>
		
		<cfreturn ListFindNoCase(getAllowedVerbs(),arguments.verb) gt 0 />
	</cffunction>

	<!---
	 Mimics the CFTHROW tag.
	 
	 @param Type 	 Type for exception. (Optional)
	 @param Message 	 Message for exception. (Optional)
	 @param Detail 	 Detail for exception. (Optional)
	 @param ErrorCode 	 Error code for exception. (Optional)
	 @param ExtendedInfo 	 Extended Information for exception. (Optional)
	 @param Object 	 Object to throw. (Optional)
	 @return Does not return a value. 
	 @author Raymond Camden (ray@camdenfamily.com) 
	 @version 1, October 15, 2002 
	--->
	<cffunction name="throw" output="No" returnType="void" hint="CFML Throw wrapper">
		<cfargument name="type" type="string" required="false" default="Application" hint="Type for Exception">
		<cfargument name="message" type="string" required="false" default="" hint="Message for Exception">
		<cfargument name="detail" type="string" required="false" default="" hint="Detail for Exception">
		<cfargument name="errorCode" type="string" required="false" default="" hint="Error Code for Exception">
		<cfargument name="extendedInfo" type="string" required="false" default="" hint="Extended Info for Exception">
		<cfargument name="object" type="any" hint="Object for Exception">
		
		<cfif not isDefined("object")>
			 
			<cf_throw message="#message#" errorCode="12030">
		<cfelse>
			<cf_throw message="#object#" errorCode="12030">
		</cfif>
		
	</cffunction>
	
	<!--- 
		function: GetHostFromURL
		in: URL
		out: host name
		note: 
	 --->
	<cffunction name="GetHostFromURL" output="No" returntype="string">
		<cfargument name="url" required="Yes" type="string" >
		
		<cfscript>
			var returnHost = arguments.url;
			if (left(returnHost, 7) eq 'http://') {
				returnHost = removeChars(returnHost, 1, 7);
			}
			if (left(returnHost, 8) eq 'https://') {
				returnHost = removeChars(returnHost, 1, 8);
			}
			if (find('/',returnHost)) {
				returnHost = left(returnHost, find('/',returnHost)-1);
			}
			return returnHost;
		</cfscript>
		
	</cffunction>

</cfcomponent>
