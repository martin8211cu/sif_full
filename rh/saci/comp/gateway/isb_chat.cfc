<cfcomponent displayname="echo" hint="Process events from the test gateway and return echo">
<cffunction name="onIncomingMessage" output="no">
  <cfargument name="CFEvent" type="struct" required="yes">
  <!--- Get the message --->
  <cfset data=cfevent.DATA>
  <cfset message="#data.message#">
  <!--- where did it come from? --->
  <cfset orig="#CFEvent.originatorID#">
  <cfset retValue = structNew()>
  <cfif listcontains("XMPP,SAMETIME,YIM,AIM,MSN,ICQ,JSC", arguments.CFEVENT.GatewayType) gt 0>
    <!--- gateway types YIM, AIM, MSN, ICQ and JSC are supported by JBuddy-CF --->
    <cfset retValue.BuddyID = orig>
	<!---
	<cfset retValue.MESSAGE = "echo: " & message>
	--->
	<cftry>
		<cfquery datasource="asp" name="m" maxrows="10">
			set rowcount 10
			# PreserveSingleQuotes( message ) #
			set rowcount 0
		</cfquery>
		<cfset msg = chr(13)>
		<cfloop list="#m.columnList#" index="col">
			<cfset msg = msg & chr(9) & lcase(col)>
		</cfloop>
		<cfloop query="m">
			<cfset msg = msg & chr(13)>
			<cfloop list="#m.columnList#" index="col">
				<cfset msg = msg & chr(9) & LCase(Evaluate("m." & col))>
			</cfloop>
		</cfloop>
		<cfset retValue.MESSAGE = msg>
	<cfcatch type="any">
		<cfset retValue.MESSAGE = cfcatch.Message & ' ' & cfcatch.Detail>
		</cfcatch>
	</cftry>	
  <cfelseif arguments.CFEVENT.GatewayType is "Socket">
    <cfset retValue.originatorID = orig>
    <cfset retValue.message = "echo: " & message>
    <cfelseif arguments.cfevent.gatewaytype is "SMS">
    <cfset retValue.command = "submit">
    <cfset retValue.sourceAddress = arguments.CFEVENT.GatewayID>
    <cfset retValue.destAddress = orig>
    <cfset retValue.shortMessage = "echo: " & message>
  </cfif>
  <!--- send the return message back --->
  <cfreturn retValue>
</cffunction>

<cffunction name="onAddBuddyRequest">
  <cfargument name="CFEvent" type="struct" required="YES">
  <!--- no quiero que acepte más gente --->
  <cfreturn>
  
  <cflock scope="APPLICATION" timeout="10" type="EXCLUSIVE">
    <cfscript>
		// If the name is in the DB once, accept; if it is missing, decline.
		// If it is in the DB multiple times, take no action.
		action="accept";
		reason="Valid ID";
			//Add the buddy to the buddy status structure only if accepted.
		if (NOT StructKeyExists(Application,"buddyStatus")) {
		Application.buddyStatus=StructNew();
		}
		if (NOT StructKeyExists(Application.buddyStatus,
		CFEvent.Data.SENDER)) {
		Application.buddyStatus[#CFEvent.Data.SENDER#]=StructNew();
		}
		Application.buddyStatus[#CFEvent.Data.SENDER#].status="Accepted Buddy Request";
		Application.buddyStatus[#CFEvent.Data.SENDER#].timeStamp=
		CFEvent.Data.TIMESTAMP;
		Application.buddyStatus[#CFEvent.Data.SENDER#].message=CFEvent.Data.MESSAGE;
	</cfscript>
  </cflock>
  <!--- Log the request and decision information. --->
  <cflog file="#CFEvent.GatewayID#Status" text="onAddBuddyRequest; SENDER: #CFEvent.Data.SENDER# MESSAGE:
#CFEvent.Data.MESSAGE# TIMESTAMP: #CFEvent.Data.TIMESTAMP# ACTION: #action#">
  <!--- Return the action decision. --->
  <cfset retValue = structNew()>
  <cfset retValue.command = action>
  <cfset retValue.BuddyID = CFEvent.DATA.SENDER>
  <cfset retValue.Reason = reason>
  <cfreturn retValue>
</cffunction>
<cffunction name="onAddBuddyResponse"></cffunction>
<cffunction name="onBuddyStatus"></cffunction>
<cffunction name="onIMServerMessage"></cffunction>
</cfcomponent>
