<!--- ABG: Transformacion Retiros de Caja Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz Retiros de Caja, procesa todos los retiros de caja y retiros por gastos  --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!---
<!--- Rutina para Obtener Parametros a Ocupar --->
<!--- Equivalencia Oficina --->
	<cfset ParOfic = false>
<!--- Equivalencia Centro Funcional --->
	<cfset ParCF = false>
<!--- Crear un Parametro Ver 2.0 --->
	<cfset ParBorrado = false>
<!--- Parametro de agrupamiento --->
	<cfset ParAgrupa = true>
<!---Parametros Forma de Retiro--->
	<cfset ParEfe = true>
    <cfset ParTar = false>
    <cfset ParVal = false>
    <cfset ParChe = true>
    <cfset ParExt = true>
    <cfset ParNot = false>
    <cfset ParMon = false>
    <cfset ParFon = false>
--->        
<cfcomponent extends="Interfaz_Base" output="no">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes"> 
    	<cfargument name="Disparo" required="no" type="boolean" default="false"> <!---ABG--->

		<!---Invocar al GC para liberar memoria---> <!---ABG--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()><!--- invoca el GC --->
        
		<!--- Tipos de Operacion para Sumatoria
		1 = Salida Efectivo Caja 2 = Deposito en Tombola 
		--->
									
		<!--- Extrae encabezados de Retiros ---> <!---ABG--->
		<cfquery datasource="sifinterfaces" result="Rupdate">
			update top (300) ESIFLD_Retiros_Caja
			set Estatus = 10
			where 
            <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
	            Estatus = 1
            	and not exists (select 1 from ESIFLD_Retiros_Caja where Estatus in (10, 11,94,92,99,100))
            <cfelse>
            	Estatus = 99
            	and not exists (select 1 from ESIFLD_Retiros_Caja where Estatus in (10, 11))
            </cfif>
		</cfquery>
		<cfquery name="rsIDERetiros" datasource="sifinterfaces"> <!---ABG--->
			select ID_Retiro
			from ESIFLD_Retiros_Caja
			where Estatus = 10
             <cfif Rupdate.recordcount EQ 0>
            	and 1 = 2
            </cfif>
		</cfquery>

		<cfif isdefined("rsIDERetiros") and rsIDERetiros.recordcount GT 0>
		<cfloop query="rsIDERetiros">
		<cftry>
        	<cfset varBorraRegistro = false>
            <cfset Maximus = 0>
			<cfquery name="rsERetiros" datasource="sifinterfaces"> <!---ABG--->
                select Ecodigo, Origen, ID_Retiro, Tipo_Retiro, Concepto_Retiro, 
                    Fecha_Retiro, Sucursal,  NumDoc_Retiro
                from ESIFLD_Retiros_Caja
                where ID_Retiro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDERetiros.ID_Retiro#">
            </cfquery>
			<cfset Retiro = rsERetiros.ID_Retiro>
            
            <cfquery datasource="sifinterfaces">
                update ESIFLD_Retiros_Caja
                set Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where ID_Retiro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Retiro#">
            </cfquery>
            
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsERetiros.Origen, 'CADENA', rsERetiros.Ecodigo, rsERetiros.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUidSIF>
            <cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			<cfset varCEcodigo = getCEcodigo(varEcodigo)>
            <cfset varCconcepto = ConceptoContable(varEcodigo,"LDRT")>
            
            <!--- Obtiene los parametros --->
            <cfset ParOfic = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=rsERetiros.Sucursal,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            
            <!--- Equivalencia Centro Funcional --->
            <cfset ParCF = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=rsERetiros.Sucursal,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            
			<!--- Borrar Registro --->
            <cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsERetiros.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            
            <!--- Agrupamiento --->
            <cfset ParAgrupa = Parametros(Ecodigo=varEcodigo,Pcodigo=8,Sucursal=rsERetiros.Sucursal,Parametro="Agrupa Pólizas",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            
            <!--- Formas de Pago --->
			<!---	Efectivo = E
					Tarjeta = T
					Cupones = V
					Cheques = H
					MonedaExtranjera = X
					NotadeCredito = N
					Monedero = M
					FondoCaja = F --->
                    
			<cfset ParEfe = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="E", Parametro="Forma de Pago Efectivo",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
			<cfset ParTar = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="T", Parametro="Forma de Pago Tarjeta",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            <cfset ParVal = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="V", Parametro="Forma de Pago Vale",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            <cfset ParChe = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="H", Parametro="Forma de Pago Cheque",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            <cfset ParExt = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="X", Parametro="Forma de Pago Moneda Extranjera",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            <cfset ParNot = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="N", Parametro="Forma de Pago Nota de Credito",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            <cfset ParMon = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="M", Parametro="Forma de Pago Monedero",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            <cfset ParFon = Parametros(Ecodigo=varEcodigo,Pcodigo=10,Sucursal=rsERetiros.Sucursal, Criterio="F", Parametro="Fondo de caja",ExtBusqueda=true, Sistema = rsERetiros.Origen)>
            
            <!--- Obtiene el usuario de Interfaz --->
	        <cfset Usuario = UInterfaz (getCEcodigo(varEcodigo))>
			<cfset varUlogin = Usuario.Usulogin>
            <cfset varUcodigo = Usuario.Usucodigo>
            
			<cfif ParOfic>
				<!---OFICINA --->
                <cfset Equiv = ConversionEquivalencia (rsERetiros.Origen, 'SUCURSAL', rsERetiros.Ecodigo, rsERetiros.Sucursal, 'Sucursal')>
                <cfset VarOcodigo = Equiv.EQUidSIF>
				<cfset VarOficina = Equiv.EQUcodigoSIF>
            <cfelse>
				 <cfset VarOficina = rsERetiros.Sucursal>
                 <cfquery name="rsOFid" datasource="#session.dsn#">
                 	select Ocodigo 
                    from Oficinas
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                    and Oficodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#VarOficina#">
                 </cfquery>	
                 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
                 	<cfset VarOcodigo = rsOFid.Ocodigo>
                 </cfif>
            </cfif>
				
			<cfif ParCF>
				<!--- CENTRO FUNCIONAL--->
                <cfset Equiv = ConversionEquivalencia (rsERetiros.Origen, 'CENTRO_FUN', rsERetiros.Ecodigo, rsERetiros.Sucursal, 'Centro_Funcional')>
                <cfset varidCF = Equiv.EQUidSIF>
				<cfset varCF = Equiv.EQUcodigoSIF>
			<cfelse>
           		<cfset varCF = rsERetiros.Sucursal>
                <cfquery name="rsOFid" datasource="#session.dsn#">
                 	select CFid 
                    from CFuncional
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                    and CFcodigo like <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">
                 </cfquery>	
                 <cfif isdefined("rsOFid") and rsOFid.recordcount GT 0>
                 	<cfset varidCF = rsOFid.CFid>
                 </cfif>
            </cfif>
            
			<!--- Busca Moneda Local SIF ---> 
			<cfquery name="rsMoneda" datasource="#session.dsn#">
				select e.Ecodigo, e.Edescripcion,m.Miso4217
				from Monedas m
					inner join Empresas e
					on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
				where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#"> 
			</cfquery>
			<cfif isdefined("rsMoneda") and rsMoneda.recordcount EQ 1>
				<cfset varMoneda = rsMoneda.Miso4217>
			<cfelse>
				<cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsMoneda.Enombre#">
			</cfif>
			<!---
			<cfset Periodo = year(rsERetiros.Fecha_Retiro)>
			<cfset Mes = month(rsERetiros.Fecha_Retiro)>--->
			<!--- Busca Periodo en Minisif --->
			<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
				select Pvalor from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                and Pcodigo = 50
			</cfquery>
			<cfset Periodo = BuscaPeriodo.Pvalor>
			
			<!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
				select Pvalor from Parametros 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
                and Pcodigo = 60
			</cfquery>
			<cfset Mes = BuscaMes.Pvalor>
			
			<!--- Descripcion de Poliza --->
			<cfif rsERetiros.Tipo_Retiro EQ "RC">
				<cfset TipoRet = "Retiro de Caja #trim(rsERetiros.NumDoc_Retiro)#">
			<cfelseif rsERetiros.Tipo_Retiro EQ "GS">
				<cfset TipoRet = "Gasto de Sucursal #trim(rsERetiros.NumDoc_Retiro)#">
			</cfif>        
			
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces"> <!---ABG--->
				select ID 
				from SIFLD_IE18
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">
				and Edocbase like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsERetiros.NumDoc_Retiro)#">
			</cfquery>	
			<cfif rsVerificaE.recordcount EQ 0>
				<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 ---> 
				<cfset RsMaximo = ExtraeMaximo("IE18","ID")> 
				<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
					<cfset Maximus = RsMaximo.Maximo>
				<cfelse>
					<cfset Maximus = 1>
				</cfif>
				
				<!--- Insercion de cabecera en IE18 --->
				<cfquery datasource="sifinterfaces">
					insert into SIFLD_IE18
						(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, 
						 Edescripcion, Edocbase, Ereferencia, Falta, Usuario, 
                         CEcodigo, EcodigoSDC, Usulogin, Usucodigo)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">, 
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Fecha_Retiro,"yyyy/mm/dd")#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de #TipoRet#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.NumDoc_Retiro#">,
					'', getdate(),
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
                    <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                    <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varEcodigoSDC#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">)  
				</cfquery>
				
				<cfset IDlinea = 1>
                <cfset varBorraRegistro = true>
			<cfelse>
				<cfset Maximus = rsVerificaE.ID>
				<cfquery name="rsLinea" datasource="sifinterfaces">
					select isnull(max(DCIconsecutivo),0) + 1 as Linea
					from SIFLD_ID18
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">
					and ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsVerificaE.ID#">
				</cfquery>
				<cfset IDlinea = rsLinea.Linea>
				<cfset IDStart = rsLinea.Linea - 1>
			</cfif>
			
			<!--- SELECCION DE REGISTROS DE DETALLE --->    
			<cfquery name="rsDRetiros" datasource="sifinterfaces">
				select  Ecodigo, Origen, Id_Retiro, Id_Linea_Retiro, Forma_Retiro, 
					Codigo_Forma_Retiro, Monto_Retiro
				from DSIFLD_Retiros_Caja
				where Id_Retiro = #Retiro#
				<cfif ParEfe EQ False>
					and Forma_Retiro not like 'E'
				</cfif>
				<cfif ParTar EQ false>
					and Forma_Retiro not like 'T'
				</cfif>
				<cfif ParVal EQ false>
					and Forma_Retiro not like 'V'
				</cfif>
				<cfif ParChe EQ false>
					and Forma_Retiro not like 'H'
				</cfif>
				<cfif ParExt EQ false>
					and Forma_Retiro not like 'X'
				</cfif>
				<cfif ParNot EQ false>
					and Forma_Retiro not like 'N'
				</cfif>
				<cfif ParMon EQ false>
					and Forma_Retiro not like 'M'
				</cfif>
				<cfif ParFon EQ false>
					and Forma_Retiro not like 'F'
				</cfif>
			</cfquery>

			<cfif isdefined("rsDRetiros") and rsDRetiros.recordcount GT 0>
			<cfloop query = "rsDRetiros">
  	
				<!--- EFECTIVO EN CAJA  --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDRT"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="EFC"
					LDDepartamento="NOUSAR"
					LDClasificacion="NOUSAR"
					LDFabricante="NOUSAR"
					LDTipoVenta="NOUSAR"
					SNegocios="NOUSAR"
					Impuestos="NOUSAR"
					Oficinas="#VarOcodigo#"		
					LDConceptoRetiroCaja="#rsERetiros.Concepto_Retiro#"
					Almacen="NOUSAR"
					Bancos="NOUSAR"
					LDCuentaBanco="NOUSAR"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="R">
                </cfinvoke>         			
                <cfset CuentaLDEF = Cuenta>  
				
				<!--- TOMBOLA  --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDRT"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="TOM"
					LDDepartamento="NOUSAR"
					LDClasificacion="NOUSAR"
					LDFabricante="NOUSAR"
					LDTipoVenta="NOUSAR"
					SNegocios="NOUSAR"
					Impuestos="NOUSAR"
					Oficinas="#VarOcodigo#"		
					LDConceptoRetiroCaja="#rsERetiros.Concepto_Retiro#"
					Almacen="NOUSAR"
					Bancos="NOUSAR"
					LDCuentaBanco="NOUSAR"
					LDMovimientoInventario="NOUSAR"
					LDAlmacen="NOUSAR"
					LDTipoRetiroCaja="D">
                </cfinvoke>         			
                <cfset CuentaLDTM = Cuenta> 
				             
				<cfif rsERetiros.Tipo_Retiro EQ "GS">
					<!--- GASTO  --->
					<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
						Oorigen="LDRT"
						Ecodigo="#varEcodigo#"  
						Conexion="#session.dsn#"
						LDOperacion="GAS"
						LDDepartamento="NOUSAR"
						LDClasificacion="NOUSAR"
						LDFabricante="NOUSAR"
						LDTipoVenta="NOUSAR"
						SNegocios="NOUSAR"
						Impuestos="NOUSAR"
						Oficinas="#VarOcodigo#"		
						LDConceptoRetiroCaja="#rsERetiros.Concepto_Retiro#"
						Almacen="NOUSAR"
						Bancos="NOUSAR"
						LDCuentaBanco="NOUSAR"
						LDMovimientoInventario="NOUSAR"
						LDAlmacen="NOUSAR"
						LDTipoRetiroCaja="D">
					</cfinvoke>         			
					<cfset CuentaLDGA = Cuenta> 
				</cfif>				
						  
				<!--- insercion del detalle en la tabla IE18 con Cuenta Contable Efectivo en Caja --->
				<cfquery name="rsInsertaID18" datasource="sifinterfaces">
					insert into SIFLD_ID18
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion, 
						 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,                         Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, 
						 Miso4217,CFcodigo, TipoOperacion)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
    	             <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">,
	        	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Fecha_Retiro, "yyyy/mm/dd")#">,
    	        	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Retiro de Efectivo en Caja">,
					 ' ', ' ', 'C', 0, 0, 0, 0, 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDRetiros.Monto_Retiro,'9.99')#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDRetiros.Monto_Retiro,'9.99')#">,
					 1, 
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
                     getdate(), 0, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
					 1)
			  	</cfquery>
			  	<cfset IDlinea = IDlinea + 1>
					 
			  	<!--- Inserta Movimiento Debito--->
				<cfquery name="rsInsertaID18" datasource="sifinterfaces">
					insert into SIFLD_ID18 
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion, 
						 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,                                            
						 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, 
						 Miso4217,CFcodigo, TipoOperacion)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDLinea#">,
    	             <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">,
	        	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Fecha_Retiro, "yyyy/mm/dd")#">,
    	        	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					 <cfif rsERetiros.Tipo_Retiro EQ "GS">
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Gasto de Sucursal">,
					 <cfelseif rsERetiros.Tipo_Retiro EQ "RC">
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Deposito en Tombola">,
					 </cfif>
					 ' ', ' ', 'D', 0, 0, 0, 0, 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDRetiros.Monto_Retiro,'9.99')#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDRetiros.Monto_Retiro,'9.99')#">,
					 1, 
                     <cfqueryparam cfsqltype="cf_sql_integer" value="#varCconcepto#">,
                     getdate(), 0, 
					 <cfif rsERetiros.Tipo_Retiro EQ "GS">
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDGA.CFformato#">,
					 <cfelseif rsERetiros.Tipo_Retiro EQ "RC">
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDTM.CFformato#">,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
					 2)
			  	</cfquery>
			 	<cfset IDlinea = IDlinea + 1>
			</cfloop> <!---Retiros Detalle--->
			</cfif>
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  <!---ABG--->
            <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
        	<cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Retiros_Caja where ID_Retiro = #Retiro#
	           		delete	ESIFLD_Retiros_Caja where ID_Retiro = #Retiro#
				<cfelse>
					update ESIFLD_Retiros_Caja 
					set Estatus = 92,
                    ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
                    Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#,
                    Periodo = #Periodo#,
                    Mes = #Mes#
					where ID_Retiro = #Retiro#
				</cfif>
        	</cfquery> 
            
            <cfset rsERetiros = javacast("null","")> <!---ABG--->
            <cfset rsOFid = javacast("null","")>
            <cfset rsMoneda = javacast("null","")>   
            <cfset rsVerificaE = javacast("null","")>   
            <cfset rsLinea = javacast("null","")>   
            <cfset rsDRetiros = javacast("null","")>   
            
		<cfcatch type="any"> <!---Error en Retiros --->
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Retiros_Caja
				set Estatus = 3,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_Retiro = #Retiro#
			</cfquery>
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif varBorraRegistro>
				<cfif isdefined("Maximus") and Maximus NEQ 0>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_ID18 
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
	                    delete from SIFLD_IE18 
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
                </cfif>
            <cfelse>
            	<cfif isdefined("Maximus") and Maximus NEQ 0 and isdefined("IDStart")>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_ID18
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                        and DCIconsecutivo > <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDStart#">
                    </cfquery>
               </cfif>
           	</cfif>
			<cfif isdefined("cfcatch.Message")>
				<cfset Mensaje="#cfcatch.Message#">
			<cfelse>
				<cfset Mensaje="">
            </cfif>
            <cfif isdefined("cfcatch.Detail")>
               	<cfset Detalle="#cfcatch.Detail#">
			<cfelse>
				<cfset Detalle="">
            </cfif>
			<cfif isdefined("cfcatch.sql")>
               	<cfset SQL="#cfcatch.sql#">
			<cfelse>
				<cfset SQL="">
            </cfif>
			<cfif isdefined("cfcatch.where")>
               	<cfset PARAM="#cfcatch.where#">
			<cfelse>
				<cfset PARAM="">
            </cfif>
            <cfif isdefined("cfcatch.StackTrace")>
				<cfset PILA="#cfcatch.StackTrace#">
			<cfelse>
				<cfset PILA="">
			</cfif>
            <cfset MensajeError= #Mensaje# & #Detalle#>
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores <!---ABG--->
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
				values 
				('CG_Caja',
				 'ESIFLD_Retiros_Caja', 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Retiro#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERetiros.Ecodigo#">,
                 null) 
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Retiros ---> <!---ABG--->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from ESIFLD_Retiros_Caja
                where Estatus in (99,100,10,11)
            </cfquery>
			<cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz de forma Masiva--->
                <cftransaction action="begin">
                <cftry>
                	<cfquery datasource="sifinterfaces">
                    	delete SIFLD_ID18B where Interfaz = 'CG_Caja'
                    </cfquery>
                    <!---Prepara los registros para ser insertados--->
                    <cfquery datasource="sifinterfaces">
                    	update SIFLD_IE18 
                        	set Interfaz = 'CG_Caja', Estatus = 1
                        where ID in (select ID18 
                        			 from ESIFLD_Retiros_Caja
                                     where Estatus in (92))
                    </cfquery>
                    
					<!--- Inserta En las Interfaces --->
                    <cfquery datasource="sifinterfaces">
                        insert into IE18 
                            (ID, Ecodigo, Cconcepto, Eperiodo, Emes, 
                             Efecha, Edescripcion, Edocbase, Ereferencia, 
                             Falta, Usuario)
                        select 
                            ID, Ecodigo, Cconcepto, Eperiodo, Emes, 
                            Efecha, Edescripcion, Edocbase, Ereferencia, 
                            Falta, Usuario
                        from SIFLD_IE18 a
                        where Interfaz = 'CG_Caja' and Estatus = 1
                    </cfquery>
                    <cfif ParAgrupa>
                        <cfquery datasource="sifinterfaces">
                            insert into SIFLD_ID18B
                                (ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
                                 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
                                 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
                                 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
                                 Referencia1, Referencia2, Referencia3, CFcodigo, Interfaz)
                            select ID, 0 as Consecutivo, Ecodigo, getdate(), Eperiodo, Emes,
                                Ddescripcion, '','', Dmovimiento, null,
                                null, null, null, sum(Doriginal), sum(Dlocal), Dtipocambio, 
                                Cconcepto, getdate(), EcodigoRef, CFformato, Oficodigo, Miso4217,
                                null, null, null, CFcodigo, 'CG_Caja'
                            from SIFLD_ID18 a
                            where exists (select 1 
                            			  from SIFLD_IE18 b 
                                          where a.ID = b.ID and b.Interfaz = 'CG_Caja' and b.Estatus = 1)
                            group by ID, Ecodigo, Eperiodo, Emes, EcodigoRef, Oficodigo, Cconcepto, 
                            		TipoOperacion, Dmovimiento, Ddescripcion, CFformato, Miso4217, 
                                    Dtipocambio, CFcodigo
                            order by ID
                        </cfquery>

                        <!--- Actualiza Consecutivo --->
                        <cfquery datasource="sifinterfaces">
                            declare @Consecutivo numeric(18,0)

                            select @Consecutivo = 0
                            
                            update SIFLD_ID18B
                            set  Consecutivo = @Consecutivo, 
                            @Consecutivo = @Consecutivo + 1
                            where Interfaz = 'CG_Caja'
                        </cfquery>
                        
                        <cfset varConsecutivo = 0>
                        <cfset varID = 0>
                        
                        <cfquery name="rsConsecutivo" datasource="sifinterfaces">
                        	select ID, Consecutivo
                            from SIFLD_ID18B
                            where Interfaz = 'CG_Caja'
                            order by ID, Consecutivo
                        </cfquery>
                        
                        <cfloop query="rsConsecutivo">
                        	<cfif rsConsecutivo.ID NEQ varID>
                            	<cfset varConsecutivo = 1>
                                <cfset varID = rsConsecutivo.ID>
                            <cfelse>
								<cfset varConsecutivo = varConsecutivo + 1>
							</cfif>
                            
                            <cfquery datasource="sifinterfaces">
                            	update SIFLD_ID18B
                                set  DCIconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varConsecutivo#">
                                where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConsecutivo.ID#">
                                and Consecutivo = <cfqueryparam cfsqltype="cf_sql_inetger" value="#rsConsecutivo.Consecutivo#">
                                and Interfaz = 'CG_Caja'
                            </cfquery>
                        </cfloop>
                        
                        <cfquery datasource="sifinterfaces">
                            insert into ID18 
                                (ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
                                 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
                                 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
                                 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
                                 Referencia1, Referencia2, Referencia3, CFcodigo)
                            select 
                                ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
                                Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
                                CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
                                Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
                                Referencia1, Referencia2, Referencia3, CFcodigo
                            from SIFLD_ID18B where Interfaz = 'CG_Caja'
                        </cfquery>
                    <cfelse>
                        <cfquery name="rsID18V" datasource="sifinterfaces">
                            insert into ID18 
                                (ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
                                 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
                                 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
                                 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
                                 Referencia1, Referencia2, Referencia3, CFcodigo)
                            select 
                                ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
                                Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
                                CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
                                Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
                                Referencia1, Referencia2, Referencia3, CFcodigo
                            from SIFLD_ID18 a
                            where exists (select 1 
                            			  from SIFLD_IE18 b 
                                          where a.ID = b.ID and b.Interfaz = 'CG_Caja' and b.Estatus = 1)
                        </cfquery>
                    </cfif>
                    
                    <!--- Dispara Interfaz --->
                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos (
                            CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                            EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                            FechaInclusion, Cancelar, UsucodigoInclusion, UsuarioBdInclusion)
                        select
                          a.CEcodigo,
                          18,
                          ID,
                          0 as SecReproceso,
                          a.EcodigoSDC,
                          'E' as OrigenInterfaz,
                          'A' as TipoProcesamiento,
                          1 as StatusProceso,
                          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
                          0 as Cancelar,
                          a.Usucodigo,
                          a.Usulogin
                        from SIFLD_IE18 a 
                        where Interfaz = 'CG_Caja' and Estatus = 1
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Retiros_Caja
                            set Estatus = 2
                        where Estatus in (92)
                        and ID18 in (select ID from SIFLD_IE18 where Interfaz = 'CG_Caja' and Estatus = 1)
                    </cfquery>
                    
                    <cftransaction action="commit" />
                <cfcatch>
                    <cftransaction action="rollback" />
                    <cfif isdefined("cfcatch.Message")>
                        <cfset Mensaje="#cfcatch.Message#">
                    <cfelse>
                        <cfset Mensaje="">
                    </cfif>
                    <cfif isdefined("cfcatch.Detail")>
                        <cfset Detalle="#cfcatch.Detail#">
                    <cfelse>
                        <cfset Detalle="">
                    </cfif>
                    <cfif isdefined("cfcatch.sql")>
                        <cfset SQL="#cfcatch.sql#">
                    <cfelse>
                        <cfset SQL="">
                    </cfif>
                    <cfif isdefined("cfcatch.where")>
                        <cfset PARAM="#cfcatch.where#">
                    <cfelse>
                        <cfset PARAM="">
                    </cfif>
                    <cfif isdefined("cfcatch.StackTrace")>
                        <cfset PILA="#cfcatch.StackTrace#">
                    <cfelse>
                        <cfset PILA="">
                    </cfif>
                    <cfset MensajeError= #Mensaje# & #Detalle#>
                    <cfquery datasource="sifinterfaces">
                        insert into SIFLD_Errores 
                        (Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
                        select 'CG_Caja', 'ESIFLD_Retiros_Caja',  ID_Retiro,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            null
                        from ESIFLD_Retiros_Caja
                        where Estatus in (92)  
                        and ID18 in (select ID from SIFLD_IE18 where Interfaz = 'CG_Caja' and Estatus = 1)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Retiros_Caja set Estatus = 3
                        where Estatus in (92) 
                        and ID18 in (select ID from SIFLD_IE18 where Interfaz = 'CG_Caja' and Estatus = 1)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction>
                
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID18
                    where ID in (select ID18 from ESIFLD_Retiros_Caja where Estatus in (2,4,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE18
                    where ID in (select ID18 from ESIFLD_Retiros_Caja where Estatus in (2,4,3))
                </cfquery>
            </cfif>
	</cfif>
    </cffunction>
</cfcomponent>