<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/results.cfm 3     10/08/02 11:19a Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>soEditor Lite 2.5 :: Posted Results</title>
  <cfif isDefined("form.stylesheet")>
    <cfoutput><link href="#form.stylesheet#" rel="stylesheet" type="text/css"></cfoutput>
  </cfif>
  <style type="text/css">
    A:hover {
    	color: #8484BD;
    	text-decoration: none;
    } 
    #content {
    	padding: 30px;
    	margin-top: 10px;
    	margin-bottom: 10px;
    	margin-left: 10%;
    	margin-right: 10%;
    	background-color: #FFFFFF;
    	border: 1px solid #000;
    	width: 100%;
    }
  </style>
</head>

<body background="images/back.gif" link="#31316B" vlink="#31316B" alink="#8484BD">

<div id="content">

<a href="index.cfm"><img src="images/logo.soeditor.lite.25.gif" alt="soEditor Lite 2.5" width="300" height="70" border="0"></a>

<h3 style="font-family: Arial, Helvetica, sans-serif; font-weight: normal; font-style: italic; color: #9C0000;">Posted Results:</h3>

<cfoutput>
<table width="100%" border="0" cellspacing="2" cellpadding="5" style="border: 1px solid ##CCCCCC;">
<!--- Example one --->
<cfif isDefined("form.content")>
  <tr>
    <td style="border: 1px solid ##CCCCCC;">#form.content#&nbsp;</td>
  </tr>
</cfif>
<!--- Example two --->
<cfif isDefined("form.name")>
  <tr>
    <td width="10%" align="right" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid ##CCCCCC;">Name:</td>
    <td width="90%" style="font-family: Verdana, Geneva, Arial, Helvetica, sans-serif; font-size: 12px;border: 1px solid ##CCCCCC;"><strong>#form.name#</strong>&nbsp;</td>
  </tr>
</cfif>
<cfif isDefined("form.details")>
  <tr valign="top">
    <td width="10%" align="right" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid ##CCCCCC;">Details:</td>
    <td width="90%" style="border: 1px solid ##CCCCCC;">#form.details#&nbsp;</td>
  </tr>
</cfif>
<!--- Example three --->
<cfif isDefined("form.title")>
  <tr style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;">
    <td width="10%" align="right" style="border: 1px solid ##CCCCCC;">Title:</td>
    <td width="90%" class="title" style="border: 1px solid ##CCCCCC;">#form.title#&nbsp;</td>
  </tr>
</cfif>
<cfif isDefined("form.leadin")>
  <tr valign="top">
    <td width="10%" align="right" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid ##CCCCCC;">Leadin:</td>
    <td width="90%" class="leadin" style="border: 1px solid ##CCCCCC;">#form.leadin#&nbsp;</td>
  </tr>
</cfif>
<cfif isDefined("form.body")>
  <tr valign="top">
    <td width="10%" align="right" style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; border: 1px solid ##CCCCCC;">Body:</td>
    <td width="90%" style="border: 1px solid ##CCCCCC;">#form.body#&nbsp;</td>
  </tr>
</cfif>
</table>
</cfoutput>

<!--- Example four --->
<cfif isDefined("form.html")>
  <cffile action="WRITE" file="#ExpandPath(".")#\html\example.page.html" output="#form.html#" addnewline="No">
  <iframe src="html/example.page.html" width="100%" height="250"></iframe>
</cfif>

<p style="font-family: Arial, Helvetica, sans-serif; font-size: 12px;"><a href="javascript:history.back();">&lt; back to example</a></p>

<br>

<p align="center" style="font-family: Arial, Helvetica, sans-serif; font-size:10px;">
<img src="images/logo.so.jpg" width="28" height="33"><br>
Copyright &copy; 2002 <a href="http://www.siteobjects.com" target="_blank">SiteObjects</a>, Inc.
</p>
    
</div>

</body>
</html>
