<cfif isdefined("form.id_bancosoin") and isdefined("form.cuentasoin") and isdefined("form.id_bancoarq") and isdefined("form.cuentaarq")>

	<cfif form.id_bancosoin neq "" and form.cuentasoin neq "" and form.id_bancoarq neq "" and form.cuentaarq neq "">
	
		<cfquery datasource="#session.Fondos.dsn#" name="VerificaCuentas">
		Select * from CJINT03
		where id_bancosoin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_bancosoin#">
		  and cuentasoin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentasoin#">
		  and id_bancoarq = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_bancoarq#">
		  and cuentaarq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentaarq#">
		</cfquery>
	
		<cfif VerificaCuentas.recordcount eq 0>
		
			<cfquery datasource="#session.Fondos.dsn#" name="InsCuentas">
			UPDATE CJINT03
			set id_bancoarq  = #form.id_bancoarq#, 
				cuentaarq    = '#form.cuentaarq#'
			where id_bancosoin = '#form.id_bancosoin#'
			  and cuentasoin   = '#form.cuentasoin#'
			</cfquery>
			
			<cfoutput>
			<script>			
			document.location = "cjc_MantenimientoBancos.cfm?id_bancosoin=#form.id_bancosoin#&cuentasoin=#form.cuentasoin#";
			</script>
			<cfabort>
			</cfoutput>
		
		<cfelse>
			<cfoutput>
			<script>
			alert("Imposible modifcar la cuenta, ya que ya existe una cuenta igual.");					
			document.location = "cjc_MantenimientoBancos.cfm?id_bancosoin=#form.id_bancosoin#&cuentasoin=#form.cuentasoin#";
			</script>
			<cfabort>
			</cfoutput>
		</cfif>
	
	</cfif>

</cfif>
<cflocation addtoken="no" url="cjc_MantenimientoBancos.cfm">
