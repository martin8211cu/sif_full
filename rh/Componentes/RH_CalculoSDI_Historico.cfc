<!---CarolRS Bitacora.--->
<cfcomponent>
	<cffunction name="AddBitacoraSDI" access="public">
		<cfargument name="DEid" 		type="numeric"	required="true"/>
		<cfargument name="Fecha" 		type="date"		required="true"/>
		<cfargument name="BMFecha" 		type="date"		default="#now()#"/>
		<cfargument name="RHHmonto" 	type="numeric"	required="true"/>
		<cfargument name="RHHfuente" 	type="numeric"	default="1"/>			<!---0=indefinido, 1=Automatico (Cuando se da un cambio de salario), 2=Manual (Genera por medio de proceso)--->
		<cfargument name="Periodo"		type="numeric"	required="true"/>
		<cfargument name="Mes"			type="numeric"	required="true"/>
		<cfargument name="usuario"		type="numeric"	default="#session.Usucodigo#"/>
		<cfargument name="Ecodigo"		type="numeric"	default="#session.Ecodigo#"/>
		<cfargument name="DSN"			type="string"	default="#session.DSN#"/>
        <cfargument name="RHTcomportam" type = "numeric" default="0"> <!---SML. Modificacion para que cuando se de alta a un trabajador en el bimestre anterior y ya se Calcularon SDI, considere el bimestre actual--->

         <cfswitch expression="#Arguments.Mes#">
            <cfcase value = "1">  <cfset vBimestreRige = 1> </cfcase>
            <cfcase value = "2">  <cfset vBimestreRige = 1> </cfcase>
            <cfcase value = "3">  <cfset vBimestreRige = 2> </cfcase>
            <cfcase value = "4">  <cfset vBimestreRige = 2> </cfcase>
            <cfcase value = "5">  <cfset vBimestreRige = 3> </cfcase>
            <cfcase value = "6">  <cfset vBimestreRige = 3> </cfcase>
            <cfcase value = "7">  <cfset vBimestreRige = 4> </cfcase>
            <cfcase value = "8">  <cfset vBimestreRige = 4> </cfcase>
            <cfcase value = "9">  <cfset vBimestreRige = 5> </cfcase>
            <cfcase value = "10"> <cfset vBimestreRige = 5> </cfcase>
            <cfcase value = "11"> <cfset vBimestreRige = 6> </cfcase>
            <cfcase value = "12"> <cfset vBimestreRige = 6> </cfcase>
		</cfswitch>
        <!---SML. Inicio Modificacion para que cuando se de alta a un trabajador en el bimestre anterior y ya se Calcularon SDI, considere el bimestre actual--->
        <cfif isdefined('RHTcomportam') and RHTcomportam EQ 1>
            <cfquery name="rsValidarBimestrePosterior" datasource="#session.DSN#">
        		select COUNT(1) as cantidad from RHHistoricoSDI
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Bimestrerige = <cfqueryparam cfsqltype="cf_sql_integer" value="#vBimestreRige#"> + 1
					and RHHperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
                    and RHHfuente = 2
        	</cfquery>

        	<cfif isdefined('rsValidarBimestrePosterior') and rsValidarBimestrePosterior.cantidad GT 0>
        		<cfset vBimestreRige = vBimestreRige + 1>
        	</cfif>
        </cfif>
        <!---SML. Final Modificacion para que cuando se de alta a un trabajador en el bimestre anterior y ya se Calcularon SDI, considere el bimestre actual--->
        <!---
			fuente:
				0 indefinido
				1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento
				2 Manual (SDI Bimestral)
				3 SDI por Aniversario
				4 Accion de Aumento (comportamiento = 6)
		 --->
		<cfquery name="rsInsert" datasource="#Arguments.DSN#">
			insert into RHHistoricoSDI (DEid,RHHmonto,RHHfecha,RHHperiodo,RHHmes,RHHfuente,Ecodigo,BMUsucodigo,BMfecha, Bimestrerige, RHHaplicado)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_money" 		value="#Arguments.RHHmonto#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.Fecha#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.periodo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.mes#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Arguments.RHHfuente#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.usuario#">,
				<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.BMFecha#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#vBimestreRige#">,
                <cfif Arguments.RHHfuente NEQ 2> 1 <cfelse> 0 </cfif>
				)
		</cfquery>
		<cfreturn>
	</cffunction>


	<cffunction name="ConsultaBitacoraSDI" access="public" returntype="query">
		<cfargument name="DEid" 		type="numeric"	required="false"/>
		<cfargument name="Periodo"		type="numeric"	required="true"/>
		<cfargument name="Mes"			type="numeric"	required="true"/>
        <cfargument name="Fuente"		type="numeric"	default="2"/>
		<cfargument name="Ecodigo"		type="numeric"	default="#session.Ecodigo#"/>
		<cfargument name="DSN"			type="string"	default="#session.DSN#"/>

	<cfquery name="rsSelect" datasource="#Arguments.DSN#">
        	select *
            from RHHistoricoSDI
            where RHHperiodo	= #Arguments.periodo#
            	and RHHmes 		= #Arguments.mes#
                and Ecodigo 	= #session.Ecodigo#
                and RHHfuente	= #Arguments.fuente#
                <cfif isdefined('Arguments.DEid')>
                	and DEid = #Arguments.DEid#
                </cfif>
		</cfquery>
		<cfreturn #rsSelect#>
	</cffunction>


</cfcomponent>

