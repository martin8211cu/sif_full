<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_El_curso_ya_fue_asignado_al_empleado"
	Default="El curso ya fue asignado al empleado"
	returnvariable="MG_El_curso_ya_fue_asignado_al_empleado"/> 

<cfset modoCCursos = "ALTA">
<cfif not isdefined("Form.NuevoCur")>

	<cfif datecompare(LSParseDateTime(form.RHPCfdesde), LSParseDateTime(form.RHPCfhasta)) eq 1 >
		<cfset tmp = form.RHPCfdesde >
		<cfset form.RHPCfdesde = form.RHPCfhasta >
		<cfset form.RHPCfhasta = tmp >
	</cfif>
	
	<cfquery name="rsInst" datasource="#session.DSN#">
		select RHIAid
		from RHOfertaAcademica
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>

	<cfif isdefined("Form.AltaCur")>		 		
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select 1 
			from RHProgramacionCursos
			where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
				and RHPCfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHPCfdesde#">
				and RHPCfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.RHPCfhasta#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		
		<cfif isdefined("rsExiste") and rsExiste.Recordcount EQ 0>
			<cftransaction>
				<cfquery name="inserta" datasource="#Session.DSN#">
					insert into RHProgramacionCursos(Ecodigo, DEid, RHCid, RHACid, RHIAid, Mcodigo, RHPCfdesde, RHPCfhasta, BMUsucodigo, BMfecha)
					values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
							null,
							null,
							<cfif isdefined("rsInst") and len(trim(rsInst.RHIAid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInst.RHIAid#">
							<cfelse>
								null
							</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHPCfdesde)#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHPCfhasta)#">,
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
			<cfset expediente.correos(form.DEid, session.Ecodigo,'', form.Mcodigo, ID)>		
		<cfelse>
			<cf_throw message="#MG_El_curso_ya_fue_asignado_al_empleado#" errorcode="10085">
		</cfif>
		
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
						redirect="curProgramados-form.cfm"
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
			set RHIAid = <cfif isdefined("rsInst") and len(trim(rsInst.RHIAid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInst.RHIAid#">
						</cfif>,
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				RHPCfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHPCfdesde)#">,					
				RHPCfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHPCfhasta)#">		
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and RHPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPCid#">	
		</cfquery>
		<cfset modoCCursos="CAMBIO">
	</cfif>
</cfif>
<cfoutput>
<form action="curProgramados-form.cfm" method="post" name="sqlCurProgram"><!----action="expediente.cfm"----->
	<input name="DEid" type="hidden" value="#form.DEid#">
	<input type="hidden" name="tab" value="#form.tab#">	
	<input type="hidden" name="puesto" value="#form.puesto#">
	<input type="hidden" name="cf" value="#form.cf#">	
	<cfif isdefined("form.CambioCur")>
		<input name="RHPCid" type="hidden" value="#form.RHPCid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
