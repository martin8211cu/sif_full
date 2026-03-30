<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBtareaProgramada">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TPid" type="numeric" required="Yes"  displayname="Confsecutivo tarea">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="Contratoid" type="string" required="No"  displayname="Identificador contrato">
  <cfargument name="LGnumero" type="numeric" required="No"  displayname="Login id">
  <cfargument name="TPinsercion" type="date" required="Yes"  displayname="Fecha insercion">
  <cfargument name="TPfecha" type="date" required="Yes"  displayname="Fecha programada">
  <cfargument name="TPfechaReal" type="string" required="No"  displayname="Fecha ejecución real">
  <cfargument name="TPdescripcion" type="string" required="Yes"  displayname="Descripcion">
  <cfargument name="TPxml" type="string" required="Yes"  displayname="Texto XML">
  <cfargument name="TPestado" type="string" required="Yes"  displayname="Estado de Tarea">
  <cfargument name="TPtipo" type="string" required="Yes"  displayname="Tipo de Tarea">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">
  <cfargument name="TPorigen" type="string" required="No" default="SACI"  displayname="origen de la tarea Programada">

	<cfif isdefined("Arguments.ts_rversion")and len(trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
		table="ISBtareaProgramada"
		redirect="metadata.code.cfm"
		timestamp="#Arguments.ts_rversion#"
		field1="TPid"
		type1="numeric"
		value1="#Arguments.TPid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBtareaProgramada
		set CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
		, Contratoid = <cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>
		, LGnumero = <cfif isdefined("Arguments.LGnumero") and Len(Trim(Arguments.LGnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#"><cfelse>null</cfif>
		
		, TPinsercion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPinsercion#" null="#Len(Arguments.TPinsercion) Is 0#">
		, TPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPfecha#" null="#Len(Arguments.TPfecha) Is 0#">
		, TPfechaReal = <cfif isdefined("Arguments.TPfechaReal") and Len(Trim(Arguments.TPfechaReal))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPfechaReal#"><cfelse>null</cfif>
		, TPdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPdescripcion#" null="#Len(Arguments.TPdescripcion) Is 0#">
		, TPxml = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPxml#" null="#Len(Arguments.TPxml) Is 0#">
		, TPorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPorigen#" null="#Len(Arguments.TPorigen) Is 0#">
		
		, TPestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPestado#" null="#Len(Arguments.TPestado) Is 0#">
		, TPtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPtipo#" null="#Len(Arguments.TPtipo) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TPid#" null="#Len(Arguments.TPid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="TPid" type="numeric" required="Yes"  displayname="Consecutivo tarea">

	<cfquery datasource="#session.dsn#">
		delete ISBtareaProgramada
		where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TPid#" null="#Len(Arguments.TPid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">
  <cfargument name="Contratoid" type="string" required="No"  displayname="Identificador contrato">
  <cfargument name="LGnumero" type="numeric" required="No"  displayname="Login id">
  <cfargument name="TPinsercion" type="date" required="Yes"  displayname="Fecha insercion">
  <cfargument name="TPfecha" type="date" required="Yes"  displayname="Fecha programada">
  <cfargument name="TPfechaReal" type="string" required="No"  displayname="Fecha ejecución real">
  <cfargument name="TPdescripcion" type="string" required="Yes"  displayname="Descripcion">
  <cfargument name="TPxml" type="string" required="Yes"  displayname="Texto XML">
  <cfargument name="TPestado" type="string" required="Yes"  displayname="Estado de Tarea">
  <cfargument name="TPtipo" type="string" required="Yes"  displayname="Tipo de Tarea">
  <cfargument name="TPorigen" type="string" required="No" default="SACI"  displayname="origen de la tarea Programada">

	<cfquery  name="rsAlta"datasource="#session.dsn#">
		insert into ISBtareaProgramada (
			CTid,
			Contratoid,
			LGnumero,
			TPinsercion,
			
			TPfecha,
			TPfechaReal,
			TPdescripcion,
			TPxml,
			
			TPestado,
			TPtipo,
			TPorigen,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">,
			<cfif isdefined("Arguments.Contratoid") and Len(Trim(Arguments.Contratoid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.LGnumero") and Len(Trim(Arguments.LGnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPinsercion#" null="#Len(Arguments.TPinsercion) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPfecha#" null="#Len(Arguments.TPfecha) Is 0#">,
			<cfif isdefined("Arguments.TPfechaReal") and Len(Trim(Arguments.TPfechaReal))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TPfechaReal#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPdescripcion#" null="#Len(Arguments.TPdescripcion) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPxml#" null="#Len(Arguments.TPxml) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPestado#" null="#Len(Arguments.TPestado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPtipo#" null="#Len(Arguments.TPtipo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TPorigen#" null="#Len(Arguments.TPorigen) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		<cf_dbidentity1 conexion="#session.dsn#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 conexion="#session.dsn#" name="rsAlta" verificar_transaccion="false">
	<cfreturn #rsAlta.identity#>
</cffunction>

<cffunction name="ejecutarPendientes">
	<cfargument name="datasource" type="string" required="yes">
	
	<cfquery datasource="#Arguments.datasource#" name="ejecutarPendientes_q0001">
		select TPid, TPtipo,
			CTid, Contratoid, LGnumero, TPorigen, TPxml 
		from ISBtareaProgramada
		where TPestado = 'P'<!--- P-Pendiente/T-Terminada/E-Error--->
		  and TPfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	</cfquery>
	
	<!---<cf_dump var="#ejecutarPendientes_q0001#">--->
	
	
	<cfloop query="ejecutarPendientes_q0001">
		<cfset componente = ''>
		<cfif TPtipo is 'CP'>
			<cfset componente = 'ISBtareaProgramadaCP'>
		<cfelseif TPtipo is 'RL'>
			<cfset componente = 'ISBtareaProgramadaRL'>
		<cfelseif TPtipo is 'RS'>
			<cfset componente = 'ISBtareaProgramadaRS'>
		<cfelseif TPtipo is 'CFC'>
			<cfset componente = 'ISBtareaProgramadaCFC'>
		<cfelse>
			<cflog file="ISBtareaProgramada" text="TPtipo invalido: #TPtipo#, TPid = #TPid#">
		</cfif>
		<cfif Len(componente)>
			<cfset hayError = false>
			<cftry>
				<cfoutput>TPid=#TPid#, TPtipo=#TPtipo#...</cfoutput>
				<cfinvoke component="saci.comp.#componente#" method="ejecutar"
					datasource="#Arguments.datasource#"
					TPid="#TPid#"
					CTid="#CTid#"
					TPxml="#XMLParse(TPxml)#" >
					<cfif Len(Contratoid)>
						<cfinvokeargument name="Contratoid" value="#Contratoid#">
					</cfif>
					<cfif Len(LGnumero)>
						<cfinvokeargument name="LGnumero" value="#LGnumero#">
					</cfif>					
					<cfif Len(TPorigen)>
						<cfinvokeargument name="TPorigen" value="#TPorigen#">
					</cfif>					
				</cfinvoke>
				<cfcatch type="any">
					<cfoutput>#cfcatch.Message# #cfcatch.Detail#</cfoutput>
					<cflog file="ISBtareaProgramada" text="TPid = #TPid#, #cfcatch.Message# #cfcatch.Detail#">
					<cfset hayError = true>
				</cfcatch>
			</cftry>
			<cfquery datasource="#Arguments.datasource#">
				update ISBtareaProgramada
				set TPestado = <cfif hayError>'E'<cfelse>'T'</cfif>,
					TPfechaReal = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TPid#">
				<!---and 1 = 0--->
			</cfquery>
			<cfoutput>ok<br></cfoutput>
		</cfif>
	</cfloop>
	
	
</cffunction>

</cfcomponent>

