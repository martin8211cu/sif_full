
  <cffunction name="mod_ds">
    <cfargument name="currentds" required="yes">
    <cfargument name="username" required="yes">
    <cfargument name="database" required="yes">
    <cflock name="serviceFactory" type="exclusive" timeout="10">
      <cfscript>
    factory = CreateObject("java", "coldfusion.server.ServiceFactory");
    ds_service = factory.datasourceservice;
    dsources = ds_service.datasources;
  </cfscript>
      <cfscript>
	myds = dsources[arguments.currentds];
	maxPooled = 10;
	if (url.type is 'sybase') {
		// convertir a sybase
		maxPooled = 1000;
		myds.driver = 'Sybase';
		myds.url = 'jdbc:macromedia:sybase://#url.host#:#url.port#;DatabaseName=#arguments.database#;SelectMethod=direct;sendStringParametersAsUnicode=false;MaxPooledStatements=#maxPooled#';
		myds.urlmap.CONNECTIONPROPS.DATABASE = arguments.database;
		myds.urlmap.CONNECTIONPROPS.SELECTMETHOD = 'direct';
		myds.urlmap.SID = "";
		myds.urlmap.VENDOR = 'sybase';
	} else if (url.type is 'oracle') {
		// convertir a oracle
		maxPooled = 300;
		myds.driver = 'Oracle';
		myds.url = 'jdbc:macromedia:oracle://#url.host#:#url.port#;SID=#url.sid#;sendStringParametersAsUnicode=false;MaxPooledStatements=#maxPooled#';
		myds.urlmap.CONNECTIONPROPS.SID = url.sid;
		myds.urlmap.SID = url.sid;
		myds.urlmap.VENDOR = 'oracle';
	} else if (url.type is 'sqlserver') {
		// convertir a mssqlserver
		maxPooled = 1000;
		myds.driver = 'MSSQLSERVER';
		myds.url = 'jdbc:macromedia:sqlserver://#url.host#:#url.port#;databaseName=#arguments.database#;SelectMethod=direct;sendStringParametersAsUnicode=false;MaxPooledStatements=#maxPooled#';
		myds.urlmap.CF_POOLED = 'true';
		myds.urlmap.CONNECTIONPROPS.DATABASE = arguments.database;
		myds.urlmap.CONNECTIONPROPS.SELECTMETHOD = 'direct';
		myds.urlmap.SID = "";
		myds.urlmap.VENDOR = 'sqlserver';
	}
	myds.password = ds_service.encryptPassword(url.password);
	myds.username = arguments.username;
	myds.urlmap.CONNECTIONPROPS.HOST = url.host;
	myds.urlmap.CONNECTIONPROPS.PORT = url.port;
	myds.urlmap.CONNECTIONPROPS.MAXPOOLEDSTATEMENTS = maxPooled;
	myds.urlmap.MaxPooledStatements = maxPooled;
	myds.urlmap._port = url.port;
	myds.urlmap.database = arguments.database;
	myds.urlmap.host = url.host;
	myds.urlmap.port = url.port;
	myds.interval = 1 *60;
	myds.timeout  = 1 *60;
	//dsdef = DataSourceFactory.getInstance().getDataSourceDef(arguments.currentds);
	//dsdef.setMap(myds);
</cfscript>
    </cflock>
  </cffunction>
  modificando...
  <cfloop list="#url.ds#" index="theds">
    <cfoutput>#theds#</cfoutput> ...
    <cfset mod_ds(theds, url['user_' & theds], url['db_' & theds])>
	ok;
  </cfloop><hr>
  <cfscript>
	ds_service.store();
	ds_service.restart();
</cfscript>
  <cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" refresh="yes"></cfinvoke>
