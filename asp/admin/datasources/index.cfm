<cfapplication name="SIF_ASP">


<cfif IsDefined('url.connect')>
	<cflocation url="/cfmx">
</cfif>

<cfinclude template="dbms_defaults.cfm">

<cfscript>
    factory = CreateObject("java", "coldfusion.server.ServiceFactory");
    ds_service = factory.datasourceservice;
    dsources = ds_service.datasources;
	
	DataSourceFactory = CreateObject("java","coldfusion.sql.DataSourceFactory");
	 //DataSourceFactory.getInstance().getDataSourceDef(dsn);
</cfscript>

<cfif len(url.ok)>
	<cfinclude template="modify.cfm">
</cfif>

<cfinclude template="ui.cfm">


<cfif Len(url.verify)>
	<cfinclude template="verify.cfm">
</cfif>
