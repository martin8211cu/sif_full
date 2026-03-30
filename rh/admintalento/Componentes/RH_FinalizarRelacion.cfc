<cfcomponent>
	<cffunction name="init">
		<cfreturn this >
	</cffunction>
	<!----================================================================---->
	<!----Funcion que verifica el tipo de evaluacion y llama a la funcion correspondiente----->
	<!----================================================================---->
	<cffunction name="funcCalculaNota">
		<cfargument name="RHRSEid" type="numeric" required="yes">
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select RHRStipo as TipoEval
			from RHRSEvaluaciones a
				inner join RHDRelacionSeguimiento b
					on a.RHDRid = b.RHDRid
				inner join RHRelacionSeguimiento c
					on b.RHRSid = c.RHRSid
			where a.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSEid#">
		</cfquery>
		<cfif rsDatos.RecordCount and rsDatos.TipoEval EQ 'C'>
			<cfset tmp = this.funcCalculaNotaHabilidad(arguments.RHRSEid)>
		<cfelse>
			<cfset tmp = this.funcCalculaNotaObjetivo(arguments.RHRSEid)>
		</cfif>
		<!----Poner la evaluacion como terminada---->
		<cfquery datasource="#session.DSN#">
			update RHRSEvaluaciones
				set RHRSEestado = 20
			where RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSEid#">	
		</cfquery>
	</cffunction>
	<!----================================================================---->
	<!----Funcion que Calcula la nota cuando es por habilidad----->
	<!----================================================================---->
	<cffunction name="funcCalculaNotaHabilidad">
		<cfargument name="RHRSEid" type="numeric" required="yes">
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select  c.RHERid
					,coalesce(d.RHCOpeso,0) as RHCOpeso
					,coalesce(c.RHRpeso,0) as RHRpeso
					,(	select max(RHDGNpeso) 
						from RHDGrupoNivel x
						where x.RHGNid = e.RHGNid) as mayorPNivel
			from RHRSEvaluaciones a
				inner join RHRERespuestas b
					on a.RHRSEid = b.RHRSEid
				inner join RHRespuestas c
					on b.RHERid = c.RHERid
				inner join RHComportamiento d
					on c.RHCOid = d.RHCOid
				inner join RHGrupoNivel e
					on d.RHGNid = e.RHGNid
				inner join RHItemEvaluar f
					on b.RHIEid = f.RHIEid
			where a.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSEid#">
		</cfquery>
		<cfoutput query="rsDatos" group="RHERid"><!---=========== C/HABILIDAD ===========---->
			<cfset vn_ptosComportamiento = 0>	<!----Puntos obtenidos en c/comportamiento segun la respuesta ---->
			<cfset vn_notaHabilidad = 0>		<!----Nota de la habilidad : sumatoria de los puntos obetenidos en c/respuesta--->
			<cfoutput><!----=========== C/RESPUESTA =========== --->
				<cfset vn_ptosComportamiento = (rsDatos.RHCOpeso*rsDatos.RHRpeso)/rsDatos.mayorPNivel><!---(Peso de la competencia*peso de la respuesta seleccionada)/peso mas alto de las posibles respuestas---->
				<cfset vn_notaHabilidad = vn_notaHabilidad + vn_ptosComportamiento>
			</cfoutput>
			<cfquery datasource="#session.DSN#"><!---Actualizar nota de la habilidad---->
				update RHRERespuestas
					set RHREnota = <cfqueryparam cfsqltype="cf_sql_float" value="#vn_notaHabilidad#">
				where RHERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHERid#">
			</cfquery>
		</cfoutput>		
	</cffunction>
	<!----================================================================---->
	<!----Funcion que Calcula la nota cuando es por Objetivo----->
	<!----================================================================---->
	<cffunction name="funcCalculaNotaObjetivo">
		<cfargument name="RHRSEid" type="numeric" required="yes">
		<cfquery name="rsDatos" datasource="#session.DSN#">			
			select  (c.RHRpeso*100)/(select  max(u.RHDGNpeso)
					from RHRelacionSeguimiento r, RHDRelacionSeguimiento s, RHGrupoNivel t, RHDGrupoNivel u, RHRSEvaluaciones v
					where r.RHRSid = s.RHRSid
						and r.RHGNid = t.RHGNid
						and t.RHGNid = u.RHGNid
						and s.RHDRid = v.RHDRid
						and v.RHRSEid = a.RHRSEid
					)  as Nota					
					,c.RHERid	
					,d.RHIEid
					,c.RHRpeso
					,d.RHIEporcentaje as porcentaje		
			from RHRSEvaluaciones a
				inner join RHRERespuestas b
					on a.RHRSEid = b.RHRSEid
				inner join RHRespuestas c
					on b.RHERid = c.RHERid
				inner join RHItemEvaluar d
					on b.RHIEid = d.RHIEid	
			where a.RHRSEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSEid#">	
		</cfquery>
		<cfloop query="rsDatos">
			<cfquery datasource="#session.DSN#">
				update RHRERespuestas
					set RHREnota = <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Nota#">
				where RHERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHERid#">
			</cfquery>
			<!----Si el peso de la respuesta es >= al porcentaje requerido del objetivo poner el estado finalizada---->
			<cfif rsDatos.RHRpeso GTE rsDatos.porcentaje>
				<cfquery datasource="#session.DSN#">
					update RHRERespuestas
						set RHIEestado = 1
					where RHERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHERid#">
				</cfquery>
			</cfif>
		</cfloop>		
	</cffunction>
	<!----================================================================---->
	<!----Funcion que crea resumen de notas y cierra la evaluacion (Machote)----->
	<!----================================================================---->
	<cffunction name="funcCantItems" returntype="numeric">
		<cfargument name="RHRSid" type="numeric" required="yes">
		<cfset vn_cantItems = 0>
		<cfquery name="rsItems" datasource="#session.DSN#">
			select count(1) as cantItems
			from RHItemEvaluar x, RHEvaluados y
			where x.RHEid = y.RHEid
				and y.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
		</cfquery>
		<cfif rsItems.RecordCount NEQ 0 and rsItems.cantItems NEQ 0>
			<cfset vn_cantItems = rsItems.cantItems>
		</cfif>
		<cfreturn vn_cantItems>
	</cffunction>
	<!----================================================================---->
	<!----Funcion que crea resumen de notas y cierra la evaluacion----->
	<!----Si recibe SOLO RHRSid cierra todas las instancias de ese machote----->
	<!----Si recibe ambos parametros cierra solo la instancia correspondiente ---->
	<!----al RHDRid enviado---->
	<!----================================================================---->
	<cffunction name="funcCierraPublicacion">
		<cfargument name="RHRSid" type="numeric" required="yes"><!----Relacion de seguimiento(machote)---->
		<cfargument name="RHDRid" type="numeric" required="no">	<!---Instancia de una relacion de seguimiento--->
		<cfset vn_cantItems = this.funcCantItems(arguments.RHRSid)><!----Cantidad de items (competencias/objetivos) de la evaluacion----->
		<cfif vn_cantItems LTE 0>
			<cfset vn_cantItems = 1>
		</cfif>
		<cftransaction>
			<!----Inserta en el resumen 1 registro por c/item - instancia---->
			<cfquery datasource="#session.DSN#">
				insert into RHResumen (	RHDRid, RHIEid, Ecodigo, 
										DEid, RHRnotaJefe, RHRnotaauto, 
										RHRnotaotros, RHRnotasub, RHRnotaprom, 
										BMUsucodigo, BMfechaalta)
				select 	b.RHDRid
						,d.RHIEid
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						,c.DEid
						,0.00 as RHRnotaJefe
						,0.00 as RHRnotaauto
						,0.00 as RHRnotaotros
						,0.00 as RHRnotasub
						,0.00 as RHRnotaprom
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						,<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
				from RHRelacionSeguimiento a
					inner join RHDRelacionSeguimiento b
						on a.RHRSid = b.RHRSid
						and b.RHDRestado = 20	<!---Instancias publicadas---->
						<cfif isdefined("arguments.RHDRid") and len(trim(arguments.RHDRid))>
							and b.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
						</cfif>
					inner join RHEvaluados c
						on a.RHRSid = c.RHRSid
					inner join RHItemEvaluar d
						on c.RHEid = d.RHEid
				where a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">	
			</cfquery>
			<!----Respuestas---->
			<cfquery name="rsDatos" datasource="#session.DSN#">					
				select  coalesce(sum(c.RHREnota),0) as notas	
						,a.RHDRid, b.RHEVtipo, c.RHIEid
				from RHDRelacionSeguimiento a
					inner join RHRSEvaluaciones b
						on a.RHDRid = b.RHDRid
						and b.RHRSEestado = 20	<!----Solo toma en cuenta las evaluaciones terminadas---->
					inner join RHRERespuestas c
						on b.RHRSEid = c.RHRSEid
				where a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
					<cfif isdefined("arguments.RHDRid") and len(trim(arguments.RHDRid))>
						and a.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
					</cfif>
				group by a.RHDRid, b.RHEVtipo, c.RHIEid
				order by RHDRid, c.RHIEid,  b.RHEVtipo			
			</cfquery>
			<!---Procesa las respuestas---->
			<cfloop query="rsDatos">
				<cfquery name="rsCant" datasource="#session.DSN#">
					select count(1) as cant
					from RHRSEvaluaciones a
						inner join RHRERespuestas c
							on a.RHRSEid = c.RHRSEid
					where c.RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHIEid#">
						and a.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHDRid#">
						and a.RHEVtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.RHEVtipo#">
						and a.RHRSEestado = 20	<!----Solo toma en cuenta las evaluaciones terminadas---->
				</cfquery>	
				<cfset vn_notafinal = rsDatos.notas/rsCant.cant>
				<cfquery datasource="#session.DSN#">
					update RHResumen
						set 
						<cfif rsDatos.RHEVtipo EQ 'C'>	
							RHRnotaotros 
						<cfelseif rsDatos.RHEVtipo EQ 'A'>
							RHRnotaauto  
						<cfelseif rsDatos.RHEVtipo EQ 'S'>
							RHRnotasub
						<cfelseif rsDatos.RHEVtipo EQ 'J'>
							RHRnotaJefe
						<cfelseif rsDatos.RHEVtipo EQ 'E'>
							RHRnotaJefe 
						</cfif>										
						= <cfqueryparam  cfsqltype="cf_sql_float" value="#vn_notafinal#">
					where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHDRid#">	
						and RHIEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHIEid#">
				</cfquery>
			</cfloop>
			<!----Pone el estado de las instancias en Cerrada---->
			<cfquery datasource="#session.DSN#">
				update RHDRelacionSeguimiento
					set RHDRestado = 30
				where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
					<cfif isdefined("arguments.RHDRid") and len(trim(arguments.RHDRid))>
						and RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
					</cfif>
			</cfquery>
		</cftransaction>
	</cffunction>
</cfcomponent>
