<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="no">
	<cffunction name="init" description="constructor">
		<cfreturn this >
	</cffunction>
	<cffunction name="getOperacionesLD" access="public" output="false" returntype="query">
		<cfargument name="DataSource" type="string" required="True"  default="" />
		<cfargument name="Estado" 	  type="string" required="true"  default="CERR" hint="CERR, ABIE, etc. (case sensitive)"/>
		<cfargument name="FechaIni"   type="date" 	required="false" default=0 />
		<cfargument name="FechaFin"   type="date" 	required="false" default=0 />
		<cfargument name="Proceso" 	  type="string" required="True"  default="" 	hint="COMPRAS, VENTAS, INVENTARIOS, etc. (case sensitive)"/>
		<cfargument name="Sucursal"   type="string" required="false" default="-1" />
		<!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->

		<cfquery name="rsCadenasEquiv" datasource="sifinterfaces">
			select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF
			from SIFLD_Equivalencia
			where SIScodigo = 'LD'
				and CATcodigo = 'CADENA'
		</cfquery>

		<cfset _cadenas = ValueList(rsCadenasEquiv.EQUempOrigen)>

		<cfquery name="rsCierre" datasource="#DataSource#">
			SELECT o.Emp_Id, s.Cadena_Id, o.Suc_Id, o.Operacion_Id, o.Operacion_Fecha_Apertura, o.Operacion_Fecha_Cierre
			FROM 	Sucursal_Operacion o
				INNER JOIN 	Sucursal s
					ON 	o.Emp_Id = s.Emp_Id
					AND o.Suc_Id = s.Suc_Id
			WHERE 	Operacion_Estado LIKE '#Estado#'
			<cfif isdefined("arguments.Sucursal") AND #arguments.Sucursal# NEQ -1>
				and s.Suc_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Sucursal#">
			</cfif>
			<!--- SOLO LAS EMPRESAS QUE SE ENCUENTREN EN LAS EQUIVALENCIAS --->
			AND s.Cadena_Id IN (#_cadenas#)
			<cfif FechaIni GT 0 AND FechaFin GT 0>
				AND o.Operacion_Fecha_Cierre
					BETWEEN
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value='#FechaIni# 00:00:00'>
						AND
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value='#FechaFin# 23:59:59'>
				<cfelse>
					AND datediff(day,o.Operacion_Fecha_Cierre, <cfqueryparam cfsqltype="cf_sql_Date" value='#DateAdd("d", -1, Now())#'>)  = 0
				order by o.Suc_Id, o.Operacion_Id, o.Operacion_Fecha_Cierre
			</cfif>
		</cfquery>


		<!--- Crea tabla temporal para comparación --->
		<cf_dbtemp name="LocalTempCompra" returnvariable="varLocalTempCompra" datasource="sifinterfaces">
			<cf_dbtempcol name="Cadena_Id" 					type="numeric">
			<cf_dbtempcol name="Emp_Id" 					type="numeric">
			<cf_dbtempcol name="Suc_Id" 					type="numeric">
			<cf_dbtempcol name="Operacion_Id" 				type="numeric">
			<cf_dbtempcol name="Operacion_Fecha_Apertura" 	type="DATETIME">
			<cf_dbtempcol name="Operacion_Fecha_Cierre" 	type="DATETIME">
		</cf_dbtemp>
		<!--- Inserta operaciones del día en tabla temporal para comparación --->
		<cfif rsCierre.recordcount GT 0>
			<cfquery datasource="sifinterfaces">
				<cfoutput query="rsCierre">
					INSERT INTO #varLocalTempCompra# VALUES(#Cadena_Id#,#Emp_Id#,#Suc_Id#,#Operacion_Id#,'#Operacion_Fecha_Apertura#','#Operacion_Fecha_Cierre#')
				</cfoutput>
			</cfquery>
		</cfif>
		<!--- obtiene los cierres no procesados --->
		<cfquery name="rsOperacionID" datasource = "sifinterfaces">
			SELECT 	*
			FROM 	##LocalTempCompra o
			WHERE 	NOT exists (SELECT 1
								FROM 	SIFLD_Bitacora_Proceso bp
								WHERE 	o.Emp_Id = bp.Emp_Id
									AND o.Suc_Id = bp.Suc_Id
									AND o.Operacion_Id = bp.Operacion_Id
									AND bp.Proceso LIKE '#Proceso#')
		</cfquery>
		<cfreturn rsOperacionID>
	</cffunction>
	<cffunction name="getOperacionesBancoLD" access="public" output="false" returntype="query">
		<cfargument name="DataSource" type="string" required="True"  default="" />
		<cfargument name="Empresa" 	  type="string" required="true"  default="" />
		<cfargument name="Sucursal"   type="string" required="true"  default="" />
		<cfargument name="Deposito"   type="string" required="True"  default="" />
		<cfargument name="FechaIni"   type="date" 	required="false" default=0 />
		<cfargument name="FechaFin"   type="date" 	required="false" default=0 />
		<!--- Obtiene los cierres de Sucursal del Dia en que se procesa la Rutina --->
		<cfquery name="rsCierre" datasource="#DataSource#">
			SELECT s.Cadena_Id, d.Emp_Id, d.Suc_Id, Deposito_Id, Deposito_Fecha, Deposito_NumeroControl, Deposito_Cometario,
				   Banco_Id, Deposito_Monto
			  FROM Deposito_Encabezado d
			  	   INNER JOIN Sucursal s
			  	   ON d.Emp_Id = s.Emp_Id AND d.Suc_Id = s.Suc_Id
			 WHERE 1=1
			   AND CONVERT(CHAR(8), Deposito_Fecha, 112)
			<cfif FechaIni GT 0 AND FechaFin GT 0>
				BETWEEN
					CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#FechaIni#'>, 112)
				AND
					CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#FechaFin#'>, 112)
			<cfelse>
				= CONVERT(CHAR(8), <cfqueryparam cfsqltype="cf_sql_timestamp" value='#now()#'>, 112)
			</cfif>
		</cfquery>
		<!--- Crea tabla temporal para comparación --->
		<cf_dbtemp name="LocalTempCompra" returnvariable="varLocalTempCompra" datasource="sifinterfaces">
			<cf_dbtempcol name="Cadena_Id" 					type="numeric">
			<cf_dbtempcol name="Emp_Id" 					type="numeric">
			<cf_dbtempcol name="Suc_Id" 					type="numeric">
			<cf_dbtempcol name="Operacion_Id" 				type="numeric">
			<cf_dbtempcol name="Operacion_Fecha_Apertura" 	type="DATETIME">
			<cf_dbtempcol name="Operacion_Fecha_Cierre" 	type="DATETIME">
		</cf_dbtemp>
		<!--- Inserta operaciones del día en tabla temporal para comparación --->
		<cfif rsCierre.recordcount GT 0>
			<cfquery datasource="sifinterfaces">
				<cfoutput query="rsCierre">
					INSERT INTO #varLocalTempCompra# VALUES(#Cadena_Id#,#Emp_Id#,#Suc_Id#,#Deposito_Id#,'#Deposito_Fecha#','#Deposito_Fecha#')
				</cfoutput>
			</cfquery>
		</cfif>
		<!--- obtiene los cierres no procesados --->
		<cfquery name="rsOperacionID" datasource = "sifinterfaces">
			SELECT 	*
			FROM 	##LocalTempCompra o
			WHERE 	NOT exists (SELECT 1
								FROM 	SIFLD_Bitacora_Proceso bp
								WHERE 	o.Emp_Id = bp.Emp_Id
									AND o.Suc_Id = bp.Suc_Id
									AND o.Operacion_Id = bp.Operacion_Id
									AND bp.Proceso LIKE '#Proceso#')
		</cfquery>
		<cfreturn rsOperacionID>
	</cffunction>
	<cffunction name="getMonedaLD" access="public" output="false" returntype="query">
		<cfargument name="DataSource" type="string" required="True"  default="" />
		<cfargument name="Empresa" 	  type="string" required="True"  default="" />
		<!--- Obtiene la Moneda Local --->
		<cfquery name="rsMoneda" datasource="ldcom">
			SELECT 	Moneda_Id
			  FROM 	Moneda
			 WHERE 	Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Empresa#">
			   AND 	Moneda_Local = 1
		</cfquery>
		<cfreturn rsMoneda>
	</cffunction>
	<cffunction name="setBitacoraProcesos" access="public" output="false">
		<cfargument name="Sistema" 	 type="string"  required="True"  default="LD" />
		<cfargument name="Empresa" 	 type="numeric" required="True"  default="" />
		<cfargument name="Sucursal"  type="numeric" required="True"  default="" />
		<cfargument name="Operacion" type="numeric" required="True"  default="" />
		<cfargument name="Proceso" 	 type="string"  required="True"  default="" />
		<!--- Hasta ahorita solo se necesita para Ventas de Contado --->
		<cfargument name="FechaVenta" type="date" required="no" />
		<cfargument name="TipoExtraccion" type="String" required="no" />

		<!--- Inserta Operacion ID a Bitacora --->
		<cfquery datasource="sifinterfaces">
			DECLARE @ID int;
			 SELECT @ID = isnull(max(Proceso_Id) ,0) + 1
			   FROM SIFLD_Bitacora_Proceso
			 INSERT	SIFLD_Bitacora_Proceso
					(Proceso_Id, Sistema, Emp_Id, Suc_Id, Operacion_Id, Proceso, Fecha_Proceso
					<cfif isdefined("arguments.FechaVenta")>,FechaVenta</cfif>
					<cfif isdefined("arguments.TipoExtraccion") AND TRIM(arguments.TipoExtraccion) NEQ "">,TipoExtraccion</cfif>)
			 VALUES (@ID, '#Arguments.Sistema#',
					<cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Empresa#" />,
					<cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Sucursal#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Operacion#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#Arguments.Proceso#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					<cfif isdefined("arguments.FechaVenta")>,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.FechaVenta#"></cfif>
					<cfif isdefined("arguments.TipoExtraccion") AND TRIM(arguments.TipoExtraccion) NEQ "">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoExtraccion#"/></cfif>)
		</cfquery>
	</cffunction>
	<cffunction name="setLogErrores" access="public" output="false">
		<cfargument name="Sistema" 	  type="string"  required="True"  default="LD" />
		<cfargument name="Empresa" 	  type="string"  required="false" default="null" />
		<cfargument name="Sucursal"   type="string"  required="false" default="null" />
		<cfargument name="Operacion"  type="string"  required="false" default="null" />
		<cfargument name="ErrCaja" 	  type="string"  required="false" default="null" />
		<cfargument name="ErrBodega"  type="string"  required="false" default="null" />
		<cfargument name="ErrFactura" type="string"  required="false" default="null" />
		<cfargument name="MsgError"   type="string"  required="true"  default="" />
		<cfargument name="Error_Comp" type="string"  required="false" default="" />
		<cfargument name="Proceso" 	  type="string"  required="True"  default="" />
		<!--- Inserta Error en Log de Errores --->
		<cfquery name="rsMaxIDError" DataSource="sifinterfaces">
			select 	isnull(max(Error_Id),0) + 1 as maxIDError
			from 	SIFLD_Log_Errores
		</cfquery>
		<cfquery name="insertErrorLog" datasource="sifinterfaces">
			 INSERT SIFLD_Log_Errores
					(Error_Id, Sistema, Empresa, Sucursal, Operacion, Caja, Bodega,
					Factura, MsgError, Error_Comp, Proceso, Fecha_Proceso)
			 VALUES (#rsMaxIDError.maxIDError#, '#Arguments.Sistema#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Empresa#"    null="true" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Sucursal#"   null="true" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Operacion#"  null="true" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ErrCaja#"    null="true" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ErrBodega#"  null="true" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ErrFactura#" null="true" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.MsgError#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Error_Comp#" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Proceso#" />,
					<cfqueryparam cfsqltype="cf_sql_timestamp"    value="#now()#" />)
		</cfquery>
	</cffunction>
</cfcomponent>