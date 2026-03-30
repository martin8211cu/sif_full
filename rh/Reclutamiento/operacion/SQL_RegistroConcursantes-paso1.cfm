<cftransaction>
<cfif isdefined("Form.BORRAR")  and len(trim(Form.BORRAR)) GT 0> 
	<!---*******************************--->
	<!--- Borra un participante         --->
	<!---*******************************--->
	<cfquery name="delConcursos" datasource="#Session.DSN#">
		delete from RHConcursantes
			where RHCconcurso  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
			and   RHCPid       = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCPid#">
	</cfquery>
<cfelseif isdefined("Form.ALTA")  and len(trim(Form.ALTA)) GT 0> 

	<!---*******************************--->
	<!--- agrega un participante        --->
	<!---*******************************--->
		<cfquery name="busConcursos" datasource="#Session.DSN#">
			select <cfif isdefined("Form.TipoConcursante") and TipoConcursante EQ 'I'>DEid<cfelse>RHOid </cfif>
			from RHConcursantes
			where RHCconcurso  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
			<cfif isdefined("Form.TipoConcursante") and TipoConcursante EQ 'I'>
				and   DEid         = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
			<cfelse>
				and   RHOid         = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHOid#">			
			</cfif>
		</cfquery>
	<cfif busConcursos.recordcount eq 0>
		<cfquery name="insConcursos" datasource="#Session.DSN#">
			insert into RHConcursantes               
			(	RHCconcurso,  
				Ecodigo,
				RHCPtipo,
				RHCPpromedio,
				Usucodigo,
				BMUsucodigo, 
				<cfif isdefined("Form.TipoConcursante") and TipoConcursante EQ 'I'>
				DEid
				<cfelse>
				RHOid
				</cfif>
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.TipoConcursante#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
				<cfif isdefined("Form.TipoConcursante") and TipoConcursante EQ 'I'>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
				<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHOid#">
				</cfif>
			)
		</cfquery>	
	<cfelse>
		<script language="javascript" type="text/javascript">
			alert("Este participante ya fue agregado");
			
		</script>
	</cfif>		
</cfif>
</cftransaction>