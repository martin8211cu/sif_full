<cfcomponent>
	<cffunction name="PosteoRelacion" access="public" output="true" >
		<cfargument name="conexion" 		type="string" 	required="no" default="#Session.DSN#">		
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
		<cfargument name="RCNid"   			type="numeric" 	required="yes">
		<cfargument name="CBcc"   			type="string" 	required="yes">
		<cfargument name="Usucodigo" 		type="numeric" 	required="yes" default="#session.Usucodigo#">
		<cfargument name="Ulocalizacion" 	type="string" 	required="no" default="00">
		<cfargument name="debug" 			type="boolean" 	required="no" default="false">

		<!--- Procedimiento de Aplicación de una Relación de Cálculo de Nómina 
		** Hecho por: Jenner Císar Montero. 
		** Fecha: 24 de Junio del 2003 
		** 
		** Este procedimiento pasa a las tablas de Pago los datos obtenidos 
		** en el cálculo de una relación de nómina. 
		--->
	
		<!--- TABLAS TEMPORALES A UTILIZAR --->
		<!--- ENCABEZADO DE RECEPCION DE NOMINA ---> 
		<cf_dbtemp name="ERNominav1" returnvariable="ERNomina" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="ERNid" 			type="numeric" 		mandatory="yes"	identity="yes">
			<cf_dbtempcol name="Ecodigo" 		type="int" 			mandatory="no">
			<cf_dbtempcol name="Tcodigo" 		type="char(5)"  	mandatory="no">
			<cf_dbtempcol name="Bid" 			type="numeric" 		mandatory="no">
			<cf_dbtempcol name="CBcc" 			type="char(25)"  	mandatory="no">
			<cf_dbtempcol name="ERNcuenta" 		type="char(25)" 	mandatory="no">
			<cf_dbtempcol name="CBTcodigo" 		type="numeric" 		mandatory="no">
			<cf_dbtempcol name="Mcodigo" 		type="numeric" 		mandatory="no">
			<cf_dbtempcol name="ERNfcarga" 		type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNfdeposito" 	type="datetime"  	mandatory="no">
			<cf_dbtempcol name="ERNfinicio" 	type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNffin" 		type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNdescripcion" type="varchar(100)" mandatory="no">
			<cf_dbtempcol name="ERNestado" 		type="int" 			mandatory="no">
			<cf_dbtempcol name="Usucodigo" 		type="numeric" 		mandatory="no">
			<cf_dbtempcol name="Ulocalizacion" 	type="char(2)" 		mandatory="no">
			<cf_dbtempcol name="ERNusuverifica" type="numeric" 		mandatory="no">
			<cf_dbtempcol name="ERNfverifica" 	type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNusuautoriza" type="numeric" 		mandatory="no">
			<cf_dbtempcol name="ERNfautoriza" 	type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNfechapago" 	type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNfprogramacion" type="datetime" 	mandatory="no">
			<cf_dbtempcol name="ERNsistema" 	type="int"  		mandatory="yes" >
			<cf_dbtempcol name="ERNcapturado" 	type="int"  		mandatory="yes">
			<cf_dbtempcol name="RCtc" 			type="float"  		mandatory="no">
		</cf_dbtemp>

 		<!--- DETALLE DE RECEPCION DE NOMINA --->
		<cf_dbtemp name="DRNominav1" returnvariable="DRNomina" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DRNlinea" 			type="numeric" 		mandatory="yes"	identity="yes">
			<cf_dbtempcol name="ERNid" 				type="numeric" 		mandatory="no">
			<cf_dbtempcol name="NTIcodigo" 			type="char(1)" 		mandatory="no">
			<cf_dbtempcol name="DRIdentificacion" 	type="varchar(60)" 	mandatory="no">
			<cf_dbtempcol name="Bid" 				type="numeric" 		mandatory="no"> 
			<cf_dbtempcol name="DEid" 				type="numeric" 		mandatory="no">
			<cf_dbtempcol name="DRNcuenta" 			type="char(25)" 	mandatory="no">
			<cf_dbtempcol name="CBcc" 				type="char(25)" 	mandatory="no">
			<cf_dbtempcol name="CBTcodigo" 			type="numeric" 		mandatory="no">
			<cf_dbtempcol name="Mcodigo" 			type="numeric" 		mandatory="no">
			<cf_dbtempcol name="DRNnombre" 			type="varchar(60)" 	mandatory="no">
			<cf_dbtempcol name="DRNapellido1" 		type="varchar(60)" 	mandatory="no">
			<cf_dbtempcol name="DRNapellido2" 		type="varchar(60)" 	mandatory="no">
			<cf_dbtempcol name="DRNtipopago" 		type="char(2)" 		mandatory="no">
			<cf_dbtempcol name="DRNperiodo" 		type="datetime" 	mandatory="no">
			<cf_dbtempcol name="DRNnumdias" 		type="int" 			mandatory="no">
			<cf_dbtempcol name="DRNsalbruto" 		type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNsaladicional" 	type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNreintegro" 		type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNrenta" 			type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNobrero" 			type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNpatrono" 		type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNotrasdeduc" 		type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNliquido" 		type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNpuesto" 			type="char(10)" 	mandatory="no">
			<cf_dbtempcol name="DRNocupacion" 		type="char(10)" 	mandatory="no">
			<cf_dbtempcol name="DRNotrospatrono" 	type="money" 		mandatory="no">
			<cf_dbtempcol name="DRNfondopen" 		type="char(10)" 	mandatory="no">
			<cf_dbtempcol name="DRNfondocap" 		type="char(10)" 	mandatory="no">
			<cf_dbtempcol name="DRNinclexcl" 		type="int" 			mandatory="no">
			<cf_dbtempcol name="DRNfinclexcl" 		type="datetime" 	mandatory="no">
			<cf_dbtempcol name="DRNestado" 			type="int" 			mandatory="no">
			<cf_dbtempcol name="DRNper" 			type="int" 			mandatory="no">
			<cf_dbtempcol name="DRNmes" 			type="int" 			mandatory="no">
		</cf_dbtemp>
		
		<!--- ALGUNAS VARIABLES --->
			<cfset vBid 				= ''>
			<cfset vCBid 				= ''>
			<cfset vPPeriodo 			= ''>
			<cfset vPMes 				= ''> 
			<cfset vSalLiquido 			= ''> 
			<cfset vSaldoInicial 		= ''> 
			<cfset vMovimientoCuenta 	= ''> 
			<cfset vDispCuenta 			= ''> 
			<cfset vDRNlinea 			= ''>  
			<cfset vDEid 				= ''> 
			<cfset vERNcuenta 			= ''> 
			<cfset vCBTcodigo 			= ''> 
			<cfset vMcodigo 			= ''> 
			<cfset vNewDRNlinea 		= ''> 
			<cfset vERNid 				= 0>	<!--- Consecutivo de la Relación ---> 
			<cfset vtdebug 				= ''> 
			<cfset vTcodigo 			= ''>   <!--- Tipo de Nómina --->
			<cfset vRCdesde 			= ''>   <!--- Fecha desde de la Relación de Cálculo --->
			<cfset vRCHasta 			= ''>   <!--- Fecha hasta de la Relación de Cálculo --->
			<cfset vRCdesdec 			= ''>   <!--- Fecha desde de la Relación de Cálculo (char) --->
			<cfset vRChastac 			= ''>   <!--- Fecha hasta de la Relación de Cálculo (char) --->
		    <cfset vInterfazBanco 		= ''>
    		<cfset vInterfazConta 		= ''>
			
			<cfquery name="rsPR_datos1" datasource="#arguments.conexion#">
				select  Tcodigo,  RCdesde, RChasta
				from RCalculoNomina  
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
			<cfset vTcodigo = rsPR_datos1.Tcodigo>  
			<cfset vRCdesde = rsPR_datos1.RCdesde>  
			<cfset vRChasta = rsPR_datos1.RChasta>
			<cfset vRCdesdec = LSdateFormat(rsPR_datos1.RCdesde, 'dd/mm/yyyy')>
			<cfset vRChastac = LSdateFormat(rsPR_datos1.RChasta, 'dd/mm/yyyy')>
			
			<!--- Validaciones Generales  --->
			<!--- Existencia de la Relación --->
			<cfquery name="rsPR_existe" datasource="#arguments.conexion#">
				select 1 
				from RCalculoNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
			<cfif rsPR_existe.recordcount eq 0 >
				<cfthrow message="No se existe la Relaci&oacute;n de N&oacute;mina.">
			</cfif>

			<!--- Existencia de Empleados --->
			<cfquery name="rsPR_existe" datasource="#arguments.conexion#">
				select coalesce(count(1),0) as total 
				from SalarioEmpleado 
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>
			<cfif rsPR_existe.total eq 0 >
				<cfthrow message="No se encontraron salarios de empleados calculados para la Relaci&oacute;n de Nómina.">
			</cfif>

			<!--- Existencia de Empleados sin calcular --->
			<cfquery name="rsPR_existe" datasource="#arguments.conexion#">
				select count(1) as total
				from SalarioEmpleado 
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				  and SEcalculado = 0
			</cfquery>	
			<cfif rsPR_existe.total gt 0 >
				<cfthrow message="Se encontraron salarios de empleados no calculados para la Relaci&oacute;n de N&oacute;mina." >
			</cfif>

			<!--- Existencia de Nominas pendientes anteriores --->
			<!--- SI ES NOMINA DE ANTICIPO --->
			<cfquery name="rsTipoNom" datasource="#session.DSN#">
				select CPtipo
				from CalendarioPagos
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>
			
			<cfif isdefined('rsTipoNom') and rsTipoNom.RecordCount and rsTipoNom.CPtipo EQ 2>
				<cfquery name="rsPR_existe" datasource="#arguments.conexion#">
					select 1 
					from RCalculoNomina a 
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
					  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vTcodigo#">
					  and a.RCdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#vRCdesde#">
					  and (not (<cfqueryparam cfsqltype="cf_sql_date" value="#vRCdesde#"> between a.RCdesde and a.RChasta)
					  and not (<cfqueryparam cfsqltype="cf_sql_date" value="#vRChasta#"> between a.RCdesde and a.RChasta))
					  and a.RCestado = 0
				</cfquery>
			<cfelse>
				<cfquery name="rsPR_existe" datasource="#arguments.conexion#">
					select 1 
					from RCalculoNomina a 
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
					  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vTcodigo#">
					  and a.RCdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#vRCdesde#"> 
					  and a.RCestado = 0
				</cfquery>	
			</cfif>
			<cfif rsPR_existe.recordcount gt 0 >
				<cfthrow message="Existe un proceso de n&oacute;mina anterior que no ha sido aplicado. La Relaci&oacute;n actual no puede aplicarse.">
			</cfif>

			<!--- Datos de la Cuenta Bancaria para el pago --->
			<cfquery name="rsPR_datos2" datasource="#arguments.conexion#">
				select Bid, CBid, CBTcodigo, CBcodigo, Mcodigo 
				from CuentasBancos 
				where CBcc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CBcc#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
                  and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>				
			<cfif rsPR_datos2.recordcount eq 0 >
				<cfthrow message="La Cuenta Bancaria para el proceso de pago no existe. Proceso cancelado.">
			</cfif>
			<cfset vBid 		= rsPR_datos2.Bid > 
			<cfset vCBid 		= rsPR_datos2.CBid >
			<cfset vCBTcodigo 	= rsPR_datos2.CBTcodigo >
			<cfset vERNcuenta 	= rsPR_datos2.CBcodigo > 
			<cfset vMcodigo 	= rsPR_datos2.Mcodigo >

			<!--- Período y mes vigentes en los sistemas --->
			<cfquery name="rsPR_datos3" datasource="#arguments.conexion#">
				select Pvalor 
				from Parametros 
				where Pcodigo = 50 
				   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
			</cfquery>	
			<cfset vPPeriodo = rsPR_datos3.Pvalor >
			 
			<cfquery name="rsPR_datos4" datasource="#arguments.conexion#">
				select Pvalor 
				from Parametros 
				where Pcodigo = 60 
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
			</cfquery>	
			<cfset vPMes = rsPR_datos4.Pvalor >
			 
			<cfset vtdebug = now() >
			
			<cfquery name="rsPR_datos5" datasource="#arguments.conexion#">
				select Pvalor 
				from RHParametros 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
				  and Pcodigo = 7 
			</cfquery>
			<cfset vInterfazBanco = rsPR_datos5.Pvalor >
			   
			<cfquery name="rsPR_datos6" datasource="#arguments.conexion#">
				select Pvalor 
				from RHParametros 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
				  and Pcodigo = 20 
			</cfquery>
			<cfset vInterfazConta = rsPR_datos6.Pvalor >
			
			<cfif vInterfazBanco neq '1' and vInterfazBanco neq '3' >
				<!--- Saldo inicial de la cuenta especificada para el pago de la nomina --->
				<cfquery name="rsPR_datos7" datasource="#arguments.conexion#">
					select coalesce(Sinicial,0) as Sinicial
					from SaldosBancarios 
					where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCBid#" > 
					  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPPeriodo#" >
					  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPMes#" >
				</cfquery>
				<cfif len(trim(rsPR_datos7.Sinicial)) >
					<cfset vSaldoInicial = rsPR_datos7.Sinicial >
				<cfelse>	
					<cfset vSaldoInicial = 0 >
				</cfif>
			 
				<!--- Obtener los movimientos de la cuenta luego del saldo inicial (movimientos del periodo) --->
				<cfquery name="rsPR_datos8" datasource="#arguments.conexion#">
					select sum(coalesce(MLmonto, 0.00) * ( charindex(MLtipomov, 'CD') * 2 - 3)) as monto
					from MLibros 
					where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCBid#" > 
					  and MLperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPPeriodo#" >
					  and MLmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPMes#" >
				</cfquery>
				<cfif len(trim(rsPR_datos8.monto)) >
					<cfset vMovimientoCuenta = rsPR_datos8.monto >
				<cfelse>	
					<cfset vMovimientoCuenta = 0 >
				</cfif>
			 
				<!--- Saldo disponible de la cuenta especificada para el pago de la nomina --->
				<cfset vDispCuenta =  vSaldoInicial  + vMovimientoCuenta >
			 
				<!--- Monto de liquido de la nomina - Montos a depositar en la cuenta de los empleados --->
				<cfquery name="rsPR_datos9" datasource="#arguments.conexion#">
					select sum(coalesce(SEliquido,0)) as monto
					from SalarioEmpleado 
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				</cfquery>
				<cfif len(trim(rsPR_datos9.monto))>
					<cfset vSalLiquido = rsPR_datos9.monto >
				<cfelse>
					<cfset vSalLiquido = 0 >
				</cfif>
			 
				<!--- Si no hay disponible en la cuenta, no puede procesarse el pago de la nomina --->
				<cfif vDispCuenta lt vSalLiquido >
					<cfthrow message="No hay suficiente efectivo en la Cuenta Cliente para el pago de la N&oacute;mina [Cuenta: #arguments.CBcc#]. Proceso cancelado">
				</cfif>
			</cfif>
			
			<!--- Obtener los datos de la tabla Relacion Calculo de Nomina --->
			<cftransaction>
			<cfquery name="rsPR_nominatemp" datasource="#arguments.conexion#">
				insert into #ERNomina#(Ecodigo, Tcodigo, ERNfinicio, ERNffin, ERNdescripcion, Usucodigo, Ulocalizacion, Bid, CBcc, ERNcuenta, CBTcodigo, Mcodigo, ERNfcarga, ERNcapturado, ERNsistema, ERNestado, RCtc)
				select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
						a.Tcodigo, a.RCdesde, a.RChasta, a.RCDescripcion, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vBid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CBcc#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#vERNcuenta#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vCBTcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						0, 1, 2, RCtc 
				from RCalculoNomina a 
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="rsPR_nominatemp">
			<cfset vERNid = rsPR_nominatemp.identity >
			</cftransaction>

			<cfif vERNid eq 0 >
				<cfthrow message="No pudo generar la Relaci&oacute;n de N&oacute;mina.">
			</cfif>	

			<!--- PARAMETROS DEL CALENDARIO DE PAGOS --->
			<!--- Modificacion hecha por Juan Carlos Gutierrez. 
				  20/02/2008	
				  Ver bug 467 --->
			<!---
			<cfquery datasource="#arguments.conexion#">
				update #ERNomina#
				set	ERNfdeposito = coalesce((select min(a.CPfpago)
									from CalendarioPagos a 
									where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
									and #ERNomina#.Tcodigo = a.Tcodigo 
									and #ERNomina#.ERNfinicio = a.CPdesde ),  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">)
			</cfquery>
			--->
			<cfquery datasource="#arguments.conexion#">
				update #ERNomina#
				set ERNfdeposito = coalesce(	( select a.CPfpago 
												  from CalendarioPagos a 
												  where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> ),  
												<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">) 
			</cfquery>
			
			<!--- SE OBTIENEN LOS DATOS DEL DETALLE DE RECEPCION DE NOMINA --->
			<!---se elimina el ecodigo del filtro por que al ser trasladado un empleado a otra 
			empresa en medio de una nomina este no es tomado en cuenta ljimenez--->
			
			<cfquery datasource="#arguments.conexion#">
				insert into #DRNomina#(ERNid, NTIcodigo, DRIdentificacion, Bid, DEid, DRNcuenta, CBcc, CBTcodigo, Mcodigo, DRNnombre, DRNapellido1, DRNapellido2, 
									DRNsalbruto, DRNrenta, DRNobrero, DRNpatrono, DRNotrasdeduc, DRNliquido, DRNsaladicional, DRNreintegro, DRNtipopago, DRNinclexcl, DRNfinclexcl, DRNestado) 
				select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vERNid#">, 
						a.NTIcodigo, DEidentificacion, Bid, a.DEid, DEcuenta,  CBcc, CBTcodigo, Mcodigo, DEnombre, DEapellido1, DEapellido2, 
						SEsalariobruto, SErenta, SEcargasempleado, SEcargaspatrono, SEdeducciones, SEliquido, SEincidencias, 0, '00', null, null, 3 
				FROM DatosEmpleado a, SalarioEmpleado b 
				WHERE <!---a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> and  ljimenez --->
					b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
					and a.DEid = b.DEid 
			</cfquery>
			
			
			<!--- cantidad de Dias --->
			<cfquery datasource="#arguments.conexion#">
				update #DRNomina#
				set DRNnumdias = (	select coalesce(sum(a.PEcantdias),0) 
									FROM PagosEmpleado a 
									where #DRNomina#.DEid = a.DEid 
									  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> )
			</cfquery>		

			<!--- Puesto --->
			<cfquery datasource="#arguments.conexion#">
				update #DRNomina# 
				set DRNpuesto = (	select min(a.RHPcodigo) 
									from PagosEmpleado a 
									where a.DEid = #DRNomina#.DEid 
									  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
									  and a.PEhasta = ( 	select max(PEhasta)  
															from PagosEmpleado b  
															where b.DEid = a.DEid 
															  and b.RCNid = a.RCNid )) 
			</cfquery>				

			<!--- Datos del Periodo --->
			<cfquery datasource="#arguments.conexion#">
				update #DRNomina#
				set DRNperiodo = ( select a.CPfpago
							from CalendarioPagos a 
							where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> ), 
					DRNper = ( select a.CPperiodo
							from CalendarioPagos a 
							where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> ), 
					DRNmes = ( select a.CPmes
							from CalendarioPagos a 
							where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> )
				where exists ( select 1
				from CalendarioPagos a 
				where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> )
			</cfquery>
			
			
			<!---  Grabado --->
			<cftransaction>
				<!--- Encabezado de la Nomina  --->
				<cfquery name="rsPR_nomina" datasource="#arguments.conexion#">
					insert into ERNomina(Ecodigo, Tcodigo, RCNid, Bid, CBcc, ERNcuenta, CBTcodigo, Mcodigo, ERNfcarga, ERNfdeposito, ERNfinicio, ERNffin, ERNdescripcion, ERNestado, Usucodigo, Ulocalizacion, ERNusuverifica, ERNfverifica, ERNusuautoriza, ERNfautoriza, ERNfechapago, ERNfprogramacion, ERNsistema, ERNcapturado, RCtc ) 

					select 	Ecodigo, Tcodigo, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
							Bid, CBcc, ERNcuenta, CBTcodigo, Mcodigo, ERNfcarga, ERNfdeposito, ERNfinicio, ERNffin, ERNdescripcion, ERNestado, Usucodigo, Ulocalizacion, ERNusuverifica, ERNfverifica, ERNusuautoriza, ERNfautoriza, ERNfechapago, ERNfprogramacion, ERNsistema, ERNcapturado, RCtc 
					from #ERNomina#
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="rsPR_nomina">
				<cfset vERNid = rsPR_nomina.identity >

				<!--- Detalle de Empleados en esta nomina --->
				<cfquery datasource="#arguments.conexion#"  name="rs12">
					insert into DRNomina( ERNid, NTIcodigo, DRIdentificacion, Bid, DEid, DRNcuenta, CBcc, CBTcodigo, Mcodigo, DRNnombre, DRNapellido1, DRNapellido2, DRNtipopago, DRNperiodo, DRNnumdias, DRNsalbruto, DRNsaladicional, DRNreintegro, DRNrenta, DRNobrero, DRNpatrono, DRNotrasdeduc, DRNliquido, DRNocupacion, DRNfondopen, DRNfondocap, DRNinclexcl, DRNfinclexcl, DRNestado, DRNper, DRNmes, DRNotrospatrono )
					
					select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vERNid#">,
							NTIcodigo, DRIdentificacion, Bid, DEid, DRNcuenta, CBcc, CBTcodigo, Mcodigo, DRNnombre, DRNapellido1, DRNapellido2, DRNtipopago, DRNperiodo, DRNnumdias, DRNsalbruto, DRNsaladicional, DRNreintegro, DRNrenta, DRNobrero, DRNpatrono, DRNotrasdeduc, DRNliquido, coalesce(DRNocupacion,'a'), DRNfondopen, DRNfondocap, DRNinclexcl, DRNfinclexcl, coalesce(DRNestado,0), DRNper, DRNmes, 0
					 FROM #DRNomina# 
				</cfquery>		

				<!--- Deducciones  de Empleado --->
				<cfquery datasource="#arguments.conexion#">
					insert into DDeducPagos( DRNlinea, DDdescripcion, DDmonto, Bid, CBcc, CBTcodigo, Mcodigo, DDcuenta, DDnombre, DDidbeneficiario, DDpago, DDpagopor  )
					select dn.DRNlinea, <cf_dbfunction name="string_part" args="a.Ddescripcion,1,60">, b.DCvalor, null, null, null, null, null, null, null, 1, 0 
					FROM DeduccionesCalculo b, DRNomina dn, DeduccionesEmpleado a 
					where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
						and dn.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vERNid#">
						and dn.DEid = b.DEid 
						and a.Did = b.Did 
				</cfquery>				
			 
				<!--- Cargas pagadas por el Empleado --->
				<cfquery datasource="#arguments.conexion#">
					insert into DDeducPagos(DRNlinea, DDdescripcion, DDmonto, Bid, CBcc, CBTcodigo, Mcodigo, DDcuenta, DDnombre, DDidbeneficiario, DDpago, DDpagopor ) 
					select dn.DRNlinea, a.DCdescripcion, b.CCvaloremp, null, null, null, null, null, null, null, 1, 0 
					FROM CargasCalculo b,  DRNomina dn, DCargas a 
					 WHERE b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
						and b.CCvaloremp > 0 
						and dn.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vERNid#">
						and dn.DEid = b.DEid 
						and a.DClinea = b.DClinea 
				</cfquery>
				
				<!--- Cargas pagadas por el Patrono --->
				<cfquery datasource="#arguments.conexion#">
					insert into DDeducPagos( DRNlinea, DDdescripcion, DDmonto, Bid, CBcc, CBTcodigo, Mcodigo, DDcuenta, DDnombre, DDidbeneficiario, DDpago, DDpagopor ) 
					select dn.DRNlinea, a.DCdescripcion, b.CCvalorpat, null, null, null, null, null, null, null, 1, 1 
					FROM CargasCalculo b,  DRNomina dn, DCargas a 
					 WHERE b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
						and b.CCvalorpat > 0 
						and dn.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vERNid#">
						and dn.DEid = b.DEid 
						and a.DClinea = b.DClinea 
				</cfquery>	
				
				<!--- Incidencias --->
				<cfquery datasource="#arguments.conexion#">
					insert into DRIncidencias( DRNlinea, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores ) 
					select 	dn.DRNlinea, a.CIid, a.ICfecha, a.ICvalor, a.ICfechasis, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
							'00', 
							a.ICcalculo, a.ICbatch, a.ICmontoant, a.ICmontores 
					from IncidenciasCalculo a, DRNomina dn 
					where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
						and dn.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vERNid#">
						and dn.DEid = a.DEid 
				</cfquery>			 

				<!--- Cambio del estado de la relacion de nomina --->
				<cfquery datasource="#arguments.conexion#">
					update RCalculoNomina 
					SET RCestado = 3 
					where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
				 </cfquery>


				<!--- Actualiza fecha de cálculo en el calendario de Pagos --->
				<cfquery datasource="#arguments.conexion#">
					update CalendarioPagos 
					set CPfcalculo = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						CPusucalc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
						CPusuloccalc = '00' 
					where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
				</cfquery>	
				  
			</cftransaction>

		<cfreturn >
	</cffunction>
</cfcomponent>