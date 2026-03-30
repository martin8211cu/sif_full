<!--- PMI: Integración Costo de Venta PMI --->
<!--- Polizas de los movimientos de Costo de Venta--->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró:Maria de los Angeles Blanco López 06 de Noviembre del 2009--->


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
      		
   		<cfif Application.dsinfo.sifinterfaces.type EQ "sybase">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top 50 SIFLD_Costo_Venta 
				set Estatus = 10 
				where 
        	    <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 1 
                    and not exists (select 1 from SIFLD_Costo_Venta where Estatus in (10, 11,94,92,99,100))
                <cfelse>
                    Estatus = 99 
                    and not exists (select 1 from SIFLD_Costo_Venta where Estatus in (10, 11))
                </cfif>
			</cfquery>
		<cfelseif Application.dsinfo.sifinterfaces.type EQ "sqlserver">
			<cfquery name="rsActualiza" datasource="sifinterfaces" result="Rupdate">
				update top (50) SIFLD_Costo_Venta 
				set Estatus = 10 
				where 
        	    <cfif isdefined("Arguments.Disparo") and Arguments.Disparo>
                    Estatus = 1 
                    and not exists (select 1 from SIFLD_Costo_Venta where Estatus in (10, 11,94,92,99,100))
                <cfelse>
                    Estatus = 99 
                    and not exists (select 1 from SIFLD_Costo_Venta where Estatus in (10, 11))
                </cfif>
			</cfquery>
        <cfelseif Application.dsinfo.sifinterfaces.type EQ "oracle">
			<cfthrow message="Base de datos #Application.dsinfo.sifinterfaces.type# no implementada">
        <cfelse>
        	<cfthrow message="Base de datos no reconocida">
		</cfif>

		<!--- toma registros cabecera de las Compras --->
		<cfquery name="rsIDCostoVenta" datasource="sifinterfaces">
			select ID_Mov_Costo
			from SIFLD_Costo_Venta 
			where 
			Estatus = 10
            <cfif Rupdate.recordcount EQ 0>
            	and 1 = 2
            </cfif> 
		</cfquery>
		
	  	<cfif isdefined("rsIDCostoVenta") AND rsIDCostoVenta.recordcount GT 0>
        <cfloop query="rsIDCostoVenta">
        <cfsilent>
		<cftry>
			<!--- toma registros cabecera de las Compras --->
            <cfquery name="rsCostoVenta" datasource="sifinterfaces">
                select Ecodigo, Origen, ID_Mov_Costo, Fecha, Descripcion, isnull(Monto, 0) as Monto, 
                Moneda, Sucursal, Venta, Contrato_Origen, Contrato_Destino, 
                Almacen_Origen, Almacen_Destino, Tipo_Item, Clas_Item, Cod_Item,
                Tipo_Costo, Periodo, Mes, Origen_Venta, Clas_Venta, Socio, Usuario
                from SIFLD_Costo_Venta 
                where 
                	ID_Mov_Costo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIDCostoVenta.ID_Mov_Costo#">
            </cfquery>
			<cfset Costo = rsCostoVenta.ID_Mov_Costo>
			
            <!---BUSCA EQUIVALENCIAS--->
			<!--- EMPRESAS --->
			<cfset varEcodigo = ConversionEquivalencia (rsCostoVenta.Origen, 'CADENA', rsCostoVenta.Ecodigo, rsCostoVenta.Ecodigo,            'Cadena')>
            
			<cfset varBorraRegistro = false>
			<!---Verifica si debe insertar encabezado o no --->
			<cfquery name="rsVerificaE" datasource="sifinterfaces">
				select ID, Ecodigo, EcodigoSDC, Empresa, Fecha,
					  Contrato_Origen, Contrato_Destino, Tipo_Costo, Usuario
				from SIFLD_IE18 
				where 
				<cfswitch expression="#rsCostoVenta.Tipo_Costo#">
							<cfcase value="ST">
								Tipo_Costo like 'ST' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCostoVenta.Ecodigo#">
                                and convert (datetime, Fecha, 103) = <cfqueryparam cfsqltype="cf_sql_date" value="#rsCostoVenta.Fecha#">
							</cfcase>
							<cfcase value="CT"> 
								Tipo_Costo like 'CT' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCostoVenta.Ecodigo#">
                                and Contrato_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#"> 
                                and convert (datetime, Fecha, 103) = <cfqueryparam cfsqltype="cf_sql_date" value="#rsCostoVenta.Fecha#">
							</cfcase>	
                            <!---RVD CAMBIO 1 DTS y DTC INICIA--->             
                            <cfcase value="DTS"> 
								Tipo_Costo like 'DTS' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCostoVenta.Ecodigo#">
                                and Contrato_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#"> 
                                and convert (datetime, Fecha, 103) = <cfqueryparam cfsqltype="cf_sql_date" value="#rsCostoVenta.Fecha#">
							</cfcase>                           
                            
                            <cfcase value="DTC"> 
								Tipo_Costo like 'DTC' 
                                and Empresa = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCostoVenta.Ecodigo#">
                                and Contrato_Origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#"> 
                                and convert (datetime, Fecha, 103) = <cfqueryparam cfsqltype="cf_sql_date" value="#rsCostoVenta.Fecha#">
							</cfcase>
                            
                            <!---RVD CAMBIO 2 DTS y DTC FIN--->				
				</cfswitch>
                and Usuario like <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsCostoVenta.Usuario)#">
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
			
			<!---OFICINAS --->
		    <cfset VarOficina = ConversionEquivalencia (rsCostoVenta.Origen, 'SUCURSAL', rsCostoVenta.Ecodigo, 
			rsCostoVenta.Sucursal,'Sucursal')>
			
			 <!--- MONEDA --->
      		<cfset varMoneda = ConversionEquivalencia (rsCostoVenta.Origen, 'MONEDA', rsCostoVenta.Ecodigo, rsCostoVenta.Moneda, 
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
				<cfthrow message="Error al Obtener la Moneda Local de la empresa: #rsECompras.Ecodigo#">
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
			
			<!--- CENTRO FUNCIONAL --->
			<cfset varCF = ConversionEquivalencia (rsCostoVenta.Origen, 'CENTRO_FUN', rsCostoVenta.Ecodigo, 
			rsCostoVenta.Sucursal, 'Centro_Funcional')>
			
			<!---Tipo cambio para la moneda origen --->
			<cfif varMoneda.EQUcodigoSIF NEQ 'MXP'>
				<cfset varTipoCambio = ExtraeTipoCambio(varMoneda.EQUcodigoSIF,varEcodigo.EQUidSIF,rsCostoVenta.Fecha)>
			<cfelse>
				<cfset varTipoCambio = 1>
			</cfif> 
			
			<!---SOCIO--->
			<cfset VarSocio = ExtraeCliente(rsCostoVenta.Socio, varEcodigo.EQUidSIF,"N")>  
			
			 <!---Tipo de Contraparte --->
			 <cfset varCEcodigo = getCEcodigo(varEcodigo.EQUidSIF)>
			 
			<cfquery name="rsContraparte" datasource="#session.dsn#">
				select sn.SNcodigo, snd.SNCDdescripcion from 
				SNClasificacionSN csn
				inner join SNegocios sn	on csn.SNid = sn.SNid 
				and sn.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">
				and sn.SNcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#VarSocio.SNcodigo#"> 
				inner join SNClasificacionD snd
		        inner join SNClasificacionE sne on snd.SNCEid = sne.SNCEid
	 	        and sne.CEcodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#varCEcodigo#">
		        and SNCEcodigo like 'SN-001' on csn.SNCDid = snd.SNCDid
			</cfquery>
		
			<cfif isdefined("rsContraparte") and rsContraparte.recordcount GT 0>
				<cfset varContraParte = rsContraparte.SNCDdescripcion>
			<cfelse>
				<cfthrow message="El Socio de Negocio #rsCostoVenta.Socio# no tiene asignado un valor para su contraparte">
			</cfif>
			
			<!---Usuario --->
			<cfset UsuInterfaz = UInterfaz(getCEcodigo(varEcodigo.EQUidSIF), rsCostoVenta.Usuario)>
			
			<cfif rsVerificaE.recordcount EQ 0>	 
				<!--- Insercion de cabecera en IE18 --->
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
					Fecha,
                    Contrato_Origen,
                    Contrato_Destino,
                    Tipo_Costo)
			 values(<cfqueryparam cfsqltype ="cf_sql_numeric" value="#Maximus#">,
				    <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">, 	
					12,
					<cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
					<cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
     				<cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
					'Costo de Venta #rsCostoVenta.Contrato_Origen# #dateformat(rsCostoVenta.Fecha,"mm-dd-yyyy")#',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">, <!---Verificar si es este o la 		venta---> 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#month(rsCostoVenta.Fecha)#">,
					getdate(),
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
					0,
                    <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUcodigoSIF#">, 
                    <cfqueryparam cfsqltype ="cf_sql_integer" value="#rsCostoVenta.Ecodigo#">, 	
                    <cfqueryparam cfsqltype ="cf_sql_numeric" value="#varCEcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz.Usulogin#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#UsuInterfaz.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Tipo_Costo#">)	          
			 </cfquery>
			</cfif>
				    
     			<!---Monto por linea --->
				<cfif varMoneda.EQUcodigoSIF NEQ varMonedaL> 
					<cfif varMonedaL NEQ 'MXP' and varMoneda.EQUcodigoSIF EQ 'MXP'>
							<cfset varTipoCambioL = ExtraeTipoCambio(varMonedaL,varEcodigo.EQUidSIF,
							rsCostoVenta.Fecha_Movimiento)>
							<cfset MontoLinL = rsCostoVenta.Monto / varTipoCambioL.TCcompra>
						<cfelseif varMonedaL EQ 'MXP' and varMoneda.EQUcodigoSIF NEQ 'MXP'>
					         <cfset MontoLinL = rsCostoVenta.Monto * varTipoCambio.TCcompra>
						<cfelseif varMonedaL NEQ 'MXP' and varMoneda.EQUcodigoSIF NEQ 'MXP'>
						   <cfset varTipoCambioL = ExtraeTipoCambio(varMonedaL,varEcodigo.EQUidSIF,rsCostoVenta.Fecha_Movimiento)>
						   <cfset MontoLinL =  ((rsCostoVenta.Monto * varTipoCambio.TCcompra) / varTipoCambioL.TCcompra) >
					</cfif>
				<cfelse>
					<cfset MontoLinL = rsCostoVenta.Monto>
				</cfif>

				<!--- , 'CONCEPTO SERVICIO' --->
     			<cfset VarConcepServicio = ExtraeConceptoServicio(rsCostoVenta.Cod_Item, varEcodigo.EQUidSIF)>
				<cfset VarCodigoServicio = VarConcepServicio.Cid>
				
				<!---REGISTRO DE LOS DETALLES ID18--->

				<cfswitch expression="#rsCostoVenta.Tipo_Costo#">
					<cfcase value="ST"> <!---Costo de Ventas sin terminal--->
					<!--- Cuenta Costo de Ventas--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CV"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
						    PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
							>				
						</cfinvoke>          			
						<cfset CuentaCostoVentas = Cuenta>
				
						<!---REGISTRO DEL ASIENTO DE LA CUENTA COSTO DE VENTA--->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'D',
							 <cfelse>
								 'C',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCostoVentas.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						<!--- Cuenta Puente Costeo Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CP"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
							PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, <!---Descripción de la tabla intermedia--->
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'C',
							 <cfelse>
								 'D',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>							
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>												
				</cfcase>
				<cfcase value="CT"> <!---Costo de Ventas de Terminal--->
						<!--- Cuenta Costo de Ventas--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CV"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
							PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
							>				
						</cfinvoke>          			
						<cfset CuentaCostoVenta = Cuenta>
						
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">,   <!----Descripcion de las intermedias--->
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'D',
							 <cfelse>
								 'C',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>							 
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCostoVenta.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						
						<!--- Cuenta Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="IV"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
							PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'C',
							 <cfelse>
								 'D',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
				</cfcase>
                
                
                <!---RVD CAMBIO DTS INICIA--->
                
               
                <!---***DTS***RVD--->
                <cfcase value="DTS"> <!---Costo de Ventas sin terminal--->
					<!--- Cuenta Costo de Ventas--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CVG"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
						    PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
							>				
						</cfinvoke>          			
						<cfset CuentaCostoVentas = Cuenta>
				
						<!---REGISTRO DEL ASIENTO DE LA CUENTA COSTO DE VENTA--->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'D',
							 <cfelse>
								 'C',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCostoVentas.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						<!--- Cuenta Puente Costeo Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CP"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
							PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, <!---Descripción de la tabla intermedia--->
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'C',
							 <cfelse>
								 'D',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>							
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>												
				</cfcase>
            <!---RVD CAMBIO DTS FIN--->
                
                
			<!---RVD CAMBIO DTC INICIA--->
            
            <!---***DTC***RVD--->
                <cfcase value="DTC"> <!---Costo de Ventas con terminal--->
					<!--- Cuenta Costo de Ventas--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CVG"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
						    PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
							>				
						</cfinvoke>          			
						<cfset CuentaCostoVentas = Cuenta>
				
						<!---REGISTRO DEL ASIENTO DE LA CUENTA COSTO DE VENTA--->
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, 
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'D',
							 <cfelse>
								 'C',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCostoVentas.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>
						<!--- Cuenta Puente Costeo Inventarios--->
						<cfinvoke returnvariable="Cuenta" component="sif.Componentes.CG_Complementos" method="TraeCuenta"
							Oorigen="PMIT"
							Ecodigo="#varEcodigo.EQUidSIF#"  
							Conexion="#session.dsn#"
							CConceptos="#rsCostoVenta.Clas_Item#"
                            PMI_Cmdty_Padre="#rsCostoVenta.Clas_Item#"
							Conceptos="#VarCodigoServicio#"
							Oficinas="#varOficina.EQUidSIF#" 
							SNegocios="#VarSocio.SNcodigo#"
							PMI_Tipo_Costo="#rsCostoVenta.Tipo_Costo#"
							PMI_Operacion_Costo="CP"
							PMI_Clas_Venta = "#rsCostoVenta.Clas_Venta#"
							PMI_Origen_Venta="#rsCostoVenta.Origen_Venta#"
							PMI_Linea_Negocio="#rsCostoVenta.Tipo_Item#"
							PMI_Tipo_Contraparte="#varContraparte#"
							PMI_Almacen="#rsCostoVenta.Contrato_Origen#"
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
							 <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(rsCostoVenta.Fecha,'yyyy/mm/dd')#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaPeriodo.Pvalor#">,
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#BuscaMes.Pvalor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Descripcion#">, <!---Descripción de la tabla intermedia--->
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Destino#">,
 							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Contrato_Origen#">,
							 <cfif rsCostoVenta.Monto GT 0>
							 	 'C',
							 <cfelse>
								 'D',
							 </cfif>
							 null,
							 null,
							 null,
							 null,
							 <cfif rsCostoVenta.Monto GT 0>
							 	round(#rsCostoVenta.Monto#,2),
							 	round(#MontoLinL#,2),
							 <cfelse>
								round(#rsCostoVenta.Monto#,2) * -1,
							 	round(#MontoLinL#,2) * -1,
							 </cfif>							
							 <cfqueryparam cfsqltype ="cf_sql_money" value="#varTipoCambio.TCcompra#">,
							 12, <!---concepto contable ????--->
							 getdate(),
							 <cfqueryparam cfsqltype ="cf_sql_integer" value="#varEcodigo.EQUidSIF#">,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#CuentaCInventario.CFformato#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varOficina.EQUcodigoSIF#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#varMoneda.EQUcodigoSIF#">, 
							 null,
							 null,
							 null,
						     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCF.EQUcodigoSIF#">)				
										          
							</cfquery>
							<cfset IDlinea = IDlinea + 1>												
				</cfcase>
                
                               
            <!---RVD CAMBIO DTS FIN--->
            	</cfswitch>
			
		<!--- Marca o Borra las Tablas Origen Registro Procesado --->
		<!--- BORRADO DE TABLAS ORIGEN --->
        <cfset stMemInfo = javaRT.totalMemory()-javaRT.freeMemory()>  
        <cfquery datasource="sifinterfaces"> 
        		<cfif Parborrado>
    	        	delete	SIFLD_Costo_Venta where ID_Mov_Costo = #Costo#     
				<cfelse>
					update SIFLD_Costo_Venta
					set Estatus = 92,
                    ID18 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Maximus#">,
	                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    ControlMem = #stMemInfo#
					where ID_Mov_Costo = #Costo#
				</cfif>
        	</cfquery>    

		<!---	<cfset disparaInterfaz(18, #Maximus#, #varEcodigo.EQUcodigoSIF#, #varEcodigo.EQUidSIF#, 0)>--->
		
		 <cfset rsVerificaE = javacast("null","")>
		 <cfset rsLinea = javacast("null","")>
         <cfset rsContraparte = javacast("null","")>
		 <cfset rsMonedaL = javacast("null","")>
         <cfset BuscaPeriodo = javacast("null","")>
		 <cfset BuscaMes = javacast("null","")>
         <cfset rsCostoVenta = javacast("null","")>
         <cfset javaRT.gc()><!--- invoca el GC --->
		
		<cfcatch>
			<!--- Marca El registro con Error--->
			<cfquery datasource="sifinterfaces">
				update SIFLD_Costo_Venta
				set Estatus = 3,
                Fecha_Fin_Proceso = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where ID_Mov_Costo = #Costo#
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
				('C_CostoVenta', 
				 'SIFLD_Costo_Venta',
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Costo#">, 
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
 				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCostoVenta.Ecodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCostoVenta.Usuario#">) 
			</cfquery>		
		</cfcatch>
		</cftry>
        </cfsilent>
		</cfloop> <!--- Encabezado de la poliza --->
			<cfquery name="rsVerifica" datasource="sifinterfaces">
            	select count(1) as Registros from SIFLD_Costo_Venta
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
                         where exists (select 1 from SIFLD_Costo_Venta b where a.ID = b.ID18 and b.Estatus in (92))
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
                        where exists (select 1 from SIFLD_Costo_Venta b where a.ID = b.ID18 and b.Estatus in (92))
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
                          Usucodigo,
                          Usulogin,
                          0 as Cancelar
                        from SIFLD_IE18 a
                        where exists (select 1 from SIFLD_Costo_Venta b where a.ID = b.ID18 and b.Estatus in (92))
                    </cfquery>
                    
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Costo_Venta
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
                        select 'C_CostoVenta', 'SIFLD_Costo_Venta', ID_Mov_Costo,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            Ecodigo,
                            Usuario
                        from SIFLD_Costo_Venta
                        where Estatus in (92)  
                        and ID18 in (select ID from SIFLD_IE18)
                    </cfquery>
                    <cfquery datasource="sifinterfaces">
                        update SIFLD_Costo_Venta set Estatus = 3
                        where Estatus in (92) 
                        and ID18 in (select ID from SIFLD_IE18)
                    </cfquery>
                </cfcatch>
                </cftry>
                </cftransaction>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_ID18
                    where ID in (select ID18 from SIFLD_Costo_Venta where Estatus in (2,3))
                </cfquery>
                <cfquery datasource="sifinterfaces">
                    delete SIFLD_IE18
                    where ID in (select ID18 from SIFLD_Costo_Venta where Estatus in (2,3))
                </cfquery>
            </cfif> 			
		</cfif>
    </cffunction>
</cfcomponent>