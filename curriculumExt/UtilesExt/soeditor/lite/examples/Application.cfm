<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/Application.cfm 3     1/06/03 5:12p Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<!--- Documentation variables --->
<cfscript>
  // Path to the soeditor_lite.cfm template, can be a relative path
  Variables.TemplatePath = "/UtilesExt/soeditor/lite/";
  // Make sure this is an absolute path (enclosed in slashes "/")
  Variables.ScriptPath = "/UtilesExt/soeditor/lite/";
</cfscript>

<!--- Lock down to IE users only --->
<cfif NOT REFindNoCase("MSIE [5|6].*win",CGI.HTTP_USER_AGENT)>
IE 5+ is required to view these example applications.
<cfabort>
</cfif>
