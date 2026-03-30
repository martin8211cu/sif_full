<cfcomponent extends="base">
	<cffunction name="solicitud_sobres_prepagos" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes" default="siic">	
		<cfargument name="SOid" type="string" required="yes">
										
		<cfset control_inicio( Arguments, 'H019','##Solicitud= ' & Arguments.SOid)>
		<cftry>
			<cfset control_servicio( 'saci' )>
	
				<cfquery datasource="#session.dsn#" name="querydatos">				
					Select 
					 AGid
					, SOfechasol
					, SOtipo
					, SOestado
					, SOfechapro
					, SOtiposobre
					, SOcantidad
					, isnull(SOgenero,'N') as SOgenero
					, SOPrefijo
					, isnull(SOobservaciones,'-') as SOobservaciones
						from  ISBsolicitudes
					Where SOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SOid#" null="#Len(Arguments.SOid) Is 0#">
				</cfquery>
<!--- S01VA1 = código_solicitud*fecha_solicitud*código_de_agente*Tipo_de_solicitud*tipo_sobre*tipo_de_genero*cantidad*usuario_del_portal*Observaciones

				1.	Tipo_de_solicitud = (P) prepago (S) sobre
				2.	Genero del sobre  :  (A) acceso (C) correo (U) ambos (N) no aplica
				3.	Tipo de sobre = (F) físico (V) virtual 
				3.	Tipo de sobre = Prefijo cuando es un Prepago --->
			
				<cfset fecha_solicitud = dateformat(querydatos.SOfechasol,'yyyymmdd')>
				
				<cfset S01VA1 = ArrayNew(1)>
					<cfset ArrayAppend(S01VA1, Arguments.SOid)>
					<cfset ArrayAppend(S01VA1, fecha_solicitud)>
					<cfset ArrayAppend(S01VA1, querydatos.AGid)>
					<cfset ArrayAppend(S01VA1, querydatos.SOtipo)>
					<cfif querydatos.SOtipo is 'S'>					  			<!--- Tipo de sobre = (F) físico (V) virtual --->
						<cfset ArrayAppend(S01VA1, querydatos.SOtiposobre)>
					<cfelseif querydatos.SOtipo is 'P'>
						<cfset ArrayAppend(S01VA1, trim(querydatos.SOPrefijo))> <!---Tipo de sobre = Prefijo cuando es un Prepago --->
					<cfelse> 
						<cfthrow message="El tipo de solicitud debe ser  ('P','S')">
					</cfif>
					<cfset ArrayAppend(S01VA1, querydatos.SOgenero)>
					<cfset ArrayAppend(S01VA1, querydatos.SOcantidad)>
					<cfset ArrayAppend(S01VA1, "#session.Usulogin#")>
					<cfset ArrayAppend(S01VA1, querydatos.SOobservaciones)>
					
					<cfquery datasource="SACISIIC">
						exec sp_Alta_SSXS01
							@S01ACC = '8',
							@S01VA1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(S01VA1, '*')#">
					</cfquery>

			<cfset control_final( )>
		<cfcatch type="any">
			<!--- error --->
			<cfset control_catch( cfcatch )>
		</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>