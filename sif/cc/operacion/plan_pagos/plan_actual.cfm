<div style="width:450px">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Plan de Pago actual">

	<cfquery datasource="#session.dsn#" name="plan_pagos">
		select PPnumero,coalesce(PPfecha_pago,PPfecha_vence) as fecha,
			PPsaldoant as saldoant,
			case when PPfecha_pago is null then PPprincipal            else PPpagoprincipal            end as principal,
			case when PPfecha_pago is null then PPinteres              else PPpagointeres+PPpagomora   end as intereses,
			case when PPfecha_pago is null then PPprincipal+PPinteres  else PPpagointeres+PPpagomora+PPpagoprincipal end as total,
			case when PPfecha_pago is null then PPsaldoant-PPprincipal else PPsaldoant-PPpagoprincipal end as saldofinal,
			PPtasa, PPtasamora,
			case when PPfecha_pago is null then 0 else 1 end as pagado,
			case when PPfecha_pago is null then '' else '<img src=../../../imagenes/w-check.gif border=0 width=16 height=16>' end as img
		from PlanPagos pp
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and pp.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.CCTcodigo#">
		  and pp.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Ddocumento#">
		order by PPnumero
	</cfquery>
	
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
		query="#plan_pagos#"
		desplegar="PPnumero,img,fecha,principal,intereses,total,saldofinal"
		etiquetas="N&uacute;m,&nbsp;,Fecha,Principal,Intereses,Cuota,Saldo"
		formatos="S,S,D,M,M,M,M"
		align="left,left,left,right,right,right,right"
		funcion="void(0)"
		MaxRows="0"
		totales="total"
		showLink="false"
		PageIndex="2">
	</cfinvoke>
<cf_web_portlet_end>

</div>