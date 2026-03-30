<cfcomponent hint="Carga los datos requeridos para una Relación de Cálculo de Nómina, equivale a rh_RelacionCalculo">
    <cf_dbfunction name="OP_concat"	returnvariable="_CAT">
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
    <cfargument name="datasource" 			type="string" 	required="no">
    <cfargument name="Ecodigo"	  			type="numeric" 	required="no">
    <cfargument name="RCNid" 	  			type="numeric" 	required="yes">
    <cfargument name="Usucodigo"  			type="numeric" 	required="no">
    <cfargument name="Tcodigo" 				type="string" 	required="no">
    <cfargument name="Ulocalizacion" 		type="string"   required="no">
    <cfargument name="debug" 				type="boolean"  required="no" default="no">
    <cfargument name="pDEid" 				type="numeric" 	required="no">
    <cfargument name="ValidarCalendarios" 	type="boolean" 	required="no" default="true" hint="True.Cuenta Calendario X mes. False.Estima Calendarios X mes, esto para la proyeccion de la Renta">


<!---
** Carga los datos requeridos para una Relación de Cálculo de Nómina
** Hecho por: Marcel de Mézerville L.
** Fecha: 03 Junio 2003
--->

<cfset var IRcodigo 	        = ''> <!---char(5)--->
<cfset var CantDiasMensual      = 0>  <!---int--->
<cfset var DiasAjuste 	        = 0>  <!---int--->
<cfset var DiasMes 		        = 0>  <!---int--->
<cfset var CantDiasParametro    = 0>  <!---int--->
<cfset var fecha 			    = ''> <!---datetime--->
<cfset var indicadornopago      = 'N'><!---char(1)--->
<cfset var dia1 			    = ''> <!---datetime--->
<cfset var ContabilizaGastosMes = 0>  <!---int--->
<CFIF NOT ISDEFINED('Arguments.Tcodigo')>
	<cfset LvarRsERC 		 = GetRCalculoNomina(Arguments.RCNid)>
	<cfset Arguments.Tcodigo = LvarRsERC.Tcodigo>
</CFIF>
<CFIF NOT ISDEFINED('Arguments.Usucodigo') AND ISDEFINED('session.Usucodigo')>
	<cfset Arguments.Usucodigo = session.Usucodigo>
</CFIF>
<CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
	<cfset Arguments.Ecodigo = session.Ecodigo>
</CFIF>
<CFIF NOT ISDEFINED('Arguments.datasource') AND ISDEFINED('session.dsn')>
	<cfset Arguments.datasource = session.dsn>
</CFIF>
<CFIF NOT ISDEFINED('Arguments.Ulocalizacion')>
	<cfif isdefined('session.Ulocalizacion')>
		<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
    <cfelse>
    	<cfset Arguments.Ulocalizacion = '00'>
    </cfif>
</CFIF>

<cf_dbtemp name="PagosEmpV01" returnvariable="PagosEmpleado" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="RCNid" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="DEid" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="PEbatch" 		type="numeric" 			mandatory="no">
	<cf_dbtempcol name="PEdesde" 		type="datetime" 		mandatory="yes">
	<cf_dbtempcol name="PEhasta" 		type="datetime" 		mandatory="yes">
	<cf_dbtempcol name="PEsalario" 		type="money" 			mandatory="yes">
    <cf_dbtempcol name="PEsalarioref" 	type="money" 		 	mandatory="no">
	<cf_dbtempcol name="PEcantdias" 	type="money" 				mandatory="yes">
	<cf_dbtempcol name="PEmontores" 	type="money" 			mandatory="yes">
	<cf_dbtempcol name="PEmontoant" 	type="money" 			mandatory="yes">
	<cf_dbtempcol name="cortedesde" 	type="datetime"			mandatory="no">
	<cf_dbtempcol name="cortehasta" 	type="datetime" 		mandatory="no">
	<cf_dbtempcol name="Tcodigo" 		type="char(5)" 			mandatory="yes">
	<cf_dbtempcol name="RHTid" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="Ocodigo" 		type="int"	 			mandatory="yes">
	<cf_dbtempcol name="Dcodigo" 		type="int" 				mandatory="yes">
	<cf_dbtempcol name="RHPid" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="RHPcodigo" 		type="char(10)" 		mandatory="yes">
	<cf_dbtempcol name="RVid" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="LTporcplaza" 	type="float" 			mandatory="no">
	<cf_dbtempcol name="LTid" 			type="numeric" 			mandatory="no">
	<cf_dbtempcol name="LTRid" 			type="numeric" 			mandatory="no">
	<cf_dbtempcol name="RHJid" 			type="numeric" 			mandatory="yes">
	<cf_dbtempcol name="PEhjornada" 	type="float" 			mandatory="yes">
	<cf_dbtempcol name="PEtiporeg" 		type="int default 0"	mandatory="yes">
	<cf_dbtempcol name="CPid" 			type="numeric" 			mandatory="no">
	<cf_dbtempcol name="PEsalariobc" 	type="money" 			mandatory="no">
	<cf_dbtempcol name="PEsalarioCS" 	type="money" 			mandatory="no">
	<cf_dbtempcol name="RHTcomportam" 	type="int default 0" 	mandatory="no">
	<cf_dbtempcol name="LTsalrec" 		type="money" 			mandatory="no">
	<cf_dbtempcol name="CPmes" 			type="int" 				mandatory="no">
	<cf_dbtempcol name="CPperiodo" 		type="int" 				mandatory="no">
    <cf_dbtempcol name="FactorFalta"	type="money" 			mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="CalendariosEmpleado" returnvariable="CalendariosEmpleado" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="CPid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="CPdesde" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="CPhasta" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="CPmes" 		type="int" 		mandatory="yes">
	<cf_dbtempcol name="CPperiodo" 	type="int" 		mandatory="yes">

</cf_dbtemp>
<cf_dbtemp name="IncidenciasReb" returnvariable="IncidenciasReb" datasource="#Arguments.datasource#">
	<!--- Tabla de control de los montos a rebajar --->
	<cf_dbtempcol name="RCNid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="DEid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="CIid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="ICfecha" 		type="datetime"	mandatory="no">
	<cf_dbtempcol name="ICvalor" 		type="money" 	mandatory="no">
	<cf_dbtempcol name="ICfechasis" 	type="datetime" mandatory="no">
	<cf_dbtempcol name="CFid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="RHSPEid" 		type="numeric" 	mandatory="no">
	<cf_dbtempcol name="diassalario"	type="money" 	mandatory="no">
	<cf_dbtempcol name="saldoreb" 		type="money" 	mandatory="no">
	<cf_dbtempcol name="saldosub" 		type="money" 	mandatory="no">
	<cf_dbtempcol name="dias" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="diasacum" 		type="money" 	mandatory="no">
	<cf_dbtempcol name="diasant" 		type="money" 	mandatory="no">
	<cf_dbtempcol name="fechaDesde" type="datetime" mandatory="no">
</cf_dbtemp>
<cf_dbtemp name="IncidenciasControlSaldos" returnvariable="IncidenciasControlSaldos" datasource="#Arguments.datasource#">
	<!--- Tabla de control saldos de los montos --->
	<cf_dbtempcol name="RCNid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="DEid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="DLlinea" 		type="numeric" 	mandatory="no">
	<cf_dbtempcol name="CIid" 			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="ICfechadesde" 	type="datetime"	mandatory="no">
	<cf_dbtempcol name="ICfechashasta" 	type="datetime" mandatory="no">
	<cf_dbtempcol name="dias" 			type="numeric" 	mandatory="no">
</cf_dbtemp>
<cf_dbtemp name="EmpleadosNomina" returnvariable="EmpleadosNomina" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="DEid" type="numeric" 	mandatory="no">
	<cf_dbtempcol name="dias" type="int" 		mandatory="no">
</cf_dbtemp>

<cf_dbtemp name="PIncidentes" returnvariable="PagosIncidentes" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="PImonto" 	type="money" 	mandatory="no">
</cf_dbtemp>

 <!--- TABLA PARA SALARIOS DE RECARGO--->
<cf_dbtemp name="PagosRecargos" returnvariable="PagosRecargos" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="LTRid" 		type="numeric"	mandatory="yes">
    <cf_dbtempcol name="RHPid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="PEdesde" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="PEhasta" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="no">
	<cf_dbtempcol name="PEmontores"	type="money" 	mandatory="no">
	<cf_dbtempcol name="PEsalario" 	type="money" 	mandatory="no">
    <cf_dbtempcol name="PEcantdias" type="int" 		mandatory="no">
</cf_dbtemp>

<!--- TABLA PARA SALARIOS DE RECARGO--->
<cf_dbtemp name="RPagosRecargos" returnvariable="PagosRecargosRetro" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="LTRid" 		type="numeric" 	mandatory="yes">
    <cf_dbtempcol name="RHPid" 		type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="PEdesde" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="PEhasta" 	type="datetime" mandatory="yes">
	<cf_dbtempcol name="DEid" 		type="numeric" 	mandatory="no">
	<cf_dbtempcol name="PEmontores" type="money" 	mandatory="no">
	<cf_dbtempcol name="PEsalario" 	type="money" 	mandatory="no">
    <cf_dbtempcol name="PEcantdias" type="int" 		mandatory="no">
</cf_dbtemp>

<!--- TABLA PARA CALCULAR LOS DÍAS PAGADOS EN LA NÓMINA --->
<cf_dbtemp name="RDiasPagar" returnvariable="RDiasPagar" datasource="#Arguments.datasource#">
	<cf_dbtempcol name="DEid" 	type="numeric" 	mandatory="yes">
    <cf_dbtempcol name="RHPid" 	type="numeric" 	mandatory="yes">
	<cf_dbtempcol name="dias" 	type="int" 		mandatory="no">
</cf_dbtemp>

<cfset apruebaIncidencias = false >
<cfset apruebaIncidenciasN = false >
<cfset apruebaIncidenciasC = false >

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="2025" default="0" returnvariable="vUsaSBC"/>
<cfif vUsaSBC>
	<cfquery name="rsCalendar" datasource="#session.dsn#" >
        select case
                    when CPmes <= 2  then 2
                    when CPmes <= 4  then 4
                    when CPmes <= 6  then 6
                    when CPmes <= 8  then 8
                    when CPmes <= 10 then 10
                    when CPmes <= 12 then 12
              end as CPmes
        , CPperiodo
        from CalendarioPagos
        where CPid = #Arguments.RCNid#
    </cfquery>


	<!---<cfinvoke component="rh.Componentes.RH_CalculoSDI_Historico" method="ConsultaBitacoraSDI" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" periodo='#rsCalendar.CPperiodo#' mes='#rsCalendar.CPmes#'  returnvariable="rsDatos"/>
    <cfif isdefined('rsDatos') and rsDatos.RecordCount EQ 0>
    	<cf_throw message="Error, no se se a generado informacion de SDI para Bimestre en curso favor de generar información. Proceso Cancelado.">
    </cfif>--->
</cfif>


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
    from RCalculoNomina a
    	inner join TiposNomina b
        	on a.Ecodigo = b.Ecodigo
	       and a.Tcodigo = b.Tcodigo
    where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
</cfquery>

<cfquery datasource="#arguments.datasource#" name="CalendarioPagos">
    select CPcodigo,CPtipo,CPdesde,CPhasta, CPnodeducciones,CPmes,CPperiodo,IRcodigo
    from CalendarioPagos
    where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
</cfquery>

<cfset LvarFechaHastaControl = CalendarioPagos.CPhasta>
<cfset LvarCpmes	=	CalendarioPagos.CPmes>
<cfset LvarCPperiodo=	CalendarioPagos.CPperiodo>

<!--- Obtener la cantidad de días máximo según tipo de Nómina
adicionalmente se lee el factor de dias para el calculo del imss en mexico si no existe se toma el valor de factor dias nomales--->
<cfquery name="rsCantDiasMensual" datasource="#arguments.datasource#">
	select FactorDiasSalario, FactorDiasIMSS, IRcodigo
    from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
</cfquery>

<cfif len(trim(rsCantDiasMensual.FactorDiasSalario)) and rsCantDiasMensual.FactorDiasSalario gt 0>
	<cfset CantDiasMensual = rsCantDiasMensual.FactorDiasSalario >
<cfelse>
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="14600708" default="N" returnvariable="FactorQUincenal"/>
	<cfif FactorQUincenal eq 'S'>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>
	<cfelse>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="70" default="" returnvariable="CantDiasMensual"/>
	</cfif>
</cfif>

<!---si no viene definido ninguno de los 2 valores usa el que se define en parametros generales para ambas variables--->
<cfif len(trim(rsCantDiasMensual.FactorDiasIMSS)) and rsCantDiasMensual.FactorDiasIMSS gt 0>
	<cfset CantDiasMensualIMSS = rsCantDiasMensual.FactorDiasIMSS >
<cfelse>
	<cfset CantDiasMensualIMSS = #CantDiasMensual# >
</cfif>

<!---ljimenez leemos el factor de dias por mes--->
<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="80" default="" returnvariable="FactorDiasMensual"/>


<cfif Len(trim(CantDiasMensual)) eq 0 or CantDiasMensual eq 0 >
	<cfthrow message="Error, debe definirse la cantidad de días a utilizar para el cálculo de la nómina mensual en los parámetros del Sistema y debe ser un valor diferente de cero. Proceso Cancelado.">
</cfif>
<cfif Arguments.debug>
	<cfoutput>DIAS PARA CALCULO DE SALARIO #CantDiasMensual#</cfoutput>
</cfif>

<!---validacion de vigencia de la tabla de renta y su existencia--->

<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#"
	pvalor="2035" default="0" returnvariable="vUsaTablaEnNomina"/>

<cfif #vUsaTablaEnNomina# and Len(rsCantDiasMensual.IRcodigo) GT 0>
	<cfset IRcodigo = #rsCantDiasMensual.IRcodigo#>
<!---ERBG Si el tipo es nomina especial entonces busca usi tiene definida una tabla para la paga Inicia--->
	<cfif CalendarioPagos.CPtipo EQ 1 and len(trim(CalendarioPagos.IRcodigo)) GT 0>
    	<cfset IRcodigo = #CalendarioPagos.IRcodigo#>
	</cfif>
<!---ERBG Si el tipo es nomina especial entonces busca usi tiene definida una tabla para la paga Fin--->
<cfelse>
    <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#"
        pvalor="30" default="" returnvariable="IRcodigo"/>

    <cfif Not Len(IRcodigo)>
        <cfthrow message='Error!, No se ha definido la Tabla de Impuesto de Renta a utilizar en los parámetros del Sistema. Proceso Cancelado!!'>
    </cfif>
</cfif>

<cfquery datasource="#Arguments.datasource#" name="countEImpuestoRenta">
	select count(1)  as cnt
	from EImpuestoRenta b
	where b.IRcodigo =
    	<cfif #vUsaTablaEnNomina# and Len(rsCantDiasMensual.IRcodigo) GT 0>
	        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCantDiasMensual.IRcodigo#">
        <cfelse>
        	<cfqueryparam cfsqltype="cf_sql_varchar" value="#IRcodigo#">
        </cfif>
	and b.EIRestado = 1
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> between b.EIRdesde and b.EIRhasta
</cfquery>

<cfif countEImpuestoRenta.cnt is 0>
	<cfthrow message='Error!, el rango de fechas de la Relación de Cálculo de Nómina (#LSDateFormat(RCalculoNomina.RCdesde, "dd/mm/yyyy")# - #LSDateFormat(RCalculoNomina.RChasta, "dd/mm/yyyy")#) no está contenido en la Tabla de Impuesto de Renta #IRcodigo#. Proceso Cancelado!!'>
</cfif>


        <!--- Inserta los Pagos de Empleados para el Tipo de Nómina de la relación --->
	<cfif CalendarioPagos.CPtipo NEQ 3>
			<cfquery datasource="#Arguments.datasource#" name="rsInsPagos">
				insert into #PagosEmpleado# (
					RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores,
					PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
					RHPcodigo, RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,LTsalrec)
                   select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
                            a.DEid, null, a.LTdesde, a.LThasta,

                            case when b.RHTpaga = 1 then (round
                                (a.LTsalario -(select coalesce(sum(DLTmonto),0)
                                                    from DLineaTiempo dlt
                                                  where dlt.LTid = a.LTid
                                                and CIid in (select d.CIid  <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
                                                             )
                                               ),2)
                                * coalesce(a.LTporcsal,100)/100)
                                 else 0.00 end ,
                              <!---ASI ESTABA ANTES, LO CAMBIE EN TODOS LOS CASOS-case when b.RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, --->

                            <!---???Salario de Referencia??--->
                            round(a.LTsalario -(select coalesce(sum(DLTmonto),0)
                                                    from DLineaTiempo
                                                  where LTid = a.LTid
                                                   and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
															<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->)
                                    ),2) * coalesce(a.LTporcsal,100)/100 ,

                            0,

                            case when b.RHTpaga = 1 then (round
                                (a.LTsalario -(select coalesce(sum(DLTmonto),0)
													from DLineaTiempo dlt
                                                where dlt.LTid=a.LTid
                                                and CIid in (select d.CIid
															 from ComponentesSalariales d
															 inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#

															 <!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
                                                             )
                                               ),2)
                                * coalesce(a.LTporcsal,100)/100)
                                 else 0.00 end PEmontores,

                            0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo,
                            a.RVid, a.LTporcplaza, a.LTid,0, a.RHJid, c.RHJhoradiaria, 0,

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
					<!--- OPARRALES 2018-10-31 Validaciones para aguinaldos, solo debe tomar acciones de nombramiento --->
					<cfif CalendarioPagos.CPtipo eq 1>
					 <!--- JARR aqui tambien estuvo Maltin AND b.RHTcomportam = 1  Acciones de nombramiento --->
					</cfif>
                    <cfif CalendarioPagos.CPtipo Is 1><!---Agregado a solicitud de JC Gutierrez (27/04/2009)---->
                         and a.DEid = i.DEid
                         and (i.Iespecial = 1 or i.Icpespecial  =1)
                    </cfif>
			</cfquery>


       <!--- BUSCA LOS RECARGOS DE LOS FUNCIONARIOS --->
        <cfquery name="rs" datasource="#session.DSN#">
        	insert into #PagosRecargos#(LTRid,RHPid,DEid,PEdesde,PEhasta)
			select a.LTRid,a.RHPid,a.DEid,a.LTdesde, a.LThasta
			from LineaTiempoR a, RHTipoAccion b, RHJornadas c
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
			  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and a.Ecodigo = b.Ecodigo
			  and a.RHTid = b.RHTid
			  and a.RHJid = c.RHJid
              and a.LTRid in(select max(LTRid) from LineaTiempoR where DEid =a.DEid and RHPid = a.RHPid group by RHPid,LTdesde,LThasta,DEid)
			  and ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
				  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)
				  or (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">
				  and a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">))
		</cfquery>
        <!--- SE ELIMINAN LOS CORTE DE RECARGOS QUE SE TRASLAPAN, SE DEJA EL ACTUAL --->
        <cfquery datasource="#session.DSN#">
       		delete from #PagosRecargos#
            where LTRid not in(
        	select max(LTRid)
            from #PagosRecargos#
            group by RHPid,PEdesde,PEhasta,DEid)
        </cfquery>

        <!---ljimenez modifica el consulta para que aplique cuado se hace el calculo masivo --->

        <cfquery name="datos" datasource="#Arguments.datasource#">
         insert into #PagosEmpleado# (
                RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores,
                PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
                RHPcodigo, RVid, LTporcplaza,LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,LTsalrec)

				 select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
						a.DEid, null,
                        <!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lvar_FhastaP#">,--->
                         (select <cf_dbfunction name="dateadd"	args="1, max(PEhasta) , DD" >
                                        from #PagosEmpleado#
                                        where #PagosEmpleado#.DEid = a.DEid),
                        a.LThasta,
						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)
												from DLineaTiempoR
											where LTRid=a.LTRid
											and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,
						0,

						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)
												from DLineaTiempoR
											where LTRid=a.LTRid
											and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,
						0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo,
						a.RVid, a.LTporcplaza, 0,a.LTRid, a.RHJid, c.RHJhoradiaria, 0,

						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.RHTcomportam,
						 (select sum(r.LTsalario*LTporcplaza/100) from LineaTiempoR r
								where r.DEid=a.DEid
								and r.LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
								and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)

				from LineaTiempoR a, RHTipoAccion b, RHJornadas c <cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
					 <cfif CalendarioPagos.CPtipo Is 1>, Incidencias i</cfif>
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
				  <cfif IsDefined('Arguments.pDEid')>
                  		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
                  </cfif>
				  and a.Ecodigo = b.Ecodigo
				  and a.RHJid = c.RHJid
                  and b.RHTid = a.RHTid
                  and a.LTRid in(select LTRid from #PagosRecargos# where DEid = a.DEid)
				  and a.LThasta > (select <cf_dbfunction name="dateadd"	args="1, max(PEhasta) , DD" >
                                        from #PagosEmpleado#
                                        where #PagosEmpleado#.DEid = a.DEid)

                  and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#"> >=
                  (select <cf_dbfunction name="dateadd"	args="1, max(PEhasta) , DD" >
                                        from #PagosEmpleado#
                                        where #PagosEmpleado#.DEid = a.DEid)

<!---                  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lvar_FhastaP#">--->
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



       <!--- ljimenez fin cambio calculo masivo--->

		<cfquery datasource="#Arguments.datasource#">
				insert into #PagosEmpleado# (
					RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores,
					PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
					RHPcodigo, RVid, LTporcplaza,LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,LTsalrec)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
						a.DEid, null,
                        case when a.LTdesde > p.PEdesde then a.LTdesde else p.PEdesde end,
                        case when a.LThasta > p.PEhasta then p.PEhasta
                             when a.LThasta <= p.PEhasta then a.LThasta
                        end,
						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)
												from DLineaTiempoR
											where LTRid=a.LTRid
											and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,
						0,

						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)
												from DLineaTiempoR
											where LTRid=a.LTRid
											and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,
						0.00, a.LTdesde, a.LThasta, a.Tcodigo, case when b.RHTpaga = 1 then a.RHTid else p.RHTid end, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo,
						a.RVid, a.LTporcplaza, 0,a.LTRid, a.RHJid, c.RHJhoradiaria, 0,

						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.RHTcomportam,
						 (select sum(r.LTsalario*LTporcplaza/100) from LineaTiempoR r
								where r.DEid=a.DEid
								and r.LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
								and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)

				from LineaTiempoR a, RHTipoAccion b, RHJornadas c <cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
					 <cfif CalendarioPagos.CPtipo Is 1>, Incidencias i</cfif><!---Agregado a solicitud de JC Gutierrez (27/04/2009)---->
                     ,#PagosEmpleado# p
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
				  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				  and a.Ecodigo = b.Ecodigo
				  and p.RHTid = b.RHTid
				  and a.RHJid = c.RHJid
                  and a.LTRid in(select LTRid from #PagosRecargos# where DEid = a.DEid)

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
                and p.DEid = a.DEid
                and p.LTid > 0
                and ((a.LThasta >= p.PEdesde
					  and a.LTdesde <= p.PEhasta)
					  or (a.LTdesde <= p.PEhasta
					  and a.LThasta >= p.PEdesde))
		</cfquery>


     <!--- INSERT QUE TOMA EN CUENTA LOS CORTES DE RECARGOS CUANDO NO SE TIENE LINEA DE TIEMPO ACTUAL --->
        <cfquery name="rsRecargosSinLinea" datasource="#Arguments.datasource#">
				 insert into #PagosEmpleado# (
					RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores,
					PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
					RHPcodigo, RVid, LTporcplaza,LTid,LTRid, RHJid, PEhjornada, PEtiporeg, CPid, RHTcomportam,LTsalrec)
				 select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
						a.DEid, null,
                        a.LTdesde,
                        a.LThasta,
						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)
												from DLineaTiempoR
											where LTRid=a.LTRid
											and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,
						0,

						case when b.RHTpaga = 1 then (round
							(a.LTsalario -(select coalesce(sum(DLTmonto),0)
												from DLineaTiempoR
											where LTRid=a.LTRid
											and CIid in (select d.CIid <!---SML. Modificacion para que no le descuente el fondo de ahorro--->
															 from ComponentesSalariales d inner join CIncidentes e on d.CIid = e.CIid
															 where d.Ecodigo=#session.Ecodigo#
																	<!--- OPARRALES 2018-08-03 Se modifica para considerar todos los Componentes Salariales  --->
															 <!--- and d.CIid is not null --->
															 and d.CSexcluyeCB = Case when d.CSsalariobase = 1 then 0
																	when d.CSsalariobase = 0 and d.CIid is not null then 0
																	else 0 end
																	<!---and e.CIfondoahorro !=1--->
														 )
										   ),2)
							* coalesce(a.LTporcsal,100)/100)
							 else 0.00 end,
						0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo,
						a.RVid, a.LTporcplaza, 0,a.LTRid, a.RHJid, c.RHJhoradiaria, 0,

						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, b.RHTcomportam,
						 (select sum(r.LTsalario*LTporcplaza/100) from LineaTiempoR r
								where r.DEid=a.DEid
								and r.LTdesde between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RCdesde#">
								and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#RCalculoNomina.RChasta#">)

				from LineaTiempoR a, RHTipoAccion b, RHJornadas c <cfif CalendarioPagos.CPtipo Is 2>, DatosEmpleado de</cfif>
					 <cfif CalendarioPagos.CPtipo Is 1>, Incidencias i</cfif>
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RCalculoNomina.Tcodigo#">
				  <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				  and a.Ecodigo = b.Ecodigo
				  and a.RHJid = c.RHJid
                  and b.RHTid = a.RHTid
                  and a.LTRid in(select LTRid from #PagosRecargos# where DEid = a.DEid)
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
               <!--- and a.DEid not in (select distinct DEid from #PagosEmpleado# where DEid = a.DEid)--->
                and a.LTRid not in (select distinct LTRid from #PagosEmpleado# where DEid = a.DEid)
			</cfquery>
   </cfif>




   <cfinclude template="RH_RelacionCalculoRetroactivos.cfm">

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
				<!--- OPARRALES 2019-03-26 Modificacion para considerar empleados cesados con fecha posterior al periodo de pago a calcular --->
				<!---
				and a.DLfvigencia between #PagosEmpleado#.PEdesde and #PagosEmpleado#.PEhasta
				 --->
				and a.DLfvigencia > #PagosEmpleado#.PEhasta
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
						Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg,LTsalrec)
					select RCNid, DEid, PEbatch,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d', 1, fecha)#">, PEhasta,
						PEsalario, PEsalarioref, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo,
						Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg,LTsalrec
					from #PagosEmpleado#
					where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#"> between PEdesde and PEhasta
					  and PEhasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
					  and PEtiporeg < 2
				</cfquery>
				<cfquery datasource="#Arguments.datasource#">
					insert into #PagosEmpleado# (RCNid, DEid, PEbatch, PEdesde, PEhasta,
						PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo,
						Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg,LTsalrec)
					select RCNid, DEid, PEbatch,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">,
						PEsalario,PEsalarioref, 1, 0.00, 0.00, cortedesde, cortehasta, Tcodigo, RHTid,
						Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, 3,LTsalrec
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
					delete from #PagosEmpleado#
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
				RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores,
				PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
				RHPcodigo, RVid, LTporcplaza, LTid,LTRid, RHJid, PEhjornada, PEtiporeg,LTsalrec,
                CPmes,CPperiodo,RHTcomportam)
			select
				RCNid, DEid, PEbatch, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dia1#">,
				PEhasta, PEsalario,PEsalarioref ,PEcantdias, PEmontores,
				PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid,
				RHPcodigo, RVid, LTporcplaza, LTid, LTRid,RHJid, PEhjornada, PEtiporeg,LTsalrec,
                CPmes,CPperiodo,RHTcomportam
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

	<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#" ecodigo="#Arguments.Ecodigo#" pvalor="14600708" default="S" returnvariable="factorISR"/>

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
		<cfif RCalculoNomina.Ttipopago is 2 >
			<!--- OPARRALES 2019-04-15 Modificacion para asignar dias laborados en nomina quincenales. --->
			<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="14600710" default="0" returnvariable="fqEntero"/>
			<cfset CantDiasParametro = CantDiasParametro / 2>
			<cfif fqEntero eq 'S'>
				<cfset CantDiasParametro = round(CantDiasParametro)>
			</cfif>
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
			
			<!--- OPARRALES 2019-07-30 Modificacion para Agregar o descontar la proporcion de dias solo a acciones de Baja --->
			<cfquery name="rsPagosTmp" datasource="#session.dsn#">
				select LTid,RHTcomportam,CPid,PEhasta,DEid,PECANTDIAS
				from #PagosEmpleado# 
				where CPid = #CPids.CPid#
			</cfquery>

			<cfloop query="rsPagosTmp">
				<!--- Buscamos ultimo corte de accion de nombramiento --->
				<cfquery name="rsUltimoCorte" dbtype="query">
					select MAX(PEhasta) PEhastaU 
					from rsPagosTmp
					where CPid = #rsPagosTmp.CPid#
					and DEid = #rsPagosTmp.DEid#
					and RHTcomportam = 1
				</cfquery>

				<!--- Modificacion para sumar un dia solo a empleados dados de alta dentro del periodo de calculo --->		
				<cfif RCalculoNomina.Ttipopago is 2><!--- SOLO NOMINAS QUINCENALES --->
					<cfquery name="rsTotDiasPagar" dbtype="query">
						select sum(PECANTDIAS) PECANTDIAS
						from rsPagosTmp
						where CPid = #CPids.CPid#
						and DEid = #rsPagosTmp.DEid#
					</cfquery>
					
					<cfif (rsTotDiasPagar.PEcantdias + DiasAjuste) lt CantDiasParametro>
						<cfquery datasource="#session.dsn#">
							update #PagosEmpleado#
							set PEcantdias += 0
							where RHTcomportam = 1
							and DEid = #rsPagosTmp.DEid#
							and PEhasta = '#rsUltimoCorte.PEhastaU#'
							and CORTEDESDE > '#LSDateFormat(RCalculoNomina.RCdesde,"YYYY-MM-dd")#'
							and CORTEHASTA >= '#LSDateFormat(RCalculoNomina.RChasta,"YYYY-MM-dd")#'
							and #PagosEmpleado#.LTid = #rsPagosTmp.LTid#
						</cfquery>
					</cfif>
				</cfif>	

				<cfif DiasAjuste LT 0>
					<cfquery datasource="#Arguments.datasource#">
						update #PagosEmpleado#
						<!--- OPARRALES 2019-04-15 Modificacion para asignar dias laborados en nomina quincenales. --->
							set PEcantdias += <cfqueryparam cfsqltype="cf_sql_money" value="#DiasAjuste#">
						where exists ( select 1
						from CalendarioPagos
						WHERE #PagosEmpleado#.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosTmp.CPid#">
						and CalendarioPagos.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosTmp.CPid#">
						and #PagosEmpleado#.PEtiporeg < 2
						<!--- OPARRALES 2019-04-15 Modificacion para asignar dias laborados en nomina quincenales. --->
						<cfif RCalculoNomina.Ttipopago is 3>
							and #PagosEmpleado#.PEhasta > <cf_dbfunction name="dateadd" args="#DiasAjuste#,CalendarioPagos.CPhasta">
						<cfelse>
							<cfif rsPagosTmp.RHTcomportam eq 2 or rsPagosTmp.RHTcomportam eq 6><!--- Bajas --->
								and #PagosEmpleado#.PEhasta <= CalendarioPagos.CPhasta
							<cfelse>
								and #PagosEmpleado#.RHTcomportam = 1 and PEhasta = '#rsUltimoCorte.PEhastaU#'
							</cfif>
						</cfif>
						)
						and ((PEcantdias+#DiasAjuste#) <= #CantDiasParametro#)
						and #PagosEmpleado#.LTid = #rsPagosTmp.LTid#
					</cfquery>
				</cfif>

				<cfif DiasAjuste GT 0>
					<cfquery datasource="#Arguments.datasource#">
						update #PagosEmpleado#
						<!--- OPARRALES 2019-04-15 Modificacion para asignar dias laborados en nomina quincenales. --->
							set PEcantdias += <cfqueryparam cfsqltype="cf_sql_money" value="#DiasAjuste#">
						where exists ( select 1
						from CalendarioPagos
						WHERE #PagosEmpleado#.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosTmp.CPid#">
						and CalendarioPagos.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosTmp.CPid#">
						<cfif rsPagosTmp.RHTcomportam eq 2 or rsPagosTmp.RHTcomportam eq 6><!--- Bajas --->
							and #PagosEmpleado#.PEhasta <= CalendarioPagos.CPhasta
						<cfelse>
							and #PagosEmpleado#.RHTcomportam = 1 and PEhasta = '#rsUltimoCorte.PEhastaU#'
						</cfif>
						and #PagosEmpleado#.PEtiporeg < 2
						)
						and ((PEcantdias+#DiasAjuste#) <= #CantDiasParametro#)
						and #PagosEmpleado#.LTid = #rsPagosTmp.LTid#
					</cfquery>
				</cfif>
			</cfloop>
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


    	<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set FactorFalta =  coalesce(
                    (select RHTfactorfalta
                        from RHTipoAccion ta
	                    where ta.RHTid = #PagosEmpleado#.RHTid),1)
			where PEmontores != 0.00
			and PEtiporeg < 2
		</cfquery>




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
            	and RHTcomportam <> 13
			and PEtiporeg < 2
		</cfquery>

        <!---ljs Calcula el valor de las faltas y se multiplica por -1 para hacer el descuento en el salario por que la accion esta marcada como pago--->
        <cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEmontores = round(((((PEmontores / <cfqueryparam cfsqltype="cf_sql_float" value="#rs_factordias.FactorDiasSalario#">) * PEcantdias)* FactorFalta) *-1)
			<!--- OPARRALES 2018-10-09 Se comenta para el calculo correcto de ausentismos --->
			+ (PEmontores / <cfqueryparam cfsqltype="cf_sql_float" value="#rs_factordias.FactorDiasSalario#">) * PEcantdias, 2)
			<!--- OPARRALES 2019-01-02 Se descomenta por que el calculo lo hace mal.... Pendiente a revisar  --->
			where PEmontores != 0.00
            	and RHTcomportam = 13 <!--- Ausentismos --->
			and PEtiporeg < 2
		</cfquery>

		<cfquery datasource="#Arguments.datasource#">
			update #PagosEmpleado#
			set PEmontores = 0
			where PEmontores != 0.00
            	and RHTcomportam = 13
			and PEtiporeg < 2
            and DEid in (select DEid from #PagosEmpleado#
                            group by RCNid ,DEid
                            having sum(PEmontores) <0)
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
		where ltrim(rtrim(Dreferencia)) = '#trim(CalendarioPagos.CPcodigo)#-#trim(Arguments.RCNid)#'
          and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
	<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
    <cfquery datasource="#Arguments.datasource#">
	    delete from RHfondoahorro
        where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
    </cfquery>
    <cfquery datasource="#Arguments.datasource#"> <!---Eliminar los datos para recalcular SML--->
		delete from RHSubsidio
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
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
		insert into #RDiasPagar#(DEid,RHPid,dias)
		select DEid,RHPid,sum(PEcantdias)
			 from #PagosEmpleado#
			 where #PagosEmpleado#.PEtiporeg = 0
			   and #PagosEmpleado#.PEmontores != 0.00
        group by DEid,RHPid
     </cfquery>

      <cfquery datasource="#Arguments.datasource#">
		 update #EmpleadosNomina#
		 set dias = coalesce(
			(select max(dias)
			 from #RDiasPagar#
			 where #RDiasPagar#.DEid =  #EmpleadosNomina#.DEid), 0)
      </cfquery>
	  <!--- SalarioEmpleado --->
	  <cfquery datasource="#Arguments.datasource#">
		 insert into SalarioEmpleado (RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinorenta, SEinocargas, SEinodeduc,SEsalrec, SEespecie)
		 select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, DEid, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00,0.00,0.00
		 from #EmpleadosNomina#
     </cfquery>

<!---	  se ingresan los montos de otros patronos---->
	 <cfquery datasource="#Arguments.datasource#">
	 	UPDATE SalarioEmpleado
		set SEotrossalarios= coalesce(
													(Select sum(SalarioBase)
													  from SalariosOtrosPatronos sop
													  where sop.DEid=SalarioEmpleado.DEid
													  and sop.Ecodigo=#session.Ecodigo#
													)
										,0)
		WHERE RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	 </cfquery>

	 <!---ljimenez aca paso los datos de los dias laborados de la tabla temporal --->


	 <!--- Pagos Empleado --->



	 <cfquery datasource="#Arguments.datasource#">
		 insert into PagosEmpleado (DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,PEsalariobc, CPmes, CPperiodo,PEsalrec,LTRid)
		 select DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario,PEsalarioref, PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg,PEsalariobc, CPmes, CPperiodo,LTsalrec,LTRid
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

<!--- ********************** ARCHIVO QUE CONTIENE LOS CALCULOS DE LOS CONCEPTOS INCIDENTES ************************** --->
<cfinclude template="RH_RelacionCalculoIncidencias.cfm">
<!--- ********************** FIN ARCHIVO QUE CONTIENE LOS CALCULOS DE LOS CONCEPTOS INCIDENTES ************************** --->

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

	<!--- CARGAS: Insertar las Cargas que tiene el empleado   --->
	<cfquery datasource="#Arguments.datasource#" >
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
		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo set CCdbc = coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,6,8)<!---no se suman los dias de vac por medio de acciones sino que se suman la cantidad de la incidencias--->
													and pe.DEid = CargasCalculo.DEid),0)<!---para que no se sumen en las dos nominas normal pago salario y especial pago dias vac--->

                                          +   coalesce((select coalesce(sum(a.ICvalor),0)
                                                    from IncidenciasCalculo a
                                                    where a.DEid = CargasCalculo.DEid
                                                        and a.RCNid = CargasCalculo.RCNid
                                                        and CIid  in (select distinct a.CIid
                                                                from RHReportesNomina c
                                                                    inner join RHColumnasReporte b
                                                                                inner join RHConceptosColumna a
                                                                                on a.RHCRPTid = b.RHCRPTid
                                                                         on b.RHRPTNid = c.RHRPTNid
                                                                        and b.RHCRPTcodigo = 'IVacaciones'	<!--- Incidencia de Pago de vacaciones --->
                                                                where c.RHRPTNcodigo = 'PR001'				<!--- Codigo Reporte Dinamico  Parametros de Incidenias pago vacaciones--->
                                                                  and c.Ecodigo = #session.Ecodigo#)),0)
				where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and CargasCalculo.DClinea in (select dc.DClinea from DCargas dc where dc.DCdbc = 1)
		</cfquery>



		<!--- ljimenez CARGAS: Actuliza los dias base de cotizacion a utilizar para calcular las cargas
		dias DBC2 Sueldos + Vacaciones - Incapacidades --->
		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo set CCdbc = coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,6,8,13)
													and pe.DEid = CargasCalculo.DEid),0)

                                            +   coalesce((select coalesce(sum(a.ICvalor),0)
                                                    from IncidenciasCalculo a
                                                    where a.DEid = CargasCalculo.DEid
                                                        and a.RCNid = CargasCalculo.RCNid
                                                        and CIid  in (select distinct a.CIid
                                                                from RHReportesNomina c
                                                                    inner join RHColumnasReporte b
                                                                                inner join RHConceptosColumna a
                                                                                on a.RHCRPTid = b.RHCRPTid
                                                                         on b.RHRPTNid = c.RHRPTNid
                                                                        and b.RHCRPTcodigo = 'IVacaciones'	<!--- Incidencia de Pago de vacaciones --->
                                                                where c.RHRPTNcodigo = 'PR001'				<!--- Codigo Reporte Dinamico  Parametros de Incidenias pago vacaciones--->
                                                                  and c.Ecodigo = #session.Ecodigo#)),0)
			where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and CargasCalculo.DClinea in (select dc.DClinea from DCargas dc where dc.DCdbc = 2)
		</cfquery>

		<!--- ljimenez CARGAS: Actuliza los dias base de cotizacion a utilizar para calcular las cargas
		dias DBC3 Sueldos + Vacaciones - Permisos(Faltas) --->
		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo set CCdbc = coalesce((select sum(pe.PEcantdias)
												from #PagosEmpleado# pe
													where pe.RCNid = CargasCalculo.RCNid
													and  pe.RHTcomportam in (1,6,8,5)
													and pe.DEid = CargasCalculo.DEid),0)

                                            +   coalesce((select coalesce(sum(a.ICvalor),0)
                                                    from IncidenciasCalculo a
                                                    where a.DEid = CargasCalculo.DEid
                                                        and a.RCNid = CargasCalculo.RCNid
                                                        and CIid  in (select distinct a.CIid
                                                                from RHReportesNomina c
                                                                    inner join RHColumnasReporte b
                                                                                inner join RHConceptosColumna a
                                                                                on a.RHCRPTid = b.RHCRPTid
                                                                         on b.RHRPTNid = c.RHRPTNid
                                                                        and b.RHCRPTcodigo = 'IVacaciones'	<!--- Incidencia de Pago de vacaciones --->
                                                                where c.RHRPTNcodigo = 'PR001'				<!--- Codigo Reporte Dinamico  Parametros de Incidenias pago vacaciones--->
                                                                  and c.Ecodigo = #session.Ecodigo#)),0)
				where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and CargasCalculo.DClinea in (select dc.DClinea from DCargas dc where dc.DCdbc = 3)
		</cfquery>


        <cfquery datasource="#Arguments.datasource#" name="rsUpdateDBC">
        	update CargasCalculo set  CCdbc = round(CCdbc * (#CantDiasMensualIMSS# / #CantDiasMensual# ),4)
            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
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
            select b.Did, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">, a.DEid, 0.00, 0.00, null, 0.00, 0
            from SalarioEmpleado a
            inner join DeduccionesEmpleado b
                on b.DEid = a.DEid
				and b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- Le agregue Ecodigo --->
            inner join TDeduccion c
                on c.TDid = b.TDid
				and c.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> <!--- Le agregue Ecodigo --->
            where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              and SEcalculado = 0
              and b.Dactivo = 1
              and b.Dfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RChasta#">
              and coalesce(b.Dfechafin,<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaDefault#">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#RCalculoNomina.RCdesde#">
              <cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>

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

    <!--- LZ: Cuando se ejecuta una nomina especial la incidencia que se paga cae en dos nominas la especial y la ordinaria
		 Se resuelve indicando que buscara el calendario de pago unicamente entre calendarios ordinarios aunque quien lo
		 llame sea una nomina espacial
	--->

	<cfquery datasource="#Arguments.datasource#">
        update IncidenciasCalculo set CPmes = (select b.CPmes
                                            from IncidenciasCalculo a, CalendarioPagos b
                                            where   a.ICfecha between b.CPdesde and b.CPhasta
                                            and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                                                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
                                                and IncidenciasCalculo.RCNid = a.RCNid
                                                and IncidenciasCalculo.ICid = a.ICid
                                                and IncidenciasCalculo.DEid = a.DEid
                                                and b.CPtipo = 0)
                              ,CPperiodo = (select b.CPperiodo
                                            from IncidenciasCalculo a, CalendarioPagos b
                                            where  a.ICfecha between b.CPdesde and b.CPhasta
                                            and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                                                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
                                                and IncidenciasCalculo.RCNid = a.RCNid
                                                and IncidenciasCalculo.ICid = a.ICid
                                                and IncidenciasCalculo.DEid = a.DEid
                                                and b.CPtipo = 0)
      	Where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
    </cfquery>


    <!--- CALCULO DE LA NOMINA--->
	<!---ljimenezretro--->
    <cfinvoke component="RH_CalculoNomina" method="CalculoNomina">
            <cfinvokeargument name="datasource" 		value = "#Arguments.datasource#">
            <cfinvokeargument name="Ecodigo" 			value = "#Arguments.Ecodigo#">
            <cfinvokeargument name="RCNid" 				value = "#Arguments.RCNid#">
            <cfinvokeargument name="Tcodigo" 			value = "#RCalculoNomina.Tcodigo#">
            <cfinvokeargument name="RCdesde" 			value = "#RCalculoNomina.RCdesde#">
            <cfinvokeargument name="RChasta" 			value = "#RCalculoNomina.RChasta#">
            <cfinvokeargument name="IRcodigo" 			value = "#IRcodigo#">
            <cfinvokeargument name="Usucodigo" 			value = "#Arguments.Usucodigo#">
            <cfinvokeargument name="Ulocalizacion" 		value = "#Arguments.Ulocalizacion#">
            <cfinvokeargument name="debug" 				value = "#Arguments.debug#">
            <cfinvokeargument name="ValidarCalendarios" value = "#Arguments.ValidarCalendarios#">
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
			select ; PElinea, DEid, RCNid, LTid, RHJid, PEhjornada, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, RHTid, RHPid, RHPcodigo, LTporcplaza, PEtiporeg
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
	<!---SML. Inicio Validacion para que no borre al trabajador cuando solo se le agrega una nomina especial de Vales de Despensa--->
    <cfquery datasource="#Arguments.datasource#" name="rsValesCS">
	   select count(1) as ValesCS from IncidenciasCalculo a
			inner join ComponentesSalariales b on b.CIid = a.CIid
			and b.CSsalarioEspecie = 1
	   where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
       		and a.ICespecie = 0
	     <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

    <cfquery datasource="#Arguments.datasource#" name="rsValesCI">
	   select count(1) as ValesCI from IncidenciasCalculo a
			inner join CIncidentes b on b.CIid = a.CIid
			and b.CIespecie = 1
	   where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
       		and a.ICespecie = 0
	     <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

    <cfset TieneVales = #rsValesCS.ValesCS# + #rsValesCI.ValesCI#>

    <cfif isdefined('TieneVales') and TieneVales LT 1>
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
	   delete from PagosEmpleado
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
		delete from SalarioEmpleado
		 where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  <cfif IsDefined('Arguments.pDEid')>and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		  and SEincidencias = 0.00
		  and SEliquido = 0.00
 	</cfquery>
    </cfif>
</cfif>
<cfif Arguments.debug>
	<cftransaction action="rollback"/>
	<cfoutput>Invocado con debug = true, abortando</cfoutput><cfabort>
</cfif>
</cftransaction>
<cf_dbtemp_deletes>
<!--- end --->
</cffunction>
<!---==========================================================--->
<cffunction name="BajaRCalculoNomina" access="public">
	<cfargument name="Conexion" 		type="string"  required="no"  hint="Nombre del DataSource">
    <cfargument name="RCNid"    		type="numeric" required="yes" hint="Id de la relación de Calculo">
    <cfargument name="TransacionActiva" type="boolean" required="no"  default="false" hint="Existe una transaccion activa">

    <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
    	<CFSET ARGUMENTS.Conexion = SESSION.DSN>
    </cfif>
    <cfif ARGUMENTS.TransacionActiva>
    	<cfset BajaRCalculoNominaPrivate(ARGUMENTS.Conexion,ARGUMENTS.RCNid)>
    <cfelse>
        <cftransaction>
        	<cfset BajaRCalculoNominaPrivate(ARGUMENTS.Conexion,ARGUMENTS.RCNid)>
        </cftransaction>
    </cfif>
</cffunction>

<cffunction name="BajaRCalculoNominaPrivate" access="private">
	<cfargument name="Conexion" type="string"  required="no"  hint="Nombre del DataSource">
    <cfargument name="RCNid"    type="numeric" required="yes" hint="Id de la relación de Calculo">
    <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
    	<CFSET ARGUMENTS.Conexion = SESSION.DSN>
    </cfif>
    <cfquery datasource="#ARGUMENTS.Conexion#">
        delete from Incidencias
         where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery datasource="#ARGUMENTS.Conexion#">
        delete from BMovimientoIncidencias
          where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery name="ABC_Resultado" datasource="#ARGUMENTS.Conexion#">
        delete from PagosEmpleado
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery name="ABC_Resultado" datasource="#ARGUMENTS.Conexion#">
        delete from IncidenciasCalculo
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery name="ABC_Resultado" datasource="#ARGUMENTS.Conexion#">
        delete from CargasCalculo
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery name="ABC_Resultado" datasource="#ARGUMENTS.Conexion#">
        delete from DeduccionesCalculo
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery name="ABC_Resultado" datasource="#ARGUMENTS.Conexion#">
        delete from SalarioEmpleado
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery name="ABC_Resultado" datasource="#ARGUMENTS.Conexion#">
        delete from RCalculoNomina
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
    <cfquery datasource="#ARGUMENTS.Conexion#">
        delete from RHPagosExternosCalculo
        where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
    </cfquery>
</cffunction>
<!---===========================FUNCION PARA INCLUIR EL ENCABEZADO DE UNA NOMINA=======================================--->
<cffunction name="AltaRCalculoNomina" access="public" hint="Funcion para Incluir el Encabezado del Calculo de Nomina">
    <cfargument name="Ecodigo"  		type="numeric" 	required="no" hint="Codigo de la empresa,default session ">
    <cfargument name="conexion" 		type="string"  	required="no" hint="Nombre del datasource, default session">
    <cfargument name="Ulocalizacion" 	type="string"  	required="no" hint="Localizacion">
    <cfargument name="BMUsucodigo" 		type="numeric"  required="no" hint="Usuario del Portal">
    <cfargument name="Usucodigo"  		type="numeric" 	required="no" hint="Usuario del Portal">

    <cfargument name="Tcodigo"  		type="string" 	required="no" default=""   hint="">
    <cfargument name="RCDescripcion"  	type="string" 	required="no" default=""   hint="">
    <cfargument name="CBcc"  			type="string" 	required="no" default=""   hint="">
    <cfargument name="RChasta"  		type="any" 		required="no" default=""   hint="">
    <cfargument name="RCdesde"  		type="any" 		required="no" default=""   hint="">

    <cfargument name="RCestado"  		type="numeric" 	required="no" default="0"   hint="0-Proceso,1-Calculo,2-Terminado,3-Pagado">
    <cfargument name="RCpagoentractos"	type="numeric" 	required="no" default="0"  hint="">

    <cfargument name="RCNid"  			type="numeric" 	required="yes" hint="Id del Calendario de Pago">

    <cfargument name="IDcontable"  		type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="NAP"  			type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="Bid"  			type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="CBid"  			type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="Mcodigo"  		type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="RCtc"  			type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="CIid"  			type="numeric" 	required="no" default="-1" hint="">

    <cfargument name="RCporcentaje"  	type="numeric" 	required="no" default="-1" hint="">
    <cfargument name="RHPTUEid"  		type="numeric" 	required="no" default="-1" hint="">

    <CFIF NOT ISDEFINED('ARGUMENTS.Ecodigo') AND ISDEFINED('SESSION.Ecodigo')>
        <CFSET ARGUMENTS.Ecodigo = SESSION.Ecodigo>
    </CFIF>
    <CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        <CFSET ARGUMENTS.conexion = SESSION.dsn>
    </CFIF>
    <CFIF NOT ISDEFINED('ARGUMENTS.Ulocalizacion') AND ISDEFINED('SESSION.Ulocalizacion')>
        <CFSET ARGUMENTS.Ulocalizacion = SESSION.Ulocalizacion>
    </CFIF>
    <CFIF NOT ISDEFINED('ARGUMENTS.BMUsucodigo') AND ISDEFINED('SESSION.UsuCodigo')>
        <CFSET ARGUMENTS.BMUsucodigo = SESSION.UsuCodigo>
    </CFIF>
    <CFIF NOT ISDEFINED('ARGUMENTS.UsuCodigo') AND ISDEFINED('SESSION.UsuCodigo')>
        <CFSET ARGUMENTS.UsuCodigo = SESSION.UsuCodigo>
    </CFIF>
    <cfinvoke component="rh.Componentes.CalendarioPago" method="getCalendarioPago" returnvariable="rsCP">
        <cfinvokeargument name="CPid" value="#ARGUMENTS.RCNid#">
    </cfinvoke>
    <cfif NOT LEN(TRIM(ARGUMENTS.Tcodigo))>
        <cfset ARGUMENTS.Tcodigo = rsCP.Tcodigo>
    </cfif>
    <cfif NOT LEN(TRIM(ARGUMENTS.RCdesde))>
        <cfset ARGUMENTS.RCdesde = rsCP.CPdesde>
    </cfif>
    <cfif NOT LEN(TRIM(ARGUMENTS.RChasta))>
        <cfset ARGUMENTS.RChasta = rsCP.CPhasta>
    </cfif>

    <cfif NOT LEN(TRIM(ARGUMENTS.RCDescripcion))>
        <cfinvoke component="rh.Componentes.TipoNomina" method="GetTipoNomina" Tcodigo="#ARGUMENTS.Tcodigo#" returnvariable="rsTN"/>
     	<cfswitch expression="#rsTN.Ttipopago#">
           <cfcase value="0"><cfset LvarFrec ='Semanal'></cfcase>
           <cfcase value="1"><cfset LvarFrec ='Bisemanal'></cfcase>
           <cfcase value="2"><cfset LvarFrec ='Quincenal'></cfcase>
           <cfcase value="3"><cfset LvarFrec ='Mensual'></cfcase>
         </cfswitch>

        <cfset ARGUMENTS.RCDescripcion = 'Nomina ' & LvarFrec&' del '&LSDATEFORMAT(ARGUMENTS.RCdesde,'DD-MM-YYYY')&' al '&LSDATEFORMAT(ARGUMENTS.RChasta,'DD-MM-YYYY')>
    </cfif>
    <cfquery name="ABC_datosCalenPago_insert" datasource="#ARGUMENTS.conexion#">
    insert into RCalculoNomina(
        RCNid,			Ecodigo,		Tcodigo,	RCDescripcion,	RCdesde,
        RChasta,		RCestado,		Usucodigo,	Ulocalizacion,	IDcontable,
        RHPTUEid,		BMUsucodigo,	NAP,		Bid,			CBid,
        CBcc,			Mcodigo,		RCtc,		CIid,			RCpagoentractos,
        RCporcentaje) values(
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.RCNid 	      EQ -1#" value="#ARGUMENTS.RCNid#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.Ecodigo 	      EQ -1#" value="#ARGUMENTS.Ecodigo#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.Tcodigo 	      EQ -1#" value="#ARGUMENTS.Tcodigo#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.RCDescripcion   EQ -1#" value="#ARGUMENTS.RCDescripcion#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.RCdesde 	      EQ -1#" value="#ARGUMENTS.RCdesde#">,

    <cf_JDBCquery_param cfsqltype="cf_sql_date" 	voidnull null="#ARGUMENTS.RChasta 	      EQ -1#" value="#ARGUMENTS.RChasta#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.RCestado 	      EQ -1#" value="#ARGUMENTS.RCestado#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.Usucodigo 	  EQ -1#" value="#ARGUMENTS.Usucodigo#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.Ulocalizacion   EQ -1#" value="#ARGUMENTS.Ulocalizacion#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.IDcontable 	  EQ -1#" value="#ARGUMENTS.IDcontable#">,

    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.RHPTUEid 	      EQ -1#" value="#ARGUMENTS.RHPTUEid#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.BMUsucodigo 	  EQ -1#" value="#ARGUMENTS.BMUsucodigo#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.NAP 	      	  EQ -1#" value="#ARGUMENTS.NAP#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.Bid 	      	  EQ -1#" value="#ARGUMENTS.Bid#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CBid 	      	  EQ -1#" value="#ARGUMENTS.CBid#">,

    <cf_JDBCquery_param cfsqltype="cf_sql_varchar" 	voidnull null="#ARGUMENTS.CBcc 	      	  EQ -1#" value="#ARGUMENTS.CBcc#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.Mcodigo 	      EQ -1#" value="#ARGUMENTS.Mcodigo#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.RCtc 	      	  EQ -1#" value="#ARGUMENTS.RCtc#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.CIid 	      	  EQ -1#" value="#ARGUMENTS.CIid#">,
    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.RCpagoentractos EQ -1#" value="#ARGUMENTS.RCpagoentractos#">,

    <cf_JDBCquery_param cfsqltype="cf_sql_integer" 	voidnull null="#ARGUMENTS.RCporcentaje 	  EQ -1#" value="#ARGUMENTS.RCporcentaje#">
    )
    </cfquery>
</cffunction>
<!---===========================FUNCION PARA RECUPERAR EL ENCABEZADO DE LA NOMINA=======================================--->
<cffunction name="GetRCalculoNomina" access="public" returntype="query" hint="Funcion para Recuperar el Encabezado del Calculo de Nomina">
    <cfargument name="RCNid"  		    type="numeric" 	required="no" hint="Id del Encabezado de la Relación de Calculo de Nomina">
    <cfargument name="conexion" 		type="string"  	required="no" hint="Nombre del datasource, default session">
    <cfargument name="Ecodigo" 			type="numeric"  required="no" hint="Ecodigo de la empresa, default session">

 	<CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        <CFSET ARGUMENTS.conexion = SESSION.dsn>
    </CFIF>
    <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        <CFSET Arguments.Ecodigo = session.Ecodigo>
    </CFIF>
    <cfquery name="rsRCalculoNomina" datasource="#ARGUMENTS.conexion#">
        select a.RCNid,a.Ecodigo,a.Tcodigo,a.RCDescripcion,a.RCdesde,a.RChasta,a.RCestado
              ,a.Usucodigo,a.Ulocalizacion,a.IDcontable,a.ts_rversion,a.BMUsucodigo,a.NAP
              ,a.Bid,a.CBid,a.CBcc,a.RCtc,a.CIid,a.RCpagoentractos,a.RCporcentaje,a.RHPTUEid
              ,b.Mcodigo, b.Tdescripcion,m.Mnombre, m.Miso4217,
              (select sum(SEliquido) from SalarioEmpleado where RCNid = a.RCNid) TotalLiquido,
              cp.CPtipo
          from RCalculoNomina a
          	inner join TiposNomina b
            	on a.Ecodigo = b.Ecodigo
			   and a.Tcodigo = b.Tcodigo
            inner join Monedas m
            	on m.Mcodigo = b.Mcodigo
         	inner join CalendarioPagos cp
            	on cp.Ecodigo = a.Ecodigo and cp.CPid = a.RCNid
       		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        <cfif isdefined('Arguments.RCNid')>
           and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfif>
    </cfquery>
    <cfreturn rsRCalculoNomina>
</cffunction>
<!---===========================FUNCION PARA RECUPERAR EL RESUMEN DE LA NOMINA=======================================--->
<cffunction name="GetResumenCalculoNomina" access="public" returntype="query" hint="Funcion para Recuperar el resumen del Calculo de Nomina">
    <cfargument name="RCNid"  		    type="numeric" 	required="no" hint="Id del Encabezado de la Relación de Calculo de Nomina">
    <cfargument name="conexion" 		type="string"  	required="no" hint="Nombre del datasource, default session">
    <cfargument name="DEid" 			type="numeric"  required="no" hint="Id del Empleado">

 	<CFIF NOT ISDEFINED('ARGUMENTS.conexion') AND ISDEFINED('SESSION.dsn')>
        <CFSET ARGUMENTS.conexion = SESSION.dsn>
    </CFIF>
    <cfquery name="rsResumenCalculoNomina" datasource="#ARGUMENTS.conexion#">
        select c.RCDescripcion, a.RCNid,b.DEid,b.DEidentificacion,b.DEapellido1 #_Cat# ' ' #_Cat#  b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre as nombreEmpl,a.SEsalariobruto,a.SEincidencias,a.SErenta,a.SEcargasempleado,SEcargaspatrono,a.SEdeducciones,a.SEliquido, a.SEcalculado
        from SalarioEmpleado a
            inner join DatosEmpleado b
                on a.DEid = b.DEid
            inner join RCalculoNomina c
                on c.RCNid = a.RCNid
        where 1=1
        <cfif isdefined('Arguments.RCNid')>
           and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfif>
        <cfif isdefined('Arguments.DEid')>
           and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
        </cfif>
    </cfquery>
    <cfreturn rsResumenCalculoNomina>
</cffunction>
<!---==================================FUNCION PARA APLICAR LA NOMINA==================================================--->
    <cffunction name="AplicaNomina" access="public" hint="Funcion para Aplicar una Nomina" output="yes" returntype="numeric">
        <cfargument name="conexion" 		type="string"  	required="no"   hint="Nombre del datasource, default session">
        <cfargument name="Usucodigo" 		type="numeric"  required="no"   hint="Codigo del usuario que esta Aplicando la Nomina">
        <cfargument name="Ulocalizacion" 	type="string"   required="no"   hint="localizacion">
        <cfargument name="Ecodigo" 			type="numeric"  required="no"   hint="Ecodigo">
        <cfargument name="btnSeguir" 		type="any"      required="no"   hint="Acción">

        <cfargument name="CBid" 			type="numeric"  required="yes"  hint="Cuenta Bancaria de la que se debitara para hacer el pago de la nomina">
        <cfargument name="Lvar_Regresar" 	type="string"   required="yes"  hint="URL para regresar Cuando da un Error">
        <cfargument name="RCNid"  		    type="numeric" 	required="yes"  hint="Id del Encabezado de la Relación de Calculo de Nomina">
        <cfargument name="Mcodigo" 			type="numeric"  required="yes"  hint="Codigo de la noneda de la nomina">
        <cfargument name="CBcc" 			type="string"   required="yes"  hint="">
        <cfargument name="tipo_cambio" 		type="numeric"  required="no"   hint="" default="1">

        <CFIF NOT ISDEFINED('Arguments.conexion') AND ISDEFINED('session.dsn')>
        	<CFSET Arguments.conexion = session.dsn>
   		</CFIF>
        <CFIF NOT ISDEFINED('Arguments.Usucodigo') AND ISDEFINED('session.Usucodigo')>
        	<CFSET Arguments.Usucodigo = session.Usucodigo>
   		</CFIF>
        <CFIF NOT ISDEFINED('Arguments.Ulocalizacion') AND ISDEFINED('session.Ulocalizacion')>
        	<CFSET Arguments.Ulocalizacion = session.Ulocalizacion>
   		</CFIF>
         <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
   		</CFIF>

     	<cfif not isdefined("Arguments.btnSeguir")>
			<!---?????????Borrar si ya hay registros para esta relacion???????--->
            <cfquery datasource="#Arguments.conexion#">
                delete from RCuentasTipo
                 where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
            </cfquery>

			<!---?????????Usa Interfaz con Contabilidad [Parametro 20]???????--->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Arguments.conexion#" ecodigo="#Arguments.Ecodigo#" pvalor="20" default="0" returnvariable="usaConta"/>
            <cfset vInterfazContable = (usaConta eq 1)>

			<!---?????????Validar Planilla Presupuestaria [Parametro 540]???????--->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Arguments.conexion#" ecodigo="#Arguments.Ecodigo#" pvalor="540" default="0" returnvariable="validaPP"/>
            <cfset vPlanillaPresupuestaria = (validaPP eq 1)>

			<!---?????????0: Conta, 10:Presupuesto[cuentas no validas], 20: Presupuesto[no hay presupuesto]???????--->
            <cfparam name="tipo" default="0">
			<!---?????????Se Invoca el RH_CuentasTipo???????--->
            <cfinvoke component="rh.Componentes.RH_CuentasTipo" method="CuentasTipo" returnvariable="cuentas_tipo">
                <cfinvokeargument name="conexion" 	value="#Arguments.conexion#">
                <cfinvokeargument name="Ecodigo" 	value="#Arguments.Ecodigo#">
                <cfinvokeargument name="RCNid" 		value="#Arguments.RCNid#">
                <cfinvokeargument name="Usucodigo" 	value="#Arguments.Usucodigo#">
                <cfinvokeargument name="CBid" 		value="#Arguments.CBid#">
                <cfinvokeargument name="debug" 		value="false">
            </cfinvoke>


			<!---?????????1.1 VALIDACION DE CONTABILIDAD???????--->
            <cfif vInterfazContable and cuentas_tipo.recordcount gt 0 >
                <cfinclude template="/rh/nomina/operacion/ResultadoCalculo-errores.cfm">
                <cfabort>
            </cfif>

			<!---?????????1.2 CUENTAS FINANCIERAS INVALIDAS???????--->
            <cfquery name="errores_pres" datasource="#Arguments.conexion#">
                select 	a.DEid,
                        a.Cformato,
                        a.tiporeg,
                        a.montores,
                        coalesce(coalesce(b.DEidentificacion,'') #_CAT# ' ' #_CAT# coalesce(b.DEnombre,'') #_CAT# ' ' #_CAT# coalesce(b.DEapellido1,'') #_CAT# ' ' #_CAT# coalesce(b.DEapellido2,''), 'NO DETERMINADO') as Nombre
                from RCuentasTipo a
                    left outer join DatosEmpleado b
                        on a.DEid = b.DEid
                where a.RCNid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                  and a.Ecodigo  = #Arguments.Ecodigo#
                  and a.CFcuenta = -1
                order by a.Cformato
            </cfquery>

			<cfif vInterfazContable and errores_pres.recordcount gt 0 >
                <cfset tipo = 10 >
                <cfinclude template="/rh/nomina/operacion/ResultadoCalculo-errores.cfm">
                <cfabort>
            </cfif>

			<!---?????????2. VALIDACION DE PRESUPUESTO???????--->
            <cfif vInterfazContable and vPlanillaPresupuestaria>
                <cfif errores_pres.recordcount gt 0 >
                    <cfset tipo = 10 >
                    <cfinclude template="/rh/nomina/operacion/ResultadoCalculo-errores.cfm">
                    <cfabort>
                </cfif>

				<!---?????????2.1 VALIDACION PRESUPUESTARIA: Cuentas Financieras con Presupuesto asociadas a Tiporeg que no verifican presupuesto???????--->
                <cfquery name="errores_pres" datasource="#Arguments.conexion#">
                    select distinct ct.Cformato,cf.CFdescripcion,ct.Periodo,ct.Mes, ct.tiporeg, ct.montores
                      from RCuentasTipo ct
                        inner join CFinanciera cf
                             ON cf.CFcuenta = ct.CFcuenta
                        inner join CPVigencia v
                            inner join PCEMascaras m
                                 ON m.PCEMid 		= v.PCEMid
                                AND m.PCEMformatoP 	is not null
                             ON v.Ecodigo	= #Arguments.Ecodigo#
                            and v.Cmayor	= substring(ct.Cformato,1,4)
                            and Periodo*100+Mes between CPVdesdeAnoMes and CPVhastaAnoMes
                     where ct.RCNid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                       and ct.Ecodigo      = #Arguments.Ecodigo#
                       and ct.vpresupuesto = 0
                </cfquery>

				<cfif errores_pres.recordCount GT 0>
                    <cfset tipo = 20>
                    <cfinclude template="/rh/nomina/operacion/ResultadoCalculo-errores.cfm">
                    <cfabort>
                </cfif>

				<!---?????????Verfica la Moneda???????--->
                <cfquery name="rsSQL" datasource="#Arguments.conexion#">
                    select Mcodigo
                      from Empresas
                     where Ecodigo = #Arguments.Ecodigo#
                </cfquery>
				<cfset LvarMcodigo 	= rsSQL.Mcodigo>
                <cfset LvarTC		= 1.00>

				<!---?????????2.0 VALIDACION PRESUPUESTARIA: Verifica Disponible de la Cuenta???????--->
                <!---?????????LLAMAR COMPONENTE DE PRES Y HACER LA VALIDACION PARA VER SI HAY PLATA O NO???????--->
                <!---?????????Primero se verifican todas las cuentas, y si no hay errores se generan los compromisos por mes???????--->
                <cfquery name="rsDocumentos" datasource="#Arguments.conexion#">
                    select distinct Periodo, Mes
                      from RCuentasTipo
                     where RCNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                       and Ecodigo = #Arguments.Ecodigo#
                </cfquery>

                <cfinvoke component="sif.Componentes.PRES_Presupuesto" returnvariable="INT_PRESUPUESTO" method="CreaTablaIntPresupuesto" >
                    <cfinvokeargument name="conIdentity" value="true" />
                </cfinvoke>
                <cfloop query="rsDocumentos">
                    <cftransaction>
						<cfquery datasource="#session.DSN#">
							delete from #INT_PRESUPUESTO#
						</cfquery>
						<cfquery datasource="#Arguments.conexion#">
							insert into #INT_PRESUPUESTO#
								(
									ModuloOrigen,
									NumeroDocumento,
									NumeroReferencia,
									FechaDocumento,
									AnoDocumento,
									MesDocumento,
									CFcuenta,
									Ocodigo,
									Mcodigo,
									MontoOrigen,
									TipoCambio,
									Monto,
									TipoMovimiento
								)
							select 	'RHPN', '0', '0',
									<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(rsDocumentos.Periodo,rsDocumentos.Mes,1)#">,
									#rsDocumentos.Periodo#, #rsDocumentos.Mes#,
									CFcuenta, Ocodigo,
									#LvarMcodigo#, sum(round(a.montores,2)), #LvarTC#, sum(round(a.montores*#LvarTC#,2)),
									'E'
							  from RCuentasTipo a
							 where a.RCNid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							   and a.Ecodigo 	= #Arguments.Ecodigo#
							   and a.Periodo 	= #rsDocumentos.Periodo#
							   and a.Mes 		= #rsDocumentos.Mes#
							   and a.vpresupuesto = 1
							group by a.Ocodigo, a.CFcuenta
						</cfquery>

						<cfinvoke component	="sif.Componentes.PRES_Presupuesto" method="ControlPresupuestario" returnvariable="LvarNAP">
							<cfinvokeargument name="ModuloOrigen"  		value="RHPN"/>
							<cfinvokeargument name="NumeroDocumento" 	value="0"/>
							<cfinvokeargument name="NumeroReferencia" 	value="0"/>
							<cfinvokeargument name="FechaDocumento" 	value="#createDate(rsDocumentos.Periodo,rsDocumentos.Mes,1)#"/>
							<cfinvokeargument name="AnoDocumento"		value="#rsDocumentos.Periodo#"/>
							<cfinvokeargument name="MesDocumento"		value="#rsDocumentos.Mes#"/>
							<cfinvokeargument name="SoloConsultar"		value="true"/>
							<cfinvokeargument name="VerErrores"			value="true"/>
						</cfinvoke>
					</cftransaction>

                    <cfquery name="rsConError" dbtype="query">
                        select 	count(1) as Cantidad
                          from Request.rsIntPresupuesto
                         where ConError = 2
                    </cfquery>

                    <cfquery name="errores_pres" dbtype="query">
                        select
                                CuentaFinanciera 	as Cformato,
                                CuentaPresupuesto 	as CPformato,
                                CodigoOficina,
                                AnoDocumento 		as Periodo,
                                MesDocumento 		as Mes,
                                DisponibleAnterior,
                                SignoMovimiento * Monto as Monto,
                                NRPsPendientes,
                                ExcesoNeto,
                                ConError,
                                MSG
                          from Request.rsIntPresupuesto
                         where ConError <> 0
                    </cfquery>
                    <cfif errores_pres.recordcount gt 0>
                        <cfif rsConError.Cantidad GT 0 OR LvarNAP LT 0>
                            <cfset tipo = 21> <!--- ERRORES: si hay ConError=2 o se rechazó el Doc --->
                            <cfinclude template="/rh/nomina/operacion/ResultadoCalculo-errores.cfm">
                            <cfabort>
                        <cfelse>
                            <cfset tipo = 22> 	<!--- SOLO WARNINGS: solo hay ConError=1 (sin fondos) pero no hubo NRP. IGUAL QUE 21 PERO PONE Arguments.btnSeguir --->
                            <cfinclude template="/rh/nomina/operacion/ResultadoCalculo-errores.cfm">
                            <cfabort>
                        </cfif>
                    </cfif>
                </cfloop>
			</cfif>
		</cfif>

		<cfset Arguments.CBcc = trim(Arguments.CBcc)>
		<!---?????????update a RCalculoNomina ( Bid, CBid, CBcc, Mcodigo, RCtc ) [BARODA]???????--->
		<cfquery datasource="#Arguments.conexion#">
			update RCalculoNomina
			set Bid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Bid#">,
				CBid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CBid#">,
				CBcc 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CBcc#">,
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">,
				RCtc 	= <cfqueryparam cfsqltype="cf_sql_float"   value="#replace(Arguments.tipo_cambio, ',','','all')#">
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		<cfinvoke component="rh.Componentes.RH_PosteoRelacion" method="PosteoRelacion" returnvariable="ERNid">
			<cfinvokeargument name="conexion" 		value="#Arguments.conexion#">
			<cfinvokeargument name="Ecodigo" 		value="#Arguments.Ecodigo#">
			<cfinvokeargument name="RCNid" 			value="#Arguments.RCNid#">
			<cfinvokeargument name="CBcc"  			value="#Arguments.CBcc#" >
			<cfinvokeargument name="Usucodigo" 		value="#Arguments.Usucodigo#">
			<cfinvokeargument name="Ulocalizacion" 	value="#Arguments.Ulocalizacion#">
			<cfinvokeargument name="debug" 			value="false">
		</cfinvoke>
		<cfreturn ERNid>
	</cffunction>

	<!---=========================FUNCION PARA VALIDAR QUE NO EXISTAN NOMINAS ANTERIORES PENDIENTES DE APLICAR==================================================--->
    <cffunction name="ValidaNominasPendientes" access="public" returntype="query">
        <cfargument name="Conexion" type="string"  required="no"  hint="Nombre del DataSource">
        <cfargument name="RCNid"    type="numeric" required="yes" hint="Id de la relación de Calculo">

		<cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
            <CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </cfif>

        <cfquery datasource="#Arguments.conexion#" name="rsNominasNoPagas">
        	select count(1) as cantidad
                from RCalculoNomina Nact
                    inner join CalendarioPagos Cact
                        on Cact.CPid = Nact.RCNid
                    inner join CalendarioPagos Cant
                         on Cant.Ecodigo = Cact.Ecodigo
                        and Cant.Tcodigo = Cact.Tcodigo
                        and Cant.CPhasta < Cact.CPhasta
             where Nact.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
              and (select count(1) from HRCalculoNomina Npagas where Npagas.RCNid = Cant.CPid) = 0
        </cfquery>
        <cfreturn rsNominasNoPagas>
    </cffunction>
<!---==================================FUNCION PARA VALIDAR QUE LA NOMINA NO CONTENGA SALARIOS LIQUIDOS NEGATIVOS==================================================--->
    <cffunction name="ValidaSalariosNegativos" access="public" returntype="query">
        <cfargument name="Conexion" type="string"  required="no"  hint="Nombre del DataSource">
        <cfargument name="RCNid"    type="numeric" required="yes" hint="Id de la relación de Calculo">
        <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
            <CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </cfif>
        <cfquery name="rsSalNegativos" datasource="#ARGUMENTS.Conexion#">
            select DEidentificacion, b.DEapellido1 #_Cat# ' ' #_Cat# b.DEapellido2 #_Cat# ' ' #_Cat# b.DEnombre as nombreEmpl
            from SalarioEmpleado a
                inner join DatosEmpleado b
                    on b.DEid = a.DEid
            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.RCNid#">
              and SEliquido < 0
        </cfquery>
       	<cfreturn rsSalNegativos>
    </cffunction>
    <!---??????Valida la cantidad de Empleados en la Nomina--->
    <cffunction name="ValidaExistenciaEmpleados" access="public" returntype="query">
        <cfargument name="Conexion" type="string"  required="no"  hint="Nombre del DataSource">
        <cfargument name="RCNid"    type="numeric" required="yes" hint="Id de la relación de Calculo">
        <cfargument name="Detener"  type="boolean" required="yes" default="true" hint="True, envia un cfthrow, false retorna la cantidad de empleados">

        <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
            <CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </cfif>
         <cfquery name="rsPR_existe" datasource="#arguments.conexion#">
            select coalesce(count(1),0) as total
             from SalarioEmpleado
            where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>
        <cfif Detener>
        	<cfthrow message="No se encontraron salarios de empleados calculados para la Relación de Nómina.">
        <cfelse>
        	<cfreturn rsPR_existe>
        </cfif>

    </cffunction>
<!---==================================FUNCION GENERAR EL AJUSTE PARA LOS SALARIOS NEGATIVOS DE UNA FORMA REMOTA==================================================--->
    <cffunction name="GeneraAjusteNegativoRemote" access="remote">
        <cfargument name="Conexion" 			type="string"   required="no"  hint="Nombre del DataSource">
        <cfargument name="RCNid"    			type="numeric"  required="no"  hint="Id de la relación de Calculo">
        <cfargument name="ValidarCalendarios" 	type="boolean" 	required="yes" default="true" hint="True. Busca la fecha del proximo calendario. False. la fecha del proximo calendario">

        <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
            <CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </cfif>

        <cfinvoke method="GeneraAjusteNegativo">
       		<cfinvokeargument name="RCNid" 				value="#ARGUMENTS.RCNid#">
            <cfinvokeargument name="ValidarCalendarios" value="#ARGUMENTS.ValidarCalendarios#">
        </cfinvoke>

    </cffunction>
<!---==================================FUNCION GENERAR EL AJUSTE PARA LOS SALARIOS NEGATIVOS==================================================--->
    <cffunction name="GeneraAjusteNegativo" access="public">
        <cfargument name="Conexion" 			type="string"   required="no" hint="Nombre del DataSource">
        <cfargument name="RCNid"   				type="numeric"  required="yes" hint="Id de la relación de Calculo">
        <cfargument name="Usucodigo"   	 		type="numeric"  required="no" hint="Id del Usuario del portal">
        <cfargument name="Ulocalizacion"    	type="numeric"  required="no" hint="Localizacion">
        <cfargument name="Ecodigo"   	 		type="numeric"  required="no" hint="Codigo de la empresa">
        <cfargument name="ValidarCalendarios" 	type="boolean" 	required="yes" default="true" hint="True. Busca la fecha del proximo calendario. False. la fecha del proximo calendario">

        <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
            <CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </cfif>
        <cfif NOT ISDEFINED('ARGUMENTS.Usucodigo') AND ISDEFINED('SESSION.Usucodigo')>
            <CFSET ARGUMENTS.Usucodigo = SESSION.Usucodigo>
        </cfif>
        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</CFIF>
        <CFIF NOT ISDEFINED('Arguments.Ulocalizacion')>
			<cfif isdefined('session.Ulocalizacion')>
                <cfset Arguments.Ulocalizacion = session.Ulocalizacion>
            <cfelse>
                <cfset Arguments.Ulocalizacion = '00'>
            </cfif>
        </CFIF>
         <!---????????Se Valida que se permitan hacer ajustes negativos y que la deduccion para el ajuste este Configurada???????--->
        <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2026" default="0" returnvariable="PemiteAjusteNegativo"/>
        <cfif PemiteAjusteNegativo EQ 0>
        	<cfreturn>
        </cfif>
		<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2027" default="0" returnvariable="DeduccionAjusteNegativo"/>
		<cfif DeduccionAjusteNegativo EQ 0>
            <cf_throw message="No se ha definido el concepto de pago para el ajuste de salario negativo en Parámetros Generales" errorcode="12176">
            <cfabort>
        </cfif>
        <cfquery name="rsIncidenciaP" datasource="#ARGUMENTS.Conexion#">
            select CIid,CIcodigo,CIdescripcion
            	from CIncidentes
             where CIid = #DeduccionAjusteNegativo#
        </cfquery>
        <!---????????Se obtienen todos los empleados que tienen Salario Liquido negativo???????--->
        <cfquery name="rsDE" datasource="#ARGUMENTS.Conexion#">
            select a.DEid,a.SEliquido, b.Tcodigo, b.RCdesde, b.RChasta
            	from SalarioEmpleado a
                	inner join RCalculoNomina b
                    	on a.RCNid = b.RCNid
            where a.RCNid = #ARGUMENTS.RCNid#
              and a.SEliquido < 0
        </cfquery>
        <!----???????Se obtienen la fecha del proximo calendario, no pagado y no calculado, para incluir el ajuste con salario con signo contrario???????--->
      	<cfif ValidarCalendarios>
       		<cfquery name="PaySchedAfterRestrict" datasource="#ARGUMENTS.Conexion#">
                select rtrim(a.Tcodigo) as Tcodigo, a.CPdesde, a.CPhasta
                    from CalendarioPagos a
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.Ecodigo#">
                  and a.CPfenvio is null
                  and a.CPtipo in (0,2)
                  and not exists( select 1 from RCalculoNomina h
                                    where a.Ecodigo = h.Ecodigo
                                      and a.Tcodigo = h.Tcodigo
                                      and a.CPdesde = h.RCdesde
                                      and a.CPhasta = h.RChasta
                                      and a.CPid = h.RCNid)
                  and not exists (select 1 from HERNomina i
                                    where a.Tcodigo = i.Tcodigo
                                      and a.Ecodigo = i.Ecodigo
                                      and a.CPdesde = i.HERNfinicio
                                      and a.CPhasta = i.HERNffin
                                      and a.CPid    = i.RCNid )
                  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCN.Tcodigo#">
                  order by CPhasta
        	</cfquery>
            <cfquery name="MinFechasNomina" dbtype="query">
                select Tcodigo, min(CPdesde) as CPdesde
                from PaySchedAfterRestrict
                group by Tcodigo
            </cfquery>
            <cfquery name="rsCalendarios" dbtype="query">
                select CPdesde
                from PaySchedAfterRestrict
                where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MinFechasNomina.Tcodigo#">
                and CPdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#MinFechasNomina.CPdesde#">
                order by CPdesde
            </cfquery>
       <cfelse>
       		 <!----???????se calcula el inicio de la proxima nomina(No importa si ya esta generada, se le avisara que tienen que restaurar), para incluir el ajuste con salario con signo contrario???????--->
       		<cfset rsCalendarios.CPdesde = dateadd('d',1,rsDE.RChasta)>
       </cfif>
		<!---???????Se inserta la Incidencia de ajuste en la nomina Actual???????----->
		<cftransaction>
        <cfloop query="rsDE">
            <cfquery name="sqlIncidencia" datasource="#ARGUMENTS.Conexion#">
                insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsDE.DEid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsIncidenciaP.CIid#">,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDatetime(rsDE.RCdesde)#">,
                    <cfqueryparam cfsqltype="cf_sql_money" 	   	value="#rsDE.SEliquido#">,
                    <cf_dbfunction name="now">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#ARGUMENTS.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.Ulocalizacion#">,
                    null
                    )
            </cfquery>
            <!---???????Se Ejecuta la relacion de Calculo???????----->
            <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo">
                <cfinvokeargument name="RCNid" 		value="#ARGUMENTS.RCNid#">
                <cfinvokeargument name="pDEid" 		value="#rsDE.DEid#">
                <cfinvokeargument name="Tcodigo" 	value="#rsDE.Tcodigo#">
                <cfinvokeargument name="ValidarCalendarios" value="#ARGUMENTS.ValidarCalendarios#">
            </cfinvoke>
			<!---???????Inserta la incidencias de ajuste en la proxima nomina, con signo opuesto???????----->
			<cfset Ivalor = rsDE.SEliquido*-1>
            <cfquery name="sqlIncidencia" datasource="#ARGUMENTS.Conexion#">
                insert  into Incidencias (DEid, CIid, CFid, Ifecha,Ivalor,Ifechasis,Usucodigo, Ulocalizacion, RHJid)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsDE.DEid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsIncidenciaP.CIid#">,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#rsCalendarios.CPdesde#">,
                    <cfqueryparam cfsqltype="cf_sql_money" 		value="#Ivalor#">,
                    <cf_dbfunction name="now">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#ARGUMENTS.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char" 		value="#ARGUMENTS.Ulocalizacion#">,
                    null
                    )
            </cfquery>
		</cfloop>
        </cftransaction>
    </cffunction>
<!---==================================FUNCION PARA MARCAR COMO VERIFICADA LA NOMINA==================================================--->
    <cffunction name="VerificaNomina" access="public">
        <cfargument name="Conexion" 			type="string"   required="no"  hint="Nombre del DataSource">
        <cfargument name="ERNid"   				type="numeric"  required="yes" hint="Id de la relación de Calculo">
        <cfargument name="Usucodigo"   	 		type="numeric"  required="no"  hint="Id del Usuario del portal">
        <cfargument name="Ecodigo"   	 		type="numeric"  required="no"  hint="Codigo de la empresa">
        <cfargument name="ERNestado"   	 		type="numeric"  default="4"    hint="0=Uploaded,1=Captura Manual,2=Listo para verificar,3=Verificado,4=Autorizado,5=Nulo,6=Enviando Pago,7=Pago Enviado,8=Pagado,9=Notificado">
        <cfargument name="DRNestado"   	 		type="numeric"  required="no"  hint="1=Pagado,=Pago Rechazado,3=Pendiente">

        <cfif NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
            <CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </cfif>
        <cfif NOT ISDEFINED('ARGUMENTS.Usucodigo') AND ISDEFINED('SESSION.Usucodigo')>
            <CFSET ARGUMENTS.Usucodigo = SESSION.Usucodigo>
        </cfif>
        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</CFIF>

    	<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="20" default="0" returnvariable="rsContabiliza"/>
 		<!---????????En caso de que la nomina se contabiliza, se verifica que los debitos sean igual a creditos con una orgura de 0.50???????--->
		<cfif rsContabiliza>
            <cfquery name="Balanceada" datasource="#ARGUMENTS.Conexion#">
                select
					sum(case when tipo = 'D' and (ci.CItimbrar is null or ci.CItimbrar = 0) then montores else 0 end) as Debitos,
					sum(case when tipo = 'C' then montores else 0 end) as Creditos
                from ERNomina a
                inner join RCuentasTipo b
                      on b.Ecodigo = a.Ecodigo
                      and b.RCNid = a.RCNid
				left join CIncidentes ci
					on ci.CIid = b.referencia
					and tipo = 'D'
                where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.ERNid#">
                   having round(sum(case when tipo = 'D' and (ci.CItimbrar is null or ci.CItimbrar = 0) then montores else 0 end),2) <> round(sum(case when tipo = 'C' then montores else 0 end),2)
                  and abs(round(sum(case when tipo = 'D' and (ci.CItimbrar is null or ci.CItimbrar = 0) then montores else 0 end),2) -  round(sum(case when tipo = 'C' then montores else 0 end),2) ) > 0.50
            </cfquery>

			<cfif Balanceada.RecordCount GT 0>
                <cfthrow message="ERROR: El asiento Contable de la Nómina no está Balanceado: Débitos=#NumberFormat(Balanceada.Debitos,',9.99')#, Créditos=#NumberFormat(Balanceada.Creditos,',9.99')#">
            </cfif>
		</cfif>
        <cfquery name="rsERNominaUpdate" datasource="#ARGUMENTS.Conexion#">
            update ERNomina set
            ERNestado 	   = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#ARGUMENTS.ERNestado#">,
            ERNusuverifica = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#ARGUMENTS.Usucodigo#">,
            ERNfverifica   = <cf_dbfunction name="now">
            where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#ARGUMENTS.Ecodigo#">
              and ERNid    = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#ARGUMENTS.ERNid#">
        </cfquery>
		<cfif isdefined('ARGUMENTS.DRNestado')>
           <cfquery name="rsDRNominaUpdate" datasource="#ARGUMENTS.Conexion#">
                update DRNomina
                 set DRNestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.DRNestado#">
                where ERNid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.ERNid#">
            </cfquery>
        </cfif>
	</cffunction>
<!---===FUNCION PARA FINALIZAR LA NOMINA(Finalizacion de Infonavit,Cierre de PTU, Calculo de Anualidades)================================--->
	<cffunction name="FinalizaNomina" access="public">
        <cfargument name="Conexion"  	 type="string"   required="no"  hint="Nombre del DataSource">
        <cfargument name="Usucodigo" 	 type="numeric"  required="no"  hint="Id del Usuario del portal">
        <cfargument name="ListERNid" 	 type="string"   required="yes" hint="Lista de ERNid(s), puede ser una lista o puede ser uno solo">
        <cfargument name="Ecodigo"   	 type="numeric"  required="no"  hint="Codigo de la empresa">

        <CFIF NOT ISDEFINED('ARGUMENTS.Conexion') AND ISDEFINED('SESSION.DSN')>
         	<CFSET ARGUMENTS.Conexion = SESSION.DSN>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.Usucodigo') AND ISDEFINED('SESSION.Usucodigo')>
            <CFSET ARGUMENTS.Usucodigo = SESSION.Usucodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('ARGUMENTS.Ecodigo') AND ISDEFINED('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</CFIF>

        <!---????????Se busca el parametro para los Conceptos de Deduciones para Infonaví???????--->
        <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2110" default="0" returnvariable="vInfonavit"/>

        <!---????????Se busca el parametro de valida presupuesto???????--->
        <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="540" default="0" returnvariable="validaPP"/>

        <!---????????Inicia el Ciclo de Cada una de las nominas a Finalizar???????--->
        <cfloop list="#ARGUMENTS.ListERNid#" index="LvarERNid">

			<!---????????Se realizan validaciones de presupuesto???????--->
            <cfinvoke component="rh.Componentes.RH_PagoNomina" method="rh_HistoricosNomina">
                <cfinvokeargument name="ERNid" value="#LvarERNid#"/>
                <cfinvokeargument name="debug" value="N" />
            </cfinvoke>

             <!---????????Histórico de Encabezado de Recepción de Nómina???????--->
             <cfquery name="EHistoNomi" datasource="#ARGUMENTS.Conexion#">
                select RCNid,HERNfinicio,HERNffin
                    from HERNomina
                  where ERNid = #LvarERNid#
             </cfquery>

			<!---????????Busca el Periodo/Mes del Calendario de pago que se esta pagando???????--->
            <cfquery name="rsPeriodoMes" datasource="#ARGUMENTS.Conexion#">
                select CPperiodo, CPmes
                	from CalendarioPagos
                 where CPid = #EHistoNomi.RCNid#
            </cfquery>

            <cftransaction>
                <!---????????INICIO DEL INFONAVIT()???????--->
                <cfif LEN(TRIM(vInfonavit)) and vInfonavit GT 0>

					<!---????????Busca a cada uno de los Empleados de la nomina, y obtiene los montos correspondientes al infonavit???????--->
                    <cfquery name="rsEmpleadoINFONAVIT" datasource="#ARGUMENTS.Conexion#">
                        select a.Did,a.Dinicio,a.Dvalor,a.Dreferencia,n.DEid,a.Did, b.Ecodigo, b.DEsdi , a.Dmetodo,	dd.FDcfm
                        from HDRNomina n
                            inner join HERNomina h
                                on h.ERNid = n.ERNid
                            inner join DatosEmpleado b
                                on b.DEid = n.DEid
                            inner join DeduccionesEmpleado a
                                 on a.DEid = b.DEid
                                and a.Did in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vInfonavit#" list="yes" separator=",">)
                            inner join TDeduccion t
                                on t.TDid = a.TDid
                            inner join FDeduccion dd
                                on dd.TDid = t.TDid
                        where h.RCNid = #EHistoNomi.RCNid#
                    </cfquery>

                    <!---????????Se busca el siguiente Consecutivo del Infonavit???????--->
                    <cfquery name="newLista" datasource="#ARGUMENTS.Conexion#">
                        select coalesce(max(Consecutivo),0)as Consecutivo
                         from RHMovInfonavit
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.Ecodigo#">
                    </cfquery>
                    <cfif newLista.Consecutivo neq ''>
                        <cfset Cons = newLista.Consecutivo + 1>
                    <cfelse>
                        <cfset Cons = 1>
                    </cfif>

                    <cfset LvarTipoMov = ''>
                    <!---????????Recorre cada una de los empleados de la nomina a calcular el INFONAVIT???????--->
                    <cfloop query="rsEmpleadoINFONAVIT">

                       <!---????????Busca el tipo de descuento del primer empleado (si son distintos para cada empleado esto esta malo)???????--->
                        <cfif rsEmpleadoINFONAVIT.Dmetodo eq 0 and len(trim(rsEmpleadoINFONAVIT.FDcfm)) neq 0 >
                            <cfset tipoDescuento = 1>  <!---porcentaje --->
                        <cfelseif rsEmpleadoINFONAVIT.Dmetodo eq 1 and len(trim(rsEmpleadoINFONAVIT.FDcfm)) eq 0 >
                            <cfset tipoDescuento = 2>  <!---cuota fija --->
                        <cfelseif rsEmpleadoINFONAVIT.Dmetodo eq 1 and len(trim(rsEmpleadoINFONAVIT.FDcfm)) neq 0 >
                            <cfset tipoDescuento = 3>  <!---veces SM --->
                        </cfif>

                        <!---????????Se coloca tipo de movimiento 17, si NO existe almenos un movimiento de infonavit previo???????--->
                        <cfquery  name="rsVerifDato"datasource="#ARGUMENTS.Conexion#">
                            select count(1) as cantidad
                                from RHMovInfonavit
                             where Ecodigo = #ARGUMENTS.Ecodigo#
                        </cfquery>
                        <cfif rsVerifDato.cantidad eq 0>
                            <cfset LvarTipoMov = '17'>
                        </cfif>
                        <!---????????Se incluyen cada uno de los registros del infonavit???????--->
                        <cflock name="Consecutivo" timeout="3" type="exclusive">
                            <cfquery name="rsInRegistro" datasource="#ARGUMENTS.Conexion#">
                                insert into RHMovInfonavit
                                 (
                                   Consecutivo,
                                   Ecodigo,
                                    Periodo,
                                    Mes,
                                    Bimestre,
                                    RCNid,
                                    DEid,
                                    DEsdi,
                                    Did,
                                    Dvalor,
                                    Dreferencia,
                                    Dinicio,
                                    Aplicada,
                                    Metodo,
                                    HERNfinicio,
                                    HERNffin,
                                    TipoMovimiento,
                                    BMfecha,
                                    BMUsucodigo
                                  )
                                values
                                (
                                    #Cons#,
                                    #ARGUMENTS.Ecodigo#,
                                    #rsPeriodoMes.CPperiodo#,
                                    #rsPeriodoMes.CPmes#,
                                    null,
                                    #EHistoNomi.RCNid#,
                                    #rsEmpleadoINFONAVIT.DEid#,
                                    #rsEmpleadoINFONAVIT.DEsdi#,
                                    #rsEmpleadoINFONAVIT.Did#,
                                    #rsEmpleadoINFONAVIT.Dvalor#,
                                    '001',
                                    #rsEmpleadoINFONAVIT.Dinicio#,
                                    0,
                                    #tipoDescuento#,
                                    '#EHistoNomi.HERNfinicio#',
                                    '#EHistoNomi.HERNffin#',
                                    <cfif isdefined('LvarTipoMov') and len(trim(LvarTipoMov)) neq 0>
                                    #LvarTipoMov#,
                                    <cfelse>
                                    null,
                                    </cfif>
                                    <cf_dbfunction name="now">,
                                    #ARGUMENTS.Usucodigo#
                                )
                                <cf_dbidentity1 datasource="#ARGUMENTS.Conexion#" name="rsInRegistro">
                            </cfquery>
                                <cf_dbidentity2 datasource="#ARGUMENTS.Conexion#" name="rsInRegistro" returnvariable="MInfoid">
                        </cflock>
                    </cfloop>
                </cfif>
                <!---????????FINAL DE INFONAVIT???????--->
                <!---????????En caso de que se valide presupuesto se finaliza el mismo???????--->
                    <cfif validaPP eq 1>
                        <cfinvoke component="rh.Componentes.RH_ValidaPresupuesto"  method="FinalizaNomina">
                             <cfinvokeargument name="ERNid" value="#LvarERNid#"/>
                        </cfinvoke>
                    </cfif>
            </cftransaction>

            <!----????????Revisa si esta nomina utilizó un calendario de pago tipo PTU --->
            <cfquery name="rsCalPTU" datasource="#ARGUMENTS.Conexion#">
                select count(1) as cantidad
                from HERNomina a
                    inner join HRCalculoNomina b
                        on b.RCNid = a.RCNid
                    inner join CalendarioPagos c
                        on c.Ecodigo = b.Ecodigo
                       and c.Tcodigo = b.Tcodigo
                       and c.CPid    = b.RCNid
                where a.ERNid  = #LvarERNid#
                  and c.CPtipo = 4 <!--- Tipo PTU --->
            </cfquery>
            <!----????????INICIO DE PTU???????--->
            <cfif rsCalPTU.cantidad eq 1>
				<!----????????Busca a cada uno de los empleados del PTU???????--->
                <cfquery name="rsPTUEmpleados" datasource="#ARGUMENTS.Conexion#">
                    select a.DEid, a.RHPTUEid
                    from RHPTUEMpleados a
                        inner join HRCalculoNomina b
                          on b.RHPTUEid = a.RHPTUEid
                        inner join HERNomina c
                          on c.RCNid = b.RCNid
                    where c.ERNid = #LvarERNid#
                      and (select count(1)
                           	from HERNomina cc
                            	inner join HDRNomina dd
                             		on dd.ERNid = cc.ERNid
                             where cc.ERNid = #LvarERNid#
                              and a.DEid = dd.DEid ) > 0
                </cfquery>
                <!---????????Actualiza los Empleados del PTU como pagados según corresponta contra HPagosEmpleado???????--->
                <cfset LvarRHPTUEid = ''>

                <cfloop query="rsPTUEmpleados">
                    <cfset LvarRHPTUEid = rsPTUEmpleados.RHPTUEid>
                    <cfquery datasource="#session.DSN#">
                        update RHPTUEMpleados
                          set RHPTUEMpagado = 1
                        where RHPTUEid = #LvarRHPTUEid#
                          and DEid     = #rsPTUEmpleados.DEid#
                    </cfquery>
                </cfloop>
                <!---????Cuenta a cuantos empleados se les reconocio el PTU, segun el ID del Encabezado del PTU(LvarRHPTUEid)?????--->
                <cfquery name="rsPTUEEmpladosReconocidos" datasource="#ARGUMENTS.Conexion#">
                    select count(1) as cantidad
                    from RHPTUEMpleados
                    where RHPTUEid = #LvarRHPTUEid#
                      and RHPTUEMreconocido = 1 <!--- 1: reconocido, 0: sin reconocer --->
                </cfquery>

                <!---????Cuenta a cuantos empleados se les Pago el PTU, segun el ID del Encabezado del PTU(LvarRHPTUEid)?????--->
                <cfquery name="rsPTUEEmpladosPagados" datasource="#ARGUMENTS.Conexion#">
                    select count(1) as cantidad
                    from RHPTUEMpleados
                    where RHPTUEid = #LvarRHPTUEid#
                      and RHPTUEMreconocido = 1 <!--- 1: reconocido, 0: sin reconocer --->
                      and RHPTUEMpagado = 1 <!--- 0: Sin Pagar, 1: Pagado --->
                </cfquery>

                <!---????????Si ya se pagaron todos los empleados reconocidos se cierra el PTU???????--->
                <cfif rsPTUEEmpladosReconocidos.cantidad eq rsPTUEEmpladosPagados.cantidad>
                    <cfquery datasource="#ARGUMENTS.Conexion#">
                        update RHPTUE
                        set	RHPTUEPagado = 1
                        where RHPTUEid = #LvarRHPTUEid#
                    </cfquery>
                </cfif>
        </cfif>
        <!---????????PTU FIN???????--->

        <!--- VALIDACION DEL PROCESO DE ANUALIDADES. 2012-01-30, Se condiciona a que se Use Tabla Salarial. --->
        <cfquery name="Anualidades" datasource="#ARGUMENTS.Conexion#">
            select 1 as usaEstructuraSalarial
			from ComponentesSalariales
			Where CSsalariobase=1
			and CSusatabla=1
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.Ecodigo#">
        </cfquery>
		<cfif Anualidades.usaEstructuraSalarial EQ 1>
				<!---?????Se Busca todos los empleados de los pagos historicos de la nomina????--->
				<cfquery name="rsSQL" datasource="#ARGUMENTS.Conexion#">
					select DEid,PEcantdias,PEdesde,PEhasta
						from HPagosEmpleado
					  where RCNid = #EHistoNomi.RCNid#
				</cfquery>
        <!---?????INICIA EL PROCESO DE CALCULO DE ANUALIDADES????--->
        		<cfloop query="rsSQL">
					<!---?????Busca a ver si ya existe un encabezado????--->
					<cfquery name="rsEnc" datasource="#ARGUMENTS.Conexion#">
						select EAid
							from EAnualidad
						where DEid = #rsSQL.DEid#
						  and DAtipoConcepto = 2 <!---Concepto de anualidad tipo ITCR--->
					</cfquery>
  					              <cfif rsEnc.recordcount eq 0>
                	<!---?????Se agrega el encabezado de las anualidades????--->
                    <cfquery name="rsIn" datasource="#ARGUMENTS.Conexion#">
                        insert into EAnualidad (DEid,EAacum,Ecodigo,BMfalta,BMUsucodigo,DAtipoConcepto) values(
                            #rsSQL.DEid#,
                            #rsSQL.PEcantdias#,
                            #ARGUMENTS.Ecodigo#,
                            <cf_dbfunction name="now">,
                            #ARGUMENTS.Usucodigo#,
                            2
                        	)
                    	<cf_dbidentity1 datasource="#ARGUMENTS.Conexion#" name="rsIn">
                    </cfquery>
                        <cf_dbidentity2 datasource="#ARGUMENTS.Conexion#" name="rsIn" returnvariable="id">
                    <!---?????Se agrega los detalles de las anualidades????--->

					<cf_dbfunction name="now" returnvariable="fechaHoy">
                    <cfquery name="rsIn" datasource="#ARGUMENTS.Conexion#">
                        insert into DAnualidad(EAid,DAfdesde,DAfhasta,DAdias,DAtipo,DAtipoConcepto,DAdescripcion,BMfalta,BMUsucodigo)
                        values(
                         #id#,
                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.PEdesde#">,
                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.PEhasta#">,
                         #rsSQL.PEcantdias#,
                         1,
                         2,
                         'Días asignados ' #_CAT# '#rsSQL.PEdesde#',
                         #fechahoy#,
                         #ARGUMENTS.Usucodigo#)
                    </cfquery>
                <cfelse>
                    <!---?????Verifica si el detalle a de la anualidades a insertar ya existe????--->
                    <cfquery name="rsVal" datasource="#ARGUMENTS.Conexion#">
                        select count(1) as cantidad from DAnualidad
                         where EAid = #rsEnc.EAid#
                           and DAfdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.PEdesde#">
                           and DAfhasta  = <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.PEhasta#">
                    </cfquery>
                    <cfif rsVal.cantidad eq 0 or len(trim(rsVal.cantidad)) eq 0>
                        <!---?????Si no existe, se agrega los detalles de las anualidades????--->
                        <cfquery name="rsIn" datasource="#ARGUMENTS.Conexion#">
                            insert into DAnualidad(EAid,DAfdesde,DAfhasta,DAdias,DAtipo,DAtipoConcepto,DAdescripcion,BMfalta,BMUsucodigo) values(
                             #rsEnc.EAid#,
                             <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.PEdesde#">,
                             <cfqueryparam cfsqltype="cf_sql_date" value="#rsSQL.PEhasta#">,
                             #rsSQL.PEcantdias#,
                             1,
                             2,
                             'Días asignados ' #_CAT# '#dateFormat(rsSQL.PEdesde,"DD/MM/YYYY")#',
                             <cf_dbfunction name="now">,
                             #ARGUMENTS.Usucodigo#
                             )
                        </cfquery>
                    </cfif>
                </cfif>
					<!---?????Actualiza el Encabezado de las anualidades, con las suma de los detalles????--->
					<cfquery name="rsUpd" datasource="#ARGUMENTS.Conexion#">
						update EAnualidad  set
							EAtotal = (select sum(DAanos) from DAnualidad
										where EAid = EAnualidad.EAid
										  and DAtipoConcepto = EAnualidad.DAtipoConcepto),
							EAacum = (select sum(DAdias) from DAnualidad
										where EAid = EAnualidad.EAid
										  and DAtipoConcepto = EAnualidad.DAtipoConcepto)
						where DEid = #rsSQL.DEid#
						  and Ecodigo = #ARGUMENTS.Ecodigo#
					</cfquery>
				<!---????FINALIZA El PROCESO DE ANUALIDAES????--->
				</cfloop>
     	<!---????FINALIZA EL CICLO DE CADA UNA DE LAS NOMINAS A FINALIZAR????--->
		</cfif>
   	</cfloop>
	</cffunction>

<!---????????????Funcion para crear una Nomina especial????????????--->
    <cffunction name="AltaNominaEspecial" access="public" output="yes" hint="Funcion para crear una Nomina especial">
        <cfargument name="Conexion" 			type="string"   required="no"  hint="Nombre del DataSource de Coldfusion">
        <cfargument name="Ecodigo" 				type="numeric"  required="no"  hint="Codigo Interno de la empresa">
        <cfargument name="Usucodigo" 			type="numeric" 	required="no"  hint="ID del usuario que esta realizando la accion">
    	<cfargument name="Ulocalizacion" 		type="string" 	required="no"  hint="Localizacion">
        <cfargument name="RCpagoentractos"  	type="boolean"  required="no" default="false" hint="Pago en dos tractos">
        <cfargument name="RCporcentaje"     	type="numeric"  required="no" default="-1"    hint="Porcentaje de pago (pago en dos tractos)">
        <cfargument name="CIid"     			type="numeric"  required="no" default="-1"    hint="Concepto Incidente (pago en dos tractos)">
        <cfargument name="reportarActividad"	type="boolean"  required="no" default="true"  hint="Bandera para saber si tienen que enviar a pantalla en avance">
        <cfargument name="Tcodigo" 				type="string"   required="no" hint="Tipo de Nomina">
        <cfargument name="RCdesde"  			type="date"     required="no" hint="Fecha desde">
        <cfargument name="RChasta"  			type="date"     required="no" hint="Fecha Hasta">
        <cfargument name="CPcodigo"    			type="string"   required="no" hint="">
        <cfargument name="ValidarCalendarios" 	type="boolean" 	required="no" default="true" hint="True.Cuenta Calendario X mes. False.Estima Calendarios X mes, esto para la proyeccion de la Renta">


        <cfargument name="RCNid"    			type="numeric"  required="yes" hint="Id del Calendario de pagos">
        <cfargument name="RCDescripcion"    	type="string"   required="yes" hint="Descripcion de la nomina especial">

        <!---??????? Si no se envia el DataSource se busca de Session ??????--->
		<cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.dsn')>
            <cfset Arguments.Conexion = Session.dsn>
        </cfif>

        <!---??????? Si no se envia la empresa se busca de Session ??????--->
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
            <cfset Arguments.Ecodigo = Session.Ecodigo>
        </cfif>

         <!---??????? Si no se envia el Usuario se busca de Session ??????--->
        <cfif NOT ISDEFINED('Arguments.Usucodigo') AND ISDEFINED('Session.Usucodigo')>
            <cfset Arguments.Usucodigo = Session.Usucodigo>
        </cfif>

         <!---??????? Si no se envia la localizacion se busca de Session, si no esta se coloca 00??????--->
        <cfif NOT ISDEFINED('Arguments.Ulocalizacion')>
            <cfif ISDEFINED('Session.Ulocalizacion')>
                <cfset Arguments.Ulocalizacion = Session.Ulocalizacion>
           <cfelse>
                <cfset Arguments.Ulocalizacion = '00'>
           </cfif>
        </cfif>
        <!---???????Se Recupera el Calendario de pago de la nomina especial??????--->
        <cfinvoke component="rh.Componentes.CalendarioPago" method="getCalendarioPago" returnvariable="rsCalendarioPago">
        	<cfinvokeargument name="CPid" value="#Arguments.RCNid#">
        </cfinvoke>
        <cfif not rsCalendarioPago.RecordCount>
        	<cfthrow message="No se puedo recuperar el calendario de pagos">
        </cfif>
        <!---???????Si no se envia el Codigo de tipo de nomina, se obtiene del Calendario de pago??????--->
        <cfif not isdefined('Arguments.Tcodigo')>
        	<cfset Arguments.Tcodigo = rsCalendarioPago.Tcodigo>
        </cfif>
        <!---???????Si no se envia la fecha desde, se obtiene del Calendario de pago??????--->
        <cfif not isdefined('Arguments.RCdesde')>
        	<cfset Arguments.RCdesde = rsCalendarioPago.CPdesde>
        </cfif>
        <!---???????Si no se envia la fecha hasta, se obtiene del Calendario de pago??????--->
        <cfif not isdefined('Arguments.RChasta')>
        	<cfset Arguments.RChasta = rsCalendarioPago.CPhasta>
        </cfif>
        <!---???????Si no se envia codigo de calendario, se obtiene del Calendario de pago??????--->
        <cfif not isdefined('Arguments.CPcodigo')>
        	<cfset Arguments.CPcodigo = rsCalendarioPago.CPcodigo>
        </cfif>


        <cfinvoke component="sif.Componentes.Translate" method="Translate"returnvariable="LB_Procesando_el_Registro_Numero"
            	Key="LB_Procesando_el_Registro_Numero" Default="Procesando el Registro Numero"/>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="MSG_ErrorDosTractos"
                Key="MSG_Deben_existir_al_menos_dos_relaciones_de_calculo_especiales_abiertas" XmlFile="/rh/componentes.xml"
                Default="No se puede crear una relación de cálculo especial de pago en dos tractos si no existe una nómina especial posterior."/>
        <cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_No_es_posible_realizar_el_calculo"
                Key="LB_No_es_posible_realizar_el_calculo" Default="No es posible realizar el cálculo"/>

		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
        <cfset LvarCIactual   = "">

		<!---?????Crear la tabla temporal de Incidencias para evitar bloqueos????--->
        <cf_dbtemp name="Inc_CalcEsp" returnvariable="IncidenciasCalculoEsp" datasource="#Arguments.Conexion#">
                <cf_dbtempcol name="DEid"   		type="numeric"  mandatory="yes">
                <cf_dbtempcol name="CIid"   		type="numeric"  mandatory="yes">
                <cf_dbtempcol name="CFid"   		type="numeric"  mandatory="no">
                <cf_dbtempcol name="Ifecha" 		type="datetime" mandatory="yes">
                <cf_dbtempcol name="Ivalor" 		type="money"    mandatory="yes">
                <cf_dbtempcol name="Ifechasis"   	type="datetime" mandatory="yes">
                <cf_dbtempcol name="Usucodigo"   	type="numeric"  mandatory="no">
                <cf_dbtempcol name="Ulocalizacion"  type="char(2)"  mandatory="no">
                <cf_dbtempcol name="BMUsucodigo"   	type="numeric"  mandatory="no">
                <cf_dbtempcol name="Iespecial"   	type="integer"  mandatory="no">
                <cf_dbtempcol name="RCNid"   		type="numeric"  mandatory="no">
                <cf_dbtempcol name="Mcodigo"   		type="numeric"  mandatory="no">
                <cf_dbtempcol name="RHJid"   		type="numeric"  mandatory="no">
                <cf_dbtempcol name="Imonto"   		type="money"    mandatory="no">
           		<cf_dbtempkey cols="DEid,CIid,Ifecha">
        </cf_dbtemp>

    <!---????Pago de Aguinaldo en dos tractos: Esto requiere un segundo Calendario de Pagos abierto, especial y posterior al actual (Henkel [14/05/2007])?????--->
	<cfif Arguments.RCpagoentractos>
        <cfquery name="rsFechaCP" datasource="#Arguments.Conexion#">
            select 1
            	from CalendarioPagos
            where Tcodigo = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#" >
              and CPtipo = 1
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and CPfpago > ( select CPfpago
                              from CalendarioPagos
                             where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> )
            order by CPfpago desc
        </cfquery>
        <cfif rsFechaCP.recordcount eq 0 >
            <cf_throw message='#MSG_ErrorDosTractos#' errorCode="1140">
        </cfif>
    </cfif>
    <!---?????Busca cada una de las incidencias a agregar??????--->
    <cfquery name="rsConceptos" datasource="#Arguments.Conexion#">
		select a.Ecodigo, a.Tcodigo, a.DEid, a.RHJid, coalesce(c.CFidconta, c.CFid) as CFid, f.CIid, g.CIcantidad, g.CIrango, g.CItipo, g.CIdia, g.CImes
			   ,g.CIsprango, coalesce(g.CIspcantidad,0) as CIspcantidad, coalesce(g.CImescompleto,0) as CImescompleto,d.CPTipoCalRenta
		from LineaTiempo a
			<!--- OPARRALES 2018-10-31 Validaciones para aguinaldos, solo debe tomar acciones de nombramiento --->
			inner join RHTipoAccion ta
				on ta.RHTid = a.RHTid
				<!---JARR aqui estuvo Maltin and ta.RHTcomportam = 1  ULTIMA ACCION DE NOMBRAMIENTO ---->
        	inner join RHJornadas b
            	on a.Ecodigo = b.Ecodigo
		       and a.RHJid = b.RHJid
            inner join RHPlazas c
            	on a.Ecodigo = c.Ecodigo
		       and a.RHPid   = c.RHPid
            inner join CalendarioPagos d
            	on a.Ecodigo = d.Ecodigo
		  	   and a.Tcodigo = d.Tcodigo
            inner join CCalendario e
            	on e.CPid = d.CPid
            inner join CIncidentes f
            	on f.CIid = e.CIid
            inner join CIncidentesD g
            	on g.CIid = f.CIid
		where a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		  and a.Tcodigo   = <cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.Tcodigo#">
		  and (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.RChasta#">
          and a.LThasta  >= <cfqueryparam cfsqltype="cf_sql_date"    value="#Arguments.RCdesde#">)
		  and d.CPid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and d.CPtipo    = 1
		  and f.CItipo in (2, 3)
		  order by f.CIid, a.DEid
	</cfquery>

	<!--- OPARRALES 2018-10-29 Inicio cambio para aguinaldo --->
	<cfset esAguinaldo = false>
	<cfquery name="rsDiasAguin" datasource="#Arguments.Conexion#">
		select Pvalor
		from RHParametros
		where
			Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2052">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	<cfset varDiasAg = (rsDiasAguin.RecordCount gt 0 and Trim(rsDiasAguin.Pvalor) neq '') ? rsDiasAguin.Pvalor : 0>

	<cfloop query="rsConceptos">
		<!--- OPARRALES 2018-10-29 Asignamos bandera y validamos que el parametro de dias de aguinaldo este configurado --->
		<cfset esAguinaldo = (rsConceptos.CPTipoCalRenta eq 2)>
		<cfif esAguinaldo and varDiasAg eq 0>
			<cfthrow message="Parametros RH " detail="No se han configurado los dias de aguinaldo">
		</cfif>


    	<!---?????reporte de avance??????--->
		<cfif Arguments.reportarActividad>
    		<cfoutput><br>#LB_Procesando_el_Registro_Numero#: #rsConceptos.CurrentRow# / #rsConceptos.recordcount# - #now()#</cfoutput>
        </cfif>

		<cfif LvarCIactual NEQ rsConceptos.CIid>
			<cfset LvarCIactual = rsConceptos.CIid>
			<cfquery name="rsObtieneCalculo" datasource="#Arguments.Conexion#">
				select CIcalculo
				from CIncidentesD
				where CIid = #LvarCIactual#
			</cfquery>
			<cfset current_formulas = rsObtieneCalculo.CIcalculo>
		</cfif>
		<!---?????Procesa el calculo de las incidencias??????--->
		<cfset presets_text = RH_Calculadora.get_presets(
									   Arguments.RChasta,
									   Arguments.RChasta,
									   rsConceptos.CIcantidad,
									   rsConceptos.CIrango,
									   rsConceptos.CItipo,
									   rsConceptos.DEid,
									   rsConceptos.RHJid,
									   rsConceptos.Ecodigo,
									   0,
									   0,
									   rsConceptos.CIdia,
									   rsConceptos.CImes,
									   rsConceptos.Tcodigo,
									   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
									   'false',
									   '',
									   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
									   , 0
									   , ''
									   ,rsConceptos.CIsprango
									   ,rsConceptos.CIspcantidad
									   ,rsConceptos.CImescompleto)>
		<cfset values     = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
		<cfset calc_error = RH_Calculadora.getCalc_error()>

		<cfif Not IsDefined("values")>
			<cfif isdefined("presets_text")>
				<cf_throw message="#LB_No_es_posible_realizar_el_calculo#&nbsp;#presets_text# &nbsp;----&nbsp; current_formulas &nbsp; ----- &nbsp; #calc_error#" errorCode="1000">
			<cfelse>
				<cf_throw message="#LB_No_es_posible_realizar_el_calculo#&nbsp;#calc_error#" errorCode="1000">
			</cfif>
		</cfif>
		<cfset varIvalor = values.get('importe').toString()>
		<!---?????Inserta cada una de las incidencias de la nomina especial??????--->		
		<cfquery name="insIncidencias" datasource="#Arguments.Conexion#">
			insert into #IncidenciasCalculoEsp# (DEid, CIid, CFid, Ifecha, Ivalor, Imonto, Ifechasis, Iespecial, Usucodigo, Ulocalizacion, RCNid)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsConceptos.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsConceptos.CIid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsConceptos.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.RChasta#">,
			<!--- OPARRALES 2018-10-29 Formula para calcular monto de aguinaldo: IVALOR * 15 /365 --->
				<cfif esAguinaldo>
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#values.get('cantidad').toString()#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" 		value="#values.get('importe').toString()#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#values.get('resultado').toString()#">,
				<cf_dbfunction name="now">,
				<cfqueryparam cfsqltype="cf_sql_bit" 		value="1">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Ulocalizacion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RCNid#">
			)
		</cfquery>


	</cfloop>
	<cfquery name="ExisteRelacion" datasource="#Arguments.Conexion#">
    	select Count(1) cantidad from RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RCNid#">
    </cfquery>
    <cfif ExisteRelacion.cantidad GT 0>
    	<cfthrow message="La relacion de calculo ya existe">
    </cfif>
	<cftransaction>

		<cfquery name="ABC_Relacion" datasource="#Arguments.Conexion#">
			insert into RCalculoNomina (RCNid, RCDescripcion, Ecodigo, Tcodigo, RCdesde, RChasta, RCestado, Usucodigo, Ulocalizacion, RCpagoentractos, RCporcentaje, CIid)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RCNid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.RCDescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char"    	value="#Arguments.Tcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.RCdesde#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.RChasta#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#">,
				<cfif Arguments.RCpagoentractos>
					1,
					<cfqueryparam cfsqltype="cf_sql_float"   value="#Arguments.RCporcentaje#" null="#Arguments.RCporcentaje EQ -1#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#" 		  null="#Arguments.CIid EQ -1#">
				<cfelse>
					0, null, null
				</cfif> )
		</cfquery>

		<cfquery name="insIncidencias" datasource="#Arguments.Conexion#">
			insert into Incidencias (DEid, CIid, CFid, Ifecha, Ivalor, Imonto, Ifechasis, Iespecial, Usucodigo, Ulocalizacion, RCNid, Iestado, NAP)
			select DEid, CIid, CFid, Ifecha, Ivalor, Imonto, Ifechasis, Iespecial, Usucodigo, Ulocalizacion, RCNid, 1, 500
			from #IncidenciasCalculoEsp# a
			where not exists ( select 1
							 from Incidencias
							 where DEid=a.DEid
							   and CIid=a.CIid
							   and Ifecha=a.Ifecha
							   )
		</cfquery>
		<!----- 27/Abril/2009 Se agrega update por problema con incidencias que se pagaron pero no tienen el RCNid
		Actualiza el RCNid de los cincidentes que se le hayan ingresado a los empleados (y que estan definidos en el calendario) cuya fecha sea para pagar en esta nomina---->
		<cfquery name="rActualiza" datasource="#Arguments.Conexion#">
			Update Incidencias
				set RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			where exists (select 1
							from Incidencias b
                            	inner join #IncidenciasCalculoEsp# a
                                	on a.DEid   = b.DEid
								   and a.CIid   = b.CIid
								   and a.Ifecha =  b.Ifecha
							where Incidencias.Iid = b.Iid)
		</cfquery>
	</cftransaction>

         <cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="RelacionCalculo">
            <cfinvokeargument name="RCNid" 				value="#Arguments.RCNid#">
            <cfinvokeargument name="ValidarCalendarios" value="#Arguments.ValidarCalendarios#">
        </cfinvoke>
	</cffunction>

    <cffunction name="fnAltaSalarioEmpleado" access="public">
    	<cfargument name="RCNid" 			type="numeric" 	required="yes">
        <cfargument name="DEid" 			type="numeric" 	required="yes">
        <cfargument name="SEsalariobruto" 	type="numeric" 	required="no" default="0">
        <cfargument name="SEcargasempleado" type="numeric" 	required="no" default="0">
        <cfargument name="SEcargaspatrono" 	type="numeric" 	required="no" default="0">
        <cfargument name="SErenta" 			type="numeric" 	required="yes">
        <cfargument name="SEdeducciones" 	type="numeric" 	required="no" default="0">
        <cfargument name="SEliquido" 		type="numeric" 	required="yes">
        <cfargument name="SEacumulado" 		type="numeric" 	required="no" default="0">
        <cfargument name="SEproyectado" 	type="numeric" 	required="no" default="0">
        <cfargument name="SEcalculado" 		type="numeric" 	required="no" default="1">
    	<cfargument name="Ecodigo" 			type="numeric" 	required="no">
    	<cfargument name="Conexion" 		type="string"	required="no">

        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>

        <cfquery datasource="#Arguments.Conexion#">
        	insert into SalarioEmpleado(RCNid, DEid, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEcalculado)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEsalariobruto#">,
            	<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEincidencias#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEcargasempleado#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEcargaspatrono#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SErenta#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEdeducciones#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEliquido#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEacumulado#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.SEproyectado#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.SEcalculado#">
            )
       	</cfquery>
    </cffunction>
</cfcomponent>
