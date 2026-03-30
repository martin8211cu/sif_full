
<cfif isdefined("URL.ETnumero") and len(trim(url.ETnumero)) gt 0 and isdefined("URL.FCid") and len(trim(url.FCid)) gt 0 >
	<cfset LvarNC = 0>
	<cfif isdefined("url.CGNC") and url.CGNC eq true>
    	<cfset LvarNC = 1>
    </cfif>
    
    <cfquery name="rsMoneda" datasource="#Session.DSN#">
    	update ETransacciones set
        ETnotaCredito = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarNC#"> ,
		ETgeneraVuelto = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarNC#">
        where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.FCid#">
        	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETnumero#">
    </cfquery>

<cfelse>
	<script language="javascript1.2" type="text/javascript">    
		window.parent.alert ('La caja o el numero de Transaccion son incorrectos, por favor vuelva a intentar');	
	</script>
</cfif>


