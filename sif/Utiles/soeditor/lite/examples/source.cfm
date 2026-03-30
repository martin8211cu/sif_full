<!--- Copyright (c) 2002 SiteObjects, Inc. --->

<!---

  SourceSafe: $Header: /SiteObjects/Products/soEditor/lite/examples/source.cfm 2     10/08/02 11:19a Don $
  Date Created: 9/10/2002
  Author: Don Bellamy
  Project: soEditor 2.5
  Description: Examples

--->

<cfparam name="URL.template" type="string" default="">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>soEditor Lite 2.5 :: Source</title>
</head>

<body>

<cfif fileExists(expandPath(url.template))>

<cffile action="Read" file="#expandPath(url.template)#" variable="source">
<cfoutput>#htmlCodeFormat(source)#</cfoutput>

<cfelse>

  File does not exist.

</cfif>

</body>
</html>
