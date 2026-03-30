	<!--- Tabla temporal de resultados --->
	<cf_dbtemp name="salidaDNomina" returnvariable="salidaDNomina">
		<cf_dbtempcol name="DEid"     		type="int"          mandatory="yes">
        <cf_dbtempcol name="Identificacion"	type="char(50)"     mandatory="no">
        <cf_dbtempcol name="Nombre"   		type="char(100)"     mandatory="no">
        <cf_dbtempcol name="Ape1"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="Ape2"   		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="SDI"			type="money"     	mandatory="no">
        <cf_dbtempcol name="FechaAlta" 		type="datetime"     mandatory="no">
        <cf_dbtempcol name="FechaHasta"		type="datetime"     mandatory="no">
        <cf_dbtempcol name="RFC"			type="char(20)"    	mandatory="no">
        <cf_dbtempcol name="CURP"			type="char(20)"    	mandatory="no">

		<cf_dbtempcol name="SalarioB" 		type="money"     	mandatory="no">
        <cf_dbtempcol name="SalarioRef"		type="money"     	mandatory="no">

        <cf_dbtempcol name="TotIncidencias"	type="money"     	mandatory="no">
        <cf_dbtempcol name="TotDeducciones"	type="money"     	mandatory="no">
        <cf_dbtempcol name="TotPagado"		type="money"     	mandatory="no">
        <cf_dbtempcol name="TotPercepciones"type="money"     	mandatory="no">

        <cf_dbtempcol name="TotCargas"		type="money"     	mandatory="no">
        <cf_dbtempcol name="TotISPT"		type="money"     	mandatory="no">
        <cf_dbtempcol name="TotSubsidio"	type="money"     	mandatory="no">
        <cf_dbtempcol name="TotOtrasDeducc"	type="money"     	mandatory="no">

        <cf_dbtempcol name="NetoEspecie"	type="money"     	mandatory="no">
        <cf_dbtempcol name="NetoEfectivo"	type="money"     	mandatory="no">
        <cf_dbtempcol name="MontoDeducc"	type="money"     	mandatory="no">

        <cf_dbtempcol name="DiasTrab"		type="money"     	mandatory="no">
        <cf_dbtempcol name="Jornada"		type="char(40)"    	mandatory="no">

		<cf_dbtempkey cols="DEid">
	</cf_dbtemp>


<cfset vSalarioEmpeleado 	= 'HSalarioEmpleado'>
<cfset vRCalculoNomina 		= 'HRCalculoNomina'>
<cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
<cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
<cfset vPagosEmpleado 		= 'HPagosEmpleado'>
<cfset vCargascalculo		= 'HCargasCalculo'>

<cfset idOficina = #codOficina#> <!--- código de la oficina --->
<!---<cfif isdefined('form.tiponomina')>
	<cfset vSalarioEmpeleado 	= 'HSalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'HRCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'HDeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'HIncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'HPagosEmpleado'>

<cfelse>
	<cfset vSalarioEmpeleado 	= 'SalarioEmpleado'>
    <cfset vRCalculoNomina 		= 'RCalculoNomina'>
    <cfset vDeduccionesCalculo 	= 'DeduccionesCalculo'>
    <cfset vIncidenciasCalculo 	= 'IncidenciasCalculo'>
    <cfset vPagosEmpleado 		= 'PagosEmpleado'>
</cfif>--->

<cfquery name="rsNomina" datasource="#session.DSN#">
	select RCNid, c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from HRCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	and a.Ecodigo = b.Ecodigo
</cfquery>

<!--- DATOS DE LA NOMINA ---->
<cfquery name="rsEmpleados" datasource="#session.DSN#">
	insert into #salidaDNomina# ( DEid, Identificacion, Nombre, Ape1,
            Ape2, CURP, RFC, SDI, FechaAlta,FechaHasta,TotISPT, NetoEfectivo,SalarioB, TotPagado, NetoEspecie, MontoDeducc,TotPercepciones )

	select a.DEid, a.DEidentificacion, a.DEnombre, a.DEapellido1,
            a.DEapellido2,  coalesce(a.CURP,'NDF'), coalesce(a.RFC,'NDF'), a.DEsdi,e.EVfantig, b.RChasta
            , d.SErenta, d.SEliquido,d.SEsalariobruto,0, d.SEespecie, 0, 0
    from HSalarioEmpleado d
        inner join DatosEmpleado a
            on d.DEid = a.DEid
        inner join HRCalculoNomina b
        	on d.RCNid = b.RCNid
        inner join EVacacionesEmpleado e
            on d.DEid = e.DEid
		<cfif idOficina gt 0>
			inner join LineaTiempo lt
			on lt.DEid = d.DEid
			inner join Oficinas o
			on o.Ocodigo = lt.Ocodigo
		</cfif>
	where d.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		<cfif idOficina gt 0>
		and o.Ocodigo = #idOficina#
		and (lt.LTdesde <= b.RChasta and lt.LThasta >= b.RChasta)
		</cfif>
</cfquery>

<!---actuliza la jornada--->
<cfquery name="rsJornada" datasource="#Session.DSN#">
	update #salidaDNomina# set Jornada =
                                   (select distinct RHJdescripcion
                                   from LineaTiempo lt
                                        inner join TiposNomina tn
                                             on lt.Tcodigo = tn.Tcodigo
                                             and lt.Ecodigo = tn.Ecodigo
                                        inner join RHJornadas j
                                            on lt.RHJid = j.RHJid
                                            and tn.Ecodigo = j.Ecodigo
                                   where lt.DEid = #salidaDNomina#.DEid
                                       and #salidaDNomina#.FechaHasta between lt.LTdesde and lt.LThasta)
</cfquery>

<!---Total Incidencias--->
<cfquery datasource="#session.dsn#">
   update #salidaDNomina#
		set TotIncidencias =  coalesce((select coalesce(sum(a.ICmontores),0)
                                    from #vIncidenciasCalculo# a
                                    where a.DEid = #salidaDNomina#.DEid
                                        and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
                                        and CIid  in (select distinct a.CIid
                                                from RHReportesNomina c
                                                    inner join RHColumnasReporte b
                                                                inner join RHConceptosColumna a
                                                                on a.RHCRPTid = b.RHCRPTid
                                                         on b.RHRPTNid = c.RHRPTNid
                                                        and b.RHCRPTcodigo = 'TotIncidenci'	<!---Total Incidencias--->
                                                where c.RHRPTNcodigo = 'MX003'				<!--- Codigo Reporte Dinamico --->
                                                  and c.Ecodigo = #session.Ecodigo#)),0)
</cfquery>

<!---Total Cargas IMSS--->
<cfquery datasource="#session.dsn#" name="UpdCargaIMSSo">
    update #salidaDNomina#
    set TotCargas =
    coalesce((
    select sum(a.CCvaloremp) from #vCargascalculo# a, CargasEmpleado b
                where a.DEid = #salidaDNomina#.DEid
                        and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
                        and a.DEid = b.DEid
                        and a.DClinea = b.DClinea
                        and b.DClinea  in (select distinct a.DClinea
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'TotCargas' 	<!---Total Cargas IMSS--->
                            where c.RHRPTNcodigo = 'MX003'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---actualiza el valor del subsidio al salario--->
<cfquery datasource="#session.dsn#" name="UpdSubsidio">
    update #salidaDNomina#
    set TotSubsidio =
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b
                where a.DEid = #salidaDNomina#.DEid
                        and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'TotSubsidio' 	<!---Subsidio al salario MEX--->
                            where c.RHRPTNcodigo = 'MX003'				<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Total Otras Deducciones--->
<cfquery datasource="#session.dsn#" >
    update #salidaDNomina#
    set TotOtrasDeducc =
    coalesce((
    select sum(a.DCvalor) from #vDeduccionesCalculo# a, DeduccionesEmpleado b
                where a.DEid = #salidaDNomina#.DEid
                        and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
                        and a.DEid = b.DEid
                        and a.Did = b.Did
                        and b.TDid  in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = 'TotOtrasDedu' 	<!---Total Otras Deducciones--->
                            where c.RHRPTNcodigo = 'MX003'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
                        ),0)
</cfquery>

<!---Actuliza Total de Deducciones --->
<cfquery datasource="#session.dsn#" name="UpdInfonaSMG">
    update #salidaDNomina#
    set TotDeducciones = TotOtrasDeducc + TotCargas + TotISPT + TotSubsidio
</cfquery>


<!---Actualiza TotPercepciones--->
<cfquery datasource="#session.dsn#" >
    update #salidaDNomina#	set TotPercepciones = TotIncidencias + NetoEspecie + SalarioB
</cfquery>

<!---Actualiza TotPagado--->
<cfquery datasource="#session.dsn#" >
    update #salidaDNomina#	set TotPagado = TotPercepciones - TotDeducciones
</cfquery>

<!---Actualiza TotPercepciones
<cfquery datasource="#session.dsn#" >
    update #salidaDNomina#	set
                              TotPercepciones 	= TotIncidencias + TotPagado + SalarioB
                        	, MontoDeducc 		= TotDeducciones
                            , NetoEspecie 		= (TotIncidencias ) - (TotOtrasDeducc + TotCargas + TotISPT)
</cfquery>

--->


<!---Actualiza dias trabajados--->
<cfquery datasource="#session.dsn#" >
    update #salidaDNomina#	set
                              DiasTrab 	= coalesce(
                              (select sum(b.PEcantdias)
                                from HSalarioEmpleado a
                                    inner join HPagosEmpleado b
                                        on a.DEid = b.DEid
                                        and a.RCNid = b.RCNid
                                    inner join RHTipoAccion c
                                        on b.RHTid = c.RHTid
                                        and c.RHTcomportam not in (3,13)
                                where a.DEid = #salidaDNomina#.DEid
                                and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">),0)
</cfquery>

<!---Actualiza salario Referencia--->
<cfquery datasource="#session.dsn#" >
    update #salidaDNomina#	set
                              SalarioRef 	=
                              coalesce((select d.DLTmonto
                                        from LineaTiempo l
                                            inner join DLineaTiempo d
                                           		on l.LTid = d.LTid
                                            inner join ComponentesSalariales c
                                                on d.CSid = c.CSid
                                                and CSsalariobase = 1
                                        where l.DEid = #salidaDNomina#.DEid
                                            and #salidaDNomina#.FechaHasta between l.LTdesde and l.LThasta
                                        ),0)
</cfquery>

<!---<cf_dumptable var="#salidaDNomina#">--->

<cfinclude template="ReporteNominaSueldos-Rep.cfm">
