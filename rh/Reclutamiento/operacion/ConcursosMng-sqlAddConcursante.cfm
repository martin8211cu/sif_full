<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteParticipanteYaFueAgregado"
	Default="Este participante ya fue agregado"
	returnvariable="MSG_EsteParticipanteYaFueAgregado"/>
<!--- Chequear la existencia del concursante --->
<cfif isdefined("Form.btnAgregar")>
	<cfquery name="busConcursos" datasource="#Session.DSN#">
		select <cfif isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'I'>a.DEid<cfelse>a.RHOid</cfif>
		from RHConcursantes a
		where a.RHCconcurso  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		<cfif isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'I'>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid1#">
		<cfelse>
			and a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid2#">
		</cfif>
	</cfquery>
	
	<!--- Insertar el Concursante --->
	<cfif busConcursos.recordCount EQ 0>
		<cfquery name="insConcursos" datasource="#Session.DSN#">
			insert into RHConcursantes 
			(	RHCconcurso,  
				Ecodigo,
				RHCPtipo,
				RHCPpromedio,
				Usucodigo,
				BMUsucodigo, 
				<cfif isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'I'>
				DEid
				<cfelse>
				RHOid
				</cfif>
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoConcursante#">,
				0.00,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
				<cfif isdefined("Form.TipoConcursante") and Form.TipoConcursante EQ 'I'>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid1#">
				<cfelse>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOid2#">
				</cfif>
			)
		</cfquery>	
	<cfelse>
		<cf_throw message="#MSG_EsteParticipanteYaFueAgregado#" errorcode="3050">
	</cfif>
</cfif>