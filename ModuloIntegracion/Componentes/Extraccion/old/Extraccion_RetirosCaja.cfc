<!--- ABG: Extraccion de Retiros de Caja Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="no">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">

	<!---Invocar al GC para liberar memoria---> <!---ABG--->
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()><!--- invoca el GC --->
        
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
    <cfsilent>
		<cfset Varthisdatasource = Vardatasources[i]>
		<cfif Varthisdatasource.name EQ 'ldcom'>
			 <cfset Lvarserverldcom = trim(Varthisdatasource.urlmap.database)>
			 <cfset Lvarbdldcom = trim(Varthisdatasource.urlmap.database)>
		</cfif>
    </cfsilent>
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
	
    <cf_dbtemp name="CadEmp" returnvariable="CadEmp" datasource="sifinterfaces">
	    <cf_dbtempcol name="Cadena_Id" type="numeric">
        <cf_dbtempcol name="Ecodigo" type="numeric">
        <cf_dbtempcol name="cache" type="varchar(20)">
    </cf_dbtemp>
    
    <cf_dbtemp name="CadEmpLD" returnvariable="CadEmpLD" datasource="ldcom">
	    <cf_dbtempcol name="Cadena_Id" type="numeric">
        <cf_dbtempcol name="mes_Auxiliar" type="int">
    </cf_dbtemp>
    
	<!--- Obtiene las cadenas de LDCOM y empresas de SIF y el cache--->
    <cfquery name="rsCadena" datasource="ldcom">
    	select Cadena_Id from Cadena with(NOLOCK)
    </cfquery>
    
    <cfloop query="rsCadena">
    <cfsilent>
    	<cfquery datasource="sifinterfaces">
        	insert into #CadEmp# (Cadena_Id,Ecodigo,cache)
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadena.Cadena_Id#">,
            	EQUidSIF, c.Ccache 
            from SIFLD_Equivalencia a 
				inner join asp..Empresa b on b.Ereferencia = a.EQUidSIF
				inner join asp..Caches c on b.Cid = c.Cid
            where EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadena.Cadena_Id#">
            and CATcodigo like 'CADENA' 
            and SIScodigo like 'LD'
        </cfquery>
    </cfsilent>
    </cfloop>
    
    <!--- Obtiene el mes de auxiliares --->
    <cfquery name="rsCadEmp" datasource="sifinterfaces">
    	select * from #CadEmp#
    </cfquery>
    <cfloop query="rsCadEmp">
    <cfsilent>
    	<cfquery name="rsAux" datasource="#rsCadEmp.cache#">
			select Pvalor 
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadEmp.Ecodigo#">
            and Pcodigo = 60
        </cfquery>
        <cfif rsAux.recordcount GT 0>
            <cfquery datasource="ldcom">
                insert into #CadEmpLD# (Cadena_Id, mes_Auxiliar)
                values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCadEmp.Cadena_Id#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsAux.Pvalor#">)
            </cfquery>
        </cfif>
    </cfsilent>
    </cfloop>
    	
	<!--- Obtiene los parametros de Fecha Extraccion --->	
    <cfif not isdefined("fechaini") and not isdefined("fechafin")>
    <cftry>
        <cfset FecIni = Parametros(Ecodigo=2,Pcodigo=16,Parametro="Fecha Inicio Extraccion",ExtBusqueda=false, Sistema = 'LD')>
        <cfset FecFin = Parametros(Ecodigo=2,Pcodigo=17,Parametro="Fecha Fin Extraccion",ExtBusqueda=false, Sistema = 'LD')>
        <cfset fechaini = createdate(right(FecIni,4),mid(FecIni,4,2),left(FecIni,2))>
		<cfset fechafin = createdate(right(FecFin,4),mid(FecFin,4,2),left(FecFin,2))>
    <cfcatch>
    </cfcatch>
    </cftry>
    </cfif>
    
	<!--- Inserta Operacion ID a Bitacora para Retiros --->
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
    <cfquery datasource="ldcom" name="Verif">
		insert into SIFLD_Bitacora_Proceso 
            (Sistema, Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso, 
             Operacion_Fecha_Apertura, Operacion_Fecha_Cierre, Estatus)
		select 'LD', o.Emp_Id, s.Cadena_Id, o.Suc_Id,o.Operacion_Id, 'RETIROS',
        	getdate(), o.Operacion_Fecha_Apertura, o.Operacion_Fecha_Cierre, 1
		from Sucursal_Operacion o with(NOLOCK)
			inner join Sucursal s with(NOLOCK)
			on o.Emp_Id = s.Emp_Id and o.Suc_Id = s.Suc_Id and s.Zona_Id = 2
        	inner join #CadEmpLD# z
            on s.Cadena_Id = z.Cadena_Id and month(o.Operacion_Fecha_Apertura) = isnull(z.mes_Auxiliar,0)
		where Operacion_Estado like 'CERR'
        and Operacion_Sincronizada = 1 <!--- Se agrega validacion nueva de Sincronizacion --->
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
						from SIFLD_Bitacora_Proceso bp with(NOLOCK)
						where o.Emp_Id = bp.Emp_Id 
						and o.Suc_Id = bp.Suc_Id
						and o.Operacion_Id = bp.Operacion_Id
                        and o.Operacion_Fecha_Apertura = bp.Operacion_Fecha_Apertura
                        and o.Operacion_Fecha_Cierre = bp.Operacion_Fecha_Cierre
						and bp.Proceso like 'RETIROS')
	</cfquery>
    
    <cfquery datasource="ldcom" result="Rupdate">
    	update top (50) SIFLD_Bitacora_Proceso
        set Estatus = 10
        where Proceso like 'RETIROS'
        and Estatus = 1
        and not exists (select 1 
						from SIFLD_Bitacora_Proceso with(NOLOCK)
						where Proceso like 'RETIROS'
                        and Estatus = 10)
    </cfquery>
    
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, 
        Operacion_Fecha_Apertura, Operacion_Fecha_Cierre
		from SIFLD_Bitacora_Proceso with(NOLOCK)
		where Estatus = 10
        and Proceso like 'RETIROS'
        <cfif Rupdate.recordcount EQ 0>
            and 1 = 2
        </cfif>
	</cfquery>	

	<cfif isdefined("rsOperacionID") and rsOperacionID.recordcount GT 0>
		<cfloop query="rsOperacionID">
        <cfsilent>
		<cftry>
			<!--- Obtiene la Moneda Local --->
			<cfquery name="rsMoneda" datasource="ldcom">
				select Moneda_Id 
				from Moneda with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">
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
				from Caja_Cierre_Retiro with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_id#">
					and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_id#">
					and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_id#">
			</cfquery>
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsERetiros") AND rsERetiros.recordcount GT 0>
			<cfloop query="rsERetiros">
            <cfsilent>
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
						(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">,	
						 'LD', 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.Tipo_Retiro#">,
                         <cfqueryparam cfsqltype="cf_sql_date"  value="#dateformat(rsERetiros.Retiro_Fecha,"yyyy/mm/dd")#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.Concepto_Retiro#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
						 15)
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
							 'E',
							 '', 
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsERetiros.Retiro_Efectivo - rsERetiros.Retiro_FondoCaja,9.99)#">)
						</cfquery>
						<cfset IDlinea = IDlinea + 1>
					</cfif>
					
					<cfif rsERetiros.Retiro_Monedaext GT 0>
						<cfquery datasource="sifinterfaces">
							insert into DSIFLD_Retiros_Caja 
								(Ecodigo,Origen, Id_Retiro,  ID_Linea_Retiro, Forma_Retiro,
								 Codigo_Forma_Retiro, Monto_Retiro) 
							values 
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_Id#">,
							 'LD', 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDlinea#">, 
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
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
							and ID_Retiro =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
						delete ESIFLD_Retiros_Caja
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
							and ID_Retiro =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxIDE.MaxID#">
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
            </cfsilent>
			</cfloop> <!--- Encabezados Retiros---> 
			</cfif>
            
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Retiros_Caja
                set Estatus = 1 
                where Estatus = 15
            </cfquery>
             
            <cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 2,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'RETIROS'
                and Estatus = 10
                and Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_id#">
                and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
                and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_id#">
                and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_id#">
                and Operacion_Fecha_Apertura = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
                and Operacion_Fecha_Cierre = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
            </cfquery>
            <cfset varProc = true>
            
            <cfset rsMoneda = javacast("null","")>
            <cfset rsMaxIDE = javacast("null","")>
            <cfset rsERetiros = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->
		<cfcatch type="any">
        	<cfquery datasource="sifinterfaces">
                delete DSIFLD_Retiros_Caja
                where ID_Retiro in 
                	(select ID_Retiro
                    from ESIFLD_Retiros_Caja
                	where Estatus = 15)
            </cfquery>
            <cfquery datasource="sifinterfaces">
                delete ESIFLD_Retiros_Caja
                where Estatus = 15
            </cfquery>
        	<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 3,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'RETIROS'
                and Estatus = 10
                and Emp_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_id#">
                and Cadena_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Cadena_id#">
                and Suc_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Suc_id#">
                and Operacion_Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_id#">
                and Operacion_Fecha_Apertura = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
                and Operacion_Fecha_Cierre = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
            </cfquery>
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
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Emp_Id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOperacionID.Operacion_Id#">,
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
            <cfset varProc = false>
		</cfcatch>
		</cftry>
        </cfsilent>
		</cfloop> <!--- Operacion ID --->
	<cfelse>
		<!--- Se Elimina este error ya que ahora no se ejecuta la tarea una vez al dia --->
		<!--- Inserta Log de Error --->
		<!---
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
		</cfquery> --->
        <cfset varProc = false> 
	</cfif>
    <cfif varProc>
    	<cfreturn 1>
    <cfelse>
    	<cfreturn 0>
    </cfif>
</cffunction>
</cfcomponent>	
	
