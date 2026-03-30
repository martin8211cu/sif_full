<cfinclude template="../../tpid.cfm">
<!---
<cfinclude template="../config.cfm">
--->
<cfset arr = ListtoArray(form.cuentas, "|")>

<cfquery datasource="sdc" name="rscuenta">
	select Iaba, convert (varchar, CBTcodigo) as CBTcodigo,
		CBcodigo, convert (varchar, Mcodigo) as Mcodigo, CBofxacctkey, CBofxusuario
	from CtaBancaria
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and Iaba      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arr[2]#">
	  and CBTcodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arr[3]#">
	  and CBcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arr[1]#">
</cfquery>


<cfquery datasource="sdc" name="rscuenta">
	select SbancoDisp
		from SaldoCuenta
	where Iaba      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arr[2]#">
	  and CBTcodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arr[3]#">
	  and CBcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arr[1]#">
</cfquery>

<cfif rscuenta.RecordCount EQ 0>
<cflocation url="trpass04.cfm?TPID=#TPID#&papa=#form.papa#&disponible=#Rand()*1000000#" >
<cfelse>
<cflocation url="trpass04.cfm?TPID=#TPID#&papa=#form.papa#&disponible=#rscuenta.SbancoDisp#" >
</cfif>


<!---

<cfif rscuenta.RecordCount EQ 0>
	<cflocation url="error.cfm?msg=cuenta-no-existe">
</cfif>
<cftry>
	<cfinclude template="bancoejb.cfm">
	
	<cfset cuenta=#cuentaDTO(rscuenta.Iaba, rscuenta.CBTcodigo, rscuenta.CBcodigo, rscuenta.Mcodigo, rscuenta.CBofxacctkey)#>

	<!--- obtener el saldo de la cuenta --->
	<cfset saldoret = banco.consultarSaldo(
		 rscuenta.CBofxusuario, form.papa, cuenta)>
		 
	<cfcatch>
		<cfset cfcatch.Type ="Any">
		<!--- <cflocation url="../errorPages/BDerror.cfm" addtoken="no"> --->
		<cfoutput>Se presentó el siguiente error: <strong>#cfcatch.Message#</strong> </cfoutput>  
		<cflocation url="../error.cfm?msg=#cfcatch.Message#" >
	</cfcatch>
</cftry>

<!--- Guardar el estado del tramite --->
<cfset arr = ListtoArray(form.cuentas, "|")>
<cfquery datasource="sdc">
	update TramitePasaporte
	set Iaba      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arr[2]#">,
		CBTcodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#arr[3]#">,
		CBcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arr[1]#">
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and TPID = #TPID#
</cfquery>

<cflocation url="../trpass04.cfm?TPID=#TPID#&papa=#form.papa#&disponible=#saldoret.getSaldoDisponible()#" >
--->