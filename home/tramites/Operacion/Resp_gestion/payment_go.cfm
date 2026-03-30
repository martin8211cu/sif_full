<cfparam name="form.moneda_pago" type="string">
<cfparam name="form.importe_pago" type="numeric">
<cfparam name="form.factor" type="numeric">
<cfparam name="form.forma_pago">

<cfif form.forma_pago eq 'T'>
	<cf_tarjeta action="readform" name="tarj">
	<cf_tarjeta action="update" data="#tarj#" name="tarj">
	
	<cf_tarjeta_cobro2
		action="autorizar"
		Ecodigosdc="#session.EcodigoSDC#"
		id_tarjeta="#tarj.id_tarjeta#"
		monto="#form.importe_pago#"
		moneda="#form.moneda_pago#"
		<!--- mejor que control fuera el id_pago, pero no se puede meter todo en la misma transaccion --->
		control="#ListFirst(form.importe_pago)#">

	<cfif cf_tarjeta_cobro.error NEQ 0>
		<cflocation url="payment3_rechazo.cfm?msg=#URLEncodedFormat(cf_tarjeta_cobro.mensaje)
			#&cobros=#URLEncodedFormat(form.cobros)
			#&importe_pago=#URLEncodedFormat(form.importe_pago)
			#&moneda_pago=#URLEncodedFormat(form.moneda_pago)
			#&id_tarjeta=#URLEncodedFormat(tarj.id_tarjeta)#">
		<cfabort>
	</cfif>
</cfif>

<cftransaction>

<cf_dbtimestamp datasource="#session.tramites.dsn#"
	table="TPInstanciaRequisito"
	redirect="payment2.cfm"
	timestamp="#form.ts_rversion#"
	field1="id_instancia" 
	field2="id_requisito" 
	type1="numeric" 
	type2="numeric" 
	value1="#form.id_instancia#"
	value2="#form.id_requisito#">
<cfquery datasource="#session.tramites.dsn#" name="update">
	update TPInstanciaRequisito set
	id_funcionario  =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
	id_ventanilla 	=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">,
	completado 		=	1,
	fecha_registro  = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	forma_pago  	=   <cfqueryparam cfsqltype="cf_sql_char"      value="#form.forma_pago#">,	
	moneda   		=   <cfqueryparam cfsqltype="cf_sql_char"      value="#form.moneda_pago#">,   
	monto_pagado	=   <cfqueryparam cfsqltype="cf_sql_float"     value="#form.importe_pago#">,   
	
	<cfif form.forma_pago eq 'E'>
		num_autorizacion =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#num_autorizacion#">,
	<cfelseif  form.forma_pago eq 'C'>
		cheque_numero  	=	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_numero#">,
		cheque_cuenta   = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_cuenta#">,
		cheque_banco  	=  	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_banco#">,
	<cfelseif  form.forma_pago eq 'T'>
		id_transaccion  =  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#cf_tarjeta_cobro.transaccion.id_transaccion#">,
		id_tarjeta     	=   <cfqueryparam cfsqltype="cf_sql_numeric" value="#tarj.id_tarjeta#">,    
	</cfif>
	BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	BMUsucodigo   	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	
	where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
	and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
</cfquery>	



<!---  
<cfquery datasource="#session.dsn#" name="pago_inserted">
	insert into sa_pagos (
		fecha_pago, forma_pago, importe, moneda,
		<cfif form.forma_pago is 'T'>
		id_tarjeta, id_transaccion, num_autorizacion,<!--- estos dos irian despues en un update si resuelvo lo de la transaccion --->
		<cfelseif form.forma_pago is 'C'>
		cheque_numero, cheque_cuenta, cheque_Bid,
		</cfif>
		CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
	values (
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.forma_pago#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.importe_pago#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.moneda_pago#">,
	
		<cfif form.forma_pago is 'T'>
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#tarj.id_tarjeta#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#cf_tarjeta_cobro.transaccion.id_transaccion#">,
	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizacion#" null="#Len( cf_tarjeta_cobro.autorizacion) is 0#">,
		<cfelseif form.forma_pago is 'C'>
	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_numero#">,
	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_cuenta#">,
	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_Bid#">,
		</cfif>

		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	<cf_dbidentity1 datasource="#session.dsn#">
</cfquery>
<cf_dbidentity2 datasource="#session.dsn#" name="pago_inserted">

<cfquery datasource="#session.dsn#" name="insert_sa_pago_aplicado">
	insert into sa_pago_aplicado (
		id_programa, id_vigencia, id_cobro, id_persona, id_pago,
		factor, importe_doc, moneda_doc, importe_pago, moneda_pago,
		CEcodigo, Ecodigo, BMfechamod, BMUsucodigo)
	select
		id_programa, id_vigencia, id_cobro, id_persona,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#pago_inserted.identity#"> as id_pago,
		
		<cfqueryparam cfsqltype="cf_sql_decimal" scale="2" value="#form.factor#"> as factor,
		(importe - pagado) as importe_doc,
		sa_cobros.moneda as moneda_doc,
		round (
			(importe - pagado) / <cfqueryparam cfsqltype="cf_sql_decimal" scale="2" value="#form.factor#">
			, 2) as importe_pago,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.moneda_pago#"> as moneda_pago,
		
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	from sa_cobros
	where id_cobro in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cobros#" list="yes">)
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!---
	validar por aquello de que no inserta bien cuando nos da malo el redondeo
--->
<cfquery datasource="#session.dsn#" name="validar">
	select * from sa_pago_aplicado
	where id_pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pago_inserted.identity#">
</cfquery>
<cfif validar.RecordCount neq ListLen(form.cobros)>
	<cfdump var="#validar#">
	<cfthrow message="No se insertaron #ListLen(form.cobros)# registros, sino #validar.RecordCount# para el pago #pago_inserted.identity#">
</cfif>

<cfquery datasource="#session.dsn#">
	update sa_cobros
	set pagado = importe
	where id_cobro in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cobros#" list="yes">)
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery datasource="#session.dsn#" name="validar">
	select * from sa_cobros
	where id_cobro in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cobros#" list="yes">)
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfif validar.RecordCount neq ListLen(form.cobros)>
	<cfdump var="#validar#">
	<cfthrow message="No se actualizaron #ListLen(form.cobros)# registros, sino #validar.RecordCount#">
</cfif>

<!---
	esto se debería hacer hasta que la autorización pase
<cfquery datasource="#session.dsn#">
	update sa_pagos
	set id_transaccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cf_tarjeta_cobro.transaccion.id_transaccion#">,
	    num_autorizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cf_tarjeta_cobro.autorizacion#" null="#Len( cf_tarjeta_cobro.autorizacion) is 0#">
	where id_pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pago_inserted.identity#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
--->
</cftransaction>

<cflocation url="payment_thanks.cfm?id_pago=#URLEncodedFormat(pago_inserted.identity)#&cobros=#URLEncodedFormat(form.cobros)#">
--->

<cfset p = ""> 
<cfif isdefined("form.ID_INSTANCIA")><cfset p = p & "id_instancia=#form.ID_INSTANCIA#"></cfif>
<cfif isdefined("form.ID_REQUISITO")><cfset p = p & "&id_requisito=#form.ID_REQUISITO#"></cfif>
<cfif isdefined("form.id_persona")><cfset p = p & "&id_persona=#form.id_persona#"></cfif>
<cfif isdefined("form.id_tramite")><cfset p = p & "&id_tramite=#form.id_tramite#"></cfif>
<cflocation url="payment_thanks.cfm?#p#">

<!---
<cfoutput>
	<form action="payment_thanks.cfm" method="post" name="sql">
		<input type="hidden" name="ID_INSTANCIA" 	 value="<cfif isdefined("form.ID_INSTANCIA")>#form.ID_INSTANCIA#</cfif>">
		<input type="hidden" name="ID_REQUISITO" 	 value="<cfif isdefined("form.ID_REQUISITO")>#form.ID_REQUISITO#</cfif>">
		<input type="hidden" name="id_persona"       value="<cfif isdefined("form.id_persona")>#form.id_persona#</cfif>">
		<input type="hidden" name="id_tramite" value="<cfif isdefined("form.id_tramite")>#form.id_tramite#</cfif>">
</form>
</cfoutput>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
--->
