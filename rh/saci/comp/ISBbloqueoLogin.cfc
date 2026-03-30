<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBbloqueoLogin">


<cffunction name="Desbloquear" output="false" returntype="void" access="remote">
  <cfargument name="BLQid"		type="numeric" 	required="Yes"  displayname="Consecutivo bloqueo">
  <cfargument name="BLQhasta" 	type="string" 	required="Yes"  displayname="Bloqueado hasta">
  <cfargument name="MBmotivo" 	type="string" 	required="No"  	default="" displayname="Motivo del desbloqueo">    
  <cfargument name="LGnumero" 	type="numeric" 	required="Yes" 	displayname="Login id">      
  <cfargument name="BLorigen" 	type="string" 	required="NO" 	default= "SACI" displayname="origen del desbloqueo">
  <cfargument name="MStexto" 	type="string" 	required="NO" 	default= "Desbloqueo de Login" displayname="Texto_Mensajes_Cliente">      	
   
   <cfif Len(Arguments.MBmotivo) is 0>
		<cfquery datasource="#session.dsn#" name="rsmotivos">
			Select MBmotivo From ISBbloqueoLogin
			where BLQid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BLQid#" null="#Len(Arguments.BLQid) Is 0#">
		</cfquery>
		<cfset Arguments.MBmotivo = rsmotivos.MBmotivo>
	</cfif> 
  
   
   
	<cfquery datasource="#session.dsn#">
		update ISBbloqueoLogin set
			 BLQhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLQhasta#" null="#Len(Arguments.BLQhasta) Is 0#">
			, BLQdesbloquear = 1
			, BLorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BLorigen#" null="#Len(Arguments.BLorigen) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where BLQid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BLQid#" null="#Len(Arguments.BLQid) Is 0#">
			<cfif len(trim(Arguments.MBmotivo))>
			and MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#" null="#Len(Arguments.MBmotivo) Is 0#">
			</cfif>
	</cfquery>
	
	<!--- Verificacion de si se permite o no desbloquear el login --->
	<cfquery name="rsBloqueado" datasource="#session.DSN#">
		select count(1) as existe
		from ISBbloqueoLogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
			and BLQdesbloquear = 0
	</cfquery>
	<!---Desbloquea el login--->
	<cfif rsBloqueado.existe EQ 0> 
		<cfinvoke component="saci.comp.ISBlogin" method="Desbloqueo">
			<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
			<cfinvokeargument name="MSmotivo" value="#Arguments.MBmotivo#">
			<cfinvokeargument name="MStexto" value="#Arguments.MStexto#">
		</cfinvoke>
	</cfif>			
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="BLQid" type="numeric" required="Yes"  displayname="Consecutivo bloqueo">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="MBmotivo" type="string" required="Yes"  displayname="Motivo">
  <cfargument name="BLQdesde" type="string" required="Yes"  displayname="Bloqueado desde">
  <cfargument name="BLQhasta" type="string" required="Yes"  displayname="Bloqueado hasta">
  <cfargument name="BLQdesbloquear" type="boolean" required="Yes"  displayname="Esta desbloqueado">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion")and len(trim(Arguments.ts_rversion))>
	<cf_dbtimestamp datasource="#session.dsn#"
				table="ISBbloqueoLogin"
				redirect="metadata.code.cfm"
				timestamp="#Arguments.ts_rversion#"
				field1="BLQid"
				type1="numeric"
				value1="#Arguments.BLQid#">
	</cfif>
	<cfquery datasource="#session.dsn#">
		update ISBbloqueoLogin
		set LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		, MBmotivo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#" null="#Len(Arguments.MBmotivo) Is 0#">
		, BLQdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLQdesde#" null="#Len(Arguments.BLQdesde) Is 0#">
		
		, BLQhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLQhasta#" null="#Len(Arguments.BLQhasta) Is 0#">
		, BLQdesbloquear = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BLQdesbloquear#" null="#Len(Arguments.BLQdesbloquear) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where BLQid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BLQid#" null="#Len(Arguments.BLQid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="BLQid" type="numeric" required="Yes"  displayname="Consecutivo bloqueo">

	<cfquery datasource="#session.dsn#">
		delete ISBbloqueoLogin
		where BLQid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BLQid#" null="#Len(Arguments.BLQid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 		type="numeric" 	required="Yes"  displayname="Login id">
  <cfargument name="MBmotivo" 		type="string" 	required="Yes"  displayname="Motivo">
  <cfargument name="BLQdesde" 		type="string" 	required="Yes"  displayname="Bloqueado desde">
  <cfargument name="BLQhasta" 		type="string" 	required="Yes"  displayname="Bloqueado hasta">
  <cfargument name="BLQdesbloquear" type="boolean" 	required="Yes"  displayname="Esta desbloqueado">
  <cfargument name="AGid" 			type="string" 	required="no" 	default="" displayname="Agente">
  <cfargument name="MSsaldo" 		type="numeric" 	required="no" 	default="0" displayname="Saldo_Mensajes_Cliente">
  <cfargument name="MSmotivo" 		type="string" 	required="no" 	default="I" displayname="Motivo_Mensajes_Cliente">
  <cfargument name="MStexto" 		type="string" 	required="no" 	default="Bloqueo de Login" displayname="Texto_Mensajes_Cliente">
  <cfargument name="BLorigen" 	    type="string" 	required="NO" 	default= "SACI" displayname="origen del desbloqueo">  
  <cfargument name="BLobs" type="string" required="No" default="" displayname="Observaciones de la Inhabilitación">    	
  
	<!---Bloquea el login--->
	<cfquery datasource="#session.dsn#">
		insert into ISBbloqueoLogin (
			LGnumero,
			MBmotivo,
			BLQdesde,
			
			BLQhasta,
			BLQdesbloquear,
			BLorigen,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.MBmotivo#" null="#Len(Arguments.MBmotivo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLQdesde#" null="#Len(Arguments.BLQdesde) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.BLQhasta#" null="#Len(Arguments.BLQhasta) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.BLQdesbloquear#" null="#Len(Arguments.BLQdesbloquear) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.BLorigen#" null="#Len(Arguments.BLorigen) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
	
	<!---Bloquea el login--->
	<cfinvoke component="saci.comp.ISBlogin" method="Bloqueo">
		<cfinvokeargument name="LGnumero" value="#Arguments.LGnumero#">
		<cfinvokeargument name="MBmotivo" value="#Arguments.MBmotivo#">
		<cfinvokeargument name="AGid" value="#Arguments.AGid#">
		<cfinvokeargument name="MStexto" value="#Arguments.MStexto#">
		<!---<cfinvokeargument name="BLobs" value="#Arguments.BLobs#">--->
	</cfinvoke>
	
</cffunction>

<cffunction name="bloquearLoginesExpirados" output="true" returntype="void" access="public">
	<!--- 
		bloquea los logines que hayan expirado
		para invocarse periódicamente desde /saci/tasks/isb_bloqueoLoginExpirado.cfm.
		Los logines expiran SOLAMENTE cuando se les asigna una contraseña temporal.
		Luego de bloquearlo, se restablece la fecha de expiración para que no se
		bloquee de nuevo.
	--->
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfargument name="datasource" type="string" required="yes">
	
	<cfinvoke component="saci.comp.ISBparametros" method="Get"
		Pcodigo="221" returnvariable="MBmotivo221" />
	<cfquery datasource="#Arguments.datasource#" name="loginesExpirados_count">
		select count(distinct l.LGnumero) as cantidad
		from ISBlogin l
			left join ISBserviciosLogin sl
				on sl.LGnumero = l.LGnumero
		where l.LGbloqueado = 0
		  and sl.SLpasswordExp < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	</cfquery>
	<cfquery datasource="#Arguments.datasource#" name="logines_count">
		select count(1) as cantidad
		from ISBlogin l
		where l.LGbloqueado = 0
	</cfquery>
	<cfif logines_count.cantidad GT 0>
		<cfset porcentaje_expirados = 100 * loginesExpirados_count.cantidad / logines_count.cantidad>
	<cfelse>
		<cfset porcentaje_expirados = 100>
	</cfif>
	<cfif (loginesExpirados_count.cantidad GE 500) Or (porcentaje_expirados GT 0.7)>
		<!---
			en promedio son 27 diarios, con una media de 23 y un máximo de 161
			500 bloqueos, o un 0.7% ya es sospechoso, y posiblemente sea un error
			del sistema y esté bloqueando una cantidad exagerada de logines.
		--->
		<cfthrow message="Hay muchos logines expirados: #loginesExpirados_count.cantidad# (#NumberFormat(porcentaje_expirados)# %). Esto se sale de lo esperado, abortando bloqueo de usuarios temporales.">
	</cfif>
	<cfquery datasource="#Arguments.datasource#" name="loginesExpirados">
		select distinct l.LGnumero, l.LGlogin
		from ISBlogin l
			left join ISBserviciosLogin sl
				on sl.LGnumero = l.LGnumero
		where l.LGbloqueado = 0
		  and sl.SLpasswordExp < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	</cfquery>
	<cfloop query="loginesExpirados">
		<cfoutput>Bloqueando login #loginesExpirados.LGlogin# (#loginesExpirados.LGnumero#)...</cfoutput>
		<cfinvoke component="#This#" method="Alta"
			LGnumero="#loginesExpirados.LGnumero#"
			MBmotivo="#MBmotivo221#"
			BLQdesde="#Now()#"
			BLQhasta="#CreateDate(6100,1,1)#"
			BLQdesbloquear="no"
			MStexto="La contraseña ha expirado" />
		<!--- Restablecer la fecha de expiración --->
		<cfquery datasource="#arguments.datasource#">
			update ISBserviciosLogin
			set SLpasswordExp = null
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#loginesExpirados.LGnumero#">
		</cfquery>
		<cfoutput>ok<br></cfoutput>
	</cfloop>
</cffunction>

</cfcomponent>

