<cfcomponent extends="base">
	<cffunction name="comision" access="public" returntype="void" output="false">
		<cfargument name="origen" type="string" required="yes">
		<cfargument name="cedula_agente" type="string" required="yes">
		<cfargument name="cuenta_siic_cliente" type="string" required="yes">
		<cfargument name="login" type="string" required="yes">
		<cfargument name="paquete" type="string" required="yes">
		<cfargument name="comision_pagada" type="numeric" required="yes">
		<cfargument name="comision_original" type="numeric" required="yes">
		<cfargument name="tipo_de_cambio" type="numeric" required="yes">
		<cfargument name="periodo" type="string" required="yes" hint="Fecha en yyyyMMdd">
		<cfargument name="observacion" type="string" required="yes">
		<cfargument name="moneda" type="string" required="yes">
		<cfargument name="S02CON" type="numeric" required="yes" default="0">
		
		<cfset control_inicio( Arguments, 'H043', Arguments.login )>
		<cftry>
			<cfset validarOrigen(Arguments.origen)>

			<cfset LGnumero = getLGnumero(Arguments.login)>
			<cfset sdfDatetime2 = CreateObject("java", "java.text.SimpleDateFormat").init('yyyyMMdd')>
			<cfset periodo_date = sdfDatetime2.parse(Arguments.periodo)>
			
			<cfquery datasource="#session.dsn#" name="buscar_agente_q">
				select a.AGid
				from ISBagente a
					join ISBpersona p
						on p.Pquien = a.Pquien
				where p.Pid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cedula_agente#">
			</cfquery>
			<cfif buscar_agente_q.RecordCount is 0>
				<cfthrow message="No hay ningún agente con la cédula #Arguments.cedula_agente#" errorcode="ISB-0029">
			</cfif>
			
			<cfquery datasource="#session.dsn#">
				update ISBproducto
				set CNmontoPag = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.comision_pagada#">,
					CNmontoOri = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.comision_original#">,
					CNtipocambio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipo_de_cambio#">,
					CNperiodo = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#periodo_date#">
				where Contratoid =
					(	select l.Contratoid
						from ISBlogin l
						where l.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LGnumero#">
					)
			</cfquery>
			
			<cfinvoke component="SSXS02" method="Cumplimiento"
				S02CON="#Arguments.S02CON#"
				EnviarHistorico="true"
				EnviarCumplimiento="false"/>
			<cfset control_final( )>
		<cfcatch type="any">
			<!--- cumplimiento / error --->
			<cfset control_catch( cfcatch )>
			<cfinvoke component="SSXS02" method="Error"
				S02CON="#Arguments.S02CON#" 
				Error="#Request._saci_intf.Error#"/>
		</cfcatch>
		</cftry>

	</cffunction>
</cfcomponent>