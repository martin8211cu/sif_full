<!---Nueva version de calculo de renta para mexico esta version aplica la utilizacion de las teblas de renta segun el tipo de nomina
esto se incorpora apartir del parametro general utiliza tabla en tipo nomina Pcodigo = 2035
La renta presenta varios tipos de calulo
	-	Por Mensual(Proyectando por cada Calendario)
	-	Por Nomina Aguinaldo (Sobre lo que se esta pagado)
	-	Ajuste Anual sobre lo que se han Ejecutado en el Año Fiscal
--->


<cfcomponent>
	<cffunction name="CalculoNominaRenta" access="public" output="true">
		<cfargument name="Conexion" 			type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="RCNid"   				type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 				type="numeric" 	required="yes">
		<cfargument name="Tcodigo" 				type="string" 	required="yes">
		<cfargument name="cantdias" 			type="numeric"	required="yes">
		<cfargument name="CantDiasMensual" 		type="numeric"	required="yes">
		<cfargument name="CantPagosRealizados" 	type="numeric"	required="yes">
		<cfargument name="Factor" 				type="numeric"	required="yes">
		<cfargument name="per" 					type="numeric"	required="yes">
		<cfargument name="mes" 					type="numeric"	required="yes">
		<cfargument name="IRcodigo" 			type="string" 	required="yes">
		<cfargument name="RCdesde" 				type="date" 	required="yes">
		<cfargument name="RChasta" 				type="date" 	required="yes">
		<cfargument name="DEid" 				type="numeric" 	required="no">
        <cfargument name="ValidarCalendarios" 	type="boolean" 	required="no" default="true" hint="True. Cuenta Calendario X mes. False. Estima Calendarios X mes">
        <cfargument name="PeriodosM" 			type="numeric" 	required="no" default="0" hint="Número de periodos incluidos en el mes"><!--- Si el calendario tiene 5 o mas periodos en el mes no se calcula el subsidio --->
        
        <cfset CalendarioPago = fnGetCalendarioPago(Arguments.RCNid,Arguments.conexion)>
        
        <!--- Elimina datos del calculo de renta --->
        <cfquery datasource="#session.dsn#">
            delete RH_CalculoISR
            where Ecodigo = #arguments.Ecodigo#
                and RCNid = #arguments.RCNid#
            <cfif isdefined("arguments.DEid")>
                and DEid = #arguments.DEid#
            </cfif> 
        </cfquery>
       
        <cfif CalendarioPago.CPTipoCalRenta EQ 1>
			<!---Calculo de Renta por tipo 1= Por Mes (actulamente es el calculo dela renta segun la nomina no proyecta nada)--->

            <!--- SE VERIFICA PARAMETRO PARA CALCULO DE RENTA MANUAL SI NO ES MANUEL SIGUE EL CALCULO NORMAL --->
            <cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#" ecodigo="#Arguments.Ecodigo#" pvalor="1090" default="" returnvariable="RentaManual"/>
            <!--- Se deducen del devengado total a proyectar las cargas del empleado --->
            <!--- que esten marcadas como:  Disminuyen el monto imponible de Renta --->
            <!--- Se suman a esto las cargas deducibles de renta de otras nominas del mes --->
            <!--- Ejemplo. Planes de Pension Voluntaria --->
            
            <cfset vDebug = "false">
            <cfif vDebug >
	            <cfset vDEid = 36 >
                <br> DEid: <cfdump var="#vDEid#"> </br>
                <br> Periodo:<cfdump var="#arguments.per#"> </br>
                <br> mes: <cfdump var="#arguments.mes#"> </br>
                <br> RCdesde: <cfdump var="#arguments.RCdesde#"> </br>
            </cfif>


            <cfquery name="rsDatosRenta" datasource="#arguments.conexion#">
                select
                    coalesce(IRfactormeses,1) as IRfactormeses, 
                    coalesce(IRCreditoAntes, 0) as IRCreditoAntes,
                    IRTipoPeriodo
                from ImpuestoRenta
                where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
            </cfquery>
            
            <!--- ljimenez se verifica el factor de meses de la tabla de renta
            para el caso de mexico se utiliza una tabla de comportamiento mensual --->
            <!---<cfif rsDatosRenta.IRfactormeses eq 1>	--->
            <cf_dbtemp name="EmpleadosRenta" returnvariable="EmpleadosRenta" datasource="#session.DSN#">
                <cf_dbtempcol name="DEid" 					type="numeric"			mandatory="no">
                <cf_dbtempcol name="ingreso" 				type="datetime" 		mandatory="no">
                <cf_dbtempcol name="meses_periodo"			type="int" 				mandatory="no">
                <cf_dbtempcol name="SEdevengado" 			type="money" 			mandatory="no">
                <cf_dbtempcol name="SEincidencias" 			type="money" 			mandatory="no">

                <cf_dbtempcol name="mes" 					type="numeric" 			mandatory="no">	<!--- Mes --->							<!---A--->
                <cf_dbtempcol name="nomMes" 				type="numeric" 			mandatory="no">	<!--- Nóminas Mes --->					<!---B--->
                <cf_dbtempcol name="numNomina" 				type="numeric" 			mandatory="no">	<!--- Num Nomina --->					<!---C--->
                <cf_dbtempcol name="nomPend" 				type="numeric" 			mandatory="no">	<!--- Nom Pend --->						<!---D--->
                <cf_dbtempcol name="diasMes" 				type="numeric(18,4)" 	mandatory="no">	<!--- Dias Mes --->						<!---E--->
                <cf_dbtempcol name="diasCalendar"	 		type="numeric(18,4)"	mandatory="no">	<!--- Dias Calend --->					<!---F--->

                <cf_dbtempcol name="diasFalta"	 			type="numeric(18,4)"	mandatory="no">
                <cf_dbtempcol name="diasIncap"	 			type="numeric(18,4)"	mandatory="no">

                <cf_dbtempcol name="diasMesCalendar" 		type="numeric(18,4)" 			mandatory="no">	<!--- Dias Mes Calendario --->			<!---G--->
                <cf_dbtempcol name="salMensual" 	 		type="money" 			mandatory="no">	<!--- Salario  Mensual --->				<!---H--->
                <cf_dbtempcol name="salRealRec" 	 		type="money" 			mandatory="no">	<!--- Salario Real Recibido --->		<!---I--->
                <cf_dbtempcol name="usar" 					type="numeric" 			mandatory="no">	<!--- Usar --->							<!---J--->
                <cf_dbtempcol name="salRecPeriodo" 			type="money" 			mandatory="no">	<!--- Salario Rec Según Periodo --->	<!---K--->

                <cf_dbtempcol name="incRecProyect" 			type="money" 			mandatory="no">	<!--- Incidenc Recib Proyec --->		<!---M--->
                <cf_dbtempcol name="totalSalProyect" 		type="money" 			mandatory="no">	<!--- Total Salarios para Proyec --->	<!---N--->
                <cf_dbtempcol name="diasNomPend" 			type="numeric" 			mandatory="no">	<!--- Dias Nom Pend Pagar --->			<!---O--->
                <cf_dbtempcol name="promSal" 				type="money" 			mandatory="no">	<!--- Promedio Salarios --->			<!---P--->
                <cf_dbtempcol name="incidNoProyect" 		type="money" 			mandatory="no">	<!--- Inciden No Proyect --->			<!---R--->
                <cf_dbtempcol name="totalSal" 				type="money" 			mandatory="no">	<!--- TOTAL SALARIOS --->				<!---S--->

                <cf_dbtempcol name="TotalDiasPromProyect" 	type="money" 			mandatory="no">	<!--- TOTAL Dias Prom Proyectado --->	<!---S2--->

                <cf_dbtempcol name="salPromDiaPr" 			type="money" 			mandatory="no">	<!--- Salario Diario Proyectado --->	<!---T--->
                <cf_dbtempcol name="salPend"				type="money"			mandatory="no">	<!--- Salarios Pend Pagar --->			<!---U--->
                <cf_dbtempcol name="totalSalRent" 			type="money" 			mandatory="no">	<!--- Total Salarios --->				<!---V--->
                <cf_dbtempcol name="rentaMens" 				type="numeric(18,10)" 			mandatory="no">	<!--- Renta  Mensual --->				<!---W--->
                <cf_dbtempcol name="subsidioMens" 			type="money" 			mandatory="no">	<!--- Subsidio Mensual --->				<!---X--->
                <cf_dbtempcol name="rentaReal" 				type="money" 			mandatory="no">	<!--- Renta Real--->					<!---Y--->
                <cf_dbtempcol name="rentaDiaria" 			type="money" 			mandatory="no">	<!--- Renta Diaria--->					<!---Z--->
                <cf_dbtempcol name="diasNomina" 			type="numeric" 			mandatory="no">	<!--- Dias Nomina--->					<!---AA--->
                <cf_dbtempcol name="diasNominaPagados"		type="numeric" 			mandatory="no">	<!--- Dias Nomina pagados--->
                <cf_dbtempcol name="rentaAcum" 				type="money" 			mandatory="no">	<!--- Renta Acum--->					<!---AC--->
                <cf_dbtempcol name="rentaAcumDed" 			type="money" 			mandatory="no">	<!--- Renta Acum x deducciones, subcidios--->


                <cf_dbtempcol name="retencion" 				type="money" 			mandatory="no">	<!--- Retencion--->						<!---AD--->
                <cf_dbtempcol name="retaRealCorte" 			type="money" 			mandatory="no">	<!--- Renta Real al Corte--->			<!---AE--->

                <cf_dbtempcol name="TLimInfAnt" 			type="money" 			mandatory="no"> <!--- Datos tabla de renta--->
                <cf_dbtempcol name="TLimSupAnt" 			type="money" 			mandatory="no">
                <cf_dbtempcol name="TMontoAnt" 				type="money" 			mandatory="no">
                <cf_dbtempcol name="TporcentajeAnt" 		type="money" 			mandatory="no">
                <cf_dbtempcol name="TLimSubInf" 			type="money" 			mandatory="no"> <!--- Datos tabla de subsidio--->
                <cf_dbtempcol name="TLimSubSup" 			type="money" 			mandatory="no">
                <cf_dbtempcol name="TMontoSub" 				type="money" 			mandatory="no">
                <cf_dbtempcol name="FactorMensual"			type="numeric(18,16)"   mandatory="no">
                <cf_dbtempcol name="BaseGravableMensual"	type="numeric(18,5)" 	mandatory="no">
                <cf_dbtempcol name="TMontoSubOrdinario"	    type="money" 	        mandatory="no">
                <cf_dbtempcol name="TMontoISROrdinario"	    type="money" 	        mandatory="no">
                <cf_dbtempcol name="TMontoSubsidioEntregado"  type="money" 	        mandatory="no">

                <cf_dbtempcol name="AguiBruto"	 	type="money"   mandatory="no">
                <cf_dbtempcol name="AguiExc"	 	type="money"   mandatory="no">
                <cf_dbtempcol name="AguiGra"	 	type="money"   mandatory="no">
                <cf_dbtempcol name="SalarioM"	 	type="money"   mandatory="no">
                <cf_dbtempcol name="DiasTrab"	 	type="money"   mandatory="no">
                <cf_dbtempcol name="Faltas"	 		type="money"   mandatory="no">
                <cf_dbtempcol name="Incapa"	 		type="money"   mandatory="no">
                <cf_dbtempcol name="AguiMensual" 	type="money"   mandatory="no">
                <cf_dbtempcol name="AguiMenGra"		type="money"   mandatory="no">
                <cf_dbtempcol name="Neto_Agui"      type="money"   mandatory="no">
                <cf_dbtempcol name="ISPT_Aguinado"  type="money"   mandatory="no">
                <cf_dbtempcol name="RVid"  			type="integer"   mandatory="no">
                <cf_dbtempcol name="Annos"  		type="integer"   mandatory="no">

                <cf_dbtempcol name="aplicaRetencion" type="numeric" 			mandatory="no">
                <cf_dbtempcol name="totalISRM" 		 type="money" 			    mandatory="no">	<!--- Renta Mensual del Ajuste de Subsidio Mensual--->					<!---Y--->
                <cf_dbtempcol name="totalSubsidioCausado" type="money" 			    mandatory="no">	<!--- SubsidioCausado Mensual del Ajuste de Subsidio Mensual--->					<!---Y--->
                
            </cf_dbtemp>

            <cf_dbtemp name="ExcepcionesRenta" returnvariable="ExcepcionesRenta" datasource="#session.DSN#">
                <cf_dbtempcol name="RCNid" 		type="numeric" 	mandatory="no">
                <cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="no">
                <cf_dbtempcol name="SalarioExo" type="money" 	mandatory="no">
                <cf_dbtempcol name="Proyectado" type="money" 	mandatory="no">
            </cf_dbtemp>

            <cf_dbtemp name="TRAAdaptada1" returnvariable="TRentaAdaptadaAnterior" datasource="#session.DSN#">
                <cf_dbtempcol name="DIRid" 			type="numeric" 	mandatory="no">
                <cf_dbtempcol name="LimInf" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="LimSup" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="MontoFijo" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="Porcentaje" 	type="money" 	mandatory="no">
            </cf_dbtemp>

            <cf_dbtemp name="TSubsidio" returnvariable="TableSubsidio" datasource="#session.DSN#">
                <cf_dbtempcol name="DIRid" 			type="numeric" 	mandatory="no">
                <cf_dbtempcol name="LimInf" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="LimSup" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="MontoFijo" 		type="money" 	mandatory="no">
            </cf_dbtemp>
            
			<!--- se incluye todos los empleado que reciben salario, SEdevengado y SEIncidencias en 0, por si acaso no se llena --->
            <cfquery datasource="#session.DSN#">
                insert into #EmpleadosRenta# (DEid, ingreso, meses_periodo, SEdevengado, SEincidencias)
                select DEid, (select min(LTdesde) from LineaTiempo b where a.DEid = b.DEid), 0,0,0
                    from SalarioEmpleado a
                    where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                    and (SEsalariobruto+SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>
           
            <!--- fecha de inicio de tabla de renta anual vigente --->
            <cfquery datasource="#session.DSN#" name="Tabla">
                select EIRdesde
                    from EImpuestoRenta a, RCalculoNomina b
                    where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
                        and EIRestado = 1
                        and (RCdesde between EIRdesde and EIRhasta
                           or RChasta between EIRdesde and EIRhasta )
                        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
            </cfquery>
            
			<!--- Establezco El mes/periodo Primer Calendario de Pagos Vigente en la Nómina para esa tabla de Renta --->
            <cfquery datasource="#session.DSN#" name="Calendario">
                select CPperiodo, CPmes
                from CalendarioPagos
                Where CPid in (Select min(CPid)
                               from CalendarioPagos
                               Where CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(Tabla.EIRdesde,'dd/mm/yyyy')#">
                               and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
                               and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">)
            </cfquery>

			<cfset FechaPrimeraNomina = CreateDate(Calendario.CPperiodo,Calendario.CPmes,01)>
            <cfset FechaTabla = Tabla.EIRdesde>

            <!--- LZ Si el Periodo/Mes del primer Calendario es diferente de la Tabla --->
            <cfif FechaPrimeraNomina NEQ FechaTabla>
                <cfset FechaTabla = FechaPrimeraNomina>
            </cfif>

			<!---Optiene la tabla de renta --->
            <cfquery datasource="#session.DSN#">
                Insert into #TRentaAdaptadaAnterior# (DIRid,LimInf,LimSup,MontoFijo,Porcentaje)
                    select b.DIRid ,b.DIRinf ,b.DIRsup ,b.DIRmontofijo ,b.DIRporcentaje
                        from EImpuestoRenta a
                            inner join DImpuestoRenta b
                                on b.EIRid = a.EIRid
                        where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
                        and a.EIRestado = 1
                        and a.EIRdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(Tabla.EIRdesde,'dd/mm/yyyy')#">
						<!--- OPARRALES 2019-01-20
							- Modificacion para el escenario con nominas en 2018 y tablas de ISR cargadas de 2018 y 2019
							- Esto evita que se crucen tablasISR de diferentes años.
						 --->
						and DatePart(year,a.EIRdesde) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Year(Tabla.EIRdesde)#">
                        order by b.DIRinf
            </cfquery>
            
            <!---
			<cfquery datasource="#session.DSN#" name="renta">
                select * from #TRentaAdaptadaAnterior#
            </cfquery>
            <cf_dump var = "#renta#">
			--->

			<!---Obtiene el codigo de la tabla de subsidio--->
            <cfquery name="rsIR" datasource="#session.DSN#">
                select IRcodigo
                from ImpuestoRenta
                where IRcodigoPadre=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.IRcodigo#">
            </cfquery>

            <cfif rsIR.RecordCount EQ 0>
                <cfthrow detail="Error. Debe definirse la tabla de Subsidios.">
            </cfif>
            <cfif rsIR.RecordCount GT 1>
                <cfthrow detail="Error. Existen varias tablas de Subsidio, debe existir solo una.">
            </cfif>

            <!---Optiene la tabla de renta --->
            <cfquery datasource="#session.DSN#">
                Insert into #TableSubsidio# (DIRid,LimInf,LimSup,MontoFijo)
                    select b.DIRid ,b.DIRinf ,b.DIRsup ,b.DIRmontofijo
                        from EImpuestoRenta a
                            inner join DImpuestoRenta b
                                on b.EIRid = a.EIRid
                        where a.IRcodigo = '#rsIR.IRcodigo#'
                        and a.EIRestado = 1
                        and a.EIRdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(Tabla.EIRdesde,'dd/mm/yyyy')#">
						<!--- OPARRALES 2019-01-20
							- Modificacion para el escenario con nominas en 2018 y tablas de ISR cargadas de 2018 y 2019
							- Esto evita que se crucen tablasISR de diferentes años.
						 --->
						and DatePart(year,a.EIRdesde) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Year(Tabla.EIRdesde)#">
                        order by b.DIRinf
            </cfquery>
            <!---------------------------------------------------------------------------------------->
            <cfquery datasource="#session.DSN#" name="rsCantDiasCalendario">
                select 
                    <cf_dbfunction name="datediff" args="a.CPdesde, a.CPhasta">+1 as diasDiferencia
                    ,b.Ttipopago, 
                    case b.Ttipopago
                        when  0 then 7
                        when  1 then 14
                        when  2 then 15
                        when  3 then 30
                    end as CantDiasCalendario
                    ,coalesce(b.AjusteMensual,0) AS AjusteMensual
                from CalendarioPagos a
                inner join TiposNomina b
                    on a.Tcodigo=b.Tcodigo
                    and a.Ecodigo=b.Ecodigo
                Where a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
                    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                    and a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.per#">
                    and a.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.mes#">
                    and a.CPtipo = 0	<!---ordinarias--->
                order by CPdesde
            </cfquery>

            <!---sacamos la catidad de dias del calendario ya quepuede ser variable--->

            <cfquery dbtype="query" name="rsCanDiasMes">
                select sum(diasDiferencia) as CanDiasMes from rsCantDiasCalendario
            </cfquery>
            
            <cfquery dbtype="query" name="rsCanCalendaMes">
                select count(diasDiferencia) as CanCalendaMes from rsCantDiasCalendario
            </cfquery>
            
            <cfif #CalendarioPago.CPtipo# EQ 0>
                <cfset diasNom = datediff('d', #arguments.RCdesde#,#arguments.RChasta#)+1>
            <cfelse>
                 <cfset diasNom = 0>
            </cfif>

            <cfset _esFinMes = esFinMes(RCNid=CalendarioPago.CPid, conexion=arguments.conexion,CPperiodo=CalendarioPago.CPperiodo,CPmes=CalendarioPago.CPmes, Tcodigo=CalendarioPago.Tcodigo) eq 1>

            <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual OPARRALES 2019-04-23 --->
                <cfquery name="rsCantDiasMensual" datasource="#session.dsn#">
                    select FactorDiasSalario, FactorDiasIMSS, IRcodigo
                    from TiposNomina
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
                </cfquery>
                <cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#" ecodigo="#Arguments.Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>
            </cfif>
            
			<cfif #rsCantDiasCalendario.Ttipopago# LT 2 and  #rsCantDiasCalendario.CantDiasCalendario# LT 15 and rsDatosRenta.IRTipoPeriodo neq 5 and _esFinMes EQ 0>
                 <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta# set
                          diasMesCalendar = #rsCanDiasMes.CanDiasMes#
                        , diasNomina = #diasNom#
                 </cfquery>
            <cfelse>
                <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta# 
                    <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual --->
                        set diasMesCalendar = #CantDiasMensual#
                    <cfelse>
                        set diasMesCalendar = #rsCantDiasCalendario.CantDiasCalendario# * #rsCanCalendaMes.CanCalendaMes#
                    </cfif>

                         , diasNomina = #rsCantDiasCalendario.diasDiferencia# 
                        <!--- , diasNomina = #rsCantDiasCalendario.CantDiasCalendario# --->
                </cfquery>
            </cfif>
            <cfif #CalendarioPago.CPtipo# NEQ 0>
                <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta#  set diasNomina = 0
                </cfquery>
            </cfif>
            

            <!---------------------------------------------------------------------------------------->

            <!---Cantidad Dias  Reales Laborados Ordinarios en Nomina --->
            <!--- Cambio oparrales --->
            <!---
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# set
                diasCalendar =  (select coalesce(sum(PEcantdias),0)
                            from RCalculoNomina a, PagosEmpleado c,CalendarioPagos d
                                where a.RCNid=d.CPid
                                and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
                                and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                and a.RCNid=c.RCNid
                                and c.PEmontores > 0
                                and c.PEtiporeg = 0
                                and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                and c.DEid = #EmpleadosRenta#.DEid )
            </cfquery>
            --->
            <cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#Arguments.Ecodigo#" pvalor="14600708" default="S" returnvariable="factorISR"/>

            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# 
                set
                    <cfif #rsCantDiasCalendario.Ttipopago# eq 2><!--- Nominas Quincenales --->
                        <cfif factorISR eq 'S'>
                            diasCalendar =(365/12.0)/2
                        <cfelse>
                            <cfset  qq="#datediff("d", arguments.rcdesde,arguments.rchasta) +1#">
                            diasCalendar = #qq#
                        </cfif> 
                    <cfelseif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)>
                        diasCalendar = diasNomina
                    <cfelse>
                        diasCalendar =  (select coalesce(sum(PEcantdias),0)
                                from RCalculoNomina a, PagosEmpleado c,CalendarioPagos d
                                    where a.RCNid=d.CPid
                                    and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
                                    and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                    and a.RCNid=c.RCNid
                                    and c.PEmontores > 0
                                    and c.PEtiporeg = 0
                                    and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                    and c.DEid = #EmpleadosRenta#.DEid )  
                    </cfif>
            </cfquery>
            
            <cfquery datasource="#session.DSN#" name="rsDiasFalta">
               update #EmpleadosRenta# set
                diasFalta =  coalesce((
                                    select sum((coalesce(ta.RHTfactorfalta,1) * pe.PEcantdias) -  pe.PEcantdias)
                                    from PagosEmpleado pe
                                        inner join  CalendarioPagos x
                                            on pe.RCNid = x.CPid
                                        inner join LineaTiempo lt
                                            on pe.LTid = lt.LTid
                                        inner join  RHTipoAccion ta
                                            on lt.RHTid = ta.RHTid
                                                and ta.RHTcomportam = 13
                                            where pe.DEid = #EmpleadosRenta#.DEid),0)
            </cfquery>

            <cfif rsDatosRenta.IRTipoPeriodo neq 5 and _esFinMes EQ 0>
                <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta# set diasCalendar =  diasCalendar - diasFalta
                </cfquery>
            </cfif>
            <!---------------------------------------------------------------------------------------->

			<!---"Salario nomina Referencia  --->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# set
                salMensual =  (select coalesce(sum(PEmontores),0)
                            from RCalculoNomina a, PagosEmpleado c,CalendarioPagos d
                                where a.RCNid=d.CPid
                                and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
                                and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                and a.RCNid=c.RCNid
                               <!--- --and c.PEtiporeg = 0--->
                                and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                and c.DEid = #EmpleadosRenta#.DEid
                                )
            </cfquery>
            <!---------------------------------------------------------------------------------------->
            
            <!--- "Incidencidencias Recibidas Proyectadas"(M) Salario Incidencias para la nomina actual--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                set incRecProyect = (
                                Select 
                                    coalesce(sum(ICmontores),0)
                                from 
                                    RCalculoNomina a,
                                    CalendarioPagos b,
                                    IncidenciasCalculo c,
                                    CIncidentes d
                                where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                and a.RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RCNid#">
                                and a.RCNid = b.CPid
                                and c.RCNid = a.RCNid
                                and c.DEid = #EmpleadosRenta#.DEid
                                and c.CIid = d.CIid
                                and d.CInorenta = 0
                                and isnull(d.CIart142,0) = 0
                                and d.CInopryrenta = 0 <!---se proyecta--->
                            ) 
            </cfquery>
            

            <!--- "Incidencidencias Recibidas NO Proyectadas" Salario Incidencias para la nomina actual (R)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                set incidNoProyect = (
                            Select coalesce(sum(ICmontores),0)
                             from RCalculoNomina a,
                                  CalendarioPagos b,
                                  IncidenciasCalculo c,
                                  CIncidentes d
                             where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                             and a.RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RCNid#">
                             and a.RCNid = b.CPid
                             and c.RCNid = a.RCNid
                             and c.DEid = #EmpleadosRenta#.DEid
                             and c.CIid = d.CIid
                             and d.CInorenta = 0
                             and isnull(d.CIart142,0) = 0
                             and d.CInopryrenta = 1 <!---NO se proyecta--->
                             )
            </cfquery>

            <!--- Articulo 142 --->
            <cfquery datasource="#session.DSN#" name="rsActEmplado"><!---SML. Considere el salario mensual Inicio--->
                update #EmpleadosRenta# set
                SalarioM = coalesce((select top 1 ddle.DDLmontobase
                        from DDLaboralesEmpleado ddle inner join DLaboralesEmpleado dle on dle.DLlinea = ddle.DLlinea
                                <!---inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid--->
                                inner join ComponentesSalariales cs on cs.CSid = ddle.CSid
                        where dle.Ecodigo = #session.Ecodigo#
                            and ddle.CSid in (select CSid from ComponentesSalariales
                                    where Ecodigo = #session.Ecodigo#
                                        and CSsalariobase = 1)
                            <!--- and dle.RHTid in (select RHTid from RHTipoAccion
                                    where Ecodigo = #session.Ecodigo#
                                        and RHTcomportam in (1,6,8))--->
                        <!--- and dle.DLFvigencia between #Fecha1# and #Fecha2#--->
                            and dle.DEid = #EmpleadosRenta#.DEid
                        order by dle.DLfechaaplic desc),0)
            </cfquery> <!---SML. Considere el salario mensual Final--->
            

            <cfquery datasource="#session.DSN#" name="upAguiMes">
                update  #EmpleadosRenta#
                    set AguiExc = 0
                        , AguiGra =
                            coalesce((select sum(ic.ICmontores)
                                    from IncidenciasCalculo ic
                                        inner join CIncidentes c
                                            on ic.CIid = c.CIid
                                            and c.CInorenta = 0
                                            and c.CIart142 = 1
                                    where ic.DEid = #EmpleadosRenta#.DEid
                                        and ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">),0)

            </cfquery>

            <cfquery datasource="#session.DSN#" name="upAguiMes">
                update  #EmpleadosRenta#
                    set AguiMensual = ((isnull(AguiGra,0)/366)*30.4)<!---(((((AguiBruto/ 366) * (DiasTrab - Faltas -  Incapa))- AguiExc)/366) * 30.4 )--->
            </cfquery>

            <cfquery datasource="#session.DSN#" name="upAguiMes">
                update  #EmpleadosRenta#
                    set AguiMenGra = isnull(SalarioM,0) + AguiMensual
            </cfquery>

            <cfquery datasource="#session.DSN#" name="rsDatos">
                select *
                from #EmpleadosRenta#
            </cfquery>

            <cfloop query="rsDatos">
                <cfset ISPT_AguiMenGra = fnCalculaISPT(rsDatos.AguiMenGra,Arguments.IRcodigo,Arguments.RCNid)> <!---SML. Modificacion para que considera la tabla de renta en la nomina de aguinaldo--->
                <cfset ISPT_SalarioM = fnCalculaISPT(rsDatos.SalarioM,Arguments.IRcodigo,Arguments.RCNid)> <!---SML. Modificacion para que considera la tabla de renta en la nomina de aguinaldo--->
                <cfset ISPT_CF = ISPT_AguiMenGra - ISPT_SalarioM>


                <cfif ISPT_CF LTE 0 >
                    <cfset ISPT_Agui = 0>
                <cfelse>
                    <cfset Tasa_Efectiva =lsNumberFormat( (ISPT_CF / rsDatos.AguiMensual) * 100,'0.0')>
                
                    <cfset ISPT_Agui	 = ((Tasa_Efectiva * rsDatos.AguiGra )/100)>
                </cfif>

                <cfset Neto_Aguinado = (rsDatos.AguiGra + rsDatos.AguiExc - ISPT_Agui)>

                <cfquery datasource="#session.DSN#" name="upAguiMes">
                    update  #EmpleadosRenta#
                        set Neto_Agui = #Neto_Aguinado#,
                            ISPT_Aguinado = #ISPT_Agui#
                    where  #EmpleadosRenta#.DEid = #rsDatos.DEid#
                </cfquery>
            </cfloop>

            <!--- Fin Articulo 142 --->

            <!---------------------------------------------------------------------------------------->
			<!---Total de Salarios, salario referencia para la renta =+K+U+L+Q+R+M  (V)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                set totalSalRent = 	salMensual + incidNoProyect + incRecProyect
            </cfquery>

            <cfquery name="rsDtsCP" datasource="#session.dsn#">
                select
                    CPmes,Tcodigo
                from CalendarioPagos
                where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>

            <cfquery name="rsIdsCP" datasource="#session.dsn#">
                select 
                    CPid
                from CalendarioPagos
                where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDtsCP.Tcodigo#">
                and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDtsCP.CPmes#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            </cfquery>

            <cfset varCPIDs = ValueList(rsIdsCP.CPid)>


            <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)>
                <cfquery name="rsExist" datasource="#session.dsn#">
                    select RCNid,Tcodigo 
                    from HRCalculoNomina 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    and RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPIDs#" list="True">)
                </cfquery>

                <cfset varNumPer = rsExist.RecordCount+1>

                <cfquery name="rsTodos" datasource="#session.dsn#">
                    Select DEid
                    from #EmpleadosRenta#
                </cfquery>
                <cfif rsCantDiasCalendario.AjusteMensual eq 0>
                    <cfloop query="rsTodos">
                        <cfquery name="rsSalarios" datasource="#session.dsn#">
                            select top 1
                                coalesce(SEacumulado,0) SEacumulado
                            from 
                                HSalarioEmpleado hse
                            where hse.DEid = #rsTodos.DEid#
                            and RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPIDs#" list="True">)
                            order by RCNid desc
                        </cfquery>
                        
                        <cfloop query="rsSalarios">
                            <cfquery datasource="#session.DSN#">
                                update er
                                set totalSalRent +=	#rsSalarios.SEacumulado#
                                from 
                                    #EmpleadosRenta# er
                                where er.DEid = #rsTodos.DEid#
                            </cfquery>
                        </cfloop>
                    </cfloop>
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta# set diasCalendar *=  #varNumPer#
                    </cfquery>
                </cfif>

            </cfif>
            <!---------------------------------------------------------------------------------------->
            <!---Poner limites segun la tabla de renta--->
            

            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                set TLimInfAnt = ( select LimInf from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    ,TLimSupAnt = ( select LimSup from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    ,TMontoAnt	 = ( select MontoFijo from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    ,TporcentajeAnt = ( select Porcentaje from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
            </cfquery>

            <!---Poner limites segun la tabla de subsidios--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                set TLimSubInf = ( select LimInf from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    ,TLimSubSup = ( select LimSup from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    ,TMontoSub	 = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
            </cfquery>

			<!--- OPARRALES 2018-08-06 Para las nominas que no realizan cargas tampoco realizan deducciones por renta. --->
			<cfquery name="rsNominaCC" datasource="#session.dsn#">
				select
					tc.CalculaCargas
				from TiposNomina tc
				inner join RCalculoNomina rc
					on tc.Tcodigo = rc.Tcodigo
					and rc.Ecodigo = tc.Ecodigo
				where rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>

            <!---<cfset _aplicaRetencion = 1>--->
            
            <cfif rsNominaCC.CalculaCargas eq 1>
                <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual --->
                    <cfquery datasource="#session.dsn#">
                        update #EmpleadosRenta#
                        set FactorMensual = diasMesCalendar / diasNomina
                    </cfquery>

                    <cfquery datasource="#session.dsn#">
                        update #EmpleadosRenta#
                        set BaseGravableMensual = totalSalRent * FactorMensual
                    </cfquery>

                    
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set TLimInfAnt = ( select LimInf from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                            ,TLimSupAnt = ( select LimSup from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                            ,TMontoAnt	 = ( select MontoFijo from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                            ,TporcentajeAnt = ( select Porcentaje from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                    </cfquery>
                    
                    <!---Poner limites segun la tabla de subsidios--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set TLimSubInf = ( select LimInf from #TableSubsidio# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                            ,TLimSubSup = ( select LimSup from #TableSubsidio# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                            ,TMontoSub	 = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                    </cfquery>
                </cfif>
	            <!--- Renta  Mensual --->				<!---(W)---> 
                <!--- NOTA SML20092022 Revisar porque suman el ISPT_aguinaldo * factor Mensual--->
	            <cfquery datasource="#session.DSN#">
	                update #EmpleadosRenta#
			        <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual --->
			 	        set rentaMens = ((BaseGravableMensual - TLimInfAnt) * (TporcentajeAnt/100)) + TMontoAnt + ( isnull(ISPT_Aguinado,0) * FactorMensual)
			        <cfelse>
			 	        set rentaMens = ((totalSalRent - TLimInfAnt) * (TporcentajeAnt/100)) + TMontoAnt
                    </cfif>
                </cfquery>
 
                <!--- Subsidio Mensual --->				<!---(X)--->
	            <cfquery datasource="#session.DSN#">
	                update #EmpleadosRenta#
                    <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual --->
                        set subsidioMens = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.BaseGravableMensual between LimInf and LimSup)
                    <cfelse>
                        set subsidioMens = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    </cfif>
                </cfquery>

	            <!--- OPARRALES 2019-01-10 CALCULOR ISR MENSUAL---><!--- Renta Real--->					<!---(Y)--->
                <!--- OPARRALES 2019-01-10 CALCULO ISR SEMANAL --->
                <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual --->
                    <cfquery name="rsTodos" datasource="#session.dsn#">
                        select 
                            DEid
                        from #EmpleadosRenta#
                        <cfif IsDefined('Arguments.DEid') and Arguments.DEid gt 0>
                            where DEid = #Arguments.DEid#
                        </cfif>
                    </cfquery>
                    
                    <cfloop query="rsTodos">
                        <cfset _aplicaRetencion = 1>

                        <cfif rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1>
                            <cfset ajuste = ajusteMensualSubsidio(
                                RCNid=CalendarioPago.CPid, 
                                DEid=rsTodos.DEid,
                                CPperiodo=CalendarioPago.CPperiodo,
                                CPmes=CalendarioPago.CPmes, 
                                Tcodigo=CalendarioPago.Tcodigo,
                                IRcodigo=arguments.IRcodigo,
                                fechaDesde=CalendarioPago.CPdesde
                            )>
                        </cfif>
                        
                        <cfif rsCantDiasCalendario.AjusteMensual eq 0>
                            <cfquery name="rsISRAnterior" datasource="#session.dsn#">
                                select top 1
                                        hse.SErentaMens,#rsTodos.DEid# AS DEid, hse.SEDiferencial,
                                        CASE 
                                            WHEN hse.SEDiferencial > 0 THEN hse.SErentaMens
                                            ELSE hse.SEDiferencial
                                        END SEDiferencial
                                from 
                                    HSalarioEmpleado hse
                                where hse.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPIDs#" list="True">)
                                and hse.DEid = #rsTodos.DEid#
                                order by hse.RCNid desc
                            </cfquery>
                            <cfif rsISRAnterior.RecordCount gt 0>
                                <cfloop query="rsISRAnterior">
                                    <cfquery datasource="#session.DSN#">
                                        update #EmpleadosRenta#
                                        set 
                                            <cfif rsISRAnterior.SEDiferencial lte 0>
                                                rentaReal = (rentaMens / FactorMensual) + isnull(ISPT_Aguinado,0)
                                            <cfelse>
                                                rentaReal = ((rentaMens / FactorMensual) - #rsISRAnterior.SEDiferencial#) + isnull(ISPT_Aguinado,0)
                                            </cfif>
                                        where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsISRAnterior.DEid#">
                                    </cfquery>
                                </cfloop>
                            <cfelse>
                                <cfquery datasource="#session.DSN#">
                                    update #EmpleadosRenta#
                                    set rentaReal = (rentaMens / FactorMensual) 
                                    where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTodos.DEid#">
                                </cfquery>
                            </cfif>
                        <cfelse>
                            <cfquery name="rsEmpleadosRenta" datasource="#session.dsn#">
                                select * from #EmpleadosRenta#
                            </cfquery>

                            <cfquery name="rsSEOrdinario" datasource="#session.DSN#">
                                select  isnull(TMontoSubOrdinario,0) TMontoSubOrdinario ,isnull(TMontoISROrdinario,0) TMontoISROrdinario,isnull(TMontoSubsidioEntregado,0) TMontoSubsidioEntregado
                                    from #EmpleadosRenta#
                                where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTodos.DEid#">
                            </cfquery>
                       
                            <cfquery datasource="#session.DSN#">
                                update #EmpleadosRenta#
                                set rentaReal = 
                                <cfif _esFinMes>
                                    <cfset _subsudioIsr = (rsSEOrdinario.TMontoSubsidioEntregado lt 0) ? abs(rsSEOrdinario.TMontoSubsidioEntregado) : 0>
                                    <cfset _tsp = (ajuste.totalSubsidioPagado eq "")?0:ajuste.totalSubsidioPagado>
                                    <!---<cfdump var="#_subsudioIsr#">
                                    <cfdump var="#_tsp#">
                                    <cf_dump var="#ajuste#">--->
                                    <cfif ajuste.totalSubsidioEntregado gt 0>
                                        <cfif (ajuste.totalSubsidioEntregado gte _tsp)>
                                            <!---#ajuste.totalISRDETM# - #ajuste.totalISRDeterminado# + (#(ajuste.totalISRDeterminado - ajuste.totalSubsidioCausado gt 0 ) ? ajuste.totalISRDeterminado - ajuste.totalSubsidioCausado : 0#)--->
                                            0
                                            <cfset _aplicaRetencion = 0>
                                        <cfelseif (ajuste.totalSubsidioEntregado lt _tsp)>
                                            0
                                            <cfset _aplicaRetencion = 0>
                                        <cfelse>
                                            #ajuste.totalISRDETM# - (rentaMens / FactorMensual)
                                        </cfif>
                                    <cfelseif ajuste.totalSubsidioTabla gt 0>
                                        <cfif (ajuste.totalSubsidioEntregado gte _tsp) >
                                            <cfset _isr = (ajuste.totalISRDeterminado - ajuste.totalSubsidioCausado gt 0 ) ? ajuste.totalISRDeterminado - ajuste.totalSubsidioCausado : 0>
                                            <cfif _isr gt ajuste.totalISRM>
                                                0
                                                <cfset _aplicaRetencion = 0>
                                            <cfelse>
                                                <cfif ajuste.totalSubsidioTabla gt 0 and ajuste.totalSubsidioTabla gt ajuste.totalSubsidioCausado and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) gt 0>
                                                    #ajuste.totalISRAjustado#
                                                <cfelse>
                                                    (rentaMens / FactorMensual)
                                                </cfif>
                                            </cfif>
                                        <cfelse>
                                            <cfif ajuste.totalSubsidioTabla gt 0 and ajuste.totalSubsidioTabla gt ajuste.totalSubsidioCausado and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) gt 0>
                                                #ajuste.totalISRAjustado#
                                            <cfelse>
                                                #ajuste.totalISRDETM#
                                            </cfif>
                                        </cfif>                                        
                                    <cfelse>
                                        <cfif ajuste.totalSubsidioTabla gte 0 and ajuste.totalSubsidioTabla lte ajuste.totalSubsidioCausado and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) lt 0>
                                            0
                                            <cfset _aplicaRetencion = 0>
                                        <cfelseif ajuste.totalSubsidioTabla gte 0 and ajuste.totalSubsidioTabla lt ajuste.totalSubsidioCausado and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) gt 0>
                                            <cfif (ajuste.totalSubsidioEntregado lt _tsp)>
                                                #ajuste.totalISRAjustado# - #_tsp#
                                            <cfelse>
                                                #ajuste.totalISRAjustado#
                                            </cfif>
                                        <cfelseif ajuste.totalSubsidioTabla eq 0 and ajuste.totalSubsidioCausado eq 0 and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) gt 0>
                                            #ajuste.totalISRM# - #ajuste.totalISRAjustado#
                                        <cfelse>
                                            #ajuste.totalISRDETM# - (rentaMens / FactorMensual)
                                        </cfif>
                                    </cfif>                        
                                <cfelse>
                                    (rentaMens / FactorMensual)
                                </cfif>
                                
                                where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTodos.DEid#">
                            </cfquery>
                            <!---<cf_dumptable var="#EmpleadosRenta#">--->
                        </cfif>
                   <!---  </cfloop>
                    <cfloop query="rsTodos"> --->
                        <cfquery datasource="#session.DSN#">
                            update #EmpleadosRenta#
                            set TMontoSubOrdinario = (isnull(TMontoSub,0) / FactorMensual),
                                TMontoISROrdinario = (rentaMens / FactorMensual),
                                TMontoSubsidioEntregado = (rentaMens / FactorMensual) - (isnull(TMontoSub,0) / FactorMensual),
                                aplicaRetencion = #_aplicaRetencion#
                            where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTodos.DEid#">
                        </cfquery>

                        <cfquery name="rsSEOrdinario" datasource="#session.DSN#">
                            select  isnull(TMontoSubOrdinario,0) TMontoSubOrdinario ,isnull(TMontoISROrdinario,0) TMontoISROrdinario,isnull(TMontoSubsidioEntregado,0) TMontoSubsidioEntregado
                                from #EmpleadosRenta#
                            where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTodos.DEid#">
                        </cfquery>
                        
                        <cfquery datasource="#session.DSN#">
                            update #EmpleadosRenta#
                            set TMontoSub = 
                            <cfif isdefined("_esFinMes") and _esFinMes>
                                
                                <cfset _subsudioIsr = (rsSEOrdinario.TMontoSubsidioEntregado lt 0) ? abs(rsSEOrdinario.TMontoSubsidioEntregado) : 0>
                                <cfset _totalSubsidioPagado = (ajuste.totalSubsidioPagado eq "")?0:ajuste.totalSubsidioPagado>
                                <!---<cfdump var="#_subsudioIsr#">
                                <cfdump var="#_totalSubsidioPagado#">
                                <cf_dump var="#ajuste#">--->
                                <cfif ajuste.totalSubsidioEntregado gt 0>
                                    <cfif ajuste.totalSubsidioEntregado gt (_totalSubsidioPagado + _subsudioIsr )>
                                       <!--- (TMontoSub / FactorMensual)
                                       + ---> <!---(#ajuste.totalSubsidioTabla# - #ajuste.totalSubsidioCausado# )--->
                                        #ajuste.totalSubsidioEntregado# - (#_totalSubsidioPagado# + #_subsudioIsr#)
                                    <cfelseif ajuste.totalSubsidioEntregado lt (_totalSubsidioPagado + _subsudioIsr )>
                                        (#_totalSubsidioPagado# + #_subsudioIsr#) - #ajuste.totalSubsidioEntregado#
                                    <cfelse>
                                        (TMontoSub / FactorMensual) 
                                    </cfif>
                                <cfelseif ajuste.totalSubsidioTabla gt 0>
                                    <cfif (ajuste.totalSubsidioEntregado gte _totalSubsidioPagado) >
                                        <cfset _isr = (ajuste.totalISRDeterminado - ajuste.totalSubsidioCausado gt 0 ) ? ajuste.totalISRDeterminado - ajuste.totalSubsidioCausado : 0>

                                        <cfif _isr gt ajuste.totalISRM>
                                            #ajuste.totalSubsidioTabla - ajuste.totalSubsidioCausado#
                                        <cfelse>
                                            <cfif ajuste.totalSubsidioTabla gt 0 and ajuste.totalSubsidioTabla gt ajuste.totalSubsidioCausado and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) gt 0>
                                                0
                                            <cfelse>
                                                (TMontoSub / FactorMensual) 
                                            </cfif>
                                        </cfif>
                                    <cfelse>
                                        <cfif ajuste.totalSubsidioTabla gt 0 and ajuste.totalSubsidioTabla gt ajuste.totalSubsidioCausado and ajuste.totalISRM gt 0 and (ajuste.totalISRM - ajuste.totalISRAjustado) gt 0>
                                            0
                                        <cfelse>
                                            #ajuste.totalSubsidioTabla#
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    0 /* #rsSEOrdinario.TMontoSubOrdinario# */
                                </cfif>                        
                            <cfelse>
                                (TMontoSub / FactorMensual) 
                            </cfif>
                            <cfif isdefined("_esFinMes") and _esFinMes>
                                <cfif ajuste.totalISRM GT 0>
                                        ,totalISRM = #ajuste.totalISRM#
                                </cfif>
                                <cfif ajuste.totalSubsidioCausado GT 0>
                                        ,totalSubsidioCausado = #ajuste.totalSubsidioCausado#
                                </cfif>                                           
                            </cfif>
                            where #EmpleadosRenta#.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTodos.DEid#">
                        </cfquery>
                    </cfloop>

		        <cfelse>
			        <cfquery datasource="#session.DSN#">
		                update #EmpleadosRenta#
		                set rentaReal = (rentaMens - subsidioMens)
		            </cfquery>
                </cfif>
	            <!--- Renta Diaria--->					<!---(Z)--->
                
                <cfquery datasource="#session.DSN#">
	                update #EmpleadosRenta#
	                set rentaDiaria = rentaReal / diasNomina
                </cfquery>
            </cfif>
            
            <!--- Sacamos la renta por deducciones retenida de las nominas historicas para el mes periodo en que esta la nomina actual--->
           
            <!---Parametro RH de subsidio salario--->
            <cfquery datasource="#arguments.conexion#" name="rsDeduccion">
                select Pvalor as TDid,Pdescripcion  from RHParametros where Pcodigo = 2033 and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
            </cfquery>
            <cfif NOT rsDeduccion.RecordCount OR NOT LEN(TRIM(rsDeduccion.TDid))>
                <cfthrow message="Error en configuración, no se ha definido la deducción para subsidio de salario">
            </cfif>

            <!---Renta acumulada positiva + Renta por deducciones--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# set
                rentaAcumDed	=
                    coalesce((
                            select sum(f.DCvalor)
                            from CalendarioPagos x
                            inner join CalendarioPagos y
                                on x.CPmes = y.CPmes
                                and x.CPperiodo = y.CPperiodo
                                and x.Ecodigo = y.Ecodigo
                                and x.Tcodigo = y.Tcodigo
                                and y.CPTipoCalRenta = 1	<!---tome en cuenta solo los calendarios con renta en mes--->
                            inner join HRCalculoNomina a
                                on a.RCNid = y.CPid
                            inner join HSalarioEmpleado b
                                on b.RCNid = a.RCNid
                                and b.DEid = #EmpleadosRenta#.DEid
                            inner join HDeduccionesCalculo f
                                on f.DEid = b.DEid
                                and f.RCNid = b.RCNid
                            inner join DeduccionesEmpleado g
                                on g.Did = f.Did
                                and b.RCNid = f.RCNid
                                and g.TDid = #rsDeduccion.TDid#
                            where x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                            and x.CPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RCNid#">
                            and b.DEid = #EmpleadosRenta#.DEid
                            and g.TDid = #rsDeduccion.TDid#
                            ), 0)
            </cfquery>
           
            <!---Renta acumulada positiva + Renta por deducciones--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# set
                rentaAcum	=  rentaReal + rentaAcumDed
            </cfquery>

            <!--- Renta Real al Corte--->			<!---(AE)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                set retaRealCorte	= round(rentaReal,2)
            </cfquery>
           
            <!--- Retencion--->						<!---(AD)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta#
                <cfif rsDatosRenta.IRTipoPeriodo eq 5 or (rsCantDiasCalendario.AjusteMensual eq 1 and _esFinMes EQ 1)><!--- Mensual --->
                    set retencion	= (retaRealCorte - coalesce(TMontoSub,0)) * aplicaRetencion
                <cfelse>
                    set retencion	= retaRealCorte
                </cfif>
            </cfquery>
            <!---Fin de calculos en la tabla temporal--->

			<!---.................................Actualizacion de tablas del sistema..............................--->

            <!---Salarios acumulados (L)--->
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SEacumulado = (select totalSalRent
                                from #EmpleadosRenta#
                                where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                    and SalarioEmpleado.SEcalculado = 0
                    and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>

            
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SEDiferencial = (select (rentaMens / FactorMensual) - coalesce(TMontoSub,0)
                                from #EmpleadosRenta#
                                where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                    and SalarioEmpleado.SEcalculado = 0
                    and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>

            <!---Salarios proyectados (N)--->
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SEproyectado =(select totalSalRent
                                    from #EmpleadosRenta#
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>

            <!---Renta proyectada, "Renta Real al Corte"  (AD)--->
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SERentaT =(select case when retaRealCorte > 0 then retaRealCorte else 0 end
                                    from #EmpleadosRenta#
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>

            <!---Renta  (Retencion (AE))--->
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SErenta = (select 
                                    <cfif isdefined("_esFinMes") and _esFinMes>
                                        <cfif isDefined("ajuste") and ajuste.RecordCount GT 0>
                                            case when retencion > 0 then 
                                                case when totalISRM > 0 then 
                                                    case when totalSubsidioCausado > 0 then 
                                                        totalISRM - retencion
                                                    else
                                                    retencion
                                                    end 
                                                else retencion
                                                end 
                                            else 0 end
                                        <cfelse>
                                            case when retencion > 0 then retencion else 0 end
                                        </cfif>
                                    <cfelse>
                                        case when retencion > 0 then retencion else 0 end
                                    </cfif>
                                    from #EmpleadosRenta#
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>

            <!--- Si existen mas de 5 periodos no descuenta el subsidio --->
            <cfif isDefined('Arguments.PeriodosM') and Arguments.PeriodosM gte 5>
                <cfquery datasource="#arguments.conexion#">
                    update SalarioEmpleado
                        set SErenta = SErenta + coalesce((select TMontoSub
                                    from #EmpleadosRenta#
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid),0)   
                    where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                    and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                        <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                </cfquery>
            </cfif>

            <!--- OPARRALES 2019-05-28 Historico de Renta, guarda el calculo de Renta mensual --->
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SErentaMens =COALESCE((select case when rentaMens > 0 then (rentaMens / FactorMensual) else 0 end
                                    from #EmpleadosRenta#
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid),0)
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>
            
            <!--- Se guarda el calculo de ISR segun articulo 42 --->
            <cfquery datasource="#arguments.conexion#">
                update SalarioEmpleado
                set SErenta142 =COALESCE((select case when isnull(ISPT_Aguinado,0) > 0 then isnull(ISPT_Aguinado,0) else 0 end
                                    from #EmpleadosRenta#
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid),0)
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>

            <!---................................Pago de la Renta usando deducciones............................ --->

            <!---Deduccion de subsidio al salario de las nominas anteriores del periodo--->
            <cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#"
                ecodigo="#Arguments.Ecodigo#" pvalor="2033" default="0" returnvariable="vCIsubc"/>

            
            <!--- EGS 31052019: Cambio de la obtencion del subsidio, ahora se trae el diferencial del historico --->
            <cfif rsDatosRenta.IRTipoPeriodo eq 5 and rsCantDiasCalendario.AjusteMensual eq 0>
                
                <cfquery name="rsEmpSub" datasource="#session.dsn#">
                    select top 1
                            er.DEid,
                            CASE 
                                WHEN hse.SEDiferencial < 0 THEN (hse.SEDiferencial)
                                ELSE 0
                            END SErenta
                    from 
                        HSalarioEmpleado hse,
                        #EmpleadosRenta# er
                    where hse.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varCPIDs#" list="True">)
                    and hse.DEid=er.DEid
                    order by hse.RCNid desc
                </cfquery>
            <cfelse>
                <cfquery datasource="#arguments.conexion#" name="rsEmpSub">
                    select retencion as SErenta, DEid
                    from #EmpleadosRenta#
                    where coalesce(retencion, 0.00) < 0.00
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                </cfquery>
            </cfif>
            
            <cfif #vCIsubc# EQ 0>
                <cfthrow detail="Error no existe concepto de pago asociado al subsidio del salario Parametros RH -> Legislaci&oacute;n">
            <cfelse>
                <!---Parametro RH de subsidio salario--->
                <cfquery datasource="#arguments.conexion#" name="rsDeduccion">
                	select 
                        Pvalor as TDid,
                        Pdescripcion  
                    from 
                        RHParametros 
                    where 
                        Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2033"> 
                    and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                </cfquery>
                <!---Deduccion asociada al parametro--->
				<!---
                <cfquery datasource="#arguments.conexion#" name="rsTDeduccion">
                	select * from TDeduccion where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeduccion.TDid#">  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                </cfquery>
                 --->
				<cfquery name="rsInc" datasource="#Arguments.conexion#">
					select * from CIncidentes
					where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeduccion.TDid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>
				<!---Calendario de Pago--->
                <cfquery name="rsCalendarioPago" datasource="#arguments.conexion#">
                    select
                        a.CPcodigo,
                        a.CPid,
                        rtrim(a.Tcodigo) as Tcodigo,
                        a.CPdesde,
                        a.CPhasta,
                        CPtipo
                    from CalendarioPagos a
                    where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                    and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                </cfquery>
                <!---Tipos de Nomina--->
                <cfquery name="rsTiposNomina" datasource="#Session.DSN#">
                    select a.Tcodigo, a.Tdescripcion
                    from TiposNomina a
                    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                    and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCalendarioPago.Tcodigo#">
                    order by a.Tdescripcion
                </cfquery>
                
                <cfset renta = rsEmpSub.SErenta>

				<!---SML. Modificacion para que no aparezca el nombre de la nomina que le corresponde al trabajador.--->
                <!--- <cfset descripcion= <!---rsTiposNomina.Tdescripcion & ', ' &---> rsDeduccion.Pdescripcion> --->

                <!---ERBG Corrección en la descripción del Subsidio al salario Inicia 03/03/2014--->
                <!--- <cfset descripcion= #rsTDeduccion.TDdescripcion#> --->
				<cfset descripcion = #rsInc.CIdescripcion#>
                <!---ERBG Corrección en la descripción del Subsidio al salario Fin 03/03/2014--->
                <!---<cf_dump var="#rsEmpSub#">--->
                <cfloop query="rsEmpSub">
                    <cfif rsEmpSub.SErenta eq 0>
                        <cfcontinue>
                    </cfif>
					<cfquery datasource="#session.dsn#" name="rsUltAc">
						select top 1 cf.CFid,lt.RHJid from LineaTiempo lt
							inner join RHPlazas p
									on lt.RHPid = p.RHPid
								   and lt.Ecodigo = p.Ecodigo
								inner join CFuncional cf
									on cf.CFid=coalesce(p.CFidconta, p.CFid)
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpSub.DEid#">
						order by LTdesde desc
					</cfquery>
                    <!--- OPARRALES 2019-07-12
                        - Modificacion para poner fecha de subsidio al primer dia laborado del periodo a calcular para el empleado
                        - para el caso que el empleado sea dado de alta despues de la fecha inicio del periodo. 
                     --->
                    
                    <cfquery name="rsUltimaAlta" datasource="#session.dsn#">
                        select 
                            DLfvigencia
                        from
                            DLaboralesEmpleado dle
                        inner join RHTipoAccion ta
                            on dle.RHTid = ta.RHTid
                        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpSub.DEid#">
                        and ta.RHTcomportam = 1
                        and dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                        order by DLfvigencia desc
                    </cfquery>

                    <cfset difDays = 0>
                    <cfif DateDiff('d',arguments.RCdesde,rsUltimaAlta.DLfvigencia) gte 0 and DateDiff('d',arguments.RChasta,rsUltimaAlta.DLfvigencia) lte 0>
                        <cfset difDays = DateDiff('d',arguments.RCdesde,rsUltimaAlta.DLfvigencia)>
                    </cfif>

					<cfquery name="rsIns" datasource="#session.dsn#">
						INSERT INTO [dbo].[IncidenciasCalculo]
				           ([RCNid]
				           ,[DEid]
				           ,[CIid]
				           ,[Iid]
				           ,[ICfecha]
				           ,[ICvalor]
				           ,[ICfechasis]
				           ,[Usucodigo]
				           ,[Ulocalizacion]
				           ,[ICcalculo]
				           ,[ICbatch]
				           ,[ICmontoant]
				           ,[ICmontores]
				           ,[CFid]
				           ,[RHSPEid]
				           ,[ICmontoexentorenta]
				           ,[Mcodigo]
				           ,[ICmontoorigen]
				           ,[BMUsucodigo]
				           ,[RHJid]
				           ,[Iusuaprobacion]
				           ,[Ifechaaprobacion]
				           ,[NAP]
				           ,[NRP]
				           ,[Inumdocumento]
				           ,[CFcuenta]
				           ,[ICpadreIid]
				           ,[CSid]
				           ,[RHPid]
				           ,[CPmes]
				           ,[CPperiodo]
				           ,[ICespecie]
				           ,[Ifechacontrol]
				           ,[DLlinea])
				     VALUES
				           (#arguments.RCNid#
				           ,#rsEmpSub.DEid#
				           ,#rsInc.CIid#
				           ,null
				           ,'#LSDateFormat(DateAdd("d",difDays,arguments.RCdesde),"YYYY-MM-dd")#'
				           ,#Abs(rsEmpSub.SErenta)#
				           ,'#LSDateFormat(DateAdd("d",difDays,arguments.RCdesde),"YYYY-MM-dd")#'
				           ,#session.Usucodigo#
				           ,'00'
				           ,0
				           ,null
				           ,0
				           ,#Abs(rsEmpSub.SErenta)#
				           ,#rsUltAc.CFid#
				           ,null
				           ,null
				           ,null
				           ,null
				           ,null
				           ,#rsUltAc.RHJid#
				           ,null
				           ,null
				           ,null
				           ,null
				           ,null
				           ,null
				           ,null
				           ,null
				           ,null
				           ,#month(arguments.RChasta)#
				           ,#Year(arguments.RChasta)#
				           ,0
				           ,null
				           ,null)
					</cfquery>

					<cfquery datasource="#arguments.conexion#" name="rsUpdate">
						update SalarioEmpleado set SEincidencias = SEincidencias+ #Abs(rsEmpSub.SErenta)#
					    where DEid = #rsEmpSub.DEid#
					    and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
					</cfquery>
                </cfloop>

                <cfquery datasource="#arguments.conexion#" name="rsSelSub">
                	select DEid, coalesce(subsidioMens,0) as subsidioMens,
                        coalesce(rentaMens,0) as rentaMens, 
                        coalesce(tmontoSub,0) as tmontoSub, 
                        coalesce(rentaReal,0) as rentaReal 
                    from #EmpleadosRenta# <!---where DEid = #rsEmpSub.DEid#--->
                </cfquery>
                
                <cfloop query="rsSelSub">
                    <cfquery datasource="#arguments.conexion#">
                            delete from RHSubsidio
                            where RCNid = #arguments.RCNid#
                                and DEid = #rsSelSub.DEid#
                    </cfquery>
                    <cfset _esFinMes = esFinMes(RCNid=CalendarioPago.CPid, conexion=arguments.conexion,CPperiodo=CalendarioPago.CPperiodo,CPmes=CalendarioPago.CPmes, Tcodigo=CalendarioPago.Tcodigo) eq 1>
                    <cfquery datasource="#arguments.conexion#" name="rsInsertSub">
                            Insert into RHSubsidio(RCNid, DEid, Ecodigo, RHSvalor, RHSFechaDesde, RHSFechaHasta,ISRDeterminado)
                            values
                            (
                                #arguments.RCNid#,#rsSelSub.DEid#,#CalendarioPago.Ecodigo#,
                                <cfif isDefined('Arguments.PeriodosM') and Arguments.PeriodosM gte 5>
                                    0.00,
                                <cfelseif isdefined("_esFinMes") and _esFinMes>
                                    #rsSelSub.tmontoSub#,
                                <cfelse>
                                    #rsSelSub.subsidioMens# <cfif arguments.IRcodigo eq 'MXM01'>/30.4*#arguments.cantdias#</cfif>,
                                </cfif>
                                '#DateFormat(CalendarioPago.CPdesde,'yyyy-mm-dd')#','#DateFormat(CalendarioPago.CPhasta,'yyyy-mm-dd')#',
                                <cfif isdefined("_esFinMes") and _esFinMes>
                                    #rsSelSub.rentaReal#
                                <cfelse>
                                    #rsSelSub.rentaMens#<cfif arguments.IRcodigo eq 'MXM01'>/30.4*#arguments.cantdias#</cfif>
                                </cfif>
                            )
                    </cfquery>
                </cfloop>
            </cfif>


            <cfif isdefined("_esFinMes") and _esFinMes>
                <!--- Ajuste mensual subsidio al empleo --->
                <cfif isdefined('arguments.DEid')> 
                    <cfif CalendarioPago.AjusteMensual eq 1>
                        <cfset varDEid = arguments.DEid>
                        <cfset ajuste = ajusteMensualSubsidio(RCNid=CalendarioPago.CPid, DEid=varDEid,CPperiodo=CalendarioPago.CPperiodo,CPmes=CalendarioPago.CPmes, Tcodigo=CalendarioPago.Tcodigo,IRcodigo=arguments.IRcodigo,fechaDesde=CalendarioPago.CPdesde)>
                    </cfif>    
                <cfelse>
                    <cfif isdefined("rsEmpRn") and rsEmpRn.RecordCount GT 0>
                        <cfloop query="rsEmpRn">
                            <cfif CalendarioPago.AjusteMensual eq 1>
                                <cfset varDEid = rsEmpRn.DEID>
                                <cfset ajusteMensualSubsidio(RCNid=CalendarioPago.CPid, DEid=varDEid,CPperiodo=CalendarioPago.CPperiodo,CPmes=CalendarioPago.CPmes, Tcodigo=CalendarioPago.Tcodigo,IRcodigo=arguments.IRcodigo,fechaDesde=CalendarioPago.CPdesde)>
                            </cfif>
                        </cfloop>
                    </cfif>
                </cfif>  
            </cfif>

        <!---Metodo para el Calculo de Renta 2 = Por Nomina aguinaldo(Sobre lo que se esta pagado)--->
        <cfelseif CalendarioPago.CPTipoCalRenta EQ 2>
            <cfset fnCalculoRentaMetodo2(Arguments.RCNid,Arguments.IRcodigo,Arguments.RChasta)>
        <!---Calculo de Renta por tipo3=Ajuste Anual sobre lo que se han Ejecutado en el Año Fiscal--->
		<cfelseif CalendarioPago.CPTipoCalRenta EQ 3>
        	<cfset fnCalculoRentaMetodo3(Arguments.RCNid,Arguments.IRcodigo,Arguments.RChasta)>
        <cfelseif CalendarioPago.CPTipoCalRenta EQ 4>
        	<cfset fnCalculoRentaMetodo4(Arguments.RCNid,Arguments.IRcodigo,Arguments.RChasta,Arguments.Tcodigo)>
        <cfelse>
        	<cfthrow message="Tipo de Cálculo de Renta no implementado">
        </cfif>
        <!--- <cf_dumptable  var="#EmpleadosSubsidio#" abort="false">
        <cf_dumptable  var="#EmpleadosRenta#" abort> --->
        <cfquery datasource="#session.dsn#">
            insert into RH_CalculoISR
            (RCNid,DEid,Ecodigo,SalarioM,SalarioMensual,DiasPeriodo,BaseGravableMensual,TLIMSubInf,TPorcentajeAnt,
            TMontoAnt,RentaMens,RentaReal,SubsidioMens,TMontoSub,TMontoSubsidioEntregado,Retencion)
            select #arguments.RCNid#,DEid,#arguments.Ecodigo#,
                isnull(SalarioM,0) SalarioM,
                isnull(SalMensual,0) SalMensual,
                isnull(DiasNOmina,0) DiasNOmina,
                isnull(BaseGravableMensual,0) BaseGravableMensual,
                TLIMSubInf,TPorcentajeAnt,TMontoAnt,RentaMens,RentaReal,SubsidioMens,TMontoSub,TMontoSubsidioEntregado,Retencion
            from #EmpleadosRenta#
        </cfquery>
        <cfif isdefined("EmpleadosSubsidio")>
            <cfquery name="rsEmpleadosSubsidio" datasource="#session.dsn#">
                select 
                    DEid,
                    isnull(TotalGravable,0) TotalGravable,
                    isnull(TotalIsrAjustado,0) TotalIsrAjustado,
                    isnull(TotalIsrDeterminado,0) TotalIsrDeterminado,
                    isnull(TotalIsrDetm,0) TotalIsrDetm,
                    isnull(TotalIsrM,0) TotalIsrM,
                    isnull(TotalSubsidioCausado,0) TotalSubsidioCausado,
                    isnull(TotalSubsidioEntregado,0) TotalSubsidioEntregado,
                    isnull(TotalSubsidioPagado,0) TotalSubsidioPagado,
                    isnull(TotalSubsidioTabla,0) TotalSubsidioTabla
                from #EmpleadosSubsidio#
            </cfquery>
            <cfloop query="rsEmpleadosSubsidio">
                <cfquery datasource="#session.dsn#">
                    update RH_CalculoISR
                        set TotalGravable = #rsEmpleadosSubsidio.TotalGravable#,
                            TotalIsrAjustado = #rsEmpleadosSubsidio.TotalIsrAjustado#,
                            TotalIsrDeterminado = #rsEmpleadosSubsidio.TotalIsrDeterminado#,
                            TotalIsrDetm = #rsEmpleadosSubsidio.TotalIsrDetm#,
                            TotalIsrM = #rsEmpleadosSubsidio.TotalIsrM#,
                            TotalSubsidioCausado = #rsEmpleadosSubsidio.TotalSubsidioCausado#,
                            TotalSubsidioEntregado = #rsEmpleadosSubsidio.TotalSubsidioEntregado#,
                            TotalSubsidioPagado = #rsEmpleadosSubsidio.TotalSubsidioPagado#,
                            TotalSubsidioTabla = #rsEmpleadosSubsidio.TotalSubsidioTabla#
                        where DEid = #rsEmpleadosSubsidio.DEid#
                </cfquery>
            </cfloop>
        </cfif>
        
        <cfreturn>
	</cffunction>

    <!---Funcion para la obtención del Calendario de Pago de la nomina--->
    <cffunction name="fnGetCalendarioPago" access="public" returntype="query">
    	<cfargument name="RCNid"   	type="numeric" 	required="yes">
        <cfargument name="conexion" type="string" 	required="no">

        <cfif NOT isdefined('Arguments.conexion') OR NOT LEN(TRIM(Arguments.conexion))>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>

    	<cfquery name="rsCP" datasource="#Arguments.conexion#">
       		select CPid, CPTipoCalRenta, CPtipo, b.CPperiodo, b.CPmes,b.CPdesde, b.CPhasta, b.Tcodigo, b.Ecodigo, c.Ttipopago,c.AjusteMensual
            	from RCalculoNomina a
                	inner join CalendarioPagos b
                    	on  b.CPid = a.RCNid
                     inner join TiposNomina c
                     	 on c.Ecodigo = b.Ecodigo
                        and c.Tcodigo = b.Tcodigo
              where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>

        <cfif rsCP.RecordCount EQ 0>
        	<cfthrow message="Error de integridad de datos. No se pudo recuperar el calendario de Pago de la Nomina">
        <cfelse>
        	<cfreturn rsCP>
        </cfif>
    </cffunction>

     <!---Metodo para el Calculo de Renta 2=Por Nomina Aguinaldo(Sobre lo que se esta pagado)--->
	<!---ljimenez se modifica para que sea el calculo de renta para el aguinaldo en mexico.
	 se deja comentado lo realizado por jose que aplica para renta en nomina.--->

	<!--- Calcula y devuelve el ISPT en base al monto ingresado--->
    <cffunction name="fnCalculaISPT" access="public" returntype="numeric">
        <cfargument name="Monto" 				type="numeric" 	required="yes">
        <cfargument name="IRcodigo" 			type="string"> <!---SML. Para considerar la tabla de Renta para el nomina de aguinaldo--->
         <cfargument name="RCNid" 				type="numeric">
        <cfargument name="Fecha" 				type="date">
        <cfargument name="Ecodigo" 				type="numeric">
        <cfargument name="Conexion" 			type="string">

        <cfif not isdefined('Arguments.Fecha')>
            <cfset Arguments.Fecha = now()>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = "#session.Ecodigo#">
        </cfif>
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = "#session.dsn#">
        </cfif>

        <cfif not isdefined('Arguments.IRcodigo')>
            <cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#"
                    ecodigo="#Arguments.Ecodigo#" pvalor="30" default="" returnvariable="IRcodigoN1"/>
        <cfelse>
        	<cfset IRcodigoN1 = #Arguments.IRcodigo#>
        </cfif>

        <!---<cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#"
                    ecodigo="#Arguments.Ecodigo#" pvalor="30" default="" returnvariable="IRcodigoN1"/>--->


                        <!---<cfthrow message="'#IRcodigoN1#'">--->

        <cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaImpuestoMarginal" returnvariable="ImpMarginal">
            <cfinvokeargument name="Monto" 			value="#Arguments.Monto#">
            <cfinvokeargument name="Fecha" 			value="#Arguments.Fecha#">
            <cfinvokeargument name="IRcodigo" 		value="#IRcodigoN1#">
            <cfinvokeargument name="SumarCuotaFija" value="true">
            <cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">
        </cfinvoke>


        <!---Para saber si tenemos una tabla hija esto es para el calculo de renta en mexico--->
        <cfquery name="rsIRcodigoN2" datasource="#Session.DSN#">
            select IRcodigo
                from ImpuestoRenta
                where IRcodigoPadre = '#IRcodigoN1#'
        </cfquery>

         <cfif isdefined('Arguments.RCNid')>
        	<cfset RCNid = #Arguments.RCNid#>
            <cfquery name="rsValNominaA" datasource="#session.DSN#">
            	select 1 as validacion from CalendarioPagos
				where Ecodigo = #session.Ecodigo#
					and CPTipoCalRenta = 2
					and CPid = #RCNid#
            </cfquery>
        </cfif>

        <cfif not isdefined("rsValNominaA") or rsValNominaA.validacion EQ 0>
        <cfinvoke component="rh.Componentes.RH_CalculoRentaMexico" method="fnCalculaSubsidio" returnvariable="Ssalario">
            <cfinvokeargument name="Monto" 		value="#Arguments.Monto#">
            <cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#">
            <cfinvokeargument name="IRcodigo" 	value="#rsIRcodigoN2.IRcodigo#">
            <cfinvokeargument name="Conexion" 	value="#Arguments.Conexion#">
        </cfinvoke>
        </cfif>

		<cfif isdefined("Ssalario")>
        	<cfreturn (ImpMarginal - Ssalario)>
        <cfelse>
        	<cfreturn ImpMarginal>
        </cfif>
    </cffunction>

   	<cffunction name="fnCalculoRentaMetodo2" access="public">
    	 <cfargument name="RCNid"    type="numeric" required="yes">
         <cfargument name="IRcodigo" type="string"  required="yes">
         <cfargument name="RChasta"  type="date"    required="yes">
         <cfargument name="Ecodigo"  type="numeric" required="no">
         <cfargument name="conexion" type="string" 	required="no">

        <cfif NOT isdefined('Arguments.Ecodigo') OR NOT LEN(TRIM(Arguments.Ecodigo))>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.conexion') OR NOT LEN(TRIM(Arguments.conexion))>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        
        <cf_dbtemp name="temp_CalRenMet2_v2" returnvariable="EmpleadosRenta" datasource="#session.DSN#">
			<cf_dbtempcol name="DEid" 		    type="numeric" mandatory="no">
            <cf_dbtempcol name="AguiBruto"	 	type="money"   mandatory="no">
			<cf_dbtempcol name="AguiExc"	 	type="money"   mandatory="no">
			<cf_dbtempcol name="AguiGra"	 	type="money"   mandatory="no">
			<cf_dbtempcol name="SalarioM"	 	type="money"   mandatory="no">
			<cf_dbtempcol name="DiasTrab"	 	type="money"   mandatory="no">
			<cf_dbtempcol name="Faltas"	 		type="money"   mandatory="no">
			<cf_dbtempcol name="Incapa"	 		type="money"   mandatory="no">
			<cf_dbtempcol name="AguiMensual" 	type="money"   mandatory="no">
			<cf_dbtempcol name="AguiMenGra"		type="money"   mandatory="no">
            <cf_dbtempcol name="Neto_Agui"      type="money"   mandatory="no">
			<cf_dbtempcol name="ISPT_Aguinado"  type="money"   mandatory="no">
			<cf_dbtempcol name="RVid"  			type="integer"   mandatory="no">
			<cf_dbtempcol name="Annos"  		type="integer"   mandatory="no">
            <cf_dbtempcol name="salMensual" 	type="money" 			mandatory="no">	<!--- Salario  Mensual --->				<!---H--->
            <cf_dbtempcol name="diasNomina" 	type="numeric" 			mandatory="no">	<!--- Dias Nomina--->					<!---AA--->
            <cf_dbtempcol name="baseGravableMensual" 	type="money" 			mandatory="no">	<!--- Salario  Mensual --->				<!---H--->
            <cf_dbtempcol name="TporcentajeAnt" 		type="money" 			mandatory="no">
            <cf_dbtempcol name="TLimSubInf" 			type="money" 			mandatory="no"> <!--- Datos tabla de subsidio--->
            <cf_dbtempcol name="rentaMens" 				type="numeric(18,10)" 			mandatory="no">	<!--- Renta  Mensual --->				<!---W--->
            <cf_dbtempcol name="subsidioMens" 			type="money" 			mandatory="no">	<!--- Subsidio Mensual --->				<!---X--->
            <cf_dbtempcol name="rentaReal" 				type="money" 			mandatory="no">	<!--- Renta Real--->					<!---Y--->
            <cf_dbtempcol name="retencion" 				type="money" 			mandatory="no">	<!--- Retencion--->						<!---AD--->
            <cf_dbtempcol name="TMontoAnt" 				type="money" 			mandatory="no">
            <cf_dbtempcol name="TMontoSub" 				type="money" 			mandatory="no">
            <cf_dbtempcol name="TMontoSubsidioEntregado"  type="money" 	        mandatory="no">
		</cf_dbtemp>
       

		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#"
						ecodigo="#Arguments.Ecodigo#" pvalor="2024" default="0" returnvariable="vSGMG"/>

		<cfset Fecha1 = createdate(year(now()),01,01)>
		<cfset Fecha2 = createdate(year(now()),12,31)>

         <!--- esto se pasa a la formulacion del concepto


        <cfquery datasource="#session.DSN#" name="rsEmpleadosRenta" >
            insert into #EmpleadosRenta#(DEid,AguiBruto,AguiExc, AguiGra, SalarioM, RVid, Annos, DiasTrab, Faltas, Incapa  )

			select b.DEid, b.SEincidencias, (#vSGMG# * 30) as AguiExc,  (b.SEincidencias - (#vSGMG# * 30)) as AguiGra,
				l.LTsalario, l.RVid ,
				case
					when <cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,YYYY "> = 0
						then 1
					else
						<cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,YYYY ">
					end as annos,
				case
					when <cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,DD"  datasource="#Arguments.conexion#"> > 365
						then 365
					else <cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,DD"  datasource="#Arguments.conexion#">
				end as dias,

				(select coalesce(sum(h.PEcantdias),0)
				from HPagosEmpleado h
					inner join RHTipoAccion r
					  on r.RHTid = h.RHTid
				where h.DEid = b.DEid
					and r.RHTcomportam = 13 <!--- Ausencia / Falta --->
					and h.PEtiporeg = 0 	<!--- Tipo de Registro: 0 :Normal --->
					and r.Ecodigo = d.Ecodigo
					and h.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					and h.PEhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">) as faltas,

				(select coalesce(sum(h.PEcantdias),0)
				from HPagosEmpleado h
					inner join RHTipoAccion r
					  on r.RHTid = h.RHTid
				where h.DEid = b.DEid
					and r.RHTcomportam = 5 	<!--- Incapacidad --->
					and h.PEtiporeg = 0 	<!--- Tipo de Registro: 0 :Normal --->
					and r.Ecodigo = d.Ecodigo
					and h.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					and h.PEhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">) as incap

			from RCalculoNomina a
				inner join SalarioEmpleado b
                	on b.RCNid = a.RCNid
				 inner join IncidenciasCalculo c
                	on c.RCNid = a.RCNid
                    and c.DEid = b.DEid
				inner join DatosEmpleado d
					on b.DEid = d.DEid
				inner join LineaTiempo l
					on c.DEid = l.DEid
						and l.LTdesde < <cf_dbfunction name="now" args=""  datasource="#Arguments.conexion#">
						and l.LThasta > <cf_dbfunction name="now" args=""  datasource="#Arguments.conexion#">
				inner join EVacacionesEmpleado ev
					on d.DEid = ev.DEid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>--->



        <cfquery datasource="#session.DSN#" name="rsEmpleadosRenta" >
            insert into #EmpleadosRenta#(DEid,AguiBruto,AguiExc, AguiGra, SalarioM, RVid, Annos, DiasTrab, Faltas, Incapa  )

			select distinct b.DEid, b.SEincidencias, 0,  0, 0, l.RVid ,
				case
					when <cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,YYYY "> = 0
						then 1
					else
						<cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,YYYY ">
					end as annos,
				case
					when <cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,DD"  datasource="#Arguments.conexion#"> > 366
						then 366
					else <cf_dbfunction name="datediff" args="ev.EVfantig, #Fecha2# ,DD"  datasource="#Arguments.conexion#">
				end as dias,

				(select coalesce(sum(h.PEcantdias),0)
				from HPagosEmpleado h
					inner join RHTipoAccion r
					  on r.RHTid = h.RHTid
				where h.DEid = b.DEid
					and r.RHTcomportam = 13 <!--- Ausencia / Falta --->
					and h.PEtiporeg = 0 	<!--- Tipo de Registro: 0 :Normal --->
					and r.Ecodigo = d.Ecodigo
					and h.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					and h.PEhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">) as faltas,

				(select coalesce(sum(h.PEcantdias),0)
				from HPagosEmpleado h
					inner join RHTipoAccion r
					  on r.RHTid = h.RHTid
				where h.DEid = b.DEid
					and r.RHTcomportam = 5 	<!--- Incapacidad --->
					and h.PEtiporeg = 0 	<!--- Tipo de Registro: 0 :Normal --->
					and r.Ecodigo = d.Ecodigo
					and h.PEdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
					and h.PEhasta <=  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">) as incap

			from RCalculoNomina a
				inner join SalarioEmpleado b
                	on b.RCNid = a.RCNid
				 inner join IncidenciasCalculo c
                	on c.RCNid = a.RCNid
                    and c.DEid = b.DEid
				inner join DatosEmpleado d
					on b.DEid = d.DEid
				inner join LineaTiempo l
					on c.DEid = l.DEid
						and l.LTdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#"> <!---SML.Modificacion para considerar a empleados que se encuentren de vacaciones--->
						and l.LThasta > <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#"> <!---SML.Modificacion para considerar a empleados que se encuentren de vacaciones--->
				inner join EVacacionesEmpleado ev
					on d.DEid = ev.DEid
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>


        <cfquery datasource="#session.DSN#" name="rsActEmplado"><!---SML. Considere el salario mensual Inicio--->
            update #EmpleadosRenta# set
        	SalarioM = (select top 1 ddle.DDLmontobase
					   from DDLaboralesEmpleado ddle inner join DLaboralesEmpleado dle on dle.DLlinea = ddle.DLlinea
							  <!---inner join RHTipoAccion rhta on rhta.RHTid = dle.RHTid--->
							  inner join ComponentesSalariales cs on cs.CSid = ddle.CSid
					   where dle.Ecodigo = #session.Ecodigo#
	  			       and ddle.CSid in (select CSid from ComponentesSalariales
								  where Ecodigo = #session.Ecodigo#
								    and CSsalariobase = 1)
	  			      <!--- and dle.RHTid in (select RHTid from RHTipoAccion
								  where Ecodigo = #session.Ecodigo#
								    and RHTcomportam in (1,6,8))--->
	  		         <!--- and dle.DLFvigencia between #Fecha1# and #Fecha2#--->
	  		          and dle.DEid = #EmpleadosRenta#.DEid
			          order by dle.DLfechaaplic desc)
        </cfquery> <!---SML. Considere el salario mensual Final--->


        <cfquery datasource="#session.DSN#" name="upAguiMes">
			update  #EmpleadosRenta#
				set AguiExc =
                          coalesce((select ic.ICmontores
                            from IncidenciasCalculo ic
                                inner join CIncidentes c
                                     on ic.CIid = c.CIid
                              where ic.DEid = #EmpleadosRenta#.DEid
                              	and c.CInorenta = 1
                                and c.CInopryrenta = 1
                                and ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">),0)


                       , AguiGra =
                           coalesce((select ic.ICmontores
                                from IncidenciasCalculo ic
                                    inner join CIncidentes c
                                         on ic.CIid = c.CIid
                                         and c.CInorenta = 0
                                 where ic.DEid = #EmpleadosRenta#.DEid
                                    and ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">),0)

		</cfquery>

      <!---  <cfquery datasource="#session.DSN#" name="upAguiMes">
			update  #EmpleadosRenta#
				set AguiGra =
                 coalesce((select sum(ic.ICmontores)
                	from IncidenciasCalculo ic
		                inner join CIncidentes c
        			         on ic.CIid = c.CIid
            		 where ic.DEid = #EmpleadosRenta#.DEid
                     	and c.CInorenta = 0
                     	and ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                     group by ic.DEid) ,0)

		</cfquery>--->

        <!---<cfthrow message="#arguments.IRcodigo#">--->

        <cfquery datasource="#session.DSN#" name="upAguiMes">
			update  #EmpleadosRenta#
				set AguiMensual = ((AguiGra/366)*30.4)<!---(((((AguiBruto/ 366) * (DiasTrab - Faltas -  Incapa))- AguiExc)/366) * 30.4 )--->
		</cfquery>

		<cfquery datasource="#session.DSN#" name="upAguiMes">
			update  #EmpleadosRenta#
				set AguiMenGra = SalarioM + AguiMensual
		</cfquery>

		<cfquery datasource="#session.DSN#" name="rsDatos">
			select *
			from #EmpleadosRenta#
		</cfquery>

		<cfloop query="rsDatos">
			<cfset ISPT_AguiMenGra = fnCalculaISPT(rsDatos.AguiMenGra,Arguments.IRcodigo,Arguments.RCNid)> <!---SML. Modificacion para que considera la tabla de renta en la nomina de aguinaldo--->
			<cfset ISPT_SalarioM = fnCalculaISPT(rsDatos.SalarioM,Arguments.IRcodigo,Arguments.RCNid)> <!---SML. Modificacion para que considera la tabla de renta en la nomina de aguinaldo--->
			<cfset ISPT_CF = ISPT_AguiMenGra - ISPT_SalarioM>


			<cfif ISPT_CF LTE 0 >
				<cfset ISPT_Agui = 0>
			<cfelse>
                <cfset Tasa_Efectiva =lsNumberFormat( (ISPT_CF / rsDatos.AguiMensual) * 100,'0.0')>
              
				<cfset ISPT_Agui	 = ((Tasa_Efectiva * rsDatos.AguiGra )/100)>
			</cfif>

			<cfset Neto_Aguinado = (rsDatos.AguiGra + rsDatos.AguiExc - ISPT_Agui)>

			<cfquery datasource="#session.DSN#" name="upAguiMes">
				update  #EmpleadosRenta#
					set Neto_Agui = #Neto_Aguinado#,
						ISPT_Aguinado = #ISPT_Agui#
				where  #EmpleadosRenta#.DEid = #rsDatos.DEid#
			</cfquery>

        <!---			<br>
			ISPT_AguiMenGra :<cfdump var="#ISPT_AguiMenGra#"><br>
			ISPT_SalarioM: <cfdump var="#ISPT_SalarioM#"><br>
			ISPT_CF: <cfdump var="#ISPT_CF#"><br>
			ISPT_Aguinado: <cfdump var="#ISPT_Aguinado#"><br>
			Neto_Aguinado: 	<cfdump var="#Neto_Aguinado#"><br>
		--->
		</cfloop>

         <cfquery datasource="#session.DSN#">
         update SalarioEmpleado
            	set SErenta = coalesce((select distinct ISPT_Aguinado from #EmpleadosRenta# where DEid = SalarioEmpleado.DEid),0)
             where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
         </cfquery>
	</cffunction>

 <!---   Ajuste anual de renta--->
    <cffunction name="fnCalculoRentaMetodo3" access="public">
    	 <cfargument name="RCNid"    type="numeric" required="yes">
         <cfargument name="IRcodigo" type="string"  required="yes">
         <cfargument name="RChasta"  type="date"    required="yes">
         <cfargument name="Ecodigo"  type="numeric" 	required="no">
         <cfargument name="conexion" type="string" 	required="no">

         <cfif NOT isdefined('Arguments.Ecodigo') OR NOT LEN(TRIM(Arguments.Ecodigo))>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.conexion') OR NOT LEN(TRIM(Arguments.conexion))>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>

        <!---????Se obtienen el Periodo de Renta Actual del Calendari de Pago???--->
        <cf_dbfunction name="dateadd" args="12, EIRdesde,MM" 		returnvariable="FechaHastaTemp">
		<cf_dbfunction name="dateadd" args="-1!#FechaHastaTemp#!DD" returnvariable="FechaHasta" delimiters="!" >
        <cfquery datasource="#Arguments.conexion#" name="Tabla">
            select a.EIRid, a.EIRdesde FechaDesde, #FechaHasta# as FechaHasta
                from EImpuestoRenta a
                where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
                  and a.EIRestado = 1
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
        </cfquery>


        <!---????Se verifica si el Periodo Actual debe ser Tomado en Cuenta???--->
        <cfquery datasource="#Arguments.conexion#" name="MesActual">
        	select a.Tcodigo, a.Ecodigo, a.CPmes, a.CPperiodo, count(a.CPid) existentes, count(b.RCNid) pagados, count(c.RCNid) Actuales
                from CalendarioPagos a
                    left outer join HRCalculoNomina b
                        on b.RCNid=a.CPid
                    left outer join RCalculoNomina c
                        on c.RCNid=a.CPid
                where a.CPtipo = 0
                and  (select count(1)
                            from CalendarioPagos d
                        where d.Ecodigo 	= a.Ecodigo
                           and d.CPperiodo 	= a.CPperiodo
                           and d.CPmes 		= a.CPmes
                           and d.Tcodigo 	= a.Tcodigo
                          and d.CPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                        ) > 0
            group by a.Tcodigo, a.Ecodigo, a.CPmes,a.CPperiodo
        </cfquery>


        <cfif MesActual.existentes EQ MesActual.pagados>
        	<cfset ConsideraMesActual = true>
        <cfelse>
        	<cfset ConsideraMesActual = false>
        </cfif>
        <!---????Creacion de la tabla de trabajo????--->
        <cf_dbtemp name="temp_CalRenMet3_v1" returnvariable="EmpleadosRenta" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="DEid" 		    type="numeric" mandatory="no">
            <cf_dbtempcol name="RentaCobrada"   type="money"   mandatory="no">
            <cf_dbtempcol name="MontoBruto" 	type="money"   mandatory="no"><!---IncidenciasR + SEsalariobruto - Cargas--->
            <cf_dbtempcol name="Rentencion"     type="money"   mandatory="no">
            <cf_dbtempcol name="Subsidio"       type="money"   mandatory="no">
		</cf_dbtemp>

		<!---???Se insertan los montos Historicos????--->
         <cfquery datasource="#Arguments.conexion#">
            insert into #EmpleadosRenta#(DEid,RentaCobrada, MontoBruto)
             select b.DEid,coalesce(sum(b.SErenta),0),coalesce(sum(d.ICvalor),0) + coalesce(sum(b.SEsalariobruto),0) - coalesce(sum(f.CCvaloremp),0)
             from HRCalculoNomina a
             	left outer join HSalarioEmpleado b
                	on b.RCNid = a.RCNid
                left outer join HCargasCalculo f
                	inner join DCargas g
                    	 on g.DClinea = f.DClinea
                        and g.DCnorenta = 1
                      on f.RCNid = a.RCNid
                     and f.DEid = b.DEid
                left outer join HIncidenciasCalculo d
                	inner join CIncidentes e
                    	 on e.CIid      = d.CIid
                        and e.CInorenta = 0
                	 on d.RCNid     = a.RCNid
                    and d.DEid      = b.DEid
                inner join CalendarioPagos h
                	on h.CPid = a.RCNid
             where a.RChasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Tabla.FechaDesde#">
                                  and <cfqueryparam cfsqltype="cf_sql_date" value="#Tabla.FechaHasta#">
             <cfif NOT ConsideraMesActual>
             	and NOT (h.CPperiodo = #MesActual.CPperiodo# and h.CPmes = #MesActual.CPmes#)
             </cfif>
             and b.DEid in (select j.DEid
             					from SalarioEmpleado j
                            where j.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">)
             group by b.DEid
        </cfquery>



        <cfif ConsideraMesActual>
        	<cfquery datasource="#Arguments.conexion#">
             	update #EmpleadosRenta#
                 set MontoBruto = MontoBruto +(select coalesce(sum(d.ICvalor),0) + coalesce(sum(b.SEsalariobruto),0) - coalesce(sum(f.CCvaloremp),0)
                                               	from RCalculoNomina a
                                                	left outer join SalarioEmpleado b
                                                        on b.RCNid = a.RCNid
                                                    left outer join IncidenciasCalculo c
                                                        on c.RCNid = a.RCNid
                                                        and c.DEid = b.DEid
                                                    left outer join CargasCalculo f
                                                        inner join DCargas g
                                                             on g.DClinea = f.DClinea
                                                            and g.DCnorenta = 1
                                                          on f.RCNid = a.RCNid
                                                         and f.DEid = b.DEid
                                                    left outer join IncidenciasCalculo d
                                                        inner join CIncidentes e
                                                             on e.CIid      = d.CIid
                                                            and e.CInorenta = 0
                                                         on d.RCNid     = a.RCNid
                                                        and d.DEid      = b.DEid
                                                 where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                                                 and #EmpleadosRenta#.DEid = b.DEid)

             </cfquery>
        </cfif>
        <!---????Cantidad de Meses que se estan Ajustando sin contar el Actual????--->
         <cfquery datasource="#session.DSN#" name="rsCantidadMeses">
        	select distinct CPperiodo, CPmes
             from HRCalculoNomina a
				inner join CalendarioPagos b
					on a.RCNid=b.CPid
   			 where a.RChasta between
                 <cfqueryparam cfsqltype="cf_sql_date" value="LSParseDateTime('#MesActual.CPperiodo#0101')"> and
                 <cfqueryparam cfsqltype="cf_sql_date" value="LSParseDateTime('#MesActual.CPperiodo#1231')">
			   and a.Ecodigo = #Session.Ecodigo#
			   and b.CPtipo = 0
               and NOT (b.CPperiodo = #MesActual.CPperiodo# and b.CPmes = #MesActual.CPmes#)
        </cfquery>
        <cfif ConsideraMesActual>
        	<cfset CantMese = rsCantidadMeses.Recordcount + 1>
        <cfelse>
        	<cfif rsCantidadMeses.Recordcount EQ 0>
            	<cfset CantMese = 1>
            <cfelse>
            	<cfset CantMese = rsCantidadMeses.Recordcount>
            </cfif>
        </cfif>

        <cfquery datasource="#session.DSN#">
        	update #EmpleadosRenta#
            set Rentencion = coalesce((select round(((#EmpleadosRenta#.MontoBruto - a.DIRinf * #CantMese# ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo * #CantMese#,2)
													from EImpuestoRenta b
                                                    	inner join DImpuestoRenta a
                                                        	on a.EIRid = b.EIRid
													where b.IRcodigo = '#arguments.IRcodigo#'
														and b.EIRestado > 0
														and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
														and round(#EmpleadosRenta#.MontoBruto,2) >= round(a.DIRinf * #CantMese#,2)
														and round(#EmpleadosRenta#.MontoBruto,2) <= round(a.DIRsup * #CantMese#,2)), 0.00)
			,Subsidio = coalesce((select round(((#EmpleadosRenta#.MontoBruto - a.DIRinf * #CantMese# ) * (a.DIRporcentaje / 100)) + a.DIRmontofijo * #CantMese#,2)
													from ImpuestoRenta c
                                                    	inner join EImpuestoRenta b
                                                        	on b.IRcodigo = c.IRcodigo
                                                    	inner join DImpuestoRenta a
                                                        	on a.EIRid = b.EIRid
													where c.IRcodigoPadre = '#arguments.IRcodigo#'
														and b.EIRestado > 0
														and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#"> between EIRdesde and EIRhasta
														and round(#EmpleadosRenta#.MontoBruto,2) >= round(a.DIRinf * #CantMese#,2)
														and round(#EmpleadosRenta#.MontoBruto,2) <= round(a.DIRsup * #CantMese#,2)), 0.00)
        </cfquery>
         <cfquery datasource="#session.DSN#">
         	update SalarioEmpleado
            	set SErenta       = (select Rentencion- Subsidio - RentaCobrada  from #EmpleadosRenta# where DEid = SalarioEmpleado.DEid)
             where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
         </cfquery>
	</cffunction>

    <!---ljimenez renta en nomina (4)--->
   	<cffunction name="fnCalculoRentaMetodo4" access="public">
    	 <cfargument name="RCNid"    type="numeric" required="yes">
         <cfargument name="IRcodigo" type="string"  required="yes">
         <cfargument name="RChasta"  type="date"    required="yes">
         <cfargument name="Tcodigo"  type="string"    required="yes">

         <cfargument name="Ecodigo"  type="numeric" required="no">
         <cfargument name="conexion" type="string" 	required="no">

        <cfif NOT isdefined('Arguments.Ecodigo') OR NOT LEN(TRIM(Arguments.Ecodigo))>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif NOT isdefined('Arguments.conexion') OR NOT LEN(TRIM(Arguments.conexion))>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>



 			<!---Calculo de Renta por tipo 1= Por Mes (Proyectando por cada Calendario)--->
            <!--- SE VERIFICA PARAMETRO PARA CALCULO DE RENTA MANUAL SI NO ES MANUEL SIGUE EL CALCULO NORMAL --->
            <cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#" ecodigo="#Arguments.Ecodigo#" pvalor="1090" default="" returnvariable="RentaManual"/>
            <!--- Se deducen del devengado total a proyectar las cargas del empleado --->
            <!--- que esten marcadas como:  Disminuyen el monto imponible de Renta --->
            <!--- Se suman a esto las cargas deducibles de renta de otras nominas del mes --->
            <!--- Ejemplo. Planes de Pension Voluntaria --->

            <cfquery name="rsDatosRenta" datasource="#arguments.conexion#">
                select coalesce(IRfactormeses,1) as IRfactormeses, coalesce(IRCreditoAntes, 0) as IRCreditoAntes
                from ImpuestoRenta
                where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
            </cfquery>


            <!--- ljimenez se verifica el factor de meses de la tabla de renta
            para el caso de mexico se utiliza una tabla de comportamiento mensual --->
            <!---<cfif rsDatosRenta.IRfactormeses eq 1>	--->
            <cf_dbtemp name="EmpleadosRenta" returnvariable="EmpleadosRenta" datasource="#session.DSN#">
                <cf_dbtempcol name="DEid" 					type="numeric"			mandatory="no">
                <cf_dbtempcol name="ingreso" 				type="datetime" 		mandatory="no">
                <cf_dbtempcol name="meses_periodo"			type="int" 				mandatory="no">
                <cf_dbtempcol name="SEdevengado" 			type="money" 			mandatory="no">
                <cf_dbtempcol name="SEincidencias" 			type="money" 			mandatory="no">

                <cf_dbtempcol name="salMensual" 	 		type="money" 			mandatory="no">	<!--- Salario  Mensual --->				<!---H--->
                <cf_dbtempcol name="salRecPeriodo" 			type="money" 			mandatory="no">	<!--- Salario Rec Según Periodo --->	<!---K--->

                <cf_dbtempcol name="incRecProyect" 			type="money" 			mandatory="no">	<!--- Incidenc Recib Proyec --->		<!---M--->
                <cf_dbtempcol name="incidNoProyect" 		type="money" 			mandatory="no">	<!--- Inciden No Proyect --->			<!---R--->

                <cf_dbtempcol name="totalSalRent" 			type="money" 			mandatory="no">	<!--- Total Salarios --->				<!---V--->
                <cf_dbtempcol name="rentaMens" 				type="money" 			mandatory="no">	<!--- Renta  Mensual --->				<!---W--->
                <cf_dbtempcol name="subsidioMens" 			type="money" 			mandatory="no">	<!--- Subsidio Mensual --->				<!---X--->
                <cf_dbtempcol name="rentaReal" 				type="money" 			mandatory="no">	<!--- Renta Real--->					<!---Y--->
                <cf_dbtempcol name="rentaDiaria" 			type="money" 			mandatory="no">	<!--- Renta Diaria--->					<!---Z--->

                <cf_dbtempcol name="retencion" 				type="money" 			mandatory="no">	<!--- Retencion--->						<!---AD--->
                <cf_dbtempcol name="retaRealCorte" 			type="money" 			mandatory="no">	<!--- Renta Real al Corte--->			<!---AE--->

                <cf_dbtempcol name="TLimInfAnt" 			type="money" 			mandatory="no"> <!--- Datos tabla de renta--->
                <cf_dbtempcol name="TLimSupAnt" 			type="money" 			mandatory="no">
                <cf_dbtempcol name="TMontoAnt" 				type="money" 			mandatory="no">
                <cf_dbtempcol name="TporcentajeAnt" 		type="money" 			mandatory="no">
                <cf_dbtempcol name="TLimSubInf" 			type="money" 			mandatory="no"> <!--- Datos tabla de subsidio--->
                <cf_dbtempcol name="TLimSubSup" 			type="money" 			mandatory="no">
                <cf_dbtempcol name="TMontoSub" 				type="money" 			mandatory="no">
            </cf_dbtemp>

            <cf_dbtemp name="ExcepcionesRenta" returnvariable="ExcepcionesRenta" datasource="#session.DSN#">
                <cf_dbtempcol name="RCNid" 		type="numeric" 	mandatory="no">
                <cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="no">
                <cf_dbtempcol name="SalarioExo" type="money" 	mandatory="no">
                <cf_dbtempcol name="Proyectado" type="money" 	mandatory="no">
            </cf_dbtemp>

            <cf_dbtemp name="TRAAdaptada1" returnvariable="TRentaAdaptadaAnterior" datasource="#session.DSN#">
                <cf_dbtempcol name="DIRid" 			type="numeric" 	mandatory="no">
                <cf_dbtempcol name="LimInf" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="LimSup" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="MontoFijo" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="Porcentaje" 	type="money" 	mandatory="no">
            </cf_dbtemp>

            <cf_dbtemp name="TSubsidio" returnvariable="TableSubsidio" datasource="#session.DSN#">
                <cf_dbtempcol name="DIRid" 			type="numeric" 	mandatory="no">
                <cf_dbtempcol name="LimInf" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="LimSup" 		type="money" 	mandatory="no">
                <cf_dbtempcol name="MontoFijo" 		type="money" 	mandatory="no">
            </cf_dbtemp>




                    <!--- se incluye SEdevengado y SEIncidencias en 0, por si acaso no se llena 4-3-2010 --->
                    <cfquery datasource="#session.DSN#">
                        insert into #EmpleadosRenta# (DEid, ingreso, meses_periodo,SEdevengado, SEincidencias)
                        select DEid, (select min(LTdesde) from LineaTiempo b where a.DEid = b.DEid), 0,0,0
                            from SalarioEmpleado a
                            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            <cfif isdefined('arguments.DEid')> and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                    </cfquery>



                    <!--- fecha de inicio de tabla de renta anual vigente --->
                    <cfquery datasource="#session.DSN#" name="Tabla">
                        select EIRdesde
                            from EImpuestoRenta a, RCalculoNomina b
                            where IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
                                and EIRestado = 1
                                and (RCdesde between EIRdesde and EIRhasta
                                   or RChasta between EIRdesde and EIRhasta )
                                and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                    </cfquery>

                    <cfset FechaTabla = Tabla.EIRdesde>

                    <!---Optiene la tabla de renta --->
                    <cfquery datasource="#session.DSN#">
                        Insert into #TRentaAdaptadaAnterior# (DIRid,LimInf,LimSup,MontoFijo,Porcentaje)
                            select  b.DIRid ,b.DIRinf ,b.DIRsup ,b.DIRmontofijo ,b.DIRporcentaje
                                from EImpuestoRenta a
                                    inner join DImpuestoRenta b
                                        on b.EIRid = a.EIRid
                                where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.IRcodigo#">
                                and a.EIRestado = 1
                                and a.EIRdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(Tabla.EIRdesde,'dd/mm/yyyy')#">
                                order by b.DIRinf
                    </cfquery>


                    <!---Obtiene el codigo de la tabla de subsidio--->
                    <cfquery name="rsIR" datasource="#session.DSN#">
                        select IRcodigo
                        from ImpuestoRenta
                        where IRcodigoPadre=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.IRcodigo#">
                    </cfquery>

                    <cfif rsIR.RecordCount EQ 0>
                        <cfthrow detail="Error. Debe definirse la tabla de Subsidios.">
                    </cfif>
                    <cfif rsIR.RecordCount GT 1>
                        <cfthrow detail="Error. Existen varias tablas de Subsidio, debe existir solo una.">
                    </cfif>

                    <!---Obtiene la tabla de renta --->
                    <cfquery datasource="#session.DSN#">
                        Insert into #TableSubsidio# (DIRid,LimInf,LimSup,MontoFijo)
                            select b.DIRid ,b.DIRinf ,b.DIRsup ,b.DIRmontofijo
                                from EImpuestoRenta a
                                    inner join DImpuestoRenta b
                                        on b.EIRid = a.EIRid
                                where a.IRcodigo = '#rsIR.IRcodigo#'
                                and a.EIRestado = 1
                                and a.EIRdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateformat(Tabla.EIRdesde,'dd/mm/yyyy')#">
                                order by b.DIRinf
                    </cfquery>



                    <!---"Salario Men Referencia Max(PEsalario)" --limpiar query --->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta# set
                        salMensual =  (select coalesce(sum(PEmontores),0)
                                    from RCalculoNomina a, PagosEmpleado c,CalendarioPagos d
                                        where a.RCNid=d.CPid
                                        and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
                                        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                        and a.RCNid=c.RCNid
                                        and c.PEtiporeg = 0
                                        and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                        and c.DEid = #EmpleadosRenta#.DEid
                                        and c.PEdesde = (select Max(PEdesde)
                                                        from RCalculoNomina a, PagosEmpleado c,CalendarioPagos d
                                                            where a.RCNid=d.CPid
                                                            and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
                                                            and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                                            and a.RCNid=c.RCNid
                                                            and c.PEtiporeg = 0
                                                            and c.DEid = #EmpleadosRenta#.DEid
                                                            and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">)
                                        )
                    </cfquery>

                    <!--- <cf_dumptable var="#EmpleadosRenta#" abort="false"> --->


                    <!---"En el caso de las Nominas Especiales, el SalMensual viene en Cero de la Consulta Anterior pues no hay informacion en PagosEmpleado
                          entonces, en este tipo de situaciones utilizaremos el Salario del Empleado al momento de la Relacion de Calculo en la Linea del Tiempo
                          Siempre y cuando el vsalor se haya cargado en Cero.
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta# set
                        salMensual =  (select coalesce(max(LTsalario),0)
                                       from LineaTiempo a, RCalculoNomina b
                                       Where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                       and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                       and #EmpleadosRenta#.DEid=a.DEid
                                       and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                       and b.RCdesde between a.LTdesde and a.LThasta)
                        Where salMensual <= 0
                   </cfquery> --->


                    <!---"Salario Recibida Según Periodo"--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta# set salRecPeriodo =  salMensual
                    </cfquery>

                    <!--- "Incidencidencias Recibidas Proyectadas"(M) Salario Incidencias para la nomina actual--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set incRecProyect = (
                                    Select coalesce(sum(ICmontores),0)
                                     from RCalculoNomina a,
                                          CalendarioPagos b,
                                          IncidenciasCalculo c,
                                          CIncidentes d
                                     where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                     and a.RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RCNid#">
                                     and a.RCNid = b.CPid
                                     and c.RCNid = a.RCNid
                                     and c.DEid = #EmpleadosRenta#.DEid
                                     and c.CIid = d.CIid
                                     and d.CInorenta = 0
                                     and isnull(d.CIart142,0) = 0
                                     and d.CInopryrenta = 0 <!---se proyecta--->
                                     )
                    </cfquery>

                    <!--- "Incidencidencias Recibidas NO Proyectadas" Salario Incidencias para la nomina actual (R)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set incidNoProyect = (
                                    Select coalesce(sum(ICmontores),0)
                                     from RCalculoNomina a,
                                          CalendarioPagos b,
                                          IncidenciasCalculo c,
                                          CIncidentes d
                                     where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                     and a.RCNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RCNid#">
                                     and a.RCNid = b.CPid
                                     and c.RCNid = a.RCNid
                                     and c.DEid = #EmpleadosRenta#.DEid
                                     and c.CIid = d.CIid
                                     and d.CInorenta = 0
                                     and isnull(d.CIart142,0) = 0
                                     and d.CInopryrenta = 1 <!---NO se proyecta--->
                                     )
                    </cfquery>

                    <!---Total de Salarios, salario referencia para la renta =+K+U+L+Q+R+M  (V)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set totalSalRent = 	salRecPeriodo + incidNoProyect	+ incRecProyect
                    </cfquery>



                    <!---Poner limites segun la tabla de renta--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set TLimInfAnt = ( select LimInf from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                            ,TLimSupAnt = ( select LimSup from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                            ,TMontoAnt	 = ( select MontoFijo from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                            ,TporcentajeAnt = ( select Porcentaje from #TRentaAdaptadaAnterior# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    </cfquery>

                    <!---Poner limites segun la tabla de subsidios--->
                    <cfif isdefined('Arguments.RCNid')> <!---SML Validacion para que no entre a la tabla de subsidio--->
            				<cfquery name="rsValNominaA" datasource="#session.DSN#">
            					select CPtipo as TNomina from CalendarioPagos
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
									and CPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.RCNid#">
            				</cfquery>
        			</cfif>

                    <cfif isdefined("rsValNominaA") and rsValNominaA.TNomina EQ 0>
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set TLimSubInf = ( select LimInf from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                            ,TLimSubSup = ( select LimSup from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                            ,TMontoSub	 = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    </cfquery>
                    </cfif>

                    <!--- Renta  Mensual --->				<!---(W)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set rentaMens = ((totalSalRent - TLimInfAnt) * (TporcentajeAnt/100)) + TMontoAnt
                    </cfquery>
                    
                    <!--- Subsidio Mensual --->				<!---(X)--->
                    <cfif isdefined("rsValNominaA") and rsValNominaA.TNomina EQ 0>
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set subsidioMens = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
                    </cfquery>
                    </cfif>

                    <!--- Renta Real--->					<!---(Y)--->

                    <cfif isdefined("rsValNominaA") and rsValNominaA.TNomina EQ 0>
                        <cfquery datasource="#session.DSN#">
                            update #EmpleadosRenta# set rentaReal = rentaMens - subsidioMens
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="#session.DSN#">
                            update #EmpleadosRenta# set rentaReal = rentaMens
                        </cfquery>
                    </cfif>


                    <!--- Renta Diaria--->					<!---(Z)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#  set rentaDiaria = rentaReal
                    </cfquery>


                    <!--- Sacamos la renta por deducciones retenida de las nominas historicas para el mes periodo en que esta la nomina actual--->

                    <!---Parametro RH de subsidio salario--->
                    <cfquery datasource="#arguments.conexion#" name="rsDeduccion">
                        select Pvalor as TDid,Pdescripcion  from RHParametros where Pcodigo = 2033 and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                    </cfquery>
                    <cfif NOT rsDeduccion.RecordCount OR NOT LEN(TRIM(rsDeduccion.TDid))>
                    	<cfthrow message="Error en configuración, no se ha definido la deducción para subsidio de salario">
                    </cfif>


                    <!--- Renta Real al Corte--->			<!---(AE)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set retaRealCorte	= round(rentaDiaria,2)
                    </cfquery>

                    <!--- Retencion--->						<!---(AD)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set retencion	= retaRealCorte
                    </cfquery>


                    <!--- Retencion--->						<!---(AD)--->
                    <cfquery datasource="#session.DSN#">
                        update #EmpleadosRenta#
                        set retencion	= rentaMens
                        where retencion < 0
                    </cfquery>

                    <!---<cfquery name= "Prueba" datasource="#session.DSN#">
                    	select * from #EmpleadosRenta#
                    </cfquery>

                    <cf_dump var ="#Prueba#">  --->
                    <!---Fin de calculos en la tabla temporal--->


                    <!---.................................Actualizacion de tablas del sistema..............................--->

                    <!---Salarios acumulados (L)--->
                    <cfquery datasource="#arguments.conexion#">
                        update SalarioEmpleado
                        set SEacumulado = (select totalSalRent
                                        from #EmpleadosRenta#
                                        where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                        where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            and SalarioEmpleado.SEcalculado = 0
                            <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                    </cfquery>

                    <!---Salarios proyectados (N)--->
                    <cfquery datasource="#arguments.conexion#">
                        update SalarioEmpleado
                        set SEproyectado =(select totalSalRent
                                            from #EmpleadosRenta#
                                            where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                    </cfquery>

                    <!---Renta proyectada, "Renta Real al Corte"  (AD)--->
                    <cfquery datasource="#arguments.conexion#">
                        update SalarioEmpleado
                        set SERentaT =(select case when retaRealCorte > 0 then retaRealCorte else 0 end
                                            from #EmpleadosRenta#
                                            where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                    </cfquery>

                    <!---Renta  (Retencion (AE))--->
                    <cfquery datasource="#arguments.conexion#">
                        update SalarioEmpleado
                        set SErenta =(select case when retencion > 0 then retencion else 0 end
                                            from #EmpleadosRenta#
                                            where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                    </cfquery>


                    <!---
                    <!---................................Pago de la Renta usando deducciones............................ --->

                    <!---Deduccion de subsidio al salario de las nominas anteriores del periodo--->
                    <cfinvoke component="RHParametros" method="get" datasource="#Arguments.conexion#"
                        ecodigo="#Arguments.Ecodigo#" pvalor="2033" default="0" returnvariable="vCIsubc"/>

                    <cfquery datasource="#arguments.conexion#" name="rsEmpSub">
                            select retencion as SErenta, DEid
                            from #EmpleadosRenta#
                            where coalesce(retencion, 0.00) < 0.00
                            <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
                    </cfquery>

                    <cfif #vCIsubc# EQ 0>
                        <cfthrow detail="Error no existe concepto de pago asociado al subsidio del salario Parametros RH -> Legislaci&oacute;n">
                    <cfelse>

                        <!---Parametro RH de subsidio salario--->
                        <cfquery datasource="#arguments.conexion#" name="rsDeduccion">
                        select Pvalor as TDid,Pdescripcion  from RHParametros where Pcodigo = 2033 and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                        </cfquery>
                        <!---Deduccion asociada al parametro--->
                        <cfquery datasource="#arguments.conexion#" name="rsTDeduccion">
                        select * from TDeduccion where TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeduccion.TDid#">  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                        </cfquery>
                        <!---Calendario de Pago--->
                        <cfquery name="rsCalendarioPago" datasource="#arguments.conexion#">
                            select
                                a.CPcodigo,
                                a.CPid,
                                rtrim(a.Tcodigo) as Tcodigo,
                                a.CPdesde,
                                a.CPhasta,
                                CPtipo
                            from CalendarioPagos a
                            where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                            and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                        </cfquery>
                        <!---Tipos de Nomina--->
                        <cfquery name="rsTiposNomina" datasource="#Session.DSN#">
                            select a.Tcodigo, a.Tdescripcion
                            from TiposNomina a
                            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
                            and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsCalendarioPago.Tcodigo#">
                            order by a.Tdescripcion
                        </cfquery>

                        <cfset renta = rsEmpSub.SErenta>

                        <cfset descripcion= rsTiposNomina.Tdescripcion & ', ' & rsDeduccion.Pdescripcion>
                        <cfloop query="rsEmpSub">

                            <cfquery datasource="#arguments.conexion#" name="rsDeduccionesEmpleado">
                            Insert into DeduccionesEmpleado(
                                DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechadoc,
                                Dfechaini, Dfechafin,
                                Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo,
                                Ulocalizacion, Dcontrolsaldo, Dactivo, Dreferencia, BMUsucodigo, Dobservacion,  IRcodigo,  Mcodigo,
                                ts_rversion, DidPadre, Dinicio)
                                 values(#rsEmpSub.DEid#, #arguments.Ecodigo#, #rsTDeduccion.SNcodigo#,#rsTDeduccion.TDid#, '#descripcion#', 1, #rsEmpSub.SErenta#, null,
                                <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">,<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">,
                                #rsEmpSub.SErenta#,  0,   0,    0,  1, null,
                                '00',0, 0, '#trim(rsCalendarioPago.CPcodigo)#', null,null,null,null,
                                null,null,0)
                                <cf_dbidentity1 datasource="#arguments.conexion#">
                            </cfquery>
                            <cf_dbidentity2 datasource="#arguments.conexion#" name="rsDeduccionesEmpleado">

                            <cfif isdefined("rsDeduccionesEmpleado")>
                                <cfset Did = rsDeduccionesEmpleado.identity>
                                <cfquery datasource="#arguments.conexion#" name="rsInsert">
                                Insert into DeduccionesCalculo(
                                    RCNid, DEid,Did, DCvalor, DCinteres, DCbatch,
                                    DCmontoant, DCcalculo, Mcodigo, DCmontoorigen, BMUsucodigo, CIid)
                                values( #arguments.RCNid#, #rsEmpSub.DEid#, #Did#, #rsEmpSub.SErenta#,0, null,
                                    0, 0, null, null,  null,  null)
                                </cfquery>

                                <cfquery datasource="#arguments.conexion#" name="rsUpdate">
                                    update SalarioEmpleado set SEdeducciones = SEdeducciones + #rsEmpSub.SErenta#
                                        where DEid = #rsEmpSub.DEid#
                                        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                </cfquery>
                            </cfif>
                        </cfloop>
                    </cfif>
					--->

                    <!---<cf_dumptable var="#EmpleadosRenta#">--->

	</cffunction>

    <cffunction  name="addConceptoSub" access="private" hint="Funcion para agregar concepto de subsidio">
        <cfargument name="conexion" type="string"  required="yes">
        <cfargument name="RCNid"    type="numeric" required="yes">
        <cfargument name="DEid"     type="numeric" required="yes">
        <cfargument name="RCdesde"  type="date"    required="yes">
        <cfargument name="RChasta"  type="date"    required="yes">
        

        <cfquery datasource="#arguments.conexion#" name="rsRHParametros">
            select  Pvalor as TDid, Pdescripcion  
            from  RHParametros 
            where 
                Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2033"> 
            and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        
        <cfquery name="rsInc" datasource="#arguments.conexion#">
            select * from CIncidentes
            where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHParametros.TDid#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        
        <cfquery name="rsUltimaAlta" datasource="#arguments.conexion#">
                        select 
                            DLfvigencia
                        from
                            DLaboralesEmpleado dle
                        inner join RHTipoAccion ta
                            on dle.RHTid = ta.RHTid
                        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
                        and ta.RHTcomportam = 1
                        and dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                        order by DLfvigencia desc
        </cfquery>

         <cfset difDays = 0>
         <cfif DateDiff('d',arguments.RCdesde,rsUltimaAlta.DLfvigencia) gte 0 and DateDiff('d',arguments.RChasta,rsUltimaAlta.DLfvigencia) lte 0>
            <cfset difDays = DateDiff('d',arguments.RCdesde,rsUltimaAlta.DLfvigencia)>
        </cfif>

         <cfquery datasource="#arguments.conexion#" name="rsUltAc">
			 select top 1 cf.CFid,lt.RHJid from LineaTiempo lt
					 inner join RHPlazas p
					 on lt.RHPid = p.RHPid
					 and lt.Ecodigo = p.Ecodigo
					 inner join CFuncional cf
					 on cf.CFid=coalesce(p.CFidconta, p.CFid)
					 where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					 order by LTdesde desc
		 </cfquery>
        
        <cfquery datasource="#arguments.conexion#">
                INSERT INTO IncidenciasCalculo
                       (RCNid,DEid,CIid,ICfecha,ICvalor,ICfechasis,Usucodigo,Ulocalizacion
                        ,ICcalculo,ICmontoant,ICmontores,CFid,RHJid,CPmes,CPperiodo,ICespecie)
                         VALUES
                               ( #arguments.RCNid#
                                ,#arguments.DEid#
                                ,#rsInc.CIid#
                                ,'#LSDateFormat(DateAdd("d",difDays,arguments.RCdesde),"YYYY-MM-dd")#'
                                ,0.01	
                                ,'#LSDateFormat(DateAdd("d",difDays,arguments.RCdesde),"YYYY-MM-dd")#'
                                ,#session.Usucodigo#
                                ,'00'
                                ,0
                                ,0.00
                                ,0.01
                                ,#rsUltAc.CFid#
                                ,#rsUltAc.RHJid#
                                ,#month(arguments.RChasta)#
                                ,#Year(arguments.RChasta)#
                                ,0)
            </cfquery>

            <cfquery datasource="#arguments.conexion#" name="rsUpdate">
                update SalarioEmpleado set SEincidencias= SEincidencias + 0.01
                where DEid = #arguments.DEid#
                and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
            </cfquery>

            <cfquery datasource="#arguments.conexion#">
                update RHSubsidio set RHSvalor = 0.01
                where RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and DEid=#arguments.DEid#
                and RHSvalor=0
            </cfquery>

    </cffunction>
    <cffunction  name="esFinMes" access="private" hint="Funcion para validar si es el ultimo Calendario de pago del mes">
        <cfargument name="conexion"  type="string"  required="yes">
        <cfargument name="RCNid"     type="numeric" required="yes">
        <cfargument name="Tcodigo"   type="string"  required="yes">
        <cfargument name="CPperiodo" type="string"  required="yes">
        <cfargument name="CPmes"     type="string"  required="yes">
        
        <cfquery name="rsCalendarioPago" datasource="#arguments.conexion#">
           select top 1 CPid  
                from CalendarioPagos 
                where CPperiodo=#arguments.CPperiodo# and CPmes=#arguments.CPmes# and Tcodigo=0#arguments.Tcodigo#
                and MONTH(CPfpago) = #arguments.CPmes# and Ecodigo = #session.Ecodigo#
                order by CPfpago desc
        </cfquery>

        <cfreturn rsCalendarioPago.CPid eq arguments.RCNid ? 1:0>
    </cffunction>

    <cffunction  name="ajusteMensualSubsidio" access="private" hint="Agrega ajuste mensual de subsidio">
        <cfargument name="RCNid"      type="numeric" required="yes">
        <cfargument name="DEid"       type="numeric" default='0'>
        <cfargument name="Tcodigo"    type="string"  required="yes">
        <cfargument name="CPperiodo"  type="string"  required="yes">
        <cfargument name="CPmes"      type="string"  required="yes">
        <cfargument name="IRcodigo"   type="string"  required="yes">
        <cfargument name="fechaDesde" type="date">

        <cf_dbtemp name="EmpleadosSubsidio" returnvariable="EmpleadosSubsidio" datasource="#session.DSN#">
            <cf_dbtempcol name="DEid" 		             type="numeric" mandatory="no">
            <cf_dbtempcol name="totalGravable"           type="money"   mandatory="no">    
            <cf_dbtempcol name="totalSubsidioTabla"      type="money"   mandatory="no"> <!---Tabla Subsidio Mensual--->
            <cf_dbtempcol name="totalISRDetm"            type="money"   mandatory="no"> <!---Tabla ISR Mensual--->
            <cf_dbtempcol name="totalISRM"               type="money"   mandatory="no"> <!---Si corresponde ISR Mensual--->
            <cf_dbtempcol name="totalSubsidioEntregado"  type="money"   mandatory="no"> <!---Si corresponde Subsidio Mensual--->
            <cf_dbtempcol name="totalSubsidioCausado"    type="money"   mandatory="no"> <!--- Sumatoria del Subsidio Tabla que le correspondio en nominas anteriores--->
            <cf_dbtempcol name="totalSubsidioPagado"     type="money"   mandatory="no"> <!--- Sumatoria del Subsidio Pagado en nominas anteriores--->
            <cf_dbtempcol name="totalISRDeterminado"     type="money"   mandatory="no"> <!--- Sumatoria del ISR Tabla que le correspondio en nominas anteriores--->
            <cf_dbtempcol name="totalISRAjustado"        type="money"   mandatory="no"> <!--- Sumatoria del ISR Retenido en nominas anteriores--->
        </cf_dbtemp>

        <cfset fechaInicio = getfechaIni(CPperiodo=#CPperiodo#,CPmes=#CPmes#,Tcodigo=#Tcodigo#)>
        <cfset fechaFin = getfechaFin(CPperiodo=#CPperiodo#,CPmes=#CPmes#,Tcodigo=#Tcodigo#)>
        
         <cfquery name="rsRCalculoNomina" datasource="#session.DSN#">
            select RCNid from RCalculoNomina where Tcodigo=#Tcodigo# and RCdesde >='#fechaInicio#'  and RChasta <='#fechaFin#'
	        union
            select RCNid from HRCalculoNomina where Tcodigo=#Tcodigo# and RCdesde >= '#fechaInicio#'  and RChasta <='#fechaFin#'
         </cfquery>

        <cfset varRCNid = ValueList(rsRCalculoNomina.RCNid)>

        <!--- SML 05122022 A peticion de Javier Espinosa se obtendra el ISR Determinado de las nominas diferentes a las normales de la tabla de HSalarioEmpleado--->
        <cfquery name="rsRCalculoNominaEsp" datasource="#session.DSN#">
            select CPid 
            from CalendarioPagos
            where Ecodigo = #session.Ecodigo#
                and CPid in (#varRCNid#) 
                and CPtipo <> 0
        </cfquery>
        
        <cfif isdefined("rsRCalculoNominaEsp") and rsRCalculoNominaEsp.RecordCount GT 0>
            <cfset varRCNidEsp = ValueList(rsRCalculoNominaEsp.CPid)>
        </cfif>
        <!--- SML 05122022 Fin--->

         <cfquery name="rsSalarioEmpleado" datasource="#session.DSN#">
            insert into #EmpleadosSubsidio# (DEid,totalGravable)
            select DEid,sum(SEsalariobruto) as SEsalariobrutoM  from (
                select DEid,sum(SEsalariobruto) as SEsalariobruto from HSalarioEmpleado where RCNid in (#varRCNid#) and (SEsalariobruto+SEincidencias) > 0
                <cfif DEid neq 0> and DEid=#DEid# </cfif>
                and  DEid in (select DEid from SalarioEmpleado where RCNid in (#varRCNid#) and SEsalariobruto>0)  group by DEid
                union all
                select DEid,SEsalariobruto from SalarioEmpleado where RCNid in (#varRCNid#) <cfif DEid neq 0> and DEid=#DEid# </cfif> and SEsalariobruto>0
            ) tmpSalario group by DEid
        </cfquery>
              
        
        <cfquery name="rsInsideciasGravables" datasource="#session.DSN#">
          select DEid,sum(ICmontores) ICvalorM from (
            select a.DEid,a.RCNid,a.ICmontores from IncidenciasCalculo a inner join CIncidentes b on a.CIid=b.CIid
                                where a.RCNid in (#varRCNid#) /* and a.ICmontores >0 */ <cfif DEid neq 0> and DEid=#DEid# </cfif> and b.CInorenta=0 and CItimbrar=0
            union all
            select a.DEid,a.RCNid,a.ICmontores from HIncidenciasCalculo a inner join CIncidentes b on a.CIid=b.CIid
                                where a.RCNid in (#varRCNid#) /* and  a.ICmontores >0 */ <cfif DEid neq 0> and DEid=#DEid# </cfif> and b.CInorenta=0 and CItimbrar=0
            ) tmpIncidencia group by DEid
        </cfquery> 
     <!--- <cfdump  var="#rsInsideciasGravables#" abort> --->
        <cfif rsInsideciasGravables.RecordCount GT 0>
           <cfloop query="rsInsideciasGravables">
            <cfquery datasource="#session.DSN#">
                update #EmpleadosSubsidio# 
                set totalGravable += #rsInsideciasGravables.ICvalorM#
                where #EmpleadosSubsidio#.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsideciasGravables.DEid#">
            </cfquery>
           </cfloop> 
        </cfif>

        <cfquery name="rsEmpleadosSubsidio" datasource="#session.DSN#">
            select * from #EmpleadosSubsidio#
        </cfquery>
     
        <!---Obtiene el codigo de la tabla de subsidio--->
        <!--- <cfquery name="rsIR" datasource="#session.DSN#">
            select IRcodigo
            from ImpuestoRenta
            where IRcodigoPadre=<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.IRcodigo#">
        </cfquery> --->
        
        <!---Codigo de Tablas Subsidio Mensual --->
        <cfset subsidioCodigo = 'MXM02'>

        <cfloop query="rsEmpleadosSubsidio">
            <cfquery datasource="#session.DSN#">
                 update #EmpleadosSubsidio# 
                 set totalSubsidioTabla = coalesce((
                    select d.DIRmontofijo from DImpuestoRenta d
			        inner join EImpuestoRenta ei on d.EIRid=ei.EIRid
		            inner join ImpuestoRenta i on ei.IRcodigo=i.IRcodigo
			        where i.IRcodigo='#subsidioCodigo#' 
			        and  #totalGravable#>= d.DIRinf and #totalGravable#<=d.DIRsup
                    and  GETDATE() > ei.EIRdesde 
                    and  GETDATE() < ei.EIRhasta
                 ),0)
                 where #EmpleadosSubsidio#.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosSubsidio.DEid#">
            </cfquery>
        </cfloop>

        <cfloop query="rsEmpleadosSubsidio">
            <cfquery name="impRenta" datasource="#session.dsn#">
                select b.DIRid ,b.DIRinf ,b.DIRsup ,b.DIRmontofijo, b.DIRporcentaje
                from (
                    select top 1 EIRid from EImpuestoRenta
                    where IRcodigo = 'MXM01'
                        and EIRestado = 1
                        and EIRdesde <= getdate()
                        and EIRhasta >= getdate()
                    order by EIRdesde desc
                ) a
                inner join DImpuestoRenta b
                    on b.EIRid = a.EIRid
                where #totalGravable#>= b.DIRinf and #totalGravable#<=b.DIRsup
                order by b.DIRinf
            </cfquery>

            <cfquery datasource="#session.DSN#">
                update #EmpleadosSubsidio# 
                 set totalISRDetm = ((#totalGravable# - #impRenta.DIRinf#) * (#impRenta.DIRporcentaje# / 100)) + #impRenta.DIRmontofijo#
                 where #EmpleadosSubsidio#.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosSubsidio.DEid#">
            </cfquery>
        </cfloop>
        
        <cfloop query="rsEmpleadosSubsidio">
            <cfquery datasource="#session.DSN#">
                update #EmpleadosSubsidio# 
                 set totalSubsidioEntregado = case when (totalISRDetm - totalSubsidioTabla) < 0 then abs(totalISRDetm - totalSubsidioTabla) else 0 end,
                 totalISRM = case when (totalISRDetm - totalSubsidioTabla) > 0 then abs(totalISRDetm - totalSubsidioTabla) else 0 end
                 where #EmpleadosSubsidio#.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosSubsidio.DEid#">
            </cfquery>
        </cfloop>

        <cfloop query="rsEmpleadosSubsidio">
            <cfquery datasource="#session.DSN#">
                update #EmpleadosSubsidio# 
                 set totalSubsidioCausado = isnull((
                    select sum(RHSvalor) subCausado from(
                            select DEid,RCNid,RHSvalor from HRHSubsidio where RCNid in (#varRCNid#) and DEid=#rsEmpleadosSubsidio.DEid#
                            <!--- union
                            select DEid,RCNid,RHSvalor from RHSubsidio where RCNid in (#varRCNid#)and DEid=#rsEmpleadosSubsidio.DEid# --->
                        ) tmpSub group by DEid
                    ),0),
                    totalISRDeterminado = isnull((
                    select sum(ISRDeterminado) ISRDeterminado from(
                            select DEid,RCNid,ISRDeterminado from HRHSubsidio where RCNid in (#varRCNid#) and DEid=#rsEmpleadosSubsidio.DEid# <!---and RHSvalor > 0--->
                            <cfif isDefined("varRCNidEsp") and len(trim(varRCNidEsp)) GT 0>
                            union
                            select DEid, RCNid, SErenta from HSalarioEmpleado where RCNid in (#varRCNidEsp#) and DEid=#rsEmpleadosSubsidio.DEid#
                            </cfif>) tmpSub group by DEid
                    ),0),
                    totalISRAjustado = isnull((
                    select sum(ISRDeterminado) ISRDeterminado from(
                            select DEid,RCNid, (ISRDeterminado - RHSvalor) as ISRDeterminado from HRHSubsidio where RCNid in (#varRCNid#) and DEid=#rsEmpleadosSubsidio.DEid# and (ISRDeterminado - RHSvalor) > 0
                            <cfif isDefined("varRCNidEsp") and len(trim(varRCNidEsp)) GT 0>
                            union
                            select DEid, RCNid, SErenta from HSalarioEmpleado where RCNid in (#varRCNidEsp#) and DEid=#rsEmpleadosSubsidio.DEid#
                            </cfif>) tmpSub group by DEid
                    ),0),
                    totalSubsidioPagado = 0
                 where #EmpleadosSubsidio#.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleadosSubsidio.DEid#">
            </cfquery>
        </cfloop>

        <!--- Parametro de Deduccion Subsidio salario  --->
        <cfquery datasource="#session.DSN#" name="rsRHParametros">
            select  Pvalor as TDid, Pdescripcion  
            from  RHParametros 
            where 
               Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2033"> 
            and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <!--- Subsidio Pagado --->
        <cfquery name="rsSubCalculado" datasource="#session.DSN#">
            select sum(ICvalor) as SubCalculado,DEid from (
            select ICvalor,RCNid,DEid from HIncidenciasCalculo where RCNid in (#varRCNid#) <cfif DEid neq 0> and DEid=#DEid# </cfif> and CIid=#rsRHParametros.TDid#
                <!--- union
                select ICvalor,RCNid,DEid from IncidenciasCalculo where RCNid in (#varRCNid#) <cfif DEid neq 0> and DEid=#DEid# </cfif> and CIid=#rsRHParametros.TDid# --->
            ) TmpIns group by  DEid 
        </cfquery>
        
        <cfif rsSubCalculado.RecordCount GT 0>
           <cfloop query="rsSubCalculado"> 
            <cfquery datasource="#session.DSN#">
                update #EmpleadosSubsidio# 
                set totalSubsidioPagado = #rsSubCalculado.SubCalculado#
                where #EmpleadosSubsidio#.DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSubCalculado.DEid#">
            </cfquery>
           </cfloop>
        </cfif>

        <cfquery name="rsPeriodosMes" datasource="#session.DSN#">
            select COUNT(a.CPid) as PeriodosMes
	                            from CalendarioPagos a 
	                            inner join CalendarioPagos b on a.CPperiodo=b.CPperiodo
	                            where b.CPid=#RCNid# and a.Tcodigo=b.Tcodigo and month(a.CPfpago)=b.CPmes
        </cfquery>
        <cfset limiteSubCausado = (rsPeriodosMes.PeriodosMes-1) * 0.01>
        
        <cfquery name="rsEmpleadosSCT" datasource="#session.DSN#">
            select * from #EmpleadosSubsidio#
        </cfquery>
        <!---<cfdump var="#limiteSubCausado#">
        <cf_dump var="#rsEmpleadosSCT#">--->
        <cfloop query="rsEmpleadosSCT">
            <cfif (rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioPagado gte limiteSubCausado) 
                or (rsEmpleadosSCT.totalSubsidioTabla gte 0 and rsEmpleadosSCT.totalSubsidioTabla lt rsEmpleadosSCT.totalSubsidioCausado)>
                <!--- Registra ajuste a subsidio causado 107--->
                <cfset addConceptoDeduccionASC(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado = (rsEmpleadosSCT.totalSubsidioTabla eq 0) 
                                            ? rsEmpleadosSCT.totalSubsidioCausado 
                                            : (rsEmpleadosSCT.totalSubsidioCausado - rsEmpleadosSCT.totalSubsidioTabla),
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <cfif (rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioPagado gte limiteSubCausado) 
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla lt rsEmpleadosSCT.totalSubsidioCausado)>
                <!--- Registra ajuste subsidio para empleado 071 --->
                <cfset addConceptoDeduccionASPE(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado=rsEmpleadosSCT.totalSubsidioPagado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <cfif (rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioPagado gte limiteSubCausado) 
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla gt rsEmpleadosSCT.totalSubsidioCausado)
                and rsEmpleadosSCT.totalISRM EQ 0 and (rsEmpleadosSCT.totalSubsidioEntregado - rsEmpleadosSCT.totalSubsidioPagado) gt 0
                and rsEmpleadosSCT.totalGravable GT 0>               
                <!--- Registra ajuste subsidio para empleado 071 --->
                <cfset addConceptoDeduccionASPE(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado=(rsEmpleadosSCT.totalSubsidioEntregado - rsEmpleadosSCT.totalSubsidioPagado)*-1,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
                
            </cfif>

            <cfif (rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioPagado gte limiteSubCausado) 
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla gt rsEmpleadosSCT.totalSubsidioCausado)
                and rsEmpleadosSCT.totalISRM EQ 0 and (rsEmpleadosSCT.totalSubsidioEntregado - rsEmpleadosSCT.totalSubsidioPagado) lt 0>
                <!--- Registra ajuste subsidio para empleado 071 --->
                <cfset addConceptoDeduccionASPE(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado= rsEmpleadosSCT.totalSubsidioPagado - rsEmpleadosSCT.totalSubsidioEntregado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <cfif (rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioPagado gte limiteSubCausado) 
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla lt rsEmpleadosSCT.totalSubsidioCausado)>
                <!--- Registra Subsidio efectivamente entregado que no correspondia  008 --->
                <cfset addConceptoDeduccionSEENC(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado = (rsEmpleadosSCT.totalSubsidioTabla eq 0) 
                                            ? ((rsEmpleadosSCT.totalSubsidioPagado eq "") ? 0 : rsEmpleadosSCT.totalSubsidioPagado)
                                            : (rsEmpleadosSCT.totalSubsidioCausado - rsEmpleadosSCT.totalSubsidioTabla),
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde)>
            </cfif>
            
            <cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla lt rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalSubsidioEntregado gt 0>
                <!---Registra ajuste ISR Determinado  002--->
                <cfset addConceptoDeduccionAISRD(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado=rsEmpleadosSCT.totalISRDeterminado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <!---<cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla gt rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalISRM gt 0 and (rsEmpleadosSCT.totalISRM - rsEmpleadosSCT.totalISRAjustado) gt 0>
                <!---Registra ajuste ISR Determinado  002--->
                <cfset addConceptoDeduccionAISRD(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado = rsEmpleadosSCT.totalISRM - rsEmpleadosSCT.totalISRAjustado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>--->

            <cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or (rsEmpleadosSCT.totalSubsidioTabla gte 0 and rsEmpleadosSCT.totalSubsidioTabla lte rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalISRM gt 0 and (rsEmpleadosSCT.totalISRM - rsEmpleadosSCT.totalISRAjustado) lt 0>
                <!---Registra Reintegro de ISR pagado en exceso que no haya sido enterado al SAT-OTROS PAGOS  001--->
                <cfset addConceptoDeduccionREISR(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado = rsEmpleadosSCT.totalISRM - rsEmpleadosSCT.totalISRAjustado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or (rsEmpleadosSCT.totalSubsidioTabla gte 0 and rsEmpleadosSCT.totalSubsidioTabla gt rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalISRM gt 0 and (rsEmpleadosSCT.totalISRM - rsEmpleadosSCT.totalISRAjustado) lt 0>
                <!---Registra Reintegro de ISR pagado en exceso que no haya sido enterado al SAT-OTROS PAGOS  001--->
                <cfset addConceptoDeduccionREISR(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado = (rsEmpleadosSCT.totalISRM - rsEmpleadosSCT.totalISRAjustado) + rsEmpleadosSCT.totalSubsidioPagado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            
            <cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or(rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla lt rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalSubsidioEntregado gte 0>
                <!--- Registra ISR ajustado por subsidio 007--->
                <cfset addConceptoDeduccionISRAS(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    <!---totalSubsidioPagado=(rsEmpleadosSCT.totalISRAjustado eq "") ? 0 : rsEmpleadosSCT.totalISRAjustado,--->
                    totalSubsidioPagado =(rsEmpleadosSCT.totalSubsidioTabla eq 0) 
                                            ? rsEmpleadosSCT.totalSubsidioCausado 
                                            : (rsEmpleadosSCT.totalSubsidioCausado - rsEmpleadosSCT.totalSubsidioTabla),
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla gt rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalSubsidioEntregado gt 0 and rsEmpleadosSCT.totalSubsidioEntregado gt rsEmpleadosSCT.totalSubsidioPagado
                and rsEmpleadosSCT.totalISRAjustado GT 0>
                <!--- Registra ISR ajustado por subsidio 007--->
                <cfset addConceptoDeduccionISRAS(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado=(rsEmpleadosSCT.totalISRAjustado eq "") ? 0 : rsEmpleadosSCT.totalISRAjustado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

            <cfif ((rsEmpleadosSCT.totalSubsidioTabla eq 0 and rsEmpleadosSCT.totalSubsidioCausado gte limiteSubCausado)
                or (rsEmpleadosSCT.totalSubsidioTabla gt 0 and rsEmpleadosSCT.totalSubsidioTabla gt rsEmpleadosSCT.totalSubsidioCausado))
                and rsEmpleadosSCT.totalSubsidioEntregado gt 0 and rsEmpleadosSCT.totalSubsidioEntregado lt rsEmpleadosSCT.totalSubsidioPagado
                and rsEmpleadosSCT.totalISRAjustado GT 0>
                <!--- Registra ISR ajustado por subsidio 007--->
                <cfset addConceptoDeduccionISRAS(
                    RCNid=arguments.RCNid,
                    varRCNid=varRCNid,
                    totalSubsidioPagado=(rsEmpleadosSCT.totalISRAjustado eq "") ? 0 : rsEmpleadosSCT.totalISRAjustado,
                    DEid=rsEmpleadosSCT.DEid,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>

        </cfloop>
        <!---  Actualizar la Tabla SalarioEmpleado para poner Deducciones --->
        <cfquery datasource="#session.DSN#">
            update SalarioEmpleado set
                SEdeducciones = coalesce((
                    select sum(a.DCvalor)
                    from DeduccionesCalculo a
                    where a.DEid = SalarioEmpleado.DEid
                    and a.RCNid = SalarioEmpleado.RCNid
                    ),0.00)
            where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            and SalarioEmpleado.SEcalculado = 0
            <cfif DEid neq 0> and SalarioEmpleado.DEid =#DEid# </cfif>
            /* <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif> */
        </cfquery>

        <cfquery name="rsEmpleadosSubsidioR" datasource="#session.DSN#">
            select * from #EmpleadosSubsidio#
        </cfquery>
        <!--- <cf_dumpTable var="#EmpleadosSubsidio#"> --->
        <cfreturn rsEmpleadosSubsidioR>
    </cffunction>

    <cffunction  name="getfechaIni" access="private">
        <cfargument name="CPperiodo" required="true">
        <cfargument name="CPmes"     type="string"  required="yes">
        <cfargument name="Tcodigo"   required="true">
        <cfif CPmes eq '1'>
            <cfquery name="rsPrimerSemana" datasource="#session.DSN#">
                select  top 1 CPdesde 
                from CalendarioPagos where CPdesde > (select top 1 CPhasta from CalendarioPagos 
                                                                                            where YEAR(CPhasta)=(#CPperiodo#-1)
                                                                                            and Tcodigo=#Tcodigo#
                                                                                            and CPesUltimaSemana='1'
                                                                                            order by CPhasta desc)
                                                                                            order by CPdesde asc
                </cfquery>
                <cfif rsPrimerSemana.CPdesde neq ''>
                    <cfreturn rsPrimerSemana.CPdesde>
                <cfelse>
                    <cfquery name="rsDesde" datasource="#session.DSN#">
                        SELECT
                               DATEADD(yy, DATEDIFF(yy, 0, CONCAT('#CPperiodo#','0101')), 0) AS StartOfYear
                    </cfquery>
                    <cfreturn rsDesde.StartOfYear>
                </cfif> 
        <cfelse> 
            <cfquery name="rsDesde" datasource="#session.DSN#">
                select top 1 CPdesde from 
                             CalendarioPagos where month(CPfpago)=#CPmes# and CPperiodo=#CPperiodo# and Tcodigo=#Tcodigo# 
                             order by CPdesde asc
            </cfquery>
            <cfreturn rsDesde.CPdesde>
        </cfif>
    </cffunction>

    <cffunction  name="getfechaFin" access="private">
        <cfargument name="CPperiodo" required="true">
        <cfargument name="CPmes"     type="string"  required="yes">
        <cfargument name="Tcodigo"   required="true">

        <cfif CPmes eq '12'>
            <cfquery name="rsUltimaSemana" datasource="#session.DSN#">
                select top 1 CPhasta from CalendarioPagos where CPmes=#CPmes# and CPperiodo=#CPperiodo# and Tcodigo=#Tcodigo# and CPesUltimaSemana='1'
                 order by CPhasta desc 
            </cfquery>
            <cfif rsUltimaSemana.CPhasta neq "">
                <cfreturn rsUltimaSemana.CPhasta>
            <cfelse>
            <cfquery name="rsHasta" datasource="#session.DSN#">
				SELECT
   					DATEADD(yy, DATEDIFF(yy, 0, CONCAT('#CPperiodo#','0101')) + 1, -1) AS EndOfYear
			</cfquery>
            <cfreturn rsHasta.EndOfYear>
            </cfif>
        <cfelse>
            <cfquery name="rsHasta" datasource="#session.DSN#">
                select top 1 CPhasta from 
                             CalendarioPagos where Tcodigo = #Tcodigo# and CPmes = #CPmes# and month(CPfpago)=#CPmes# and CPperiodo=#CPperiodo#
				             order by CPhasta desc
            </cfquery>
            <cfreturn rsHasta.CPhasta>
        </cfif>
    </cffunction>

    <cffunction  name="addConceptoDeduccionASC" access="private" hint="Se agrega el ajuste mensual de subsidio como deduccion al calculo">
        <cfargument name="RCNid"               type="numeric" required="yes">
        <cfargument name="varRCNid"            type="string"  required="yes">
        <cfargument name="DEid"                type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado" type="numeric" required="yes">
        <cfargument name="fechaDesde"          type="date">

        <cfquery name="rsTDeduccion" datasource="#session.DSN#">
            select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="107">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    
        <cfif rsTDeduccion.TDid neq ''>
            
            <cfquery datasource="#session.DSN#">
                delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did = (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#')
                delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#'
            </cfquery>

            <cfquery datasource="#session.DSN#">
                insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                          values(
                                 #DEid#,
                                 #session.Ecodigo#,
                                 #rsTDeduccion.SNcodigo#,
                                 #rsTDeduccion.TDid#,
                                 '#rsTDeduccion.TDdescripcion#',
                                 CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                 1,
                                 #totalSubsidioPagado#,
                                 '#fechaDesde#',
                                 #totalSubsidioPagado#,
                                 0,
                                 0,
                                 0,
                                 1,
                                 0,
                                 0
                          )

                insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                     values(#RCNid#,
                            #DEid#,
                            (SELECT @@IDENTITY), 
                            #totalSubsidioPagado#,
                            0,
                            0,
                            0)
            </cfquery>
                    
            <cfelse>
                <cfthrow detail="Error. Debe definirse el tipo de Deduccion 107 Ajuste al Subsidio Causado">
        </cfif>
    </cffunction>

    <cffunction  name="addConceptoDeduccionAISRD">
        <cfargument name="RCNid"                    type="numeric" required="yes">
        <cfargument name="varRCNid"                 type="string"  required="yes">
        <cfargument name="DEid"                     type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado" type="numeric" required="yes">
        <cfargument name="fechaDesde"               type="date">

        <cfquery name="rsTDeduccion" datasource="#session.DSN#">
            select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="002">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>

        <cfif rsTDeduccion.TDid neq ''>
            
            <cfquery datasource="#session.DSN#">
                delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did = (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#')
                delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#'
            </cfquery>

            <!--- <cfquery name="rsTotalISRD" datasource="#session.DSN#">
                select sum(ISRDeterminado) ISRD from(
                            select DEid,RCNid,ISRDeterminado from HRHSubsidio where RCNid in (#varRCNid#) and DEid=#DEid#
                            union
                            select DEid,RCNid,ISRDeterminado from RHSubsidio where RCNid in (#varRCNid#)and DEid=#DEid#) tmpSub group by DEid
            </cfquery>     --->
            <cfquery datasource="#session.DSN#">
                insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                          values(
                                 #DEid#,
                                 #session.Ecodigo#,
                                 #rsTDeduccion.SNcodigo#,
                                 #rsTDeduccion.TDid#,
                                 '#rsTDeduccion.TDdescripcion#',
                                 CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                 1,
                                 #totalSubsidioPagado#,
                                 '#fechaDesde#',
                                 #totalSubsidioPagado#,
                                 0,
                                 0,
                                 0,
                                 1,
                                 0,
                                 0
                          )

                insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                     values(#RCNid#,
                            #DEid#,
                            (SELECT @@IDENTITY), 
                            #totalSubsidioPagado#,
                            0,
                            0,
                            0)
            </cfquery>
                    
            <cfelse>
                <cfthrow detail="Error. Debe definirse el tipo de Deduccion 002 Ajuste ISR">
        </cfif>

    </cffunction>

    <cffunction  name="addConceptoDeduccionASPE">
        <cfargument name="RCNid"                    type="numeric" required="yes">
        <cfargument name="varRCNid"                 type="string"  required="yes">
        <cfargument name="DEid"                     type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado"      type="numeric" default=0>
        <cfargument name="fechaDesde"               type="date">
        
        <cfquery name="rsTDeduccion" datasource="#session.DSN#">
            select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="071">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>

        <!--- <cfquery datasource="#session.DSN#" name="rsRHParametros">
            select  Pvalor as TDid, Pdescripcion  
            from  RHParametros 
            where 
               Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2033"> 
            and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>

        <cfquery name="rsSubCalculado" datasource="#session.DSN#">
            select sum(ICvalor) as SubCalculado from (
            select ICvalor,RCNid,DEid from HIncidenciasCalculo where RCNid in (#varRCNid#) and DEid=#DEid# and CIid=#rsRHParametros.TDid#
            union
            select ICvalor,RCNid,DEid from IncidenciasCalculo where RCNid in (#varRCNid#) and DEid=#DEid# and CIid=#rsRHParametros.TDid#) TmpIns group by  DEid
        </cfquery> --->

        <cfif rsTDeduccion.TDid neq ''>

            <cfquery datasource="#session.DSN#" name="rsValidaNumDeducciones">
                SELECT td.TDcodigo
                FROM DeduccionesEmpleado de
                INNER JOIN TDeduccion td ON de.TDid = td.TDid
                AND de.Ecodigo = td.Ecodigo
                WHERE de.DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.DEid#">
                and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>
                
            <!--- Elimina registro  --->
            <cfquery datasource="#session.DSN#">
                delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did = (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#')
                delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#'
            </cfquery>

            <cfif rsValidaNumDeducciones.RecordCount EQ 1 AND ListContains(rsValidaNumDeducciones.TDcodigo,"071") AND arguments.totalSubsidioPagado LT 0>
                <!--- Solo tiene la dedducción 071, por lo tanto se eliminará y se cargará como deducción (Parametro 2033)  --->
                <cfset addIncidenciaCalculoSubsidioEmpleo(
                    RCNid=arguments.RCNid,
                    DEid=arguments.DEid,
                    totalSubsidioPagado=arguments.totalSubsidioPagado,
                    fechaDesde=arguments.fechaDesde
                )>
            <cfelseif rsValidaNumDeducciones.RecordCount GT 1 AND (ListContains(rsValidaNumDeducciones.TDcodigo,"071")  OR arguments.totalSubsidioPagado LT 0)>
                <!--- Tiene más de una deducción, entre ellas la 071, entonces esta se va a cambiar por el 008 --->
                <cfquery name="rsTDeduccion008" datasource="#session.DSN#">
                    select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="008">
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                </cfquery>
                
                <cfif rsTDeduccion008.RecordCount GT 0>
                    <cfquery datasource="#session.DSN#">
                        delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did IN (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion008.TDid# and Dfechaini='#fechaDesde#')
                        delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion008.TDid# and Dfechaini='#fechaDesde#'
                    </cfquery>

                    <cfquery datasource="#session.DSN#">
                        insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                                values(
                                        #arguments.DEid#,
                                        #session.Ecodigo#,
                                        #rsTDeduccion008.SNcodigo#,
                                        #rsTDeduccion008.TDid#,
                                        '#rsTDeduccion008.TDdescripcion#',
                                        CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                        1,
                                        #arguments.totalSubsidioPagado#,
                                        '#arguments.fechaDesde#',
                                        #arguments.totalSubsidioPagado#,
                                        0,
                                        0,
                                        0,
                                        1,
                                        0,
                                        0
                                )
        
                        insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                            values(#arguments.RCNid#,
                                    #arguments.DEid#,
                                    (SELECT @@IDENTITY), 
                                    #arguments.totalSubsidioPagado#,
                                    0,
                                    0,
                                    0)
                    </cfquery>
                </cfif>
            <cfelseif rsValidaNumDeducciones.RecordCount GT 0 AND (!ListContains(rsValidaNumDeducciones.TDcodigo,"008"))>
                <cfquery datasource="#session.DSN#">
                    insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                              values(
                                     #DEid#,
                                     #session.Ecodigo#,
                                     #rsTDeduccion.SNcodigo#,
                                     #rsTDeduccion.TDid#,
                                     '#rsTDeduccion.TDdescripcion#',
                                     CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                     1,
                                     #totalSubsidioPagado#,
                                     '#fechaDesde#',
                                     #totalSubsidioPagado#,
                                     0,
                                     0,
                                     0,
                                     1,
                                     0,
                                     0
                              )
    
                    insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                         values(#RCNid#,
                                #DEid#,
                                (SELECT @@IDENTITY), 
                                #totalSubsidioPagado#,
                                0,
                                0,
                                0)
                </cfquery>
            <cfelseif rsValidaNumDeducciones.RecordCount EQ 0>
                <cfset addIncidenciaCalculoSubsidioEmpleo(
                    RCNid=arguments.RCNid,
                    DEid=arguments.DEid,
                    totalSubsidioPagado=arguments.totalSubsidioPagado,
                    fechaDesde=arguments.fechaDesde
                )>
            </cfif>
                    
            <cfelse>
                <cfthrow detail="Error. Debe definirse el tipo de Deduccion 071 Ajuste en Subsidio para el empleo">
        </cfif>

    </cffunction>

    <cffunction name="addIncidenciaCalculoSubsidioEmpleo">
        <cfargument name="RCNid"                    type="numeric" required="yes">
        <cfargument name="DEid"                     type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado"      type="numeric" default=0>
        <cfargument name="fechaDesde"               type="date">

        <cfinvoke component="RHParametros" method="get" pvalor="2033" default="" returnvariable="param2033"/>

        <cfif param2033 neq ''>
            <cfquery name="rsInc" datasource="#session.DSN#">
                select * from CIncidentes
                where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#param2033#">
                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            </cfquery>

            <cfquery datasource="#session.DSN#" name="rsUltAc">
                select top 1 cf.CFid,lt.RHJid, lt.LTdesde from LineaTiempo lt
                        inner join RHPlazas p
                        on lt.RHPid = p.RHPid
                        and lt.Ecodigo = p.Ecodigo
                        inner join CFuncional cf
                        on cf.CFid=coalesce(p.CFidconta, p.CFid)
                        where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
                        order by LTdesde desc
            </cfquery>

            <cfquery datasource="#session.DSN#" name="rsExiste">
                SELECT COUNT(1) AS Existe
                FROM IncidenciasCalculo
                WHERE CIid = #rsInc.CIid#
                AND RCNid = #arguments.RCNid#
                AND DEid = #arguments.DEid#
            </cfquery>

            <cfif rsExiste.Existe eq 0>
                <cfquery datasource="#session.DSN#">
                    INSERT INTO IncidenciasCalculo
                            (RCNid,DEid,CIid,ICfecha,ICvalor,ICfechasis,Usucodigo,Ulocalizacion
                            ,ICcalculo,ICmontoant,ICmontores,CFid,RHJid,CPmes,CPperiodo,ICespecie)
                    SELECT 
                        #arguments.RCNid#
                        ,#arguments.DEid#
                        ,#rsInc.CIid#
                        ,'#LSDateFormat(rsUltAc.LTdesde,"YYYY-MM-dd")#'
                        ,#abs(totalSubsidioPagado)#	
                        ,'#LSDateFormat(rsUltAc.LTdesde,"YYYY-MM-dd")#'
                        ,#session.Usucodigo#
                        ,'00'
                        ,0
                        ,0.00
                        ,#abs(totalSubsidioPagado)#
                        ,#rsUltAc.CFid#
                        ,#rsUltAc.RHJid#
                        ,#month(rsUltAc.LTdesde)#
                        ,#Year(rsUltAc.LTdesde)#
                        ,0
                </cfquery>
            </cfif>

            <!--- Actualiza montos Incidencias --->
            <cfquery datasource="#session.DSN#" name="rsIncidencias">
                SELECT SUM(ICmontores) AS ICmontores
                FROM IncidenciasCalculo
                WHERE DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
                AND RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
            </cfquery>

            <cfquery datasource="#session.DSN#" name="rsUpdateSalario">
                UPDATE SalarioEmpleado
                SET SEincidencias = #rsIncidencias.ICmontores#,
                    SEliquido = SEsalariobruto + (#rsIncidencias.ICmontores#) - SEcargasempleado
                WHERE RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                AND DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
            </cfquery>

        </cfif>


    </cffunction>

    <cffunction  name="addConceptoDeduccionISRAS" access="private" hint="Se agrega el ajuste mensual de subsidio como deduccion al calculo">
        <cfargument name="RCNid"                    type="numeric" required="yes">
        <cfargument name="varRCNid"                 type="string"  required="yes">
        <cfargument name="DEid"                     type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado"     type="numeric" required="yes">
        <cfargument name="fechaDesde"               type="date">

        <cfquery name="rsTDeduccion" datasource="#session.DSN#">
            select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="007">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    
        <cfif rsTDeduccion.TDid neq ''>
            
            <cfquery datasource="#session.DSN#">
                delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did = (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#')
                delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#'
            </cfquery>

            <cfquery datasource="#session.DSN#">
                insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                          values(
                                 #DEid#,
                                 #session.Ecodigo#,
                                 #rsTDeduccion.SNcodigo#,
                                 #rsTDeduccion.TDid#,
                                 '#rsTDeduccion.TDdescripcion#',
                                 CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                 1,
                                 -#totalSubsidioPagado#,
                                 '#fechaDesde#',
                                 -#totalSubsidioPagado#,
                                 0,
                                 0,
                                 0,
                                 1,
                                 0,
                                 0
                          )

                insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                     values(#RCNid#,
                            #DEid#,
                            (SELECT @@IDENTITY), 
                            -#totalSubsidioPagado#,
                            0,
                            0,
                            0)
            </cfquery>
                    
            <cfelse>
                <cfthrow detail="Error. Debe definirse el tipo de Deduccion 007 ISR ajustado por subsidio">
        </cfif>
    </cffunction>

    <cffunction  name="addConceptoDeduccionSEENC">
        <cfargument name="RCNid"               type="numeric" required="yes">
        <cfargument name="varRCNid"            type="string"  required="yes">
        <cfargument name="DEid"                type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado" type="numeric" default=0>
        <cfargument name="fechaDesde"          type="date">
        
        <cfquery name="rsTDeduccion" datasource="#session.DSN#">
            select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="008">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>

        <cfif rsTDeduccion.TDid neq ''>
            
            <cfquery datasource="#session.DSN#">
                delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did = (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#')
                delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#'
            </cfquery>

            <cfquery datasource="#session.DSN#">
                insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                          values(
                                 #DEid#,
                                 #session.Ecodigo#,
                                 #rsTDeduccion.SNcodigo#,
                                 #rsTDeduccion.TDid#,
                                 '#rsTDeduccion.TDdescripcion#',
                                 CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                 1,
                                 #totalSubsidioPagado# * -1,
                                 '#fechaDesde#',
                                 #totalSubsidioPagado# * -1,
                                 0,
                                 0,
                                 0,
                                 1,
                                 0,
                                 0
                          )

                insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                     values(#RCNid#,
                            #DEid#,
                            (SELECT @@IDENTITY), 
                            #totalSubsidioPagado# * -1,
                            0,
                            0,
                            0)
            </cfquery>
                    
            <cfelse>
                <cfthrow detail="Error. Debe definirse el tipo de Deduccion 008 Subsidio efectivamente entregado que no correspondia ">
        </cfif>

    </cffunction>

    <cffunction  name="addConceptoDeduccionREISR">
        <cfargument name="RCNid"                    type="numeric" required="yes">
        <cfargument name="varRCNid"                 type="string"  required="yes">
        <cfargument name="DEid"                     type="numeric" required="yes">
        <cfargument name="totalSubsidioPagado" type="numeric" required="yes">
        <cfargument name="fechaDesde"               type="date">

        <cfquery name="rsTDeduccion" datasource="#session.DSN#">
            select * from TDeduccion where TDcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="001">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>

        <cfif rsTDeduccion.TDid neq ''>
            
            <cfquery datasource="#session.DSN#">
                delete from DeduccionesCalculo where DEid=#DEid# and RCNid=#RCNid# and Did = (select Did from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#')
                delete from DeduccionesEmpleado where DEid=#DEid# and TDid=#rsTDeduccion.TDid# and Dfechaini='#fechaDesde#'
            </cfquery>

            <!--- <cfquery name="rsTotalISRD" datasource="#session.DSN#">
                select sum(ISRDeterminado) ISRD from(
                            select DEid,RCNid,ISRDeterminado from HRHSubsidio where RCNid in (#varRCNid#) and DEid=#DEid#
                            union
                            select DEid,RCNid,ISRDeterminado from RHSubsidio where RCNid in (#varRCNid#)and DEid=#DEid#) tmpSub group by DEid
            </cfquery>     --->
            <cfquery datasource="#session.DSN#">
                insert into DeduccionesEmpleado(DEid,Ecodigo,SNcodigo,TDid,Ddescripcion,Dreferencia,Dmetodo,Dvalor,Dfechaini,Dmonto,Dtasa,Dsaldo,Dmontoint,Destado,Dcontrolsaldo,Dactivo)
                          values(
                                 #DEid#,
                                 #session.Ecodigo#,
                                 #rsTDeduccion.SNcodigo#,
                                 #rsTDeduccion.TDid#,
                                 '#rsTDeduccion.TDdescripcion#',
                                 CONCAT('Ajuste Mes ', month('#fechaDesde#')),
                                 1,
                                 #totalSubsidioPagado#,
                                 '#fechaDesde#',
                                 #totalSubsidioPagado#,
                                 0,
                                 0,
                                 0,
                                 1,
                                 0,
                                 0
                          )

                insert into DeduccionesCalculo (RCNid, DEid, Did, DCvalor,DCcalculo,DCmontoant,DCinteres) 
                     values(#RCNid#,
                            #DEid#,
                            (SELECT @@IDENTITY), 
                            #totalSubsidioPagado#,
                            0,
                            0,
                            0)
            </cfquery>
                    
        <cfelse>
                <cfthrow detail="Error. Debe definirse el tipo de Deduccion 001 Reintegro de ISR pagado en exceso que no haya sido enterado al SAT">
        </cfif>

    </cffunction>

    <cffunction  name="tieneSubsidio">
        <cfargument name="DEid"       type="numeric" default='0'>
        <cfargument name="Tcodigo"    type="string"  required="yes">
        <cfargument name="CPperiodo"  type="string"  required="yes">
        <cfargument name="CPmes"      type="string"  required="yes">
        <cfargument name="fechaDesde" type="date">

        <cfset fechaInicio = getfechaIni(CPperiodo=#CPperiodo#,CPmes=#CPmes#,Tcodigo=#Tcodigo#)>
        <cfset fechaFin = getfechaFin(CPperiodo=#CPperiodo#,CPmes=#CPmes#,Tcodigo=#Tcodigo#)>

        <cfquery name="rsRCalculoNomina" datasource="#session.DSN#">
            select RCNid from RCalculoNomina where Tcodigo=#Tcodigo# and RCdesde >='#fechaInicio#'  and RChasta <='#fechaFin#'
	        union
            select RCNid from HRCalculoNomina where Tcodigo=#Tcodigo# and RCdesde >= '#fechaInicio#'  and RChasta <='#fechaFin#'
         </cfquery>
        
        <cfset varRCNid = ValueList(rsRCalculoNomina.RCNid)>

        <cfquery name="rsSalarioEmpleado" datasource="#session.DSN#">
             select DEid,sum(SEsalariobruto) as SEsalariobrutoM  from (
                select DEid,sum(SEsalariobruto) as SEsalariobruto from HSalarioEmpleado where RCNid in (#varRCNid#) and (SEsalariobruto+SEincidencias) > 0
                and DEid=#Deid#
                and  DEid in (select DEid from SalarioEmpleado where RCNid in (#varRCNid#))  group by DEid
                union
                select DEid,SEsalariobruto from SalarioEmpleado where RCNid in (#varRCNid#) and DEid=#Deid#
            ) tmpSalario group by DEid
        </cfquery>

        <cfset totalGravable = rsSalarioEmpleado.SEsalariobrutoM>

        <cfquery name="rsInsideciasGravables" datasource="#session.DSN#">
            select DEid,sum(ICmontores) ICvalorM from (
                                                      select a.DEid,a.RCNid,a.ICmontores from IncidenciasCalculo a inner join CIncidentes b on a.CIid=b.CIid
                                                                          where a.RCNid in (#varRCNid#) and a.ICmontores >0  and DEid=#DEid# and b.CInorenta=0 and CItimbrar=0
                                                      union
                                                      select a.DEid,a.RCNid,a.ICmontores from HIncidenciasCalculo a inner join CIncidentes b on a.CIid=b.CIid
                                                                          where a.RCNid in (#varRCNid#) and  a.ICmontores >0  and DEid=#DEid# and b.CInorenta=0 and CItimbrar=0
                                                   ) tmpIncidencia group by DEid
          </cfquery> 
       
          <cfif rsInsideciasGravables.RecordCount GT 0>
             <cfloop query="rsInsideciasGravables">
                <cfset totalGravable += rsInsideciasGravables.ICvalorM>
             </cfloop>
          </cfif>   

        <cfset subsidioCodigo = 'MXM02'>
            <cfquery name="rsSubsidio" datasource="#session.DSN#">
                    select d.DIRmontofijo from DImpuestoRenta d
			        inner join EImpuestoRenta ei on d.EIRid=ei.EIRid
		            inner join ImpuestoRenta i on ei.IRcodigo=i.IRcodigo
			        where i.IRcodigo='#subsidioCodigo#' 
			        and  #totalGravable#>= d.DIRinf and #totalGravable#<=d.DIRsup
                    and  GETDATE() > ei.EIRdesde 
                    and  GETDATE() < ei.EIRhasta
            </cfquery>
        <cfreturn rsSubsidio.DIRmontofijo gt 0 ? 1:0>
    </cffunction>

 </cfcomponent>

