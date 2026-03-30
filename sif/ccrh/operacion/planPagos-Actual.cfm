<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Plan de Pago actual">

	<cfquery datasource="#session.dsn#" name="plan_pagos">
		select pp.PPnumero,coalesce(pp.PPfecha_pago,pp.PPfecha_vence) as fecha,
			pp.PPsaldoant as saldoant,
			case when pp.PPfecha_pago is null then pp.PPprincipal  else pp.PPpagoprincipal end as principal,
			case when pp.PPfecha_pago is null then pp.PPinteres    else pp.PPpagointeres+pp.PPpagomora end as intereses,
			case when pp.PPfecha_pago is null then pp.PPprincipal+pp.PPinteres  else pp.PPpagointeres+pp.PPpagomora+pp.PPpagoprincipal end as total,
			case when pp.PPfecha_pago is null then pp.PPsaldoant-pp.PPprincipal else pp.PPsaldoant-pp.PPpagoprincipal end as saldofinal,
			pp.PPtasa, pp.PPtasamora,
			case when pp.PPfecha_pago is null then 0 else 1 end as pagado,
			case when pp.PPfecha_pago is null then '' else '<img src=''../../imagenes/w-check.gif'' border=''0'' width=''16'' height=''16''>' end as img,
			#Form.DEid# as DEid,
			#Form.Did# as Did,
			#Form.TDid2# as TDid
		from DeduccionesEmpleadoPlan pp
		where pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and pp.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
		order by pp.PPnumero
	</cfquery>
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
		<cfinvokeargument name="query" value="#plan_pagos#">
		<cfinvokeargument name="desplegar" value="PPnumero,img,fecha,principal,intereses,total,saldofinal">
		<cfinvokeargument name="etiquetas" value="N&uacute;m,&nbsp;,Fecha,Principal,Intereses,Cuota,Saldo">
		<cfinvokeargument name="formatos" value="S,S,D,M,M,M,M">
		<cfinvokeargument name="align" value="left,left,left,right,right,right,right">
		<cfinvokeargument name="MaxRows" value="20">
		<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#">
		<cfinvokeargument name="keys" value="TDid, DEid, Did, PPnumero">
		<cfinvokeargument name="totales" value="total">		
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
<cf_web_portlet_end>