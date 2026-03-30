<!---Nueva version de calculo de renta para mexico esta version aplica la utilizacion de las teblas de renta segun el tipo de nomina
esto se incorpora apartir del parametro general utiliza tabla en tipo nomina Pcodigo = 2035
La renta presenta varios tipos de calulo
	-	Por Mensual(Proyectando por cada Calendario)
	-	Por Nomina Aguinaldo (Sobre lo que se esta pagado)
	-	Ajuste Anual sobre lo que se han Ejecutado en el Año Fiscal
--->


<cfcomponent>
	<cffunction name="CalculoNominaRenta" access="public" output="true" >
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

		<cfset CalendarioPago = fnGetCalendarioPago(Arguments.RCNid,Arguments.conexion)>
        <!---<cf_dump var="#CalendarioPago#">--->


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
                
                <cf_dbtempcol name="mes" 					type="numeric" 			mandatory="no">	<!--- Mes --->							<!---A--->
                <cf_dbtempcol name="nomMes" 				type="numeric" 			mandatory="no">	<!--- Nóminas Mes --->					<!---B--->
                <cf_dbtempcol name="numNomina" 				type="numeric" 			mandatory="no">	<!--- Num Nomina --->					<!---C--->	
                <cf_dbtempcol name="nomPend" 				type="numeric" 			mandatory="no">	<!--- Nom Pend --->						<!---D--->
                <cf_dbtempcol name="diasMes" 				type="numeric(18,4)" 	mandatory="no">	<!--- Dias Mes --->						<!---E--->
                <cf_dbtempcol name="diasCalendar"	 		type="numeric(18,4)"	mandatory="no">	<!--- Dias Calend --->					<!---F--->
                
                <cf_dbtempcol name="diasFalta"	 			type="numeric(18,4)"	mandatory="no">
                <cf_dbtempcol name="diasIncap"	 			type="numeric(18,4)"	mandatory="no">
                
                <cf_dbtempcol name="diasMesCalendar" 		type="numeric" 			mandatory="no">	<!--- Dias Mes Calendario --->			<!---G--->
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
                <cf_dbtempcol name="rentaMens" 				type="money" 			mandatory="no">	<!--- Renta  Mensual --->				<!---W--->
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
                        order by b.DIRinf
            </cfquery>
            
<!---             <cfquery datasource="#session.DSN#" name="renta">
                select * from #TRentaAdaptadaAnterior# 
            </cfquery>
            
            
            <cf_dump var = "#renta#">--->
            
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
                        order by b.DIRinf
            </cfquery>
<!---------------------------------------------------------------------------------------->
            <cfquery datasource="#session.DSN#" name="rsCantDiasCalendario">
                select <cf_dbfunction name="datediff" args="a.CPdesde, a.CPhasta">+1 as diasDiferencia
                    , b.Ttipopago, case b.Ttipopago  
                                                                      when  0 then 7
                                                                      when  1 then 14
                                                                      when  2 then 15
                                                                      when  3 then 30
                                                                      
                                                    end as CantDiasCalendario
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
             
			<cfif #rsCantDiasCalendario.Ttipopago# LT 2 and  #rsCantDiasCalendario.CantDiasCalendario# LT 15>
                 <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta# set 
                          diasMesCalendar = #rsCanDiasMes.CanDiasMes# 
                        , diasNomina = #diasNom#
                 </cfquery>
            <cfelse>
                 <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta# set diasMesCalendar = #rsCantDiasCalendario.CantDiasCalendario# * #rsCanCalendaMes.CanCalendaMes#
                        , diasNomina = #rsCantDiasCalendario.CantDiasCalendario#
                </cfquery>
            </cfif>

            <cfif #CalendarioPago.CPtipo# NEQ 0> 
                <cfquery datasource="#session.DSN#">
                    update #EmpleadosRenta#  set diasNomina = 0
                </cfquery>
            </cfif>

<!---------------------------------------------------------------------------------------->
            
			<!---Cantidad Dias  Reales Laborados Ordinarios en Nomina --->
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
                    
			<!---<cfquery datasource="#session.DSN#" name="rsdiasIncap">
               update #EmpleadosRenta# set
                diasIncap =  coalesce((
                                    select sum(pe.PEcantdias)
                                    from PagosEmpleado pe
                                        inner join  CalendarioPagos x 
                                            on pe.RCNid = x.CPid
                                        inner join LineaTiempo lt
                                            on pe.LTid = lt.LTid
                                        inner join  RHTipoAccion ta
                                            on lt.RHTid = ta.RHTid
                                                and ta.RHTcomportam = 5
                                            where pe.DEid = #EmpleadosRenta#.DEid),0)
            </cfquery>--->

            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# set diasCalendar =  diasCalendar - diasFalta
            </cfquery>

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
                                <!---and c.PEdesde = (select Max(PEdesde)  
                                                from RCalculoNomina a, PagosEmpleado c,CalendarioPagos d
                                                    where a.RCNid=d.CPid
                                                    and d.CPhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTabla#">
                                                    and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                                                    and a.RCNid=c.RCNid
                                                 <!---   --and c.PEtiporeg = 0--->
                                                    and c.DEid = #EmpleadosRenta#.DEid  
                                                    and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">)--->
                                ) 
            </cfquery>
            
<!---------------------------------------------------------------------------------------->
            
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
                             and d.CInopryrenta = 1 <!---NO se proyecta--->
                             )
            </cfquery>

<!---------------------------------------------------------------------------------------->

			<!---Total de Salarios, salario referencia para la renta =+K+U+L+Q+R+M  (V)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# 
                set totalSalRent = 	salMensual + incidNoProyect + incRecProyect
            </cfquery>
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
            
            <!--- Renta  Mensual --->				<!---(W)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# 
                set rentaMens = ((totalSalRent - TLimInfAnt) * (TporcentajeAnt/100)) + TMontoAnt
            </cfquery>
            

            <!--- Subsidio Mensual --->				<!---(X)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# 
                set subsidioMens = ( select MontoFijo from #TableSubsidio# where  #EmpleadosRenta#.totalSalRent between LimInf and LimSup)
            </cfquery>
            
            <!--- Renta Real--->					<!---(Y)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# 
                set rentaReal = rentaMens - subsidioMens
            </cfquery>
            
             <!--- Renta Diaria--->					<!---(Z)--->
            <cfquery datasource="#session.DSN#">
                update #EmpleadosRenta# 
                set rentaDiaria = rentaReal / diasNomina
            </cfquery>

            
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
                set retencion	= retaRealCorte
            </cfquery>
            <!---<cf_dumptable var="#EmpleadosRenta#"> --->
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
                set SErenta =(select case when retencion > 0 then retencion else 0 end
                                    from #EmpleadosRenta# 
                                    where #EmpleadosRenta#.DEid = SalarioEmpleado.DEid)
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                and (SalarioEmpleado.SEsalariobruto+SalarioEmpleado.SEincidencias) > 0
                    <cfif isdefined('arguments.DEid')> and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> </cfif>
            </cfquery>
            
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
            
           <!--- <cf_dump var = "#rsEmpSub#">--->

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
                
                <cfset descripcion= <!---rsTiposNomina.Tdescripcion & ', ' &---> rsDeduccion.Pdescripcion>  <!---SML. Modificacion para que no aparezca el nombre de la nomina que le corresponde al trabajador.--->
                <cfloop query="rsEmpSub">
                    
                    <cfquery datasource="#arguments.conexion#" name="rsDeduccionesEmpleado">	
                    Insert into DeduccionesEmpleado(	
                        DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechadoc,
                        Dfechaini, Dfechafin, 
                        Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo,
                        Ulocalizacion, Dcontrolsaldo, Dactivo, Dreferencia, BMUsucodigo, Dobservacion,  IRcodigo,  Mcodigo,
                        ts_rversion, DidPadre, Dinicio)
                         values(#rsEmpSub.DEid#, #arguments.Ecodigo#, #rsTDeduccion.SNcodigo#,#rsTDeduccion.TDid#, '#descripcion#', 1, #rsEmpSub.SErenta#, null,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RCdesde#">,<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">,
                        #rsEmpSub.SErenta#,  0,   0,    0,  1, null,
                        '00',0, 0
                        , '#trim(rsCalendarioPago.CPcodigo)#-#trim(arguments.RCNid)#'
                        , null,null,null,null,
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
                 
                <cfquery datasource="#arguments.conexion#" name="rsSelSub">	
                	select DEid, coalesce(subsidioMens,0) as subsidioMens from #EmpleadosRenta# <!---where DEid = #rsEmpSub.DEid#--->
                </cfquery>
                  
                
                  
               <!---<cf_dump var="#rsSelSub#">--->
                <cfloop query="rsSelSub"> 
                  <cfquery datasource="#arguments.conexion#">
                		delete from RHSubsidio 
                   		where RCNid = #arguments.RCNid#
                       		and DEid = #rsSelSub.DEid#
                  </cfquery> 
                  <cfquery datasource="#arguments.conexion#" name="rsInsertSub">	
                        Insert into RHSubsidio(RCNid, DEid, Ecodigo, RHSvalor, RHSFechaDesde, RHSFechaHasta)
                        values( 
                        #arguments.RCNid#,#rsSelSub.DEid#,#CalendarioPago.Ecodigo#,#rsSelSub.subsidioMens#,
                        '#DateFormat(CalendarioPago.CPdesde,'yyyy-mm-dd')#','#DateFormat(CalendarioPago.CPhasta,'yyyy-mm-dd')#')
                  </cfquery>
                </cfloop>                
            </cfif>
                 
  <!---<cf_dumptable var="#EmpleadosRenta#"> --->
                  
 
                       

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
       		select CPid, CPTipoCalRenta, CPtipo, b.CPperiodo, b.CPmes,b.CPdesde, b.CPhasta, b.Tcodigo, b.Ecodigo, c.Ttipopago
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
		
        <!---<cf_dump var = "#rsDatos#">--->
		<cfloop query="rsDatos">
			<cfset ISPT_AguiMenGra = fnCalculaISPT(rsDatos.AguiMenGra,Arguments.IRcodigo,Arguments.RCNid)> <!---SML. Modificacion para que considera la tabla de renta en la nomina de aguinaldo--->
			<cfset ISPT_SalarioM = fnCalculaISPT(rsDatos.SalarioM,Arguments.IRcodigo,Arguments.RCNid)> <!---SML. Modificacion para que considera la tabla de renta en la nomina de aguinaldo--->
			<cfset ISPT_CF = ISPT_AguiMenGra - ISPT_SalarioM>
          
			
			<cfif ISPT_CF LTE 0 >
				<cfset ISPT_Agui = 0>
			<cfelse>
				<cfset Tasa_Efectiva = (ISPT_CF / rsDatos.AguiMensual) * 100>
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
                    
<!---<cf_dumptable var="#EmpleadosRenta#">--->
                    
                    
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
    
    
    
    
    
    
 </cfcomponent>