<!--- see comments below for explanation of this template--->

<CFIF LISTFIRST(SERVER.COLDFUSION.PRODUCTVERSION) LT 6>
	<cf_errorCode	code = "50667" msg = "<H3>CF_FORWARD works only in CFMX and above.</H3>">
	<CFABORT>
</CFIF>

<CFTRY>
	<CFIF NOT ISDEFINED("attributes.URL")>
		<cf_errorCode	code = "50668" msg = "You must provide a URL">
	</CFIF>
	
	<CFIF ISDEFINED("attributes.localvarscopied")>
		<CFSWITCH EXPRESSION="#attributes.localvarscopied#">
			<CFCASE VALUE="yes,y">
				<CFSET RC = STRUCTAPPEND(CALLER.REQUEST,CALLER.VARIABLES)>
			</CFCASE>
			<CFCASE VALUE="no,n">
				<!--- do nothing --->
			</CFCASE>
			<CFDEFAULTCASE>
				<cf_errorCode	code = "50669"
								msg  = "The value of the attribute LocalVarsCopied, which is currently '@errorDat_1@', is invalid."
								errorDat_1="#attributes.localvarscopied#"
				>
			</CFDEFAULTCASE>
		</CFSWITCH>
	</CFIF>

	<CFIF ISDEFINED("attributes.FORMURLvarscopied")>
		<CFSWITCH EXPRESSION="#attributes.FORMURLvarscopied#">
			<CFCASE VALUE="yes,y">
				<CFSET RC = STRUCTAPPEND(CALLER.REQUEST,CALLER.FORM)>
				<CFSET RC = STRUCTAPPEND(CALLER.REQUEST,CALLER.URL)>
			</CFCASE>
			<CFCASE VALUE="no,n">
				<!--- do nothing --->
			</CFCASE>
			<CFDEFAULTCASE>
				<cf_errorCode	code = "50670"
								msg  = "The value of the attribute formurlvarscopied, which is currently '@errorDat_1@', is invalid."
								errorDat_1="#attributes.formurlvarscopied#"
				>
			</CFDEFAULTCASE>
		</CFSWITCH>
	</CFIF>

	<CFCATCH>
		<H3>Attribute validation error for tag CF_FORWARD.</H3>
		<CFOUTPUT>
		#cfcatch.message#<BR>
		#cfcatch.detail#
		</CFOUTPUT>
		<CFABORT>
	</CFCATCH>
</CFTRY>

<CFTRY>
	<!--- because of a bug in the forward method (in Beta 3 at least), if any FORM variables were passed to the caller, the forward will fail with an err.io.short_read error. So I have to check for that and stop you from seeing that error. --->
	<CFIF CGI.REQUEST_METHOD IS "post">
		<cf_errorCode	code = "50671" msg = "Error processing CF_FORWARD.">
	</CFIF>
	<CFCATCH>
		<CFOUTPUT>
		<H3>#cfcatch.message#</H3>
		#cfcatch.detail#<BR>
		</CFOUTPUT>
		<CFABORT>
	</CFCATCH>
</CFTRY>


<CFSCRIPT>
	getPageContext().forward("#attributes.URL#");
</CFSCRIPT>

<!---
Custom Tag: FORWARD (CF_FORWARD) for CFMX and above Only
Created by: 	Charlie Arehart, carehart@systemanage.com
Created: 05/05/2002
Last Updated:	05/10/2002

Purpose:		Provides true server-side redirection from one CF page to another page on the server. The benefit of server-side redirect over CFLOCATION is that:
a) as opposed to CFLOCATION, this tag does NOT do a client-side redirection . The transfer of control is all done on the server. It leverages the CFMX capability to call the PageContext.forward() method available in the servlets API.
b) any CF variables created on the starting page can be made available on the page to which control is forwarded. The only requirement is that only variables in the REQUEST scope are shared this way.

To help make it easier to pass all vars from the calling page to the forwarded page, an available attribute (LOCALVARSCOPIED) can be set to "y" or "yes" to automatically copy all local variables (variables in the "variables" scope, such as locally defined queries) into the request scope to make them available in the forwarded page (again, available via the REQUEST scope there).

One other very interesting thing to note: if a cookie is set on the page doing the forward, even though it is a server-side redirect, it DOES set the cookie. This is in stark contrast to CFLOCATION which did NOT send to the browser any cookies set before it was called. This behavior is consistent with the JSP:forward tag.

--------------------------------------------------------------
Attributes:
REQUIRED attributes:
------------------------
URL - the page to which you want to pass control. Does NOT need to be another CF page. Can be a JSP, HTM or other page.

OPTIONAL attributes:
------------------------
LOCALVARSCOPIED (y/yes/n/no)- automatically copies all variables in the local ("VARIABLES") scope, including CFQUERY results, etc. to the REQUEST scope so that they're available in the forwarded page (in the REQUEST scope there).

FORMURLVARSCOPIED (y/yes/n/no)- automatically copies all FORM and URL variables passed to the caller into the REQUEST scope so that they're available in the forwarded page (in the REQUEST scope there).

POSSIBLE IMPROVEMENTS:
-------------------------------

With the two optional "copied" attributes above, I simply place the vars (either the variables and/or form/url scopes) into the request scope. I don't create any special structure to hold them. I just put them into the request scope, just like JSPs and servlets find their equivalent passed in form and URL variables available there. 

In that some might not like the possible name collisions that could occur if these copies might overwrite existing request scope vars of the same name, perhaps an improvement would be to allow for an attribute that defines an optional structure into which each copy should be made, respectively. And if none is provided, proceed with the copy as I do it now.

--->



