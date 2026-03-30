
<cfset modoCCursos = "ALTA">
<cfif not isdefined("Form.NuevoCur")>
	<cfif datecompare(LSParseDateTime(form.RHCfdesde1), LSParseDateTime(form.RHCfhasta1)) eq 1 >
		<cfset tmp = form.RHCfdesde1 >
		<cfset form.RHPfdesde1 = form.RHCfhasta1 >
		<cfset form.RHCfhasta1 = tmp >
	</cfif>
	<cfif isdefined("Form.AltaCur")>		 		
		<cftransaction>
			<cfquery name="inserta" datasource="#Session.DSN#">
				insert into RHProgramacionCursos(Ecodigo, DEid, RHCid, RHACid, RHIAid, Mcodigo, RHPCfdesde, RHPCfhasta, BMUsucodigo, BMfecha)
				values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid1#">,
						null,
						<cfif isdefined("form.RHIAid1") and len(trim(form.RHIAid1))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid1#">
						<cfelse>
							null
						</cfif>,
						<cfif isdefined("form.Mcodigo1") and len(trim(form.Mcodigo1))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo1#">
						<cfelse>
							null
						</cfif>,	
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfdesde1)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfhasta1)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
		</cftransaction>
		<cfset modoCCursos="ALTA">
		
		<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="expediente"> 
		<cfif isdefined("form.RHPCid")>
			<cfset ID=form.RHPCid>
		<cfelseif isdefined("inserta")>
			<cfset ID= inserta.identity>
		</cfif>
		<cfset expediente.correos(form.DEid, session.Ecodigo, form.RHCid1,'', ID)>
		
	<cfelseif isdefined("Form.BajaCur")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHProgramacionCursos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">
		</cfquery>  
		<cfset modoCCursos="ALTA">

	<cfelseif isdefined("Form.CambioCur")>			
		<cf_dbtimestamp datasource="#session.dsn#"
						table="RHProgramacionCursos"
						redirect="ProgramInstaciaCurso-form.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHPCid" 
						type2="numeric" 
						value2="#form.RHPCid#"
						field3="DEid" 
						type3="numeric" 
						value3="#form.DEid#">			
		<cfquery name="update" datasource="#Session.DSN#">
			update RHProgramacionCursos
			set RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid1#">,
				RHIAid = <cfif isdefined("form.RHIAid1") and len(trim(form.RHIAid1))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIAid1#">
						<cfelse>
							null
						</cfif>,
				Mcodigo = <cfif isdefined("form.Mcodigo1") and len(trim(form.Mcodigo1))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo1#">
						<cfelse>
							null
						</cfif>,
				RHPCfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfdesde1)#">,					
				RHPCfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHCfhasta1)#">		
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">	
		</cfquery>
		<cfset modoCCursos="CAMBIO">
	</cfif>
</cfif>
<cfoutput>
<form action="ProgramInstaciaCurso-form.cfm" method="post" name="sqlCurProgram"><!----action="expediente.cfm"----->
	<input name="Mcodigo" type="hidden" value="#form.Mcodigo#">		
	<input name="DEid" type="hidden" value="#form.DEid#">	
	<input name="tab" type="hidden" value="#form.tab#">	
	<cfif isdefined("form.CambioCur")>
		<input name="RHPCid" type="hidden" value="#form.RHPCid#">
	</cfif>
</form>
</cfoutput>	
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
