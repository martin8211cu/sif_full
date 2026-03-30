<!---ljimenez funciones para el calculo de SDI, nombramiento, cambio salario, bimestral--->
<cfcomponent output="yes">

<!----------------------------------------------------------------------------->
	<cffunction name="fnSalario" access="public"  returntype="numeric">
		<cfargument name="RHAlinea" type="numeric" 	required="true">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfquery name="rsSalario" datasource="#Arguments.conexion#">
			select coalesce(DLsalario,0) as DLsalario
				from RHAcciones
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>

		<cfreturn #rsSalario.DLsalario#>
	</cffunction>
	
	<cffunction name="fnFactorDiasSalario" access="public"  returntype="numeric">
		<cfargument name="RHAlinea" type="numeric" 	required="true">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfquery name="rsFactorDiasSalario" datasource="#Arguments.conexion#">
			select coalesce(tn.FactorDiasSalario,30.4) as FactorDiasSalario
				from RHAcciones ra
				inner join TiposNomina tn
					on ra.Tcodigo = tn.Tcodigo and ra.Ecodigo = tn.Ecodigo
				where ra.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>

		<cfreturn #rsFactorDiasSalario.FactorDiasSalario#>
	</cffunction>
<!----------------------------------------------------------------------------->
	<cffunction name="SMG" access="public" returntype="numeric">
		<cfargument name="DEid" type="numeric" required="yes">
		<!--- <cfquery name="rsSQL" datasource="#session.dsn#">
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
		</cfif> --->
		<!--- Se comento debido a que el salario ya no es por zonas economicas --->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
		<cfreturn #SZEsalarioMinimo#>
	</cffunction>


	<!----------------------------------------------------------------------------->
	<cffunction name="fnValidaSDI" access="public"  returntype="numeric">
		<cfargument name="SDI" type="numeric" 	required="true">
		<cfargument name="DEid" type="numeric" 	required="true">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#"
		ecodigo="#session.Ecodigo#" pvalor="2051" default="0" returnvariable="varUMA"/>

		<cfset topeUMA = varUMA * 25>
		<!---
			<cfset vSMG 	= SMG(Arguments.DEid)>
			<cfset vTopeSDI = SMG(Arguments.DEid) * 25 >  <!--- 25 = veses Salario Minimo General para saber el monto del tope --->
 		--->

		<cfif #Arguments.SDI# GT  #topeUMA#>
			<cfset vSDI = #topeUMA#>
		<cfelse>
			<cfset vSDI = #Arguments.SDI# >
		</cfif>

		<cfreturn #vSDI#>
	</cffunction>

	<!---IRR APH funciones para el calculo de SDI, cambio salario masivo--->
	<!----------------------------------------------------------------------------->
	<cffunction name="fnSDImasivo" access="public"  returntype="numeric">
		<cfargument name="DEid" 	type="numeric" 	required="true">
		<cfargument name="RVid" 	type="numeric"	required="true">
		<cfargument name="SalarioM" type="numeric"  required="true">
		<cfargument name="Fecha" 	type="date" >
		<cfargument name="Ecodigo" 	type="numeric">
		<cfargument name="Conexion" type="string">

		<cfargument name="default"  type="string" default="0">


		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<!---<cfset Arguments.Fecha = #FechaAccion.DLfvigencia#>--->
		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#"
			ecodigo="#Arguments.Ecodigo#" pvalor="80" default="0" returnvariable="FactorDiasMensual"/>

		<cfquery datasource="#Arguments.Conexion#" name="rsDias">
			select coalesce(rv.DRVdiasgratifica,0) as DRVdiasgratifica, coalesce(rv.DRVdiasprima,0) as DRVdiasprima
				from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
				 where a.EVfantig <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
					and a.DEid = #Arguments.DEid#
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and c.DEid = #Arguments.DEid#
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#"> between c.LTdesde and c.LThasta
					and rv.RVid = c.RVid
					and rv.DRVcant = ( select coalesce(max(DRVcant),1)
										from DRegimenVacaciones rv2
										where rv2.RVid = c.RVid
										and rv2.DRVcant <= datediff(yy, a.EVfantig, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">)
									)
		</cfquery>

		<cfset DRVdiasgratifica = rsDias.DRVdiasgratifica>
		<cfset DRVdiasprima 	= rsDias.DRVdiasprima>
		<cfset Salario		 	= SalarioM>

		<cfquery datasource="#Arguments.Conexion#" name="rsDias">
			select ((#Salario# / #FactorDiasMensual#) * ((365 + #DRVdiasgratifica# + #DRVdiasprima#)/365)) as Dias
		</cfquery>
		<cfset sueldoDiario = #Salario# / #FactorDiasMensual#>
		
		<!--- OPARRALES 2019-03-07 Modificacion para complementar el calculo del SDI con Regla de Negocio para Tiendas FULL Sapiens --->
		<cfset sueldoDiario += conceptosAdicionalesSDI(Arguments.DEid)>
		
		<cfset factorInt = 365 + #DRVdiasgratifica# + #DRVdiasprima#>
        <cfset factorInt =factorInt/365>
		<cfset sub=sueldoDiario*factorInt>
		
		<!--- Modificacion para complementar el calculo del SDI --->
		<cfif Not Len(rsDias.Dias)>
			<cfreturn Arguments.default>
		</cfif>
		<cfset rSDI = fnValidaSDI(sub,Arguments.DEid)>

        <cfset vPeriodo = datepart('yyyy',#Arguments.Fecha#)>
        <cfset vMes		= datepart('m',#Arguments.Fecha#)>

        <cfswitch expression="#vMes#">
            <cfcase value = "1">  <cfset vMesRige = 11> </cfcase>
            <cfcase value = "2">  <cfset vMesRige = 11> </cfcase>
            <cfcase value = "3">  <cfset vMesRige = 1> </cfcase>
            <cfcase value = "4">  <cfset vMesRige = 1> </cfcase>
            <cfcase value = "5">  <cfset vMesRige = 3> </cfcase>
            <cfcase value = "6">  <cfset vMesRige = 3> </cfcase>
            <cfcase value = "7">  <cfset vMesRige = 5> </cfcase>
            <cfcase value = "8">  <cfset vMesRige = 5> </cfcase>
            <cfcase value = "9">  <cfset vMesRige = 7> </cfcase>
            <cfcase value = "10"> <cfset vMesRige = 7> </cfcase>
            <cfcase value = "11"> <cfset vMesRige = 9> </cfcase>
            <cfcase value = "12"> <cfset vMesRige = 9> </cfcase>
		</cfswitch>

        <!--- SML Inicio.Modificacion para considerar la variabilidad cuando no se han aplicado SDI--->

        <cfquery datasource="#Arguments.Conexion#" name="rsSDI">
			select * from RHHistoricoSDI
			where RHHfuente = 2
			and RHHmes = #vMesRige# + 2
			and RHHperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPeriodo#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>

        <cfif isdefined("rsSDI") and rsSDI.RecordCount EQ 0>
			<cfswitch expression="#vMes#">
				<cfcase value = "1">  <cfset vMesRige = 9> </cfcase>
				<cfcase value = "2">  <cfset vMesRige = 9> </cfcase>
				<cfcase value = "3">  <cfset vMesRige = 11> </cfcase>
				<cfcase value = "4">  <cfset vMesRige = 11> </cfcase>
				<cfcase value = "5">  <cfset vMesRige = 1> </cfcase>
				<cfcase value = "6">  <cfset vMesRige = 1> </cfcase>
				<cfcase value = "7">  <cfset vMesRige = 3> </cfcase>
				<cfcase value = "8">  <cfset vMesRige = 3> </cfcase>
				<cfcase value = "9">  <cfset vMesRige = 5> </cfcase>
				<cfcase value = "10"> <cfset vMesRige = 5> </cfcase>
				<cfcase value = "11"> <cfset vMesRige = 7> </cfcase>
				<cfcase value = "12"> <cfset vMesRige = 7> </cfcase>
			</cfswitch>
        	<cfif vMesRige EQ 11>
        		<cfset vPeriodo = #vPeriodo# - 1>
        	</cfif>
        <cfelseif isdefined("rsSDI") and rsSDI.RecordCount GT 0>
			<cfquery dbtype="query" name="rsSDIaplicado">
				select * from rsSDI
				where RHHaplicado = 0
			</cfquery>
            <cfif isdefined("rsSDIaplicado") and rsSDIaplicado.RecordCount GT 0>
        		<cfswitch expression="#vMes#">
        			<cfcase value = "1">  <cfset vMesRige = 9> </cfcase>
           			<cfcase value = "2">  <cfset vMesRige = 9> </cfcase>
            		<cfcase value = "3">  <cfset vMesRige = 11> </cfcase>
            		<cfcase value = "4">  <cfset vMesRige = 11> </cfcase>
            		<cfcase value = "5">  <cfset vMesRige = 1> </cfcase>
           			<cfcase value = "6">  <cfset vMesRige = 1> </cfcase>
            		<cfcase value = "7">  <cfset vMesRige = 3> </cfcase>
            		<cfcase value = "8">  <cfset vMesRige = 3> </cfcase>
            		<cfcase value = "9">  <cfset vMesRige = 5> </cfcase>
            		<cfcase value = "10"> <cfset vMesRige = 5> </cfcase>
            		<cfcase value = "11"> <cfset vMesRige = 7> </cfcase>
            		<cfcase value = "12"> <cfset vMesRige = 7> </cfcase>
        		</cfswitch>
        		<cfif vMesRige EQ 11>
        			<cfset vPeriodo = #vPeriodo# - 1>
        		</cfif>
            </cfif>
        </cfif> <!--- SML Final. Modificacion para considerar la variabilidad cuando no se han aplicado SDI--->

        <cfquery name="rsMontoIMSS" datasource="#Arguments.Conexion#">
        	select coalesce (sum(ic.ICmontores),0) as MtoIMSS
   			from HIncidenciasCalculo ic, CalendarioPagos cp, CIncidentes c
   			where ic.CIid not in  (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs on  ci.CIid = cs.CIid)
  		    and	cp.CPperiodo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">
   			and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_integer" value="#vMesRige#"> , <cfqueryparam cfsqltype="cf_sql_integer" value="#vMesRige#"> +1)
   			and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   			and ic.RCNid = cp.CPid
   			and c.CIafectaSBC = 1
   			and ic.CIid = c.CIid
   			and  ic.DEid = #Arguments.DEid#
        </cfquery>

        <cfquery name="rsDiasLab" datasource="#Arguments.Conexion#">
        	select coalesce(sum(b.PEcantdias),0)as DiasBimestreLabor
                        from HPagosEmpleado b
                            inner join RHTipoAccion c
                              on c.RHTid = b.RHTid
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0
                                and d.CPmes	in  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vMesRige#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMesRige#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPeriodo#">
                        where b.DEid = #Arguments.DEid#
                            and c.RHTcomportam not in (5,13) <!--- Incapacidad, Ausencia / Falta--->
                            and b.PEtiporeg = 0	 	<!--- Tipo de Registro: 0 :Normal --->
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <cfif rsDiasLab.DiasBimestreLabor NEQ 0>
        <cfset montoGravado = rsMontoIMSS.MtoIMSS/rsDiasLab.DiasBimestreLabor>
        <cfelse>
        <cfset montoGravado = 0>
        </cfif>
        		<!---<cfthrow message = "Salario=#Salario# #FactorDiasMensual# sueldoDiario=#sueldoDiario# X factorInt=#factorInt# = #sub# gratifica=#DRVdiasgratifica# prima=#DRVdiasprima#  #rsDias.Dias# rsdI=#rSDI# montogravado= #montoGravado# #rsMontoIMSS.MtoIMSS#  #rsDiasLab.DiasBimestreLabor# ">--->

        <cfset rSDI = rSDI + montoGravado>
         <!---<cfthrow message="#DEid# Salario: #Salario#, FactorDiasMensual #FactorDiasMensual#, diasPrima #DRVdiasprima#, diasGratifica #DRVdiasgratifica# rsDias #rsDias.Dias#, rSDI #rSDI# #vMes# #vPeriodo# #montoGravado# #rsMontoIMSS.MtoIMSS# #rsDiasLab.DiasBimestreLabor#">    --->
		<cfset DRVdiasgratifica = 0>
		<cfset DRVdiasprima 	= 0>
		<cfset Salario		 	= 0>
        <cfset sueldoDiario 	= 0>
        <cfset factorInt 		= 0>
		<cfset sub				= 0>
		
        <!---IRR APH, guarda en bitacora de SDI --->
        <cfinvoke component="rh.Componentes.RH_CalculoSDI_Historico" method="AddBitacoraSDI" returnvariable="AddBitacoraSDI">
            <cfinvokeargument name="DEid" 			value="#Arguments.DEid#"/>
            <cfinvokeargument name="Fecha" 			value="#Arguments.Fecha#"/>
            <cfinvokeargument name="RHHmonto" 		value="#rSDI#"/>
            <cfinvokeargument name="RHHfuente" 		value="1"/>
            <cfinvokeargument name="Periodo"		value="#vPeriodo#"/>
            <cfinvokeargument name="Mes"			value="#vMes#"/>
        </cfinvoke>

		<cfreturn #rSDI#>
	</cffunction>
	
	<cffunction name="fnSDI" access="public"  returntype="numeric">
		<cfargument name="DEid" 	type="numeric" 	required="true">
		<cfargument name="RVid" 	type="numeric"	required="true">
		<cfargument name="RHAlinea" type="numeric"  required="true">
		<cfargument name="Fecha" 	type="date" >
		<cfargument name="Ecodigo" 	type="numeric">
		<cfargument name="Conexion" type="string">

		<cfargument name="default"  type="string" default="0">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

		<cfif not isdefined('Arguments.Fecha')>
			<cfquery datasource="#Arguments.Conexion#" name="FechaAccion">
				select DLfvigencia
				from RHAcciones
				Where RHAlinea =#Arguments.RHAlinea#
			</cfquery>

			<cfset Arguments.Fecha = #FechaAccion.DLfvigencia#>
		</cfif>

		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#"
			ecodigo="#Arguments.Ecodigo#" pvalor="80" default="0" returnvariable="FactorDiasMensual"/>

		<cfquery datasource="#Arguments.Conexion#" name="rsDias">
			select coalesce(rv.DRVdiasgratifica,0) as DRVdiasgratifica, coalesce(rv.DRVdiasprima,0) as DRVdiasprima
				from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
				 where a.EVfantig <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
					and a.DEid = #Arguments.DEid#
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and c.DEid = #Arguments.DEid#
					and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#"> between c.LTdesde and c.LThasta
					and rv.RVid = c.RVid

					and rv.DRVcant = ( select coalesce(max(DRVcant),1)
										from DRegimenVacaciones rv2
										where rv2.RVid = c.RVid
										and rv2.DRVcant <= datediff(yy, a.EVfantig, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">)
									)
		</cfquery>

		<cfset DRVdiasgratifica = rsDias.DRVdiasgratifica>
		<cfset DRVdiasprima 	= rsDias.DRVdiasprima>
		<cfset Salario		 	= fnSalario(Arguments.RHAlinea)>

		<cfquery datasource="#Arguments.Conexion#" name="rsDias">
			select ((#Salario# / #FactorDiasMensual#) * ((365 + #DRVdiasgratifica# + #DRVdiasprima#)/365)) as Dias
		</cfquery>

		<cfif Not Len(rsDias.Dias)>
			<cfreturn Arguments.default>
		</cfif>
		<cfset rSDI = fnValidaSDI(rsDias.Dias,Arguments.DEid)>
		<!--- <cfthrow message="#rSDI#">--->
        <cfset vPeriodo = datepart('yyyy',#Arguments.Fecha#)>
        <cfset vMes		= datepart('m',#Arguments.Fecha#)>

        <!---- Aqui   realiza  los calculos del SDI + el Moto Gravado para Aumentos IRR-APH 310712 --->
        	<!---salarioDI= salario * factor Integracion + --->
		<cfswitch expression="#vMes#">
            <cfcase value = "1">  <cfset vMesRige = 11> </cfcase>
            <cfcase value = "2">  <cfset vMesRige = 11> </cfcase>
            <cfcase value = "3">  <cfset vMesRige = 1> </cfcase>
            <cfcase value = "4">  <cfset vMesRige = 1> </cfcase>
            <cfcase value = "5">  <cfset vMesRige = 3> </cfcase>
            <cfcase value = "6">  <cfset vMesRige = 3> </cfcase>
            <cfcase value = "7">  <cfset vMesRige = 5> </cfcase>
            <cfcase value = "8">  <cfset vMesRige = 5> </cfcase>
            <cfcase value = "9">  <cfset vMesRige = 7> </cfcase>
            <cfcase value = "10"> <cfset vMesRige = 7> </cfcase>
            <cfcase value = "11"> <cfset vMesRige = 9> </cfcase>
            <cfcase value = "12"> <cfset vMesRige = 9> </cfcase>
		</cfswitch>
        <cfquery name="rsMontoIMSS" datasource="#Arguments.Conexion#">
        	select coalesce (sum(ic.ICmontores),0) as MtoIMSS
   			from HIncidenciasCalculo ic, CalendarioPagos cp, CIncidentes c
   			where ic.CIid not in  (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs on  ci.CIid = cs.CIid)
  		    and	cp.CPperiodo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPeriodo#">
   			and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vMesRige#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMesRige#"> +1)
   			and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
   			and ic.RCNid = cp.CPid
   			and c.CIafectaSBC = 1
   			and ic.CIid = c.CIid
   			and  ic.DEid = #Arguments.DEid#
        </cfquery>

        <cfquery name="rsDiasLab" datasource="#Arguments.Conexion#">
        	select coalesce(sum(b.PEcantdias),0)as DiasBimestreLabor
                        from HPagosEmpleado b
                            inner join RHTipoAccion c
                              on c.RHTid = b.RHTid
                            inner join CalendarioPagos d
                                on b.RCNid = d.CPid
                                and CPtipo = 0
                                and d.CPmes	in  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#vMesRige#"> , <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMesRige#"> +1)
                                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPeriodo#">
                        where b.DEid = #Arguments.DEid#
                            and c.RHTcomportam not in (5,13)-- <!--- Incapacidad, Ausencia / Falta--->
                            and b.PEtiporeg = 0	 	--<!--- Tipo de Registro: 0 :Normal --->
                            and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        </cfquery>
        <!---<cfset montoGravado = rsMontoIMSS.MtoIMSS/rsDiasLab.DiasBimestreLabor>--->
        <cfif rsDiasLab.DiasBimestreLabor NEQ 0>
        <cfset montoGravado = rsMontoIMSS.MtoIMSS/rsDiasLab.DiasBimestreLabor>
        <cfelse>
        <cfset montoGravado = 0>
        </cfif>
        <cfset rSDI = rSDI + montoGravado>
		
		<!--- 
			<cfthrow message="Salario: #Salario#, FactorDiasMensual #FactorDiasMensual#, diasPrima #DRVdiasprima#, diasGratifica #DRVdiasgratifica# rsDias #rsDias.Dias#, rSDI #rSDI# #vMes# #vPeriodo# #rsMontoIMSS.MtoIMSS# #rsDiasLab.DiasBimestreLabor#">
         --->
        <!---ljimenez, guarda en bitacora de SDI --->
        <cfinvoke component="rh.Componentes.RH_CalculoSDI_Historico" method="AddBitacoraSDI" returnvariable="AddBitacoraSDI">
            <cfinvokeargument name="DEid" 			value="#Arguments.DEid#"/>
            <cfinvokeargument name="Fecha" 			value="#Arguments.Fecha#"/>
            <cfinvokeargument name="RHHmonto" 		value="#rSDI#"/>
            <cfinvokeargument name="RHHfuente" 		value="1"/>
            <cfinvokeargument name="Periodo"		value="#vPeriodo#"/>
            <cfinvokeargument name="Mes"			value="#vMes#"/>
        </cfinvoke>

		<cfreturn #rSDI#>
	</cffunction>

    <!---ljimenez Calculo de SDI al momento del Nombramiento de un empleado--->
<!----------------------------------------------------------------------------->
	<cffunction name="fnSDINombramiento" access="public"  returntype="numeric">
		<cfargument name="DEid" 	type="numeric" 	required="true">
		<cfargument name="RVid" 	type="numeric"	required="true">
		<cfargument name="RHAlinea" type="numeric"  required="true">
		<cfargument name="Fecha" 	type="date" >
		<cfargument name="Ecodigo" 	type="numeric">
		<cfargument name="Conexion" type="string">
		<cfargument name="default"  type="string" default="0">
        <cfargument name="RHTcomportam" type = "numeric" default="0"> <!---SML. Modificacion para que cuando se de alta a un trabajador en el bimestre anterior y ya se Calcularon SDI, considere el bimestre actual--->

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>

		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#"
			ecodigo="#Arguments.Ecodigo#" pvalor="80" default="0" returnvariable="FactorDiasMensual"/>

		<!--- Obtenemos la ultima fecha de nombramiento para calcular antiguedad--->
		<cfquery name="rsFechaAlta" datasource="#Arguments.Conexion#">
			select top 1 dle.DLfvigencia from DLaboralesEmpleado dle inner join RHTipoAccion ta
			on ta.RHTid = dle.RHTid and RHTcomportam = 1
			and dle.DEid = #Arguments.DEid#
			order by dle.DLfvigencia desc
		</cfquery>
		
		<cfif rsFechaAlta.RecordCount gt 0 and Arguments.RHTcomportam NEQ 6>
			<cfset Arguments.Fecha = rsFechaAlta.DLfvigencia>
		</cfif>

        <cfset anno = DateDiff('yyyy', Arguments.Fecha, now())> <!---SML. Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta--->
		<cfquery datasource="#Arguments.Conexion#" name="rsDias">
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
			where r.Ecodigo = #Arguments.Ecodigo#
				and r.RVid = #Arguments.RVid#
		</cfquery>
		<cfif not len(trim(rsDias.DRVdiasgratifica)) or not len(trim(rsDias.DRVdiasprima))>
        	<cfthrow message="No existe los detalles de regimen definidos">
        </cfif>

		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#"
			ecodigo="#Arguments.Ecodigo#" pvalor="2052" default="0" returnvariable="varDiasAguinaldo"/>

		<cfset DRVdiasgratifica = rsDias.DRVdiasgratifica>
		<cfset DRVdiasprima 	= rsDias.DRVdiasprima>
		<cfset Salario		 	= fnSalario(Arguments.RHAlinea)>
		<cfset FactorDiasMensual = fnFactorDiasSalario(Arguments.RHAlinea)>

		<!---SML. Inicio Modificacion para que realice correctamente el calculo de SDI--->
		<cfset pVacacional	= (rsDias.DRVdiasprima)><!--- Este monto se debe de ingresar ya calculado es el 25% de dias de vacaciones --->
		<cfset factorDias = LSNumberFormat(((365 + #varDiasAguinaldo# + #pVacacional#)/365),'9.0000')><!--- Factor de Integracion --->
		<cfset salarioDiario = (#Salario# / #FactorDiasMensual#)>
		<cfset salarioDiario += conceptosAdicionalesSDI(Arguments.DEid,true,Arguments.RHAlinea)>
		<cfset rsDias = (#salarioDiario# * #factorDias#)>

        <cfif Not Len(rsDias)>
			<cfreturn Arguments.default>
		</cfif>
		<cfset rSDI = fnValidaSDI(rsDias,Arguments.DEid)>

		<cfset vPeriodo = datepart('yyyy',#Arguments.Fecha#)>
        <cfset vMes		= datepart('m',#Arguments.Fecha#)>
		
		<cfset fuente	= Arguments.RHTcomportam eq 6 ? 4 : Arguments.RHTcomportam eq 1 ? 1 : 0 >
		<!---
			fuente:
				0 indefinido
				1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento (Comportamiento = 1)
				2 Manual (SDI Bimestral)
				3 SDI por Aniversario
				4 Accion de Aumento (comportamiento = 6)
		 --->
		<cfset rSDI = LSNumberFormat(rSDI,'9.0000')>
		
		<!---ljimenez, guarda en bitacora de SDI --->
		<cfinvoke component="rh.Componentes.RH_CalculoSDI_Historico" method="AddBitacoraSDI" returnvariable="AddBitacoraSDI">
        	<cfinvokeargument name="DEid" 		value="#Arguments.DEid#"/>
            <cfinvokeargument name="Fecha" 		value="#Arguments.Fecha#"/>
            <cfinvokeargument name="RHHmonto" 	value="#rSDI#"/>
            <cfinvokeargument name="RHHfuente" 	value="#fuente#"/>
            <cfinvokeargument name="Periodo"	value="#vPeriodo#"/>
            <cfinvokeargument name="Mes"		value="#vMes#"/>
            <cfinvokeargument name="RHTcomportam" value="#Arguments.RHTcomportam#"/><!---SML. Modificacion para que cuando se de alta a un trabajador en el bimestre anterior y ya se Calcularon SDI, considere el bimestre actual--->
		</cfinvoke>
		
		<cfreturn #rSDI#>
	</cffunction>

<!----------------------------------------------------------------------------->

	<cffunction name="fnVerifica" access="public"  returntype="query">
		<cfargument name="Fecha" 	type="date"  required="yes">
        <cfargument name="Bimestre" type="numeric"  required="yes">
        <cfargument name="BimestreRige" type="numeric"  required="yes">
		<cfargument name="Ecodigo" 	type="numeric">
		<cfargument name="Conexion" type="string">


		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>

		<!---<cfset fechacalculo = dateadd('d',-1,#Arguments.Fecha#)>--->

        <cfset fechacalculo = #Arguments.Fecha#>

        <cfset periodo = #year(fechacalculo)#> <!---SML. Modificacion para tomar en cuenta el a�o que va a regir el bimestre.--->

        <cfquery name="rsHSDI" datasource="#Arguments.Conexion#">
        	select count(1) as existen
            from RHHistoricoSDI
			where Bimestrerige = #Arguments.Bimestrerige#
            and RHHfuente = 2
			and Ecodigo = #session.Ecodigo#
            and RHHperiodo = #periodo# <!---SML. Modificacion para tomar en cuenta el a�o que va a regir el bimestre.--->
        </cfquery>


        <cfif isdefined('rsHSDI') and rsHSDI.existen EQ 0>
            <cfquery name="rsVerifica" datasource="#Arguments.Conexion#">
                select case #Arguments.BimestreRige#
                            when 1  then 'TRUE'
                            when 2  then 'TRUE'
                            when 3  then 'TRUE'
                            when 4  then 'TRUE'
                            when 5  then 'TRUE'
                            when 6  then 'TRUE'
                        else 'FALSE'
                        end as Aplica,

                        case #Arguments.Bimestre#
                            when 12 then <cf_dbfunction name="date_part" args="yyyy, #fechacalculo#"> -1
                        else
                            <cf_dbfunction name="date_part"	args="yyyy, #fechacalculo#">
                        end as Periodo,
                        case #Arguments.BimestreRige#
                            when 1  then 11
                            when 2  then 1
                            when 3  then 3
                            when 4  then 5
                            when 5  then 7
                            when 6  then 9
                        end as Mes
                       <!--- #Arguments.Bimestre# as Mes--->
                        , <cf_dbfunction name="date_part"	args="mm, #fechacalculo#"> as MesCalculo
                        , <cf_dbfunction name="date_part"	args="yyyy, #fechacalculo#"> as PeriodoCalculo

            </cfquery>
        <cfelse>
	       	<cfquery name="rsVerifica" datasource="#Arguments.Conexion#">
				select 'false' as Aplica
			</cfquery>
        </cfif>

		<cfreturn #rsVerifica#>
	</cffunction>
<!----------------------------------------------------------------------------->
	<cffunction name="rsUpdateSDI" access="public"  returntype="query">
		<cfargument name="Fecha" 		type="date"  	required="yes">
		<cfargument name="FechaCalculo" type="date"  	required="yes">
		<cfargument name="Periodo" 		type="numeric" 	required="yes">
		<cfargument name="Mes" 			type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">


		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
		<cfif not isdefined('Arguments.Fecha')>
			<cfset Arguments.Fecha = now()>
		</cfif>


		<cfinvoke component="RHParametros" method="get" datasource="#Arguments.Conexion#"
			ecodigo="#Arguments.Ecodigo#" pvalor="80" default="0" returnvariable="FactorDiasMensual"/>



		<!---NOTA: ver pagina 67-68-72 del Libro Estudio Integral de la Nomina--->
		<cfquery name="rsUpdateSDI" datasource="#Arguments.Conexion#">
			select de.DEid, de.DEsdi,lt.LTsalario,
				( coalesce((select coalesce(sm.SZEsalarioMinimo,0)
					from DatosEmpleado d1
					inner join ZonasEconomicas ze
						on d1.ZEid = ze.ZEid
					inner join SalarioMinimoZona sm
						on ze.ZEid = sm.ZEid
						and sm.SZEestado = 1
					where  d1.DEid = de.DEid
						and sm.SZEhasta  = (select max(s.SZEhasta)
											from DatosEmpleado d
												inner join ZonasEconomicas z
													on d.ZEid = z.ZEid
												inner join SalarioMinimoZona s
													on z.ZEid = s.ZEid
													and s.SZEestado = 1)
					),0) * 25) as TopeSMG,


					<!---Salario Diario--->
					((lt.LTsalario/#FactorDiasMensual#) *

					<!---Dias de Gratificacion--->
					((365 + coalesce((select rv.DRVdiasgratifica
										from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
										 where a.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
											and a.DEid = de.DEid
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
											and c.DEid = de.DEid

											and c.LTdesde <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
											and c.LThasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
											and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#"> between c.LTdesde and c.LThasta
											and rv.RVid = c.RVid

											and rv.DRVcant = ( select coalesce(max(DRVcant),1)
																from DRegimenVacaciones rv2
																where rv2.RVid = c.RVid
																and rv2.DRVcant <= datediff(yy, a.EVfantig,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">)
															)),0)
					   +
					   <!---Dias de Prima (Prima vacaional)--->
					   coalesce((select rv.DRVdiasprima
									from EVacacionesEmpleado a, LineaTiempo c, DRegimenVacaciones rv
									 where a.EVfantig < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
										and a.DEid = de.DEid
										and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
										and c.DEid = de.DEid

										and c.LTdesde <  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
										and c.LThasta >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
										and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#"> between c.LTdesde and c.LThasta
										and rv.RVid = c.RVid

										and rv.DRVcant = ( select coalesce(max(DRVcant),1)
															from DRegimenVacaciones rv2
															where rv2.RVid = c.RVid
															and rv2.DRVcant <= datediff(yy, a.EVfantig,  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">)
														)),0))
					   / 365))
					   +
					   <!---Calculo de la parte variable, monto por incidencias --->
						((coalesce((select sum(ic.ICmontores)
										from HIncidenciasCalculo ic, CalendarioPagos cp
										where ic.CIid not in  (select  cs.CIid from  CIncidentes ci inner join ComponentesSalariales cs
																				on  ci.CIid = cs.CIid
																			where  ci.CIafectaSBC = 1)
											and	cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
											and cp.CPmes in (<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">-1,<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">)
										and cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
										and ic.RCNid = cp.CPid
										and de.DEid = ic.DEid),0)/

										<cf_dbfunction name="datediff" args="#Arguments.FechaCalculo#, #Arguments.Fecha#,DD">))  as nuevo
										<!---,<cf_dbfunction name="datediff" args="#Arguments.FechaCalculo#, #Arguments.Fecha#,DD"> as dias--->

					from DatosEmpleado de
						inner join LineaTiempo lt
							on de.DEid = lt.DEid
							and lt.LTdesde < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">
							and lt.LThasta > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha#">

					where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfreturn #rsUpdateSDI#>
	</cffunction>



    <cffunction name="fnDiasBimestre" access="public"  returntype="numeric">
		<cfargument name="CPmes" 		type="numeric"  required="yes">
        <cfargument name="CPperiodo" 	type="numeric"  required="yes">
        <cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">

        <cfset vDiasBimestre = 0>

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>

        <cfswitch expression="#Arguments.CPmes mod 2#">
            <cfcase value="1">
				<cfset vFecha1 = createdate(#Arguments.CPperiodo#,#Arguments.CPmes#,01)>
                <cfset vFecha2 = createdate(#Arguments.CPperiodo#,#Arguments.CPmes#+1,01)>
            </cfcase>

            <cfcase value="0">
				<cfset vFecha1 = createdate(#Arguments.CPperiodo#,#Arguments.CPmes#-1,01)>
                <cfset vFecha2 = createdate(#Arguments.CPperiodo#,#Arguments.CPmes#,01)>
            </cfcase>

            <cfdefaultcase>
            	<cfset vFecha1 = now()>
				<cfset vFecha2 = now()>
			</cfdefaultcase>
        </cfswitch>
        <cfset vDiasBimestre = DaysInMonth(#vFecha1#) + DaysInMonth(#vFecha2#)>
        <cfreturn #vDiasBimestre#>
	</cffunction>

    <cffunction name="fnCalBimestre" access="public"  returntype="numeric">
		<cfargument name="CPmes" 		type="numeric"  required="yes">
        <cfargument name="CPperiodo" 	type="numeric"  required="yes">
        <cfargument name="Tcodigo" 		type="numeric"  required="yes">
        <cfargument name="Ecodigo" 		type="numeric">
		<cfargument name="Conexion" 	type="string">

		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = "#session.Ecodigo#">
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = "#session.dsn#">
		</cfif>
	    <cfset vCalendariosBimestre = 0>

        <cfswitch expression="#Arguments.CPmes mod 2#">
            <cfcase value="1">
                <cfquery name="rsCantPeriodos" datasource="#session.dsn#">
                    select count(1) as Periodos
                        from CalendarioPagos
                        where CPperiodo = #Arguments.CPperiodo#
                            and CPmes >= #Arguments.CPmes#
                            and CPmes <= #Arguments.CPmes#+1
                            and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
                            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            and CPtipo = 0
                        group by CPperiodo
                </cfquery>
            </cfcase>

            <cfcase value="0">
				<cfquery name="rsCantPeriodos" datasource="#session.dsn#">
                    select count(1) as Periodos
                        from CalendarioPagos
                        where CPperiodo = #Arguments.CPperiodo#
                            and CPmes >= #Arguments.CPmes#-1
                            and CPmes <= #Arguments.CPmes#
                            and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tcodigo#">
                            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            and CPtipo = 0
                        group by CPperiodo
                </cfquery>
            </cfcase>

            <cfdefaultcase>
            	<cfquery name="rsCantPeriodos" datasource="#session.dsn#">
                    select 0 as Periodos
                </cfquery>
			</cfdefaultcase>
        </cfswitch>
        <cfset vCalendariosBimestre = #rsCantPeriodos.Periodos#>
        <cfreturn #vCalendariosBimestre#>
	</cffunction>

	<cffunction  name="conceptosAdicionalesSDI" access="public" returntype="numeric">
		<cfargument name="DEid" 		type="numeric" 	required="true">
		<cfargument name="EsAlta"		type="boolean"	required="false" default="false">
		<cfargument name="RHAlinea" 	type="numeric" 	required="false">

		<cfset varMontoSumFactor = 0>
		
		<cfquery name="rsHorasExtras" datasource="#session.dsn#">
			select 
				HE2,
				HE3,
				<cfif Arguments.EsAlta>
					dd.RHDAmontores DLsalario,
				<cfelse>
					lt.DLsalario,
				</cfif>
				lt.RHJid,
				lt.Tcodigo,
				(select Ttipopago from TiposNomina where Tcodigo = lt.Tcodigo and Ecodigo = lt.Ecodigo) Ttipopago,
				(select RHJhoradiaria from RHJornadas where RHJid = lt.RHJid) horas,
				(select FactorDiasIMSS from TiposNomina where Tcodigo = lt.Tcodigo and Ecodigo = lt.Ecodigo) factorDias
			from
				DatosEmpleado de
				<cfif EsAlta>
					INNER JOIN RHacciones lt 
						ON de.DEid = lt.DEid
						AND lt.Ecodigo = de.Ecodigo
					inner join RHDAcciones dd
						on dd.RHAlinea = lt.RHAlinea
				<cfelse>
					inner join
						DLaboralesEmpleado lt
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
				</cfif>
			inner join RHPlazas p
				on lt.RHPid = p.RHPid
				and lt.Ecodigo = p.Ecodigo
			inner join RHPuestos pu
				on pu.RHPcodigo = lt.RHPcodigo
				and pu.Ecodigo = lt.Ecodigo
			where de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			<cfif EsAlta>
				and lt.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
			</cfif>
		</cfquery>

		<cfset varCodigo = 0>
		<cfif rsHorasExtras.Ttipopago eq 0>
			<cfset varCodigo = 40>
		<cfelseif rsHorasExtras.Ttipopago eq 1>
			<cfset varCodigo = 50>
		<cfelseif rsHorasExtras.Ttipopago eq 2>
			<cfset varCodigo = 60>
		<cfelse>
			<cfset varCodigo = 70>
		</cfif>

		<cfset varDLsalario = rsHorasExtras.DLsalario>
		<cfif Arguments.EsAlta>
			<cfset varDLsalario = fnSalario(Arguments.RHAlinea)>
		</cfif>
		<cfset varDLsalario = LSNumberFormat(rsHorasExtras.DLsalario,'9.0000')>
		
		<cfquery name="rsDiasTN" datasource="#session.dsn#">
			select Pvalor 
			from RHParametros 
			where Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCodigo#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfset factorHE2 = 0>
		<cfset factorHE3 = 0>

		<cfif rsHorasExtras.HE2 gt 0>
			<cfset factorHE2 = LSNumberFormat(((((varDLsalario / rsHorasExtras.factorDias) / rsHorasExtras.horas)  * 2) * rsHorasExtras.HE2) / rsDiasTN.Pvalor,'9.0000')>
		</cfif>
		
		<cfif rsHorasExtras.HE3 gt 0>
			<cfset factorHE3 = LSNumberFormat(((((varDLsalario / rsHorasExtras.factorDias) / rsHorasExtras.horas)  * 3) * rsHorasExtras.HE3) / rsDiasTN.Pvalor,'9.000')>
		</cfif>
		
		<cfset varMontoSumFactor += factorHE2>
		<cfset varMontoSumFactor += factorHE3>

		<cfset varMontoProd = 0>
		<cfquery name="rsMontoProd" datasource="#session.dsn#">
			select DEdato3, DEdato5 
			from DatosEmpleado 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		</cfquery>

		<cfif IsNumeric(rsMontoProd.DEdato3)>
			<cfset varMontoSumFactor += rsMontoProd.DEdato3>
		</cfif>
		
		<cfif IsNumeric(rsMontoProd.DEdato5)>
			<cfset varMontoSumFactor += rsMontoProd.DEdato5>
		</cfif>
		
		<cfreturn LSNumberFormat(varMontoSumFactor,'9.00')>
	</cffunction>
</cfcomponent>
