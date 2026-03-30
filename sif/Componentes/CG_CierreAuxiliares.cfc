<!--- 
	Esta es la nomenclatura para los nombres de las tablas temporales que se van a crear
	en el procedimiento de cierre de auxiliares;
		- Para CC_CierreMesCxC
			* Monedas = CierreMes_M
			* Documentos = CierreMes_D
		- Para CP_CierreMesCxP
			* Monedas = CierreMes_M2
			* Documentos = CierreMes_D2
		- Para MB_CierreMesBancos
			* SaldosBancarios = CierreMesB_SB
--->
<!---	Cierre Auxiliares	--->
<cfcomponent output="yes">
	<cffunction name='CierreAuxiliares' access='public' output='no'>
		<cfargument name='Ecodigo' type='numeric' required='true'>
		<cfargument name='debug' type='string' required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">

		<cfsetting requesttimeout="3600">
		<cfset LvarEsPrimerMensajeCierre = true>
		
		<!--- Parámetros Generales --->
		<cfset Pcodigo_mes = 60>
		<cfset Pcodigo_per = 50>
		<cfset periodo = 0>	
		<cfset periodoant = 0>		
		<cfset mes = 0>		
		<cfset mesant = 0>
		<cfset sistema = "GN">				
		<cfset error = 0>		
		<cfset Monloc = 0>		

		<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
		    select Mcodigo 
			from Empresas 
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>
		
		<cfquery name="rs_ParMes" datasource="#arguments.conexion#">
			select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros
			where Pcodigo = #Pcodigo_mes#
			  and Mcodigo = '#sistema#'
			  and Ecodigo = #arguments.Ecodigo#
		</cfquery>
		
		<cfif isdefined('rs_ParMes') and rs_ParMes.recordCount GT 0>
			<cfset mes = rs_ParMes.Pvalor>
			<cfset mesant = rs_ParMes.Pvalor>
		</cfif>

		<cfquery name="rs_ParPer" datasource="#arguments.conexion#">
			select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
			from Parametros 
			where Pcodigo = #Pcodigo_per#
			  and Mcodigo = '#sistema#'
			  and Ecodigo = #arguments.Ecodigo#
		</cfquery>
	
		<cfif isdefined('rs_ParPer') and rs_ParPer.recordCount GT 0>
			<cfset periodo = rs_ParPer.Pvalor>
			<cfset periodoant = rs_ParPer.Pvalor>
		</cfif>		

		<cfset fnReportaActividad("Validaciones Iniciales del Cierre #numberformat(periodoant, "9999")#-#numberformat(mesant, "99")# ")>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadCxC
			from Documentos
			where Ecodigo = #arguments.Ecodigo#
			and CCTcodigo not in ('FE' , 'NH')
		</cfquery>
		<cfset LvarExistenDocumentosCxC = rsVerifica.CantidadCxC>
		
		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadCxC
			from Documentos
			where Ecodigo = #arguments.Ecodigo#
			and CCTcodigo  in ('FE' , 'NH')
		</cfquery>
		<cfset LvarExistenDocumentosCxCCE = rsVerifica.CantidadCxC>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadCxP
			from EDocumentosCP
			where Ecodigo = #arguments.Ecodigo#
			and  CPTcodigo not in ('FE' , 'NH')
		</cfquery>
		<cfset LvarExistenDocumentosCxP = rsVerifica.CantidadCxP>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(*) as CantidadCPR
			from EDocumentosCPR
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset LvarExistenDocumentosRemision = rsVerifica.CantidadCPR>
		
		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadCxPCE
			from EDocumentosCP
			where Ecodigo = #arguments.Ecodigo#
			and  CPTcodigo in ('FE' , 'NH')
		</cfquery>
		<cfset LvarExistenDocumentosCxPCE = rsVerifica.CantidadCxPCE>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadMB
			from CuentasBancos
			where Ecodigo = #arguments.Ecodigo#
            	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset LvarExistenBancos = rsVerifica.CantidadMB>

		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadActivos
			from Activos
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset LvarExistenActivos = rsVerifica.CantidadActivos>
		
		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select count(1) as CantidadActivosFinancieros
			from AFNProcesoRegistro
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfquery name="rsExisteAFN" datasource="#arguments.conexion#">
			select count(1) as countAFN
			from AFNActivoFinanciero
			where Ecodigo = #arguments.Ecodigo#
		</cfquery>
		<cfset LvarExistenActivosFinancieros = rsVerifica.CantidadActivosFinancieros>
        <cfset LvarExistenActivosFinancieros2 = rsExisteAFN.countAFN>
        
		<!--- Validaciones con el componente CG_VALIDA. Se hace para minimizar el desperdicio de procesamiento
		del servidor de Base de Datos, EJ: procesa cierre de activos fijos, CxP, pero, procesando el cierre de CxC
		da el error "no se ha definido el periodo 1" y por ese error se pierde todo lo procesado anteriormente --->
		<cfif LvarExistenActivos GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_AF">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>	
				<cfinvokeargument name="periodo" value="#periodo#"/>
				<cfinvokeargument name="mes" value="#mes#"/>						
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
				
		</cfif>
		<cfif LvarExistenDocumentosCxP GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_CXP">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
		<cfif LvarExistenDocumentosRemision GT 0>
		    <cfinvoke component="CG_VALIDA" method="VALIDA_REMISIONES">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
		<cfif LvarExistenDocumentosCxPCE GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_CXP_CE">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
		<cfif LvarExistenDocumentosCxC GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_CXC">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
        <cfif LvarExistenDocumentosCxCCE GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_CXC_CE">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="debug" value="#arguments.debug#"/>							
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
        
		<cfif LvarExistenActivosFinancieros GT 0>
			<cfinvoke component="CG_VALIDA" method="VALIDA_AFinanciero">
			<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
			<cfinvokeargument name="debug" value="#arguments.debug#"/>							
			<cfinvokeargument name="periodo" value="#periodo#"/>
			<cfinvokeargument name="mes" value="#mes#"/>
			<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>
		</cfif>
        
        <!--- Como solo se valida la cantidad de registros en una tabla de bancos, se invoca el componente de una vez --->
        <cfinvoke component="CG_VALIDA" method="VALIDA_MB">
            <cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
            <cfinvokeargument name="debug" value="#arguments.debug#"/>							
            <cfinvokeargument name="conexion" value="#arguments.conexion#"/>
        </cfinvoke>
	
		<!--- 
			5 Agosto 2010
			Se eliminan posibles registros inconsistentes en la tabla de Asientos Contables.
			Los registros inconsistentes se podrían generar por el manejo de la transacción en la aplicación de asientos contables.
			El asiento se aplica utilizando una transacción, y los registros se eliminan de la tabla de asientos en proceso en otra transacción.
			Si el proceso termina entre ambas transacciones, pueden quedar registros inconsistentes en las estructuras.
			
			Se identifican por tener los valores de Periodo y Mes en negativo.

			Solicitado por Mauricio Esquivel
		--->
		<cfset fnReportaActividad("Eliminando Datos Inconsistentes en Asientos Contables")>

		<cfquery name="rs_AsientosBorrar" datasource="#Arguments.Conexion#">
			select IDcontable, Eperiodo, Emes
			from EContables
			where Ecodigo = #arguments.Ecodigo#
			  and Eperiodo < 0
			  and Emes     < 0  
		</cfquery>

		<cfloop query="rs_AsientosBorrar">
			<cfset LvarAsientosBorrar_IDcontable = rs_AsientosBorrar.IDcontable>
			<cfset LvarAsientosBorrar_Eperiodo   = rs_AsientosBorrar.Eperiodo>
			<cfset LvarAsientosBorrar_Emes       = rs_AsientosBorrar.Emes>

			<cfquery name="rs_AsientosBorrarHistoria" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad
				from HEContables
				where IDcontable = #LvarAsientosBorrar_IDcontable#
			</cfquery>

			<cfif LvarAsientosBorrar_IDcontable GT 0 and LvarAsientosBorrar_Eperiodo LT 0 and LvarAsientosBorrar_Emes LT 0 and rs_AsientosBorrarHistoria.Cantidad GT 0>
				<cftransaction>
					<cfquery datasource="#Arguments.Conexion#">
						delete from DContables 
						where IDcontable = #LvarAsientosBorrar_IDcontable#
					</cfquery>
                
					<cfquery datasource="#Arguments.Conexion#">
						delete from EContables 
						where IDcontable = #LvarAsientosBorrar_IDcontable#
					</cfquery>
				</cftransaction>
			</cfif>
		</cfloop>
		<!--- /Eliminar registros inconsistentes en las tablas de asientos contables --->

		<cfset fnReportaActividad("Creando Estructuras de Datos de Control")>

		<!--- ************************************************************************************************ --->
		<cfset SaldosBancarios   = this.Crea_SaldosBancarios()>
		<cfset TCP_Monedas       = this.CreaMonedasCxP()>
		<cfset TCP_CPDocumentos  = this.Crea_CPDocs()>
		<cfset TCP_SIdocumentos  = this.CreaSIDocsCP() >
		<cfset TCC_Monedas       = this.CreaMonedas()>
		<cfset TCC_CCDocumentos  = this.CreaDocsCxC()>
		<cfset TCC_SIdocumentos  = this.CreaSIDocsCC() >
        
		<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>	

		<cftransaction>
			<!--- 	Cierre Mes Activos Fijos	--->
			<cfif LvarExistenActivos GT 0>
				<cfset fnReportaActividad("Activos Fijos")>
				<cfinvoke component="AF_CierreMes" method="CierreMes">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
				</cfinvoke>
			</cfif>
			<!---- Cierre de Inventarios ---->
			<cfset fnReportaActividad("Inventarios")>
			<cfset INnuevoMes = ((Mes mod 12) + 1)>
			<cfset INnuevoPeriodo = iif(INnuevoMes is 1,periodo + 1,periodo)>
			<cfquery datasource="#arguments.conexion#">		
				insert into CostoProduccionSTD (Aid, Ecodigo, CTDcosto, CTDperiodo, CTDmes, fechaalta, BMUsucodigo)
					select 	a.Aid,
							#arguments.Ecodigo#,		
							coalesce (CTDcosto,Acosto,0) as Acosto,
							#INnuevoPeriodo#,
							#INnuevoMes#,
							<cf_dbfunction name="now">,
							#session.Usucodigo#			
					from Articulos a
						left outer join CostoProduccionSTD b
							on a.Aid = b.Aid
							and a.Ecodigo = b.Ecodigo
					where a.Ecodigo = #arguments.Ecodigo#
					and   b.CTDperiodo = #periodo#
					and   b.CTDmes     = #mes#
					and (	
						select count(1)
						from CostoProduccionSTD c
						where c.Aid = a.Aid
						and c.CTDperiodo =  #INnuevoPeriodo#
						and c.CTDmes     =  #INnuevoMes#
					) = 0
			</cfquery>
			<cfquery datasource="#arguments.conexion#">  
				insert into ExistenciaInicial( 
						Aid, 
						Alm_Aid, 
						EIperiodo, 
						EIMes, 
						EIexistencia, 
						EIcosto, 
						BMUsucodigo )
				select e.Aid, 
					   e.Alm_Aid, 
					   #INnuevoPeriodo#, 
					   #INnuevoMes#, 
					   e.Eexistencia, 
					   e.Ecostototal, 
					   #session.Usucodigo#
				from Articulos a
					inner join Existencias e
					  on a.Aid=e.Aid
				where a.Ecodigo = #arguments.Ecodigo#
			</cfquery>
	
			<cfif LvarExistenBancos GT 0>
				<cfset fnReportaActividad("Bancos")>
				<!--- 	Cierre Mes Bancos 	--->
				<cfinvoke component="MB_CierreMesBancos" method="CierreMesBancos">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>							
					<cfinvokeargument name="periodo" value="#periodo#"/>
					<cfinvokeargument name="mes" value="#mes#"/>
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="SaldosBancarios" value="#SaldosBancarios#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			
			<cfif LvarExistenDocumentosCxP GT 0>
				<cfset fnReportaActividad("Cuentas Por Pagar")>
				<!--- Cierre Mes CxP --->	
				<cfinvoke component="CP_CierreMesCxP" method="CierreMesCxP">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>				
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="Monedas" value="#TCP_Monedas#"/>
					<cfinvokeargument name="CPDocumentos" value="#TCP_CPDocumentos#"/>
					<cfinvokeargument name="SIdocumentos" value="#TCP_SIdocumentos#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			
			<cfif LvarExistenDocumentosCxPCE GT 0>
				<cfset fnReportaActividad("Cuentas Por Pagar CE")>
				<!--- Cierre Mes CxP  Comercializador del  Estado E --->
				<cfinvoke component="CP_CierreMesCxP" method="CierreMesCxPCE">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>				
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="Monedas" value="#TCP_Monedas#"/>
					<cfinvokeargument name="CPDocumentos" value="#TCP_CPDocumentos#"/>
					<cfinvokeargument name="SIdocumentos" value="#TCP_SIdocumentos#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			
			<cfif LvarExistenDocumentosCxC GT 0>
				<cfset fnReportaActividad("Cuentas por Cobrar")>
				<!--- Inicio de la ejecucion de los componentes de los Procedimientos Almacenados --->
				<!--- 	Cierre Mes CxC 	--->
				<cfinvoke component="CC_CierreMesCxC" method="CierreMes">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>				
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="Monedas" value="#TCC_Monedas#"/>
					<cfinvokeargument name="CCDocumentos" value="#TCC_CCDocumentos#"/>
					<cfinvokeargument name="SIdocumentos" value="#TCC_SIdocumentos#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			<cfif LvarExistenDocumentosCxCCE GT 0>
				<cfset fnReportaActividad("Cuentas por Cobrar CE")>
				<!--- Inicio de la ejecucion de los componentes de los Procedimientos Almacenados --->
				<!---  Cierre Mes CxC Comercializadora del  Estado --->
				<cfinvoke component="CC_CierreMesCxC" method="CierreMesCE">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>				
					<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
					<cfinvokeargument name="Monedas" value="#TCC_Monedas#"/>
					<cfinvokeargument name="CCDocumentos" value="#TCC_CCDocumentos#"/>
					<cfinvokeargument name="SIdocumentos" value="#TCC_SIdocumentos#"/>
					<cfinvokeargument name="Intarc" value="#Intarc#"/>
				</cfinvoke>		
			</cfif>
			<!--- verificar si tiene configurado el modulo--->
			<cfset fnReportaActividad("Anticipos Pagados por Tesoreria")>
			<cfquery datasource="#session.dsn#" name="rsMod">
				SELECT COUNT(*) as Existe
				FROM 
					CCHconfig
				WHERE Ecodigo = #session.Ecodigo#
			</cfquery>
			
			<cfif rsMod.recordCount GT 0>			
			<!--- guardar anticipos pagados por medio de tesoreria--->
			<cfinvoke component="CG_CierreMesAnticipoDE" method="DetalleanticipoEmpleadoFinalizado">
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="debug" value="#arguments.debug#"/>		
				</cfinvoke>
			</cfif>

<!---Reversa de NAPs que no se consumieron Totalmente
	 Elaborado por: RVD 28/02/2014 --->
     		<cfset vPeriodoMes = periodo * 100 + mes>
     
			<cfset fnReportaActividad("Creando Reversa de los NAPs que no se han consumido totalmente")>
          		<!---Se valida  que el parametro de compromisos Automaticos este activo para el periodo actual--->
            	<cfquery name="rs_CompromisoAutomatico" datasource="#arguments.conexion#">
                       select  * from CPparametros a
                       inner join CPresupuestoPeriodo b
                       on a.CPPid = b.CPPid
                       where SUBSTRING(cast(CPPanoMesDesde as varchar(8)),0,5) =(
                       select Pvalor from Parametros
                       where Pcodigo = #Pcodigo_per#
                       and Ecodigo = #arguments.Ecodigo#)
                       and a.CPCompromiso = 1
                       and a.Ecodigo = b.Ecodigo
                       and a.Ecodigo = #arguments.Ecodigo#
				</cfquery>
                <cfquery name="rsCuentas" datasource="#Session.DSN#">
                    select count(*) as CuentasNA
                    from CPresupuestoComprAut a
                    inner join CPresupuestoComprAutD d
                                on a.CPCCid=d.CPCCid
                    where a.Ecodigo = #arguments.Ecodigo#
                        and a.CPPid   = (
							select cpp.CPPid 
							from CPparametros cpp
							inner join (select CPresupuestoPeriodo.CPPid 
										from CPresupuestoPeriodo where #vPeriodoMes# BETWEEN CPresupuestoPeriodo.CPPanoMesDesde 
										and CPresupuestoPeriodo.CPPanoMesHasta
							) cp
								on cpp.CPPid = cp.CPPid
							where Ecodigo = #arguments.Ecodigo# and CPCompromiso = 1
						)
                        and a.CPcambioAplicado = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                        and d.CPComprMod <> d.CPComp_Anterior
                </cfquery>
                
                <cfif rsCuentas.CuentasNA gt 0>
                	<cfthrow message="Existen compromisos pendientes de aplicar en Control de Presupuesto\Cuentas de Presupuesto con Compromiso Automático!">
                <cfelse>
                
								<!---Se consulta la oficina de la Empresa--->
                                <cfquery name="rsOficina" datasource="#Session.DSN#">
                                    select Ocodigo,Odescripcion,Oficodigo from Oficinas a
                                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                </cfquery>
                                
                 		<cfif rs_CompromisoAutomatico.recordcount NEQ 0> 
                   			 <!---Si esta activo el parametro de compromisos automatico para el periodo actual entra aqui--->
                    
                              <cfquery name="rs_NAPs" datasource="#arguments.conexion#"> 
                              <!---Query que obtiene los NAPs correspondientes a los compromisos automaticos--->                              
                                   select c.CPNAPnum,c.CPcuenta,c.CPCano,c.CPCmes,c.CPNAPnum * 10000 + c.CPNAPDlinea as CPNAPDlinea,
                                   c.CPNAPDlinea as CPNAPDlineaRef,cast(c.Ecodigo as int) Ecodigo, e.CPNAPmoduloOri,n.Mcodigo, 
                                   (n.CPNAPDmonto-n.CPNAPDutilizado) as NAPMonto,c.CPPid,n.CPCPtipoControl,n.CPCPcalculoControl,n.PCGDid,n.Ocodigo 
                                   from CPNAPdetalle n 
                                        inner join CPresupuestoComprometidasNAPs c 
                                            on c.CPPid =(select cpp.CPPid 
														from CPparametros cpp
														inner join (select CPresupuestoPeriodo.CPPid 
																	from CPresupuestoPeriodo where #vPeriodoMes# BETWEEN CPresupuestoPeriodo.CPPanoMesDesde 
																	and CPresupuestoPeriodo.CPPanoMesHasta
														) cp
														on cpp.CPPid = cp.CPPid
														where Ecodigo = #arguments.Ecodigo# and CPCompromiso = 1
														)
                                            and n.CPNAPnum = c.CPNAPnum 
                                            and n.CPcuenta = c.CPcuenta 
                                            and n.CPCmes = c.CPCmes
                                            and n.Ecodigo = c.Ecodigo
                                            and n.CPNAPDlinea = c.CPNAPDlinea
                                        inner join CPNAP e 
                                            on c.CPNAPnum = e.CPNAPnum 
                                            and c.Ecodigo = e.Ecodigo
                                        inner join CPresupuestoComprAut d
                                            on c.CPPid = d.CPPid and c.CPcuenta = d.CPcuenta and e.Ecodigo = d.Ecodigo 
                                    where c.CPCmes = (select Pvalor from Parametros where Pcodigo =  #Pcodigo_mes# and Mcodigo = '#sistema#'
                                    and Ecodigo = #arguments.Ecodigo#)
                                    
                            </cfquery>
                                                    
                             <cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
                             <cfset LobjControl.CreaTablaIntPresupuesto ( Session.DSN,false,false,true)/>
							 <cfset rowIndex = 1>
                             <cfloop query="rs_NAPs">
                                    <cfquery name="rsSQLNAP" datasource="#session.dsn#">
                                            select count(*) as ultimo 
                                            from CPNAP 
                                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                                and EcodigoOri =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                                and CPNAPmoduloOri = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#rs_NAPs.CPNAPmoduloOri#"> 
                                                and left(CPNAPdocumentoOri,3) = 'REV' 
                                    </cfquery>
                                
                                        <cfif rsSQLNAP.ultimo EQ "">
                                            <cfset LvarDocumentoAprobo = 1 />
                                        <cfelse>
                                            <cfset LvarDocumentoAprobo = rsSQLNAP.ultimo + 1 />
                                        </cfif>
                                        
                                        <cfset LvarDocumentoAprobo = "REV-"&#LvarDocumentoAprobo# />
                            
                                <cfif rs_NAPs.recordCount GT 0>
                        
                                    <cfquery name="rsInsertintPresupuesto" datasource="#session.dsn#">
                                    
                                        insert into #request.intPresupuesto#
                                            (
                                                ModuloOrigen,
                                                NumeroDocumento,
                                                NumeroReferencia,
                                                FechaDocumento,
                                                AnoDocumento,
                                                MesDocumento,
                                                NumeroLinea,
                                                NAPreversado,
                                                CPPid, 
                                                CPCano, 
                                                CPCmes,
                                                CPcuenta, 
                                                Ocodigo, 
                                                CodigoOficina,
                                                TipoMovimiento,
                                                SignoMovimiento,
                                                TipoControl,
                                                CalculoControl,
                                                Mcodigo,
                                                MontoOrigen, 
                                                TipoCambio,
                                                Monto,
                                                NAPreferencia,
                                                LINreferencia
                                              )
                                            values ('#rs_NAPs.CPNAPmoduloOri#', 
                                                '#LvarDocumentoAprobo#', 
                                                'REV.COMPROMISO', 
                                                <cf_dbfunction name="now">,
                                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rs_NAPs.CPCano#">, 
                                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rs_NAPs.CPCmes#">,
                                                -#rs_NAPs.CPNAPDlinea#, 
                                                #rs_NAPs.CPNAPnum#,
                                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rs_NAPs.CPPid#">,
                                                #rs_NAPs.CPCano#, 
                                                #rs_NAPs.CPCmes#,
                                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rs_NAPs.CPcuenta#">, 
                                                <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsOficina.Ocodigo#">,
                                                 '#rsOficina.Oficodigo#',
                                                'CC', 
                                                -1,
                                                #rs_NAPs.CPCPtipoControl#,
                                                #rs_NAPs.CPCPcalculoControl#,
                                                #rs_NAPs.Mcodigo#, 
                                                -1*#rs_NAPs.NAPMonto#,
                                                1, 
                                                -1*#rs_NAPs.NAPMonto#, 
                                                #rs_NAPs.CPNAPnum#,
                                                #rs_NAPs.CPNAPDlineaRef#
                                            )
                                       </cfquery>
                    
                             </cfif>
                             
										<cfif rowIndex mod 500 eq 0>
                                       <!--- limpiando memoria --->
											   <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime() />
                                               <cfset javaRT.gc() />
                                       <!--- invoca el GC --->
                                      </cfif>
                                      		  <cfset rowIndex = rowIndex + 1>
                        </cfloop>
                        
                        
                        <cfquery name="rsSQL" datasource="#session.DSN#" maxrows="1">
                            select	ModuloOrigen,
                                    NumeroDocumento,
                                    NumeroReferencia,
                                    FechaDocumento,
                                    AnoDocumento,
                                    MesDocumento
                              from #request.intPresupuesto#
                        </cfquery>
                            
           				<cfinvoke
						 component		= "PRES_Presupuesto"
						 method			= "ControlPresupuestario"
						 returnvariable="LvarNAP">
							<cfinvokeargument name="ModuloOrigen" 		value="#rsSQL.ModuloOrigen#"/>
							<cfinvokeargument name="NumeroDocumento" 	value="#rsSQL.NumeroDocumento#"/>
							<cfinvokeargument name="NumeroReferencia" 	value="#rsSQL.NumeroReferencia#"/>
							<cfinvokeargument name="FechaDocumento" 	value="#rsSQL.FechaDocumento#"/>
							<cfinvokeargument name="AnoDocumento" 	value="#rsSQL.AnoDocumento#"/>4
							<cfinvokeargument name="MesDocumento" 	value="#rsSQL.MesDocumento#"/>
							<cfinvokeargument name="validaComp" value="True"/>							
						</cfinvoke>							
                        <cfif LvarNAP lt 0>
                            <cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
                        </cfif>
                
                </cfif>
         

    </cfif>
<!---Finaliza cambio para regresar los NAPs que no se han cosumido totalmente--->                
            
            
			<cfset fnReportaActividad("Actualizando Par&aacute;metros")>
			<!--- actualizar el mes --->
			<cfset mes = ((mes mod 12) + 1)>
			<cfquery name="rs_ParPvalor" datasource="#arguments.conexion#">
				update Parametros
				set   Pvalor  = <cf_dbfunction name="to_char" datasource="#arguments.conexion#" args="#mes#">
				where Pcodigo = #Pcodigo_mes#
					and Mcodigo = '#sistema#'
					and Ecodigo = #arguments.Ecodigo#
			</cfquery>
	
			<!--- actualizar el periodo, si hay un cambio de año --->
			<cfif mes EQ 1>
				<cfset Periodo = periodo + 1>
				<cfquery name="rs_MesPer" datasource="#arguments.conexion#">
					update Parametros
						set   Pvalor  = <cf_dbfunction name="to_char" datasource="#arguments.conexion#" args="#(periodo)#">
					where Pcodigo = #Pcodigo_per# 
						and Mcodigo = '#sistema#'
						and Ecodigo = #arguments.Ecodigo#			
				</cfquery>
			</cfif>
	
			<!--- Inserta en la bitácora --->
			<cfset fnReportaActividad("Actualizando bit&aacute;coras")>
			<cfquery name="rsBitacora" datasource="#Arguments.Conexion#">
				insert into BitacoraCierres (Ecodigo,BCperiodo,BCmes,BCtipocierre,Mcodigo,BCfcierre,Usucodigo,BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="2">, <!--- Cierre Auxiliar --->
					'#sistema#',
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,				
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
			<!--- Inserta en CGPeriodosProcesados --->
			
			<!---  a) Insertar el periodo Actual si no existe --->
			<cfquery name="rsPerProcexists" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from CGPeriodosProcesados 
				where Ecodigo = #Arguments.Ecodigo# 
				  and Speriodo = #periodoant#
				  and Smes = #mesant#
			</cfquery>
			<cfif rsPerProcexists.Cantidad eq 0>
				<cfquery name="rsinsPerProc" datasource="#Arguments.Conexion#">
					insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
					values (
						#Arguments.Ecodigo#, 
						#periodoant#, 
						#mesant#, 
						#session.Usucodigo#, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">)
				</cfquery>
			</cfif>
	
			<!---  b) Insertar el nuevo periodo si no existe --->
			<cfquery name="rsPerProcexists" datasource="#Arguments.Conexion#">
				select count(1) as Cantidad 
				from CGPeriodosProcesados 
				where Ecodigo = #Arguments.Ecodigo# 
				  and Speriodo = #periodo#
				  and Smes = #mes#
			</cfquery>
			
			<cfif rsPerProcexists.Cantidad eq 0>
				<cfquery name="rsinsPerProc" datasource="#Arguments.Conexion#">
					insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
					values (
						#Arguments.Ecodigo#, 
						#periodo#, 
						#Mes#, 
						#session.Usucodigo#, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">)
				</cfquery>
			</cfif>

			<cfif arguments.debug>
				<cfquery datasource="#arguments.conexion#" name="rs_ParamPer">
					select Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor
					from Parametros 
					where Ecodigo = #arguments.Ecodigo#
						and Pcodigo = #Pcodigo_per#
				</cfquery>
				
				<cfif isdefined('rs_ParamPer')>
					<cfdump var="#rs_ParamPer#" label="Tabla de Parametros con Pcodigo #Pcodigo_per# en CierreAuxiliares">
				</cfif>
				
				<cfquery datasource="#arguments.conexion#" name="rs_ParamMes">
					select Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor
					from Parametros 
					where Ecodigo = #arguments.Ecodigo#
						and Pcodigo = #Pcodigo_mes#
				</cfquery>
							
				<cfif isdefined('rs_ParamMes')>
					<cfdump var="#rs_ParamMes#" label="Tabla de Parametros con Pcodigo #Pcodigo_mes# en CierreAuxiliares">
				</cfif>
			</cfif>
		</cftransaction>

		
		<!--- SML 15042015. Inicio Guarda los saldos de Activos Financieros--->
	<cfif LvarExistenActivosFinancieros EQ 0 and LvarExistenActivosFinancieros2 GT 0>
		<cfset fnReportaActividad("Actualizando Saldos de Activos Financieros")>
        <cfquery name="rsSaldosActivosF" datasource="#arguments.conexion#">
       		select AFNid from AFNSaldos
            WHERE AFNSPeriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#">
                AND AFNSMes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#">
                AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
        </cfquery>
        
        <cfif rsSaldosActivosF.recordcount GT 0>
           <cfloop query="rsSaldosActivosF">
                <cfquery name="rsSaldosActivosF" datasource="#arguments.conexion#">
                    INSERT INTO AFNSaldos (Ecodigo,AFNid,AFNSPeriodo,AFNSMes, AFNSValorMes, AFNSValorAccionMes,AFNSTipoCambioMes,
                               AFNSCantidadMes,AFNSCostoMes, AFNSValorHistorico,AFNSValorAccionHistorico, AFNSTipoCambioHistorico, 
                               AFNSCantidadHistorico, AFNSCostoHistorico,BMUsucodigo,AFNSvalorHistoricoML)
                    SELECT <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,AFNid,<cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#"> as AFNSPeriodo,<cfqueryparam cfsqltype="cf_sql_integer" value="#mes#"> as AFNSMes,AFNSValorAccionHistorico,AFNSValorHistorico,AFNSTipoCambioHistorico,
                           AFNSCantidadHistorico,AFNSCostoHistorico,AFNSValorHistorico,AFNSValorAccionHistorico, AFNSTipoCambioHistorico,
                           AFNSCantidadHistorico,AFNSCostoHistorico,#session.usucodigo# as BMUsucodigo
                           ,(AFNSCostoHistorico * AFNSTipoCambioHistorico * AFNSCantidadHistorico) as AFNSvalorHistoricoML
                    FROM AFNSaldos
                    WHERE AFNSPeriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#">
                        AND AFNSMes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#">
                        AND Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        AND AFNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSaldosActivosF.AFNid#">
                </cfquery>
           </cfloop>
            <!--- SML 15042015. Final Guarda los saldos de Activos Financieros--->  
	   </cfif>
	  </cfif>         
		
        
		<cfset fnReportaActividad("Borrando Documentos Sin Saldo en CxP")>
		<!--- Se borran los documentos en cero de CxP y CxC fuera de la transacción.  No se requieren luego del cierre de mes --->
		<cfif LvarExistenDocumentosCxP GT 0>
			<cfinvoke component="CP_CierreMesCxP" method="CMA_CierreMesCxP_BorrarCeros">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>		
		</cfif>

		<cfset fnReportaActividad("Borrando Documentos Sin Saldo en CxC")>
		<cfif LvarExistenDocumentosCxC GT 0>
			<cfinvoke component="CC_CierreMesCxC" method="CMA_CierreMesCxC_BorrarCeros">
				<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
				<cfinvokeargument name="conexion" value="#arguments.conexion#"/>
			</cfinvoke>		
		</cfif>
		
		<!--- 
			Borrar los registros que existan en las tablas temporales
			porque no se pueden eliminar las tablas.
			De esta forma quedan las estructuras pero sin datos
			
			Se incluyeron dentro de un try porq algunas veces las tablas ya no existen si se cambia de coneccion. Sugerido por Mauricio E.
		--->
		<cfset fnReportaActividad("Borrando Tablas de Trabajo del Proceso de Cierre")>
		<cftry>
			<cfquery datasource="#arguments.conexion#">
				delete from #SaldosBancarios#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCP_Monedas#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCP_CPDocumentos#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCP_SIdocumentos#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCC_Monedas#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCC_CCDocumentos#
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				delete from #TCC_SIdocumentos#
			</cfquery>
		   <cfcatch type="any"></cfcatch>
		</cftry>
		<cfset fnReportaActividad("Proceso Terminado")>
	</cffunction>

	<cffunction name="fnReportaActividad" access="private" output="yes" hint="Reporta la actividad del cierre de mes para que el usuario pueda saber si el proceso está avanzando">
		<cfargument name="LvarProceso" type="string" default="*** Cierre ***">
		<cfif LvarEsPrimerMensajeCierre>
			<cfoutput>
			<br />
			<strong>Cierre de Auxiliares</strong>
			<br />
			</cfoutput>
			<cfset LvarEsPrimerMensajeCierre = false>
		<cfelse>
			<cfoutput>Terminado<br /></cfoutput>
		</cfif>
		<cfoutput>#Arguments.LvarProceso#:&nbsp;#DateFormat(now(), "DD/MM/YYYYY")#:#TimeFormat(now(), "HH:MM:SS")#.....</cfoutput>
		<!---<cfflush>--->
	</cffunction>
	
	<cffunction name="Crea_SaldosBancarios" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_Bancos_SB" returnvariable="CMA_Bancos_SB">
			<cf_dbtempcol name="CBid"  			type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Mes"  		    type="int"		    mandatory="yes">										
			<cf_dbtempcol name="Periodo"  		type="int"		    mandatory="yes">									
			<cf_dbtempcol name="Ecodigo"  		type="numeric">			
			<cf_dbtempcol name="Ocodigo"  		type="numeric">
			<cf_dbtempcol name="Mcodigo"  		type="numeric">
			<cf_dbtempcol name="TipoCambio"  	type="float">
			<cf_dbtempcol name="Sinicial"		type="money">
			<cf_dbtempcol name="Slocal"  		type="money">
			<cf_dbtempcol name="SaldoAJ"  		type="money">			
			<cf_dbtempcol name="Ajuste"  		type="money">
			<cf_dbtempcol name="MesN"  		    type="int"		mandatory="yes">										
			<cf_dbtempcol name="PeriodoN"  		type="int"		mandatory="yes">		
										
			<cf_dbtempkey cols="CBid,Mes,Periodo">
		</cf_dbtemp>
		
		<cfreturn CMA_Bancos_SB>
	</cffunction>		

	<cffunction name="CreaMonedasCxP" access="public" returntype="string" output="no">
		<cf_dbtemp name="CMA_CxPMoneda" returnvariable="CMA_CxPMonedas">
			<cf_dbtempcol name="Ecodigo"  	type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Mcodigo"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Periodo"  	type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Mes"  	    type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Ocodigo"  	type="int"    		mandatory="yes">
			<cf_dbtempcol name="TC"		    type="float"    	mandatory="yes">
			<cf_dbtempcol name="Mnombre"  	type="char(80)">
			<cf_dbtempcol name="Total"  	type="money"	 	mandatory="yes">
			<cf_dbtempcol name="Ccuenta"  	type="numeric">

			<cf_dbtempkey cols="Mcodigo,Ocodigo">
		</cf_dbtemp>
		
		<cfreturn CMA_CxPMonedas>
	</cffunction>	

	<cffunction name="Crea_CPDocs" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxPDocs" returnvariable="CMA_CxPDocs">
			<cf_dbtempcol name="IDdocumento"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  		type="int">			
			<cf_dbtempcol name="Periodo"  		type="int">						
			<cf_dbtempcol name="Mes"  			type="int">							
			<cf_dbtempcol name="CPTcodigo"  	type="char(2)">
			<cf_dbtempcol name="Ddocumento"		type="varchar(40)">
			<cf_dbtempcol name="Ocodigo"  		type="int">
			<cf_dbtempcol name="SNcodigo"  		type="int">
			<cf_dbtempcol name="Mcodigo"  		type="numeric">
			<cf_dbtempcol name="Ccuenta"  		type="numeric">			
			<cf_dbtempcol name="EDsaldo"  		type="money">			
			<cf_dbtempcol name="Saldo"  		type="money">						
			<cf_dbtempcol name="EDtcultrev"  	type="float">									
 
			<cf_dbtempkey cols="IDdocumento">
		</cf_dbtemp>
		
		<cfreturn CMA_CxPDocs>		
	</cffunction>
	
	<cffunction name="CreaSIDocsCP" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxPDocsSI" returnvariable="CMA_CxPDocsSI">
			<cf_dbtempcol name="Ecodigo"  			type="int"  	mandatory="yes">			
			<cf_dbtempcol name="SNcodigo"  			type="int"     	mandatory="yes">
			<cf_dbtempcol name="SNid"  				type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Mcodigo"  			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CPTcodigo"  		type="char(2)"  mandatory="yes">
			<cf_dbtempcol name="Ddocumento"  		type="varchar(40)"	mandatory="yes">
			<cf_dbtempcol name="id_direccion"  		type="numeric"	mandatory="yes">
			<cf_dbtempcol name="fecha"  			type="datetime"	mandatory="yes">
			<cf_dbtempcol name="saldo"  			type="money"	mandatory="yes">
			<cf_dbtempcol name="fechavencimiento"	type="datetime"	mandatory="yes">
		</cf_dbtemp>
		<cfreturn CMA_CxPDocsSI>		
	</cffunction>

	<cffunction name="CreaMonedas" access="public" returntype="string" output="no">
		<cf_dbtemp name="CMA_CxCMonedas" returnvariable="CMA_CxCMonedas">
			<cf_dbtempcol name="Mcodigo"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  	type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Periodo"  	type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Mes"  		type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Ocodigo"  	type="int"    		mandatory="yes">
			<cf_dbtempcol name="TC"			type="float"    	mandatory="yes">
			<cf_dbtempcol name="Mnombre"  	type="char(80)">
			<cf_dbtempcol name="Total"  	type="money"	 	mandatory="yes">
			<cf_dbtempcol name="Ccuenta"  	type="numeric">
			<cf_dbtempkey cols="Mcodigo,Ocodigo,Ecodigo,Periodo,Mes">
		</cf_dbtemp>
		
		<cfreturn CMA_CxCMonedas>
	</cffunction>	

	<cffunction name="CreaDocsCxC" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxCDocs" returnvariable="CMA_CxCDocs">
			<cf_dbtempcol name="CCTcodigo"  	type="char(2)"     	mandatory="yes">
			<cf_dbtempcol name="Ddocumento"  	type="varchar(40)"		mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  		type="int"    		mandatory="yes">			
			<cf_dbtempcol name="Periodo"  		type="int"    		mandatory="yes">						
			<cf_dbtempcol name="Mes"  			type="int"    		mandatory="yes">							
			<cf_dbtempcol name="Ocodigo"		type="int">
			<cf_dbtempcol name="SNcodigo"  		type="int">
			<cf_dbtempcol name="Mcodigo"  		type="numeric">
			<cf_dbtempcol name="Ccuenta"  		type="numeric">
			<cf_dbtempcol name="Dsaldo"  		type="money">			
			<cf_dbtempcol name="Saldo"  		type="money">			
			<cf_dbtempcol name="Dtcultrev"  	type="float">						
 
			<cf_dbtempkey cols="CCTcodigo,Ddocumento">
		</cf_dbtemp>
		<cfreturn CMA_CxCDocs>		
	</cffunction>

	<cffunction name="CreaSIDocsCC" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMA_CxCDocsSI_v1" returnvariable="CMA_CxCDocsSI">
			<cf_dbtempcol name="Ecodigo"  			type="int"  	mandatory="yes">			
			<cf_dbtempcol name="SNcodigo"  			type="int"     	mandatory="yes">
			<cf_dbtempcol name="SNid"  				type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Mcodigo"  			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CCTcodigo"  		type="char(2)"  mandatory="yes">
			<cf_dbtempcol name="Ddocumento"  		type="varchar(40)"	mandatory="yes">
			<cf_dbtempcol name="id_direccion"  		type="numeric"	mandatory="yes">
			<cf_dbtempcol name="fecha"  			type="datetime"	mandatory="yes">
			<cf_dbtempcol name="saldo"  			type="money"	mandatory="yes">
			<cf_dbtempcol name="fechavencimiento"	type="datetime"	mandatory="yes">
			<cf_dbtempcol name="tipo"				type="char(1)"	mandatory="yes">
			<cf_dbtempcol name="HDid"				type="numeric"	mandatory="yes">
		</cf_dbtemp>
		<cfreturn CMA_CxCDocsSI>		
	</cffunction>
</cfcomponent>