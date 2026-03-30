<cfinclude template="../../tpid.cfm">

<!---
	Acciones validas segun el estado
				Accion
	Estado		N	P	R	E
	N			x
	V				x
	R				x	x
	E						x
		Accion
	N,E		N
	V,R		
--->

<cfif #form.accion# EQ "N">
	<!--- accion: pasaporte nuevo --->
	<cfif #tramite.Pestado# NEQ "N">
		<cflocation url="../error.cfm?msg=accion-invalida">
	</cfif>
	<cfset Importe = 45>
	<cfset Moneda = "USD">
<cfelseif #form.accion# EQ "P">
	<!--- accion: pasaporte perdido --->
	<cfif #tramite.Pestado# NEQ "V" AND #tramite.Pestado# NEQ "R">
		<cflocation url="../error.cfm?msg=accion-invalida">
	</cfif>
	<cfset Importe = 90>
	<cfset Moneda = "USD">
<cfelseif #form.accion# EQ "R">
	<!--- accion: revalidar a los cinco anios --->
	<cfif #tramite.Pestado# NEQ "R">
		<cflocation url="../error.cfm?msg=accion-invalida">
	</cfif>
	<cfset Importe = 1.75>
	<cfset Moneda = "USD">
<cfelseif #form.accion# EQ "E">
	<!--- accion: pasaporte nuevo a los diez anios --->
	<cfif #tramite.Pestado# NEQ "E">
		<cflocation url="../error.cfm?msg=accion-invalida">
	</cfif>
	<cfset Importe = 45>
	<cfset Moneda = "USD">
<cfelse>
	<!--- Accion invalida --->
	<cflocation url="../error.cfm?msg=accion-invalida">	
</cfif>

<cfquery datasource="sdc" name="buscarmoneda">
	select convert (varchar, Mcodigo) as Mcodigo
	from Moneda
	where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Moneda#">
</cfquery>
<cfset Mcodigo = buscarmoneda.Mcodigo>

<cfif buscarmoneda.RecordCount EQ 0 >
	<cflocation url="../error.cfm?msg=moneda-invalida">
</cfif>

<!--- Guardar el estado del tramite --->

<cfquery datasource="sdc">
	update TramitePasaporte
	set Avance = '3',
		Accion  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.accion#">,
		Mcodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Mcodigo#">,
		Importe = <cfqueryparam cfsqltype="cf_sql_money"   value="#Importe#">
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and TPID = #TPID#
</cfquery>

<cflocation url="trpass03.cfm?TPID=#TPID#" >
