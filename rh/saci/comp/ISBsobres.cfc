<!---
	Funcionamiento de los sobres
	
	En principio los sobres cuando se importan son asignados a la empresa, es decir con Sdonde = 0 y Sestado = 1
	En la venta de servicio o creación de cuentas a agentes, el sobre es asignado al login o al agente pero Sdonde no se actualiza hasta ese momento
	En el momento en que se aplica definitivamente la venta o asignación es que se actualiza el Sdonde en 1 o en 2 y al mismo tiempo se coloca Sestado en 1
	Cuando la empresa entrega sobres a los agentes estos todavía mantienen Sestado en 1 hasta que los agentes lo asignen a un cliente
	El código de agente en el sobre no se pierde aunque el sobre sea asignado a un cliente
	
--->

<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBsobres">

<!--- Desasigna todos los sobres relacionados a un producto, unicamente aplica para los productos en captura --->
<cffunction name="Desasignar" output="false" returntype="void" access="remote">
  <cfargument name="Contratoid" type="numeric" required="Yes"  displayname="ID Producto">
  
	<cfquery datasource="#session.dsn#">
		update ISBsobres
		set LGnumero = null, Sdonde = '1'
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where exists (
			select 1
			from ISBproducto x
				inner join ISBlogin y
					on y.Contratoid = x.Contratoid
					and y.Snumero = ISBsobres.Snumero
			where x.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Contratoid#" null="#Len(Arguments.Contratoid) Is 0#">
			and x.CTcondicion = 'C'
		)
	</cfquery>

</cffunction>

<!--- Desasigna todos los sobres relacionados a una cuenta, unicamente aplica para los productos en captura --->
<cffunction name="DesasignarDeCuenta" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="ID Cuenta">
  
	<cfquery datasource="#session.dsn#">
		update ISBsobres
		set LGnumero = null, Sdonde = '1'
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where exists (
			select 1
			from ISBcuenta z
				inner join ISBproducto x
					on x.CTid = z.CTid
					and x.CTcondicion = 'C'
				inner join ISBlogin y
					on y.Contratoid = x.Contratoid
					and y.Snumero = ISBsobres.Snumero
			where z.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
		)
	</cfquery>

</cffunction>

<cffunction name="cambioEstado" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Tarjeta">
  <cfargument name="Sestado" type="string" required="Yes"  displayname="EstadoSobre">

	<cfquery datasource="#session.dsn#" name="rsExisteSobre">
		select 1 as cantSobre
		from ISBsobres
		where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
	</cfquery>
	
	<cfif isdefined('rsExisteSobre') and rsExisteSobre.cantSobre GT 0>
		<cfquery datasource="#session.dsn#">
			update ISBsobres
				set Sestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Sestado#" null="#Len(Arguments.Sestado) Is 0#">
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
		</cfquery>
	<cfelse>
		<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# no existe, el cambio del estado del sobre fall&oacute;.">
	</cfif>	
</cffunction>

<cffunction name="Asigna_Agente" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">
  <cfargument name="AGid" type="numeric" required="No"  displayname="Agente">

	<cfquery datasource="#session.dsn#">
		update ISBsobres
		set AGid = <cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>
		, Sdonde='1'
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
			and Sdonde='0'
	</cfquery>
</cffunction>

<cffunction name="AsignaAgenteRango" output="false" returntype="void" access="remote">
  	<cfargument name="rangoIni" type="string" required="Yes"  displayname="Rango_Inicial">
  	<cfargument name="rangoFin" type="string" required="Yes"  displayname="Rango_Final">  
  	<cfargument name="AGid" type="numeric" required="No"  displayname="Agente">
   
  	<cfquery datasource="#session.dsn#">
		update ISBsobres 
			set AGid= <cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>
			, Sdonde='1'
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Snumero between 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rangoIni#" null="#Len(Arguments.rangoIni) Is 0#">
			and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rangoFin#" null="#Len(Arguments.rangoFin) Is 0#">
			and Sdonde='0'
	</cfquery>
</cffunction>

<cffunction name="cambioEstadoRango" output="false" returntype="void" access="remote">
  	<cfargument name="rangoIni" type="string" required="Yes"  displayname="Rango_Inicial">
  	<cfargument name="rangoFin" type="string" required="Yes"  displayname="Rango_Final">  
	<cfargument name="Sestado" type="string" required="Yes"  displayname="EstadoSobre">
   
  	<cfquery datasource="#session.dsn#">
		update ISBsobres 
			set Sestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Sestado#" null="#Len(Arguments.Sestado) Is 0#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Snumero between 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rangoIni#" null="#Len(Arguments.rangoIni) Is 0#">
			and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.rangoFin#" null="#Len(Arguments.rangoFin) Is 0#">
	</cfquery>
</cffunction>


<cffunction name="Asigna_Login" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">
  <cfargument name="LGnumero" type="numeric" required="No"  displayname="Login id">

	<cfquery datasource="#session.dsn#">
		update ISBsobres
		set LGnumero = <cfif isdefined("Arguments.LGnumero") and Len(Trim(Arguments.LGnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#"><cfelse>null</cfif>,
			Sdonde = '2', 
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
	</cfquery>		
</cffunction>


<cffunction name="Desasignar_Login" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">
  <cfargument name="LGnumero" type="numeric" required="No"  displayname="Login id">

	<cfquery datasource="#session.dsn#">
		update ISBsobres
		set LGnumero = <cfif isdefined("Arguments.LGnumero") and Len(Trim(Arguments.LGnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#"><cfelse>null</cfif>,
			Sdonde = '1', 
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
	</cfquery>		
</cffunction>

<cffunction name="Activacion" output="false" returntype="numeric" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">

	<cfset LvarError = 0>
	
	<cfquery name="rsSobre" datasource="#session.dsn#">
		select LGnumero, AGid, Sestado
		from ISBsobres
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfquery>

	
	<cfif isdefined('rsSobre') and rsSobre.recordCount GT 0>
		<cfif rsSobre.Sestado NEQ '0' or Len(Trim(rsSobre.LGnumero)) EQ 0>
			<cfset LvarError = 1>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				update ISBsobres
				set Sestado = <cfqueryparam cfsqltype="cf_sql_char" value="1">
				, Sdonde = <cfqueryparam cfsqltype="cf_sql_char" value="2">
				, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
			</cfquery>
		</cfif>	
	<cfelse>
		<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# no existe. La activaci&oacute;n del sobre fall&oacute;">
	</cfif>

	<cfreturn LvarError>
</cffunction>


<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">
  <cfargument name="Sestado" type="string" required="Yes"  displayname="Estado">
  <cfargument name="Sdonde" type="string" required="Yes"  displayname="Responsable">
  <cfargument name="SpwdAcceso" type="string" required="Yes"  displayname="Clave acceso">
  <cfargument name="SpwdCorreo" type="string" required="Yes"  displayname="Clave correo">
  <cfargument name="LGnumero" type="numeric" required="No"  displayname="Login id">
  <cfargument name="AGid" type="numeric" required="No"  displayname="Agente">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfquery name="rsSobre" datasource="#session.dsn#">
		select 1 as cantSobres
		from ISBsobres
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfquery>

	<cfif isdefined('rsSobre') and rsSobre.cantSobres GT 0>
		<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="ISBsobres"
							redirect="metadata.code.cfm"
							timestamp="#Arguments.ts_rversion#"
							field1="Snumero"
							type1="numeric"
							value1="#Arguments.Snumero#">
		</cfif>
		
		<cfquery datasource="#session.dsn#">
			update ISBsobres
			set Sestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Sestado#" null="#Len(Arguments.Sestado) Is 0#">
			, Sdonde = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Sdonde#" null="#Len(Arguments.Sdonde) Is 0#">
				
			, SpwdAcceso = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SpwdAcceso#" null="#Len(Arguments.SpwdAcceso) Is 0#">
			, SpwdCorreo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SpwdCorreo#" null="#Len(Arguments.SpwdCorreo) Is 0#">
	
			, LGnumero = <cfif isdefined("Arguments.LGnumero") and Len(Trim(Arguments.LGnumero))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#"><cfelse>null</cfif>
			, AGid = <cfif isdefined("Arguments.AGid") and Len(Trim(Arguments.AGid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#"><cfelse>null</cfif>
	
			, Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			
			where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
		</cfquery>	
	<cfelse>
		<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# no existe. La actualizaci&oacute;n del sobre fall&oacute;">
	</cfif>
</cffunction>


<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">

	<cfquery datasource="#session.dsn#">
		delete ISBsobres
		where Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">
	</cfquery>
	
</cffunction>

<!--- Los sobres siempre se van a insertar inactivos y asignados a la empresa --->
<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="Snumero" type="numeric" required="Yes"  displayname="Número visible del sobre">
  <cfargument name="AGid" type="numeric" required="no" default="0"  displayname="Código de agente">
  <cfargument name="SpwdAcceso" type="string" required="Yes"  displayname="Clave acceso">
  <cfargument name="SpwdCorreo" type="string" required="Yes"  displayname="Clave correo">
  <cfargument name="Sgenero" type="string" required="no" default="M"  displayname="Genero del Sobre (A)cceso (C)orreo (M)ambos">
  <cfargument name="Stipo" type="string" required="no" default="F"  displayname="Tipo de Sobre (V)irtual (F)isico">

	

	<cfquery name="rsSobre" datasource="#session.dsn#">
		select count(Snumero) as cantSobres
		from ISBsobres
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#">
	</cfquery>
	
	
	<cfif isdefined('rsSobre') and rsSobre.cantSobres EQ 0>
		<cfquery datasource="#session.dsn#">
			insert into ISBsobres (
				Snumero,
				Sestado,
				Sdonde,
				
				Sgenero,
				Stipo,
				SpwdAcceso,
				SpwdCorreo,
				AGid,
				Ecodigo,
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Snumero#" null="#Len(Arguments.Snumero) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="0">,
				<cfif Len(Arguments.AGid)>
					<cfqueryparam cfsqltype="cf_sql_char" value="1"><!--- Asignados al agente --->
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_char" value="0"><!--- En la empresa --->
				</cfif>,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Sgenero#" null="#Len(Arguments.Sgenero) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Stipo#" null="#Len(Arguments.Stipo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SpwdAcceso#" null="#Len(Arguments.SpwdAcceso) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SpwdCorreo#" null="#Len(Arguments.SpwdCorreo) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.AGid#" null="#Len(Arguments.AGid) Is 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			)
		</cfquery>
	<cfelse>
		<cfthrow message="Error, el sobre n&uacute;mero #Arguments.Snumero# ya existe. La inserci&oacute;n del sobre fall&oacute;">	
	</cfif>
</cffunction>

</cfcomponent>

