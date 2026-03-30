


<cfcomponent hint="Carga los datos requeridos para una Relación de Cálculo de Nómina, equivale a rh_RelacionCalculo">

	<!---
		se invoca desde:
		rh/nomina/operacion/RelacionCalculo-sql.cfm
		rh/nomina/operacion/RelacionCalculoEsp-sql.cfm
		rh/nomina/operacion/ResultadoCalculo-listaSql.cfm
		rh/nomina/operacion/ResultadoCalculo-sql.cfm
		rh/nomina/operacion/ResultadoCalculoEsp-listaSql.cfm
		rh/nomina/operacion/ResultadoCalculoEsp-sql.cfm
		rh/nomina/operacion/ResultadoModify-sql.cfm (2)
		rh/nomina/operacion/ResultadoModifyEsp-sql.cfm (2)
	
	Está basado en el procedimiento almacenado rh_RelacionCalculo,
	tomado de desarrollo, tal como aparece en RH_RelacionCalculo.sql
	
	Migrado por danim, 16-jun-2006
	
	Notas:
	
	--->

<cffunction name="ObtenerDato" returntype="any">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pcodigo#">
	</cfquery>
	<cfif rs.recordCount GT 0>
		<cfreturn #rs.Pvalor#>
	<cfelse>
		<cfset vacio = ''>
		<cfreturn vacio>
	</cfif>
	<cfreturn #rs#>
</cffunction>

<cffunction name="ObtenerCP_RecargoPl" returntype="any">	<!---Trae el id del consepto de pago por medio del codigo de CP--->
	<cfargument name="CIcodigo" type="string" required="true">	
	<cfquery name="rs" datasource="#session.DSN#">
		select CIid
		from CIncidentes
		where upper(ltrim(rtrim(CIcodigo))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(Arguments.CIcodigo))#">
		and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- Le agregue Ecodigo --->
	</cfquery>
	<cfif rs.recordCount GT 0>
		<cfreturn #rs.CIid#>
	<cfelse>
		<cfset vacio = ''>
		<cfreturn vacio>
	</cfif>
</cffunction>

<!---ljimenez Funcion que devuelve el salario minimo general para el empleado (SMG) uso mexico--->	
<cffunction name="SMG" access="public" returntype="numeric">
	<cfargument name="DEid" type="numeric" required="yes">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
			inner join ZonasEconomicas ze
				on de.ZEid = ze.ZEid
			inner join SalarioMinimoZona sm
				on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #arguments.DEid#
				and sm.SZEhasta  = (select max(s.SZEhasta) 
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid	
											and s.SZEestado = 1)		
	</cfquery>     
	   
	<cfif isdefined("rsSQL") and rsSQL.RecordCount neq 0>
		<cfset SZEsalarioMinimo = #rsSQL.SZEsalarioMinimo#>
	<cfelse>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
			ecodigo="#session.Ecodigo#" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
	</cfif>
	<cfreturn #SZEsalarioMinimo#>
</cffunction>

<!---NOTA: PARA EFECTOS DE QUE LA FUNCION TRABAJE EN CF9, SE DIVIDIO UNA ETIQUETE TRANSACTION EN DOS 
ETIQUETAS TRANSACTION, ESTO POR ERROR QUE SUCEDIA POR GRAN NUMERO DE INSTRUCCIONES DENTRO DEL TRANSACTION 
QUE CONCLUIAN EN UN ERROR DE JAVA. (crodriguez)--->	
<cffunction name="RelacionCalculo" access="public" returntype="void">
<cfargument name="datasource" type="string" required="yes">
<cfargument name="Ecodigo" type="numeric" required="yes">
<cfargument name="RCNid" type="numeric" required="yes">
<cfargument name="Usucodigo" type="numeric" required="yes">
<cfargument name="Tcodigo" type="string" required="yes">
<cfargument name="Ulocalizacion" type="string" default="00">
<cfargument name="debug" type="boolean" default="no">
<cfargument name="pDEid" type="numeric" required="no">

<!---
** Carga los datos requeridos para una Relación de Cálculo de Nómina
** Hecho por: Marcel de Mézerville L.
** Fecha: 03 Junio 2003
--->


<cfset var IRcodigo = ''><!---char(5)--->
<cfset var CantDiasMensual = 0><!---int--->
<cfset var DiasAjuste = 0><!---int--->
<cfset var DiasMes = 0><!---int--->
<cfset var CantDiasParametro = 0><!---int---> 
<cfset var fecha = ''><!---datetime--->
<cfset var indicadornopago = 'N'><!---char(1)--->
<cfset var dia1 = ''><!---datetime--->
<cfset var ContabilizaGastosMes = 0><!---int--->

<cf_dbtemp name="PagosEmpV01" returnvariable="PagosEmpleado" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="RCNid" type="numeric" mandatory="yes">  
	<cf_dbtempcol name="DEid" type="numeric" mandatory="yes">
	<cf_dbtempcol name="PEbatch" type="numeric" mandatory="no">
	<cf_dbtempcol name="PEdesde" type="datetime" mandatory="yes">
	<cf_dbtempcol name="PEhasta" type="datetime" mandatory="yes">
	<cf_dbtempcol name="PEsalario" type="money" mandatory="yes">
    <cf_dbtempcol name="PEsalarioref" type="money" 		 mandatory="no">
	<cf_dbtempcol name="PEcantdias" type="int" mandatory="yes">
	<cf_dbtempcol name="PEmontores" type="money" mandatory="yes">
	<cf_dbtempcol name="PEmontoant" type="money" mandatory="yes">
	<cf_dbtempcol name="cortedesde" type="datetime" mandatory="no">
	<cf_dbtempcol name="cortehasta" type="datetime" mandatory="no">
	<cf_dbtempcol name="Tcodigo" type="char(5)" mandatory="yes">
	<cf_dbtempcol name="RHTid" type="numeric" mandatory="yes">
	<cf_dbtempcol name="Ocodigo" type="int" mandatory="yes">
	<cf_dbtempcol name="Dcodigo" type="int" mandatory="yes">
	<cf_dbtempcol name="RHPid" type="numeric" mandatory="yes">
	<cf_dbtempcol name="RHPcodigo" type="char(10)" mandatory="yes">
	<cf_dbtempcol name="RVid" type="numeric" mandatory="yes">
	<cf_dbtempcol name="LTporcplaza" type="float" mandatory="no">
	<cf_dbtempcol name="LTid" type="numeric" mandatory="no">
	<cf_dbtempcol name="LTRid" type="numeric" mandatory="no">
	<cf_dbtempcol name="RHJid" type="numeric" mandatory="yes">
	<cf_dbtempcol name="PEhjornada" type="float" mandatory="yes">
	<cf_dbtempcol name="PEtiporeg" type="int default 0" mandatory="yes">
	<cf_dbtempcol name="CPid" type="numeric" mandatory="no">
	<cf_dbtempcol name="PEsalariobc" type="money" mandatory="no">
	<cf_dbtempcol name="PEsalarioCS" type="money" mandatory="no">
	<cf_dbtempcol name="RHTcomportam" type="int default 0" mandatory="no">
	<cf_dbtempcol name="LTsalrec" type="money" mandatory="no">
	<cf_dbtempcol name="CPmes" type="int" mandatory="no">
	<cf_dbtempcol name="CPperiodo" type="int" mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="CalendariosEmpleado" returnvariable="CalendariosEmpleado" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="CPid" 		type="numeric" mandatory="yes"> 
	<cf_dbtempcol name="DEid" 		type="numeric" mandatory="yes"> 
	<cf_dbtempcol name="CPdesde" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="CPhasta" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="CPmes" 		type="int" mandatory="yes">
	<cf_dbtempcol name="CPperiodo" 	type="int" mandatory="yes">
	
</cf_dbtemp>
<cf_dbtemp name="IncidenciasReb" returnvariable="IncidenciasReb" datasource="#Arguments.datasource#">
	<!--- Tabla de control de los montos a rebajar --->
	<cf_dbtempcol name="RCNid" type="numeric" mandatory="no">
	<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
	<cf_dbtempcol name="CIid" type="numeric" mandatory="no">
	<cf_dbtempcol name="ICfecha" type="datetime" mandatory="no">
	<cf_dbtempcol name="ICvalor" type="money" mandatory="no">
	<cf_dbtempcol name="ICfechasis" type="datetime" mandatory="no">
	<cf_dbtempcol name="CFid" type="numeric" mandatory="no">
	<cf_dbtempcol name="RHSPEid" type="numeric" mandatory="no">
	<cf_dbtempcol name="diassalario" type="money" mandatory="no">
	<cf_dbtempcol name="saldoreb" type="money" mandatory="no">
	<cf_dbtempcol name="saldosub" type="money" mandatory="no">
	<cf_dbtempcol name="dias" type="numeric" mandatory="no">
	<cf_dbtempcol name="diasacum" type="money" mandatory="no">
	<cf_dbtempcol name="diasant" type="money" mandatory="no">
</cf_dbtemp>
<cf_dbtemp name="EmpleadosNomina" returnvariable="EmpleadosNomina" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
	<cf_dbtempcol name="dias" type="int" mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="PIncidentes" returnvariable="PagosIncidentes" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="DEid" type="numeric" mandatory="yes">
	<cf_dbtempcol name="PImonto" type="money" mandatory="no">
</cf_dbtemp>


<cfset apruebaIncidencias = false >
<cfset apruebaIncidenciasN = false >
<cfset apruebaIncidenciasC = false >

<!--- Aprueba Incidencias Normales parametro 1010 --->
<cfquery name="rs_apruebaincidencias" datasource="#arguments.datasource#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
	and Pcodigo = 1010
</cfquery>
<cfif trim(rs_apruebaincidencias.Pvalor) eq 1 >
	<cfset apruebaIncidenciasN = true >
</cfif>

<!--- Aprueba Incidencias Normales parametro 1010 --->
<cfquery name="rs_apruebaincidencias" datasource="#arguments.datasource#">
	select Pvalor
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
	and Pcodigo = 1060
</cfquery>
<cfif trim(rs_apruebaincidencias.Pvalor) eq 1 >
	<cfset apruebaIncidenciasC = true >
</cfif>
<!--- calcula si la empresa necesit aaprobar incidencias (normales o calculo, o ambas) --->
<cfif apruebaIncidenciasN or apruebaIncidenciasC>
	<cfset apruebaIncidencias = true >
</cfif>

<!--- ORACLE no soporta la instruccion coalesce(fecha, '61000101'), pues para el segundo valor 
	  espera una fecha, no un string. Entonces usamos una variable date de CF para simularlo.	
--->
<cfset vFechaDefault = createdate(6100,01,01) >

<!--- begin --->
<cfquery datasource="#arguments.datasource#" name="RCalculoNomina">
    select 
        a.RCdesde,
        a.RChasta,
        a.Tcodigo,
        b.Ttipopago,
		a.RCpagoentractos,			<!--- estos 3 campos siguientes para pago en tractos --->
		a.RCporcentaje,
		a.CIid
		
    from RCalculoNomina a, TiposNomina b
    where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
      and a.Ecodigo = b.Ecodigo
	  and a.Tcodigo = b.Tcodigo
</cfquery>

<cfquery datasource="#arguments.datasource#" name="CalendarioPagos">
    select CPcodigo,CPtipo, CPhasta, CPnodeducciones,CPmes,CPperiodo
    from CalendarioPagos
    where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
</cfquery>

<cfset LvarFechaHastaControl = CalendarioPagos.CPhasta>
<cfset LvarCpmes	=	CalendarioPagos.CPmes>
<cfset LvarCPperiodo=	CalendarioPagos.CPperiodo>


<!--- Obtener la cantidad de días máximo según tipo de Nómina --->
<cfquery name="rsCantDiasMensual" datasource="#arguments.datasource#">
	select FactorDiasSalario
    from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
	  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
</cfquery>	  
<cfif len(trim(rsCantDiasMensual.FactorDiasSalario)) and rsCantDiasMensual.FactorDiasSalario gt 0>
	<cfset CantDiasMensual = rsCantDiasMensual.FactorDiasSalario >
<cfelse>
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>
</cfif>	

<!---ljimenez leemos el factor de dias por mes--->
<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="80" default="" returnvariable="FactorDiasMensual"/>
	
<cfif Len(trim(CantDiasMensual)) eq 0 or CantDiasMensual eq 0 >
	<cfthrow message="Error, debe definirse la cantidad de días a utilizar para el cálculo de la nómina mensual en los parámetros del Sistema y debe ser un valor diferente de cero. Proceso Cancelado.">
</cfif>
	<cfif Arguments.debug>
		<cfoutput>DIAS PARA CALCULO DE SALARIO #CantDiasMensual#</cfoutput>
	</cfif>

<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#"
	pvalor="30" default="" returnvariable="IRcodigo"/>
<cfif Not Len(IRcodigo)>
	<cfthrow message='Error!, No se ha definido la Tabla de Impuesto de Renta a utilizar en los parámetros del Sistema. Proceso Cancelado!!'>
</cfif>
<cfquery datasource="#Arguments.datasource#" name="countEImpuestoRenta">
	select count(1)  as cnt
	from EImpuestoRenta b 
	where b.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#IRcodigo#">
	and b.EIRestado = 1
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#"> between b.EIRdesde and b.EIRhasta
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> between b.EIRdesde and b.EIRhasta
</cfquery>
<cfif countEImpuestoRenta.cnt is 0>
	<cfthrow message='Error!, el rango de fechas de la Relación de Cálculo de Nómina (#LSDateFormat(RCalculoNomina.RCdesde, "dd/mm/yyyy")# - #LSDateFormat(RCalculoNomina.RChasta, "dd/mm/yyyy")#) no está contenido en la Tabla de Impuesto de Renta #IRcodigo#. Proceso Cancelado!!'>
</cfif>
        <!--- Inserta los Pagos de Empleados para el Tipo de Nómina de la relación --->
		
	<cfif CalendarioPagos.CPtipo NEQ 3>
			<cfquery datasource="#Arguments.datasource#">
				insert into #PagosEmpleado# (
					RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores, 
					PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, 
					RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,LTsalrec)
	
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, 
						a.DEid, null, a.LTdesde, a.LThasta,  
						
						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
												from DLineaTiempo 
											where LTid=a.LTid 
											and CIid in (select CIid 
															from ComponentesSalariales
														  where Ecodigo=#session.Ecodigo# and CIid is not null
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,		
						  <!---ASI ESTABA ANTES, LO CAMBIE EN TODOS LOS CASOS-case when b.RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, --->
						<!---►►Salario de Referencia◄◄--->
                        round(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
												from DLineaTiempo 
											  where LTid = a.LTid 
											   and CIid in (select CIid 
															 from ComponentesSalariales
														    where Ecodigo = #session.Ecodigo# 
                                                              and CIid is not null)
								),2) * coalesce(a.LTporcsal,100)/100,
                        0, 
	
						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
												from DLineaTiempo 
											where LTid=a.LTid 
											and CIid in (select CIid 
															from ComponentesSalariales
														  where Ecodigo=#session.Ecodigo# and CIid is not null
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,	
						0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
						a.RVid, a.LTporcplaza, a.LTid, a.RHJid, c.RHJhoradiaria, 0, 
						
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.RHTcomportam,
						 (select sum(r.LTsalario*LTporcplaza/100) from LineaTiempoR r
								where r.DEid=a.DEid
								and r.LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
								and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
						
				from LineaTiempo a, RHTipoAccion b, RHJornadas c <cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
					 <cfif CalendarioPagos.CPtipo Is 1>, Incidencias i</cfif><!---Agregado a solicitud de JC Gutierrez (27/04/2009)---->
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
				  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				  and a.Ecodigo = b.Ecodigo
				  and a.RHTid = b.RHTid
				  and a.RHJid = c.RHJid
				  and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#"> 
					  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">) 
					  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
					  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">))
				<cfif CalendarioPagos.CPtipo Is 2>
				  and a.Ecodigo = de.Ecodigo
				  and a.DEid = de.DEid
				  and de.DEporcAnticipo > 0
				</cfif>
				<cfif CalendarioPagos.CPtipo Is 1><!---Agregado a solicitud de JC Gutierrez (27/04/2009)---->
					 and a.DEid = i.DEid
					 and (i.Iespecial = 1 or i.Icpespecial  =1)
				</cfif>
				
		</cfquery>
		<!--- VERIFICA SI TIENE RECARGOS PARA SUMAR LOS SALARIOS BASE DE CADA UNO --->
	<!---	
		<cfquery name="updatePagosEmpleado" datasource="#session.DSN#">
		 update #PagosEmpleado#
		 set PEmontores = PEmontores+coalesce((
			select sum(sal) from (
			select case when c.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempoR 
										where LTRid=a.LTRid 
										and CIid in (select CIid 
													  from ComponentesSalariales
													  where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
													    and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end as sal
			from LineaTiempoR a
			inner join RHTipoAccion c
				on c.RHTid = a.RHTid
				and c.Ecodigo = a.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			 and a.DEid = #PagosEmpleado#.DEid
			and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#"> 
			  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">) 
			  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
			  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">))) as salario),0),
		PEsalario = PEsalario+coalesce((
			select sum(sal) from (
			select case when c.RHTpaga = 1 then (round
						(a.LTsalario -(selqect coalesce(sum(DLTmonto),0)  
											from DLineaTiempoR 
										where LTRid=a.LTRid 
										and CIid in (select CIid 
													  from ComponentesSalariales
													  where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
													    and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end as sal
			from LineaTiempoR a
			inner join RHTipoAccion c
				on c.RHTid = a.RHTid
				and c.Ecodigo = a.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			 and a.DEid = #PagosEmpleado#.DEid
			and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#"> 
			  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">) 
			  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
			  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">))) as salario),0)
		</cfquery>--->
	</cfif>
	<!--------------------------------------------------------------------------------------------------->	
	<!------------------------------------- CALCULO DE RETROACTIVOS ------------------------------------->
	<!--------------------------------------------------------------------------------------------------->	
	<!--- BUSCA TODOS LOS CALENDARIOS DE PAGO DONDE APLICA RETROACTIVO --->
	<!--- TIPO DE NOMINA CPtipo = 0 NORMAL CPtipo = 2 ANTICIPO --->
	<cfif CalendarioPagos.CPtipo Is 0 or CalendarioPagos.CPtipo Is 2>
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempo a, CalendarioPagos d, CalendarioPagos e<cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and d.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPdesde >= d.CPdesde
			  and e.CPtipo in (0,2)
			  and d.CPtipo in (0,2)
			  and e.CPfcalculo is not null
			  <cfif CalendarioPagos.CPtipo Is 2>
				  and a.Ecodigo = de.Ecodigo
				  and a.DEid = de.DEid
				  and de.DEporcAnticipo > 0
			</cfif>
			</cfquery>
		<!---=============================================MCZ--Retroactivos en caso de Recargo========================================================
		========Cuando se utiliza la linea de tiempo de recargos si se toma el salario base y a este no se le restan los componentes salariales del ==
		detalle de la linea del tiempo esto porque si se trabajan con tablas salariales no se les debe de quitar los componentes q ya traia asociados=
		entonces el calculo puede ser incorrecto======================================================================================================			
		==========================================================================================================================================--->
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempoR a, CalendarioPagos d, CalendarioPagos e<cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and d.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.CPhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPdesde >= d.CPdesde
			  and e.CPtipo in (0,2)
			  and d.CPtipo in (0,2)
			  and e.CPfcalculo is not null
			  <cfif CalendarioPagos.CPtipo Is 2>
				  and a.Ecodigo = de.Ecodigo
				  and a.DEid = de.DEid
				  and de.DEporcAnticipo > 0
			</cfif>
		</cfquery>
	
	 <cfelseif CalendarioPagos.CPtipo Is 3 ><!--- CUANDO ES UNA NÓMINA DE RETROACTIVO --->
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			  select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempo a, CalendarioPagos d, CalendarioPagos e
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPtipo in (0,2)
			  and d.CPtipo = 3
			  and e.CPdesde >= d.CPdesde
			  and e.CPfcalculo is not null
			  and e.CPhasta <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			  and d.CPhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
		</cfquery> 
		<!--- RECARGOS--->
		<cfquery datasource="#Arguments.datasource#">
			insert  into #CalendariosEmpleado#(CPid, DEid, CPdesde, CPhasta,CPmes, CPperiodo)
			  select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta, e.CPmes, e.CPperiodo
			from LineaTiempoR a, CalendarioPagos d, CalendarioPagos e
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and d.Ecodigo = a.Ecodigo
			  and d.Tcodigo = a.Tcodigo
			  and a.LTdesde between d.CPdesde and d.CPhasta 
			  and e.Ecodigo = d.Ecodigo
			  and e.Tcodigo = d.Tcodigo
			  and e.CPtipo in (0,2)
			  and d.CPtipo = 3
			  and e.CPdesde >= d.CPdesde
			  and e.CPfcalculo is not null
			  and e.CPhasta <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
			  and d.CPhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
		</cfquery>
	</cfif>
    <!---Retroactivos positivos para el primer corte  --->
	<cfquery datasource="#Arguments.datasource#">
		insert into #PagosEmpleado# (
		RCNid, DEid, PEbatch, 
		PEdesde, 
		PEhasta, 
		PEsalario, 
        PEsalarioref, 
		PEcantdias, 
		PEmontores, 
		PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
		RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,CPmes, CPperiodo
		)
		select distinct 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
		case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
		case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta end, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempo 
										where LTid=a.LTid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		<!---►►Salario de Referencia◄◄--->
        round (a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							    from DLineaTiempo 
							 where LTid = a.LTid 
							   and CIid in (select CIid 
												from ComponentesSalariales
											 where Ecodigo = #session.Ecodigo# 
                                               and CIid is not null)
				),2) * coalesce(a.LTporcsal,100)/100,
        0, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempo 
										where LTid=a.LTid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
		a.RVid, a.LTporcplaza, a.LTid, a.RHJid, RHJhoradiaria, 1, ce.CPid , b.RHTcomportam, ce.CPmes, ce.CPperiodo
		from #CalendariosEmpleado# ce, LineaTiempo a, RHTipoAccion b, RHJornadas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and a.DEid = ce.DEid
		  and a.Ecodigo = b.Ecodigo
		  and a.RHTid = b.RHTid
		  and a.RHJid = c.RHJid
		  and a.LThasta >= ce.CPdesde
		  <cfif CalendarioPagos.CPtipo NEQ 3 >
 		  and (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid) between a.LTdesde and a.LThasta
		  and a.LTdesde < (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
		  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		  </cfif>
	</cfquery>
	<!--- RETROACTIVOS POSITIVOS PARA EL PRIMER CORTE RECARGOS --->
	<cfquery datasource="#Arguments.datasource#">
		insert into #PagosEmpleado# (
		RCNid, DEid, PEbatch, 
		PEdesde, 
		PEhasta, 
		PEsalario, 
        PEsalarioref, 
		PEcantdias, 
		PEmontores, 
		PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
		RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,CPmes, CPperiodo
		)
		select distinct 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
		case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
		case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempoR
										where LTRid=a.LTRid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		<!---►►Salario de Referencia◄◄--->
        round (a.LTsalario -(select coalesce(sum(DLTmonto),0)  
								from DLineaTiempoR
							 where LTRid = a.LTRid 
							   and CIid in (select CIid 
											  from ComponentesSalariales
											where Ecodigo = #session.Ecodigo# 
                                              and CIid is not null)
			  ),2) * coalesce(a.LTporcsal,100)/100,
        0, 
				case when b.RHTpaga = 1 then (round
						(a.LTsalario -(select coalesce(sum(DLTmonto),0)  
											from DLineaTiempoR
										where LTRid=a.LTRid 
										and CIid in (select CIid 
														from ComponentesSalariales
													  where Ecodigo=#session.Ecodigo# and CIid is not null
													 )
									   ),2)
						* coalesce(a.LTporcsal,100)/100)
						 else 0.00 end,	
		0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
		a.RVid, a.LTporcplaza, a.LTRid,a.LTRid, a.RHJid, RHJhoradiaria, 1, ce.CPid , b.RHTcomportam, ce.CPmes, ce.CPperiodo
		from #CalendariosEmpleado# ce, LineaTiempoR a, RHTipoAccion b, RHJornadas c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and a.DEid = ce.DEid
		  and a.Ecodigo = b.Ecodigo
		  and a.RHTid = b.RHTid
		  and a.RHJid = c.RHJid
		  and a.LThasta >= ce.CPdesde
		  <cfif CalendarioPagos.CPtipo NEQ 3 >
 		  and (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid) between a.LTdesde and a.LThasta
		  and a.LTdesde < (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
		  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		  </cfif>
	</cfquery>
    <!---  Retroactivos positivos con corte posterior al primer dia del mes seleccionado --->
	<!--- APLICA SOLO PARA LAS OTRAS NOMINAS PORQUE LA DE RETROACTIVOS YA TIENE LOS CORTES EN EL QUERY ANTERIOR --->
	 <cfif CalendarioPagos.CPtipo NEQ 3 > 
		<cfquery datasource="#Arguments.datasource#">
			insert into #PagosEmpleado# (
			RCNid, DEid, PEbatch, 
			PEdesde, 
			PEhasta, 
			PEsalario, 
            PEsalarioref, 
			PEcantdias, 
			PEmontores, 
			PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
			RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam
			)
			select distinct 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
			case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
			case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempo 
							where LTid=a.LTid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	 
			<!---►►Salario de Referencia◄◄--->
            round ((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							        from DLineaTiempo 
							     where LTid = a.LTid 
                                   and CIid in (select CIid 
                                                   from ComponentesSalariales 
                                                where Ecodigo = #session.Ecodigo# 
                                                  and CIid is not null)
                               ))
							* coalesce(LTporcsal,100)/100,2),
            0, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempo 
							where LTid=a.LTid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	
			0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
			a.RVid, a.LTporcplaza, a.LTid, a.RHJid, RHJhoradiaria, 1, ce.CPid, b.RHTcomportam
			from #CalendariosEmpleado# ce, LineaTiempo a, RHTipoAccion b, RHJornadas c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  and a.DEid = ce.DEid
			  and a.Ecodigo = b.Ecodigo
			  and a.RHTid = b.RHTid
			  and a.RHJid = c.RHJid
			  and a.LThasta >= ce.CPdesde
			  and a.LTdesde >= (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
			  and a.LTdesde <= ce.CPhasta
			  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		</cfquery>
		<!--- RECARGOS --->
		<cfquery datasource="#Arguments.datasource#">
			insert into #PagosEmpleado# (
			RCNid, DEid, PEbatch, 
			PEdesde, 
			PEhasta, 
			PEsalario, 
            PEsalarioref, 
			PEcantdias, 
			PEmontores, 
			PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
			RVid, LTporcplaza, LTid, LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam
			)
			select distinct 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
			case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
			case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempoR 
							where LTRid=a.LTRid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	 
			<!---►►Salario de Referencia◄◄--->
            round ((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							        from DLineaTiempoR 
							     where LTRid = a.LTRid 
                                   and CIid in (select CIid 
                                                 from ComponentesSalariales 
                                                where Ecodigo = #session.Ecodigo# 
                                                  and CIid is not null)
                     )) * coalesce(LTporcsal,100)/100,2),
            0, 
			case when b.RHTpaga = 1 then round
							((a.LTsalario -(select coalesce(sum(DLTmonto),0)  
							from DLineaTiempoR 
							where LTRid=a.LTRid and CIid in (select CIid from ComponentesSalariales where Ecodigo=#session.Ecodigo# and CIid is not null)))
							* coalesce(LTporcsal,100)/100,2) else 0.00 end,	
			0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
			a.RVid, a.LTporcplaza, a.LTRid,a.LTRid, a.RHJid, RHJhoradiaria, 1, ce.CPid, b.RHTcomportam
			from #CalendariosEmpleado# ce, LineaTiempoR a, RHTipoAccion b, RHJornadas c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  and a.DEid = ce.DEid
			  and a.Ecodigo = b.Ecodigo
			  and a.RHTid = b.RHTid
			  and a.RHJid = c.RHJid
			  and a.LThasta >= ce.CPdesde
			  and a.LTdesde >= (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
			  and a.LTdesde <= ce.CPhasta
			  and a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		</cfquery>
	 </cfif> 
	

	<!---  3. Retroactivos negativos--->
	<cfquery datasource="#Arguments.datasource#">
		insert into #PagosEmpleado# (
		RCNid, DEid, PEbatch, 
		PEdesde, 
		PEhasta, 
		PEsalario, 
        PEsalarioref, 
		PEcantdias, 
		PEmontores, 
		PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
		RVid, LTporcplaza, LTid, RHJid, PEhjornada, CPmes, CPperiodo, PEtiporeg,CPid
		)
		select 
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, ce.DEid, null, 
		e.PEdesde, 
		e.PEhasta, 
		abs(e.PEsalario),
        <!---►►Salario de Referencia◄◄--->
        abs(e.PEsalarioref),
		<cf_dbfunction name="datediff" args="e.PEdesde,e.PEhasta"> + 1, 
		sum(e.PEmontores*-1), 
		0.00, e.PEdesde, e.PEhasta, e.Tcodigo, e.RHTid, e.Ocodigo, e.Dcodigo, e.RHPid, e.RHPcodigo, 
		e.RVid, 100, 0, e.RHJid, e.PEhjornada, ce.CPmes, ce.CPperiodo, 2, 733
		from #CalendariosEmpleado# ce, HPagosEmpleado e
		where e.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
		  and e.DEid = ce.DEid
		  and e.RCNid = ce.CPid
		  and e.PEmontores != 0.00
		   <cfif CalendarioPagos.CPtipo NEQ 3 >
		  and e.PEdesde >= (select min(g.CPdesde) from #CalendariosEmpleado# g where g.DEid = ce.DEid)
		  and e.PEhasta < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		  </cfif>
		group by  ce.DEid, e.PEdesde, e.PEhasta, abs(e.PEsalario), abs(e.PEsalarioref), e.Tcodigo, e.RHTid, e.Ocodigo, e.Dcodigo, e.RHPid, e.RHPcodigo, e.RVid, e.RHJid, e.PEhjornada, ce.CPmes, ce.CPperiodo
		having sum(e.PEmontores*-1) != 0
	</cfquery>


 <!--- 2010-03-05 RX PARA EL AJUSTE DE LA CANTIDAD DE DIAS PARA LOS RETROACTIVOS YA PAGADOS --->	   
	<cfquery name="factordias" datasource="#Arguments.datasource#">
		select FactorDiasSalario
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and rtrim(Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
	</cfquery>
		   
	<cfquery datasource="#Arguments.datasource#">
		update #PagosEmpleado# 	set 
			PEcantdias = round(PEmontores / (PEsalario / <cfqueryparam cfsqltype="cf_sql_float" value="#factordias.FactorDiasSalario#">),2)
		where PEtiporeg=2
	</cfquery>	


	<cfif Arguments.debug>
		<cfquery datasource="#Arguments.datasource#" name="debugCalendariosEmpleado">
			select CPid, DEid, CPdesde, CPhasta
			from #CalendariosEmpleado#
				<cfif IsDefined('Arguments.pDEid')>where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
					order by DEid, CPdesde
					select RCNid, DEid, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid 
					from #PagosEmpleado#
				<cfif IsDefined('Arguments.pDEid')>where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			order by PEtiporeg, PEdesde
		</cfquery>
		<cfdump var="#debugCalendariosEmpleado#" label="debugCalendariosEmpleado">
	</cfif>

	<cfquery datasource="#Arguments.datasource#">
		update #PagosEmpleado#
		set PEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
			, CPmes 	= #LvarCPmes#
			, CPperiodo = #LvarCPperiodo#
		where PEtiporeg = 0 
		  and PEdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
    </cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		update #PagosEmpleado#
		set PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> 
			, CPmes 	= #LvarCPmes#
			, CPperiodo = #LvarCPperiodo#
		where PEtiporeg = 0 
		  and PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
	</cfquery>

	<cfset PEhasta = DateAdd("d", -1, RCalculoNomina.RCdesde)>
	<!--------------------------------------------------------------------------------------------------->	
	<!--------------------------------- FIN CALCULO DE RETROACTIVOS ------------------------------------->
	<!--------------------------------------------------------------------------------------------------->	

	<!--- SI ES NÓMINA DE RETROACTIVOS, ELIMINA LOS EMPLEADOS ACTIVOS --->
	<cfif CalendarioPagos.CPtipo EQ 3>
		<!---Eliminar Empleados Cesados en esta Nomina --->
		<cfquery datasource="#Arguments.datasource#">
		delete from #PagosEmpleado# 
		where NOT exists ( 
				select 1  
				from DLaboralesEmpleado a, RHTipoAccion b 
				where a.DEid = #PagosEmpleado#.DEid 
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				  and a.DLfvigencia >= #PagosEmpleado#.PEdesde
				  and a.RHTid = b.RHTid 
				  and b.RHTcomportam = 2 <!---CESE --->
				  and b.RHTliquidatotal = 1 <!---Se Paga el total de los dias laborados en la liquidación --->
				  and not exists (Select 1 From LineaTiempo  c Where c.LTdesde >= a.DLfvigencia and c.DEid=a.DEid)<!--- verifica que no exista una accion de nombramiento posterior al cese --->
		) 
		</cfquery>
	<cfelse>
	<!--- SI ES NÓMINA NORMAL, ELIMINA LOS EMPLEADOS INACTIVOS --->
		<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#PEhasta#"> 
			where PEtiporeg != 0 
			  and PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
		</cfquery>
		<!---Eliminar Empleados Cesados en esta Nomina --->
		<cfquery datasource="#Arguments.datasource#">
		delete from #PagosEmpleado# 
		where exists ( 
				select 1  
				from DLaboralesEmpleado a, RHTipoAccion b 
				where a.DEid = #PagosEmpleado#.DEid 
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				  and a.DLfvigencia >= #PagosEmpleado#.PEdesde
				  and a.RHTid = b.RHTid 
				  and b.RHTcomportam = 2 <!---CESE --->
				  and b.RHTliquidatotal = 1 <!---Se Paga el total de los dias laborados en la liquidación --->
				  and not exists (Select 1 From LineaTiempo  c Where c.LTdesde >= a.DLfvigencia and c.DEid=a.DEid)<!--- verifica que no exista una accion de nombramiento posterior al cese --->
		) 
		</cfquery>
	</cfif>
	 <!---SI ES NÓMINA DE ANTIVIPOO Eliminar Empleados que no deben tener anticipo--->
	<cfif CalendarioPagos.CPtipo Is 2>
		 <!---Eliminar Empleados que no deben tener anticipo--->
		<cfquery datasource="#Arguments.datasource#">
		delete from #PagosEmpleado# 
		where exists ( 
				select 1  
				from DatosEmpleado a
				where a.DEid = #PagosEmpleado#.DEid 
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				  and a.DEporcAnticipo <= 0
				) 
		</cfquery>
	</cfif>
    <!--- Para tomar en cuenta los días que no se pagan.  Utiliza Indicador de Días de NO pago --->
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#"
		pvalor="90" default="N" returnvariable="indicadornopago"/>
      
    <cfif indicadornopago is 'S' And (CalendarioPagos.CPtipo Is 0 or CalendarioPagos.CPtipo IS 2)>
        <cfquery datasource="#Arguments.datasource#" name="fecha">
			select min(PEdesde) as fecha from #PagosEmpleado#
		</cfquery>
		<cfset fecha = fecha.fecha>
    
        <cfif Not Len(fecha)>
        	<cfset fecha = RCalculoNomina.RCdesde>
		</cfif>
        <cfloop condition="fecha LE RCalculoNomina.RChasta">
            <cfquery datasource="#Arguments.datasource#" name="exists">
				select 1
				from DiasTiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
				and DTNdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('w', fecha)#">
			</cfquery>
			<cfif exists.RecordCount>
				<cfquery datasource="#Arguments.datasource#">
					insert into #PagosEmpleado# (RCNid, DEid, PEbatch, PEdesde, PEhasta, 
						PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, 
						Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,LTsalrec)
					select RCNid, DEid, PEbatch, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, fecha)#">, PEhasta, 
						PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, 
						Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,LTsalrec
					from #PagosEmpleado#
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#"> between PEdesde and PEhasta
					  and PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEtiporeg < 2
				</cfquery>
				<cfquery datasource="#Arguments.datasource#">
					insert into #PagosEmpleado# (RCNid, DEid, PEbatch, PEdesde, PEhasta,
						PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo,
						Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,LTsalrec)
					select RCNid, DEid, PEbatch,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">,
						PEsalario,PEsalarioref, 1, 0.00, 0.00, cortedesde, cortehasta, Tcodigo, RHTid,
						Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, 3,LTsalrec
					from #PagosEmpleado#
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#"> between PEdesde and PEhasta
					  and PEhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEtiporeg < 2
                </cfquery>
				<cfquery datasource="#Arguments.datasource#">
					update #PagosEmpleado#
					set PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, fecha)#">
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#"> between PEdesde and PEhasta
					  and PEdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEtiporeg < 2
                </cfquery>
				<!---Elimina el registro que inicia en la fecha que se está procesando --->
                <cfquery datasource="#Arguments.datasource#">
					delete #PagosEmpleado#
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#"> between PEdesde and PEhasta 
					  and PEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEtiporeg < 2 
                </cfquery>  
                <cfquery datasource="#Arguments.datasource#">
					update #PagosEmpleado#
					set PEmontores = 0.00,
						PEtiporeg = 3
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#"> between PEdesde and PEhasta
					  and PEdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEdesde = PEhasta
					  and PEmontores != 0.00
					  and PEtiporeg < 2
				</cfquery>
            </cfif>
            <cfset fecha = DateAdd('d', 1, fecha)>
        </cfloop><!---del while--->
    </cfif><!--- del indicador de dias de NO pago--->
    <!---************************************************************************************
        Modificado por Yu Hui 
        Fecha: 23 de Diciembre 2005
    *************************************************************************************--->
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#"
		pvalor="490" default="0" returnvariable="ContabilizaGastosMes"/>
		
   <!--- Realizar los cortes para los pagos que cubren diferentes meses contables --->
    <cfif ContabilizaGastosMes Is 1 and ListFind('0,1', RCalculoNomina.Ttipopago)
		and (DatePart('m', RCalculoNomina.RCdesde) NEQ DatePart('m', RCalculoNomina.RChasta))>
        <cfset dia1 = CreateDate( Year(RCalculoNomina.RChasta), Month(RCalculoNomina.RChasta), 1)>
		<cfquery datasource="#Arguments.datasource#">
			insert into #PagosEmpleado# (
				RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref PEcantdias, PEmontores,
				PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
				RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,LTsalrec)
			select
				RCNid, DEid, PEbatch, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dia1#">,
				PEhasta, PEsalario,PEsalarioref PEcantdias, PEmontores,
				PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
				RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,LTsalrec
			from #PagosEmpleado#
			where PEdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dia1#">
			and PEhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dia1#">
			and PEtiporeg < 2
		</cfquery>
		
		<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', -1, dia1)#">
			where PEdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dia1#">
			and PEhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dia1#">
			and PEtiporeg < 2
		</cfquery>
          
    </cfif>
    <!---************************************************************************************
        Fin Modificaciones
    *************************************************************************************--->
        
    <!--- La cantidad de días resultante por cada funcionario no puede ser mayor que la cantidad de días segun tipo de Nómina--->

	<cfquery datasource="#Arguments.datasource#">
	    update #PagosEmpleado# set PEcantdias = <cf_dbfunction name="datediff" args="PEdesde,PEhasta,DD,true"> + 1 where PEtiporeg < 2
	</cfquery>
    <cfset DiasAjuste = 0>
	<cfset DiasMes = 0>
	<!--- PARA NOMINAS MENSUALES ES NECESARIO AJUSTAR LOS 31 Y LOS 28. 
		OBTENER LA CANTIDAD DE DIAS QUE SE REQUIERE AJUSTAR A LOS PERIODOS
	--->
	<cfset CantDiasParametro = CantDiasMensual>
	<cfif ListFind('2,3', RCalculoNomina.Ttipopago )>
		<cfif RCalculoNomina.Ttipopago is 2>
			<cfset CantDiasParametro = Ceiling(CantDiasParametro / 2)>
		</cfif>
		<cfquery datasource="#Arguments.datasource#" name="CPids">
			select distinct CPid
			from #PagosEmpleado#
			where PEtiporeg < 2
			  and CPid is not null
			order by CPid
		</cfquery>
        <cfloop query="CPids">
    		<cfquery datasource="#Arguments.datasource#" name="DiasdelMes">
				SELECT CPdesde, CPhasta
				from CalendarioPagos
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
			</cfquery>
			<cfset DiasMes = DateDiff('d', DiasdelMes.CPdesde, DiasdelMes.CPhasta) + 1>
		    <cfset DiasAjuste = 0>
    		<cfif DiasMes GT CantDiasParametro>
   				<cfset DiasAjuste = (DiasMes - CantDiasParametro)*-1>
    		</cfif>
    		<cfif DiasMes LT CantDiasParametro>
    			<cfset DiasAjuste = (DiasMes - CantDiasParametro )*-1>
    		</cfif>
    		<cfif DiasAjuste LT 0>
				<cfquery datasource="#Arguments.datasource#">
					update #PagosEmpleado# 
					set PEcantdias = PEcantdias + <cfqueryparam cfsqltype="cf_sql_integer" value="#DiasAjuste#">
					where exists ( select 1
					from CalendarioPagos
					WHERE #PagosEmpleado#.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
					  and #PagosEmpleado#.PEhasta > <cf_dbfunction name="dateadd" args="#DiasAjuste#,CalendarioPagos.CPhasta">
					  and CalendarioPagos.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
					  and #PagosEmpleado#.PEtiporeg < 2
					)  
				</cfquery>
    		</cfif>
    		<cfif DiasAjuste GT 0>
				<cfquery datasource="#Arguments.datasource#">
					update #PagosEmpleado# 
					set PEcantdias = PEcantdias + <cfqueryparam cfsqltype="cf_sql_integer" value="#DiasAjuste#">
					where exists ( select 1
					from CalendarioPagos
					WHERE #PagosEmpleado#.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
					  and CalendarioPagos.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
					  and #PagosEmpleado#.PEhasta = CalendarioPagos.CPhasta
					  and #PagosEmpleado#.PEtiporeg < 2
					) 
				</cfquery>
    		</cfif>
       </cfloop><!---while--->
	</cfif>
	
	<!---ljimenez se verifica el estatus de usa sbc para realizar calculos especiales si es = 1	--->
	<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="vUsaSBC"/>
	<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2024" default="" returnvariable="vSMGA"/>
	
	
	<!---	ljimenez aca se incluye el calculo del SBC ahora lo tomamos de datosempleado DEsdi--->
	
	<!---<cfif vUsaSBC eq 1>
		<cfinclude template="RH_sacasbc.cfm">
		
	</cfif>--->
	<!---ljimenez fin del calculos especiales SBC--->
	

	<!--- ============================================= --->
	<!--- Modificaciones Proyecto DHC - Panama - INICIO	--->
	<!--- ============================================= --->
	<!--- calculo de factor dias salario del tipo de nomina de la relacion de calculo --->
	<cfquery name="rs_factordias" datasource="#Arguments.datasource#">
		select FactorDiasSalario
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Tcodigo#">
	</cfquery>
	
	<!--- caso 1: El tipo de nomina tiene definido el campo FactorDiasSalario con un numero mayor que cero --->
	
	<!---ljimenez aca es donde se hace el calculo del monto correspondiente al salario  para los dias laborados--->

	<cfif len(trim(rs_factordias.FactorDiasSalario)) and rs_factordias.FactorDiasSalario gt 0 >
		<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEmontores = round((PEmontores / <cfqueryparam cfsqltype="cf_sql_float" value="#rs_factordias.FactorDiasSalario#">) * PEcantdias, 2)
			where PEmontores != 0.00
			and PEtiporeg < 2
		</cfquery>
		
		<!--- ljimenez Actualizo lo correspondiente a SBC deacuerdo en la tabla temporal --->
		<cfif vUsaSBC eq 1>
		
			<cfquery datasource="#Arguments.datasource#">
				update #PagosEmpleado# set PEsalariobc = coalesce((select de.DEsdi from DatosEmpleado de 
															where de.DEid = #PagosEmpleado#.DEid 
																and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">),0)
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEmontores = round((PEmontores * 12.0 / 52.0 / (	select coalesce(RHJdiassemanal,7)
																	from RHJornadas j
																	where j.RHJid = #PagosEmpleado#.RHJid) 
							* PEcantdias), 2)
			where PEmontores != 0.00
			and PEtiporeg < 2
			and RHJid in (Select RHJid
						  from RHJornadas
						  Where coalesce(RHJdiassemanal,0) > 0)
		</cfquery>

		<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEmontores = round((PEmontores / <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">) * PEcantdias, 2)
			where PEmontores != 0.00
			and PEtiporeg < 2
			and RHJid in (Select RHJid
						  from RHJornadas
						  Where coalesce(RHJdiassemanal,0) = 0)
		</cfquery>
	</cfif>
	
	
	<!--- ============================================= --->
	<!--- Modificaciones Proyecto DHC - Panama - FIN	--->
	<!--- ============================================= --->


<!---PRIMER TRANSACTION (SEGMENTADO PARA CF9), contiene: 
Calculo del SalarioEmpleado,Pagos de Empleado, Insercion como Incidencias los componentes Salariales, Calculo de las Incidencias Retroactivas Negativas, Incidencias de ago correspondientes  eje: horas extra, Insercion de incidencias no pagadas que corresponden a importe, Insercion de todos los conceptos de cálculo retroactivos  Ej: Horas pagadas en nóminas anteriores, Insercion de todas las incidencias de la relación de cálculo especial que esten definidas en el calendario, Insercion de incidencias no pagadas que corresponden a importe o a cálculo de cualquier nómina igual o anterior a la que se está procesando Ej: Comisiones, Monto a Rebajar de la tabla de RHSaldoPagosExceso, Monto a Subsidiar de la tabla RHSaldoPagosExceso --->
<cftransaction>

	<cfquery datasource="#Arguments.datasource#">
		delete from RHPagosExternosCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		delete from IncidenciasCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		delete from PagosEmpleado 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		delete from CargasCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		delete from DeduccionesCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		delete from DeduccionesEmpleado
		where ltrim(rtrim(Dreferencia)) = '#trim(CalendarioPagos.CPcodigo)#'
	<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		delete from SalarioEmpleado
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfquery datasource="#Arguments.datasource#">
		 insert into #EmpleadosNomina# (DEid, dias)   <!--- Obtener los dias trabajados por cada empleado en la nomina actual. --->
		 select distinct DEid, 0
		 from #PagosEmpleado#
     </cfquery>
	 <cfif CalendarioPagos.CPtipo NEQ 0 and CalendarioPagos.CPtipo NEQ 2 and CalendarioPagos.CPtipo NEQ 3><!--- No hay pagos de salario en nominas especiales --->
        <cfquery datasource="#Arguments.datasource#">
			delete from #PagosEmpleado#
		</cfquery>
     </cfif>
	 
	 <cfquery datasource="#Arguments.datasource#">
		 update #EmpleadosNomina#
		 set dias = coalesce(
			(select sum(PEcantdias)
			 from #PagosEmpleado# 
			 where #PagosEmpleado#.DEid = #EmpleadosNomina#.DEid
			   and #PagosEmpleado#.PEtiporeg = 0
			   and #PagosEmpleado#.PEmontores != 0.00), 0)
      </cfquery>
	  
	
	  <!--- SalarioEmpleado --->
	  <cfquery datasource="#Arguments.datasource#">
		 insert into SalarioEmpleado (RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinorenta, SEinocargas, SEinodeduc,SEsalrec)
		 select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, DEid, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,0.00
		 from #EmpleadosNomina#
     </cfquery>
	 
	 <!---ljimenez aca paso los datos de los dias laborados de la tabla temporal --->
	  
	 <!--- Pagos Empleado --->

	 <cfquery datasource="#Arguments.datasource#">
		 insert into PagosEmpleado (DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,PEsalariobc, CPmes, CPperiodo,PEsalrec)
		 select DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,PEsalariobc, CPmes, CPperiodo,LTsalrec
		 from #PagosEmpleado#
	</cfquery>
	
	<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		select 1
		from Empresa e
			inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'GT'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>
	
<!--- ARCHIVO QUE CONTIENE LOS CALCULOS DE LOS CONCEPTOS INCIDENTES --->	
<cfinclude template="RH_RelacionCalculoIncidencias.cfm">

<cfif Arguments.debug>
	<cftransaction action="rollback"/>
	<cfoutput>Invocado con debug = true, abortando</cfoutput><cfabort>
</cfif>
</cftransaction>


<!---SEGUNDO TRANSACTION (SEGMENTADO PARA CF9), contiene: 
Eliminacion de las incidencias, inclusion de conceptos de pago por carrera profesional, insercion de las Cargas que tiene el empleado, actulizacion de los dias base de cotizacion a utilizar para calcular las cargas dias DBC3 Sueldos + Vacaciones - Permisos(Faltas),verificacion sobre calculo de deducciones en la nomina Borrar deducciones que no se pagan en esta Nómina, cuando hay registros, Eliminacion de la relacion a todos los funcionarios --->

<cftransaction>
 
	<!--- *************************************** --->
   	<!--- * este delete elimina las incidencias * --->
	<!--- * en el rango de fechas indicadas en  * --->
	<!--- * cualquier tipo acción que tenga     * --->
	<!--- * activo (1) el bit de  No incluir    * --->
    <!--- * conceptos de pago incidentes entre  * --->
    <!--- * las fechas de vigencia de la acción * --->
	<!--- *************************************** --->

	
	<cfquery datasource="#Arguments.datasource#">
        delete from IncidenciasCalculo
        where RCNid = #Arguments.RCNid#
          and exists ( 
                select 1  
                from LineaTiempo a
                	inner join RHTipoAccion b
                    on b.RHTid = a.RHTid
                where a.DEid = IncidenciasCalculo.DEid 
                  and IncidenciasCalculo.ICfecha between a.LTdesde and a.LThasta
                  and b.RHTnopagaincidencias = 1)  <!---No incluir conceptos de pago incidentes entre las fechas de vigencia de la acción --->
    </cfquery>
	
	<!--- 
		CONCEPTOS DE PAGO POR CARRERA PROFESIONAL
		SE INCLUYE EL COMPONENTE DE CALCULO DE CONCEPTOS DE PAGO POR CARRERA PROFESIONAL
	
    <cfinvoke component="RH_CalculoCP" method="CalculoCP">
		<cfinvokeargument name="conexion" 		value="#Arguments.datasource#">
		<cfinvokeargument name="Ecodigo" 		value = "#Arguments.Ecodigo#">
		<cfinvokeargument name="RCNid" 			value = "#Arguments.RCNid#">
		<cfinvokeargument name="RCdesde" 		value = "#RCalculoNomina.RCdesde#">
		<cfinvokeargument name="RChasta" 		value = "#RCalculoNomina.RChasta#">
		<cfinvokeargument name="CantDiasMensual"value = "#CantDiasMensual#">
		<cfinvokeargument name="Usucodigo" 		value = "#Arguments.Usucodigo#">
		<cfinvokeargument name="Ulocalizacion" 	value  = "#Arguments.Ulocalizacion#">
		<cfinvokeargument name="debug" 			value = "#Arguments.debug#">
		<cfif IsDefined('Arguments.pDEid')>
			<cfinvokeargument name="pDEid" value = "#Arguments.pDEid#">
		</cfif>
	</cfinvoke>
	 --->
	
	
	<!--- CARGAS: Insertar las Cargas que tiene el empleado   --->
	<cfquery name="InsertaCargas" datasource="#Arguments.datasource#">
		insert into CargasCalculo (DClinea, RCNid, DEid, CCvaloremp, CCvalorpat, CCbatch, CCvalorempant,
		 CCvalorpatant, CCsmg)
		select c.DClinea, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, 0.00, 0.00, null, 0.00, 0.00, 0.00
		from SalarioEmpleado a, CargasEmpleado b, DCargas c
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		  and a.SEcalculado = 0
		  and a.DEid = b.DEid
		  and b.CEdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RChasta#">
		  and coalesce(b.CEhasta,<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaDefault#">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RCdesde#">
		  and b.DClinea = c.DClinea
		  and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  <!--- Desarrollo Baroda-DHC: se excluyen cargas ke fueron definidas para no incluirlas en el calculo.
		  		Solicitado por Lizandro.
		   --->	
		  and c.DClinea not in ( select DClinea
		  						 from RHCargasExcluir
								 where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  )
	</cfquery>
	
	
	<cfif vUsaSBC eq 1>
		<!--- ljimenez CARGAS: Actuliza los dias base de cotizacion a utilizar para calcular las cargas 
		dias DBC1 Sueldos + Vacaciones - Permisos(Faltas) - Incapacidades --->
		<cfquery name="rsDBC" datasource="#Arguments.datasource#">
			update CargasCalculo set CCdbc = coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe		
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,3)
													and pe.DEid = CargasCalculo.DEid),0)
				where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  
					and CargasCalculo.DClinea in (select dc.DClinea from DCargas dc where dc.DCdbc = 1)
		</cfquery>
	
		<!--- ljimenez CARGAS: Actuliza los dias base de cotizacion a utilizar para calcular las cargas 
		dias DBC2 Sueldos + Vacaciones - Incapacidades --->
		<cfquery name="rsDBC" datasource="#Arguments.datasource#">
			update CargasCalculo set CCdbc = coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe		
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,3,13)
													and pe.DEid = CargasCalculo.DEid)
											, coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe		
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,3)
													and pe.DEid = CargasCalculo.DEid),0))
				where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  
					and CargasCalculo.DClinea in (select dc.DClinea from DCargas dc where dc.DCdbc = 2)
		</cfquery>
		
		<!--- ljimenez CARGAS: Actuliza los dias base de cotizacion a utilizar para calcular las cargas 
		dias DBC3 Sueldos + Vacaciones - Permisos(Faltas) --->
		<cfquery name="rsDBC" datasource="#Arguments.datasource#">
			update CargasCalculo set CCdbc = coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe		
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,3,5)
													and pe.DEid = CargasCalculo.DEid)
											, coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe		
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,3)
													and pe.DEid = CargasCalculo.DEid),0))
				where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">  
					and CargasCalculo.DClinea in (select dc.DClinea from DCargas dc where dc.DCdbc = 3)
		</cfquery>
	</cfif>

	<cfquery datasource="#Arguments.datasource#" name="rsSMG">
		select distinct DEid 
		from  CargasCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
		
	<cfif vUsaSBC eq 1>	
		<cfloop query="rsSMG">
			<cfquery datasource="#Arguments.datasource#">
				update CargasCalculo set CCsmg = #SMG(rsSMG.DEid)#
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSMG.DEid#">
			</cfquery>
		</cfloop>
	</cfif>
		
	<cfif CalendarioPagos.CPnodeducciones EQ 0><!--- verificacion sobre calculo de deducciones en la nomina --->
		 <!--- DEDUCCIONES --->
		 <cfquery datasource="#Arguments.datasource#">
			 insert into DeduccionesCalculo (Did, RCNid, DEid, DCvalor, DCinteres, DCbatch, DCmontoant, DCcalculo)
			 select a.Did, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, 0.00, 0.00, null, 0.00, 0
			 from DeduccionesEmpleado a, SalarioEmpleado c, TDeduccion d
			 where c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			   and c.SEcalculado = 0
			   and a.Dactivo = 1
			   <cfif IsDefined('Arguments.pDEid')>and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			   and a.DEid = c.DEid
			   and a.Dfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RChasta#">
			   and coalesce(a.Dfechafin,<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaDefault#">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RCdesde#">
			   and d.TDid = a.TDid 
			   and d.TDrenta = 0<!--- DAG 20/04/2007: No incluir deducciones de tipo renta, porque estas se incluiran como Renta --->
		</cfquery>
		<!--- Borrar deducciones que no se pagan en esta Nómina, cuando hay registros --->
		<cfquery datasource="#Arguments.datasource#" name="exists">
			select 1
			from RHExcluirDeduccion
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		<cfif exists.RecordCount>
			<cfquery datasource="#Arguments.datasource#">
				delete from DeduccionesCalculo
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and exists ( 	select 1
								from #EmpleadosNomina# a
								where a.DEid = DeduccionesCalculo.DEid
								  and exists(	select 1
												from DeduccionesEmpleado de, RHExcluirDeduccion ed
												where de.Did = DeduccionesCalculo.Did
												and ed.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
												and ed.CPid = DeduccionesCalculo.RCNid
												and de.TDid = ed.TDid
											) 
							)
			</cfquery>		
			
		</cfif>
	</cfif><!--- /fin de verificacion sobre calculo de deducciones en la nomina --->
	
	<cfquery datasource="#Arguments.datasource#">
		 insert into RHPagosExternosCalculo (PEXid, Ecodigo, PEXTid, DEid, RCNid, PEXmonto, PEXperiodo, PEXmes, Ifechasis, BMUsucodigo, PEXfechaPago)
		 select pext.PEXid, pext.Ecodigo, pext.PEXTid, pext.DEid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, 
		 	pext.PEXmonto, pext.PEXperiodo, pext.PEXmes, <cf_dbfunction name="now">, pext.BMUsucodigo, pext.PEXfechaPago
		 from #EmpleadosNomina# e
		 	inner join RHPagosExternos pext
		 	on pext.DEid = e.DEid
		 	and pext.PEXfechaPago <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaHastaControl#">
			<cfif IsDefined('Arguments.pDEid')>and e.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#">
		<!---select b.Tcodigo, b.Ecodigo, b.CPmes, b.CPperiodo,a.ICfecha, a.RCNid, b.CPid, a.*
			from IncidenciasCalculo a, CalendarioPagos b
				where a.ICfecha between b.CPdesde and b.CPhasta
					and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and ltrim(rtrim(b.Tcodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">--->
		update IncidenciasCalculo set CPmes = (select b.CPmes
                                            from IncidenciasCalculo a, CalendarioPagos b
                                            where   a.ICfecha between b.CPdesde and b.CPhasta
                                                and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                                            and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                                                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
												and b.CPid = a.RCNid
                                                and IncidenciasCalculo.ICid = a.ICid
                                                and IncidenciasCalculo.DEid = a.DEid)
                                                , CPperiodo = (select b.CPperiodo
                                            from IncidenciasCalculo a, CalendarioPagos b
                                            where   a.ICfecha between b.CPdesde and b.CPhasta
                                                and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                                            and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                                                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
												and b.CPid = a.RCNid
                                                and IncidenciasCalculo.ICid = a.ICid
                                                and IncidenciasCalculo.DEid = a.DEid)
	
	</cfquery>
	
<!---	<cfquery datasource="#Arguments.datasource#" name="x">
		select *
		from IncidenciasCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and DEid = 87355
	</cfquery>
	<cfdump var="#x#">--->

    <!--- CALCULO DE LA NOMINA--->
	
	<!---ljimenezretro--->
    <cfinvoke component="RH_CalculoNomina" method="CalculoNomina">
		<cfinvokeargument name="datasource" value="#Arguments.datasource#">
                <cfinvokeargument name="Ecodigo" 		value = "#Arguments.Ecodigo#">
                <cfinvokeargument name="RCNid" 			value = "#Arguments.RCNid#">
                <cfinvokeargument name="Tcodigo" 		value = "#RCalculoNomina.Tcodigo#">
                <cfinvokeargument name="RCdesde" 		value = "#RCalculoNomina.RCdesde#">
                <cfinvokeargument name="RChasta" 		value = "#RCalculoNomina.RChasta#">
                <cfinvokeargument name="IRcodigo" 		value = "#IRcodigo#">
                <cfinvokeargument name="Usucodigo" 		value = "#Arguments.Usucodigo#">
                <cfinvokeargument name="Ulocalizacion" 	value = "#Arguments.Ulocalizacion#">
                <cfinvokeargument name="debug" 			value = "#Arguments.debug#">
				<cfif IsDefined('Arguments.pDEid')>
					<cfinvokeargument name="pDEid" value = "#Arguments.pDEid#">
				</cfif>
	</cfinvoke>
	
                
   <cfif Arguments.debug>
   		<cfquery datasource="#Arguments.datasource#" name="SalarioEmpleado">
			select  RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinodeduc, SEinocargas, SEinorenta
			from SalarioEmpleado 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>
		<cfdump var="SalarioEmpleado">
		
		<cfquery datasource="#Arguments.datasource#" name="PagosEmpleado">
			select  PElinea, DEid, RCNid, LTid, RHJid, PEhjornada, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, RHTid, RHPid, RHPcodigo, LTporcplaza, PEtiporeg
			from PagosEmpleado 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			order by DEid, PEdesde, PEhasta
		</cfquery>
		<cfdump var="PagosEmpleado">
		
		<cfquery datasource="#Arguments.datasource#" name="IncidenciasCalculo">
			select  ICid, RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, ICcalculo, ICmontores, CFid, RHSPEid
			from IncidenciasCalculo 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
        </cfquery>
		<cfdump var="IncidenciasCalculo">
		
		<cfquery datasource="#Arguments.datasource#" name="CargasCalculo">
			select  DClinea, RCNid, DEid, CCvaloremp, CCvalorpat
			from CargasCalculo 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
        </cfquery>
		<cfdump var="CargasCalculo">
		
		<cfquery datasource="#Arguments.datasource#" name="DeduccionesCalculo">
			select RCNid, DEid, Did, DCvalor, DCinteres, DCcalculo
			from DeduccionesCalculo 
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>
		<cfdump var="DeduccionesCalculo">
		
    </cfif>
	
	
<cfif CalendarioPagos.CPtipo NEQ 0 and CalendarioPagos.CPtipo NEQ 2 and CalendarioPagos.CPtipo NEQ 3>
    <!--- Eliminar de la relacion a todos los funcionarios que no tienen pagos --->
	<cfquery datasource="#Arguments.datasource#">
	   delete from IncidenciasCalculo
	   where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
	     <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		 and exists (  select 1 
	   				   from SalarioEmpleado b
					   where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
						  <cfif IsDefined('Arguments.pDEid')>and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
						  and b.SEincidencias = 0.00
						  and b.SEliquido = 0.00
						  and IncidenciasCalculo.RCNid = b.RCNid
						  and IncidenciasCalculo.DEid = b.DEid )
						  
	</cfquery>
	
	<cfquery datasource="#Arguments.datasource#"> 
	   delete from CargasCalculo
	   where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	   <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	   and exists ( 	select 1
					   from SalarioEmpleado b
					   where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
						  <cfif IsDefined('Arguments.pDEid')>and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
						  and b.SEincidencias = 0.00
						  and b.SEliquido = 0.00
						  and CargasCalculo.RCNid = b.RCNid
						  and CargasCalculo.DEid = b.DEid )
	</cfquery>
 	
	<cfquery datasource="#Arguments.datasource#">
	   delete from DeduccionesCalculo
	   where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		and exists( 	select 1
					   from SalarioEmpleado b
					   where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
						  <cfif IsDefined('Arguments.pDEid')>and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
						  and b.SEincidencias = 0.00
						  and b.SEliquido = 0.00
						  and DeduccionesCalculo.RCNid = b.RCNid
						  and DeduccionesCalculo.DEid = b.DEid )
 	</cfquery>

	<cfquery datasource="#Arguments.datasource#">
	   delete PagosEmpleado
	   where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		and exists( 	select 1
					   from SalarioEmpleado b
					   where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
						  <cfif IsDefined('Arguments.pDEid')>and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
						  and b.SEincidencias = 0.00
						  and b.SEliquido = 0.00
						  and PagosEmpleado.RCNid = b.RCNid
						  and PagosEmpleado.DEid = b.DEid )
 	</cfquery>
	
	
	<cfquery datasource="#Arguments.datasource#">
		delete SalarioEmpleado
		 where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		  and SEincidencias = 0.00
		  and SEliquido = 0.00
 	</cfquery>
</cfif>
<cfif Arguments.debug>
	<cftransaction action="rollback"/>
	<cfoutput>Invocado con debug = true, abortando</cfoutput><cfabort>
</cfif>
</cftransaction>
<cf_dbtemp_deletes>
<!--- end --->
</cffunction>
</cfcomponent>