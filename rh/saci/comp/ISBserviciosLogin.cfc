<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBserviciosLogin" extends="saci.ws.intf.base">

<!---Devuelve en un lista los servicios que pertenecen a un login especifico--->
<cffunction name="RetornaServicios" output="false" returntype="string" access="remote">
  <cfargument name="LGnumero" 		type="numeric" required="Yes"	displayname="id Login">
  <cfargument name="datasource" 	type="string" required="No" 	default="#session.DSN#">

	<cfquery  name="rsTScodigo" datasource="#Arguments.datasource#">
		select TScodigo 
		from ISBserviciosLogin
		where  LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>

	<cfset lista="">
	<cfif rsTScodigo.RecordCount GT 0> <cfset lista = valuelist(rsTScodigo.TScodigo)> </cfif>
	
	<cfreturn lista> 
</cffunction>

<!---Elimina una lista de servicios que pertenecen a un login en especial--->
<cffunction name="Elimina_ListaServicio" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" 		type="string" required="Yes"	displayname="id Login">
  <cfargument name="listTScodigo"	type="string" required="Yes"	displayname="Lista de tipos de servios a borrar">
  <cfargument name="datasource" 	type="string" required="No" 	default="#session.DSN#">
  
  	<cfquery datasource="#Arguments.datasource#">
		delete ISBserviciosLogin
		where TScodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#Arguments.listTScodigo#">)
		and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
  
</cffunction>


<!---Actualiza uno o varios registros en la tabla ISBserviciosLogin con el paquete que reciba como argumento. Si el TScodigo no es enviado en los argumentos entonces actualiza todos los servicios del login.--->
<cffunction name="UpdatePaqueteServicio" output="false" returntype="void" access="remote">
  <cfargument name="PQcodigo" 	type="string" required="Yes"	displayname="codigo del paquete">
  <cfargument name="LGnumero" 	type="numeric"required="Yes"	displayname="id del Login">
  <cfargument name="LGlogin" 	type="string" required="No" 	default="" displayname="Login">
  <cfargument name="TScodigo"	type="string" required="No"		default="" displayname="Tipo de servicio">
  <cfargument name="datasource" type="string" required="No" 	default="#session.DSN#">

	<cfif not len(trim(Arguments.LGlogin)) and not len(trim(Arguments.LGnumero))>
		<cfthrow message="Error: LGlogin ó LGnumero son requeridos en los argumentos.">
	</cfif>
	
	<cfif not len(trim(Arguments.LGlogin))>
		<cfquery datasource="#Arguments.datasource#" name="rsLGlogin">
			select LGlogin from ISBlogin
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
		
		<cfif rsLGlogin.RecordCount GT 0>	<cfset Arguments.LGlogin = rsLGlogin.LGlogin>
		
		<cfelse><cfthrow message="Error: El login es inválido"></cfif>
	</cfif>
	
	
	<cfif len(trim(Arguments.LGnumero ))>
		<cfquery datasource="#Arguments.datasource#">
			update ISBserviciosLogin
			set	PQcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.PQcodigo#">
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
			<cfif len(trim(Arguments.TScodigo))>
			and TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">  
			</cfif>
		</cfquery>
	</cfif>
	
</cffunction>

<!---Elimina un único servicio que pertenece a un login en especial--->
<cffunction name="EliminaServicio" output="false" returntype="void" access="remote">
  <cfargument name="TScodigo"	type="string" required="Yes"	displayname="Tipo de servicio">
  <cfargument name="LGnumero" 	type="numeric"required="Yes" 	displayname="id Login">
  <cfargument name="LGlogin" 	type="string" required="No" 	default=""displayname="Login">
  <cfargument name="datasource" type="string" required="No" 	default="#session.DSN#">
  
	<cfif not len(trim(Arguments.LGlogin)) and not len(trim(Arguments.LGnumero))>
		<cfthrow message="Error: LGlogin ó LGnumero son requeridos en los argumentos.">
	</cfif>
	
	<cfif not len(trim(Arguments.LGlogin))>
		<cfquery datasource="#Arguments.datasource#" name="rsLGlogin">
			select LGlogin from ISBlogin
			where LGnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.LGnumero#">
		</cfquery>
		<cfif rsLGlogin.RecordCount GT 0>	<cfset Arguments.LGlogin = rsLGlogin.LGlogin>
		<cfelse><cfthrow message="Error: El login es inválido:"></cfif>
	</cfif>
	
	<cfquery datasource="#Arguments.datasource#">
		delete ISBserviciosLogin
		where TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">  
		and LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	
</cffunction>

<cffunction name="sinVigencia" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
 	
	<cfquery datasource="#session.dsn#">
		Update ISBserviciosLogin
		set SLpasswordExp = null
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">  
		and TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="conVigencia" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
 	
	<cfquery datasource="#session.dsn#">
		Update ISBserviciosLogin
		set SLpasswordExp = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,now())#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">  
		and TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="SLpassword" type="string" required="Yes"  displayname="Password">
  <cfargument name="SLcese" type="string" required="No"  displayname="Fecha Inhabilitación">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="ts_rversion" type="string" required="No"  displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBserviciosLogin"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="LGnumero"
						type1="numeric"
						value1="#Arguments.LGnumero#"
						field2="TScodigo"
						type2="char"
						value2="#Arguments.TScodigo#"
						field3="PQcodigo"
						type3="char"
						value3="#Arguments.PQcodigo#">
	</cfif>
	
	<cfquery datasource="#session.dsn#">
		update ISBserviciosLogin
		set SLpassword = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SLpassword#" null="#Len(Arguments.SLpassword) Is 0#">
		
		, SLcese = <cfif isdefined("Arguments.SLcese") and Len(Trim(Arguments.SLcese))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.SLcese#"><cfelse>null</cfif>
		, Habilitado = <cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		  and TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
		  and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="CambioPassword" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="SLpassword" type="string" required="Yes"  displayname="Password">
  	
	<cfquery datasource="#session.dsn#">
		update ISBserviciosLogin
		set  SLpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SLpassword#">
			,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">
		  and TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">
	</cfquery>
	<!--- Cambios en los sistemas externos --->
	<!--- Agregado por Camilo Pérez 06-Jun-2006 --->
	<!--- Ver SACI-03-H022.doc --->
	<cfquery datasource="#session.dsn#" name="ISBlogin">
		select lg.LGlogin, lg.LGmailQuota, lg.LGrealName,
			case when pq.PQtelefono = 1 then lg.LGtelefono else '' end as LGtelefono,
			p.Pnombre, p.Papellido, p.Papellido2, pr.PQcodigo, pq.PQmaxSession
		from ISBlogin lg
			join ISBproducto pr
				on pr.Contratoid = lg.Contratoid
			join ISBpaquete pq
				on pq.PQcodigo = pr.PQcodigo
			join ISBcuenta ct
				on ct.CTid = pr.CTid
			join ISBpersona p
				on p.Pquien = ct.Pquien
		where lg.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
	</cfquery>
	<!---
	<!--- CISCO --->
	<!--- Eliminar el login de CISCO --->
	<cfinvoke webservice="#getWSURL('cisco')#" method="deleteUser" 
		usuario="#ISBlogin.LGlogin#"/>
	<!--- Crear el login en CISCO --->
	<cfinvoke webservice="#getWSURL('cisco')#" method="createUser"
		usuario="#ISBlogin.LGlogin#"
		clave="#Arguments.SLpassword#"
		parentGroup="#ISBlogin.PQnombre#"
		listaTelefonos="#ISBlogin.LGtelefono#"
		maxSession="ISBlogin.PQmaxSession"
		autoriza="-no-se-usa-"/>
	<!--- Iplanet --->
	<!--- Se elimina el casillero de correo --->
	<cfinvoke webservice="#getWSURL('iplanet')#" method="delete"
		usuario="#ISBlogin.LGlogin#"
		LdapDomain="#getParametro(400)#" />
	<!--- Se crea el casillero de correo --->
	<cfinvoke webservice="#getWSURL('iplanet')#" method="add"
		usuario="#ISBlogin.LGlogin#"
		ldapDomain="#getParametro(400)#"
		altMailDomain="#getParametro(401)#"
		mailHost="#getParametro(402)#"
		mailQuotaKB="#ISBlogin.LGmailQuota#"
		accountName="#ISBlogin.LGrealName#"
		nombre="#ISBlogin.Pnombre#"
		apellido="#ISBlogin.Papellido# #ISBlogin.Papellido2#"
		userPassword="#Arguments.SLpassword#" />
		--->
</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">

	<cfquery datasource="#session.dsn#">
		delete ISBserviciosLogin
		where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">  and TScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">  and PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="void" access="remote">
  <cfargument name="LGnumero" type="numeric" required="Yes"  displayname="Login id">
  <cfargument name="TScodigo" type="string" required="Yes"  displayname="Tipo de servicio">
  <cfargument name="PQcodigo" type="string" required="Yes"  displayname="paquete">
  <cfargument name="SLpassword" type="string" required="Yes"  displayname="Password">
  <cfargument name="SLcese" type="date" required="No"  displayname="Fecha Inhabilitación">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">

	<cfquery datasource="#session.dsn#">
		insert into ISBserviciosLogin (
			
			LGnumero,
			TScodigo,
			PQcodigo,
			SLpassword,
			
			SLcese,
			Habilitado,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#" null="#Len(Arguments.LGnumero) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.TScodigo#" null="#Len(Arguments.TScodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.PQcodigo#" null="#Len(Arguments.PQcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SLpassword#" null="#Len(Arguments.SLpassword) Is 0#">,
			
			<cfif isdefined("Arguments.SLcese") and Len(Trim(Arguments.SLcese))><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.SLcese#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		)
	</cfquery>
</cffunction>

</cfcomponent>

