<cfset parametros = '' >
<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
	<cfset parametros = parametros & "&f_identificacion=#form.f_identificacion#" >
</cfif>
<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
	<cfset parametros = parametros & "&f_asociado=#form.f_asociado#" >
</cfif>
<cfif isdefined("form.f_periodicidad") and len(trim(form.f_periodicidad)) >
	<cfset parametros = parametros & "&f_periodicidad=#form.f_periodicidad#" >
</cfif>

<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">
<cfif isdefined("form.ALTA")>
	<!---  VERIFICA QUE NO HAYA UN CREDITO DE ESTE TIPO Y SEA UN PRESTAMO UNICO --->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select 1
		from ACCreditosAsociado a
		inner join ACCreditosTipo b
			on b.Ecodigo = a.Ecodigo
			and b.ACCTid = a.ACCTid
			and b.ACCTunico = 1
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.ACAid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACAid#">
		  and a.ACCTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ACCTid#">
		  and (a.ACCTcapital - a.ACCTamortizado) > 0
	</cfquery>
	<cfif rsVerifica.RecordCount EQ 0>
		<cftransaction>
			<!--- 1. Crea el credito par ael asociado --->
			<cfset form.ACCAid = plan.insertarCredito( 	form.ACAid,
														form.ACCTid,
														replace(form.ACCTcapital, ',', '', 'all' ),
														replace(form.ACCTplazo, ',', '', 'all' ), 
														replace(form.ACCTtasa, ',', '', 'all' ), 
														replace(form.ACPTtasamora, ',', '', 'all' ), 
														form.ACCTfechaInicio, 
														form.ACCAperiodicidad,
														0,
														form.Tcodigo,
														replace(form.ACCTcuotas, ',', '', 'all' ) ) >
			
			<!--- 2. Crea el plan de pagos --->										
			<cfset plan.crearPlan(	form.ACCAid,
									false,
									session.usucodigo,
									session.Ecodigo,
									session.DSN )> 
		</cftransaction>
	<cfelse>
		<cfthrow detail="Error. Solo puede tener un Crdito de este tipo.">
	</cfif>							
<cfelseif isdefined("form.CAMBIO")>

	<cfif plan.existenPagos(form.ACCAid, session.DSN) eq 0 >
		<cftransaction>
			<!--- 1. borra el plan de pagos actual --->
			<cfset plan.eliminarPlan( form.ACCAid, session.DSN )> 
		
			<!--- 2. modifica el credito --->
			<cfset plan.modificarCredito( form.ACCAid,
											form.ACAid,
											form.ACCTid,
											replace(form.ACCTcapital, ',', '', 'all' ),
											replace(form.ACCTplazo, ',', '', 'all' ), 
											replace(form.ACCTtasa, ',', '', 'all' ), 
											replace(form.ACPTtasamora, ',', '', 'all' ), 
											form.ACCTfechaInicio, 
											form.ACCAperiodicidad,
											0,
											form.Tcodigo,
											replace(form.ACCTcuotas, ',', '', 'all' ) ) >
		
			<!--- 3. vuelve a crear el plan  --->
			<cfset plan.crearPlan(	form.ACCAid,
									false,
									session.usucodigo,
									session.Ecodigo,
									session.DSN )> 
		</cftransaction>							
	</cfif> 								

<cfelseif isdefined("form.BAJA")>
	<cfif plan.existenPagos(form.ACCAid, session.DSN) eq 0 >
		<cftransaction>
			<!--- 1. borra el plan de pagos actual --->
			<cfset plan.eliminarPlan( form.ACCAid, session.DSN )> 
		
			<!--- 2. elimina el credito --->
			<cfset plan.eliminarCredito( form.ACCAid, session.DSN ) >
		</cftransaction>
	
		<cflocation url="creditos-lista.cfm?ACCAid=#form.ACCAid##parametros#" >
	</cfif>

<cfelseif isdefined("form.REGRESAR")>
	<cflocation url="creditos-lista.cfm?1=1#parametros#" >
</cfif>

<cflocation url="creditos.cfm?ACCAid=#form.ACCAid##parametros#" >
