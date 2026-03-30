<cfcomponent hint="Ver SACI-03-H045.doc" extends="base">
	<!---replicarAgente--->
	<cffunction name="replicarAgente" access="public" returntype="void">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="operacion" type="string" default="A" hint="Debe ser A(alta), B(baja) ó C(cambio)">
		<cfargument name="AGid" type="string" required="yes">
		<cfargument name="login_principal" type="string" default="" hint="Requerido para el subject">
		<cfargument name="S01CON_principal" type="numeric" default="0">
		
		<cfset control_inicio( Arguments, 'H045a', Arguments.login_principal)>

		<cftry>
			<cfif Not ListFind('A,B,C', Arguments.operacion)>
				<cfthrow message="Operación inválida: #Arguments.operacion#. Debe ser A(alta), B(baja) ó C(cambio)" errorcode="ARG-0002">
			</cfif>
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="activarAgente_q">
				select p.Pnombre || ' ' || p.Papellido || ' ' || p.Papellido2 as nombre,
					p.Pid,
					case when a.AAinterno = 1 then 'I' else 'E' end as VENTIP,
					case when a.Habilitado = 1  then 'A' else 'B' end as VENEST,
					coalesce (a.AAplazoDocumentacion, 0) as AAplazoDocumentacion,
					coalesce (a.AAcomisionTipo, '1') as AAcomisionTipo,
					coalesce (a.AAcomisionPctj, 0) as AAcomisionPctj,
					coalesce (a.AAcomisionMnto, 0) as AAcomisionMnto,
					coalesce (a.AAinterno, 0) as AAinterno,
					a.Habilitado,
					a.CTidAcceso
				from ISBpersona p
					join ISBagente a
						on a.Pquien = p.Pquien
				where a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" />
			</cfquery>
			
			<cfif Arguments.operacion neq 'A'>
				<cfif Not Len(Arguments.login_principal)>
					<!--- Buscar el login principal --->
					<cfset control_servicio( 'saci' )>
					<cfquery datasource="#session.dsn#" name="login_buscar" maxrows="1">
						select top 1 l.LGlogin
						from ISBlogin l
							join ISBproducto p
								on p.Contratoid = l.Contratoid
						where p.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#activarAgente_q.CTidAcceso#">
						order by case when Habilitado = 1 then 0 else 1 end, LGnumero
					</cfquery>
					<cfif login_buscar.RecordCount is 0>
						<cfthrow message="El agente no tiene login principal, no se puede replicar">
					</cfif>
					<cfset Arguments.login_principal = login_buscar.LGlogin>
					<cfset control_asunto( Arguments.login_principal )>
				</cfif>
			</cfif>
			
			<!--- Notificación a SIIC de la inclusión del vendedor --->
			<!--- Tabla de conversiones
			VENTIP = (I) interno  – (E) externo - ISBagente.AAinterno (1=interno) (0=otro)
			VENEST = (A) activo - (B) borrado – ISBagente.Habilitado = (1=activo) (0=inactivo) (2=borrado)
			--->
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC">
				if not exists (select 1 from SSXVEN
					where VENCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">)
				begin
					insert into SSXVEN (VENCOD, VENDES, VENTIP, VENEST)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#activarAgente_q.nombre#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#activarAgente_q.VENTIP#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#activarAgente_q.VENEST#"> )
				end
			</cfquery>
			<cfset S01VA1 = ArrayNew(1)>
			<!--- Operación = (A=Alta) (B=baja) (C=cambio) --->
			<cfset ArrayAppend(S01VA1, Arguments.operacion)>
			<!--- S01CON = Se refiere al código de la tarea N
				 cuando se ingresa la cuenta de acceso del agente. --->
			<cfset ArrayAppend(S01VA1, Arguments.S01CON_principal)>
			<cfset ArrayAppend(S01VA1, Arguments.AGid)>
			<cfset ArrayAppend(S01VA1, Trim(Replace(activarAgente_q.nombre, '*', ' ', 'all')))>
			<cfset ArrayAppend(S01VA1, activarAgente_q.Pid)>
			<cfset ArrayAppend(S01VA1, Replace(session.Usulogin, '*', ' ', 'all'))>
			<cfset ArrayAppend(S01VA1, activarAgente_q.AAplazoDocumentacion)>
			<cfset ArrayAppend(S01VA1, activarAgente_q.AAcomisionTipo)>
			<cfset ArrayAppend(S01VA1, activarAgente_q.AAcomisionPctj)>
			<cfset ArrayAppend(S01VA1, activarAgente_q.AAcomisionMnto)>
			<cfset ArrayAppend(S01VA1, activarAgente_q.AAinterno)>
			<cfset ArrayAppend(S01VA1, activarAgente_q.Habilitado)>
			
			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXS01
					@S01ACC = 'J',
					@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">,
					@SERCLA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login_principal#">,
					<cfif Arguments.operacion eq 'A'>
						@S01COF = -501,
					<cfelse>
						@S01COF = 0,
					</cfif>
					@S01ORT = 0
			</cfquery>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>		
		
	</cffunction>
	<!---aprobacionServicios--->
	<cffunction name="aprobacionServicios" access="public" returntype="void">
		<cfargument name="origen" type="string" default="siic">
		<cfargument name="AGid" type="string" required="yes">
		<cfargument name="CUECUE" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H045b', 'Codigo de Agente: ' & Arguments.AGid )>
		<cftry>
			<cfset control_servicio( 'saci' )>
			<cftransaction>
				<cfquery datasource="#session.dsn#" name="agente">
					select CTidFactura
					from ISBagente
					where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
				</cfquery>
				<cfif agente.RecordCount is 0>
					<cfthrow message="No hay ningún agente registrado con el código #Arguments.AGid#" errorcode="ISB-0031">
				</cfif>
				<cfif Not Len(agente.CTidFactura)>
					<cfthrow message="El agente no tiene CTidFacturacion. AGid:#Arguments.AGid#" errorcode="ISB-0031">
				</cfif>
				<cfquery datasource="#session.dsn#" name="update_q">
					update ISBcuenta
					set CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUE#">
					, CTmodificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					where CTid = 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#agente.CTidFactura#">
					select @@rowcount as update_rowcount
				</cfquery>
				<cfif update_q.update_rowcount is 0>
					<cfset control_mensaje( 'ISB-0006', 'ISBcuenta con CTid #agente.CTidFactura#' )>
				</cfif>
			</cftransaction>
			<cfset control_servicio( 'siic' )>
			<cfquery datasource="SACISIIC">
				if not exists (select 1 from SSXVCT
					where VENCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">)
				begin
					insert into SSXVCT (VENCOD, CUECUE, SSCCTA)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AGid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CUECUE#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#agente.CTidFactura#">)
				end
			</cfquery>
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"
				EnviarHistorico="true"
				EnviarCumplimiento="false"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>

