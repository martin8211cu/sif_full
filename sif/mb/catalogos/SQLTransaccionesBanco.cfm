<!--- <cfdump var="#form#">
<cfdump var="#session#">
<cf_dump var="#url#"> --->

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
	#LvarPagina# Variable de redireccion segun sea el caso
--->

<cfset LvarPagina = "TransaccionesBanco.cfm">
    <cfset LvarBTEtce = 0>
<cfif isdefined("LvarTCESQLTransBancos")>
	<cfset LvarPagina = "TCETransaccionesBanco.cfm">
    <cfset LvarBTEtce = 1>
</cfif>

 <cfif isdefined("form.ALTA")>
	<cfquery name="rsinsert" datasource="#session.DSN#">
		insert into TransaccionesBanco 
		(Bid, 
		BTEcodigo, 
		BTEdescripcion, 
		BTEtipo, 
		BMUsucodigo,
        BTEtce)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.BTEdescripcion#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEtipo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTEtce#">  
			)
	</cfquery>
    
    <!---#LvarPagina# Variable de redireccion segun el caso--->
	<cflocation url="#LvarPagina#?Bid=#form.Bid#&BTEcodigo=#form.BTEcodigo#&modo=Cambio" addtoken="no">
<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update TransaccionesBanco
			set
				BTEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.BTEdescripcion#">,
				BTEtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEtipo#">
		where 
			Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
			and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">
	</cfquery>
    
        <!---#LvarPagina# Variable de redireccion segun el caso--->
	<cflocation url="#LvarPagina#?Bid=#form.Bid#&BTEcodigo=#form.BTEcodigo#&modo=Cambio" addtoken="no">
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from TransaccionesBanco
		where 
			Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
			and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">
	</cfquery>
    
        <!---#LvarPagina# Variable de redireccion segun el caso--->
	<cflocation url="#LvarPagina#?Bid=#form.Bid#&modo=ALTA" addtoken="no">
</cfif>

    <!---#LvarPagina# Variable de redireccion segun el caso--->
 <cflocation url="#LvarPagina#?Bid=#form.Bid#&modo=ALTA" addtoken="no">