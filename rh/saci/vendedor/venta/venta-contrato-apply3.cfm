<cfif isdefined("form.Guardar") or isdefined("form.GuardarContinuar") or (isdefined("form.submitMenu") and form.submitMenu EQ 1)>
	<cfif form.CTcobro EQ "4">						
		<cfset CTid = form.CTid>
		<cfset CTcobro = form.CTcobro>
		<cfset CTtipoCtaBco = "">
		<cfset CTbcoRef = "">
		<cfset CTmesVencimiento = "">
		<cfset CTanoVencimiento = "">
		<cfset CTverificadorTC = "">
		<cfset EFid = "">
		<cfset MTid = "">
		<cfset PpaisTH = "">
		<cfset CTcedulaTH = "">
		<cfset CTnombreTH = ""> 
		<cfset CTapellido1TH = "">
		<cfset CTapellido2TH = "">
		
		
	<cfelseif  form.CTcobro EQ "2">
		<cfset CTid = form.CTid>
		<cfset CTcobro = form.CTcobro>
		<cfset CTtipoCtaBco = "">
		<cfset CTbcoRef = form.NumTarjeta>
		<cfset CTmesVencimiento = form.MesTarjeta>
		<cfset CTanoVencimiento = form.AnoTarjeta>
		<cfset CTverificadorTC = form.VerificaTarjeta>
		
		<cfif isdefined("form.MTid") and len(form.MTid)>
			<cfquery datasource="#session.DSN#"	name="myEFid">
				select EFid 
					  from ISBentidadFinanciera a
					where a.IFCCOD = (select min(b.IFCCOD) 
					                      from ISBtarjeta b 
					                    where b.MTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MTid#">
					                  )
			</cfquery>
		</cfif>
		<cfset EFid = "">
		<cfif isdefined("myEFid")and  myEFid.recordCount gt 0>
			<cfset EFid = "#myEFid.EFid#">
		</cfif>
		
		<cfset MTid = form.MTid>
		<cfset PpaisTH = form.Ppais>
		<cfset CTcedulaTH = form.CedulaTarjeta>
		<cfset CTnombreTH = form.NombreTarjeta> 
		<cfif isdefined("form.Apellido1Tarjeta")>
			<cfset CTapellido1TH = form.Apellido1Tarjeta>
		<cfelse>
			<cfset CTapellido1TH = ''>
		</cfif>
		
		<cfif isdefined("form.Apellido2Tarjeta")>
			<cfset CTapellido2TH = form.Apellido2Tarjeta>
		<cfelse>
			<cfset CTapellido2TH = ''>
		</cfif>
	<cfelseif form.CTcobro EQ "3">
		<cfset CTid = form.CTid>
		<cfset CTcobro = form.CTcobro>
		<cfset CTtipoCtaBco = form.CuentaTipo>
		<cfset CTbcoRef = form.NumCuenta>
		<cfset CTmesVencimiento = "">
		<cfset CTanoVencimiento = "">
		<cfset CTverificadorTC = "">
		<cfset EFid = form.EFid>					
		<cfset MTid = "">
		<cfset PpaisTH = "">
		<cfset CTcedulaTH = form.CedulaCuenta>
		<cfset CTnombreTH =form.NombreCuenta> 
		<cfset CTapellido1TH = form.Apellido1Cuenta>
		<cfset CTapellido2TH = form.Apellido2Cuenta>
		
	</cfif>
		
	<!--- Datos de la Cuenta --->
	<cfquery name="rsCuenta" datasource="#Session.DSN#">
		select a.CTtipoUso
		from ISBcuenta a
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
	</cfquery>

	<!--- Si la cuenta que se está modificando es de tipo acceso para agente, averiguar la cuenta de tipo facturacion del agente --->	
	<cfif rsCuenta.CTtipoUso EQ 'A'>
		<cfquery name="rsDatosAgente" datasource="#Session.DSN#">
			select a.CTidFactura
			from ISBagente a
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
			and a.CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		</cfquery>
		<cfif rsDatosAgente.recordCount GT 0>
			<cfset LvarFacturacionAgente = rsDatosAgente.CTidFactura>
		</cfif>
	</cfif>

	<cftransaction>
		
		<cfinvoke component="saci.comp.ISBcuentaCobro" method="Cambio">
			<cfinvokeargument name="CTid" value="#CTid#">
			<cfinvokeargument name="CTcobro" value="#CTcobro#">
			<cfinvokeargument name="CTtipoCtaBco" value="#CTtipoCtaBco#">
			<cfinvokeargument name="CTbcoRef" value="#CTbcoRef#">
			<cfinvokeargument name="CTmesVencimiento" value="#CTmesVencimiento#">
			<cfinvokeargument name="CTanoVencimiento" value="#CTanoVencimiento#">
			<cfinvokeargument name="CTverificadorTC" value="#CTverificadorTC#">
			<cfinvokeargument name="EFid" value="#EFid#">
			<cfinvokeargument name="MTid" value="#MTid#">
			<cfinvokeargument name="PpaisTH" value="#PpaisTH#">
			<cfinvokeargument name="CTcedulaTH" value="#CTcedulaTH#">
			<cfinvokeargument name="CTnombreTH" value="#CTnombreTH#">
			<cfinvokeargument name="CTapellido1TH" value="#CTapellido1TH#">
			<cfinvokeargument name="CTapellido2TH" value="#CTapellido2TH#">
		</cfinvoke>

		<!--- Si la cuenta es de tipo acceso del agente, hay que actualizar también los datos de la cuenta de facturación del agente --->
		<cfif isdefined("LvarFacturacionAgente") and Len(Trim(LvarFacturacionAgente))>
			<cfinvoke component="saci.comp.ISBcuentaCobro" method="Cambio">
				<cfinvokeargument name="CTid" value="#LvarFacturacionAgente#">
				<cfinvokeargument name="CTcobro" value="#CTcobro#">
				<cfinvokeargument name="CTtipoCtaBco" value="#CTtipoCtaBco#">
				<cfinvokeargument name="CTbcoRef" value="#CTbcoRef#">
				<cfinvokeargument name="CTmesVencimiento" value="#CTmesVencimiento#">
				<cfinvokeargument name="CTanoVencimiento" value="#CTanoVencimiento#">
				<cfinvokeargument name="CTverificadorTC" value="#CTverificadorTC#">
				<cfinvokeargument name="EFid" value="#EFid#">
				<cfinvokeargument name="MTid" value="#MTid#">
				<cfinvokeargument name="PpaisTH" value="#PpaisTH#">
				<cfinvokeargument name="CTcedulaTH" value="#CTcedulaTH#">
				<cfinvokeargument name="CTnombreTH" value="#CTnombreTH#">
				<cfinvokeargument name="CTapellido1TH" value="#CTapellido1TH#">
				<cfinvokeargument name="CTapellido2TH" value="#CTapellido2TH#">
			</cfinvoke>
		</cfif>
		
	</cftransaction>
	
</cfif>
