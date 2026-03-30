<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBagenteCobertura">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente">
  <cfargument name="LCid" type="numeric" required="Yes"  displayname="Localidad">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBagenteCobertura"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="AGid"
						type1="numeric"
						value1="#Arguments.AGid#"
						field2="LCid"
						type2="numeric"
						value2="#Arguments.LCid#">
	</cfif>

	<cfquery datasource="#session.dsn#">
		update ISBagenteCobertura
		set Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		  and LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="string" required="Yes"  displayname="Agente">
  <cfargument name="LCid" type="string" required="Yes"  displayname="Localidad">

	<cfquery datasource="#session.dsn#">
		delete ISBagenteCobertura
		where AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">  
			and LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="AGid" type="string" required="Yes"  displayname="Agente">
  <cfargument name="LCid"  type="string" required="Yes"  displayname="Localidad">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">

	<cfquery datasource="#session.dsn#">
		insert into ISBagenteCobertura (
			
			AGid,
			LCid,
			Habilitado,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#" null="#Len(Arguments.LCid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

<cffunction name="AltaMasivo" output="false" returntype="void" access="remote">
	<cfargument name="AGid" type="string" required="Yes"  displayname="Agente">
	<cfargument name="LCid"  type="string" required="Yes"  displayname="Localidad">
	<cfargument name="nivelMax"  type="numeric" required="Yes"  displayname="Nivel_Maximo">
	<cfargument name="Habilitado"  type="numeric" required='no' default="1"  displayname="Habilitado">	

	<cfif not listcontains('0,1', Arguments.Habilitado)>
		<cfthrow message="Error, el parametro Habilitado solo acepta 1 y 0">
	</cfif>
	
	<!--- Nivel actual del LCid de Arguments --->
	<cfquery name="rsNivelSel" datasource="#session.DSN#">
		select DPnivel
		from Localidad
		where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#">
	</cfquery>		
	
	<cfif not Arguments.LCid eq '0'> 
		<cfif isdefined('rsNivelSel') and rsNivelSel.recordCount GT 0>
			<cfset nivel = Arguments.nivelMax - rsNivelSel.DPnivel>
			
			<cfif nivel GT 0>
				<!--- Inserta las localidades de ultimo nivel hijas de la pasada por parametro --->
				<cfquery datasource="#session.DSN#">
					insert ISBagenteCobertura (AGid, LCid, Habilitado, BMUsucodigo)
					Select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
						, lc.LCidHijo
						, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Habilitado#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					from LocalidadCubo lc
					where lc.LCidPadre=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#">
						and LCnivel = <cfqueryparam cfsqltype="cf_sql_integer" value="#nivel#">
						and not exists(
									select 1
									from ISBagenteCobertura ac
									where ac.LCid = lc.LCidHijo
										and ac.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
								)
				</cfquery>			
			<cfelseif nivel EQ 0>
				<!--- Inserta solo la localidad del ultimo nivel seleccionada en el mantenimiento --->
				<cfquery name="rsLocInsertar" datasource="#session.DSN#">
					insert ISBagenteCobertura (AGid, LCid, Habilitado, BMUsucodigo)
					Select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
						, loc.LCid
						, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Habilitado#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					from Localidad loc
					where loc.LCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LCid#">
						and not exists(
									select 1
									from ISBagenteCobertura ac
									where ac.LCid = loc.LCid
										and ac.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
								)
				</cfquery>			
			</cfif>
		</cfif>
	<cfelse>
				<!--- agrega todo el territorio nacional --->				
				<cfquery datasource="#session.DSN#">
					insert ISBagenteCobertura (AGid, LCid, Habilitado, BMUsucodigo)
					Select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
						, loc.LCid
						, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.Habilitado#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					from Localidad loc
					where not exists(
									select 1
									from ISBagenteCobertura ac
									where ac.LCid = loc.LCid
										and ac.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
								)
				</cfquery>			
	</cfif>

</cffunction>

</cfcomponent>

