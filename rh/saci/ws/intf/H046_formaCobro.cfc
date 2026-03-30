<cfcomponent hint="Ver SACI-03-H046.doc" extends="base">
	<!---replicarFormaCobro--->
	<cffunction name="replicarFormaCobro" access="public" returntype="void">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="operacion" type="string" default="A" hint="Debe ser A(alta), B(baja) ó C(cambio)">
		<cfargument name="CTid" type="string" required="yes">
		
		<cfset control_inicio( Arguments, 'H046', Arguments.CTid)>

		<cftry>
			<cfif Not ListFind('A,B,C', Arguments.operacion)>
				<cfthrow message="Operación inválida: #Arguments.operacion#. Debe ser A(alta), B(baja) ó C(cambio)" errorcode="ARG-0002">
			</cfif>
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="replicar_q">
				select
					ct.CUECUE,
					cc.CTcobro, cc.CTtipoCtaBco, cc.CTbcoRef,
					cc.CTmesVencimiento, cc.CTanoVencimiento, cc.CTverificadorTC,
					cc.EFid, cc.CTcedulaTH,
					ef.IFCCOD
				from ISBcuenta ct
					left join ISBcuentaCobro cc
						on cc.CTid = ct.CTid
					left join ISBentidadFinanciera ef
						on ef.EFid = cc.EFid
				where ct.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" />
			</cfquery>
			<cfset control_asunto( 'CTid: ' & Arguments.CTid & ', CUECUE:' & replicar_q.CUECUE)>
			<cfif Len(replicar_q.CTcobro) is 0>
				<cfthrow message="La cuenta #Arguments.CTid# no tiene registro de su forma de cobro" errorcode="ISB-0033">
			</cfif>
			<cfif Len(replicar_q.CUECUE) is 0 or replicar_q.CUECUE LE 0>
				<cfthrow message="La cuenta #Arguments.CTid# no ha sido aprobada." errorcode="ISB-0032">
			</cfif>
			
			<!--- Notificación a SIIC del cambio de la forma de cobro --->
			<cfset control_servicio( 'siic' )>
			<cfset S01VA1 = ArrayNew(1)>
			<!--- Operación = (A=Alta) (B=baja) (C=cambio) --->
			<cfset ArrayAppend(S01VA1, Arguments.operacion)>
			<cfset ArrayAppend(S01VA1, replicar_q.CUECUE)>
			<cfset ArrayAppend(S01VA1, replicar_q.CTcobro)>
			<cfset ArrayAppend(S01VA1, replicar_q.CTtipoCtaBco)>
			<cfset ArrayAppend(S01VA1, replicar_q.CTbcoRef)>
			<cfset ArrayAppend(S01VA1, replicar_q.CTmesVencimiento)>
			<cfset ArrayAppend(S01VA1, replicar_q.CTanoVencimiento)>
			<cfset ArrayAppend(S01VA1, replicar_q.CTverificadorTC)>
			<cfif ListFind('2,3', replicar_q.CTcobro) and Len(replicar_q.IFCCOD)>
				<cfset ArrayAppend(S01VA1, replicar_q.IFCCOD)>
			<cfelse>
				<cfset ArrayAppend(S01VA1, 0)>
			</cfif>
			<cfset ArrayAppend(S01VA1, replicar_q.CTcedulaTH)>

			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXS01
					@S01ACC = 'H',
					@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">,
					@S01ORT = 0
			</cfquery>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>		
		
	</cffunction>
</cfcomponent>

