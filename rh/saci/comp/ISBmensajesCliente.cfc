<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBmensajesCliente">

<cffunction name="CambioRevAgente" output="false" returntype="void" access="remote">
  <cfargument name="MSid" type="numeric" required="Yes"  displayname="Identificador mensaje">
  <cfargument name="MSrevAgente" type="string" required="Yes"  displayname="Revisado por agente">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBmensajesCliente"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="MSid"
						type1="numeric"
						value1="#Arguments.MSid#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBmensajesCliente set 
			MSrevAgente = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSrevAgente#" null="#Len(Arguments.MSrevAgente) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where MSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MSid#" null="#Len(Arguments.MSid) Is 0#">
	</cfquery>
</cffunction>


<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="MSid" type="numeric" required="Yes"  displayname="Identificador mensaje">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Agente responsable">
  <cfargument name="MSoperacion" type="string" required="Yes"  displayname="Tipo de operación">
  <cfargument name="MSfechaEnvio" type="date" required="Yes"  displayname="Fecha de envío del mensaje">
  <cfargument name="MSfechaAgente" type="date" required="No"  displayname="Fecha de revision por agente">
  <cfargument name="MSfechaCliente" type="date" required="No"  displayname="Fecha de revisión por cliente">
  <cfargument name="MSrevAgente" type="string" required="Yes"  displayname="Revisado por agente">
  <cfargument name="MSrevCliente" type="string" required="Yes"  displayname="Revisado por cliente">
  <cfargument name="MSsaldo" type="numeric" required="No"  displayname="Saldo pendiente del cliente">
  <cfargument name="MSmotivo" type="string" required="Yes"  displayname="Motivo del mensaje">
  <cfargument name="MStexto" type="string" required="No" default="" displayname="Texto del mensaje">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBmensajesCliente"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="MSid"
						type1="numeric"
						value1="#Arguments.MSid#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBmensajesCliente
		set LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		, AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">
		, MSoperacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSoperacion#" null="#Len(Arguments.MSoperacion) Is 0#">
		
		, MSfechaEnvio = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MSfechaEnvio#" null="#Len(Arguments.MSfechaEnvio) Is 0#">
		, MSfechaAgente = <cfif isdefined("Arguments.MSfechaAgente") and Len(Trim(Arguments.MSfechaAgente))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MSfechaAgente#"><cfelse>null</cfif>
		, MSfechaCliente = <cfif isdefined("Arguments.MSfechaCliente") and Len(Trim(Arguments.MSfechaCliente))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MSfechaCliente#"><cfelse>null</cfif>
		
		, MSrevAgente = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSrevAgente#" null="#Len(Arguments.MSrevAgente) Is 0#">
		, MSrevCliente = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSrevCliente#" null="#Len(Arguments.MSrevCliente) Is 0#">
		, MSsaldo = <cfif isdefined("Arguments.MSsaldo") and Len(Trim(Arguments.MSsaldo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MSsaldo#" scale="2"><cfelse>null</cfif>
		, MSmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSmotivo#" null="#Len(Arguments.MSmotivo) Is 0#">
		
		, MStexto = <cfif isdefined("Arguments.MStexto") and Len(Trim(Arguments.MStexto))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MStexto#"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where MSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MSid#" null="#Len(Arguments.MSid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="MSid" type="numeric" required="Yes"  displayname="Identificador mensaje">
	<cfquery datasource="#session.dsn#">
		update ISBmensajesCliente
		set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where MSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MSid#" null="#Len(Arguments.MSid) Is 0#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete ISBmensajesCliente
		where MSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MSid#" null="#Len(Arguments.MSid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="MSoperacion" type="string" required="no" default="L" displayname="Tipo de operación">
  <cfargument name="MSfechaEnvio" type="date" required="Yes"  displayname="Fecha de envío del mensaje">
  <cfargument name="MSsaldo" type="numeric" required="No"  displayname="Saldo pendiente del cliente">
  <cfargument name="MSmotivo" type="string" required="Yes"  displayname="Motivo del mensaje">
  <cfargument name="MStexto" type="string" required="No" default="" displayname="Texto del mensaje">

	<!---Obtiene el agente en caso de que no este definido en los argumentos--->
	<cfquery datasource="#session.dsn#" name="Alta_Q_Agente">
		select v.AGid
		from ISBlogin a
			join ISBproducto b
				on a.Contratoid = b.Contratoid
			join ISBvendedor v
				on v.Vid = b.Vid
		where	a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#">
		insert into ISBmensajesCliente (
			LGnumero,
			AGid,
			MSoperacion,
			
			MSfechaEnvio,
			MSfechaCompleto,
			
			MSsaldo,
			MSmotivo,
			
			MStexto,
			BMUsucodigo
			<cfif IsDefined('Request.S02CON')>,S02CON</cfif>
		)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Alta_Q_Agente.AGid#" null="#Len(Alta_Q_Agente.AGid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSoperacion#" null="#Len(Arguments.MSoperacion) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.MSfechaEnvio#" null="#Len(Arguments.MSfechaEnvio) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- MSfechaCompleto --->
			
			<cfif isdefined("Arguments.MSsaldo") and Len(Trim(Arguments.MSsaldo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MSsaldo#" scale="2"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MSmotivo#" null="#Len(Arguments.MSmotivo) Is 0#">,
			
			<cfif isdefined("Arguments.MStexto") and Len(Trim(Arguments.MStexto))><cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MStexto#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			
			<!--- Esta variable se establece en saci.comp.intf.repconnSelector, y se pone global
			para no afectar todo el SACI para guardar este nuevo dato --->
			<cfif IsDefined('Request.S02CON')>,<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.S02CON#"></cfif>
		)
	</cfquery>
</cffunction>

</cfcomponent>

