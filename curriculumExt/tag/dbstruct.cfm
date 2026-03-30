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

<cfset dbtype = Application.dsinfo[Attributes.datasource].type>
<cfif dbtype is 'sybase'>
	<cfquery name="rsSQL" datasource="#Attributes.datasource#">
		select 	c.name, 
				t.name as db_type,
				case
					when t.name in ('bit','decimal','numeric','float','real')
					  or charindex('int', t.name) > 0
					  or charindex('money', t.name) > 0
						 then 'N'

					when t.name = 'text'
					  or t.name = 'sysname'
					  or charindex('char', t.name) > 0
						 then 'S'

					when charindex('date', t.name) > 0
						 then 'D'

					when t.name = 'image'
					  or t.name = 'timestamp'
					  or charindex('binary', t.name) > 0
						 then 'B'
				end as cf_type,
				case
					when t.name = 'bit'
						 then 'cf_sql_bit'
					when charindex('int',t.name) > 0
						 then 'cf_sql_integer'
					when t.name in ('decimal','numeric')
						 then 'cf_sql_numeric'
					when t.name in ('float','real')
						 then 'cf_sql_float'
					when charindex('money',t.name) > 0
						 then 'cf_sql_money'

					when t.name = 'text'
						 then 'cf_sql_longvarchar'
					when t.name = 'sysname'
					  or charindex('char', t.name) > 0
						 then 'cf_sql_varchar'

					when charindex('date', t.name) > 0
						 then 'cf_sql_timestamp'

					when t.name = 'image'
					  or t.name = 'timestamp'
					  or charindex('binary', t.name) > 0
						 then 'cf_sql_blob'
				end as cf_sql_type,
				case 
					when t.name in ('float','real')			then coalesce(c.prec,case c.length when 8 then 16 else 5 end)
					when charindex('tinyint', t.name) > 0	then 3
					when charindex('int', t.name) > 0
					  or charindex('money', t.name) > 0		then case c.length when 8 then 18 when 4 then 9 else 4 end
					when t.name in ('text','image')			then 2000000000
					else coalesce(c.prec,c.length)
				end as len, 
				case
					when t.name in ('decimal','numeric') 	then c.prec - c.scale 
					when t.name in ('float','real')			then 0
					when charindex('int', t.name) > 0		then case c.length when 8 then 18 when 4 then 9 else 4 end
					when charindex('money', t.name) > 0		then case c.length when 8 then 18 when 4 then 9 else 4 end - 4
					when t.name in ('bit')					then 1
					else null
				end as ent, 
				case 
					when t.name in ('decimal','numeric') 	then c.scale 
					when t.name in ('float','real')			then coalesce(c.prec,case c.length when 8 then 16 else 5 end)
					when charindex('money', t.name) > 0		then 4
					when t.name = 'bit'
					  or charindex('int', t.name) > 0		then 0
					else null 
				end as dec, 
				CASE convert(bit, (c.status & 8)) WHEN 1 THEN 0 ELSE 1 END as mandatory,
				convert(bit, (c.status & 0x80)) as locked
		  from syscolumns c 
			inner join systypes t
				on t.usertype = c.usertype
		 where id=object_id(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.name#">)
		<cfif Attributes.sinDatosSoin>
		   and upper(c.name) not in ('BMUSUCODIGO','TS_RVERSION')
		</cfif>
 		 order by colid
	</cfquery>
<cfelseif dbtype is 'oracle'>
	<cfquery name="rsSQL" datasource="#Attributes.datasource#">
		SELECT 	
				COLUMN_NAME AS name,
				CASE 
					WHEN DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 AND DATA_PRECISION IS NULL THEN 'INTEGER'
					ELSE SUBSTR(DATA_TYPE,1,9)
				END AS db_type,
				case
					when DATA_TYPE in ('NUMBER','FLOAT')
						 then 'N'

					when DATA_TYPE = 'CLOB'
					  or instr(DATA_TYPE,'CHAR') > 0
						 then 'S'

					when DATA_TYPE = 'DATE'
						 then 'D'

					when DATA_TYPE in ('BLOB', 'RAW')
						 then 'B'

					when SUBSTR(DATA_TYPE,1,9) = 'TIMESTAMP'
						 then 'D'
				end as cf_type,

				case
					when DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 AND DATA_PRECISION IS NULL
						 then 'cf_sql_integer'
					when DATA_TYPE = 'NUMBER'
						 then 'cf_sql_numeric'
					when DATA_TYPE = 'FLOAT'
						 then 'cf_sql_float'

					when DATA_TYPE = 'CLOB'
						 then 'cf_sql_longvarchar'
					when instr(DATA_TYPE, 'CHAR') > 0
						 then 'cf_sql_varchar'

					when instr(DATA_TYPE, 'DATE') > 0
						 then 'cf_sql_timestamp'

					when DATA_TYPE in ('BLOB', 'RAW')
						 then 'cf_sql_blob'

					when SUBSTR(DATA_TYPE,1,9) = 'TIMESTAMP'
						 then 'cf_sql_timestamp'
				end as cf_sql_type,
				CASE 
				  WHEN DATA_TYPE = 'NUMBER' AND DATA_SCALE = 0 AND DATA_PRECISION IS NULL THEN 10
				  WHEN DATA_TYPE = 'FLOAT' THEN ceil(DATA_PRECISION * log(10, 2))
				  ELSE COALESCE (DATA_PRECISION,DATA_LENGTH) 
				END AS len,
				case 
					when DATA_TYPE = 'NUMBER' 				then DATA_SCALE
					when DATA_TYPE = 'FLOAT'				then ceil(DATA_PRECISION * log(10, 2))
					else null 
				end as dec, 
				CASE NULLABLE WHEN 'Y' THEN 0 ELSE 1 END as mandatory,
				0 as locked
		  FROM USER_TAB_COLUMNS
		 WHERE TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(Attributes.name)#">
		 ORDER BY COLUMN_ID
	</cfquery>
<cfelse>
	<cfthrow message="cf_dbstruct no soportado para DBMS #dbtype#">
</cfif>
<cfset Caller[Attributes.returnvariable] = rsSQL>
