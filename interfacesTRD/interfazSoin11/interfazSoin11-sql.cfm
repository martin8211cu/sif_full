<!--- <cfdump var="#Form#"> --->

<cfif isDefined("form.BTNPRECARGAR")>
	<!--- Aqui es donde se tiene que hacer la carga de las tablas IE11 y ID10  equivalentes a los documentos tanto de CXC como de CXP --->
	
	<!--- Los pasos a realizar son los siguientes :
	 1 Hacer los querys necesarios en la parte del Cliente para poder cargar las estructuras IE11 Y IE11
	 2 Unas vez hechos los querys se recorre el registro por registro para ir cargardo las tablas menciondas 
	   esto se debe a que es necesario invocar el componente que genera el id de proceso por cada encabezado que se ingrese
	   *** recuerde que se tiene que hacer un datasource en Coldfusion para poder accesar las bases de datos del cliente.
	   *** que los encabezados de la facturas deben tener almenos una linea de detalle.
	   *** asegurarse insertar los datos que no aceptan null y asi evitar un error de ejecucion.
	   *** cuando se vaya insertar una nueva facturar asegurarse que ya no se encuentra incluida tanto en las tablas de interface
	       como en las tablas de trabajo tanto de CXC y CXP.
	 --->
	 
	 <!--- Query que trae la información del cliente  (Este es que ustedes tiene que hacer en PMI)--->
	 <!--- Query para insertar los encabazados de las facturas  --->
	<cfquery name="rsDatosOrigenEncabezado" datasource="sifinterfaces">
		select 
			'P'  							as TipoCobroPago,
			'254789965413265' 				as CodigoBanco,
			'BN-VIT001-123653 (Colones)' 	as CuentaBancaria,
			getdate() 						as FechaTransaccion,
			'T' 							as TipoPago,
			'IE11' 							as NumeroDocumento,
			'000554' 						as NumeroSocio,
			'000554' 						as NumeroSocioDocumento,
			1910.93							as MontoPago,
			1.00 							as TipoCambio,
			'CRC' 							as CodigoMonedaPago,
			'XXX' 							as TransaccionOrigen
	</cfquery>
	 <!--- Carga de datos en las tablas IE11 y ID11 --->
	 
	 <cfif rsDatosOrigenEncabezado.recordCount GT 0>
		 <cfloop query="rsDatosOrigenEncabezado">
			<cfinvoke 
				component="interfacesSoin.Componentes.interfaces"
				method="fnSiguienteIdProceso" 
				returnvariable="LvarID">
  		    <!--- inserta encabazado de la factura  --->
			
			<!--- la interfaz 11 tiene la particularidad de que se puede llenar solamente el encabezado (IE11) 
			ya que en la version anterior solo se podía pagar solamente una factura , ahora se creo un detalle (ID11)
			el cual me permite pagar varias facturas con un cheque, por lo tanto el campo ConDetalle del encabezado 
			siempre tiene que ser 'S' , y no se permite llenar solo el encabezado. y el StatusProceso siempre tiene que ser 1 
			--->

			<cfquery name="rsInsEncabezado" datasource="sifinterfaces">
				insert into IE11 (
					ID,
					EcodigoSDC,
					TipoCobroPago,
					CodigoBanco,
					CuentaBancaria,
					FechaTransaccion,
					TipoPago,
					NumeroDocumento,
					NumeroSocio,
					NumeroSocioDocumento,
					MontoPago,
					TipoCambio,
					CodigoMonedaPago,
					TransaccionOrigen,
					BMUsucodigo,
					StatusProceso,
					ConDetalle 
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.ecodigosdc#">,	
					<cfqueryparam cfsqltype="cf_sql_char"		value="#rsDatosOrigenEncabezado.TipoCobroPago#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CodigoBanco#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CuentaBancaria#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#rsDatosOrigenEncabezado.FechaTransaccion#">,
					<cfqueryparam cfsqltype="cf_sql_char"		value="#rsDatosOrigenEncabezado.TipoPago#">, 
					<cfqueryparam cfsqltype="cf_sql_char"		value="#rsDatosOrigenEncabezado.NumeroDocumento#-#LvarID#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.NumeroSocio#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.NumeroSocioDocumento#">,
					<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenEncabezado.MontoPago#">,
					<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenEncabezado.TipoCambio#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CodigoMonedaPago#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.TransaccionOrigen#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,
					1,
					1     
				)
			</cfquery>
		
		 	<!--- Query para insertar las lineas de la facturas  --->
			<cfquery name="rsDatosOrigenDetalle" datasource="sifinterfaces">
				select 
					'CO' 		as CodigoTransaccion,
					'CP 07_07_2005'	as Documento,
					910.93   		as MontoPago,
					910.93   		as MontoPagoDocumento,
					'CRC' 		as CodigoMonedaDoc
				union
				select
					'CO' 		as CodigoTransaccion,
					'ACTIVOSANDREA003'	as Documento,
					1000   		as MontoPago,
					1000   		as MontoPagoDocumento,
					'CRC' 		as CodigoMonedaDoc
			
			</cfquery>	
			<cfloop query="rsDatosOrigenDetalle">
				<cfquery name="rsInsDetalle" datasource="sifinterfaces">
					insert into ID11 (
						ID,
						CodigoTransaccion,
						Documento,
						MontoPago,
						MontoPagoDocumento,
						CodigoMonedaDoc,
						BMUsucodigo					
					)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  	value="#rsDatosOrigenDetalle.CodigoTransaccion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar"    value="#rsDatosOrigenDetalle.Documento#">,
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.MontoPago#">, 
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.MontoPagoDocumento#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenDetalle.CodigoMonedaDoc#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">
					)
				</cfquery>
			</cfloop>
		 </cfloop>
	 </cfif>
<cfelseif isDefined("form.BTNAPLICAR")>
	<cfquery name="rsQueryID" datasource="sifinterfaces">
		select 
			ID,
			StatusProceso
		from IE11 
		where EcodigoSDC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#">
		and StatusProceso in (1,11)  
		order by ID
	</cfquery>
	<cfset LvarMSG = "">
	<cfloop query="rsQueryID">
		<cfif #rsQueryID.StatusProceso# eq 1>
			<cfinvoke 
				component="interfacesSoin.Componentes.interfaces" 
				method="fnProcesoNuevoExterno" 
				returnvariable="LvarMSG"
				NumeroInterfaz="11"
				IdProceso="#rsQueryID.ID#"
				UsuarioDbInclusion="#session.usulogin#"
			> 
		<cfelse>
			<cfinvoke 
				component="interfacesSoin.Componentes.interfaces" 
				method="fnBitacoraReprocesar" 
				returnvariable="LvarMSG"
				NumeroInterfaz="11"
				IdProceso="#rsQueryID.ID#"
				UsuarioDbInclusion="#session.usulogin#"
			>
		</cfif>
		<cfoutput>
		<cfif LvarMSG NEQ "OK">
			<cfquery name="rsupdate" datasource="sifinterfaces">
				update IE11 set StatusProceso  = 11 
				where ID = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsQueryID.ID#">
			</cfquery>
			<cfbreak>
		<cfelse>
			<cfquery name="rsupdate" datasource="sifinterfaces">
				update IE11 set StatusProceso  = 10
				where ID = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsQueryID.ID#">
			</cfquery>
		</cfif>
		</cfoutput>
		<cfset LvarMSG = "">
	</cfloop>
</cfif>


<form action="interfazSoin11-lista.cfm" method="post" name="sql">
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
