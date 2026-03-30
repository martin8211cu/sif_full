<!--- Extraccion de Retiros de Tombola Interfaz LD-SIF Ver. 2.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent>
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
	<cfset LvarLinkServ = false>
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
	<cfquery datasource="ldcom" name="rsOperacionIDLD">
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
	</cfquery>
	<cfquery name ="temp" datasource = "sifinterfaces">
		IF OBJECT_ID('tempdb..##LocalTempRetiroBanco', 'U') IS NOT NULL
		DROP TABLE ##LocalTempRetiroBanco
		CREATE TABLE ##LocalTempRetiroBanco(Emp_Id int,Cadena_Id int,Suc_Id int,Operacion_Id int,Operacion_Fecha_Apertura DATETIME,Operacion_Fecha_Cierre DATETIME)
		<cfloop query="rsOperacionIDLD">
			INSERT INTO ##LocalTempRetiroBanco VALUES(#rsOperacionIDLD.Emp_Id#,#rsOperacionIDLD.Cadena_Id#,#rsOperacionIDLD.Suc_Id#,#rsOperacionIDLD.Operacion_Id#,'#rsOperacionIDLD.Operacion_Fecha_Apertura#','#rsOperacionIDLD.Operacion_Fecha_Cierre#')
		</cfloop>
	</cfquery>
	<cfquery name="rsOperacionID" datasource = "sifinterfaces">
		select * from ##LocalTempRetiroBanco o WHERE NOT exists (select 1 
						from SIFLD_Bitacora_Proceso bp 
						where o.Emp_Id = bp.Emp_Id 
						and o.Suc_Id = bp.Suc_Id
						and o.Operacion_Id = bp.Operacion_Id
						and bp.Proceso like 'BANCOS')
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
			<!--- Extrae los encabezados para los Retiros Bancos --->
			<!---<cfquery name="rsERetiroB" datasource="ldcom">
				select Suc_Id, Deposito_Id, Deposito_Fecha, Deposito_NumeroControl, Deposito_Cometario, 
					Banco_Id, Deposito_Monto
				from Deposito_Encabezado
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					and Deposito_Fecha between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
                    AND Suc_Id=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
			</cfquery>--->
            
            <!---  Se extren los Datos de la Interface de LD INTRFCDEPOSITO --->
            <cfquery name="rsERetiroB" datasource="ldcom">
				select Suc_Id, Deposito_Id, Deposito_Fecha, Deposito_NumeroControl, Deposito_Cometario, 
					Banco_Id, Deposito_Monto
				from INTRFCDEPOSITO
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
					and Deposito_Fecha between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
                    AND Suc_Id=<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">
                    AND Estatus_proceso = 0
			</cfquery>
            
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
                <cfset fechaProceso =#fechaProceso.fechaP#>
				<cftry>
					<!--- Inserta los encabezados ---> 
					<cfquery datasource="sifinterfaces">
						insert into SIFLD_Movimientos_Bancarios
							(Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento, 
							 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen, 
  						  	 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus, Fecha_Inclusion)
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
						 '#fechaProceso#')
					</cfquery>
					<cftransaction action="commit" />
                    <cfquery name="updINTRFCDEPOSITO" datasource="ldcom">
                    	update INTRFCDEPOSITO
                        set Estatus_proceso=2 and Factura_Fecha_Aplica=<cfqueryparam cfsqltype="cf_sql_date" value="#fechaProceso#">
                        where suc_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">
                        and Operacion_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Operacion_Id#">
                    </cfquery>
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
			<cfquery datasource="sifinterfaces">
				declare @ID int
				select @ID = isnull(max(Proceso_Id) ,0) + 1
				from SIFLD_Bitacora_Proceso 
				insert SIFLD_Bitacora_Proceso 
					(Proceso_Id, Sistema, Emp_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso)
				values (@ID, 'LD',
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_Id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Operacion_Id#">,
						'BANCOS',
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
					'BANCOS',
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
				'No hay Cierres de Sucursal para el Dia de Hoy', 'BANCOS', getdate())
		</cfquery>
	</cfif>
</cffunction>
</cfcomponent>

