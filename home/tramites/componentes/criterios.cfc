<cfcomponent>

	<!--- 
		RESULTADO
		Retorna true si requisito es AND, false si es OR
	--->
	<cffunction name="es_criterio_and" returntype="boolean" access="public" >
		<cfargument name="id_requisito" type="numeric" required="yes">
		
		<cfquery name="datos" datasource="#session.tramites.dsn#" >
			select es_criterio_and
			from TPRequisito
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_requisito#">
			and es_criterio_and = 1
		</cfquery>
		
		<cfif datos.recordcount gt 0>
			<cfreturn true >
		<cfelse>
			<cfreturn false >
		</cfif>
	</cffunction>
	<!--- 
		RESULTADO
		Retorna true si requisito tiene criterios asociados, false de lo contrario
	--->
	<cffunction name="hay_criterios" returntype="boolean" access="public" >
		<cfargument name="id_requisito" type="numeric" required="yes">
		
		<cfquery name="datos" datasource="#session.tramites.dsn#" >
			select id_criterio
			from TPCriterioAprobacion
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_requisito#">
		</cfquery>
		<cfif datos.recordcount gt 0>
			<cfreturn true >
		<cfelse>
			<cfreturn false >
		</cfif>
	</cffunction>

	<!--- 
		RESULTADO
		Retorna un query si el requisito/campo tiene asociado un criterio de aprobacion
	--->
	<cffunction name="obtener_criterio" returntype="query" access="public" >
		<cfargument name="id_requisito" type="numeric" required="yes">
		
		<cfquery name="datos" datasource="#session.tramites.dsn#" >
			select id_criterio, id_requisito, id_campo, operador, valor, campo_fijo
			from TPCriterioAprobacion
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_requisito#">
		</cfquery>
		<cfreturn datos >
	</cffunction>

	<!--- 
		RESULTADO
		Retorna true si cumple el criterio de aprobacion, false de lo contrario
	--->
	<cffunction name="cumple_criterio" access="public" >
		<cfargument name="id_requisito" type="numeric" required="yes">
		<cfargument name="id_registro" type="numeric" required="yes">
		<cfargument name="id_persona" type="numeric" required="yes">

		<cfset operadores = '>=,<=,>,<,=,<>,MAX,MIN' >
		<cfset cfoperadores = 'gte,lte,gt,lt,eq,neq,MAX,MIN' >		

		<cfset es_and = es_criterio_and(id_requisito) >
		
		<cfset lista = this.obtener_criterio(arguments.id_requisito) >
		<cfif lista.RecordCount EQ 0>
			<cfreturn true>
		</cfif>
		<cfinvoke component="home.tramites.componentes.cierre" 
			method="datos_fijos" returnvariable="datos_fijos">
		</cfinvoke>
		<cfloop query="lista">
			<!--- obtiene el tipo del dato y el valor del campo --->
			<cfif Len(Trim(lista.id_campo))>
				<cfquery name="tipo" datasource="#session.tramites.dsn#">
					select tipo_dato, valor 
					from DDCampo c
									
					inner join DDTipoCampo tc
					on tc.id_campo = c.id_campo
					
					inner join DDTipo t
					on t.id_tipo = tc.id_tipo
									
					where c.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lista.id_campo#">
						and c.id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_registro#">
				</cfquery>
			<cfelse>
				<cfquery dbtype="query" name="tipo">
					select tipo_dato, '' as valor, columna
					from datos_fijos
					where codigo = '#lista.campo_fijo#'
				</cfquery>
				<cfif tipo.RecordCount>
					<cfquery datasource="#session.tramites.dsn#" name="buscar_valor_persona">
						select #tipo.columna# as valor
						from TPPersona
						where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_persona#">
					</cfquery>
					<cfif IsDate(buscar_valor_persona.valor)>
						<cfset QuerySetCell(tipo, 'valor', DateFormat(buscar_valor_persona.valor,'dd/mm/yyyy'))>
					<cfelse>
						<cfset QuerySetCell(tipo, 'valor', buscar_valor_persona.valor)>
					</cfif>
				<cfelse>
					<cfset tipo = QueryNew('tipo_dato,valor')>
				</cfif>
			</cfif>
			
			<cfset expresion = '' >
			
			<cfif len(trim(tipo.tipo_dato)) and len(trim(tipo.valor)) and len(trim(lista.valor)) >
				<cfset i = listfind(operadores, trim(lista.operador) ) >
				<cfif i gt 0>
					<cfif tipo.tipo_dato eq 'F'>
						<!--- valida las fechas --->
						<cfset fecha1 = listtoarray(tipo.valor, '/')>
						<cfset fecha2 = listtoarray(lista.valor, '/')>
						
						<cfif ArrayLen(fecha1) EQ 3>
							<cfset fecha_tipo =  fecha1[3] & fecha1[2] & fecha1[1] >
	
							<cfif ListContains('MAX,MIN',ListGetAt(cfoperadores, i) )>
								<cfset expresion = " datediff('d', createdate(#fecha1[3]#,#fecha1[2]#,#fecha1[1]#), Now() ) " >
							<cfelse>
								<cfif ArrayLen(fecha2) eq 3>
									<cfset fecha_lista =  fecha2[3] & fecha2[2] & fecha2[1] >
								</cfif>
								<cfset expresion = " '#fecha_tipo#' #ListGetAt(cfoperadores, i)# '#fecha_lista#' ">
							</cfif>
						</cfif>
					<cfelseif tipo.tipo_dato eq 'N' >
						<cfif IsNumeric(tipo.valor) and IsNumeric(lista.valor) >
							<cfset expresion = " #tipo.valor# #ListGetAt(cfoperadores, i)# #lista.valor# ">
						</cfif>
					<!--- B y S --->
					<cfelse>
						<cfset expresion = " '#ucase(trim(tipo.valor))#' #ListGetAt(cfoperadores, i)# '#ucase(trim(lista.valor))#' " >
					</cfif>
					
					<cfset aprobado = false >
					
					<cfif len(trim(expresion)) and evaluate(expresion) >
						<cfset aprobado = true >
					</cfif>
<!---
		<cf_dump var="aprobado :#aprobado#, expresion: #expresion#, tipo.tipo_dato:#tipo.tipo_dato#, fecha1:#tipo.valor#, fecha2:#lista.valor#">
--->
					
					
					<cfif es_and And (not aprobado)>
						<!---
							si el criterio es and, y esta condicion no se cumple
							regrasar false de una vez sin seguir evaluando
						--->
						<cfreturn false>
					<cfelseif (not es_and) and aprobado>
						<!---
							si el criterio es or, y esta condicion sí se cumple
							regrasar true de una vez sin seguir evaluando
						--->
						<cfreturn true>
					</cfif>
					
				</cfif> 
			</cfif>
		</cfloop>
		
		<!---
			si llegamos hasta aqui:
			- Si era un "and", significa que
			aprobó todos los criterios, de lo contrario ya habría 
			salido. En este caso regresamos TRUE
			- Si era un "or", significa que no se aprobó ninguno de los
			criterios. En este caso regresamos FALSE
		--->
		<cfreturn es_and>

	</cffunction>
</cfcomponent>