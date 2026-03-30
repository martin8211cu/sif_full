<cfcomponent output="no">
<!--- Resumen de valores y significados de los estatus --->
<!---
0.- Inactivo
1.- Pendiente
2.- Finalizado Exitosamente
3.- Error en Proceso
4.- Pendiente proceso Contable
5.- Pendiente Proceso Auxiliar
6.- Error en Proceso Contable
10.- Proceso en Ejecucion
11.- Proceso en Ejecucion Complementario
12.- Proceso en Ejecucion Auxliar
13.- Proceso en Ejecucion Auxiliar Complementario
Procesos en Motor
92.- Registro Listo para cargarse a Interfaz sin Proceso Pendiente
94.- Registro Listo para cargarse a Interfaz con proceso Pendiente
95.- Registro Listo para cargarse a Interfaz con proceso Pendiente
99.- Proceso en Cola
100.- Proceso Complementario en Cola
--->
<!--- Se modifica el proceso de Inegracion para mejorar el uso de la memoria
	- Se ejecuta un solo componente cada vez para evitar que el proceso se quede abierto durante mucho tiempo
	- Se utilizan tablas Temporales para cargar las interfaces de SOIN de forma masiva
	- Se utiliza el tag cfsilent para evitar llenar la memoria de basura
--->
	<cfquery datasource="asp" name="__conexiones__">
    	select e.Ereferencia, e.CEcodigo, c.Ccache, e.Ereferencia
        from Empresa e
            join Caches c
            on e.Cid = c.Cid
	</cfquery>

    <cfset Request.Conexiones = __conexiones__>
    <cfset Request.CATcodigo  = ''>
	<cfset Request.CampoError = ''>
    <cfset Request.ValorError = ''>

    <!---Limpia Variables no usadas--->
    <cfset __conexiones__ = ''>

    <cffunction name = 'ConversionEquivalencia' returntype="query" output="yes">
    	<cfargument name='SIScodigo'	type='string'	required='true' hint="Sistema">
      	<cfargument name='CATcodigo'	type='string'	required='true' hint="Catalogo">
    	<cfargument name='EmpOrigen'	type='numeric'	required='true' hint="Empresa Origen">
      	<cfargument name='CodOrigen'	type='string'	required='true' hint="Codigo Origen">
      	<cfargument name='CampoError'	type='string'	required='true' hint="Campo Error">
    <cfsilent>
		<cfset Request.CATcodigo = Arguments.CATcodigo>
    	<cfset Request.CampoError = Arguments.CampoError>
    	<cfset Request.ValorError = Arguments.CodOrigen>

      	<cfquery name="rsEquiv" datasource="sifinterfaces">
      		select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF
            from SIFLD_Equivalencia
            where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#SIScodigo#">
            	and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CATcodigo#">
                and EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpOrigen#">
                and EQUcodigoOrigen = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#CodOrigen#">
      	</cfquery>
      	<cfif rsEquiv.recordcount eq 0>
        	<!--- si No Existe el Registro en Equivalencias     --->
        	<cfthrow message="No se encuentra equivalencia para #Arguments.CATcodigo# - #Arguments.CodOrigen#">
      	</cfif>
      	<cfreturn rsEquiv>
    </cfsilent>
    </cffunction>

    <!--- Funcion Para extraer el Ultimo campo ID (Maximo) de las tablas IEXX --->
	<cffunction name = 'ExtraeMaximo'>
    	<cfargument name='Tabla' type='string'	required='true' hint="Tabla">
      	<cfargument name='CampoID' type='string'	required='true' hint="Proceso">
    <cfsilent>
        <cfquery name="rsMaximo_Tabla" datasource="sifinterfaces">
       		select coalesce (max( # CampoID # ), 0) + 1 as Maximo from # Tabla #
       	</cfquery>

        <cfif rsMaximo_Tabla.Maximo NEQ "">
			<cfset Max_Tabla = rsMaximo_Tabla.Maximo>
        <cfelse>
        	<cfset Max_Tabla = 0>
        </cfif>

        <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
            select 1
            from IdProceso
       	</cfquery>

        <cfif rsMaximo_IdProceso.recordcount LTE 0>
        	<cfquery datasource="sifinterfaces">
	            insert IdProceso(Consecutivo,BMUsucodigo) values(0,1)
            </cfquery>
        </cfif>

        <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
            select isnull(max(Consecutivo),0) + 1 as Maximo
            from IdProceso
       	</cfquery>

        <cfset Max_Cons = rsMaximo_IdProceso.Maximo>

        <cfif  Max_Cons LT Max_Tabla>
        	<cfset retvalue = rsMaximo_Tabla>
        <cfelseif Max_Cons GTE Max_Tabla>
        	<cfset retvalue = rsMaximo_IdProceso>
        </cfif>
        <cfquery datasource="sifinterfaces">
            update IdProceso
            set Consecutivo = #retvalue.Maximo#
        </cfquery>
        <cfreturn retvalue>
    </cfsilent>
    </cffunction>

	<!--- FUNCION GETCONEXION --->
	<cffunction name="getConexion" returntype="string" output="no">
    	<cfargument name="Ecodigo" type="numeric" required="yes" hint="Ecodigo (sdc) que es usar¨¢ para obtener el cache o conexion">

    <cfsilent>
		<cfquery dbtype="query" name="ret">
        	select * from Request.Conexiones where Ereferencia = #Arguments.Ecodigo#
        </cfquery>
        <cfreturn ret.Ccache>
    </cfsilent>
    </cffunction>

	<!--- FUNCION GETCECODIGO --->
	<cffunction name="getCEcodigo" returntype="string" output="no">
    	<cfargument name="Ecodigo" type="numeric" required="yes" hint="Ecodigo (sdc) que es usará para obtener el CEcodigo">

    <cfsilent>
        <cfquery name="rsCEcodigo" datasource="#getConexion(Arguments.Ecodigo)#">
        	select CEcodigo
			from Empresa e
				inner join Empresas s
				on  e.Ereferencia = s.Ecodigo and s.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>
		<cfreturn rsCEcodigo.CEcodigo>
    </cfsilent>
    </cffunction>

	<!--- Funcion Dispara Interfaz Funcion Eliminada--->

	<!---FUNCION EXTRAE CLIENTE--->
	<cffunction name = 'ExtraeCliente'>
		<cfargument name='Cliente' type='string' 	required='true' hint="ClienteInterfaz">
		<cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">
		<cfargument name='TipoSocio' type='string'	required='false' hint="TipoSocio">
		<cfargument name='ValidaCuenta' type='string'	required='true' default="N" hint="ValidarCuenta">

    <cfsilent>
		<cfset ConexionBase = getConexion(Arguments.Ecodigo) >
    		<cfif Arguments.ValidaCuenta EQ 'S'>
			<cfset VarValida = true>
		<cfelse>
			<cfset VarValida = false>
		</cfif>
		<cfquery name="rsCliente" datasource="#ConexionBase#">
			select
				case when esIntercompany = 1 then  <!---    1 = Afiliados, 0 = Terceros    --->
					'02'
				else
					'01'
				end as TipoCte, SNcodigo, SNcuentacxc, SNcuentacxp
			from SNegocios
			where SNcodigoext like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cliente#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isDefined('Arguments.TipoSocio') and len(Arguments.TipoSocio) GT 0>
                and SNtiposocio in('#Arguments.TipoSocio#')
            </cfif>
		</cfquery>
        <cfif not isdefined("rsCliente") OR rsCliente.recordcount LTE 0>
            <cfquery name="rsCliente" datasource="#ConexionBase#">
                select
                    case when esIntercompany = 1 then  <!---    1 = Afiliados, 0 = Terceros    --->
                        '02'
                    else
                        '01'
                    end as TipoCte, SNcodigo, SNcuentacxc, SNcuentacxp
                from SNegocios
                where SNcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cliente#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                <cfif isDefined('Arguments.TipoSocio') and len(Arguments.TipoSocio) GT 0>
                    and SNtiposocio in('#Arguments.TipoSocio#')
                </cfif>
            </cfquery>
		</cfif>
		<cfif not isdefined("rsCliente") OR rsCliente.recordcount LTE 0>
			<cfthrow message="No Existe el Socio de Negocios con Codigo #Arguments.Cliente#">
		</cfif>

		<!---Valida las cuentas contables del socio --->
		<cfif VarValida>
			<cfif isdefined("Arguments.TipoSocio") and (Arguments.TipoSocio EQ 'P' OR Arguments.TipoSocio EQ 'A')>
				<cfif not isdefined("rsCliente") OR rsCliente.SNcuentacxp EQ "">
					<cfthrow message="El Socio no tiene definida la cuenta para proveedor CxP">
				</cfif>
			<cfelseif isdefined("Arguments.TipoSocio") and (Arguments.TipoSocio EQ 'C' OR Arguments.TipoSocio EQ 'A')>
				<cfif not isdefined("rsCliente") OR rsCliente.SNcuentacxc EQ "">
					<cfthrow message="El Socio no tiene definida la cuenta para cliente CxC">
				</cfif>
			<cfelse>
				<cfthrow message="Debe proporcionar un tipo de Socio Valido P, C o A">
			</cfif>
		</cfif>
		<cfreturn rsCliente>
    </cfsilent>
	</cffunction>

    <!--- Busqueda de Parametros --->
	<cffunction name='Parametros' returntype="string" output="yes">
    	<cfargument name='Ecodigo'	type='numeric'	required='true' hint="Empresa">
        <cfargument name="Sistema" type="string" required="true" default="0" hint="Sistema">
      	<cfargument name='Pcodigo'	type='numeric'	required='true' hint="Parametro">
    	<cfargument name='Sucursal'	type='string'	required='true' default="0" hint="Sucursal">
        <cfargument name='Criterio'	type='string'	required='true' default="0" hint="Sucursal">
        <cfargument name='Parametro'	type='string'	required='true' default="Desconocido" hint="Descripción Parametro">
        <cfargument name='ExtBusqueda'	type='boolean' required='true' default="false" hint="Busqueda extendida">

    <cfsilent>
        <cfif len(trim(Arguments.Sucursal)) EQ 0>
        	<cfset Arguments.Sucursal = "0">
        </cfif>
        <cfif len(trim(Arguments.Criterio)) EQ 0>
        	<cfset Arguments.Criterio = "0">
        </cfif>
        <cfif len(trim(Arguments.Sistema)) EQ 0>
        	<cfset Arguments.Sistema = "0">
        </cfif>
        <cfset varError = false>
        <cfloop from="1" to="8" index="PasoPrueba">
            <cfswitch expression="#PasoPrueba#">
            <cfcase value="1">
                <cfset varSistema = Arguments.Sistema>
                <cfset varSucursal = Arguments.Sucursal>
                <cfset varCriterio = Arguments.Criterio>
            </cfcase>
            <cfcase value="2">
                <cfset varSistema = Arguments.Sistema>
                <cfset varSucursal = Arguments.Sucursal>
                <cfset varCriterio = "0">
            </cfcase>
            <cfcase value="3">
                <cfset varSistema = Arguments.Sistema>
                <cfset varSucursal = "0">
                <cfset varCriterio = Arguments.Criterio>
            </cfcase>
            <cfcase value="4">
                <cfset varSistema = Arguments.Sistema>
                <cfset varSucursal = "0">
                <cfset varCriterio = "0">
            </cfcase>
            <cfcase value="5">
                <cfset varSistema = "0">
                <cfset varSucursal = Arguments.Sucursal>
                <cfset varCriterio = Arguments.Criterio>
            </cfcase>
            <cfcase value="6">
                <cfset varSistema = "0">
                <cfset varSucursal = Arguments.Sucursal>
                <cfset varCriterio = "0">
            </cfcase>
            <cfcase value="7">
                <cfset varSistema = "0">
                <cfset varSucursal = "0">
                <cfset varCriterio = Arguments.Criterio>
            </cfcase>
            <cfdefaultcase>
                <cfset varSistema = "0">
                <cfset varSucursal = "0">
                <cfset varCriterio = "0">
            </cfdefaultcase>
            </cfswitch>

            <cfquery name="rsParametro" datasource="sifinterfaces">
                select Pvalor
                from SIFLD_Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and SIScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varSistema#">
                and Sucursal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varSucursal#">
                and Criterio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCriterio#">
                and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
            </cfquery>
            <cfif rsParametro.recordcount GT 0>
                <cfbreak>
                <cfset varError = false>
            <cfelseif rsParametro.recordcount EQ 0 AND Arguments.ExtBusqueda EQ false>
				<cfset varError = true>
            	<cfbreak>
            <cfelseif rsParametro.recordcount EQ 0 AND PasoPrueba EQ 8>
            	<cfset varError = true>
                <cfbreak>
            </cfif>
        </cfloop>

        <cfif varError>
        	<cfset DetalleError = "No se ha configurado el parámetro #Arguments.Parametro# para la Empresa:#Arguments.Ecodigo#">
			<cfif Arguments.Sistema NEQ "0">
                <cfset DetalleError = "#DetalleError# Sistema:#Arguments.Sistema#">
            </cfif>
			<cfif Arguments.Sucursal NEQ "0">
                <cfset DetalleError = "#DetalleError# Sucursal:#Arguments.Sucursal#">
            </cfif>
            <cfif Arguments.Criterio NEQ "0">
                <cfset DetalleError = "#DetalleError# Criterio:#Arguments.Criterio#">
            </cfif>
            <cfthrow message="#DetalleError#">
        </cfif>
        <cfreturn rsParametro.Pvalor>
    </cfsilent>
    </cffunction>

    <!--- FUNCION Usuario Interfaz --->
	<cffunction name="UInterfaz" returntype="query" output="no">
    	<cfargument name='CEcodigo' type='numeric'	required='true' hint="CEcodigo">
		<cfargument name='Usuario' type='string'	required='true' default="InterfazLD" hint="Usuario">

    <cfsilent>
		<cfquery name="rsUInterfaz" datasource="asp">
        	select Usucodigo, Usulogin
			from Usuario
            where ltrim(rtrim(Usulogin)) like ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Usuario#">))
            and CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CEcodigo#">
        </cfquery>
		<cfif isdefined("rsUInterfaz") and rsUInterfaz.recordcount EQ 1>
	        <cfreturn rsUInterfaz>
		<cfelse>
			<cfthrow message="No se ha definido el usuario para interfaz: #Arguments.Usuario#">
		</cfif>
    </cfsilent>
    </cffunction>

	<!--- FUNCION Valida Transaccion --->
    <cffunction name="VTran" returntype="query" output="no">
        <cfargument name='Ecodigo' type='numeric'    required='true' hint="Ecodigo">
        <cfargument name='CTransaccion' type='string'    required='true' hint="Codigo Transaccion">
        <cfargument name="Modulo" type="string" required="yes" default="CP" hint="Modulo">

    <cfsilent>
        <cfset ConexionBase = getConexion(Arguments.Ecodigo)>

        <cfquery name="rsTransaccion" datasource="#ConexionBase#">
            <cfif Arguments.Modulo EQ "CP">
                select CPTcodigo as CTcodigo, CPTtipo as CTtipo
                from CPTransacciones
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CTransaccion#">
            </cfif>
            <cfif Arguments.Modulo EQ "CC">
                select CCTcodigo as CTcodigo, CCTtipo as CTtipo
                from CCTransacciones
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CTransaccion#">
            </cfif>
        </cfquery>
        <cfif isdefined("rsTransaccion") and rsTransaccion.recordcount EQ 1>
            <cfreturn rsTransaccion>
        <cfelse>
            <cfthrow message="Codigo de Transacción #Argumentos.CTransaccion# del módulo #Arguments.Modulo# NO valido">
        </cfif>
    </cfsilent>
    </cffunction>

	<!--- Elaboró Maria de los Angeles Blanco López--->
    <!---FUNCION EXTRAE CONCEPTO SERVICIO--->
	<cffunction name = 'ExtraeConceptoServicio'>
		<cfargument name='Cproducto' type='string' 	required='true' hint="CodigoProducto">
		<cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">

    <cfsilent>
		<cfset ConexionBase = getConexion(Arguments.Ecodigo) >

		<cfquery name="rsConceptoServicio" datasource="#ConexionBase#">
			select Cid,Ccodigo, CCid
            from Conceptos
            where Ccodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cproducto#">
			and Ecodigo = <cfqueryparam cfsqltype= "cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>

		<cfif not isdefined("rsConceptoServicio") or rsConceptoServicio.recordcount LTE 0>
			<cfthrow message="No Existe un concepto de Servicio para el codigo de producto #Arguments.Cproducto#">
		</cfif>

		<cfreturn rsConceptoServicio>
	</cfsilent>
    </cffunction>


	<!---Tipo de Cambio--->
    <cffunction name = 'ExtraeTipoCambio'>
    <cfargument name='Cmoneda' type='string' required='true' hint="CodigoMoneda">
    <cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">
    <cfargument name='FechaTipoCambio' type="date" required='true' hint="FechaTipoCambio">

		<cfset ConexionBase = getConexion(Arguments.Ecodigo)>

        <cfquery name="rsTipoCambio" datasource="#ConexionBase#">
		        select TC.TCcompra <!---, TC.Hfecha, TC.TCventa --->
                from Htipocambio TC
                	inner join Monedas M
                    on TC.Mcodigo = M.Mcodigo
                where convert(datetime, TC.Hfecha, 103) = <cfqueryparam cfsqltype="cf_sql_date" value= "#Arguments.FechaTipoCambio#">
                and M.Miso4217 = <cfqueryparam cfsqltype= "cf_sql_varchar" value= "#Arguments.Cmoneda#">
                and M.Ecodigo = <cfqueryparam cfsqltype= "cf_sql_integer" value= "#Arguments.Ecodigo#">
        </cfquery>
        <cfif not isdefined("rsTipoCambio") or rsTipoCambio.recordcount LTE 0>
            <cfthrow message="No Existe un tipo de cambio para la moneda #Arguments.Cmoneda# en el dia #Arguments.FechaTipoCambio#">
        </cfif>

        <cfreturn rsTipoCambio>
    </cffunction>

	<!---Tipo de Cambio
    <cffunction name = 'ExtraeTipoCambio'>
    <cfargument name='Cmoneda' type='string' required='true' hint="CodigoMoneda">
    <cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">
    <cfargument name='FechaTipoCambio' type="date" required='true' hint="FechaTipoCambio">

		<cfset ConexionBase = getConexion(Arguments.Ecodigo)>

    <!---- <cfset LvarFechaIniDia = createODBCdate(Arguments.FechaTipoCambio)>

        <cfset LvarFechaFinDia = dateAdd("d",1,LvarFechaIniDia)>

        <cfset LvarFechaFinDia = dateAdd("s",-1,LvarFechaFinDia)>

        <cfquery name="rsTipoCambio" datasource="#ConexionBase#">
			select TC.TCcompra
            from Monedas M
	            inner join Htipocambio TC
                on TC.Ecodigo  = M.Ecodigo
                and TC.Mcodigo = M.Mcodigo
               and TC.Hfecha  between
               <cfqueryparam cfsqltype="cf_sql_timestamp" value= "#LvarFechaIniDia#">
               AND <cfqueryparam cfsqltype="cf_sql_timestamp" value= "#LvarFechaFinDia#">
           where M.Miso4217       = <cfqueryparam cfsqltype= "cf_sql_varchar" value= "#Arguments.Cmoneda#">
	           and M.Ecodigo             = <cfqueryparam cfsqltype= "cf_sql_integer" value= "#Arguments.Ecodigo#">
        </cfquery> ---->

		<cfquery name="rsTipoCambio" datasource="#ConexionBase#">
			        <cfquery name="rsTipoCambio" datasource="#ConexionBase#">
		        select TC.TCcompra <!---, TC.Hfecha, TC.TCventa --->
                from Htipocambio TC
                	inner join Monedas M
                    on TC.Mcodigo = M.Mcodigo
                where convert(datetime, TC.Hfecha, 103) = <cfqueryparam cfsqltype="cf_sql_date" value= "#Arguments.FechaTipoCambio#">
                and M.Miso4217 = <cfqueryparam cfsqltype= "cf_sql_varchar" value= "#Arguments.Cmoneda#">
                and M.Ecodigo = <cfqueryparam cfsqltype= "cf_sql_integer" value= "#Arguments.Ecodigo#">
        </cfquery>

        <cfif not isdefined("rsTipoCambio") or rsTipoCambio.recordcount LTE 0>
            <cfthrow message="No Existe un tipo de cambio para la moneda #Arguments.Cmoneda# en el dia #Arguments.FechaTipoCambio#">
        </cfif>

        <cfreturn rsTipoCambio>
    </cffunction>---->

    <!---Concepto Contable--->
    <cffunction name = 'ConceptoContable' returntype="numeric" output="no">
        <cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">
        <cfargument name='Origen' type="string" required='true' hint="Origen Contable">

        <cfset ConexionBase = getConexion(Arguments.Ecodigo)>

    	<cfquery name="rsContable" datasource="#ConexionBase#">
        	select isnull(Cconcepto,0) as Cconcepto
            from ConceptoContable
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Origen#">
        </cfquery>

        <cfreturn rsContable.Cconcepto>
    </cffunction>

	<!--- Obtiene el nombre de la base de datos de un DataSource --->
	<cffunction name="getDatabaseName" access="public" returntype="String">
		<cfargument name='DatasourceName'		type='String' 	required='true'>
		<cfinvoke component="home.Componentes.DbUtils" method="getColdfusionDatasources"/>

			<cfset lVarDatabaseName = "">
			<cflock name="serviceFactory" type="exclusive" timeout="10">
				<cfscript>
					factory = CreateObject("java", "coldfusion.server.ServiceFactory");
					ds_service = factory.datasourceservice;
				   </cfscript>
			</cflock>
			<cfset caches = ds_service.getNames()>
			<cftry>
				<cfset databaseName = "ds_service.getDataSources().#DatasourceName#.urlmap.database" >
				<cfset lVarDatabaseName = #Evaluate(databaseName)#>
				<cfcatch type="any">
					<cfthrow message = "Ha ocurrido un error al obtener el nombre de la base de datos para el datasource (#UCASE(DatasourceName)#). [#cfcatch.message#]">
				</cfcatch>
			</cftry>
		<cfreturn  lVarDatabaseName>
	</cffunction>

	<!--- Obtiene el impuesto IVA en LDCOM, ya sea 8 o 16 --->
	<cffunction name="getPorcentajeIVA" returntype="string" output="no">
		<cfargument name='Emp_Id' type='string' required='true' hint="Emp_Id">
		<!--- SE OBTIENE PORCENTAJE DE IVA GRAVADO (8 o 16) --->
		<cfquery name="rsGetPorcIva" datasource="ldcom">
			SELECT TOP 1 COALESCE(Impuesto_Porcentaje, 0) AS PorcentajeIva,
			       COALESCE(Impuesto_Nombre, 'IVA') AS NombreIva
			FROM Impuesto
			WHERE UPPER(Impuesto_Tipo) LIKE '%IVA%'
			  AND Impuesto_Porcentaje > 0
			  AND Emp_Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Emp_Id#">
			ORDER BY Impuesto_Porcentaje DESC
		</cfquery>

		<cfset lVarPorcentajeIvaGravado = 16>
		<cfif isdefined("rsGetPorcIva") AND #rsGetPorcIva.RecordCount# GT 0>
			<cfset lVarPorcentajeIvaGravado = #rsGetPorcIva.PorcentajeIva#>
		</cfif>
		<cfreturn INT(lVarPorcentajeIvaGravado)>
	</cffunction>
</cfcomponent>


