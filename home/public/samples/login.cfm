<cfdump var="#session#"/>
<cfset authurl = application.google.generateAuthUrl(application.callback, session.urltoken)>

<h1>Login Required</h1>

<p>
  In order to use this app, you must login with your Google account. Click to login below.
</p>

<cfoutput>
	<p>
	<a href="#authurl#">LOGIN!</a>
	</p>
</cfoutput>