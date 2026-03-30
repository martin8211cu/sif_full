 
<cfset me = application.google.getProfile(session.token.access_token)>
 
<h1>Home</h1>

<cfdump var="#me#" label="me">


<cfoutput>#googleData#</cfoutput>