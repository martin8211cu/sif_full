
<cfparam name="form.CCTcodigo" default="">
<cfparam name="form.Ddocumento" default="">
<cfparam name="form.plazo" type="numeric">
<cfparam name="form.interes" type="numeric">
<cfparam name="form.mora" type="numeric">
<cfparam name="form.tipo" type="string">
<cfset url.CCTcodigo  = form.CCTcodigo>
<cfset url.Ddocumento = form.Ddocumento>
<cfset url.plazo      = form.plazo>
<cfset url.interes    = form.interes>
<cfset url.mora       = form.mora>
<cfset url.tipo       = form.tipo>
<cfset url.pago_inicial = form.pago_inicial>
<cfset url.primerfecha  = form.primerfecha>

<cfquery datasource="#session.dsn#" name="pagos_pendientes">
	select Ecodigo,Pcodigo,CCTcodigo,PPnumero,DPmonto
	from DPagos dp
	where dp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and dp.Doc_CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and dp.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
</cfquery>
<cfif pagos_pendientes.RecordCount>
	<cf_errorCode	code = "50192"
					msg  = "Advertencia: Hay @errorDat_1@ pago(s)<BR> para este documento que aún no ha sido aplicado. <BR> No podrá cambiar el plan de pagos mientras haya pagos en proceso. "
					errorDat_1="#pagos_pendientes.RecordCount#"
	>
</cfif>

<cftransaction>
<cfquery datasource="#session.dsn#" name="documento">
	select d.CCTcodigo, Mcodigo, Dfecha, Dsaldo
	from Documentos d
		join CCTransacciones cct
			on cct.Ecodigo = d.Ecodigo
			and cct.CCTcodigo = d.CCTcodigo
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and d.Dsaldo != 0
	  and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
	  and cct.CCTtipo = 'D'
</cfquery>

<cfquery datasource="#session.dsn#" name="plan_pagos">
	select PPnumero,coalesce(PPfecha_pago,PPfecha_vence) as fecha,
		PPsaldoant             as saldoant,
		PPprincipal            as principal,
		PPinteres              as intereses,
		PPprincipal+PPinteres  as total,
		PPsaldoant-PPprincipal as saldofinal,
		1 as pagado
	from PlanPagos pp
	where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and pp.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and pp.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
	  and pp.PPfecha_pago is not null
	order by PPnumero
</cfquery>
<cfinclude template="refinanciar.cfm">

<cfquery datasource="#session.dsn#">
	delete from PlanPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
	  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
	  and PPfecha_pago is null
</cfquery>
<cfloop query="calculo">
	<cfif not calculo.pagado>
		<cfquery datasource="#session.dsn#">
			insert into PlanPagos (
				Ecodigo, CCTcodigo, Ddocumento, PPnumero,
				PPfecha_vence, PPsaldoant, PPprincipal, PPinteres,
				PPpagoprincipal, PPpagointeres, PPpagomora, PPfecha_pago,
				Mcodigo, PPtasa, PPtasamora)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#calculo.PPnumero#">,
				
				<cfqueryparam cfsqltype="cf_sql_date"    value="#calculo.fecha#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#calculo.saldoant#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#calculo.principal#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#calculo.intereses#">,
				0,0,0,null,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#documento.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.interes#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.mora#">)
		</cfquery>
	</cfif>
</cfloop>
</cftransaction>
<cflocation url="index.cfm?#params#" addtoken="no">

