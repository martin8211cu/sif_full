<cfparam name="url.tipo" default="0">
<cfparam name="url.proxyserver" default="">
<cfparam name="url.proxyport"	default="1">
<cfif url.tipo EQ "1">
	<cfhttp 
		method="get" 
		url="https://www.gruponacion.biz/WssOIN/sERVICIO.ASMX?wsdl"
		result="hola"
		throwonerror="no"
		proxyserver="#url.proxyserver#"
		proxyport="#url.proxyport#"
	>
	</cfhttp>
	<cfdump var="#hola#">
<cfelse>
	<cfinvoke 
		webservice="https://www.gruponacion.biz/WssOIN/sERVICIO.ASMX?wsdl"
		method="queryDataset"
		returnvariable="dsAgencias"
		proxyserver="#url.proxyserver#"
		proxyport="#url.proxyport#"
	>
	</cfinvoke>
	<cfdump var="#dsAgencias#">
</cfif>