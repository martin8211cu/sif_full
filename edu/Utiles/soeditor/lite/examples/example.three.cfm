<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/example.three.cfm 4     1/06/03 5:07p Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<cfparam name="form.title" default="">
<cfparam name="form.leadin" default="">
<cfparam name="form.body" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
  <title>soEditor Lite 2.5 :: Example Three</title>
  <link href="styles/styles.css" rel="stylesheet" type="text/css">
</head>

<body>

<div id="content">

<a href="index.cfm"><img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0"></a>

<h3>Example Three</h3>

<p class="subtitle">Multiple editors</p>

<p>
This example demonstrates how to use more than one instance of soEditor within a form.
The <span class="code">basefont</span> attribute is set to Arial and the <span class="code">basefontsize</span> attribute is set to 2.
The <span class="code">font</span> and <span class="code">htmledit</span> attributes are set to false in order to control all formatting with the base font and size.
Focus is set to the title field in the <span class="code">initialfocus</span> attribute.
</p>

<p>Submit the form below to post content.</p>

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.three.cfm">view source</a></p>

<cfoutput>
<fieldset>
<legend>News Article</legend>
<form action="results.cfm" method="post" name="exampleForm" id="exampleForm">
<table width="100%" cellspacing="2" cellpadding="3">
  <tr>
    <td width="10%" align="right">Title:</td>
    <td width="90%">
    <input type="text" name="title" value="#form.title#" size="50" maxlength="50">
    </td>
  </tr>
  <tr valign="top">
    <td align="right">Lead in:</td>
    <td>
    <cfmodule 
      template="#Variables.TemplatePath#soeditor_lite.cfm" 
      form="exampleForm" 
      field="leadin" 
      scriptpath="#Variables.ScriptPath#"
      height="100px"
      baseurl="http://#cgi.server_name#:#cgi.server_port##variables.scriptpath#examples/"
      html="#form.leadin#" 
      initialfocus="false"
      format="false"
      basefont="Arial,Helvetica"
      basefontsize="2"
      save="false"
      image="false"
      fontdialog="false"
      font="false"
      fgcolor="false"
      bgcolor="false"
      htmledit="false">
    </td>
  </tr>
  <tr valign="top">
    <td align="right">Body:</td>
    <td>
    <cfmodule 
      template="#Variables.TemplatePath#soeditor_lite.cfm" 
      form="exampleForm" 
      field="body" 
      scriptpath="#Variables.ScriptPath#"
      baseurl="http://#cgi.server_name#:#cgi.server_port##variables.scriptpath#examples/"
      html="#form.body#" 
      initialfocus="title"
      format="false"
      basefont="Arial,Helvetica"
      basefontsize="2"
      save="false"
      fontdialog="false"
      font="false"
      fgcolor="false"
      bgcolor="false"
      htmledit="false">
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

<p><a href="index.cfm">&lt; back to examples</a> &nbsp; || &nbsp; <a href="viewsource.cfm?template=example.three.cfm">view source</a></p>

<br>

<p align="center" style="font-size:smaller;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com/" target="_blank">SiteObjects</a>, Inc.
</p>
    
</div>

<br>

</body>
</html>