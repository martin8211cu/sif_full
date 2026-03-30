<cfinclude template="env.cfm">

<cfparam name="url.Diagram"  default="">
<cfparam name="url.code"  default="">

<cfparam name="url.pdm"  default="">
<cfparam name="url.path" default="">
<cfparam name="url.pack" default="">
<cfparam name="url.app"  default="">

<cfif Len(url.pdm )><cfset session.pdm.file = url.pdm ></cfif>
<cfif Len(url.path)><cfset session.pdm.path = url.path></cfif>
<cfif Len(url.app )><cfset session.pdm.app  = url.app ></cfif>

<cflocation url="index.cfm?Diagram=#URLEncodedFormat(url.Diagram)#&code=#URLEncodedFormat(url.code)#">
