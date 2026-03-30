<cfif isdefined("form.id_bancosoin") and isdefined("form.cuentasoin") and isdefined("form.id_bancoarq") and isdefined("form.cuentaarq")>

	<cfif form.id_bancosoin neq "" and form.cuentasoin neq "" and form.id_bancoarq neq "" and form.cuentaarq neq "">
	
		<!--- Verifica si la cuenta existe en las tabla de soin --->
		<cfquery datasource="#session.Fondos.dsn#" name="ExtSoin">
		Select A.B01COD, B.BANCUE
		from B01ARC A, BANARC B
		where A.B01COD = B.B01COD
		  and A.B01COD = '#id_bancosoin#'
		  and B.BANCUE = '#cuentasoin#'		
		</cfquery>
		
		<!--- Verifica si la cuenta existe en las tabla de arquitectura --->
		<cfquery datasource="#session.Fondos.dsn#" name="ExtArqui">
		Select A.id_banco, B.cuenta_corriente
		from arquitectura..EBA01C A, arquitectura..EBA02C B
		where A.id_banco = B.id_banco
		  and A.id_banco = #id_bancoarq#
		  and B.cuenta_corriente = '#cuentaarq#'		
		</cfquery>	
		
		<cfif ExtSoin.recordcount gt 0 and ExtArqui.recordcount gt 0>
		
			<cfquery datasource="#session.Fondos.dsn#" name="VerificaCuentas">
			Select * from CJINT03
			where id_bancosoin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_bancosoin#">
			  and cuentasoin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentasoin#">
			  and id_bancoarq = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_bancoarq#">
			  and cuentaarq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentaarq#">
			</cfquery>
	
			<cfif VerificaCuentas.recordcount eq 0>
			
				<cfquery datasource="#session.Fondos.dsn#" name="InsCuentas">
				INSERT INTO CJINT03(id_bancosoin, cuentasoin, id_bancoarq, cuentaarq)
				VALUES('#form.id_bancosoin#', '#form.cuentasoin#', #form.id_bancoarq#, '#form.cuentaarq#')
				</cfquery>
				
				<script>			
				document.location = "cjc_MantenimientoBancos.cfm";
				</script>
				<cfabort>
			
			<cfelse>
				<script>
				alert("Las cuentas que usted esta ingresando ya estan asociadas");					
				document.location = "cjc_MantenimientoBancos.cfm";
				</script>
				<cfabort>
			</cfif>
	
		<cfelse>			
			<script>
			alert('Datos invalidos. Alguna de las cuentas podría no ser válida');					
			document.location = "cjc_MantenimientoBancos.cfm";
			</script>
			<cfabort>		
		</cfif>	
		
	
	</cfif>

</cfif>
<cflocation addtoken="no" url="cjc_MantenimientoBancos.cfm">
