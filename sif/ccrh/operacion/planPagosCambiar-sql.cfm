<cfinclude template="plan-financiamiento.cfm">

<cfquery name="dataMoneda" datasource="#session.DSN#">
	select Mcodigo 
	from Empresas 
	where Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfquery datasource="#session.DSN#"  name="dataDeduccion" maxrows="1">
	select Dreferencia
	from DeduccionesEmpleado
	where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
	  and Ecodigo =  #session.Ecodigo# 
</cfquery>

<cfquery dbtype="query" name="dataCuota" maxrows="1">
	select total
	from calculo
	where pagado = 0
	order by PPnumero
</cfquery>

<cfquery dbtype="query" name="dataCuotaP" maxrows="1">
	select total
	from calculo
	where pagado != 0
	order by PPnumero
</cfquery>

<cfquery name="rsSaldo" dbtype="query" maxrows="1">
	select saldoant
	from calculo
	where pagado = 0
	order by PPnumero
</cfquery>

<cfquery name="calculoNoPagado"  dbtype="query">
	select *
	from calculo
	where pagado = 0
	order by PPnumero
</cfquery>

<cfquery name="CantcalculoNoPagado"  dbtype="query">
	select count(1) as cantidad, sum(total) as total
	from calculo
	where pagado = 0
	order by PPnumero
</cfquery>

<CFIF LEN(TRIM(#dataCuotaP.total#))>
	<CFSET LVAR= #dataCuotaP.total#>
<cfelse>
	<cfset LVAR	= 0>
</CFIF>
<CFIF LEN(TRIM(#CantcalculoNoPagado.total#))>
	<CFSET LVAR2= #CantcalculoNoPagado.total#>
<cfelse>
	<cfset LVAR2	= 0>
</CFIF>
<CFIF LEN(TRIM(#dataCuota.total#))>
	<CFSET LVAR3= #dataCuota.total#>
<cfelse>
	<cfset LVAR3	= 0>
</CFIF>


<cftransaction>

<cfset LvarTotal=#LVAR#+(#LVAR2#)>
<cfset LvarSaldo=CantcalculoNoPagado.total>
<CFIF NOT LEN(TRIM(#LvarSaldo#))>
	<cfset LvarSaldo=0>
</CFIF>
<!---
<cfdump var="#dataCuotaP#">
<cf_dump var="#LvarTotal#">--->
	<!--- Recupera el IDcontable generado para el plan de pagos, para no perderlo y volover a insertarlo --->
	<cfquery name="rsIDcontable" datasource="#session.DSN#" maxrows="1">
		select IDcontable
		from DeduccionesEmpleadoPlan
		where Ecodigo =  #session.Ecodigo# 
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and PPpagado = 0
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from DeduccionesEmpleadoPlan
		where Ecodigo =  #session.Ecodigo# 
		  and Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and PPpagado = 0
	</cfquery>

	<cfloop query="calculoNoPagado">
		<cfquery datasource="#session.DSN#">
			insert into DeduccionesEmpleadoPlan(Did, 
											PPnumero, 
											Ecodigo, 
											PPfecha_vence, 
											PPsaldoant, 
											PPprincipal, 
											PPinteres, 
											PPpagoprincipal, 
											PPpagointeres, 
											PPpagomora, 
											PPfecha_pago, 
											Mcodigo, 
											PPtasa, 
											PPtasamora, 
											PPpagado, 
											PPdocumento,
											IDcontable, 
											BMUsucodigo)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#calculoNoPagado.PPnumero#">,
					 #session.Ecodigo# ,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#calculoNoPagado.fecha#">,  <!--- *** PPfecha_vence --->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(calculoNoPagado.saldoant,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(calculoNoPagado.principal,',','','all')#">, <!--- PPprincipal --->
					<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(calculoNoPagado.intereses,',','','all')#">, <!--- PPinteres --->
					0, <!--- PPpagoprincipal --->
					0, <!--- PPpagointeres --->
					0, <!--- PPpagomora --->
					null,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataMoneda.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Dtasa,',','','all')#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form.Dtasainteresmora,',','','all')#">,
					0,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#dataDeduccion.Dreferencia#">,
					<cfif len(trim(rsIDcontable.IDcontable))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDcontable.IDcontable#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
		</cfquery>
	</cfloop>

	<cfquery datasource="#session.DSN#">
		update DeduccionesEmpleado
		set Dvalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(LVAR3,',','','all')#">,
			Dtasa = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.Dtasa,',','','all')#">,
			Dsaldo = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(LvarSaldo,',','','all')#">,
            Dmonto= <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(LvarTotal,',','','all')#">
		where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and Ecodigo =  #session.Ecodigo# 
	</cfquery>
</cftransaction>

<cfoutput>
<cfset parametros = "?DEid=#form.DEid#&Did=#form.Did#&TDid2=#form.TDid2#" >
<cflocation url="planPagosCambiar.cfm#parametros#">
</cfoutput>