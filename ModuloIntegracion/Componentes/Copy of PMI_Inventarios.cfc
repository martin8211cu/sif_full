<!--- PMI: Integración Inventarios PMI --->
<!--- Polizas de los movimientos de Inventarios--->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró:Maria de los Angeles Blanco López 04 de Noviembre del 2009--->


<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="no">
    	<cfargument name="Disparo" required="no" type="boolean" default="false">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		
		<!---Invocar al GC para liberar memoria--->
        <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
        <cfset javaRT.gc()><!--- invoca el GC --->
        
        <!---Actualiza los registros a Estatus en Proceso--->
		<cfif Application.dsinfo.sifinterfaces.type EQ "sybase">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top 50 ESIFLD_Movimientos_Inventario 
                set Estatus = 10 
                where 
                <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 1 
                    and not exists (select 1 from ESIFLD_Movimientos_Inventario where Estatus in (10, 11,94,92,99,100))
                <cfelse>
                    Estatus = 99
                    and not exists (select 1 from ESIFLD_Movimientos_Inventario where Estatus in (10, 11))
                </cfif>
                and Tipo_Movimiento in ('EP', 'SF', 'SV', 'TO', 'TR', 'IC', 'CM', 'AL')
			</cfquery>
		<cfelseif Application.dsinfo.sifinterfaces.type EQ "sqlserver">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top (50) ESIFLD_Movimientos_Inventario 
                set Estatus = 10 
                where 
                <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 1 
                    and not exists (select 1 from ESIFLD_Movimientos_Inventario where Estatus in (10, 11,94,92,99,100))
                <cfelse>
                    Estatus = 99
                    and not exists (select 1 from ESIFLD_Movimientos_Inventario where Estatus in (10, 11))
                </cfif>
                and Tipo_Movimiento in ('EP', 'SF', 'SV', 'TO', 'TR', 'IC', 'CM', 'AL')
			</cfquery>
        <cfelseif Application.dsinfo.sifinterfaces.type EQ "oracle">
			<cfthrow message="Base de datos #Application.dsinfo.sifinterfaces.type# no implementada">
        <cfelse>
        	<cfthrow message="Base de datos no reconocida">
		</cfif>
		
		<!--- toma registros cabecera de las Inventarios¬ --->
		<cfquery name="rsIDEInventarios" datasource="sifinterfaces">
			select ID_Movimiento
			from ESIFLD_Movimientos_Inventario
			where 
		    Estatus = 10 
			and Tipo_Movimiento in ('EP', 'SF', 'SV', 'TO', 'TR', 'IC', 'CM', 'AL')
            <cfif Rupdate.recordcount EQ 0>
	            and 1 = 2
            </cfif> 
		</cfquery>
		
		<cfif isdefined("rsIDEInventarios") AND rsIDEInventarios.recordcount GT 0>
        <cfloop query="rsIDEInventarios">
        <cfsilent>
		<cftry>
			<!--- toma registros cabecera de las Inventarios¬ --->
            <cfquery name="rsEInventarios" datasource="sifinterfaces">
                select Ecodigo, Origen, ID_Movimiento, Tipo_Movimiento, Fecha_Movimiento, Documento, 
                Descripcion, Almacen_Origen,
                Almacen_Destino, Tipo_Ajuste, Sucursal_Origen, Sucursal_Destino, Moneda, Tipo_Cambio, Afecta_Costo, Usuario
                from ESIFLD_Movimientos_Inventario
                where 
                	ID_Movimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDEInventarios.ID_Movimiento#">
            </cfquery>
			<cfset Movimiento = rsEInventarios.ID_Movimiento>
			
            <!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset varEcodigo = ConversionEquivalencia (rsEInventarios.Origen, 'CADENA', rsEInventarios.Ecodigo, rsEInventarios.Ecodigo, 'Cadena')>
            
			<cfset varBorraRegistro = false>
			<!---Validar que no exista mas de una linea de negocio--->
			<cfif rsEInventarios.Tipo_Movimiento EQ 'CM'>
				<cfquery name="rsValidaLinea" datasource="sifinterfaces">
					select distinct Tipo_Item
					from DSIFLD_Movimientos_Inventario e
					where ID_Movimiento = #Movimiento#
				</cfquery> 
			
				<cfif isdefined("rsValidaLinea") and rsValidaLinea.recordcount EQ 1>
				<cfset LineaNegocio = rsValidaLinea.Tipo_Item>
				<cfelseif isdefined("rsValidaLinea") and rsValidaLinea.recordcount GTE 2>
					<cfthrow message="Error al agrupar la poliza de Costo de Mercado, existe mas de una linea de negocio 								                	para el registro #rsEInventarios.Almacen_Destino#">
				<cfelseif isdefined("rsValidaLinea") and rsValidaLinea.recordcount EQ 0> 
					<cfthrow message="Error el registro #rsEInventarios.Almacen_Destino# no tiene asignado una valor para la 						                    Linea de Negocio">
				</cfif>	
				
			</cfif>
			
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select  ID, Ecodigo, EcodigoSDC, Empresa, Fecha_Movimiento,
					  Almacen_Origen, Almacen_Destino, Tipo_Movimiento,
					  Tipo_Item, Usuario
				from SIFLD_IE18 
				where 
				<cfswitch expression="#rsEInventarios.Tipo_Movimiento#">
							<cfcase value="EP"> 
								Tipo_Movimiento like 'EP' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and Almacen_Destino = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">
							</cfcase>
							<cfcase value="SF">
								Tipo_Movimiento like 'SF' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and Almacen_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">
								and convert (datetime, Fecha_Movimiento, 103) = <cfqueryparam cfsqltype="cf_sql_date" value="#rsEInventarios.Fecha_Movimiento#">
							</cfcase>
							<cfcase value="SV"> 
								Tipo_Movimiento like 'SV' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and convert (datetime, Fecha_Movimiento, 103) = <cfqueryparam cfsqltype="cf_sql_date" 
								value="#rsEInventarios.Fecha_Movimiento#">
							</cfcase>
							<cfcase value="TO">
 								Tipo_Movimiento like 'TO' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and Almacen_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">
							</cfcase>
							<cfcase value="IC"> 
								Tipo_Movimiento like 'IC' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and	Almacen_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">
							</cfcase>
							<cfcase value="CM">
								Tipo_Movimiento like 'CM' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and Tipo_Item = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LineaNegocio#">
							</cfcase>
							<cfcase value="TR"> 
								Tipo_Movimiento like 'TR' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
							</cfcase>
							<cfcase value="AL">
								Tipo_Movimiento like 'AL' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEInventarios.Ecodigo#">
                                and convert (datetime, Fecha_Movimiento, 103) = <cfqueryparam cfsqltype="cf_sql_date" value="#rsEInventarios.Fecha_Movimiento#">
							</cfcase> 
						</cfswitch>
                        and Usuario like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEInventarios.Usuario)#">
			</cfquery>
					
			 <cfif rsVerificaE.recordcount EQ 0>	
                    <!--- Extrae Maximo+1 de tabla IE18 para insertar nuevo reg, en IE18 ---> 
                    <cfset RsMaximo = ExtraeMaximo("IE18","ID")> 
                    <cfif isdefined("RsMaximo.Maximo") And RsMaximo.Maximo GT 0>
                        <cfset Maximus = RsMaximo.Maximo>
                    <cfelse>
                        <cfset Maximus = 1>
                    </cfif>      
                    <cfset varBorraRegistro = true>
                    <cfset IDlinea = 1>	
            <cfelse>
                    <cfset Maximus = rsVerificaE.ID>
                    <cfquery name="rsLinea" datasource="sifinterfaces">
                        select isnull(max(DCIconsecutivo),0) + 1 as Linea
                        from SIFLD_ID18
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
                        and ID = <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsVerificaE.ID#">
                    </cfquery>
                    <cfset IDlinea = rsLinea.Linea>
                    <cfset IDStart = rsLinea.Linea - 1>
            </cfif>     
			
			<cfset session.dsn = getConexion(varEcodigo.EQUidSIF)>			
			<cfset varCEcodigo = getCEcodigo(varEcodigo.EQUidSIF)>
			
			<!---Usuario --->
			<cfset UsuInterfaz = UInterfaz(getCEcodigo(varEcodigo.EQUidSIF), rsEInventarios.Usuario)>	
			
			<!---OFICINAS ORIGEN Y DESTINO --->
			<cfset VarOficinaO =ConversionEquivalencia (rsEInventarios.Origen, 'SUCURSAL', rsEInventarios.Ecodigo, 
			rsEInventarios.Sucursal_Origen,'Sucursal')>
			
            <cfset VarOficinaD = ConversionEquivalencia (rsEInventarios.Origen, 'SUCURSAL', rsEInventarios.Ecodigo, 
			rsEInventarios.Sucursal_Destino,'Sucursal')>
			
			 <!--- MONEDA --->
			<cfset varMoneda = ConversionEquivalencia (rsEInventarios.Origen, 'MONEDA', rsEInventarios.Ecodigo, rsEInventarios.Moneda, 
			'Moneda')>
			
			<!--- Busca Moneda Local SIF ---> 
			<cfquery name="rsMonedaL" datasource="#session.dsn#">
				select e.Ecodigo, m.Mnombre, m.Miso4217, e.Edescripcion
				from Monedas m
					inner join Empresas e
					on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
				where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varEcodigo.EQUidSIF#"> 
			</cfquery>
			<cfif isdefined("rsMonedaL") and rsMonedaL.recordcount EQ 1>
				<cfset varMonedaL = rsMonedaL.Miso4217>
			<cfelse>
				<cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsEInventarios.Ecodigo#">
			</cfif>	
			
			<!--- Busca Periodo en Minisif --->
			<cfquery name="BuscaPeriodo" datasource="#session.dsn#">
				SELECT Pvalor FROM Parametros WHERE Ecodigo = #varEcodigo.EQUidSIF# AND Pcodigo = 50
			</cfquery>
			<cfset Periodo = #BuscaPeriodo.Pvalor#>
			
			<!--- Busca Mes en Minisif --->
			<cfquery name="BuscaMes" datasource="#session.dsn#">
				SELECT Pvalor FROM Parametros WHERE Ecodigo = #varEcodigo.EQUidSIF# AND Pcodigo = 60
			</cfquery>
			<cfset Mes = #BuscaMes.Pvalor#>
			
			<!--- CENTROS FUNCIONALES ORIGEN Y DESTINO--->
			<cfset varCFO = ConversionEquivalencia (rsEInventarios.Origen, 'CENTRO_FUN', rsEInventarios.Ecodigo, 
			rsEInventarios.Sucursal_Origen, 'Centro_Funcional')>
			
			<cfset varCFD = ConversionEquivalencia (rsEInventarios.Origen, 'CENTRO_FUN', rsEInventarios.Ecodigo, 
			rsEInventarios.Sucursal_Destino, 'Centro_Funcional')>
			
			<!---Tipo cambio para la moneda origen --->
			<cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
				<cfset varTipoCambio = ExtraeTipoCambio(varMoneda.EQUcodigoSIF,varEcodigo.EQUidSIF,rsEInventarios.Fecha_Movimiento)>
			<cfelse>
				<cfset varTipoCambio = 1>
			</cfif> 
			
			 <cfif rsVerificaE.recordcount EQ 0>
				 <cfquery datasource="sifinterfaces">
				 insert into SIFLD_IE18
						(ID, 
						Ecodigo, 
						Cconcepto, 
						Eperiodo, 
						Emes, 
						Efecha,
						Edescripcion, 
						Edocbase, 
						Ereferencia, 
						Falta, 
						Usuario,
						ECIreversible,
                        EcodigoSDC,
                        Empresa,
                        CEcodigo,
                        Usulogin,
                        Usucodigo,
                        Fecha_Movimiento,
                        Almacen_Origen,
                        Almacen_Destino,
                        Tipo_Movimiento,
                        Tipo_Item
                        )
				 values(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					    <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 	
						11,
						<cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
						<cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
     					<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
						<cfswitch expression="#rsEInventarios.Tipo_Movimiento#">
							<cfcase value="EP"> 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							</cfcase>
								<cfcase value="SF">
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							</cfcase>
							<cfcase value="SV"> 
								'Transito Clientes #dateformat(rsEInventarios.Fecha_Movimiento,"mm-dd-yyyy")#',
								'Transito Clientes',
							</cfcase>
							<cfcase value="TO">
								<cfqueryparam cfsqltype="cf_sql_varchar" 
								value="#rsEInventarios.Almacen_Origen##rsEInventarios.Almacen_Destino#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" 
								value="#rsEInventarios.Almacen_Origen##rsEInventarios.Almacen_Destino#">,
							</cfcase>
							<cfcase value="IC"> 
								'Inventario en custodia #rsEInventarios.Almacen_Destino# 		                                 #dateformat(rsEInventarios.Fecha_Movimiento,"mm-dd-yyyy")#',
								'Inventario en Custodia',
							</cfcase>
							<cfcase value="CM">
								'Reserva Baja de Valor Inventarios #dateformat(rsEInventarios.Fecha_Movimiento,"mm-dd-yyyy")#',
								'BV INV',
							</cfcase>
							<cfcase value="TR"> 
								'#rsEInventarios.Almacen_Destino# #dateformat(rsEInventarios.Fecha_Movimiento,"mm-dd-yyyy")#',
								'CV/Tránsito',
							</cfcase>
							<cfcase value="AL">
								'Alijos de la fecha #dateformat(rsEInventarios.Fecha_Movimiento,"mm-dd-yyyy")# 
								#rsEInventarios.Almacen_Origen#/#rsEInventarios.Almacen_Destino#',
							<cfqueryparam cfsqltype="cf_sql_varchar" 
							value="#rsEInventarios.Almacen_Origen#/#rsEInventarios.Almacen_Destino#">,
							</cfcase>
						</cfswitch>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#month(rsEInventarios.Fecha_Movimiento)#">, 
						getdate(),
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
						<cfif rsEInventarios.Tipo_Movimiento EQ 'EP' or rsEInventarios.Tipo_Movimiento EQ 'SF' or 
						rsEInventarios.Tipo_Movimiento EQ 'TO' or rsEInventarios.Tipo_Movimiento EQ 'AL'>
							0,
						<cfelse>
							1,
						</cfif>
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUcodigoSIF#">, 
                        <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsEInventarios.Ecodigo#">, 	
                        <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#UsuInterfaz.Usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Tipo_Movimiento#">,
                        <cfif isdefined("LineaNegocio") and LineaNegocio NEQ "">
                           <cfqueryparam cfsqltype="cf_sql_varchar" value="#LineaNegocio#">
                        <cfelse>
                            ''
                        </cfif>)
				 </cfquery>
 		  </cfif>
            
			<!--- Seleccion de Detalles --->
			<cfquery name="rsDInventarios" datasource="sifinterfaces">
				select Ecodigo, ID_linea, Tipo_Item, Clas_Item, Cod_Item, Cantidad,
				       isnull(Costo, 0) as Costo
				from DSIFLD_Movimientos_Inventario
				where ID_Movimiento = #Movimiento#
			</cfquery>
			<cfif isdefined("rsDInventarios") and rsDInventarios.recordcount GT 0>
			<cfloop query="rsDInventarios">
            <cfsilent>
				<!---Monto por linea --->
				<cfset MontoLin = rsDInventarios.Costo> <!---VERIFICAR CON PATRICIO--->
				<cfif varMoneda.EQUcodigoSIF NEQ varMonedaL> 
					<cfif varMonedaL NEQ 'MXP' and varMoneda.EQUcodigoSIF EQ 'MXP'>
							<cfset varTipoCambioL = ExtraeTipoCambio(varMonedaL,varEcodigo.EQUidSIF,rsEInventarios.Fecha_Movimiento)>
							<cfset MontoLinL = MontoLin / varTipoCambioL.TCcompra>
						<cfelseif varMonedaL EQ 'MXP' and varMoneda.EQUcodigoSIF NEQ 'MXP'>
					         <cfset MontoLinL = MontoLin * varTipoCambio.TCcompra>
						<cfelseif varMonedaL NEQ 'MXP' and varMoneda.EQUcodigoSIF NEQ 'MXP'>
						   <cfset varTipoCambioL = ExtraeTipoCambio(varMonedaL,varEcodigo.EQUidSIF,rsEInventarios.Fecha_Movimiento)>
						   <cfset MontoLinL =  ((MontoLin * varTipoCambio.TCcompra) / varTipoCambioL.TCcompra) >
					</cfif>
				<cfelse>
					<cfset MontoLinL = MontoLin>
				</cfif>
									
							
				<!--- , 'CONCEPTO SERVICIO' --->
				<cfif isdefined("rsDInventarios.Cod_Item") and trim(rsDInventarios.Cod_Item) NEQ "">
     				<cfset VarConcepServicio = ExtraeConceptoServicio(rsDInventarios.Cod_Item, varEcodigo.EQUidSIF)>
					<cfset VarCodigoServicio = VarConcepServicio.Cid>					
				</cfif>
				
				<cfif not isdefined("VarCodigoServicio")>
					<cfset VarCodigoServicio = 1>
				</cfif>
				
				<!---Validar Importes Negativos--->
				<cfif rsDInventarios.Costo LT 0>
					<cfthrow message="El documento contiene valores negativos, no pueden ser procesados valores negativos">
				</cfif>	
				
				<!---REGISTRO DE LOS DETALLES ID18--->

				<cfswitch expression="#rsEInventarios.Tipo_Movimiento#">
					<cfcase value="EP"> <!---Entrega Producto--->
						<!--- Cuenta Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="IV"
							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaInventario = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA INVENTARIOS---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" 
							 value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							 <cfif rsEInventarios.Tipo_Ajuste EQ 'E'>
								 'D',
							 <cfelse>
							 	 'C',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
 							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Puente Costeo de Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="CP"
							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaCInventario = Cuenta>
				
						<!---REGISTRO DEL ASIENTO DE LA CUENTA INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 <cfif rsEInventarios.Tipo_Ajuste EQ 'E'>
							 	'C',
							 <cfelse>
							 	'D',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
				<cfcase value="SF"> <!---Salida Producto Flete--->
						<!--- Cuenta Puente Costeo Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="CP"
							PMI_Almacen="#rsEInventarios.Almacen_Origen#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaCInventario = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							 <cfif rsEInventarios.Tipo_Ajuste EQ 'S'>
								 'D',
							 <cfelse>
							 	 'C',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="IV"
							PMI_Almacen="#rsEInventarios.Almacen_Origen#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaInventario = Cuenta>
				
						<!---REGISTRO DEL ASIENTO DE LA CUENTA INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 <cfif rsEInventarios.Tipo_Ajuste EQ 'S'>
								'C',
							 <cfelse>
							 	'D',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
				<cfcase value="SV"> <!---Producto en Transito de Ventas No Realizadas--->
						<!--- Cuenta Producto en Transito Pendiente de Entregar a Clientes--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="TV"
							<!----En esta transacción se envia el valor de la Transacción en lugar del Almacén ya que para transito no se manejan almacenes sino CTTs y se complementara solo la transacción para el PMI_Almacen---->
							PMI_Almacen="#rsEInventarios.Tipo_Movimiento#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaPTransito = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA TRANSITO PENDIENTE DE ENTREGAR A CLIENTES---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'D',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaPTransito.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="CP"
							<!----En esta transacción se envia el valor de la Transacción en lugar del Almacén ya que para transito no se manejan almacenes sino CTTs y se complementara solo la transacción para el PMI_Almacen---->
							PMI_Almacen="#rsEInventarios.Tipo_Movimiento#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaCInventario = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE INVENTARIOS---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'C',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
				<cfcase value="TO"> <!---Traspaso Interalmacen--->
					<!--- Cuenta Terminal Destino--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="IV" 
 							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaTDestino = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'D',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaTDestino.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Terminal Origen--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="IV"  
 							PMI_Almacen="#rsEInventarios.Almacen_Origen#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaTOrigen = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							 'C',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaTOrigen.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)				
							        
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
				<cfcase value="IC">
					<!--- Cuenta Inventario en Custodia--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
						    PMI_Op_Inventario="IC" 
							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaInvCustodiaRecibido= Cuenta>
						
						<!---REGISTRO DEL ASIENTO DEL INVENTARIO EN CUSTODIA RECIBIDO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'D',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaInvCustodiaRecibido.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						    <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Inventario en Custodia por Entregar--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="IE" 
 							PMI_Almacen="#rsEInventarios.Almacen_Origen#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaInvCustodiaEntregar = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'C',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaInvCustodiaEntregar.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)
												    
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
				<cfcase value="CM">
						<!--- Cuenta Baja Costo de Ventas--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="BC"
							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaBCostoVenta = Cuenta>
						
						<!---REGISTRO BAJA COSTO DE VENTA---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'D',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaBCostoVenta.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Baja Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="BI"
							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaBInventarios = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA BAJA DE INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 'C',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaBInventarios.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
				<cfcase value="AL"> <!---Alijos--->
						<!--- Cuenta Puente Costeo Inventarios Destino--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="CP"
							PMI_Almacen="#rsEInventarios.Almacen_Destino#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaCInventarioD = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO DESTINO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">,<!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Destino#">,
							 '',
							 'D',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventarioD.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Puente Costeo Inventarios Origen--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="CP"
							PMI_Almacen="#rsEInventarios.Almacen_Origen#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaCInventarioO = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO ORIGEN---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							 '',
							 'C',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventarioO.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaO.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFO.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
					<cfcase value="TR"> <!---Producto en transito--->
						<!--- Cuenta Producto en transito--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaD.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="TR"
							<!----En esta transacción se envia el valor de la Transacción en lugar del Almacén ya que para transito no se manejan almacenes sino CTTs y se complementara solo la transacción para el PMI_Almacen---->
							PMI_Almacen="#rsEInventarios.Tipo_Movimiento#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaProductoTransito = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PRODUCTO EN TRANSITO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
							 '',
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							 'D',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaProductoTransito.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Puente Costeo Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMII"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsDInventarios.Clas_Item#"
                            PMI_Cmdty_Padre="#rsDInventarios.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficinaO.EQUidSIF#"
							PMI_Mov_Inventario="#rsEInventarios.Tipo_Movimiento#"
							PMI_Op_Inventario="CP"
							<!----En esta transacción se envia el valor de la Transacción en lugar del Almacén ya que para transito no se manejan almacenes sino CTTs y se complementara solo la transacción para el PMI_Almacen---->
							PMI_Almacen="#rsEInventarios.Tipo_Movimiento#"
							PMI_Linea_Negocio="#rsDInventarios.Tipo_Item#"
							>				
						</cfinvoke>          			
						<cfset CuentaCInventario = Cuenta>
						
						<!---REGISTRO DEL ASIENTO DE LA CUENTA PUENTE DE COSTO INVENTARIO---><br>
				        <cfquery datasource="sifinterfaces">
						insert into SIFLD_ID18
							(ID, 
							 DCIconsecutivo, 
							 Ecodigo, 
							 DCIEfecha, 
							 Eperiodo, 
							 Emes,
							 Ddescripcion, 
							 Ddocumento, 
							 Dreferencia, 
							 Dmovimiento, 
							 Ccuenta,
							 CFcuenta, 
							 Ocodigo, 
							 Mcodigo, 
							 Doriginal, 
							 Dlocal, 
							 Dtipocambio,
							 Cconcepto, 
							 BMfalta, 
							 EcodigoRef, 
							 CFformato, 
							 Oficodigo, 
							 Miso4217,
							 Referencia1, 
							 Referencia2, 
							 Referencia3, 
							 CFcodigo)
				      values (<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
					         <cfqueryparam cfsqltype="cf_sql_integer" value="#IDlinea#">, 
  						     <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsEInventarios.Fecha_Movimiento,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Descripcion#">, <!---DESCRIPCION DEL ENCABEZADO--->
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Almacen_Origen#">,
							 '',
							 'C',
							 null,
							 null,
							 null,
							 null,
							 round(#MontoLin#,2),
							 round(#MontoLinL#,2),
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 11, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficinaD.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCFD.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
			</cfswitch>
		</cfsilent>
        </cfloop>
		</cfif> <!--- Detalles Poliza--->
			
		<!--- Marca o Borra las Tablas Origen Registro Procesado --->
		<!--- BORRADO DE TABLAS ORIGEN --->  
        <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>
        <cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
					delete DSIFLD_Movimientos_Inventario where ID_Movimiento = #Movimiento# 
					delete ESIFLD_Movimientos_Inventario where ID_Movimiento = #Movimiento#
    	        <cfelse>
					update ESIFLD_Movimientos_Inventario
					set Estatus = 92,
                    ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
	                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#
					where ID_Movimiento = #Movimiento#
				</cfif>
        </cfquery>    

		<!---	<cfset disparaInterfaz(18, #Maximus#, #varEcodigo.EQUcodigoSIF#, #varEcodigo.EQUidSIF#,0)>--->
		
         <cfset rsValidaLinea = javacast("null","")>
		 <cfset rsVerificaE = javacast("null","")>
		 <cfset rsLinea = javacast("null","")>
         <cfset rsMonedaL = javacast("null","")>
         <cfset BuscaPeriodo = javacast("null","")>
		 <cfset BuscaMes = javacast("null","")>
		 <cfset rsDInventarios = javacast("null","")>
         <cfset rsEInventarios = javacast("null","")>
         <cfset javaRT.gc()><!--- invoca el GC --->		

		<cfcatch>
			
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update ESIFLD_Movimientos_Inventario
				set Estatus = 3,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_Movimiento = #Movimiento#
			</cfquery>
			<!--- Elimina Registros Insertados. Verifica si se grabo algo en las tablas --->
			<cfif varBorraRegistro>
				<cfif isdefined("Maximus")>
					<cfquery datasource="sifinterfaces">
						delete from SIFLD_ID18 where ID = #Maximus#
					</cfquery>
                    <cfquery datasource="sifinterfaces">
	                    delete from SIFLD_IE18 where ID = #Maximus#				
                    </cfquery>
                </cfif>
            <cfelse>
            	<cfif isdefined("Maximus")>
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
                insert into SIFLD_Errores 
                (Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, MsgErrorPila, Ecodigo, Usuario)
                values 
                ('C_Inventarios', 
                 'ESIFLD_Movimientos_Inventario',
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#Movimiento#">, 
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
 				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEInventarios.Ecodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEInventarios.Usuario#">) 
            </cfquery>
		</cfcatch>
		</cftry>
		</cfsilent>
        </cfloop> <!--- Encabezado de la poliza --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from ESIFLD_Movimientos_Inventario 
                where Estatus in (99,10)
            </cfquery>
            <cfif rsVerifica.Registros LT 1>
				<!---Se Dispara la Interfaz 18 de forma Masiva--->
                <cftransaction action="begin">
                <cftry>
                    <cfquery datasource="sifinterfaces">
                        insert into IE18
                            (ID, 
                            Ecodigo, 
                            Cconcepto, 
                            Eperiodo, 
                            Emes, 
                            Efecha,
                            Edescripcion, 
                            Edocbase, 
                            Ereferencia, 
                            Falta, 
                            Usuario,
                            ECIreversible)
                         select a.ID, a.Ecodigo, a.Cconcepto, a.Eperiodo, a.Emes, 
                            a.Efecha, a.Edescripcion, a.Edocbase, a.Ereferencia, 
                            a.Falta, a.Usuario, a.ECIreversible
                         from SIFLD_IE18 a
                         where exists (select 1 from ESIFLD_Movimientos_Inventario b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        insert into ID18 
                            (ID, 
                             DCIconsecutivo, 
                             Ecodigo, 
                             DCIEfecha, 
                             Eperiodo, 
                             Emes,
                             Ddescripcion, 
                             Ddocumento, 
                             Dreferencia, 
                             Dmovimiento, 
                             Ccuenta,
                             CFcuenta, 
                             Ocodigo, 
                             Mcodigo, 
                             Doriginal, 
                             Dlocal, 
                             Dtipocambio,
                             Cconcepto, 
                             BMfalta, 
                             EcodigoRef, 
                             CFformato, 
                             Oficodigo, 
                             Miso4217,
                             Referencia1, 
                             Referencia2, 
                             Referencia3, 
                             CFcodigo)
                        select a.ID, a.DCIconsecutivo, a.Ecodigo, a.DCIEfecha, a.Eperiodo, 
                             a.Emes, a.Ddescripcion, a.Ddocumento, a.Dreferencia, a.Dmovimiento, 
                             a.Ccuenta, a.CFcuenta, a.Ocodigo, a.Mcodigo, a.Doriginal, 
                             a.Dlocal, a.Dtipocambio, a.Cconcepto, a.BMfalta, a.EcodigoRef, 
                             a.CFformato, a.Oficodigo, a.Miso4217, a.Referencia1, a.Referencia2, 
                             a.Referencia3, a.CFcodigo
                        from SIFLD_ID18 a
                        where exists (select 1 from ESIFLD_Movimientos_Inventario b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        insert into InterfazColaProcesos (
                            CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                            EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                            FechaInclusion, UsucodigoInclusion, UsuarioBdInclusion, Cancelar)
                        select
                          a.CEcodigo,
                          18,
                          a.ID,
                          0 as SecReproceso,
                          a.EcodigoSDC,
                          'E' as OrigenInterfaz,
                          'A' as TipoProcesamiento,
                          1 as StatusProceso,
                          <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
                          a.Usucodigo,
                          a.Usulogin,
                          0 as Cancelar
                        from SIFLD_IE18 a
                        where exists (select 1 from ESIFLD_Movimientos_Inventario b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Movimientos_Inventario
                            set Estatus = 2
                        where Estatus = 92
                        and ID18 in (select ID from SIFLD_IE18)
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
                        select 'C_Inventarios', 'ESIFLD_Movimientos_Inventario', ID_Movimiento,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            Usuario
                        from ESIFLD_Movimientos_Inventario
                        where Estatus in (92)  
                        and ID18 in (select ID from SIFLD_IE18)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update ESIFLD_Movimientos_Inventario set Estatus = 3
                        where Estatus in (92) 
                        and ID18 in (select ID from SIFLD_IE18)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction> 
                
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID18
                    where ID in (select ID18 from ESIFLD_Movimientos_Inventario where Estatus in (2,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE18
                    where ID in (select ID18 from ESIFLD_Movimientos_Inventario where Estatus in (2,3))
                </cfquery>			
			</cfif>
		</cfif>
    </cffunction>
</cfcomponent>