
<cfif isdefined("Form.BTNAPLICAR")> 
	<cfif isdefined("form.CONCURSO") and len(trim(form.CONCURSO)) gt 0> 
		<cfif form.CONCURSO eq 0>
		<cftransaction>
			<!--- CREA UN NUEVO CONCURSO Y LE AGREGA LOS CANDIDATOS --->
			<cfset estado = 15>
			<cfquery name="insConcursos" datasource="#Session.DSN#">			
				insert INTO RHConcursos (Ecodigo, RHCcodigo, RHCdescripcion, CFid, RHCfecha, RHPcodigo,RHCcantplazas, 
										RHCfapertura, RHCfcierre, RHCmotivo, RHCotrosdatos, 
										RHCestado,Usucodigo, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCcodigoN#">)),
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCdescripcionN#">)),
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
					 <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">)),
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCcantplazas#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaA)#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.FechaC)#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.LAMotivo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHCotrosdatos#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,
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
				<cfloop query="rsPruebasComp">
					<cfquery name="insRHPruebasConcurso" datasource="#session.DSN#">
						insert into RHPruebasConcurso (RHCconcurso, Ecodigo, RHPcodigopr, Cantidad, Peso, BMUsucodigo)
						values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rsPruebasComp.RHPcodigopr#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPruebasComp.cant#">,
								<cfqueryparam cfsqltype="cf_sql_money" value="#(peso * rsPruebasComp.cant)#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">)
					</cfquery>
				</cfloop>
			</cfif>		
			<cfset arreglo = listtoarray(form.OFERENTES)>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfif arreglo[i] neq '-1'>
					<cfquery name="RSConcursos" datasource="#Session.DSN#">
						select 1 from RHConcursantes
						where RHCconcurso	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
						and Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHOid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">
					</cfquery>
					
					<cfif RSConcursos.recordCount eq 0>
						<cfquery name="insConcursos" datasource="#Session.DSN#">
							insert into RHConcursantes 
							(	RHCconcurso,  
								Ecodigo,
								RHCPtipo,
								RHCPpromedio,
								Usucodigo,
								BMUsucodigo, 
								RHOid
							)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								'E',
								0.00,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">
							)
						</cfquery>	
					</cfif>
				</cfif>
			</cfloop>
			<!--- EN ESTA AREA SE AGREGAN LAS PLAZAS QUE FUERON ASIGNADAS Y SE ACTUALIZA EL NUMERO DE PLAZAS --->
			<cfif isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST))>
				<cfquery name="delRHPlazasConcurso" datasource="#session.DSN#">
					delete from RHPlazasConcurso
					where Ecodigo 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				</cfquery>
				<cfset arrayKeysid = ListToArray(form.RHCGIDLIST)>
				<cfloop from="1" to="#ArrayLen(arrayKeysid)#" index="i">
					<cfquery name="rsRHPlazasConcursoInsert" datasource="#session.DSN#">
						insert into RHPlazasConcurso (Ecodigo, RHCconcurso, RHPid, RHCPidsel, Usucodigo, RHPCpesoareas, RHPCpesocomp, BMUsucodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#arrayKeysid[i]#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							0,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						)
					</cfquery>
				</cfloop>
				<!--- Actualiza el campo de Cantidad de Plazas en el Concurso --->
				 <cfquery name="updPlazas" datasource="#Session.DSN#">
					update RHConcursos set 
						RHCcantplazas = (
							select count(1)
							from RHPlazasConcurso x
							where x.RHCconcurso = RHConcursos.RHCconcurso
						)
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
				 </cfquery>
			</cfif>			
		</cftransaction>
		<cfelseif form.CONCURSO eq 1>
		<!--- AGREGA LOS CANDIDATOS A CONCURSO SELECCIONADO --->
			<cfset arreglo = listtoarray(form.OFERENTES)>
			<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				<cfif arreglo[i] neq '-1'>
					<cfquery name="RSConcursos" datasource="#Session.DSN#">
						select 1 from RHConcursantes
						where RHCconcurso	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">
						and Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHOid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">
					</cfquery>
					
					<cfif RSConcursos.recordCount eq 0>
						<cfquery name="insConcursos" datasource="#Session.DSN#">
							insert into RHConcursantes 
							(	RHCconcurso,  
								Ecodigo,
								RHCPtipo,
								RHCPpromedio,
								Usucodigo,
								BMUsucodigo, 
								RHOid
							)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCconcurso#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								'E',
								0.00,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo[i]#">
							)
						</cfquery>	
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>
</cfif>
<HTML>
  <head>
  </head>
  <body>
	<script language="JavaScript1.2" type="text/javascript">window.close();</script>
  </body>
</HTML>

