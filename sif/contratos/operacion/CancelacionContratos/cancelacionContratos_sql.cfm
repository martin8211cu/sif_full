<!--- <cf_dump var = "#url#"> --->

<!--- JMRV. 12/08/2014. --->

<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfset CTContid = "#url.CTContid#">
<cfset razonCancelacion = "#url.razonCancelacion#">
<cfset cancelado = 2>

<cftransaction>
	<cftry>
		
		<!--- Cambia el estatus del contrato a "Cancelado" --->
		<cfquery datasource="#session.dsn#">
			update CTContrato
			set CTCestatus = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cancelado#">
				where Ecodigo = #Session.Ecodigo#
				and  CTContid = #CTContid#  
		</cfquery>
		
		<!--- Inserta la razon de cancelacion en los detalles del contrato --->
		<cfquery datasource="#session.dsn#">
			update CTDetContrato
			set MotivoCancelacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#razonCancelacion#">
				where Ecodigo = #Session.Ecodigo#
				and  CTContid = #CTContid#  
		</cfquery>

        <cfcatch type="database">
 			<cftransaction action="rollback">
           <cfabort showerror="#cfcatch.detail#"><!---NativeErrorCode o detail--->
          </cfcatch>
        </cftry>
     </cftransaction>
     
<cflocation url="cancelacionContratos-lista.cfm">

