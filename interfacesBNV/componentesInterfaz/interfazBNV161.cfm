<!--- 
	Interfaces desde BNValores hacia SOIN.
	Interfaz 160: Bancos
	Entradas :
		ID : ID del Proceso a crear.
--->

<!--- Crea Instancia de Componente de Interfaces para reportar actividad de la intarfaz --->
<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<!--- Lectura de IE161 --->
<!---<cftransaction isolation="read_uncommitted">--->
	<!--- Lee encabezado y detalles por procesar. --->
	<cfquery name="readInterfaz161" datasource="sifinterfaces">
		select 	Id,
				Banco,
				CuentaBancaria,
				Descripcion,
				TipoCuenta, <!--- (1,2) --->
				Moneda_ISO,
				CuentaCliente,
				CodigoOficina,
				CuentaFinanciera,
				Modo,
				Usuario

		from IE161

		where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fue por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>

	<!--- Valida que vengan datos --->
	<cfif readInterfaz161.recordcount eq 0>
		<cfthrow message="Error en Interfaz 161. No existen datos de Entrada para el ID='#GvarID#' o no tiene detalles definidos. Proceso Cancelado!.">
	</cfif>

<!---</cftransaction>--->

<!--- Reporta actividad de la interfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>
<!--- Validaciones. --->
		<!--- validar banco --->
		
	<!--- procesa la interfaz --->
	<cftransaction>
	<cfloop query="readInterfaz161">
		<!--- recupera codigo de banco --->
		<cfquery name="rsBanco" datasource="#session.DSN#">
			select Bid
			from Bancos
			where Bcodigocli = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.Banco#">
		</cfquery>
		<cfif rsBanco.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 161. Banco #rsBanco.Banco# no existe. Proceso Cancelado!.">
		</cfif>
		
		<!--- valida tipo de cuenta --->
		<cfif listfind('1,2', readInterfaz161.TipoCuenta) eq 0 >
			<cfthrow message="Error en Interfaz 161. Tipos de Cuenta incorrecto. Debe ser 1:Ahorros, 2:Corriente. Proceso Cancelado!.">
		</cfif>
		
		<!--- recupera moneda --->
		<cfquery name="rsMoneda" datasource="#session.DSN#">
			select Mcodigo, Miso4217 
			from Monedas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.Moneda_ISO#">
		</cfquery>
		<!--- validar moneda --->
		<cfif rsMoneda.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 161. Moneda #rsMoneda.Miso4217# no existe. Proceso Cancelado!.">
		</cfif>
		
		<!--- recupera oficina --->
		<cfquery name="rsoficina" datasource="#session.DSN#">
			select Ocodigo, Oficodigo
			from Oficinas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Oficodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CodigoOficina#">
		</cfquery>
		<!--- validar oficina --->
		<cfif rsoficina.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 161. Oficina #rsoficina.Oficodigo# no existe. Proceso Cancelado!.">
		</cfif>
		
		<!--- CAMBIAR ESTO recupera cuenta financiera --->
		<cfquery name="rsCuenta" datasource="#session.DSN#">
			select Ccuenta  
			from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaFinanciera#">
		</cfquery>		
		<!--- validar cuenta financiera --->
		<cfif rsCuenta.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 161. Cuenta financiera #readInterfaz161.CuentaFinanciera# no existe. Proceso Cancelado!.">
		</cfif>

		<!--- recupera cuenta financiera --->
		<cfquery name="rsCuenta6" datasource="#session.DSN#">
			select Ccuenta  
			from CContables
			where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.Ccuenta#">
			  and Mcodigo = 6
		</cfquery>		
		<!--- validar cuenta financiera --->
		<cfif rsCuenta6.recordcount eq 0 >
			<cfthrow message="Error en Interfaz 161. Cuenta financiera #readInterfaz161.CuentaFinanciera# no es de Bancos. Proceso Cancelado!.">
		</cfif>

		<!--- agregar --->	
		<cfif readInterfaz161.Modo eq 'A' >
			<!--- recupera codigo de banco --->
			<cfquery name="rsCBanco" datasource="#session.DSN#">
				select CBid
				from CuentasBancos
				where Bid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsBanco.Bid#">
				  and CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaBancaria#">
                  and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfif rsCBanco.recordcount gt 0 >
				<cfthrow message="Error en Interfaz 161. Cuenta Bancaria #readInterfaz161.CuentaBancaria# ya existe. Proceso Cancelado!.">
			</cfif>
		
		
			<cfquery datasource="#session.DSN#">
				insert into CuentasBancos(   Bid, 
											 Ecodigo,
											 Ocodigo,
											 Mcodigo,
											 Ccuenta,
											 CBcodigo, 		
											 CBdescripcion, 
											 CBcc, 			
											 CBTcodigo, 	
											 BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBanco.Bid#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficina.Ocodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.Ccuenta#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaBancaria#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.Descripcion#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaCliente#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz161.TipoCuenta#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
			</cfquery>
		<!--- cambiar --->
		<cfelse>
			<!--- recupera codigo de banco --->
			<cfquery name="rsCBanco" datasource="#session.DSN#">
				select CBid
				from CuentasBancos
				where Bid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsBanco.Bid#">
				  and CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaBancaria#">
                  and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfif rsCBanco.recordcount eq 0 >
				<cfthrow message="Error en Interfaz 161. Cuenta Bancaria #readInterfaz161.CuentaBancaria# no existe. Proceso Cancelado!.">
			</cfif>
			
			<cfquery name="rsMonedas" datasource="#session.DSN#">
				select m.Miso4217
				from CuentasBancos cb, Monedas m
				where cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCBanco.CBid#">
                	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfif trim(readInterfaz161.Moneda_ISO) neq trim(rsMonedas.Miso4217)>
				<cfquery name="rsMovimientos" datasource="#session.DSN#">
					select 1
					from MLibros
					where cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCBanco.CBid#">
				</cfquery>
				<cfif rsMovimientos.recordcount gt 0 >
					<cfthrow message="Error en Interfaz 161. Cuenta Bancaria posee movimientos para la moneda #rsMonedas.Miso4217#. No es posible modificar la moneda. Proceso cancelado!">
				</cfif>
			</cfif>
		
			<cfquery datasource="#session.DSN#">
				update CuentasBancos
				set Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBanco.Bid#">,
					Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOficina.Ocodigo#">,
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
					Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuenta.Ccuenta#">,
					CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaBancaria#">,
					CBdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.Descripcion#">,
					CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaCliente#">,
					CBTcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#readInterfaz161.TipoCuenta#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#readInterfaz161.CuentaBancaria#">
			</cfquery>
		</cfif>
	</cfloop>
	</cftransaction>

<!--- Reporta actividad de la intarfaz --->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>