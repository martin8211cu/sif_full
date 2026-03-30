<!---<cf_dump var="#Session.DSN#">--->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("form.GENERAR")>
	<cfset LvarPeriodo = 0>
	<cfset LvarMes = 0>

	<!--- Periodo Auxiliar --->
	<cfquery name="rsPPeriodo" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1
		where Ecodigo =  #session.Ecodigo#
		and Pcodigo = 50
	</cfquery>
	<!--- Mes Auxiliar --->
	<cfquery name="rsPMes" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1
		where Ecodigo =  #session.Ecodigo#
		and Pcodigo = 60
	</cfquery>

	<cfset LvarPeriodo = rsPPeriodo.value>
	<cfset LvarMes = rsPMes.value>

	<!--- 1.	Construir la tabla temporal de Asientos Contables --->
	<!--- 1.1	Crea tabla temporal para crear el asiento #INTARC# --->
	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" returnvariable="INTARC"/>

	<!--- 2.	Llenar la tabla temportal de Asientos Contables  (C)--->

	<cfif isdefined("form.SNCEid") and len(trim(form.SNCEid))>

		<cfquery name="rsDatos" datasource="#Session.DSN#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
			select
			'CCAR' as INTORI,
			1 as INTREL,
			<cf_dbfunction name="sPart"	args="d.CCTcodigo #_Cat# ' - ' #_Cat# d.Ddocumento ;1;20" delimiters=";"> as INTDOC,
			coalesce (d.Dtref, '') #_Cat# ' - ' #_Cat# coalesce (d.Ddocref, '') as INTREF,
			round(d.Dsaldo * coalesce(d.Dtcultrev, 1.00), 2) as INTMON,
			'C' as INTTIP,

			<cf_dbfunction name="sPart"	args="s.SNnombre #_Cat# ' Asiento reversible de estimacion de incobrable : ' #_Cat#  cc.Cformato; 1;80" delimiters=";"> as INTDES,
			'#dateformat(lsparsedatetime(Form.fecha),"yyyymmdd")#' as INTFEC,
			coalesce(d.Dtcultrev, 1.00) as INTCAM,
			#LvarPeriodo# as Periodo,
			#LvarMes# as Mes,
			d.Ccuenta as Ccuenta,
			d.Mcodigo as Mcodigo,
			d.Ocodigo as Ocodigo,
			d.Dsaldo  as INTMOE,
            d.CFid as CFid
			from SNClasificacionE ce
				inner join SNClasificacionD cd
					inner join SNClasificacionSN cs
						inner join SNegocios s
								inner join Documentos d
									inner join CCTransacciones t
										on t.CCTcodigo = d.CCTcodigo
										and t.Ecodigo = d.Ecodigo
										and t.CCTtipo = 'D'
									inner join CContables cc
										on d.Ecodigo = cc.Ecodigo
										and d.Ccuenta = cc.Ccuenta
								on d.Ecodigo = s.Ecodigo
								and d.SNcodigo = s.SNcodigo
						 on s.SNid = cs.SNid
						and s.Ecodigo = #Session.Ecodigo#
					on cs.SNCDid = cd.SNCDid
				on cd.SNCEid = ce.SNCEid
				<cfif isdefined("form.sncdvalor1") and len(trim(form.sncdvalor1)) and isdefined("form.sncdvalor2") and len(trim(form.sncdvalor2))>
					and cd.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.sncdvalor1#">
					and cd.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.sncdvalor2#">
				<cfelseif isdefined("form.sncdvalor1") and len(trim(form.sncdvalor1)) and  isdefined("form.sncdvalor2") and len(trim(form.sncdvalor2)) eq 0>
					and cd.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.sncdvalor1#">
				<cfelseif isdefined("form.sncdvalor2") and len(trim(form.sncdvalor2)) and  isdefined("form.sncdvalor1") and len(trim(form.sncdvalor1)) eq 0>
					and  cd.SNCDvalor <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.sncdvalor2#">
				</cfif>
			where ce.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNCEid#">
				and <cf_dbfunction name="datediff" args="Dvencimiento, #lsparsedatetime(Form.fecha)#"> >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CantDias#">
				and d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(Form.fecha)#">
				and d.Dsaldo > 0

		</cfquery>
	<cfelse>
		<cfquery name="rsDatos" datasource="#Session.DSN#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE, CFid)
			select
			'CCAR' as INTORI,
			1 as INTREL,
			<cf_dbfunction name="sPart"	args="d.CCTcodigo #_Cat# ' - ' #_Cat# d.Ddocumento;1;20" delimiters=";"> as INTDOC,
			coalesce (d.Dtref, '') #_Cat# ' - ' #_Cat# coalesce (d.Ddocref, '') as INTREF,
			round(d.Dsaldo * coalesce(d.Dtcultrev, 1.00), 2) as INTMON,
			'C' as INTTIP,
			<cf_dbfunction name="sPart"	args="s.SNnombre #_Cat# ' Asiento reversible de estimacion de incobrable : ' #_Cat# cc.Cformato;1; 80" delimiters=";"> as INTDES,
			'#dateformat(lsparsedatetime(Form.fecha),"yyyymmdd")#' as INTFEC,
			coalesce(d.Dtcultrev, 1.00) as INTCAM,
			#LvarPeriodo# as Periodo,
			#LvarMes# as Mes,
			d.Ccuenta as Ccuenta,
			d.Mcodigo as Mcodigo,
			d.Ocodigo as Ocodigo,
			d.Dsaldo  as INTMOE,
            d.CFid as CFid
			from SNegocios s
				inner join Documentos d
					inner join CCTransacciones t
						on t.CCTcodigo = d.CCTcodigo
						and t.Ecodigo = d.Ecodigo
						and t.CCTtipo = 'D'
					inner join CContables cc
						on d.Ecodigo = cc.Ecodigo
						and d.Ccuenta = cc.Ccuenta
				 on d.Ecodigo = s.Ecodigo
				and d.SNcodigo = s.SNcodigo
			where s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and d.Dvencimiento < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(Form.fecha)#">
			  and <cf_dbfunction name="datediff" args="Dvencimiento, #lsparsedatetime(Form.fecha)#"> >= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CantDias#">
			  and d.Dsaldo > 0
		</cfquery>
	</cfif>
	 <cfquery datasource="#session.dsn#">
		delete from #INTARC#
		where INTMON = 0.00
	</cfquery>
	<!--- 3.	Llenar la tabla temportal de Asientos Contables (D)--->
	<cfquery name="rsDatos"  datasource="#session.dsn#">
		insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
		select
			'CCAR' as INTORI,
			1 as INTREL,
			INTDOC,
			INTREF,
			sum(INTMON),
			'D' as INTTIP,
			INTDES,
			'#dateformat(lsparsedatetime(Form.fecha),"yyyymmdd")#' as INTFEC,
			avg(INTCAM),
			Periodo as Periodo,
			Mes as Mes,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#"> as Ccuenta,
			Mcodigo as Mcodigo,
			Ocodigo as Ocodigo,
			sum(INTMOE),
            CFid
		from #INTARC#
		group by INTDOC, INTREF, INTTIP, INTDES,  Periodo, Mes, Mcodigo, Ocodigo,CFid
		having sum(INTMON) <> 0.00
	</cfquery>

	<!---
		Retroactivo="#not (periodo_valido eq periodo_contable and mes_valido eq mes_contable)#"
		Edocbase="RC: #Form.fecha#"
	--->
	<cftransaction>
		<!--- 4.	Genera el asiento contable--->
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento"
				Conexion="#session.dsn#"
				method="GeneraAsiento"
				returnvariable="IDcontable"
				Ecodigo="#session.ecodigo#"
				Usuario="#session.Usulogin#"
				Oorigen="CCAR"
				debug="false"
				Eperiodo="#LvarPeriodo#"
				Emes="#LvarMes#"
				Efecha="#Form.fecha#"
				Edescripcion="Generacion de asiento reversible de estimacion de incobrable: #Form.fecha#."
				Ereferencia="ESTIMAC.INCOBRABLES"
				Edocbase="#Form.fecha#"/>

		<!--- 5.	lo marca con un asiento reversible--->
		 <cfquery name="rsDatos" datasource="#session.dsn#">
			Update EContables
			Set ECreversible = 1
			Where IDcontable = #IDcontable#
		</cfquery>
	</cftransaction>

	 <cfquery datasource="#session.dsn#">
		delete from #INTARC#
	</cfquery>
</cfif>
<cflocation url="AsientosReversibles.cfm">
