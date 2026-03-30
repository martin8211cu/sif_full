<cfapplication name="BANCO" 
	sessionmanagement="Yes"
	clientmanagement="No"
	setclientcookies="Yes"
	sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="tramites_cr" />
<cfparam name="session.tramites" default="#StructNew()#">
<cfparam name="session.tramites.dsn" default="tramites_cr">
