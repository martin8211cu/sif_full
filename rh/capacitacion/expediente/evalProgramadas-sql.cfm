<cfset modoCEvaluaciones = "ALTA">
<cfif not isdefined("Form.NuevoEval")>

	<!--- invierte las fechas cuando es el caso --->
	<cfif datecompare(LSParseDateTime(form.RHEEfdesde), LSParseDateTime(form.RHEEfhasta)) eq 1 >
		<cfset tmp = form.RHEEfdesde >
		<cfset form.RHEEfdesde = form.RHEEfhasta >
		<cfset form.RHEEfhasta = tmp >
	</cfif>

	<cfif isdefined("Form.AltaEval")>
		<cftransaction>
			<!--- 1. Inserta en RHEEvaluacionDes --->
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into RHEEvaluacionDes (Ecodigo, Usucodigo, RHEEdescripcion, RHEEfecha, RHEEfdesde, RHEEfhasta, RHEEestado, RHEEtipoeval, PCid)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEEfdesde)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEEfhasta)#">,
						5,
						'1',
						<cfif isdefined("form.PCid") and len(trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif> )
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">

			<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="expediente"> 
			<cfset expediente.correosEvaluacion(form.DEid, session.Ecodigo,insert.identity)>	

			<!--- 2. Inserta en RHListaEvaldes --->
			<cfquery datasource="#session.DSN#">
				insert into RHListaEvalDes( RHEEid, DEid, RHPcodigo, Ecodigo)
				values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
			</cfquery>

			<!--- 3. Inserta en RHEvaluadoresDes --->
			<!--- 3.1 Inserta la autoevaliuacion --->
			<cfquery datasource="#session.DSN#">
					insert into RHEvaluadoresDes( RHEEid, DEid, DEideval, RHEDtipo )
					values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
								'A')
			</cfquery>

			<!--- 3.2 Inserta la evaluacion del jefe, si tiene--->
			<!--- NOTA: Deberia validar si el cuestionario seleccinado requiere insertar un jefe, por ejemplo si es de clima organizacional no tiene ningun sentido poner un jefe --->
			<!--- 3.2.1 Calcula el jefe del empleado --->
			<cfquery name="jefe" datasource="#session.DSN#">
				select  (select min(l.DEid) from LineaTiempo l where l.RHPid = c.RHPid and getdate() between l.LTdesde and l.LThasta) as jefe, 
					    (select min(l.DEid) from LineaTiempo l where l.RHPid = c2.RHPid and getdate()  between l.LTdesde and l.LThasta) as jefe2
				from LineaTiempo a
				inner join  RHPlazas b
					on a.RHPid = b.RHPid 
				inner join  CFuncional c
				    on b.Ecodigo = c.Ecodigo
				    and b.CFid = c.CFid
				left outer join  CFuncional c2
				 	on c.CFidresp = c2.CFid
				where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between a.LTdesde and a.LThasta
				  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>
			
			<!--- 3.2.2 Inserta el jefe del emplado --->
			<cfif len(trim(jefe.jefe))>
				<cfquery datasource="#session.DSN#" name="rsvalida">
					select count(1) as cant
					from RHEvaluadoresDes
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and DEideval= <cfqueryparam cfsqltype="cf_sql_numeric" value="#jefe.jefe#">
				</cfquery>
				<cfif !rsvalida.cant>
					<cfquery datasource="#session.DSN#">
							insert into RHEvaluadoresDes( RHEEid, DEid, DEideval, RHEDtipo )
							values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#jefe.jefe#">, 
										'J')
					</cfquery>
				</cfif>
			<cfelseif len(trim(jefe.jefe2)) >
				<cfquery datasource="#session.DSN#">
						insert into RHEvaluadoresDes( RHEEid, DEid, DEideval, RHEDtipo )
						values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#insert.identity#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#jefe.jefe2#">, 
									'J')
				</cfquery>
			</cfif>
			
			<!--- Solo para cuestionario por habilidades--->
			<cfif isdefined("form.PCid") and form.PCid EQ -1>
				<cfquery datasource="#session.DSN#">
					insert into RHNotasEvalDes(RHEEid, DEid, RHHid )
					select 	distinct #insert.identity#,
							#form.DEid#,
							a.RHHid
					from RHHabilidades a, RHHabilidadesPuesto b
					where a.RHHid = b.RHHid
						and a.Ecodigo = b.Ecodigo
						and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			<cfelseif isdefined('form.PCid') and form.PCid EQ 0>
			<!--- CUENTIONARIO POR CONOCIMIENTOS --->
				<cfquery datasource="#session.DSN#">
					insert into RHNotasEvalDes(RHEEid, DEid, RHCid )
					select 	#insert.identity#, 
							#form.DEid#, 
							a.RHCid
					from RHConocimientos a, RHConocimientosPuesto b
					where a.RHCid = b.RHCid
					and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			</cfif>
		</cftransaction>	

	<cfelseif isdefined("Form.BajaEval")>
		<cfquery datasource="#session.DSN#">
			delete from RHNotasEvalDes
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from RHEvaluadoresDes
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from RHListaEvalDes
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from RHDEvaluacionDes
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery datasource="#session.DSN#">
			delete from RHEEvaluacionDes
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>

	<cfelseif isdefined("Form.CambioEval")>			
		<!---
		<cf_dbtimestamp datasource="#session.dsn#"
						table="RHEEvaluacionDes"
						redirect="evalProgramadas.cfm"
						timestamp="#form.ts_rversion#"				
						field1="RHEEid" 
						type1="numeric" 
						value1="#form.RHEEid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.Ecodigo#" >
		--->						
						
		<!--- Query para ajuste de datos --->
		<cfquery name="cambioPCid" datasource="#session.DSN#">
			select PCid
			from RHEEvaluacionDes
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<!--- Update del evaluacion --->
		<cfquery datasource="#Session.DSN#">
			update RHEEvaluacionDes
			set  RHEEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEdescripcion#">,
				 RHEEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEEfdesde)#">,
				 RHEEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.RHEEfhasta)#">,
				 PCid = <cfif isdefined("form.PCid") and len(trim(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif> 	
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<!--- Ajuste de datos, solo si cambio el PCid --->
		<!--- 
			Si tenia cuestionario especifico y se cambio a cuestionario por habilidades, debe generar la tabla RHListaEvalDes.
			Si tenia cuestionario por habilidades y se cambio a cuestionario especifico, no se necesita la tabla RHListaEvalDes (borrarla).
			Esta ultima parte no la voy a hacer, para evitar perder las notas si ya se habia evaluado el cuestionario.
		--->
		<cfif isdefined("form.PCid") and (trim(cambioPCid.PCid) neq trim(form.PCid) ) >
			<cftransaction>
			<cfif form.PCid EQ -1 or form.PCid EQ 0>
				<cfquery name="validar" datasource="#session.DSN#">
					select * 
					from RHNotasEvalDes
					where RHEEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEid#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				</cfquery>
				
				<cfif validar.recordcount eq 0 >
					<cfif form.PCid EQ -1>
						<cfquery datasource="#session.DSN#">
							insert into RHNotasEvalDes(RHEEid, DEid, RHCid )
							select 	#form.RHEEid#, 
									#form.DEid#, 
									a.RHCid
							from RHConocimientos a, RHConocimientosPuesto b
							where a.RHCid = b.RHCid
							and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
					<cfelseif form.PCid EQ 0>
						<cfquery datasource="#session.DSN#">
							insert into RHNotasEvalDes(RHEEid, DEid, RHHid )
							select 	distinct #form.RHEEid#,
									#form.DEid#,
									a.RHHid
							from RHHabilidades a, RHHabilidadesPuesto b
							where a.RHHid = b.RHHid
								and a.Ecodigo = b.Ecodigo
								and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
								and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
			</cftransaction>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<form action="expediente.cfm" method="post" name="sqlEvalProgram">
	<input name="DEid" type="hidden" value="#form.DEid#">
	<input type="hidden" name="tab" value="7">
	<cfif isdefined("form.CambioEval")>
		<input name="RHEEid" type="hidden" value="#form.RHEEid#">
	</cfif>
</form>
</cfoutput>	

<html><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></html>
