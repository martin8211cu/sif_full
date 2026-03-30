<cfscript>
    dbutils = CreateObject("component", "sif/Componentes/DButils");
	hexdigits = ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F");

	function binary2Hex(binaryData) {
		var i = 0;
		if (not isArray(binaryData))
			return "";
		entrada = ListToArray(ArrayToList(arguments.binaryData));
		salida  = ArrayNew(1);
		for (i = 1; i LE ArrayLen (entrada); i = i + 1) {
			if (entrada[i] LT 0)
				entrada[i] = entrada[i] + 256;
			salida[i] = hexdigits[(entrada[i] \ 16) + 1] & hexdigits[(entrada[i] MOD 16) + 1];
		}
		return ArrayToList(salida,"");
	}
	function controlchars (stringvalue) {
		// el '&' ampersand se toma como carácter especial porque SQL*Plus
		// lo utiliza para sustitución de variables.
		var retval = "";
		var ch = '';
		var fn = '';
		var i = 0;
		if (dbms_type is 'ora') {
			fn = "chr(";
		} else if (dbms_type is 'db2') {
			fn = "chr(";
		} else if (ListFind('syb,mss', dbms_type )) {
			fn = "char(";
		} else {
			fn = " char_dbms_" + dbms_type + "(";
		}
		//stringvalue = replace(stringvalue, "  ", " ", "all");

		for (i=1; i LE Len(stringvalue); i = i + 1) {
			ch = Mid(stringvalue, i, 1);

			// ( Asc(ch) LT 32 OR Asc (ch) GT 127 or Asc(ch) IS 38 )  { // se quita el GT 127 por DB2 Transliteration failed
			// error Transliteration failed si se usa la funcion char para valores superiores a 127
			// ocurre en db2 si caracteres especiales (tildes) subidos por un script generado desde aqui se trata de acceder desde coldfusion
			if ( Asc(ch) LT 32 or Asc(ch) IS 38 )  {
				if (i GT 1) {
					if (dbms_type is 'mss') {
						retval = retval & "'+";
					} else {
						retval = retval & "'||";
					}
				}
				retval = retval & fn & Asc(ch) & ")";
				if (i LT Len(stringvalue)) {
					if (dbms_type is 'mss') {
						retval = retval & "+'";
					} else {
						retval = retval & "||'";
					}
				}
			} else {
				if (ch IS "'") {
					ch = "''";
				}
				if (i is 1) retval = retval & "'";
				retval = retval & ch;
				if (i is Len(stringvalue)) retval = retval & "'";
			}
		}
		if (dbms_type is 'mss') {
			return replace(retval,"+''+","+","ALL");
		} else {
			return replace(retval,"||''||","||","ALL");
		}
	}

	function TypeIsLOB( typeName ) { // para manejo especial del volumen de datos en oracle
		return (0 NEQ ListFindNoCase("image,text,BLOB,CLOB", typeName));
	}
	function TypeIsBinary( typeName ) {
		return (0 NEQ ListFindNoCase("binary,varbinary,image,BLOB", typeName));
	}
	function TypeIsDate( typeName )  {
		return (0 NEQ ListFindNoCase("date,time,datetime,smalldatetime", typeName));
	}
	function TypeIsBoolean( typeName )  {
		return (0 NEQ ListFindNoCase("bit,boolean", typeName));
	}
	function TypeIsNumeric( typeName )  {
		return (0 NEQ ListFindNoCase("bigint,int,integer,smallint,tinyint,numeric,number,decimal,double,float,money,real", typeName));
	}
	function TypeIsString( typeName )  {
		return (0 NEQ ListFindNoCase("text,char,varchar,varchar2,CLOB,longvarchar", typeName));
	}
	function getTypeNames( ret ) {
		var typeNames = ArrayNew (1);
		var md = ret.getMetaData();
		var count = md.getColumnCount();
		for (i = 1; i LE count; i = i + 1) {
			typeNames[i] = md.getColumnTypeName (JavaCast ("int", i) );
		}
		return typeNames;
	}
	function quoteXML( value, typeName ) {
		if (Len ( value ) EQ 0) {
			return "";
		} else if ( TypeIsBinary( typeName )) {
			return binary2Hex( value );
		} else if ( TypeIsNumeric( typeName )) {
			return value;
		} else if ( TypeIsDate( typeName )) {
			return DateFormat(value, "yyyymmdd") & " " & TimeFormat(value, "HH:mm:ss.lll");
		} else if ( TypeIsBoolean( typeName )) {
			if (value) { 
				return "true";
			} else {
				return "false";
			}
		} else if ( TypeIsString( typeName )) {
			return XmlFormat( Trim (value) );
		} else {
			return " DESCONOCIDO : " & typeName;
		}
	}
	function quoteSQL2( value, typeName , lobIndex ) {
		if (Len ( value ) EQ 0) {
			return "null";
		} else if (TypeIsLOB(typeName)) {
			if (dbms_type is 'ora') {
				return 'lob' & lobIndex;
			} else if (dbms_type is 'db2') { // db2
				if ( TypeIsBinary( typeName )) {
					return "null";
				} else {
					return controlchars (value);
				}
			} else if (ListFind('syb,mss', dbms_type )) { // sybase/ms sql server
				if ( TypeIsBinary( typeName )) {
					return '0x' & binary2Hex ( value );
				} else {
					return controlchars (value);
				}
			}
		} else if ( TypeIsBinary( typeName )) {
			if (dbms_type is 'ora') {
				return 'hextoraw(''' & binary2Hex ( value ) & ''')';
			} else if (dbms_type is 'db2') {
				return 'null';
			} else if (ListFind('syb,mss', dbms_type)) {
				return '0x' & binary2Hex ( value );
			} else {
				return 'null_' + dbms_type;
			}
		} else if ( TypeIsNumeric( typeName )) {
			return value;
		} else if ( TypeIsDate( typeName )) {
			if (dbms_type is 'ora') {
				return "'" & DateFormat(value,"yyyymmdd")& "'";
			} else if (dbms_type is 'db2') {
				return "'" & DateFormat(value,"yyyy-mm-dd-") & TimeFormat(value,"HH.mm.ss") & "'";
			} else if (ListFind('syb,mss', dbms_type)) {
				return "'" & DateFormat(value,"yyyymmdd") & " " & TimeFormat(value,"HH:mm:ss.lll") & "'";
			}
		} else if ( TypeIsBoolean( typeName )) {
			if (value) {
				return "1";
			} else {
				return "0";
			}
		} else if ( TypeIsString( typeName )) {
				if (Len ( TRIM(value) ) EQ 0) {
					return "null";
					}	
				return controlchars (RTRIM(value));
		} else {
			return " DESCONOCIDO : " & typeName;
		}
	}
	function quoteSQL( value, typeName ) {
		return quoteSQL2 (value, typeName, 0);
	}
	function gen(ret, table, pk, tipo, insertonly)
	{
		if (tipo EQ "xml") {
			genXML(ret, table);
		} else {
			genSQL(ret, table, pk, insertonly);
		}
	}
	function init_row (lobNames, lobTypes, rs, tableName) {
		var retval = "";
		var value  = "";
		var chunk  = "";
		var i = 0;
		var j = 0;
		if (dbms_type is 'ora') {
			retval = "select '" & tableName & " fila " & rs.CurrentRow & " de " & rs.RecordCount & "' as msg from dual; " & newline 
			       & '/ ' & newline & 'DECLARE ' & newline;
			retval = retval & ' n int;' & newline;
			for (i = 1; i LE ArrayLen(lobNames); i = i + 1) {
				if (TypeIsBinary(lobTypes[i])) {
					retval = retval & ' lob' & i & ' blob;' & newline;
				} else {
					retval = retval & ' lob' & i & ' clob;' & newline;
				}
			}
			retval = retval & 'BEGIN'  & newline;
			for (i = 1; i LE ArrayLen(lobNames); i = i + 1) {
				value = Evaluate('rs.' & lobNames[i]);
				if (Len(value) Is 0) {
					retval = retval & 'lob' & i & ' := null;' & newline;
				} else {
					retval = retval & 'dbms_lob.createTemporary (lob' & i & ', true);' & newline &
								'dbms_lob.open (lob' & i & ', dbms_lob.LOB_READWRITE);' & newline;
					if (TypeIsBinary(lobTypes[i])) {
						value = binary2Hex(value);
						for (j = 1; j LE Len(value); j = j + 200) {
							chunk = Mid(value, j, 200);
							retval = retval & 'dbms_lob.writeAppend (lob' & i & ', ' & (Len(chunk)/2) & ', hextoraw(''' & chunk & '''));' & newline;
						}
					} else {
						value = rtrim(value);
						for (j = 1; j LE Len(value); j = j + 200) {
							chunk = Mid(value, j, 200);
							retval = retval & 'dbms_lob.writeAppend (lob' & i & ', ' & Len(chunk) & ', ' & quoteSQL(chunk,'varchar') & ');' & newline;
						}
					}
				}
			}
		} else if (dbms_type is 'db2') {
			retval = dbms_print(tableName & " fila: " & rs.CurrentRow & " de " & rs.RecordCount)& newline & 
				"BEGIN ATOMIC" & newline;
		} else if (ListFind('syb,mss', dbms_type)) {
			retval = "print '" & tableName & " fila: " & rs.CurrentRow & " de " & rs.RecordCount &  "'" & newline 
			       & 'declare @n int ' & newline;
			retval = retval & 'begin tran' & newline;
		}
		return retval;
	}
	function done_row(lobNames, lobTypes, rs) {
		var retval = "";
		var i = 0;
		if (dbms_type is 'ora') {
			for (i = 1; i LE ArrayLen(lobNames); i = i + 1) {
				value = Evaluate('rs.' & lobNames[i]);
				if (Len(value) Neq 0) {
					retval = retval & 'dbms_lob.close (lob' & i & ');' & newline &
							'dbms_lob.freeTemporary (lob' & i & ');' & newline;
				}
			}
			retval = retval & 'COMMIT;' & newline;
			retval = retval & 'END;' & newline & '/' & newline;
		} else if (dbms_type is 'db2') {
			retval = dbms_go & 'commit ' & dbms_go;
		} else if (ListFind('syb,mss', dbms_type)) {
			retval = 'commit ' & dbms_go;
		}
		return retval;
	}
</cfscript>

<cfset newline = Chr(13)&Chr(10)>
<cfset indent  = "  ">
<cfset dbms_go = newline & 'go' & newline>
<cfset dbms_type = 'syb'>

<cffunction name="set_dbms" output="false">
	<cfargument name="dbms">
	<cfif Arguments.dbms is 'ora'>
		<cfset dbms_go = newline & '/' & newline>
	<cfelseif Arguments.dbms is 'db2'>
		<cfset dbms_go = newline & ';' & newline>
	<cfelseif ListFind('syb,mss', Arguments.dbms)>
		<cfset dbms_go = newline & 'go' & newline>
	<cfelse>
		<cfthrow message="DBMS no soportado: #Arguments.dbms#">
	</cfif>
	<cfset dbms_type = Arguments.dbms>
</cffunction>
<cffunction name="dbms_print" output="false">
	<cfargument name="msg">
	<cfif dbms_type is 'ora'>
		<cfreturn newline & 'select ''' & msg & ''' msg from dual; ' & newline>
	<cfelseif dbms_type is 'db2'>
		<cfreturn newline & 'select ''' & msg & ''' msg from dual;' & newline>
	<cfelseif ListFind('syb,mss', dbms_type)>
		<cfreturn newline & 'print ''' & msg & '''' & newline>
	<cfelse>
		<cfreturn newline & 'print ''' & msg & '''' & newline>
	</cfif>
</cffunction>
<cffunction name="dbms_sql_init" output="false">
	<cfif dbms_type is 'ora'>
		<cfreturn 'alter session set NLS_DATE_FORMAT=''YYYYMMDD HH24:MI:SS'';' & dbms_go &
				  'alter session set NLS_TIMESTAMP_FORMAT=''YYYYMMDD HH24:MI:SS:FF'';' & dbms_go>
	<cfelseif dbms_type is 'db2'>
		<cfreturn ''>
	<cfelseif ListFind('syb,mss', dbms_type)>
		<cfreturn 'set nocount on' & dbms_go>
	<cfelse>
		<cfreturn ''>
	</cfif>
</cffunction>

<cffunction name="genSQL">
	<cfargument name="ret"   required="yes">
	<cfargument name="table" required="yes">
	<cfargument name="pk"    required="yes">
	<cfargument name="insertonly" required="yes" default="no" type="boolean">
	
		<cfset names = ret.getMetaData().getColumnLabels()>
		<cfset typeNames = getTypeNames(ret)>
		<cfset timestamp_column = -1>
		<cfset lobNames = ArrayNew(1)>
		<cfset lobTypes = ArrayNew(1)>
		<cfset lobIndex = ArrayNew(1)>
		<cfset lastcol = ArrayLen(names)>
		<cfloop from="1" to="#ArrayLen(names)#" index="i">
			<cfset lobIndex[i] = 0>
			<cfif "timestamp" EQ names[i] OR "ts_rversion" EQ names[i]>
				<cfset timestamp_column = i>
				<cfif timestamp_column EQ lastcol>
					<cfset lastcol = lastcol - 1>
				</cfif>
			<cfelseif TypeIsLOB(typeNames[i])>
				<cfset ArrayAppend(lobNames, names[i])>
				<cfset ArrayAppend(lobTypes, typeNames[i])>
				<cfset lobIndex[i] = ArrayLen(lobNames)>
			</cfif>
		</cfloop>
		<cfset updateable_columns = 0>
		<cfloop from="1" to="#ArrayLen(names)#" index="i">
			<cfif i NEQ timestamp_column AND ListFindNoCase(pk, names[i]) EQ 0>
				<cfset updateable_columns = updateable_columns + 1>
			</cfif>
		</cfloop>
		<cfif updateable_columns is 0>
			<cfset Arguments.insertonly = true>
		</cfif>
		<cfif Arguments.insertonly>
			<cfoutput>#dbms_print('Actualizar ' & table & ' (insert only)...')#</cfoutput>
		<cfelse>
			<cfoutput>#dbms_print('Actualizar ' & table & ' (update/insert)...')#</cfoutput>
		</cfif>

		<cfloop query="ret">
			<cfoutput>#init_row(lobNames, lobTypes, ret, table)#</cfoutput>
			
			<!--- preparar el where --->
			<cfset where_clause = "">
			<cfset where_keyword = "where">
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif ListFindNoCase(pk, names[i]) NEQ 0>
					<cfset where_clause = where_clause & 
						where_keyword & " " & names[i] & " = " & quoteSQL2( Evaluate (
						"ret." & names[i]), typeNames[i], lobIndex[i] ) >
					<cfset where_keyword = "  and">
				</cfif>
			</cfloop>
			
			<cfif dbms_type is 'ora'>
				<cfoutput>select count(1) into n</cfoutput>
			<cfelseif dbms_type is 'db2'>
				<cfoutput>FOR row AS select count(1) as c </cfoutput>
			<cfelseif ListFind('syb,mss', dbms_type)>
				<cfoutput>select @n = count(1)</cfoutput>
			<cfelse><!--- otros --->
			</cfif>
			<cfoutput>#newline#from #table# #newline#</cfoutput>
			<cfoutput>#where_clause#</cfoutput>
			<cfif dbms_type is 'ora'>
				<cfoutput>; #newline#</cfoutput>
				<cfoutput>if (n=0) then #newline#</cfoutput>				
			<cfelseif dbms_type is 'db2'>
				<cfoutput> DO #newline#</cfoutput>
				<cfoutput>IF row.c = 0 THEN#newline#</cfoutput>
			<cfelseif ListFind('syb,mss', dbms_type)>
				<cfoutput>if (@n = 0) begin#newline#</cfoutput>				
			</cfif>
			
			<!--- insert --->
			<cfoutput>insert into #table# (#newline#</cfoutput>
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp_column>
					<cfoutput>#names[i]#<cfif i NEQ lastcol>,<cfif i MOD 4 EQ 0>#newline# </cfif> </cfif></cfoutput>
				</cfif>
			</cfloop>
			<cfoutput>)#newline#values (#newline#  </cfoutput>
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp_column>
					<cfoutput>#quoteSQL2( Evaluate (
						"ret." & names[i]), typeNames[i], lobIndex[i] )#<cfif i NEQ lastcol>,<cfif i MOD 4 EQ 0>#newline# </cfif> </cfif></cfoutput>
				</cfif>
			</cfloop>
			<cfoutput>)</cfoutput>

			<cfif not Arguments.insertonly>
				<cfif dbms_type is 'ora'>
					<cfoutput>;#newline#else#newline#</cfoutput>
				<cfelseif dbms_type is 'db2'>
					<cfoutput>;#newline#ELSE #newline#</cfoutput>
				<cfelseif ListFind('syb,mss', dbms_type)>
					<cfoutput>#newline#end else begin #newline#</cfoutput>
				<cfelse>
				</cfif>
				
				<!--- update --->
				<cfoutput>update #table## newline #</cfoutput>
				<cfset set_keyword = "set">
				<cfloop from="1" to="#ArrayLen(names)#" index="i">
					<cfif i NEQ timestamp_column AND ListFindNoCase(pk, names[i]) EQ 0>
						<cfoutput>#set_keyword# #names[i]# = #quoteSQL2( Evaluate (
							"ret." & names[i]), typeNames[i], lobIndex[i] )## newline #</cfoutput>
						<cfset set_keyword = ",  ">
					</cfif>
				</cfloop>
				<cfoutput>#where_clause#</cfoutput>
			</cfif>

			<cfif dbms_type is 'ora'>
				<cfoutput>;#newline#end if; #newline#</cfoutput>
			<cfelseif dbms_type is 'db2'>
				<cfoutput>;#newline#END IF;#newline#</cfoutput>
				<cfoutput>END FOR;#newline#</cfoutput>
				<cfoutput>END#newline#</cfoutput>
			<cfelseif ListFind('syb,mss', dbms_type)>
				<cfoutput>#newline#end -- if #newline#</cfoutput>
			<cfelse>
			</cfif>
			
			<cfoutput>#done_row(lobNames, lobTypes, ret)#</cfoutput>
		</cfloop>
		<cfoutput>#dbms_print( 'Terminado ' & table )#</cfoutput>
</cffunction>

<cffunction name="genXML">
	<cfargument name="ret" required="yes">
	<cfargument name="table" required="yes">
		<cfset names = ret.getMetaData().getColumnLabels()>
		<cfset typeNames = getTypeNames(ret)>
		<cfset timestamp_column = -1>
		<cfset lastcol = ArrayLen(names)>
		<cfloop from="1" to="#ArrayLen(names)#" index="i">
			<cfif "timestamp" EQ names[i] OR "ts_rversion" EQ names[i]>
				<cfset timestamp_column = i>
				<cfif timestamp_column EQ lastcol>
					<cfset lastcol = lastcol - 1>
				</cfif>
				<cfbreak>
			</cfif>
		</cfloop>
		<cfoutput><#table#_list>#newline#</cfoutput>
		<cfloop query="ret">
			<cfoutput>#indent#<row>#newline#</cfoutput>
			<cfloop from="1" to="#ArrayLen(names)#" index="i">
				<cfif i NEQ timestamp_column>
					<cfoutput>#indent##indent#<#names[i]#>#quoteXML( Evaluate (
						"ret." & names[i]), typeNames[i] )#</#names[i]#>#newline#</cfoutput>
				</cfif>
			</cfloop>
			<cfoutput>#indent#</row>#newline#</cfoutput>
		</cfloop>
		<cfoutput></#table#_list>#newline#</cfoutput>
</cffunction>

<cffunction name="identity_insert_on">
	<cfargument name="table" required="yes">
	<cfargument name="identityfield" required="yes">

	<cfif ListFind('syb,mss', dbms_type)>
		<cfoutput>set identity_insert #Arguments.table# on</cfoutput>
		<cfoutput>#dbms_go#</cfoutput>
	<cfelseif dbms_type is 'ora'>
		<cfoutput>call soinpk.set_identity_insert_on()</cfoutput>
		<cfoutput>#dbms_go#</cfoutput>
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbms_type#">
	</cfif>
</cffunction>

<cffunction name="identity_insert_off">
	<cfargument name="table" required="yes">
	<cfargument name="identityfield" required="yes">
	<cfargument name="query" type="query" required="yes">
	
	<cfif ListFind('syb,mss', dbms_type)>
		<cfoutput>set identity_insert #Arguments.table# off #dbms_go#</cfoutput>
		<cfoutput>#dbms_go#</cfoutput>
	<cfelseif dbms_type is 'ora'>
		<cfquery dbtype="query" name="nextval">
			select max(#Trim(Arguments.identityfield)#) as nextval from Arguments.query
		</cfquery>
		<cfif Len(nextval.nextval)>
			<cfoutput>#dbms_go#</cfoutput>
			<cfoutput>drop sequence s_#Arguments.table#</cfoutput>
			<cfoutput>#dbms_go#</cfoutput>
			<cfoutput>create sequence s_#Arguments.table# start with #nextval.nextval#</cfoutput>
			<cfoutput>#dbms_go#</cfoutput>
		</cfif>
	<cfelse>
		<cfthrow message="DBMS no soportado: #dbms_type#">
	</cfif>
</cffunction>

