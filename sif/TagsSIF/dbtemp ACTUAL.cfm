<cfsilent>
<!--- 
	CREAR TABLAS TEMPORALES
	
	EJEMPLO 
	<cf_dbtemp name="TT_MAYORIZA" returnvariable="temp_table" datasource="#Attributes.datasource#">
		<cf_dbtempcol name="Ecodigo" type="numeric">
		<cf_dbtempcol name="Ecodigo" type="varchar(20)">
		<cf_dbtempcol name="Ecodigo" type="numeric">
		<cf_dbtempcol name="Ecodigo" type="numeric">
		
		<cf_dbtempkey cols="Ecodigo,Cuenta">
	</cf_dbtemp>

	Modificado por: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*
	* Pemite crear una tabla temporal por la conexión jdbc
	*
	* Utilización:
	*	<CF_dbTemp ... jdbc="no/yes">
	*
---->
<cfparam name="Attributes.name" 			type="string">
<cfparam name="Attributes.returnvariable" 	type="string" default="temp_table">
<cfparam name="ThisTag.Columns" 			default="#ArrayNew(1)#">
<cfparam name="ThisTag.Keys" 				default="#ArrayNew(1)#">
<cfparam name="ThisTag.Indexes" 			default="#ArrayNew(1)#">
<cfparam name="Attributes.datasource" 		default="">
<cfparam name="Attributes.temp" 			type="boolean" default="yes">
<cfparam name="Attributes.jdbc" 			type="boolean" default="no">

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif> 

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="no">
</cfinvoke>

<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
</cfif>


<cfif NOT ThisTag.HasEndTag>
	<cfthrow message="End tag requerido para cf_dbtemp">
</cfif>

<cfset Attributes.name = trim(Attributes.name)>
<cfif ThisTag.ExecutionMode is 'end'>
	<cfif ArrayLen(ThisTag.Columns) Is 0>
		<cfthrow message="Debe incluir columnas al cf_dbtemp.  Use al menos un cf_dbtempcol para definir las columnas de la tabla temporal.">
	</cfif>
	
	<cfset dbtype = Application.dsinfo[Attributes.datasource].type>
	<cfif ListFind('sybase,sqlserver', dbtype)>
		<cfif Attributes.temp>
			<cfset Attributes.name = "##" & Attributes.name>
		</cfif>
		<cfif Attributes.jdbc>
			<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
			<cfoutput>
				if object_id('<cfif dbtype is 'sqlserver'>tempdb..</cfif>#Attributes.name#') is not null
					drop table #Attributes.name#
			</cfoutput>
			</cf_jdbcquery_open>
		<cfelse>
			<cfquery datasource="#Attributes.datasource#">
				if object_id('<cfif dbtype is 'sqlserver' AND attributes.temp>tempdb..</cfif>#Attributes.name#') is not null
					drop table #Attributes.name#
			</cfquery>
		</cfif>		
		
		<cfset create_prolog = "create table">
		<cfset create_epilog = " ">
		<cfset create_condition = true>
	<cfelseif dbtype is 'oracle'>
		<cfif Attributes.temp>
			<cfset create_prolog = "create global temporary table">
			<cfset create_epilog = "on commit preserve rows">
		<cfelse>
			<cfset create_prolog = "create table">
			<cfset create_epilog = " ">
		</cfif>
		<cfquery datasource="#Attributes.datasource#" name="existe">
			select * from user_tables
			where table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Attributes.name)#">
		</cfquery>
		<cfset create_condition = existe.RecordCount is 0>
		<cfif NOT Attributes.temp AND NOT create_condition>
			<cfif Attributes.jdbc>
				<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
				<cfoutput>
					drop table #Attributes.name#
				</cfoutput>
				</cf_jdbcquery_open>
			<cfelse>
				<cfquery datasource="#Attributes.datasource#">
					drop table #Attributes.name#
				</cfquery>
			</cfif>		
			<cfset create_condition = true>
		</cfif>
	<cfelseif dbtype is 'db2'>
		<cfif Attributes.temp>
			<cfset #Attributes.name# = "SESSION.#Attributes.name#">
			<cfset create_prolog = "DECLARE GLOBAL TEMPORARY TABLE">
			<cfset create_epilog = "on commit preserve rows">
			<cfset TABSCHEMA	= "SESSION">
			<cfset TABNAME		= replace(ucase(trim(Attributes.name)),"SESSION.","")>
		<cfelse>
			<cfset create_prolog = "create table">
			<cfset create_epilog = " ">
			<cfset TABSCHEMA = ucase(trim(Application.dsinfo[Attributes.datasource].schema))>
			<cfset TABNAME		= ucase(trim(Attributes.name))>
		</cfif>

		<cfif trim(Application.dsinfo[Attributes.datasource].schema) EQ "">
			<cfthrow message="No se ha cargado el esquema del DSN='#Attributes.datasource#': #Application.dsinfo[Attributes.datasource].SCHEMAERROR#">
		</cfif>
		<cftry>
			<cfquery datasource="#Attributes.datasource#" name="existe">
				SELECT count(1) from #Attributes.name#
			</cfquery>
			<cfset create_condition = false>
		<cfcatch type="any">
			<cfset create_condition = true>
		</cfcatch>
		</cftry>
		
		<cfif NOT create_condition>
			<cfif Attributes.jdbc>
				<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
				<cfoutput>
					drop table #Attributes.name#
				</cfoutput>
				</cf_jdbcquery_open>
			<cfelse>
				<cfquery datasource="#Attributes.datasource#">
					drop table #Attributes.name#
				</cfquery>
			</cfif>		
			<cfset create_condition = true>
		</cfif>
	<cfelse>
		<cfthrow message="cf_dbtemp no soportado para DBMS #dbtype#">
	</cfif>

	<!--- Guarda las tablas temporales a ser borradas por cf_dbtemp_deletes --->
	<cfif Attributes.temp AND not Attributes.jdbc>
		<cfif not isdefined("request.cf_dbtemp_deletes_names") or request.cf_dbtemp_deletes_names EQ "">
			<cfset request.cf_dbtemp_deletes_names = "#Attributes.datasource#|#Attributes.name#">
		<cfelse>
			<cfset request.cf_dbtemp_deletes_names = request.cf_dbtemp_deletes_names & ",#Attributes.datasource#|#Attributes.name#">
		</cfif>
	</cfif>
			
	<cfif create_condition>
		<cfset sqlstring = "">
		<cfset identity_column = "">
		<!--- CREATE TABLE: Columnas --->
		<cfloop index="i" from="1" to="#ArrayLen(ThisTag.Columns)#">
			<cfloop index="k" from="1" to="#ArrayLen(ThisTag.Keys)#">
				<cfif (ListFind(ThisTag.Keys[k].cols, ThisTag.Columns[i].name))>
					<cfset ThisTag.Columns[i].mandatory = true>
				</cfif>
			</cfloop>
			<cfif i gt 1><cfset sqlstring = sqlstring & ","></cfif>
			<cfset sqlstring = sqlstring & chr(13) & "  " &
				ThisTag.Columns[i].name & " " & TranslateColumnType(ThisTag.Columns[i].type)>
			<cfif Len(identity_column) is 0 and ThisTag.Columns[i].identity>
				<cfset identity_column = ThisTag.Columns[i].name>
				<cfif ListFind('sybase,sqlserver', dbtype)>
					<cfset sqlstring = sqlstring & " identity ">
				<cfelseif ListFind('db2', dbtype)>
					<cfset sqlstring = sqlstring & " GENERATED BY DEFAULT AS IDENTITY ">
				</cfif>
			</cfif>
			<cfif ThisTag.Columns[i].mandatory>
				<cfset sqlstring = sqlstring & " not null">
			<cfelse>
				<cfif ListFind('sybase,sqlserver, oracle', dbtype)>
					<cfset sqlstring = sqlstring & " null">
				</cfif>
			</cfif>
		</cfloop>
		<cfif Attributes.jdbc>
			<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
			<cfoutput>
				#create_prolog# #Attributes.name# ( #sqlstring# ) #create_epilog#
			</cfoutput>
			</cf_jdbcquery_open>
		<cfelse>
			<cfquery datasource="#Attributes.datasource#">
				#create_prolog# #Attributes.name# ( #sqlstring# ) #create_epilog#
			</cfquery>
		</cfif>

		<cfif NOT (dbtype is 'db2' AND Attributes.temp)>
			<!--- ALTER TABLE ADD PRIMARY/UNIQUE --->
			<cfloop from="1" to="#ArrayLen(ThisTag.Keys)#" index="i">
				<cfif Attributes.jdbc>
					<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
					<cfoutput>
						alter table #Attributes.name# add
						<cfif i is 1>primary key<cfelse>unique</cfif>
						( #ThisTag.Keys[i].cols# )
					</cfoutput>
					</cf_jdbcquery_open>
				<cfelse>
					<cfquery datasource="#Attributes.datasource#">
						alter table #Attributes.name# add
						<cfif i is 1>primary key<cfelse>unique</cfif>
						( #ThisTag.Keys[i].cols# )
					</cfquery>
				</cfif>		
			</cfloop>
	
			<!--- CREATE INDEX --->
			<cfloop from="1" to="#ArrayLen(ThisTag.Indexes)#" index="i">
				<cfif Attributes.jdbc>
					<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
					<cfoutput>
						create index #Replace( Attributes.name, '##', '', 'one' )#_idx#i# on #Attributes.name#
						( #ThisTag.Indexes[i].cols# )
					</cfoutput>
					</cf_jdbcquery_open>
				<cfelse>
					<cfquery datasource="#Attributes.datasource#">
						create index #Replace( Attributes.name, '##', '', 'one' )#_idx#i# on #Attributes.name#
						( #ThisTag.Indexes[i].cols# )
					</cfquery>
				</cfif>		
			</cfloop>
		</cfif>
		
		<!--- CREATE SEQUENCE --->
		<cfif Len (identity_column)>
			<cfset sbCreateSequence()>
		</cfif>
	<cfelseif dbtype is 'oracle'>
		<cfif Attributes.jdbc>
			<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
			<cfoutput>
				delete from #Attributes.name#
			</cfoutput>
			</cf_jdbcquery_open>
		<cfelse>
			<cfquery datasource="#Attributes.datasource#">
				delete from #Attributes.name#
			</cfquery>
		</cfif>		
	
		<cfset identity_column = "">
		<cfloop from="1" to="#ArrayLen(ThisTag.Columns)#" index="i">
			<cfif ThisTag.Columns[i].identity>
				<cfset identity_column = ThisTag.Columns[i].name>
				<cfbreak>
			</cfif>
		</cfloop>

		<cfif Len (identity_column)>
			<cfset sbCreateSequence()>
 		</cfif>
	</cfif>
	<cfset Caller[Attributes.returnvariable] = #Attributes.name#>
<cfelseif len(Attributes.name) GT 11>
	<cfif session.Usulogin EQ 'marcel' and session.Usucodigo EQ 27>
		<cftry>
			<cfthrow message="Tabla con nombre mayor a 16: #Attributes.name#">
		<cfcatch type="any">
			<cfset LvarTemplate = "iniciado desde: #getBaseTemplatePath()#">
			<cfset LvarTagContext = cfcatch.TagContext[1]>
			<cfif isdefined("LvarTagContext.template") AND isdefined("LvarTagContext.raw_trace")>
				<cfloop index="i" from="1" to="#arrayLen(cfcatch.TagContext)#">
					<cfif right(cfcatch.TagContext[i].template,10) NEQ "dbtemp.cfm">
						<cfset LvarTemplate = "#cfcatch.TagContext[i].raw_trace#">
						<cfset LvarTemplate = mid(LvarTemplate, find("(",LvarTemplate)+1,100)>
						<cfset LvarTemplate = "en: " & mid(LvarTemplate, 1,len(LvarTemplate)-1)>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset LvarTemplate = "Tabla Temporal '#Attributes.name#' mayor que 12, #LvarTemplate#">
			<cflog file="dbtemp_warning" text="#LvarTemplate#">
		</cfcatch>
		</cftry>
	</cfif>
</cfif>
</cfsilent>

<cffunction name="TranslateColumnType" output="no" returntype="string">
	<cfargument name="type" type="string" required="yes">
	
	<cfif ListFind('sybase,sqlserver', dbtype)>
		<cfset LvarTipo = ColumnTypeToSYBASE(ColumnTypeFromDBtemp(Arguments.type))>
	<cfelseif dbtype EQ "oracle">
		<cfset LvarTipo = ColumnTypeToORACLE(ColumnTypeFromDBtemp(Arguments.type))>
	<cfelseif dbtype EQ "db2">
		<cfset LvarTipo = ColumnTypeToDB2(ColumnTypeFromDBtemp(Arguments.type))>
	<cfelse>
		<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #dbtype#">
	</cfif>
	<cfreturn LvarTipo>
	
	<cfset type = replace(lcase(type)," ","","ALL")>
	<cfif ListFind('sybase,sqlserver', dbtype)>
		<cfif type EQ "binary">					<cfreturn 'binary(1)'>
		<cfelseif find("binary(",type) EQ 1>	<cfreturn type>
		<cfelseif type EQ "bit">				<cfreturn type>
		<cfelseif type EQ "char">				<cfreturn 'char(1)'>
		<cfelseif find("char(",type) EQ 1>		<cfreturn type>
		<cfelseif type EQ "date">				<cfreturn 'datetime'>
		<cfelseif type EQ "datetime">			<cfreturn 'datetime'>
		<cfelseif type EQ "dec">				<cfreturn type>
		<cfelseif find("dec(",type)>			<cfreturn type>
		<cfelseif type EQ "decimal">			<cfreturn type>
		<cfelseif find("decimal(",type)>		<cfreturn type>
		<cfelseif type EQ "float">				<cfreturn type>
		<cfelseif find("float(",type)>			<cfreturn type>
		<cfelseif type EQ "image">				<cfreturn type>
		<cfelseif type EQ "int">				<cfreturn type>
		<cfelseif type EQ "integer">			<cfreturn type>
		<cfelseif type EQ "money">				<cfreturn type>
		<cfelseif type EQ "numeric">			<cfreturn type>
		<cfelseif find("numeric(",type)>		<cfreturn type>
		<cfelseif type EQ "real">				<cfreturn type>
		<cfelseif type EQ "smalldate">			<cfreturn 'datetime'>
		<cfelseif type EQ "smalldatetime">		<cfreturn 'datetime'>
		<cfelseif type EQ "smallint">			<cfreturn type>
		<cfelseif type EQ "smallmoney">			<cfreturn type>
		<cfelseif type EQ "text">				<cfreturn type>
		<cfelseif type EQ "timestamp">			<cfreturn type>
		<cfelseif type EQ "tinyint">			<cfreturn type>
		<cfelseif type EQ "varbinary">			<cfreturn 'varbinary(1)'>
		<cfelseif find("varbinary(",type)>		<cfreturn type>
		<cfelseif type EQ "varchar">			<cfreturn 'varchar(1)'>
		<cfelseif find("varchar(",type)>		<cfreturn type>
		<cfelse>
			<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #type#">
		</cfif>
	<!---<cfelseif dbtype EQ 'oracle'>--->
	<cfelseif ListFind('oracle', dbtype)>
		<cfif type EQ "binary">					<cfreturn 'RAW(1)'>
		<cfelseif find("binary(",type) EQ 1>	<cfreturn replace(type,"binary","RAW")>
		<cfelseif type EQ "bit">				<cfreturn 'SMALLINT'>
		<cfelseif type EQ "char">				<cfreturn 'CHAR(1)'>
		<cfelseif find("char(",type) EQ 1>		<cfreturn replace(type,"char","CHAR")>
		<cfelseif type EQ "date">				<cfreturn 'DATE'>
		<cfelseif type EQ "datetime">			<cfreturn 'DATE'>
		<cfelseif type EQ "dec">				<cfreturn 'NUMBER(18)'>
		<cfelseif find("dec(",type)>			<cfreturn replace(type,"dec","NUMBER")>
		<cfelseif type EQ "decimal">			<cfreturn 'NUMBER'>
		<cfelseif find("decimal(",type)>		<cfreturn replace(type,"decimal","NUMBER")>
		<cfelseif type EQ "float">				<cfreturn 'FLOAT'>
		<cfelseif find("float(",type)>			<cfreturn replace(type,"float","FLOAT")>
		<cfelseif type EQ "image">				<cfreturn 'BLOB'>
		<cfelseif type EQ "int">				<cfreturn 'INTEGER'>
		<cfelseif type EQ "integer">			<cfreturn 'INTEGER'>
		<cfelseif type EQ "money">				<cfreturn 'NUMBER(18,4)'>
		<cfelseif type EQ "numeric">			<cfreturn 'NUMBER(18)'>
		<cfelseif find("numeric(",type)>		<cfreturn replace(type,"numeric","NUMBER")>
		<cfelseif type EQ "real">				<cfreturn 'FLOAT'>
		<cfelseif type EQ "smalldatetime">		<cfreturn 'DATE'>
		<cfelseif type EQ "smallint">			<cfreturn 'SMALLINT'>
		<cfelseif type EQ "smallmoney">			<cfreturn 'NUMBER(18,4)'>
		<cfelseif type EQ "text">				<cfreturn 'CLOB'>
		<cfelseif type EQ "timestamp">			<cfreturn 'TIMESTAMP'>
		<cfelseif type EQ "tinyint">			<cfreturn 'SMALLINT'>
		<cfelseif type EQ "varbinary">			<cfreturn 'RAW(1)'>
		<cfelseif find("varbinary(",type)>		<cfreturn replace(type,"varbinary","RAW")>
		<cfelseif type EQ "varchar">			<cfreturn 'VARCHAR2(1)'>
		<cfelseif find("varchar(",type)>		<cfreturn replace(type,"varchar","varchar2")>
		<cfelse>
			<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #type#">
		</cfif>
	<cfelseif ListFind('db2', dbtype)>
		<cfif type EQ "binary">					<cfreturn 'BLOB(1)'>
		<cfelseif find("binary(",type) EQ 1>	<cfreturn replace(type,"binary","BLOB")>
		<cfelseif type EQ "bit">				<cfreturn 'SMALLINT'>
		<cfelseif type EQ "char">				<cfreturn 'CHAR(1)'>
		<cfelseif find("char(",type) EQ 1>		<cfreturn replace(type,"char","CHAR")>
		<cfelseif type EQ "date">				<cfreturn 'TIMESTAMP'>
		<cfelseif type EQ "datetime">			<cfreturn 'TIMESTAMP'>
		<cfelseif type EQ "dec">				<cfreturn 'DECIMAL(18)'>
		<cfelseif find("dec(",type)>			<cfreturn replace(type,"dec","DECIMAL")>
		<cfelseif type EQ "decimal">			<cfreturn 'DECIMAL'>
		<cfelseif find("decimal(",type)>		<cfreturn replace(type,"decimal","DECIMAL")>
		<cfelseif type EQ "float">				<cfreturn 'FLOAT'>
		<cfelseif find("float(",type)>			<cfreturn replace(type,"float","FLOAT")>
		<cfelseif type EQ "image">				<cfreturn 'BLOB(2G) NOT LOGGED'>
		<cfelseif type EQ "int">				<cfreturn 'INTEGER'>
		<cfelseif type EQ "integer">			<cfreturn 'INTEGER'>
		<cfelseif type EQ "money">				<cfreturn 'DECIMAL(18,4)'>
		<cfelseif type EQ "numeric">			<cfreturn 'DECIMAL(18)'>
		<cfelseif find("numeric(",type)>		<cfreturn replace(type,"numeric","DECIMAL")>
		<cfelseif type EQ "real">				<cfreturn 'FLOAT'>
		<cfelseif type EQ "smalldatetime">		<cfreturn 'TIMESTAMP'>
		<cfelseif type EQ "smallint">			<cfreturn 'SMALLINT'>
		<cfelseif type EQ "smallmoney">			<cfreturn 'DECIMAL(18,4)'>
		<cfelseif type EQ "text">				<cfreturn 'CLOB(2G) NOT LOGGED'>
		<cfelseif type EQ "timestamp">			<cfreturn 'TIMESTAMP'>
		<cfelseif type EQ "tinyint">			<cfreturn 'SMALLINT'>
		<cfelseif type EQ "varbinary">			<cfreturn 'BLOB(1)'>
		<cfelseif find("varbinary(",type)>		<cfreturn replace(type,"varbinary","BLOB")>
		<cfelseif type EQ "varchar">			<cfreturn 'VARCHAR(1)'>
		<cfelseif find("varchar(",type)>		<cfreturn replace(type,"varchar","VARCHAR")>
		<cfelse>
			<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #type#">
		</cfif>
	<cfelse>
		<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #dbtype#">
	</cfif>
	<cfreturn type>
</cffunction>

<cffunction name="sbCreateSequence" output="no">
	<cfif dbtype is 'oracle'>
		<cfset LvarPK_TEMP_Name = mid("PK_TEMP_#Attributes.name#",1,30)>
		<cfif Attributes.temp>
			<cftry>
				<cfif Attributes.jdbc>
					<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
					<cfoutput>
						EXECUTE #LvarPK_TEMP_Name#.P_INITVAL
					</cfoutput>
					</cf_jdbcquery_open>
				<cfelse>
					<cfstoredproc procedure="#LvarPK_TEMP_Name#.P_INITVAL" datasource="#Attributes.datasource#" />
				</cfif>
				<!--- Si se crea la tabla: crea el package y el trigger --->
				<cfif create_condition>
					<cfset sbCreateSequenceOracleTemp()>
				</cfif>
			<cfcatch type="any">
				<cftry>
					<!--- Si no existe el package: crea el package y el trigger --->
					<cfset sbCreateSequenceOracleTemp()>
				<cfcatch type="any">
					<!--- Si la creacion del package o trigger da error borra la tabla y el package --->
					<cftry>
						<cfif Attributes.jdbc>
							<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
							<cfoutput>
								DROP PACKAGE #LvarPK_TEMP_Name#
							</cfoutput>
							</cf_jdbcquery_open>
						<cfelse>
							<cfquery datasource="#Attributes.datasource#">
								DROP PACKAGE #LvarPK_TEMP_Name#
							</cfquery>
						</cfif>
					<cfcatch type="any">
					</cfcatch>
					</cftry>
					<cftry>
						<cfif Attributes.jdbc>
							<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
							<cfoutput>
								DROP TABLE #Attributes.name#
							</cfoutput>
							</cf_jdbcquery_open>
						<cfelse>
							<cfquery datasource="#Attributes.datasource#">
								DROP TABLE #Attributes.name#
							</cfquery>
						</cfif>
					<cfcatch type="any">
					</cfcatch>
					</cftry>
				</cfcatch>
				</cftry>
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset sbCreateSequenceOraclePerm()>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="sbCreateSequenceOracleTemp" output="no">
	<cfset line_feed = chr(10)><!--- no se porqué no funciona con el 13+10 --->
	<cfif Attributes.jdbc>
		<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#"><cfoutput>#line_feed
			#CREATE OR REPLACE PACKAGE #LvarPK_TEMP_Name# AS  #line_feed
			#  IDENTITY NUMBER :=0;  #line_feed
			#  FUNCTION F_NEXTVAL RETURN NUMBER;  #line_feed
			#  PROCEDURE P_INITVAL;  #line_feed
			#END #LvarPK_TEMP_Name#;  #line_feed
		#</cfoutput></cf_jdbcquery_open>
	<cfelse>
		<cfquery datasource="#Attributes.datasource#">#line_feed
			#CREATE OR REPLACE PACKAGE #LvarPK_TEMP_Name# AS  #line_feed
			#  IDENTITY NUMBER :=0;  #line_feed
			#  FUNCTION F_NEXTVAL RETURN NUMBER;  #line_feed
			#  PROCEDURE P_INITVAL;  #line_feed
			#END #LvarPK_TEMP_Name#;  #line_feed
		#</cfquery>
	</cfif>		
	<cfif Attributes.jdbc>
		<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#"><cfoutput>#line_feed
			#CREATE OR REPLACE PACKAGE BODY #LvarPK_TEMP_Name# AS  #line_feed
			#  function F_NEXTVAL return NUMBER as  #line_feed
			#  begin  #line_feed
			#    IDENTITY := IDENTITY + 1;  #line_feed
			#    RETURN IDENTITY;  #line_feed
			#  end;  #line_feed
			#  procedure P_INITVAL as  #line_feed
			#  begin  #line_feed
			#    IDENTITY := 0;  #line_feed
			#  end;  #line_feed
			#END #LvarPK_TEMP_Name#;  #line_feed
		#</cfoutput></cf_jdbcquery_open>
	<cfelse>
		<cfquery datasource="#Attributes.datasource#">#line_feed
			#CREATE OR REPLACE PACKAGE BODY #LvarPK_TEMP_Name# AS  #line_feed
			#  function F_NEXTVAL return NUMBER as  #line_feed
			#  begin  #line_feed
			#    IDENTITY := IDENTITY + 1;  #line_feed
			#    RETURN IDENTITY;  #line_feed
			#  end;  #line_feed
			#  procedure P_INITVAL as  #line_feed
			#  begin  #line_feed
			#    IDENTITY := 0;  #line_feed
			#  end;  #line_feed
			#END #LvarPK_TEMP_Name#;  #line_feed
		#</cfquery>
	</cfif>		
	<!--- #   select S_TEMP_#Attributes.name#.nextval into SOINPK.LASTIDENTITY from dual; #line_feed --->
	<cfif Attributes.jdbc>
		<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#"><cfoutput>#line_feed
			#CREATE OR REPLACE TRIGGER #line_feed
			#tib_#Attributes.name# BEFORE #line_feed
			#INSERT ON #Attributes.name# FOR EACH ROW declare integrity_error  exception; #line_feed
			#   errno            integer; #line_feed
			#   errmsg           char(200); #line_feed
			#   dummy            integer; #line_feed
			#   found            boolean; #line_feed
			#begin #line_feed
			#   select #LvarPK_TEMP_Name#.F_nextval into SOINPK.LASTIDENTITY from dual; #line_feed
			#   select SOINPK.LASTIDENTITY INTO :new.#identity_column# FROM dual; #line_feed
			#exception #line_feed
			#   when integrity_error then #line_feed
			#      raise_application_error(errno, errmsg); #line_feed
			#end; #line_feed
		#</cfoutput></cf_jdbcquery_open>
	<cfelse>
		<cfquery datasource="#Attributes.datasource#"> #line_feed
			#CREATE OR REPLACE TRIGGER #line_feed
			#tib_#Attributes.name# BEFORE #line_feed
			#INSERT ON #Attributes.name# FOR EACH ROW declare integrity_error  exception; #line_feed
			#   errno            integer; #line_feed
			#   errmsg           char(200); #line_feed
			#   dummy            integer; #line_feed
			#   found            boolean; #line_feed
			#begin #line_feed
			#   select #LvarPK_TEMP_Name#.F_nextval into SOINPK.LASTIDENTITY from dual; #line_feed
			#   select SOINPK.LASTIDENTITY INTO :new.#identity_column# FROM dual; #line_feed
			#exception #line_feed
			#   when integrity_error then #line_feed
			#      raise_application_error(errno, errmsg); #line_feed
			#end; #line_feed
		#</cfquery>
	</cfif>		
</cffunction>

<cffunction name="sbCreateSequenceOraclePerm" output="no">
	<cfset line_feed = chr(10)><!--- no se porqué no funciona con el 13+10 --->
	<cfif Attributes.jdbc>
		<cftry>
			<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
			<cfoutput>
				DROP SEQUENCE S_#Attributes.name#
			</cfoutput>
			</cf_jdbcquery_open>
		<cfcatch type="any"></cfcatch>
		</cftry>
		<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#">
		<cfoutput>
			CREATE SEQUENCE S_#Attributes.name#
		</cfoutput>
		</cf_jdbcquery_open>
	<cfelse>
		<cftry>
			<cfquery datasource="#Attributes.datasource#">
				DROP SEQUENCE S_#Attributes.name#
			</cfquery>
		<cfcatch type="any"></cfcatch>
		</cftry>
		<cfquery datasource="#Attributes.datasource#">
			CREATE SEQUENCE S_#Attributes.name#
		</cfquery>
	</cfif>		
	<!--- #   select S_TEMP_#Attributes.name#.nextval into SOINPK.LASTIDENTITY from dual; #line_feed --->
	<cfif Attributes.jdbc>
		<cf_jdbcquery_open update="yes" datasource="#Attributes.datasource#"><cfoutput>#line_feed
			#CREATE OR REPLACE TRIGGER #line_feed
			#tib_#Attributes.name# BEFORE #line_feed
			#INSERT ON #Attributes.name# FOR EACH ROW declare integrity_error  exception; #line_feed
			#   errno            integer; #line_feed
			#   errmsg           char(200); #line_feed
			#   dummy            integer; #line_feed
			#   found            boolean; #line_feed
			#begin #line_feed
			#   IF (SOINPK.IDENTITYOFF = 0) THEN #line_feed
			#     select S_#Attributes.name#.nextval INTO SOINPK.LASTIDENTITY FROM dual; #line_feed
			#     select SOINPK.LASTIDENTITY INTO :new.#identity_column# FROM dual; #line_feed
			#   END IF; #line_feed
			#exception #line_feed
			#   when integrity_error then #line_feed
			#      raise_application_error(errno, errmsg); #line_feed
			#end; #line_feed
		#</cfoutput></cf_jdbcquery_open>
	<cfelse>
		<cfquery datasource="#Attributes.datasource#"> #line_feed
			#CREATE OR REPLACE TRIGGER #line_feed
			#tib_#Attributes.name# BEFORE #line_feed
			#INSERT ON #Attributes.name# FOR EACH ROW declare integrity_error  exception; #line_feed
			#   errno            integer; #line_feed
			#   errmsg           char(200); #line_feed
			#   dummy            integer; #line_feed
			#   found            boolean; #line_feed
			#begin #line_feed
			#   IF (SOINPK.IDENTITYOFF = 0) THEN #line_feed
			#     select S_#Attributes.name#.nextval INTO SOINPK.LASTIDENTITY FROM dual; #line_feed
			#     select SOINPK.LASTIDENTITY INTO :new.#identity_column# FROM dual; #line_feed
			#   END IF; #line_feed
			#exception #line_feed
			#   when integrity_error then #line_feed
			#      raise_application_error(errno, errmsg); #line_feed
			#end; #line_feed
		#</cfquery>
	</cfif>		
</cffunction>

<!---
'TIPOS DE DATOS:
'   String:
'       char,nchar,varchar,nvarchar,sysname     C=char,V=VarChar         n,1
'   Binarios:
'       binary,varbinary                        B=Binary,VB=VarBinary    n,1
'   LOB:
'       text, image                             CL=CLOB,BL=BLOB         -2
'   Numéricos Entero:
'       biginteger,integer,int,smallint,tinyint I=Integer                20,10,5,3
'   Numéricos Punto Fijo:
'       numeric,decimal,dec                     N=Numeric                n,d
'   Numéricos Punto Flotante:
'       real, float, double precision           F=Float                  7,15
'   Numéricos Montos:
'       money,smallmoney                        M=Money                  18,4
'   Logicos:
'       bit                                     L=Logico                 1
'   Fecha:
'       date, datetime, smalldatetime           D=DateTime               0
'   Control de Concurrencia optimístico:
'       timestamp                               TS=Timestamp             0
--->
<cffunction name="ColumnTypeFromDBtemp" returntype="struct" output="no">
	<cfargument name="Tipo">
	
	<!--- LvarTipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTYPE = structNew()>
	<cfset LvarTYPE.Tip = "">
	<cfset LvarTYPE.Lon = "">
	<cfset LvarTYPE.Decs = "">
	<cfset LvarTYPE.Def = "">
	<cfset LvarTipo		= replace(trim(Arguments.Tipo),"  "," ","ALL")>

	<cfset LvarDefault = findnocase(" default ", LvarTipo)>
	<cfif LvarDefault NEQ 0>
		<cfset LvarTYPE.Def	= mid (LvarTipo,LvarDefault,100)>
		<cfset LvarTipo		= mid (LvarTipo,1,LvarDefault-1)>
	</cfif>
	
	<cfset LvarTipo 	= replace(LvarTipo,"(",",")>
	<cfset LvarTipo 	= replace(LvarTipo,")","") & ",0,0">
	<cfset LvarTYPE.Tip 	= lcase(listGetAt(LvarTipo,1))>
	<cfset LvarTYPE.Lon 	= listGetAt(LvarTipo,2)>
	<cfset LvarTYPE.Decs 	= listGetAt(LvarTipo,3)>

	<cfif listFind("char,nchar",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "C">
	<cfelseif listFind("varchar,nvarchar,sysname",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "V">
	<cfelseif LvarTYPE.Tip EQ "binary">
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "B">
	<cfelseif LvarTYPE.Tip EQ "varbinary">
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "VB">
	<cfelseif LvarTYPE.Tip EQ "text">
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "CL">
	<cfelseif LvarTYPE.Tip EQ "image">
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "BL">
	<cfelseif listFind("bigint,biginteger,integer,int,smallint,tinyint",LvarTYPE.Tip)>
		<cfif find("big", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 19>
		<cfelseif find("small", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 5>
		<cfelseif find("tiny", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 3>
		<cfelse>
			<cfset LvarTYPE.Lon = 10>
		</cfif>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "I">
	<cfelseif listFind("numeric,decimal,dec",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 18>
		</cfif>
		<cfset LvarTYPE.Tip = "N">
	<cfelseif listFind("real,float,double,double precision",LvarTYPE.Tip)>
		<cfif LvarTYPE.Tip EQ "real">
			<cfset LvarTYPE.Lon = 7>
		<cfelseif find("double",LvarTYPE.Tip)>
			<cfset LvarTYPE.Lon = 15>
		<cfelseif LvarTYPE.Lon EQ 0 OR LvarTYPE.Lon GTE 8>
			<cfset LvarTYPE.Lon = 15>
		<cfelse>
			<cfset LvarTYPE.Lon = 7>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "F">
	<cfelseif listFind("money,smallmoney",LvarTYPE.Tip)>
		<cfset LvarTYPE.Lon = "18">
		<cfset LvarTYPE.Decs = "4">
		<cfset LvarTYPE.Tip = "M">
	<cfelseif LvarTYPE.Tip EQ "bit">
		<cfset LvarTYPE.Lon = "1">
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "L">
	<cfelseif listFind("date,datetime,smalldatetime",LvarTYPE.Tip)>
		<cfset LvarTYPE.Lon = "">
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "D">
	<cfelseif LvarTYPE.Tip EQ "timestamp">
		<cfset LvarTYPE.Lon = "">
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "TS">
	<cfelse>
		<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #LvarTYPE.Tip#">
	</cfif>
	<cfreturn LvarType>
</cffunction>

<cffunction name="ColumnTypeToSYBASE" returntype="string" output="no">
	<cfargument name="Type" type="struct">
	
	<!--- LvarTipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTipos["C"]	= "char(L)">
	<cfset LvarTipos["V"]	= "varchar(L)">
	<cfset LvarTipos["B"]	= "binary(L)">
	<cfset LvarTipos["VB"]	= "varbinary(L)">
	<cfset LvarTipos["CL"]	= "text">
	<cfset LvarTipos["BL"]	= "image">
	<cfset LvarTipos["I"]	= "****">
	<cfset LvarTipos["N"]	= "numeric(LD)">
	<cfset LvarTipos["F"]	= "float">
	<cfset LvarTipos["M"]	= "money">
	<cfset LvarTipos["L"]	= "bit">
	<cfset LvarTipos["D"]	= "datetime">
	<cfset LvarTipos["TS"]	= "timestamp">
	
	<cfif Arguments.Type.Tip EQ "I">
		<cfif Arguments.Type.Lon EQ 3>
			<cfset LvarTipo = "tinyint">
		<cfelseif Arguments.Type.Lon EQ 5>
			<cfset LvarTipo = "smallint">
		<cfelseif Arguments.Type.Lon EQ 10>
			<cfset LvarTipo = "integer">
		<cfelseif Arguments.Type.Lon EQ 19>
			<cfset LvarTipo = "bigint">
		</cfif>
	<cfelse>
		<cfset LvarTipLon		= "(#Arguments.Type.Lon#)">
		<cfif Arguments.Type.Decs GT 0>
			<cfset LvarTipLonDec	= "(#Arguments.Type.Lon#,#Arguments.Type.Decs#)">
		<cfelse>
			<cfset LvarTipLonDec	= LvarTipLon>
		</cfif>
		
		<cfset LvarTipo = replace(LvarTipos[Arguments.Type.Tip],"(L)",LvarTipLon)>
		<cfset LvarTipo = replace(LvarTipo,"(LD)",LvarTipLonDec)>
	</cfif>
	
	<cfset LvarTipo = LvarTipo & Arguments.Type.Def>
	<cfreturn LvarTipo>
</cffunction>

<cffunction name="ColumnTypeToORACLE" returntype="string" output="no">
	<cfargument name="Type">
	
	<!--- LvarTipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTipos["C"]	= "VARCHAR2(L)">
	<cfset LvarTipos["V"]	= "VARCHAR2(L)">
	<cfset LvarTipos["B"]	= "RAW(L)">
	<cfset LvarTipos["VB"]	= "RAW(L)">
	<cfset LvarTipos["CL"]	= "CLOB">
	<cfset LvarTipos["BL"]	= "BLOB">
	<cfset LvarTipos["I"]	= "NUMBER(L)">
	<cfset LvarTipos["N"]	= "NUMBER(LD)">
	<cfset LvarTipos["F"]	= "****">
	<cfset LvarTipos["M"]	= "NUMBER(18,4)">
	<cfset LvarTipos["L"]	= "NUMBER(1)">
	<cfset LvarTipos["D"]	= "DATE">
	<cfset LvarTipos["TS"]	= "TIMESTAMP">
	
	<cfif Arguments.Type.Tip EQ "F">
		<cfif Arguments.Type.Lon EQ 7>
			<cfset LvarTipo = "FLOAT(24)">
		<cfelse>
			<cfset LvarTipo = "FLOAT(53)">
		</cfif>
	<cfelse>
		<cfset LvarTipLon		= "(#Arguments.Type.Lon#)">
		<cfif Arguments.Type.Decs GT 0>
			<cfset LvarTipLonDec	= "(#Arguments.Type.Lon#,#Arguments.Type.Decs#)">
		<cfelse>
			<cfset LvarTipLonDec	= LvarTipLon>
		</cfif>
		
		<cfset LvarTipo = replace(LvarTipos[Arguments.Type.Tip],"(L)",LvarTipLon)>
		<cfset LvarTipo = replace(LvarTipo,"(LD)",LvarTipLonDec)>
	</cfif>
	
	<cfset Arguments.Type.Def = replaceNoCase(Arguments.Type.Def,"getdate()","SYSDATE")>
	<cfset LvarTipo = LvarTipo & Arguments.Type.Def>
	<cfreturn LvarTipo>
</cffunction>

<cffunction name="ColumnTypeToDB2" returntype="string" output="no">
	<cfargument name="Type">
	
	<!--- LvarTipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTipos["C"]	= "CHAR(L)">
	<cfset LvarTipos["V"]	= "VARCHAR(L)">
	<cfset LvarTipos["B"]	= "CLOB(L)">
	<cfset LvarTipos["VB"]	= "BLOB(L)">
	<cfset LvarTipos["CL"]	= "CLOB(2G) NOT LOGGED">
	<cfset LvarTipos["BL"]	= "BLOB(2G) NOT LOGGED">
	<cfset LvarTipos["I"]	= "****">
	<cfset LvarTipos["N"]	= "DECIMAL(LD)">
	<cfset LvarTipos["F"]	= "****">
	<cfset LvarTipos["M"]	= "DECIMAL(18,4)">
	<cfset LvarTipos["L"]	= "DECIMAL(1)">
	<cfset LvarTipos["D"]	= "TIMESTAMP">
	<cfset LvarTipos["TS"]	= "TIMESTAMP">

	<cfif Arguments.Type.Tip EQ "F">
		<cfif Arguments.Type.Lon EQ 7>
			<cfset LvarTipo = "FLOAT(24)">
		<cfelse>
			<cfset LvarTipo = "FLOAT(53)">
		</cfif>
	<cfelseif Arguments.Type.Tip EQ "I">
		<cfif Arguments.Type.Lon EQ 3>
			<cfset LvarTipo = "DECIMAL(3)">
		<cfelseif Arguments.Type.Lon EQ 5>
			<cfset LvarTipo = "SMALLINT">
		<cfelseif Arguments.Type.Lon EQ 10>
			<cfset LvarTipo = "INTEGER">
		<cfelseif Arguments.Type.Lon EQ 19>
			<cfset LvarTipo = "BIGINT">
		</cfif>
	<cfelse>
		<cfset LvarTipLon		= "(#Arguments.Type.Lon#)">
		<cfif Arguments.Type.Decs GT 0>
			<cfset LvarTipLonDec	= "(#Arguments.Type.Lon#,#Arguments.Type.Decs#)">
		<cfelse>
			<cfset LvarTipLonDec	= LvarTipLon>
		</cfif>
		
		<cfset LvarTipo = replace(LvarTipos[Arguments.Type.Tip],"(L)",LvarTipLon)>
		<cfset LvarTipo = replace(LvarTipo,"(LD)",LvarTipLonDec)>
	</cfif>
	
	<cfset Arguments.Type.Def = replaceNoCase(Arguments.Type.Def,"getdate()","CURRENT TIMESTAMP")>
	<cfset LvarTipo = LvarTipo & Arguments.Type.Def>
	<cfreturn LvarTipo>
</cffunction>

<cffunction name="ColumnTypeFromORACLE" returntype="struct" output="no">
	<cfargument name="Tipo">
	
	<cfset LvarTYPE = structNew()>
	<cfset LvarTYPE.Tip = "">
	<cfset LvarTYPE.Lon = "">
	<cfset LvarTYPE.Decs = "">
	<cfset LvarTipo		= trim(replace(Arguments.Tipo,"  "," "))>
	<cfset LvarTipo 	= replace(LvarTipo,"(",",")>
	<cfset LvarTipo 	= replace(LvarTipo,")","") & ",0,0">
	<cfset LvarTYPE.Tip 	= lcase(listGetAt(LvarTipo,1))>
	<cfset LvarTYPE.Lon 	= listGetAt(LvarTipo,2)>
	<cfset LvarTYPE.Decs 	= listGetAt(LvarTipo,3)>
	
	<!--- LvarTipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfif listFind("CHAR",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "C">
	<cfelseif listFind("VARCHAR2",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "V">
	<cfelseif LvarTYPE.Tip EQ "RAW">
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "VB">
	<cfelseif LvarTYPE.Tip EQ "CLOB">
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "CL">
	<cfelseif LvarTYPE.Tip EQ "BLOB">
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "BL">
	<cfelseif LvarTYPE.tip EQ "NUMBER">
		<cfset LvarTYPE.Tip = "N">
	<cfelseif LvarTYPE.tip EQ "FLOAT">
		<cfset LvarTYPE.Tip = "F">
		<cfif find("big", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 19>
		<cfelseif find("small", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 5>
		<cfelseif find("tiny", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 3>
		<cfelse>
			<cfset LvarTYPE.Lon = 10>
		</cfif>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "I">
	<cfelseif listFind("numeric,decimal,dec",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 18>
		</cfif>
		<cfset LvarTYPE.Tip = "N">
	<cfelseif listFind("real,float,double,double precision",LvarTYPE.Tip)>
		<cfif LvarTYPE.Tip EQ "real">
			<cfset LvarTYPE.Lon = 7>
		<cfelseif find("double",LvarTYPE.Tip)>
			<cfset LvarTYPE.Lon = 15>
		<cfelseif LvarTYPE.Lon EQ 0 OR LvarTYPE.Lon GTE 8>
			<cfset LvarTYPE.Lon = 15>
		<cfelse>
			<cfset LvarTYPE.Lon = 7>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "F">
	<cfelseif listFind("money,smallmoney",LvarTYPE.Tip)>
		<cfset LvarTYPE.Lon = "18">
		<cfset LvarTYPE.Decs = "4">
		<cfset LvarTYPE.Tip = "M">
	<cfelseif LvarTYPE.Tip EQ "bit">
		<cfset LvarTYPE.Lon = "1">
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "L">
	<cfelseif listFind("date,datetime,smalldatetime",LvarTYPE.Tip)>
		<cfset LvarTYPE.Lon = "">
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "D">
	<cfelseif LvarTYPE.Tip EQ "timestamp">
		<cfset LvarTYPE.Lon = "">
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "TS">
	<cfelse>
		<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #LvarTYPE.Tip#">
	</cfif>
	<cfreturn LvarType>
</cffunction>

<cffunction name="ColumnTypeFromDB2" returntype="struct" output="no">
	<cfargument name="Tipo">
	
	<cfset LvarTYPE = structNew()>
	<cfset LvarTYPE.Tip = "">
	<cfset LvarTYPE.Lon = "">
	<cfset LvarTYPE.Decs = "">
	<cfset LvarTipo		= trim(replace(Arguments.Tipo,"  "," "))>
	<cfset LvarTipo 	= replace(LvarTipo,"(",",")>
	<cfset LvarTipo 	= replace(LvarTipo,")","") & ",0,0">
	<cfset LvarTYPE.Tip 	= lcase(listGetAt(LvarTipo,1))>
	<cfset LvarTYPE.Lon 	= listGetAt(LvarTipo,2)>
	<cfset LvarTYPE.Decs 	= listGetAt(LvarTipo,3)>
	
	<cfif listFind("CHAR,CHARACTER,NCHAR",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "C">
	<cfelseif listFind("VARCHAR,VARCHAR2,CHAR VARYING,CHARACTER VARYING,NVARCHAR",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "V">
	<cfelseif LvarTYPE.Tip EQ "RAW">
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "VB">
	<cfelseif LvarTYPE.Tip EQ "CLOB,NCLOB,LONG VARCHAR">
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "CL">
	<cfelseif LvarTYPE.Tip EQ "BLOB,LONG RAW">
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "BL">
	<cfelseif LvarTYPE.tip EQ "NUMBER">
	<cfelseif LvarTYPE.tip EQ "FLOAT">
		<cfif find("big", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 19>
		<cfelseif find("small", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 5>
		<cfelseif find("tiny", LvarTYPE.tip)>
			<cfset LvarTYPE.Lon = 3>
		<cfelse>
			<cfset LvarTYPE.Lon = 10>
		</cfif>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "I">
	<cfelseif listFind("numeric,decimal,dec",LvarTYPE.Tip)>
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 18>
		</cfif>
		<cfset LvarTYPE.Tip = "N">
	<cfelseif listFind("real,float,double,double precision",LvarTYPE.Tip)>
		<cfif LvarTYPE.Tip EQ "real">
			<cfset LvarTYPE.Lon = 7>
		<cfelseif find("double",LvarTYPE.Tip)>
			<cfset LvarTYPE.Lon = 15>
		<cfelseif LvarTYPE.Lon EQ 0 OR LvarTYPE.Lon GTE 8>
			<cfset LvarTYPE.Lon = 15>
		<cfelse>
			<cfset LvarTYPE.Lon = 7>
		</cfif>
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "F">
	<cfelseif listFind("money,smallmoney",LvarTYPE.Tip)>
		<cfset LvarTYPE.Lon = "18">
		<cfset LvarTYPE.Decs = "4">
		<cfset LvarTYPE.Tip = "M">
	<cfelseif LvarTYPE.Tip EQ "bit">
		<cfset LvarTYPE.Lon = "1">
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.Tip = "L">
	<cfelseif listFind("date,datetime,smalldatetime",LvarTYPE.Tip)>
		<cfset LvarTYPE.Lon = "">
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "D">
	<cfelseif LvarTYPE.Tip EQ "timestamp">
		<cfset LvarTYPE.Lon = "">
		<cfset LvarTYPE.Decs = "">
		<cfset LvarTYPE.Tip = "TS">
	<cfelse>
		<cfthrow message="cf_dbtemp TranslateColumnType no soportado para DBMS #LvarTYPE.Tip#">
	</cfif>
	<cfreturn LvarType>
</cffunction>
