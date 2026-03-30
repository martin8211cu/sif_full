<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.ALTA")>
		<cfquery name="rsRHAreasEvalConcursoInsert" datasource="#session.DSN#">
			insert into RHAreasEvalConcurso
			(RHCconcurso, RHEAid, Ecodigo, RHAECpeso, Usucodigo, BMUsucodigo)
			values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEAid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.RHEApeso#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.CAMBIO") or isdefined("Form.SIGUIENTE") or (isdefined("Form.modificaPesoC")) and Form.modificaPesoC EQ 'true' and not (isdefined("form.btnModificaPrueba"))><!--- and Form.modificaPesoC---->
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("Peso_", i) NEQ 0>				
				<cfset linea = Mid(i, 6, Len(i))>
				<cfif isdefined("form.Idcomp_#linea#") and isdefined("Form.tipocomp_#linea#")>
					<cfquery name="UpdRHCompetenciasConcurso" datasource="#session.DSN#">
						update RHCompetenciasConcurso
						set RHCPpeso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.peso_'&linea)#">
						where RHCconcurso 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
						  and Idcompetencia   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.Idcomp_'&linea)#">
						  and tipocompetencia = <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.tipocomp_'&linea)#">
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
		<cfif isdefined("Form.SIGUIENTE") and Form.pasoante EQ 3>
			<cfset form.paso = 4>
		</cfif>
	<cfelseif isdefined("Form.borrararea") and form.borrararea EQ 'true'>
		<cfquery name="rsRHAreasEvalConcursodel" datasource="#session.DSN#">
			delete from RHAreasEvalConcurso
			where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
			  and RHEAid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEAid#">
			  and Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	
	<cfelseif isdefined("form.btnModificaPrueba")>
		<cfif isdefined("Form.INDEX") and(Form.INDEX GT 0)>
			<cfloop from="1" to ="#Form.INDEX#" index="i">
				<cfquery name="updatePruebas" datasource="#Session.DSN#">
					 update RHPruebasConcurso  set 
					 Peso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form['PESO_#i#']#">
					 where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
					   and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
					   and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#form['RHPcodigopr_#i#']#">
				</cfquery>
			</cfloop>				
		</cfif>	
	</cfif>
</cfif>


