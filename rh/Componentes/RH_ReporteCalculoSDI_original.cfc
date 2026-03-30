<cfcomponent>
	<cffunction name="CargarDatos" access="public" returntype="query">
		<cfargument name="FInicio" 		type="date" 	required="no">
        <cfargument name="FFinal"  		type="date" 	required="no">
        <cfargument name="MesInic"  	type="numeric" 	required="no">
        <cfargument name="PeriodoInic"  type="numeric" 	required="no">
        <cfargument name="Tcodigo"  	type="string" 	required="no">
        <cfargument name="InsertHSDI"  	type="string" 	required="no">

        <cfset MesInicAnt 	= datepart('m', #FInicio#)>
		<cfset PeriodoInicAnt 	= datepart('yyyy', #FFinal#)>
		
		<cfswitch expression="#MesInicAnt#">
			<cfcase value = "1">
				<cfset MesInicAnt = 11>
				<cfset  PeriodoInicAnt= PeriodoInicAnt-1>
			</cfcase>
			<cfcase value = "3,5,7,9,11">  
				<cfset MesInicAnt =MesInicAnt-2 >
			</cfcase>
		</cfswitch>
		<cfset  FInicioAnt=dateadd('m',0,getFInicio(mes=MesInicAnt,periodo=PeriodoInicAnt))> 
		<cfset  FFinalAnt= dateadd('m',0,getFFin(mes=MesInicAnt,periodo=PeriodoInicAnt))>

       <!---  FFinalAnt<cfdump var="#FFinalAnt#">
        FInicioAnt<cfdump var="#FInicioAnt#">
        PeriodoInicAnt<cf_dump var="#PeriodoInicAnt#"> --->



        <!---ljimenez variables para el calculo de SDI bimestre Anterior

        <cfset FInicioAnt1 	=   dateadd('m',-2,#arguments.FInicio#) >
        <cfset FFinalAnt1 	= dateadd('m',2,#FInicioAnt1#)>
        <cfset FFinalAnt1 	= dateadd('d',-1,#FFinalAnt1#)>


        <cfset MesInicAnt1 	= datepart('m', #FInicioAnt1#)>
        <cfset PeriodoInicAnt1 	= datepart('yyyy', #FInicioAnt1#)>
        --->

         <cfswitch expression="#Arguments.MesInic#">
            <cfcase value = "1">  <cfset vBimestreRige = 1> </cfcase>
            <cfcase value = "3">  <cfset vBimestreRige = 2> </cfcase>
            <cfcase value = "5">  <cfset vBimestreRige = 3> </cfcase>
            <cfcase value = "7">  <cfset vBimestreRige = 4> </cfcase>
            <cfcase value = "9">  <cfset vBimestreRige = 5> </cfcase>
            <cfcase value = "11"> <cfset vBimestreRige = 6> </cfcase>
		</cfswitch>

        <cf_dbtemp name="SReporteSDI" returnvariable="SReporteSDI" datasource="#session.DSN#">
            <cf_dbtempcol name="DEid" 					type="numeric"			mandatory="no">
            <cf_dbtempcol name="DEidentificacion"  		type="varchar(60)"  	mandatory="no">
            <cf_dbtempcol name="Nombre"					type="varchar(255)"		mandatory="no">
            <cf_dbtempcol name="ingreso" 				type="datetime" 		mandatory="no">
            <cf_dbtempcol name="AnnosAntiguedad"		type="int" 				mandatory="no">

            <cf_dbtempcol name="MtoFactorIntegra"		type="money" 			mandatory="no">
            <cf_dbtempcol name="DiasBimestre"			type="int" 				mandatory="no">
            <cf_dbtempcol name="DiasBimestreLabor"		type="int" 				mandatory="no">
            <cf_dbtempcol name="DiasBimestreFalta"		type="int" 				mandatory="no">
			<cf_dbtempcol name="DiasBimestreIncap"		type="int" 				mandatory="no">
			<cf_dbtempcol name="DiasPosBimestre"		type="int" 				mandatory="no">
			<cf_dbtempcol name="DErespetaSBC"		    type="int" 				mandatory="no">
            <cf_dbtempcol name="SueldoDiario" 			type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoIncidenciasIMSS"		type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoDiasLaborados"		type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoGravDiario"			type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoSDICalculado"		type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoSDIAnterior"			type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoSMGV"				type="money" 			mandatory="no">
            <cf_dbtempcol name="MtoSDITopado"			type="money" 			mandatory="no">
            <cf_dbtempcol name="Diferencias"			type="money" 			mandatory="no">
			<cf_dbtempcol name="MtoSalario"				type="money" 			mandatory="no">
			<cf_dbtempcol name="MtoparteFija"			type="money" 			mandatory="no">
			<cf_dbtempcol name="RVid"					type="numeric"			mandatory="no">
        </cf_dbtemp>

       <!--- MesInicAnt: <cfdump var="#MesInicAnt#">--->
		<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="2052" default="0" returnvariable="varDiasAguinaldo"/>

		<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="80" default="0" returnvariable="FactorDiasMensual"/>
			
        <cfquery name="rsDatosEmpleado" datasource="#session.DSN#">
        	insert into #SReporteSDI# (MtoSDIAnterior,DEid,DEidentificacion,Nombre,ingreso, AnnosAntiguedad,DiasBimestre,
					DiasBimestreFalta, DiasBimestreIncap, DiasBimestreLabor, SueldoDiario, MtoFactorIntegra, MtoIncidenciasIMSS,MtoSalario,RVid,DErespetaSBC)
            select distinct 0,  a.DEid, a.DEidentificacion,<cf_dbfunction name="concat"	args="a.DEapellido1,' ',a.DEapellido2,' ',a.DEnombre"> as Nombre
                , (select top 1 dle.DLfvigencia from DLaboralesEmpleado dle
					inner join RHTipoAccion ta on ta.RHTid = dle.RHTid
					and ta.RHTcomportam = 1
					and dle.DEid = a.DEid
					order by dle.DLfvigencia desc) as ingreso
                <!--- , <cf_dbfunction name="datediff"	args="c.EVfantig, #FFinalAnt# ,YYYY"> as annos --->
                 , CEILING((<cf_dbfunction name="datediff"	args="c.EVfantig, #FFinalAnt# ,dd">+1)/365.00) as annos
                 , <cf_dbfunction name="datediff"	args="#dateadd('m',-2,FInicio)# , #dateadd('m',-2,FFinal)# ,DD">+1  as DiasBimestre 
                , (select coalesce(sum(b.PEcantdias),0)
                        from HPagosEmpleado b
                            inner join RHTipoAccion c
                              on c.RHTid = b.RHTid
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                        where b.DEid = a.DEid
                            and c.RHTcomportam = 13 <!--- Ausencia / Falta --->
                            and b.PEtiporeg = 0	 	<!--- Tipo de Registro: 0 :Normal --->
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">

                        ) as DiasBimestreFalta

                   , (select coalesce(sum(b.PEcantdias),0)
                        from HPagosEmpleado b
                            inner join RHTipoAccion c
                              on c.RHTid = b.RHTid
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0 
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                        where b.DEid = a.DEid
                            and c.RHTcomportam = 5 <!--- Incapacidad --->
                            and b.PEtiporeg = 0	 	<!--- Tipo de Registro: 0 :Normal --->
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">

                        ) as DiasBimestreIncap

                   , (select coalesce(sum(b.PEcantdias),0)
                        from HPagosEmpleado b
                            inner join RHTipoAccion c
                              on c.RHTid = b.RHTid
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                        where b.DEid = a.DEid
                            and c.RHTcomportam not in (5,13) <!--- Incapacidad, Ausencia / Falta--->
                            and b.PEtiporeg = 0	 	<!--- Tipo de Registro: 0 :Normal --->
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">

                        ) as DiasBimestreLabor

                    , ( 
						<!--- (select dl.DLTmonto
                            from DLineaTiempo dl
                            inner join ComponentesSalariales c
                        	    on dl.CSid = c.CSid
                        	    and c.CSsalariobase = 1
                            where dl.LTid = b.LTid
                        ) --->
					(
							select 
								lt.DLsalario
							from
								DatosEmpleado de
							inner join DLaboralesEmpleado lt
								on de.DEid = lt.DEid
								and lt.Ecodigo = de.Ecodigo
								and lt.DLlinea = (	select max(lt2.DLlinea)
													from DLaboralesEmpleado lt2
													inner join RHTipoAccion ta 
														on ta.Ecodigo = lt2.Ecodigo 
														and lt2.RHTid = ta.RHTid
													where lt2.DEid = de.DEid
														and ta.RHTcomportam in (1,6,8)
												)
							where de.DEid = b.DEid
						)/tn.FactorDiasSalario)   as SueldoDiario

                    , ((365 <!---Dias de Sueldo--->

                    + #varDiasAguinaldo#<!--- Dias aguinaldo por parametro --->
                      <!--- (coalesce((select rv.DRVdiasgratifica
										from EVacacionesEmpleado Ev, LineaTiempo ltc, DRegimenVacaciones rv
										 where Ev.DEid = a.DEid
										 	<!---and Ev.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FInicioAnt#">	---->

											and ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and ltc.DEid = a.DEid
											<!---
											and ltc.LTdesde <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FInicioAnt#">
											and ltc.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#FFinalAnt#">
											--->
											and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#"> between ltc.LTdesde and ltc.LThasta
											and rv.RVid = ltc.RVid

											and rv.DRVcant = ( select coalesce(max(DRVcant),1)
																from DRegimenVacaciones rv2
																where rv2.RVid = ltc.RVid
																and rv2.DRVcant <= datediff(yy, Ev.EVfantig,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#">)
															)
                                         ),0)
                     ) --->

                     <!---Dias de Prima (Prima vacaional)--->
                  	 + (coalesce((select coalesce(rv.DRVdiasgratifica,0)
                                from EVacacionesEmpleado Ev,
								LineaTiempo ltc,
								DRegimenVacaciones rv
                                 where Ev.DEid = a.DEid
                                    and ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                    and ltc.DEid = a.DEid
                                    and #FFinalAnt# between b.LTdesde and b.LThasta
                                    and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#"> between ltc.LTdesde and ltc.LThasta
                                    and rv.RVid = ltc.RVid
                                    and rv.DRVcant = ( select coalesce(max(DRVcant),1)
                                                        from DRegimenVacaciones rv2
                                                        where rv2.RVid = ltc.RVid
                                                        and rv2.DRVcant <= datediff(yy, Ev.EVfantig,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#">)
                                                    )
                               ),0)/100 <!--- Si marca excepcion en esta linea se debe a la divicion entre 0 y es ocacionada
											  por que no esta configurada la tabla de Regimen de Vacaciones en RH  --->
                         )
                       ) / 365) <!---Dias de Sueldo--->
                      as MtoFactorIntegra
                   ,

                   <!---Calculo de la parte variable, monto por incidencias --->
				   <!--- Los incidencias excluidas tienen una validacion que dicta si
				   		 integra o no al SDI y son procesadas en validaIntegraExenta()
				   		 Dichas incidencias son configuradas en RH --> Conceptos de Pago.
				   --->
                    coalesce((select sum(ic.ICmontores)
                                    from HIncidenciasCalculo ic, CalendarioPagos cp, CIncidentes c
                                    where ic.CIid not in  (select  cs.CIid from  CIncidentes ci
                                    							inner join ComponentesSalariales cs
                                                                    on  ci.CIid = cs.CIid
                                                                  ) and	cp.CPperiodo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                                        and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                        and cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                        and ic.RCNid = cp.CPid
                                        and c.CIafectaSBC = 1
                                        and ic.CIid = c.CIid
                                        and a.DEid = ic.DEid
										and c.CIexencionSDI = 0 <!--- Diferente de Comedor empresa y Uso Gratuito casa habitacion --->
										and c.RHCSATid not in (select RHCSATid
														from RHCFDIConceptoSAT
														where RHCSATtipo = 'P'
														and RHCSATcodigo in ('030','010','049')) <!--- Diferente de:
																											 Vales de restaurante
																											 Premios por puntualidad
																											 Premios por asistencia
																								 --->
										),0) as MtoIMSS

                   ,

                   <!---(select coalesce(sum(b.SEsalariobruto),0)
                        from HSalarioEmpleado b
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0 <!--- Tipo de nomina Normal --->
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                        where b.DEid = a.DEid
                            and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">

                        ) --->
						(
							select 
								lt.DLsalario
							from
								DatosEmpleado de
							inner join DLaboralesEmpleado lt
								on de.DEid = lt.DEid
								and lt.Ecodigo = de.Ecodigo
								and lt.DLlinea = (	select max(lt2.DLlinea)
													from DLaboralesEmpleado lt2
													inner join RHTipoAccion ta 
														on ta.Ecodigo = lt2.Ecodigo 
														and lt2.RHTid = ta.RHTid
													where lt2.DEid = de.DEid
														and ta.RHTcomportam in (1,6,8)
												)
							where de.DEid = b.DEid
						)
						as MtoSalario,b.RVid,a.DErespetaSBC
            from DatosEmpleado a
                inner join LineaTiempo b
                    on a.DEid = b.DEid
                    <!---and b.LTdesde <= #FInicioAnt#
                    and b.LThasta >= #FFinalAnt#--->
                    and #FFinalAnt# between b.LTdesde and b.LThasta
                    <cfif isdefined('Arguments.Tcodigo')>
	                    and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Tcodigo#">
                    </cfif>
				inner join TiposNomina tn
					on b.Tcodigo = tn.Tcodigo
					and b.Ecodigo = tn.Ecodigo
                inner join EVacacionesEmpleado c
                    on a.DEid = c.DEid
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            <!---order by a.DEapellido1,a.DEapellido2, a.DEnombre--->
		</cfquery>
		
		<cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
			select * from #SReporteSDI#
		</cfquery>
		
		<cfloop query="rsDatosEmpleado">

			<cfset yearsDiff = DateDiff("yyyy",'#ingreso#','#FFinalAnt#')+1>

			<cfquery datasource="#session.dsn#" name="rsRV">
				select DRVdias,(DRVdiasprima) as DRVdiasprima
				from DRegimenVacaciones where DRVcant = #yearsDiff#
				and RVid = #RVid#
			</cfquery>

			<!--- 
				<cfset valTemp = (varDiasAguinaldo / 365)+((rsRV.DRVdias/365)*rsRV.DRVdiasprima)+1>
			--->
			<cfset valTemp = (365 + varDiasAguinaldo + rsRV.DRVdiasprima) / 365>

			<cfquery datasource="#session.dsn#">
				update #SReporteSDI# set MtoFactorIntegra = #valTemp# where DEid = #DEid#
			</cfquery>

			<cfinvoke component="rh.Componentes.RH_CalculoSDI" method="conceptosAdicionalesSDI" returnvariable="montoAdicional">
				<cfinvokeargument name="DEid" 			value="#DEid#"/>
			</cfinvoke>
			
			<cfquery datasource="#session.dsn#">
				update #SReporteSDI# 
				set SueldoDiario += #montoAdicional# 
				where DEid = #DEid#
			</cfquery>

		</cfloop>
		
        <!---SML. Inicio Dividir los Componentes de Tipo Especie para Que Integre IMSS--->
        <cfquery name = "rsMontoIncidenciasIMSS" datasource="#session.dsn#">
        	select DEid, MtoIncidenciasIMSS from #SReporteSDI#
        </cfquery>

		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
		ecodigo="#session.Ecodigo#" pvalor="80" default="0" returnvariable="DiasMensual"/>

		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
		ecodigo="#session.Ecodigo#" pvalor="2051" default="0" returnvariable="vUMA"/>

		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
		ecodigo="#session.Ecodigo#" pvalor="2052" default="0" returnvariable="vDiasAguinaldo"/>

		<cfset limite20Porciento = vUMA * 0.2 * DiasMensual>
		<cfset limite40Porciento = vUMA * 0.4 * DiasMensual>
		<cfset limite10Porciento = vUMA * 0.1 * DiasMensual>

		<cfset fechaInicial = LSDateFormat(createDate(PeriodoInicAnt,MesInicAnt,1),"YYYY-MM-dd")>

		<!--- Validacion para calculo bimestral Diciembre --->
		<cfif MesInicAnt+2 eq 13>
			<cfset fechaFinal = createDate(PeriodoInicAnt,12,31)>
			<cfset fechaFinal = LSDateFormat(fechaFinal,"YYYY-MM-dd")><!--- Ultimo dia del segundo mes --->
		<cfelse>
			<cfset fechaFinal = createDate(PeriodoInicAnt,MesInicAnt+2,1)>
			<cfset fechaFinal = LSDateFormat(dateAdd('d',-1,fechaFinal),"YYYY-MM-dd")><!--- Ultimo dia del segundo mes --->
		</cfif>
		<cfquery name="rsNominas" datasource="#session.dsn#">
			select RCNid from HRCalculoNomina cn
			where cn.RCdesde >= '#fechaInicial#'
			and cn.RChasta <= '#fechaFinal#' order by cn.RCdesde
		</cfquery>

		<cfloop query="rsNominas">
			<cfloop query="rsMontoIncidenciasIMSS">
				<cfset validaIntegraExenta(limite20Porciento,"030","097",0)><!--- Vales de restaurante --->
				<cfset validaIntegraExenta(limite20Porciento,"047","095",1)><!--- Alimentacion comedor empresa --->
				<cfset validaIntegraExenta(limite20Porciento,"048","096",2)><!--- Uso gratuito casa habitacion --->
				<cfset validaIntegraExenta(limite10Porciento,"010","",0)><!--- Premios por puntualidad --->
				<cfset validaIntegraExenta(limite10Porciento,"049","",0)><!--- Premios por asistencia --->
			</cfloop>
		</cfloop>

        <cfloop query="rsMontoIncidenciasIMSS">

	        <cfquery name="rsComponentesEspecieP" datasource="#session.dsn#">
				select sum(ic.ICmontores) as montoP
				from HIncidenciasCalculo ic,
					CalendarioPagos cp, CIncidentes c
				where
					ic.CIid in (select b.CIid
						from ComponentesSalariales a inner join CIncidentes b
						on b.CIid = a.CIid
	                    where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                    and CSsalarioEspecie = 1
	                    union
						select CIid
						from CIncidentes
	                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                    and CIespecie = 1)
	                and	cp.CPperiodo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
	                and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#">)
	                and cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	                and ic.RCNid = cp.CPid
	                <!---and c.CIafectaSBC = 1--->
	                and ic.CIid = c.CIid
	                and ic.ICmontores > 0
	                and ic.DEid = #rsMontoIncidenciasIMSS.DEid#
	        </cfquery>

	        <cfquery name="rsComponentesEspecieS" datasource="#session.dsn#">
				select sum(ic.ICmontores) as montoS
				from HIncidenciasCalculo ic,
					CalendarioPagos cp, CIncidentes c
				where
					c.CIid in  (select b.CIid
						from ComponentesSalariales a inner join CIncidentes b
	     				on b.CIid = a.CIid
						where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and CSsalarioEspecie = 1
						union
						select CIid from CIncidentes
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and CIespecie = 1)
					and	cp.CPperiodo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
					and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> + 1)
					and cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ic.RCNid = cp.CPid
					<!---and c.CIafectaSBC = 1--->
					and ic.CIid = c.CIid
					and ic.ICmontores > 0
					and ic.DEid = #rsMontoIncidenciasIMSS.DEid#
	        </cfquery>

	        <cfif rsComponentesEspecieP.montoP GT limite40Porciento>
	        	<cfset montoPGravable = rsComponentesEspecieP.montoP - limite40Porciento>
	        <cfelse>
	        	<cfset montoPGravable = 0>
	        </cfif>

	        <cfif rsComponentesEspecieS.montos GT limite40Porciento>
	        	<cfset montoSGravable = rsComponentesEspecieS.montoS - limite40Porciento>
	        <cfelse>
	        	<cfset montoSGravable = 0>
	        </cfif>

	        <cfquery name="rsMontoIMSS" datasource="#session.dsn#">
	        	update #SReporteSDI#
	        	set MtoIncidenciasIMSS =
					#rsMontoIncidenciasIMSS.MtoIncidenciasIMSS# + #montoPGravable# + #montoSGravable#
	            where DEid = #rsMontoIncidenciasIMSS.DEid#
	        </cfquery>

        </cfloop>

        <!---SML. Final Dividir los Componentes de Tipo Especie para Que Integre IMSS--->
        <!---Importe dias pagados del periodo--->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoDiasLaborados = MtoSalario
        </cfquery>
		
		<!--- Dias Posteriores inicio Bimestre --->
		<cfquery name="rsDiasDiffBimestre" datasource="#session.dsn#">
				select de.DEid,ufi.fechaingreso, 
				case when ufi.fechaingreso > #FInicioAnt# then DATEDIFF(DAY, #FInicioAnt#, ufi.fechaingreso) else 0 end  as diasDif
                from DLaboralesEmpleado de
                inner join 
                (
                   select DEid,max(DLfvigencia) fechaingreso 
                   from DLaboralesEmpleado
                   where RHTid = 1 and Ecodigo=#session.Ecodigo#
                   group by DEid
                ) ufi on de.DEid = ufi.DEid and de.DLfvigencia = ufi.fechaingreso
                where RHTid = 1
		</cfquery>

		<cfif rsDiasDiffBimestre.DEid neq ''>
			<cfquery name="rsDiasPosBimestre" datasource="#session.dsn#">
					update #SReporteSDI# set DiasPosBimestre = 
							#rsDiasDiffBimestre.diasDif#
					where DEid =  #rsDiasDiffBimestre.DEid#
			</cfquery>
		</cfif>

        <!---Sueldo gravable diario--->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoGravDiario = (case when (MtoIncidenciasIMSS / DiasBimestreLabor)>#vUMA#*25 then #vUMA#*25 else (MtoIncidenciasIMSS / DiasBimestreLabor)end)
        	where DiasBimestreLabor >0
		</cfquery>
		
         <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoGravDiario = 0
        	where DiasBimestreLabor = 0
        </cfquery>
		<!--- DiasBimestreIncap --->
		

		<!---SDI calculado = ((Factor Integracion * Salario diario) + Mto Gravable diario --->
		<cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSDICalculado = (case when DErespetaSBC=1 and DiasBimestreIncap>0 then 
			coalesce((
                    select RHHmonto
                        from RHHistoricoSDI
                        where Bimestrerige =  #vBimestreRige#
                        and RHHid = (select max(RHHid) from RHHistoricoSDI where Bimestrerige =  #vBimestreRige# and DEid = #SReporteSDI#.DEid)
                ),0) else case when (MtoFactorIntegra * SueldoDiario) < #vUMA#*25 then (MtoFactorIntegra * SueldoDiario) + MtoGravDiario else #vUMA#*25 end end)
		</cfquery>
		
		<cfquery name="rsparteFija" datasource="#session.dsn#">
			update #SReporteSDI# set MtoparteFija = (case when (MtoFactorIntegra * SueldoDiario) < #vUMA#*25 then (MtoFactorIntegra * SueldoDiario) else #vUMA#*25 end)
		</cfquery>
		
         <!---MtoSMGV Monto 25 VSMG vigente--->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSMGV = 25 * #vUMA#
        </cfquery>

        <!--- MtoSDITopado si MtoSDICalculado <=  MtoSMGV se usa MtoSDICalculado --->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSDITopado = case when MtoSDICalculado <= MtoSMGV then MtoSDICalculado else MtoSMGV end
        </cfquery>

        <cfquery name="sss" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSDIAnterior =
                coalesce((
                    select RHHmonto
                        from RHHistoricoSDI
                        where Bimestrerige =  #vBimestreRige#
                        and RHHid = (select max(RHHid) from RHHistoricoSDI where Bimestrerige =  #vBimestreRige# and DEid = #SReporteSDI#.DEid)
                ),0)
        </cfquery>

        <!---  Inicia el Redondeo del SDI Topado--->
        <cfquery name="rsMtoSDITopado" datasource="#session.dsn#">
         select DEid,MtoSDITopado from #SReporteSDI#
        </cfquery>

        <cfloop query="rsMtoSDITopado">
   			<cfset RedondearSDITopado = ''>
   			<cfset RedondearSDITopado = rsMtoSDITopado.MtoSDITopado * 100>
			<cfset RedondearSDITopado = Round(RedondearSDITopado)>
			<cfset RedondearSDITopado = RedondearSDITopado / 100>

      		<cfquery name="RedMtoSDITopado" datasource="#session.dsn#">
      			update #SReporteSDI# set MtoSDITopado =  #RedondearSDITopado# where DEid = #rsMtoSDITopado.DEid#
            </cfquery>

            <cfquery name= "SelMtoSDITopado" datasource="#session.dsn#">
            	select MtoSDITopado from #SReporteSDI#
            </cfquery>
        </cfloop>

        <!---Termina SDI Topado--->

      	<!---  Inicia el Redondeo del SDI Anterior--->

        <cfquery name="rsMtoSDIAnterior" datasource="#session.dsn#">
         select DEid, MtoSDIAnterior from #SReporteSDI#
        </cfquery>

        <cfloop query="rsMtoSDIAnterior">
			<cfset RedondearSDIAnterior = ''>
			<cfset RedondearSDIAnterior = rsMtoSDIAnterior.MtoSDIAnterior * 100>
			<cfset RedondearSDIAnterior = Round(RedondearSDIAnterior)>
			<cfset RedondearSDIAnterior = RedondearSDIAnterior / 100>

			<cfquery name="RedMtoSDIAnterior" datasource="#session.dsn#">
				update #SReporteSDI# set MtoSDIAnterior =  #RedondearSDIAnterior# where DEid = #rsMtoSDIAnterior.DEid#
			</cfquery>

			<cfquery name="SelMtoSDIAnterior" datasource="#session.dsn#">
				select MtoSDIAnterior from #SReporteSDI#
			</cfquery>
        </cfloop>

        <!---Termina--->

        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set Diferencias = MtoSDITopado - MtoSDIAnterior
        </cfquery>

        <!---Iniciar Validacion--->
        <cfquery name = "SelDiasFalta" datasource="#session.dsn#">
        	select DEid, MtoSDIAnterior, Diferencias from #SReporteSDI#
        </cfquery>

        <!---<cfdump var="#SelDiasFalta#">--->

        <cfloop query="SelDiasFalta">
			<cfif Diferencias EQ '0.01' or Diferencias EQ '-0.0100'>
	            <cfquery name="UpdMontoSDITopado" datasource="#session.dsn#">
	            	update #SReporteSDI# set MtoSDITopado =  #MtoSDIAnterior# where DEid = #SelDiasFalta.DEid#
	            </cfquery>
            </cfif>
        </cfloop>

 		<cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set Diferencias = MtoSDITopado - MtoSDIAnterior
        </cfquery>

        <cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
        	select * from #SReporteSDI#
        </cfquery>
		
		<cfreturn rsDatosEmpleado>

	</cffunction>
	<!--- OPARRALES 2017-07-26
		  En esta funcion se validan las incidencias de:
		  		-Comedor de la empresa
		  		-Uso gratuito casa habitacion
		  		-Vales para restaurante
		  		-Premios por puntualidad
		  		-Premios pos asistencia
		  Cada uno de estas incidencias se obtiene por su codigo
		  asignado por parte del SAT.
		  Segun la validacion se decide si integra o exenta al
		  calculo del SDI.
	 --->
	<cffunction name="validaIntegraExenta" access="public" output="false">
		<cfargument name="limite"	   type="numeric" required="true">
		<cfargument name="codigoP" 	   type="string"  required="true">
		<cfargument name="codigoD" 	   type="string"  required="true">
		<cfargument name="ExencionSDI" type="numeric" required="true">

		<cfquery name="rsDeduccion" datasource="#session.dsn#">
			select
				dede.Dvalor
			from
				HDeduccionesCalculo dc
				,DeduccionesEmpleado dede
				,TDeduccion td
				,RHCFDIConceptoSAT csat
			where
				dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNominas.RCNid#">
				and dc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMontoIncidenciasIMSS.DEid#">
				and	dc.Did = dede.Did
				and dc.DEid=dede.DEid
				and dede.TDid = td.TDid
				and td.RHCSATid = csat.RHCSATid
				and csat.RHCSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.codigoD#"> <!--- DEDUCCION --->
		</cfquery>

		<cfquery name="rsPercepcion" datasource="#session.dsn#">
			select
				hci.ICmontores
			from
				HIncidenciasCalculo hci,
				CIncidentes ci,
				RHCFDIConceptoSAT csat
			where
				hci.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNominas.RCNid#">
				and hci.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMontoIncidenciasIMSS.DEid#">
				and hci.CIid = ci.CIid
				and ci.CIexencionSDI = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ExencionSDI#">
				and ci.RHCSATid = csat.RHCSATid
				and csat.RHCSATcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.codigoP#"><!--- PERCEPCION --->
		</cfquery>

		<cfif (rsDeduccion.RecordCount eq 0 and Arguments.codigoD neq '') <!--- No existe Deduccion y la percepcion es 100% gravable --->
			or (rsDeduccion.RecordCount gt 0 and rsDeduccion.Dvalor lt Arguments.limite)<!--- Si existe Deduccion y es menor al limite es 100% gravable  --->
			or (Arguments.codigoD eq "" and rsPercepcion.RecordCount gt 0 and rsPercepcion.ICmontores lte Arguments.limite)><!--- Aqui solo importa la Percepcion y que sea menor o igual al limite para ser 100% gravable--->
			<cfquery name="rsMontoIMSS" datasource="#session.dsn#">
	        	update #SReporteSDI#
	        	set MtoIncidenciasIMSS =
					#rsMontoIncidenciasIMSS.MtoIncidenciasIMSS# + #rsPercepcion.ICmontores eq '' ? 0 : rsPercepcion.ICmontores#
	            where DEid = #rsMontoIncidenciasIMSS.DEid#
	        </cfquery>
		</cfif>

	</cffunction>

	<cffunction  name="getFInicio" access="public" output="false">
		<cfargument name="mes"	   type="numeric" required="true">
		<cfargument name="periodo" type="numeric" required="true">

		<cfquery name="rsFInicio" datasource="#session.dsn#">
			select top 1 CPdesde from CalendarioPagos 
			  where Ecodigo=#session.Ecodigo# and CPperiodo=#Arguments.periodo#  
			  and cpmes=#Arguments.mes# order by CPdesde asc
		</cfquery>

		<cfreturn rsFInicio.CPdesde>
	</cffunction>

	<cffunction  name="getFFin" access="public" output="false">
		<cfargument name="mes"	   type="numeric" required="true">
		<cfargument name="periodo" type="numeric" required="true">

		<cfquery name="rsFFin" datasource="#session.dsn#">
  			select top 1 CPhasta from CalendarioPagos 
			  where Ecodigo=#session.Ecodigo# and CPperiodo=#Arguments.periodo# 
			  and cpmes=#Arguments.mes#+1 order by CPhasta desc
		</cfquery>

		<cfreturn rsFFin.CPhasta>
	</cffunction>

</cfcomponent>