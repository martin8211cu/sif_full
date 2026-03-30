<!--- ABG: Transformacion Retiros de Caja Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz Retiros de Caja, procesa todos los retiros de caja y retiros por gastos  --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="yes">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
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
				1 = Salida Efectivo Caja 2 = Deposito en Tombola 
			--->
		</cf_dbtemp>
									
		<!--- Extrae encabezados de Retiros --->
		<cfquery name="rsERetiros" datasource="sifinterfaces">
			select Ecodigo, Origen, ID_Retiro, Tipo_Retiro, Concepto_Retiro, 
				Fecha_Retiro, Sucursal,  NumDoc_Retiro
			from ESIFLD_Retiros_Caja
			where Estatus = 1
		</cfquery>
		<!--- Crea tabla temporal para control de Encabezados --->
		<cf_dbtemp name="rsRetiroEnc" returnvariable="rsRetiroEnc" datasource="sifinterfaces">
			<cf_dbtempcol name="ID" type="int">
			<cf_dbtempcol name="Ecodigo" type="int">
   	        <cf_dbtempcol name="Documento" type="varchar(20)"> 
		</cf_dbtemp>  
		<cfif isdefined("rsERetiros") and rsERetiros.recordcount GT 0>
		<cfloop query="rsERetiros">
		<cftry>
		
			<cfset Retiro = rsERetiros.Id_Retiro>
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsERetiros.Origen, 'CADENA', rsERetiros.Ecodigo, rsERetiros.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUempSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
		
			<!---OFICINA --->
			<cfset Equiv = ConversionEquivalencia (rsERetiros.Origen, 'SUCURSAL', rsERetiros.Ecodigo, rsERetiros.Sucursal, 'Sucursal')>
        	<cfset VarOficina = Equiv.EQUempSIF>
			
			<!--- CENTRO FUNCIONAL--->
			<cfset Equiv = ConversionEquivalencia (rsERetiros.Origen, 'CENTRO_FUN', rsERetiros.Ecodigo, rsERetiros.Sucursal, 'Centro_Funcional')>
			<cfset varCF = Equiv.EQUempSIF>
			
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
			
			<cfset Periodo = year(rsERetiros.Fecha_Retiro)>
			<cfset Mes = month(rsERetiros.Fecha_Retiro)>
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
			
			<!--- Descripcion de Poliza --->
			<cfif rsERetiros.Tipo_Retiro EQ "RC">
				<cfset TipoRet = "Retiro de Caja">
			<cfelseif rsERetiros.Tipo_Retiro EQ "GS">
				<cfset TipoRet = "Gasto de Sucursal">
			</cfif>        
			
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select * 
				from #rsRetiroEnc#
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">
				and Documento like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsERetiros.NumDoc_Retiro)#">
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
					insert into #TmpIE18#
						(ID, Ecodigo, Cconcepto, Eperiodo, Emes, Efecha, 
						 Edescripcion, Edocbase, Ereferencia, Falta, Usuario)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo#">, 0,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Fecha_Retiro,'short')#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Poliza de #TipoRet#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsERetiros.NumDoc_Retiro#">,
					'', getdate(), '0')  
				</cfquery>
				
				<!---Inserta Registro de Control --->
				<cfquery datasource="sifinterfaces">
					insert into #rsRetiroEnc# (ID, Ecodigo, Documento)
					values
					(<cfqueryparam cfsqltype ="cf_sql_integer" value="#Maximus#">,
                     <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarEcodigo#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsERetiros.NumDoc_Retiro)#">)
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
					Oficinas="#varOficina#"		
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
					Oficinas="#varOficina#"		
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
						Oficinas="#varOficina#"		
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
					insert into #TmpID18#
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion, 
						 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,                                            
						 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, 
						 Miso4217,CFcodigo, TipoOperacion)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	                 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	             <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
	        	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Fecha_Retiro, 'short')#">,
    	        	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">, 
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="Retiro de Efectivo en Caja">,
					 ' ', ' ', 'C', 0, 0, 0, 0, 
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDRetiros.Monto_Retiro,'9.99')#">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsDRetiros.Monto_Retiro,'9.99')#">,
					 1, 0, getdate(), 0, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaLDEF.CFformato#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varOficina#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF#">,
					 1)
			  	</cfquery>
			  	<cfset IDlinea = IDlinea + 1>
					 
			  	<!--- Inserta Movimiento Debito--->
				<cfquery name="rsInsertaID18" datasource="sifinterfaces">
					insert into #TmpID18# 
						(ID, DCIconsecutivo, Ecodigo, DCIEfecha, Eperiodo, Emes, Ddescripcion, 
						 Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Ocodigo, Mcodigo,                                            
						 Doriginal, Dlocal, Dtipocambio, Cconcepto, BMfalta, EcodigoRef, CFformato, Oficodigo, 
						 Miso4217,CFcodigo, TipoOperacion)
					values 
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
	                 <cfqueryparam cfsqltype="cf_sql_integer" value="#IDLinea#">,
    	             <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo#">,
	        	     <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsERetiros.Fecha_Retiro, 'short')#">,
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
					 1, 0, getdate(), 0, 
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
			<!--- BORRADO DE TABLAS ORIGEN --->  
        	<cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete 	DSIFLD_Retiros_Caja where ID_Retiro = #Retiro#
	           		delete	ESIFLD_Retiros_Caja where ID_Retiro = #Retiro#
				<cfelse>
					update ESIFLD_Retiros_Caja 
					set Estatus = 2
					where ID_Retiro = #Retiro#
				</cfif>
        	</cfquery>    
		<cfcatch type="any"> <!---Error en Retiros --->
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
				update ESIFLD_Retiros_Caja
				set Estatus = 3
				where ID_Retiro = #Retiro#
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
				('CG_Caja',
				 'ESIFLD_Retiros_Caja', 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Retiro#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">) 
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Retiros --->
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
				<!--- Actualiza fecha y tipo cambio --->
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