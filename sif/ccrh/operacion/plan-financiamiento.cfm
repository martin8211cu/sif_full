<!---

DeduccionesEmpleadoPlan

Did			Llave Deduccion del Empleado
PPnumero		Numero para identificar el Plan
PPfecha_vence
PPsaldoant		Saldo Anterior a Cuota Actual
PPprincipal		Cuota de Amortizacion al Principal
PPinteres		Interes que se debe cobrar
PPpagoprincipal		Amortizacion Pagada
PPpagointeres		Interes Pagado
PPpagomora		Monto pagado por Mora
PPfecha_pago
Mcodigo			Moneda de la Deduccion
PPtasa
PPtasamora
PPpagado		Bandera (0 = No Pagado, 1 = Pagado, 2 = Pago Extraordinario)
PPdocumento
IDcontable		Llave del Asiento Contable generado
DEPextraordinario	Bandera para indicar si la cuota se pago mediante un pago extraordinario

Cuota que se cobra por periodo = PPprincipal + PPinteres

--->

<!--- <cfdump var="#session.deduccion_empleado#">
<cfabort> --->

<!--- esta en session --->
<cfset periodicidad = ArrayNew(1)>
<cfset periodicidad[1] = 's' >
<cfset periodicidad[2] = 'q' >  <!--- *** qu epasa cuando es bisemana --->
<cfset periodicidad[3] = 'q' >
<cfset periodicidad[4] = 'm' >

<!--- query --->
<cfset calculo = QueryNew("PPnumero,fecha,saldoant,principal,intereses,total,saldofinal,pagado,img")>

<cfif isdefined("btnRecalcular") or isdefined("btnModificar")>
	<cfparam name="saldo" type="numeric" default="#form.Dmonto#" >
	<cfparam name="url.plazo"   type="numeric" default="#form.Dnumcuotas#" >
	<cfparam name="url.interes" type="numeric" default="#form.Dtasa#">
	<cfparam name="url.tipo"    default="#periodicidad[form.Dperiodicidad+1]#">
	<cfparam name="url.pago_inicial" type="string" default="0">
	<cfparam name="url.primerfecha" type="string" default="#form.PPfecha_vence#">
	<cfset fecha = LSParseDateTime(url.primerfecha) > <!--- *** --->

	<!--- inserta los registros que ya fueron pagados, incluyendo los extraordinarios --->
	<cfquery datasource="#session.dsn#" name="plan_pagos">
		select PPnumero, coalesce(PPfecha_pago,PPfecha_vence) as fecha,
			PPfecha_pago,
			PPfecha_vence,
			PPsaldoant             as saldoant,
			PPprincipal            as principal,
			PPinteres              as intereses,
			PPprincipal+PPinteres  as total,
			PPsaldoant-PPprincipal as saldofinal,
			PPpagado as pagado
		from DeduccionesEmpleadoPlan pp
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and pp.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		  and pp.PPfecha_pago is not null
		order by PPnumero
	</cfquery>

	<cfloop query="plan_pagos">
		<cfif plan_pagos.pagado>
			<cfset QueryAddRow(calculo,1)>
			<cfset QuerySetCell(calculo,'PPnumero'  , plan_pagos.PPnumero)>
			<cfset QuerySetCell(calculo,'fecha'     , plan_pagos.fecha)>
			<cfset QuerySetCell(calculo,'saldoant'  , LSNumberFormat(plan_pagos.saldoant, '9.0000'))>
			<cfset QuerySetCell(calculo,'principal' , LSNumberFormat(plan_pagos.principal, '9.0000'))>
			<cfset QuerySetCell(calculo,'intereses' , LSNumberFormat(plan_pagos.intereses, '9.0000'))>
			<cfset QuerySetCell(calculo,'total'     , LSNumberFormat(plan_pagos.total, '9.0000'))>
			<cfset QuerySetCell(calculo,'saldofinal', LSNumberFormat(plan_pagos.saldofinal, '9.0000'))>
			<cfset QuerySetCell(calculo,'pagado'    , plan_pagos.pagado)>
			<cfset QuerySetCell(calculo,'img'       , "<img src=../../imagenes/w-check.gif border=0 width=16 height=16>")>
			<cfif fecha lt plan_pagos.fecha>
				<cfset fecha = plan_pagos.fecha>
			</cfif>
		</cfif>
	</cfloop>

<cfelse>
	
	<!---
	<cfparam name="saldo"   type="numeric" default="#val(session.deduccion_empleado.Dmonto)#" >
	<cfparam name="url.plazo"   type="numeric" default="#session.deduccion_empleado.Dnumcuotas#" >
	<cfparam name="url.interes" type="numeric" default="#session.deduccion_empleado.Dtasa#">
	<cfparam name="url.tipo" default="#periodicidad[session.deduccion_empleado.Dperiodicidad+1]#">
	<cfparam name="url.pago_inicial" type="string" default="0">
	<cfparam name="url.primerfecha" type="string" default="#session.deduccion_empleado.Dfechaini#">
	<cfset fecha = url.primerfecha> <!--- *** --->
	<!--- <cfset fecha=LSParseDateTime(url.primerfecha) >  --->
	--->

	<cfset saldo = val(session.deduccion_empleado.Dmonto)>
	<cfset url.plazo = session.deduccion_empleado.Dnumcuotas>
	<cfset url.interes = session.deduccion_empleado.Dtasa>
	<cfset url.tipo = periodicidad[session.deduccion_empleado.Dperiodicidad+1]>
	<cfset url.pago_inicial = 0>
	<cfset url.primerfecha = session.deduccion_empleado.Dfechaini>
	<cfset fecha = url.primerfecha>


</cfif>

<cfif url.tipo is 'm'>
	<cfset interes_div = url.interes / 1200>
	<cfset dateadd_part = 'm'>
	<cfset dateadd_cant = 1>
<cfelseif url.tipo is 'q'>
	<cfset interes_div = url.interes / 2400>
	<cfset dateadd_part = 'ww'>
	<cfset dateadd_cant = 2>
<cfelseif url.tipo is 's'>
	<cfset interes_div = url.interes / 5200>
	<cfset dateadd_part = 'ww'>
	<cfset dateadd_cant = 1>
<cfelse>
	<cf_errorCode	code = "50193"
					msg  = "tipo invalido: @errorDat_1@"
					errorDat_1="#url.tipo#"
	>
</cfif>

<cfset plazo = Abs(Round(url.plazo))>

<cfif not IsNumeric(plazo) or not IsNumeric(interes_div)>
	<cf_errorCode	code = "50194" msg = "Parámetros inválidos">
</cfif>

<cfif Len(url.pago_inicial)>
	<cfset url.pago_inicial = Replace(url.pago_inicial,',','','all')>
	<cfif isnumeric(url.pago_inicial) and Len(url.pago_inicial) and url.pago_inicial gt 0>
		<cfset cuota = url.pago_inicial>
		<cfset interes_mes = 0>

		<cfset QueryAddRow(calculo,1)>
		<cfset interes_mes = 0>
		<cfset QuerySetCell(calculo,'PPnumero'  ,  calculo.RecordCount)>
		<cfset QuerySetCell(calculo,'fecha'     ,  fecha)>
		<cfset QuerySetCell(calculo,'saldoant'  ,  LSNumberFormat(saldo, '9.0000'))>
		<cfset QuerySetCell(calculo,'principal' ,  LSNumberFormat((cuota - interes_mes), '9.0000'))>
		<cfset QuerySetCell(calculo,'intereses' ,  LSNumberFormat(interes_mes, '9.0000'))>
		<cfset QuerySetCell(calculo,'total'     ,  LSNumberFormat(cuota, '9.0000'))>
		<cfset saldo = saldo + interes_mes - cuota>
		<cfset QuerySetCell(calculo,'saldofinal',  LSNumberFormat(saldo, '9.0000'))>
		<cfset QuerySetCell(calculo,'pagado'    ,  0)>
		<cfset QuerySetCell(calculo,'img'       , " ")>
	</cfif>
</cfif>

<cfif plazo le 0>
	<cfset cuota = saldo>
	<cfset dateadd_part = 'd'>
	<cfset dateadd_cant = 0>
	<cfset plazo = 1>
	<cfset interes_div = 0>
<cfelseif interes_div is 0>
	<cfset cuota = saldo / plazo>
<cfelse>
	<cfset cuota = saldo / ((1 - (  (1+interes_div) ^  -plazo    ))/interes_div)>
</cfif>
<cfset cuota = Round(cuota*100)/100>

<!--- Configuración de variable inicial para el cálculo de las fechas de los calendarios de pago para los planes de financiamiento --->
<cfif isdefined("btnRecalcular") or isdefined("btnModificar")>
	<cfset periodicidad = form.Dperiodicidad>
<cfelse>
	<cfset periodicidad = session.deduccion_empleado.Dperiodicidad>
</cfif>

<!--- Obtener una fecha antes del pago de la primer cuota para empezar a realizar los cálculos de cada cuota del plan de financiamiento --->
<cfset Fdesde = fecha>
<cfif periodicidad EQ "0"> 		<!--- Semanal --->
	<cfset Fdesde = DateAdd("d", -6, fecha)>
<cfelseif periodicidad EQ "1">	<!--- Bisemanal --->
	<cfset Fdesde = DateAdd("d", -13, fecha)>
<cfelseif periodicidad EQ "2">	<!--- Quincenal --->
	<cfif Day(fecha) EQ "15">
		<cfset Fdesde = DateAdd("d", -14, fecha)>
	<cfelse>
		<cfset Fdesde = CreateDate(Year(fecha), Month(fecha), 16)>
	</cfif>
<cfelseif periodicidad EQ "3">	<!--- Mensual --->													
	<cfset Fdesde = CreateDate(Year(fecha), Month(fecha), 1)>
</cfif>

<cfloop from="1" to="#plazo#" index="i">
	<cfif saldo is 0><cfbreak></cfif>

	<cfset QueryAddRow(calculo,1)>

	<cfset interes_mes = Round(saldo * interes_div*100)/100>

	<!--- Calculo de las fechas para los calendarios de pago del financiamento, tomado de calendario de pagos de los tipos de nómina --->
	<cfset continuar = true>
	<!--- Seguir buscando la fecha adecuada hasta no topar con una exclusión --->
	<cfloop condition="continuar">
		<cfif isdefined("Form.btnModificar") and CompareNoCase(calculo.recordCount, Trim(Form.PPnumero)) EQ 0>
			<cfset fecha = LSParseDateTime(Form.FechaCorte)>
			<cfif periodicidad EQ "0"> 		<!--- Semanal --->
				<cfset Fdesde = DateAdd("d", -6, fecha)>
			<cfelseif periodicidad EQ "1">	<!--- Bisemanal --->
				<cfset Fdesde = DateAdd("d", -13, fecha)>
			<cfelseif periodicidad EQ "2">	<!--- Quincenal --->
				<cfif Day(fecha) EQ "15">
					<cfset Fdesde = DateAdd("d", -14, fecha)>
				<cfelse>
					<cfset Fdesde = CreateDate(Year(fecha), Month(fecha), 16)>
				</cfif>
			<cfelseif periodicidad EQ "3">	<!--- Mensual --->													
				<cfset Fdesde = CreateDate(Year(fecha), Month(fecha), 1)>
			</cfif>
		</cfif>
		
		<cfif periodicidad EQ "0"> 		<!--- Semanal --->
			<cfset Fhasta = DateAdd("d", 6, Fdesde)>
			<cfset Fdesde = DateAdd("d", 1, Fhasta)>
		<cfelseif periodicidad EQ "1">	<!--- Bisemanal --->
			<cfset Fhasta = DateAdd("d", 13, Fdesde)>
			<cfset Fdesde = DateAdd("d", 1, Fhasta)>
		<cfelseif periodicidad EQ "2">	<!--- Quincenal --->
			<cfif Day(Fdesde) EQ "01">
				<cfset Fhasta = DateAdd("d", 14, Fdesde)>
				<cfset Fdesde = DateAdd("d", 1, Fhasta)>
			<cfelseif Day(Fdesde) EQ "16">
				<cfset Fhasta = CreateDate(Year(Fdesde), Month(Fdesde), DaysInMonth(Fdesde))>
				<cfset Fdesde = DateAdd("d", 1, Fhasta)>
			</cfif>
		<cfelseif periodicidad EQ "3">	<!--- Mensual --->
			<cfset Fhasta = DateAdd("d", (DaysInMonth(Fdesde) - 1), Fdesde)>
			<cfset Fdesde = DateAdd("d", 1, Fhasta)>
		</cfif>
		<cfset fecha = Fhasta>
		
		<!--- Revisar si existen exclusiones para la fecha calculada --->
		<cfif isdefined("btnRecalcular") or isdefined("btnModificar")>
			<cfquery name="rsExclusion" datasource="#Session.DSN#">
				select 1
				from DeduccionesEmpleado a, LineaTiempo d, RHExcluirDeduccion b, CalendarioPagos c
				where a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				and a.DEid = d.DEid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between d.LTdesde and d.LThasta
				and a.TDid = b.TDid
				and b.CPid = c.CPid
				and c.CPhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
				and c.Ecodigo = d.Ecodigo
				and c.Tcodigo = d.Tcodigo
			</cfquery>
		<cfelse>
			<cfquery name="rsExclusion" datasource="#Session.DSN#">
				select 1
				from DatosEmpleado a, LineaTiempo d, RHExcluirDeduccion b, CalendarioPagos c
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.DEid#">
				and a.DEid = d.DEid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between d.LTdesde and d.LThasta
				and b.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.deduccion_empleado.TDid#">
				and b.CPid = c.CPid
				and c.CPhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
				and c.Ecodigo = d.Ecodigo
				and c.Tcodigo = d.Tcodigo
			</cfquery>
		</cfif>
		<!--- Si no se topa con una exclusión, puede salir del ciclo --->
		<cfif rsExclusion.recordCount EQ 0>
			<cfset continuar = false>
		</cfif>
		
	</cfloop>
	<!--- Fin Calculo de las fechas para los calendarios de pago del financiamento, tomado de calendario de pagos de los tipos de nómina --->

	<cfif i is plazo and cuota neq saldo + interes_mes>
		<cfset cuota = saldo + interes_mes>
	</cfif>

	<!--- VALIDA que el calculo.recordcount no se repita (PPnumero) --->
	<cfset vPPnumero = calculo.RecordCount >


	<!--- Actualizar la fecha de inicio de la deducción del empleado en caso de que sea la primer cuota la que se cambia --->
	<cfif isdefined("Form.btnModificar") and CompareNoCase(calculo.recordCount, Trim(Form.PPnumero)) EQ 0 and i EQ 1>
		<cfquery name="updDeduccion" datasource="#Session.DSN#">
			update DeduccionesEmpleado 
				set Dfechaini = <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
			where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		</cfquery>
	</cfif>

<!---
	<cfquery name="rsExistePPnumero" dbtype="query">
		select PPnumero
		from calculo
		where PPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPPnumero#">
	</cfquery>
	<cfif rsExistePPnumero.recordCount gt 0 >
		<cfquery name="rsPPnumero" dbtype="query">
			select max(PPnumero) as PPnumero
			from calculo
		</cfquery>
		<cfset vPPnumero = rsPPnumero.PPnumero + 1 >
	</cfif>
--->	
	<!--- ---> 
	<cfset QuerySetCell(calculo,'PPnumero'  ,  vPPnumero)>
	<cfset QuerySetCell(calculo,'fecha'     ,  fecha)>
	<cfset QuerySetCell(calculo,'saldoant'  ,  LSNumberFormat(saldo, '9.0000'))>
	<cfset QuerySetCell(calculo,'principal' ,  LSNumberFormat((cuota - interes_mes), '9.0000'))>
	<cfset QuerySetCell(calculo,'intereses' ,  LSNumberFormat(interes_mes, '9.0000'))>
	<cfset QuerySetCell(calculo,'total'     ,  LSNumberFormat(cuota, '9.0000'))>

	<cfset saldo = saldo + interes_mes - cuota>

	<cfset QuerySetCell(calculo,'saldofinal',  LSNumberFormat(saldo, '9.0000'))>
	<cfset QuerySetCell(calculo,'pagado'    ,  0)>
	<cfset QuerySetCell(calculo,'img'       , " ")>
</cfloop>



