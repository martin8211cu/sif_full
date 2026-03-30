<!--- ABG: Extraccion de Retiros de Tombola Interfaz LD-SIF Ver. 1.0 --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!---Movimientos Bancarios especiales SIF --->
<!---
CB = Comisiones
IV = IVA comision bancaria
--->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="no">
<cffunction name="Ejecuta" access="public" returntype="string" output="no">

	<!---Invocar al GC para liberar memoria---> <!---ABG--->
	<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
    <cfset javaRT.gc()><!--- invoca el GC --->
    
	<cfset LvarLinkServ = false>
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
    
	<!--- Inserta Operacion ID a Bitacora para Bancos --->
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
    <cfquery datasource="ldcom">
        insert into SIFLD_Bitacora_Proceso 
            (Sistema, Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso, 
             Operacion_Fecha_Apertura, Operacion_Fecha_Cierre, Estatus)
		select 'LD', o.Emp_Id, s.Cadena_Id, o.Suc_Id,o.Operacion_Id, 'BANCOS',
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
						and bp.Proceso like 'BANCOS')
	</cfquery>
	
    <cfquery datasource="ldcom" result="Rupdate">
    	update top (50) SIFLD_Bitacora_Proceso
        set Estatus = 10
        where Proceso like 'BANCOS'
        and Estatus = 1
        and not exists (select 1 
						from SIFLD_Bitacora_Proceso with(NOLOCK)
						where Proceso in ('VENTAS', 'BANCOS')
                        and Estatus = 10)
    </cfquery>
    
    <!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
	<cfquery datasource="ldcom" name="rsOperacionID">
		select Emp_Id, Cadena_Id, Suc_Id, Operacion_Id, 
        Operacion_Fecha_Apertura, Operacion_Fecha_Cierre
		from SIFLD_Bitacora_Proceso with(NOLOCK)
		where Estatus = 10
        and Proceso like 'BANCOS'
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
				select convert(numeric(18,0),isnull(Moneda_Id,0)) as Moneda_Id
				from Moneda with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
				and Moneda_Local = 1
			</cfquery>
			<cfif rsMoneda.recordcount EQ 0 OR rsMoneda.Moneda_Id EQ 0>
				<cfthrow message="Error al extraer la moneda Local">
			</cfif>

			<!--- Extrae los encabezados para los Retiros Bancos --->
			<cfquery name="rsERetiroB" datasource="ldcom">
				select Suc_Id, Deposito_Id, Deposito_Fecha, Deposito_NumeroControl, Deposito_Cometario, 
					Banco_Id, Deposito_Efectivo, Deposito_MonedaExt, Cambio_Monto
				from Deposito_Encabezado with(NOLOCK)
				where Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Emp_Id#">
                	and Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Suc_id#">
					and Deposito_Fecha between
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Apertura#">
						and
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsOperacionID.Operacion_Fecha_Cierre#">
			</cfquery>
            <cfset varTC = rsERetiroB.Cambio_Monto>
            <cfset varMonedaL = rsMoneda.Moneda_Id>
            <cfset varMontoL = rsERetiroB.Deposito_Efectivo>
			<cfset varMonedaE = 2>
            <cfset varMontoE = rsERetiroB.Deposito_MonedaExt>
            <cfif varTC LTE 0>
            	<cfset varConExt = false>
            <cfelse>
            	<cfset varConExt = true>
            </cfif>
            
			<!--- Recorremos los encabezados Insertandolos y extrayendo sus detalles de Pago y detalles de Venta --->
			<cfif isdefined("rsERetiroB") AND rsERetiroB.recordcount GT 0>
			<cfloop query="rsERetiroB">
            <cfsilent>
				<!--- Crea el numero de Documento --->
				<cfset Num_Doc = numberformat(rsOperacionID.Emp_Id,"00") & "-" & numberformat(rsOperacionID.Suc_Id,"0000") & "-" &  Deposito_NumeroControl>
				<cfset Num_Doc = left(Num_Doc,20)>
                <cftransaction action="begin">
                <cftry>
                    <!--- Inserta Deposito en Moneda Local --->
                    <cfif rsERetiroB.Deposito_Efectivo gt 0>
                        <!--- ID para la tabla de Encabezados --->
                        <cfquery name="rsMaxIDE" datasource="sifinterfaces">
                            select isnull(max(ID_MovimientoB),0) + 1 as MaxID
                            from SIFLD_Movimientos_Bancarios
                        </cfquery> 
                        <cfquery datasource="sifinterfaces">
                            insert into SIFLD_Movimientos_Bancarios
                                (Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento, 
                                 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen, 
                                 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus, Concepto,
                                 Tipo_Cambio, Moneda)
                            values 
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
                             'LD',
                             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
                             'TOM',
                             'D', 
                             <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiroB.Deposito_Fecha,"yyyy/mm/dd")#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsERetiroB.Deposito_Cometario,100)#">,
                             null,
                             null,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiroB.Banco_Id#">,
                             null,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(varMontoL,'9.99')#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
                             15,
                             'DP',
                             1,
                             convert(varchar,<cfqueryparam cfsqltype="cf_sql_numeric" value="#varMonedaL#">)
                             )
                        </cfquery>
                    </cfif>
                    <!--- Inserta Deposito en Moneda Extranjera --->
                    <cfif rsERetiroB.Deposito_MonedaExt GT 0 AND varConExt>
                        <!--- ID para la tabla de Encabezados --->
                        <cfquery name="rsMaxIDE" datasource="sifinterfaces">
                            select isnull(max(ID_MovimientoB),0) + 1 as MaxID
                            from SIFLD_Movimientos_Bancarios
                        </cfquery> 
                        <cfquery datasource="sifinterfaces">
                            insert into SIFLD_Movimientos_Bancarios
                                (Ecodigo, Origen, ID_MovimientoB, Tipo_Operacion, Tipo_Movimiento, 
                                 Fecha_Movimiento,Documento, Referencia, Banco_Origen, Cuenta_Origen, 
                                 Banco_Destino, Cuenta_Destino, Importe_Movimiento, Sucursal, Estatus, Concepto,
                                 Tipo_Cambio, Moneda)
                            values 
                            (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOperacionID.Cadena_Id#">,
                             'LD',
                             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxIDE.MaxID#">,
                             'TOM',
                             'D', 
                             <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiroB.Deposito_Fecha,"yyyy/mm/dd")#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#Num_Doc#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rsERetiroB.Deposito_Cometario,100)#">,
                             null,
                             null,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiroB.Banco_Id#">,
                             null,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#numberformat(varMontoE/varTC,'9.99')#">,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOperacionID.Suc_Id#">,
                             15,
                             'DP',
                             <cfqueryparam cfsqltype="cf_sql_float" value="#varTC#">,
                             convert(varchar,<cfqueryparam cfsqltype="cf_sql_numeric" value="#varMonedaE#">)
                             )
                        </cfquery>
                    </cfif>
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
            </cfsilent>
			</cfloop> <!--- Encabezados Bancos--->
			</cfif> 
            
            <cfquery datasource="sifinterfaces">
                update SIFLD_Movimientos_Bancarios
                set Estatus = 1 
                where Estatus = 15
            </cfquery>
            
        	<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 2,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'BANCOS'
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
            <cfset rsERetiroB = javacast("null","")>
            <cfset javaRT.gc()><!--- invoca el GC --->
		<cfcatch type="any">
        	<cfquery datasource="sifinterfaces">
                delete SIFLD_Movimientos_Bancarios
                where Estatus = 15
            </cfquery>
        	<cfquery datasource="ldcom">
                update SIFLD_Bitacora_Proceso
                set Estatus = 3,
                Fecha_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where Proceso like 'BANCOS'
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
				'No hay Cierres de Sucursal para el Dia de Hoy', 'BANCOS', getdate())
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

