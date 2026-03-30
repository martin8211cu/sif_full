<!----
	Author: 	   Rodrigo Ivan Rivera Meneses
	Name: 		   LD_Extraccion_RetirosCaja.cfc
	Based on :     Extraccion_RetirosCaja.cfc by Alejandro Bolaños
	Version: 	   1.0
	Date Created:  19-NOV-2015
	Date Modified: 19-NOV-2015
	Hint:		   This Process is heavy on the memory, if you get the java overhead limit exceeded error,
				   avoid calling the GC directly and instead increase the java heap size in the coldfusion administrator
--->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfset LvarLinkServ = false>
	<!--- Cambiar esta variable a true si se desea que se haga una poliza por cada cierre
	Poner en false si se desea una sola poliza por sucursal, Operacion ID agrupando todos los retiros--->
	<cfset varDetallado = false>
	<!--- variables --->
	<cfset DataSource = 'ldcom'>
	<cfset ErrCaja 	  = "">
	<cfset ErrBodega  = "">
	<cfset ErrFactura = "">
	<cfset this.IDlinea = 0>

	<!--- Asigna las variables de fechas --->
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdate(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2))>
	<cfelse>
		<cfset fechaini = 0>
		<cfset fechafin = 0>
	</cfif>
	<!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfinvoke component = "ModuloIntegracion.Componentes.Operaciones" method="init" returnvariable="O" />
	<cfset varArguments = {DataSource = "#DataSource#",Estado = "CERR", FechaIni = "#fechaini#", FechaFin = "#fechafin#", Proceso = "RETIROS"}>
	<cfset rsOperacionID = O.getOperacionesLD(argumentCollection = varArguments)>
	<!--- Proceso --->
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
			<cftry>
				<!--- Obtiene la Moneda Local --->
				<cfset rsMoneda = O.getMonedaLD(DataSource,Emp_Id)>
				<cfif rsMoneda.recordcount EQ 0>
					<cfthrow message="Error al extraer la moneda Local">
				</cfif>
				<!--- Extrae los encabezados para los Retiros que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
				<cfset rsERetiros = getEncabezado(DataSource,Emp_Id,Suc_Id,Operacion_Id)>
				<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
				<cfif isdefined("rsERetiros") AND rsERetiros.recordcount GT 0>
					<cfloop query="rsERetiros">
						<!--- ID para la tabla de Encabezados --->
						<cfquery name="rsMaxIDE" datasource="sifinterfaces">
							select isnull(max(ID_Retiro),0) + 1 as MaxID
							from ESIFLD_Retiros_Caja
						</cfquery>
						<!--- Crea el numero de Documento --->
						<cfif varDetallado>
							<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & numberformat(rsERetiros.Caja_Id,"00") & numberformat(rsERetiros.Cierre_Id,"00000000") & "-" & numberformat(rsERetiros.Retiro_Id,"00")>
						<cfelse>
							<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & "-" & numberformat(rsOperacionID.Operacion_Id,"000000000")>
						</cfif>
						<cftransaction action="begin">
						<cftry>
							<!--- Inserta los encabezados --->
							<cfquery datasource="sifinterfaces">
								insert into ESIFLD_Retiros_Caja
											(Ecodigo, ID_Retiro, Origen,  Tipo_Retiro, Fecha_Retiro,
									 		Concepto_Retiro, Sucursal, NumDoc_Retiro, Estatus, Fecha_Inclusion)
								values
										(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
										 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
										 'LD',
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.Tipo_Retiro#">,
										 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Retiro_Fecha,'short')#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.Concepto_Retiro#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
										 1,
										 '#DateFormat(now(),'yyyy-mm-dd HH:mm:ss')#')
							</cfquery>
							<cftransaction action="commit" />
						<cfcatch type="any">
							<cftransaction action="rollback" />
							<!--- Variables de Error --->
							<cfset ErrCaja = rsERetiros.Caja_Id>
							<cfset ErrFactura = rsERetiros.Retiro_Id>
							<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
							<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
							<cfthrow message="Error al Insertar el Encabezado: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
						</cfcatch>
						</cftry>
						</cftransaction>
						<!--- Inserta los detalles del Retiro de Caja --->
						<!---
							Efectivo 		 = E
							Tarjeta 		 = T
							Cupones			 = V
							Cheques			 = H
							MonedaExtranjera = X
							NotadeCredito	 = N
							Monedero 	 	 = M
							FondoCaja 		 = F
						--->
						<cfset this.IDlinea = 1>
						<cftransaction action="begin">
						<cfif rsERetiros.Retiro_Efectivo GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'E',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_Monedaext GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'X',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_Cheque GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'H',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_Tarjeta GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'T',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_Monedero GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'M',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_Cupon GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'V',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_NotaCredito GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'N',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cfif rsERetiros.Retiro_FondoCaja GT 0>
							<cfset rsDRetiros = setDetalle('sifinterfaces',
															  rsOperacionID.Cadena_Id,
															  rsMaxIDE.MaxID,
															  'F',
															  this.IDlinea,
															  rsERetiros.Retiro_Efectivo)>
						</cfif>
						<cftransaction action="commit" />
						</cftransaction>
					</cfloop> <!--- Encabezados Retiros--->
				</cfif>
				<!--- Inserta Operacion ID a Bitacora para Ventas --->
				<cfset varArgumentsBP = {Sistema   = "LD",
										 Empresa   = "#rsOperacionID.Emp_Id#",
										 Sucursal  = "#rsOperacionID.Suc_Id#",
										 Operacion = "#rsOperacionID.Operacion_Id#",
										 Proceso   = "RETIROS"}>
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
				<cfset varArgumentsLE = {Sistema    = "LD",
										 Empresa    = "#rsOperacionID.Emp_Id#",
										 Sucursal   = "#rsOperacionID.Suc_Id#",
										 Operacion  = "#rsOperacionID.Operacion_Id#",
										 ErrCaja    = "#ErrCaja#",
										 ErrBodega  = "#ErrBodega#",
										 ErrFactura = "#ErrFactura#",
										 MsgError   = "#cfcatch.Message#",
										 Error_Comp = "#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#",
										 Proceso    = "RETIROS"}>
				<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
			</cfcatch>
			</cftry>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Inserta Log de Error --->
		<cfset varArgumentsLE = {Sistema    ="LD",
								 MsgError 	="No hay Cierres de Sucursal para el Dia de Hoy",
								 Error_Comp ="No hay Cierres de Sucursal para el Dia de Hoy",
								 Proceso 	="RETIROS"}>
		<cfset LogErrores = O.setLogErrores(argumentCollection=varArgumentsLE)>
	</cfif>
</cffunction>
<cffunction name="getEncabezado" access="private" output="false">
	<cfargument name="DataSource" 	type="string" required="True" default="" />
	<cfargument name="Emp_Id" 	  	type="string" required="True" default="" />
	<cfargument name="Suc_Id"     	type="string" required="True" default="" />
	<cfargument name="Operacion_Id"	type="string" required="True" default="" />
		<cfquery name="rsEncabezado" datasource="#Arguments.DataSource#">
			SELECT 	Retiro_Id, Caja_Id, Cierre_Id,
					case
						when Retiro_Tipo like 'N' then 'RC'
					when Retiro_Tipo like 'D' then 'GS'
					else 'AN' end as Tipo_Retiro,
					case
						when Retiro_Tipo like 'N' then 'RC'
						when Retiro_Tipo like 'D' then convert(varchar(10),tipogasto_id)
					else 'AN' end as Concepto_Retiro,
					Retiro_Fecha,
					Retiro_Efectivo, Retiro_Monedaext, Retiro_Cheque, Retiro_Tarjeta,
					Retiro_Monedero, Retiro_Cupon, Retiro_NotaCredito, Retiro_FondoCaja
			  FROM 	Caja_Cierre_Retiro
			 WHERE 	Emp_Id 		 = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_id#">
			   AND 	Suc_Id 		 = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_id#">
			   AND 	Operacion_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_Id#">
		</cfquery>
	<cfreturn rsEncabezado>
</cffunction>
<cffunction name="setDetalle" access="private" output="true">
	<cfargument name="DataSource" 	   type="string" required="false" default="sifinterfaces" />
	<cfargument name="Cadena_Id"  	   type="string" required="True" default="" />
	<cfargument name="MaxID"      	   type="string" required="True" default="" />
	<cfargument name="FormaRetiro" 	   type="string" required="True" default="" />
	<cfargument name="IDlinea" 	  	   type="string" required="True" default="" />
	<cfargument name="Retiro_Efectivo" type="string"  required="True" default="" />
	<!--- <cf_dump var="#arguments#"> --->
	<cftry>
		<cfquery name="rsEncabezado" datasource="#Arguments.DataSource#">
			INSERT INTO DSIFLD_Retiros_Caja
				(Ecodigo, Origen, ID_Retiro, Id_Linea_Retiro, Forma_Retiro,
				 Codigo_Forma_Retiro, Monto_Retiro)
			VALUES
				(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cadena_Id#">,
				 'LD',
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MaxID#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#IDlinea#">,
				 '#Arguments.FormaRetiro#',
				 '',
				 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(Arguments.Retiro_Efectivo,9.99)#">)
		</cfquery>
		<cfset this.IDlinea = this.IDlinea + 1>
	<cfcatch type="any">
		<cftransaction action="rollback" />
		<!--- Borra los registros para el Encabezado que se habia Insertado--->
		<cfquery datasource="sifinterfaces">
			DELETE DSIFLD_Retiros_Caja
			 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
			   AND ID_Retiro =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
			DELETE ESIFLD_Retiros_Caja
			 WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
			   AND ID_Retiro =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
		</cfquery>
		<!--- Variables de Error --->
		<cfset ErrCaja = rsERetiros.Caja_Id>
		<cfset ErrFactura = rsERetiros.Retiro_Id>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
		<cfthrow message="Error Insertando Detalle de Retiro: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
</cffunction>
</cfcomponent>

