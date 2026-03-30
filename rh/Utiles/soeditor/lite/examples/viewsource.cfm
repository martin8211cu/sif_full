<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/viewsource.cfm 3     10/08/02 11:19a Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<cfparam name="URL.template" type="string" default="example.one.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>soEditor Lite 2.5 :: View Source</title>
  <link href="styles/styles.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="content">

<a href="index.cfm"><img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0"></a>

<h3>View Source</h3>

<cfoutput>
<p><strong><em>Source code of #url.template#</em></strong></p>
<iframe src="source.cfm?template=#url.template#" width="100%" height="300"></iframe>
</cfoutput>

<br>

<cfoutput>
<p><a href="#url.template#">&lt; back to #url.template#</a></p>
</cfoutput>

<br>

<p align="center" style="font-size:smaller;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com" target="_blank">SiteObjects</a>, Inc.
</p>
    
</div>

<br>

</body>
</html>