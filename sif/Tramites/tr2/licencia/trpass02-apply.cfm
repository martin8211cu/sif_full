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

<cfif #form.accion# EQ "2">
	<cfset Importe = 3200>
	<cfset Moneda = "CRC">
<cfelse>
	<cfset Importe = 3200>
	<cfset Moneda = "CRC">
</cfif>

<cfquery datasource="sdc" name="buscarmoneda">
	select convert (varchar, Mcodigo) as Mcodigo
	from Moneda
	where Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Moneda#">
</cfquery>
<cfset Mcodigo = buscarmoneda.Mcodigo>
<cfquery datasource="sdc">
	update TramitePasaporte
	set Avance = '3',
		Mcodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Mcodigo#">,
		Importe = <cfqueryparam cfsqltype="cf_sql_money"   value="#Importe#">
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and TPID = #TPID#
</cfquery>

<cfif buscarmoneda.RecordCount EQ 0 >
	<cflocation url="../error.cfm?msg=moneda-invalida">
</cfif>

<!--- Guardar el estado del tramite --->

<cflocation url="trpass03.cfm?TPID=#TPID#" >
