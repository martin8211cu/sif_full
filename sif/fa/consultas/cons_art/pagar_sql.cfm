<cfset session.debug = false>
<cftransaction>
	<cfset form.FCid = listtoArray(form.FCid,'|')>
	<cfset form.FCid = form.FCid[1]>
	
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
	<cfquery name="getSNegocios" datasource="#session.dsn#">
		select SNnombre
		from SNegocios
		where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
	</cfquery>
	<cfset LSNnombre = getSNegocios.SNnombre>
	<!--- I N S E R T A   E L   E N C A B  E Z A D O  --->
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
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ETfecha,'YYYYMMDD')#">, 
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
	<!--- I N S E R T A   L O S   D E T A L L E S ---> 
	<cfloop collection="#session.listafactura.articulos#" item="LAid">
		<cfset LCant = session.listafactura.articulos[LAid]>
		<!--- Datos de los Artículos por Facturar --->
		<cfquery name="getArticulo" datasource="#session.dsn#">
			select a.Adescripcion, b.DLprecio
			from Articulos a 
				inner join DListaPrecios b	
				on a.Aid = b.Aid
				and <cf_dbfunction name="now"> between DLfechaini and DLfechafin
				and LPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.lista_precios#"> 
			where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LAid#"> 
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		</cfquery>
		<cfset LPrecio = getArticulo.DLprecio>
		<cfset LDescripcion = getArticulo.Adescripcion>
		<cfquery datasource="#session.dsn#" name="insertETransacciones">
			insert DTransacciones (
					FCid, ETnumero, Ecodigo, DTtipo, Aid, Alm_Aid, Ccuenta, Ccuentades, Cid, FVid, Dcodigo, 
					DTfecha, DTcant, DTpreciou, DTdeslinea, DTtotal, DTborrado, 
					DTdescripcion, DTdescalterna
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LETnumero#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="A">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LAid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Alm_Aid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuenta#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LCcuentadesc#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="" null="yes">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FVid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.ETfecha,'YYYYMMDD')#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#LCant#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="#LPrecio#">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="0.00">, 
					round(<cfqueryparam cfsqltype="cf_sql_money" value="#LCant*LPrecio#">,2), 
					<cfqueryparam cfsqltype="cf_sql_bit" value="0">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#LDescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes">
				)
		</cfquery>
		<cfset LTotal = LTotal + Round(LCant*LPrecio*100)/100>
	</cfloop>
	<!---  A C T U A L I Z A   E L   E N C A B  E Z A D O  --->
	<cfquery name="updateETransacciones" datasource="#session.dsn#">
		update ETransacciones
		set ETtotal = round(#LTotal#,2)
		where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
		and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LETnumero#">
	</cfquery>
	<cfif session.debug>
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
<cf_template>
<cf_templatearea name="title">
	Factura Confiramada</cf_templatearea>
<cf_templatearea name="body">
	<cfoutput>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td colspan="2"><p><strong>Se gener&oacute; la factura n&uacute;mero #LETnumero# por <br>un monto de #LSCurrencyFormat(LTotal,'none')#.</strong></p></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2"><input name="return" type="image" onClick="location.href = 'index.cfm'" value="Seguir comprando" src="images/btn_seguir_comprando.gif" alt="Seguir comprando"></td>
		</tr>
	</table>
	</cfoutput>
</cf_templatearea>
</cf_template>

