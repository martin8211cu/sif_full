


<cfcomponent extends="taffy.core.api">
	<cfset This.loginstorage="Session">
	<cfset This.sessionmanagement="True">
	<cfset session.dsn = "">
	<cfscript>

		this.name = hash(getCurrentTemplatePath());

		this.mappings["/resources"] = listDeleteAt(cgi.script_name, listLen(cgi.script_name, "/"), "/") & "/resources";

		variables.framework = {};
		variables.framework.debugKey = "debug";
		variables.framework.reloadKey = "reload";
		variables.framework.reloadPassword = "true";
		variables.framework.serializer = "taffy.core.nativeJsonSerializer";
		variables.framework.returnExceptionsAsJson = true;
		variables.framework.allowCrossDomain = true;

		function onApplicationStart(){
			return super.onApplicationStart();
		}

		function onRequestStart(TARGETPATH){
			return super.onRequestStart(TARGETPATH);
		}

		// this function is called after the request has been parsed and all request details are known
		function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers){
			//allow white-listed requests through
			
			if (cfc == "login" || cfc == "echo"){
				return true;
			}
	
			//otherwise require a device token
			if (!structKeyExists(arguments.requestArguments, "token")){
	
				return newRepresentation().noData().withStatus(401, "Not Authenticated");
	
			//and make sure it's valid
			}else if (!validateToken(arguments.requestArguments.token)){
	
				return newRepresentation().noData().withStatus(403, "Not Authorized");
				
			}
			
			rsUserData = getTokenInfo(arguments.requestArguments.token);
			userData = structNew();
			
			userData["usucodigo"] = rsUserData.usucodigo;
			userData["login"] = rsUserData.login;
			userData["cecodigo"] = rsUserData.cecodigo;
			
			session["usucodigo"] = rsUserData.usucodigo;
			session["login"] = rsUserData.login;
			session["cecodigo"] = rsUserData.cecodigo;
			
			if (structKeyExists(arguments.requestArguments, "ecodigo")){
				userData["ecodigo"] = arguments.requestArguments.ecodigo;
				session["ecodigo"] = arguments.requestArguments.ecodigo;
				
				rsDSN = getDSN(arguments.requestArguments.ecodigo);
				if (rsDSN.recordCount > 0) {
					userData["dsn"] = rsDSN.Ccache;					
					session["dsn"] = rsDSN.Ccache;					
					session["EcodigoSDC"] = rsDSN.EcodigoSDC;					
					session["Enombre"] = rsDSN.Enombre;					
				} else {
					return newRepresentation().noData().withStatus(400, "Empresa invalida");
				}
			}
			
			arguments.requestArguments["userData"] = userData;
			//if a token is included, and valid, allow the request to continue
			return true;
		}

		
	</cfscript>
	
	<cffunction name="validateToken" access="private">
		<cfargument name="token" type="string" required="true">
		<cfquery name="rsToken" datasource="aspmonitor">
			select count(1) valid
			from MonProcesos mp
			where cerrada = 0
				and CONVERT(VARCHAR(32),HashBytes('MD5', convert(varchar(32),sessionid)),2) = '#arguments.token#'
		</cfquery>
		<cfreturn rsToken.valid>
	</cffunction>

	<cffunction name="getTokenInfo" access="private">
		<cfargument name="token" type="string" required="true">
		<cfquery name="rsToken" datasource="aspmonitor">
			select Usucodigo, login, CEcodigo, cerrada
			from MonProcesos mp
			where cerrada = 0
				and CONVERT(VARCHAR(32),HashBytes('MD5', convert(varchar(32),sessionid)),2) = '#arguments.token#'
		</cfquery>
		<cfreturn rsToken>
	</cffunction>
	
	<cffunction name="getDSN" access="private">
		<cfargument name="ecodigo" type="numeric" required="true">
		<cfquery name="rsCache" datasource="asp">
			select e.Ereferencia ecodigo, c.Ccache, e.Ecodigo EcodigoSDC, e.ENombre
					from Empresa e
					inner join Caches c on e.Cid = c.Cid
					where e.Ereferencia = #arguments.ecodigo#
		</cfquery>
		<cfreturn rsCache>
	</cffunction>
</cfcomponent>
