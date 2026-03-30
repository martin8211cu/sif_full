<cfcomponent>
	<cffunction name="CargarDatos" access="public" returntype="query">
		<cfargument name="FInicio" 		type="date" 	required="no">
        <cfargument name="FFinal"  		type="date" 	required="no">
        <cfargument name="MesInic"  	type="numeric" 	required="no">
        <cfargument name="PeriodoInic"  type="numeric" 	required="no">
        <cfargument name="Tcodigo"  	type="string" 	required="no">
        <cfargument name="InsertHSDI"  	type="string" 	required="no">
		<cfargument name="ValidaOfiOEmp"  	type="string" 	required="no">
		<cfargument name="RegistroPatronal"  	type="string" 	required="no">

        <cfset FInicioAnt 	=  #arguments.FInicio#>
        <cfset FFinalAnt 	= dateadd('m',2,#arguments.FInicio#)>
        <cfset FFinalAnt 	= dateadd('d',-1,#FFinalAnt#)>

        <cfset MesInicAnt 	= datepart('m', #FInicioAnt#)>
        <cfset PeriodoInicAnt 	= datepart('yyyy', #FInicioAnt#)>
	<!-- 	<cfif not isDefined ('form.ValidaOfiOEmp')> -->
<!-- 			<cfset ValidaOfiOEmp = ""> -->
<!-- 		</cfif> -->
<!---
        FFinalAnt<cfdump var="#FFinalAnt#">
        MesInicAnt<cfdump var="#MesInicAnt#">
        PeriodoInicAnt<cfdump var="#PeriodoInicAnt#">

        --->


        <!---ljimenez variables para el calculo de SDI bimestre Anterior

        <cfset FInicioAnt1 	=   dateadd('m',-2,#arguments.FInicio#) >
        <cfset FFinalAnt1 	= dateadd('m',2,#FInicioAnt1#)>
        <cfset FFinalAnt1 	= dateadd('d',-1,#FFinalAnt1#)>


        <cfset MesInicAnt1 	= datepart('m', #FInicioAnt1#)>
        <cfset PeriodoInicAnt1 	= datepart('yyyy', #FInicioAnt1#)>
        --->
        <cfdump var="#FFinalAnt#">

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
            <cf_dbtempcol name="NSS"  					type="varchar(60)"  	mandatory="no">
            <cf_dbtempcol name="CURP"  					type="varchar(20)"  	mandatory="no">
            <cf_dbtempcol name="RegPatron" 				type="varchar(20)"  	mandatory="no">
            <cf_dbtempcol name="NombreCompleto"			type="varchar(255)"		mandatory="no">
            <cf_dbtempcol name="Nombres"				type="varchar(255)"		mandatory="no">
            <cf_dbtempcol name="ApePat"					type="varchar(255)"		mandatory="no">
            <cf_dbtempcol name="ApeMat"					type="varchar(255)"		mandatory="no">
            <cf_dbtempcol name="ingreso" 				type="datetime" 		mandatory="no">
            <cf_dbtempcol name="AnnosAntiguedad"		type="int" 				mandatory="no">
            <cf_dbtempcol name="Fechadesde" 			type="datetime" 		mandatory="no">
            <cf_dbtempcol name="MtoFactorIntegra"		type="money" 			mandatory="no">
            <cf_dbtempcol name="DiasBimestre"			type="int" 				mandatory="no">
            <cf_dbtempcol name="DiasBimestreLabor"		type="int" 				mandatory="no">
            <cf_dbtempcol name="DiasBimestreFalta"		type="int" 				mandatory="no">
            <cf_dbtempcol name="DiasBimestreIncap"		type="int" 				mandatory="no">
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
        </cf_dbtemp>

     <!--- <cfquery name="rsRegistro" datasource="#session.dsn#"> --->
<!--- 		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor  from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300 --->
<!--- 	</cfquery> --->
<!--- 	<cfset RegistroPatronal = #rsRegistro.Pvalor#>    --->


       <!--- MesInicAnt: <cfdump var="#MesInicAnt#">--->

        <cfquery name="rsDatosEmpleado" datasource="#session.DSN#">
        	insert into #SReporteSDI# (MtoSDIAnterior,DEid,DEidentificacion ,NSS,CURP,Fechadesde
            ,NombreCompleto,Nombres,ApePat,ApeMat,ingreso, AnnosAntiguedad,DiasBimestre,
					DiasBimestreFalta, DiasBimestreIncap, DiasBimestreLabor, SueldoDiario, MtoFactorIntegra, MtoIncidenciasIMSS,MtoSalario )
            select distinct 0,  a.DEid, a.DEidentificacion,  ltrim(rtrim(a.DESeguroSocial)),a.CURP ,LTdesde
            ,<cf_dbfunction name="concat"	args="a.DEapellido1,' ',a.DEapellido2,' ',a.DEnombre"> as NombreCompleto
            ,ltrim(rtrim(a.DEnombre)),ltrim(rtrim(a.DEapellido1)),ltrim(rtrim(a.DEapellido2))
                , c.EVfantig as ingreso
                 , <cf_dbfunction name="datediff"	args="c.EVfantig, #FFinalAnt# ,YYYY"> as annos
                 , <cf_dbfunction name="datediff"	args="#FInicioAnt#, #FFinalAnt# ,DD"> +1  as DiasBimestre
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
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> + 1 )
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
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1 )
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                        where b.DEid = a.DEid
                            and c.RHTcomportam not in (5,13) <!--- Incapacidad, Ausencia / Falta--->
                            and b.PEtiporeg = 0	 	<!--- Tipo de Registro: 0 :Normal --->
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">

                        ) as DiasBimestreLabor

                    , ( (select dl.DLTmonto
                        from DLineaTiempo dl
                        inner join ComponentesSalariales c
                        	on dl.CSid = c.CSid
                        	and c.CSsalariobase = 1
                        where dl.LTid = b.LTid
                    )/30)   as SueldoDiario

                    , ((365 <!---Dias de Sueldo--->

                    + <!---Dias de Gratificacion--->
                      (coalesce((select rv.DRVdiasgratifica
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
                     )

                     <!---Dias de Prima (Prima vacaional)--->
                  	 + (coalesce((select rv.DRVdiasprima
                                from EVacacionesEmpleado Ev, LineaTiempo ltc, DRegimenVacaciones rv
                                 where Ev.DEid = a.DEid
                                 	<!--- and Ev.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FInicioAnt#">	----->

                                    and ltc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                    and ltc.DEid = a.DEid
                                    <!---
                                    and ltc.LTdesde <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FInicioAnt#">
                                    and ltc.LThasta >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#">
                                    --->
                                    and #FFinalAnt# between b.LTdesde and b.LThasta

                                    and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#"> between ltc.LTdesde and ltc.LThasta
                                    and rv.RVid = ltc.RVid

                                    and rv.DRVcant = ( select coalesce(max(DRVcant),1)
                                                        from DRegimenVacaciones rv2
                                                        where rv2.RVid = ltc.RVid
                                                        and rv2.DRVcant <= datediff(yy, Ev.EVfantig,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FFinalAnt#">)
                                                    )
                               ),0)
                         )
                       ) / 365) <!---Dias de Sueldo--->
                      as MtoFactorIntegra
                   ,

                   <!---Calculo de la parte variable, monto por incidencias --->
                    coalesce((select sum(ic.ICmontores)
                                    from HIncidenciasCalculo ic, CalendarioPagos cp, CIncidentes c
                                    where ic.CIid not in  (select  cs.CIid from  CIncidentes ci
                                    							inner join ComponentesSalariales cs
                                                                    on  ci.CIid = cs.CIid
                                                                  )                                        and	cp.CPperiodo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                                        and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                        and cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                        and ic.RCNid = cp.CPid
                                        and c.CIafectaSBC = 1
                                        and ic.CIid = c.CIid
                                        and a.DEid = ic.DEid),0) as MtoIMSS

                   ,

                   (select coalesce(sum(b.SEsalariobruto),0)
                        from HSalarioEmpleado b
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0 <!--- Tipo de nomina Normal --->
                                and d.CPmes	in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#MesInicAnt#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PeriodoInicAnt#">
                        where b.DEid = a.DEid
                            and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">

                        ) as MtoSalario


            from DatosEmpleado a
                inner join LineaTiempo b
                    on a.DEid = b.DEid
                    <!---and b.LTdesde <= #FInicioAnt#
                    and b.LThasta >= #FFinalAnt#--->
                    and #FFinalAnt# between b.LTdesde and b.LThasta
                    <cfif isdefined('Arguments.Tcodigo')>
	                    and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Tcodigo#">
                    </cfif>
                inner join EVacacionesEmpleado c
                    on a.DEid = c.DEid
				<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
				<cfif ValidaOfiOEmp eq "1">
	    			inner join oficinas o
					on o.Ocodigo = b.Ocodigo
				</cfif>
				<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			<cfif ValidaOfiOEmp eq "1">
				and o.Onumpatronal = '#RegistroPatronal#'
			</cfif>
            <!---order by a.DEapellido1,a.DEapellido2, a.DEnombre--->
        </cfquery>
        <!---Importe dias pagados del periodo--->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoDiasLaborados = MtoSalario
        </cfquery>

        <!---Sueldo gravable diario--->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoGravDiario = MtoIncidenciasIMSS / DiasBimestreLabor
        	where DiasBimestreLabor >0
        </cfquery>

         <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoGravDiario = 0
        	where DiasBimestreLabor = 0
        </cfquery>

        <!---SDI calculado = ((Factor Integracion * Salario diario) + Mto Gravable diario --->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSDICalculado = ((MtoFactorIntegra * SueldoDiario) + MtoGravDiario)
        </cfquery>

        <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
				ecodigo="#session.Ecodigo#" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>

         <!---MtoSMGV Monto 25 VSMG vigente--->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSMGV = 25 * #SZEsalarioMinimo#
        </cfquery>

        <!---MtoSDITopado si MtoSDICalculado <=  MtoSMGV se usa MtoSDICalculado --->
        <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set MtoSDITopado = case when MtoSDICalculado <= MtoSMGV then MtoSDICalculado else MtoSMGV end
        </cfquery>

        <!---<cf_dumptable var="#SReporteSDI#">--->

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

        <cflog file="nuevoDos" text="linea 297: Inicia el Redondeo del SDI Topado">
        <cfloop query="rsMtoSDITopado">

        		<cfset RedondearSDITopado = ''>
                <cflog file="nuevoDos" text="linea 301: RedondearSDITopado = #RedondearSDITopado#, MtoSDITopado = #rsMtoSDITopado.MtoSDITopado#">
        		<cfset RedondearSDITopado = rsMtoSDITopado.MtoSDITopado * 100>
				<cfset RedondearSDITopado = Round(RedondearSDITopado)>
				<cfset RedondearSDITopado = RedondearSDITopado / 100>

                <cflog file="nuevoDos" text="linea 306: RedondearSDITopado = #RedondearSDITopado#">

        		<cfquery name="RedMtoSDITopado" datasource="#session.dsn#">
        		update #SReporteSDI# set MtoSDITopado =  #RedondearSDITopado# where DEid = #rsMtoSDITopado.DEid#
                </cfquery>

                <cfquery name= "SelMtoSDITopado" datasource="#session.dsn#">
                select MtoSDITopado from #SReporteSDI#
                </cfquery>

                <cflog file="nomina" text="linea 316: MtoSDITopado = #SelMtoSDITopado.MtoSDITopado#">

        </cfloop>

        <!---Termina SDI Topado--->

        <cflog file="nomina" text="linea 322: Inicia el Redondeo del SDI Anterior">
      	<!---  Inicia el Redondeo del SDI Anterior--->

        <cfquery name="rsMtoSDIAnterior" datasource="#session.dsn#">
         select DEid, MtoSDIAnterior from #SReporteSDI#
        </cfquery>

        <cfloop query="rsMtoSDIAnterior">

        		<cfset RedondearSDIAnterior = ''>
                <cflog file="nuevoDos" text="linea 332: RedondearSDIAnterior = #RedondearSDIAnterior#, MtoSDIAnterior = #rsMtoSDIAnterior.MtoSDIAnterior#">

        		<cfset RedondearSDIAnterior = rsMtoSDIAnterior.MtoSDIAnterior * 100>
				<cfset RedondearSDIAnterior = Round(RedondearSDIAnterior)>
				<cfset RedondearSDIAnterior = RedondearSDIAnterior / 100>

                <cflog file="nuevoDos" text="linea 338: RedondearSDIAnterior = #RedondearSDIAnterior#">

        		<cfquery name="RedMtoSDIAnterior" datasource="#session.dsn#">
        		update #SReporteSDI# set MtoSDIAnterior =  #RedondearSDIAnterior# where DEid = #rsMtoSDIAnterior.DEid#
                </cfquery>

				<cfquery name="SelMtoSDIAnterior" datasource="#session.dsn#">
         		select MtoSDIAnterior from #SReporteSDI#
        		</cfquery>

                <cflog file="nuevoDos" text="linea 348: MtoSDIAnterior = #SelMtoSDIAnterior.MtoSDIAnterior#">

        </cfloop>

        <!---Termina--->

         <cfquery name="rsDiasFalta" datasource="#session.dsn#">
        	update #SReporteSDI# set Diferencias = MtoSDITopado - MtoSDIAnterior
        </cfquery>

		<cfquery  name="upRegPat" datasource="#session.dsn#">
        	update #SReporteSDI# set regPatron = '#RegistroPatronal#'
        </cfquery>

        <cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
        	select * from #SReporteSDI#
            where MtoSDIAnterior <> MtoSDICalculado
            and Diferencias not in (0.00,0.01,-0.01)
           <!--- and DEidentificacion=1658--->
        </cfquery>

       <!---<cfdump var="#rsDatosEmpleado#">--->
		<cfreturn rsDatosEmpleado>
	</cffunction>


</cfcomponent>