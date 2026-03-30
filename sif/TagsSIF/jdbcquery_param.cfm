<cfsilent>
<!---
	Autor: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*
	* Emula el <cfqueryparam...> para utilizarlo con el <CF_JDBCquery_open>
	* Pero se puede utilizar cuando se arma una instrucción SQL en una variable de memoria
	*
	* Utilización:
	*	<CF_jdbcquery_param cfsqltype="XX" value="XX" [scale="XX" maxlength="XX" null="XX" returnVariable="XX" dateFormat="DD/MM/YYYY HH:MI:SS"]>
	*
--->
<cfparam name="Attributes.cfsqltype" 		type="string">
<cfparam name="Attributes.value"			type="any">
<cfparam name="Attributes.null" 			type="boolean"	default="no">
<cfparam name="Attributes.scale"  			type="numeric"	default="0">
<cfparam name="Attributes.maxlength"		type="numeric"	default="0">
<cfparam name="Attributes.datasource"		type="string"	default="">
<cfparam name="Attributes.returnVariable"	type="String"	default="">	 <!--- Nombre Variable --->
<cfparam name="Attributes.dateFormat"	 	type="String"	default="YYYY/MM/DD"> <!--- Default value cambia a ansi standard --->

<cfset LvarTypes = "cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint,cf_sql_integer,cf_sql_numeric,cf_sql_decimal,cf_sql_money,cf_sql_money4,cf_sql_float,cf_sql_real,cf_sql_double,cf_sql_bit,cf_sql_char,cf_sql_longvarchar,cf_sql_varchar,cf_sql_clob,cf_sql_date,cf_sql_time,cf_sql_timestamp,cf_sql_blob">
<cfset Attributes.cfsqltype = lcase(Attributes.cfsqltype)>
<cfif isdefined("Attributes.voidnull") and Attributes.cfsqltype NEQ 'cf_sql_blob'>
	<cfset Attributes.null = Attributes.null OR trim(Attributes.value) EQ "">
</cfif>
<cfset LvarSQLvalueNull = fnEsNull(Attributes.cfsqltype,Attributes.value,Attributes.datasource)>
<cfif Attributes.null>
	<cfset LvarSQLvalue = LvarSQLvalueNull>
<cfelseif listFind("cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint,cf_sql_integer",Attributes.cfsqltype)>
	<cfset LvarSQLvalue = fnEsNumerico(Attributes.value, 0)>
<cfelseif listFind("cf_sql_money,cf_sql_money4",Attributes.cfsqltype)>
	<cfset LvarSQLvalue = fnEsNumerico(Attributes.value, 4)>
<cfelseif listFind("cf_sql_numeric,cf_sql_decimal",Attributes.cfsqltype)>
	<cfset LvarSQLvalue = fnEsNumerico(Attributes.value, Attributes.scale)>
<cfelseif listFind("cf_sql_float,cf_sql_real,cf_sql_double",Attributes.cfsqltype)>
	<cfset LvarSQLvalue = fnEsNumerico(Attributes.value, -1)>
<cfelseif Attributes.cfsqltype EQ "cf_sql_bit">
	<cfif isboolean(Attributes.value)>
		<cfif Attributes.value>
			<cfset LvarSQLvalue = 1>
		<cfelse>
			<cfset LvarSQLvalue = 0>
		</cfif>
	<cfelse>
		<cfif fnEsNumerico(Attributes.value,0) NEQ 0>
			<cfset LvarSQLvalue = 1>
		<cfelse>
			<cfset LvarSQLvalue = 0>
		</cfif>
	</cfif>
<cfelseif listFind("cf_sql_char,cf_sql_longvarchar,cf_sql_varchar,cf_sql_clob",Attributes.cfsqltype)>
	<cfset LvarSQLvalue = "'#replace(Attributes.value,"'","''","ALL")#'">
	<cfif isdefined("Attributes.len")>
		<cf_dbfunction name="spart" args="#LvarSQLvalue# ¬ 1 ¬ #Attributes.len#" delimiters="¬" returnVariable="LvarSQLvalue">
	</cfif>
<cfelseif Attributes.cfsqltype EQ "cf_sql_date">
	<cfset sbEsTiempo()>
	<cfset LvarSQLvalue = createODBCdateTime(createdate(year(Attributes.value),month(Attributes.value),day(Attributes.value)))>
<cfelseif Attributes.cfsqltype EQ "cf_sql_time">
	<cfset sbEsTiempo()>
	<cfset LvarSQLvalue = createODBCtime(Attributes.value)>
<cfelseif Attributes.cfsqltype EQ "cf_sql_timestamp">
	<cfset sbEsTiempo()>
	<cfset LvarSQLvalue = createODBCdateTime(Attributes.value)>
<cfelseif listFind("cf_sql_blob",Attributes.cfsqltype)>
	<cfset LvarSQLvalue = "'#replace(Attributes.value,"'","''","ALL")#'">
<cfelse>
	<cf_errorCode	code = "50693"
					msg  = "jdbcquery_param: Sólo se han implementado los siguientes tipos: @errorDat_1@"
					errorDat_1="#LvarTypes#"
	>
</cfif>

<cffunction name="fnEsNumerico" access="private" output="false" returntype="string">
	<cfargument name="value"			type="any">
	<cfargument name="scale"  		 	type="numeric">
	<!---Se eliminan las comas que separan los miles, ya que el cfmonto no las quita--->
	<cfset Arguments.value = replace(Arguments.value,",","","ALL")>
	<cfif not isnumeric(Arguments.value)>
		<cf_errorCode	code = "50694"
						msg  = "El valor '@errorDat_1@' no es numerico"
						errorDat_1="#Attributes.value#"
		>
	</cfif>
	
	<cfset LvarPto = find(".",Arguments.value)>
	<cfif LvarPto EQ 0 OR Arguments.scale LT 0>
		<cfreturn Arguments.value>
	</cfif>
	
	<cfif LvarPto+Arguments.scale GT 18>
		<!--- Cuando es un numero de más de 18 dígitos, se usa BigDecimal --->
		<cfset ROUND_HALF_UP = 4>
		<cfreturn createObject("java","java.math.BigDecimal").init(Arguments.value).setScale(Arguments.scale,ROUND_HALF_UP)>
	<cfelseif Arguments.scale EQ 0>
		<cfreturn numberFormat(Arguments.value,"9")>
	<cfelse>
		<cfreturn numberFormat(Arguments.value,"9.#repeatString("0", Arguments.scale)#")>
	</cfif>
</cffunction>

<cffunction name="sbEsTiempo" access="private" output="false" returntype="void">
	<cfif not isdate(Attributes.value)>
		<cf_errorCode	code = "50695"
						msg  = "El valor '@errorDat_1@' no es tiempo"
						errorDat_1="#Attributes.value#"
		>
	<cfelseif Attributes.value.getClass().name EQ "java.lang.String">
	<!---►► Convierte el String a tipo de dato Fecha Verificando que el formato indicado (default DD/MM/YYYY) ◄◄--->
		<cfset Attributes.value = strToDate(Attributes.value,Attributes.dateFormat)>	
	</cfif>
</cffunction>

<cffunction name="strToDate" returntype="string">
	<cfargument name="fechaStr" type="string">
	<cfargument name="fechaFmt" type="string">
	
	<cfset Arguments.fechaStr = trim(Arguments.fechaStr)>
	<cfif Arguments.fechaStr EQ "">
		<cfreturn "">
	</cfif>
	<cfset LvarFechaFormato = trim(Arguments.fechaFmt)>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"D","d","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"M","M","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"Y","y","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"H","H","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"MI","mm","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"S","s","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"MS","SSS","ALL")>
	<cfset LvarFechaFormato = replaceNoCase(LvarFechaFormato,"-","/","ALL")>
	<cfif reFind("[^dMyHmsS/:.]",LvarFechaFormato)>
		<cfthrow message="jdbcquery_param: El formato de la fecha solo puede contener DD, MM, YY, YYYY, HH, MI, SS, MS: #Arguments.fechaFmt#">
	</cfif>
	<cfset LvarDF = createObject("java","java.text.SimpleDateFormat").init("#LvarFechaFormato#")>
	<cfset LvarFecha = LvarDF.parse(Arguments.fechaStr)>
	<cfif LvarDF.format(LvarFecha) NEQ Arguments.fechaStr>
		<cfthrow message="jdbcquery_param: El valor de la fecha no cumple el formato indicado: #Arguments.fechaStr# #Arguments.fechaFmt#">
	</cfif>
	<cfreturn LvarFecha>
</cffunction>

<cffunction name="fnEsNull" access="private" output="false" returntype="string">
	<cfargument name="cfsqltype"	type="string">
	<cfargument name="value"		type="any">
	<cfargument name="datasource"  	type="string">
	<cfif len(Attributes.datasource) EQ 0>
		<cfset Attributes.datasource = 'asp'>
	</cfif>
	<cfif (Not IsDefined('Application.dsinfo')) OR (Not StructKeyExists(Application.dsinfo,Attributes.datasource))>
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" datasource="#Attributes.datasource#" />
  </cfif>
	<cfset LvarDBtype = Application.dsinfo[Attributes.datasource].type>
	<cfif Attributes.cfsqltype NEQ 'cf_sql_blob' and ucase(Arguments.value) NEQ "null" AND NOT Attributes.null>
		<cfreturn Arguments.value>
	<cfelseif LvarDBtype EQ 'db2'>
		<cfset Attributes.null = true>
		<cfif listFind("cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint,cf_sql_integer,cf_sql_money,cf_sql_money4,cf_sql_numeric,cf_sql_decimal,cf_sql_float,cf_sql_real,cf_sql_double,cf_sql_bit",Attributes.cfsqltype)>
			<cfreturn "CAST(null AS INTEGER)">
		<cfelseif listFind("cf_sql_char,cf_sql_longvarchar,cf_sql_varchar,cf_sql_clob,cf_sql_date,cf_sql_time,cf_sql_timestamp",Attributes.cfsqltype)>
			<cfreturn "CAST(null AS CHAR)">
		<cfelseif listFind("cf_sql_blob",Attributes.cfsqltype)>
			<cfreturn "CAST(null AS BLOB)">
		<cfelse>
			<cf_errorCode	code = "50693"
					msg  = "jdbcquery_param: Sólo se han implementado los siguientes tipos: @errorDat_1@"
					errorDat_1="#LvarTypes#"
			>
		</cfif>
	<cfelse>
		<cfset Attributes.null = "true">
		<cfreturn "null">
	</cfif>
</cffunction>
</cfsilent><cfif Attributes.returnVariable EQ ""><cfoutput>#LvarSQLvalue#</cfoutput><cfelse><cfset caller[Attributes.returnVariable] = LvarSQLvalue></cfif>