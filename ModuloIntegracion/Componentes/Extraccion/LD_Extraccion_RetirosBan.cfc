<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   LD_Extraccion_RetirosBan.cfc
	Based on :     Extraccion_RetirosBancos.cfc by Alejandro Bolaños
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Hint:		   This Process is heavy on the memory, if you get the java overhead limit exceeded error,
				   avoid calling the GC directly and instead increase the java heap size in the coldfusion administrator
--->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<!--- Variables --->
	<cfset DataSource = 'ldcom'>
	<cfset ErrCaja 	  = "">
	<cfset ErrBodega  = "">
	<cfset ErrFactura = "">
	<!--- Asigna variables de fecha --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdate(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2))>
	<cfelse>
		<cfset fechaini = 0>
		<cfset fechafin = 0>
	</cfif>
	<!--- Obtiene operaciones no procesadas a realizar --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones" method="init" returnvariable="O" />
	<cfset varArguments = {DataSource = "#DataSource#",
						   FechaIni = "#fechaini#",
						   FechaFin = "#fechafin#",
						   Proceso = "BANCOS"}>
	<cfset rsOperacionID = O.getOperacionesBancoLD(argumentCollection = varArguments)>
	<!--- <cf_dump var=#rsOperacionID#> --->
	<!--- Proceso --->
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
			<cftry>
				<!--- Obtiene la Moneda Local --->
				<cfset rsMoneda = O.getMonedaLD(DataSource,Emp_Id)>
				<cfif rsMoneda.recordcount EQ 0>
					<cfthrow message="Error al extraer la moneda Local">
				</cfif>
				<!--- Extrae los encabezados para los Retiros Bancos --->
				<cfset rsERetiroB = getEncabezado(DataSource,
												  Emp_Id,
												  Suc_Id,
												  Operacion_Id,
												  rsOperacionID.Operacion_Fecha_Apertura,
												  rsOperacionID.Operacion_Fecha_Cierre)>
				<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
				<cfif isdefined("rsERetiroB") AND rsERetiroB.recordcount GT 0>
					<cfloop query="rsERetiroB">
						<!--- ID para la tabla de Encabezados --->
						<cfquery name="rsMaxIDE" datasource="sifinterfaces">
							select isnull(max(ID_MovimientoB),0) + 1 as MaxID
							from SIFLD_Movimientos_Bancarios
						</cfquery>
						<!--- Crea el numero de Documento --->
						<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & "-" &  Deposito_NumeroControl>
						<cftransaction action="begin">
						<cfquery name="fechaProceso" datasource="sifinterfaces">
								select getdate()as fechaP
						</cfquery>
						<cfset varMonedaL = rsMoneda.Moneda_Id>
						<cfset fechaProceso =#fechaProceso.fechaP#>
						<cftry>
							<!--- Inserta los encabezados --->
							<cfquery datasource="sifinterfaces">
								insert into SIFLD_Movimientos_Bancarios
									(Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento,
									 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen,
									 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus, Concepto,
									 Tipo_Cambio, Moneda, Fecha_Inclusion)
								values
								(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
								 'LD',
								 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
								 'CFT',
								 'D',
								 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiroB.Deposito_Fecha,'short')#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiroB.Deposito_Cometario#">,
								 null,
								 null,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiroB.Banco_Id#">,
								 null,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(rsERetiroB.Deposito_Monto,'9.99')#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
								 1,
								 'DP',
								 1,
								 convert(varchar,<cfqueryparam cfsqltype="cf_sql_numeric" value="#varMonedaL#">),
								 '#fechaProceso#')
							</cfquery>
							<cftransaction action="commit" />
						<cfcatch type="any">
							<cftransaction action="rollback" />
							<!--- Variables de Error --->
							<cfset ErrFactura = rsERetiroB.Deposito_Id>
							<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
							<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
							<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
						</cfcatch>
						</cftry>
						</cftransaction>
					</cfloop> <!--- Encabezados Inventario--->
				</cfif>
				<!--- Inserta Operacion ID a Bitacora para BANCOS --->
				<cfset varArgumentsBP = {Sistema   = "LD",
										 Empresa   = "#rsOperacionID.Emp_Id#",
										 Sucursal  = "#rsOperacionID.Suc_Id#",
										 Operacion = "#rsOperacionID.Operacion_Id#",
										 Proceso   = "BANCOS"}>
				<cfset BitacoraProcesos = O.setBitacoraProcesos(argumentCollection=varArgumentsBP)>
			<cfcatch type="any">
				<cfoutput>
					<table>
					<tr>
					<td>
					Error: #cfcatch.message#
					</td>
					</tr>
					<cfif isdefined("cfcatch.detail") AND len(cfcatch.detail) NEQ 0>
						<tr>
						<td>
						Detalles: #cfcatch.detail#
						</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.sql") AND len(cfcatch.sql) NEQ 0>
						<tr>
						<td>
						SQL: #cfcatch.sql#
						</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.queryError") AND len(cfcatch.queryError) NEQ 0>
						<tr>
						<td>
						QUERY ERROR: #cfcatch.queryError#
						</td>
						</tr>
					</cfif>
					<cfif isdefined("cfcatch.where") AND len(cfcatch.where) NEQ 0>
						<tr>
						<td>
						Parametros: #cfcatch.where#
						</td>
						</tr>
					</cfif>
					</table>
				</cfoutput>
				<!--- Busca Errores de SQL y Parametros --->
				<cfif isdefined("cfcatch.sql")>
					<cfset ErrSQL = cfcatch.sql>
				<cfelse>
					<cfset ErrSQL = "">
				</cfif>
				<cfif isdefined("cfcatch.where")>
					<cfset ErrPAR = cfcatch.where>
				<cfelse>
					<cfset ErrPAR = "">
				</cfif>
				<!--- Inserta Log de Error --->
				<cfset varArgumentsLE = {Sistema 	= "LD",
										 Empresa	= "#rsOperacionID.Emp_Id#",
										 Sucursal	= "#rsOperacionID.Suc_Id#",
										 Operacion 	= "#rsOperacionID.Operacion_Id#",
										 ErrCaja 	= "#ErrCaja#",
										 ErrBodega  = "#ErrBodega#",
										 ErrFactura = "#ErrFactura#",
										 MsgError   = "#cfcatch.Message#",
										 Error_Comp = "#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#",
										 Proceso    = "BANCOS"}>
				<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
			</cfcatch>
			</cftry>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Inserta Log de Error --->
		<cfset varArgumentsLE = {Sistema	= "LD",
								 MsgError	= "No hay Retiros Bancarios para el Dia de Hoy",
								 Error_Comp = "No hay Retiros Bancarios para el Dia de Hoy",
								 Proceso 	= "BANCOS"}>
		<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
	</cfif>
</cffunction>
<cffunction name="getEncabezado" access="private" output="true">
	<cfargument name="DataSource" type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  type="string" required="true" default="" />
	<cfargument name="Suc_Id" 	  type="string" required="true" default="" />
	<cfargument name="FechaIni"   type="date"   required="true" default="" />
	<cfargument name="FechaFin"   type="date"   required="true" default="" />
		<cfquery name="rsEncabezado" datasource="#Arguments.DataSource#">
			SELECT Suc_Id, Deposito_Id, Deposito_Fecha, Deposito_NumeroControl, Deposito_Cometario,
				   Banco_Id, Deposito_Monto
			  FROM Deposito_Encabezado
			 WHERE Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
			   AND Deposito_Fecha_Conciliacion between
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaIni#">
					AND
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaFin#">
			   AND Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Suc_Id#">
		</cfquery>
	<cfreturn rsEncabezado>
</cffunction>
</cfcomponent>