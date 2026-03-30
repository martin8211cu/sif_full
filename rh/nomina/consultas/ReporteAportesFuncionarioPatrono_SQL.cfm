<!---IMPORTANTE: Cualquier cambio que se genere en este fuente afectará dos reportes: Reporte de Aguinaldo y Reporte de Aguinaldo por Mes-Periodo, ambos deben probarse al hacer un cambio al fuente--->
<cfparam name="url.GrupaMesPeriodo" default="0">
<cfparam name="form.GrupaMesPeriodo" default="#url.GrupaMesPeriodo#">
<cfparam name="url.ListaDEidEmpleado1" default="0">
<cfparam name="url.DEid" default="#url.ListaDEidEmpleado1#">

<cfsetting requesttimeout="3600">

<!---2014-0926 ljimenez se crea tempora para sacar los empleados con  los que vamos a trabajar el reporte
sacamos todos los empleados que que tengan fecha de antiguedad entre los rangos de fechas del filtro
y adicionalmente no tengan una liquidacion aplicada en una fecha superior a la antiguedad ya que de ser asi 
el aguinaldo ya fue cancelado en la liquidacion
- se marcan los emplado como vigente (1) y no vigentes (0) segun la linea del tiempo y las fecha hasta del filtro--->

<cf_dbtemp name="EmpReporte08" returnvariable="EmpleadosAcumulados" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid" 		type="numeric"	mandatory="yes">
	<cf_dbtempcol name="fingreso" 	type="datetime"	mandatory="no">
	<cf_dbtempcol name="vigente" 	type="numeric"	mandatory="no">
	<cf_dbtempcol name="liquidado" 	type="numeric"	mandatory="no">
</cf_dbtemp>

<cfquery datasource="#session.DSN#">
	insert into #EmpleadosAcumulados# (DEid, fingreso, vigente,liquidado)
        (select ev.DEid, ev.EVfantig
        ,  coalesce((select distinct 1
					from DLaboralesEmpleado a
					inner join RHTipoAccion b
					on b.RHTid = a.RHTid
					and b.RHTcomportam = 1
					where a.DEid = ev.DEid
					and a.DLfvigencia >= (select coalesce(max(a.DLfvigencia),'19000101')
										from DLaboralesEmpleado a
										inner join RHTipoAccion b
										on b.RHTid = a.RHTid
										and b.RHTcomportam = 2
										where a.DEid = ev.DEid
										)
				),0) as vigente
        ,  coalesce((select distinct 1
            from DLaboralesEmpleado a
            inner join RHTipoAccion b
            on b.RHTid = a.RHTid
            and b.RHTcomportam = 2
            where a.DEid = ev.DEid
            and a.DLfvigencia >= (select coalesce(max(a.DLfvigencia),'19000101')
                                from DLaboralesEmpleado a
                                inner join RHTipoAccion b
                                    on b.RHTid = a.RHTid
                                        and b.RHTcomportam = 2
                                where a.DEid = ev.DEid
                                    and exists  (select 1 
                                                 from RHLiquidacionPersonal l
                                                 where l.DLlinea = a.DLlinea
                                                 and l.RHLPestado = 1)
                                                )
			<!--- Se verifica que no exista un nombramiento posterior a  la ultima liquidacion aplicada  --->
            and not exists  (select distinct 1
	                        from DLaboralesEmpleado a1
	                        inner join RHTipoAccion b1
	                        on b1.RHTid = a1.RHTid
	                        and b1.RHTcomportam = 1
	                        where a1.DEid = ev.DEid
	                        and a1.DLfvigencia >= a.DLfvigencia)
        ),0) as Liquidado 
        from EVacacionesEmpleado ev
        inner join DatosEmpleado de
        	on de.DEid = ev.DEid
        	and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		<cfif isdefined("url.Fhasta") and len(trim(url.Fhasta)) gt 0 >
			and ev.EVfantig <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fhasta)#">
        </cfif>
		<cfif isdefined("url.DEid") and len(trim(url.DEid)) gt 0 and url.DEid NEQ 0>
			and ev.DEid in (#url.DEid#) <!---se modifica ya que actualmente puedo hacer la consulta para una lista de empleados--->
		</cfif>
        )
</cfquery>

<cfquery datasource="#session.DSN#">
	delete from  #EmpleadosAcumulados# where liquidado = 1
</cfquery>

<!------------------------------------------------------------------------------------------------->

<cf_dbtemp name="acumempleado" returnvariable="acumempleado" datasource="#session.dsn#">
	<cf_dbtempcol name="RCNid" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="DEid" 		type="numeric"	mandatory="yes">
	<cf_dbtempcol name="DClinea" 	type="numeric"	mandatory="no">
	<cf_dbtempcol name="fdesde" 	type="datetime"	mandatory="no">
	<cf_dbtempcol name="fhasta" 	type="datetime"	mandatory="no">
	<cf_dbtempcol name="dia" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="mes" 		type="numeric"	mandatory="no">
	<cf_dbtempcol name="periodo" 	type="numeric"	mandatory="no">
	<cf_dbtempcol name="codigo" 	type="varchar(200)"	mandatory="no">
	<cf_dbtempcol name="MontoEmp" 	type="money"	mandatory="yes">
	<cf_dbtempcol name="MontoPat" 	type="money"	mandatory="yes">
	<cf_dbtempcol name="MontoFinal"	type="money"	mandatory="no">
	<cf_dbtempcol name="vigente" 	type="numeric"	mandatory="no">
	<cf_dbtempcol name="tipocambio"	type="money"	mandatory="no">	<!---- el tipo de cambio se tomará de la última nómina finaliza---->
</cf_dbtemp>

<cf_dbfunction name="op_concat" returnvariable="concat">
<cf_dbfunction name="date_part"	args="dd, dac.DACEffin" 	returnvariable="vDia">
<cf_dbfunction name="date_part"	args="mm, dac.DACEffin" 	returnvariable="vMes">
<cf_dbfunction name="date_part"	args="yyyy, dac.DACEffin"  	returnvariable="vAnio">
<cf_dbfunction name="to_char"	args="#vDia#"   returnvariable="vDiaChar">
<cf_dbfunction name="to_char"	args="#vMes#"   returnvariable="vMesChar">
<cf_dbfunction name="to_char"	args="#vAnio#"  returnvariable="vAnioChar">

<cfparam name="url.ListaTipoNomina1" default="">
<cfparam name="url.ListaTipoNomina" default="#url.ListaTipoNomina1#">

 <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
 ecodigo="#session.Ecodigo#" pvalor="2820" default="" returnvariable="lvarConfig"/>

<!--- Inserta los montos provisonados Patrono y Empleado Históricos---> 
<cfquery  datasource="#session.DSN#" name="rstemp">
	insert into #acumempleado# (RCNid, DEid, DClinea, fdesde, fhasta,dia,mes,periodo,codigo, MontoEmp,MontoPat)
	select 
		dac.RCNid, 
		dac.DEid, 
		dac.DClinea,
		dac.DACEfinicio,
		dac.DACEffin,
		#vDia#,
		#vMes#,
		#vAnio#,
		<!---<cfif isdefined("url.PorFechas")>
			case when #vMes# < 10 then 	'0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# 
			else #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# end
			as codigo,
		<cfelse>--->
			case when #vDia# < 10 and #vMes# < 10 
					then 	'0' #concat# #vDiaChar# #concat# '-' #concat# '0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# 
				when #vDia# < 10 and #vMes# > 9  
					then	'0' #concat# #vDiaChar# #concat# '-' #concat# '0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar#
				when #vDia# > 9  and #vMes# < 10 
					then 	#vDiaChar# #concat# '-' #concat# '0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar#
			else #vDiaChar# #concat# '-' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# end
			as codigo,
		<!---</cfif>--->
		dac.DACEvaloremp,
		dac.DACEvalorpat
	from DACargasEmpleado dac
		inner join EACargasEmpleado eac
			on eac.EACElote = dac.EACElote
        inner join CargasEmpleado ce
            on ce.DClinea  = dac.DClinea
            and dac.DACEfinicio >= ce.CEdesde
            and dac.DEid=ce.DEid         
		inner join #EmpleadosAcumulados# ea
        	on ea.DEid = dac.DEid
		inner join EVacacionesEmpleado eve
            on eve.DEid=dac.DEid
            and dac.DACEfinicio >= eve.EVfantig
	where eac.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	 and dac.DACEffin >= ea.fingreso <!--- se cambia ya que si los empleados ingresan a trab en medio de una nomina no son tomados en cuenta en el primer pago--->
     and dac.DClinea in (<cfqueryparam cfsqltype="cf_sql_numeric" list="true" value="#lvarConfig#">) 
	 <cfif isdefined("url.PorFechas")>
	 	<cfif isdefined("url.Fdesde") and len(trim(url.Fdesde))>
	 		and dac.DACEffin >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
		</cfif>
		<cfif isdefined("url.Fhasta") and len(trim(url.Fhasta))>
	  	and dac.DACEfinicio <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		</cfif>
     <cfelseif isdefined("url.ListaNomina") and len(trim(url.ListaNomina))>
	 	and dac.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ListaNomina#" list="yes">)
	 </cfif>  
</cfquery>



<cf_dbfunction name="date_part"	args="dd, a.RChasta" 	returnvariable="vDia">
<cf_dbfunction name="date_part"	args="mm, a.RChasta" 	returnvariable="vMes">
<cf_dbfunction name="date_part"	args="yyyy, a.RChasta"  returnvariable="vAnio">
<cf_dbfunction name="to_char"	args="#vDia#"   returnvariable="vDiaChar">
<cf_dbfunction name="to_char"	args="#vMes#"   returnvariable="vMesChar">
<cf_dbfunction name="to_char"	args="#vAnio#"  returnvariable="vAnioChar">

<!--- Inserta los montos provisonados Patrono y Empleado en Nóminas en Progreso---> 
<cfquery  datasource="#session.DSN#" name="rstemp">
	insert into #acumempleado# (RCNid, DEid, DClinea, fdesde, fhasta,dia,mes,periodo,codigo, MontoEmp,MontoPat)
	select 
		a.RCNid, 
		b.DEid, 
		b.DClinea,
		a.RCdesde,
		a.RChasta,
		#vDia#,
		#vMes#,
		#vAnio#,
		<!---<cfif isdefined("url.PorFechas")>
			case when #vMes# < 10 then 	'0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# 
			else #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# end
			as codigo,
		<cfelse>--->
			case when #vDia# < 10 and #vMes# < 10 
					then 	'0' #concat# #vDiaChar# #concat# '-' #concat# '0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# 
				when #vDia# < 10 and #vMes# > 9  
					then	'0' #concat# #vDiaChar# #concat# '-' #concat# '0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar#
				when #vDia# > 9  and #vMes# < 10 
					then 	#vDiaChar# #concat# '-' #concat# '0' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar#
			else #vDiaChar# #concat# '-' #concat# #vMesChar# #concat# '-' #concat# #vAnioChar# end
			as codigo,
		<!---</cfif>--->
		b.CCvaloremp,
		b.CCvalorpat
	
	from RCalculoNomina a 
		inner join CargasCalculo b
			on a.RCNid=b.RCNid	
		inner join #EmpleadosAcumulados# ea
        	on ea.DEid = b.DEid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	 and a.RChasta >= ea.fingreso <!--- se cambia ya que si los empleados ingresan a trab en medio de una nomina no son tomados en cuenta en el primer pago--->
     and b.DClinea in (<cfqueryparam cfsqltype="cf_sql_numeric" list="true" value="#lvarConfig#">) 
	 <cfif isdefined("url.PorFechas")>
	 	<cfif isdefined("url.Fdesde") and len(trim(url.Fdesde))>
	 		and a.RChasta >= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#">
		</cfif>
		<cfif isdefined("url.Fhasta") and len(trim(url.Fhasta))>
	  	and a.RCdesde <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		</cfif>
     <cfelseif isdefined("url.ListaNomina") and len(trim(url.ListaNomina))>
	 	and a.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ListaNomina#" list="yes">)
	 </cfif>  
</cfquery>

<!--- se actualiza el estado vigente con los empleado de la temporanl que ya estan identificados si son vigente o no --->
<cfquery name="Updatevig" datasource="#session.DSN#">
	update #acumempleado#
		set vigente = (select ea.vigente from #EmpleadosAcumulados# ea where ea.DEid = #acumempleado#.DEid)
</cfquery>

<cfquery name="Columnas" datasource="#session.DSN#">
	select distinct mes,periodo, codigo
    from #acumempleado#
	order by periodo,mes,codigo
</cfquery>

<!---- este sufijo se agrega en las columnas con group by para la descripción---->
<cfset suf=''>

<cfif isdefined('url.resumido') and url.resumido EQ '0'>
	<!--- Detallado --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 	e.DEapellido1 as DEapellido1,
           		e.DEapellido2 as DEapellido2,
           		e.DEnombre as DEnombre,
				e.DEidentificacion, 
				{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat( ' ',e.DEnombre)})})})} as Nombre,
				a.fhasta,
				a.codigo as Codigo, 
            	min(a.RCNid) as RCNid, 
				sum(a.MontoEmp) as MontoEmp,
				sum(a.MontoPat) as MontoPat, 
				e.DEid
		from #acumempleado# a
			
			inner join DatosEmpleado e
				on e.DEid = a.DEid
		<cfif isdefined('url.vigente') and len(trim(url.vigente)) >
			where a.vigente = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.vigente#" />
		</cfif>
		group by e.DEid,e.DEidentificacion,e.DEnombre,DEapellido1, DEapellido2, a.fhasta, a.codigo
		order by e.DEidentificacion,e.DEnombre,DEapellido1, DEapellido2, a.fhasta, a.codigo
	</cfquery>
<cfelse>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Resumido"
	Default="Resumido"
	returnvariable="LB_Resumido"/>
	
	<!--- Resumido --->
	<cf_dbfunction name="date_part"	args="dd, max(a.fhasta)" returnvariable="vDiaH">
	<cf_dbfunction name="date_part"	args="mm, max(a.fhasta)" returnvariable="vMesH">
	<cf_dbfunction name="date_part"	args="yyyy, max(a.fhasta)"  returnvariable="vAnioH">
	<cf_dbfunction name="to_char"	args="#vDiaH#"   returnvariable="vDiaCharH">
	<cf_dbfunction name="to_char"	args="#vMesH#"   returnvariable="vMesCharH">
	<cf_dbfunction name="to_char"	args="#vAnioH#"  returnvariable="vAnioCharH">

	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 	e.DEapellido1 as DEapellido1,
           		e.DEapellido2 as DEapellido2,
           		e.DEnombre as DEnombre,
				e.DEidentificacion, 
				{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat( ' ',e.DEnombre)})})})} as Nombre,
				<!---<cf_dbfunction name="to_date00"	args="max(a.fhasta)"> as fhasta,
				case when #vDiaH# < 10 and #vMesH# < 10 
						then 	'0' #concat# #vDiaCharH# #concat# '-' #concat# '0' #concat# #vMesCharH# #concat# '-' #concat# #vAnioCharH# 
					when #vDiaH# < 10 and #vMesH# > 9  
						then	'0' #concat# #vDiaCharH# #concat# '-' #concat# '0' #concat# #vMesCharH# #concat# '-' #concat# #vAnioCharH#
					when #vDiaH# > 9  and #vMesH# < 10 
						then 	#vDiaCharH# #concat# '-' #concat# '0' #concat# #vMesCharH# #concat# '-' #concat# #vAnioCharH#
				else #vDiaCharH# #concat# '-' #concat# #vMesCharH# #concat# '-' #concat# #vAnioCharH# end as codigo,--->
				'#LB_Resumido#' as codigo,
            	0 as RCNid, 
				sum(a.MontoEmp) as MontoEmp,
				sum(a.MontoPat) as MontoPat, 
				e.DEid
		from #acumempleado# a
			
			inner join DatosEmpleado e
				on e.DEid = a.DEid
		<cfif isdefined('url.vigente') and len(trim(url.vigente)) >
			where a.vigente = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.vigente#" />
		</cfif>
		group by e.DEid,e.DEidentificacion,e.DEnombre,DEapellido1, DEapellido2
		order by e.DEid,e.DEidentificacion,e.DEnombre,DEapellido1, DEapellido2
	</cfquery>
	
	<cfquery name="Columnas" dbtype="query">
		select distinct codigo
		from rsReporte
		order by codigo
	</cfquery>

</cfif>

<cf_translatedata name="get" tabla="CuentaEmpresarial" col="CEnombre" conexion="asp" returnvariable="LvarCEnombre">
<cfquery datasource="asp" name="rsCEmpresa">
	select #LvarCEnombre# as CEnombre 
	from CuentaEmpresarial 
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfset LB_Corp = rsCEmpresa.CEnombre>
