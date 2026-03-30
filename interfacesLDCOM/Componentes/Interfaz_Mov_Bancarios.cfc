<!--- ABG: Transformacion Operaciones Bancarias Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Operaciones Bancarias, procesa todos los Retiros Con Deposito  Bancos --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<cfcomponent extends="Interfaz_Base">
    <cffunction name="Ejecuta" access="public" returntype="string" output="yes">
        <!--- Parametro para usar equivalencia de Bancos en Depositos--->
		<cfset ParBEquiv = true>
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		<cfquery name="rsMovBancarios" datasource="sifinterfaces">
            select Id_MovimientoB, Ecodigo, Banco_Origen, Cuenta_Origen, Tipo_Operacion, Tipo_Movimiento, 
				Banco_Destino, Cuenta_Destino, Importe_Movimiento, Fecha_Movimiento, Referencia,
				Documento, Origen, sucursal
            from SIFLD_Movimientos_Bancarios
            where Estatus = 1
        </cfquery>
        
		<cfif isdefined("rsMovBancarios") and rsMovBancarios.recordcount GT 0>
		<cfloop query="rsMovBancarios">
		<cftry>
            <cfset MovBancario = rsMovBancarios.Id_MovimientoB>
            
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'CADENA', rsMovBancarios.Ecodigo, rsMovBancarios.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUempSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
		
			<!---OFICINA --->
			<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'SUCURSAL', rsMovBancarios.Ecodigo, rsMovBancarios.Sucursal, 'Sucursal')>
        	<cfset VarOficina = Equiv.EQUempSIF>
			
			<!--- CENTRO FUNCIONAL--->
			<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'CENTRO_FUN', rsMovBancarios.Ecodigo, rsMovBancarios.Sucursal, 'Centro_Funcional')>
			<cfset varCF = Equiv.EQUempSIF>
             
            <!--- Busca Moneda Local SIF ---> 
			<cfquery name="rsMoneda" datasource="#session.dsn#">
				select e.Ecodigo, e.Enombre,m.Miso4217
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
			
			<!--- Busca Tipo de Transaccion bancaria en Minisif --->
            <cfquery name="BuscaTipoTran" datasource="#session.dsn#">
            	select b.BTcodigo
              	from BTransacciones b
                inner join Parametros p
                on b.Ecodigo = p.Ecodigo and b.BTid = p.Pvalor
              	where p.Ecodigo = #getEcodigo(varEcodigo)# and Pcodigo = 160
            </cfquery>
            <cfif isdefined("BuscaTipoTran") and BuscaTipoTran.recordcount EQ 1>        
				<cfset TTranBO = #BuscaTipoTran.BTcodigo#>
			<cfelse>
				<cfthrow message="Error al Obtener la Transaccion Origen">
			</cfif>
 			<cfquery name="BuscaTipoTran" datasource="#session.dsn#">
            	select b.BTcodigo
              	from BTransacciones b
                inner join Parametros p
                on b.Ecodigo = p.Ecodigo and b.BTid = p.Pvalor
              	where p.Ecodigo = #getEcodigo(varEcodigo)# and Pcodigo = 170
            </cfquery>
            <cfif isdefined("BuscaTipoTran") and BuscaTipoTran.recordcount EQ 1>        
				<cfset TTranBD = #BuscaTipoTran.BTcodigo#>
			<cfelse>
				<cfthrow message="Error al Obtener la Transaccion Destino">
			</cfif>
			
            <!--- BUSCA EQUIVALENCIA DE CUENTA DEPOSITO PARA LA SUCURSAL EN CASO DE QUE NO EXISTA IRA POR LA 
			EQUIVALENCIA DE CUENTA DEPOSITO POR EMPRESA  --->
            <cfif rsMovBancarios.TipoMovimiento EQ "P">
				<cfset varCtaSuc = "CTA_PAGSUC">
				<cfset varCtaEmp = "CTA_PAGEMP">
			<cfelse>
				<cfset varCtaSuc = "CTA_BANSUC">
				<cfset varCtaEmp = "CTA_BANEMP">
			</cfif>
			
			<cftry>    
				<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, varCtaSuc, rsMovBancarios.Ecodigo, rsMovBancarios.Sucursal, 'Cuenta_Banco_Sucursal')>
            	<cfset varCtaBanco = Equiv.EQUempSIF>
            <cfcatch>
				<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, varCtaEmp, rsMovBancarios.Ecodigo, rsMovBancarios.Ecodigo, 'Cuenta_Banco_Empresa')>
				<cfset varCtaBanco = Equiv.EQUempSIF>	
			</cfcatch>
			</cftry>
			<cfif isdefined("varCtaBanco") and len(varCtaBanco) GT 0>
				<cfquery name="rsCta_Banco" datasource="#session.dsn#">
		           	select CBid, Bid from CuentasBancos
               		where CBid = #varCtaBanco#
                    	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
            	</cfquery>
				<cfset varCuentaB = rsCta_Banco.CBid>
	            <cfset varBanco = rsCta_Banco.Bid>
			<cfelse>
				<cfthrow message="Error Cuenta Bancaria No Existe">
			</cfif>
			
            <cfset RsMaximo = ExtraeMaximo("IE14","ID")>
            
            <cfif isdefined(#RsMaximo.Maximo#) or #RsMaximo.Maximo# gt 0>
        		<cfset Maximus = #RsMaximo.Maximo#>
			<cfelse>
	        	<cfset Maximus = 1>
			</cfif>
            
		    <!--- CUENTA CONTABLE PARA MOVIMIENTO  --->
			<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
				Oorigen="LDRT"
				Ecodigo="#varEcodigo#"  
				Conexion="#session.dsn#"
				LDOperacion="#rsMovBancarios.Tipo_Operacion#"
				LDDepartamento=""
				LDClasificacion=""
				LDFabricante=""
				LDTipoVenta=""
				SNegocios=""
				Impuestos=""
				Oficina="#varOficina#"		
				LDConceptoRetiroCaja=""
				Almacen=""
				Banco="#varBanco#"
				LDCuentaBanco="#varCuentaB#"
				LDMovimientoInven="">
			</cfinvoke>         			
			<cfset CuentaLDTM = Cuenta>  
        	
			<!--- Tipo Movimiento
			D = Deposito
			R = Retiro
			T = Transferencia
			P = Deposito por forma de Pago
			--->
			<cfif rsMovBancarios.Tipo_Movimiento EQ "D" OR rsMovBancarios.Tipo_Movimiento EQ "P">
				<cfquery name="rsInsertaIE14" datasource="sifinterfaces">
					insert into IE14 
						(ID, EcodigoSDC, CodigoBancoOrigen, CuentaBancariaOrigen, TipoMovimientoOrigen, 
						CodigoMonedaOrigen, MontoOrigen, MontoComision, CodigoBancoDestino, 
						CuentaBancariaDestino, TipoMovimientoDestino, CodigoMonedaDestino, MontoDestino, 
						FechaValor, Observacion, FechaAplicacion, NumeroDocumento, BMUsucodigo, 
						Estimacion, IndMovConta)
					values
					(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">, 
					 <cfif ParBEquiv>
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#varBanco#">,
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaB#">,
					 <cfelse>
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Banco_Origen#">,
					 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Cuenta_Origen#">,
					 </cfif>
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#TTranBO#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="varMoneda">,
					 <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,
					 0, 
					 null,null, null, null, null, 
					 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsMovBancarios.Fecha_Movimiento,'short')#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Referencia#">, 
					 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsMovBancarios.Fecha_Movimiento,'short')#">, 
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Documento#">, 1, 0, 1)
				</cfquery>
			<cfelseif rsMovBancarios.Tipo_Movimiento EQ "T">
				
			</cfif>
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
        	<cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete	SIFLD_Movimientos_Bancarios where ID_MovimientoB = #MovBancario#
				<cfelse>
					update SIFLD_Movimientos_Bancarios  
					set Estatus = 2
					where ID_MovimientoB = #MovBancario# 
				</cfif>
        	</cfquery>    

			<!--- Proceso de Carga Cola Interfaz SIF --->   
			<!---
			<cfset disparaInterfaz(14, #Maximus#, #varEcodigo#,0)> --->
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
				update SIFLD_Movimientos_Bancarios  
				set Estatus = 3
				where ID_MovimientoB = #MovBancario#
			</cfquery>

			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif isdefined("Maximus")>
				<cfquery datasource="sifinterfaces">
					delete ID14
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					delete IE14
					where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
				</cfquery>
				<cfquery datasource="sifinterfaces">
					update IdProceso
					set Consecutivo = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#"> - 1
				</cfquery>
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
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErroDet, MsgErrorSQL, MsgErrorParam)
				values 
				('CG_MovBancarios',
				 'SIFLD_Movimientos_Bancarios', 
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#MovBancario#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">) 
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Retiros --->
		</cfif>
	</cffunction>
</cfcomponent>