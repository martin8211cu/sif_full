<!---
	Este componente debe invocarse dentro de un cftransaction

	El campo CUECUE de ISBcuenta es el número de cuenta que se obtiene por interfaz con otro sistema, en general no se le da mantenimiento, 
	pero se puede asignar cuando esta se obtenga del sistema interfazado.
	Cuando se da de alta una cuenta se pueden insertar 3 valores diferentes en el campo CUECUE:
	0: Pendiente de Generación por parte de SIIC
	-1: Cuenta de Acceso para Agente
	-2: Cuenta de Facturación para Agente
	
--->

<cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla ISBcuenta">

<cffunction name="PermiteVenta" output="false" returntype="struct" access="remote">
	<cfargument name="Pquien" 		type="numeric" 	required="Yes" 	displayname="id del cliente">
	<cfargument name="Pid" 			type="string" 	required="No" 	displayname="cédula del cliente">
 	<cfargument name="datasource" 	type="string" 	required="No" 	default="#session.DSN#"	displayname="string de conexion"> 
  	
	<!---ESTADOS PERMITIDOS DE LA CUENTA
		Estado	Subestado
		0		(1-10)
		1		(1,2)
		4		(15)
		5		(15)
	--->
	<cfset ret = structNew()>
	
  	<cfquery  name="rsCuentasInconsistentes"datasource="#session.dsn#">
		select  b.ECestado as estado, b.ECsubEstado as subestado, b.ECnombre as nombre
		from ISBcuenta a
			inner join ISBcuentaEstado b
			on b.ECidEstado= a.ECidEstado
		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#">
	</cfquery>
	
	<cfset ret.valida = true>
	<cfset ret.nombre = "">
	<cfloop query="rsCuentasInconsistentes">
		<cfset estado = rsCuentasInconsistentes.estado>
		<cfset subestado = rsCuentasInconsistentes.subestado>
		<cfset nombre = rsCuentasInconsistentes.nombre>
		<cfset ret.nombre = nombre>
		
		<cfif estado EQ 0>
			<cfset lista = "1,2,3,4,5,6,7,8,9,10" >
			<cfif ListFindNoCase(lista,subestado,',') EQ 0>	<cfset ret.valida = false> <cfreturn ret></cfif>			
		<cfelseif estado EQ 1>
			<cfif subestado NEQ 1 and  subestado NEQ 2>	<cfset ret.valida = false> <cfreturn ret></cfif>			
		<cfelseif estado EQ 4 or estado EQ 5>
			<cfif subestado NEQ 15>	<cfset ret.valida = false> <cfreturn ret></cfif>			
		<cfelseif estado EQ 3>
		    <cfset ret.valida = false>
			<cfreturn ret>
		</cfif>	
	</cfloop> 
	
	<cfreturn ret>
	
</cffunction>

<cffunction name="Activacion" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes" displayname="Cuenta">
  <cfargument name="CTapertura" type="date" required="No" displayname="Fecha de apertura">

	<cfquery datasource="#session.dsn#">
		update ISBcuenta
		set Habilitado = 1
		<cfif isdefined("Arguments.CTapertura") and Len(Trim(Arguments.CTapertura)) NEQ 0>
			, CTapertura = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CTapertura#">
		</cfif>
		, CTmodificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Cambio_CUECUE" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes" displayname="Cuenta">
  <cfargument name="CUECUE" type="numeric" required="Yes" displayname="Cuenta SIIC">

	<cfquery datasource="#session.dsn#">
		update ISBcuenta
		set CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUE#" null="#Len(Arguments.CUECUE) Is 0#">
		, CTmodificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Cambio_ECidEstado" output="false" returntype="void" access="remote">
  <cfargument name="ECidEstado" type="numeric" required="Yes" displayname="ECidEstado">
  <cfargument name="CUECUE" type="numeric" required="Yes" displayname="Cuenta SIIC">

	<cfquery datasource="#session.dsn#">
		update ISBcuenta
		set ECidEstado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECidEstado#" null="#Len(Arguments.ECidEstado) Is 0#">
		, CTmodificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where CUECUE = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUE#" null="#Len(Arguments.CUECUE) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Cambio" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes" displayname="Cuenta">
  <cfargument name="Pquien" type="numeric" required="No" displayname="Persona">
  <cfargument name="CTdesde" type="date" required="Yes" displayname="Inicio">
  <cfargument name="CThasta" type="date" required="No" displayname="Cese">
  <cfargument name="CCclaseCuenta" type="numeric" required="No" displayname="Código clase de cuenta">
  <cfargument name="GCcodigo" type="numeric" required="No" displayname="Código Grupo de cobro">
  <cfargument name="CTobservaciones" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="ts_rversion" type="string" required="No" displayname="ts_rversion">

	<cfif isdefined("Arguments.ts_rversion") and Len(Trim(Arguments.ts_rversion))>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ISBcuenta"
						redirect="metadata.code.cfm"
						timestamp="#Arguments.ts_rversion#"
						field1="CTid"
						type1="numeric"
						value1="#Arguments.CTid#">
	</cfif>
				
	<cfquery datasource="#session.dsn#">
		update ISBcuenta
		set Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">
		, CTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CTdesde#" null="#Len(Arguments.CTdesde) Is 0#">
		, CThasta = <cfif isdefined("Arguments.CThasta") and Len(Trim(Arguments.CThasta)) NEQ 0><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CThasta#"><cfelse>null</cfif>

		, CCclaseCuenta = <cfif isdefined("Arguments.CCclaseCuenta") and Len(Trim(Arguments.CCclaseCuenta)) NEQ 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CCclaseCuenta#"><cfelse>null</cfif>
		, GCcodigo = <cfif isdefined("Arguments.GCcodigo") and Len(Trim(Arguments.GCcodigo)) NEQ 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GCcodigo#"><cfelse>null</cfif>
		<cfif isdefined("Arguments.CTobservaciones")>
		, CTobservaciones = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTobservaciones#" null="#Len(Arguments.CTobservaciones) Is 0#">
		</cfif>

		, CTmodificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>

</cffunction>

<cffunction name="Baja" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Cuenta">

	<cfquery datasource="#session.dsn#">
		delete ISBcuenta
		where CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>
</cffunction>

<cffunction name="Alta" output="false" returntype="numeric" access="remote">
  <cfargument name="Pquien" type="numeric" required="No" displayname="Persona">
  <cfargument name="CUECUE" type="numeric" required="Yes" displayname="Cuenta SIIC">
  <cfargument name="ECidEstado" type="numeric" required="No" displayname="Ident. Estado">
  <cfargument name="CTapertura" type="date" required="Yes" displayname="Fecha de apertura">
  <cfargument name="CTdesde" type="date" required="Yes" displayname="Inicio">
  <cfargument name="CThasta" type="date" required="No" displayname="Cese">
  <cfargument name="CTcobrable" type="string" required="Yes" displayname="Uso de cuenta">
  <cfargument name="CTrefComision" type="string" required="No" default="" displayname="Referencia cobro comisiones">
  <cfargument name="CCclaseCuenta" type="numeric" required="No" displayname="Código clase de cuenta">
  <cfargument name="GCcodigo" type="numeric" required="No" displayname="Código Grupo de cobro">
  <cfargument name="CTpagaImpuestos" type="boolean" required="Yes"  displayname="Paga impuestos ?">
  <cfargument name="Habilitado" type="numeric" required="Yes"  displayname="Habilitado">
  <cfargument name="CTobservaciones" type="string" required="No" default="" displayname="Observaciones">
  <cfargument name="CTcomision" type="numeric" required="No" displayname="Monto de comisión">
  <cfargument name="CTtipoUso" type="string" required="Yes"  displayname="Tipo de uso de cuenta">


	<cfif Not IsDefined("Arguments.ECidEstado")>
		<cfquery datasource="#session.dsn#" name="buscar_el_ECidEstado_default">
			select ECidEstado
			from ISBcuentaEstado
			where ECestado = 0
			  and ECsubEstado = 1
		</cfquery>
		<cfif buscar_el_ECidEstado_default.RecordCount is 0>
			<cfthrow message="Error de parametrizacion: No existe el estado de cuentas (ISBcuentaEstado) con estado y subestado (0,1)">
		</cfif>
		<cfset Arguments.ECidEstado = buscar_el_ECidEstado_default.ECidEstado>
	</cfif>

	<cfquery datasource="#session.dsn#" name="rsAlta">
		insert into ISBcuenta (
			Pquien,
			CUECUE,
			ECidEstado,
			
			CTapertura,
			CTdesde,
			
			CThasta,
			CTcobrable,
			CTrefComision,
			CCclaseCuenta,
			
			GCcodigo,
			CTmodificacion,
			CTpagaImpuestos,
			Habilitado,
			
			CTobservaciones,
			BMUsucodigo,
			CTcomision,
			CTtipoUso
		)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pquien#" null="#Len(Arguments.Pquien) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CUECUE#" null="#Len(Arguments.CUECUE) Is 0#">,
			<cfif isdefined("Arguments.ECidEstado") and Len(Trim(Arguments.ECidEstado)) NEQ 0><cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ECidEstado#"><cfelse>null</cfif>,
			
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CTapertura#" null="#Len(Arguments.CTapertura) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CTdesde#" null="#Len(Arguments.CTdesde) Is 0#">,
			
			<cfif isdefined("Arguments.CThasta") and Len(Trim(Arguments.CThasta)) NEQ 0><cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.CThasta#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTcobrable#" null="#Len(Arguments.CTcobrable) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTrefComision#" null="#Len(Arguments.CTrefComision) Is 0#">,
			<cfif isdefined("Arguments.CCclaseCuenta") and Len(Trim(Arguments.CCclaseCuenta)) NEQ 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.CCclaseCuenta#"><cfelse>null</cfif>,
			
			<cfif isdefined("Arguments.GCcodigo") and Len(Trim(Arguments.GCcodigo)) NEQ 0><cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.GCcodigo#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#Arguments.CTpagaImpuestos#" null="#Len(Arguments.CTpagaImpuestos) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_smallint" value="#Arguments.Habilitado#" null="#Len(Arguments.Habilitado) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTobservaciones#" null="#Len(Arguments.CTobservaciones) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfif IsDefined("Arguments.CTcomision")><cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CTcomision#" null="#Len(Arguments.CTcomision) Is 0#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CTtipoUso#" null="#Len(Arguments.CTtipoUso) Is 0#">
		)
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="rsAlta" verificar_transaccion="false">

	<cfreturn rsAlta.identity>	
	
</cffunction>

</cfcomponent>

