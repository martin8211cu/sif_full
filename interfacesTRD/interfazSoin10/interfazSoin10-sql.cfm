<!--- <cfdump var="#Form#"> --->

<cfif isDefined("form.BTNPRECARGAR")>
	<!--- Aqui es donde se tiene que hacer la carga de las tablas IE10 y ID10  equivalentes a los documentos tanto de CXC como de CXP --->
	
	<!--- Los pasos a realizar son los siguientes :
	 1 Hacer los querys necesarios en la parte del Cliente para poder cargar las estructuras IE10 Y IE10
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
		'8-987-554' as NumeroSocio,
		'CP' as Modulo,
		'FA' as CodigoTransacion,
		'CCINTERFAZ' as Documento,
		'CRC' as CodigoMoneda,
		getdate() as FechaDocumento,
		getdate() as FechaVencimiento,
		'0' as Facturado,
		'VPMI-00001'VoucherNo,
		'RX' as CodigoRetencion,
		'000'  as CodigoOficina,
		'0060-01'as CuentaFinanciera,
		'10001' as CodigoConceptoServicio,
		27 as BMUsucodigo,
		5 as DiasVencimiento, 
		getdate() as FechaTipoCambio,
		'Ext9584' as CodigoDireccionEnvio,
		'Ext9584' as CodigoDireccionFact,
		1 as StatusProceso 
	
	
<!--- 	union
	select
		'8-987-554' as NumeroSocio,
		'CC' as Modulo,
		'FC' as CodigoTransacion,
		'CCINTERFAZ' as Documento,
		'USD' as CodigoMoneda,
		getdate() as FechaDocumento,
		getdate() as FechaVencimiento,
		'S' as Facturado,
		'VPMI-00002'VoucherNo,
		'RX' as CodigoRetencion,
		'000'  as CodigoOficina,
		'0060-01'as CuentaFinanciera,
		'10001' as CodigoConceptoServicio,
		27 as BMUsucodigo,
		5 as DiasVencimiento, 
		getdate() as FechaTipoCambio,
		'Ext9584' as CodigoDireccionEnvio,
		'Ext9584' as CodigoDireccionFact,
		1 as StatusProceso  --->
		
		
	</cfquery>
	 <!--- Carga de datos en las tablas IE10 y ID10 --->
	 
	 <cfif rsDatosOrigenEncabezado.recordCount GT 0>
		 <cfloop query="rsDatosOrigenEncabezado">
			<cfinvoke 
				component="interfacesSoin.Componentes.interfaces"
				method="fnSiguienteIdProceso" 
				returnvariable="LvarID">
  		    <!--- inserta encabazado de la factura  --->

			<cfquery name="rsInsEncabezado" datasource="sifinterfaces">
				insert into IE10 (
					ID, 
					EcodigoSDC,
					NumeroSocio,
					Modulo,
					CodigoTransacion,
					Documento,
					Estado,
					CodigoMoneda,
					FechaDocumento,
					FechaVencimiento,
					Facturado,
					Origen,
					VoucherNo,
					CodigoRetencion,
					CodigoOficina,
					CuentaFinanciera,
					CodigoConceptoServicio,
					BMUsucodigo,
					DiasVencimiento,
					CodigoDireccionEnvio,
					CodigoDireccionFact,
					FechaTipoCambio,
					StatusProceso 
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarID#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.ecodigosdc#">,	 
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.NumeroSocio#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.Modulo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CodigoTransacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsDatosOrigenEncabezado.Documento#-#LvarID#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CodigoMoneda#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#rsDatosOrigenEncabezado.FechaDocumento#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp"	value="#rsDatosOrigenEncabezado.FechaVencimiento#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.Facturado#">,
					'PMI',
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.VoucherNo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CodigoRetencion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CodigoOficina#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#rsDatosOrigenEncabezado.CuentaFinanciera#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsDatosOrigenEncabezado.CodigoConceptoServicio#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer"  	value="#rsDatosOrigenEncabezado.DiasVencimiento#">, 
					<cfqueryparam cfsqltype="cf_sql_char"	value="#rsDatosOrigenEncabezado.CodigoDireccionEnvio#">,
					<cfqueryparam cfsqltype="cf_sql_char"	value="#rsDatosOrigenEncabezado.CodigoDireccionFact#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#rsDatosOrigenEncabezado.FechaTipoCambio#">,
					1				
				)
			</cfquery>
		
		 	<!--- Query para insertar las lineas de la facturas  --->
			<cfquery name="rsDatosOrigenDetalle" datasource="sifinterfaces">
				select 
					1   as Consecutivo,
					'O' as  TipoItem,
					'JS0005' as CodigoItem,
					1000 as PrecioUnitario,
					'UNI' as CodigoUnidadMedida,
					1 as CantidadTotal,
					1 as CantidadNeta,
					1 as NumeroBOL,
					getdate() as FechaBOL,
					'IV' as CodigoImpuesto, 
					0  as ImporteImpuesto,
					100 as ImporteDescuento, 
					27 as BMUsucodigo,
					900 as PrecioTotal,
					'3' as CodigoAlmacen,
					'0011-03-01'as CuentaFinancieraDet,
					'01' as CentroFuncional,
					'554dd'as OCtransporte, 
					'OR-COMER-1' as OCcontrato,
					'01' as OCconceptoCompra,
					'B' as OCtransporteTipo,
					'popeye' as CodEmbarque
		
				union
				select
					2   as Consecutivo,
					'O' as  TipoItem,
					'JS0005' as CodigoItem,
					1000 as PrecioUnitario,
					'UNI' as CodigoUnidadMedida,
					1 as CantidadTotal,
					1 as CantidadNeta,
					1 as NumeroBOL,
					getdate() as FechaBOL,
					'IV' as CodigoImpuesto, 
					0  as ImporteImpuesto,
					100 as ImporteDescuento, 
					27 as BMUsucodigo,
					900 as PrecioTotal,
					'3' as CodigoAlmacen,
					'0011-03-01' as CuentaFinancieraDet,
					'01' as CentroFuncional,
					'554dd'as OCtransporte, 
					'OR-COMER-1' as OCcontrato,
					'01' as OCconceptoCompra,
					'B' as OCtransporteTipo,
					'popeye' as CodEmbarque				
			</cfquery>	
			<cfloop query="rsDatosOrigenDetalle">
				<cfquery name="rsInsDetalle" datasource="sifinterfaces">
					insert into ID10 (
						ID,
						Consecutivo,
						TipoItem,
						CodigoItem,
						NombreBarco,
						FechaHoraCarga,
						FechaHoraSalida,
						PrecioUnitario,
						CodigoUnidadMedida,
						CantidadTotal,
						CantidadNeta,
						NumeroBOL,
						FechaBOL,
						TripNo,
						ContractNo,
						CodigoImpuesto,
						ImporteImpuesto,
						ImporteDescuento,
						BMUsucodigo,
						CodigoAlmacen,
						CodigoDepartamento,
						PrecioTotal,
						CentroFuncional,
						CuentaFinancieraDet,
						OCtransporte, 
						OCcontrato,
						OCconceptoCompra,
						OCtransporteTipo,
						CodEmbarque						
					)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarID#">,
						<cfqueryparam cfsqltype="cf_sql_integer"  	value="#rsDatosOrigenDetalle.Consecutivo#">, 
						<cfqueryparam cfsqltype="cf_sql_char"     	value="#rsDatosOrigenDetalle.TipoItem#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar"  	value="#rsDatosOrigenDetalle.CodigoItem#">, 
						null,
						null,
						null,
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.PrecioUnitario#">, 
						<cfqueryparam cfsqltype="cf_sql_char"  		value="#rsDatosOrigenDetalle.CodigoUnidadMedida#">, 
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.CantidadTotal#">, 
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.CantidadNeta#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric"  	value="#rsDatosOrigenDetalle.NumeroBOL#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp"  value="#rsDatosOrigenDetalle.FechaBOL#">, 
						null,
						null,
						<cfqueryparam cfsqltype="cf_sql_char"  		value="#rsDatosOrigenDetalle.CodigoImpuesto#">, 
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.ImporteImpuesto#">, 
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.ImporteDescuento#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char"  		value="#rsDatosOrigenDetalle.CodigoAlmacen#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_float"  	value="#rsDatosOrigenDetalle.PrecioTotal#">,
						<cfqueryparam cfsqltype="cf_sql_char"  		value="#rsDatosOrigenDetalle.CentroFuncional#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar"  	value="#rsDatosOrigenDetalle.CuentaFinancieraDet#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  	value="#rsDatosOrigenDetalle.OCtransporte#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  	value="#rsDatosOrigenDetalle.OCcontrato#">,
						<cfqueryparam cfsqltype="cf_sql_varchar"  	value="#rsDatosOrigenDetalle.OCconceptoCompra#">,
						<cfqueryparam cfsqltype="cf_sql_char"  		value="#rsDatosOrigenDetalle.OCtransporteTipo#">,
						<cfqueryparam cfsqltype="cf_sql_char"  		value="#rsDatosOrigenDetalle.CodEmbarque#">
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
		from IE10 
		where EcodigoSDC  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#">
		and StatusProceso in (1,11)  
		order by ID
	</cfquery>
	<!--- <cf_dump var="#rsQueryID#"> --->
	<cfset LvarMSG = "">
	<cfloop query="rsQueryID">
		<cfif #rsQueryID.StatusProceso# eq 1>
			<cfinvoke 
				component="interfacesSoin.Componentes.interfaces" 
				method="fnProcesoNuevoExterno" 
				returnvariable="LvarMSG"
				NumeroInterfaz="10"
				IdProceso="#rsQueryID.ID#"
				UsuarioDbInclusion="#session.usulogin#"
			> 
		<cfelse>
			<cfinvoke 
				component="interfacesSoin.Componentes.interfaces" 
				method="fnBitacoraReprocesar" 
				returnvariable="LvarMSG"
				NumeroInterfaz="10"
				IdProceso="#rsQueryID.ID#"
				UsuarioDbInclusion="#session.usulogin#"
			>
		</cfif>
		<cfoutput>
		<cfif LvarMSG NEQ "OK">
			<cfquery name="rsupdate" datasource="sifinterfaces">
				update IE10 set StatusProceso  = 11 
				where ID = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsQueryID.ID#">
			</cfquery>
			<cfbreak>
		<cfelse>
			<cfquery name="rsupdate" datasource="sifinterfaces">
				update IE10 set StatusProceso  = 10
				where ID = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsQueryID.ID#">
			</cfquery>
		</cfif>
		</cfoutput>
		<cfset LvarMSG = "">
	</cfloop>
</cfif>


<form action="interfazSoin10-lista.cfm" method="post" name="sql">
</form>
<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
