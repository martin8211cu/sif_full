<!--- 
OBTENER LA ESTRUCTURA DE UNA TABLA

EJEMPLO 
<cf_dbstruct name="TABLA" returnvariable="rsStruct" datasource="#session.DSN#">

---->
<cfparam name="Attributes.name" type="string">
<cfparam name="Attributes.returnvariable" type="string" default="rsStruct">
<cfparam name="Attributes.datasource" default="">
<cfparam name="Attributes.sinDatosSoin" default="true" type="boolean">
 
<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cf_errorCode	code = "50597" msg = "Falta el atributo datasource, y session.dsn no está definida.">
	</cfif>
</cfif> 

<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="no">
</cfinvoke>

<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cf_errorCode	code = "50599"
					msg  = "Datasource no definido: @errorDat_1@"
					errorDat_1="#HTMLEditFormat(Attributes.datasource)#"
	>
</cfif>

<cfset dbtype = Application.dsinfo[Attributes.datasource].type>
<cfif ListFind('sybase,sqlserver',dbtype)>
	<!--- TiposPD = C,V,CL,	B,VB,BL,	I,N,F,M,L,	D,	TS --->
	<!--- TiposCF = S,		B,			N,			D,	TS --->
	<cfquery name="rsSQL" datasource="#Attributes.datasource#">
		select 	c.name, 

				<!--- Tipo Base de datos --->
				t.name as db_type,

				<!--- Tipo Standard DataBaseModel --->
				case
					when t.name in 	('char','nchar')						then 'C'
					when t.name in 	('varchar','nvarchar','sysname')		then 'V'
					when t.name 	= 'text'								then 'CL'

					when t.name 	= 'varbinary'							then 'VB'
					when t.name 	= 'binary'								then 'B'
					when t.name 	= 'image'								then 'BL'

					when charindex	('int', t.name) > 0						then 'I'
					when t.name in 	('decimal','dec','numeric')				then 'N'
					when t.name in 	('float','real','double',
									 'double precision') 					then 'F'
					when charindex	('money', t.name) > 0					then 'M'
					when t.name 	= 'bit'									then 'L'

					when charindex	('date', t.name) > 0					then 'D'
					when t.name 	= 'timestamp'							then 'TS'
				end as dbm_type,

				<!--- Tipo Coldfusion --->
				case
					when t.name in 	('char','nchar')							
					  OR t.name in 	('varchar','nvarchar','sysname')			
					  OR t.name 	= 'text'								then 'S'

					when t.name 	= 'binary'									
					  OR t.name 	= 'varbinary'								
					  OR t.name 	= 'image'									
					  OR t.name 	= 'timestamp'							then 'B'

					when charindex	('int', t.name) > 0						
					  OR t.name in 	('decimal','dec','numeric')				
					  OR t.name in 	('float','real','double',
									'double precision') 					
					  OR charindex	('money', t.name) > 0
					  OR t.name 	= 'bit'									then 'N'

					when charindex	('date', t.name) > 0					then 'D'
				end as cf_type,

				<!--- Tipo cf_sql_type para usarse en cfqueryparam --->
				case
					when t.name in 	('char','nchar')							
					  OR t.name in 	('varchar','nvarchar','sysname')		then 'cf_sql_varchar'
					  
					when t.name 	= 'text'								then 'cf_sql_longvarchar'

					when t.name 	= 'binary'									
					  OR t.name 	= 'varbinary'								
					  OR t.name 	= 'image'
					  OR t.name 	= 'timestamp'							then 'cf_sql_blob'

					when charindex	('int',t.name) > 0						then 'cf_sql_integer'
					
					when t.name in 	('decimal','dec','numeric')				then 'cf_sql_numeric'

					when t.name in 	('float','real','double',
									'double precision') 					then 'cf_sql_float'

					when charindex	('money',t.name) > 0					then 'cf_sql_money'

					when charindex	('date', t.name) > 0					then 'cf_sql_timestamp'
					
					when t.name 	= 'bit'									then 'cf_sql_bit'
				end as cf_sql_type,

				<!--- Longitud --->
				case 
					when t.name in 	('decimal','dec','numeric')				then coalesce(c.prec,c.length)
					when t.name in 	('float','real','double',
									'double precision') 					then coalesce(c.prec,case c.length when 8 then 15 else 7 end)

					when charindex	('tinyint', t.name) > 0					then 3

					when charindex	('int', t.name) > 0
					  or charindex	('money', t.name) > 0					then case c.length when 8 then 18 when 4 then 10 else 5 end
					  
					when t.name in 	('text','image')						then 2e6
					
					else coalesce	(c.prec,c.length)
				end as len, 

				<!--- Maximo Decimales en numéricos --->
				case 
					when t.name in 	('decimal','dec','numeric')				then c.scale 
					when t.name in 	('float','real','double',
									'double precision') 					then coalesce(c.prec,case c.length when 8 then 15 else 7 end)
					when charindex	('money', t.name) > 0					then 4
					else 0
				end as dec, 

				<!--- Maximo Enteros en numéricos --->
				case
					when t.name in 	('decimal','dec','numeric')				then c.prec - c.scale 
					when t.name in 	('float','real','double',
									'double precision') 					then coalesce(c.prec,case c.length when 8 then 15 else 7 end)
					when charindex	('tinyint', t.name) > 0					then 3
					when charindex	('int', t.name) > 0						then case c.length when 8 then 18 when 4 then 10 else 5 end
					when charindex	('money', t.name) > 0					then case c.length when 8 then 18 when 4 then 10 else 5 end - 4
					when t.name in 	('bit')									then 1
					else 0
				end as ent, 

				<!--- Obligatorio NOT NULL --->
				CASE convert(bit, (c.status & 8)) WHEN 1 THEN 0 ELSE 1 END as mandatory,

				<!--- Identity --->
				convert(bit, (c.status & 0x80)) as "identity"
		  from syscolumns c 
			inner join systypes t
				on t.usertype = c.usertype
		 where id=object_id(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.name#">)
		<cfif Attributes.sinDatosSoin>
		   and ((upper(c.name) <> 'BMUSUCODIGO' OR convert(bit, (c.status & 8)) = 0) AND upper(c.name) <> 'TS_RVERSION')
		</cfif>
 		 order by colid
	</cfquery>
<cfelseif dbtype is 'oracle'>
	<cfquery name="rsSQL" datasource="#Attributes.datasource#">
		SELECT	TRIGGER_BODY
		  FROM	USER_TRIGGERS t
		 WHERE 	TABLE_OWNER	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Application.dsinfo[attributes.Datasource].Schema)#">
		   AND 	TABLE_NAME	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Attributes.name)#">
		   AND	TRIGGER_NAME    like 'TIB_%'
	</cfquery>
	<!--- SELECT SOINPK.LASTIDENTITY INTO :NEW.CAMPO_IDENTITY FROM DUAL; --->
	<cfset LvarTrigger = trim(rsSQL.TRIGGER_BODY)>
	<cfset LvarSelect = "SELECT SOINPK.LASTIDENTITY INTO :NEW.">
	<cfset LvarPto = findNoCase(LvarSelect,LvarTrigger)>
	<cfif LvarPto GT 0>
		<cfset LvarTrigger = mid(LvarTrigger,LvarPto + len(LvarSelect), 50)>
		<cfset LvarIdentity = mid(LvarTrigger,1, findNoCase(" FROM DUAL;",LvarTrigger)-1)>
	<cfelse>
		<cfset LvarIdentity = "">
	</cfif>

	<cfquery name="rsSQL" datasource="#Attributes.datasource#">
		SELECT 	
				COLUMN_NAME AS name,

				<!--- Tipo Base de datos: el INTEGER se dejó de usar con el DBM --->
				CASE 
					when DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 
									AND DATA_PRECISION IS NULL					then 'INTEGER'
					ELSE SUBSTR(DATA_TYPE,1,9)
				END AS db_type,

				<!--- Tipo Standard DataBaseModel --->
				case
					when DATA_TYPE in ('CHAR','NCHAR')							then 'C'
					when DATA_TYPE in ('VARCHAR2','NVARCHAR2')					then 'V'
					when DATA_TYPE in ('CLOB','NCLOB','LONG VARCHAR','LONG')	then 'CL'

					when DATA_TYPE = 'RAW'										then 'VB'
					when DATA_TYPE in ('BLOB','LONG RAW')						then 'BL'

					when DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 
									AND DATA_PRECISION IS NULL					then 'I'
					when DATA_TYPE = 'NUMBER'									then 'N'
					when DATA_TYPE = 'FLOAT'				 					then 'F'

					when DATA_TYPE = 'DATE'				 						then 'D'
					when SUBSTR(DATA_TYPE,1,9) = 'TIMESTAMP'					then 'TS'
				end as dbm_type,

				<!--- Tipo Coldfusion --->
				case
					when DATA_TYPE in ('CHAR','NCHAR')							
					  OR DATA_TYPE in ('VARCHAR2','NVARCHAR2')					
					  OR DATA_TYPE in ('CLOB','NCLOB','LONG VARCHAR','LONG')	then 'S'
					  
					when DATA_TYPE = 'RAW'										
					  OR DATA_TYPE in ('BLOB','LONG RAW')						then 'B'
					  
					when DATA_TYPE = 'NUMBER'									
					  OR DATA_TYPE = 'FLOAT'				 					then 'N'

					when DATA_TYPE = 'DATE'				 					
					  OR SUBSTR(DATA_TYPE,1,9) = 'TIMESTAMP'					then 'D'
				end as cf_type,

				<!--- Tipo cf_sql_type para usarse en cfqueryparam --->
				case
					when DATA_TYPE in ('CHAR','NCHAR')							
					  OR DATA_TYPE in ('VARCHAR2','NVARCHAR2')					then 'cf_sql_varchar'
					  
					when DATA_TYPE in ('CLOB','NCLOB','LONG VARCHAR','LONG')	then 'cf_sql_longvarchar'
					
					when DATA_TYPE = 'RAW'										
					  OR DATA_TYPE in ('BLOB','LONG RAW')						then 'cf_sql_blob'
					
					when DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 
									AND DATA_PRECISION IS NULL					then 'cf_sql_integer'

					when DATA_TYPE = 'NUMBER'									then 'cf_sql_numeric'

					when DATA_TYPE = 'FLOAT'									then 'cf_sql_float'

					when DATA_TYPE = 'DATE'				 					
					  OR SUBSTR(DATA_TYPE,1,9) = 'TIMESTAMP'					then 'cf_sql_timestamp'
				end as cf_sql_type,

				<!--- Longitud --->
				CASE 
					when DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 
									AND DATA_PRECISION IS NULL 					THEN 10
					when DATA_TYPE = 'FLOAT'									then ceil(DATA_PRECISION * log(10, 2))
					else COALESCE (DATA_PRECISION,DATA_LENGTH) 
				END AS len,

				<!--- Maximo Decimales en numéricos --->
				case 
					when DATA_TYPE = 'NUMBER' 									then DATA_SCALE
					when DATA_TYPE = 'FLOAT'									then ceil(DATA_PRECISION * log(10, 2))
					else 0
				end as dec, 

				<!--- Maximo Enteros en numéricos --->
				CASE 
					when DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 
									AND DATA_PRECISION IS NULL 					THEN 10
					when DATA_TYPE = 'NUMBER' 									then COALESCE (DATA_PRECISION,DATA_LENGTH) - DATA_SCALE
					when DATA_TYPE = 'FLOAT'									then ceil(DATA_PRECISION * log(10, 2))
					else 0
				END AS ent,

				<!--- Obligatorio NOT NULL --->
				CASE NULLABLE WHEN 'Y' THEN 0 ELSE 1 END as mandatory,

				<!--- Identity --->
			<cfif LvarIdentity EQ "">
				0 as identity
			<cfelse>
				case when COLUMN_NAME = '#LvarIdentity#' then 1 else 0 end as identity
			</cfif>
		  FROM ALL_TAB_COLUMNS c
		 WHERE OWNER		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Application.dsinfo[attributes.Datasource].Schema)#">
		   AND TABLE_NAME	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Attributes.name)#">
		<cfif Attributes.sinDatosSoin>
		   and ((upper(COLUMN_NAME) <> 'BMUSUCODIGO' OR NULLABLE <> 'Y') AND upper(COLUMN_NAME) <> 'TS_RVERSION')
		</cfif>
		 ORDER BY COLUMN_ID
	</cfquery>
<cfelseif dbtype is 'db2'>
	<cfquery name="rsSQL" datasource="#Attributes.datasource#">
		SELECT 	
				COLNAME AS name,

				<!--- Tipo Base de datos: el INTEGER se dejó de usar con el DBM --->
				TYPENAME as db_type,

				<!--- Tipo Standard DataBaseModel --->
				case
					when TYPENAME in ('CHAR','CHARACTER')						then 'C'
					when TYPENAME = 'VARCHAR'									then 'V'
					when TYPENAME in ('CLOB','LONG VARCHAR')					then 'CL'

					when TYPENAME = 'BLOB' AND LENGTH < 255						then 'VB'
					when TYPENAME = 'BLOB'										then 'BL'

					when TYPENAME in ('BIGINT','INTEGER','SMALLINT')			then 'I'
					when TYPENAME in ('DEC','DECIMAL','NUM','NUMERIC')			then 'N'
					when TYPENAME in ('DOUBLE','FLOAT','REAL')		 			then 'F'

					when TYPENAME = 'TIMESTAMP' AND ROWCHANGETIMESTAMP = 'Y' 	then 'TS'
					when TYPENAME = 'TIMESTAMP'				 					then 'D'
					when TYPENAME = 'DATE'				 						then 'D1'
					when TYPENAME = 'TIME'				 						then 'D2'
				end as dbm_type,

				<!--- Tipo Coldfusion --->
				case
					when TYPENAME in ('CHAR','CHARACTER')						
					  OR TYPENAME = 'VARCHAR'									
					  OR TYPENAME in ('CLOB','LONG VARCHAR')					then 'S'
					  
					when TYPENAME = 'BLOB'										then 'B'
					  
					when TYPENAME in ('BIGINT','INTEGER','SMALLINT')			
					  OR TYPENAME in ('DEC','DECIMAL','NUM','NUMERIC')			
					  OR TYPENAME in ('DOUBLE','FLOAT','REAL')		 			then 'N'

					when TYPENAME = 'TIMESTAMP'				 					
					  OR TYPENAME = 'DATE'				 						
					  OR TYPENAME = 'TIME'				 						then 'D'
				end as cf_type,

				<!--- Tipo cf_sql_type para usarse en cfqueryparam --->
				case
					when TYPENAME in ('CHAR','CHARACTER')						
					  OR TYPENAME = 'VARCHAR'									then 'cf_sql_varchar'
					  
					when TYPENAME in ('CLOB','LONG VARCHAR')					then 'cf_sql_longvarchar'
					
					when TYPENAME = 'BLOB'										then 'cf_sql_blob'
					
					when TYPENAME in ('BIGINT','INTEGER','SMALLINT')			then 'cf_sql_integer'
					when TYPENAME in ('DEC','DECIMAL','NUM','NUMERIC')			then 'cf_sql_numeric'
					when TYPENAME in ('DOUBLE','FLOAT','REAL')		 			then 'cf_sql_float'

					when TYPENAME = 'TIMESTAMP'				 					then 'cf_sql_timestamp'
					when TYPENAME = 'DATE'				 						then 'cf_sql_date'
					when TYPENAME = 'TIME'				 						then 'cf_sql_time'
				end as cf_sql_type,

				<!--- Longitud --->
				LENGTH as len,

				<!--- Maximo Decimales en numéricos --->
				case 
					when TYPENAME in ('DEC','DECIMAL','NUM','NUMERIC')			then SCALE
					when TYPENAME in ('DOUBLE','FLOAT')			 				then 15
					when TYPENAME in ('REAL')			 						then 7
					else 0
				end as dec, 

				<!--- Maximo Enteros en numéricos --->
				CASE 
					when TYPENAME in ('BIGINT','INTEGER','SMALLINT')			then LENGTH
					when TYPENAME in ('DEC','DECIMAL','NUM','NUMERIC')			then (LENGTH - SCALE)
					when TYPENAME in ('DOUBLE','FLOAT')			 				then 15
					when TYPENAME in ('REAL')			 						then 7
					else 0
				END AS ent,

				<!--- Obligatorio NOT NULL --->
				case
					when NULLS = 'Y' then '0' else '1'
				end	as mandatory,

				<!--- Identity --->
				case
					when IDENTITY = 'Y' then '1' else '0'
				end	as identity
		  FROM	SYSCAT.COLUMNS C
		 WHERE	TABSCHEMA	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Application.dsinfo[attributes.Datasource].Schema)#">
		   AND 	TABNAME		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Attributes.name)#">
		<cfif Attributes.sinDatosSoin>
		   and ((upper(COLNAME) <> 'BMUSUCODIGO' OR NULLS <> 'Y') AND upper(COLNAME) <> 'TS_RVERSION')
		</cfif>
		 ORDER BY COLNO
	</cfquery>
<cfelse>
	<cf_errorCode	code = "50647"
					msg  = "cf_dbstruct no soportado para DBMS @errorDat_1@"
					errorDat_1="#dbtype#"
	>
</cfif>
<cfset Caller[Attributes.returnvariable] = rsSQL>


