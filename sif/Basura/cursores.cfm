<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="refresh" content="5">
<title>Untitled Document</title>
</head>

<body>
<cfquery datasource="aspmonitor" name="usuarios">
	select a.sessionid, b.login, b.ip, count(1)
	from MonRequest a
		join MonProcesos b
			on b.sessionid = a.sessionid
	where requested >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n', -5, Now())#">
	  and requestid > (select max (requestid) from MonRequest) - 1000
	group by a.sessionid, b.login, b.ip
</cfquery>
<cfdump var="#usuarios#" label="Usuarios Conectados">


<table border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2">
	

<cfset jdbcDriver = CreateObject("java", "macromedia.jdbc.MacromediaDriver")>
<cfoutput>
Macromedia Drivers Version #jdbcDriver.getMajorVersion()#.#jdbcDriver.getMinorVersion()#
</cfoutput>
	</td>
  </tr>
  <tr>
    <td valign="top">
	<!---
	<cfquery datasource="minisif" name="the_query">
	select (
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Int(Rand() * 1000)#">
	) as CURSOR_TEST, #Int(Rand() * 1000)# as M from DUAL
</cfquery>
<cfdump var="#the_query#" label="query que crea cursores">
<hr>
--->
<cfquery datasource="minisif" name="curbyconn">
	select user_name, sid, count(1) as cantidad
	from v$open_cursor 
	where USER_NAME = 'MINISIF2' 
	group by user_name, sid
</cfquery>
<cfdump var="#curbyconn#" label="Cursores por conexion">
</td>
    <td valign="top">
	
<cfquery datasource="minisif" name="cursores">
	select hash_value, sid, sql_text, user_name
	from v$open_cursor
	where USER_NAME = 'MINISIF2' 
	/*and SQL_TEXT like '%CURSOR'||'_TEST%'*/
	order by sid, upper(SQL_TEXT)
</cfquery>
<cfdump var="#cursores#" label="cursores">
	
	</td>
  </tr>
</table>

 


</body>
</html>
