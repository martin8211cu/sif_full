<cfif isdefined("form.id_bancosoin") and isdefined("form.cuentasoin") and isdefined("form.id_bancoarq") and isdefined("form.cuentaarq")>

	<cfif form.id_bancosoin neq "" and form.cuentasoin neq "" and form.id_bancoarq neq "" and form.cuentaarq neq "">
					
			<cfquery datasource="#session.Fondos.dsn#" name="DelCuentas">
			DELETE CJINT03
			WHERE id_bancosoin = '#form.id_bancosoin#'
			  and cuentasoin   = '#form.cuentasoin#'
			  and id_bancoarq  = #form.id_bancoarq#
			  and cuentaarq    = '#form.cuentaarq#'
			</cfquery>					
					
	</cfif>

</cfif>
<cflocation addtoken="no" url="cjc_MantenimientoBancos.cfm">
