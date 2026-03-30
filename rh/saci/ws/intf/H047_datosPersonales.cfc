<cfcomponent hint="Ver SACI-03-H046.doc" extends="base">
	<!---replicarDatosPersonales--->
	<cffunction name="replicarDatosPersonales" access="public" returntype="void">
		<cfargument name="origen" type="string" default="saci">
		<cfargument name="operacion" type="string" default="A" hint="Debe ser A(alta), B(baja) ó C(cambio)">
		<cfargument name="Pquien" type="string" required="yes">
		
		<cfset control_inicio( Arguments, 'H047', Arguments.Pquien)>

		<cftry>
			<cfif Not ListFind('A,B,C', Arguments.operacion)>
				<cfthrow message="Operación inválida: #Arguments.operacion#. Debe ser A(alta), B(baja) ó C(cambio)" errorcode="ARG-0002">
			</cfif>
			<cfset control_servicio( 'saci' )>
			<cfquery datasource="#session.dsn#" name="replicar_q">
				select 
					p.Pid, 
					case when tp.Pfisica = 0 then 'J' else 'F' end as personeria,
					p.Pnombre, p.Papellido,
					p.Papellido2, p.PrazonSocial, p.AEactividad, p.CPid, p.Papdo,
					coalesce ( loc3.LCcod, '9') as provincia,
					coalesce ( loc2.LCcod, '99') as canton,
					coalesce ( loc1.LCcod, '99') as distrito,
					p.Pdireccion, p.Pbarrio,
					p.Ptelefono1, p.Ptelefono2, p.Pfax, p.Pemail, p.Pfecha
				from ISBpersona p
					left join ISBtipoPersona tp
						on tp.Ppersoneria = p.Ppersoneria
					left join Localidad loc1
						on loc1.LCid = p.LCid
					left join Localidad loc2
						on loc2.LCid = loc1.LCidPadre
					left join Localidad loc3
						on loc3.LCid = loc2.LCidPadre
				where p.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" />
			</cfquery>
			
			<!--- Notificación a SIIC del cambio de la forma de cobro --->
			<cfset control_servicio( 'siic' )>
			<cfset S01VA1 = ArrayNew(1)>
			<!--- Operación = (A=Alta) (B=baja) (C=cambio) --->
			<cfset ArrayAppend(S01VA1, Arguments.operacion)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pid)>
			<cfset ArrayAppend(S01VA1, replicar_q.personeria)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pnombre)>
			<cfset ArrayAppend(S01VA1, replicar_q.Papellido)>

			<cfset ArrayAppend(S01VA1, replicar_q.Papellido2)>
			<cfset ArrayAppend(S01VA1, replicar_q.PrazonSocial)>
			<cfset ArrayAppend(S01VA1, replicar_q.AEactividad)>
			<cfset ArrayAppend(S01VA1, replicar_q.CPid)>
			<cfset ArrayAppend(S01VA1, replicar_q.Papdo)>

			<cfset ArrayAppend(S01VA1, replicar_q.provincia)>
			<cfset ArrayAppend(S01VA1, replicar_q.canton)>
			<cfset ArrayAppend(S01VA1, replicar_q.distrito)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pdireccion)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pbarrio)>

			<cfset ArrayAppend(S01VA1, replicar_q.Ptelefono1)>
			<cfset ArrayAppend(S01VA1, replicar_q.Ptelefono2)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pfax)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pemail)>
			<cfset ArrayAppend(S01VA1, replicar_q.Pfecha)>

			<cfquery datasource="SACISIIC">
				exec sp_Alta_SSXS01
					@S01ACC = '2',
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

