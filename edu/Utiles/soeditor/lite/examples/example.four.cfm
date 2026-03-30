<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/example.four.cfm 5     1/06/03 5:07p Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<cffile action="READ" file="#ExpandPath(".")#\html\example.page.html" variable="variables.html">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <title>soEditor Lite 2.5 :: Example Four</title>
  <link href="styles/styles.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="content">

<a href="index.cfm"><img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0"></a>

<h3>Example Four</h3>

<p class="subtitle">Editing HTML files</p>

<p>
This example shows you how soEditor can be used to load, edit and save an entire html file.
The <span class="code">cffile</span> tag is used to read the file and by setting the <span class="code">pageedit</span> attribute to true we are able to preserve the html, head and body elements.
</p>

<p>Click the save icon to save this file.</p>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.four.cfm">view source</a></p>

<cfoutput>
<form action="results.cfm" method="post" name="exampleForm" id="exampleForm">
<cfmodule 
  template="#Variables.TemplatePath#soeditor_lite.cfm" 
  form="exampleForm" 
  field="html" 
  scriptpath="#Variables.ScriptPath#"
  pageedit="true" 
  html="#variables.html#">
</form>
</cfoutput>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.four.cfm">view source</a></p>

<br>

<p align="center" style="font-size:smaller;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com/" target="_blank">SiteObjects</a>, Inc.
</p>
    
</div>

<br>

</body>
</html>