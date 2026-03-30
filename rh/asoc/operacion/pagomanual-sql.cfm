<cfset parametros = '' >
<cfif isdefined("form.f_identificacion") and len(trim(form.f_identificacion)) >
	<cfset parametros = parametros & "&f_identificacion=#form.f_identificacion#" >
</cfif>
<cfif isdefined("form.f_asociado") and len(trim(form.f_asociado)) >
	<cfset parametros = parametros & "&f_asociado=#form.f_asociado#" >
</cfif>
<cfif isdefined("form.pagenNum_lista0") and len(trim(form.pagenNum_lista0)) >
	<cfset parametros = parametros & "&pagenNum_lista0=#form.pagenNum_lista0#" >
</cfif>

<cfinvoke component="rh.asoc.Componentes.RH_PagoExtraordinario" method="init" returnvariable="pago">
<cfinvoke component="rh.asoc.Componentes.RH_PlanPagos" method="init" returnvariable="plan">
<cfinvoke component="rh.asoc.Componentes.ACDeducciones" method="init" returnvariable="ded">
<cfif isdefined("form.Aplicar")>
	<!--- 0. Obtiene datos necesarios para los calculos --->
	<cfset fecha = LSdateformat(now(), 'dd/mm/yyyy') >
	<cfset cuotas = replace(form.ACCRPEmonto, ',', '', 'all') >
	<cfset data_credito = plan.obtenerCredito( form.ACCAid, session.DSN ) >

	<cftransaction >
		<!--- 1. recupera el id y el monto de las cuotas a cancelar --->
		<cfset data_cuotas = plan.obtenerCuotasAdelanto( form.ACCAid, cuotas, plan.obtenerParametro(session.Ecodigo, 40, session.DSN), session.DSN ) >
		<cfloop query="data_cuotas">
			<!--- 2. actualiza el acumulado de amortizacion para el credito  --->
			<cfset plan.actualizarAmortizacion(form.ACCAid, data_cuotas.amortizacion, session.DSN) >
			
			<!--- 3. modifca el plan de pagos para registrar el pago de las cuotas --->
			<cfset plan.modificarPlan(form.ACCAid, data_cuotas.ACPPid, LSDateFormat(now(), 'dd/mm/yyyy'), 'S', 'M', session.DSN ) >

			<!--- 4. modifca el saldo de la deduccion --->
			<cfif len(trim(data_cuotas.Did))>
				<cfset ded.modificarSaldo( data_cuotas.Did, data_cuotas.cuota ) >
			</cfif>
		</cfloop>
		<!--- VERIFICAR SI EL CREDITO SE ESTA CANCELANDO--->
		<cfquery name="rsCreditoCancelado" datasource="#session.DSN#">
			select 1
			from ACCreditosAsociado a
			where ACCAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACCAid#">
			and (a.ACCTcapital - a.ACCTamortizado) <= 0
		</cfquery>
		<cfif rsCreditoCancelado.REcordCount>
			<cfset ded.Inactivar(data_cuotas.Did)>
		</cfif>
	</cftransaction>
	<cfset parametros = parametros & "&ACCAid=#form.ACCAid#&ok=ok" >
</cfif>

<cflocation url="pagomanual.cfm?ACAid=#form.ACAid##parametros#" >