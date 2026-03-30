<!--- ABG: Transformacion Operaciones Bancarias Interfaz LD-SIF Ver. 1.0 --->
<!--- La interfaz de Operaciones Bancarias, procesa todos los Retiros Con Deposito  Bancos --->
<!--- La Interfaz LD-SIF solo funciona con versiones de Coldfusion 8.0 en adelante --->

<!---
<!--- Parametro para usar equivalencia de Bancos en Depositos--->
	<cfset ParBEquiv = true>
<!--- Rutina para Obtener Parametros a Ocupar --->
<!--- Equivalencia Oficina --->
	<cfset ParOfic = false>
<!--- Equivalencia Centro Funcional --->
	<cfset ParCF = false>
<!--- Crear un Parametro Ver 2.0 --->
	<cfset ParBorrado = false>
--->

<cfcomponent extends="Interfaz_Base">
    <cffunction name="Ejecuta" access="public" returntype="string" output="yes">
    	<cfargument name="Disparo" required="no" type="boolean" default="false"> <!---ABG--->
		
        <!---Invocar al GC para liberar memoria---> <!---ABG--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()><!--- invoca el GC --->
        
        <cfquery datasource="sifinterfaces" result="Rupdate">
            update top (300) SIFLD_Movimientos_Bancarios
			set Estatus = 10
            where 
            <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                Estatus = 1
                and not exists (select 1 from SIFLD_Movimientos_Bancarios where Estatus in (10, 11,94,92,99,100))
            <cfelse>
            	Estatus = 99
                and not exists (select 1 from SIFLD_Movimientos_Bancarios where Estatus in (10, 11))
            </cfif>
        </cfquery>
		<cfquery name="rsIDMovBancarios" datasource="sifinterfaces">
            select ID_MovimientoB
            from SIFLD_Movimientos_Bancarios
            where Estatus = 10
            <cfif Rupdate.recordcount EQ 0>
            	and 1 = 2
            </cfif>
        </cfquery>

		<cfif isdefined("rsIDMovBancarios") and rsIDMovBancarios.recordcount GT 0>
		<cfloop query="rsIDMovBancarios">
		<cftry>
        	<cfset varBorraRegistro = false>
            <cfset varBorraDetalle = false>
            <cfset Maximus = 0>
        	<cfquery name="rsMovBancarios" datasource="sifinterfaces">
                select ID_MovimientoB, Ecodigo, Banco_Origen, Cuenta_Origen, Tipo_Operacion, Tipo_Movimiento, 
                    Banco_Destino, Cuenta_Destino, Importe_Movimiento, Fecha_Movimiento, Referencia,
                    Documento, Origen, Sucursal, Moneda, Tipo_Cambio, Concepto
                from SIFLD_Movimientos_Bancarios
                where ID_MovimientoB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDMovBancarios.ID_MovimientoB#">
            </cfquery>
			<cfset MovBancario = rsMovBancarios.ID_MovimientoB>
            
            <cfquery datasource="sifinterfaces">
                update SIFLD_Movimientos_Bancarios
                set Fecha_Inicio_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                where ID_MovimientoB = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MovBancario#">
            </cfquery>
            
			<!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'CADENA', rsMovBancarios.Ecodigo, rsMovBancarios.Ecodigo, 'Cadena')>
			<cfset varEcodigo = Equiv.EQUidSIF>
			<cfset varEcodigoSDC = Equiv.EQUcodigoSIF>
			<cfset session.dsn = getConexion(varEcodigo)>
			<cfset varCEcodigo = getCEcodigo(varEcodigo)>
            
            <!--- MONEDA --->
            <cfif rsMovBancarios.Moneda NEQ "" and len(rsMovBancarios.Moneda) GT 0>
				<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'MONEDA', rsMovBancarios.Ecodigo, rsMovBancarios.Moneda, 'Moneda')>
                <cfset varMoneda = Equiv.EQUcodigoSIF>
            <cfelse>
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
            </cfif>
            
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
            
            <!--- Agrupamiento --->
            <cfset ParAgrupa = Parametros(Ecodigo=varEcodigo,Pcodigo=9,Parametro="Agrupa Documentos",ExtBusqueda=true, Sistema = rsMovBancarios.Origen)>
            
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select ID 
				from SIFLD_IE920
				where EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">
				and Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsMovBancarios.Documento)#">
                and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">
			</cfquery>	
            
            <cfif rsVerificaE.recordcount GT 0 and ParAgrupa>
	            <cfset Maximus = rsVerificaE.ID>
            <cfelse>
				<cfset RsMaximo = ExtraeMaximo("IE920","ID")>
                <cfif isdefined("RsMaximo.Maximo") AND RsMaximo.Maximo gt 0>
                    <cfset Maximus = RsMaximo.Maximo>
                <cfelse>
                    <cfset Maximus = 1>
                </cfif>
                <cfset varBorraRegistro = true>
            </cfif>
            
			<!--- Obtiene los parametros --->
            <cfset ParOfic = Parametros(Ecodigo=varEcodigo,Pcodigo=1,Sucursal=rsMovBancarios.Sucursal,Parametro="Equivalencia Oficina",ExtBusqueda=true, Sistema = rsMovBancarios.Origen)>
            
            <!--- Equivalencia Centro Funcional --->
            <cfset ParCF = Parametros(Ecodigo=varEcodigo,Pcodigo=2,Sucursal=rsMovBancarios.Sucursal,Parametro="Equivalencia Centro Funcional",ExtBusqueda=true, Sistema = rsMovBancarios.Origen)>
            
			<!--- Borrar Registro --->
            <cfset ParBorrado = Parametros(Ecodigo=varEcodigo,Pcodigo=4,Sucursal=rsMovBancarios.Sucursal,Parametro="Borrar Registros",ExtBusqueda=true, Sistema = rsMovBancarios.Origen)>
            
            <!--- Equivalencia Banco --->
            <cfset ParBEquiv = Parametros(Ecodigo=varEcodigo,Pcodigo=11,Sucursal=rsMovBancarios.Sucursal,Parametro="Equivalencia Banco",ExtBusqueda=true, Sistema = rsMovBancarios.Origen)>
            
            <!--- Obtiene el usuario de Interfaz --->
	        <cfset Usuario = UInterfaz (getCEcodigo(varEcodigo))>
			<cfset varUlogin = Usuario.Usulogin>
            <cfset varUcodigo = Usuario.Usucodigo>
            
			<cfif ParOfic>
				<!---OFICINA --->
                <cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'SUCURSAL', rsMovBancarios.Ecodigo, rsMovBancarios.Sucursal, 'Sucursal')>
                <cfset VarOcodigo = Equiv.EQUidSIF>
				<cfset VarOficina = Equiv.EQUcodigoSIF>
             <cfelse>
            	 <cfset VarOficina = rsMovBancarios.Sucursal>
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
                <cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, 'CENTRO_FUN', rsMovBancarios.Ecodigo, rsMovBancarios.Sucursal, 'Centro_Funcional')>
                <cfset varidCF = Equiv.EQUidSIF>
				<cfset varCF = Equiv.EQUcodigoSIF>
            <cfelse>
           		<cfset varCF = rsMovBancarios.Sucursal>
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
            
            <!--- Busca Tipo de Transaccion bancaria en Minisif --->
            <cfquery name="BuscaTipoTran" datasource="#session.dsn#">
            	select b.BTcodigo
              	from BTransacciones b
                inner join Parametros p
                on b.Ecodigo = p.Ecodigo and b.BTid = p.Pvalor
              	where p.Ecodigo = #varEcodigo# and Pcodigo = 160
            </cfquery>
            <cfif isdefined("BuscaTipoTran") and BuscaTipoTran.recordcount EQ 1>        
				<cfset TTranBD = #BuscaTipoTran.BTcodigo#> <!--- Transaccion para Retiros --->
			<cfelse>
				<cfthrow message="Error al Obtener la Transaccion Origen">
			</cfif>
 			<cfquery name="BuscaTipoTran" datasource="#session.dsn#">
            	select b.BTcodigo
              	from BTransacciones b
                inner join Parametros p
                on b.Ecodigo = p.Ecodigo and b.BTid = p.Pvalor
              	where p.Ecodigo = #varEcodigo# and Pcodigo = 170
            </cfquery>
            <cfif isdefined("BuscaTipoTran") and BuscaTipoTran.recordcount EQ 1>        
				<cfset TTranBO = #BuscaTipoTran.BTcodigo#> <!--- Transaccion para Depositos --->
			<cfelse>
				<cfthrow message="Error al Obtener la Transaccion Destino">
			</cfif>
			
            <!--- BUSCA EQUIVALENCIA DE CUENTA DEPOSITO PARA LA SUCURSAL EN CASO DE QUE NO EXISTA IRA POR LA 
			EQUIVALENCIA DE CUENTA DEPOSITO POR EMPRESA  --->
            <cfif rsMovBancarios.Tipo_Movimiento EQ "P">
				<cfset varParametro = 14>
                <cfset varCuentaDef = "Pago">
                <cfset varDesDet = "Deposito por Forma Pago">
			<cfelse>
				<cfset varParametro = 13>
                <cfset varCuentaDef = "Deposito">
                <cfset varDesDet = "Deposito de Tombola">
			</cfif>
			
			<!---<cftry>    
				<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, varCtaSuc, rsMovBancarios.Ecodigo, rsMovBancarios.Sucursal, 'Cuenta_Banco_Sucursal')>
            	<cfset varCtaBanco = Equiv.EQUcodigoSIF>
            <cfcatch>
				<cfset Equiv = ConversionEquivalencia (rsMovBancarios.Origen, varCtaEmp, rsMovBancarios.Ecodigo, rsMovBancarios.Ecodigo, 'Cuenta_Banco_Empresa')>
				<cfset varCtaBanco = Equiv.EQUcodigoSIF>	
			</cfcatch>
			</cftry> 
            
			<cfif isdefined("varCtaBanco") and len(varCtaBanco) GT 0>
				<cfquery name="rsCta_Banco" datasource="#session.dsn#">
		           	select CBid, Bid from CuentasBancos
               		where CBid = #varCtaBanco#
            	</cfquery>
				<cfset varCuentaB = rsCta_Banco.CBid>
	            <cfset varBanco = rsCta_Banco.Bid>
			<cfelse>
				<cfthrow message="Error Cuenta Bancaria No Existe">
			</cfif> --->
            
            <cfset varCtaBanco=Parametros(Ecodigo=varEcodigo,Pcodigo=varParametro,Sucursal=rsMovBancarios.Sucursal,Criterio=varMoneda,Parametro="Cuenta para #varCuentaDef#",ExtBusqueda=true, Sistema = rsMovBancarios.Origen)>
            <cfif isdefined("varCtaBanco") and len(varCtaBanco) GT 0>
				<cfquery name="rsCta_Banco" datasource="#session.dsn#">
		           	select CBcodigo, Iaba 
                    from CuentasBancos c 
					inner join Bancos b 
					on c.Ecodigo = b.Ecodigo
					and c.Bid = b.Bid 
               		where c.CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCtaBanco#">
                    and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigo#">
            	</cfquery>
				<cfset varCuentaB = rsCta_Banco.CBcodigo>
	            <cfset varBanco = rsCta_Banco.Iaba>
			<cfelse>
				<cfthrow message="Error Cuenta Bancaria #varCtaBanco# No Existe en la empresa #varEcodigo#">
			</cfif>
            
            <cfif not isdefined("varCuentaB") OR len(varCuentaB) LT 1 OR not isdefined("varBanco") OR len(varBanco) LT 1>
            	<cfthrow message="Error al obtener la Cuenta Bancaria o el Banco para la Cuenta Bancaria #varCtaBanco# ">
            </cfif>
            
		    <!--- CUENTA CONTABLE PARA MOVIMIENTO  --->
			<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
				Oorigen="LDRT"
                Ecodigo="#varEcodigo#"  
                Conexion="#session.dsn#"
                LDOperacion="#rsMovBancarios.Tipo_Operacion#"
                LDDepartamento="NOUSAR"
                LDClasificacion="NOUSAR"
                LDFabricante="NOUSAR"
                LDTipoVenta="NOUSAR"
                SNegocios="NOUSAR"
                Impuestos="NOUSAR"
                Oficinas="#VarOcodigo#"		
                LDConceptoRetiroCaja="NOUSAR"
                Almacen="NOUSAR"
                Bancos="#varBanco#"
                LDCuentaBanco="#varCtaBanco#"
                LDMovimientoInventario="NOUSAR"
                LDAlmacen="NOUSAR"
                LDTipoRetiroCaja="NOUSAR">
			</cfinvoke>         			
			<cfset CuentaLDTM = Cuenta>  
        	
			<!--- Tipo Movimiento
			D = Deposito
			R = Retiro
			T = Transferencia
			P = Deposito por forma de Pago
			--->
			<cfif rsMovBancarios.Tipo_Movimiento EQ "D" OR rsMovBancarios.Tipo_Movimiento EQ "P">
				<cfif rsVerificaE.recordcount EQ 1 and ParAgrupa>
                    <!--- Verifica si debe insertar un Detalle --->
                    <cfquery name="rsVerificaD" datasource="sifinterfaces">
                    	select isnull(max(ID_Linea),0) as ID_Linea
                        from SIFLD_ID920
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                        and Concepto_Mov = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Concepto#">
                    </cfquery>
                    <cfif rsVerificaD.recordcount EQ 1 and rsVerificaD.ID_Linea NEQ 0>
                    	<cfquery datasource="sifinterfaces">
                            update SIFLD_ID920
                            set Importe_Mov = round(Importe_Mov +  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,2)
                            where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                            and ID_Linea = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsVerificaD.ID_Linea#">
                        </cfquery>
                    <cfelse>
                    	<cfquery name="rsVerificaD" datasource="sifinterfaces">
                            select isnull(max(ID_Linea),0) + 1 as ID_Linea
                            from SIFLD_ID920
                            where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                        </cfquery>
                    	<cfquery datasource="sifinterfaces">
                            insert into SIFLD_ID920(ID, ID_Linea, Descripcion_Mov_Det, Concepto_Mov, Importe_Mov)
                            values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                            	<cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsVerificaD.ID_Linea#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDesDet#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Concepto#">,
                                round(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,2))
                        </cfquery>
                        <cfset varBorraDetalle = true>
                        <cfset varIDLinea = rsVerificaD.ID_Linea>
                    </cfif>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_IE920
                        set Importe_Total_Mov = round(Importe_Total_Mov +  <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,2)
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
				<cfelse>
                    <cfquery datasource="sifinterfaces">
                        insert into SIFLD_IE920 
                            (ID, EcodigoSDC, Origen, Tipo_Operacion, Tipo_Movimiento,
                            Documento, Referencia, Descripcion_Mov, Importe_Total_Mov, 
                            Banco_Destino, Cuenta_Destino, Moneda, Tipo_Cambio, Fecha_Mov, 
                            Estatus, CEcodigo, Usulogin, Usucodigo)
                        values
                        (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#varEcodigoSDC#">, 
                         'LDCOM', 
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#TTranBO#">,
                         'D', <!---Deposito--->
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Documento#">, 
                         null,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Referencia#">, 
                         <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,
                         <cfif isdefined("varBanco") and len(varBanco) GT 0>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#varBanco#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCuentaB#">,
                         <cfelse>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Banco_Origen#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Cuenta_Origen#">,
                         </cfif>
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varMoneda#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Tipo_Cambio#">,
                         <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsMovBancarios.Fecha_Movimiento,"yyyy/mm/dd")#">, 
                         1,
                         <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varUlogin#">,
		                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#varUcodigo#">)
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into SIFLD_ID920(ID, ID_Linea, Descripcion_Mov_Det, Concepto_Mov, Importe_Mov)
                        values 
                        	(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
                             1,
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDesDet#">, 
                             <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsMovBancarios.Concepto#">,
                             round(<cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,2))
                    </cfquery>
                </cfif>
			<cfelseif rsMovBancarios.Tipo_Movimiento EQ "T">
				
			</cfif>
			
			<!--- Marca o Borra las Tablas Origen Registro Procesado --->
			<!--- BORRADO DE TABLAS ORIGEN --->  
            <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
        	<cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete	SIFLD_Movimientos_Bancarios where ID_MovimientoB = #MovBancario#
				<cfelse>
					update SIFLD_Movimientos_Bancarios  
					set Estatus = 92,
					ID920 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
                    Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#,
                    Periodo = #Periodo#,
                    Mes = #Mes#
					where ID_MovimientoB = #MovBancario# 
				</cfif>
        	</cfquery> 
		<cfcatch type="any"> <!---Error en Retiros --->
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update SIFLD_Movimientos_Bancarios  
				set Estatus = 3,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_MovimientoB = #MovBancario#
			</cfquery>

			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif varBorraRegistro>
            	<cfif isdefined("Maximus") and Maximus NEQ 0>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_ID920
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        delete SIFLD_IE920
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>
                </cfif>
			<cfelse>
            	<cfif isdefined("Maximus") and Maximus NEQ 0>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_IE920
                        set Importe_Total_Mov = round(Importe_Total_Mov - <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,2)
                        where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                    </cfquery>	
                    <cfif varBorraDetalle>
                        <cfquery datasource="sifinterfaces">
                            delete SIFLD_ID920
                            where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                            and ID_Linea = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varIDLinea#">
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="sifinterfaces">
                            update SIFLD_ID920
                            set Importe_Mov = round(Importe_Mov - <cfqueryparam cfsqltype="cf_sql_money" value="#numberformat(rsMovBancarios.Importe_Movimiento,'9.99')#">,2)
                            where ID = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">
                            and ID_Linea = <cfqueryparam cfsqltype ="cf_sql_numeric" value="#rsVerificaD.ID_Linea#">
                        </cfquery>
                    </cfif>
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
				insert into SIFLD_Errores 
				(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo)
				values 
				('CG_MovBancarios',
				 'SIFLD_Movimientos_Bancarios', 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#MovBancario#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMovBancarios.Ecodigo#">) 
			</cfquery>
		</cfcatch>
		</cftry>
		</cfloop> <!--- Encabezados Retiros --->
			<!--- Dispara Interfaz --->
            <cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from SIFLD_Movimientos_Bancarios
                where Estatus in (99,10)
            </cfquery>
            <cfif rsVerifica.Registros LT 1>
        		<!---Se Dispara la Interfaz de forma Masiva--->
                <cftransaction action="begin">
                <cftry>
                	<!---Prepara los registros para ser insertados--->
                    <cfquery datasource="sifinterfaces">
                    	update SIFLD_IE920
                        	set Interfaz = 'CG_MovBancarios', Estatus = 1
                        where ID in (select ID920
                        			 from SIFLD_Movimientos_Bancarios
                                     where Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into IE920
                            (ID, EcodigoSDC, Origen, Tipo_Operacion, Tipo_Movimiento,
                            Documento, Referencia, Descripcion_Mov, Importe_Total_Mov, 
                            Banco_Destino, Cuenta_Destino, Moneda, Tipo_Cambio, Fecha_Mov, 
                            Estatus)
                         select a.ID, a.EcodigoSDC, a.Origen, a.Tipo_Operacion, a.Tipo_Movimiento,
                            a.Documento, a.Referencia, a.Descripcion_Mov, a.Importe_Total_Mov, 
                            a.Banco_Destino, a.Cuenta_Destino, a.Moneda, a.Tipo_Cambio, a.Fecha_Mov, 
                            a.Estatus
                         from SIFLD_IE920 a 
                         where Interfaz = 'CG_MovBancarios' and Estatus = 1
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        insert into ID920 
                                (ID, ID_Linea, Descripcion_Mov_Det, Concepto_Mov, Importe_Mov)
                        select ID, ID_Linea, Descripcion_Mov_Det, Concepto_Mov, Importe_Mov
                        from SIFLD_ID920 a 
                        where exists (select 1 
                                  from SIFLD_IE920 b
                                  where a.ID = b.ID and b.Interfaz = 'CG_MovBancarios' and b.Estatus = 1)
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos (
                            CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                            EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                            FechaInclusion, Cancelar, UsucodigoInclusion, UsuarioBdInclusion)
                        select
                          a.CEcodigo,
                          920,
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
                        from SIFLD_IE920 a 
                        where Interfaz = 'CG_MovBancarios' and Estatus = 1
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Movimientos_Bancarios
                            set Estatus = 2
                        where Estatus in (92)
                        and ID920 in (select ID from SIFLD_IE920
                        				where Interfaz = 'CG_MovBancarios' and Estatus = 1)
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
                        (Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, 
                        MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
                        select 'CG_MovBancarios', 'SIFLD_Movimientos_Bancarios', ID_MovimientoB,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            Usuario
                        from SIFLD_Movimientos_Bancarios
                        where Estatus in (92)  
                        and ID920 in (select ID from SIFLD_IE920
                        				where Interfaz = 'CG_MovBancarios' and Estatus = 1)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Movimientos_Bancarios set Estatus = 3
                        where Estatus in (92) 
                        and ID920 in (select ID from SIFLD_IE920
                        				where Interfaz = 'CG_MovBancarios' and Estatus = 1)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction>
                
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID920
                    where ID in (select ID920 from SIFLD_Movimientos_Bancarios where Estatus in (2,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE920
                    where ID in (select ID920 from SIFLD_Movimientos_Bancarios where Estatus in (2,3))
                </cfquery>
            </cfif>
        
		</cfif>
	</cffunction>
</cfcomponent>