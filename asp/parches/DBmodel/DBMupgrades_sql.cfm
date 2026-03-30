<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfif isdefined("url.DB2_REORG")>
	<cfset session.DB2_REORG = (url.DB2_REORG EQ 1)>
	<cflocation url="DBMupgrades.cfm">
</cfif>
<cfif isdefined("url.DBM_DEPENDENCIAS")>
	<cfset session.DBM_DEPENDENCIAS = (url.DBM_DEPENDENCIAS EQ 1)>
	<cflocation url="DBMupgrades.cfm">
</cfif>
<cfif isdefined("url.op")>
	<cfif url.op EQ 1>
		<!--- Configurar DSNs: IDmod --->
		<cflocation url="DBMupgrades.cfm?IDmod=#url.IDmod#">

	<cfelseif url.op EQ 2 OR url.op EQ 5>
		<!--- Visualizar Versiones Nuevas: IDdsn --->
		<cfinclude template="DBMupgrades_view.cfm">
	<cfelseif url.op EQ 3 OR url.op EQ 4>
		<!--- Crear Nueva Generación, Generar Script y Ejecutar Script: IDdsn --->
		<cfparam name="url.IDdsn" type="numeric">
		<cfparam name="url.IDmod" type="numeric">
		<cfquery name="rsSQL" datasource="asp">
			select    IDverUlt
					, coalesce((select min(IDver) 
						 from DBMversiones
						where IDmod = d.IDmod
						  and IDver > coalesce(d.IDverUlt,0)
					  ),0) as IDverIniMod
					, coalesce((select max(IDver) 
						 from DBMversiones
						where IDmod = d.IDmod
						  and IDver > coalesce(d.IDverUlt,0)
					  ),0) as IDverFinMod
			  from DBMdsn d
			 where IDdsn = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
		</cfquery>
		
		<cfquery name="rsInsert" datasource="asp">
			insert into DBMgen
				(IDdsn,IDmod,IDverIni,IDverFin)
			values(
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.IDverIniMod#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.IDverFinMod#">
				) 
			<cf_dbidentity1 name="rsInsert" verificar_transaccion="false" returnVariable="LvarIDgen" datasource="asp">
		</cfquery>
		<cf_dbidentity2 name="rsInsert" verificar_transaccion="false" returnVariable="LvarIDgen" datasource="asp">

		<cfquery datasource="asp">
			insert into DBMgenP
				(IDgen,IDdsn,IDmod)
			values(
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDgen#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
				)
		</cfquery>

		<cfthread name="DBM_UPGRADE_NEW">
			<cftry>
				<cflock name="DBM_UPGRADE_LCK_#LvarIDgen#" timeout="1">
					<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
					<cfif url.op EQ 3>
						<cfset LvarOBJ.UPGRADE(LvarIDgen,"SCRIPT")>
					<cfelse>
						<cfset LvarOBJ.UPGRADE(LvarIDgen,"UPGRADE")>
					</cfif>
				</cflock>
			<cfcatch type="any">
				<cfrethrow>
				<cf_jdbcquery_open update="yes" datasource="asp">
					<cfoutput>
					update DBMgenP
					   set msg = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="left(#cfcatch.Message#: #cfcatch.Detail#,490)">
						 , stsP = 0
						 , tabsP = 0
					 where IDgen = #LvarIDgen#
					   and (msg is null or stsP <> 0)
					</cfoutput>
				</cf_jdbcquery_open>
			</cfcatch>
			</cftry>
		</cfthread>
		<cfthread action="sleep" duration="2000">
		</cfthread>
		<cfset session.Refrescar = true>
	<cfelseif url.op EQ 5>
		<!--- Visualizar Generación: IDgen --->
	<cfelseif url.op EQ 6 OR url.op EQ 7>
		<!--- Generar y Ejecutar Script: IDgen --->
		<cfparam name="url.IDgen" type="numeric">
		<cfthread name="DBM_UPGRADE_OLD">
			<cftry>
				<cflock name="DBM_UPGRADE_LCK_#url.IDgen#" timeout="1">
					<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
					<cfif url.op EQ 6>
						<cfset LvarOBJ.UPGRADE(url.IDgen,"SCRIPT")>
					<cfelse>
						<cfset LvarOBJ.UPGRADE(url.IDgen,"UPGRADE")>
					</cfif>
				</cflock>
			<cfcatch type="any">
				<cf_jdbcquery_open update="yes" datasource="asp">
					<cfoutput>
					update DBMgenP
					   set msg = <cfqueryparam cfsqltype="cf_sql_varchar" value="left(#cfcatch.Message#: #cfcatch.Detail#,490)">
						 , stsP = 0
						 , tabsP = 0
					 where IDgen = #LvarIDgen#
					   and (msg is null or stsP <> 0)
					</cfoutput>
				</cf_jdbcquery_open>
				<cfrethrow>
			</cfcatch>
			</cftry>
		</cfthread>
		<cfthread action="sleep" duration="2000">
		</cfthread>
		<cfset session.Refrescar = true>
	<cfelseif url.op EQ 8>
		<!--- Inicia modo Verificacion DBM --->
		<cfquery name="rsSQL" datasource="asp">
			select dsn
			  from DBMdsn d
			 where IDdsn = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
		</cfquery>
		<cfquery datasource="asp">
			update DBMdsn
			   set IDverUlt = null
			 where IDdsn = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
		</cfquery>
		<cfquery datasource="#rsSQL.dsn#">
			update DBMgens
			   set IDverFin = -IDverFin
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
			   and IDverFin > 0
		</cfquery>
	<cfelseif url.op EQ 9>
		<!--- Finaliza modo Verificacion DBM --->
		<cfquery name="rsSQL" datasource="asp">
			select dsn
			  from DBMdsn d
			 where IDdsn = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDdsn#">
		</cfquery>
		<cfquery datasource="#rsSQL.dsn#">
			update DBMgens
			   set IDverFin = -IDverFin
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
			   and IDverFin < 0
		</cfquery>
	<cfelseif url.op EQ 40>
		<cfset LvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(url.IDgen,"0000000000") & ".sql">
		<cfheader name="Content-Disposition"	value="attachment;filename=Script.sql">
		<cfcontent type="text/plain" reset="yes" file="#LvarScript#" deletefile="no">
		<cfabort>
	<cfelseif url.op EQ 41>
		<cfset LvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(url.IDgen,"0000000000") & "_exe.txt">
		<cfheader name="Content-Disposition"	value="attachment;filename=Script_exe.txt">
		<cfcontent type="text/plain" reset="yes" file="#LvarScript#" deletefile="no">
		<cfabort>
	<cfelseif url.op EQ 42>
		<cfset LvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(url.IDgen,"0000000000") & "_err.txt">
		<cfheader name="Content-Disposition"	value="attachment;filename=Script_err.txt">
		<cfcontent type="text/plain" reset="yes" file="#LvarScript#" deletefile="no">
		<cfabort>
	</cfif>
	<cflocation url="DBMupgrades.cfm?x=#getTickCount()#">
</cfif>
<cflocation url="DBMupgrades.cfm">