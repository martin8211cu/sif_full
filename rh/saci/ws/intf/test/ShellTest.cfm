<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ShellService.cfc Test</title>
</head>

<body>

<cfparam name="cmd"  default="c:/cygwin/bin/ls.exe -l -a * mk">

<form method="get">
cmd:<input type="text" name="cmd" size="100"  value="<cfoutput># HTMLEditFormat( cmd )#</cfoutput>" />
</form>

<cfset comp = CreateObject("component", "saci.ws.intf.ShellService")>


<cfset comp.shellExecute(cmd,'test','test')>
#comp.debug()#

</cfoutput>
</body>
</html>
