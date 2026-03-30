<cfcomponent>
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
    <cffunction name="CuentasTipo" access="public" output="true" >
		<cfargument name="conexion" 	type="string" 	required="no" default="#Session.DSN#">		
		<cfargument name="Ecodigo" 		type="numeric" 	required="yes">
		<cfargument name="RCNid"   		type="numeric" 	required="yes">
		<cfargument name="Usucodigo" 	type="string" 	required="no" default="#Session.Usucodigo#">
		<cfargument name="CBid" 		type="numeric">
		<cfargument name="debug" 		type="boolean" 	required="no" default="false">
		<cfset CuentasTipo_CreaTemp(arguments.conexion)>
		<cfsetting requesttimeout="15000" >
		<cfset vError 			  		= ''>
		<cfset vCmayor			  		= ''>
		<cfset vCformato 		  		= ''>
		<cfset vCuentabanco        		= ''>
		<cfset vCuentabancofmt     		= ''>
		<cfset vContabiliza		  		= ''>
		<cfset vValidaplanillap    		= 'N'>
		<cfset vBid                		= ''>
		<cfset vPeriodo            		= ''>
		<cfset vMes                		= ''>
		<cfset vPeriodoAnt         		= ''>
		<cfset vMesAnt             		= ''>
		<cfset vTipoPago          		= ''>
		<cfset vRCdesde			  		= ''>
		<cfset vRChasta			  		= ''>
		<cfset vDia1				  	= ''>
		<cfset vCuentaPasivo       		= ''>
		<cfset vCuentaPasivoFmt	  		= ''>

		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cf_dbfunction name="findOneOf" args="cuenta, ?!*" returnvariable="findoneof_cuenta">
		<cf_dbfunction name="findOneOf" args="Cformato, ?!*" returnvariable="findoneof_cformato">
		
		<cfquery datasource="#arguments.conexion#">
			delete from RCuentasTipo 
			where RCNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		
		<cfquery name="rsValidaPlanillaP" datasource="#arguments.conexion#">
			select (case when coalesce(ltrim(rtrim(Pvalor)), '0') = '0' then 'N' else 'S' end) as validaplanillap
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 540
		</cfquery>
		<cfif len(trim(rsValidaPlanillaP.validaplanillap))>
			<cfset vValidaplanillap = rsValidaPlanillaP.validaplanillap >	
		</cfif>
	
		<cfquery name="rsContabiliza" datasource="#arguments.conexion#">
			select (case when coalesce(ltrim(rtrim(Pvalor)),'0') = '0' then 'N' else 'S' end) as contabiliza
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 20
		</cfquery>
		<cfset vcontabiliza = rsContabiliza.contabiliza >	

		<!--- Averiguar si se requiere contabilizar los gastos por mes--->
		<cfquery name="rsContabilizaGastosMes" datasource="#arguments.conexion#">
		   select coalesce(Pvalor, '0') as ContabilizaGastosMes
			 from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 490
		</cfquery>	
		<cfset vContabilizaGastosMes = rsContabilizaGastosMes.ContabilizaGastosMes >
		
		<cfquery name="rsContabilizada" datasource="#arguments.Conexion#">
			select 1 
			 from HRCalculoNomina 
			where RCNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<!--- La Nomina está procesada, por lo tanto. TIENE que estar contabilizada si lo requiere --->
		<cfif rsContabilizada.recordcount gt 0>
			<cfset vContabiliza = 'N' >
		</cfif>

		<!--- Periodo y Mes --->
		<cfquery name="rsCT_Datos" datasource="#arguments.Conexion#">
			select a.RCdesde, a.RChasta, b.CPperiodo, b.CPmes, c.Ttipopago, b.CPtipo
			from RCalculoNomina a
            	inner join CalendarioPagos b
                	on b.CPid = a.RCNid
                inner join TiposNomina c
                   on c.Ecodigo = a.Ecodigo
			  	  and c.Tcodigo = a.Tcodigo
			where a.RCNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>		  
		<cfset vRCdesde   = rsCT_Datos.RCdesde >
		<cfset vRChasta   = rsCT_Datos.RChasta >
		<cfset vPeriodo   = rsCT_Datos.CPperiodo > 
		<cfset vMes 	  = rsCT_Datos.CPmes >
		<cfset vTipoPago  = rsCT_Datos.Ttipopago >
        <cfset vCPtipo    = rsCT_Datos.CPtipo >

		<!--- Cuenta Contable de Renta --->
		<cfquery name="rsCT_Datos1" datasource="#arguments.Conexion#">
			select coalesce(Pvalor,'-1') as Cuentarenta
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 140
		</cfquery>	
		<cfset vCuentarenta = rsCT_Datos1.Cuentarenta >

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Revise_los_parametros_del_sistema"
			Default="Revise_los_parametros_del_sistema"
			XmlFile="/rh/componentes.xml"
			returnvariable="MSG_ErrorGeneral"/>

		<cfif (len(trim(vCuentarenta)) eq 0 ) or (vCuentarenta eq '-1')>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_La_cuenta_contable_de_renta_no_ha_sido_definida"
				Default="Error! La cuenta contable de renta no ha sido definida"
				XmlFile="/rh/componentes.xml"
				returnvariable="MSG_Error"/>
			<cfthrow message="#MSG_Error#. #MSG_ErrorGeneral#">
		</cfif>

		<cfquery name="rsCT_Datos2" datasource="#arguments.Conexion#">
			select Cformato as cuentarentafmt
			from CContables
			where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuentarenta#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfset vCuentarentafmt = rsCT_Datos2.cuentarentafmt >
		
		
		<cfif len(trim(vCuentarentafmt)) eq 0 >
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_La_cuenta_contable_de_renta_no_es_una_cuenta_valida"
				Default="La cuenta contable de renta no es una cuenta v&aacute;lida"
				XmlFile="/rh/componentes.xml"
				returnvariable="MSG_Error"/>
			<cfthrow message="#MSG_Error#. #MSG_ErrorGeneral#">
		</cfif>

		<!--- Cuenta Contable de Pagos no realizados --->
		<cfquery name="rsCT_Datos3" datasource="#arguments.Conexion#">
			select coalesce(Pvalor,'-1') as cuentapnoreal
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and Pcodigo = 150
		</cfquery>				  
		<cfset vCuentapnoreal = rsCT_Datos3.cuentapnoreal >
		<cfif (len(trim(vCuentapnoreal)) eq 0 ) or (vCuentapnoreal eq '-1')>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_La_cuenta_contable_para_Pagos_no_Realizados_no_ha_sido_definida"
				Default="La cuenta contable para Pagos no Realizados no ha sido definida"
				XmlFile="/rh/componentes.xml"
				returnvariable="MSG_Error"/>
			<cfthrow message="#MSG_Error#. #MSG_ErrorGeneral#">
		</cfif>

		<cfquery name="rsCT_Datos4" datasource="#arguments.Conexion#">
			select Cformato as Cuentapnorealfmt
			from CContables
			where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuentapnoreal#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfset vCuentapnorealfmt = rsCT_Datos4.Cuentapnorealfmt >
		<cfif len(trim(vCuentapnorealfmt)) eq 0 >
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_La_cuenta_contable_para_Pagos_no_Realizados_no_es_una_cuenta_valida"
				Default="La cuenta contable para Pagos no Realizados no es una cuenta v&aacute;lida"
				XmlFile="/rh/componentes.xml"
				returnvariable="MSG_Error"/>
			<cfthrow message="#MSG_Error#. #MSG_ErrorGeneral#">
		</cfif>

		<!--- Cuenta Contable de la Cuenta Bancaria --->
		<cfquery name="rsCT_Datos5" datasource="#arguments.Conexion#">
			select b.Ccuenta, b.Bid
			from CuentasBancos b
			where b.CBid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CBid#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		</cfquery>

		<cfset vCuentabanco = rsCT_Datos5.Ccuenta >
		<cfset vBid = rsCT_Datos5.Bid >
		<cfif len(trim(vCuentabanco)) eq 0 >
			<cfquery name="rsCT_cuenta" datasource="#arguments.conexion#">
				select CBdescripcion
				from CuentasBancos
				where CBid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CBid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                  and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_No_ha_sido_definida_la_cuenta_contable_para_la_cuenta_bancaria"
				Default="No ha sido definida la cuenta contable para la cuenta bancaria"
				XmlFile="/rh/componentes.xml"
				returnvariable="MSG_Error"/>
			<cfthrow message="#MSG_Error#:(#rsCT_cuenta.CBdescripcion#). #MSG_ErrorGeneral#">
		</cfif>

		<cfquery name="rsCT_Datos6" datasource="#arguments.Conexion#">
			select Cformato as cuentabancofmt
			from CContables
			where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuentabanco#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfset vCuentabancofmt = rsCT_Datos6.cuentabancofmt >

		<cfif len(trim(vCuentabancofmt)) eq 0 >
			<cfquery datasource="#arguments.conexion#">
				insert into #Errores#(tiporeg, descripcion, tipoerr)
				select 0, 'La cuenta contable de la cuenta Bancaria no estÃ¡ definida.', 1
			</cfquery>
		</cfif>

		<!--- Llenado de Tabla de Empleados --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Empleados# (RCNid, DEid, RHPid, RHPPid, CFid, Ecodigo, Ocodigo, Dcodigo)
			select RCNid, DEid, -1, -1, -1, -1, -1, -1
			from SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>

		<!--- El CFuncional de la mayor fecha de cÃ¡lculo de la relacion --->
		<cfquery datasource="#arguments.conexion#">
			update #Empleados# 
				set RHPid = coalesce((	select min(pe.RHPid)
										from PagosEmpleado pe
										where pe.RCNid = #Empleados#.RCNid
										  and pe.DEid = #Empleados#.DEid 
										  and pe.PEdesde = (select max(z.PEdesde) from PagosEmpleado z where z.RCNid = #Empleados#.RCNid and z.DEid = #Empleados#.DEid)
										  and pe.PEtiporeg != 2 ), -1)
		</cfquery>
		
		<cfquery datasource="#arguments.conexion#">
			update #Empleados# 
			 set CFid = (select coalesce(p.CFidconta , p.CFid)
				from RHPlazas p
				where #Empleados#.RHPid = p.RHPid
				and #Empleados#.RHPid != -1			 
			 )
			 where exists ( select 1 
			 from RHPlazas p
			 where #Empleados#.RHPid = p.RHPid
			 and #Empleados#.RHPid != -1
			 )
		</cfquery>	 
        
          <!--- Para nÃ³minas ESPECIALES   --->
		  <!--- SE ACTUALIZAN LOS DATOS DE PLAZA Y CENTRO FUNCIONAL PARA LA GENERACION DEL ASIENTO --->
		  <cfif vCPtipo EQ 1 >
              <cfquery datasource="#arguments.conexion#">
               update #Empleados# 
                set RHPid = coalesce(( select lt.RHPid
                      from LineaTiempo lt
                      	inner join RCalculoNomina rc 
                        	on rc.RCNid = #Empleados#.RCNid
                      where lt.DEid = #Empleados#.DEid
					  and lt.Ecodigo = rc.Ecodigo
                      and (rc.RCdesde between LTdesde and LThasta 
                           or rc.RChasta between LTdesde and LThasta)
                      ), -1)
				where exists ( select 1
							 from LineaTiempo lt
                             	inner join RCalculoNomina rc 
                                	on rc.RCNid = #Empleados#.RCNid
							  where lt.DEid = #Empleados#.DEid
							  and lt.Ecodigo = rc.Ecodigo
							  and (rc.RCdesde between LTdesde and LThasta 
								   or rc.RChasta between LTdesde and LThasta))
              </cfquery>
              <cfquery datasource="#arguments.conexion#">
               update #Empleados# 
                set CFid = coalesce(( select coalesce(p.CFidconta , p.CFid)
						  				from LineaTiempo lt
                           					inner join RCalculoNomina rc
                           						on rc.RCNid = #Empleados#.RCNid
                           					inner join RHPlazas p
                           						on p.RHPid = lt.RHPid
						  				where lt.DEid = #Empleados#.DEid
										  and lt.Ecodigo = rc.Ecodigo
						  				  and (rc.RCdesde between LTdesde and LThasta or rc.RChasta between LTdesde and LThasta)), -1) 
				where exists (select 1
                               from LineaTiempo lt
                               inner join RCalculoNomina rc 
                                     on rc.RCNid = #Empleados#.RCNid
                              where lt.DEid = #Empleados#.DEid
							  	and lt.Ecodigo = rc.Ecodigo
                                and (rc.RCdesde between LTdesde and LThasta or rc.RChasta between LTdesde and LThasta))
              </cfquery>
          </cfif>

		<cfquery datasource="#arguments.conexion#">
			update #Empleados# 
			set Ocodigo = ( select c.Ocodigo
				from CFuncional c
				where #Empleados#.CFid = c.CFid
				and #Empleados#.CFid != -1
				),				
				Dcodigo = ( select c.Dcodigo
				from CFuncional c
				where #Empleados#.CFid = c.CFid
				and #Empleados#.CFid != -1
				),
				Ecodigo = ( select c.Ecodigo
				from CFuncional c
				where #Empleados#.CFid = c.CFid
				and #Empleados#.CFid != -1
				)
			 where exists ( select 1 
				from CFuncional c
				where #Empleados#.CFid = c.CFid
				and #Empleados#.CFid != -1
			)
		</cfquery>

		<cfquery datasource="#arguments.conexion#" name="invalidos">
			select count(1) as cnt
			from RHPlazas p
            	inner join #Empleados# a
                	on a.RHPid = p.RHPid
			where p.RHPPid is null
		</cfquery>
		<cfif invalidos.cnt>
			<cfthrow message="Hay #invalidos.cnt# plazas sin plaza presupuestaria">
		</cfif>

		<cfquery datasource="#arguments.conexion#">
			update #Empleados# 
			set RHPPid = ( select p.RHPPid
			from RHPlazas p
			where p.RHPid = #Empleados#.RHPid
			)
			where exists ( select 1 
			from RHPlazas p
			where p.RHPid = #Empleados#.RHPid
			)
		</cfquery>

		<!--- 2) Llenado de la Tabla de Trabajo (RCuentasTipo) --->
		<!--- CONTABILIZACION DE GASTOS POR MES --->
		<!--- Inicializar fecha referencia en caso de que la nomina cubra dos meses contables --->
		<cfset vdia1 = '' >
		<cfset vHoy = now() >
		<!--- Averiguar si el pago de nomina cubre dos meses contables para hacer el prorrateo de Salarios en Incidencias --->
		<cfif vContabilizaGastosMes eq 1 and listfind('0,1', vTipoPago) and (datepart('m', vRCdesde) neq datepart('m', vRChasta)) >
			<cfset vDia1 = year(vRChasta) &  RepeatString('0', 2-len(month(vRChasta)) ) & month(vRChasta) & '01'>
			<!--- compatibilidad con oracle, no puede tomarse al fecha como varchar, debe ser objeto date --->
			<cfset vDia1 = createdate(year(vRChasta), month(vRChasta), 1) >
			<cfset vFecha = createdate(vPeriodo, vMes, 1) >
			<cfset vFecha = dateadd('m', -1, vFecha) >

			<cfset vMesAnt = datepart('m', vFecha) >
			<cfset vPeriodoAnt = datepart('yyyy', vFecha) >

			<!--- Obtener la cuenta contable de Pasivo de la tabla de parametros --->
			<cfquery name="rsCT_datos7" datasource="#arguments.conexion#">
				select Pvalor as CuentaPasivo
				from RHParametros 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				and Pcodigo = 500
			</cfquery>
			<cfset vCuentaPasivo = rsCT_datos7.CuentaPasivo >
			<cfif len(trim(vCuentaPasivo)) eq 0 >
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_La_cuenta_de_pasivo_para_contabilizacion_no_se_ha_definido"
					Default="La cuenta de pasivo para contabilizaci&oacute;n no se ha definido"
					XmlFile="/rh/componentes.xml"
					returnvariable="MSG_Error"/>
				<cfthrow message="#MSG_Error#. #MSG_ErrorGeneral#">
			</cfif>
				
			<cfquery name="rsCT_datos8" datasource="#arguments.conexion#">
				select Cformato
				from CContables
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCuentaPasivo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			</cfquery>
			<cfset vCuentaPasivoFmt = rsCT_datos8.Cformato >
			<cfif len(trim(vCuentaPasivoFmt)) eq 0 >
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_La_cuenta_de_pasivo_para_contabilizacion_de_los_gastos_por_mes_no_se_encuentra_parametrizada"
					Default="La cuenta de pasivo para contabilizaci&oacute;n de los gastos por mes no se encuentra parametrizada"
					XmlFile="/rh/componentes.xml"
					returnvariable="MSG_Error"/>
				<cfthrow message="#MSG_Error#.">
			</cfif>
			<!--- Salarios (Debitos) para el Primer Mes --->
			<!--- Insertar Salarios para el Primer Mes --->
			<cfset CuentasTipo_Salarios_D(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
			<!--- Incidencias (Debitos) para el Primer Mes (Cuenta Fija)--->
			<cfset CuentasTipo_Incidencias_D(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		</cfif>
		<!--- DEBITOS --->
		<!--- 2.1 Salarios --->
		<cfset CuentasTipo_Salarios_2_1(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- 2.2a Incidencias  (Cuenta Fija)--->
		<cfset CuentasTipo_Incidencias_CuentaFija(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- Aqui se incluye el componente encargado de hacer la distribuciÃ³n de componentes salariales para los casos en que se cumpla --->
		<!--- 2.25a Pagos no Realizados (Cuenta Fija)--->
		<cfset CuentasTipo_Pagos_No_Realizados(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- 2.3 Cargas Patronales que no son de CxC --->
		<!--- Averiguar si el pago de nÃ³mina cubre dos meses contables para hacer el PRORRATEO DE CARGAS --->
		<cfif vContabilizaGastosMes eq 1 and listfind('0,1', vTipoPago) and (datepart('m', vRCdesde) neq datepart('m', vRChasta)) >
			<!--- INICIAR PRORRATEO DE CARGAS --->
			<!--- Primer Mes --->
			<cfset CuentasTipo_PRORRATEO_DE_CARGAS(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
			<cfset CuentasTipo_Insertar_Cargas1(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<cfelse>
			<cfset CuentasTipo_Insertar_Cargas2(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		</cfif>
		<!--- ************************************************************************************************************** --->
        <!---   En este include  se realiza la distribuciÃ³n de las cargas de los centro funcionales a lo que corresponde     --->
        <!---   Ya que actualmente todas la cargas las rebajaba al centro funcional alque pertenece el empleado              --->
   		<!--- ************************************************************************************************************** --->		
		<cfif vCPtipo NEQ 1 >
         	<cfset CuentasTipo_DistribucionCargas(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
				<!--- 
				Se quita este include y se convierte en una funciÃ³n.	
				<cfinclude template="DistribucionCargas.cfm"> 
				--->
		 </cfif>
		 
   		<!--- ************************************************************************************************************** --->
		<!--- Objeto de Gasto (Cargas Patronales que no son de CxC) --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion, tipoerr)
			select distinct 30, 'La Carga Patronal ' #_Cat# ltrim(rtrim(c.DCcodigo)) #_Cat# ' no tiene el objeto de gasto definido.', 1
			from #Empleados# emp
            	inner join CargasCalculo a
                	on a.RCNid = emp.RCNid
                   and a.DEid = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join CFuncional b
                	on b.CFid = emp.CFid
			where a.CCvalorpat != 0.00
			  and c.DCtipo = 0					<!--- Solo las que no son una cuenta por Cobrar --->
			 and #preservesinglequotes(findoneof)#
			 and ltrim(rtrim(c.DCcuentac)) is null
		</cfquery>
		
		<!--- 2.4 Cargas Patronales que corresponden a CxC --->
		<!--- LZ 2011-0519, Se realiza dicha condicion de modo que Unicamente se Ejecute CuentasTipo_tiporeg_40 cuando no hay distribucion contable, sino otra Funcion genera los Reg 40.--->		
		<cfif vContabilizaGastosMes eq 1 and listfind('0,1', vTipoPago) and (datepart('m', vRCdesde) neq datepart('m', vRChasta)) >		
		<cfelse>
				<cfset CuentasTipo_tiporeg_40(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		</cfif>	
<!---Carmela --->
		<!--- CREDITOS --->
		<!--- 2.5 Cargas de Empleado --->
		<cfset CuentasTipo_tiporeg_50_55(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- El socio de Negocios de la deduccion no tiene definida la cuenta contable CxP --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion, tipoerr)
			select distinct 60, 'El Socio de Negocios ' #_Cat# ltrim(rtrim(s.SNnombre)) #_Cat# ' no tiene cuenta contable de CxP definida.', 1
			from #Empleados# emp
            	inner join DeduccionesCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DeduccionesEmpleado c
                	 on c.Did = a.Did
                inner join SNegocios s
                	 on s.Ecodigo = c.Ecodigo
					and s.SNcodigo = c.SNcodigo
			where a.DCvalor != 0
			and (s.SNcuentacxp is null
			 or (select count(1) 
				   from CContables cc
				  where cc.Ccuenta = s.SNcuentacxp
				    and cc.Ecodigo = s.Ecodigo
				    and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				    and cc.Cformato is not null) = 0)
		</cfquery>
		<!--- 2.61 Intereses de prestamos --->
		<cfset CuentasTipo_tiporeg_61(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- 2.7 Renta --->
		<cfset CuentasTipo_tiporeg_70(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- 2.8 Bancos --->
		<cfset CuentasTipo_tiporeg_80(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<!--- Aplicar la Mascara al formato del centro funcional --->
		<!--- 
		<cfquery datasource="#arguments.conexion#">
			update RCuentasTipo 
			set Cformato = <cfif Application.dsinfo[arguments.conexion].type is 'sqlserver'>dbo.</cfif>CGAplicarMascara(cuenta, valor) 
			<!--- 	En baroda (ambiente sybase), por algun motivo si se usa el cfqueryparam este query no sirve, 
					se reviso y quitando ese tag funciono correctamente. No supimos el porque.....--->
			where RCNid = #arguments.RCNid#
			and (cuenta like '%[?!*]%' 
			and rtrim(ltrim(valor)) is not null)
		</cfquery> 
		--->
        <!--- ************************************************************************** --->
        <!--- PROCESO DE VERIFICACION Y REALIAZACION DE DISTRIBUCION A NIVEL DE          --->
        <!--- CONCEPTOS DE PAGO,COMPONENTES SALARIALES Y CARGAS SOCIALES                 --->
        <!--- ************************************************************************** --->
		<cfquery datasource="#arguments.conexion#" name="RS_EntraDistribucion">
				select count(a.DEid) as cantidad from RCuentasTipo a 
				inner join DistEmpCompSal decs
					on   a.DEid 	= decs.DEid 
					and  a.Ecodigo 	= decs.Ecodigo    
					where a.RCNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.tipo = 'D'
					and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.tiporeg in (10,11)
				group by a.DEid
				union 
				select count(a.DEid)  as cantidad from RCuentasTipo a 
						 inner join IncidenciasCalculo c
							on  a.DEid  = c.DEid
							and a.RCNid = c.RCNid 
							and a.CFid  = c.CFid
							and a.referencia  = c.CIid
							and c.ICmontores > 0 
				inner join DistEmpIncidencias dei
							on   a.DEid 	= dei.DEid 
							and  c.CIid 	= dei.CIid 
							and  a.Ecodigo 	= dei.Ecodigo    
					where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.tipo = 'D'
					and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and a.tiporeg in (20,21)
				group by a.DEid
				union 
				select count(a.DEid) as cantidad from RCuentasTipo a 
					  inner join DistEmpCargas decs
							on   a.DEid 		= decs.DEid 
							and  a.Ecodigo 		= decs.Ecodigo 
							and  a.referencia 	= decs.DClinea   
					where a.RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and a.tipo = 'D'
					and a.Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
					and   tiporeg in (30,31,40,41)
				group by a.DEid
				having count(a.DEid) > 1		
		</cfquery>
		<cfif RS_EntraDistribucion.recordCount GT 0 >
			<cfinclude template="Distribucion.cfm">
		</cfif>
		<!--- 
		******************************************************************************
					AQUI ES DONDE SE VA INSERTAR LA FUNCION DE 55 Y 56,57,50,51,52
		******************************************************************************
		  --->
		<cfset DistribucionCargasPatronales_X_mes(arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>
		<cfset DistribucionCargasEmpleado_X_mes  (arguments.conexion,arguments.Usucodigo,arguments.RCNid,arguments.Ecodigo)>

   		<!---???? VALIDA LA ACTIVIDAD EMPRESARIAL ?????--->
		
		<!---??Activar Transaccionabilidad de Actividad Empresarial??--->
        <cfquery name="rsAE" datasource="#session.dsn#">
            select Coalesce(Pvalor,'N') as Pvalor 
                from Parametros 
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and Pcodigo = 2200
        </cfquery>
		<cfif isdefined('rsAE.Pvalor') and rsAE.Pvalor EQ 'S'>	
				<cfinvoke component="rh.Componentes.RH_AplicarMascara" method="ValidaActividadEmpresarial" returnvariable="ErroresActEmp">
					<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
					<cfinvokeargument name="Errores" value="#Errores#">
				</cfinvoke>		
		</cfif>
   		<!---????ACTUALIZA EL FORMATO DE LA CUENTA FINANCIERA?????--->
        <cfinvoke component="rh.Componentes.RH_AplicarMascara" method="ActualizaFormatoRCuentasTipo">
        	<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
        </cfinvoke>
		
		<!--- LZ 2011-05-31 Modificaciones Generacion de Cuentas, cuando se utiliza Plan de Cuentas--->
		<cfquery name="rsCT_cursor" datasource="#arguments.conexion#">
			select rtrim(ltrim(Pvalor)) as Pvalor
			from Parametros
			Where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#"> 
			and Pcodigo=1
		</cfquery>
	
		<cfif rsCT_cursor.Pvalor EQ 'S' >
		<!--- Ejecutar el sp del plan cuentas para las cuentas que todavÃ­a no existen --->
		<!--- LZ 2011-05-31  Dicho Proceso debe hacerse antes de Verificar las Cuentas, para establecer que no hay problema  con cuentas aun existentes --->
				<cfquery name="rsCT_cursor" datasource="#arguments.conexion#">
					select distinct tiporeg, Cformato
					from RCuentasTipo 
					where (CFcuenta <= 0 or CFcuenta is null)
					and Cformato is not null
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				</cfquery>
							
				<cfloop query="rsCT_cursor">
					<!--- Ejecutar el SP del Plan de Cuentas --->
					<cfif len(trim(rsCT_cursor.Cformato)) >
						<cfset vCmayor = mid(rsCT_cursor.Cformato, 1, 4) >
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="Mensaje">
							<cfinvokeargument name="Lprm_Ecodigo" 	value="#arguments.Ecodigo#">
							<cfinvokeargument name="Lprm_Cmayor"	value="#vCmayor#">
							<cfinvokeargument name="Lprm_Cdetalle"	value="#mid(rsCT_cursor.Cformato,6,len(rsCT_cursor.Cformato))#"> 
							<cfinvokeargument name="Lprm_debug"		value="false">
						</cfinvoke>
						<cfif '#Mensaje#' NEQ 'NEW' AND '#Mensaje#' NEQ 'OLD'>
							<cfquery datasource="#arguments.conexion#">
								<!--- Llenar #Errores Cuentas invÃ¡lidas --->
								insert into #Errores#(tiporeg, descripcion, CFformato, tipoerr)
								select distinct #rsCT_cursor.tiporeg#, 
									<cfqueryparam value="#Mensaje#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#rsCT_cursor.Cformato#" cfsqltype="cf_sql_varchar">,	
									 9
								from dual
							</cfquery>							
						</cfif>				
					</cfif>
				</cfloop>
		</cfif>
		<cfquery datasource="#arguments.conexion#">
		    update RCuentasTipo 
			set Cformato = cuenta 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">  
			and (not #preservesinglequotes(findoneof_cuenta)# or #preservesinglequotes(findoneof_cformato)# or ltrim(rtrim(Cformato)) is null)
		</cfquery>
		<!--- Actualizar el CFcuenta y Ccuenta para los que requieren CFinanciera --->
		<cfquery datasource="#arguments.conexion#">
			update RCuentasTipo
			set CFcuenta = coalesce((	select min(CFcuenta)  
										from CFinanciera c 
										where c.Ecodigo = RCuentasTipo.Ecodigo
										and c.CFformato = RCuentasTipo.Cformato
										and c.CFmovimiento = 'S'), -1),
				Ccuenta = coalesce((	select  min(Ccuenta)  
										from CFinanciera c 
										where c.Ecodigo = RCuentasTipo.Ecodigo
										and c.CFformato = RCuentasTipo.Cformato
										and c.CFmovimiento = 'S'), -1)
			where CFcuenta = 0
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
		</cfquery>
		<!--- Actualiza el Ccuenta para los registros que no requieren CFinanciera --->
		<cfquery datasource="#arguments.conexion#">
			update RCuentasTipo
			set Ccuenta = coalesce((	select min(Ccuenta) 
										from CContables c 
										where c.Ecodigo = RCuentasTipo.Ecodigo
										and c.Cformato = RCuentasTipo.Cformato
										and c.Cmovimiento = 'S' ), -1)
			where CFcuenta is null
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
		</cfquery>
		<!---Actualizar el CFcuenta donde no requiero CFinanciera --->
		<cfquery datasource="#arguments.conexion#">
			update RCuentasTipo
			set CFcuenta = coalesce((	select min(CFcuenta) 
										from CFinanciera a 
										where a.Ccuenta = RCuentasTipo.Ccuenta ), -1)
			where CFcuenta is null
			  and Ccuenta is not null
			  and Ccuenta > 0
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
		</cfquery>		
			   
		<!--- Actualizar el Periodo y el Mes del asiento --->
		<cfquery datasource="#arguments.conexion#">
			update RCuentasTipo 
			set Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
				Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">  
			  and Periodo is null 
			  and Mes is null
		</cfquery>
		
		<!--- 3) Validaciones Previas al Posteo --->
		<cfquery name="rsCT_datos10" datasource="#arguments.conexion#">
			select 1
			from RCuentasTipo 
			where coalesce(Ccuenta,-1) < 0 and coalesce(Ccuenta,-1) <> -999
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
		</cfquery>	
		<cfif rsCT_datos10.recordcount gt 0>
			<!--- Llenar #Errores Cuentas inválidas --->
			<cfquery datasource="#arguments.conexion#">
				insert into #Errores#(tiporeg, descripcion, CFformato, tipoerr)
				select distinct tiporeg, 'La cuenta ' #_Cat# Cformato #_Cat# ' no existe o no es una cuenta válida.!',	Cformato, 1
				from RCuentasTipo 
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				and coalesce(Ccuenta,-1) < 0 AND coalesce(Ccuenta,-1) <> -999
				and ltrim(rtrim(Cformato)) is not null
			</cfquery>
		</cfif>
		<!--- Centros Funcionales sin Cuenta --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion, tipoerr)
			select distinct 0, 'El Centro Funcional ' #_Cat# ltrim(rtrim(a.CFdescripcion)) #_Cat# ' no tiene una cuenta definida.', 1
			from CFuncional a
            	inner join #Empleados# b
                	on a.CFid    = b.CFid
				   and a.Ecodigo = b.Ecodigo
			where ltrim(rtrim(a.CFcuentac)) is null
		</cfquery>
		<cfif arguments.debug >
			<cfquery name="rsDebug" datasource="#arguments.conexion#">
				select tiporeg, cuenta, valor, Cformato, tipo, Ocodigo, Dcodigo, montores Monto
				from RCuentasTipo
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
				order by tiporeg, Cformato
			</cfquery>
		</cfif>
		<cfif vValidaplanillap eq 'S'>
			<!--- Validar contra Presupuesto las cuentas --->
			<cfquery name="rsCT_errores" datasource="#arguments.conexion#">
				select tiporeg, descripcion, CFformato, tipoerr 
				from #Errores#
				order by tipoerr, tiporeg
			</cfquery>
			<cfreturn rsCT_errores >
		</cfif>
    	<!--- Regresa los registro que hubo con error --->
		<cfquery name="rsCT_errores" datasource="#arguments.conexion#">
			select tiporeg, descripcion, CFformato, tipoerr 
			from #Errores#
			order by tipoerr, tiporeg
		</cfquery>
		<cfreturn rsCT_errores >
	</cffunction>
	<!--- ******************************************************************** --->
	<!---                       FUNCIONES EXTRAS                               --->
	<!--- ******************************************************************** --->
	<!---  SE PASO A FUNCIONES VARIOS INSERT A RCUENTASTIPO DEBIDO AQUE LA     --->
	<!---  FUNCION CUENTASTIPO ERA MUY GRANDE Y DABA ERRORES EN JAVA           --->
	<!--- ******************************************************************** --->
	<cffunction name="CuentasTipo_CreaTemp" access="private" output="false">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<!---	Crea las Cuentas que posteriormente seran utilizadas para validar si tienen Presupuesto --->
		<cf_dbtemp name="tempEmpleadosv2" returnvariable="Empleados" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="RCNid"  	type="numeric"	mandatory="yes">
			<cf_dbtempcol name="DEid"		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="RHPid"		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="RHPPid"		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CFid"		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Ecodigo"	type="int"		mandatory="yes">
			<cf_dbtempcol name="Dcodigo"	type="int"		mandatory="yes">
			<cf_dbtempcol name="Ocodigo"	type="int"		mandatory="yes">
            <cf_dbtempindex cols="RCNid,DEid">
		</cf_dbtemp>
		<!--- ***** poner en los inserts el default en 1, cuando no lo pone --->
		<cf_dbtemp name="Errores" returnvariable="Errores" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="tiporeg"  		type="int"				mandatory="no">
			<cf_dbtempcol name="descripcion"	type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="CFformato"		type="varchar(255)"  	mandatory="no">
			<cf_dbtempcol name="tipoerr"		type="int"  			mandatory="no">
		</cf_dbtemp>
		<cf_dbtemp name="tempCargDistri_v1" returnvariable="CargasDistribucion" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DEid"				type="numeric" 		mandatory="yes">
            <cf_dbtempcol name="DClinea"  			type="numeric"		mandatory="yes">
            <cf_dbtempcol name="CIid"  				type="numeric"		mandatory="no">
            <cf_dbtempcol name="RCTid"  			type="numeric"		mandatory="no">
			<cf_dbtempcol name="Evalorpat"			type="money"   	 	mandatory="no">
			<cf_dbtempcol name="DCmetodo"			type="int"			mandatory="no">
			<cf_dbtempcol name="MontoBase"			type="money"		mandatory="no">
			<cf_dbtempcol name="MontoCarga"			type="money"		mandatory="no">
            <cf_dbtempcol name="Prioridad"			type="int"			mandatory="no">
            <cf_dbtempcol name="CFid"				type="numeric"		mandatory="no">
            <cf_dbtempcol name="CFcuentac"			type="varchar(100)"	mandatory="no">
            <cf_dbtempcol name="valor"				type="varchar(100)"	mandatory="no">
			<cf_dbtempcol name="valor2"				type="varchar(100)"	mandatory="no">
            <cf_dbtempcol name="Ocodigo"			type="int"			mandatory="no">
            <cf_dbtempcol name="Dcodigo"			type="int"			mandatory="no">
			<cf_dbtempcol name="Mes"				type="int"			mandatory="no">
            <cf_dbtempcol name="Periodo"			type="int"			mandatory="no">
            <cf_dbtempindex cols="DEid,DClinea,Mes,Periodo,CFid">
 			<cf_dbtempindex cols="DEid,DClinea,CIid">
			<cf_dbtempindex cols="RCTid">
            <!---<cf_dbtempindex cols="CFcuentac, valor,valor2, CFid, Ocodigo, Dcodigo, DEid, DClinea"> --->
		</cf_dbtemp>
         <cf_dbtemp name="tempDistrib_v1" returnvariable="Distribucion" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="RCTidREF"			type="numeric" 		mandatory="yes"><!--- registro (llave) origen --->
            <cf_dbtempcol name="RCNid"  			type="numeric"		mandatory="yes">
            <cf_dbtempcol name="Ecodigo"  			type="int"			mandatory="yes">
	        <cf_dbtempcol name="tiporeg"  			type="int"			mandatory="no">
            <cf_dbtempcol name="DEid"				type="numeric" 		mandatory="no">
            <cf_dbtempcol name="referencia"			type="numeric" 		mandatory="no">
            <cf_dbtempcol name="cuenta"				type="varchar(100)"	mandatory="no">
            <cf_dbtempcol name="valor"				type="varchar(100)"	mandatory="no">
            <cf_dbtempcol name="Cformato"			type="varchar(100)"	mandatory="no">
            <cf_dbtempcol name="Ccuenta"			type="numeric" 		mandatory="no">
            <cf_dbtempcol name="CFcuenta"			type="numeric" 		mandatory="no">
            <cf_dbtempcol name="tipo"				type="char"			mandatory="no">
            <cf_dbtempcol name="CFid"				type="numeric" 		mandatory="no">
            <cf_dbtempcol name="Ocodigo"  			type="int"			mandatory="no">
	        <cf_dbtempcol name="Dcodigo"  			type="int"			mandatory="no">
			<cf_dbtempcol name="montores"			type="float"		mandatory="no">
            <cf_dbtempcol name="vpresupuesto"  		type="int"			mandatory="no">
			<cf_dbtempcol name="BMfechaalta"		type="datetime"   	mandatory="no">
            <cf_dbtempcol name="BMUsucodigo"		type="numeric" 		mandatory="no">
            <cf_dbtempcol name="RHPPid"				type="numeric" 		mandatory="no">
            <cf_dbtempcol name="Periodo"  			type="int"			mandatory="no">
	        <cf_dbtempcol name="Mes"  				type="int"			mandatory="no">
            <cf_dbtempcol name="valor2"				type="varchar(100)"	mandatory="no">
            <cf_dbtempcol name="CSid"				type="numeric" 		mandatory="no">
            <cf_dbtempcol name="procesado"			type="int" 			mandatory="no">
            <cf_dbtempcol name="insertado"			type="int" 			mandatory="no">
            <cf_dbtempcol name="SB_INC"				type="float"		mandatory="no"><!--- Salario base para incidencias --->
            <cf_dbtempcol name="CFidOrigen"			type="numeric" 		mandatory="no"><!--- Centro  funcional origen --->
            <cf_dbtempcol name="montoresORI"		type="float"		mandatory="no"><!--- monto origen  --->
            <cf_dbtempcol name="porcentajeAPL"		type="money"		mandatory="no"><!--- porcentaje de aplicaciÃ³n  --->
            <cf_dbtempcol name="tipod"				type="varchar(25)"	mandatory="no">
 			<cf_dbtempcol name="montoorigen" 		type="float" 		mandatory="no">
 			<cf_dbtempindex cols="RCNid,referencia,Mes,Periodo">
			<cf_dbtempindex cols="RCNid,Mes,Periodo">
		</cf_dbtemp> 
		
		<cf_dbtemp name="tempProporcional_v3" returnvariable="Proporcional" datasource="#Arguments.Conexion#">
            <cf_dbtempcol name="RCNid"  			type="numeric"		mandatory="yes">
			<cf_dbtempcol name="Mes"				type="int"			mandatory="no">
            <cf_dbtempcol name="Periodo"			type="int"			mandatory="no">
			<cf_dbtempcol name="montores"			type="float"		mandatory="no">
			<cf_dbtempcol name="Proporc"			type="float"		mandatory="no">
            <cf_dbtempcol name="referencia"			type="numeric" 		mandatory="no">
			<cf_dbtempindex cols="RCNid">
			<cf_dbtempindex cols="RCNid,referencia">
			<cf_dbtempindex cols="RCNid,Mes,Periodo">
		</cf_dbtemp>  	

		<cf_dbtemp name="TempCargProc_v1" returnvariable="CargasProceso" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DEid"				type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CFid"				type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Ocodigo"			type="int"		mandatory="yes">
			<cf_dbtempcol name="Dcodigo"			type="int"		mandatory="yes">
			<cf_dbtempcol name="DClinea"  			type="numeric"	mandatory="yes">
			<cf_dbtempcol name="Periodo"			type="int"		mandatory="yes">
			<cf_dbtempcol name="Mes"				type="int"		mandatory="yes">
			<cf_dbtempcol name="TotalSalario"		type="money"	mandatory="no">
			<cf_dbtempcol name="TotalCargas"		type="money"	mandatory="no">
			<cf_dbtempcol name="SalarioProrrateado"	type="money"	mandatory="no">
			<cf_dbtempcol name="CargaProrrateada"	type="money"	mandatory="no">		
            <cf_dbtempindex cols="DEid">
            <cf_dbtempindex cols="DEid,DClinea">
            <cf_dbtempindex cols="DEid,DClinea,CFid">
            <cf_dbtempindex cols="DEid,DClinea,Periodo,Mes">
		</cf_dbtemp>
        
		<cf_dbtemp name="CargasResumenv3" returnvariable="CargasResumen" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DEid"						type="numeric"  mandatory="yes">
			<cf_dbtempcol name="DClinea"  					type="numeric"	mandatory="yes">
			<cf_dbtempcol name="CFid"						type="numeric"  mandatory="yes">
			<cf_dbtempcol name="Ocodigo"					type="int"		mandatory="yes">
			<cf_dbtempcol name="Dcodigo"					type="int"		mandatory="yes">
			<cf_dbtempcol name="TotalCargas"				type="money"	mandatory="no">
			<cf_dbtempcol name="TotalCargasProrrateadas"	type="money"	mandatory="no">
			<cf_dbtempcol name="PeriodoM"					type="int"		mandatory="no">
			<cf_dbtempcol name="MesM"						type="int"		mandatory="no">
            <cf_dbtempindex cols="DEid,DClinea,CFid">			
            <cf_dbtempindex cols="DEid,DClinea,CFid, Dcodigo,Ocodigo">			
		</cf_dbtemp>
        
		<cf_dbtemp name="CargasTotalv3" returnvariable="CargasTotal" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="DEid"						type="numeric"  mandatory="yes">
			<cf_dbtempcol name="DClinea"  					type="numeric"	mandatory="yes">
			<cf_dbtempcol name="CFid"						type="numeric"  mandatory="no">
			<cf_dbtempcol name="TotalCargas"				type="money"	mandatory="no">
			<cf_dbtempcol name="TotalCargasProrrateadas"	type="money"	mandatory="no">
			<cf_dbtempcol name="PeriodoM"					type="int"		mandatory="no">
			<cf_dbtempcol name="MesM"						type="int"		mandatory="no">
			<cf_dbtempindex cols="DEid,DClinea">	
			<cf_dbtempindex cols="DEid,DClinea,PeriodoM,MesM">	
		</cf_dbtemp>
		
		
	</cffunction>
	<cffunction name="CuentasTipo_Salarios_D" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">

		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					10, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid=b.CFid 
								 and ec.valor1=c.RHTcuentac ), c.RHTcuentac),
					c.RHTcuentac, 
					null, 
					null, 
					0, 
					'D', 
					b.CFid, 
					b.Ocodigo, 
					b.Dcodigo,  
					sum(a.PEmontores), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					a.DEid, 
					p.RHPPid, 
					a.PElinea, 
					1, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from PagosEmpleado a
            	inner join RHPlazas p
                	on p.RHPid = a.RHPid
                inner join CFuncional b
                	on b.CFid = Coalesce(p.CFidconta,p.CFid)
                inner join RHTipoAccion c
                	on c.RHTid = a.RHTid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.PEhasta < <cfqueryparam cfsqltype="cf_sql_date" value="#vDia1#">		<!--- modificacion agregada en caso de que el pago cubra dos meses contables --->
			  and (not #preservesinglequotes(findoneof)# or c.RHTcuentac is not null)
			group by b.CFcuentac, c.RHTcuentac, b.CFid, b.Ocodigo, b.Dcodigo, a.DEid, a.PElinea, p.RHPPid
		</cfquery>	
		<!--- (Creditos) contra la Cuenta de Pasivo para el Primer Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					11, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 
					'C', 
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					0 as DEid, 
					null as RHPPid, 
					0 as referencia, 
					0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 10
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>	
		<!--- (Debitos) contra la Cuenta de Pasivo para el Segundo Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					11, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">,
					null, 
					null, 
					null, 
					0, 
					'D', 
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					0 as DEid, 
					null as RHPPid, 
					0 as referencia, 
					0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 10
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>
	</cffunction>
	<cffunction name="CuentasTipo_Incidencias_D" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">

		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid,referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					20, 
					c.Cformato, 
					c.Cformato, 
					null, 
					null, 
					0, 
					'D', 
					b.CFid, 
					b.Ocodigo, 
					b.Dcodigo, 
					sum(a.ICmontores), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					a.DEid, 
					p.RHPPid, 
					a.CIid, 
					1, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
                inner join LineaTiempo lt
                	on lt.DEid = a.DEid
                inner join RHPlazas p
                	on p.Ecodigo = lt.Ecodigo
                   and p.RHPid   = lt.RHPid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.ICfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#vDia1#">		<!--- modificacion agregada en caso de que el pago cubra dos meses contables --->
			  and c.CInorealizado = 0
			  and c.Ccuenta is not null
			  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and a.ICfecha between lt.LTdesde and lt.LThasta
			group by c.Ccuenta, c.Cformato, b.CFid, b.Ocodigo, b.Dcodigo, a.DEid, a.CIid, p.RHPPid
		</cfquery>	
		<!--- Incidencias (Debitos) para el Primer Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid,referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 

					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					20, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid=b.CFid 
								 and ec.valor1=c.CIcuentac ), c.CIcuentac),

					c.CIcuentac, 
					null, 
					null, 
					0, 
					'D', 
					b.CFid, 
					b.Ocodigo, 
					b.Dcodigo, 
					sum(a.ICmontores), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					a.DEid, 
					p.RHPPid, 
					a.CIid, 
					1, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
                inner join LineaTiempo lt
                	on lt.DEid = a.DEid
                inner join RHPlazas p
                	 on p.Ecodigo = lt.Ecodigo
					and p.RHPid   = lt.RHPid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.ICfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#vDia1#">		<!--- modificacion agregada en caso de que el pago cubra dos meses contables --->
			  and c.CInorealizado = 0
			  and c.Ccuenta is null
			  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and a.ICfecha between lt.LTdesde and lt.LThasta
			  and (not #preservesinglequotes(findoneof)# or c.CIcuentac is not null)
			group by b.CFcuentac, c.CIcuentac, b.CFid, b.Ocodigo, b.Dcodigo, a.DEid, a.CIid, p.RHPPid
		</cfquery>	
		<!--- (Creditos) contra la Cuenta de Pasivo para el Primer Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					21, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 
					'C', 
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					0 as DEid, 
					null as RHPPid, 
					0 as referencia, 
					0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 20
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>
		<!--- (Debitos) contra la Cuenta de Pasivo para el Segundo Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					21, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 
					'D', 
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					0 as DEid, 
					null as RHPPid, 
					0 as referencia, 
					0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 20
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>
	</cffunction>
	<cffunction name="CuentasTipo_Salarios_2_1" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">	

		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					10, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid=b.CFid 
								 and ec.valor1=c.RHTcuentac ), c.RHTcuentac),
					c.RHTcuentac, 
					null, 
					null, 
					0, 
					'D', 
					b.CFid, 
					b.Ocodigo, 
					b.Dcodigo,  
					sum(a.PEmontores), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					a.DEid, 
					p.RHPPid, 
					a.PElinea, 
					1, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from PagosEmpleado a
            	inner join RHPlazas p
                	on p.RHPid = a.RHPid	
                inner join CFuncional b
                	on b.CFid = Coalesce(p.CFidconta,p.CFid)
                inner join RHTipoAccion c
                	on c.RHTid = a.RHTid	
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.PEhasta >= <cfif isdate(vDia1)><cfqueryparam cfsqltype="cf_sql_date" value="#vDia1#"><cfelse>a.PEhasta</cfif>     <!--- modificacion agregada en caso de que el pago cubra dos meses contables --->
			  and (not #preservesinglequotes(findoneof)# or c.RHTcuentac is not null)
			group by b.CFcuentac, c.RHTcuentac, b.CFid, b.Ocodigo, b.Dcodigo, a.DEid, a.PElinea, p.RHPPid
		</cfquery>

		<!--- Objetos de Gasto (Tipos de Accion) con error --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion)
			select distinct 10, 'El tipo de Accion ' #_Cat# ltrim(rtrim(c.RHTcodigo)) #_Cat# ' no tiene el objeto de gasto definido.'
			from PagosEmpleado a
            	inner join RHPlazas p
                	on p.RHPid = a.RHPid
                inner join CFuncional b
                	on b.CFid = Coalesce(p.CFidconta,p.CFid)
                inner join RHTipoAccion c
                	on c.RHTid = a.RHTid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and #preservesinglequotes(findoneof)#
			  and c.RHTcuentac is null
		</cfquery>	
	</cffunction>	
	<cffunction name="CuentasTipo_Incidencias_CuentaFija" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">		

		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid,referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					20, 
					c.Cformato, 
					c.Cformato, 
					null, null, 0, 'D', b.CFid, b.Ocodigo, b.Dcodigo, 
					sum(a.ICmontores), 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					a.DEid, p.RHPPid, a.CIid, 1, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
                inner join LineaTiempo lt
                	 on lt.DEid = a.DEid
                    and a.ICfecha between lt.LTdesde and lt.LThasta
                inner join RHPlazas p
                	on p.Ecodigo = lt.Ecodigo
                   and p.RHPid   = lt.RHPid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.ICfecha >= <cfif isdate(vDia1)><cfqueryparam cfsqltype="cf_sql_date" value="#vDia1#"><cfelse>a.ICfecha</cfif>     <!--- modificacion agregada en caso de que el pago cubra dos meses contables --->
			  and c.CInorealizado = 0
			  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and c.Ccuenta is not null
			group by c.Ccuenta, c.Cformato, b.CFid, b.Ocodigo, b.Dcodigo, a.DEid, a.CIid, p.RHPPid
		</cfquery>						
		<!--- 2.2b Incidencias --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid,referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					20, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid = b.CFid 
								 and ec.valor1=c.CIcuentac ), c.CIcuentac),
					c.CIcuentac, 
					null, null, 0, 'D', b.CFid, b.Ocodigo, b.Dcodigo, 
					sum(a.ICmontores), 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					a.DEid, p.RHPPid, a.CIid, 1, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
                inner join LineaTiempo lt
            		 on lt.DEid = a.DEid
                    and a.ICfecha between lt.LTdesde and lt.LThasta
                inner join RHPlazas p
					on p.Ecodigo = lt.Ecodigo
                   and p.RHPid   = lt.RHPid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.ICfecha >= <cfif isdate(vDia1)><cfqueryparam cfsqltype="cf_sql_date" value="#vDia1#"><cfelse>a.ICfecha</cfif>     <!--- modificacion agregada en caso de que el pago cubra dos meses contables --->
			  and c.CInorealizado = 0
			  and c.Ccuenta is null
			  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			  and (not #preservesinglequotes(findoneof)# or c.CIcuentac is not null)
			group by b.CFcuentac, c.CIcuentac, b.CFid, b.Ocodigo, b.Dcodigo, a.DEid, a.CIid, p.RHPPid
		</cfquery>						
		<!--- Incidencias con error --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion)
			select distinct 20, 'El concepto de Pago ' #_Cat# ltrim(rtrim(c.CIcodigo)) #_Cat#' no tiene el objeto de gasto definido.'
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid 
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.CInorealizado = 0
			  and #preservesinglequotes(findoneof)#
			  and c.CIcuentac is null
			  and c.Ccuenta is null
		</cfquery>
	</cffunction>
	<cffunction name="CuentasTipo_Pagos_No_Realizados" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">		

		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					25, 
					c.Cformato, 
					c.Cformato, 
					null, null, 'D', b.CFid, b.Ocodigo, b.Dcodigo, sum(a.ICmontores), 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					-1, -1, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.CInorealizado = 1
			  and c.Ccuenta is not null
			group by c.Ccuenta, c.Cformato, b.CFid, b.Ocodigo, b.Dcodigo
		</cfquery>
		<!--- 2.25b Pagos no Realizados --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					25, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid = b.CFid 
								 and ec.valor1=c.CIcuentac ), c.CIcuentac),
					c.CIcuentac, 
					null, null, 'D', b.CFid, b.Ocodigo, b.Dcodigo, sum(a.ICmontores), 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					-1, -1, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.CInorealizado = 1
			  and c.Ccuenta is null
			  and (not #preservesinglequotes(findoneof)# or c.CIcuentac is not null)
			group by b.CFcuentac, c.CIcuentac, b.CFid, b.Ocodigo, b.Dcodigo
		</cfquery>
		<!--- Objetos de Gasto (Pagos no Realizados) con error --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion)
			select distinct 25, 'El concepto de Pago ' #_Cat# ltrim(rtrim(c.CIcodigo)) #_Cat# ' no tiene el objeto de gasto definido.'
			from IncidenciasCalculo a
            	inner join CFuncional b
                	on b.CFid = a.CFid
                inner join CIncidentes c
                	on c.CIid = a.CIid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and c.CInorealizado = 1
			  and #preservesinglequotes(findoneof)#
			  and c.CIcuentac is null
			  and c.Ccuenta is null
		</cfquery>
	</cffunction>	
	
	
	<cffunction name="CuentasTipo_PRORRATEO_DE_CARGAS" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">

		
		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">

<!--- El CFID no puede salir de la TEMP, debe SALIR de RCUENTASTIPO LZ--->
			insert into #CargasProceso#(DEid, CFid, Ocodigo, Dcodigo, DClinea, Periodo, Mes, TotalSalario, TotalCargas, SalarioProrrateado, CargaProrrateada)
			select emp.DEid, rt.CFid, b.Ocodigo, b.Dcodigo, a.DClinea, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">,
					0.00, 0.00, 0.00, 0.00
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DCargas c
                	 on c.DClinea = a.DClinea
                inner join CFuncional b
                	 on b.CFid = emp.CFid
                inner join RCuentasTipo rt
                	 on rt.RCNid = a.RCNid
                    and rt.DEid  =  a.DEid
			where a.CCvalorpat != 0.00
<!--- LZ20110519			  and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->--->
			  and (not #preservesinglequotes(findoneof)# or c.DCcuentac is not null)
			  and rt.Mes 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			  and rt.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			group by emp.DEid, rt.CFid, b.Ocodigo, b.Dcodigo, a.DClinea
		</cfquery>
		<!--- Segundo Mes --->
		<!--- El CFID no puede salir de la TEMP, debe SALIR de RCUENTASTIPO LZ--->	
        <cfquery datasource="#arguments.conexion#">
			insert into #CargasProceso#(DEid, CFid, Ocodigo, Dcodigo, DClinea, Periodo, Mes, TotalSalario, TotalCargas, SalarioProrrateado, CargaProrrateada)
			select emp.DEid, rt.CFid, b.Ocodigo, b.Dcodigo, a.DClinea, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">,
				0.00, 0.00, 0.00, 0.00
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join CFuncional b
                	on b.CFid = emp.CFid
                inner join RCuentasTipo rt
                	 on rt.RCNid = a.RCNid
                    and rt.DEid  = a.DEid
			where a.CCvalorpat != 0.00
<!---LZ20110519			  and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->--->
			  and (not #preservesinglequotes(findoneof)#  or c.DCcuentac is not null)
			  and rt.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			  and rt.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">	
			group by emp.DEid, rt.CFid, b.Ocodigo, b.Dcodigo, a.DClinea
		</cfquery>	
		<!--- Insertar registros en tabla para ajuste de diferencias en el prorrateo de cargas --->
			
									
		<cfquery datasource="#arguments.conexion#">
			insert into #CargasResumen#(DEid, DClinea, CFid, Dcodigo, Ocodigo, TotalCargas, TotalCargasProrrateadas)
			select distinct DEid, DClinea, CFid, Dcodigo, Ocodigo, 0.00, 0.00
			from #CargasProceso#
		</cfquery>
		
		<!--- AVERIGUAR EL TOTAL DE SALARIOS + INCIDENCIAS, TOTAL POR CARGA y SALARIO PRORRATEADO POR EMPLEADO --->
		<cfquery datasource="#arguments.conexion#">
			update #CargasProceso# 
			set	TotalSalario = (	select sum(x.montores)
									from RCuentasTipo x
									where x.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									and x.tiporeg in (10,20)
									and x.DEid = #CargasProceso#.DEid),
				TotalCargas = (		select sum(a.CCvalorpat)
									from CargasCalculo a, DCargas c, CFuncional b
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									and a.DEid = #CargasProceso#.DEid
									and a.DClinea = #CargasProceso#.DClinea
									and a.CCvalorpat != 0.00
									and c.DClinea = a.DClinea
<!---LZ20110519			  					and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->--->
									and b.CFid = #CargasProceso#.CFid
									and (not #preservesinglequotes(findoneof)# or c.DCcuentac is not null)),
				SalarioProrrateado = (	select sum(x.montores)
										from RCuentasTipo x
										where x.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
										and x.tiporeg in (10,20)
										and x.DEid = #CargasProceso#.DEid
										and x.Periodo = #CargasProceso#.Periodo
										and x.Mes = #CargasProceso#.Mes
										and x.CFid = #CargasProceso#.CFid
										and x.Dcodigo = #CargasProceso#.Dcodigo
										and x.Ocodigo = #CargasProceso#.Ocodigo ),
				CargaProrrateada = 0.00
		</cfquery>
		<!--- CALCULO DE CARGAS PRORRATEADO --->
		<cfquery datasource="#arguments.conexion#">
			update #CargasProceso# 
			set CargaProrrateada = round((SalarioProrrateado * TotalCargas) / TotalSalario, 2)
		</cfquery>	
		
		<cfquery datasource="#arguments.conexion#">
			update #CargasResumen# 
			set TotalCargas = (	select sum(a.CCvalorpat)
								from CargasCalculo a, DCargas c, CFuncional b
								where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
								and a.DEid = #CargasResumen#.DEid
								and a.DClinea = #CargasResumen#.DClinea
								and a.CCvalorpat != 0.00
								and c.DClinea = a.DClinea
<!---LZ20110519			  				and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->--->
								and b.CFid = #CargasResumen#.CFid
								and (not #preservesinglequotes(findoneof)# or c.DCcuentac is not null)),
				TotalCargasProrrateadas = (	select sum(CargaProrrateada)
											from #CargasProceso# x
											where x.DEid = #CargasResumen#.DEid
											and x.DClinea = #CargasResumen#.DClinea
											and x.CFid = #CargasResumen#.CFid
											and x.Dcodigo = #CargasResumen#.Dcodigo
											and x.Ocodigo = #CargasResumen#.Ocodigo
<!---  LZ Se asocia el  Mes Periodo a la Table Resumen, para que aterrice contra la proceso como debería
									and x.Mes = #CargasResumen#.MesM
									and x.Periodo = #CargasResumen#.PeriodoM  --->
											)
		</cfquery>

				<cfquery datasource="#arguments.conexion#">
			insert into #CargasTotal#(DEid, DClinea, TotalCargas, TotalCargasProrrateadas)
			select DEid, DClinea, 0.00, sum(CargaProrrateada)
			from #CargasProceso#
			group by DEid, DClinea
		</cfquery> 
	
			
		<cfquery datasource="#arguments.conexion#">
			update #CargasTotal#
			set TotalCargas = (		select sum(a.CCvalorpat)
									from CargasCalculo a, DCargas c
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									and a.DEid = #CargasTotal#.DEid
									and a.DClinea = #CargasTotal#.DClinea
									and a.CCvalorpat != 0.00
									and c.DClinea = a.DClinea
									and c.DClinea = #CargasTotal#.DClinea
<!---LZ20110519			  					and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->--->
									and c.DCcuentac is not null
								)
		</cfquery>
		
		
		<!--- Averiguar si hay que ajustar los montos de cargas prorrateados --->
		<cfquery name="rs_diferencia" datasource="#arguments.conexion#">
			select 1 from #CargasTotal# 
			where TotalCargas != TotalCargasProrrateadas
		</cfquery>
		
		<cfif rs_diferencia.recordcount gt 0>
		
			<cfquery datasource="#arguments.conexion#">
				update #CargasTotal# 
				set	PeriodoM = (	select max(Periodo)
									from #CargasProceso# x
									where x.DEid = #CargasTotal#.DEid
									and x.DClinea = #CargasTotal#.DClinea
									and x.CargaProrrateada = (	select max(CargaProrrateada)
																from #CargasProceso# y
																where y.DEid = #CargasTotal#.DEid
																and y.DClinea = #CargasTotal#.DClinea
																) ),
					MesM = (	select max(Mes)
								from #CargasProceso# x
								where x.DEid = #CargasTotal#.DEid
								and x.DClinea = #CargasTotal#.DClinea
								and x.CargaProrrateada = (	select max(CargaProrrateada)
															from #CargasProceso# y
															where y.DEid = #CargasTotal#.DEid
															and y.DClinea = #CargasTotal#.DClinea
															) )
			</cfquery>

			<cfquery datasource="#arguments.conexion#">
				update #CargasProceso#
					set CargaProrrateada = CargaProrrateada + ( select (b.TotalCargas - b.TotalCargasProrrateadas)
																from #CargasTotal# b
																where #CargasProceso#.DEid = b.DEid
																and #CargasProceso#.DClinea = b.DClinea
																and #CargasProceso#.Periodo = b.PeriodoM
																and #CargasProceso#.Mes = b.MesM
																and b.TotalCargas != b.TotalCargasProrrateadas						
																)
				
				where exists ( 	select 1 
								from #CargasTotal# b
								where #CargasProceso#.DEid = b.DEid
								and #CargasProceso#.DClinea = b.DClinea
								and #CargasProceso#.Periodo = b.PeriodoM
								and #CargasProceso#.Mes = b.MesM
								and b.TotalCargas != b.TotalCargasProrrateadas
							)
				and CFid = (select max(CFid) from #CargasProceso# b
							where #CargasProceso#.DEid = b.DEid
								and #CargasProceso#.DClinea = b.DClinea
								and #CargasProceso#.Periodo = b.Periodo
								and #CargasProceso#.Mes = b.Mes
							 )
			</cfquery>
		</cfif>	
	</cffunction>
	<cffunction name="CuentasTipo_Insertar_Cargas1" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		<!--- Insertar Cargas en RCuentasTipo para el Primer Mes --->
		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					30, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid = b.CFid 
								 and ec.valor1=c.DCcuentac ), c.DCcuentac),
					c.DCcuentac, 
					null, null, 0, 'D', b.CFid, b.Ocodigo, b.Dcodigo, cp.CargaProrrateada, 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					cp.DEid, emp.RHPPid, cp.DClinea, 1, cp.Periodo, cp.Mes
			from #CargasProceso# cp, 
			      DCargas c, 
			      CFuncional b, 
			     #Empleados# emp
			where cp.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			and cp.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			and c.DClinea = cp.DClinea
			and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->
			and b.CFid = cp.CFid
			and emp.DEid = cp.DEid
			and cp.CargaProrrateada != 0
		</cfquery>
<!--- 20110519 LZ Insertar Cargas en RCuentasTipo para el Primer Mes --->		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					40, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid = b.CFid 
								 and ec.valor1=c.DCcuentac ), c.DCcuentac),
					c.DCcuentac, 
					null, null, 0, 'D', b.CFid, b.Ocodigo, b.Dcodigo, cp.CargaProrrateada, 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					cp.DEid, emp.RHPPid, cp.DClinea, 1, cp.Periodo, cp.Mes
			from #CargasProceso# cp, 
			      DCargas c, 
			      CFuncional b, 
			     #Empleados# emp
			where cp.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			and cp.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			and c.DClinea = cp.DClinea
			and c.DCtipo = 1                 <!--- Solo las que no son una cuenta por Cobrar --->
			and b.CFid = cp.CFid
			and emp.DEid = cp.DEid
			and cp.CargaProrrateada != 0
		</cfquery>	
			

		<!--- Insertar Cargas en RCuentasTipo para el Segundo Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					30, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid = b.CFid 
								 and ec.valor1=c.DCcuentac ), c.DCcuentac),
					c.DCcuentac, 
					null, null, 0, 'D', b.CFid, b.Ocodigo, b.Dcodigo, cp.CargaProrrateada, 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					cp.DEid, emp.RHPPid, cp.DClinea, 1, cp.Periodo, cp.Mes
			from #CargasProceso# cp
            	inner join DCargas c
                	on c.DClinea = cp.DClinea
                inner join CFuncional b
                	on b.CFid = cp.CFid
                inner join #Empleados# emp
                	on emp.DEid = cp.DEid
			where cp.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">
			  and cp.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			  and c.DCtipo   = 0                 <!--- Solo las que no son una cuenta por Cobrar --->
			  and cp.CargaProrrateada != 0
		</cfquery>

<!--- 20110519 LZ Insertar Cargas en RCuentasTipo para el Segundo Mes --->		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					40, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid = b.CFid 
								 and ec.valor1=c.DCcuentac ), c.DCcuentac),
					c.DCcuentac, 
					null, null, 0, 'D', b.CFid, b.Ocodigo, b.Dcodigo, cp.CargaProrrateada, 
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">,
					cp.DEid, emp.RHPPid, cp.DClinea, 1, cp.Periodo, cp.Mes
			from #CargasProceso# cp
            	inner join DCargas c
                	on c.DClinea = cp.DClinea
                inner join CFuncional b
                	on b.CFid = cp.CFid
                inner join #Empleados# emp
                	on emp.DEid = cp.DEid
			where cp.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">
			  and cp.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			  and c.DCtipo   = 1                 <!--- Solo las que son una cuenta por Cobrar --->
			  and cp.CargaProrrateada != 0
		</cfquery>
				
					
		<!--- (Creditos) contra la Cuenta de Pasivo para el Primer Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					31, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 
					'C', 
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid, 0 as referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 30
			and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>	
		
		<!--- 20110519 LZ (Creditos) contra la Cuenta de Pasivo para el Primer Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					41, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 
					'C', 
					a.CFid, 
					a.Ocodigo, 
					a.Dcodigo, 
					round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid, 0 as referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 40
			and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>			
					
		<!--- (Debitos) contra la Cuenta de Pasivo para el Segundo Mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					31, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 'D', a.CFid, a.Ocodigo, a.Dcodigo, round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid, 0 as referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 30
			and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>	
		<!--- (Debitos) 20110519 LZ contra la Cuenta de Pasivo para el Segundo Mes --->		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	a.RCNid, 
					a.Ecodigo, 
					41, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 
					null, 
					null, 
					null, 
					0, 'D', a.CFid, a.Ocodigo, a.Dcodigo, round(sum(a.montores),2), 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid, 0 as referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from RCuentasTipo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and a.tiporeg = 40
			and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
			and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			group by a.RCNid, a.Ecodigo, a.CFid, a.Ocodigo, a.Dcodigo
		</cfquery>			
	</cffunction>	
	<cffunction name="CuentasTipo_Insertar_Cargas2" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		
		<cf_dbfunction name="findOneOf" args="b.CFcuentac, ?!*" returnvariable="findoneof">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">,
					30, 
					b.CFcuentac, 
					coalesce(( select ec.valor2 
							   from CFExcepcionCuenta ec
							   where ec.CFid=b.CFid 
								 and ec.valor1=c.DCcuentac ), c.DCcuentac),
					c.DCcuentac, 
					null, 
					null, 
					0, 
					'D', 
					b.CFid, 
					b.Ocodigo, 
					b.Dcodigo, 
					sum(a.CCvalorpat), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					emp.DEid, emp.RHPPid, a.DClinea, 1,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join CFuncional b
                	on b.CFid = emp.CFid
			where a.CCvalorpat != 0.00
			  and c.DCtipo = 0                 <!--- Solo las que no son una cuenta por Cobrar --->
			  and (not #preservesinglequotes(findoneof)# or c.DCcuentac is not null)
			group by b.CFcuentac, c.DCcuentac, b.CFid, b.Ocodigo, b.Dcodigo, emp.DEid, emp.RHPPid, a.DClinea
		</cfquery>
	</cffunction>	
	
	<cffunction name="CuentasTipo_tiporeg_40" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					40, cc.Cformato, null, null, null, 'D', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.CCvalorpat), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					-1, c.DClinea, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join SNegocios s
                	 on s.Ecodigo  = c.Ecodigo
                    and s.SNcodigo = c.SNreferencia
                inner join CContables cc
                	 on cc.Ccuenta = s.SNcuentacxc
                    and cc.Ecodigo = s.Ecodigo
			where a.CCvalorpat != 0.00
			  and c.DCtipo   = 1                 <!--- Solo las que son una cuenta por Cobrar --->
			  and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			group by cc.Cformato, emp.CFid, emp.Ocodigo, emp.Dcodigo, c.DClinea
		</cfquery>
				
		<!--- Cuenta Contable del Socio de Negocio no definida --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion, tipoerr)
			select distinct 40, 'El Socio de Negocios ' #_Cat# ltrim(rtrim(s.SNnombre)) #_Cat#  ' no tiene cuenta contable de CxC definida.', 1
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join SNegocios s
                	 on s.Ecodigo = c.Ecodigo
                    and s.SNcodigo = c.SNreferencia 
			where a.CCvalorpat != 0.00
			and c.DCtipo = 1					<!--- Solo las que son una cuenta por Cobrar --->
			and (s.SNcuentacxc is null
			 or (select count(1) 
                    from CContables cc
				where cc.Ccuenta     = s.SNcuentacxc
				  and cc.Ecodigo     = s.Ecodigo
				  and cc.Cmovimiento = 'S'
				  and cc.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">) = 0)
		</cfquery>	
	</cffunction>
	<cffunction name="CuentasTipo_tiporeg_50_55" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo( RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes )
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					50, cc.Cformato, null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.CCvaloremp), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					-1, c.DClinea, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join SNegocios s
                	 on s.Ecodigo  = c.Ecodigo
                    and s.SNcodigo = c.SNcodigo
                inner join CContables cc
                	 on cc.Ccuenta = s.SNcuentacxp
                    and cc.Ecodigo = s.Ecodigo
			where a.CCvaloremp != 0
			  and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			group by cc.Cformato, emp.CFid, emp.Ocodigo, emp.Dcodigo, c.DClinea
		</cfquery>				
		<!--- Cuenta Contable del Socio de Negocio no definida --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion, tipoerr)
			select distinct 50, 'El Socio de Negocios ' #_Cat# ltrim(rtrim(s.SNnombre)) #_Cat# ' no tiene cuenta contable de CxP definida.', 1
			from #Empleados# emp
            	inner join CargasCalculo a
            		 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
           	 	inner join DCargas c
            		on c.DClinea = a.DClinea
           		inner join SNegocios s
            		 on s.Ecodigo  = c.Ecodigo
					and s.SNcodigo = c.SNcodigo
			where a.CCvaloremp != 0
			and (s.SNcuentacxp is null
			 or (select count(1) 
                    from CContables cc
				 where cc.Ccuenta     = s.SNcuentacxp
				   and cc.Ecodigo     = s.Ecodigo
				   and cc.Cmovimiento = 'S'
				   and cc.Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				   and cc.Cformato is not null) = 0)
		</cfquery>
		<!--- 2.51 Cargas Patronales --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					55, cc.Cformato, null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.CCvalorpat), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					-1, c.DClinea, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
                    and a.DEid = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join SNegocios s
                	 on s.Ecodigo  = c.Ecodigo
                    and s.SNcodigo = c.SNcodigo
                inner join CContables cc
                	on cc.Ccuenta  = s.SNcuentacxp
			where a.CCvalorpat != 0
			  and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			group by cc.Cformato, emp.CFid, emp.Ocodigo, emp.Dcodigo, c.DClinea
		</cfquery>
		<!--- Cuenta Contable del Socio de Negocio no definida --->
		<cfquery datasource="#arguments.conexion#">
			insert into #Errores#(tiporeg, descripcion, tipoerr)
			select distinct 55, 'El Socio de Negocios ' #_Cat# ltrim(rtrim(s.SNnombre)) #_Cat# ' no tiene cuenta contable de CxP definida.', 1
			 from #Empleados# emp
            	inner join CargasCalculo a
                	 on a.RCNid = emp.RCNid
					and a.DEid  = emp.DEid
                inner join DCargas c
                	on c.DClinea = a.DClinea
                inner join SNegocios s
                	 on s.Ecodigo  = c.Ecodigo
					and s.SNcodigo = c.SNcodigo
			where a.CCvalorpat != 0
			and (s.SNcuentacxp is null
			 or (select Count(1) 
				   from CContables cc
				 where cc.Ccuenta = s.SNcuentacxp
				   and cc.Ecodigo = s.Ecodigo
				   and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				   and cc.Cformato is not null) = 0)
		</cfquery>
		<!--- 2.6 Deducciones del Empleado --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					60, cc.Cformato, null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.DCvalor - a.DCinteres), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					-1, a.Did, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join DeduccionesCalculo a
                	 on a.RCNid = emp.RCNid	
                    and a.DEid  = emp.DEid
                inner join DeduccionesEmpleado c
                	 on c.Did     = a.Did
                inner join SNegocios s
                	on s.SNcodigo = c.SNcodigo
                   and s.Ecodigo  = c.Ecodigo
                inner join CContables cc
                	on cc.Ccuenta = s.SNcuentacxp
			where a.DCvalor != 0
			  and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			group by cc.Cformato, emp.CFid, emp.Ocodigo, emp.Dcodigo, a.Did
		</cfquery>
	</cffunction>	
	<cffunction name="CuentasTipo_tiporeg_61" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					61, cc.Cformato, null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.DCinteres), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					-1, -1, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join DeduccionesCalculo a
                	 on a.RCNid = emp.RCNid	
                    and a.DEid  = emp.DEid
                inner join DeduccionesEmpleado c
                	on c.Did = a.Did
                inner join TDeduccion td
                	on td.TDid = c.TDid
                inner join CContables cc
                	on cc.Ccuenta = td.cuentaint
			where a.DCvalor != 0
			  and a.DCinteres > 0
			  and cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			group by cc.Cformato, emp.CFid, emp.Ocodigo, emp.Dcodigo
		</cfquery>		
	</cffunction>
	<cffunction name="CuentasTipo_tiporeg_70" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					70, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vcuentarentafmt#">, 
					null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.SErenta), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					-1, -1, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join SalarioEmpleado a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
			where a.SErenta != 0.00
			group by emp.CFid, emp.Ocodigo, emp.Dcodigo
		</cfquery>		
	</cffunction>			
	<cffunction name="CuentasTipo_tiporeg_80" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">		
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					80, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vcuentabancofmt#">,  
					null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.SEliquido), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					emp.DEid, -1, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join SalarioEmpleado a
                	 on a.RCNid = emp.RCNid
                    and a.DEid  = emp.DEid
                inner join DatosEmpleado de
                	on de.DEid = a.DEid
			where de.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vBid#">    <!--- Solo cuando es en el mismo banco --->
			group by emp.CFid, emp.Ocodigo, emp.Dcodigo, emp.DEid
		</cfquery>
		<!--- 2.81 Salarios por Pagar para los empleados que no se paguen con la cuenta bancaria seleccionada (en el mismo banco) --->
		<cfquery datasource="#arguments.conexion#">
			insert into RCuentasTipo(RCNid,Ecodigo, tiporeg, cuenta, valor, Cformato, Ccuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, referencia, vpresupuesto, Periodo, Mes)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> , 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">, 
					85, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentapnorealfmt#">, 
					null, null, null, 'C', emp.CFid, emp.Ocodigo, emp.Dcodigo, sum(a.SEliquido), 
					<cf_dbfunction name="now">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					emp.DEid, -1, 0, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
			from #Empleados# emp
            	inner join SalarioEmpleado a
                	 on a.RCNid = emp.RCNid	
                    and a.DEid  = emp.DEid
                inner join DatosEmpleado de
                	on de.DEid = a.DEid
			where (de.Bid is null or de.Bid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#vBid#"> )   
			 <!--- Solo cuando NO es en el mismo banco o el empleado no tiene banco asignado --->
			group by emp.CFid, emp.Ocodigo, emp.Dcodigo, emp.DEid
		</cfquery>
	</cffunction>
	
	
	<cffunction name="CuentasTipo_DistribucionCargas" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">	
		<!--- Precarga las cargas obrero patronal para cada una de las incidencias que no se encuentran en el mismo centro funcional del empleado --->
		
		<cfquery name="rsInsert" datasource="#arguments.conexion#">
			insert into #CargasDistribucion# (DEid,CIid,DClinea,Evalorpat,DCmetodo,MontoBase,MontoCarga,Prioridad,CFid,CFcuentac,valor,valor2,Ocodigo,Dcodigo, Mes, Periodo) 
			select 
				a.DEid,
				c.CIid,
				a.DClinea,
				coalesce(a.CEvalorpat,coalesce(b.DCvalorpat,0)) as Evalorpat,
				DCmetodo,
				c.ICmontores,
				0.00,
				coalesce(e.ECprioridad, 0) as Prioridad,
				c.CFid,
				cf.CFcuentac,
				coalesce(( select ec.valor2 
						   from CFExcepcionCuenta ec
						   where ec.CFid=cf.CFid 
							 and ec.valor1=b.DCcuentac ), b.DCcuentac),
				b.DCcuentac,
				cf.Ocodigo,
				cf.Dcodigo,
				rt.Mes,
				rt.Periodo
			from CargasEmpleado  a 
			inner join  DCargas b
				on b.DClinea = a.DClinea
			inner join ECargas e
				on e.ECid = b.ECid
			inner join IncidenciasCalculo c
				on  a.DEid = c.DEid
				and c.RCNid =  #Arguments.RCNid#
				and c.ICmontores > 0
			inner join CIncidentes d
				on  c.CIid = d.CIid
				and d.Ecodigo = #Arguments.Ecodigo# 
				and d.CIredondeo   = 0
			inner join  LineaTiempo lt
				on c.DEid = lt.DEid
				and c.ICfecha between lt.LTdesde and lt.LThasta
				and lt.Ecodigo = #Arguments.Ecodigo# 
			inner join  RHPlazas p   
				on lt.Ecodigo = p.Ecodigo
				and lt.RHPid = p.RHPid
				and  c.CFid != coalesce(p.CFidconta,p.CFid)
			inner join CFuncional cf
				on c.CFid = cf.CFid
			inner join RCuentasTipo rt
				 on rt.RCNid   = c.RCNid 
                and rt.Ecodigo = d.Ecodigo
                and rt.DEid = a.DEid
				and rt.referencia=a.DClinea
			where coalesce(a.CEvalorpat,coalesce(b.DCvalorpat,0)) > 0 
		</cfquery>	

		<!---  Actualiza la llave de RCuentasTipo asociada a la carga del empleado --->
		<cfquery name="rsupdate" datasource="#arguments.conexion#">
			 update #CargasDistribucion# 
			 set RCTid =( 	select a.RCTid 
			 				from RCuentasTipo a  
							where   a.DEid 		 = #CargasDistribucion#.DEid
							and 	a.referencia = #CargasDistribucion#.DClinea
							and 	a.tiporeg 	 = 30
							and 	a.RCNid      = #Arguments.RCNid#
			<!--- LZ Se incluyo Periodo, Mes CFid en la Relacion Unica --->							
							and 	a.Mes		 = #CargasDistribucion#.Mes
							and 	a.Periodo	 = #CargasDistribucion#.Periodo
							and 	a.CFid	 	 = #CargasDistribucion#.CFid
					 )
		</cfquery>
		<!---  borra las cargas que no fueron contempladas en RCuentasTipo--->
		<cfquery name="rsdelete" datasource="#arguments.conexion#">
			delete from #CargasDistribucion# 
			where RCTid is null
		</cfquery>
        <cfquery name="rsupdate" datasource="#arguments.conexion#">
            update  #CargasDistribucion# set MontoCarga = 
                case DCmetodo when 1 then 
                    round(MontoBase * coalesce(Evalorpat, 100) / 100, 2)
                else Evalorpat end
		</cfquery>
        
		<cfquery name="rsCargas" datasource="#arguments.conexion#">
			update RCuentasTipo 
			set montores = coalesce(montores,0) - 
				coalesce(
					(select coalesce(sum(MontoCarga),0) 
					 from #CargasDistribucion# 
					 where  RCuentasTipo.RCTid = #CargasDistribucion#.RCTid
					 )
				, 0.00)
			where RCNid   = #Arguments.RCNid#
              and Ecodigo = #session.Ecodigo#
		 </cfquery>
		 
	 
		<cfquery datasource="#arguments.conexion#" name="FFF">
		   insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, valor2, Cformato, Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Mes, Periodo)
			select 	#Arguments.RCNid#,
					#Arguments.Ecodigo#,
					30, 
					b.CFcuentac, 
					b.valor,
					b.valor2, 
					null, 
					null, 
					0, 
					'D', 
					b.CFid, 
					b.Ocodigo, 
					b.Dcodigo, 
					sum(b.MontoCarga), 
					<cf_dbfunction name="now">, 
					#arguments.Usucodigo#, 
					b.DEid, 
					a.RHPPid,
					b.DClinea,
					1,
					a.Mes,
					a.Periodo
			from #CargasDistribucion# b
				inner join RCuentasTipo a
				on  a.RCTid = b.RCTid
				and a.DEid    = b.DEid
		   group by a.Mes, a.Periodo, b.CFcuentac, b.valor,b.valor2, b.CFid, b.Ocodigo, b.Dcodigo, b.DEid, a.RHPPid, b.DClinea 
		</cfquery>
		<cfquery name="rsdelete" datasource="#arguments.conexion#">
			delete from #CargasDistribucion# 
		</cfquery>
	</cffunction>
	<cffunction name="DistribucionCargasPatronales_X_mes" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		<cfargument name="debug" type="boolean" required="no" default="false">
		<!--- Paso 1 Verifica si los parametros permiten la distribucion de cargas patronles por mes --->	
		<cfquery name="rsValida490" datasource="#arguments.conexion#">
			select Pvalor
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and Pcodigo = 490
		</cfquery>
		
		<cfquery name="rsValida1080" datasource="#arguments.conexion#">
			select Pvalor
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and Pcodigo = 1080
		</cfquery>
		<cfset Lvar_490 = 0>
		<cfset Lvar_1080 = 0>
		<cfif rsValida490.recordCount GT 0>
			<cfset Lvar_490 = rsValida490.Pvalor>
		</cfif>
		<cfif rsValida1080.recordCount GT 0>
			<cfset Lvar_1080 = rsValida1080.Pvalor>
		</cfif>
			<cfquery datasource="#arguments.conexion#" name="rsdistribuye">
				Select RCNid, Periodo, Mes
				from RCuentasTipo 
				where RCNid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (30,40)
				Group by RCNid, Periodo, Mes
			</cfquery>				
		<cfif Lvar_1080 eq 1 and  Lvar_490 eq 1  and rsdistribuye.recordCount GT 1 and isdefined("rsdistribuye")>
			<cfquery datasource="#arguments.conexion#" name="rsborrar">
				delete from #Distribucion#
			</cfquery> 
			<!--- Paso 2 inicia proceso de distribucion --->	
			<!--- Paso 2.1 copia los registros 55 en la tabla temporal --->
			<!--- Paso 2.1 55 actual --->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into #Distribucion# (	RCTidREF,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
											valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
											vpresupuesto,BMfechaalta,
											BMUsucodigo,RHPPid,Periodo,Mes,referencia)
				select 
					RCTid,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
					valor, valor2, Cformato, Ccuenta, 
					CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
					vpresupuesto,BMfechaalta,
					BMUsucodigo,RHPPid,Periodo,Mes,referencia
				from RCuentasTipo 
				where RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (55)
			</cfquery>
					
			<!--- Paso 2.1 55 mes anterior --->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into #Distribucion# (	RCTidREF,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
											valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
											vpresupuesto,BMfechaalta,
											BMUsucodigo,RHPPid,Periodo,Mes,referencia)
				select 
					RCTidREF,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
					valor, valor2, Cformato, Ccuenta, 
					CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
					vpresupuesto,BMfechaalta,BMUsucodigo,RHPPid,
					case when Mes = 1 then Periodo-1  else Periodo end,
					case when Mes = 1 then 12  else Mes-1 end,
					referencia
				from #Distribucion# 
			</cfquery>

			<!--- Paso 2.1 Calcula los proporcionales en base a los Registros 30  --->
			<cfquery datasource="#arguments.conexion#" name="rsproporcional">
				insert into  #Proporcional# (RCNid,Periodo,Mes,montores,Proporc,referencia)
				Select RCNid, Periodo, Mes, Sum(montores) as Monto, 0 as Proporc,referencia
				from RCuentasTipo 
				where RCNid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (30,40)
				Group by RCNid, Periodo, Mes,referencia
			</cfquery>
			<cfquery datasource="#arguments.conexion#" name="rsproporcional">
				update #Proporcional# 
				set Proporc = montores / (Select Sum(montores)
												From #Proporcional# a
												Where a.RCNid=#Proporcional#.RCNid
												and a.referencia=#Proporcional#.referencia)
			</cfquery>

			<cfquery datasource="#arguments.conexion#" name="rsproporcional">
				update #Distribucion# 
				set montores= montores * (Select Proporc
					from #Proporcional#  a
					Where  #Distribucion#.RCNid=a.RCNid
					and    #Distribucion#.referencia=a.referencia
					and    #Distribucion#.Mes=a.Mes
					and    #Distribucion#.Periodo=a.Periodo )
			</cfquery>		
		<cfif arguments.debug >
				<cfquery datasource="#arguments.conexion#" name="rscopiar">
					Select 'Registro 30,40 en RCuentasTipo' as Label, RCNid, tiporeg, Mes, Periodo,referencia, sum(montores)
					from RCuentasTipo 
					where RCNid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and   Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
					and   tiporeg in (30,40)
					Group by RCNid, tiporeg, Mes, Periodo,referencia
				</cfquery>
				<cfdump var="#rscopiar#">
				<cfquery datasource="#arguments.conexion#" name="rscopiar">
					Select 'Registro 55 en Distribucion', RCNid, tiporeg, Mes, Periodo,referencia, sum(montores)
					from #Distribucion# 
					Group by RCNid, tiporeg, Mes, Periodo,referencia
				</cfquery>
				<cf_dump var="#rscopiar#">
			</cfif>
			
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into RCuentasTipo  (RCNid, Ecodigo, tiporeg,DEid, cuenta, 
											valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
											vpresupuesto,BMfechaalta,
											BMUsucodigo,RHPPid,Periodo,Mes,referencia)
				select 
					RCNid, Ecodigo, 56,DEid, cuenta, 
					valor, valor2, Cformato, Ccuenta, 
					CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
					vpresupuesto,BMfechaalta,
					BMUsucodigo,RHPPid,Periodo,Mes,referencia
				from #Distribucion#

			</cfquery>
			<cfquery datasource="#arguments.conexion#" name="rsborrar">
				delete from #Distribucion#
			</cfquery> 
			<cfquery datasource="#arguments.conexion#" name="rsborrar">
				delete from #Proporcional#
			</cfquery> 
			
			
			<cfquery datasource="#arguments.conexion#" name="rs30ant">
				select sum(montores) as montores30ant ,referencia
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg in (30,40)
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
				and a.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#"> 
				group by referencia
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#" name="rs30act">
				select  sum(montores) as montores30act ,referencia
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg in (30, 40)
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">
				and a.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#"> 
				group by referencia
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#" name="rs56ant">
				select  sum(montores) as montores56ant , min(RCTid)as RCTid,referencia
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg = 56
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
				and a.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#"> 
				group by referencia
			</cfquery>

			<cfquery datasource="#arguments.conexion#" name="rs56act">
				select  sum(montores) as montores56act , min(RCTid)as RCTid,referencia
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg = 56
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">
				and a.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#"> 
				group by referencia
			</cfquery>	
	
			<cfquery dbtype="query"  name="rs30ant_rs56ant">
				select 
					(rs30ant.montores30ant -  rs56ant.montores56ant) montores ,rs56ant.RCTid
				from rs30ant ,rs56ant 
				where rs30ant.referencia = rs56ant.referencia
			</cfquery>
			
			<cfset montores56ant       = 0>
			<cfset vrs56antRCTid	   = 0>
			
			<cfloop query="rs30ant_rs56ant">
				<cfset montores56ant   = 	rs30ant_rs56ant.montores>
				<cfset vrs56antRCTid   =   rs30ant_rs56ant.RCTid >
				
				<cfquery datasource="#arguments.conexion#" name="rs56antUP">
					update RCuentasTipo set montores = montores + #montores56ant# 
					where RCTid = #vrs56antRCTid#
				</cfquery>
			</cfloop>
			
			<cfquery dbtype="query"  name="rs30act_rs56act">
				select 
					(rs30act.montores30act -  rs56act.montores56act) montores ,rs56act.RCTid
				from rs30act ,rs56act 
				where rs30act.referencia = rs56act.referencia
			</cfquery>

						
			<cfset montores56act       = 0>
			<cfset vrs56actRCTid	   = 0>
			
			<cfloop query="rs30act_rs56act">
				<cfset montores56act   = 	rs30act_rs56act.montores>
				<cfset vrs56actRCTid   =   rs30act_rs56act.RCTid >
				
				<cfquery datasource="#arguments.conexion#" name="rs56antUP">
					update RCuentasTipo set montores = montores + #montores56act# 
					where RCTid = #vrs56actRCTid#
				</cfquery>
			</cfloop>
			
			<cfif arguments.debug >
				<cfdump var="#rs30ant_rs56ant#">	
				<cfdump var="#rs30act_rs56act#">	
			</cfif>				
			
			<!--- 
			---===========================================================================================
			-- Informacion para la Cuenta Puente REGISTRO 56 (NEW) DEBIDO A LA PARTICION DEL REGISTRO 55
			---===========================================================================================
			--->		
			<!--- Creacion del Registro 57 con base a La Informacion del Puente Homologo 31 --->
			
			<cfquery datasource="#arguments.conexion#" name="rsinsert">
				insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, 
										Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, 
										BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
					
				select 	a.RCNid, a.Ecodigo, 57, <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 	null, 	Cformato, 
					Ccuenta, CFcuenta, 'D', a.CFid, a.Ocodigo, a.Dcodigo, a.montores, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid,referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg = 56
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
				and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			</cfquery>
			<cfquery datasource="#arguments.conexion#" name="rsinsert">
				insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, 
										Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, 
										BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
					
				select 	a.RCNid, a.Ecodigo, 57, <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, null, 	Cformato, 
					Ccuenta, CFcuenta, 'C', a.CFid, a.Ocodigo, a.Dcodigo,a.montores, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid, referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg = 56
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
				and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			</cfquery>
						
			<!--- 	--->
			<cfquery datasource="#arguments.conexion#" name="rsborrado">
				delete from RCuentasTipo 
				where RCNid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (55)
			</cfquery>		
	<cfif arguments.debug >			
				<cfquery datasource="#arguments.conexion#" name="rscopiar">
					Select tiporeg, Case 
									when tiporeg=10 then 'SalarioBruto'
									when tiporeg=11 then 'Salarios Mes Anterior'
									when tiporeg=20 then 'Incidencias'
									when tiporeg=21 then 'Incidencias Mes Anterior'                
									when tiporeg=30 then 'CargasPatronales' --d
									when tiporeg=31 then 'Cargas Patronales Mes Anterior' --d                
									when tiporeg=40 then 'CargasEmpleado'                
									when tiporeg=50 then 'Retencion Empleado'           --pasiv 55
									when tiporeg=55 then 'CargasPatronales' --c
									when tiporeg=56 then 'CargasPatronales por distribucion'   
									when tiporeg=57 then 'CargasPatronales Mes Anterior'                                
									when tiporeg=60 then 'Deducciones' --c
									when tiporeg=70 then 'Renta'                
									when tiporeg=80 then 'Salario a Pagar Banco Asignado'                                
									when tiporeg=85 then 'Salario a Pagar Sin Banco Asignado'                 
									else 'Otros'
									end as DescripcionReg,
									a.tipo,
									a.Periodo,
									a.Mes,
									case when a.tipo='D' then sum(montores)
									else sum(montores)*-1 end as MONTO
					from RCuentasTipo a
					Where RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					group by tiporeg, Case 
									when tiporeg=10 then 'SalarioBruto'
									when tiporeg=11 then 'Salarios Mes Anterior'
									when tiporeg=20 then 'Incidencias'
									when tiporeg=21 then 'Incidencias Mes Anterior'                
									when tiporeg=30 then 'CargasPatronales' --d
									when tiporeg=31 then 'Cargas Patronales Mes Anterior' --d                
									when tiporeg=40 then 'CargasEmpleado'                
									when tiporeg=50 then 'Retencion Empleado'           --pasiv 55
									when tiporeg=55 then 'CargasPatronales' --c
									when tiporeg=56 then 'CargasPatronales por distribucion'   
									when tiporeg=57 then 'CargasPatronales Mes Anterior' 
									when tiporeg=60 then 'Deducciones' --c
									when tiporeg=70 then 'Renta'                
									when tiporeg=80 then 'Salario a Pagar Banco Asignado'                                
									when tiporeg=85 then 'Salario a Pagar Sin Banco Asignado'                 
									else 'Otros'
									end,
									a.tipo,
									a.Periodo,
									a.Mes 
				</cfquery>
			<cf_dump var="#rscopiar#">
	
		</cfif>
		</cfif>
	</cffunction>	

	<cffunction name="DistribucionCargasEmpleado_X_mes" access="private" output="false">
		<cfargument name="conexion"   type="string" required="no" default="#Session.DSN#">
		<cfargument name="Usucodigo"  type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="RCNid"      type="numeric" required="yes">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		<cfargument name="debug" type="boolean" required="no" default="false">

		<!--- Paso 1 Verifica si los parametros permiten la distribucion de cargas patronles por mes --->	
		<cfquery name="rsValida490" datasource="#arguments.conexion#">
			select Pvalor
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and Pcodigo = 490
		</cfquery>
		
		<cfquery name="rsValida1100" datasource="#arguments.conexion#">
			select Pvalor
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			and Pcodigo = 1100
		</cfquery>
		<cfset Lvar_490 = 0>
		<cfset Lvar_1100 = 0>
		<cfif rsValida490.recordCount GT 0>
			<cfset Lvar_490 = rsValida490.Pvalor>
		</cfif>
		<cfif rsValida1100.recordCount GT 0>
			<cfset Lvar_1100 = rsValida1100.Pvalor>
		</cfif>
		<cfquery datasource="#arguments.conexion#" name="rsdistribuye">
				Select RCNid, Periodo, Mes
				from RCuentasTipo 
				where RCNid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (10)
				Group by RCNid, Periodo, Mes
			</cfquery>		
		<cfif Lvar_1100 eq 1 and  Lvar_490 eq 1  and rsdistribuye.recordCount GT 1 and isdefined("rsdistribuye")>		
			<cfquery datasource="#arguments.conexion#" name="rsborrar">
				delete from #Distribucion#
			</cfquery> 
			<!--- Paso 2 inicia proceso de distribucion --->	
			<!--- Paso 2.1 copia los registros 55 en la tabla temporal --->
			<!--- Paso 2.1 50 actual --->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into #Distribucion# (	RCTidREF,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
											valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
											vpresupuesto,BMfechaalta,
											BMUsucodigo,RHPPid,Periodo,Mes,referencia)
				select 
					RCTid,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
					valor, valor2, Cformato, Ccuenta, 
					CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
					vpresupuesto,BMfechaalta,
					BMUsucodigo,RHPPid,Periodo,Mes,referencia
				from RCuentasTipo 
				where RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo 	   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (50)
			</cfquery>
			<!--- Paso 2.1 50 mes anterior --->
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into #Distribucion# (	RCTidREF,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
											valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
											vpresupuesto,BMfechaalta,
											BMUsucodigo,RHPPid,Periodo,Mes,referencia)
				select 
					RCTidREF,RCNid, Ecodigo, tiporeg,DEid, cuenta, 
					valor, valor2, Cformato, Ccuenta, 
					CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
					vpresupuesto,BMfechaalta,BMUsucodigo,RHPPid,
					case when Mes = 1 then Periodo-1  else Periodo end,
					case when Mes = 1 then 12  else Mes-1 end,
					referencia
				from #Distribucion# 
			</cfquery>

			<!--- Paso 2.1 Calcula los proporcionales en base a los Registros 20/10  --->
			<cfquery datasource="#arguments.conexion#" name="rsproporcional">
				insert into  #Proporcional# (RCNid,Periodo,Mes,montores,Proporc)
				Select RCNid, Periodo, Mes, Sum(montores) as Monto, 0 as Proporc
				from RCuentasTipo 
				where RCNid  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (20,10)
				Group by RCNid, Periodo, Mes
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#" name="rsproporcional">
				update #Proporcional# 
				set Proporc = round(montores / (Select Sum(montores)
												From #Proporcional# a
												Where a.RCNid=#Proporcional#.RCNid	),2)
			</cfquery>

			<cfquery datasource="#arguments.conexion#" name="rsproporcional">
				update #Distribucion# 
				set montores= round( montores * (Select Proporc
					from #Proporcional#  a
					Where  #Distribucion#.RCNid=a.RCNid
					and    #Distribucion#.Mes=a.Mes
					and    #Distribucion#.Periodo=a.Periodo ),2)
			</cfquery>
			<cfif arguments.debug >
				<cfquery datasource="#arguments.conexion#" name="rscopiar">
					Select 'Registro 50 en RCuentasTipo' as Label, sum(Montores)
					from RCuentasTipo 
					where RCNid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and   Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
					and   tiporeg in (50)
				</cfquery>
				<cfdump var="#rscopiar#">
				<cfquery datasource="#arguments.conexion#" name="rscopiar">
					Select 'Registro 50 en Distribucion', Mes, Periodo, sum(Montores)
					from #Distribucion# 
					Group by Mes, Periodo
				</cfquery>
				<cfdump var="#rscopiar#">
			</cfif>
			
			<cfquery datasource="#arguments.conexion#" name="retencionempleado">
					Select coalesce(sum(montores),0) as Monto
					from RCuentasTipo
					Where tiporeg=50
					and RCNid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					and   Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			</cfquery>
			
			<cfquery datasource="#arguments.conexion#" name="distribempl">
					Select coalesce(sum(montores),0) as Monto, min(RCTidREF) as RCTid
					from #Distribucion#
			</cfquery>
			
			<cfset v_diferenciaemp= retencionempleado.Monto - distribempl.Monto>
			
			<cfif isdefined("distribempl.RCTid") and len(trim(distribempl.RCTid))>		
				<cfquery datasource="#arguments.conexion#">
						 Update #Distribucion#
						 set montores=montores + #v_diferenciaemp#
						 Where RCTidREF = #distribempl.RCTid#
						 and Periodo=#vPeriodoAnt#
						 and Mes=#vMesAnt#
				</cfquery>
			</cfif>
			
			<cfquery datasource="#arguments.conexion#" name="distribempl">
					Select sum(montores) as Monto
					from #Distribucion#
			</cfquery>
				
			<cfquery datasource="#arguments.conexion#" name="rscopiar">
			   insert into RCuentasTipo  (RCNid, Ecodigo, tiporeg,DEid, cuenta, 
											valor, valor2, Cformato, Ccuenta, 
											CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
											vpresupuesto,BMfechaalta,
											BMUsucodigo,RHPPid,Periodo,Mes,referencia)
				select 
					RCNid, Ecodigo, 51,DEid, cuenta, 
					valor, valor2, Cformato, Ccuenta, 
					CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores,
					vpresupuesto,BMfechaalta,
					BMUsucodigo,RHPPid,Periodo,Mes,referencia
				from #Distribucion#
			</cfquery>
			
	
			
			<cfquery datasource="#arguments.conexion#" name="rsborrar">
				delete from #Distribucion#
			</cfquery> 
			<cfquery datasource="#arguments.conexion#" name="rsborrar">
				delete from #Proporcional#
			</cfquery> 
			<!--- 
			---===========================================================================================
			-- Informacion para la Cuenta Puente REGISTRO 52 (NEW) DEBIDO A LA PARTICION DEL REGISTRO 50
			---===========================================================================================
			--->		
			<!--- Creacion del Registro 52 con base a La Informacion del Puente Homologo 31 --->
			
			<cfquery datasource="#arguments.conexion#" name="rsinsert">
				insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, 
										Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, 
										BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
					
				select 	a.RCNid, a.Ecodigo, 52, <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, 	null, 	Cformato, 
					Ccuenta, CFcuenta, 'D', a.CFid, a.Ocodigo, a.Dcodigo, a.montores, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid,referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg = 51
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
				and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			</cfquery>
			
			
			
			<cfquery datasource="#arguments.conexion#" name="rsinsert">
				insert into RCuentasTipo(RCNid, Ecodigo, tiporeg, cuenta, valor, Cformato, 
										Ccuenta, CFcuenta, tipo, CFid, Ocodigo, Dcodigo, montores, 
										BMfechaalta, BMUsucodigo, DEid, RHPPid, referencia, vpresupuesto, Periodo, Mes)
					
				select 	a.RCNid, a.Ecodigo, 52, <cfqueryparam cfsqltype="cf_sql_varchar" value="#vCuentaPasivoFmt#">, null, 	Cformato, 
					Ccuenta, CFcuenta, 'C', a.CFid, a.Ocodigo, a.Dcodigo,a.montores, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#vHoy#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">, 
					0 as DEid, null as RHPPid, referencia, 0 as vpresupuesto, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
				from RCuentasTipo a
				where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and a.tiporeg = 51
				and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodoAnt#">
				and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesAnt#">
			</cfquery>
			<!--- 	--->
			<cfquery datasource="#arguments.conexion#" name="rsborrado">
				delete from RCuentasTipo 
				where RCNid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
				and   Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				and   tiporeg in (50)
			</cfquery>		
			<cfif arguments.debug >
				<cfquery datasource="#arguments.conexion#" name="rscopiar">
					Select tiporeg, Case 
									when tiporeg=10 then 'SalarioBruto'
									when tiporeg=11 then 'Salarios Mes Anterior'
									when tiporeg=20 then 'Incidencias'
									when tiporeg=21 then 'Incidencias Mes Anterior'                
									when tiporeg=30 then 'CargasPatronales' --d
									when tiporeg=31 then 'Cargas Patronales Mes Anterior' --d                
									when tiporeg=40 then 'CargasEmpleado'                
									when tiporeg=50 then 'Retencion Empleado'           --pasiv 55
									when tiporeg=51 then 'Retencion por distribucion'   
									when tiporeg=52 then 'Retencion Mes Anterior' 
									when tiporeg=55 then 'CargasPatronales' --c
									when tiporeg=56 then 'CargasPatronales por distribucion'   
									when tiporeg=57 then 'CargasPatronales Mes Anterior'                                
									when tiporeg=60 then 'Deducciones' --c
									when tiporeg=70 then 'Renta'                
									when tiporeg=80 then 'Salario a Pagar Banco Asignado'                                
									when tiporeg=85 then 'Salario a Pagar Sin Banco Asignado'                 
									else 'Otros'
									end as DescripcionReg,
									a.Tipo,
									a.Periodo,
									a.Mes,
									case when a.Tipo='D' then sum(montores)
									else sum(montores)*-1 end as MONTO
					from RCuentasTipo a
					Where RCNid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					group by tiporeg, Case 
									when tiporeg=10 then 'SalarioBruto'
									when tiporeg=11 then 'Salarios Mes Anterior'
									when tiporeg=20 then 'Incidencias'
									when tiporeg=21 then 'Incidencias Mes Anterior'                
									when tiporeg=30 then 'CargasPatronales' --d
									when tiporeg=31 then 'Cargas Patronales Mes Anterior' --d                
									when tiporeg=40 then 'CargasEmpleado'                
									when tiporeg=50 then 'Retencion Empleado'           --pasiv 55
									when tiporeg=51 then 'Retencion por distribucion'   
									when tiporeg=52 then 'Retencion Mes Anterior' 
									when tiporeg=55 then 'CargasPatronales' --c
									when tiporeg=56 then 'CargasPatronales por distribucion'   
									when tiporeg=57 then 'CargasPatronales Mes Anterior' 
									when tiporeg=60 then 'Deducciones' --c
									when tiporeg=70 then 'Renta'                
									when tiporeg=80 then 'Salario a Pagar Banco Asignado'                                
									when tiporeg=85 then 'Salario a Pagar Sin Banco Asignado'                 
									else 'Otros'
									end,
									a.TIPO,
									a.Periodo,
									a.Mes 
				</cfquery>
			<cf_dump var="#rscopiar#">
		</cfif>
		</cfif>
	</cffunction>	

	
</cfcomponent>
