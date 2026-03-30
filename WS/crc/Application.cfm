<cfapplication 
	name				= "SIF_ASP"
    sessionmanagement	= "yes"
    clientmanagement	= "no"
    applicationtimeout	= "#CreateTimeSpan( 0, 10, 0, 0 )#"
    setclientcookies	= "yes"
>
<cfsetting requesttimeout="3600" showdebugoutput="false" enablecfoutputonly="false"/>
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="minsif" />
<cfparam name="session.tramites" default="#StructNew()#">
<cfparam name="session.tramites.dsn" default="minsif">
