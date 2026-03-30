<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de febrero del 2006
	Motivo: Actualizacin de fuentes de educación a nuevos estndares de Pantallas y Componente de Listas.
 ---> 
<cfset params="">
<cfset pagina = "1">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="rsMaxMorden" datasource="#session.Edu.DSN#">
				select coalesce(max(m.Morden),0)+10  as Morden
				from Nivel n
				inner join Grado g
				   on n.Ncodigo = g.Ncodigo
				inner join Materia m
				   on g.Ncodigo = m.Ncodigo
				  and g.Gcodigo = m.Gcodigo
				where n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  and m.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
				  and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
			</cfquery>
			<cfquery name="rsInsertM" datasource="#session.Edu.DSN#">
				insert into Materia (
						<cfif isdefined("Form.Melectiva") and form.Melectiva NEQ 'S'> 
							Gcodigo, 
						</cfif>
						Ncodigo, MTcodigo, EVTcodigo, Mcodigo, Mnombre, Mobservaciones, Mreglamentos,
						Mhoras, Mcreditos, Mtipoevaluacion, Melectiva, Morden 
						<cfif isdefined("Form.EPcodigo") and (form.Melectiva EQ 'R' or form.Melectiva EQ 'S' )> 
							,EPcodigo
						</cfif>
						, Mactiva
						)
				values(
					<cfif isdefined("Form.Melectiva") and form.Melectiva NEQ 'S'> 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">, 
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MTcodigo#">,
					<cfif Form.Mtipoevaluacion NEQ "-1">
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mtipoevaluacion#">,
					<cfelse>
						null,	
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mobservaciones#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mreglamentos#">,
					<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Mhoras#">,
					<cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Mcreditos#">,
					<cfif Form.Mtipoevaluacion NEQ "-1">
						<cfqueryparam cfsqltype="cf_sql_char" value="1">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_char" value="0">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Melectiva#">,
					<cfif #len(trim(Form.Morden))# NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Morden#">
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxMorden.Morden#">
					</cfif>
					<cfif isdefined("Form.EPcodigo") and (form.Melectiva EQ 'R' or form.Melectiva EQ 'S' )> 
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPcodigo#">
					</cfif>
					,<cfqueryparam value="#Form.Mactiva#" cfsqltype="cf_sql_bit">)
				<cf_dbidentity1 datasource="#session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertM">
		</cftransaction>
		<cfset form.Mconsecutivo = rsInsertM.identity>
		<cfset pagina = form.Pagina>
		<cfset params=params&"Mconsecutivo="&rsInsertM.identity>
		<cfquery name="rsInsertECM" datasource="#session.Edu.DSN#">
			select m.Mconsecutivo, pe.PEcodigo, ep.ECcodigo, ep.EPCporcentaje
			from Materia m
			inner join EvaluacionPlanConcepto ep
			   on m.EPcodigo = ep.EPcodigo
			inner join PeriodoEvaluacion pe
			   on m.Ncodigo = pe.Ncodigo
			where m.Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mconsecutivo#">
			  and (m.Melectiva = 'R' or m.Melectiva = 'S')
		</cfquery>
	<cfelseif isdefined('form.Cambio')>
		<cfquery name="rsMaxMorden" datasource="#session.Edu.DSN#">
			 select coalesce(max(m.Morden),0)+10 as Morden 
			from Nivel n
			inner join Grado g
			   on n.Ncodigo = g.Ncodigo
			inner join Materia m
			   on g.Ncodigo = m.Ncodigo
			  and g.Gcodigo = m.Gcodigo
			where n.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and m.Ncodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ncodigo#">
			  and m.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">
			  and m.Mconsecutivo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		</cfquery>
		<cfquery name="rsUpdateM" datasource="#session.Edu.DSN#">
			update Materia 
			set
			<cfif isdefined("Form.Melectiva") and form.Melectiva NEQ 'S'>
				Gcodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Gcodigo#">, 
			<cfelse>
				Gcodigo         = null, 
			</cfif>
			MTcodigo 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MTcodigo#">, 
			<cfif Form.Mtipoevaluacion NEQ "-1">
				EVTcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mtipoevaluacion#">,
			<cfelse>
				EVTcodigo 	= null,	
			</cfif>
			Mnombre 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mnombre#">,
			Mobservaciones 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mobservaciones#">, 
			Mreglamentos 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Mreglamentos#">,
			Mhoras			= <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Mhoras#">,
			Mcreditos		= <cfqueryparam cfsqltype="cf_sql_smallint" value="#Form.Mcreditos#">,
			<cfif Form.Mtipoevaluacion NEQ "-1">
				Mtipoevaluacion = <cfqueryparam cfsqltype="cf_sql_char" value="1">,
			<cfelse>
				Mtipoevaluacion = <cfqueryparam cfsqltype="cf_sql_char" value="0">,
			</cfif>
			Melectiva 		= <cfqueryparam  cfsqltype="cf_sql_char" value="#Form.Melectiva#">,
			<cfif #len(trim(Form.Morden))# NEQ 0>
				Morden      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Morden#">
			<cfelse>
				Morden      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxMorden.Morden#">	
			</cfif>
			,Mactiva 		= <cfqueryparam cfsqltype="cf_sql_bit" value="#Form.Mactiva#">
			where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		</cfquery>
		<cfset pagina = form.Pagina>
		<cfset params=params&"Mconsecutivo="&Form.Mconsecutivo>
	<cfelseif isdefined('form.Baja')>
		<cfquery name="rsConsultaC" datasource="#session.Edu.DSN#">
			select Ccodigo
			from Curso 
			where Mconsecutivo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
		</cfquery>
		<cfif isdefined('rsConsultaC') and rsConsultaC.RecordCount EQ 0>
			<cfquery name="rsDeleteME" datasource="#session.Edu.DSN#">
				delete from MateriaElectiva
				where (Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
				   or Melectiva = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">)
			</cfquery>
			<cfquery name="rsDeleteEM" datasource="#session.Edu.DSN#">
				delete from EvaluacionMateria
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			</cfquery>
			<cfquery name="rsDeleteECM" datasource="#session.Edu.DSN#">
				delete from EvaluacionConceptoMateria
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			</cfquery>
			<cfquery name="rsDeleteGS" datasource="#session.Edu.DSN#">
				delete from GradoSustitutivas
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			</cfquery>
			<cfquery name="rsDeleteM" datasource="#session.Edu.DSN#">
				delete from Materia
				where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mconsecutivo#">
			</cfquery>

		</cfif>
	</cfif>
</cfif>

<cfif isdefined('form.Baja')>
	<cflocation url="listaMaterias.cfm?Pagina=#pagina#&Filtro_Mcodigo=#Form.Filtro_Mcodigo#&Filtro_MTdescripcion=#Form.Filtro_MTdescripcion#&Filtro_Mnombre=#Form.Filtro_Mnombre#&Filtro_Melectiva=#Form.Filtro_Melectiva#&FGcodigoC=#form.FGcodigoC#&FNcodigoC=#Form.FNcodigoC#&HFiltro_Mcodigo=#Form.Filtro_Mcodigo#&HFiltro_MTdescripcion=#Form.Filtro_MTdescripcion#&HFiltro_Mnombre=#Form.Filtro_Mnombre#&HFiltro_Melectiva=#Form.Filtro_Melectiva#">
<cfelse>
	<cflocation url="Materias.cfm?Pagina=#pagina#&Filtro_Mcodigo=#Form.Filtro_Mcodigo#&Filtro_MTdescripcion=#Form.Filtro_MTdescripcion#&Filtro_Mnombre=#Form.Filtro_Mnombre#&Filtro_Melectiva=#Form.Filtro_Melectiva#&FGcodigoC=#form.FGcodigoC#&FNcodigoC=#Form.FNcodigoC#&HFiltro_Mcodigo=#Form.Filtro_Mcodigo#&HFiltro_MTdescripcion=#Form.Filtro_MTdescripcion#&HFiltro_Mnombre=#Form.Filtro_Mnombre#&HFiltro_Melectiva=#Form.Filtro_Melectiva#&#params#">
</cfif>