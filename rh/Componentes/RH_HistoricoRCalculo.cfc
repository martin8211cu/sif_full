<cfcomponent>
	<cffunction name="HistoricoRCalculo" access="public" output="true" >
		<cfargument name="conexion"		type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="RCNid"   		type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="Usucodigo" 	type="numeric" 	required="no" default="#session.Usucodigo#">
		<cfargument name="debug" 		type="boolean"  default="no">
		
		<!--- 	Procesamiento del historico de nóminas del sistema
		  		Se modifican las estructuras de datos historicas propias del sistema de Recursos Humanos
		 		Este proceso no debe ejecutarse dentro de una transaccion de Base de Datos
		 		pues se controla la ejecución de esta dentro del procedimiento
			    Este proceso es invocado desde el componente: RH_HistoricosNomina --->

	<cfset error = 0 >
	<cfset controlerror = 0 >
	<cfset mensaje = '' >
	
	<cfif len(trim(arguments.RCNid)) eq 0>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Relacion_de_Calulo_no_valida"
		Default="Error! La Relaci&oacute;n de C&aacute;lculo de N&oacute;mina indicada no es una relaci&oacute;n de c&aacute;lculo v&aacute;lida. Proceso Cancelado"
		xmlfile="/rh/Componentes.xml"
		returnvariable="vError"/>
		<cfthrow message="#vError#">
	</cfif>

	<cfquery name="rsExiste" datasource="#arguments.conexion#">
		select 1 
		from HRCalculoNomina
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
	</cfquery>
	<cfif rsExiste.recordcount gt 0>
		<!---	Este proceso ya se ejecuto. 
		  		Como se lleva a cabo dentro de una transacción, se ejecuta completo
				o se devuelve completo.
		  		Para evitar registros duplicados, se regresa el proceso cuando 
		  		la relacion de cálculo ya existe en la historia --->
		<cfreturn 3	>
	</cfif>

	<cftransaction>

		<cfquery datasource="#arguments.conexion#">
			insert into HRCalculoNomina( RCNid, Ecodigo, Tcodigo, RCDescripcion, RCdesde, RChasta, RCestado, 
										 Usucodigo, Ulocalizacion, IDcontable, NAP, Bid, CBid, CBcc, Mcodigo, RCtc, RHPTUEid,RHCFOAid)
			select 	RCNid, Ecodigo, Tcodigo, RCDescripcion, RCdesde, RChasta, RCestado, 
					Usucodigo, Ulocalizacion, IDcontable, NAP, Bid, CBid, CBcc, Mcodigo, RCtc, RHPTUEid,RHCFOAid
			from RCalculoNomina
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
        
        <!--- Inicio.Se actualiza el estatus las deducciones de FOA en el cierre Anual SML   ---> 

		<cfquery datasource="#arguments.conexion#" name = "rsNominaFOA">
			select c.RHCFOAfechaInicio,c.RHCFOAfechaFinal from HRCalculoNomina a
					inner join CalendarioPagos b on b.CPid = a.RCNid 
						and a.Ecodigo = b.Ecodigo and a.Tcodigo=b.Tcodigo
					inner join RHCierreFOA c on c.RHCFOAid = a.RHCFOAid
			where CPtipo = 5
 				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and CPperiodo = datepart(yyyy,RHCFOAfechaInicio)
 			and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
        
        <cfif isdefined('rsNominaFOA') and rsNominaFOA.RecordCount GT 0>
        	<cfquery datasource="#arguments.conexion#">
				update RHHFondoAhorro 
				set FAEstatus = 2
				where RCNid in (select CPid
							from CalendarioPagos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNominaFOA.RHCFOAfechaInicio#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNominaFOA.RHCFOAfechaFinal#">
							and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">)
                	and FAEstatus = 0
			</cfquery>
            <cfquery datasource="#arguments.conexion#">
				update RHHFondoAhorro 
				set FAEstatusCierre = 1
				where RCNid in (select CPid
							from CalendarioPagos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNominaFOA.RHCFOAfechaInicio#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNominaFOA.RHCFOAfechaFinal#">
							and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            and CPtipo = 0
                            union
                            select top(1) CPid
							from CalendarioPagos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNominaFOA.RHCFOAfechaInicio#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsNominaFOA.RHCFOAfechaFinal#">
							and CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                            and CPtipo = 1                            
                            order by CPid desc)
			</cfquery>
            
        </cfif>
        
		<cfquery datasource="#arguments.conexion#">
			insert into HSalarioEmpleado(	RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, 
											SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinodeduc, SEinocargas, SEinorenta,SERentaT,
											SERentaD,SEsalrec,SEespecie,SEsalariobc,SEotrossalarios,SErentaotrossalarios,SErentaMens,SEDiferencial)
			select RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, 
				   SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinodeduc, SEinocargas, SEinorenta,SERentaT,SERentaD,
					 SEsalrec,SEespecie, SEsalariobc, SEotrossalarios,SErentaotrossalarios,SErentaMens,SEDiferencial
			from SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>	
			
		<cfquery datasource="#arguments.conexion#">
			insert into HPagosEmpleado(	DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario, PEsalarioref,
										PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, 
										Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, 
										LTid, RHJid, PEhjornada, PEtiporeg, HPElinea,PEsalrec,CPperiodo,CPmes)
			select DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario, PEsalarioref,
				   PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, 
				   Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, 
				   LTid, RHJid, PEhjornada, PEtiporeg, PElinea, PEsalrec,CPperiodo,CPmes
			from PagosEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>	

		<cfquery datasource="#arguments.conexion#">
			insert into HCargasCalculo( DClinea, RCNid, DEid, CCvaloremp, CCvalorpat, CCbatch, 
										CCvalorempant, CCvalorpatant, CCBaseSalProyectado, CCSalarioBaseEmpleado, CCSalarioBase,CCSalarioBaseCotizacion )
			select DClinea, RCNid, DEid, CCvaloremp, CCvalorpat, CCbatch, 
				   CCvalorempant, CCvalorpatant, CCBaseSalProyectado, CCSalarioBaseEmpleado, CCSalarioBase, CCSalarioBaseCotizacion
			from CargasCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>	
		
		<cfquery datasource="#arguments.conexion#">
			insert into HIncidenciasCalculo( RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, 
											 Usucodigo, Ulocalizacion, ICcalculo, ICbatch, 
											 ICmontoant, ICmontores, CFid, RHSPEid, RHJid, HICid,
											 Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta
											 ,CPmes, CPperiodo,ICespecie, Ifechacontrol)
			select RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, 
				   Usucodigo, Ulocalizacion, ICcalculo, ICbatch, 
				   ICmontoant, ICmontores, CFid, RHSPEid, RHJid, ICid,
				   Iusuaprobacion, Ifechaaprobacion, NAP, NRP, Inumdocumento, CFcuenta
				   ,CPmes, CPperiodo,ICespecie, Ifechacontrol
			from IncidenciasCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>	

		<cfquery datasource="#arguments.conexion#">
			insert into HDeduccionesCalculo( Did, RCNid, DEid, DCvalor, DCinteres, DCbatch, 
											 DCmontoant, DCcalculo, DCsaldo)
			select a.Did, a.RCNid, a.DEid, a.DCvalor, a.DCinteres, a.DCbatch, 
				   a.DCmontoant, a.DCcalculo, case when d.Dcontrolsaldo = 1 then d.Dsaldo else 0.00 end
			from DeduccionesCalculo a, DeduccionesEmpleado d
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and d.Did = a.Did
			  and d.DEid = a.DEid
		</cfquery>	
        
        <cfquery datasource="#arguments.conexion#">  <!---Inserta FOA en Historico --->
        	insert into RHHFondoAhorro (DEid,Ecodigo,FAMonto,RCNid,TDid,Tcodigo,FAEstatus,FAEstatusFini,FAEstatusCierre)
            select DEid,Ecodigo,FAMonto,RCNid,TDid,Tcodigo,FAEstatus,0,0 from RHFondoAhorro
            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
        </cfquery>
        
		<!---Insertar el Subsidio en la tabla de HRHSubsidio SML--->
          <cfquery datasource="#arguments.conexion#" name="rsInsertSub">	
               Insert into HRHSubsidio(RCNid, DEid, Ecodigo, RHSvalor, RHSFechaDesde, RHSFechaHasta,ISRDeterminado)
                select RCNid,DEid, Ecodigo, RHSValor, RHSFechaDesde, RHSFechaHasta,ISRDeterminado from RHSubsidio
                where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#"> 
           </cfquery>		
		
			<cfquery datasource="#Arguments.conexion#">
			 insert into HRHPagosExternosCalculo (PEXid, Ecodigo, PEXTid, DEid, RCNid, PEXmonto, PEXperiodo, PEXmes, Ifechasis, BMUsucodigo, PEXfechaPago)
			 select PEXid, Ecodigo, PEXTid, DEid, RCNid, PEXmonto, PEXperiodo, PEXmes, Ifechasis, BMUsucodigo, PEXfechaPago
			 from RHPagosExternosCalculo pext
			 where pext.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
				  
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleado 
				set Dsaldo = DeduccionesEmpleado.Dsaldo - (	select a.DCvalor <!--- - a.DCinteres  se elimina la resta de intereses, pq el monto está contemplado dentro de DCvalor---> 
															from DeduccionesCalculo a
															where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
															  and a.Did = DeduccionesEmpleado.Did
															  and a.DEid = DeduccionesEmpleado.DEid)
			where exists( 	select 1
							from DeduccionesCalculo a
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and a.Did = DeduccionesEmpleado.Did
							  and a.DEid = DeduccionesEmpleado.DEid )
				and Dcontrolsaldo = 1			  
		</cfquery>			  
			
		<!--- Actualiza la fecha de pago de las Deducciones si éstas tienen plan --->
		<!---
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleadoPlan 
			set PPfecha_pago = c.CPfcalculo,
				PPfecha_doc = c.CPfcalculo,
				PPpagoprincipal = p.PPprincipal,
				PPpagointeres = p.PPinteres,
				PPpagado = 1
			from  DeduccionesCalculo a, CalendarioPagos c, DeduccionesEmpleadoPlan p
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.DCvalor > 0.00 
			  and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and p.Did = a.Did
			  and p.PPfecha_vence = c.CPhasta
			  and p.PPpagado = 0
		</cfquery>			   
		--->
	<cfquery name="DEP" datasource="#session.dsn#">
		select distinct  p.Did ,d.DEid,  (select min (p2.PPnumero) 
											from DeduccionesEmpleadoPlan p2, DeduccionesEmpleado d2,CalendarioPagos c2
                                 			where  c2.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
                                                 and d2.Did=p2.Did
                                                 and p2.PPfecha_pago is null
                                                 and p2.PPpagado = 0
                                                 and d2.DEid=d.DEid
                                                 and d2.Did=d.Did
                                                 and p2.Did=p.Did) as minimo
		from DeduccionesEmpleadoPlan p,DeduccionesEmpleado d,CalendarioPagos c,DeduccionesCalculo dc
		 where 
			d.Did=p.Did
			and dc.Did=d.Did
            and p.PPfecha_pago is null
            and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">            
            and p.PPpagado = 0
            and dc.DEid=d.DEid	
			and dc.RCNid=c.CPid		
			and p.Ecodigo=#session.Ecodigo#
	</cfquery>

		<cfloop query="DEP">
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleadoPlan 
			set PPfecha_pago = (	select c.CPfcalculo
									from  DeduccionesCalculo a, CalendarioPagos c, DeduccionesEmpleadoPlan p
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									  and a.DCvalor > 0.00 
									  and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									  and p.Did = a.Did									  
									  and p.PPpagado = 0
									  and p.Did = DeduccionesEmpleadoPlan.Did
									  and p.PPnumero = DeduccionesEmpleadoPlan.PPnumero
									and a.DEid=#DEP.DEid#
                                    and a.Did=#DEP.Did#
                                    and p.PPnumero=#DEP.minimo# ),
				PPfecha_vence = (	select c.CPfpago
									from  DeduccionesCalculo a, CalendarioPagos c, DeduccionesEmpleadoPlan p
									where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									  and a.DCvalor > 0.00 
									  and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
									  and p.Did = a.Did									  
									  and p.PPpagado = 0
									  and p.Did = DeduccionesEmpleadoPlan.Did
									  and p.PPnumero = DeduccionesEmpleadoPlan.PPnumero
									and a.DEid=#DEP.DEid#
                                    and a.Did=#DEP.Did#
                                    and p.PPnumero=#DEP.minimo# ),
				PPfecha_doc = PPfecha_pago,
				PPpagoprincipal = PPprincipal,
				PPpagointeres = PPinteres,
				PPpagado = 1
			where exists ( 	select 1
							from  DeduccionesCalculo a, CalendarioPagos c, DeduccionesEmpleadoPlan p
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and a.DCvalor > 0.00 
							  and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and p.Did = a.Did
				  			  and p.PPpagado = 0
							  and p.Did = DeduccionesEmpleadoPlan.Did
							  and p.PPnumero = DeduccionesEmpleadoPlan.PPnumero
                            and a.DEid=#DEP.DEid#
                            and a.Did=#DEP.Did#
                            and p.PPnumero=#DEP.minimo# )
						
				and PPpagado = 0
				and Did=#DEP.Did#
				and PPnumero=#DEP.minimo#
					   
		</cfquery>			
		</cfloop>	
        <!---
            Comentado por Yu Hui 6 Octubre 2005
    	-- Mueve el plan de pagos cuando no se hizo un pago
    	update DeduccionesEmpleadoPlan set 
            PPfecha_vence = Case when tn.Ttipopago = 0 then dateadd(dd, 7, p.PPfecha_vence)
                                 when tn.Ttipopago = 1 then dateadd(dd, 14, p.PPfecha_vence)
                                 when tn.Ttipopago = 2 then dateadd(dd, 15, p.PPfecha_vence)
                                 when tn.Ttipopago = 3 then dateadd(mm, 1, p.PPfecha_vence) end
        from DeduccionesCalculo a, CalendarioPagos c, TiposNomina tn, DeduccionesEmpleadoPlan p
        where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
          and a.DCvalor = 0.00 
          and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
          and tn.Ecodigo = c.Ecodigo
          and tn.Tcodigo = c.Tcodigo
          and p.Did = a.Did
          and p.PPpagado = 0 
        --->

        <!--- INICIO MODIFICACIONES PARA PLAN DE PAGOS Yu Hui 6 Octubre 2005 --->
        <!--- Procede a registrar en Bitacora el movimiento de planes de pago--->

		<!---
		<cf_dbfunction name="dateaddm" args="NumeroMeses, Fecha">
		<cf_dbfunction name="dateadd" args="NumeroDias, Fecha">
		<cf_dbfunction name="date_part"   args="DD,sysdate">
		--->
		
		<!--- ******************************************* --->
			<cf_dbfunction name="date_part" args="DD,dep.PPfecha_vence" 		returnvariable="datepart1" >
			<cf_dbfunction name="dateaddm" 	args="1,dep.PPfecha_vence" 			returnvariable="dateaddm1">
			<cf_dbfunction name="dateadd" 	args="#datepart1# * -1 x #dateaddm1#" returnvariable="args1" delimiters="x"> <!--- truco: delimitador es la x, pues el string esta lleno de comas --->
		<!--- ******************************************* --->
		
		<!--- ******************************************* --->
			<cf_dbfunction name="dateaddm" 	args="2,dep.PPfecha_vence"	returnvariable="dateaddm2">
			<cf_dbfunction name="date_part"   args="DDx #dateaddm2#" returnvariable="datepart2" delimiters="x">
			<cf_dbfunction name="dateadd" args="#datepart2# * -1 x #dateaddm2#" returnvariable="args2" delimiters="x">
		<!--- ******************************************* --->		

		<cfquery datasource="#arguments.conexion#">
			insert into BDeduccionesEmpleadoPlan(RCNid, Did, PPnumero, BDEPfechaant, BDEPfechanueva, BMUsucodigo, BMfecha)
			<!---
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, dep.Did, dep.PPnumero, dep.PPfecha_vence, 
				   case when tn.Ttipopago = 0 then dateadd(dd, 7, dep.PPfecha_vence)
						when tn.Ttipopago = 1 then dateadd(dd, 14, dep.PPfecha_vence)
						when tn.Ttipopago = 2 and datepart(dd, dep.PPfecha_vence) > 15 then dateadd(dd, 15, dep.PPfecha_vence)
						when tn.Ttipopago = 2 and datepart(dd, dep.PPfecha_vence) = 15 then dateadd(dd, datepart(dd, dep.PPfecha_vence) * -1,dateadd(mm, 1, dep.PPfecha_vence))
						when tn.Ttipopago = 3 then dateadd(dd, datepart(dd, dateadd(mm, 2, dep.PPfecha_vence)) * -1,dateadd(mm, 2, dep.PPfecha_vence))
				   end,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.usucodigo#">, 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				   --->
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">, dep.Did, dep.PPnumero, dep.PPfecha_vence, 
				   case when tn.Ttipopago = 0 then <cf_dbfunction name="dateadd" args="7, dep.PPfecha_vence">
						when tn.Ttipopago = 1 then <cf_dbfunction name="dateadd" args="14, dep.PPfecha_vence">
						when tn.Ttipopago = 2 and <cf_dbfunction name="date_part"   args="DD,dep.PPfecha_vence"> > 15 then <cf_dbfunction name="dateadd" args="15,dep.PPfecha_vence">
						when tn.Ttipopago = 2 and <cf_dbfunction name="date_part" args="DD,dep.PPfecha_vence"> = 15 then #preservesinglequotes(args1)#
						when tn.Ttipopago = 3 then #preservesinglequotes(args2)#
				   end,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.usucodigo#">, 
				   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			from DeduccionesEmpleadoPlan dep, DeduccionesEmpleadoPlan a, CalendarioPagos b, DeduccionesEmpleado c, LineaTiempo d, TiposNomina tn
			where dep.PPpagado = 0
			and a.Did = dep.Did
			and a.PPpagado = 0
			and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and b.Ecodigo = a.Ecodigo
			and b.CPhasta = a.PPfecha_vence
			and c.Did = a.Did
			and d.DEid = c.DEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between d.LTdesde and d.LThasta
			and d.Tcodigo = b.Tcodigo
			and tn.Ecodigo = b.Ecodigo
			and tn.Tcodigo = b.Tcodigo
			and not exists (
				select 1
				from DeduccionesCalculo x
				where x.Did = a.Did
				and x.RCNid = b.CPid
				and x.DCvalor != 0.00
			)
		</cfquery>

		<!--- Mueve el plan de pagos cuando no se hizo un pago --->
		<!---
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleadoPlan 
			set PPfecha_vence = case when tn.Ttipopago = 0 then dateadd(dd, 7, DeduccionesEmpleadoPlan.PPfecha_vence)
									 when tn.Ttipopago = 1 then dateadd(dd, 14, DeduccionesEmpleadoPlan.PPfecha_vence)
									 when tn.Ttipopago = 2 and datepart(dd, DeduccionesEmpleadoPlan.PPfecha_vence) > 15 then dateadd(dd, 15, DeduccionesEmpleadoPlan.PPfecha_vence)
									 when tn.Ttipopago = 2 and datepart(dd, DeduccionesEmpleadoPlan.PPfecha_vence) = 15 then dateadd(dd, datepart(dd, DeduccionesEmpleadoPlan.PPfecha_vence) * -1,dateadd(mm, 1, DeduccionesEmpleadoPlan.PPfecha_vence))
									 when tn.Ttipopago = 3 then dateadd(dd, datepart(dd, dateadd(mm, 2, DeduccionesEmpleadoPlan.PPfecha_vence)) * -1,dateadd(mm, 2, DeduccionesEmpleadoPlan.PPfecha_vence))
								end
			from DeduccionesEmpleadoPlan, DeduccionesEmpleadoPlan a, CalendarioPagos b, DeduccionesEmpleado c, LineaTiempo d, TiposNomina tn
			where DeduccionesEmpleadoPlan.PPpagado = 0
			and a.Did = DeduccionesEmpleadoPlan.Did
			and a.PPpagado = 0
			and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			and b.Ecodigo = a.Ecodigo
			and b.CPhasta = a.PPfecha_vence
			and c.Did = a.Did
			and d.DEid = c.DEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between d.LTdesde and d.LThasta
			and d.Tcodigo = b.Tcodigo
			and tn.Ecodigo = b.Ecodigo
			and tn.Tcodigo = b.Tcodigo
			and not exists (
				select 1
				from DeduccionesCalculo x
				where x.Did = a.Did
				and x.RCNid = b.CPid
				and x.DCvalor != 0.00
			)
		</cfquery>
		--->


  
		<!--- FIN MODIFICACIONES PARA PLAN DE PAGOS Yu Hui 6 Octubre 2005 --->

		<!--- Inactivar Deducciones con saldo = 0   --->
		<!---
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleado 
			set Dactivo = 0
			from DeduccionesCalculo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.Did = DeduccionesEmpleado.Did
			  and a.DEid = DeduccionesEmpleado.DEid
			  and DeduccionesEmpleado.Dcontrolsaldo = 1
			  and DeduccionesEmpleado.Dsaldo <= 0.00
			  and DeduccionesEmpleado.Dactivo = 1
		</cfquery>	  
		--->
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleado 
			set Dactivo = 0
			where exists( 	select 1
							from DeduccionesCalculo a
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and a.Did = DeduccionesEmpleado.Did
							  and a.DEid = DeduccionesEmpleado.DEid )
				  and DeduccionesEmpleado.Dcontrolsaldo = 1
				  and DeduccionesEmpleado.Dsaldo <= 0.00
				  and DeduccionesEmpleado.Dactivo = 1
		</cfquery>	  

		<!--- Actualiza el Valor para el siguiente pago (cuando el saldo es menor que el valor) --->
<!---
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleado 
			set Dvalor = Dsaldo
			from DeduccionesCalculo a
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and a.Did = DeduccionesEmpleado.Did
			  and a.DEid = DeduccionesEmpleado.DEid
			  and DeduccionesEmpleado.Dcontrolsaldo = 1
			  and DeduccionesEmpleado.Dmetodo = 1
			  and DeduccionesEmpleado.Dvalor > DeduccionesEmpleado.Dsaldo
			  and DeduccionesEmpleado.Dactivo = 1
		</cfquery>
--->		
		<cfquery datasource="#arguments.conexion#">
			update DeduccionesEmpleado 
			set Dvalor = Dsaldo
			where exists ( 	select 1 
							from DeduccionesCalculo a
							where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and a.Did = DeduccionesEmpleado.Did
							  and a.DEid = DeduccionesEmpleado.DEid )
				  and Dcontrolsaldo = 1
				  and Dmetodo = 1
				  and Dvalor > Dsaldo
				  and Dactivo = 1
		</cfquery>
		
		<!--- Actualizar la tabla de Saldos de Pagos en Exceso con los datos de la nomina actual --->
		<!--- 1. Incidencia de Rebajo ---->
		<!---	
		<cfquery datasource="#arguments.conexion#">
			update RHSaldoPagosExceso
				set RHSPEsaldo = RHSPEsaldo + coalesce((	select sum(ic.ICmontores)
															from IncidenciasCalculo ic, RHTipoAccion ta
															where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
															  and ic.DEid = RHSaldoPagosExceso.DEid
															  and ic.RHSPEid = RHSaldoPagosExceso.RHSPEid
															  and ta.RHTid = RHSaldoPagosExceso.RHTid
															  and ic.CIid = ta.CIncidente1), 0.00)
			from IncidenciasCalculo i
			where i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and i.RHSPEid is not null
			  and RHSaldoPagosExceso.RHSPEid = i.RHSPEid
		</cfquery>  
		--->
		<cfquery datasource="#arguments.conexion#">
			update RHSaldoPagosExceso
				set RHSPEsaldo = RHSPEsaldo + coalesce((	select sum(ic.ICmontores)
															from IncidenciasCalculo ic, RHTipoAccion ta
															where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
															  and ic.DEid = RHSaldoPagosExceso.DEid
															  and ic.RHSPEid = RHSaldoPagosExceso.RHSPEid
															  and ta.RHTid = RHSaldoPagosExceso.RHTid
															  and ic.CIid = ta.CIncidente1), 0.00)

			where exists(	select 1
							from IncidenciasCalculo i
							where i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and i.RHSPEid is not null
							  and i.RHSPEid = RHSaldoPagosExceso.RHSPEid )
		</cfquery>  		

		<!--- 2. Incidencia de subsidio --->
		<!---
		<cfquery datasource="#arguments.conexion#">
			update RHSaldoPagosExceso
				set RHSPEsaldosub = RHSPEsaldosub - coalesce((	select sum(ic.ICmontores)
																from IncidenciasCalculo ic, RHTipoAccion ta
																where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
																  and ic.DEid = RHSaldoPagosExceso.DEid
																  and ic.RHSPEid = RHSaldoPagosExceso.RHSPEid
																  and ta.RHTid = RHSaldoPagosExceso.RHTid
																  and ic.CIid = ta.CIncidente2), 0.00)
			from IncidenciasCalculo i
			where i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and i.RHSPEid is not null
			  and RHSaldoPagosExceso.RHSPEid = i.RHSPEid
		</cfquery>		  
		--->
		<cfquery datasource="#arguments.conexion#">
			update RHSaldoPagosExceso
				set RHSPEsaldosub = RHSPEsaldosub - coalesce((	select sum(ic.ICmontores)
																from IncidenciasCalculo ic, RHTipoAccion ta
																where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
																  and ic.DEid = RHSaldoPagosExceso.DEid
																  and ic.RHSPEid = RHSaldoPagosExceso.RHSPEid
																  and ta.RHTid = RHSaldoPagosExceso.RHTid
																  and ic.CIid = ta.CIncidente2), 0.00)
			where exists(	select 1 
							from IncidenciasCalculo i
							where i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
							  and i.RHSPEid is not null
							  and i.RHSPEid = RHSaldoPagosExceso.RHSPEid )
		</cfquery>		

	</cftransaction>
	<cfreturn 3 >   <!--- Es correcto el proceso --->

	</cffunction>
</cfcomponent>