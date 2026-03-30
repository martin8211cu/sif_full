<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBbitacoraPrepago">

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="BPid" type="numeric" required="Yes"  displayname="id_Bitacora_Prepago">
  <cfargument name="TJid" type="numeric" required="Yes"  displayname="Prepago">
  <cfargument name="TJlogin" type="string" required="Yes"  displayname="Login">  
  <cfargument name="BPautomatica" type="boolean" required="No" default="0" displayname="Automática">  
  <cfargument name="BPobs" type="string" required="Yes"  displayname="Observación">  
  <cfargument name="BPfecha" type="string" required="No" default="#Now()#" displayname="Fecha de registro">
  <cfargument name="BPusuario" type="string" required="No" default="#session.usuario#" displayname="Usuario que modifica">
  <cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">  

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#Arguments.conexion#"
					table="ISBbitacoraPrepago"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="BPid"
					type1="numeric"
					value1="#Arguments.BPid#">
	</cfif>
	<cfquery datasource="#Arguments.conexion#">
		update ISBbitacoraPrepago set
			TJid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">
			, TJlogin		= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJlogin#" null="#Len(Arguments.TJlogin) Is 0#">
			, BPautomatica	= <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BPautomatica#" null="#Len(Arguments.BPautomatica) Is 0#">
			, BPobs			= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BPobs#" null="#Len(Arguments.BPobs) Is 0#">
			, BPfecha		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BPfecha#">
			, BPusuario		= <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BPusuario#">
			, BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where BPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BPid#" null="#Len(Arguments.BPid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  	<cfargument name="BPid" type="numeric" required="Yes"  displayname="id_Bitacora_Prepago">
	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">
	
	<cfquery datasource="#Arguments.conexion#">
		delete ISBbitacoraPrepago
		where BPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BPid#" null="#Len(Arguments.BPid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="TJid" type="numeric" required="Yes"  displayname="Prepago">
  <cfargument name="TJlogin" type="string" required="Yes"  displayname="Login">  
  <cfargument name="BPautomatica" type="boolean" required="No" default="0" displayname="Automática">  
  <cfargument name="BPobs" type="string" required="Yes"  displayname="Observación">  
  <cfargument name="BPfecha" type="string" required="No" default="#Now()#" displayname="Fecha de registro">
  <cfargument name="BPusuario" type="string" required="No" default="#session.usuario#" displayname="Usuario que Inserta">
  <cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">

	<cfquery datasource="#Arguments.conexion#">
		insert into ISBbitacoraPrepago (
			TJid
			, TJlogin
			, BPautomatica			
			, BPobs			
			, BPfecha
			, BPusuario
			, BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TJlogin#" null="#Len(Arguments.TJlogin) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BPautomatica#" null="#Len(Arguments.BPautomatica) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BPobs#" null="#Len(Arguments.BPobs) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BPfecha#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BPusuario#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

<!--- Insercion en la bitacora de acuerdo a un rango de logines de las tarjetas prepago --->
<cffunction name="AltaRango" output="false" returntype="void" access="remote">
	<cfargument name="prefijo" type="string" required="Yes"  displayname="Prefijo">
  	<cfargument name="rangoIni" type="string" required="Yes"  displayname="Rango_Inicial">
  	<cfargument name="rangoFin" type="string" required="Yes"  displayname="Rango_Final">  
	<cfargument name="BPautomatica" type="boolean" required="No" default="0" displayname="Automática">  
	<cfargument name="BPobs" type="string" required="Yes"  displayname="Observación">  
  	<cfargument name="TJestado" type="string" required="Yes"  displayname="EstadoTarjeta">	
	<cfargument name="BPfecha" type="string" required="No" default="#Now()#" displayname="Fecha de registro">
	<cfargument name="BPusuario" type="string" required="No" default="#session.usuario#" displayname="Usuario que Inserta">
	<cfargument name="conexion" type="string" required="No" default="#session.dsn#" displayname="conexion">

  	<cfset ranIni 		= Arguments.prefijo & Arguments.rangoIni>
  	<cfset ranFin 		= Arguments.prefijo & Arguments.rangoFin>
  	<cfset tamPrefijo 	= Len(Arguments.prefijo)>	
	
	<cfquery datasource="#Arguments.conexion#">
		insert ISBbitacoraPrepago (TJid, TJlogin, BPautomatica, BPobs, BPfecha, BPusuario, BMUsucodigo)	
		select TJid
			, TJlogin
			, <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BPautomatica#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BPobs#">
			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BPfecha#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.BPusuario#">
			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		from ISBprepago
		where substring(TJlogin, 1, <cfqueryparam cfsqltype="cf_sql_integer" value="#tamPrefijo#" null="#Len(tamPrefijo) Is 0#">
				) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.prefijo#" null="#Len(Arguments.prefijo) Is 0#">
			and convert(numeric, substring(TJlogin, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#tamPrefijo#" null="#Len(tamPrefijo) Is 0#">
				+1, char_length(TJlogin))) 
			between <cfqueryparam cfsqltype="cf_sql_integer" value="#rangoIni#" null="#Len(rangoIni) Is 0#">
				 and <cfqueryparam cfsqltype="cf_sql_integer" value="#rangoFin#" null="#Len(rangoFin) Is 0#">
				<cfif Arguments.TJestado EQ '1'>	<!--- Activar --->
					<!--- Solo se permite activar las tarjetas con estados de 0. Generada y 5. Desactivada --->
					and TJestado in ('0','5')		
				<cfelseif Arguments.TJestado EQ '5'>	<!--- Bloquear o Desactivar --->
					<!--- Solo se permite bloquear o desactivar las tarjetas con estados de 1. Activas --->
					and TJestado = '1'
					and not exists (
								Select 1
								from ISBeventoPrepago ep
								where ep.TJid = ISBprepago.TJid
							)					
				<cfelseif Arguments.TJestado EQ '6'>	<!--- Anular --->
					<!--- Solo se permite Anular las tarjetas con estados de 1. Activas y 2.Utilizadas --->
					and TJestado in ('1','2')	
				<cfelseif Arguments.TJestado EQ 'A'>	<!--- Asignacion de Agente --->
					<!--- Solo se permite Asignar agentes a las tarjetas con estado de 0.Generada --->
					and TJestado = '0'
				</cfif> 
	</cfquery>
</cffunction>

</cfcomponent>

