
<!--- Eduardo Gonzalez Sarabia (APH)
	  Limpia las preventas que estén en BTransito_CC después de ciertos días.
	  01/02/2019 --->
<cfsetting  requesttimeout="3600">

<cfset lVarDias = 3>

<cflock scope="Application" timeout="90">
	<cftransaction>
		<cftry>
			<cfset lVarDateAntes = createdate(YEAR(NOW() -lVarDias), MONTH(NOW() -lVarDias), DAY(NOW() -lVarDias))>

			<cfquery name="deleteTransito" datasource="#session.dsn#">
				DELETE BTransito_CC
				WHERE createdat <= <cfqueryparam cfsqltype="cf_sql_date" value='#lVarDateAntes#'>
				  AND Numero_Documento IS NULL
				  AND Monto > 0
			</cfquery>
			<cftransaction action="commit" />
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cflog file="Log_CleanTransitoCC" application="no" text="Error al limpiar la tabla BTransito_CC: #now()# --- [#cfcatch.message#]">
			</cfcatch>
		</cftry>
	</cftransaction>
</cflock>
