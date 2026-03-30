<cfset rollback_transaction = 0>
<cfset Estado = 0>
<cfif isdefined("form.radRep") and form.radRep EQ 1>
	<cfset Tipo = 'E'> <!--- Efectivo --->
<cfelseif isdefined("form.radRep") and form.radRep EQ 2>
	<cfset Tipo = 'C'> <!--- Cheque--->
<cfelseif isdefined("form.radRep") and form.radRep EQ 3>
	<cfset Tipo = 'T'> <!--- Tarjeta de Crédito--->
</cfif>
<cfif isdefined("form.radTC") and form.radTC EQ 1>
	<cfset TC = 'CO'> <!--- Efectivo --->
	<cfset Estado = 100>
<cfelseif isdefined("form.radTC") and form.radTC EQ 2>
	<cfset TC = 'CR'> <!--- Cheque--->
	<cfset Estado = 50><!--- En Caja --->
<cfelseif isdefined("form.radTC") and form.radTC EQ 3>
	<cfset TC = 'FI'> <!--- Tarjeta de Crédito--->
	<cfset Estado = 50> <!--- En Financiamiento --->
<cfelse>
	<cf_errorCode	code = "50375" msg = "Tipo de Pago Inválido">
</cfif>
<cfif isDefined('Form.btnAceptar')>
<cftransaction>
	<cfquery name="SQLRecibePagos" datasource="#Session.DSN#">
			Update VentaE 
			Set tipo_compra = <cfqueryparam cfsqltype="cf_sql_char" value="#TC#">,
			estado=  <cfqueryparam cfsqltype="cf_sql_char" value="#Estado#">,
			forma_pago = <cfqueryparam cfsqltype="cf_sql_char" value="#Tipo#">,
			monto_recibido = <cfqueryparam cfsqltype="cf_sql_money" value="#form.monto_recibido#">
			<cfif isdefined("form.radRep") and form.radRep EQ 2>
				, cheque_numero  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_numero#">
				, cheque_cuenta  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cheque_cuenta#">
				, cheque_Bid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
			<cfelseif isdefined("form.radRep") and form.radRep EQ 3>
				, num_autorizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Autoriza#">
				, num_tarjeta =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.num_tarjeta#">
				, tipo_tarjeta = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo_tarjeta#">
			</cfif>
			Where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.VentaID#">
	</cfquery>

	<cfquery datasource="#session.dsn#" name="credito_usado">
		select total_productos - monto_recibido as credito_usado, CDid
		from VentaE
		Where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.VentaID#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		update ClienteDetallista
		set CDcreditoutilizado = coalesce(CDcreditoutilizado,0) + <cfqueryparam cfsqltype="cf_sql_decimal" value="#credito_usado.credito_usado#">
		where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#credito_usado.CDid#">
	</cfquery>

	<cfset form.FCid = Trim(ListFirst(form.FCid,'|'))>
	
	<cfquery datasource="#session.dsn#" name="getETnumero">
		select coalesce(max(ETnumero),0)+1 as ETnumero
		from ETransacciones 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset LETnumero = getETnumero.ETnumero>
	<cfquery name="getTid" datasource="#Session.DSN#">
		select Tid
		from TipoTransaccionCaja
		where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
	</cfquery>
	<cfset LTid = getTid.Tid>
	<cfif Len(LTid) is 0>
		<cf_errorCode	code = "50376"
						msg  = "El tipo de transaccion @errorDat_1@ no está definido para la caja @errorDat_2@"
						errorDat_1="#form.cctcodigo#"
						errorDat_2="#form.fcid#"
		>
	</cfif>
	<cfquery datasource="#session.dsn#" name="setRIsig">
		Update Talonarios 
		set RIsig = RIsig + 1
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTid#">
	</cfquery>
	<cfquery datasource="#session.dsn#" name="getRIsig">
		select RIsig from Talonarios 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer"> 
		and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LTid#">			
	</cfquery>
	<cfset LRIsig = getRIsig.RIsig>
	<cfif Len(LRIsig) is 0>
		<cf_errorCode	code = "50377"
						msg  = "No hay talonarios del tipo de transaccion @errorDat_1@ para la caja @errorDat_2@"
						errorDat_1="#form.cctcodigo#"
						errorDat_2="#form.fcid#"
		>
	</cfif>
	<cfquery name="getCaja" datasource="#session.dsn#">
		select Ocodigo, Ccuenta, Ccuentadesc
		from FCajas
		where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
	</cfquery>
	<cfset LOcodigo = getCaja.Ocodigo>
	<cfset LCcuenta = getCaja.Ccuenta>
	<cfset LCcuentadesc = getCaja.Ccuentadesc>
	<cfquery name="getMonedaLocal" datasource="#Session.DSN#">
		select Mcodigo from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	</cfquery>
	<cfset LMonedaLocal = getMonedaLocal.Mcodigo>
	<cfquery datasource="#session.dsn#" name="cual_socio">
		select coalesce (v.SNcodigo, c.SNcodigo) as SNcodigo
		from VentaE v
			join SNegocios c
				on v.CDid = c.CDid
		where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.VentaID#">
	</cfquery>
	<cfif Len(cual_socio.SNcodigo) is 0>
		<cfquery datasource="#session.dsn#" name="cual_socio">
			select SNcodigo
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
			  and SNnumero = '999-9999'
			  and SNcodigo = 9999
		</cfquery>
	</cfif>
	<cfif Len(cual_socio.SNcodigo) is 0>
		<cf_errorCode	code = "50378" msg = "Este cliente no está habilitado para facturas de crédito (Socio de Negocios), y no existe el Socio Generico 999-9999">
	</cfif>
	<cfset form.SNcodigo = cual_socio.SNcodigo>
	<cfquery name="getSNegocios" datasource="#session.dsn#">
		select SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	</cfquery>
	<cfset LSNnombre = getSNegocios.SNnombre>
	<!--- I N S E R T A   E L   E N C A B  E Z A D O  --->
	<!---
	<cfoutput>LETnumero:=#LETnumero#;#LOcodigo#;#LMonedaLocal#=#LCcuenta#,#LTid#,#LSNnombre# $ #LRIsig#</cfoutput>
	<cfabort>
	--->
	<cfquery datasource="#session.dsn#" name="insertETransacciones">
		insert ETransacciones (
			FCid, ETnumero, Ecodigo, Ocodigo, SNcodigo, Mcodigo, ETtc, CCTcodigo, Icodigo, Ccuenta, Tid,
			ETfecha, ETtotal, ETestado, Usucodigo, Ulocalizacion, Usulogin, 
			ETporcdes, ETmontodes, ETimpuesto, ETnombredoc, ETobs, ETdocumento, ETserie
		) values (				
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#LETnumero#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#LOcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#LMonedaLocal#">, 
			<cfqueryparam cfsqltype="cf_sql_float" value="1.00">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#LTid#">,				
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="P">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="00">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">, 
			<cfqueryparam cfsqltype="cf_sql_float" value="0.00">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
			<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSNnombre#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#LRIsig#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="" null="yes">
		)
	</cfquery>
	<cfset LTotal = 0>
	
	<cfquery datasource="#session.dsn#" name="articulos">
		select v.Aid, v.cantidad, v.precio_linea, v.precio_unitario, a.Adescripcion
		from VentaD v
			join Articulos a
				on a.Aid = v.Aid
				and a.Ecodigo = v.Ecodigo
		where VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.VentaID#">
	</cfquery>
	
	<!--- I N S E R T A   L O S   D E T A L L E S ---> 
	<!--- Datos de los Artículos por Facturar --->

	<!---
	<cfoutput>LETnumero:=#LETnumero#;#LOcodigo#;#LMonedaLocal#=#LCcuenta#,#LTid#,#LSNnombre# $ #LRIsig#</cfoutput>
	<cfabort>
	--->
	
	<cfquery datasource="#session.dsn#" name="insertETransacciones">
		insert DTransacciones (
				FCid, ETnumero, Ecodigo, DTtipo, Aid, Alm_Aid, Ccuenta, Ccuentades, Cid, FVid, Dcodigo, 
				DTfecha, DTcant, DTpreciou, DTdeslinea, DTtotal, DTborrado, 
				DTdescripcion, DTdescalterna)
		select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LETnumero#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="A">, 
				v.Aid, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuentadesc#" null="#Len(LCcuentadesc) Is 0#">, 
				null, 
				e.FVid, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">, 
				v.cantidad, 
				v.precio_unitario, 
				<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
				round(v.precio_linea, 2), 
				<cfqueryparam cfsqltype="cf_sql_bit" value="0">, 
				a.Adescripcion, 
				null
		from VentaD v
			join VentaE e
				on e.VentaID = v.VentaID
			join Articulos a
				on a.Aid = v.Aid
				and a.Ecodigo = v.Ecodigo
		where v.VentaID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.VentaID#">
	</cfquery>
	
	<!--- oooooops --->
	<cfset LTotal = LTotal + Round(articulos.precio_linea*100)/100>

	<!---  A C T U A L I Z A   E L   E N C A B E Z A D O  --->
	<cfquery name="updateETransacciones" datasource="#session.dsn#">
		update ETransacciones
		set ETtotal = round(#LTotal#,2)
		where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LETnumero#">
	</cfquery>
	<cfif rollback_transaction>
		<cfquery name="rsQryE" datasource="#session.dsn#">
			select * from ETransacciones where ETnumero = #LETnumero#
		</cfquery>
		<cfdump var="#rsQryE#">
		<cfquery name="rsQryD" datasource="#session.dsn#">
			select * from DTransacciones where ETnumero = #LETnumero#
		</cfquery>
		<cfdump var="#rsQryD#">
		<cftransaction action="rollback"/>
	</cfif>
	<cfset Session.listaFactura = StructNew()>
	<cfset Session.listaFactura.Articulos = StructNew()>
	<cfset Session.listaFactura.Total = 0.00>
</cftransaction>
</cfif>
<cf_template>
<cf_templatearea name="title">
	Factura Confiramada</cf_templatearea>
<cf_templatearea name="body">
	<cfoutput>
	
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
	<center><br>
<br>

	
	
		<strong>Se gener&oacute; la factura n&uacute;mero #LETnumero# por <br>un monto de #LSCurrencyFormat(LTotal,'none')#.</strong><br>
<br>

				<cf_boton link="RecibePagosLista.cfm" texto="Continuar" size="120"><br>

	</center>
	</cfoutput>
</cf_templatearea>
</cf_template>


