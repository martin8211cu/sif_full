<cfif isdefined("Form.btnDescalificar")>
	<!--- Eliminar todos los datos del concursante --->
	<cfquery name="delRHCalificaCompPrueOfer" datasource="#Session.DSN#">
		delete from RHCalificaCompPrueOfer
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
	</cfquery>
	
	<cfquery name="delRHCalificaPrueConcursante" datasource="#Session.DSN#">
		delete from RHCalificaPrueConcursante
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
	</cfquery>
	
	<cfquery name="delRHCalificaAreaConcursante" datasource="#Session.DSN#">
		delete from RHCalificaAreaConcursante
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
	</cfquery>
	
	<!--- Actualizar datos del Concursante --->
	<cfquery name="updConcursante" datasource="#session.DSN#">
		update RHConcursantes 
		set	RHCdescalifica = 1,
			RHCPpromedio = 0,
			RHCevaluado = 0,
			RHCrazondeacalifica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCrazondeacalifica#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
	</cfquery>
	
<cfelseif isdefined("Form.btnAceptar")>

	<!--- Actualizar datos del Concursante --->
	<cfquery name="updConcursante" datasource="#session.DSN#">
		update RHConcursantes 
		set	RHCrazondeacalifica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCrazondeacalifica#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		  and RHCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCPid#">
	</cfquery>
	
</cfif>