<!--- <cf_dump var="#form#"> --->
<cfif isdefined ("Form.flag") and isdefined("Anterior")>
	<cfset Form.paso = 0>
	<cfset Form.flag = 1>
</cfif>
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
			<cfif isdefined("Form.Alta")>
				<cfset estado = 15>
				<cfquery name="insConcursos" datasource="#Session.DSN#">			
					insert INTO RHConcursos (Ecodigo, RHCcodigo, RHCdescripcion, CFid, RHCfecha, RHPcodigo, RHCcantplazas, 
											RHCfapertura, RHCfcierre, RHCmotivo, RHCotrosdatos, 
											<cfif not isdefined("Form.flag")>RHCestado,</cfif>Usucodigo, BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCcodigo#">)),
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCdescripcion#">)),
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#Form.INFecha#">,
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">)),
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCcantplazas#">,
						 <cfif not isdefined("Form.flag")>
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaA)#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaC)#">,
						 <cfelse>
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 </cfif>
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.LAMotivo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCotrosdatos#">,
						 <cfif not isdefined("Form.Flag")><cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,</cfif> 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insConcursos">			
				<cfset Form.RHCconcurso = insConcursos.identity>
				<cfquery name="rsRHHabilidadesConcursoIns" datasource="#session.DSN#">
					insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo, 
														RHCPpeso, BMUsucodigo)
					select #insConcursos.identity#, RHHid, 'H' as tipocompetencia, #session.Ecodigo#, 
							coalesce (RHNnotamin,0)as RHNnotamin,
						   #Session.Usucodigo#, coalesce(RHHpeso,0) as RHHpeso, #Session.Usucodigo#
					from RHHabilidadesPuesto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">		
				</cfquery>
				<cfquery name="rsRHConocimientosConcursoIns" datasource="#session.DSN#">
					insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo, 
														RHCPpeso, BMUsucodigo)
					select #insConcursos.identity#, RHCid, 'C' as tipocompetencia, #session.Ecodigo#, 
					coalesce (RHCnotamin,0) as RHCnotamin,
					#Session.Usucodigo#, coalesce (RHCpeso,0) as RHCpeso, #Session.Usucodigo#
					from RHConocimientosPuesto
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">
				</cfquery>
				
				<cfquery name="rsPruebasComp" datasource="#session.DSN#">
					select  distinct RHPcodigopr, count (RHPcodigopr) as cant
					from RHCompetenciasConcurso a inner join  RHPruebasCompetencia b
						on  a.Ecodigo 		  = b.Ecodigo 
						and a.Idcompetencia   = b.id
						and a.tipocompetencia = b.RHPCtipo
					where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
					group by b.RHPcodigopr
				</cfquery>
				<cfif isdefined("rsPruebasComp") and rsPruebasComp.RecordCount GT 0>
					<cfquery name="rsPeso" dbtype="query">
						select sum(cant) as total
						from rsPruebasComp
					</cfquery>
					<cfset peso = (1/rsPeso.total) * 100>
					<cfquery name="insRHPruebasConcurso" datasource="#session.DSN#">
						<cfloop query="rsPruebasComp">
							insert into RHPruebasConcurso (RHCconcurso, Ecodigo, RHPcodigopr, Cantidad, Peso, BMUsucodigo)
							values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rsPruebasComp.RHPcodigopr#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPruebasComp.cant#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#(peso * rsPruebasComp.cant)#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
						</cfloop>
					</cfquery>
				</cfif>				
			<cfelseif isdefined("Form.Baja")> 
				<cfquery name="delRHConcursantes" datasource="#Session.DSN#">
					delete from RHConcursantes
					where exists (
						select 1 
						from RHPlazasConcurso a
						where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					)
				</cfquery>
				<cfquery name="delRHCompetenciasConcurso" datasource="#Session.DSN#">
					delete from RHCompetenciasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				<cfquery name="delRHPlazasConcurso" datasource="#Session.DSN#">
					delete from RHPlazasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				 <cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
					delete from RHAreasEvalConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				<cfquery name="delRHPruebasConcurso" datasource="#session.DSN#">
					delete from RHPruebasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">					
				</cfquery>
				<cfquery name="delRHConcursos" datasource="#Session.DSN#">
					delete from RHConcursos
					where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				<cfset Form.RHCconcurso = 0>
				<cfset Form.paso = 0>

			<cfelseif isdefined("Form.Cambio") or isdefined("Form.SIGUIENTE") and Form.pasoante EQ 1>
 				 <cfquery name="rsBuscaPuestoActual" datasource="#Session.DSN#">
					select RHPcodigo
					from RHConcursos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>

				<cf_dbtimestamp
					datasource="#session.DSN#"
					table="RHConcursos"
					redirect="ConcursoProceso-paso1-SQL.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#">

				<cfquery name="updRHConcursos" datasource="#Session.DSN#">
					update RHConcursos set 
						RHCcodigo 		= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCcodigo#">,
						RHCdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCdescripcion#">, 
						CFid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
						RHCfecha		= <cfqueryparam cfsqltype="cf_sql_date" value="#Form.INFecha#">,
						RHPcodigo		= rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">)),
						RHCcantplazas 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCcantplazas#">,
						<cfif not isdefined("form.flag")>
						RHCfapertura	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaA)#">,
						RHCfcierre		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaC)#">,
						</cfif>
						RHCmotivo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.LAMotivo#">, 
						RHCotrosdatos	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCotrosdatos#">,
						BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>

				<cfif rtrim(rsBuscaPuestoActual.RHPcodigo) NEQ rtrim(form.RHPcodigo)>
				<!--- Al poder modificarse el puesto deben borrarse las competencias del concurso y volverlas a insertar para aegurarse 
					  de tener actualizados los datos en el paso 3 --->
					<cfquery name="delRHPlazasConcurso" datasource="#session.DSN#">
						delete from RHPlazasConcurso
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
					</cfquery>
					<cfquery name="delRHAreasEvalConcurso" datasource="#Session.DSN#">
						delete from RHAreasEvalConcurso
						where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					</cfquery>					  
					<cfquery name="delRHCompetenciasPlaza" datasource="#Session.DSN#">
						delete from RHCompetenciasConcurso
						where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
					</cfquery>
					<cfquery name="rsRHHabilidadesConcursoIns" datasource="#session.DSN#">
						<!--- preguntar si se pueden inicializar peso, notamin en 0 si no están para que no MFT el insert --->
						insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, Usucodigo, 
															RHCPpeso, BMUsucodigo)
						select #form.RHCconcurso#, RHHid, 'H' as tipocompetencia, #session.Ecodigo#, coalesce (RHNnotamin,0) as RHNnotamin,
						#Session.Usucodigo#, coalesce (RHHpeso,0) as RHHpeso, #Session.Usucodigo#
						from RHHabilidadesPuesto
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">		
					</cfquery>
					<cfquery name="rsRHConocimientosConcursoIns" datasource="#session.DSN#">
						insert into RHCompetenciasConcurso (RHCconcurso, Idcompetencia, tipocompetencia, Ecodigo, RHnotamin, 
															Usucodigo, RHCPpeso, BMUsucodigo)
						select #form.RHCconcurso#, RHCid, 'C' as tipocompetencia, #session.Ecodigo#, coalesce (RHCnotamin,0) as RHCnotamin,
						#Session.Usucodigo#, coalesce (RHCpeso,0) as RHCpeso, #Session.Usucodigo#
						from RHConocimientosPuesto
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and rtrim(RHPcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.RHPcodigo)#">
					</cfquery>
	 			</cfif>
				<cfif isdefined("Form.SIGUIENTE") and Form.pasoante EQ 1>
					<cfset form.paso = 2>
				</cfif>
				
			<cfelseif isdefined("Form.Aplicar")>
				<cf_dbtimestamp
					datasource="#session.DSN#"
					table="RHConcursos"
					redirect="ConcursoProceso-paso1-SQL.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#">
				<cfquery name="updRHConcursos" datasource="#Session.DSN#">
					update RHConcursos set 
						RHCestado 	 = 10,
						BMUsucodigo	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
				</cfquery>
				<cfset Form.paso = 0>
				<cfset Form.flag = 1>
			</cfif>
	</cfif>
</cftransaction>