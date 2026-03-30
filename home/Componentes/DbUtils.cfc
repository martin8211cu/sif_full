<cfcomponent>
	<cffunction name="get_dbtype" output="false" returntype="string">
		<cfargument name="DriverClass" type="string">
		<cfargument name="DriverType"  type="string">
		<cfargument name="url"         type="string">
		
		<cfif DriverClass is 'macromedia.jdbc.MacromediaDriver'>
			<cfreturn LCase(ListGetAt(url,3,':'))>
		<cfelseif DriverClass is 'com.soin.multidriver.MultiDriver'>
			<cfreturn 'multiple'>
		<cfelseif FindNoCase('sybase', DriverClass)>
			<cfreturn 'sybase'>
		<cfelseif FindNoCase('sqlserver', DriverClass)>
			<cfreturn 'sqlserver'>
		<cfelseif FindNoCase('oracle', DriverClass)>
			<cfreturn 'oracle'>
		<cfelseif FindNoCase('db2', DriverClass)>
			<cfreturn 'db2'>
		<cfelseif FindNoCase('jtds', DriverClass)>
			<cfreturn LCase(ListGetAt(Arguments.url,3,':'))>
		<!--- 
			El jdbc:db2:  com.ibm.db2.jcc.DB2Driver
				da error en las instruccion diferentes a SELECT:
				CREATE, ALTER, UPDATE, DELETE
				java.lang.NullPointerException at coldfusion.sql.CFNoResultSetTable.
				
		--->	
		<cfelse>
			<cfreturn 'none'>
		</cfif>
	</cffunction>

	<cffunction name="generate_dsinfo" output="false">
		<cfargument name="refresh" type="boolean" default="no">
		<cfargument name="datasource" type="string" default="">

		<!---------------------------------------------------------->
		<cfif 	Arguments.refresh Or 
				Not IsDefined('Application.dsinfo') Or 
				(Len(Arguments.datasource) And Not StructKeyExists(Application.dsinfo, Arguments.datasource)) OR
				Not IsDefined('Application.dsinfo.asp.charType')
		>
			<cfset restart = false>
			<cfset dsinfo = StructNew()>
			<cfset factory = CreateObject("java", "coldfusion.server.ServiceFactory")>
			<cfset ds_service = factory.datasourceservice>

			<cfset datasources = this.getColdfusionDatasources(ds_service)>
			<cfloop collection="#datasources#" item="i">
				<cftry>
					<cfset thisdatasource = datasources[i]>
					
					<cfif IsDefined('thisdatasource.class')>
						<!--- este try+if va porque el DefaultDataSource de jrun4 da problemas en desarrollo --->
						<cfset dsinfoitem = StructNew()>
						<cfset dsinfoitem.name        = thisdatasource.name>
						<cfset dsinfoitem.driverClass = thisdatasource.class>
						<cfset dsinfoitem.driverName  = thisdatasource.driver>
						<cfset dsinfoitem.url         = thisdatasource.url>
						<cfset dsinfoitem.type        = This.get_dbtype(dsinfoitem.driverClass, dsinfoitem.driverName, dsinfoitem.url)>
						<!--- OBTIENE SCHEMA --->
						<cftry>
							<cfset dsinfoitem.schema      = "">
							<cfset dsinfoitem.schemaError = "">
							<cfif ListFind('sybase,sqlserver', dsinfoitem.type)>
								<cfquery name="rsSCHEMA" datasource="#dsinfoitem.name#">
									select db_name() as schema_nombre
								</cfquery>
								<cfset dsinfoitem.schema    = rsSCHEMA.schema_nombre>
							<cfelseif dsinfoitem.type EQ 'oracle'>
								<cfquery name="rsSCHEMA" datasource="#dsinfoitem.name#">
									SELECT SYS_CONTEXT('USERENV','CURRENT_SCHEMA') as schema_nombre FROM DUAL
								</cfquery>
								<cfset dsinfoitem.schema    = rsSCHEMA.schema_nombre>
							<cfelseif dsinfoitem.type EQ 'db2'>
								<cfquery name="rsSCHEMA" datasource="#dsinfoitem.name#">
									SELECT CURRENT SCHEMA AS schema_nombre FROM SYSIBM.SYSDUMMY1
								</cfquery>
								<cfset dsinfoitem.schema    = trim(rsSCHEMA.schema_nombre)>
							<cfelse>
								<cfset dsinfoitem.schemaError = "Schema no se ha implementado en base de datos '#dsinfoitem.type#'">
							</cfif>
						<cfcatch type="any">
							<cfset dsinfoitem.schemaError = "Error de Conexión: #cfcatch.Detail#">
						</cfcatch>
						</cftry>

						<!--- OBTIENE EL TIPO DE DATO PARA CHAR --->
						<cfif dsinfoitem.schemaError EQ "">
							<cftry>
								<cfset CHARTYPE_TABLE = "DSN__CharType">
								<cfset CHARTYPE_TS = getTickCount()>
								<cfif ListFind('sybase,sqlserver', dsinfoitem.type)>
									<cfquery name="rsGetCharType" datasource="#dsinfoitem.name#">
										select object_id('#CHARTYPE_TABLE#') as id
									</cfquery>
									<cfif rsGetCharType.id NEQ "">
										<cfquery datasource="#dsinfoitem.name#">
											DELETE FROM #CHARTYPE_TABLE#
										</cfquery>
									<cfelse>
										<cfquery datasource="#dsinfoitem.name#">
											create table #CHARTYPE_TABLE# (XX char(10), YY numeric(18))
										</cfquery>
									</cfif>
									<cfset dsinfoitem.charTypeDBM = fnGetCharTypeDBM()>
									<cfif dsinfoitem.charTypeDBM EQ "C">
										<cfset dsinfoitem.charType = "char">
									<cfelse>
										<cfset dsinfoitem.charType = "varchar">
									</cfif>
								<cfelseif dsinfoitem.type EQ 'oracle'>
									<cfset CHARTYPE_TABLE = ucase(CHARTYPE_TABLE) & "_V1">
									<cfquery name="rsGetCharType" datasource="#dsinfoitem.name#">
										select count(1) as cantidad
										  from	ALL_TABLES
										 where	OWNER		= '#dsinfoitem.schema#'
										   AND 	TABLE_NAME	= '#CHARTYPE_TABLE#'
									</cfquery>
									<cfif rsGetCharType.cantidad GT 0>
										<cfquery datasource="#dsinfoitem.name#">
											DELETE FROM #CHARTYPE_TABLE#
										</cfquery>
									<cfelse>
										<cfquery datasource="#dsinfoitem.name#">
											CREATE TABLE #CHARTYPE_TABLE# (XX CHAR(10), YY NUMBER(18))
										</cfquery>
									</cfif>
									<cfset dsinfoitem.charTypeDBM = fnGetCharTypeDBM()>
									<cfif dsinfoitem.charTypeDBM EQ "C">
										<cfset dsinfoitem.charType = "CHAR">
									<cfelse>
										<cfset dsinfoitem.charType = "VARCHAR2">
									</cfif>
								<cfelseif dsinfoitem.type EQ 'db2'>
									<cfset CHARTYPE_TABLE = ucase(CHARTYPE_TABLE)>
									<cfquery name="rsGetCharType" datasource="#dsinfoitem.name#">
										SELECT count(1) as cantidad
										  FROM	SYSCAT.TABLES
										 WHERE	TABSCHEMA	= '#dsinfoitem.schema#'
										   AND 	TABNAME		= '#CHARTYPE_TABLE#'
									</cfquery>
									<cfif rsGetCharType.cantidad GT 0>
										<cfquery datasource="#dsinfoitem.name#">
											DELETE FROM #CHARTYPE_TABLE#
										</cfquery>
									<cfelse>
										<cfquery datasource="#dsinfoitem.name#">
											CREATE TABLE  #CHARTYPE_TABLE# (XX CHAR(10),YY DECIMAL(18))
										</cfquery>
									</cfif>
									<cfset dsinfoitem.charTypeDBM = fnGetCharTypeDBM()>
									<cfif dsinfoitem.charTypeDBM EQ "C">
										<cfset dsinfoitem.charType = "CHAR">
									<cfelse>
										<cfset dsinfoitem.charType = "VARCHAR">
									</cfif>
								</cfif>
							<cfcatch type="any">
								<cfset dsinfoitem.schemaError = "Error obteniendo charType: #cfcatch.Message# #cfcatch.Detail#">
							</cfcatch>
							</cftry>
						</cfif>
						<!--- AJUSTA PARAMETROS PARA MANEJO DE BLOBs --->
						<cftry>
							<cfif thisdatasource.disable_blob or thisdatasource.disable_clob>
								<cfset restart = true>
								<cfset thisdatasource.disable_blob 	= false>
								<cfset thisdatasource.disable_clob 	= false>
								<cfset thisdatasource.blob_buffer 	= 64000>
								<cfset thisdatasource.buffer 		= 64000>
							</cfif>
						<cfcatch type="any">
							<cfset dsinfoitem.schemaError = cfcatch.Message>
						</cfcatch>
						</cftry>
						<cfset dsinfo[datasources[i].name] = dsinfoitem>
					</cfif>
					<cfcatch type="any">
						<cfdump var="#cfcatch.Message#">
					</cfcatch>
				</cftry>
			</cfloop>
			
			<cftry>
				<cfif restart>
					<cfscript>
						ds_service.store();
						ds_service.restart();
					</cfscript>
				</cfif>
				<cfcatch type="any"></cfcatch>
			</cftry>
			<cfset Application.dsinfo = dsinfo>
		</cfif>
	</cffunction>

	<cffunction name="fnGetCharTypeDBM" returntype="string" output="no" access="private">
		<cfif ListFind('sybase,sqlserver,oracle', dsinfoitem.type)>
			<cfquery datasource="#dsinfoitem.name#">
				GRANT SELECT ON #CHARTYPE_TABLE# TO PUBLIC
			</cfquery>
		<cfelseif dsinfoitem.type EQ 'db2'>
			<cfquery datasource="#dsinfoitem.name#">
				GRANT SELECT ON TABLE #CHARTYPE_TABLE# TO PUBLIC
			</cfquery>
		</cfif>

		<cfquery datasource="#dsinfoitem.name#">
			insert into #CHARTYPE_TABLE# (XX,YY) values('1',#CHARTYPE_TS#)
		</cfquery>
		<cfquery name="rsGetCharType" datasource="#dsinfoitem.name#">
			select XX
			  from #CHARTYPE_TABLE#
			 where XX = <cfqueryparam cfsqltype="cf_sql_varchar" value="1">
		</cfquery>
		<cftry>
			<cfquery name="rsGetServer" datasource="asp">
				select YY
				<cfif ListFind('sybase,sqlserver', dsinfoitem.type)>
				  from #dsinfoitem.schema#..#CHARTYPE_TABLE#
				<cfelse>
				  from #dsinfoitem.schema#.#CHARTYPE_TABLE#
				</cfif>
			</cfquery>
			<cfset dsinfoitem.aspServer = (rsGetServer.YY EQ CHARTYPE_TS)>
		<cfcatch type="database">
			<cfset dsinfoitem.aspServer = false>
		</cfcatch>
		</cftry>
		<cfif rsGetCharType.XX EQ "1">
			<cfreturn "C">
		<cfelse>
			<CFreturn "V">
		</cfif>
	</cffunction>

  	<!---►►Funcion para el manejo de concurrencia◄◄--->  
  	<cffunction name="toTimeStamp" output="false" access="public" returntype="string">
		<cfargument name="arTimeStamp" type="any" required="true">
		<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
		
		<cfif lcase(arTimeStamp.getClass().getName()) EQ "oracle.sql.timestamp">
			<cfset arTimeStamp = arTimeStamp.timestampValue()>
		</cfif>
		
		<cfif IsDate(arTimeStamp)>
			<cfreturn DateFormat(arTimestamp, 'yyyymmdd') & TimeFormat(arTimestamp, 'hhmmssll')>
		</cfif>

		<cfif not isArray(arTimeStamp)>
			<cfset ts = "0x00">
			<cfreturn ts>
			<cfexit>
		</cfif>
		<cfset miarreglo=#ListtoArray(ArraytoList(#arguments.arTimeStamp#,","),",")#>
		<cfset miarreglo2=ArrayNew(1)>
		<cfset temp=ArraySet(miarreglo2,1,8,"")>

		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
		</cfloop>

		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 10>
				<cfset miarreglo2[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
			<cfelse>
				<cfset miarreglo2[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
			</cfif>
		</cfloop>
		<cfset temp = #ArrayPrepend(miarreglo2,"0x")#>
		<cfset ts = #ArraytoList(miarreglo2,"")#>
		<cfreturn #ts#>
	</cffunction>

	<!---►►Toma un objeto file (en este caso una imagen) y la convierte a formato sybase◄◄--->
	<cffunction name="toBinaryFile" output="false" access="public" returntype="string">
		<cfargument name="arBinaryFile" type="any" required="true">
		
		<!--- Copia la imagen a un folder del servidor servidor --->
		<cffile action="Upload" fileField="arBinaryFile"  destination="#gettempdirectory()#" nameConflict="Overwrite" accept="image/*"> 
		
		<cfset tmp = "" >		<!--- contenido binario de la imagen --->
		
		<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
		<cffile action="readbinary" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" >
		
		<cffile action="delete" file="#gettempdirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" >
	 
		<!--- Formato para sybase --->
		<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
	
		<cfif not isArray(tmp)>
			<cfset ts = "">
		</cfif>
		<cfset miarreglo=#ListtoArray(ArraytoList(#tmp#,","),",")#>
		<cfset miarreglo2=ArrayNew(1)>
		<cfset temp=ArraySet(miarreglo2,1,8,"")>
	
		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 0>
				<cfset miarreglo[i]=miarreglo[i]+256>
			</cfif>
		</cfloop>
	
		<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
			<cfif miarreglo[i] LT 10>
				<cfset miarreglo2[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
			<cfelse>
				<cfset miarreglo2[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
			</cfif>
		</cfloop>
		<cfset temp = #ArrayPrepend(miarreglo2,"0x")#>
		<cfset ts = #ArraytoList(miarreglo2,"")#>
		<cfreturn #ts#>
	</cffunction>

	<cffunction name="getColdfusionDatasources" returntype="any" output="no" access="public">
		<cfargument name="DS_Service" type="any">
		<cfargument name="CFadmiPWD" type="string" default="">
		<!--- el getDatasources() da error de seguridad en Codlfusion 9.0.1 cuando Administrator tiene password --->
		<cfset versionCF = replace(SERVER.ColdFusion.ProductVersion,',','','all')*1>

		<cfif SERVER.ColdFusion.ProductName EQ "Railo">
			<cftry>
				<cfset LvarCFadmiPWD = "">
				<cfinclude template="DbUtils_cfadmin.cfm">
			<cfcatch type="any">
				<cfset LvarCFadmiPWD = fnCFadmiPWD(Arguments.CFadmiPWD)>
				<cfinclude template="DbUtils_cfadmin.cfm">
			</cfcatch>
			</cftry>
			<cfset datasources = structNew()>
			<cfloop query="rsDSN">
				<cfset  datasources[rsDSN.name] = structNew()>
				<cfset  datasources[rsDSN.name].name			= rsDSN.name>
				<cfset  datasources[rsDSN.name].class			= rsDSN.ClassName>
				<cfset  datasources[rsDSN.name].driver			= rsDSN.ClassName>
				<cfset  datasources[rsDSN.name].url				= rsDSN.DsnTranslated>
				<cfset  datasources[rsDSN.name].disable_clob	= rsDSN.clob>
				<cfset  datasources[rsDSN.name].disable_blob	= rsDSN.blob>
			</cfloop>
		<cfelseif versionCF LT 901274733>
			<cfset datasources = arguments.DS_Service.getDatasources()>
		<cfelse>
			<cftry>
				<cfset datasources = arguments.DS_Service.getDatasources()>
			<cfcatch type="any">
                <cftry>
                    <cfset LvarCFadmiPWD = fnCFadmiPWD(Arguments.CFadmiPWD)>
    
                    <cfset adminObj = createObject("component","CFIDE.adminapi.administrator")>
                    <cfset adminObj.login(LvarCFadmiPWD)>
                    <cfset dataSourceObb=createobject("component","CFIDE.adminapi.datasource").getDataSources()>
                    <cfset datasources = dataSourceObb>
                <cfcatch type="any">
					<cfset application.CFadmiPWD = "">
                    <cfset LvarCFadmiPWD = fnCFadmiPWD(Arguments.CFadmiPWD)>
    
                    <cfset adminObj = createObject("component","CFIDE.adminapi.administrator")>
                    <cfset adminObj.login(LvarCFadmiPWD)>
                    <cfset dataSourceObb=createobject("component","CFIDE.adminapi.datasource").getDataSources()>
                    <cfset datasources = dataSourceObb>
                </cfcatch>
                </cftry>
			</cfcatch>
			</cftry>
		</cfif>
		<cfreturn datasources>
	</cffunction>

	<cffunction name="fnCFadmiPWD" returntype="string" output="false">
		<cfargument name="CFadmiPWD">
		
		<cfset LvarFile = expandpath("/home/Componentes/CFIDE.cfg")>
		<cfif Arguments.CFadmiPWD NEQ "">
			<cfset LvarCFadmiPWD = Arguments.CFadmiPWD>
		<cfelseif fileexists(LvarFile)>
			<cfif isdefined("application.CFadmiPWD") and application.CFadmiPWD NEQ "">
				<cfset LvarCFadmiPWD = decrypt(application.CFadmiPWD,"asp128","CFMX_COMPAT","HEX")>
			<cfelse>
				<cffile action="read" file="#LvarFile#" variable="LvarFile">
				<cfloop file="#expandpath("/home/Componentes/CFIDE.cfg")#" index="LvarLinea">
					<cfif left(LvarLinea,4) EQ "PWD=">
						<cfset LvarLinea = mid(LvarLinea,5,len(LvarLinea))>
						<cfbreak>
					</cfif>
					<cfset LvarLinea = "">
				</cfloop>
				<cfset application.CFadmiPWD = LvarLinea>
				<cfset LvarCFadmiPWD = decrypt(application.CFadmiPWD,"asp128","CFMX_COMPAT","HEX")>
			</cfif>
		<cfelse>
			<cfif isdefined("application.CFadmiPWD")>
				<cfset application.CFadmiPWD = "">
			</cfif>
			<cfthrow message="Esta instalación de Coldfusion requiere que registre el password de Administrador para leer la información de los Datasources:<BR>/cfmx/home/public/CFIDE/password.cfm">
		</cfif>
		<cfreturn LvarCFadmiPWD>
	</cffunction>
</cfcomponent>
