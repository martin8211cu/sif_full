
<cfsetting requesttimeout="1800">

<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_dbtemp name="ID925tmp_V3" returnvariable="CFformatos" datasource="#session.DSN#">
	<cf_dbtempcol name="CFformatoSF" type="varchar(100)"  mandatory="yes">
	<cf_dbtempcol name="CmayorSF"    type="varchar(4)"    mandatory="no">
	<cf_dbtempcol name="CdetSF"      type="varchar(100)"  mandatory="no">
	<cf_dbtempcol name="CFcuenta"    type="numeric"       mandatory="no">
	<cf_dbtempcol name="Ccuenta"     type="numeric"       mandatory="no">
	<cf_dbtempcol name="CFformato"   type="varchar(100)"  mandatory="no">
</cf_dbtemp>			

<cf_dbdatabase table="ID925" returnvariable="LvarID925" datasource="sifinterfaces">

<cfquery name="rsverexistencia" datasource="#session.DSN#">
	select count(1) as Cantidad
	from EContablesInterfaz18
	where ID = #GvarID#
</cfquery>

<cfif rsverexistencia.Cantidad EQ 0>
	<cfquery name="rsVariables" datasource="sifinterfaces">
		select
			 Cconcepto
			,  Periodo
			,  Mes
			,  Fecha_Emision
			,  Descripcion_Nomina
			,  Num_Nomina
			,  Nomina_Ref 
			,  getdate() as Falta
			,  ECIreversible
			,  Cancelacion
		from IE925 E
		where ID = #GvarID#
	</cfquery>
	
	<cfif rsVariables.recordcount EQ 0>
		<cfthrow message="Se envio un Asiento sin registro de control">
	</cfif>

	<cfset LvarCconcepto      = rsVariables.Cconcepto>
	<cfset LvarPeriodo       = rsVariables.Periodo>
	<cfset LvarMes           = rsVariables.Mes>
	<cfset LvarFecha         = createODBCdate(rsVariables.Fecha_Emision)>
	<cfset LvarDescripcion   = rsVariables.Descripcion_Nomina>
	<cfset LvarEdocbase       = rsVariables.Num_Nomina>
	<cfset LvarEreferencia    = rsVariables.Nomina_Ref>
	<cfset LvarFalta          = createODBCdatetime(rsVariables.Falta)>
	<cfset LvarECIreversible  = rsVariables.ECIreversible>
	<cfset LvarCancelacion    = rsVariables.Cancelacion>
	
	<cfquery name="rsControl" datasource="sifinterfaces">
		Select count(1) as Cantidad
		from ID925
		where ID = #GvarID#
	</cfquery>
	
	<cfif rsControl.Cantidad EQ 0>
		<cfthrow message="Se envio a procesar un Asiento sin datos (en blanco)!">
	</cfif>
	
	<!---Valida que no este desbalanceada la poliza---->
	<cfquery name="rsBalance" datasource="sifinterfaces">
		select round((select sum(Total_Linea) from ID925 where Tipo = 'C' and ID = #GvarID#) -
		(select sum(Total_Linea) from ID925 where Tipo = 'D' and ID = #GvarID#),2) as Diferencia 
	</cfquery>
	
	<cfif rsBalance.Diferencia GT 1>
		<cfthrow message="La Nómina esta desbalanceada por #rsBalance.Diferencia#">
	<cfelseif rsBalance.Diferencia NEQ 0 and rsBalance.Diferencia LTE 1 and rsBalance.Diferencia GTE -1>
		<cfset Dif = rsBalance.Diferencia>
		<cfif Dif GT 0>
			<cfset TipoM = 'D'>
			<cfset ImporteB = rsBalance.Diferencia>
		<cfelse>
			<cfset TipoM = 'C'>
			<cfset ImporteB = rsBalance.Diferencia * -1>
		</cfif>		
		
	
		<cfquery name="rsMaxD" datasource="#session.dsn#">
			select isnull(max(DConsecutivo),0) + 1 as MaxD 
			from #LvarID925#
			where ID = #GvarID#
		</cfquery>
		
		<cfif rsMaxD.MaxD GT 0>
			<cfset MaxD = rsMaxD.MaxD> 
		</cfif>
		
		<cfquery name="rsOfiMon" datasource="#session.dsn#">
			select top 1 Oficodigo, Miso4217
			from #LvarID925#
			where ID = #GvarID#
		</cfquery>
		
		<cfquery name="rsCFuncional" datasource="#session.dsn#">
			select CFid
			from CFuncional
			where CFcodigo = 'RAIZ'
		</cfquery>
		
		<cfif rsCFuncional.recordcount GT 0>
			<cfset CtroFun = rsCFuncional.CFid>
		<cfelse>
			<cfthrow message="No existe el centro funcional Raiz en el sistema">
		</cfif>
		
		<!---Se obtiene la cuenta--->
		<cfquery name="rsCuentaB" datasource="#session.dsn#">
			select CFformato, Pvalor from Parametros P
			inner join CFinanciera F on P.Pvalor = F.CFcuenta
			where Pcodigo = 25
		</cfquery>
		
		<cfif rsCuentaB.recordcount GT 0>
			<cfset CuentaBal = 	rsCuentaB.CFformato>
		<cfelse>
			<cfthrow message="No esta parametrizada la Cuenta Financiera de Balance para ajustar diferencias de tipos de cambio">
		</cfif>
		
		<cfquery datasource="#session.dsn#">
			insert into #LvarID925#
						(ID,
						DConsecutivo,
						Ecodigo,
						CConcepto,
						Concepto,
						Descripcion_Detalle,
						Tipo,
						Total_Linea,
						CFformato,
						CFuncional,
						Oficodigo,
						Miso4217,
						Genera_Orden,
						Gasto)
			     values (#GvarID#,
				 		 #MaxD#,
						 #session.ecodigo#,
						 '',
						 '',
						 'BALANCEO CENTAVOS',
						 '#TipoM#',
						<!--- <cfif Dif GT 0>
							 round(#Dif#,2),
						 <cfelse>
						 	 round(convert(integer,#Dif#) * -1),2),
						 </cfif>--->
						 round(#ImporteB#,2),
						 '#CuentaBal#',
						 #CtroFun#,
						 '#rsOfiMon.Oficodigo#',
						 '#rsOfiMon.Miso4217#',
						 0,
						 0)
			</cfquery>
	</cfif>

	<!--- 
		Procesar las cuentas que llegan sin cuenta financiera
		Si tienen cuenta financiera no se procesan en el ciclo, porque ya están listas! 
	--->

	<cfquery datasource="#session.dsn#">
		insert into #CFformatos# 
			(CFformatoSF, CFcuenta, Ccuenta)
		select 
			CFformato, 
			max(coalesce(CFcuenta, 0)), max(coalesce(Ccuenta, 0))
		from #LvarID925#
		where ID = #GvarID#
		group by CFformato
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update #CFformatos# 
			set 
				CmayorSF = <cf_dbfunction name="sPart"	args="CFformato, 2, 3">, 
				CdetSF   = <cf_dbfunction name="sPart"	args="CFformato, 5, 100">
	</cfquery>

	<!--- Actualizar las cuentas que no tienen guiones. Formato similar a Versión 5 de SIF --->
	<cfquery datasource="#session.DSN#">
			update #CFformatos#
			set CFcuenta = ( 
					select min(cf.CFcuenta)
					from CFinanciera cf
					where cf.CmayorSF  = #CFformatos#.CmayorSF
					  and cf.CdetSF  = #CFformatos#.CdetSF 
					  and cf.Ecodigo =  #session.ecodigo# 
					)
		where CFformatoSF NOT LIKE '%-%'
		  and CFcuenta = 0
	</cfquery>

	<!--- Actualizar las cuentas que tienen guiones. Formato de Version 6 de SIF  --->
	<cfquery datasource="#session.DSN#">
			update #CFformatos#
			set CFcuenta = ( 
					select min(cf.CFcuenta)
					from CFinanciera cf
					where cf.CFformato  = #CFformatos#.CFformatoSF
					  and cf.Ecodigo    =  #session.ecodigo# 
					)
		where CFformatoSF LIKE '%-%'
		  and CFcuenta = 0
	</cfquery>

	<!--- Actualizar el campo Ccuenta de las cuentas que tienen CFcuenta --->
	<cfquery datasource="#session.DSN#">
		update #CFformatos#
		set Ccuenta = ( 
				select min(cf.Ccuenta)
				from CFinanciera cf
				where cf.CFcuenta  = #CFformatos#.CFcuenta
				)
		where CFcuenta is not null
		  and CFcuenta > 0
	</cfquery>

	<!--- Actualizar el campo Ccuenta de las cuentas que tienen CFcuenta --->
	<cfquery datasource="#session.DSN#">
		update #CFformatos#
		set CFformato = ( 
				select min(cf.CFformato)
				from CFinanciera cf
				where cf.CFcuenta  = #CFformatos#.CFcuenta
				)
		where CFcuenta is not null
	</cfquery>
					
	<!--- Actualiza Ccuenta y CFcuenta en la tabla ID18 --->
	<cfquery datasource="#session.dsn#">
		update #LvarID925#
		set  Ccuenta  = (( select min(cf.Ccuenta)  from #CFformatos# cf where cf.CFformatoSF = #LvarID925#.CFformato )),
			 CFcuenta = (( select min(cf.CFcuenta) from #CFformatos# cf where cf.CFformatoSF = #LvarID925#.CFformato ))
		where ID = #GvarID#
		  and CFcuenta is null
	</cfquery>			

	<!--- Actualiza CFformato en la tabla ID925 si la cuenta no es nula y el formato de cuenta no tiene guiones --->
	<cfquery datasource="#session.dsn#">
		update #LvarID925#
		set  CFformato  = (( select min(cf.CFformato) from #CFformatos# cf where cf.CFcuenta = #LvarID925#.CFcuenta ))
		where ID = #GvarID#
		  and CFcuenta is not null
	</cfquery>			
		
	<!--- 
		Verifica si algún CFcuenta esta en nulo y no tiene guiones en el formato...
		En este caso, coloca los guiones en la cuenta según la máscara de la cuenta
	--->
			
	<cfquery name="rsFormatos" datasource="sifinterfaces">
		select distinct CFformato
		from ID925
		where ID = #GvarID#
		  and CFcuenta is null
		  and CFformato NOT LIKE '%-%'
	</cfquery>

	<cfloop query="rsFormatos">

		<!--- Obtiene la cuenta mayor --->
		<cfset LvarCuentaMayor = Mid(rsFormatos.CFformato,1,4)>
		<cfset LvarCuentaControl = rsFormatos.CFformato>
		<cfset LvarCuentaTotal = rsFormatos.CFformato>
		
		<!--- OBTIENE LA MASCARA DE LA CUENTA --->
		<cfquery name="rsMascara" datasource="#session.DSN#">
			select  CPVformatoF 
			from CPVigencia
			where Ecodigo =   #session.ecodigo#
			  and Cmayor  =  '#LvarCuentaMayor#'
		</cfquery>
		
		<cfif rsMascara.recordcount eq 0>
			<cfthrow message="No existe mascara para la cuenta contable #LvarCuentaMayor#">
		</cfif>
		
		<cfset Mascara = rsMascara.CPVformatoF>
		<cfset Cuenta="">
		
		<cfloop condition="find('-',Mascara,1) GT 0">
		
			<cfset pos = find("-",Mascara,1)>
			<cfset subhilera = Mid(LvarCuentaTotal,1,pos-1)>
			<cfset LvarCuentaTotal = Mid(LvarCuentaTotal,pos,len(LvarCuentaTotal))>
			<cfset Mascara = Mid(Mascara,pos+1,len(Mascara))>
		
			<cfif Cuenta eq "">
				<cfset Cuenta = subhilera>
			<cfelse>
				<cfset Cuenta = Cuenta & "-" & subhilera>
			</cfif>
		
		</cfloop>

		<cfset Cuenta = Cuenta & "-" & LvarCuentaTotal>
		
		<cfloop condition="Mid(Cuenta,len(Cuenta),1) EQ '-'">
			<cfset Cuenta = Mid(Cuenta,1,len(Cuenta)-1)>			
		</cfloop>
		
		<cfquery datasource="sifinterfaces">
			update ID925
			set CFformato   = '#Cuenta#'
			where CFformato = '#LvarCuentaControl#'
			  and ID = #GvarID#
			  and CFcuenta is null
		</cfquery>
	</cfloop>

	<!--- Actualiza la Oficina --->
	<cfquery name="rsActualiza" datasource="sifinterfaces">
		select distinct Oficodigo
		from ID925
		where ID = #GvarID#
		  and Oficodigo is not null
	</cfquery>
	
	<cfloop query="rsActualiza">
		<cfset LvarOficodigo = rsActualiza.Oficodigo>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select Ocodigo
			from Oficinas
			where Ecodigo   = #session.Ecodigo#
			  and Oficodigo = '#LvarOficodigo#'
		</cfquery>
		<cfif rsDatos.recordcount GT 0>
			<cfset LvarOcodigo = rsDatos.Ocodigo>
			<!---<cfquery datasource="sifinterfaces">
				update ID925
				set Ocodigo = #LvarOcodigo#
				where ID = #GvarID#
				  and Oficodigo is not null
				  and Oficodigo = '#LvarOficodigo#'
			</cfquery>--->
		</cfif>
	</cfloop>

	<!--- Actualiza la Moneda --->
	<cfquery name="rsActualiza" datasource="sifinterfaces">
		select distinct Miso4217
		from ID925
		where ID = #GvarID#
		and Miso4217 is not null
	</cfquery>
	
	<cfloop query="rsActualiza">
		<cfset LvarMiso4217 = rsActualiza.Miso4217>
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select Mcodigo
			from Monedas
			where Ecodigo   = #session.Ecodigo#
			  and Miso4217  = '#LvarMiso4217#'
		</cfquery>
		<cfif rsDatos.recordcount GT 0>
			<cfset LvarMcodigo = rsDatos.Mcodigo>
			<!---<cfquery datasource="sifinterfaces">
				update ID925
				set Mcodigo = #LvarMcodigo#
				where ID = #GvarID#
				  and Miso4217 is not null
				  and Miso4217 = '#LvarMiso4217#'
			</cfquery>--->
		</cfif>
	</cfloop>

	<cfquery name="rsTotales" datasource="sifinterfaces">
		select
			sum(case when Tipo = 'D' then Total_Linea else 0.00 end) as Debitos,
			sum(case when Tipo = 'C' then Total_Linea else 0.00 end) as Creditos,
			count(1) as Cantidad
		from ID925
		where ID = #GvarID#
	</cfquery>
	<cfset LvarTotalDebitos = rsTotales.Debitos>
	<cfset LvarTotalCreditos = rsTotales.Creditos>
	<cfset LvarTotalRegistros = rsTotales.Cantidad>
	
	<cfif not LvarCancelacion>
		<cfquery name="rsOrdenes" datasource="sifinterfaces">
	   		select * from ID925
			where Genera_Orden = 1
			and ID = #GvarID#
			order by Empleado, Gasto asc 
		</cfquery>
	<cfelse>
		<cfquery name="rsOrdenes" datasource="sifinterfaces">
   			select * from ID925
			where Genera_Orden = 1
			and ID = coalesce((select ID from IE925 where Num_Nomina = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEreferencia#">),0)
			order by Empleado, Gasto asc 
		</cfquery>
	</cfif>
   
   <!---Valida que no este activo el parametro  de Validar compromiso por cuenta presupuestal--->
   	<cfquery name="rsValidaCtaPptal" datasource="#session.dsn#">
		select Pvalor 
		from Parametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 1131
	</cfquery>
	
	<cfif isdefined("rsValidaCtaPptal") and rsValidaCtaPptal.Pvalor EQ 'S' and not LvarCancelacion>
		<cfset PerMes = #LvarPeriodo#*100+#LvarMes#>
		
		<cfinvoke component="sif.presupuesto.Componentes.PRES_ValidaPptoCompromiso" method="Valida_CompromisoSuficiente">
			<cfinvokeargument name="ID" value="#GvarID#">
			<cfinvokeargument name="Num_Nomina" value="#LvarEdocbase#">
			<cfinvokeargument name="Fecha_Nom" value="#LvarFecha#">
			<cfinvokeargument name="PerMes" value="#PerMes#">		
			<cfinvokeargument name="Periodo" value="#LvarPeriodo#">		
			<cfinvokeargument name="Mes" value="#LvarMes#">		
        </cfinvoke>

		<cfquery name="rsValidaNRC" datasource="sifinterfaces">
			select count(*) as NRCs
			from NRCE_Nomina 
			where NRC_NumNomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEdocbase#">))	
		</cfquery>
		
		<cfif rsValidaNRC.NRCs GT 0>
			<cfthrow message="Existen errores de compromiso, consulte el detalle en la Interfaz de Nómina">
		</cfif>
	</cfif>
    
     	
   	<!--- Si es una cancelación adicionalmente a la póliza contable hace la cancelación de la Orden de Pago siempre y cuando la Orden de pago se encuentre antes de enviar a emitir.---->
	<cftransaction action="begin">   
		<cfif LvarCancelacion> 
			<cfloop query="rsOrdenes"> 
			  <cfif not rsOrdenes.Gasto>
				 	<cfquery name="rsNominaAnt" datasource="#session.DSN#">
			   			select Id_Solicitud, Num_Nomina
						from #sifinterfacesdb#..IE926 E
						inner join #sifinterfacesdb#..ID926 D on E.ID = D.ID
						where D.ReferenciaOri = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEreferencia#">
						and E.Empleado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOrdenes.Empleado#"> <!--- JMRV --->
						and D.Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOrdenes.Descripcion_Detalle#"> <!--- JMRV --->
						and D.Total_Linea = <cfqueryparam cfsqltype="cf_sql_money" value="#rsOrdenes.Total_Linea#">
		   			</cfquery>

					<cfif isdefined("rsNominaAnt") and rsNominaAnt.Id_Solicitud NEQ ''>
					   	<cfset NumSolAnt = rsNominaAnt.Id_Solicitud>
					<cfelse>
						<cfthrow message="La Nómina que desea cancelar no se ha procesado en el SIF">
					</cfif>
		 
					<cftry>
						<cfquery name="rsOrdenesPago" datasource="#session.DSN#">
							select S.TESSPid as Solicitud, O.TESOPid as Orden, D.TESDPid as Detalle
							from TESsolicitudPago S 
							inner join TESdetallePago D on S.TESSPid = D.TESSPid 
							inner join TESordenPago O on O.TESOPid = D.TESOPid
							where S.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NumSolAnt#">
							and S.TESSPestado = 10
							and D.TESDPestado = 10
							and TESOPestado = 10
						</cfquery>
						
						<cfif rsOrdenesPago.recordcount GT 0>
							<cfloop query="rsOrdenesPago">
								<cfset Solicitud = rsOrdenesPago.Solicitud>
								<cfset OrdenPago = rsOrdenesPago.Orden>
								<cfset Detalles = rsOrdenesPago.Detalle>
				
								<!---ACTUALIZA LA ORDEN DE PAGO A CANCELADA--->
								<cfquery datasource="#session.DSN#">
									update TESordenPago 
									set TESOPestado = 13,
									TESOPmsgRechazo = 'Cancelación de Nomina',
									TESOPfechaCancelacion = <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
									UsucodigoCancelacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">
									where TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#OrdenPago#">				
								</cfquery>
			
								<!---ACTUALIZA LOS DETALLES DE LA ORDEN Y LA SOLICITUD--->
								<cfquery datasource="#session.DSN#">
									update TESdetallePago 
									set TESDPestado = 13,
									TESOPid = null,
									TESDPfechaPago = null,
									TESDPtipoCambioOri = null,
									TESDPmontoAprobadoLocal = null,
									EcodigoPago = null,
									TESDPfactorConversion = null,
									TESDPmontoPago = null,
									TESDPmontoPagoLocal = null
									where TESDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Detalles#">	
									and TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Solicitud#">	
								</cfquery>
								<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
								<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn,false,false,true)/>
						
								<cfquery name="rsSP" datasource="#session.DSN#">
									select 	sp.TESSPid
		 							,	sp.EcodigoOri
									,	sp.TESSPnumero
						   			, sp.TESSPestado
									,	coalesce(sp.NAP, 0) as NAP
					            			,	(select CPNAPmoduloOri from CPNAP where Ecodigo=sp.EcodigoOri and CPNAPnum=sp.NAP) as CPNAPmoduloOri
					            			,	(select CPNAPdocumentoOri from CPNAP where Ecodigo=sp.EcodigoOri and CPNAPnum=sp.NAP) as CPNAPdocumentoOri
									,	TESSPtipoDocumento
				  					from TESsolicitudPago sp
						  			left join TESordenPago op
										on op.TESOPid = sp.TESOPid
				 					where sp.TESSPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Solicitud#">	
								</cfquery>

								<cfloop query="rsSP">
									<cfif not listfind("2,10,11", rsSP.TESSPestado)>
										<cf_errorCode	code = "50756"
											msg  = "La Solicitud de Pago Num. '@errorDat_1@' está en estado '@errorDat_2@' y no puede ser rechazada"
											errorDat_1="#rsSP.TESSPnumero#"
											errorDat_2="#rsSP.ESTADO#">
									</cfif>

									<!---
												
										CONTROL DE PRESUPUESTO
									--->	
									<cfif rsSP.NAP NEQ "0">
										<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
											select Pvalor
											from Parametros
											where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
										</cfquery>
		
										<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
											select Pvalor
											from Parametros
											where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
										</cfquery>
			
										<cfquery datasource="#session.DSN#">
											delete from #request.IntPresupuesto#
										</cfquery>

										<cfif rsSP.CPNAPmoduloOri EQ "TESP">
						          				<cfset LvarDoc = rsSP.TESSPnumero>
										<cfelse>
						         				<cfset LvarDoc = rsSP.CPNAPdocumentoOri>
						        			</cfif>

										<cfset LvarNAP = LobjControl.fnReversarNAPcompleto 
													(
														"TESP", 
														rsSP.TESSPnumero, 
														'SP,RECHAZO', 
							
														now(), 
														rsPeriodoAuxiliar.Pvalor,
														rsMesAuxiliar.Pvalor,
														
														rsSP.NAP, 
														#LvarDoc#, 
														
														#session.DSN#, rsSP.EcodigoOri,
														rsSP.CPNAPmoduloOri
													)>
			
										<cfif LvarNAP GTE 0>
											<!--- Devuelve la Suficiencia --->
											<cfquery datasource="#session.dsn#">
												update CPDocumentoD
												set CPDDsaldo = CPDDsaldo + 
															(
															 select sum(
															 		round(round(abs(dp.TESDPmontoAprobadoOri),2) * dp.TESDPtipoCambioSP,2) 
															 	    )
															 from TESdetallePago dp
															 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.TESSPid#">
															 and CPDDid = CPDocumentoD.CPDDid
															)
												 where Ecodigo = #session.Ecodigo#
												 and 	(
													 select count(1)
													   from TESdetallePago dp
														inner join CFinanciera cf
															left join CPresupuesto cp
															   on cp.CPcuenta = cf.CPcuenta
															inner join CtasMayor m
																 on m.Ecodigo	= cf.Ecodigo
																and m.Cmayor	= cf.Cmayor
															  on cf.CFcuenta = dp.CFcuentaDB
															 and cf.Ecodigo	 = dp.EcodigoOri
													  where dp.TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.TESSPid#">
														and dp.CPDDid = CPDocumentoD.CPDDid
												 	) > 0
											</cfquery>
										<cfelse>		
											<cfquery datasource="#session.dsn#">
												update TESsolicitudPago 
												set NRP = #abs(LvarNAP)#
												where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSP.TESSPid#">
												and EcodigoOri = #session.Ecodigo#
											</cfquery>
											<!---<cftransaction action="commit" />--->
											<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
										</cfif>
									</cfif>
								</cfloop>
								<!--- FIN CONTROL DE PRESUPUESTO --->
					
										
								<!---		<cfinvoke component		= "sif.tesoreria.Componentes.TESaplicacion"
											method			= "sbRechazarSPaprobada"
							
											DSN			= "#session.DSN#"
											Ecodigo			= "#session.Ecodigo#"
											TESSPid			= "#Solicitud#"
											TESOPid			= "-1"
											TESSPmsgRechazo	= "Cancelación de Nomina"
								>--->
					
								<cfquery datasource="#session.DSN#">		
									update TESsolicitudPago
									set TESSPestado = 23,
									TESSPmsgRechazo = 'Cancelación de Nomina',
									TESOPid = null,
									CBid = null,
									TESMPcodigo = null,
									EcodigoSP = null,
									TESOPfechaPago = null,
									TESSPfechaRechazo = null,
									UsucodigoRechazo = null
									where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Solicitud#">	
								</cfquery>
							</cfloop>
						<cfelse>
							<cfthrow message="La orden de pago debe estar en estatus de generada, es decir antes de enviar a emitir para poder ser cancelada.">
						</cfif>	
					<cfcatch type="any">
						<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
						<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
			      			<cfthrow message="Error al eliminar la solicitud: #cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
					</cfcatch>
					</cftry>
				</cfif>			
			</cfloop>		
		</cfif>
	
		<!--- Insercion en la Tabla de Interfaz de Asientos (Encabezado) --->
		<cfquery name="rsInput" datasource="#session.DSN#">
			insert into EContablesImportacion 
			(
				   Ecodigo
				,  Cconcepto
				,  Eperiodo
				,  Emes
				,  Efecha
				,  Edescripcion
				,  Edocbase
				,  Ereferencia
				,  BMfalta
				,  BMUsucodigo
				,  ECIreversible
				,  Oorigen
			)
			values (
				   #Session.Ecodigo#
				,  #LvarCconcepto#
				,  #LvarPeriodo#
				,  #LvarMes#
				,  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDescripcion#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEdocbase#">
				,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEreferencia#">
				,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFalta#">
				,  #Session.Usucodigo#
				,  #LvarECIreversible#
				,  'TEPN'
				)
			<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInput" verificar_transaccion="false">
	
		<cfif rsInput.recordCount EQ 0>
			<cftransaction action="rollback"/>
			<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 925=Interfaz de Asientos Contables">
		</cfif>
		<cfset ECImp_id = rsInput.identity>

		<!--- JMRV. 13/01/2015. Inicio. --->
			<!--- Obtiene la moneda local --->
			<cfquery name="rsMonedaL" datasource="#session.dsn#">
				select m.Miso4217
				from Monedas m
				inner join Empresas e
				on m.Ecodigo = e.Ecodigo and m.Mcodigo = e.Mcodigo
				where e.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			</cfquery>
			<cfif isdefined("rsMonedaL") and rsMonedaL.recordcount EQ 1>
				<cfset varMonedaL = rsMonedaL.Miso4217>
			<cfelse>
				<cfthrow message="Error al Obtener la Moneda Local de la empresa: #session.Ecodigo#">
			</cfif>	

			<!--- Obtiene el tipo de cambio --->
			<cfif isDefined("varMonedaL") and varMonedaL NEQ LvarMiso4217>
				<cfquery name="rsTipoCambio" datasource="#session.dsn#">
					select top 1 htc.TCpromedio as tipoCambio 
					from 	Htipocambio htc
						inner join 	Monedas m
								on htc.Ecodigo = m.Ecodigo
								and htc.Mcodigo = m.Mcodigo
					where htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and m.Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMiso4217#">
					and htc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
					and htc.Hfechah  > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">
					order by htc.Hfecha desc
				</cfquery>
				<cfif isdefined("rsTipoCambio") and rsTipoCambio.recordcount EQ 1>
					<cfset varTipoCambio = rsTipoCambio.tipoCambio>
				<cfelse>
					<cfthrow message="Error al Obtener el tipo de cambio para la moneda #LvarMiso4217#">
				</cfif>	
			<cfelse>
				<cfset varTipoCambio = 1>
			</cfif>  
		<!--- JMRV. 13/01/2015. Fin. --->
		
		<!--- Insercion en la Tabla de Interfaz de Asientos (Detalle) --->
		<cfquery name="rsInput" datasource="#session.DSN#">
			INSERT into DContablesImportacion (			  
				  ECIid, 				DCIconsecutivo,			  Ecodigo,				  DCIEfecha,
				  Eperiodo,				Emes,					  Ddescripcion,			  Ddocumento,
				  Dreferencia,			Dmovimiento,			  CFformato,			  Ccuenta,
				  CFcuenta,				Ocodigo,				  Mcodigo,				  Doriginal,
				  Dlocal,				Dtipocambio,			  Cconcepto,			  BMfalta,
				  BMUsucodigo,			EcodigoRef,				  Referencia1,			  Referencia2,
				  Referencia3, 			CFid, 					  CFcodigo
			)
			select	#ECImp_id#, 		a.DConsecutivo,		a.Ecodigo, 			#LvarFecha#
					, #LvarPeriodo#, 	#LvarMes#, 				a.Descripcion_Detalle, 	'#LvarEdocbase#'
					, null,				a.Tipo, 			    a.CFformato, 		a.Ccuenta
					, a.CFcuenta, 		#LvarOcodigo#, 			#LvarMcodigo#, 		a.Total_Linea
					, round( Total_Linea * #varTipoCambio#, 2 ), 	#varTipoCambio#,	a.CConcepto, 		#LvarFalta#
					, #Session.Usucodigo#, a.Ecodigo, 			null, 		 		null
					, null
					,    <cf_jdbcquery_param cfsqltype="cf_sql_decimal" value="null">,					null
			  from #LvarID925# a
			 where ID = #GvarID#
		</cfquery>

		<!--- **************************************** --->
		<!---      Insercion en la tabla intermedia.   --->
		<!--- **************************************** --->
		
		<cfquery name="rsEncInterfaz925" datasource="#session.DSN#">
			select count(1) as Cantidad
			from EContablesInterfaz18
			where ID = #GvarID#
		</cfquery>
		
		<cfif rsEncInterfaz925.Cantidad GT 0>
			<cfthrow message="Error, El ID #GvarID# ingresado ya existe!">
		</cfif>

	
		<cfquery datasource="#session.DSN#">
			insert into EContablesInterfaz18 ( ID,	ECIid,	Ecodigo,   ImpFecha,	ImpPeriodo,	ImpMes, BMUsucodigo, ASTPorProcesar)
			values
			(
				#GvarID#,
				#ECImp_id#,
				#session.ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				#LvarPeriodo#,
				#LvarMes#,
				#Session.Usucodigo#,
				1
			)
		</cfquery>
       
	   <!--- Consulta para verificar si se tiene que aplicar el asiento importado --->
       <cfquery name="rsPvalor" datasource="#session.DSN#">
	      select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 2400
	   </cfquery>
	   <cfif rsPvalor.Pvalor eq 1>	   
	     <cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
			<cfinvokeargument name="ECIid" value="#ECImp_id#">
			<cfinvokeargument name="TransaccionActiva" value="true">
         </cfinvoke>	   
	   </cfif>	   
	   
		<!----GENERA ORDENES DE PAGO
		<cfif not LvarCancelacion>
	   		<cfinvoke component="interfacesSoin.Componentes.TS_GeneraSolicitudPago" method="TS_GeneraSolicitud" returnvariable="Solicitud"> 
				<cfinvokeargument name="query" value="#rsOrdenes#">	
				<cfinvokeargument name="Fecha" value="#LvarFecha#">
				<cfinvokeargument name="Documento" value="#LvarEdocbase#">
				<cfinvokeargument name="Ocodigo" value="#LvarOcodigo#">	
			</cfinvoke>
		</cfif>
		---->
		<!---<cfloop query="rsOrdenes">   VERIFICAR SI SE NECESITA--->
	    <cfif isdefined("rsOrdenes") and rsOrdenes.recordcount GT 0>
			<!---Actualiza el estatus del historico de Nómina--->	 
		   	<cfquery datasource="#session.DSN#">
				update #sifinterfacesdb#..Enc_Pago_Nomina 
				set Estatus_Provision = 2
				where Num_Nomina = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEdocbase#">))
			</cfquery>			
		</cfif>
	   <!--- </cfloop>--->
	<cftransaction action="commit"/>  
	</cftransaction>
		
	<cfquery name="rsControlInt" datasource="sifinterfaces">
			UPDATE ControlInterfaz18
			set ProcesoInt   = 1,
				DebitosInt   = #LvarTotalDebitos#,
				CreditosInt  = #LvarTotalCreditos#,
				NumLineasInt = #LvarTotalRegistros#
			where ID = #GvarID#
	</cfquery>
	
	<!----INSERTA EL REGISTRO DE LA NOMINA EN TABLAS DE HISTORICO--->
	<!---<cfquery datasource="sifinterfaces">
		insert into HPS_PMI_GL_HEADER
		select * from PS_PMI_GL_HEADER
	</cfquery>
	
	<cfquery datasource="sifinterfaces">
		insert into HPS_PMI_GL_DET_NOM
		select * from PS_PMI_GL_DET_NOM
	</cfquery>--->

	<cfquery datasource="#session.DSN#">
		delete from #CFformatos#
	</cfquery>

<!---	<cfquery datasource="sifinterfaces">
		delete PS_PMI_GL_DET_NOM
	</cfquery>
	
	<cfquery datasource="sifinterfaces">
		delete PS_PMI_GL_HEADER
	</cfquery>	--->

<!---	<cfquery datasource="peoplesoft">
		delete PS_PMI_GL_DET_NOM
	</cfquery>
	
	<cfquery datasource="peoplesoft">
		delete PS_PMI_GL_HEADER
	</cfquery>--->
<cfelse>
	<cfthrow message="El registro ya fue procesado anteriormente">    
</cfif>

