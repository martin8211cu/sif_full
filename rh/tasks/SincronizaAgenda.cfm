<cfif isdefined('url.Periodoinicio') and isdefined('url.Periodofin') >

<cfapplication name="SIF_ASP" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>

<cfinvoke component="commons.Componentes.Agenda" method="Sincronizo"  access="public" >
		<cfinvokeargument name="Periodoinicio" 	value="#URL.Periodoinicio#">
        <cfinvokeargument name="Periodofin" 	value="#URL.Periodofin#">
        <cfinvokeargument name="conexion" 		value="minisif">
        <cfinvokeargument name="CAAgrupado" 	value="Rvac">
</cfinvoke>
    Listo
<cfelse>
	ERROR NO SE ENVIO EL PERIODO
</cfif>