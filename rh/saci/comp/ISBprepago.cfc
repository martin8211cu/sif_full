<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBprepago">

<cffunction name="AsignaAgente" output="false" returntype="void" access="remote">
  <cfargument name="TJid" type="numeric" required="Yes"  displayname="Tarjeta">
  <cfargument name="AGid" type="numeric" required="Yes"  displayname="Id_Agente">
  
	<cfquery datasource="#session.dsn#">
		update ISBprepago
			set AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="CambioEstado" output="false" returntype="void" access="remote">
  <cfargument name="TJid" type="numeric" required="Yes"  displayname="Tarjeta">
  <cfargument name="TJestado" type="string" required="Yes"  displayname="EstadoTarjeta">

 	<cfquery datasource="#session.dsn#">
		update ISBprepago
			set TJestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJestado#" null="#Len(Arguments.TJestado) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="CambioEstadoRango" output="false" returntype="void" access="remote">
	<cfargument name="prefijo" type="string" required="Yes"  displayname="Prefijo">
  	<cfargument name="rangoIni" type="string" required="Yes"  displayname="Rango_Inicial">
  	<cfargument name="rangoFin" type="string" required="Yes"  displayname="Rango_Final">  
  	<cfargument name="TJestado" type="string" required="Yes"  displayname="EstadoTarjeta">
	<cfargument name="S02CON" type="numeric" required="No" default="0">
  
  	<cfset ranIni 		= Arguments.prefijo & Arguments.rangoIni>
  	<cfset ranFin 		= Arguments.prefijo & Arguments.rangoFin>
  	<cfset tamPrefijo 	= Len(Arguments.prefijo)>	
  
  
  
   	<cfquery datasource="#session.dsn#" name="rsprepagos">
		Select TJid, TJestado,TJlogin,
				convert(numeric, substring(TJlogin,#tamPrefijo#+1,char_length(TJlogin))) as consecutivo
			 From ISBprepago 
		where substring(TJlogin, 1, <cfqueryparam cfsqltype="cf_sql_integer" value="#tamPrefijo#" null="#Len(tamPrefijo) Is 0#">
				) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.prefijo#" null="#Len(Arguments.prefijo) Is 0#">
			and convert(numeric, substring(TJlogin, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#tamPrefijo#" null="#Len(tamPrefijo) Is 0#">
				+1, char_length(TJlogin))) 
			between <cfqueryparam cfsqltype="cf_sql_integer" value="#rangoIni#" null="#Len(rangoIni) Is 0#">
				 and <cfqueryparam cfsqltype="cf_sql_integer" value="#rangoFin#" null="#Len(rangoFin) Is 0#">
	</cfquery>
  
	<cfset razon = "">
	<cfloop query="rsprepagos">

		<cfif Arguments.TJestado eq 1>
			<cfif Not ListFind('0,5',rsprepagos.TJestado)> 		
				<cfset razon = 'Solo se permiten activar las tarjetas generadas o desactivadas'>
			</cfif>
		<cfelseif Arguments.TJestado eq 5>					
			<cfset con_evento = TieneEventos(rsprepagos.TJid)>
			
			<cfif Not ListFind('1',rsprepagos.TJestado)>	
				<cfset razon = 'Solo se permiten desactivar las tarjetas activas'>
			<cfelseif con_evento>
				<cfset razon = 'La tarjeta tiene tráfico asociado'>
			</cfif>
		<cfelseif Arguments.TJestado eq 6>
			<cfif Not  ListFind('1,2',rsprepagos.TJestado)>	
				<cfset razon = 'Solo se permiten anular las tarjetas activas y utilizadas'>
			</cfif>	
		
		</cfif>
		
		<cfif Len(razon)>
			<cfinvoke component="saci.ws.intf.SSXS02" method="Cumplimiento_Prepago"
			S01ACC="C"
			S01VA1="#Arguments.prefijo#*#rsprepagos.consecutivo#"
			S01VA2="N*#razon#"
			SERCLA="#rsprepagos.TJlogin#" 
			S02CON="#Arguments.S02CON#"/>
		
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update ISBprepago 
					set TJestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJestado#" null="#Len(Arguments.TJestado) Is 0#">
						, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						, S02CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.S02CON#" null="#Len(Arguments.S02CON) Is 0#">
				where TJid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsprepagos.TJid#" null="#Len(rsprepagos.TJid) Is 0#">
			</cfquery>	
		</cfif>
		
	</cfloop>
		
	
</cffunction>

<cffunction name="AsignaAgenteRango" output="false" returntype="void" access="remote">
	<cfargument name="prefijo" type="string" required="Yes"  displayname="Prefijo">
  	<cfargument name="rangoIni" type="string" required="Yes"  displayname="Rango_Inicial">
  	<cfargument name="rangoFin" type="string" required="Yes"  displayname="Rango_Final">  
  	<cfargument name="AGid" type="numeric" required="Yes"  displayname="Id_Agente">
  
  	<cfset ranIni = Arguments.prefijo & Arguments.rangoIni>
  	<cfset ranFin = Arguments.prefijo & Arguments.rangoFin>  
	<cfset tamPrefijo 	= Len(Arguments.prefijo)>	
	
  	<cfquery datasource="#session.dsn#">
		update ISBprepago 
			set AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where substring(TJlogin, 1, <cfqueryparam cfsqltype="cf_sql_integer" value="#tamPrefijo#" null="#Len(tamPrefijo) Is 0#">
				) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.prefijo#" null="#Len(Arguments.prefijo) Is 0#">
			and convert(numeric, substring(TJlogin, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#tamPrefijo#" null="#Len(tamPrefijo) Is 0#">
				+1, char_length(TJlogin))) 
			between <cfqueryparam cfsqltype="cf_sql_integer" value="#rangoIni#" null="#Len(rangoIni) Is 0#">
				 and <cfqueryparam cfsqltype="cf_sql_integer" value="#rangoFin#" null="#Len(rangoFin) Is 0#">
			and TJestado = '0'	<!--- Solo se permite asignar agentes a tarjetas con estado 0.Generadas --->
	</cfquery>  
</cffunction>

<cffunction name="TieneEventos" output="false" returntype="boolean" access="remote">
	<cfargument name="TJid" type="numeric" required="Yes"  displayname="id de la tarjeta">
  
	
  	<cfquery datasource="#session.dsn#" name="rseventos">
		Select count(1) as evento
		from ISBeventoPrepago ep
		where ep.TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">
	</cfquery>  

	<cfif rseventos.evento eq 0>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>



<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="TJid" type="numeric" required="Yes"  displayname="Tarjeta">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="AGid" type="numeric" required="No"  displayname="Agente">
  <cfargument name="TJlogin" type="string" required="Yes"  displayname="LoginTarjeta">
  <cfargument name="TJpassword" type="string" required="Yes"  displayname="clave acceso">
  <cfargument name="TJgeneracion" type="date" required="Yes"  displayname="Generación">
  <cfargument name="TJestado" type="string" required="Yes"  displayname="EstadoTarjeta">
  <cfargument name="TJliquidada" type="boolean" required="Yes"  displayname="Liquidada">
  <cfargument name="TJuso" type="date" required="No"  displayname="Fecha primer uso">
  <cfargument name="TJvigencia" type="numeric" required="No"  displayname="Días de vigencia">
  <cfargument name="TJprecio" type="numeric" required="Yes"  displayname="Precio">
  <cfargument name="TJoriginal" type="numeric" required="No"  displayname="Segundos originales">
  <cfargument name="TJdsaldo" type="numeric" required="No"  displayname="Segundos restantes">
  <cfargument name="ts_rversion" type="string" required="Yes"  displayname="ts_rversion">

	<cf_dbtimestamp datasource="#session.dsn#"
					table="ISBprepago"
					redirect="metadata.code.cfm"
					timestamp="#Arguments.ts_rversion#"
					field1="TJid"
					type1="numeric"
					value1="#Arguments.TJid#">
	<cfquery datasource="#session.dsn#">
		update ISBprepago
		set PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
		, AGid = <cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>
		, TJlogin = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJlogin#" null="#Len(Arguments.TJlogin) Is 0#">		
		, TJpassword = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJpassword#" null="#Len(Arguments.TJpassword) Is 0#">
		, TJgeneracion = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.TJgeneracion#" null="#Len(Arguments.TJgeneracion) Is 0#">
		, TJestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJestado#" null="#Len(Arguments.TJestado) Is 0#">
		, TJliquidada = <cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TJliquidada#" null="#Len(Arguments.TJliquidada) Is 0#">		
		, TJuso = <cfif isdefined("Arguments.TJuso") and Len(Trim(Arguments.TJuso))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.TJuso#"><cfelse>null</cfif>
		, TJvigencia = <cfif isdefined("Arguments.TJvigencia") and Len(Trim(Arguments.TJvigencia))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJvigencia#"><cfelse>null</cfif>
		, TJprecio = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.TJprecio#" null="#Len(Arguments.TJprecio) Is 0#">
		, TJoriginal = <cfif isdefined("Arguments.TJoriginal") and Len(Trim(Arguments.TJoriginal))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJoriginal#" scale="2"><cfelse>null</cfif>		
		, TJdsaldo = <cfif isdefined("Arguments.TJdsaldo") and Len(Trim(Arguments.TJdsaldo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJdsaldo#" scale="2"><cfelse>null</cfif>
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="TJid" type="numeric" required="Yes"  displayname="Tarjeta">

	<cfquery datasource="#session.dsn#">
		delete ISBprepago
		where TJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJid#" null="#Len(Arguments.TJid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="AGid" type="numeric" required="No"  displayname="Agente">
  <cfargument name="TJlogin" type="string" required="Yes"  displayname="LoginTarjeta">
  <cfargument name="TJpassword" type="string" required="Yes"  displayname="clave acceso">
  <cfargument name="TJgeneracion" type="date" required="Yes"  displayname="Generación">
  <cfargument name="TJestado" type="string" required="Yes"  displayname="EstadoTarjeta">
  <cfargument name="TJliquidada" type="boolean" required="Yes"  displayname="Liquidada">
  <cfargument name="TJuso" type="date" required="No"  displayname="Fecha primer uso">
  <cfargument name="TJvigencia" type="numeric" required="No"  displayname="Días de vigencia">
  <cfargument name="TJprecio" type="numeric" required="Yes"  displayname="Precio">
  <cfargument name="TJoriginal" type="numeric" required="No"  displayname="Segundos originales">
  <cfargument name="TJdsaldo" type="numeric" required="No"  displayname="Segundos restantes">

	<cfquery datasource="#session.dsn#">
		insert into ISBprepago (
			PQcodigo,
			AGid,
			TJlogin,			
			TJpassword,
			TJgeneracion,
			TJestado,
			TJliquidada,			
			TJuso,
			TJvigencia,
			TJprecio,
			TJoriginal,			
			TJdsaldo,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">,
			<cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJlogin#" null="#Len(Arguments.TJlogin) Is 0#">,			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJpassword#" null="#Len(Arguments.TJpassword) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.TJgeneracion#" null="#Len(Arguments.TJgeneracion) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TJestado#" null="#Len(Arguments.TJestado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.TJliquidada#" null="#Len(Arguments.TJliquidada) Is 0#">,			
			<cfif isdefined("Arguments.TJuso") and Len(Trim(Arguments.TJuso))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.TJuso#"><cfelse>null</cfif>,
			<cfif isdefined("Arguments.TJvigencia") and Len(Trim(Arguments.TJvigencia))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJvigencia#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.TJprecio#" null="#Len(Arguments.TJprecio) Is 0#">,
			<cfif isdefined("Arguments.TJoriginal") and Len(Trim(Arguments.TJoriginal))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJoriginal#" scale="2"><cfelse>null</cfif>,			
			<cfif isdefined("Arguments.TJdsaldo") and Len(Trim(Arguments.TJdsaldo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TJdsaldo#" scale="2"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cffunction>

</cfcomponent>

