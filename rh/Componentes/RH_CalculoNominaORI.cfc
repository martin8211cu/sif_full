<!--- NOTA IMPORTANTE: CUALQUIER AGREGADO A ESTE ARCHIVO DEBE TRATAR DE SER INDEPENDIENTE DE LA FUNCION CalculoNomina, ES DECIR EN LO POSIBLE NO AGREGAR CADIGO FUENTE A ESTA FUNCION MENCIONADA PARA EVITAR ERROR DE MEMORIA DE JAVA, SE HAY NECESIDAD DE AGREGAR CODIGO FUENTE, PARA ESTA FUNCION, INTENTAR REALIZAR FUNCIONES INDEPENDIENTES QUE PUEDEAN SER LLAMADAS DESDE LA FUNCION CalculoNomina O CalculoNominaExtencion SEGUN SEA EL CASO (crodriguez)--->

<cfcomponent hint="Realiza el cálculo de la nómina, equivale a rh_CalculoNomina">
	<!---
		se invoca desde:
		rh/nomina/operacion/ResultadoCalculo-listaSql.cfm
		rh/nomina/operacion/ResultadoCalculo-sql.cfm (2)
		rh/nomina/operacion/ResultadoCalculoEsp-listaSql.cfm
		rh/nomina/operacion/ResultadoCalculoEsp-sql.cfm (2)

	Está basado en el procedimiento almacenado rh_CalculoNomina,
	tomado de desarrollo, tal como aparece en RH_CalculoNomina.sql

	Migrado por danim, 16-jun-2006g

	Notas:
		[NOTA1] Query sobre parámetros, revisar
		[NOTA2]: Esta sección del código depende de la base de datos
		[NOTA3]: se pone el max para que no devuelva nunca más de un valor.

	--->

<!---ljimenez Funcion que devuelve el salario minimo general para el empleado (SMG) uso mexico--->
<cffunction name="SMG" access="public" returntype="numeric" hint="Funcion que devuelve el salario minimo general para el empleado (SMG)">
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
		<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
	</cfif>
	<cfreturn SZEsalarioMinimo>
</cffunction>
<!---?????Funcion que devuelve el salario Diario Integral para el empleado(mexico)?????--->
<cffunction name="SDI" access="public" returntype="numeric">
	<cfargument name="DEid" type="numeric" required="yes">

    <!---<cfif arguments.DEid GT 0 >
	  <cfquery name="rsAno" datasource="#session.dsn#">
     	select distinct case
        	when (datediff(yy, EVfantig, GETDATE())+1) >= 5 and (datediff(yy, EVfantig, GETDATE())+1) <=  9 then   5
        	when (datediff(yy, EVfantig, GETDATE())+1) >=10 and (datediff(yy, EVfantig, GETDATE())+1) <= 14 then  10
	        when (datediff(yy, EVfantig, GETDATE())+1) >=15 and (datediff(yy, EVfantig, GETDATE())+1) <= 19 then  15
    	    when (datediff(yy, EVfantig, GETDATE())+1) >=20 and (datediff(yy, EVfantig, GETDATE())+1) <= 24 then  20
        	when (datediff(yy, EVfantig, GETDATE())+1) >=25 and (datediff(yy, EVfantig, GETDATE())+1) <= 29 then  25
	        when (datediff(yy, EVfantig, GETDATE())+1) >=30 and (datediff(yy, EVfantig, GETDATE())+1) <= 34 then  30
            when (datediff(yy, EVfantig, GETDATE())+1) >=35 and (datediff(yy, EVfantig, GETDATE())+1) <= 39 then  35
        	when (datediff(yy, EVfantig, GETDATE())+1) >=40 and (datediff(yy, EVfantig, GETDATE())+1) <= 44 then  40
    	    else  (datediff(yy, EVfantig, GETDATE())+1)
	        end as annos from DRegimenVacaciones, EVacacionesEmpleado
		where DEid = #arguments.DEid#
	  </cfquery>
    </cfif>

   <cfif rsAno.annos NEQ ''>
      <cfquery name="rsFactInt" datasource="#session.dsn#">
      	select distinct 1  + (DRVdias/365)*0.25 + DRVdiasgratifica/365 as FactorIntegracion
		from EVacacionesEmpleado ev,DRegimenVacaciones rv, LineaTiempo ltc
		where ev.DEid=#arguments.DEid#
		and ltc.Ecodigo=#session.Ecodigo#
		and DRVcant= #rsAno.annos#
		and rv.RVid = ltc.RVid
      </cfquery>

      <cfquery name="rsSalDi" datasource="#session.dsn#">
     	select max(dl.DLTmonto)/30 as Salario
        from DLineaTiempo dl
        inner join ComponentesSalariales c on dl.CSid = c.CSid and c.CSsalariobase = 1
        inner join LineaTiempo lt on dl.LTid = lt.LTid
        where DEid =#arguments.DEid#
      </cfquery>

	<cfif isdefined("rsFactInt") and rsFactInt.RecordCount neq 0 and isdefined("rsSalDi") and rsSalDi.RecordCount neq 0 >
		<cfset salario = rsSalDi.Salario>
        <cfset factor = rsFactInt.FactorIntegracion>
        <cfset sdi=salario*factor>
	<cfelse>
		<cfset sdi = 0>
	</cfif>--->
   <!--- <cfthrow message="#salario# #factor# #sdi#"  >--->

  <!--- <cfelse>--->
   	 <cfquery name="rsSDi" datasource="#session.dsn#">
		select coalesce(de.DEsdi,0) as DEsdi
			from DatosEmpleado de
			where de.DEid = #arguments.DEid#
	 </cfquery>
     <cfif isdefined("rsSDi") and rsSDi.RecordCount neq 0  >
        <cfset sdi=rsSDi.DEsdi>
	 <cfelse>
		<cfset sdi = 0>
	 </cfif>
   <!--- </cfif>--->
	<cfreturn sdi>
</cffunction>

<cffunction name="CalculoNomina" access="public" returntype="void" hint="Calcula la nómina para uno o todos los empleados">
    <cfargument name="datasource" 			type="string" 	required="no"  	hint="Nombre del Datasource de Coldfusion">
    <cfargument name="Ecodigo" 				type="numeric" 	required="no" 	hint="Codigo Interno de la empresa">
    <cfargument name="RCNid" 				type="numeric" 	required="yes" 	hint="Codigo Interno del encabezado de la nomina">
    <cfargument name="Tcodigo" 				type="string" 	required="no" 	hint="Codigo del tipo de Nomina" default="">
    <cfargument name="RCdesde" 				type="date" 	required="no" 	hint="Fecha Desde">
    <cfargument name="RChasta" 				type="date" 	required="no" 	hint="Fecha Hasta">
    <cfargument name="Usucodigo" 			type="numeric" 	required="no" 	hint="ID del usuario que esta realizando la accion">
    <cfargument name="Ulocalizacion" 		type="string" 	required="no" 	hint="Localizacion">
    <cfargument name="debug" 				type="boolean" 	required="no" 	hint="Debug"	default="no">
    <cfargument name="pDEid" 				type="numeric"	required="no" 	hint="Id Interno del Empleado">
    <cfargument name="ValidarCalendarios" 	type="boolean" 	required="no"   hint="True. Cuenta Calendario X mes. False. Estima Calendarios X mes"default="true" >

	<!---??????? Inicialización de Variables ??????--->
	<cfset var CantPagosPeriodo = 0><!---int--->
    <cfset var per 				= 0><!---int--->
    <cfset var mes 				= 0><!---int--->
    <cfset var Factor			= 1><!---float--->
    <cfset var CantDiasMensual 	= 0><!---int--->
    <cfset var cantdias 		= 0><!---int--->
    <cfset var retroactivo 		= 0><!---int--->
    <cfset var idincidenciared	= 0><!---numeric--->
    <cfset var factored 		= 0><!---money--->
    <cfset var tipored 			= 0><!---int--->
    <cfset var minimo 			= 0><!---money--->
    <cfset var CSid	 			= 0><!---numeric, Id del componente del salario base --->
    <cfset var PagoComision 	= 0><!---int--->
    <cfset var error 			= 0><!---int--->
    <cfset var CPidant 			= 0><!---numeric--->
    <cfset var IRcodigo 		= ''><!---varchar--->
    <cfset CantPagosRealizados 	= QueryNew("cant")>



	<!---??????? Si no se envia el DataSource se busca de Session ??????--->
	<cfif NOT ISDEFINED('Arguments.datasource') AND ISDEFINED('Session.dsn')>
        <cfset Arguments.datasource = Session.dsn>
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

    <!---??????? Se obtienen el Salario Minimo General Zona A ??????--->
    <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2024" default="0" returnvariable="vSMGA"/>
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2051" default="0" returnvariable="vUMA"/>

	<!---??????? Se obtienen los datos del calendario, nomina y tipo de nomina Actual ??????--->
	<cfquery datasource="#Arguments.datasource#" name="CalendarioPagos">
        select a.CPnorenta, a.CPnocargas, a.CPnocargasley, a.CPperiodo, a.CPmes, a.CPtipo, a.CPnodeducciones, b.RCpagoentractos, b.RCporcentaje, b.RChasta, b.RCdesde, a.Tcodigo,c.Ttipopago as frecuencia, c.FactorDiasSalario,  c.FactorDiasIMSS, c.IRcodigo
            from CalendarioPagos a
                inner join RCalculoNomina b
                    on b.RCNid = a.CPid
                inner join TiposNomina c
                    on c.Ecodigo = a.Ecodigo
                   and c.Tcodigo = a.Tcodigo
        where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	</cfquery>
    <cfif Not Len(CalendarioPagos.CPperiodo) or Not Len(CalendarioPagos.CPmes)>
		<cfthrow message="Error, No se pudo obtener el ID en el Calendario de Pagos correspondiente a las fehas de la relación de Cálculo de Nómina!!!!. Proceso Cancelado.">
	</cfif>

    <!---??????? Se calcula la Fecha Desde, Fecha Hasta y Tipo de Calendario de Pago en caso de que no se envie ??????--->
	<cfif Not Len(Arguments.Tcodigo)>
        <cfset Arguments.RCdesde = CalendarioPagos.RCdesde>
        <cfset Arguments.RChasta = CalendarioPagos.RChasta>
        <cfset Arguments.Tcodigo = CalendarioPagos.Tcodigo>
    </cfif>

    <!---??????? Se busca la Tabla de Impuesto de Renta a Utilizar??????--->
   <!--- <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="30" default="" returnvariable="IRcodigo"/>--->

	<cfif Not Len(Arguments.IRcodigo)>
        <cfthrow message="Error!, No se ha definido la Tabla de Impuesto de Renta a utilizar en los parámetros del Sistema. Proceso Cancelado!!">
    </cfif>

	<!---???????   Obtener factor de redondeo y id de la incidencia para redondeo ??????--->
    <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="110" default="0" returnvariable="factored"/>
    <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="120" default="1" returnvariable="tipored"/>

  	<!---???????   Se busca el concepto de Pago para redondeo ??????--->
    <cfquery datasource="#Arguments.datasource#" name="idincidenciared">
        select CIid
        from CIncidentes
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
          and CIredondeo = 1
          and CIcarreracp = 0
    </cfquery>
    <cfif Not Len(idincidenciared.CIid)>
        <cfquery datasource="#Arguments.datasource#" name="idincidenciared">
            select min(b.CIid) as CIid
            from CIncidentes b
            where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and b.CIcarreracp = 0
        </cfquery>
    </cfif>
    <cfset idincidenciared = idincidenciared.CIid>
    <cfif Not Len(idincidenciared)>
        <cfthrow message="Error, no se ha definido el Concepto de Pago para Redondeo!. Proceso Cancelado.">
    </cfif>

	<!---???????Se busca la cantidad de pagos por periodo/mes y la cantidad pagos anteriores a la nomina a pagar(CRC y SLV si lo usan, MX no usa esto) ??????--->
	<cfif CalendarioPagos.CPnorenta is 0>
    	<!---??Se busca la cantidad de pagos realizados (Igual para Cloud y RRHH)??--->
    	<cfquery datasource="#Arguments.datasource#" name="CantPagosRealizados">
            select count(1) as cant
            from CalendarioPagos
            where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              and Tcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
              and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPperiodo#">
              and CPmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPmes#">
              and CPtipo in (0,2,3,4)
              and CPdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
        </cfquery>

        <!---??Se busca la cantidad Pagos por periodo y factor para RRHH ??--->
        <cfif ValidarCalendarios>
            <cfquery datasource="#Arguments.datasource#" name="CantPagosPeriodo">
                select count(1) as cant
                from CalendarioPagos
                where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and Tcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
                  and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPperiodo#">
                  and CPmes		= <cfqueryparam cfsqltype="cf_sql_integer" value="#CalendarioPagos.CPmes#">
                  and CPtipo in (0,2,3,4)
            </cfquery>

            <cfif CantPagosRealizados.cant is 0>
                <cfthrow message="Error, No se puede obtener el factor para el cálculo del salario proyectado!.Proceso Cancelado.">
            </cfif>
            <cfset Factor = CantPagosPeriodo.cant / CantPagosRealizados.cant>
        <!---??Se busca la cantidad Pagos por periodoy Factor para Cloud??--->
        <cfelse>
        	<cfset StructReturn = getFactor(CalendarioPagos.CPmes,CalendarioPagos.CPperiodo,Arguments.Tcodigo,CalendarioPagos.CPtipo,CalendarioPagos.frecuencia,Arguments.RCdesde)>


		    <cfset Factor = StructReturn["CantCalendarioMensuales"] / CantPagosRealizados.cant >
    	</cfif>
		<cfif Factor is 0>
            <cfthrow message="Error, El factor obtenido para el cálculo del salario proyectado es Cero!. Proceso Cancelado.">
        </cfif>
    </cfif>


	<!---??????? Definir el componente de salario base del empleado ??????--->
    <cfquery datasource="#Arguments.datasource#" name="ComponentesSalariales">
        select min(CSid) as CSid
        from ComponentesSalariales
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
          and CSsalariobase = 1
    </cfquery>

	<!---??????? Si no encuentra un componentes marcado como salario base, toma el primero por orden de codigo ??????--->
	<cfif Not Len(ComponentesSalariales.CSid)>
        <cfif CalendarioPagos.CPtipo EQ 2>
            <cfquery datasource="#Arguments.datasource#" name="ComponentesSalariales" maxrows="1">
                select cs.CSid
                from ComponentesSalariales cs, CIncidentes ci
                where cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and cs.CIid = ci.CIid
                  and ci.CInoanticipo = 1
                order by CScodigo
             </cfquery>
        <cfelse>
            <cfquery datasource="#Arguments.datasource#" name="ComponentesSalariales" maxrows="1">
                select cs.CSid
                from ComponentesSalariales cs
                where cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                order by CScodigo
             </cfquery>
         </cfif>
    </cfif>
	<cfset CSid = ComponentesSalariales.CSid>

    <!---??????? @CantDiasMensual Cantidad de días a utilizar para el cálculo de la nómina mensua(cantidad de dias que se trabajan en el "mes") ??????--->
	<cfif len(trim(CalendarioPagos.FactorDiasSalario)) and CalendarioPagos.FactorDiasSalario gt 0>
        <cfset CantDiasMensual = CalendarioPagos.FactorDiasSalario >
    <cfelse>
        <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="80" default="" returnvariable="CantDiasMensual"/>
    </cfif>
    <cfif Len(trim(CantDiasMensual)) eq 0 or CantDiasMensual eq 0 >
        <cfthrow message="Error, debe definirse la cantidad de días a utilizar para el cálculo de la nómina mensual en los parámetros del Sistema y debe ser un valor diferente de cero. Proceso Cancelado.">
    </cfif>

	<!---??????? @cantdias Identifica la cantidad de dias que se estan pagando en esta nomina (diferencia de dias calendario).A este valor se le restan luego los dias no laborables asignados al tipo de nomina ??????---->
    <cfif CalendarioPagos.frecuencia is 2>
		<cfset cantdias = CantDiasMensual / 2>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="14600710" default="0" returnvariable="fqEntero"/>
		<cfif fqEntero eq 'S'>
			<cfset cantdias = round(cantdias)>
		</cfif>
    <cfelseif CalendarioPagos.frecuencia is 3>
        <cfset cantdias = CantDiasMensual>
    <cfelse>
        <cfquery datasource="#Arguments.datasource#" name="DiasTiposNomina">
            select  count(1) as cant
            from DiasTiposNomina
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
        </cfquery>
        <cfset cantdias = Abs(DateDiff('d', Arguments.RChasta, Arguments.RCdesde)) + 1 - DiasTiposNomina.cant + Int(cantdias / 7.0) >
        <cfif cantdias EQ 0><cfset cantdias = 1></cfif>
	</cfif>
	
	<!---??????? @minimo Salario mínimo legal mensual, Se utiliza como parametro para calculo de deducciones de ley, que valoran la deduccion contra el salario minimo de ley mensual??????--->
    <cfquery datasource="#Arguments.datasource#" name="minimo">
        select pn.Pvalor
        from RCalculoNomina rn
            inner join RHParametros pn
                on pn.Ecodigo = rn.Ecodigo
        where rn.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
          and pn.Pcodigo = 130
    </cfquery>
    <cfset minimo = minimo.Pvalor / CantDiasMensual * cantdias>

	<cfif not isdefined('Arguments.pDEid') or Arguments.pDEid LT 1 or len(trim(Arguments.pDEid)) eq 0>

		<!--- Revisar si el calculo es para un solo empleado --->
		<cfquery name="rsVerificaSoloEmpleado" datasource="#Arguments.datasource#">
			select count(1) as CantidadEmpleados
			from SalarioEmpleado se
			where se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and se.SEcalculado = 0
		</cfquery>
		<cfif rsVerificaSoloEmpleado.CantidadEmpleados eq 1>
			<!--- Se está ejecutando para un solo empleado y no se pasó el parámetro --->
			<cfquery name="rsVerificaSoloEmpleado" datasource="#Arguments.datasource#">
				select min(DEid) as pDEid
				from SalarioEmpleado se
				where se.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and se.SEcalculado = 0
			</cfquery>
			<cfset Arguments.pDEid = rsVerificaSoloEmpleado.pDEid>
		</cfif>
	</cfif>




<!--- begin --->
	<!---
		Borrar incidencias del tipo del codigo de incidencia de redondeo
		siempre y cuando no existan en la tabla de incidencias capturadas
	--->
	<cfquery datasource="#Arguments.datasource#">
		delete from IncidenciasCalculo
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idincidenciared#">
		and not exists (
			select 1
			from Incidencias b
			where b.DEid = IncidenciasCalculo.DEid
			and b.CIid = IncidenciasCalculo.CIid
			and b.Ifecha = IncidenciasCalculo.ICfecha)
	</cfquery>

	<!--- Actualizar el monto de salario en cero cuando la jornada es por hora --->
	<cfquery datasource="#Arguments.datasource#">
		 update PagosEmpleado
		 set PEmontores = 0
		 where PagosEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		   <cfif IsDefined('Arguments.pDEid')> and PagosEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		   and exists(
		   		select 1
		   		from RHJornadas j
				where j.RHJid = PagosEmpleado.RHJid
				  and j.RHJornadahora = 1)
	</cfquery>
	<!--- Actualizar el monto de salario en cero cuando el empleado tiene una planificación
	para las fechas de la nómina cuya joranada es de pago por horas laboradas, se considera
	que con solo que este en una jornada de pago por horas labordas para al guno de los días
	de la nómina, el empleado gana por horas laboradas --->

	<!--- 20120515 LZ.  Este Procedimiento se creo para dar prioridad a las planificaciones sobre la Linea del Tiempo,
							lo cual conceptualmente no es correcto.
							Adicional que el planificador no mostrara las Jornadas que son diferentes a las del empleado segun su linea del tiempo


	<cfquery datasource="#Arguments.datasource#">
	 update PagosEmpleado
	 set PEmontores = 0
	 where PagosEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	   <cfif IsDefined('Arguments.pDEid')> and PagosEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	   and exists(
	   		select 1
	   		from RHPlanificador rhpj, RHJornadas j
			where rhpj.DEid = PagosEmpleado.DEid
			  and rhpj.RHPJfinicio >= PagosEmpleado.PEdesde
			  and rhpj.RHPJffinal <= PagosEmpleado.PEhasta
			  and j.RHJid = rhpj.RHJid
			  and j.RHJornadahora = 1)
	</cfquery>
	--->
	<!---
		Calculo del Monto de las Incidencias (Pagos Variables)
		Condiciones:

			1. IncidenciasCalculo de esta relacion de calculo (RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">)
			2. Fecha de Incidencia debe ser menor que la fecha hasta de la relacion de pago (ICfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)
			3. Empleado no calculado (SalarioEmpleado.SEcalculado = 0)
			4. Tipo de Incidencia debe ser por hora o por dia (CItipo < 2 donde CItipo = 0 --> Horas, CItipo = 1 --> Dias)

		Calculo:
			1. Salario por Hora o por Dia es:
				componente de Salario Base del Detalle de la Linea del tiempo / horas de la jornada * CIfactor * CInegativo (subquery)

	--->


	<cfquery name="rsVerificaParametro1000" datasource="#Arguments.datasource#">
		select Pvalor
		from RHParametros
		where Pcodigo = 1000
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
	</cfquery>

<!--- LZ 20110401. Cuando para México se eliminan Incidencias que tienen "amarrados" conceptos para control de Límites, los valores originales deben actualizarse con su valor original,
      para el el ReCalculo preserve los montos gravables. Unicamente los conceptos de pago que tengas límites(CEidexceso) --->
	<cfquery datasource="#Arguments.datasource#" name="UpdtaeGrava">
		update IncidenciasCalculo
		set ICvalor= coalesce((Select Ivalor
						from Incidencias x
						Where IncidenciasCalculo.Iid=x.Iid),0)
		where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
		and CIid in (Select CIid from CIncidentes Where CIidexceso is not null and CItipo in (0,1) )
	</cfquery>
	<cfquery datasource="#Arguments.datasource#" name="a">
		select * from IncidenciasCalculo where  RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	    and CIid in (Select CIid from CIncidentes Where CIidexceso is not null and CItipo =2 )
	</cfquery>
	<cfquery datasource="#Arguments.datasource#" name="UpdtaeGrava">
		update IncidenciasCalculo
		set ICmontores= (Select Ivalor
						from Incidencias x
						Where IncidenciasCalculo.Iid=x.Iid)
		where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		<cfif IsDefined('Arguments.pDEid')>	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"> </cfif>
		and CIid in (Select CIid from CIncidentes Where CIidexceso is not null and CItipo =2 )
	</cfquery>
	<!-----===================== Afecta calculo del costo de horas extraordinarias =====================--->
	<cfif isdefined("rsVerificaParametro1000") and rsVerificaParametro1000.RecordCount NEQ 0 and rsVerificaParametro1000.Pvalor EQ 1>
		<!----Tabla que contiene el mto total por componentes salariales y por conceptos de pago de cada empleado de la planilla---->
		<cf_dbtemp name="temp_datos" returnvariable="temp_datos">
			<cf_dbtempcol name="DEid" 						type="numeric"  	mandatory="yes">
			<cf_dbtempcol name="RCNid" 						type="numeric"  	mandatory="yes">
			<cf_dbtempcol name="totalcomponentes" 			type="float" 		mandatory="no">
			<cf_dbtempcol name="totalconceptos"				type="float"		mandatory="no">
		</cf_dbtemp>
		<cfquery datasource="#Arguments.datasource#"><!----Inserta en la tabla los empleados de esa nomina---->
			insert into #temp_datos#(DEid,RCNid)
			select  DEid, RCNid
			from SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		<cfquery name="rsTemporal" datasource="#Arguments.datasource#"><!---Actualiza el mto total de las incidencias del empleados que afectan costo---->
			update #temp_datos#
				set totalconceptos =coalesce(( 	select sum(ICmontores)
													from IncidenciasCalculo a
														inner join CIncidentes b
															on a.CIid = b.CIid
															and b.CIafectacostoHE = 1
													where a.RCNid = #temp_datos#.RCNid
														and a.DEid = #temp_datos#.DEid
												),0)
		</cfquery>
		<cfquery datasource="#Arguments.datasource#"><!-----Actualiza el mto total de los componentes salariales del empleado----->
			update #temp_datos#
				set totalcomponentes =coalesce((	select sum(dt.DLTmonto)  <!---distinc LZ para baroda--->
													from 	SalarioEmpleado a,
															RCalculoNomina b,
															LineaTiempo lt,
															DLineaTiempo dt,
															ComponentesSalariales cs
															<cfif CalendarioPagos.CPtipo EQ 2>
															,CIncidentes ci
															</cfif>
													where a.RCNid = b.RCNid
														and a.DEid =lt.DEid
														and b.RCdesde <= lt.LThasta
														and b.RChasta >= lt.LTdesde
														and lt.LTid = dt.LTid
														and cs.CSid = dt.CSid
														and cs.CSpagohora = 1
														 <cfif CalendarioPagos.CPtipo EQ 2>
														  and cs.CIid = ci.CIid
														  and ci.CInoanticipo = 1
														  </cfif>
														and a.RCNid = #temp_datos#.RCNid
														and a.DEid = #temp_datos#.DEid
												),0)
												+			<!---INCLUYE RECARGO DE FUNCIONES--->
												coalesce((	select sum(dt.DLTmonto)
													from 	SalarioEmpleado a,
															RCalculoNomina b,
															LineaTiempoR lt,
															DLineaTiempoR dt,
															ComponentesSalariales cs
															<cfif CalendarioPagos.CPtipo EQ 2>
															,CIncidentes ci
															</cfif>
													where a.RCNid = b.RCNid
														and a.DEid =lt.DEid
														and b.RCdesde <= lt.LThasta
														and b.RChasta >= lt.LTdesde
														and lt.LTRid = dt.LTRid
														and cs.CSid = dt.CSid
														and cs.CSpagohora = 1
														 <cfif CalendarioPagos.CPtipo EQ 2>
														  and cs.CIid = ci.CIid
														  and ci.CInoanticipo = 1
														  </cfif>
														and a.RCNid = #temp_datos#.RCNid
														and a.DEid = #temp_datos#.DEid
												),0)
		</cfquery>

		<!---Actualiza IncidenciasCalculo---->
		<cfquery name="t" datasource="#Arguments.datasource#">
		update IncidenciasCalculo
		  set ICmontores =
			(select
				case
					when (b.CItipo = 0 and coalesce(j.RHJhorasemanal, 0.00) > 1.00)
						then
						case when b.CIfactor = 1 then	<!----Hora normal---->
							coalesce(
							round(
									coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>,CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  <!--- and dt.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CSid#"> --->
											  and cs.CSid = dt.CSid
											  and cs.CSpagohora = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)
									* 12.0 / 52.0
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
									/ (j.RHJhorasemanal * 1.00)
							,2), 0.00)
						else	<!---Hora extra, doble, etc---->
							coalesce(
								round(coalesce((select sum(x.totalcomponentes+x.totalconceptos)
												from #temp_datos# x
												where d.DEid = x.DEid
													and d.RCNid = x.RCNid
												),0.00)
											* 12.0 / 52.0
											* IncidenciasCalculo.ICvalor
											* b.CIfactor
											* b.CInegativo
											/ (j.RHJhorasemanal * 1.00)
										,2)
								,0.00) * (lt.LTporcsal/100)
						end
					when (b.CItipo = 0 and coalesce(j.RHJhoradiaria, 0.00) > 1.00)
						then
						  case when b.CIfactor = 1 then	<!----Hora normal---->
							coalesce(
							round(
									coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  <!--- and dt.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CSid#"> --->
											  and cs.CSid = dt.CSid
											  and cs.CSpagohora = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)
									/ <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
									/<!---Pago por hora---->
									case when coalesce(j.RHJtipoPago,0) = 1 then
										j.RHJhoradiaria  <!--- JC , Se define sólo esto para que el valor por hora sea entre horadiaria (Ej:salario/26/8) y no entre 9.6 de la jornada--->
									else<!---Pago por dia (default)---->
										((
											case when j.RHJincHJornada = IncidenciasCalculo.CIid then
											(
											case
												(coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = <cf_dbfunction name="date_part" args="dw,IncidenciasCalculo.ICfecha">),0.00))
											when 0.00 then j.RHJhoradiaria
											else
												(coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = <cf_dbfunction name="date_part" args="dw,IncidenciasCalculo.ICfecha">),0.00))
											end
											)
											else j.RHJhoradiaria end
										  ) * 1.00)
									end
							,2), 0.00)
						else	<!---Hora extra, doble, etc---->
							coalesce(
							round(coalesce((select sum(x.totalcomponentes+x.totalconceptos)
												from #temp_datos# x
												where d.DEid = x.DEid
													and d.RCNid = x.RCNid
										),0.00)
										/ <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
										* IncidenciasCalculo.ICvalor
										* b.CIfactor
										* b.CInegativo
										/
										<!---Pago por hora---->
										case when coalesce(j.RHJtipoPago,0) = 1 then
											j.RHJhoradiaria  <!--- JC , Se define sólo esto para que el valor por hora sea entre horadiaria (Ej:salario/26/8) y no entre 9.6 de la jornada--->
										else<!---Pago por dia (default)---->
											((
											case when j.RHJincHJornada = IncidenciasCalculo.CIid then
											(
											case
												(coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = <cf_dbfunction name="date_part" args="dw,IncidenciasCalculo.ICfecha">),0.00))
											when 0.00 then j.RHJhoradiaria
											else
												(coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = <cf_dbfunction name="date_part" args="dw,IncidenciasCalculo.ICfecha">),0.00))
											end
											)
											else j.RHJhoradiaria end
										  ) * 1.00)
										end
								   ,2)
							  ,0.00)
						end
					when (b.CItipo = 1 and coalesce (j.RHJdiassemanal, 0) >  1.00)
						then
							coalesce(
							round(
									coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)
									* 12.0 / 52.0
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
									/ (j.RHJdiassemanal * 1.00)
							,2), 0.00)

					when (b.CItipo = 1)
						then
							coalesce(
							round(
									coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>,CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)
									/ <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
							,2), 0.00)
					else
							0.00
				end
			 from SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j
			 where d.DEid = IncidenciasCalculo.DEid
			   and d.RCNid = IncidenciasCalculo.RCNid
			   <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			   and d.SEcalculado = 0
			   and b.CIid = IncidenciasCalculo.CIid
			   and b.CItipo < 2                        <!--- Que no sea importe --->
			   and IncidenciasCalculo.DEid = lt.DEid
			   and IncidenciasCalculo.ICfecha between lt.LTdesde and lt.LThasta
			   and j.RHJid = coalesce(IncidenciasCalculo.RHJid, lt.RHJid)
			)
		 where IncidenciasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		   and IncidenciasCalculo.ICfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
		   and exists (
				 select 1
				 from SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j
				 where d.DEid = IncidenciasCalculo.DEid
				   and d.RCNid = IncidenciasCalculo.RCNid
				   <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				   and d.SEcalculado = 0
				   and b.CIid = IncidenciasCalculo.CIid
				   and b.CItipo < 2                        <!--- Que no sea importe --->
				   and IncidenciasCalculo.DEid = lt.DEid
				   and IncidenciasCalculo.ICfecha between lt.LTdesde and lt.LThasta
				   and j.RHJid = coalesce(IncidenciasCalculo.RHJid, lt.RHJid))
		</cfquery>

	<cfelse><!-----========= UPdate anterior sin parametro 1000 =========----->
    	<cfquery datasource="#Arguments.datasource#">
		 update IncidenciasCalculo
		  set ICmontores =
			(select
				case  <!---calculo cuando la nomina es horas semanal--->
					when (b.CItipo = 0 and coalesce(j.RHJhorasemanal, 0.00) > 1.00)
						then
							coalesce(
							round(
									(coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt,
											ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>,
											CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagohora = 1
                                              and cs.CSusatabla = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)+
                                    coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00))
											from DLineaTiempo dt,
											ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>,
											CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagohora = 1
                                              and cs.CSusatabla <> 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00))
									* 12.0 / 52.0
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
									/ ((j.RHJhorasemanal * 1.00) * (lt.LTporcsal/100))
							,2), 0.00)
						<!---calculo cuando la nomina es horas mensual/quincenal--->
					when (b.CItipo = 0 and coalesce(j.RHJhoradiaria, 0.00) > 1.00)
						then
							coalesce(
							round(
									(coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagohora = 1
                                              and cs.CSusatabla = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)
									<!--- OPARRALES 2018-08-10 Modificacion para calculo de horas extras --->
									<!--- Para el calculo de horas extras no es necesario incluir los componentes salariales que no usan tabla. --->
                                    <!--- + coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00))
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagohora = 1
                                              and cs.CSusatabla <> 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00) --->)
									/ <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
									 /
									<!---Pago por hora---->
									(case when coalesce(j.RHJtipoPago,0) = 1 then
										j.RHJhoradiaria  <!--- JC , Se define sólo esto para que el valor por hora sea entre horadiaria (Ej:salario/26/8) y no entre 9.6 de la jornada--->
									else<!---Pago por dia (default)---->
										((
											case when j.RHJincHJornada = IncidenciasCalculo.CIid then
											(
											case
												(coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = <cf_dbfunction name="date_part" args="dw,IncidenciasCalculo.ICfecha">),0.00))
											when 0.00 then j.RHJhoradiaria
											else
												(coalesce((select RHJhorasNormales from RHDJornadas where RHJid = j.RHJid and RHDJdia = <cf_dbfunction name="date_part" args="dw,IncidenciasCalculo.ICfecha">),0.00))
											end
											)
											else j.RHJhoradiaria end
										  ) * 1.00)
									end
									<!--- OPARRALES 2018-08-10 Modificacion para calculo de horas extras --->
									*(lt.LTporcsal/100))
							,2), 0.00)

					 <!---calculo cuando la nomina es dias semanal--->
					<!--- when (b.CItipo = 1 and coalesce (j.RHJdiassemanal, 0) >  1.00)
						then
							coalesce(
							round(
									(coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
                                              and cs.CSusatabla = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)+
                                    coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00))
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
                                              and cs.CSusatabla <> 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00))
									* 12.0 / 52.0
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
									/ ((j.RHJdiassemanal * 1.00) * (lt.LTporcsal/100))
							,2), 0.00) --->

					when (b.CItipo = 1 and coalesce (j.RHJdiassemanal, 0) >  1.00)
						then
							coalesce(
							round(
									(((coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
                                              and cs.CSusatabla = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)+0
                                    <!--- coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00))
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>, CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
                                              and cs.CSusatabla <> 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00) --->
									)
									/30.4)/8)
									<!--- Semanal --->
									* IncidenciasCalculo.ICvalor ,2), 0.00)

					<!---calculo cuando la nomina es Dias mensual/quincenal--->
					when (b.CItipo = 1)
						then
							coalesce(
							round(
									(coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00)) * (lt.LTporcsal/100)
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>,CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
                                              and cs.CSusatabla = 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00)+
                                    coalesce((
											select sum(coalesce(dt.DLTmonto, 0.00))
											from DLineaTiempo dt, ComponentesSalariales cs<cfif CalendarioPagos.CPtipo EQ 2>,CIncidentes ci</cfif>
											where dt.LTid = lt.LTid
											  and cs.CSid = dt.CSid
											  and cs.CSpagodia = 1
                                              and cs.CSusatabla <> 1
											  <cfif CalendarioPagos.CPtipo EQ 2>
											  and cs.CIid = ci.CIid
											  and ci.CInoanticipo = 1
											  </cfif>
									), 0.00))
									/ <cfqueryparam cfsqltype="cf_sql_float" value="#CantDiasMensual#">
									* IncidenciasCalculo.ICvalor
									* b.CIfactor
									* b.CInegativo
							,2), 0.00)
					else
							0.00
				end
			 from SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j
			 where d.DEid = IncidenciasCalculo.DEid
			   and d.RCNid = IncidenciasCalculo.RCNid
			   <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			   and d.SEcalculado = 0
			   and b.CIid = IncidenciasCalculo.CIid
			   and b.CItipo < 2                        <!--- Que no sea importe --->
			   and IncidenciasCalculo.DEid = lt.DEid
			   and IncidenciasCalculo.ICfecha between lt.LTdesde and lt.LThasta
			   and j.RHJid = coalesce(IncidenciasCalculo.RHJid, lt.RHJid)
			)
		 where IncidenciasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		   and IncidenciasCalculo.ICfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
		   and exists (
				 select 1
				 from SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j
				 where d.DEid = IncidenciasCalculo.DEid
				   and d.RCNid = IncidenciasCalculo.RCNid
				   <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				   and d.SEcalculado = 0
				   and b.CIid = IncidenciasCalculo.CIid
				   and b.CItipo < 2                        <!--- Que no sea importe --->
				   and IncidenciasCalculo.DEid = lt.DEid
				   and IncidenciasCalculo.ICfecha between lt.LTdesde and lt.LThasta
				   and j.RHJid = coalesce(IncidenciasCalculo.RHJid, lt.RHJid))
		</cfquery>
    </cfif><!---Fin de parametro 1000---->


	<!--- Ejecutar el calculo de incidencias de comisiones cuando aplica --->
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="330" default="0" returnvariable="PagoComision"/>
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="331" default="0" returnvariable="PagoComisionC"/>
	<cfif (PagoComision is 1) or (PagoComisionC is 1)>
		  <cfinvoke component="RH_CalculoNominaComision" method="CalculoNominaComision"
		  	conexion="#Arguments.datasource#"
		  	  ecodigo="#Arguments.Ecodigo#"
			  rcnid="#Arguments.RCNid#"
			  tcodigo="#Arguments.Tcodigo#"
			  rcdesde="#Arguments.RCdesde#"
			  rchasta="#Arguments.RChasta#"
			  ircodigo="#Arguments.IRcodigo#"
			  usucodigo="#Arguments.Usucodigo#"
			  ulocalizacion="#Arguments.Ulocalizacion#"
			  debug ="#Arguments.debug#">
			  <cfif IsDefined('Arguments.pDEid')><cfinvokeargument name="pDEid" value="#Arguments.pDEid#"></cfif>
		 </cfinvoke>
	</cfif>

	<!---Actualiza el monto de las incidencias de tipo importe---->
	<cfquery datasource="#Arguments.datasource#">
		update IncidenciasCalculo
			set ICmontores = (
				select round(IncidenciasCalculo.ICvalor,2) * b.CInegativo
				from CIncidentes b, SalarioEmpleado d
				where b.CIid = IncidenciasCalculo.CIid
				  and b.CItipo = 2                      <!--- Que sea importe  --->
				  and d.DEid = IncidenciasCalculo.DEid
				  and d.RCNid = IncidenciasCalculo.RCNid
				  and d.SEcalculado = 0
				  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>)
		where IncidenciasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and IncidenciasCalculo.ICfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
		  and exists (select 1
			from CIncidentes b, SalarioEmpleado d
			where b.CIid = IncidenciasCalculo.CIid
			  and b.CItipo = 2                        <!--- Que sea importe  --->
			  and d.DEid = IncidenciasCalculo.DEid
			  and d.RCNid = IncidenciasCalculo.RCNid
			  and d.SEcalculado = 0
			  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>)
	</cfquery>

	<cfquery datasource="#Arguments.datasource#">
		update IncidenciasCalculo
			set ICmontores = (
				select round(IncidenciasCalculo.ICmontores,2) * b.CInegativo
				from CIncidentes b, SalarioEmpleado d
				where b.CIid = IncidenciasCalculo.CIid
				  and b.CItipo = 3                      <!--- Que sea importe  --->
				  and d.DEid = IncidenciasCalculo.DEid
				  and d.RCNid = IncidenciasCalculo.RCNid
				  and d.SEcalculado = 0
				  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>)
		where IncidenciasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and IncidenciasCalculo.ICfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
			  and exists (select 1
				from CIncidentes b, SalarioEmpleado d
				where b.CIid = IncidenciasCalculo.CIid
				  and b.CItipo = 3                        <!--- Que sea importe  --->
				  and d.DEid = IncidenciasCalculo.DEid
				  and d.RCNid = IncidenciasCalculo.RCNid
				  and d.SEcalculado = 0
				  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>)
	</cfquery>

	<cfquery datasource="#Arguments.datasource#">
		update IncidenciasCalculo
			set ICmontores = (
				select round(IncidenciasCalculo.ICmontores - coalesce(IncidenciasCalculo.ICmontoant, 0.00),2)
				from SalarioEmpleado d
				where d.DEid = IncidenciasCalculo.DEid
				  and d.RCNid = IncidenciasCalculo.RCNid
				  and d.SEcalculado = 0
				  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>)
		where IncidenciasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and exists (select 1
				from SalarioEmpleado d
				where d.DEid = IncidenciasCalculo.DEid
				  and d.RCNid = IncidenciasCalculo.RCNid
				  and d.SEcalculado = 0
				  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>)
	</cfquery>

	<!---ljimenez Buscamos las incidencias que tienen limite en base al SBC, las verificamos para ver que no sobrepase ese limite,
    si lo pasa dividimos la incidencia en parte excenta y parte gravable para efectos del calculo de ISR (renta en mexico)--->

    <!---Lee parametro de usa Salario base de cotizacion este se usa como indicador que de es Legislacion Mexico--->
    <cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2025" default="0" returnvariable="vUsaSBC"/>

    <cfif vUsaSBC eq 1>
        <cfinclude template="RH_divideincidencias.cfm">
    </cfif>

    <!---FIN ljimenez Buscamos las incidencias que tienen limite en base al SBC--->

	<cfif CalendarioPagos.CPtipo EQ 0>
		<!---***INICIO Procesamiento Séptimo y Q250***--->
		<!--- Datos Séptimo y Q250 --->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo"
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250"
				returnvariable="Lvar_PagaQ250">
		<!--- PRIMERO SE TIENE QUE GENERAR EL PAGO DE SEPTIMO PARA QUE ADICIONALMENTE
			SE GENEREN LOS DIAS POR VACACIONES Y SE PUEDA CALCULAR LA BONIFICACION. --->
		<cfif Lvar_PagaSeptimo>
			<!--- Ejecutar el cálculo de incidencias de Séptimo --->
			<cfinvoke component="RH_CalculoNominaSeptimo" method="CalculoNominaSeptimo"
			  	conexion="#Arguments.datasource#"
			  	  ecodigo="#Arguments.Ecodigo#"
				  rcnid="#Arguments.RCNid#"
				  tcodigo="#Arguments.Tcodigo#"
				  rcdesde="#Arguments.RCdesde#"
				  rchasta="#Arguments.RChasta#"
				  ircodigo="#Arguments.IRcodigo#"
				  cantdiasmensual = "#CantDiasMensual#"
				  usucodigo="#Arguments.Usucodigo#"
				  ulocalizacion="#Arguments.Ulocalizacion#"
				  debug ="#Arguments.debug#">
				  <cfif IsDefined('Arguments.pDEid')><cfinvokeargument name="pDEid" value="#Arguments.pDEid#"></cfif>
			 </cfinvoke>
		</cfif>
		<cfif Lvar_PagaQ250>
			<!--- Ejecutar el cálculo de incidencias de Q250 --->
			<cfinvoke component="RH_CalculoNominaQ250" method="CalculoNominaQ250"
			  	conexion="#Arguments.datasource#"
			  	  ecodigo="#Arguments.Ecodigo#"
				  rcnid="#Arguments.RCNid#"
				  tcodigo="#Arguments.Tcodigo#"
				  rcdesde="#Arguments.RCdesde#"
				  rchasta="#Arguments.RChasta#"
				  ircodigo="#Arguments.IRcodigo#"
				  cantdiasmensual = "#CantDiasMensual#"
				  usucodigo="#Arguments.Usucodigo#"
				  ulocalizacion="#Arguments.Ulocalizacion#"
				  debug ="#Arguments.debug#">
				  <cfif IsDefined('Arguments.pDEid')><cfinvokeargument name="pDEid" value="#Arguments.pDEid#"></cfif>
			 </cfinvoke>
		</cfif>
		<!---***FIN Procesamiento Séptimo y Q250***--->
	</cfif>
	<cfquery datasource="#Arguments.datasource#">
		update IncidenciasCalculo set ICmontores = round(ICmontores,2)
		where RCNid = #Arguments.RCNid#
		  <cfif IsDefined('Arguments.pDEid')> and DEid = #Arguments.pDEid#</cfif>
	</cfquery>

	<!--- ACTUALIZA LOS MONTOS x EMPLEADO. Resumen de Nomina en la tabla SalarioEmpleado--->
	<!---ljimenez revasar SEsalariobc--->
	<cfquery datasource="#Arguments.datasource#">
		update SalarioEmpleado set
			SEincidencias  = coalesce((select coalesce(sum(b.ICmontores),0.00) from IncidenciasCalculo b
	        						<!---SML. Modificacion para que no se sumen los vales de despensa y no tengan que agregar una incidencia en negativa--->
	        							<!---inner join ComponentesSalariales cs on b.CIid = cs.CIid
										and cs.CSsalarioEspecie <> 1--->
	                                    <!---left join CIncidentes ci on ci.CIid = b.CIid
										and coalesce(ci.CIespecie,0) !=1--->
	                                <!---SML. Modificacion para que no se sumen los vales de despensa y no tengan que agregar una incidencia en negativa--->
	                                   where SalarioEmpleado.DEid = b.DEid and SalarioEmpleado.RCNid = b.RCNid), 0.00)
			, SEsalariobruto = coalesce((select coalesce(sum(b.PEmontores) ,0.00) from PagosEmpleado b where SalarioEmpleado.DEid = b.DEid and SalarioEmpleado.RCNid = b.RCNid), 0.00)
			, SEsalrec= coalesce((select coalesce(sum(b.PEsalrec) ,0.00) from PagosEmpleado b where SalarioEmpleado.DEid = b.DEid and SalarioEmpleado.RCNid = b.RCNid), 0.00)
			, SEsalariobc	 = coalesce((select coalesce(max(b.PEsalariobc) ,0.00) from PagosEmpleado b where SalarioEmpleado.DEid = b.DEid and SalarioEmpleado.RCNid = b.RCNid), 0.00)
		where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and SalarioEmpleado.SEcalculado = 0
		  <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

   	<cfquery datasource="#Arguments.datasource#">
        update SalarioEmpleado set
            SEsalariobc	 = coalesce((select de.DEsdi from DatosEmpleado de
															where de.DEid = SalarioEmpleado.DEid
																and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">),0)
        where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
          and SalarioEmpleado.SEcalculado = 0
          and SalarioEmpleado.SEsalariobc = 0
          <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

    <!--- ACTUALIZA LOS MONTOS x EMPLEADO. Resumen de Nomina en la tabla SalarioEmpleado para pago incidencias especie --->
	<!---ljimenez revasar SEsalariobc--->
   	<cfquery datasource="#Arguments.datasource#">
	    update SalarioEmpleado set
	        SEespecie  = round(coalesce((select coalesce(sum(b.ICmontores),0.00)
	    						from IncidenciasCalculo b
	                            	inner join CIncidentes c
	                                	on b.CIid = c.CIid
	                                inner join ComponentesSalariales d
	                                    on c.CIid = d.CIid
	                                    and d.CSsalarioEspecie = 1
	                            	where SalarioEmpleado.DEid = b.DEid
	                                	and SalarioEmpleado.RCNid = b.RCNid
	                                    and ICespecie = 0
	                           ), 0.00),0)

	</cfquery>
	<!---SML. Modificacion para que sume los Vales de Despensa que sean como Incidencia, no como Componente Salarial--->
	<cfquery datasource="#Arguments.datasource#">
	    update SalarioEmpleado set
	        SEespecie  =(SEespecie + round(coalesce((select coalesce(sum(b.ICmontores),0.00)
	    						from IncidenciasCalculo b
	                            	inner join CIncidentes c
	                                	on b.CIid = c.CIid
	                            	where SalarioEmpleado.DEid = b.DEid
	                                	and SalarioEmpleado.RCNid = b.RCNid
	                                    and ICespecie = 0
	                                    and c.CIespecie = 1
	                           ), 0.00),0))

	</cfquery>
	<!---SML. Modificacion para que sume los Vales de Despensa que sean como Incidencia, no como Componente Salarial--->
	<!--- Redondeo de Calculos --->
	<cfquery datasource="#Arguments.datasource#">
		update SalarioEmpleado set
			SEsalariobruto = round(SEsalariobruto,2),
			SEsalrec = round(SEsalrec,2),
			SEincidencias = round(SEincidencias,2),
			SErenta = round(SErenta,2),
			SEcargasempleado = round(SEcargasempleado,2),
			SEcargaspatrono = round(SEcargaspatrono,2),
			SEdeducciones = round(SEdeducciones,2)
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and SEcalculado = 0
		  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

	<!--- Ingresos de salario que no se consideran para cálculos en esta nómina --->
	<cfquery datasource="#Arguments.datasource#">
		update SalarioEmpleado
		set
			SEinocargas = coalesce((
				select sum(b.ICmontores)
				from IncidenciasCalculo b, CIncidentes d
				where SalarioEmpleado.DEid = b.DEid
				  and SalarioEmpleado.RCNid = b.RCNid
				  and d.CIid = b.CIid
				  and d.CInocargas > 0
			),0.00) + coalesce((
				select sum(p.PEmontores)
				from PagosEmpleado p, RHTipoAccion t
				where p.DEid = SalarioEmpleado.DEid
				  and p.RCNid = SalarioEmpleado.RCNid
				  and t.RHTid = p.RHTid
				  and t.RHTnocargas > 0
			),0.00),
			SEinocargasley = coalesce((
			   select sum(b.ICmontores)
			   from IncidenciasCalculo b, CIncidentes d
			   where SalarioEmpleado.DEid = b.DEid
				 and SalarioEmpleado.RCNid = b.RCNid
				 and d.CIid = b.CIid
				 and d.CInocargasley > 0
			  ),0.00) + coalesce((
			   select sum(p.PEmontores)
			   from PagosEmpleado p, RHTipoAccion t
			   where p.DEid = SalarioEmpleado.DEid
				 and p.RCNid = SalarioEmpleado.RCNid
				 and t.RHTid = p.RHTid
				 and t.RHTnocargasley > 0
			  ),0.00),
			SEinodeduc = coalesce((
				select sum(b.ICmontores)
				from IncidenciasCalculo b, CIncidentes d
				where SalarioEmpleado.DEid = b.DEid
				  and SalarioEmpleado.RCNid = b.RCNid
				  and d.CIid = b.CIid
				  and d.CInodeducciones > 0
			),0.00) + coalesce((
				select sum(p.PEmontores)
				from PagosEmpleado p, RHTipoAccion t
				where p.DEid = SalarioEmpleado.DEid
				  and p.RCNid = SalarioEmpleado.RCNid
				  and t.RHTid = p.RHTid
				  and t.RHTnodeducciones > 0
			),0.00)
		where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and SalarioEmpleado.SEcalculado = 0
		  <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<!---ljimenez--->

	<!--- Cálculo de las CARGAS LABORALES . Empleado y Empleador --->
	<cfif CalendarioPagos.CPnocargas is 0 or CalendarioPagos.CPnocargasley is 0 >

		<!--- Actualizar CargasCalculo con los valores de SEinocargas y SEinocargasley --->
		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo
			set CCSalarioBase = coalesce((
				select sum(SEsalariobruto + SEincidencias)
				from SalarioEmpleado se
				where se.RCNid = CargasCalculo.RCNid
				  and se.DEid = CargasCalculo.DEid), 0.00)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>

		<!--- ljimenez es aca donde se actualiza el valor de las cargas deacuerdo a los dias base de cotizacion (dbc mexico) --->
		<!--- Actualizar CargasCalculo con los valores de SEsalariobc --->
		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo
			set CCSalarioBaseCotizacion = coalesce((
				<!---select max(SEsalariobc) --->
				select max(SEsalariobc)
				from SalarioEmpleado se
				where se.RCNid = CargasCalculo.RCNid
				  and se.DEid = CargasCalculo.DEid), 0.00)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>

		<!--- ljimenez es aca donde se actualiza el valor de las cargas deacuerdo a los dias base de cotizacion (dbc mexico) --->
		<!--- calculo de cargas en periodo especial --->
		<cfquery datasource="#session.dsn#" name="rsCargasPeriodoEspecial">
			select  b.DEid,
					a.RHTid,
					a.DClinea,
					a.RHCPEporcentaje,
					b.CCSalarioBase,
					( select sum(PEsalario)
					 from PagosEmpleado
					 where RCNid = b.RCNid
					   and DEid = b.DEid ) as PEsalario  ,
					<!----coalesce(( select sum(PEsalario)---->
					coalesce(( select sum(PEsalario * case PEtiporeg when 2 then -1 else 1 end )
					  from PagosEmpleado pe
					  where pe.RCNid = c.RCNid
					    and pe.DEid = b.DEid ), 0) as salario,

					coalesce(( select sum(ICvalor)
					 		   from IncidenciasCalculo ic, Incidencias i, CIncidentes ci
					  			where ic.RCNid = c.RCNid
								  and ic.DEid = b.DEid
								  and i.Iid = ic.Iid
								  and ci.CIid = i.CIid
								  and ci.CInocargasley = 0
								  and ci.CInocargas=0 ), 0) as incidencias,
						coalesce(RHCPEporcentaje, 0) as porcentaje

			from RHCargasPeriodoEspecial a, CargasCalculo b, RCalculoNomina c

			where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and b.DClinea = a.DClinea
			and c.RCNid = b.RCNid
			<cfif IsDefined('Arguments.pDEid')> and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>

			and exists( select 1
						from LineaTiempo lt
						where lt.RHTid = a.RHTid
						  and lt.DEid = b.DEid
						  and c.RCdesde between lt.LTdesde and lt.LThasta   )
		</cfquery>

		<cfloop query="rsCargasPeriodoEspecial">
			<cfset salario_base = (rsCargasPeriodoEspecial.salario+rsCargasPeriodoEspecial.incidencias) * (rsCargasPeriodoEspecial.porcentaje/100)>
			<cfquery datasource="#session.dsn#">
				update CargasCalculo
				set CCSalarioBase = <cfqueryparam cfsqltype="cf_sql_numeric" value="#salario_base#">
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargasPeriodoEspecial.DEid#">
				  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargasPeriodoEspecial.DClinea#">
				  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>
		</cfloop>
		<!--- FIN cargas periodo especial --->

		<!--- cambio con la propuesta de roxana para que funcione en SQL server--->

		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo
			set CCSalarioBase = CCSalarioBase -
					(select case when e.ECauto = 1
								   then case when (select count(1)
								            	   from DCTDeduccionExcluir de
								            	   where de.DClinea = CargasCalculo.DClinea) > 0 then
												   			(select coalesce(sum(ic.ICmontores),0.00)
															from DCargas dc, DCTDeduccionExcluir de, IncidenciasCalculo ic
															where dc.DClinea = CargasCalculo.DClinea
															and de.DClinea = dc.DClinea
															and ic.CIid = de.CIid
															and ic.RCNid = CargasCalculo.RCNid
															and ic.DEid = CargasCalculo.DEid)
											 else
											 		coalesce(sum(se.SEinocargasley),00) end
								   else case when (select count(1)
								   				   from DCTDeduccionExcluir de
								   				   where de.DClinea = CargasCalculo.DClinea) > 0 then
												   			(select coalesce(sum(ic.ICmontores),0.00)
															from DCargas dc, DCTDeduccionExcluir de, IncidenciasCalculo ic
															where dc.DClinea = CargasCalculo.DClinea
															and de.DClinea = dc.DClinea
															and ic.CIid = de.CIid
															and ic.RCNid = CargasCalculo.RCNid
															and ic.DEid = CargasCalculo.DEid)
											else
													coalesce(sum(se.SEinocargas),0.00) end
								   end
						from DCargas d, ECargas e, SalarioEmpleado se
						where d.DClinea = CargasCalculo.DClinea
						  and e.ECid    = d.ECid
						  and se.DEid = CargasCalculo.DEid
						  and se.RCNid = CargasCalculo.RCNid

						<!--- Agrege un group by que me pide con el sum --->
                                                       group by e.ECauto )
			where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and CCSalarioBase > 0.00

			  <!--- *** debe excluir las cargas que estan en periodo especial, pues los calculos son incorrectos para este tipo de cargas  --->
			  and not exists( 	select  1

								from RHCargasPeriodoEspecial a, CargasCalculo b, RCalculoNomina c

								where b.DClinea = a.DClinea
								  and c.RCNid = b.RCNid
								  and b.DEid = CargasCalculo.DEid
								  and b.RCNid = CargasCalculo.RCNid
								  and b.DClinea = CargasCalculo.DClinea
								  and exists( select 1
											  from LineaTiempo lt
											  where lt.RHTid = a.RHTid
											    and lt.DEid = b.DEid
												 and c.RCdesde between lt.LTdesde and lt.LThasta   )
					  		)
				<!--- fin *** --->

		</cfquery>
		<!---fin del cambio propuesto por roxana para que funcione en SQL server--->

		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo
			set CCSalarioBaseEmpleado = CCSalarioBase
			where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>


		<!---
			loop por prioridad de cargas.
			Calcular los montos de las cargas de acuerdo con la prioridad de procesamiento
			1. Se obtienen las diferentes prioridades de cargas.  Prioridad nula se asume prioridad cero y se procesa en el primer grupo
			2. Se calculan los montos de salarios base para cada una de las prioridades
			3. Cuando la prioridad no es la primera, se rebaja lo calculado en otras cargas al salario base de calculo
			4. Se calcula el monto de la carga con base en el salario calculado y el porcentaje asignado a la carga
		--->

		<cfquery name="rsPrioridades" datasource="#Arguments.datasource#">
			select distinct coalesce(e.ECprioridad, 0) as Prioridad
			from CargasCalculo a
				inner join DCargas d
					inner join ECargas e
						on e.ECid = d.ECid
				on d.DClinea = a.DClinea
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and CCSalarioBase > 0.00
			order by 1
		</cfquery>

		<cfloop query="rsPrioridades">
			<cfif rsPrioridades.Prioridad GT 0>
				<cfquery datasource="#Arguments.datasource#">
					update CargasCalculo
						set CCSalarioBaseEmpleado = (CCSalarioBaseEmpleado
							-
							coalesce(( 	select sum(round(rhpe.PEXmonto, 2))
										from DCargas dc, ECargas ec,
											RHCargasRebajar re, DCargas dc2,
											RHPagosExternosTipo pet, RHPagosExternosCalculo rhpe
										where dc.DClinea = CargasCalculo.DClinea
										and ec.ECid = dc.ECid
										and ec.ECprioridad = #rsPrioridades.Prioridad#
										and re.ECid = ec.ECid
										and dc2.ECid = re.ECidreb
										and pet.DClinea = dc2.DClinea
										and rhpe.DEid = CargasCalculo.DEid
										and rhpe.RCNid = CargasCalculo.RCNid
										and rhpe.PEXTid = pet.PEXTid
									 ), 0.00) )
					where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
					  and CargasCalculo.CCSalarioBaseEmpleado > 0.00
				</cfquery>

				<!--- Actualizar el SalarioBase de las cargas a calcular  ---->
				<cfquery datasource="#Arguments.datasource#">
						update CargasCalculo
						set CCSalarioBase = CCSalarioBase
								- coalesce((
												select sum(round(cc2.CCvalorpat * coalesce(re.RHCRporc_pat, 100) / 100, 2))
												from DCargas dc, ECargas ec, RHCargasRebajar re,
													DCargas dc2, CargasCalculo cc2
												where dc.DClinea = CargasCalculo.DClinea
												and ec.ECid = dc.ECid
												and ec.ECprioridad = #rsPrioridades.Prioridad#
												and re.ECid = ec.ECid
												and dc2.ECid = re.ECidreb
												and cc2.DEid = CargasCalculo.DEid
												and cc2.RCNid = CargasCalculo.RCNid
												and cc2.DClinea = dc2.DClinea
											), 0.00),
							CCSalarioBaseEmpleado = CCSalarioBaseEmpleado
								- coalesce((
												select sum(round(cc2.CCvaloremp * coalesce(re.RHCRporc_emp, 100) / 100, 2))
												from DCargas dc, ECargas ec, RHCargasRebajar re,
														DCargas dc2,CargasCalculo cc2
												where dc.DClinea = CargasCalculo.DClinea
												and ec.ECid = dc.ECid
												and ec.ECprioridad = #rsPrioridades.Prioridad#
												and re.ECid = ec.ECid
												and dc2.ECid = re.ECidreb
												and cc2.DEid = CargasCalculo.DEid
												and cc2.RCNid = CargasCalculo.RCNid
												and cc2.DClinea = dc2.DClinea
											), 0.00)

						where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
						  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
						  and CargasCalculo.CCSalarioBase > 0.00
				</cfquery>
			</cfif>
			<!--- SE MODIFICA EL CALCULO DE LAS CARGAS, RESTANDO LOS CONCEPTOS DE PAGO QUE FUERON INCLUIDOS
				Y ESTAN DENTRO DE LAS EXCEPCIONES PARA EL CALCULO DE LAS CARGAS --->

			<cfquery name="rsPagos" datasource="#session.dsn#">
				select
					DEid,
					min(LTdesde) LTdesde,
					max(LThasta) LThasta,
					RVid,
					sum(Cantdias) sumDias,
					Salario,
					RHTcomportam
				from
				(
					SELECT 
						a.DEid,
						a.LTdesde,
						a.LThasta,
						a.RVid,
						CASE	
							WHEN a.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> AND a.LThasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
								THEN DATEDIFF(DD,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)+1	
							WHEN a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> AND a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
								THEN DATEDIFF(DD, LTdesde, a.LThasta)+1	
							WHEN a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> AND a.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
								THEN DATEDIFF(DD, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">, a.LThasta)+1
							WHEN a.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> AND a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
								THEN DATEDIFF(DD, a.LTdesde, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)+1
						END AS Cantdias,
						CASE
							WHEN b.RHTpaga = 1 
								THEN (ROUND(a.LTsalario - (SELECT COALESCE(SUM(DLTmonto), 0)
																FROM DLineaTiempo
																WHERE LTid = a.LTid
																AND CIid IN
																	(SELECT d.CIid
																	FROM ComponentesSalariales d
																	INNER JOIN CIncidentes e ON d.CIid = e.CIid
																	WHERE d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																	AND d.CIid IS NOT NULL))
										, 2) * COALESCE(a.LTporcsal, 100) / 100)
							ELSE 0.00
						END AS Salario,
						b.RHTcomportam
					FROM LineaTiempo a,
						RHTipoAccion b,
						RHJornadas c
					WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						AND a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
						AND a.Ecodigo = b.Ecodigo
						AND b.RHTcomportam NOT IN (13,5)
						AND a.RHTid = b.RHTid
						AND a.RHJid = c.RHJid
						AND ((a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
							AND a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)
							OR (a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
								AND a.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">))
				)obj
				group by DEid,
					RVid,
					Salario,
					RHTcomportam
				order by DEid
			</cfquery>

			<!--- separar los proceso e iterar las afectaciones salariales registradas en pagos
			despues sumar el resultado de cada carga Patronal y Empleado para que cuadren --->
			<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
						ecodigo="#session.Ecodigo#" pvalor="80" default="0" returnvariable="vMensual"/>

			<cfquery name="rsNominaCC" datasource="#session.dsn#">
				select
					tc.CalculaCargas
				from TiposNomina tc
				inner join RCalculoNomina rc
					on tc.Tcodigo = rc.Tcodigo
					and rc.Ecodigo = tc.Ecodigo
				where rc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>

			<cfloop query="rsPagos">

				<!--- Obtenemos la ultima fecha de nombramiento para calcular antiguedad--->
				<cfquery name="rsFechaAlta" datasource="#session.dsn#">
					select top 1 dle.DLfvigencia,Tcodigo from DLaboralesEmpleado dle inner join RHTipoAccion ta
					on ta.RHTid = dle.RHTid and RHTcomportam = 1
					and dle.DEid = #DEid#
					order by dle.DLfvigencia desc
				</cfquery>

				<!---SML. Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta--->
				<cfset anno = DateDiff('yyyy', rsFechaAlta.DLfvigencia, now())>

				<!--- Inicia proceso de calculo de SDI por sueldo para cada pago --->
				<cfquery datasource="#session.dsn#" name="rsDias">
					select coalesce(dv.DRVdiasgratifica,0) as DRVdiasgratifica, coalesce(dv.DRVdiasprima,0) as DRVdiasprima, dv.DRVdias
					from RegimenVacaciones r
						inner join 	DRegimenVacaciones dv
							on r.RVid = dv.RVid
							and dv.DRVcant = <!---SML. Inicio Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta--->
							(select coalesce(max(DRVcant),1)
		                                      from DRegimenVacaciones rv2
		                                      where rv2.RVid = dv.RVid
		                                      	and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_integer" value="#anno+1#"> )
		                                    <!---SML. Fin Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta---> <!---(select min(DRVcant) from DRegimenVacaciones a where a.RVid =  dv.RVid)--->
					where r.Ecodigo = #session.Ecodigo#
						and r.RVid = #RVid#
				</cfquery>
				<cfif not len(trim(rsDias.DRVdiasgratifica)) or not len(trim(rsDias.DRVdiasprima))>
		        	<cfthrow message="No existe los detalles de regimen definidos">
		        </cfif>

				<cfset SDItmp = 0>
				<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
					ecodigo="#Arguments.Ecodigo#" pvalor="2052" default="0" returnvariable="varDiasAguinaldo"/>


				<cfset DRVdiasgratifica = rsDias.DRVdiasgratifica>
				<cfset DRVdiasprima 	= rsDias.DRVdiasprima>
				<cfset Salario		 	= #Salario#>

				<!---SML. Inicio Modificacion para que realice correctamente el calculo de SDI--->
				<cfset pVacacional		= rsDias.DRVdias * (rsDias.DRVdiasprima/100)>
		        <cfset factorDias = ((365 + #varDiasAguinaldo# + #pVacacional#)/365)><!--- Factor de Integracion --->
		        <cfset salarioDiario = (#Salario# / #vMensual#)>
				<cfset unSDI = (#salarioDiario# * #factorDias#)>


				<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
				ecodigo="#session.Ecodigo#" pvalor="2051" default="0" returnvariable="varUMA"/>

				<cfset topeUMA = varUMA * 25>

				<cfif unSDI GT  topeUMA>
					<cfset SDItmp = topeUMA>
				<cfelse>
					<cfset SDItmp = unSDI>
				</cfif>

				<cfquery name="rsSDIH" datasource="#session.dsn#">
					select
						RHHmonto
					from RHHistoricoSDI
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					order by RHHperiodo desc,RHHmes desc
				</cfquery>

				<cfif rsSDIH.RecordCount gt 0 and rsSDIH.RHHmonto gt 0>
					<cfset SDItmp = rsSDIH.RHHmonto>
				</cfif>

				<cfset dbc = DateDiff("d",(DateCompare(LTdesde,Arguments.RCdesde,'d') eq -1 ? Arguments.RCdesde : LTdesde),
					(((DateCompare(LThasta,'6100-01-01 00:00:00.000','d') eq 0) or (DateCompare(LThasta,Arguments.RChasta,'d') eq 1)) ? Arguments.RChasta : LThasta))>
				<cfset dbc += 1>
				
				<cfset diasIncap = 0>
				<cfquery name="rsPagoEmpleado" datasource="#session.dsn#">
					SELECT 
						coalesce(sum(PEcantdias),0) PEcantdias 
					FROM 
						PagosEmpleado pe
					inner join RHTipoAccion ta
						on ta.RHTid = pe.RHTid
						and ta.RHTcomportam = 5 <!--- INCAPACIDADES --->
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				</cfquery>
				<cfif rsPagoEmpleado.RecordCount gt 0>
					<cfset diasIncap = rsPagoEmpleado.PEcantdias>
					<!---
						<cfset dbc += rsPagoEmpleado.PEcantdias>
					--->
				</cfif>
				
				<cfset totDiasFalta = 0>
				<cfquery name="rsAusentismosEmpleado" datasource="#session.dsn#">
					SELECT 
						case
							when Coalesce(ta.RHTIncluirFactorNomina,0) = 1
								then (coalesce(ta.RHTfactorfalta,1) * coalesce(sum(PEcantdias),0))  
							else coalesce(sum(PEcantdias),0)
						end AS PEcantdias 
					FROM 
						PagosEmpleado pe
					inner join RHTipoAccion ta
						on ta.RHTid = pe.RHTid
						and ta.RHTcomportam = 13 <!--- AUSENTISMOS --->
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					group by ta.RHTIncluirFactorNomina,ta.RHTfactorfalta
				</cfquery>
				<cfif rsAusentismosEmpleado.RecordCount gt 0>
					<cfset totDiasFalta = rsAusentismosEmpleado.PEcantdias>
				</cfif>

				<cfif rsNominaCC.CalculaCargas eq 1>
					<!--- OPARRALES 2019-01-08 Modificacion para reasignar los Dias Base de Cotizacion por Parametro 14600704 --->
					<cfquery name="rsCargasSemXMes" datasource="#session.dsn#">
						select
							Pvalor
						from
							RHParametros
						where
							Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="14600704">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>

					<!--- OPARRALES 2018-01-13
						- Se agrega validacion para buscar empleados dados de alta despues de la fecha inicio del calendario de pago
						- Si existen empleados se saca los dias trabajados de fecha de alta vs Fecha fin de pago
					 --->
					<cfquery name="rsLTAlta" datasource="#session.dsn#">
						select top 1 lt.LTdesde,Tcodigo from LineaTiempo lt
						inner join RHTipoAccion ta
							on ta.RHTid = lt.RHTid
							and ta.Ecodigo = lt.Ecodigo
						where
							lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and ta.RHTcomportam = 1 <!--- Accion de Tipo Nombramiento --->
						and lt.LTdesde
							between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#">
						AND lt.BMUsucodigo is not null
						order by lt.LTdesde desc
					</cfquery>

					<cfset varDiasTemp = 7>
					<cfif rsLTAlta.RecordCount gt 0>
						<cfset dbc = (DateDiff("d",rsLTAlta.LTdesde,Arguments.RChasta) + 1)>
						<cfset varDiasTemp = dbc>
					</cfif>
					
					<cfif rsCargasSemXMes.RecordCount gt 0 and rsCargasSemXMes.Pvalor eq 1 and varDiasTemp lte 7>
						<cfquery name="rsCP" datasource="#session.dsn#">
							select Tcodigo, CPmes ,CPperiodo
							from CalendarioPagos
							where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
		
						<cfquery name="rsPeriodos" datasource="#session.dsn#">
							select Count(CPid) as NumPeriodos
							from CalendarioPagos
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
							and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCP.CPmes#">
							and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCP.Tcodigo#">
							and CPperiodo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCP.CPperiodo#">
							and CPtipo = 0
						</cfquery>
						
						<!--- Obtenemos semanas por Mes --->
						<cfset diasMes = DaysInMonth(Arguments.RChasta)>
						<cfset varDBC = (diasMes / rsPeriodos.NumPeriodos) - (7 - varDiasTemp)>
						<cfset dbc = varDBC>
						
					<cfelse>
						<cfset varDiasP = 0>
						<cfif rsLTAlta.RecordCount gt 0>
							<cfset varDiasP = (DateDiff("d",Arguments.RCdesde,Arguments.RChasta) + 1) - (DateDiff("d",rsLTAlta.LTdesde,Arguments.RChasta) + 1)>
						</cfif>
						<cfset dbc = CalendarioPagos.FACTORDIASIMSS - varDiasP>
					</cfif>

					<!--- OPARRALES Modificacion para empleados cesados dentro del periodo de calculo --->
					<cfquery name="rsDiasLab" datasource="#session.dsn#">
						select top 1
							ta.RHTcomportam,
							ta.RHTdesc,
							DATEDIFf(DAY,dle.DLfvigencia,'#LSDateFormat(Arguments.RChasta,"YYYY-MM-dd")#') diasSinTrabajar
						from DLaboralesEmpleado dle
						inner join RHTipoAccion ta
							on ta.RHTid = dle.RHTid
							and ta.RHTcomportam = 2 <!--- Bajas/Finiquitos --->
							and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						Where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagos.DEid#">
						AND dle.DLfvigencia between '#LSDateFormat(Arguments.RCdesde,"YYYY-MM-dd")#' and '#LSDateFormat(Arguments.RChasta,"YYYY-MM-dd")#'
						order by DLfvigencia desc
					</cfquery>

					<cfif rsDiasLab.RecordCount gt 0 and rsDiasLab.diasSinTrabajar gt 0>
						<cfset dbc -= rsDiasLab.diasSinTrabajar>
					</cfif>

					<cfquery name="rsTipoPago" datasource="#session.dsn#">
						select 
							Ttipopago
						from 
							TiposNomina 
						where 
							Tcodigo = '#Trim(rsFechaAlta.Tcodigo)#'
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>
					
					<cfif rsTipoPago.Ttipopago eq 2 and dbc lt CalendarioPagos.FACTORDIASIMSS><!--- quincenal --->
						<cfset dbc += 0>
					</cfif>

					<!--- Buscamos las Incidencias de Faltas con el codigo 04 --->
					<cfquery name="rsFaltas" datasource="#session.dsn#">
						select
							CIid
						from
							CIncidentes
						where CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="04">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>

					<cfset varDiasFalta = 0>
					<cfif rsFaltas.RecordCount gt 0>
						<cfset varIdsC = Valuelist(rsFaltas.CIId,",") >

						<cfquery name="rsHrsD" datasource="#session.dsn#">
							select
								RHJhoradiaria
							from
								RHJornadas
							where RHJId =
										(
											select top 1 RHJid from LineaTiempo
											where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
											order by LThasta desc
										)
						</cfquery>

						<cfset varHrsDia = rsHrsD.RHJhoradiaria>

						<cfquery name="rsIncCalc" datasource="#session.dsn#">
							select
								ICvalor
							from
								IncidenciasCalculo
							where
								RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							and CIId in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIdsC#" list="true">)
						</cfquery>
						
						<cfset tmpDias = 0>

						<cfloop query="rsIncCalc">
							<cfset tmpDias += (ICvalor / varHrsDia)>
						</cfloop>
						<cfset dbc -= tmpDias>
					</cfif>
			
					<cfquery datasource="#Arguments.datasource#">
						<!--- ljimenez es aca donde se hace el calculo de las cargas utilizando alguno de los 2 metodos 0 = monto, 1 = %.
								si la opcion diminuye en x VSMG  la restamos al SBC para hacer el calculo de la carga
								y verificamos cuando hacemos el calculo de las cargas utilizando el SBC como base del calculo
								o lo hacemos con el Salario calculado(normal) --->
					 	update CargasCalculo
						set	CCvaloremp +=
						coalesce((select
								case
								when DCmetodo = 0
									then coalesce(b.CEvaloremp, c.DCvaloremp)

								when DCmetodo = 1 and coalesce(ECSalarioBaseC,0) = 0 and coalesce(DCdisminuyeSBC,0) = 0
									then round((CargasCalculo.CCSalarioBaseEmpleado) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)

								<!---ljimenez Calculo de las cargas para mexico usando el SBC--->
								<!--- Cambios OPARRALES Inicio 16/05/2017--->
								<!--- Excedentes --->
								when DCmetodo = 1
										and coalesce(ECSalarioBaseC,0) = 1
										and coalesce(DCdisminuyeSBC,0) = 0
										and coalesce(DCusaSMGA,0) = 0
									then
										case
											when coalesce(DCUsaUMA,0) = 1 and coalesce(DCEsExcedente,0) = 1 AND Coalesce(DCConsideraFaltas,0) = 1
											then
												case when #SDItmp# > (#vUMA# * 3)
													then
													<!--- EXCEDENTES --->
														round(((#SDItmp# - (#vUMA# * 3))*(#dbc# - #diasIncap# - #totDiasFalta# )) * (coalesce(b.CEvaloremp, c.DCvaloremp)/100),2)
													<!--- round(((CargasCalculo.CCSalarioBaseCotizacion) * CargasCalculo.CCdbc) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2) --->
													else
														0
												end
											when coalesce(DCUsaUMA,0) = 1 and coalesce(DCEsExcedente,0) = 1
											then
												case when #SDItmp# > (#vUMA# * 3)
													then
													<!--- EXCEDENTES --->
														round(((#SDItmp# - (#vUMA# * 3))*(#dbc# - #diasIncap# )) * (coalesce(b.CEvaloremp, c.DCvaloremp)/100),2)
													<!--- round(((CargasCalculo.CCSalarioBaseCotizacion) * CargasCalculo.CCdbc) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2) --->
													else
														0
												end
											else
												<!--- 2019-01-08 OPARRALES
													  Aqui entra:
														- 04 invalidez y vida solo para empleado
														- 06 Riesgo de Trabajo
														- 08 Cesantia y vejez solo empleado
														- 09 Retiro
														- 10 Infonavit
												 --->
												<!--- Aqui realiza los demas calculos. --->
												case
													when DCdbc = 1
														then
															round(((#SDItmp#) * (#dbc# - #totDiasFalta# - #diasIncap#)) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)
													when DCdbc = 2
														then
															round(((#SDItmp#) * (#dbc# - #diasIncap#)) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)
													else <!--- DCdbc = 3 --->
														round(((#SDItmp#) * (#dbc# - #totDiasFalta#)) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)
												end
										end
								<!--- Cambios OPARRALES Fin --->
										<!--- PRESTAMOS EN DINERO --->
								when DCmetodo = 1
										and coalesce(ECSalarioBaseC,0) = 1
										and coalesce(DCdisminuyeSBC,0) = 0
										and coalesce(DCusaSMGA,0) = 1
									then round(((#vSMGA#) * #dbc#) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)

								when DCmetodo = 1
										and coalesce(ECSalarioBaseC,0) = 1
										and coalesce(DCdisminuyeSBC,0) = 1
										and coalesce(DCusaSMGA,0) = 1

									then
										case when (round(((#SDItmp# - (#vSMGA# * 3)) * #dbc#) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2) < 0)
												then 0
													else round(((#SDItmp# - (#vSMGA# * 3)) * #dbc#) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)
												end
							when DCmetodo = 2
										and coalesce(ECSalarioBaseC,0) = 1
										and coalesce(DCdisminuyeSBC,0) = 0
										and coalesce(DCusaSMGA,0) = 1
										<!--- oparrales se cambio vSMGA por UMA 16/05/2017 --->
									then round(((#vUMA#) * (#dbc# - #diasIncap# - case when Coalesce(DCConsideraFaltas,0) = 1 then #totDiasFalta# else 0 end)) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2)
								end
						from CargasEmpleado b, DCargas c, ECargas d
						where b.DEid = #DEid#
						and CargasCalculo.DEid = #DEid#
						  and b.DClinea = CargasCalculo.DClinea
						  and b.CEdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
						  and coalesce(b.CEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#">) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
						  and c.DClinea = CargasCalculo.DClinea
						  and d.ECid = c.ECid
						), 0)
						where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
						  <cfif IsDefined('Arguments.pDEid')> and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
						  <cfif rsPrioridades.Prioridad GT 0>
								  and exists(
								  	select 1
								  	from DCargas a
								  		inner join ECargas b
								  			 on b.ECid = a.ECid
								  			and b.ECprioridad = #rsPrioridades.Prioridad#
								  	where a.DClinea = CargasCalculo.DClinea
								  	)
						  </cfif>
						  and exists(
						  select 1
						  from CargasEmpleado b, DCargas c, ECargas d
							where
							b.DEid = #DEid#
							and CargasCalculo.DEid = #DEid#
						  and b.DClinea = CargasCalculo.DClinea
						  and b.CEdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
						  and coalesce(b.CEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#">) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
						  and c.DClinea = CargasCalculo.DClinea
						  and d.ECid = c.ECid)
						  and CargasCalculo.CCSalarioBase > 0.00
					</cfquery>
				</cfif>
			</cfloop>

			<!---ERBG Cambio de Cargas Patronales por Oficina Inicia--->
			<cfif rsNominaCC.CalculaCargas eq 1>
				<cfinvoke component="RH_CalculoCargaPatronOficina" method="CargaPatronOficina">
					<cfinvokeargument name="conexion" 	value="#Arguments.datasource#">
					<cfinvokeargument name="Ecodigo" 	value="#Arguments.Ecodigo#">
					<cfinvokeargument name="RCNid" 		value="#Arguments.RCNid#">
					<cfinvokeargument name="RCdesde" 	value="#Arguments.RCdesde#">
					<cfinvokeargument name="RChasta"	value="#Arguments.RChasta#">
					<cfinvokeargument name="vSMGA" 		value="#vSMGA#">
					<cfinvokeargument name="vUMA" 		value="#vUMA#"><!--- oparrales se agrego argumento UMA --->
					<cfinvokeargument name="Prioridad" 	value="#rsPrioridades.Prioridad#">
					<cfif IsDefined('Arguments.pDEid')>
							<cfinvokeargument name="pDEid" value="#Arguments.pDEid#">
					</cfif>
					<cfinvokeargument name="rsPagos" value="#rsPagos#">
					<cfinvokeargument name="FactorDiasIMSS" value="#Trim(LSNumberFormat(CalendarioPagos.FACTORDIASIMSS,'9.0000'))#">
				</cfinvoke>
			</cfif>
			<!---ERBG Cambio de Cargas Patronales por Oficina Fin--->
		</cfloop>
	</cfif>

	<!--- ================================================================================================= --->
	<!--- aqui empiezan calculos de rangos--->
	 <!--- Cuando La carga tiene rangos maximos definidos, se debe recalcular cuando se excede el monto de la carga --->
	 <cfquery datasource="#Arguments.datasource#" name="rsCargas">
		select 	cc.DClinea,
				cc.DEid,
				dc.DCmetodo,
				dc.DCvaloremp as valor_emp,
				dc.DCvalorpat as valor_pat,
				dc.DCtiporango as rango,
				dc.DCrangomin as tope_minimo,
				dc.DCrangomax as tope_maximo,
				dc.DCaplica as aplica,
				(select ECauto from ECargas where ECid = dc.ECid) as cargadeley

		from CargasCalculo cc
			inner join SalarioEmpleado se
				 on se.RCNid        = cc.RCNid
				and se.DEid         = cc.DEid
				and se.SEcalculado  < 1
			inner join DCargas dc
				on dc.DClinea       = cc.DClinea
		where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		 <cfif IsDefined('Arguments.pDEid')> and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		  and dc.DCmetodo = 1		<!--- solo porcentaje --->
		  and dc.DCtiporango > 0	<!--- rango por montos --->
	</cfquery>

	<cfloop query="rsCargas">
		<!--- tope minimo  --->
		<cfset vTopeMin = rsCargas.tope_minimo >
		<!--- tope maximo  --->
		<cfset vTopeMax = rsCargas.tope_maximo >

		<!--- calcular salario del empleado para la nomina en proceso --->
		<cfset vSalarioProceso = 0 >
		<cfquery name="rs_salariobruto" datasource="#Arguments.datasource#"	>
			select sum(SEsalariobruto) as bruto
			from SalarioEmpleado a
			where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscargas.DEid#">
			  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
		<cfset vBruto = 0 >
		<cfif len(trim(rs_salariobruto.bruto))>
			<cfset vBruto = rs_salariobruto.bruto >
		</cfif>

		<!--- calcular incidencias que afectan cargas en nominas historicas --->
		<cfquery name="rs_incidencias" datasource="#arguments.datasource#" >
			select sum(a.ICmontores) as incidencias
			from IncidenciasCalculo a, RCalculoNomina b, CIncidentes ci
			where b.RCNid=a.RCNid
			and ci.CIid=a.CIid
		    and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscargas.DEid#">
			<cfif rsCargas.cargadeley eq 1 >
				and ci.CInocargasley = 0
			<cfelse>
				and ci.CInocargas = 0
			</cfif>

			<!--- quita las incidencias definidas en excepciones --->
			and a.CIid not in ( select CIid
								from DCTDeduccionExcluir
								where DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCargas.DClinea#" > )
		</cfquery>
		<cfset vIncidencias = 0 >
		<cfif len(trim(rs_incidencias.incidencias))>
			<cfset vIncidencias = rs_incidencias.incidencias >
		</cfif>

		<!--- salario de nomina en proceso --->
		<cfset vSalarioProceso = vBruto + vIncidencias >

		<!--- calcular salario bruto del empleado para nominas historicas, solo si el rango es mensual --->
		<cfset vSalarioHistoria = 0 >
		<cfif rsCargas.rango eq 2 >
			<cfquery name="rs_nomina" datasource="#arguments.datasource#">
				select CPperiodo, CPmes
				from CalendarioPagos
				where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			</cfquery>

			<cfquery name="rs_salariobruto" datasource="#Arguments.datasource#"	>
				select sum(SEsalariobruto) as bruto
				from HSalarioEmpleado a, CalendarioPagos cp
				where a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscargas.DEid#">
				and cp.CPid=a.RCNid
				and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPmes#">
				and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPperiodo#">
				and cp.CPtipo = 0
			</cfquery>
			<cfset vBruto = 0 >
			<cfif len(trim(rs_salariobruto.bruto))>
				<cfset vBruto = rs_salariobruto.bruto >
			</cfif>

			<!--- calcular incidencias que afectan cargas en nominas historicas --->
			<cfquery name="rs_incidencias" datasource="#arguments.datasource#" >
				select sum(a.ICmontores) as incidencias
				from HIncidenciasCalculo a, HRCalculoNomina b, CalendarioPagos cp, CIncidentes ci
				where b.RCNid=a.RCNid
				and cp.CPid=b.RCNid
				and ci.CIid=a.CIid
				and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPmes#">
				and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_nomina.CPperiodo#">
				and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rscargas.DEid#">
				and cp.CPtipo=0
				<cfif rsCargas.cargadeley eq 1 >
					and ci.CInocargasley = 0
				<cfelse>
					and ci.CInocargas = 0
				</cfif>
			<!--- falta poner que el concepto incidente no este en la tabl ad eexcepciones de carga--->
			</cfquery>
			<cfset vIncidencias = 0 >
			<cfif len(trim(rs_incidencias.incidencias))>
				<cfset vIncidencias = rs_incidencias.incidencias >
			</cfif>

			<!--- salario acumulado en la historia para el periodo y mes de nomina en proceso --->
			<cfset vSalarioHistoria = vBruto + vIncidencias >
		</cfif>

		<!--- *********************************** --->
		<!--- valida que el salario de nomina en proceso mas lo acumulado en la historia, sea mayor igual al tope minimo --->
		<cfif (vSalarioHistoria + vSalarioProceso) gte vTopeMin >
			<!--- logica del proceso --->
			<cfset vMontoCargaPatrono = 0 >
			<cfset vMontoCargaEmpleado = 0 >
			<!--- ya el salario recibido sobrepaso el tope maximo, osea ya pago el total del porcentaje relacionado a la carga --->
			<cfif vSalarioHistoria gte vTopeMax  >
				<cfset vMontoCarga = 0 >
			<!--- si el salario recibido no ha sobrepasado el tope --->
			<cfelse>
				<!--- se calcula el monto pendiente par aajustar al tope, si ya existen pagos historicos para el mismo periodo y mes --->
				<cfset vPendiente = vTopeMax - vSalarioHistoria >
				<!--- si el monto pendiente es mayor al salario en proceso, se hacen los calculos sobre el salario en proceso completo --->
				<cfif vpendiente gt vSalarioProceso >
					<cfset vMontoCargaPatrono = (vSalarioProceso*rsCargas.valor_pat)/100 >
					<cfset vMontoCargaEmpleado = (vSalarioProceso*rsCargas.valor_emp)/100  >
				<!--- si lo pendiente es menor al salario se hacen los calculos sobre el monto pendiente --->
				<cfelse>
					<cfset vMontoCargaPatrono = (vpendiente*rsCargas.valor_pat)/100 >
					<cfset vMontoCargaEmpleado = (vpendiente*rsCargas.valor_emp)/100  >
				</cfif>
			</cfif>
		<cfelse>
			<cfset vMontoCargaPatrono = 0 >
			<cfset vMontoCargaEmpleado = 0 >
		</cfif>

		<!---- modifica la carga con el nuevo monto --->
		<cfquery datasource="#Arguments.datasource#">
			update CargasCalculo
			set CCvaloremp = <cfif listfind('2,3', rsCargas.aplica) and len(trim(vMontoCargaEmpleado)) ><cfqueryparam cfsqltype="cf_sql_money" value="#vMontoCargaEmpleado#"><cfelse>CCvaloremp</cfif>,
				CCvalorpat = <cfif listfind('1,3', rsCargas.aplica) and len(trim(vMontoCargaPatrono)) ><cfqueryparam cfsqltype="cf_sql_money" value="#vMontoCargaPatrono#"><cfelse>CCvalorpat</cfif>
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rscargas.DEid#">
			  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rscargas.DClinea#">
			  and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>
	</cfloop>
	<!--- FIN CARGAS --->


	<!---LLAMADO A LA FUNCION DE EXTENCION PARA LA FUNCION DE CalculoNomina (CONTINUACION DE LA FUNCION CALCULONOMINA) CARGAS Y DEDUCCIONES--->
	 <cfinvoke component="RH_CalculoNomina" method="CalculoNominaExtencion">
		<cfinvokeargument name="datasource" value="#Arguments.datasource#">
		<cfinvokeargument name="Ecodigo" 		value = "#Arguments.Ecodigo#">
		<cfinvokeargument name="RCNid" 			value = "#Arguments.RCNid#">
		<cfinvokeargument name="Tcodigo" 		value = "#Arguments.Tcodigo#">
		<cfinvokeargument name="RCdesde" 		value = "#Arguments.RCdesde#">
		<cfinvokeargument name="RChasta" 		value = "#Arguments.RChasta#">
		<cfinvokeargument name="IRcodigo" 		value = "#Arguments.IRcodigo#">
		<cfinvokeargument name="Usucodigo" 		value = "#Arguments.Usucodigo#">
		<cfinvokeargument name="Ulocalizacion" 	value  = "#Arguments.Ulocalizacion#">
		<cfinvokeargument name="debug" 			value = "#Arguments.debug#">
		<cfif IsDefined('Arguments.pDEid')>
			<cfinvokeargument name="pDEid" value = "#Arguments.pDEid#">
		</cfif>
		<cfinvokeargument name="CalendarioPagos" 			value = "#CalendarioPagos#">
		<cfinvokeargument name="cantdias" 					value = "#cantdias#">
		<cfinvokeargument name="cantdiasMensual" 			value = "#cantdiasMensual#">
		<cfinvokeargument name="CantPagosRealizados" 		value = "#CantPagosRealizados#">
		<cfinvokeargument name="Factor" 					value = "#Factor#">
		<cfinvokeargument name="Factored" 					value = "#Factored#">
		<cfinvokeargument name="Tipored" 					value = "#Tipored#">
		<cfinvokeargument name="idincidenciared" 			value = "#idincidenciared#">
		<cfinvokeargument name="minimo" 					value = "#minimo#">
        <cfinvokeargument name="ValidarCalendarios" 		value = "#Arguments.ValidarCalendarios#">
	</cfinvoke>

	<!---===============================================================================================================--->

<!--- end --->
</cffunction>



<!---FUNCION DE EXTENCION PARA LA FUNCION DE CalculoNomina (CONTINUACION DE LA FUNCION CALCULONOMINA) CARGAS Y DEDUCCIONES--->
<cffunction name="CalculoNominaExtencion" returntype="any">
	<cfargument name="datasource" 			type="string" 	required="yes">
	<cfargument name="Ecodigo" 				type="numeric" 	required="yes">
	<cfargument name="RCNid" 				type="numeric" 	required="yes">
	<cfargument name="Tcodigo" 				type="string" 	required="no"	default="">
	<cfargument name="RCdesde" 				type="date" 	required="no">
	<cfargument name="RChasta" 				type="date" 	required="no">
	<cfargument name="IRcodigo" 			type="string" 	required="no">
	<cfargument name="Usucodigo" 			type="numeric" 	required="yes">
	<cfargument name="Ulocalizacion" 		type="string" 	required="no"	default="00">
	<cfargument name="debug" 				type="boolean" 	required="no"	default="no">
	<cfargument name="pDEid" 				type="numeric" 	required="no">
	<cfargument name="CalendarioPagos" 		type="query" 	required="yes">
	<cfargument name="cantdias" 			type="numeric" 	required="yes">
	<cfargument name="cantdiasMensual" 		type="numeric" 	required="yes">
	<cfargument name="CantPagosRealizados" 	type="query" 	required="yes">
	<cfargument name="Factor" 				type="string" 	required="yes">
	<cfargument name="Factored" 			type="string" 	required="yes">
	<cfargument name="tipored" 				type="string" 	required="yes">
	<cfargument name="idincidenciared" 		type="string" 	required="yes">
    <cfargument name="ValidarCalendarios" 	type="boolean" 	required="no" default="true" hint="True. Cuenta Calendario X mes. False. Estima Calendarios X mes">



	<!--- UPDATE PARA ELIMINAR EL CALCULO DE LAS CARGAS NO DE LEY CUANDO EL CALENDARIO INDICA "NO CALCULA CARGAS" --->
	<cfif CalendarioPagos.CPnocargas EQ 1>
		<cfquery name="rsUpdate" datasource="#session.DSN#">
			update CargasCalculo
			set
				CCvaloremp = 0,
				CCvalorpat = 0
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and  exists(select 1
			  			  from DCargas dc
						  inner join ECargas ec
						  	on ec.Ecodigo = dc.Ecodigo
							and ec.ECid = dc.ECid
							and ec.ECauto = 0
						  where dc.DClinea = CargasCalculo.DClinea)
		</cfquery>
	</cfif>
	<!--- UPDATE PARA ELIMINAR EL CALCULO DE LAS CARGAS DE LEY CUANDO EL CALENDARIO INDICA "NO CALCULA CARGAS LEY" --->
	<cfif CalendarioPagos.CPnocargasley EQ 1>
		<cfquery name="rsUpdate" datasource="#session.DSN#">
			update CargasCalculo
			set CCvaloremp = 0,
				CCvalorpat = 0
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and  exists(select 1
			  			  from DCargas dc
						  inner join ECargas ec
						  	on ec.Ecodigo = dc.Ecodigo
							and ec.ECid = dc.ECid
							and ec.ECauto = 1
						  where dc.DClinea = CargasCalculo.DClinea)
		</cfquery>
	</cfif>



	<cfif CalendarioPagos.CPnodeducciones EQ 0><!--- SI EL CALENDARIO INDICA APLICAR LAS DEDUCCIONES --->
		<!--- Deducciones --->
		<cfquery name="insertDeducciones" datasource="#Arguments.datasource#">
			insert into DeduccionesEmpleado (
				DEid, Ecodigo, SNcodigo, TDid, Ddescripcion,
				Dmetodo, Dvalor, Dfechadoc, Dfechaini, Dfechafin,
				Dmonto, Dtasa, Dsaldo, Dmontoint,
				Destado, Usucodigo, Ulocalizacion,
				Dcontrolsaldo, Dactivo, Dreferencia,
				BMUsucodigo, Dobservacion,
				IRcodigo, Mcodigo)
			select distinct
				ic.DEid, ir.Ecodigo, ir.SNcodigo, ir.TDid, ir.Descripcion,
				1,
				sum(round(coalesce(ic.ICmontores,0) * coalesce(ir.Porcentaje,0) / 100, 2)),
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">,
				sum(round(coalesce(ic.ICmontores,0) * coalesce(ir.Porcentaje,0) / 100, 2)),
				0.00, 0.00, 0.00,
				0, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, '00',
				0, 1, ci.CIcodigo,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 'Retención',
				null, null
			from IncidenciasCalculo ic
				inner join RHDeduccionesReb ir
						inner join CIncidentes ci
							on ci.CIid = ir.CIid
					on ir.CIid = ic.CIid
			where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')> and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and ic.ICmontores > 0.00
			  and not exists(
					select 1
					from DeduccionesEmpleado de
					where de.DEid = ic.DEid
					  and de.TDid = ir.TDid
					  and ltrim(rtrim(de.Dreferencia)) = ltrim(rtrim(ci.CIcodigo))
					)
			group by ic.DEid, ir.Ecodigo, ir.SNcodigo, ir.TDid, ir.Descripcion,ci.CIcodigo
		</cfquery>

		<!--- Borra todas las deduccionesCalculo que correspondan a Deducciones generadas por Incidencias --->
		<cfquery datasource="#Arguments.datasource#">
			delete from DeduccionesCalculo
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and CIid is not null
		</cfquery>

		<!--- 4-3-2010 LZ La condicion "select 1 from FDeduccion" solo aplica si la Deduccion como tal tiene Formula,
					con la condición antes descrita, con que otra deduccion tenga fórmula, las demás no se establecen --->

		<!--- 31-08-2017 OPARRALES Se agregaron nuevo filtro para las Deducciones de Tipo Credito Infonavit con un metodo de calculo en veces UMA --->
		<cfset mesIniTmp = month(arguments.RCdesde)>
		<cfset mesFinTmp = month(Arguments.RChasta)>

		<cfset mesCorreinte = mesIniTmp>
		<cfif mesIniTmp lt mesFinTmp>
			<cfset mesCorreinte = mesFinTmp><!--- El periodo corresponde al mes de la fecha fin --->
		</cfif>

		<cfset mesIniBim = 0>
		<cfset mesFinBim = 0>
		<cfswitch expression="#mesCorreinte#">
			<cfcase value="1,2">
				<cfset mesIniBim = 1>
				<cfset mesFinBim = 2>
			</cfcase>
			<cfcase value="3,4">
				<cfset mesIniBim = 3>
				<cfset mesFinBim = 4>
			</cfcase>
			<cfcase value="5,6">
				<cfset mesIniBim = 5>
				<cfset mesFinBim = 6>
			</cfcase>
			<cfcase value="7,8">
				<cfset mesIniBim = 7>
				<cfset mesFinBim = 8>
			</cfcase>
			<cfcase value="9,10">
				<cfset mesIniBim = 9>
				<cfset mesFinBim = 10>
			</cfcase>
		    <cfcase value="11,12">
			    <cfset mesIniBim = 11>
				<cfset mesFinBim = 12>
			</cfcase>
		</cfswitch>

		<cfset lvarFechaIniCP = LSDateFormat(Arguments.RCdesde,'YYYY-MM-dd')>

		<cfquery name="rsPeriodos" datasource="#session.dsn#">
			select
				DateDiff(ww,
					coalesce((select top 1 CPdesde from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesIniBim#">
						and year(CPdesde) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPdesde), '#lvarFechaIniCP#')
					,
					(select top 1 CPhasta from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesFinBim#">
						and year(CPhasta) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPhasta desc)
				) as periodos,
				COALESCE((select top 1 CPdesde from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesIniBim#">
						and year(CPdesde) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPdesde), '#lvarFechaIniCP#') iniPer,
				(select top 1 CPhasta from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesFinBim#">
						and year(CPhasta) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPhasta desc) finPer,	
				DateDiff(ww,
					(select top 1 CPdesde from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesCorreinte#">
						and year(CPdesde) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPdesde)
					,
					(select top 1 CPhasta from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesCorreinte#">
						and year(CPhasta) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPhasta desc)
				) as periodosM,
				(select top 1 CPdesde from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesCorreinte#">
						and year(CPdesde) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPdesde) iniPerM,
						(select top 1 CPhasta from CalendarioPagos
						where CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mesCorreinte#">
						and year(CPhasta) = Year(<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">)
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and Tcodigo = tn.Tcodigo order by CPhasta desc) finPerM,
				tn.Ttipopago
			from TiposNomina tn
			where tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Tcodigo#">
			and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		
		<!--- TIPO DE PAGO
			0 = Semanal
			1 = Bisemanal
			2 = Quincenal
			3 = Mensual
		 --->
		<cfset periodosF = #rsPeriodos.periodos#>
		<cfswitch expression="#rsPeriodos.Ttipopago#">
			<cfcase value="1,2">
				<cfset periodosF = round((#rsPeriodos.periodos# - 0.1)/2)>
			</cfcase>
			<cfcase value="3">
				<cfset periodosF = round((#rsPeriodos.periodos# - 0.1)/4)>
			</cfcase>
		</cfswitch>

		<!---cf_dump var="#rsPeriodos#"---->

		<cfset iniPer = LSDateFormat(rsPeriodos.iniPer,'YYYY-MM-dd')>
		<cfset finPer = LSDateFormat(rsPeriodos.finPer,'YYYY-MM-dd')>
		<cfset iniPerM = LSDateFormat(rsPeriodos.iniPerM,'YYYY-MM-dd')>
		<cfset finPerM = LSDateFormat(rsPeriodos.finPerM,'YYYY-MM-dd')>
		<cfset diasMCot = DateDiff("d", iniPerM, finPerM)+1>

		<cfset diasBimCot = DateDiff("d", iniPer, finPer)+1>
		<cfset fecIniBim = createDate(Year(Arguments.RCdesde), mesIniBim, 1)>
		<cfset fecFinBim = DateAdd('d',-1,DateAdd('m',1,createDate(Year(Arguments.RChasta), mesFinBim, 1)))>

		
		
		
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2051" default="0" returnvariable="vUMA"/>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="14600706" default="0" returnvariable="vUMI"/>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="4600708" default="S" returnvariable="CalcINFONAVIPeriodoB"/>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2034" default="0" returnvariable="montoVivienda"/>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="14600707" default="N" returnvariable="esCalculoPeriodo"/>
		

		<cfif CalcINFONAVIPeriodoB eq 'S'>
			<cfset diasBimEfectivos = DateDiff("d",fecIniBim,fecFinBim)+1>
		<cfelse>
			<cfset diasBimEfectivos = DateDiff("d",rsPeriodos.iniPer,rsPeriodos.finPer)+1>
		</cfif>

		<cfquery datasource="#Arguments.datasource#">
				update DeduccionesCalculo
				set
					DCvalor =
						coalesce((
								select 
										case 	<!--- OPARRALES 2019-06-10 Para este punto el monto en DCvalor ya viene calculado para los casos de:
													- Pago en especie (Vales de Despensa)
													- Fondo de ahorro Patron
													- Fondo de ahorro Empleado
												 --->
												when Dmetodo = 1 and (coalesce(TDespecie,0) + coalesce(TDFondoAhorro,0) + coalesce(TDFondoAhorroEmp,0) ) >0
													then DeduccionesCalculo.DCvalor
												when Dmetodo = 1 
													then a.Dvalor
												<!--- FIN OPARRALES 2019-06-10 --->
												when Dmetodo = 0 then round((round(c.SEsalariobruto + c.SEincidencias - c.SEinodeduc,2) * a.Dvalor/100),2)
												when Dmetodo = 2 <!--- Veces UMA --->
													then
													<!--- vecesUMA*UMA*2/periodoNominaPorBimestre/DiasPeriodo*(DiasPeriodo - Ausentismos - incapacidades)  --->
													(((((a.Dvalor * #vUMA#) * 2) / #periodosF#)/#Arguments.cantdias#)*(select sum(PEcantdias) from PagosEmpleado where PEmontores > 0.00 and DEid = c.DEid))
												when Dmetodo = 3 and '#esCalculoPeriodo#' = 'N'
													then
													(((((a.Dvalor * #vUMI#) * 2) / #diasBimEfectivos#)*#diasBimCot#)+#montoVivienda#)/#periodosF#
												when Dmetodo = 3 and '#esCalculoPeriodo#' = 'S'
													then
													(((((a.Dvalor * #vUMI#) * 2) / #diasBimEfectivos#))+#montoVivienda#)*(select sum(PEcantdias) from PagosEmpleado where PEmontores > 0.00 and DEid = c.DEid)
												when Dmetodo = 4 and '#esCalculoPeriodo#' = 'N'
													then
													((((a.Dvalor * 2) / #diasBimEfectivos#)*#diasBimCot#)+#montoVivienda#)/#periodosF#
												when Dmetodo = 4 and '#esCalculoPeriodo#' = 'S'
													then
													((((a.Dvalor * 2) / #diasBimEfectivos#))+#montoVivienda#)*(select sum(PEcantdias) from PagosEmpleado where PEmontores > 0.00 and DEid = c.DEid)
												when Dmetodo = 5
													then
													(((a.Dvalor / #diasMCot#)))*(select sum(PEcantdias) from PagosEmpleado where PEmontores > 0.00 and DEid = c.DEid)
										else a.Dvalor end
								from DeduccionesEmpleado a
								inner join SalarioEmpleado c
									on c.DEid = DeduccionesCalculo.DEid
									and a.DEid = c.DEid
									and c.RCNid = DeduccionesCalculo.RCNid
									and a.Did = DeduccionesCalculo.Did
								inner join TDeduccion b
									on b.TDid = a.TDid
									and a.DEid = DeduccionesCalculo.DEid
								where a.Did = DeduccionesCalculo.Did
								and not exists (select 1 from FDeduccion where TDid=b.TDid and (<cf_dbfunction name="length" args="FDformula"> <> 0 or FDcfm is not null))
						), Coalesce(DeduccionesCalculo.DCvalor,0)),
					DCinteres = 0
				where DeduccionesCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">

		  	<cfif IsDefined('Arguments.pDEid')> and DeduccionesCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		  	and not exists(
						select 1 from DeduccionesEmpleadoPlan pp
				 		where pp.Did = DeduccionesCalculo.Did)
		</cfquery>


	<cfquery name="DEP" datasource="#session.dsn#">
		select distinct  p.Did ,d.DEid,  (select min (p2.PPnumero) from DeduccionesEmpleadoPlan p2
                                    inner join DeduccionesEmpleado d2
                                    on d2.Did=p2.Did
                                 where  p2.PPfecha_pago is null
                                 and p2.PPpagado = 0
								 and d2.DEid=d.DEid
								 and d2.Did=d.Did
								 and p2.Did=p.Did) as Minimo
		from DeduccionesEmpleadoPlan p
			inner join DeduccionesEmpleado d
			on d.Did=p.Did
		 where  p.PPfecha_pago is null
         and p.PPpagado = 0
		and DEid in (select DEid from DeduccionesCalculo where RCNid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">)
	</cfquery>

	<cfloop query="DEP">
		<cfquery datasource="#Arguments.datasource#">
            update DeduccionesCalculo
            set
              DCvalor =
                    coalesce((select sum(pl.PPprincipal + pl.PPinteres)
                           from DeduccionesEmpleadoPlan pl
                           where pl.Did = DeduccionesCalculo.Did
                              and pl.PPfecha_pago is null
                              and pl.PPpagado != 1
							  and pl.Did=#DEP.Did#
							  and pl.PPnumero=#DEP.Minimo#
                      ), 0.00),
              DCinteres =
                   coalesce((select sum(pl.PPinteres)
                          from DeduccionesEmpleadoPlan pl
                          where pl.Did = DeduccionesCalculo.Did
                             and pl.PPfecha_pago is null
                             and pl.PPpagado != 1
							 and pl.Did=#DEP.Did#
							 and pl.PPnumero=#DEP.Minimo#
                      ), 0.00)
             where DeduccionesCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
               <cfif IsDefined('Arguments.pDEid')> and DeduccionesCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
               and exists(
                     select 1 from DeduccionesEmpleadoPlan pp
                     where pp.Did = DeduccionesCalculo.Did)
			and DEid=#DEP.DEid#
			and Did=#DEP.Did#
		</cfquery>
	</cfloop>
		<!--- Insertar las Deducciones que se generan a partir de los Conceptos (Retenciones)--->
		<cfquery name="consulta" datasource="#Arguments.datasource#">
			insert into DeduccionesCalculo (
				RCNid, DEid, Did,
				DCvalor,
				DCinteres, DCbatch, DCmontoant,
				DCcalculo, Mcodigo, DCmontoorigen,
				BMUsucodigo, CIid)
			select
				ic.RCNid, ic.DEid, d.Did,
				sum(round(ic.ICmontores * ir.Porcentaje / 100, 2)),
				0.00, null, 0.00,
				0, null,
				sum(round(ic.ICmontores * ir.Porcentaje / 100, 2)),
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, ic.CIid
			from IncidenciasCalculo ic
				inner join RHDeduccionesReb ir
						inner join CIncidentes ci
							on ci.CIid = ir.CIid
					on ir.CIid = ic.CIid
				inner join DeduccionesEmpleado d
						inner join TDeduccion e
							on e.TDid = d.TDid
							and e.TDrenta = 0<!--- DAG 24/04/2007: No incluir deducciones de tipo renta, porque estas se incluiran como Renta --->
					 on d.DEid = ic.DEid
					and d.TDid = ir.TDid
					and ltrim(rtrim(d.Dreferencia)) = ltrim(rtrim(ci.CIcodigo))
					and Dactivo = 1
			where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		   <cfif IsDefined('Arguments.pDEid')> and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and not exists(
					select 1
					from DeduccionesCalculo de
					where de.RCNid = ic.RCNid
					  and de.DEid = ic.DEid
					  and de.Did = d.Did
					)
			  group by ic.RCNid, ic.DEid, d.Did, ic.CIid
		</cfquery>
		<!--- ACTUALIZA EL VALOR DE LA DEDUCCION DEL EMPLEADO (RETENCION) CON EL VALOR DEL CALCULO --->
		<cfquery datasource="#Arguments.datasource#">
			update DeduccionesCalculo set DCvalor = round(DCvalor,2)
			where RCNid = #Arguments.RCNid#
			  <cfif IsDefined('Arguments.pDEid')> and DEid = #Arguments.pDEid#</cfif>
		</cfquery>
	</cfif>

    <!---<cfquery datasource="#session.DSN#" name="z">
		select * from DeduccionesCalculo
		where <!---Did= 30124--->
		 RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<!---and DEid = 277--->
		</cfquery>
	<cf_dump var="#z#">--->


	<cfif CalendarioPagos.CPnodeducciones EQ 0>
		<!---
		/**************************************************************************************
		** De aqui en adelante corresponde al calculo de Deducciones Especiales              **
		**************************************************************************************/
		[NOTA2]: Esta sección del código depende de la base de datos.  Reemplazo las variables
		que había en el stored procedure original por sus valores, para no tener que usar el "declare" de sql
		que evitaría, definitivamente, la portabilidad
		--->
		<cfquery datasource="#Arguments.datasource#" name="DeduccionesEspeciales">
      <!---        select a.TDid
                from TDeduccion a
                inner join FDeduccion b
                  on b.TDid = a.TDid
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and a.TDrenta = 0
           --->

			select a.TDid, e.DEid
			    from TDeduccion a
			    inner join FDeduccion b
			      on a.TDid = b.TDid
			      inner join DeduccionesEmpleado e
			    on a.TDid = e.TDid
			    and e.Destado = 1
			  where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			    and a.TDrenta = 0
			    and a.TDid in
			    (select c.TDid
			    from DeduccionesEmpleado c
			    inner join SalarioEmpleado d
			    on c.DEid = d.DEid
			    <!---<cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>--->
			    where c.Destado = 1)
		</cfquery>


		<cfloop query="DeduccionesEspeciales">
			<!--- Primero busca busca archivo cfm con proceso para la decuccion y lo ejecuta, si no
				  existiera un cfm, entonces verifica que exista el script de base de datos (sp) y lo ejecuta.
			--->
			<cfquery datasource="#Arguments.datasource#" name="formula">
				select FDformula, FDcfm
				from FDeduccion
				where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DeduccionesEspeciales.TDid#">
			</cfquery>

			<cfif len(trim(formula.FDcfm))>
				<!--- 	Hace el proceso respectivo de la deduccion. Se creo basicamente por Oracle
						y la idea es que los scripts se migren a cfm con sql ansi e incluirlos aqui.
				--->

				<cfset Arguments.pDEid1 = DeduccionesEspeciales.DEid>


				<cfinclude template="#trim(formula.FDcfm)#">
			<cfelse>
				<cfif Len(Trim(formula.FDformula))>
					<cfset sqlscript = formula.FDformula>
					<cfset sqlscript = Replace(sqlscript, '@RCNid'	, Arguments.RCNid, 'all')>
					<cfset sqlscript = Replace(sqlscript, '@TDid'	, DeduccionesEspeciales.TDid, 'all')>
					<cfset sqlscript = Replace(sqlscript, '@minimo'	, arguments.minimo, 'all')>
					<cfset sqlscript = Replace(sqlscript, '@Ecodigo', #Session.Ecodigo#, 'all')>

					<cfquery datasource="#Arguments.datasource#">
						# PreserveSingleQuotes( sqlscript )#
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
	<!--- Fin de calculo de Deducciones Especiales --->


<!---<cfquery datasource="#session.DSN#" name="z">
select * from DeduccionesCalculo
where Did= 30124
and RCNid = 735
and DEid = 277
</cfquery>
<cf_dump var="#z#">--->

	   <!--- SML. Inicio Aplica para agregar las deducciones de Fondo de Ahorro cuando es un nomina de vacaciones--->

       <!---<cf_dump var = "#CalendarioPagos#">--->

      <cfif CalendarioPagos.CPtipo EQ 1>
        <cfquery name="rsDedFondoAhorro" datasource="#session.DSN#">
   		select de.DEid,de.Did,de.Dmetodo,de.Dvalor
        from DeduccionesCalculo dc inner join DeduccionesEmpleado de on de.Did=dc.Did
			inner join SalarioEmpleado pe on pe.DEid=de.DEid and pe.RCNid=dc.RCNid
			inner join CalendarioPagos cp on cp.CPid = pe.RCNid
		where de.DFA=1
    		and pe.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        	<cfif IsDefined('Arguments.pDEid')> and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			group by de.DEid,de.Did,de.Dmetodo,de.Dvalor
 		</cfquery>

       <cfif isdefined('rsDedFondoAhorro') and rsDedFondoAhorro.RecordCount GT 0>
			<cfloop query="rsDedFondoAhorro">
            <cfquery datasource="#session.dsn#" name="rsDiasVac">
        				select coalesce(sum(a.ICmontores),0) as MtoVacac , coalesce(sum(a.ICvalor),0) as DiasVacac
                        from IncidenciasCalculo a
                        where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                            and a.DEid = #rsDedFondoAhorro.DEid#
                            and CIid  in (select distinct a.CIid
                                    from RHReportesNomina c
                                        inner join RHColumnasReporte b
                                                    inner join RHConceptosColumna a
                                                    on a.RHCRPTid = b.RHCRPTid
                                             on b.RHRPTNid = c.RHRPTNid
                                            and b.RHCRPTcodigo = 'IncVac'		<!---Total Incidencias--->
                                    where c.RHRPTNcodigo = 'PR002'				<!--- Codigo Reporte Dinamico --->
                                      and c.Ecodigo = #session.Ecodigo#)
      			</cfquery>

       			<cfset TotalInciden = #rsDiasVac.MtoVacac#>
            	<cfif rsDedFondoAhorro.Dmetodo EQ 0>
                	<cfset porcentaje = (rsDedFondoAhorro.Dvalor/100)>
                	<cfset montoDeduc =(TotalInciden * porcentaje )>
                   	<cfquery datasource="#Arguments.datasource#">
						update DeduccionesCalculo
						set DCvalor = #montoDeduc#
                        where DEid = #rsDedFondoAhorro.DEid#
                        and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                        and Did = #rsDedFondoAhorro.Did#
					</cfquery>
                </cfif>
        	</cfloop>
       </cfif>
      </cfif>
      <!--- SML.Final Aplica para agregar las deducciones de Fondo de Ahorro cuando es un nomina de vacaciones--->
		
		<!--- Si el valor de la deduccion a rebajar es mayor que el saldo, se toma el valor del saldo --->
		<cfquery datasource="#Arguments.datasource#">
				update DeduccionesCalculo
					set DCinteres = 0.00,
							DCvalor = coalesce((
																select a.Dsaldo
																from SalarioEmpleado d, DeduccionesEmpleado a
																where DeduccionesCalculo.RCNid = d.RCNid
																and DeduccionesCalculo.DEid = d.DEid
																and d.SEcalculado = 0
																<cfif IsDefined('Arguments.pDEid')>
																		and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
																</cfif>
																and a.Did = DeduccionesCalculo.Did
																and a.DEid = DeduccionesCalculo.DEid
																and a.Dcontrolsaldo > 0
																and a.Dsaldo < DeduccionesCalculo.DCvalor),0.00)
				where DeduccionesCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and exists (select 1
										from SalarioEmpleado d, DeduccionesEmpleado a
										where DeduccionesCalculo.RCNid = d.RCNid
											and DeduccionesCalculo.DEid = d.DEid
											and d.SEcalculado = 0
											<cfif IsDefined('Arguments.pDEid')> 
												and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
											</cfif>
											and a.Did = DeduccionesCalculo.Did
											and a.DEid = DeduccionesCalculo.DEid
											and a.Dcontrolsaldo > 0
											and a.Dsaldo < DeduccionesCalculo.DCvalor)
		</cfquery>
	</cfif>

	<!--- Actualizar Cargas en SalarioEmpleado --->
	<cfquery datasource="#Arguments.datasource#">
	update SalarioEmpleado
	set
		SEcargasempleado = coalesce((
			select sum(a.CCvaloremp)
			from CargasCalculo a
			where a.DEid = SalarioEmpleado.DEid
			  and a.RCNid = SalarioEmpleado.RCNid
			),0.00),
		SEcargaspatrono = coalesce((
			select sum(a.CCvalorpat)
			from CargasCalculo a
			where a.DEid = SalarioEmpleado.DEid
			  and a.RCNid = SalarioEmpleado.RCNid
			),0.00)
	where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	  and SalarioEmpleado.SEcalculado = 0
	  <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

	<!---  Actualizar la Tabla SalarioEmpleado para poner Deducciones --->
	<cfquery datasource="#Arguments.datasource#">
	update SalarioEmpleado set
		SEdeducciones = coalesce((
			select sum(a.DCvalor)
			from DeduccionesCalculo a
			where a.DEid = SalarioEmpleado.DEid
			  and a.RCNid = SalarioEmpleado.RCNid
			),0.00)
	where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	  and SalarioEmpleado.SEcalculado = 0
	  <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>

    <!--- Guardo la información  del Fondo de Ahorro  IRR--->
    <!---Modificado por SML para que cuando se restaure individualmente se agregue en la tabla--->
    <cfquery name="insRHFondoAhorro"  datasource="#session.dsn#">
    	insert into RHFondoAhorro(DEid,Ecodigo,FAMonto,RCNid,TDid,Tcodigo,FAEstatus)
        select dc.DEid,cp.Ecodigo,DCvalor,pe.RCNid, TDid,cp.Tcodigo,0
		from DeduccionesCalculo dc inner join DeduccionesEmpleado de on de.Did=dc.Did
			inner join SalarioEmpleado pe on pe.DEid=de.DEid and pe.RCNid=dc.RCNid
			inner join CalendarioPagos cp on cp.CPid = pe.RCNid
		where de.DFA=1
        	and pe.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        <cfif IsDefined('Arguments.pDEid')>and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
   </cfquery>
   <!--- Información del Fondo  de Ahorro Guardada  IRR--->

   <!---SML. Inicio Modificar para la Incidencia de Fondo de Ahorro y no considerar LineaTiempo--->
   <cfquery name="rsDedFondoAhorro" datasource="#session.DSN#">
   		select dc.DEid,DCvalor
		from DeduccionesCalculo dc inner join DeduccionesEmpleado de on de.Did=dc.Did
			inner join SalarioEmpleado pe on pe.DEid=de.DEid and pe.RCNid=dc.RCNid
			inner join CalendarioPagos cp on cp.CPid = pe.RCNid
		where de.DFA=1
        	and de.TDid in (select distinct a.TDid
                            from RHReportesNomina c
                                inner join RHColumnasReporte b
                                            inner join RHConceptosColumna a
                                            on a.RHCRPTid = b.RHCRPTid
                                     on b.RHRPTNid = c.RHRPTNid
                                    and b.RHCRPTcodigo = '01' 		<!---Deduccion Empresa--->
                            where c.RHRPTNcodigo = 'PR004'					<!--- Codigo Reporte Dinamico --->
                              and c.Ecodigo = #session.Ecodigo#)
    		and pe.RCNid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        	<cfif IsDefined('Arguments.pDEid')> and de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			group by dc.DEid,DCvalor
   </cfquery>

   <cfloop query="rsDedFondoAhorro">
   		<cfquery name="rsFondoAhorro" datasource="#session.DSN#">
   			select top 1 ICid
			from IncidenciasCalculo a
				inner join CIncidentes b on a.CIid = b.CIid
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and b.CIfondoahorro = 1
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDedFondoAhorro.DEid#">
   		</cfquery>


        <cfset idIncidencia = #rsFondoAhorro.ICid#>
        <cfif isdefined('idIncidencia') and len(idIncidencia) GT 0>
        <cfquery name="rsFondoAhorro" datasource="#session.DSN#">
			update IncidenciasCalculo
            set ICvalor = #rsDedFondoAhorro.DCvalor#,
            	ICmontores = #rsDedFondoAhorro.DCvalor#
            where ICid = #idIncidencia#
   		</cfquery>

		<cfif CalendarioPagos.CPtipo EQ 1>
        	<cfquery name="rsFondoAhorro" datasource="#session.DSN#">
				update IncidenciasCalculo
                set ICvalor = 0,
            	ICmontores = 0
           		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and CIid in (select CIid from CIncidentes where CIfondoahorro = 1 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDedFondoAhorro.DEid#">
                	and ICid <> #idIncidencia#
   			</cfquery>
        <cfelseif CalendarioPagos.CPtipo EQ 0>
        	<cfquery name="rsFondoAhorro" datasource="#session.DSN#">
				delete from IncidenciasCalculo
            	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and CIid in (select CIid from CIncidentes where CIfondoahorro = 1 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDedFondoAhorro.DEid#">
                	and ICid <> #idIncidencia#
   			</cfquery>
        </cfif>

        <cfquery datasource="#Arguments.datasource#">
			update SalarioEmpleado set
				SEincidencias  = coalesce((select coalesce(sum(b.ICmontores),0.00) from IncidenciasCalculo b
                							<!---inner join ComponentesSalariales cs on b.CIid = cs.CIid
												and cs.CSsalarioEspecie <> 1
                                                left join CIncidentes ci on ci.CIid = b.CIid
													and ci.CIespecie !=1--->
                                    	   where SalarioEmpleado.DEid = b.DEid and 	 SalarioEmpleado.RCNid = b.RCNid ), 0.00)
			where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	  			and SalarioEmpleado.SEcalculado = 0
	  			<cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>
        </cfif>
   </cfloop>

   <!---SML. Final Modificar para la Incidencia de Fondo de Ahorro y no considerar LineaTiempo--->
<!---ljimenez - Llamado a la componente de calculo de renta.--->
	<cfif CalendarioPagos.CPnorenta is 0>
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2020" default="RH_CalculoNominaRentaCR.cfc" returnvariable="ComponenteRenta"/>
		<cfset comp  = Mid('#ComponenteRenta#', 1, len(trim(#ComponenteRenta#))-4)>
		<cfinvoke component="#comp#" method="CalculoNominaRenta">
        	<cfinvokeargument name="Conexion" 			 value= "#Arguments.datasource#">
            <cfinvokeargument name="RCNid" 				 value= "#Arguments.RCNid#">
            <cfinvokeargument name="Ecodigo" 			 value= "#Arguments.Ecodigo#">
            <cfinvokeargument name="Tcodigo" 			 value= "#Arguments.Tcodigo#">
            <cfinvokeargument name="cantdias" 			 value= "#cantdias#">
            <cfinvokeargument name="CantDiasMensual" 	 value= "#CantDiasMensual#">
            <cfinvokeargument name="CantPagosRealizados" value= "#CantPagosRealizados.cant#">
            <cfinvokeargument name="Factor" 			 value= "#Factor#">
            <cfinvokeargument name="per" 				 value= "#CalendarioPagos.CPperiodo#">
            <cfinvokeargument name="mes"				 Value= "#CalendarioPagos.CPmes#">
            <cfinvokeargument name="IRcodigo" 			 Value= "#Arguments.IRcodigo#">
            <cfinvokeargument name="RCdesde"			 Value= "#Arguments.RCdesde#">
            <cfinvokeargument name="RChasta"			 Value= "#Arguments.RChasta#">
            <cfinvokeargument name="ValidarCalendarios"  value="#Arguments.ValidarCalendarios#">
	        <cfif isdefined('arguments.pDEid')>
            	<cfinvokeargument name="DEid" 			value="#arguments.pDEid#">
            </cfif>
        </cfinvoke>
	</cfif>

<!---ljimenez inicio realiza el calculo de cargas que se calculan despues del calculo de la renta. --->

	<cfinclude template="CalculoEspeciales.cfm">

<!---ljimenez fin del calculo de deducciones que se calculan despues del calculo de la renta.--->

	<cfquery datasource="#Arguments.datasource#">
	update SalarioEmpleado set
		SEsalariobruto = round(SEsalariobruto,2),
		SEincidencias = round(SEincidencias,2),
		SErenta = round(SErenta,2),
		SEcargasempleado = round(SEcargasempleado,2),
		SEcargaspatrono = round(SEcargaspatrono,2),
		SEdeducciones = round(SEdeducciones,2)
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	  and SEcalculado = 0
	  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>


	<!--- NOMINA DE ANTICIPO --->
	<!--- SI LA NÓMINA ES DE ANTICIPO DEBE DE:
	1) VERIFICAR SI EL MONTO DEL ANTICIPO >0 Y MENOR = 100 CON COALESCES
	2) CALCULAR EL SALARIO LIQUIDO EN UNA VARIABLE SALARIOLIQ=ROUND(SEsalariobruto + SEincidencias - SErenta - SEcargasempleado - SEdeducciones,2)
	3) CALCULAR EL % ANTICIPO (40) Y EL PORCENTAJE RESTANTE(60) SOBRE LA VARIABLE SALARIO LIQUIDO (DEL PASO ANTERIOR)
	4) INSERTAR UNA INCIDENCIA NEGATIVA EN iNCIDENCIAS CALCULO (esta relacion por el 60)PARA ESE EMPLEADO POR EL MONTO RESTANTE DEL ANTICIPO
	5) INSERTAR LA INCIDENCIA EN iNCIDENCIAS (NEGATIVA) PARA LA FECHA DESDE DEL SIG. CALENDARIO NORMAL (por el 40) POSTERIOR A ESTA RELACION DE ANTICIPO
	6) ACTUALIZAR EL MONTO DE SEincidencias EN SalarioEmpleado
	--->
	<cfif CalendarioPagos.CPtipo EQ 2>
		 <!--- TRAE EL CONCEPTO DE PAGO DEFINIDO PARA ANTICIPO DE SALARIO --->
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="730" default="" returnvariable="CIidAnticipo"/>
		<cfif Not Len(CIidAnticipo)>
			<cfthrow message="Error!, No se ha definido el Concepto de Pago para Anticipos de Salario a utilizar en los parámetros del Sistema. Proceso Cancelado!!">
		</cfif>
		<!--- DATOS DE LA INCIDENCIA --->
		<cfquery name="rsDatosInc" datasource="#session.DSN#">
			select CInegativo
			from CIncidentes
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">
		</cfquery>
		 <!--- (4)CREA LA INCIDENCIA PARA QUE EL CALCULO DEL SALARIO LIQUIDO, SOLO TOME EN CUENTA EL ANTICIPO --->
		 <!--- MODIFICACIÓN DEL 01/08/2007 REALIZADA POR ANA VILLAVICENCIO.
			SE MODIFICÓ LA FECHA PARA LA INCIDENCIA PARA EL CASO DE LAS PERSONAS QUE HAN SIDO NOMBRADAS DESPUES
			DE LA FECHA DE INICIO DE LA NÓMINA, CUANDO SE DA ESTE CASO ENTONCES SE PONE LA FECHA DEL NOMBRAMIENTO
			DE LO CONTRARIO LA FECHA DE INICIO DE LA NÓMINA
		 --->


		<cfquery name="rsIncidenciaAnticipo" datasource="#session.DSN#">
			insert into IncidenciasCalculo (RCNid,
											DEid,
											CIid,
											ICfecha,
											ICvalor,
											ICfechasis,
											Usucodigo,
											Ulocalizacion,
											ICcalculo,ICbatch, ICmontoant,
											ICmontores, CFid)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
				a.DEid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidAnticipo#">,
				case when (select 1
							from DLaboralesEmpleado dl, RHTipoAccion ta
							where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							  and dl.DEid = a.DEid
							  and dl.RHTid = ta.RHTid
							  and ta.RHTcomportam = 1
							  and dl.DLfvigencia > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">) = 1
						then (select dl.DLfvigencia
							from DLaboralesEmpleado dl, RHTipoAccion ta
							where dl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							  and dl.DEid = a.DEid
							  and dl.RHTid = ta.RHTid
							  and ta.RHTcomportam = 1
							  and dl.DLfvigencia > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">)
						else <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> end,
				1,
				<cf_dbfunction name="today">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">,
				0, null, 0.00,
				(round((SEsalariobruto + SEincidencias - SErenta - SEcargasempleado - SEdeducciones) * coalesce(100-DEporcAnticipo,100)/100,2)) * #rsDatosInc.CInegativo#,
				(select max(case when p.CFidconta is null then p.CFid else p.CFidconta end)
					from PagosEmpleado pe, RHPlazas p
					where pe.RCNid = a.RCNid
					  and pe.DEid = a.DEid
					  and pe.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = pe.RCNid and b.DEid = pe.DEid)
					  and p.RHPid = pe.RHPid
					  <cfif IsDefined('Arguments.pDEid')> and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
					)
			from SalarioEmpleado a
			inner join DatosEmpleado de
			   on de.DEid = a.DEid
			   and de.Ecodigo=#session.Ecodigo#
			  and de.DEporcAnticipo > 0
			  and de.DEporcAnticipo <= 100
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			<cfif IsDefined('Arguments.pDEid')> and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>
		<!--- SE ACTUALIZA EL MONTO DE LAS INCIDENCIAS --->
		<cfquery datasource="#Arguments.datasource#">
			update SalarioEmpleado set
				SEincidencias = coalesce((select coalesce(sum(b.ICmontores),0.00) from IncidenciasCalculo b where SalarioEmpleado.DEid = b.DEid and SalarioEmpleado.RCNid = b.RCNid), 0.00)
			where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and SalarioEmpleado.SEcalculado = 0
			  <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		</cfquery>
	</cfif>
	<!---- / FIN DE NOMINA DE ANTICIPO --->

	<!---
		  Pago de Aguinaldo en dos tractos.
		  Se agrego un check en pantalla para poder pagar en dos tractos. Esto requiere un segundo Calendario de Pagos
		  abierto, especial y posterior al actual. Se deben generar incidencias negativas por el monto restante del adelanto,
		  y estas seran tomadas en cuenta para la proxima nomina especial.
		  En este segmento de codigo se valida la existencia de la nomima especial posterior y se calculan los montos para
		  adelantar por cada usuario.
		  El adelanto se hace sobre las incidencias de la nómina.
	--->

	<cfif isdefined("CalendarioPagos.RCpagoentractos") and CalendarioPagos.RCpagoentractos eq 1>
		<cfset vPorcentaje = 100 >
		<cfset vPorcentajePendiente = 0 >
		<cfif isdefined("CalendarioPagos.RCporcentaje") and len(trim(CalendarioPagos.RCporcentaje))>
			<cfset vPorcentaje = replace(CalendarioPagos.RCporcentaje,',','','all') >
		</cfif>
		<cfset vPorcentajePendiente = 100 - vPorcentaje >

		<!--- Inserta en IncidenciasCalculo--->
		<cfif vPorcentajePendiente gt 0 >
			<cfquery name="rsObtieneConcepto" datasource="#session.dsn#">
				select min(CIid) as CIid
				from RCalculoNomina
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>
			<cfset LvarConcepto = rsObtieneConcepto.CIid>
			<cfquery name="rsAdelanto" datasource="#session.DsN#">
				insert into IncidenciasCalculo ( RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis,
												Usucodigo, Ulocalizacion, ICcalculo, ICmontoant, ICmontores )
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
						ic.DEid,
						#LvarConcepto#,
						<cfqueryparam cfsqltype="cf_sql_date" value="#CalendarioPagos.RChasta#">,
						round((sum(ICmontores)* (#vPorcentajePendiente/100#))* -1,2),
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
						'00',
						0,
						0,
						round((sum(ICmontores)* (#vPorcentajePendiente/100#))* -1,2)
				from IncidenciasCalculo ic
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				<cfif IsDefined('Arguments.pDEid')>and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				group by ic.DEid
			</cfquery>
			<!--- SE ACTUALIZA EL MONTO DE LAS INCIDENCIAS --->
			<cfquery datasource="#Arguments.datasource#">
				update SalarioEmpleado set
					SEincidencias = coalesce((select coalesce(sum(b.ICmontores),0.00) from IncidenciasCalculo b where SalarioEmpleado.DEid = b.DEid and SalarioEmpleado.RCNid = b.RCNid), 0.00)
				where SalarioEmpleado.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				  and SalarioEmpleado.SEcalculado = 0
				  <cfif IsDefined('Arguments.pDEid')> and SalarioEmpleado.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			</cfquery>
		</cfif>
	</cfif>
	<!--- ************************************************************************************************ --->

	<!--- OPARRALES 2018-07-20 Cambio para excluir el monto de las incidencias con el check de: Ecluir del CFDI del monto neto  --->
	<!--- OPARRALES 2018-08-22 Se complementa query para obtener DEid --->
	<cfset montoIncExcl = 0>
	<cfquery name="rsIncExcl" datasource="#session.dsn#">
		Select
			sum(ICmontores) as sumICmontores,
			sum(ICvalor) as sumICvalor,
			DEid
		from
			IncidenciasCalculo ic
		inner join Cincidentes ci on ic.CIid = ci.CIid
		where
			ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and ci.CItimbrar = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
		<!--- <cfif IsDefined('Arguments.pDEid')>
			and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
		</cfif> --->
		group by DEid
	</cfquery>

	<!--- OPARRALES 2018-08-22 Se actualiza SEliquido como lo hacia inicialmente --->
	<cfquery datasource="#Arguments.datasource#">
		update SalarioEmpleado
			set SEliquido = round(SEsalariobruto + SEincidencias - SErenta - SEcargasempleado - SEdeducciones,2)
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and SEcalculado = 0
	  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
	</cfquery>
	<cfif rsIncExcl.RecordCount gt 0>
		<!--- OPARRALES 2018-08-22 Se actualiza SEliquido por empleado de acuerdo a la configuracion de sus componentes
			- (cuando tiene un componente con pagos en efectivo, se excluye dicho monto en SEliquido)
		 --->
		<cfloop query="rsIncExcl">
			<cfset montoIncExcl = LSNumberFormat(rsIncExcl.sumICmontores,'9.00')>
			<cfquery datasource="#Arguments.datasource#">
				update SalarioEmpleado
					set SEliquido = round(SEsalariobruto + SEincidencias - SErenta - SEcargasempleado - SEdeducciones - #montoIncExcl#,2)
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				and SEcalculado = 0
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncExcl.DEid#">
			</cfquery>

		</cfloop>
	</cfif>

	<!--- Prioridades de Deducciones --->
	<!--- verifica que no existan calendario de pagos abiertos antes del actual --->
	<cfquery datasource="#Arguments.datasource#" name="ExisteCalendario">
		select 1
		from CalendarioPagos a, CalendarioPagos b
		where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and b.Ecodigo = a.Ecodigo
		  and b.Tcodigo = a.Tcodigo
		  and b.CPdesde < a.CPdesde
		  and b.CPfcalculo is null
	</cfquery>
	<cfif Not ExisteCalendario.RecordCount>
		<cfquery datasource="#Arguments.datasource#" name="ExisteSalarioEmpleado">
			select 1
			from SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			and SEcalculado = 0
				<cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				and SEliquido < 0.00
		</cfquery>
		<cfif ExisteSalarioEmpleado.RecordCount>
			
			<cfinvoke component="RH_ProcesaDeducciones" method="ProcesaDeducciones">
				<cfinvokeargument name="conexion" value="#Arguments.datasource#">
				<cfinvokeargument name="RCNid" value="#Arguments.RCNid#">
				<cfif IsDefined('Arguments.pDEid')>
					<cfinvokeargument name="pDEid" value="#Arguments.pDEid#">
				</cfif>
				<cfinvokeargument name="debug" value="#Arguments.debug#">
			</cfinvoke>
		</cfif>
	</cfif>

	<cfif Arguments.debug>
		<cfoutput>factored:#factored#, tipored:#tipored#</cfoutput>
	</cfif>


	<cfif factored GT 0>
		<cfif tipored is 1>
			<!--- Redondeo a la unidad de pago parametrizada. Solo si la unidad de pago es mayor a cero --->
			<cfquery datasource="#Arguments.datasource#">
			insert into IncidenciasCalculo
				(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant,ICmontores, CFid)
			select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
				DEid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#idincidenciared#">,

				<!---============ Modificacion LZ-26/10/2010 ============---->

				case when (select max(xx.LThasta)
							from LineaTiempo xx
							where xx.DEid = SalarioEmpleado.DEid)
							< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#"> then
								(select max(xx.LThasta)
								from LineaTiempo xx
								where xx.DEid = SalarioEmpleado.DEid)


					 when (select max(xx.LThasta)
							from LineaTiempo xx
							where xx.DEid = SalarioEmpleado.DEid)
							< <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#"> then
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
				else
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
				end ,
				<!----<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">, ----->

				1, <cf_dbfunction name="today">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 0.00,
				round(round(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">, 0)
					* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">, 2) - SEliquido,
				(select distinct case when p.CFidconta is null then p.CFid else p.CFidconta end
				from PagosEmpleado a, RHPlazas p
				where a.RCNid = SalarioEmpleado.RCNid
				  and a.DEid = SalarioEmpleado.DEid
				  and a.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = a.RCNid and b.DEid = a.DEid)
				  and a.PEtiporeg != 2
				  and p.RHPid = a.RHPid
				)
			from SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and SEcalculado = 0
			  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and SEliquido != round(round(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">, 0)
			  	* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2)
			 </cfquery>
			 <cfquery datasource="#Arguments.datasource#">
			update SalarioEmpleado set
				SEliquido = round(round(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">, 0)
					* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2),
				SEincidencias = SEincidencias + (round(round(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">, 0)
					* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2) - SEliquido)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and SEcalculado = 0
			  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and SEliquido != round(round(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">, 0)
			  	* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2)
			 </cfquery>

		<cfelse>
			<cfquery datasource="#Arguments.datasource#">
			insert into IncidenciasCalculo
				(RCNid, DEid,
				CIid,
				ICfecha, ICvalor, ICfechasis,
				Usucodigo,
				Ulocalizacion,
				ICcalculo,
				ICbatch,
				ICmontoant,
				ICmontores, CFid)
			select
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">,
				DEid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#idincidenciared#">,

				<!---============ Modificacion LZ-10/11/2008 ============---->
				case when (select max(xx.LThasta) from LineaTiempo xx where xx.DEid = SalarioEmpleado.DEid) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#"> then
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
				else
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
				end ,
				<!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">, ----->

				1, <cf_dbfunction name="today">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ulocalizacion#">, 0, null, 0.00,
				round(<cf_dbfunction name="ceiling">(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">)
					* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2) - SEliquido,
				<!--- [NOTA3]: se pone el max para que no devuelva nunca más de un valor.
				--->
				(select max(case when p.CFidconta is null then p.CFid else p.CFidconta end)
				from PagosEmpleado a, RHPlazas p
				where a.RCNid = SalarioEmpleado.RCNid
				  and a.DEid = SalarioEmpleado.DEid
				  and a.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = a.RCNid and b.DEid = a.DEid)
				  and p.RHPid = a.RHPid
				)
			from SalarioEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and SEcalculado = 0
			  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and SEliquido != round(<cf_dbfunction name="ceiling">(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">)
			  	* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2)
			</cfquery>
			<cfquery datasource="#Arguments.datasource#">
			update SalarioEmpleado set
				SEliquido = round(<cf_dbfunction name="ceiling">(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">)
					* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2),
				SEincidencias = SEincidencias + (round(<cf_dbfunction name="ceiling">(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">)
					* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2) - SEliquido)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and SEcalculado = 0
			  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
			  and SEliquido != round(<cf_dbfunction name="ceiling">(SEliquido / <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">)
			  	* <cfqueryparam cfsqltype="cf_sql_money" value="#factored#">,2)
			 </cfquery>
		</cfif>
	</cfif>

    <!--- En caso de que alguna incidencia tengo nulo el valor de Cfid , se inserta el definido en la plaza al que pertenece el empleado --->

    <cfquery datasource="#Arguments.datasource#">
        update IncidenciasCalculo set CFid =
        		(select max(case when p.CFidconta is null then p.CFid else p.CFidconta end)   from LineaTiempo  a, RCalculoNomina b, RHPlazas p
       				 where  ( RCdesde between LTdesde and LThasta
            		or  RChasta between LTdesde and LThasta)
        			and  RCNid = IncidenciasCalculo.RCNid
                    and IncidenciasCalculo.DEid = a.DEid
         			and p.RHPid = a.RHPid
                    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    and a.Ecodigo = b.Ecodigo
                    and a.Ecodigo = p.Ecodigo
                    )
        where CFid is null
        and  RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	</cfquery>


	<!--- Calendario de Pagos anterior --->
	<cfif CalendarioPagos.CPtipo EQ 2> <!--- SI ES ANTICIPO DE SALARIO LA COMPARACION ES DIFERENTE --->
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select Ttipopago as CodTipoPago
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and rtrim (Tcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(Arguments.Tcodigo)#">
		</cfquery>
		<cfif rsTipoNomina.CodTipoPago EQ "0"> 		<!--- Semanal --->
			<cfset Lvar_Fecha = DateAdd("d", -6, "#Arguments.RCdesde#")>
		<cfelseif rsTipoNomina.CodTipoPago EQ "1">	<!--- Bisemanal --->
			<cfset Lvar_Fecha = DateAdd("d", -13, "#Arguments.RCdesde#")>
		<cfelseif rsTipoNomina.CodTipoPago EQ "2">	<!--- Quincenal --->
			<cfset Lvar_Fecha = DateAdd("d", -14, "#Arguments.RCdesde#")>
		<cfelseif rsTipoNomina.CodTipoPago EQ "3">	<!--- Mensual --->
			<cfset Lvar_Fecha = DateAdd("d", -(DaysInMonth(Arguments.RCdesde) - 1)	, "#Arguments.RCdesde#")>
		</cfif>
		<cfset Periodo = DatePart('yyyy',Lvar_Fecha)>
		<cfset Mes = DatePart('m',Lvar_Fecha)>
		<cfquery datasource="#Arguments.datasource#" name="CPidant">
			select a.CPid
			from CalendarioPagos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.CPdesde = (select min(CPdesde)
								from CalendarioPagos
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								  and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
								  and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
								  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">)
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
		</cfquery>
	<cfelse>
		<!--- VERIFICA SI HAY UNA NOMINA DE ANTICIPO PARA EL MISMO PERIODO DE LA NOMINA NORMAL QUE SE ESTA CALCULANDO
			SI HAY UNA NOMINA DE ANTICIPO SE VERIFICA QUE TIENE Q ESTAR EN HISTORICOS PARA PODER GENERARLA.
		 --->
		<cfset Periodo = DatePart('yyyy',"#Arguments.RCdesde#")>
		<cfset Mes = DatePart('m',"#Arguments.RCdesde#")>
		<cfquery name="CPidant" datasource="#session.DSN#">
			select a.CPid
			from CalendarioPagos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and a.CPdesde = (
			  	select max(b.CPdesde) from CalendarioPagos b
				where b.Ecodigo = a.Ecodigo
				  and b.Tcodigo = a.Tcodigo
				  and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
				  and b.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
				  and CPtipo = 2
				 )
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
			  and CPtipo = 2
		</cfquery>
		<cfif CPidant.RecordCount EQ 0 or CalendarioPagos.CPtipo eq 1 >		<!--- Se agrego la segunda parte del or, pues las nominas especiales no deben considerar el query anterior. --->
			<cfquery datasource="#Arguments.datasource#" name="CPidant">
				select a.CPid
				from CalendarioPagos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and a.CPdesde = (
				  	select max(b.CPdesde) from CalendarioPagos b
					where b.Ecodigo = a.Ecodigo
					and b.Tcodigo = a.Tcodigo
					 and b.CPdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
					 )
				  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
			</cfquery>
		</cfif>
	</cfif>

	<cfif Len(CPidant.CPid)>
		<cfquery datasource="#Arguments.datasource#" name="existsHRCalculoNomina">
			select 1 from HRCalculoNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
			and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPidant.CPid#">
		</cfquery>
	</cfif>

	<!---Lee parametro de usa Salario base de cotizacion este se usa como indicador que de es Legislacion Mexico--->
	<cfinvoke component="RHParametros" method="get" datasource="#Arguments.datasource#" ecodigo="#Arguments.Ecodigo#" pvalor="2025" default="0" returnvariable="vUsaSBC"/>


	<!--- Si la Nómina anterior está en la historia o si es la primer nómina que se paga (estaría nula la variable @CPidant) --->

	<cfif Not Len(CPidant.CPid) Or existsHRCalculoNomina.RecordCount >
    	<cfquery name="rsPeriodo" datasource="#session.DSN#"> <!---SML Obtener el periodo del bimestre que va a regir el SDI--->
        	select CPperiodo from CalendarioPagos
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
        </cfquery>

		<!---Cambiar el Status de Calculado a todos los Empleados --->
		<cfquery datasource="#Arguments.datasource#">
		update SalarioEmpleado
		set SEcalculado = 1
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and SEcalculado = 0
		  <cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
		  and SEliquido >= 0.00
          <cfif vUsaSBC eq 1>
              and DEid in
              (select a.DEid
                from SalarioEmpleado a
                    inner join RHHistoricoSDI b
                        on a.DEid = b.DEid
                        and b.RHHperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.CPperiodo#"> <!---SML Obtener el periodo del bimestre que va a regir el SDI--->
                        and b.RHHaplicado = 1 <!---SML. Modificacion para que valide que los SDI estan aplicados--->
                        and b.Bimestrerige =
                        (select case when CPmes = 1 then 1
                                when CPmes = 2 then 1
                                when CPmes = 3 then 2
                                when CPmes = 4 then 2
                                when CPmes = 5 then 3
                                when CPmes = 6 then 3
                                when CPmes = 7 then 4
                                when CPmes = 8 then 4
                                when CPmes = 9 then 5
                                when CPmes = 10 then 5
                                when CPmes = 11 then 6
                                when CPmes = 12 then 6
                            end
                         from CalendarioPagos
                            where CPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                        )
                    where RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                )
          </cfif>
		</cfquery>
	</cfif>
	<!---===============================================================================================================--->
	<!---Cambia el estatus a calculado(SEcalculado=1) al calendario ESPECIAL que se esta generando, siempre y cuando NO
	  exista un calendario del mismo tipo de nomina (quincenal,mensual,bisemanal,etc) abierto y con fecha hasta < a la fecha
	  hasta del calendario especial que se esta generando.Esto para permitir aplicar calendarios de pago especiales como
	  los del aguinaldo.---->
	<!---===============================================================================================================--->

	<cfif CalendarioPagos.CPtipo EQ 1>
		<cfquery datasource="#session.DSN#">
			update SalarioEmpleado
				set SEcalculado = coalesce((select 1
											from SalarioEmpleado a, CalendarioPagos b
											where a.RCNid = b.CPid
												and a.DEid = SalarioEmpleado.DEid
												and a.SEcalculado = 0
												and a.SEliquido >= 0.00
												and b.CPtipo = 1	<!----Calendario de pago de tipo especial---->
												and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
												<!---Cuando no exista un calendario abierto (RCalculoNomina) con fecha hasta < a fecha hasta del calendario de la nomina aplicando---->
												and not exists(	select 1
																from CalendarioPagos c, RCalculoNomina y
																where c.CPid = y.RCNid
																	and b.Ecodigo = c.Ecodigo
																	<!---and b.CPtipo = c.CPtipo---->
																	and b.Tcodigo = c.Tcodigo
																	and c.CPid <> b.CPid
																	and c.CPhasta < b.CPhasta)
											),0)
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				<cfif IsDefined('Arguments.pDEid')> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
				and exists (select 1
							from SalarioEmpleado a, CalendarioPagos b
							where a.RCNid = b.CPid
								and a.DEid = SalarioEmpleado.DEid
								and a.SEcalculado = 0
								and a.SEliquido >= 0.00
								and b.CPtipo = 1	<!----Calendario de pago de tipo especial---->
								and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
								<!---Cuando no exista un calendario abierto (RCalculoNomina) con fecha hasta < a fecha hasta del calendario de la nomina aplicando---->
								and not exists(	select 1
												from CalendarioPagos c, RCalculoNomina y
												where c.CPid = y.RCNid
													and b.Ecodigo = c.Ecodigo
													<!---and b.CPtipo = c.CPtipo--->
													and b.Tcodigo = c.Tcodigo
													and c.CPid <> b.CPid
													and c.CPhasta < b.CPhasta)
							)
		</cfquery>
	</cfif>
</cffunction>
<!---??????Funcion para obtener listado de las nominas??????--->
<cffunction name="GetCalculoNomina" access="public" hint="Funcion para obtener listado de las nominas" returntype="query">
	<cfargument name="Conexion" type="string"  required="no" hint="Nombre del DataSource de Coldfusion">
    <cfargument name="Ecodigo" 	type="numeric" required="no" hint="Codigo Interno de la empresa">
    <cfargument name="Tcodigo" 	type="string"  required="no" hint="Codigo del Tipo de Nomina">

	<cfif not isdefined('Arguments.Conexion') and isdefined('session.dsn')>
    	<cfset Arguments.Conexion = session.dsn>
    </cfif>
    <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
    	<cfset Arguments.Ecodigo = session.Ecodigo>
    </cfif>
    <cfquery name="rsCalculoNomina" datasource="#Arguments.Conexion#">
    	select a.RCNid,a.Ecodigo,a.Tcodigo,a.RCDescripcion,a.RCdesde,a.RChasta,a.RCestado,a.Usucodigo,a.Ulocalizacion,a.IDcontable,
        	   a.ts_rversion,a.BMUsucodigo,a.NAP,a.Bid,a.CBid,a.CBcc,a.Mcodigo,a.RCtc,a.CIid,a.RCpagoentractos,a.RCporcentaje,a.RHPTUEid, CP.CPtipo
         from RCalculoNomina a
         	inner join CalendarioPagos CP
            	 on CP.CPid = a.RCNid
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        <cfif isdefined('Arguments.Tcodigo') and LEN(TRIM(Arguments.Tcodigo))>
        	and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
        </cfif>
    </cfquery>
    <cfreturn rsCalculoNomina>
</cffunction>
<!---??????Funcion para obtener el Factor para la proyeccion de la renta??????--->
<cffunction name="GetFactor" access="public" hint="Funcion para el Factor para la proyeccion de la renta" returntype="struct">
	<cfargument name="CPmes" 		type="numeric"  required="yes" hint="Mes de la nomina que se esta procesando">
    <cfargument name="CPperiodo" 	type="numeric"  required="yes" hint="Periodo de la nomina que se esta procesando">
    <cfargument name="Tcodigo" 		type="string"   required="yes" hint="Codigo del Tipo de Nomina">
    <cfargument name="CPtipo" 		type="numeric"  required="yes" hint="Tipo de Nomina (0=nomal, 1=especial, 2=anticipo, 4=PTU)">
    <cfargument name="Ttipopago" 	type="numeric"  required="yes" hint="Frecuencia de pago (0=Semanal ,1=Bisemanal ,2=Quincenal ,3=Mensual)">
    <cfargument name="RCdesde" 		type="date"  	required="yes" hint="Fecha desde de la nomina que se esta procesando">

    <cfargument name="Conexion" type="string"  required="no" hint="Nombre del DataSource de Coldfusion">
    <cfargument name="Ecodigo" 	type="numeric" required="no" hint="Codigo Interno de la empresa">

	<cfif not isdefined('Arguments.Conexion') and isdefined('session.dsn')>
    	<cfset Arguments.Conexion = session.dsn>
    </cfif>

    <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
    	<cfset Arguments.Ecodigo = session.Ecodigo>
    </cfif>

 	<cfquery datasource="#Arguments.Conexion#" name="rsPrimerNominaDelMes">
        select a.CPfpago
            from CalendarioPagos a
         where a.CPmes 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPmes#">
           and a.CPperiodo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPperiodo#">
           and a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
           and a.Tcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
           and a.CPtipo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPtipo#">
           and a.CPfpago 	= (select min(b.CPfpago)
                                from CalendarioPagos b
                                 where b.CPmes 		= a.CPmes
                                   and b.CPperiodo 	= a.CPperiodo
                                   and b.Ecodigo	= a.Ecodigo
                                   and b.Tcodigo 	= a.Tcodigo
                                   and b.CPtipo		= a.CPtipo)
    </cfquery>
	<cfif NOT rsPrimerNominaDelMes.RecordCount>
        <cfthrow message="No se pudo Recuperar la primer Calendario de #Arguments.CPperiodo# -  #Arguments.CPmes#">
    </cfif>
	<cfif Arguments.Ttipopago EQ 0><!---Semanal--->
        <cfset CantCalendarioMensuales 			 = 1>
        <cfset CantCalendarioMensualesAnteriores = 1>
        <cfset Continuar				= true>
        <cfset CPfpagoTemp 				= rsPrimerNominaDelMes.CPfpago>
        <cfloop condition="Continuar EQ true">
            <cfset CPfpagoTemp = DateAdd("d", 7, CPfpagoTemp)>
            <cfif DatePart("yyyy", CPfpagoTemp) EQ Arguments.CPperiodo and DatePart("m", CPfpagoTemp) EQ Arguments.CPmes>
                	<cfset CantCalendarioMensuales = CantCalendarioMensuales + 1>
                <cfif CPfpagoTemp LTE Arguments.RCdesde>
                	<cfset CantCalendarioMensualesAnteriores = CantCalendarioMensualesAnteriores + 1>
                </cfif>
            <cfelse>
                <cfset Continuar = false>
            </cfif>
        </cfloop>
    <cfelseif Arguments.Ttipopago EQ 1><!---Bisemanal--->
        <cfset CantCalendarioMensuales 	= 1>
        <cfset Continuar				= true>
        <cfset CPfpagoTemp 				= rsPrimerNominaDelMes.CPfpago>
        <cfset CantCalendarioMensualesAnteriores = 0>
        <cfloop condition="Continuar EQ true">
            <cfset CPfpagoTemp = DateAdd("d", 14, CPfpagoTemp)>
            <cfif DatePart("yyyy", CPfpagoTemp) EQ Arguments.CPperiodo and DatePart("m", CPfpagoTemp) EQ Arguments.CPmes>
                	<cfset CantCalendarioMensuales = CantCalendarioMensuales + 1>
                <cfif CPfpagoTemp LTE Arguments.RCdesde>
                	<cfset CantCalendarioMensualesAnteriores = CantCalendarioMensualesAnteriores + 1>
                </cfif>
            <cfelse>
                <cfset Continuar = false>
            </cfif>
        </cfloop>
        <cfif CantCalendarioMensualesAnteriores EQ 0>
        	<cfset CantCalendarioMensualesAnteriores = 1>
        </cfif>
    <cfelseif  Arguments.Ttipopago EQ 2><!---Quincenal--->
        <cfset CantCalendarioMensuales = 2>
        <cfif DatePart("m", Arguments.RCdesde) LTE 15>
        	<cfset CantCalendarioMensualesAnteriores = 1>
        <cfelse>
        	<cfset CantCalendarioMensualesAnteriores = 2>
        </cfif>
    <cfelseif  Arguments.Ttipopago EQ 3><!---Mensual--->
        <cfset CantCalendarioMensuales = 1>
        <cfset CantCalendarioMensualesAnteriores = 1>
    <cfelse>
        <cfthrow message="Frecuencia de Pago del Tipo de nomina no implementado">
    </cfif>
    <cfset StructReturn = StructNew()>
    <cfset StructInsert(StructReturn,"CantCalendarioMensuales", CantCalendarioMensuales, 1)>
    <cfset StructInsert(StructReturn,"CantCalendarioMensualesAnteriores", CantCalendarioMensualesAnteriores, 1)>
    <cfset StructInsert(StructReturn,"Factor", CantCalendarioMensuales / CantCalendarioMensualesAnteriores, 1)>

    <cfreturn StructReturn>
    </cffunction>
</cfcomponent>