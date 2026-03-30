<cfset params = "">
<cfinvoke component="rh.asoc.Componentes.ACParametros" 	method="init" returnvariable="Parametros">
<cfif isdefined("ALTA")>
	<cftransaction>
    <cfquery name="rsInsert" datasource="#session.dsn#">
        INSERT INTO ACAportesRegistro 
        (ACAAid, ACARfecha, ACARtipo, ACARmonto, ACARreferencia, BMUsucodigo, BMfecha)
        VALUES (
        	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACAAid#">, 
            <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
            'A', 
            <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.ACARmonto,',','','all')#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACARreferencia#">, 
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
        <cf_dbidentity1>
    </cfquery>
    <cf_dbidentity2 name="rsInsert">
    </cftransaction>
	<cfset params = "&ACARid=#rsInsert.identity#">
<cfelseif isdefined("CAMBIO")>
	<cf_dbtimestamp
		datasource="#Session.DSN#"
		table="ACAportesRegistro" 
		redirect="registroAportesManuales.cfm"
		timestamp="#form.ts_rversion#"
		field1="ACARid,numeric,#Form.ACARid#">
	<cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
        UPDATE ACAportesRegistro 
        SET ACARfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
        	ACARmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(Form.ACARmonto,',','','all')#">, 
            ACARreferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ACARreferencia#">
        WHERE ACARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACARid#">
    </cfquery>
    <cfset params = "&ACARid=#Form.ACARid#">
<cfelseif isdefined("BAJA")>
	<cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
        DELETE from ACAportesRegistro 
        WHERE ACARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACARid#">
    </cfquery>
<cfelseif isdefined("APLICAR")>
	<cfset Lvar_Periodo 	= Parametros.Get("10",	"Periodo")>
    <cfset Lvar_Mes 		= Parametros.Get("20",	"Mes")>
	<cfquery name="rsData" datasource="#session.dsn#">
    	SELECT ACAAid, ACARfecha, ACARmonto, ACARreferencia
        FROM  ACAportesRegistro 
        WHERE ACARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACARid#">
    </cfquery>
    <cftransaction>
	<cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
        INSERT INTO ACAportesTransacciones 
        (ACAAid, ACATperiodo, ACATmes, ACATfecha, ACATtipo, ACATafecta, ACATmonto, ACATreferencia, BMUsucodigo, BMfecha)
        VALUES(
        	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.ACAAid#">,  
            <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">, 
            <cfqueryparam cfsqltype="cf_sql_date" value="#rsData.ACARfecha#">, 
            'M', 'C', 
            <cfqueryparam cfsqltype="cf_sql_money" value="#rsData.ACARmonto#">, 
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsData.ACARreferencia#">, 
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)
	</cfquery>
    <cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
        UPDATE ACAportesSaldos
        SET ACAAaporteMes = ACAAaporteMes + <cfqueryparam cfsqltype="cf_sql_money" value="#rsData.ACARmonto#">
        WHERE ACAAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACAAid#">
          AND ACASperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Periodo#">
          AND ACASmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Mes#">
	</cfquery>
	<cfquery name="rsACAportesRegistro" datasource="#session.dsn#">
        DELETE from ACAportesRegistro 
        WHERE ACARid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACARid#">
    </cfquery>
    </cftransaction>
</cfif>
<cflocation url="registroAportesManuales.cfm?#params#">