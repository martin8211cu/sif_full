<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>

		<cfset initialContextFactory = 'com.sybase.jms.InitialContextFactory'>
		<cfset providerURL = 'iiop://desarrollo.racsa.co.cr:9100'>
		<cfset queueConnectionFactory = 'javax.jms.QueueConnectionFactory'>
		
		<cfset env = CreateObject('java', 'java.util.Properties')>
		<cfset env.init()>
		<cfset jndi = CreateObject('java', 'javax.naming.InitialContext')>
		<cfset env.setProperty(jndi.PROVIDER_URL, providerURL)>
		<cfset env.setProperty(jndi.INITIAL_CONTEXT_FACTORY, initialContextFactory)>
		
		<cfset jndi.init(env)>

		<cfset conFactory = jndi.lookup(queueConnectionFactory)>
		
		<cfdump var="#conFactory#">

</body>
</html>
