<!--- Tabla temporal para almacenar los errores --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="text" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>

<cf_dbfunction name="OP_concat"	returnvariable="_CAT" >
<cf_dbfunction name="to_char"		args="id"  		isNumber="true" returnvariable="lvarID">
<cf_dbfunction name="to_char"		args="Periodo"  isNumber="true" returnvariable="lvarPeriodo">
<cf_dbfunction name="to_char"		args="Mes"  	isNumber="true" returnvariable="lvarMes">

<cfquery datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
	select '<strong>Error:</strong> Centro Funcional ' #_CAT# CFcodigo #_CAT# ' no es v&aacute;lido.<br/><strong>Datos del registro</strong> : CFcodigo(' #_CAT# CFcodigo #_CAT# '), Periodo(' #_CAT# #lvarPeriodo# #_CAT# '), Mes (' #_CAT# #lvarMes# #_CAT# ').<br /><strong>Error en el registro Num&ordm;:</strong> ' #_CAT# #lvarID#, 1
	from #table_name# tmp
    where not exists(select 1 from CFuncional cf where cf.Ecodigo = #session.Ecodigo# and cf.CFcodigo = tmp.CFcodigo)
</cfquery>

<cfquery name="err" datasource="#session.dsn#">
	select ErrorNum, Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum
</cfquery>

<cfif err.recordCount eq 0>

    <cfquery name="rsMinP" datasource="#session.dsn#">
        select min(Periodo) as Periodo
        from #table_name#
    </cfquery>
     <cfquery name="rsMinM" datasource="#session.dsn#">
        select min(Mes) as Mes
        from #table_name#
        where Periodo = #rsMinP.Periodo#
    </cfquery>
    
    <cfquery name="rsMaxP" datasource="#session.dsn#">
        select max(Periodo) as Periodo
        from #table_name#
    </cfquery>
     <cfquery name="rsMaxM" datasource="#session.dsn#">
        select max(Mes) as Mes
        from #table_name#
        where Periodo = #rsMaxP.Periodo#
    </cfquery>
    
    <cfset vd_fechadesde = CreateDate(rsMinP.Periodo, rsMinM.Mes, 1)>	<!---Variable con el periodo desde--->
	<cfset vd_fechahasta = CreateDate(rsMaxP.Periodo, rsMaxM.Mes, 1)>	<!---Variable con el periodo hasta--->
	<cftransaction>
        <cfquery name="insertOP" datasource="#session.DSN#">
            insert into RHOtrasPartidas(RHEid,RHPOPid,Ecodigo,fechadesde,fechahasta,BMfecha,BMUsucodigo)
            values(<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHEid#">,
                   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHPOPid#">,	
                   <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#">,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#vd_fechadesde#">,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#vd_fechahasta#">,
                   <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">,
                   <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.USucodigo#">)
            <cf_dbidentity1 datasource="#session.DSN#">			
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="insertOP">
        <cfset LvarRHOPid = insertOP.identity>
        <cfquery datasource="#session.DSN#">
            insert into RHDOtrasPartidas(RHOPid, 
                                    Mes, 
                                    Periodo, 
                                    Monto, 
                                    BMfecha, 
                                    BMUsucodigo,
                                    CFid)
            select 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarRHOPid#">,
                    Mes,
                    Periodo,
                    Monto,
                    <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
                    #session.Usucodigo#,
                    cf.CFid
            from #table_name# tmp
                inner join CFuncional cf
                    on cf.CFcodigo = tmp.CFcodigo and cf.Ecodigo = #session.Ecodigo#
        </cfquery>
    </cftransaction>

</cfif>