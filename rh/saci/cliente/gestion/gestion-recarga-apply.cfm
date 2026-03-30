<!--- Primero que nada veamos si hay pago en línea pendiente, en este caso procedemos al pago --->
<cfif IsDefined('url.pagoenlinea')>
	<cfset StructAppend(form, session.pagando)>
</cfif>

<!--- Validar la tarjeta --->
<cfquery datasource="#session.dsn#" name="saldo">
	select p.TJid, p.TJdsaldo, pp.prefijo, pp.recargable, pp.precio, pp.Miso4217, p.TJpassword
	from ISBprepago p
		left join ISBprefijoPrepago pp
			on pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and p.TJlogin like rtrim(pp.prefijo) || '%'
	where p.TJlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tj#">
	  and p.TJpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.pw#">
</cfquery>
<cfif saldo.RecordCount is 0>
	<cfthrow message="La contraseña no corresponde a la tarjeta indicada">
<cfelseif saldo.recargable neq 1>
	<cfthrow message="La tarjeta no es recargable. (serie #HTMLEditFormat(saldo.prefijo)#)">
</cfif>

<!--- quitar las comas separadoras de miles --->
<cfparam name="form.costo_total" type="string">
<cfset form.costo_total = Replace(form.costo_total, ',', '', 'all')>
<cfparam name="form.costo_total" type="numeric">

<cfparam name="form.moneda2" type="string">

<!--- quitar las comas separadoras de miles --->
<cfparam name="form.costo_por_hora" type="string">
<cfset form.costo_por_hora = Replace(form.costo_por_hora, ',', '', 'all')>
<cfparam name="form.costo_por_hora" type="numeric">

<!--- quitar las comas separadoras de miles --->
<cfparam name="form.horas_recarga" type="string">
<cfset form.horas_recarga = Replace(form.horas_recarga, ',', '', 'all')>
<cfparam name="form.horas_recarga" type="numeric">

<!--- Se hace una resta para que convierta a números al comparar, eg, 86.40 con 86.4 --->
<cfset diferencia = form.costo_total - Round( form.horas_recarga * saldo.precio * 100) / 100>
<cfif diferencia GE 0.005>
	<cfthrow message="El costo total de # form.costo_total # es incorrecto. Debe ser #NumberFormat(form.horas_recarga * saldo.precio, ',0.00')#">
</cfif>

<cfif form.moneda2 neq saldo.Miso4217>
	<cfthrow message="La moneda #form.moneda2# es incorrecta.  Debe ser #saldo.Miso4217#">
</cfif>

<!--- Se hace una resta para que convierta a números al comparar, eg, 86.40 con 86.4 --->
<cfset diferencia = form.costo_por_hora - saldo.precio>
<cfif diferencia GE 0.005>
	<cfthrow message="El costo por hora de #form.costo_por_hora# es incorrecto.  Debe ser #saldo.precio#">
</cfif>

<!--- ver si el pago se realizó --->
<cfquery datasource="#session.dsn#" name="pagado">
	select PTmonto, PTid, PTcodAutorizacion
	from ISBpago
	where PTlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tj#">
	  and PTusado = 0
	  and PTautorizado = 1
	  and PTmonto >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.costo_total-0.01#" scale="2">
	  <cfif IsDefined('url.pagoenlinea')>
		and PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.pagoenlinea#">
	  </cfif>
	order by PTmonto
</cfquery>
<cfif pagado.RecordCount is 0>

	<cfif IsDefined('url.pagoenlinea')>
		<cfset ExtraParams = "recargaok=0&tj=#form.tj#" >
		<cfinclude template="gestion-redirect.cfm">
		<!--- Se supone que de aquí no pasa, pero pongo el cfthrow por lo que potis --->
		<cfthrow message="El pago para #form.tj# por #form.costo_total# no fue aceptado.">
	</cfif>

	<!--- guardar el form en session, y mandar a pagar --->
	<cfset session.pagando = StructNew()>
	<cfset StructAppend(session.pagando, form)>
	<cfinvoke component="saci.pagos.vpos" method="send" returnvariable="vpos_struct"
		monto="#form.costo_total#"
		moneda="#saldo.Miso4217#"
		origen="SACI"
		tipoTransaccion="AURP"
		login="#form.tj#"
		descripcion="Recarga de prepago #form.tj# por #form.horas_recarga# horas" />
	<cflocation url="../../pagos/vpos-request.cfm?datos=#vpos_struct.datos#&validar=#vpos_struct.validar#" addtoken="no">
<cfelse>
	<cfset form.PTid = pagado.PTid>
	<cfset form.TRrefPago = 'Aut #pagado.PTcodAutorizacion#, Tran #pagado.PTid#'>
</cfif>

<cftransaction>
	<!--- Registrar la recarga --->
	<cfquery datasource="#session.dsn#">
	insert into ISBprepagoRecarga 
		(TJid, TRfecha, TRsegundos, TRmonto, TRrefPago, BMUsucodigo)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#saldo.TJid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#3600*form.horas_recarga#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#saldo.precio*form.horas_recarga#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TRrefPago#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
	</cfquery>
	<!--- Recargar el prepago --->
	<cfquery datasource="#session.dsn#">
		update ISBprepago
		set TJdsaldo = 
			<!--- si el saldo es negativo se ignora --->
			(case when TJdsaldo > 0 then TJdsaldo else 0 end)
			+ <cfqueryparam cfsqltype="cf_sql_numeric" value="#3600*form.horas_recarga#">
		<!---
			, TJvigencia = (...)
			, TJliquidada = (...)
			, TJestado = (...)
		--->
		where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#saldo.TJid#">
	</cfquery>
	
	<!--- Marcar ISBpago como utilizada --->
	<cfquery datasource="#session.dsn#">
		update ISBpago
		set PTusado = 1
		where PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PTid#">
	</cfquery>
	
</cftransaction>
<cfset ExtraParams = "recargaok=1&tj=#form.tj#" >
<cfinclude template="gestion-redirect.cfm">
