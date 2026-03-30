<cfsilent>
<!---
	Autor: Ing. Óscar Bonilla, MBA. 02/AGO/2006
	*
	* Emula el <cfqueryparam...> para utilizarlo con el <CF_JDBCquery_open>
	* Pero se puede utilizar cuando se arma una instrucción SQL en una variable de memoria
	*
	* Utilización:
	*	<CF_jdbcquery_param cfsqltype="XX" value="XX" [scale="XX" maxlength="XX" null="XX" returnVariable="XX"]>
	*
--->
<cfparam name="Attributes.cfsqltype" 		type="string">
<cfparam name="Attributes.value"			type="any">
<cfparam name="Attributes.null" 			type="boolean"	default="no">
<cfparam name="Attributes.scale"  			type="numeric"	default="0">
<cfparam name="Attributes.maxlength"		type="numeric"	default="0">
<cfparam name="Attributes.datasource"		type="string"	default="">
<cfparam name="Attributes.returnVariable"	type="String"  default="">	 <!--- Nombre Variable --->

<cfset LvarTypes = "cf_sql_bigint,cf_sql_smallint,cf_sql_tinyint,cf_sql_integer,cf_sql_numeric,cf_sql_decimal,cf_sql_money,cf_sql_money4,cf_sql_float,cf_sql_real,cf_sql_double,cf_sql_bit,cf_sql_char,cf_sql_longvarchar,cf_sql_varchar,cf_sql_clob,cf_sql_date,cf_sql_time,cf_sql_timestamp,cf_sql_blob">
<cfset Attributes.cfsqltype = lcase(Attributes.cfsqltype)>
<cfif Attributes.null>
	<cfset LvarSQLvalue = "null">
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
<cfelseif Attributes.cfsqltype EQ "cf_sql_date">
	<cfset sbEsTiempo()>
	<cfset LvarSQLvalue = createODBCdate(Attributes.value)>
<cfelseif Attributes.cfsqltype EQ "cf_sql_time">
	<cfset sbEsTiempo()>
	<cfset LvarSQLvalue = createODBCtime(Attributes.value)>
<cfelseif Attributes.cfsqltype EQ "cf_sql_timestamp">
	<cfset sbEsTiempo()>
	<cfset LvarSQLvalue = createODBCdateTime(Attributes.value)>
<cfelseif listFind("cf_sql_blob",Attributes.cfsqltype)>
	<cfif attributes.datasource EQ "">
		<cf_errorCode	code = "50691" msg = "jdbcquery_param: Si tipo es cf_sql_blob debe especificar datasource">
	<cfelse>
		<cf_errorCode	code = "50692" msg = "jdbcquery_param: No se ha implementado tipo cf_sql_blob">
	</cfif>
<cfelse>
	<cf_errorCode	code = "50693"
					msg  = "jdbcquery_param: Sólo se han implementado los siguientes tipos: @errorDat_1@"
					errorDat_1="#LvarTypes#"
	>
</cfif>

<cffunction name="fnEsNumerico" access="private" output="false" returntype="string">
	<cfargument name="value"			type="any">
	<cfargument name="scale"  		 	type="numeric">
	
	<cfif not isnumeric(Attributes.value)>
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
	</cfif>
</cffunction>
</cfsilent>
<cfif Attributes.returnVariable EQ ""><cfoutput>#LvarSQLvalue#</cfoutput><cfelse><cfset caller[Attributes.returnVariable] = LvarSQLvalue></cfif>


