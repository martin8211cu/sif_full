<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/example.two.cfm 4     1/06/03 5:07p Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<cfparam name="form.name" default="">
<cfparam name="form.details" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <title>soEditor Lite 2.5 :: Example Two</title>
  <link href="styles/styles.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="content">

<a href="index.cfm"><img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0"></a>

<h3>Example Two</h3>

<p class="subtitle">Using in a form</p>

<p>
This example demonstrates how soEditor can be used within a regular form.
Focus is set to the name field in the <span class="code">initialfocus</span> attribute. 
Field validation is also enabled by setting the <span class="code">validateonsave</span> attribute to true and by using the <span class="code">validationmessage</span> attribute.
<p>

<p>Submit the form below to post content.</p>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.two.cfm">view source</a></p>

<cfoutput>
<fieldset>
<legend>Product Information</legend>
<form action="results.cfm" method="post" name="exampleForm" id="exampleForm">
<table width="100%" cellspacing="2" cellpadding="3">
  <tr>
    <td width="10%" align="right">Name:</td>
    <td width="90%">
    <input type="text" name="name" value="#form.name#" size="40">
    </td>
  </tr>
  <tr valign="top">
    <td align="right">Details:</td>
    <td>
    <cfmodule 
      template="#Variables.TemplatePath#soeditor_lite.cfm" 
      form="exampleForm" 
      field="details" 
      scriptpath="#Variables.ScriptPath#"
      baseurl="http://#cgi.server_name#:#cgi.server_port##variables.scriptpath#examples/"
      validateonsave="true"
      validationmessage="Product details are required."
      html="#form.details#" 
      initialfocus="name"
      save="false">
    </td>
  </tr>
  <tr>
    <td></td>
    <td>
    <input type="submit" value="OK" class="button">
    <input type="button" value="Cancel" class="button" onClick="window.location='index.cfm';">
    </td>
  </tr>
</table>
</form>
</fieldset>
</cfoutput>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.two.cfm">view source</a></p>

<br>

<p align="center" style="font-size:smaller;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com/" target="_blank">SiteObjects</a>, Inc.
</p>
    
</div>

<br>

</body>
</html>