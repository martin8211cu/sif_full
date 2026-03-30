<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body style="margin:0">

<h1>Monitor @ <cfoutput>#Now()#</cfoutput>
<a href="status.cfm">reload</a></h1>

<h2>server.monitor_accesos:</h2>
<p><cfif IsDefined('server.monitor_accesos')>
<table border="1" width="900">
<tr><th>thread</th>
    <th>requestid</th>
    <th>startTime</th>
    <th>finishTime</th>
    <th>sess</th>
    <th>scriptName</th>
    <th>queryString</th>
    </tr>
<cfoutput>
<cfloop from="1" to="#ArrayLen(server.monitor_accesos)#" index="num">
<cfset x = server.monitor_accesos[num]>
<tr><td>#x.threadName#</td>
    <td>#x.requestid#</td>
    <td>#x.startTime#</td>
    <td>#x.finishTime#</td>
    <td>#x.sessionId#</td>
    <td>#x.scriptName#</td>
    <td>#x.queryString#</td>
    </tr>
</cfloop></cfoutput></table>

<cfelse>-NO HAY-
</cfif></p>

<h2>server.monitor_thread:</h2>
<p><cfif IsDefined('server.monitor_thread')>

<table border="1">
<tr><th>thread</th>
    <th>requestid</th>
    <th>startTime</th>
    <th>finishTime</th>
    <th>sess</th>
    <th>scriptName</th>
    <th>queryString</th>
    </tr>
<cfoutput>
<cfloop list="#ListSort( StructKeyList( server.monitor_thread), 'Text'  )#" index="tname">
<cfset x = server.monitor_thread[tname]>
<tr><td>#x.threadName#</td>
    <td>#x.requestid#</td>
    <td>#x.startTime#</td>
    <td>#x.finishTime#</td>
    <td>#x.sessionId#</td>
    <td>#x.scriptName#</td>
    <td>#x.queryString#</td>
    </tr>
</cfloop></cfoutput></table>
<cfelse>-NO HAY-
</cfif></p>

</body>
</html>
