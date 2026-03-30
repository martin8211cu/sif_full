<!--- ABG: Transformacion Movimientos de Inventario Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Movimientos de Inventario, procesa todos los movimientos de inventario afectando
solo la contabilidad general --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		<!--- Parametro de agrupamiento --->
		<cfset ParAgrupa = false>
		
		<!--- Crea tabla Temporal para Trabajar --->
		<cf_dbtemp name="TmpIE18" returnvariable="TmpIE18" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="numeric">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="Cconcepto" type="int">
			<cf_dbtempcol name="Eperiodo" type="int">
			<cf_dbtempcol name="Emes" type="int">
			<cf_dbtempcol name="Efecha" type="datetime">
			<cf_dbtempcol name="Edescripcion" type="varchar(100)">
			<cf_dbtempcol name="Edocbase" type="varchar(20)">
			<cf_dbtempcol name="Ereferencia" type="varchar(25)">
			<cf_dbtempcol name="Falta" type="datetime">
			<cf_dbtempcol name="Usuario" type="varchar(30)">
		</cf_dbtemp>
		<cf_dbtemp name="TmpID18" returnvariable="TmpID18" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="numeric">
			<cf_dbtempcol name="DCIconsecutivo" type="int">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="DCIEfecha" type="datetime">
			<cf_dbtempcol name="Eperiodo" type="int">
			<cf_dbtempcol name="Emes" type="int">
			<cf_dbtempcol name="Ddescripcion" type="varchar(100)">
			<cf_dbtempcol name="Ddocumento" type="varchar(20)">
			<cf_dbtempcol name="Dreferencia" type="varchar(25)">
			<cf_dbtempcol name="Dmovimiento" type="char(1)">
			<cf_dbtempcol name="Ccuenta" type="numeric">
			<cf_dbtempcol name="CFcuenta" type="numeric">
			<cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="Mcodigo" type="numeric">
			<cf_dbtempcol name="Doriginal" type="money">
			<cf_dbtempcol name="Dlocal" type="money">
			<cf_dbtempcol name="Dtipocambio" type="float">
			<cf_dbtempcol name="Cconcepto" type="int">
			<cf_dbtempcol name="BMfalta" type="datetime">
			<cf_dbtempcol name="EcodigoRef" type="int">
			<cf_dbtempcol name="CFformato" type="varchar(100)">
			<cf_dbtempcol name="Oficodigo" type="char(10)">
			<cf_dbtempcol name="Miso4217" type="char(3)">
			<cf_dbtempcol name="Referencia1" type="char(20)">
			<cf_dbtempcol name="Referencia2" type="char(20)">
			<cf_dbtempcol name="Referencia3" type="char(20)">
			<cf_dbtempcol name="CFcodigo" type="char(20)">
			<cf_dbtempcol name="TipoOperacion" type="int">
			<!--- Tipos de Operacion para Sumatoria
				1 = Salida Almacen, 2 = Entrada Almacen, 3 = Salida Transito, 4 = Entrada Transito, 5 = Ajuste
			--->
		</cf_dbtemp>
		
		<cfquery name="rsEMovInventario" datasource="sifinterfaces">
			select Ecodigo, Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento, 
				Documento, Descripcion, Almacen_Origen, Almacen_Destino, Sucursal_Origen, 
				Tipo_Ajuste, Sucursal_Destino			
			from ESIFLD_Movimientos_Inventario
			where Estatus = 1
  		</cfquery>
		<!--- Crea tabla temporal para control de Encabezados --->
		<cf_dbtemp name="rsInvEnc" returnvariable="rsInvEnc" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="int">
			<cf_dbtempcol name="Ecodigo" type="int">
   	        <cf_dbtempcol name="Documento" type="varchar(20)"> 
		</cf_dbtemp>  
  		<cfif isdefined("rsEMovInventario") and rsEMovInventario.recordcount GT 0>
		<cfloop query="rsEMovInventario">
		<cftry>
			<cfset TipoAjuste = trim(rsEMovInventario.Tipo_Ajuste)>
			<!--- Descripcion de las Polizas--->
			<cfif TipoAjuste EQ "E">
				<cfset DescAjuste = "Entrada">
			<cfelseif TipoAjuste EQ "S">
				<cfset DescAjuste = "Salida">
			<cfelseif TipoAjuste EQ "ES">
				<cfset DescAjuste = "Entrada/Salida">
			</cfif>    

			<cfset Movimiento = rsEMovInventario.Id_Movimiento>
			<cfset TipoMov = rsEMovInventario.Tipo_Movimiento>        
		
			<!--- Busca equivalencias --->
			<!---OFICINA --->
			<cfif TipoAjuste EQ "S">
				<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'SUCURSAL', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Origen, 'Sucursal')>
			<cfelse>
				<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'SUCURSAL', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Destino, 'Sucursal')>
			</cfif>
            <cfset VarOficina = Equiv.EQUempSIF>
			
			<!--- CENTRO FUNCIONAL--->
			<cfif TipoAjuste EQ "S">
				<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'CENTRO_FUN', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Origen, 'Centro_Funcional')>
			<cfelse>
				<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'CENTRO_FUN', rsEMovInventario.Ecodigo, rsEMovInventario.Sucursal_Destino, 'Centro_Funcional')>
			</cfif>
			<cfset varCF = Equiv.EQUempSIF>

			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsEMovInventario.Origen, 'CADENA', rsEMovInventario.Ecodigo, rsEMovInventario.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUempSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			
  			<cfset Periodo = year(rsEMovInventario.Fecha_Movimiento)>
			<cfset Mes = month(rsEMovInventario.Fecha_Movimiento)>

			<!--- Busca Periodo en Minisif --->
			<!---<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
				SELECT Pvalor FROM Parametros WHERE Ecodigo = #EcodigoSDC# AND Pcodigo = 50
			</cfquery>
			<cfset Periodo = #BuscaPeriodo.Pvalor#>
			
			<!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
				SELECT Pvalor FROM Parametros WHERE Ecodigo = #EcodigoSDC# AND Pcodigo = 60
			</cfquery>
			<cfset Mes = #BuscaMes.Pvalor#>--->
			
			<!--- Busca Moneda Local SIF ---> 
			<cfquery name="rsMoneda" datasource="#session.dsn#">
				select e.Ecodigo, e.Edescripcion,m.Miso4217
				from Monedas m
					inner join Empresas e
					on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
				where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(varEcodigo)#"> 
			</cfquery>
			<cfif isdefined("rsMoneda") and rsMoneda.recordcount EQ 1>
				<cfset varMoneda = rsMoneda.Miso4217>
			<cfelse>
				<cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsMoneda.Enombre#">
			</cfif>
			
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select * 
				from #rsInvEnc#
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
				and Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEMovInventario.Documento)#">
			</cfquery>	
			<cfif rsVerificaE.recordcount EQ 0>
			
				<!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 ---> 
				<cfset RsMaximo = ExtraeMaximo("IE18","ID")> 
				<cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
					<cfset Maximus = RsMaximo.Maximo>
				<cfelse>
					<cfset Maximus = 1>
				</cfif>
	
				<cfquery datasource="sifinterfaces">
					insert into #TmpIE18#
						(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, Edescripcion, Edocbase, 
						 Ereferencia, Falta, Usuario)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">, 
					 0,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento,'short')#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Movs. Inventario #DescAjuste# #rsEMovInventario.Descripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEMovInventario.Documento#">,
					 '', getdate(), 1)
				</cfquery> 
				
				<!---Inserta Registro de Control --->
				<cfquery datasource="sifinterfaces">
					insert into #rsInvEnc# (ID, Ecodigo, Documento)
					values
					(<cfqueryparam cfsqltype ="cf_sql_integer" value="#Maximus#">,
                     <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarEcodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEMovInventario.Documento)#">)
				</cfquery>
				<cfset IDlinea = 1>
			<cfelse>
				<cfset Maximus = rsVerificaE.ID>
				<cfquery name="rsLinea" datasource="sifinterfaces">
					select isnull(max(DCIconsecutivo),0) + 1 as Linea
					from #TmpID18#
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
					and ID = <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsVerificaE.ID#">
				</cfquery>
				<cfset IDlinea = rsLinea.Linea>
				<cfset IDStart = rsLinea.Linea - 1>
			</cfif>
								 
   			<!--- Selecciona Detalles de Movimiento--->
			<cfquery name="rsDMovInventario" datasource="sifinterfaces">
				select  Ecodigo, ID_movimiento, Id_Linea, Clas_Item, Cod_Item, Cantidad, 
					Costo, Cod_Fabricante, Tipo_Item
				from DSIFLD_Movimientos_Inventario
				where ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEMovInventario.ID_Movimiento#">
			</cfquery>
	   
			<cfif isdefined("rsDMovInventario") and rsDMovInventario.recordcount GT 0>
			<cfloop query = "rsDMovInventario"> 
				<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
					<!--- ALMACEN SALIDAS --->
    	            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
        	        	Oorigen="LDMI"
            	        Ecodigo="#varEcodigo#"  
                	    Conexion="#session.dsn#"
                    	LDOperacion="ALM"
						LDDepartamento="#rsDMovInventario.Tipo_Item#"
						LDClasificacion="#rsDMovInventario.Clas_Item#"
						LDFabricante="#rsDMovInventario.Cod_Fabricante#"
						LDTipoVenta="NOUSAR"
						SNegocios="NOUSAR"
						Impuestos="NOUSAR"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="#rsEMovInventario.Almacen_Origen#"
						Bancos="NOUSAR"
						LDCuentaBanco="NOUSAR"
						LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
						LDAlmacen="#rsEMovInventario.Almacen_Origen#"
						LDTipoRetiroCaja="NOUSAR">
	                </cfinvoke>          			
    	            <cfset CuentaLDCA_S = Cuenta>

					<!--- AJUSTE SALIDAS --->					
					<cfif rsEMovInventario.Tipo_Movimiento NEQ "DC" and  rsEMovInventario.Tipo_Movimiento NEQ "RC" and  rsEMovInventario.Tipo_Movimiento NEQ "TR">
	    	            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="LDMI"
							Ecodigo="#varEcodigo#"  
							Conexion="#session.dsn#"
							LDOperacion="#rsEMovInventario.Tipo_Movimiento#"
							LDDepartamento="#rsDMovInventario.Tipo_Item#"
							LDClasificacion="#rsDMovInventario.Clas_Item#"
							LDFabricante="#rsDMovInventario.Cod_Fabricante#"
							LDTipoVenta="NOUSAR"
							SNegocios="NOUSAR"
							Impuestos="NOUSAR"
							Oficinas="#varOficina#"		
							LDConceptoRetiroCaja="NOUSAR"
							Almacen="#rsEMovInventario.Almacen_Origen#"
							Bancos="NOUSAR"
							LDCuentaBanco="NOUSAR"
							LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
							LDAlmacen="#rsEMovInventario.Almacen_Origen#"
							LDTipoRetiroCaja="NOUSAR">
						</cfinvoke>          			
						<cfset CuentaLDAJ_S = Cuenta>
					</cfif>  
				</cfif>
				
				<!--- ALMACEN VENTAS ENTRADAS --->				
				<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
    	            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
        	        	Oorigen="LDMI"
            	        Ecodigo="#varEcodigo#"  
                	    Conexion="#session.dsn#"
                    	LDOperacion="ALM"
						LDDepartamento="#rsDMovInventario.Tipo_Item#"
						LDClasificacion="#rsDMovInventario.Clas_Item#"
						LDFabricante="#rsDMovInventario.Cod_Fabricante#"
						LDTipoVenta="NOUSAR"
						SNegocios="NOUSAR"
						Impuestos="NOUSAR"
						Oficinas="#varOficina#"		
						LDConceptoRetiroCaja="NOUSAR"
						Almacen="#rsEMovInventario.Almacen_Destino#"
						Bancos="NOUSAR"
						LDCuentaBanco="NOUSAR"
						LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
						LDAlmacen="#rsEMovInventario.Almacen_Destino#"
						LDTipoRetiroCaja="NOUSAR">
	                </cfinvoke>          			
    	            <cfset CuentaLDCA_E = Cuenta>
					
					<!--- AJUSTE ENTRADAS --->					
					<cfif rsEMovInventario.Tipo_Movimiento NEQ "DC" and  rsEMovInventario.Tipo_Movimiento NEQ "RC" and  rsEMovInventario.Tipo_Movimiento NEQ "TR">
	    	            <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="LDMI"
							Ecodigo="#varEcodigo#"  
							Conexion="#session.dsn#"
							LDOperacion="#rsEMovInventario.Tipo_Movimiento#"
							LDDepartamento="#rsDMovInventario.Tipo_Item#"
							LDClasificacion="#rsDMovInventario.Clas_Item#"
							LDFabricante="#rsDMovInventario.Cod_Fabricante#"
							LDTipoVenta="NOUSAR"
							SNegocios="NOUSAR"
							Impuestos="NOUSAR"
							Oficinas="#varOficina#"		
							LDConceptoRetiroCaja=""
							Almacen="#rsEMovInventario.Almacen_Destino#"
							Bancos="NOUSAR"
							LDCuentaBanco="NOUSAR"
							LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
							LDAlmacen="#rsEMovInventario.Almacen_Destino#"
							LDTipoRetiroCaja="NOUSAR">
						</cfinvoke>          			
						<cfset CuentaLDAJ_E = Cuenta>
					</cfif>  
				</cfif>
				
				<!--- TRANSITO (No Importa el Almacen) --->
                <cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
                	Oorigen="LDMI"
                    Ecodigo="#varEcodigo#"  
                    Conexion="#session.dsn#"
                    LDOperacion="TRN"
					LDDepartamento="#rsDMovInventario.Tipo_Item#"
					LDClasificacion="#rsDMovInventario.Clas_Item#"
					LDFabricante="#rsDMovInventario.Cod_Fabricante#"
					LDTipoVenta="NOUSAR"
					SNegocios="NOUSAR"
					Impuestos="NOUSAR"
					Oficinas="#varOficina#"		
					LDConceptoRetiroCaja=""
					Almacen="NOUSAR"
					Bancos="NOUSAR"
					LDCuentaBanco="NOUSAR"
					LDMovimientoInventario="#rsEMovInventario.Tipo_Movimiento#"
					LDAlmacen="TRN"
					LDTipoRetiroCaja="NOUSAR">
                </cfinvoke>          			
                <cfset CuentaLDIT = Cuenta>

				<cfset MontoLin = rsDMovInventario.Cantidad * rsDMovInventario.Costo>
				
				<!--- Inserta los asientos de la Poliza --->
				<cfif TipoAjuste EQ "S" OR TipoAjuste EQ "ES">
					<!--- Salida de Almacen --->
					<cfquery datasource="sifinterfaces">
						insert into #TmpID18# 
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	        	         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	        	     <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Salida de Almacen">, 
						 '', '', 'C',
						 0, 0, 0, 0,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
						 1, 0, getdate(), 0, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_S.CFformato#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 1)  
					</cfquery>	
					<cfset IDlinea = IDlinea + 1>
					
					<!--- Entrada a Transito --->
					<cfif rsEMovInventario.Tipo_Movimiento EQ "DC" OR  rsEMovInventario.Tipo_Movimiento EQ "RC" OR  (rsEMovInventario.Tipo_Movimiento EQ "TR" AND TipoAjuste NEQ "ES")>
						<cfquery datasource="sifinterfaces">
							insert into #TmpID18# 
								(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
								 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
								 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
								 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
							values 
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, 'short')#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Entrada a Transito">, 
							 '', '', 'D',
							 0, 0, 0, 0,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
							 1, 0, getdate(), 0, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT.CFformato#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 4)  
						</cfquery>
						<cfset IDlinea = IDlinea + 1>	 
					</cfif> 
				</cfif>

				<cfif TipoAjuste EQ "E" OR TipoAjuste EQ "ES">
					<!--- Entrada de Almacen --->
					<cfquery datasource="sifinterfaces">
						insert into #TmpID18# 
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	        	         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	        	     <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="Entrada de Almacen">, 
						 '', '', 'D',
						 0, 0, 0, 0,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
						 1, 0, getdate(), 0, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDCA_E.CFformato#">, 
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 2)  
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
					<!--- Salida de Transito --->
					<cfif rsEMovInventario.Tipo_Movimiento EQ "DC" OR  rsEMovInventario.Tipo_Movimiento EQ "RC" OR  (rsEMovInventario.Tipo_Movimiento EQ "TR" AND TipoAjuste NEQ "ES")>
						<cfquery datasource="sifinterfaces">
							insert into #TmpID18# 
								(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
								 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
								 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
								 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
							values 
							(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, 'short')#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="Salida de Transito">, 
							 '', '', 'C',
							 0, 0, 0, 0,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
							 1, 0, getdate(), 0, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDIT.CFformato#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
							 3)  
						</cfquery>
						<cfset IDlinea = IDlinea + 1>	 
					</cfif>					
				</cfif>
				
				<!--- Movimiento de Ajuste--->
				<cfif rsEMovInventario.Tipo_Movimiento NEQ "DC" and  rsEMovInventario.Tipo_Movimiento NEQ "RC" and  rsEMovInventario.Tipo_Movimiento NEQ "TR">  
					<cfquery datasource="sifinterfaces">
						insert into #TmpID18#  
							(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion,
							 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,
							 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, 
							 Oficodigo, Miso4217,CFcodigo, TipoOperacion)
						values 
						(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	        	         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	        	     <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEMovInventario.Fecha_Movimiento, 'short')#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">, 
						 <cfif TipoAjuste EQ "E">
						 	<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Entrada">, 
						 <cfelseif TipoAjuste EQ "S">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Ajuste de Salida">, 
						 </cfif>
						 '', '', 
						 <cfif TipoAjuste EQ "E">
						 	'C',
						 <cfelseif TipoAjuste EQ "S">
							'D',
						 </cfif>
						 0, 0, 0, 0,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
						 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(MontoLin,'9.99')#">,
						 1, 0, getdate(), 0, 
						 <cfif TipoAjuste EQ "E">
						 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAJ_E.CFformato#">, 
						 <cfelseif TipoAjuste EQ "S">
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDAJ_S.CFformato#">, 
						 </cfif>
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
						 5)  
					</cfquery>
					<cfset IDlinea = IDlinea + 1>
				</cfif>
			</cfloop> <!---Detalle de Ventas --->
			</cfif>  
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
        	<cfquery name="rsBorraDet_FactVen" datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Movimientos_Inventario where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
	           		delete	ESIFLD_Movimientos_Inventario where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
				<cfelse>
					update ESIFLD_Movimientos_Inventario 
					set Estatus = 2
					where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
				</cfif>
        	</cfquery>    
		<cfcatch type="any"> <!---Error en Inventarios --->
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
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Movimientos_Inventario 
				set Estatus = 3
				where ID_Movimiento = #rsEMovInventario.ID_Movimiento#
			</cfquery>
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif isdefined("Maximus")>
				<cfquery datasource="sifinterfaces">
					delete #TmpID18#
					where 
					<cfif isdefined("IDstart")>
						DCIconsecutivo > <cfqueryparam cfsqltype ="cf_sql_numeric" value="#IDstart#">
					<cfelse>
						ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
					</cfif>
				</cfquery>
				<cfif not isdefined("IDstart")>
					<cfquery datasource="sifinterfaces">
						delete #TmpIE18#
						where 
						ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
					</cfquery>
					<cfquery datasource="sifinterfaces">
						update IdProceso
						set Consecutivo = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#"> - 1
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
            <cfset MensajeError= #Mensaje# & #Detalle#>
			<cfquery datasource="sifinterfaces">
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam)
				values 
				('CG_Inventarios',
				 'ESIFLD_Movimientos_Inventario', 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEMovInventario.ID_Movimiento#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">)
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Inventarios --->
		</cfif>
		<!--- Limite --->
		<cfquery name="rsLimiteE" datasource="sifinterfaces">
			select isnull(max(ID),0) as MaxID
			from #TmpIE18#
		</cfquery>
		<cfif rsLimiteE.MaxID GT 0>
			<!--- Inserta En las Interfaces --->
			<cfquery datasource="sifinterfaces">
				insert into IE18 
					(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha,
					 Edescripcion, Edocbase, Ereferencia, Falta, Usuario)
				select 
					ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha,
					Edescripcion, Edocbase, Ereferencia, Falta, Usuario
				from #TmpIE18#
			</cfquery>
			<cfif ParAgrupa>
				<cf_dbtemp name="ID18Datos" returnvariable="ID18Datos" datasource="sifinterfaces">
					<cf_dbtempcol name="ID" type="numeric">
					<cf_dbtempcol name="DCIconsecutivo" type="int">
					<cf_dbtempcol name="Ecodigo" type="int">
					<cf_dbtempcol name="DCIEfecha" type="datetime">
					<cf_dbtempcol name="Eperiodo" type="int">
					<cf_dbtempcol name="Emes" type="int">
					<cf_dbtempcol name="Ddescripcion" type="varchar(100)">
					<cf_dbtempcol name="Ddocumento" type="varchar(20)">
					<cf_dbtempcol name="Dreferencia" type="varchar(25)">
					<cf_dbtempcol name="Dmovimiento" type="char(1)">
					<cf_dbtempcol name="Ccuenta" type="numeric">
					<cf_dbtempcol name="CFcuenta" type="numeric">
					<cf_dbtempcol name="Ocodigo" type="int">
					<cf_dbtempcol name="Mcodigo" type="numeric">
					<cf_dbtempcol name="Doriginal" type="money">
					<cf_dbtempcol name="Dlocal" type="money">
					<cf_dbtempcol name="Dtipocambio" type="float">
					<cf_dbtempcol name="Cconcepto" type="int">
					<cf_dbtempcol name="BMfalta" type="datetime">
					<cf_dbtempcol name="EcodigoRef" type="int">
					<cf_dbtempcol name="CFformato" type="varchar(100)">
					<cf_dbtempcol name="Oficodigo" type="char(10)">
					<cf_dbtempcol name="Miso4217" type="char(3)">
					<cf_dbtempcol name="Referencia1" type="char(20)">
					<cf_dbtempcol name="Referencia2" type="char(20)">
					<cf_dbtempcol name="Referencia3" type="char(20)">
					<cf_dbtempcol name="CFcodigo" type="char(20)">
				</cf_dbtemp>
				<cfquery datasource="sifinterfaces">
					insert into #ID18Datos#
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes,
						 Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta,
						 CFcuenta, Ocodigo, Mcodigo, Doriginal, Dlocal, Dtipocambio,
						 Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, Miso4217,
						 Referencia1, Referencia2, Referencia3, CFcodigo)
					select a.ID, 0 as Consecutivo, b.Ecodigo, getdate(), b.Eperiodo, b.Emes,
						a.Ddescripcion, '','', a.Dmovimiento, null,
						null, null, null, a.Monto, a.Local, a.Dtipocambio, 
						0, getdate(), b.EcodigoRef, a.CFformato, b.Oficodigo, a.Miso4217,
						null, null, null, b.CFcodigo
					from 
						(select 
							ID, Ddescripcion, sum(Doriginal) as Monto , sum(Dlocal) as Local, Dtipocambio,
							Dmovimiento,CFformato, Miso4217, TipoOperacion
						from #TmpID18#
						group by ID, TipoOperacion, Dmovimiento, Ddescripcion, CFformato, Miso4217, Dtipocambio) a
					inner join 
						(select distinct
							ID, Ecodigo, getdate() as DCIEfecha, Eperiodo, Emes,
							Ddescripcion, Dmovimiento, Ccuenta,
							Cconcepto, EcodigoRef, CFformato, Oficodigo, 
							Miso4217, Dtipocambio, CFcodigo, TipoOperacion
						from #TmpID18#) b
					on a.ID = b.ID 
					and a.TipoOperacion = b.TipoOperacion
					and a.Dmovimiento = b.Dmovimiento
					and a.Ddescripcion = b.Ddescripcion
					and a.CFformato = b.CFformato
					and a.Miso4217 = b.Miso4217
					and a.Dtipocambio = b.Dtipocambio
				</cfquery>
				<!--- Actualiza consecutivo y Fecha --->
				<cfloop from="1" to="#rsLimiteE.MaxID#" index="ID">
					<cfquery datasource="sifinterfaces">
						declare @IDlinea as int
						select @IDlinea = 0
						update #ID18Datos#
						set @IDlinea = @IDlinea + 1,
						DCIconsecutivo = @IDlinea, DCIEfecha = e.Efecha
						from #ID18Datos# d, #TmpIE18# e
						where d.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ID#">
						and d.ID = e.ID
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
					from #ID18Datos#
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
					from #TmpID18#
				</cfquery>
			</cfif>
			<!--- Dispara Interfaz --->
			<!---
			<!--- Limites --->
			<cfquery name="rsLimite" datasource="sifinterfaces">
				select min(ID) as ID, max(ID) as ID2
				from #TmpIE18#
			</cfquery>
			<cfset disparaInterfaz(18, #rsLimite.ID#, varEcodigo,1,#rsLimite.ID2#)> --->
		</cfif>
	</cffunction>
</cfcomponent>