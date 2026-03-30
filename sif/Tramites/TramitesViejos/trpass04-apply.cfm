<cfinclude template="tpid.cfm">
<cfinclude template="config.cfm">

<!---cftry--->
	<cfinclude template="bancoejb.cfm">
	<CFOBJECT action=create name=comision    type="JAVA" class="java.math.BigDecimal">

	<CFOBJECT action=create name=MonedaDestino type="JAVA" class="java.math.BigDecimal">
	<CFOBJECT action=create name=CBTCodDestino type="JAVA" class="java.math.BigDecimal">

	<cfset comision.init('0')>
	<cfset MonedaDestino.init('2')> <!--- dolares --->
	<cfset CBTCodDestino.init('1')>  <!--- 1-ahorro --->
	<cfset IabaDestino = '98765'> <!--- banco bcr --->
	<cfset CBcodigoDestino = '00101635784'> <!--- la cuenta de migracion --->
	<cfset cuentaO=#cuentaDTO(tramite.Iaba, tramite.CBTcodigo, tramite.CBcodigo, tramite.Mcodigo, tramite.CBofxacctkey)#>
	<!--- la cuenta de migracion --->
	<cfset cuentaD=#cuentaDTO(IabaDestino, CBTCodDestino, CBcodigoDestino, MonedaDestino, '1111111')#>
	<cfset TIcodigo = banco.preparaTransferencia(
		 cuentaO, cuentaD, new_BigDecimal(tramite.Mcodigo), true, 'Pago por pasaporte')>
		 
	<cfquery datasource="sdc">
		update TramitePasaporte
		set Avance     = '4',
			TIcodigo   = <cfqueryparam cfsqltype="cf_sql_decimal" value="#TIcodigo#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
		  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
		  and TPID = #TPID#
	</cfquery>
	
	<cfset numerito = banco.transferir(
			TIcodigo, tramite.CBofxusuario, form.papa,
		    tramite.Importe, comision) >
	<!---cfcatch>
		<cflocation url="error.cfm?msg=#cfcatch.Message#" >
		<cfrethrow>
	</cfcatch>
</cftry--->

<cfoutput>
TIcodigo: #TIcodigo#<br>
numerito: #numerito#<br>
</cfoutput>

<!--- Guardar el estado del tramite: 5 = Pago complatado --->
<cfquery datasource="sdc">
	update TramitePasaporte
	set Avance     = '5',
		Pagado     = 1,
		IabaD      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#IabaDestino#">,
		CBTcodigoD = <cfqueryparam cfsqltype="cf_sql_decimal" value="#CBTCodDestino.toString()#">,
		CBcodigoD  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CBcodigoDestino#">,
		TIcodigo   = <cfqueryparam cfsqltype="cf_sql_decimal" value="#TIcodigo#">
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and TPID = #TPID#
</cfquery>

<cflocation url="trpass05.cfm?TPID=#TPID#&numerito=#numerito#" >