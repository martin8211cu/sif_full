<!---
	Utiliza el api de opensmpp
--->

<cfcomponent>

<cfset This.ipAddress = "10.7.7.30">
<cfset This.port = "12345">
<cfset This.session = false>
<cfset This.systemId = "pavel" >
<cfset This.password = "dfsew" >
<cfset This.bound = false>
<cfset This.systemType = "">
<cfset This.addressRange = create_address_range("1", "1", "11*")>

	<cfset This.sourceAddress = CreateObject ( "java", "org.smpp.pdu.Address" ) >
	<cfset This.sourceAddress.init ( 1, 1, '0' ) >
	
<cfset This.sourceAddress = create_address("1", "1", "8381218")>
ok
<cfabort>

<!---
<cfset x = CreateObject ("java", "java.lang.System")>
<cfset cp = x.getProperty("java.class.path")>
<cfdump var="#ListToArray(cp,';')#">
<cfflush>
--->
<cffunction name="bind">

	<cfif This.bound>
		<cflog file="smpp" text="Bind request: Already bound">
		<cfthrow message="Already bound">
	</cfif>
	<cfset request_sm = CreateObject("java", "org.smpp.pdu.BindTransmitter")>
	<cfset request_sm.init ( ) >

	<cfset connection = CreateObject ( "java", "org.smpp.TCPIPConnection" )>
	<cfset connection.init ( This.ipAddress, This.port) >
	<cfset connection.setReceiveTimeout ( JavaCast ( "int", 20 * 1000) ) > 
	<cfset This.session = CreateObject ( "java", "org.smpp.Session" )>
	<cfset This.session.init ( connection ) >

	<cfset request_sm.setSystemId ( This.systemId ) >
	<cfset request_sm.setPassword ( This.password ) >
	<cfset request_sm.setSystemType ( This.systemType ) >
	
	<cfset request_sm.setInterfaceVersion ( JavaCast("int", 3 * 16 + 4 )) >
	<cfset request_sm.setAddressRange ( This.addressRange ) >

	<cflog file="smpp" text="Bind request: #request_sm.debugString()#">
	<cfset response_sm = This.session.bind ( request_sm ) >
	<cflog file="smpp" text="Bind response #response_sm.debugString()#">
	<cfif response_sm.getCommandStatus() Is 0>
		<!--- Data.ESME_ROK == 0 --->
		<cfset This.bound = True>
	</cfif>
</cffunction>

<cffunction name="create_address">
	<cfargument name="ton" >
	<cfargument name="npi" >
	<cfargument name="addr" type="string" >
	
	<cfset var ret = CreateObject ( "java", "org.smpp.pdu.Address" ) >
	<cfset ret.init ( Arguments.ton, Arguments.npi, Arguments.addr ) >

	<cfreturn ret>	
</cffunction>

<cffunction name="create_address_range">
	<cfargument name="ton" >
	<cfargument name="npi" >
	<cfargument name="addr" >
	
	<cfset var ret = CreateObject ( "java", "org.smpp.pdu.AddressRange" ) >
	<cfset ret.init ( Arguments.ton, Arguments.npi, Arguments.addr )>

	<cfreturn ret>	
</cffunction>

<cffunction name="submit_sm">

	<cfset request_sm = CreateObject ( "java", "org.smpp.pdu.SubmitSM" ) >
	<cfset request_sm.init ( ) >
		SubmitSMResp response;

	// input values
	<cfset serviceType = "">
	<cfset sourceAddress = create_address( "1", "1", "8381218") >
	<cfset destAddress = create_address("1", "1", "8381218") >
	<cfset shortMessage = "The short message">
	<cfset scheduleDeliveryTime = "">
	<cfset validityPeriod = "">
	<!--- bytes --->
	<cfset esmClass = 0 >
	<cfset protocolId = 0>
	<cfset priorityFlag = 0>
	<cfset registeredDelivery = 0>
	<cfset replaceIfPresentFlag = 0>
	<cfset dataCoding = 0>
	<cfset smDefaultMsgId = 0>

	// set values
	<cfset request_sm.setServiceType(serviceType)>
	<cfset request_sm.setSourceAddr(sourceAddress)>
	<cfset request_sm.setDestAddr(destAddress)>
	<cfset request_sm.setReplaceIfPresentFlag(replaceIfPresentFlag)>
	<cfset request_sm.setShortMessage(shortMessage)>
	<cfset request_sm.setScheduleDeliveryTime(scheduleDeliveryTime)>
	<cfset request_sm.setValidityPeriod(validityPeriod)>
	<cfset request_sm.setEsmClass(esmClass)>
	<cfset request_sm.setProtocolId(protocolId)>
	<cfset request_sm.setPriorityFlag(priorityFlag)>
	<cfset request_sm.setRegisteredDelivery(registeredDelivery)>
	<cfset request_sm.setDataCoding(dataCoding)>
	<cfset request_sm.setSmDefaultMsgId(smDefaultMsgId)>

	// send the request_sm

	<cfloop from="1" to="1" index="i">
		<cfset request_sm.assignSequenceNumber(true)>
		<cflog file="smpp" text="No. #i#">
		<cflog file="smpp" text="Submit request #request_sm.debugString()#">
		<cfset response = This.session.submit(request_sm)>
		<cflog file="smpp" text="Submit response #response.debugString()#">
		<cfset messageId = response.getMessageId()>
	</cfloop>
</cffunction>

<cffunction name="unbind">
	<cflog file="smpp" text="Going to unbind.">
	<cfif This.session.getReceiver().isReceiver()>
		<cflog file="smpp" text="It can take a while to stop the receiver.">
	</cfif>
	<cfset  response = session.unbind()>
	<cflog file="smpp" text="Unbind response #response.debugString()#">
	<cfset This.bound = false>
</cffunction>

</cfcomponent>
