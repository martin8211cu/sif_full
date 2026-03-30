<cfcomponent
    displayname="Application"
    output="true"
    hint="Handle the application.">


    <!--- Set up the application. --->
    <cfset THIS.Name = "AppCFC" />
    <cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 0, 1, 0 ) />
    <cfset THIS.SessionManagement = true />
    <cfset THIS.SetClientCookies = true />

	<cffunction
        name="OnRequestStart">
		<cfif !StructKeyExists(session,"ListaCarrito")>
        	<cfset session.ListaCarrito = ArrayNew(1)/>
		</cfif>
    </cffunction>



</cfcomponent>
