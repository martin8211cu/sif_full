<cfcomponent extends="base">
	<!--- no lo expongo como web service, pero lo tengo junto a los otros por comodidad --->
	<cffunction name="Cumplimiento" returntype="void" access="public">
		<cfargument name="S02CON" type="numeric" required="yes">
		<cfargument name="S01VA2" type="string" default="">
		<cfargument name="EnviarCumplimiento" type="boolean" default="yes">
		<cfargument name="EnviarHistorico" type="boolean" default="yes">
		
		<cfset control_mensaje( 'SIC-0003', 'S02CON=#Arguments.S02CON#,Cumplimiento=#Arguments.EnviarCumplimiento#,Histórico=#Arguments.EnviarHistorico#' )>
		<cfif Arguments.EnviarCumplimiento>
			<!--- notificar cumplimiento con éxito --->
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXS01
					@S01ACC = 'C',
					@S01VA1 = 'A',<!--- (A) cumplida (R) no cumplida --->
					<cfif Len(Arguments.S01VA2)>
					@S01VA2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.S01VA2#">,
					</cfif>
					@S01ORT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">,
					@S01COF = 0
			</cfquery>
		</cfif>
		<cfif Arguments.EnviarHistorico>
			<cfinvoke component="SSXS02" method="Historico"
				S02CON="#Arguments.S02CON#"/>
		</cfif>
	</cffunction>

	<cffunction name="Cumplimiento_Prepago" returntype="void" access="public">
		<cfargument name="S01ACC" type="string" required="yes">
		<cfargument name="S01VA1" type="string" required="yes">
		<cfargument name="S01VA2" type="string" required="yes">
		<cfargument name="SERCLA" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" default="0">
		
		<cfset control_mensaje( 'SIC-0003', 'Cumplimiento Prepago #Arguments.S01ACC#,#Arguments.S01VA1#,#Arguments.S01VA2#,#Arguments.SERCLA#,#Arguments.S02CON#' )>
		<cfquery datasource="SACISIIC">
			exec sp_Alta_SSXS01
				@S01ACC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.S01ACC#">,		
				@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.S01VA1#">,
				@S01VA2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.S01VA2#">,
				@SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SERCLA#">,
				@S01ORT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">,
				@S01COF = 0
		</cfquery>
	</cffunction>
	
	<cffunction name="Error" returntype="void" access="public">
		<cfargument name="S02CON" type="numeric" required="yes">
		<cfargument name="Error" type="string" required="yes">

		
		<cfset enviarcum = false>
		<cfif Len(Arguments.Error) is 0>
			<!--- Código genérico de error --->
			<cfset Arguments.Error = 'ERR-0000'>
		</cfif>

		<cfquery datasource="#session.dsn#" name="getcodigointerfaz">
			if exists(Select 1 from ISBinterfazMensaje
				Where codMensaje =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Error#"> )
			begin
				Select codmensajeinterfaz,mensaje
				from ISBinterfazMensaje
				where codMensaje = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Error#">
			end	else
				Select codmensajeinterfaz,mensaje
				from ISBinterfazMensaje
				where codMensaje = <cfqueryparam cfsqltype="cf_sql_varchar" value="ERR-0000">
		</cfquery>
		
		
		<cfquery datasource="SACISIIC" name="q_orden">
			select S02VA2 from SSXS02
			where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
		</cfquery>	
		
		
		<cfif isdefined('q_orden') and ListFind('O,G', Left(q_orden.S02VA2, 1))>
			 <cfset enviarcum = true>
		</cfif>
		
		<cfquery datasource="SACISIIC">
			if not exists (select 1 from SSIS02
				where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">)
			begin
				begin tran
				
					<cfif enviarcum>
					<!--- notificar complimiento con error --->				
					if not exists (select 1 from SSXS01
						where S01ORT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">)
									
					exec sp_Alta_SSXS01
						@S01ACC = 'C',
						@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="R*#getcodigointerfaz.mensaje#">, <!--- (A) cumplida (R) no cumplida --->
						@S01ORT = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">,
						@S01COF = 0
					</cfif>				
				<!--- mover a la tarea a la tabla de inconsistencias, SSIS02 --->
				insert into SSIS02
					(S02CON, S02FEC, S02FCM, S02ACC, S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER)
				select
					<cfif Len(getcodigointerfaz.codmensajeinterfaz)>
					S02CON, S02FEC, S02FCM, S02ACC, #getcodigointerfaz.codmensajeinterfaz# as S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER
					<cfelse> 
					S02CON, S02FEC, S02FCM, S02ACC,S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER
					</cfif>
				from SSXS02
				where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">

				delete from SSXS02
				where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
					and S02CON in (select S02CON from SACISIIC..SSIS02)
				commit
			end
		</cfquery>
		
	</cffunction>
	
	<cffunction name="Historico" returntype="void" access="public">
		<cfargument name="S02CON" type="numeric" required="yes">
		<cfquery datasource="SACISIIC">
			if not exists (select 1 from SSHS02
				where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">)
			begin
				if exists (select 1 from SSXS02
					where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">)
				begin
					begin tran
					insert into SSHS02
						(S02CON, S02FEC, S02FCM, S02ACC, S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER)
					select
						S02CON, S02FEC, getdate(), S02ACC, S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER
					from SSXS02
					where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
	
					delete from SSXS02
					where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
					and S02CON in (select S02CON from SACISIIC..SSHS02)
					commit
				end else begin
					begin tran
					insert into SSHS02
						(S02CON, S02FEC, S02FCM, S02ACC, S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER)
					select
						S02CON, S02FEC, getdate(), S02ACC, S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER
					from SSIS02
					where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
				
					delete from SSIS02
					where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
					and S02CON in (select S02CON from SACISIIC..SSHS02)
					commit
				end
			end
		</cfquery>
	</cffunction>
	
	<cffunction name="getTarea" returntype="query" output="false" hint="Obtiene los datos de SSXS02 / SSIS02">
		<cfargument name="S02CON" type="numeric" required="yes">
		
		<cfquery datasource="SACISIIC" name="getSSXS02_Q">
			select S02ACC, S02VA1, S02VA2, S02FCM, S02FEC, S02COF
			from SSXS02
			where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
		</cfquery>
		<cfif getSSXS02_Q.RecordCount>
			<cfreturn getSSXS02_Q>
		</cfif>

		<!--- Estas tablas se consultan por los reenvíos --->
		<cfquery datasource="SACISIIC" name="getSSXS02_Q">
			select S02ACC, S02VA1, S02VA2, S02FCM, S02FEC, S02COF
			from SSIS02
			where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
		</cfquery>
		<cfif getSSXS02_Q.RecordCount>
			<cfreturn getSSXS02_Q>
		</cfif>

		<!--- Estas tablas se consultan por los reenvíos --->
		<cfquery datasource="SACISIIC" name="getSSXS02_Q">
			select S02ACC, S02VA1, S02VA2, S02FCM, S02FEC, S02COF
			from SSHS02
			where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
		</cfquery>
		<cfif getSSXS02_Q.RecordCount>
			<cfreturn getSSXS02_Q>
		</cfif>
		
		<cfthrow message="No aparece la tarea con S02CON #Arguments.S02CON#">

	</cffunction>
	
	<cffunction name="reenviar" returntype="void" output="false" hint="Reenvía una tarea inconsistente o del histórico a SSXS02">
		<cfargument name="S02CON" type="numeric" required="yes">
		
		<cfset cols = 'S02CON, S02FEC, S02FCM, S02ACC, S02COF, S02VA1, S02VA2, S02ORT, SERCLA, S02PER, row_version, update_time'>
		<cfquery datasource="SACISIIC">
			begin tran
			insert into SSXS02 (#cols#)
				select #cols#
					from SSHS02 where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
			insert into SSXS02 (#cols#)
				select #cols#
					from SSIS02 where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
			delete   from SSHS02
				where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
					and S02CON in (select S02CON from SACISIIC..SSXS02)
			delete   from SSIS02
				where S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#">
					and S02CON in (select S02CON from SACISIIC..SSXS02)
			commit
		</cfquery>
		
		
	</cffunction>
	
</cfcomponent>