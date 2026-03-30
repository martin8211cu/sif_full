<cfparam name="url.plazo"   type="numeric">
<cfparam name="url.interes" type="numeric">
<cfparam name="url.tipo"    default="m">
<cfparam name="url.pago_inicial" type="string">
<cfparam name="url.primerfecha" type="string">

<cfset fecha = LSParseDateTime(url.primerfecha) >
<cfset calculo = QueryNew("PPnumero,fecha,saldoant,principal,intereses,total,saldofinal,pagado,img")>
<cfloop query="plan_pagos">
	<cfif plan_pagos.pagado>
		<cfset QueryAddRow(calculo,1)>
		<cfset QuerySetCell(calculo,'PPnumero'  , plan_pagos.PPnumero)>
		<cfset QuerySetCell(calculo,'fecha'     , plan_pagos.fecha)>
		<cfset QuerySetCell(calculo,'saldoant'  , plan_pagos.saldoant)>
		<cfset QuerySetCell(calculo,'principal' , plan_pagos.principal)>
		<cfset QuerySetCell(calculo,'intereses' , plan_pagos.intereses)>
		<cfset QuerySetCell(calculo,'total'     , plan_pagos.total)>
		<cfset QuerySetCell(calculo,'saldofinal', plan_pagos.saldofinal)>
		<cfset QuerySetCell(calculo,'pagado'    , plan_pagos.PPnumero)>
		<cfset QuerySetCell(calculo,'img'       , "<img src=../../../imagenes/w-check.gif border=0 width=16 height=16>")>
		<cfif fecha lt plan_pagos.fecha>
			<cfset fecha = plan_pagos.fecha>
		</cfif>
	</cfif>
</cfloop>

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

<cfset saldo = documento.Dsaldo>
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
		<cfset QuerySetCell(calculo,'saldoant'  ,  saldo)>
		<cfset QuerySetCell(calculo,'principal' ,  cuota - interes_mes)>
		<cfset QuerySetCell(calculo,'intereses' ,  interes_mes)>
		<cfset QuerySetCell(calculo,'total'     ,  cuota)>
		<cfset saldo = saldo + interes_mes - cuota>
		<cfset QuerySetCell(calculo,'saldofinal',  saldo)>
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

<cfloop from="1" to="#plazo#" index="i">
	<cfif saldo is 0><cfbreak></cfif>
	<cfset QueryAddRow(calculo,1)>
	<cfset interes_mes = Round(saldo * interes_div*100)/100>
	<cfset fecha = DateAdd(dateadd_part, dateadd_cant, fecha)>
	<cfif i is plazo and cuota neq saldo + interes_mes>
		<cfset cuota = saldo + interes_mes>
	</cfif>
	<cfset QuerySetCell(calculo,'PPnumero'  ,  calculo.RecordCount)>
	<cfset QuerySetCell(calculo,'fecha'     ,  fecha)>
	<cfset QuerySetCell(calculo,'saldoant'  ,  saldo)>
	<cfset QuerySetCell(calculo,'principal' ,  cuota - interes_mes)>
	<cfset QuerySetCell(calculo,'intereses' ,  interes_mes)>
	<cfset QuerySetCell(calculo,'total'     ,  cuota)>
	<cfset saldo = saldo + interes_mes - cuota>
	<cfset QuerySetCell(calculo,'saldofinal',  saldo)>
	<cfset QuerySetCell(calculo,'pagado'    ,  0)>
	<cfset QuerySetCell(calculo,'img'       , " ")>
</cfloop>


