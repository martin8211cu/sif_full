<cfparam name="session.RHRid" type="numeric" default="0">
<cfif session.RHRid is 0><cflocation url="index.cfm" addtoken="no"></cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>RelojMarcador</title>
</head>
<body bgcolor="#ffffff">

<!--url's used in the movie-->
<!--text used in the movie-->
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
  codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="950" height="550" id="RelojMarcador" align="middle">
<param name="allowScriptAccess" value="sameDomain" />
<cfoutput>
<param name="movie" value="RelojMarcador.swf" />
</cfoutput>
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" />
<embed src="RelojMarcador.swf" quality="high" bgcolor="#ffffff"
   width="950" height="550" name="RelojMarcador" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />

&nbsp;
</object>
</body>
</html>