<cfquery datasource="#session.tramites.dsn#" name="sucursal">
	select  a.id_sucursal , b.id_inst  from TPVentanilla a, TPSucursal b	
	where 
	a. id_ventanilla = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">
	and a.id_sucursal = b.id_sucursal 
</cfquery>
<cfquery datasource="#session.tramites.dsn#" name="benificiario">
	select  id_inst,id_tiposerv from TPRequisito	
	where  id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
</cfquery>
<cfquery datasource="#session.tramites.dsn#" name="tipo">
	select  id_tipoident from TPPersona 	
	where  id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery>

<cf_dbtimestamp datasource="#session.tramites.dsn#"
	table="TPInstanciaRequisito"
	redirect="req_pago.cfm"
	timestamp="#form.ts_rversion#"
	field1="id_instancia" 
	field2="id_requisito" 
	type1="numeric" 
	type2="numeric" 
	value1="#form.id_instancia#"
	value2="#form.id_requisito#">

<cfquery datasource="#session.tramites.dsn#" name="update">
	update TPInstanciaRequisito set
	completado 		=	1,
	fecha_registro  = 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	BMfechamod    	= 	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
	BMUsucodigo   	= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
	where id_instancia  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
	and id_requisito =    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
</cfquery>	
<cfquery datasource="#session.tramites.dsn#" name="insert">
	insert into TPPago(
		id_instancia, 
		id_requisito,
		id_funcionario,
		id_ventanilla,
		id_sucursal,
		id_beneficiario,
		id_recaudador,
		id_tiposerv,
		num_referencia,
		num_autorizacion,
		monto_pagado,
		moneda,
		fecha_pago,
		BMUsucodigo,
		BMfechamod)
	values(
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#sucursal.id_sucursal#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#benificiario.id_inst#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#sucursal.id_inst#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#benificiario.id_tiposerv#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.num_referencia#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.num_tiquete#">,
		<cfqueryparam cfsqltype="cf_sql_float"   value="#form.monto_pagado#">,   
		<cfqueryparam cfsqltype="cf_sql_char"      value="#form.moneda#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	)	
</cfquery>	
<cflocation url="/cfmx/home/tramites/Operacion/gestion/gestion-form.cfm?identificacion_persona=#form.id_persona#&id_tipoident=#tipo.id_tipoident#&id_tramite=#form.id_tramite#&loc=gestion">