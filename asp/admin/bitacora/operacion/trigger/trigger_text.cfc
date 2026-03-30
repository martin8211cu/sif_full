<cfcomponent>
<!---►►►►►Funcion Para Concatenar Varias Columnas, las de Texto muy grandes no forma parte de la Bitacora:sybase-sqlServer(text,image,binary,varbinary )oracle: blob,clob,raw◄◄◄◄◄--->
<cffunction name="cat_colnames" output="no" hint="Concatena varias columnas sql con el operador ||" access="private">
	<cfargument name="columns" type="query"/>
	<cfset var ret = ''>
	<cfloop query="Arguments.columns">
		<cfif Not ListFind('text,image,binary,varbinary,blob,clob,raw', Arguments.columns.type_name)>
			<cfset ret = ListAppend (ret, Arguments.columns.column_name) >
		</cfif>
	</cfloop>
	<cfreturn ret>
</cffunction>

<cffunction name="cat_campos" output="no" hint="Concatena varias columnas sql con el operador ||" access="private">
	<cfargument name="columns" 			type="query"/>
	<cfargument name="campos" 			type="string" />
	<cfargument name="tblprefix" 		type="string" default="i" />
	<cfargument name="list_separator" 	type="string" default="," />
	<cfargument name="datasource" 		type="string" />

	<cfset var ret_value = ''>


    <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
	<cfset dbtype = Application.dsinfo[arguments.datasource].type>
	<cfset Coalesceini   = "Coalesce(">
    <cfset Coalescefin   = ",'')">
	<cfif dbtype is 'sybase'>
		<cfset convert_ini = 'convert(varchar, '>
		<cfset convert_fin = ')'>
		<cfset convert60_ini = 'convert(varchar(60), '>
		<cfset convert60_fin = ')'>
		<cfset replace_ini = 'str_replace('>
		<cfset replace_fin = ')'>
     <cfelseif dbtype is 'sqlserver'>
		<cfset convert_ini 	 = "convert(varchar, ">
		<cfset convert_fin 	 = ")">
		<cfset convert60_ini = "convert(varchar(60), ">
		<cfset convert60_fin = ")">
		<cfset replace_ini   = "replace(">
		<cfset replace_fin   = ")">
	<cfelseif dbtype is 'oracle'>
		<cfset convert_ini = 'to_char('>
		<cfset convert_fin = ')'>
		<cfset convert60_ini = 'left(to_char('>
		<cfset convert60_fin = '),60)'>
		<cfset replace_ini = 'replace('>
		<cfset replace_fin = ')'>
	<cfelseif dbtype is 'db2'>
		<cfset convert_ini = 'RTRIM(CAST('>
		<cfset convert_fin = ' AS CHAR(254)))'>
		<cfset convert60_ini = 'RTRIM(CAST('>
		<cfset convert60_fin = ' AS CHAR(60)))'>
		<cfset replace_ini = 'replace('>
		<cfset replace_fin = ')'>
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbtype#">
	</cfif>
	<cfloop query="Arguments.columns">
			<!---Los campos image se excluyen del monitoreo sybase/sqlserver: text,image,binary,varbinary oracle: blob,clob,raw--->
		<cfif ListFind(Arguments.campos, Arguments.columns.column_name) and not ListFind('text,image,binary,varbinary,blob,clob,raw', Arguments.columns.type_name)>
			<cfif Len(ret_value)>
				<cfset ret_value = ret_value & " #_Cat# '" & list_separator & "' #_Cat#" & Chr(13) & Chr(10) & Chr(9) & Chr(9) & Chr(9)>
			</cfif>
			<!--- FALSE: para que no haga el str_replace, que da errores --->
			<cfif false and Arguments.list_separator is ','>
				<cfset str_replace_init = replace_ini & replace_ini >
				<cfset str_replace_done = ", '%', '%25' " & replace_fin & ", ',', '%2C' " & replace_fin>
			<cfelse>
				<cfset str_replace_init = "">
				<cfset str_replace_done = "">
			</cfif>
			<!--- Utiliza un encoding similar al URLencode, pero solamente para la coma y el porcentaje --->
			<!--- Los campos alfanuméricos sybase/sqlServer: varchar,char,nvarchar oracle: char,varchar2--->
			<cfif ListFind('varchar,char,nvarchar,varchar2', Arguments.columns.type_name)>
				<cfif Arguments.columns.isnullable>
					<cfset ret_value = ret_value & str_replace_init & Coalesceini & arguments.tblprefix & "." & Arguments.columns.column_name &Coalescefin& str_replace_done>
                 <cfelse>
                 	<cfset ret_value = ret_value & str_replace_init & arguments.tblprefix & "." & Arguments.columns.column_name & str_replace_done>
                 </cfif>
			<!---Los campos texto largo sybase/sqlServer: text oracle: clob--->
			<cfelseif ListFind('text,clob', Arguments.columns.type_name)>
				<cfset ret_value = ret_value & str_replace_init & convert60_ini & arguments.tblprefix & "." & Arguments.columns.column_name & convert60_fin & str_replace_init>
			<!---Integer, bit, numeric y demas tipos--->
            <cfelse>
            	<cfif Arguments.columns.isnullable>
					<cfset ret_value = ret_value & Coalesceini & convert_ini & arguments.tblprefix & "." & Arguments.columns.column_name & convert_fin & Coalescefin>
                 <cfelse>
                 	<cfset ret_value = ret_value & convert_ini & arguments.tblprefix & "." & Arguments.columns.column_name & convert_fin>
                 </cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfif Not Len(ret_value)>
		<cfthrow message="Definicion invalida de campos para tabla. Datasource: #Arguments.datasource#, table_name: #Arguments.columns.table_name#, table_columns: #ValueList(Arguments.columns.column_name)#, campos por concatenar: #Arguments.campos#">
	</cfif>
	<cfreturn ret_value>
</cffunction>

<cffunction name="create_trigger" returntype="string" output="no" access="private">
	<cfargument name="table_name" type="string">
	<cfargument name="trigger_name" type="string">
	<cfargument name="trigger_type" type="string">
	<cfargument name="trigger_text" type="string">
	<cfargument name="datasource" type="string">

	<cfset dbtype = Application.dsinfo[arguments.datasource].type>

	<cfif listfind('sybase,sqlserver',dbtype)>

		<!--- solamente se valida si el trigger existe cuando sea SYBASE, SQLSERVER O DB2 --->
		<!--- <cfquery datasource="#arguments.datasource#" name="trigger_actual">
			select
				object_name (#Arguments.trigger_type#trig) as trigger_actual
			from sysobjects
			where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.table_name#">
		</cfquery>
		<cfquery datasource="#arguments.datasource#" name="buscar_trigger">
			select type
			from sysobjects
			where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.trigger_name#">
		</cfquery> --->

		<cfquery name="rsval" datasource="#arguments.datasource#">
			SELECT * FROM sys.triggers WHERE name = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.trigger_name#">
		</cfquery>
		<cfif rsval.RecordCount gt 0>
			<cftry>
				<cfquery datasource="#arguments.datasource#">
					drop trigger #Arguments.trigger_name#
				</cfquery>
				<cfcatch>
					<cfthrow message="#cfcatch.Message#">
				</cfcatch>
			</cftry>
		</cfif>

		<!--- <cfif Len(trigger_actual.trigger_actual) and trigger_actual.trigger_actual neq Arguments.trigger_name>
			<cfthrow message="La tabla #Arguments.table_name# ya tiene un trigger para #Arguments.trigger_type#: #trigger_actual.trigger_actual#">
		<cfelseif Len(trigger_actual.trigger_actual) and trigger_actual.trigger_actual EQ Arguments.trigger_name>
			<cfthrow message="La tabla #Arguments.table_name# ya tiene un trigger con el mismo nombre para #Arguments.trigger_type#: #Arguments.trigger_name#">
		<cfelseif Len(buscar_trigger.type) and buscar_trigger.type neq 'TR'>
			<cfthrow message="El objeto #Arguments.trigger_name# ya existe, y es de tipo #buscar_trigger.type# (no es un trigger)">
		</cfif> --->
	<cfelseif dbtype is 'db2'>
		<cfquery datasource="#arguments.datasource#" name="buscar_trigger">
			select TRIGNAME, TABNAME, case TRIGEVENT when 'I' then 'Inserción' when 'U' then 'Actualización' when 'D' then 'Supresión' end as TRIGEVENT
			from SYSCAT.TRIGGERS
			where upper(TRIGNAME) = '#Ucase(Arguments.trigger_name)#'
		</cfquery>
		<cfif buscar_trigger.recordcount GT 0>
			<cfthrow message="Ya existe un trigger con el nombre #buscar_trigger.TRIGNAME# para la tabla #buscar_trigger.TABNAME# y es de tipo #buscar_trigger.TRIGEVENT#">
		</cfif>
	</cfif>
	<cfquery datasource="#Arguments.datasource#">
		#PreserveSingleQuotes(Arguments.trigger_text)#
	</cfquery>

</cffunction>

<cffunction name="get_trigger_text" returntype="struct" output="no" access="public">
    <cfargument name="table_name" type="string">
    <cfargument name="datasource" type="string">
    <cfargument name="exclusions" type="string">

	<cfset var ret 				   = StructNew()>
    <cfset var columna_BMUsucodigo = "">
    <cfset var columna_Ecodigo     = "">
    <cfset dbtype 				   = Application.dsinfo[arguments.datasource].type>

<cfquery datasource="#Arguments.datasource#" name="columns">
	<!---►►Columnas Sybase◄◄--->
	<cfif listfind('sybase',dbtype)>
		select o.name as table_name, c.name as column_name, t.name as type_name, t.allownulls as isnullable
		from syscolumns c
			join sysobjects o
				on o.id = c.id
			join systypes t
				on t.usertype = c.usertype
		where o.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.table_name#">
		  and c.name != 'ts_rversion'
		order by c.colid
     <!---►►Columnas SQl Server◄◄--->
     <cfelseif listfind('sqlserver',dbtype)>
		select o.name as table_name, c.name as column_name, t.name as type_name, c.isnullable
		from syscolumns c
			join sysobjects o
				on o.id = c.id
			join systypes t
				on t.usertype = c.usertype
		where o.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.table_name#">
		  and c.name != 'ts_rversion'
		order by c.colid
	<!---►►Columnas Oracle◄◄--->
	<cfelseif dbtype is 'oracle'>
		select table_name, column_name, data_type as type_name, case NULLABLE when 'N' then 0 else 1 end as isnullable
		from user_tab_columns
		where table_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.table_name#">
		  and column_name != 'TS_RVERSION'
		order by column_id
	<!---►►Columnas DB2◄◄--->
	<cfelseif dbtype is 'db2'>
		select TABNAME as table_name, COLNAME as column_name, TYPENAME as type_name,CASE NULLS when 'N' then 0 else 1 end as isnullable
		from SYSCAT.COLUMNS
		where lower(TABNAME) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LCase(Arguments.table_name)#">
		  and COLNAME != 'TS_RVERSION'
		order by COLNO
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbtype#">
	</cfif>
</cfquery>
<cfquery datasource="asp" name="defn">
	select PBllaves, PBalterna, PBlista
	from PBitacora
	where PBtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.table_name#">
</cfquery>

<cfloop query="columns">
	<cfif UCase( columns.column_name ) is UCase("BMUsucodigo")>
		<cfset columna_BMUsucodigo = columns.column_name>
	</cfif>
	<cfif UCase( columns.column_name ) is UCase("Ecodigo")>
		<cfset columna_Ecodigo = columns.column_name>
	</cfif>
</cfloop>
<!---►►►Tablas y Aleas de Sybase y Sql-Server◄◄◄--->
<cfif listfind('sybase,sqlserver',dbtype)>
	<cfset prefix_inserted = 'i' >
	<cfset prefix_deleted  = 'd' >
    <cfset prefix_user     = 'u' >
	<cfset from_insert 	   = ' from inserted #prefix_inserted#' >
	<cfset from_update 	   = ' from inserted #prefix_inserted# join deleted #prefix_deleted# on ' >
	<cfset from_delete 	   = ' from deleted #prefix_deleted# ' >

	<cfset first=true>
	<cfloop list="#defn.PBllaves#" index="pk">
		<cfif not first> <cfset from_update = from_update & ' and '></cfif>
		<cfset first=false>
		<cfset from_update = from_update & ' #prefix_inserted#.' & pk & ' = #prefix_deleted#.' & pk>
	</cfloop>
    <cfif Len(columna_BMUsucodigo)>
    	<cfset from_insert = "#from_insert# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_inserted#.#columna_BMUsucodigo#">
        <cfset from_update = "#from_update# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_inserted#.#columna_BMUsucodigo#">
        <cfset from_delete = "#from_delete# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_deleted#.#columna_BMUsucodigo#">
	</cfif>
<!---►►►Tablas y Aleas de Oracle◄◄◄--->
<cfelseif dbtype is 'oracle'>
	<cfset prefix_inserted = ':new' >
	<cfset prefix_deleted  = ':old' >
    <cfset prefix_user     = 'u' >
	<cfset from_insert = ' from dual ' >
	<cfset from_update = ' from dual ' >
	<cfset from_delete = ' from dual ' >
    <cfif Len(columna_BMUsucodigo)>
    	<cfset from_insert = "#from_insert# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_inserted#.#columna_BMUsucodigo#">
        <cfset from_update = "#from_update# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_inserted#.#columna_BMUsucodigo#">
        <cfset from_delete = "#from_delete# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_deleted#.#columna_BMUsucodigo#">
	</cfif>
<!---►►►Tablas y Aleas de DB2◄◄◄--->
<cfelseif dbtype is 'db2'>
	<cfset prefix_inserted = 'new' >
	<cfset prefix_deleted  = 'old' >
    <cfset prefix_user     = 'u' >
	<cfset from_insert = ' from dual ' >
	<cfset from_update = ' from dual ' >
	<cfset from_delete = ' from dual ' >
    <cfif Len(columna_BMUsucodigo)>
    	<cfset from_insert = "#from_insert# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_inserted#.#columna_BMUsucodigo#">
        <cfset from_update = "#from_update# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_inserted#.#columna_BMUsucodigo#">
        <cfset from_delete = "#from_delete# left join Usuario #prefix_user# on #prefix_user#.Usucodigo = #prefix_deleted#.#columna_BMUsucodigo#">
	</cfif>
<cfelse>
	<cfthrow message="DBMS no soportado: #dbtype#">
</cfif>


<cfoutput>
<cf_dbfunction name="now" returnvariable="LvarNow">
<cfset LvarNow = trim(LvarNow)>
<cfsavecontent variable="trigger_insert">
#trigger_declaration(Arguments.table_name, 'bitins_' & Arguments.table_name, 'insert', dbtype)#

	DECLARE @cnt int
	SET @cnt = (select isnull(max(bitacoraid),0) from MonBitacora)

	/*
	Llaves: (#defn.PBllaves#)
	Llave alterna: (#defn.PBalterna#)
	Campos descriptivos: (#defn.PBlista#)
	Datasource: #Arguments.datasource#
	*/
	insert into MonBitacora (
		bitacoraid,oper, tabla,
		<cfif Len(defn.PBllaves)
		>pk, </cfif><cfif Len(defn.PBalterna)
		>ak, </cfif><cfif Len(defn.PBlista)
		>descripcion, </cfif>
		anterior, nuevo, columnas, Usulogin, Usucodigo, fecha)
	select @cnt +(row_number() OVER (ORDER BY #defn.PBllaves# ASC)) As rowid,'I', '#Arguments.table_name#',
		<cfif Len(defn.PBllaves)
		>#cat_campos(columns, defn.PBllaves,  prefix_inserted, ',', Arguments.datasource)#,
		</cfif><cfif Len(defn.PBalterna)
		>#cat_campos(columns, defn.PBalterna, prefix_inserted, ',', Arguments.datasource)#,
		</cfif><cfif Len(defn.PBlista)
		>#cat_campos(columns, defn.PBlista,   prefix_inserted, ' ', Arguments.datasource)#,
		</cfif
		>'',
		#cat_campos(columns, cat_colnames(columns), prefix_inserted, ',', Arguments.datasource)#,
		'#cat_colnames(columns)#',
		<cfif Len(columna_BMUsucodigo)>
			#prefix_user#.Usulogin, #prefix_inserted#.#columna_BMUsucodigo#
        <cfelse>
        	' ',-1
        </cfif>,
		#preserveSingleQuotes(LvarNow)#
	#from_insert#
	<cfif Len(columna_Ecodigo) and Len(Trim(Arguments.exclusions))>
	where #prefix_inserted#.#columna_Ecodigo# not in (#Arguments.exclusions#)
	</cfif>
</cfsavecontent>

<cfset udpPBllaves = ArrayNew(1)>
<cfloop index = "PBllave" list = "#defn.PBllaves#">
  <cfset  ArrayAppend(udpPBllaves, "#prefix_inserted#.#PBllave#")>
</cfloop>

<cfsavecontent variable="trigger_update">
#trigger_declaration(Arguments.table_name, 'bitupd_' & Arguments.table_name, 'update', dbtype)#

	DECLARE @cnt int
	SET @cnt = (select isnull(max(bitacoraid),0) from MonBitacora)

	/*
	Llaves: (#defn.PBllaves#)
	Llave alterna: (#defn.PBalterna#)
	Campos descriptivos: (#defn.PBlista#)
	*/
	insert into MonBitacora (
		bitacoraid,oper, tabla,
		<cfif Len(defn.PBllaves)
		>pk, </cfif><cfif Len(defn.PBalterna)
		>ak, </cfif><cfif Len(defn.PBlista)
		>descripcion, </cfif>
		anterior, nuevo, columnas, Usulogin, Usucodigo, fecha)
	select @cnt +(row_number() OVER (ORDER BY #ArrayToList(udpPBllaves,",")# ASC)) As rowid,'U', '#Arguments.table_name#',
		<cfif Len(defn.PBllaves)
		>#cat_campos(columns, defn.PBllaves,prefix_inserted, ',', Arguments.datasource)#,
		</cfif><cfif Len(defn.PBalterna)
		>#cat_campos(columns, defn.PBalterna,prefix_inserted, ',', Arguments.datasource)#,
		</cfif><cfif Len(defn.PBlista)
		>#cat_campos(columns, defn.PBlista,prefix_inserted,' ', Arguments.datasource)#,
		</cfif
		>#cat_campos(columns, ValueList(columns.column_name),prefix_deleted, ',', Arguments.datasource)#,
		#cat_campos(columns, ValueList(columns.column_name),prefix_inserted, ',', Arguments.datasource)#,
		'#cat_colnames(columns)#',
        <cfif Len(columna_BMUsucodigo)>
			#prefix_user#.Usulogin, #prefix_inserted#.#columna_BMUsucodigo#
        <cfelse>
        	' ',-1
        </cfif>,
		#preserveSingleQuotes(LvarNow)#
	#from_update#
	<cfif Len(columna_Ecodigo) and Len(Trim(Arguments.exclusions))>
	where #prefix_inserted#.#columna_Ecodigo# not in (#Arguments.exclusions#)
	</cfif>
</cfsavecontent>

<cfset delPBllaves = ArrayNew(1)>
<cfloop index = "PBllave" list = "#defn.PBllaves#">
  <cfset  ArrayAppend(delPBllaves, "#prefix_deleted#.#PBllave#")>
</cfloop>

<cfsavecontent variable="trigger_delete">
#trigger_declaration(Arguments.table_name, 'bitdel_' & Arguments.table_name, 'delete', dbtype)#

	DECLARE @cnt int
	SET @cnt = (select isnull(max(bitacoraid),0) from MonBitacora)

/*
	Llaves: (#defn.PBllaves#)
	Llave alterna: (#defn.PBalterna#)
	Campos descriptivos: (#defn.PBlista#)
	*/
	insert into MonBitacora (
		bitacoraid,oper, tabla,
		<cfif Len(defn.PBllaves)
		>pk, </cfif><cfif Len(defn.PBalterna)
		>ak, </cfif><cfif Len(defn.PBlista)
		>descripcion, </cfif>
		anterior, nuevo, columnas, Usulogin, Usucodigo, fecha)
	select @cnt +(row_number() OVER (ORDER BY #ArrayToList(delPBllaves,",")# ASC)) As rowid,'D', '#Arguments.table_name#',
		<cfif Len(defn.PBllaves)
		>#cat_campos(columns, defn.PBllaves, prefix_deleted, ',', Arguments.datasource)#,
		</cfif><cfif Len(defn.PBalterna)
		>#cat_campos(columns, defn.PBalterna, prefix_deleted, ',', Arguments.datasource)#,
		</cfif><cfif Len(defn.PBlista)
		>#cat_campos(columns, defn.PBlista, prefix_deleted,' ', Arguments.datasource)#,
		</cfif
		>#cat_campos(columns, ValueList(columns.column_name), prefix_deleted, ',', Arguments.datasource)#,
		'',
		'#cat_colnames(columns)#',
		<cfif Len(columna_BMUsucodigo)>
			#prefix_user#.Usulogin, #prefix_deleted#.#columna_BMUsucodigo#
        <cfelse>
        	' ',-1
        </cfif>,
		#preserveSingleQuotes(LvarNow)#
	#from_delete#
	<cfif Len(columna_Ecodigo) and Len(Trim(Arguments.exclusions))>
	where #prefix_deleted#.#columna_Ecodigo# not in (#Arguments.exclusions#)
	</cfif>
</cfsavecontent>
</cfoutput>


<cfset ret.insert_text = trigger_insert>
<cfset ret.insert_name = "bitins_" & Arguments.table_name>
<cfset ret.update_text = trigger_update>
<cfset ret.update_name = "bitupd_" & Arguments.table_name>
<cfset ret.delete_text = trigger_delete>
<cfset ret.delete_name = "bitdel_" & Arguments.table_name>
<cfreturn ret>

</cffunction>

<cffunction name="create_triggers" returntype="string" access="public" output="no">

<cfargument name="table_name" type="string">
<cfargument name="datasource" type="string">
<cf_dbfunction name="now" returnvariable="LvarNow">
<cfset exclusions = get_exclusions(Arguments.datasource)>

<cfset trigger_text = get_trigger_text(Arguments.table_name, Arguments.datasource, exclusions)>

<cfset create_trigger (Arguments.table_name, trigger_text.insert_name, 'ins', trigger_text.insert_text, Arguments.datasource)>
<cfset create_trigger (Arguments.table_name, trigger_text.update_name, 'upd', trigger_text.update_text, Arguments.datasource)>
<cfset create_trigger (Arguments.table_name, trigger_text.delete_name, 'del', trigger_text.delete_text, Arguments.datasource)>

	<cfquery datasource="asp" name="curinfo">
		select regenerar
		from PBitacoraTrg
		where cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.datasource)#">
		  and PBtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.table_name)#">
	</cfquery>
	<cfif curinfo.RecordCount>
		<cfquery datasource="asp">
			update PBitacoraTrg
			set regenerar = 0,
			    trg_fecha   = #LvarNow#,
				exclusiones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#exclusions#  ">,
				BMfechamod  = #LvarNow#,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">
			where cache     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.datasource)#">
			  and PBtabla   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.table_name)#">
		</cfquery>
	<cfelse>
		<cfquery datasource="asp">
			insert into PBitacoraTrg (cache, PBtabla,
				regenerar, trg_fecha, exclusiones, BMfechamod, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.datasource)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.table_name)#">,
				0,
			    #LvarNow#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#exclusions#  ">,
				#LvarNow#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Usucodigo#">)
		</cfquery>
	</cfif>

<cfreturn 'Triggers creados para #Arguments.table_name#: #trigger_text.insert_name#, #trigger_text.update_name#, #trigger_text.delete_name#'>

</cffunction>

<cffunction name="trigger_declaration" returntype="string" output="no">
	<cfargument name="table_name">
	<cfargument name="trigger_name">
	<cfargument name="for">
	<cfargument name="dbtype">

	<cfif listfind('sybase,sqlserver',dbtype)>
		<cfreturn
"create trigger #Arguments.trigger_name#
	on #Arguments.table_name# for #Arguments.for#
as
">
	<cfelseif dbtype is 'oracle'>
		<cfreturn
"create or replace trigger #Arguments.trigger_name#
	 after #Arguments.for# on #Arguments.table_name#
	 for each row
">

<cfelseif dbtype is 'db2' and for EQ 'insert'>
		<cfreturn
"CREATE TRIGGER #Arguments.trigger_name#
	 AFTER #Arguments.for# ON #Arguments.table_name#
	 REFERENCING NEW AS new
	 FOR EACH ROW
">
<cfelseif dbtype is 'db2' and for EQ 'update'>
		<cfreturn
"CREATE TRIGGER #Arguments.trigger_name#
	 AFTER #Arguments.for# ON #Arguments.table_name#
	 REFERENCING NEW AS new OLD as old
	 FOR EACH ROW
">
<cfelseif dbtype is 'db2' and for EQ 'delete'>
		<cfreturn
"CREATE TRIGGER #Arguments.trigger_name#
	 AFTER #Arguments.for# ON #Arguments.table_name#
	 REFERENCING OLD as old
	 FOR EACH ROW
">

	<cfelse>
		<cfthrow message="DBMS no soportado: #Arguments.dbtype#">
	</cfif>

</cffunction>



<cffunction name="get_exclusions" returntype="string" access="public" output="no">

<cfargument name="datasource" type="string">

<cfquery datasource="asp" name="query_exclusions">
	select distinct
		<cfif Arguments.datasource EQ "asp">
			pbe.Ecodigo
		<cfelse>
			pbe.Ereferencia as Ecodigo
		</cfif>
	from PBitacoraEmp pbe
		join Empresa e
			on e.Ecodigo = pbe.Ecodigo
		join Caches c
			on c.Cid = e.Cid
	where pbe.PBinactivo = 1
	  and c.Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.datasource#">
	<cfif Arguments.datasource NEQ "asp">
	  and e.Ecodigo <> 1
	</cfif>
	  and coalesce(pbe.Ereferencia,0) > 0
	order by 1
</cfquery>


<cfreturn ValueList(query_exclusions.Ecodigo)>

</cffunction>

</cfcomponent>
