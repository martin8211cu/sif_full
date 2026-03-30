<cfcomponent>

<cffunction name="onIncomingMessage" output="no">
  <cfargument name="CFEvent" type="struct" required="yes">

	<cfparam name="CFEvent.data.msg" default="">
	<cfparam name="CFEvent.data.id" default="">
	<cflog file="isb_in" text="Mensaje recibido. gw=#CFEvent.GatewayID#, origen= #CFEvent.OriginatorID#: id=#CFEvent.data.id#, msg=#CFEvent.data.msg#">
	
	<!---
	
		other fields:
		GatewayID
		Data
		OriginatorID
		GatewayType
		CFCPath
		CFCMethod
		CFCTimeout
	
	--->
</cffunction>

</cfcomponent>
