<cfcomponent>
	<!--- 	RESULTADO 
			Devuelve instancia del componente 
	--->
	<cffunction name="init">
		<cfreturn this >
	</cffunction>

	<!---	RESULTADO 
			Verifica si la relacion de seguimiento tiene instancias
			[true: si false: no]
	--->
	<cffunction name="tieneInstancias" access="public" returntype="string">
		<cfargument name="RHRSid" 	type="numeric" 	required="yes" >
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >
		
		<cfquery name="rs_instancia" datasource="#arguments.DSN#">
			select count(1) as instancias
			from RHRelacionSeguimiento
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
		</cfquery>
		<cfif rs_instancia.recordcount  gt 0>
			<cfreturn true >
		</cfif>
		<cfreturn false >
	</cffunction>

	<!---	RESULTADO 
			Elimina las instancias de una relacion con estado creadas o publicadas			
	--->
	<cffunction name="eliminarInstanciaPorRelacion" access="public" returntype="string">
		<cfargument name="RHRSid" 	type="numeric" 	required="yes" >
		<!---<cfargument name="fecha" 	type="date" 	required="yes" >--->
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >
		
		<!--- determina las instancias cuyas fechas de inicio son mayores a la fecha de parametros 
			  o la fecha de inicio est aincluida en una instancia actual
			  Solo borra las creadas o publicadas
		--->
		<cfquery name="rs_instancias_futuro" datasource="#arguments.DSN#">
			select RHDRid
			from RHDRelacionSeguimiento
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
			and RHDRestado <= 20
			<!---and (	RHDRfinicio >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#">
					or
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#"> between RHDRfinicio and RHDRffin
				)--->
		</cfquery>
		<cfloop query="rs_instancias_futuro">
			<cfset this.eliminarInstancia(rs_instancias_futuro.RHDRid) >
		</cfloop>
		
	</cffunction>

	<!---	RESULTADO 
			Obtiene el estado de la instancia de la relacion de seguimiento
			[ 10: creada; 20: Publicada; 30: Cerrada; 40: Eliminada ]
	--->
	<cffunction name="obtenerEstadoInstancia" access="public" returntype="string">
		<cfargument name="RHDRid" 	type="numeric" 	required="yes" >
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >
		
		<cfquery name="rs_estado_instancia" datasource="#arguments.DSN#">
			select RHDRestado as estado
			from RHDRelacionSeguimiento
			where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
		</cfquery>
		<cfreturn rs_estado_instancia.estado >
	</cffunction>

	<!---	RESULTADO 
			Cambia el estado a una instancia de la relacion de seguimiento
			[ 10: creada; 20: Publicada; 30: Cerrada; 40: Eliminada ]
	--->
	<cffunction name="cambiarEstadoInstancia" access="public">
		<cfargument name="RHDRid" 	type="numeric" 	required="yes" >
		<cfargument name="estado" 	type="string" 	required="yes" >
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >
		
		<cfquery datasource="#arguments.DSN#">
			update RHDRelacionSeguimiento
			set RHDRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.estado#">
			where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
		</cfquery>

	</cffunction>
	
	<!---	RESULTADO 
			Elimina una instancia de la relacion de seguimiento si el estado no es publicado (solo estado 10)
	--->
	<cffunction name="eliminarInstancia" access="public">
		<cfargument name="RHDRid" 	type="numeric" 	required="yes" >
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >

		<!--- elimina solo las instancias en estado 10 (creadas) --->		
		<cfset v_estado = this.obtenerEstadoInstancia(arguments.RHDRid) >
		<cfif v_estado lte 20 >
			<cftransaction>
			<!--- RHResumen --->
			<cfquery datasource="#arguments.DSN#">
				delete from RHResumen
				where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
			</cfquery>

			<!--- RHRespuestas  --->
			<cfquery datasource="#arguments.DSN#">
				delete from RHRespuestas
				where RHERid in (	select a.RHERid
									from RHRERespuestas a, RHRSEvaluaciones b
									where b.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
									and b.RHRSEid=a.RHRSEid )
									
			</cfquery>
			
			<!--- RHRERespuestas --->
			<cfquery datasource="#session.DSN#">
				delete from RHRERespuestas
				where RHRSEid in ( 	select b.RHRSEid
									from RHRSEvaluaciones b
									where b.RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#"> )
			</cfquery>
			
			<cfquery datasource="#session.DSN#">
				delete from RHRSEvaluaciones
				where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">			
			</cfquery>

			<!--- instancia --->
			<cfquery datasource="#arguments.DSN#">
				delete from RHDRelacionSeguimiento
				where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHDRid#">
			</cfquery>
			</cftransaction>
		</cfif>
	
	</cffunction>

	<!--- 	RESULTADO
			Obtiene informacion de la relacion (machote)
	--->
	<cffunction name="obtenerRelacion" access="public" returntype="query">
		<cfargument name="RHRSid" 	type="numeric" 	required="yes" >
		<cfargument name="select" 	type="string" 	required="no" 	default="" >
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >
		
		<cfquery name="rs_relacion_info" datasource="#arguments.DSN#">
			select <cfif len(trim(arguments.select))>#arguments.select#<cfelse>*</cfif>
			from RHRelacionSeguimiento
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
		</cfquery>
		
		<cfreturn rs_relacion_info >
	
	</cffunction>
	
	<!---	RESULTADO
			Determina las fechas de inicio y fin de la siguiente instancia de la relacion
	--->
	<cffunction name="obtenerFechaSiguiente" access="public" returntype="struct">
		<cfargument name="RHRSid"	type="numeric" 	required="yes" >
		<cfargument name="DSN" 		type="string" 	required="no"	default="#session.DSN#" >	

		<cfset rs_relacion_info_1 = this.obtenerRelacion( 	arguments.RHRSid, 
													  		" RHRSinicio as inicio, 
															  RHRStipofrecuencia as tipo_frecuencia,
															  RHRSfrecuencia as frecuencia,
															  RHRSdiashabil as dias_habiles ") >

		<cfset fecha_inicio_siguiente = rs_relacion_info_1.inicio >
			
		<!--- saca la maxima fecha de inicio para las instancias de la relacion --->
		<cfquery name="rs_fechasiguiente" datasource="#arguments.DSN#">
			select max(RHDRfinicio) as inicio
			from RHDRelacionSeguimiento
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
		</cfquery>
		<cfset hay_instancias = false >
		<cfif len(trim(rs_fechasiguiente.inicio))>
			<cfset fecha_inicio_siguiente = rs_fechasiguiente.inicio >		
			<cfset hay_instancias = true >
		</cfif>
		
		<cfset vdatepart = lcase(rs_relacion_info_1.tipo_frecuencia) >
		<cfif listfind('s,a', vdatepart) >
			<cfif ucase(vdatepart) eq 's'>
				<cfset vdatepart = 'ww' >
			<cfelse>
				<cfset vdatepart = 'yyyy' >
			</cfif>
		</cfif>
		
		<cfif hay_instancias >
			<cfset fecha_inicio_siguiente = dateadd(vdatepart, rs_relacion_info_1.frecuencia, fecha_inicio_siguiente) >
		</cfif>

		<cfset fecha_final_siguiente = dateadd('d', rs_relacion_info_1.dias_habiles, fecha_inicio_siguiente) >		
		<cfset fecha_final_siguiente = dateadd('s', -1, fecha_final_siguiente) >		
		
		<cfset struct_fechas = structnew() >
		<cfset struct_fechas.inicio = fecha_inicio_siguiente >
		<cfset struct_fechas.fin 	= fecha_final_siguiente >

		<cfreturn struct_fechas >

	</cffunction>
	
	<!---	RESULTADO
			Crea una instancia de la relacion de seguimiento
	--->
	<cffunction name="crearRelacion" access="public" returntype="string">
		<cfargument name="RHRSid"		type="numeric" 	required="yes" >
		<cfargument name="DSN" 			type="string" 	required="no"	default="#session.DSN#" >
		<cfargument name="BMUsucodigo" 	type="string" 	required="no"	default="#session.Usucodigo#" >

		<!--- obtiene las informacion de la relacion de seguimiento --->
		<cfset rs_crear_relacion_info = this.obtenerRelacion( arguments.RHRSid, 
													  		" RHRSinicio as inicio,
															  RHRSfin as fin,  
															  RHRSestado as estado ") >
															  
		<!--- validacion del estado: solo estado publicado( 20 ) se debe procesar --->															  
		<cfif rs_crear_relacion_info.estado neq 20 >
			<cfthrow message="Error. La Relaci&oacute;n de Seguimiento no esta publicada, no se puede generar instancias.">
		</cfif>
		
		<!--- obtiene las fechas de la instancia que se va a generar --->
		<cfset fechas = this.obtenerFechaSiguiente(arguments.RHRSid) >
		
		<!--- valida que la fecha de inicio de la instancia este en el rango de fechas de la relacion de seguimiento--->
		<cfif not (fechas.inicio gte rs_crear_relacion_info.inicio and fechas.inicio lte rs_crear_relacion_info.fin) >
			<cfthrow message="Error. La vigencia de Relaci&oacute;n de Seguimiento ha concluido. Revise las fechas de inicio y fin de la relaci&oacute;n.">
		</cfif>
		
		<cftransaction>
		<!--- inserta la instancia de la relacion de seguimiento --->
		<cfquery name="instancia" datasource="#arguments.DSN#">
			insert into RHDRelacionSeguimiento( RHRSid, RHDRfinicio, RHDRffin, BMUsucodigo, BMfechaalta)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#fechas.inicio#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#fechas.fin#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" > )	
			<cf_dbidentity1 datasource="#arguments.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#arguments.DSN#" name="instancia">

		<!--- inserta tabla de control de evaluaciones --->
		<cfquery datasource="#arguments.DSN#">
			insert into RHRSEvaluaciones(RHDRid, Ecodigo, DEid, DEideval, RHEVtipo, RHRSEestado, BMUsucodigo, BMfechaalta)
			select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.identity#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					b.DEid, 
					a.DEid, 
					a.RHEVtipo, 
					10, 	<!--- estado en proceso --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" >

			from RHEvaluadores a, RHEvaluados b

			where b.RHEid=a.RHEid
			  and b.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<!--- inserta por cada item a evaluar cada uno de los evaluadores --->
		<cfquery datasource="#arguments.DSN#">
			insert into RHRERespuestas( Ecodigo, RHRSEid, DEid, DEideval, RHIEid, RHERtipo, BMUsucodigo, BMfechaalta )
			select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					( 	select min(RHRSEid)
						from RHRSEvaluaciones 
						where RHDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#instancia.identity#">
						and DEid=b.DEid
						and DEideval=a.DEid ),
					b.DEid, 
					a.DEid, 
					c.RHIEid, 
					a.RHEVtipo, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BMUsucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" >

			from RHEvaluadores a, RHEvaluados b , RHItemEvaluar c

			where b.RHEid=a.RHEid
			  and c.RHEid=b.RHEid
			  and b.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHRSid#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		</cftransaction>
	
	</cffunction>

</cfcomponent>