<cfcomponent>
	<cffunction name='CierreMes' access='public' output='true'>
		<cfargument name='Ecodigo' type='numeric' required='true'>		
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='periodo' type='numeric' required='yes'>
		<cfargument name='mes' type='numeric' required='yes'>

		<!--- Valida que existan Activos --->
		<cfquery name="rsdp" datasource="#arguments.conexion#">
			select count(1) as cant from Activos
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfif rsdp.recordcount eq 0 or rsdp.cant eq 0>
			<cfreturn>
		</cfif>

		<!--- Valida que no existan transacciones (depreciacion, revaluacion , mejora, retiro) sin aplicar--->
		<cfquery name="rs_AGTP_Con_Det" datasource="#arguments.conexion#">
			select count(1) as Cantidad
			from AGTProceso 
			where AGTProceso.Ecodigo     = #arguments.Ecodigo#
			  and AGTProceso.AGTPperiodo = #arguments.Periodo#
			  and AGTProceso.AGTPmes     = #arguments.Mes#
			  and AGTPestadp < 4
			  and (select count(1) from ADTProceso b where AGTProceso.AGTPid = b.AGTPid) > 0
		</cfquery>

		<cfif rs_AGTP_Con_Det.RecordCount gt 0 and rs_AGTP_Con_Det.Cantidad GT 0>
			<cf_errorCode	code = "50910" msg = "Error en Cierre de Activos Fijos!, Existen transacciones de Activos Fijos, para este Periodo Mes, sin Aplicar!, Proceso Cancelado!">
		</cfif>

		<!--- Borra transacciones (depreciacion, revaluacion , mejora, retiro) en proceso que no tengan activos asociados --->
		<cfquery name="rs_Borra_AGTP_Sin_Det" datasource="#arguments.conexion#">
			delete from AGTProceso 
			where AGTProceso.Ecodigo     = #arguments.Ecodigo#
			  and AGTProceso.AGTPperiodo = #arguments.Periodo#
			  and AGTProceso.AGTPmes     = #arguments.Mes#
			  and AGTPestadp < 4
			  and (select count(1) from ADTProceso b where AGTProceso.AGTPid = b.AGTPid) = 0
		</cfquery>

		<!--- actualizar el mes --->
		<cfset nuevoMes = ((arguments.Mes mod 12) + 1)>
		<cfset nuevoPeriodo = iif(nuevoMes is 1,arguments.periodo + 1,arguments.periodo)>

		<!--- Borra saldos del siguiente mes *** NO DEBERÍAN EXISTIR *** --->
		<cfquery name="rs_Traslada_Saldos" datasource="#arguments.conexion#">
			delete from AFSaldos
			where Ecodigo 	 = #arguments.Ecodigo#
			  and AFSperiodo = #nuevoPeriodo#
			  and AFSmes     = #nuevoMes#
		</cfquery>

		<!--- Se pasan los saldos de los activos con saldo de vida útil del periodo / mes  por cerrar al nuevo periodo / mes --->
		<cfquery name="rs_Traslada_Saldos" datasource="#arguments.conexion#">
			insert into AFSaldos (
				Ecodigo, Aid, CFid, AFSperiodo, 
				AFSmes, AFSvutiladq, AFSvutilrev, AFSsaldovutiladq, 
				AFSsaldovutilrev, AFSvaladq, AFSvalmej, AFSvalrev, 
				AFSdepacumadq, AFSdepacummej, AFSdepacumrev, AFSmetododep, 
				AFSdepreciable, AFSrevalua, Ocodigo, AFCcodigo, 
				ACcodigo, ACid)
			select 
				s.Ecodigo, s.Aid, s.CFid, #nuevoPeriodo#, 
				#nuevoMes#, s.AFSvutiladq, s.AFSvutilrev, s.AFSsaldovutiladq, 
				s.AFSsaldovutilrev, s.AFSvaladq, s.AFSvalmej, s.AFSvalrev, 
				s.AFSdepacumadq, s.AFSdepacummej, s.AFSdepacumrev, s.AFSmetododep, 
				s.AFSdepreciable, s.AFSrevalua, s.Ocodigo, s.AFCcodigo, 
				s.ACcodigo, s.ACid
			from AFSaldos s
				inner join Activos a
					on a.Aid = s.Aid
					and a.Astatus < 1
			where s.Ecodigo = #arguments.Ecodigo#
			and s.AFSperiodo = #arguments.Periodo#
			and s.AFSmes = #arguments.Mes#
			
		</cfquery>
	</cffunction>
</cfcomponent>