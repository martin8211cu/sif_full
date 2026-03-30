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
		
	<cfelseif isdefined("Form.btnModificaConceptos")>
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
					   and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					   and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#form['RHPcodigopr_#i#']#">
				</cfquery>
			</cfloop>				
		</cfif>	
		
	<cfelseif isdefined("form.RegCompetencias") and Form.RegCompetencias EQ 1>

		<cfquery name="delRHCompetenciasPlaza" datasource="#Session.DSN#">
			delete from RHCompetenciasConcurso
			where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		</cfquery>

		<cfquery name="rsRHHabilidadesConcursoIns" datasource="#session.DSN#">
			insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo, RHCPpeso, BMUsucodigo)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">, 
				   RHHid, 
				   'H' as tipocompetencia, 
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				   coalesce (RHNnotamin,0) as RHNnotamin,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				   coalesce(RHHpeso,0) as RHHpeso,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHHabilidadesPuesto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.ORHPcodigo)#">
		</cfquery>

		<cfquery name="rsRHConocimientosConcursoIns" datasource="#session.DSN#">
			insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo, RHCPpeso, BMUsucodigo)
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">, 
				   RHCid, 
				   'C' as tipocompetencia, 
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
				   coalesce (RHCnotamin,0) as RHCnotamin,
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				   coalesce (RHCpeso,0) as RHCpeso, 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHConocimientosPuesto
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.ORHPcodigo)#">
		</cfquery>

	<cfelseif isdefined("form.RegPruebas") and Form.RegPruebas EQ 1>

		<cfquery name="delRHCompetenciasPlaza" datasource="#Session.DSN#">
			delete from RHPruebasConcurso
			where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
		</cfquery>

		<cfquery name="rsPruebasComp" datasource="#session.DSN#">
			select  distinct RHPcodigopr, count(RHPcodigopr) as cant
			from RHCompetenciasConcurso a 
				inner join  RHPruebasCompetencia b
				on b.Ecodigo = a.Ecodigo
				and b.id = a.Idcompetencia
				and b.RHPCtipo = a.tipocompetencia
			where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
			group by b.RHPcodigopr
		</cfquery>
		<cfif isdefined("rsPruebasComp") and rsPruebasComp.RecordCount GT 0>
			<cfquery name="rsPeso" dbtype="query">
				select sum(cant) as total
				from rsPruebasComp
			</cfquery>
			<cfset peso = (1/rsPeso.total) * 100>
			<cfloop query="rsPruebasComp">
				<cfquery name="insRHPruebasConcurso" datasource="#session.DSN#">
					insert into RHPruebasConcurso (RHCconcurso, Ecodigo, RHPcodigopr, Cantidad, Peso, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#rsPruebasComp.RHPcodigopr#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPruebasComp.cant#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#(peso * rsPruebasComp.cant)#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					)
				</cfquery>
			</cfloop>
		</cfif>

		
	</cfif>
</cfif>
