<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/example.one.cfm 3     1/06/03 5:07p Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<cfparam name="form.content" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <title>soEditor Lite 2.5 :: Example One</title>
  <link href="styles/styles.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="content">

<a href="index.cfm"><img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0"></a>

<h3>Example One</h3>

<p class="subtitle">Default configuration</p>

<p>
This example displays the default configuration of soEditor in a stand-alone form. 
</p>

<p>Click the save icon to post content.</p>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.one.cfm">view source</a></p>

<cfoutput>
<form action="results.cfm" method="post" name="exampleForm" id="exampleForm">
<cfmodule 
  template="#Variables.TemplatePath#soeditor_lite.cfm" 
  form="exampleForm" 
  field="content" 
  scriptpath="#Variables.ScriptPath#" 
  html="#form.content#">
</form>
</cfoutput>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.one.cfm">view source</a></p>

<br>

<p align="center" style="font-size:smaller;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com/" target="_blank">SiteObjects</a>, Inc.
</p>
    
</div>

<br>

</body>
</html>


