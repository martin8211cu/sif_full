<!--- ABG: Extraccion de Retiros de Caja Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfset LvarLinkServ = false>
	<!--- Cambiar esta variable a true si se desea que se haga una poliza por cada cierre 
	Poner en false si se desea una sola poliza por sucursal, Operacion ID agrupando todos los retiros--->
	<cfset varDetallado = false>
	<!--- variables datasource --->
	<!--- Rutina para obtener el nombre del server del datasource ldcom --->
	<cfset Varfactory = CreateObject("java", "coldfusion.server.ServiceFactory")>
	<cfset Vards_service = Varfactory.datasourceservice>
	<cfset Vardatasources = Vards_service.getDatasources()>
	<cfloop collection="#Vardatasources#" item="i">
		<cfset Varthisdatasource = Vardatasources[i]>
		<cfif Varthisdatasource.name EQ 'ldcom'>
			 <cfset Lvarserverldcom = trim(Varthisdatasource.urlmap.database)>
			 <cfset Lvarbdldcom = trim(Varthisdatasource.urlmap.database)>
		</cfif>
	</cfloop>
	<cfif NOT isdefined("Lvarserverldcom") OR Len(Lvarserverldcom) LTE 0>
		<cfthrow message="Error al obtener nombre de server para Sistema Comercial, datasource ldcom">
	</cfif>
	<cfif NOT isdefined("Lvarbdldcom") OR Len(Lvarbdldcom) LTE 0>
		<cfthrow message="Error al obtener nombre de la Base de Datos para Sistema Comercial, datasource ldcom">
	</cfif>
	
	<cfset ldcomsrv       	= Lvarserverldcom>
	<cfset ldcomdb       	= Lvarbdldcom>
	<cfif LvarLinkServ>
		<cfset ldcoma = '#ldcomsrv#.#ldcomdb#'>
	<cfelse>
		<cfset ldcoma = '#ldcomdb#'>
	</cfif>
	<cfset sifinterfacesdb 	= "sif_interfaces">
	<cfif isdefined("form.fechaIni") and isdefined("form.fechaFin")>
		<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
		<cfset fechafin = createdate(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2))>
	</cfif>
	
	<!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select o.Emp_Id, s.Cadena_Id, o.Suc_Id, o.Operacion_Id, o.Operacion_Fecha_Apertura, o.Operacion_Fecha_Cierre
		from Sucursal_Operacion o 
			inner join Sucursal s
			on o.Emp_Id = s.Emp_Id and o.Suc_Id = s.Suc_Id
		where Operacion_Estado like 'CERR'
		and CONVERT(CHAR(8), o.Operacion_Fecha_Cierre, 112) 
		<cfif isdefined("fechaini") and isdefined("fechafin")>
			between 
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechaini#'>, 112)
			and 
				CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#fechafin#'>, 112)
		<cfelse>
			= CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#now()#'>, 112)
		</cfif>
		and not exists (select 1 
						from SIFLD_Bitacora_Proceso bp 
						where o.Emp_Id = bp.Emp_Id 
						and o.Suc_Id = bp.Suc_Id
						and o.Operacion_Id = bp.Operacion_Id
						and bp.Proceso like 'RETIROS')
	</cfquery>
	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
		<cftry>
			<!--- Obtiene la Moneda Local --->
			<cfquery name="rsMoneda" datasource="ldcom">
				select Moneda_Id 
				from Moneda 
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and Moneda_Local = 1
			</cfquery>
			<cfif rsMoneda.recordcount EQ 0>
				<cfthrow message="Error al extraer la moneda Local">
			</cfif>
			<!--- Extrae los encabezados para los Retiros que pertenecen a las operaciones Cerradas al momento de la ejecucion --->
			<cfquery name="rsERetiros" datasource="ldcom">
				select Retiro_Id, Caja_Id, Cierre_Id,
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
				from Caja_Cierre_Retiro 
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_id#">
					and Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_id#">
					and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_id#">
			</cfquery>
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
							(Ecodigo, ID_Retiro, Origen,  tipo_Retiro, fecha_Retiro,
							 Concepto_Retiro,Sucursal, NumDoc_Retiro, Estatus)
						values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,	
						 'LD', 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.Tipo_Retiro#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Retiro_Fecha,'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.Concepto_Retiro#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
						 1)
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
					Efectivo = E
					Tarjeta = T
					Cupones = V
					Cheques = H
					MonedaExtranjera = X
					NotadeCredito = N
					Monedero = M
					FondoCaja = F
					
				--->
				<cfset IDlinea = 1>
				<cftransaction action="begin">
				<cftry>
					<cfif rsERetiros.Retiro_Efectivo GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'E',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Efectivo,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_Monedaext GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'X',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Monedaext,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_Cheque GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'H',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Cheque,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_Tarjeta GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'T',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Tarjeta,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_Monedero GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'M',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Monedero,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_Cupon GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'V',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Cupon,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
		
					<cfif rsERetiros.Retiro_NotaCredito GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'N',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_NotaCredito,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_FondoCaja GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
							 'F',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_FondoCaja,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					<cftransaction action="commit" />
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<!--- Borra los registros para el Encabezado que se habia Insertado--->
					<cfquery datasource="sifinterfaces">
						delete DSIFLD_Retiros_Caja
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
							and ID_Retiro =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
						delete ESIFLD_Retiros_Caja
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_id#">
							and ID_Retiro =	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">
					</cfquery>
					<!--- Variables de Error --->
					<cfset ErrCaja = rsERetiros.Caja_Id>
					<cfset ErrFactura = rsERetiros.Retiro_Id>
					<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
					<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
					<cfthrow message="Error Insertando Detalle de Retiro: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
				</cfcatch>
				</cftry>
				</cftransaction>
			</cfloop> <!--- Encabezados Retiros---> 
			</cfif> 
			<!--- Inserta Operacion ID a Bitacora para Ventas --->
			<cfquery datasource="ldcom">
				declare @ID int
				select @ID = isnull(max(Proceso_Id) ,0) + 1
				from SIFLD_Bitacora_Proceso 
				insert SIFLD_Bitacora_Proceso 
					(Proceso_Id, Sistema, Emp_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso)
				values (@ID, 'LD',
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_Id#">,
						'RETIROS',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>	
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
			<cfquery datasource="sifinterfaces">
				declare @ID int
				select @ID = isnull(max(Error_Id),0) + 1
				from SIFLD_Log_Errores
				insert SIFLD_Log_Errores
					(Error_Id, Sistema, Empresa, Sucursal, Operacion, Caja, Bodega,
					Factura, MsgError, Error_Comp, Proceso, Fecha_Proceso)
				values (@ID, 'LD',
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_Id#">,
					<cfif isdefined("ErrCaja")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrCaja#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("ErrBodega")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrBodega#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("ErrFactura")>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#ErrFactura#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#cfcatch.Message#">,
					'#cfcatch.Message# #cfcatch.Detail# #ErrSQL# #ErrPAR#',
					'RETIROS',
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Inserta Log de Error --->
		<cfquery datasource="sifinterfaces">
			declare @ID int
			select @ID = isnull(max(Error_Id),0) + 1
			from SIFLD_Log_Errores
			insert SIFLD_Log_Errores
				(Error_Id, Sistema, Empresa, Sucursal, Operacion, Caja, Bodega,
				Factura, MsgError, Error_Comp, Proceso, Fecha_Proceso)
			values 
				(@ID, 'LD', null, null, null, null, null,
				null, 'No hay Cierres de Sucursal para el Dia de Hoy',
				'No hay Cierres de Sucursal para el Dia de Hoy', 'RETIROS', getdate())
		</cfquery>
	</cfif>
</cffunction>
</cfcomponent>	
	
