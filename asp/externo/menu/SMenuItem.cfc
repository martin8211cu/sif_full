<cfcomponent>

	<cffunction name="insertar" returntype="numeric" hint="debe invocarse en una transaccion">
		<cfargument name="etiqueta" type="string">
		<cfargument name="estereotipo" type="string" default="item">
		<cfargument name="SScodigo" type="string" default="">
		<cfargument name="SMcodigo" type="string" default="">
		<cfargument name="SPcodigo" type="string" default="">
		<cfargument name="id_pagina" type="string" default="">
		<cfargument name="padre" type="string" default="">
		<cfargument name="posicion" type="string" default="">
		
		<cfquery datasource="asp" name="SMenuItem_inserted">
			insert into SMenuItem ( etiqueta_item, estereotipo, SScodigo, SMcodigo, SPcodigo, id_pagina, BMfecha, BMUsucodigo ) 
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.etiqueta_item#" null="#Len(Arguments.etiqueta_item) Is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.estereotipo#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SScodigo#" null="#Len(Arguments.SScodigo) Is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SMcodigo#" null="#Len(Arguments.SMcodigo) Is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.SPcodigo#" null="#Len(Arguments.SPcodigo) Is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_pagina#" null="#Len(Arguments.id_pagina) Is 0#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
			<cf_dbidentity1 datasource="asp" verificar_transaccion="no">
		</cfquery>
		<cf_dbidentity2 datasource="asp" name="SMenuItem_inserted" verificar_transaccion="no">

		<cfset nuevo_item = SMenuItem_inserted.identity>

		<cfif Len(Arguments.padre)>
			<cfif len(trim(Arguments.posicion)) is 0 >
				<cfquery datasource="asp" name="buscar_posicion">
					select coalesce (max(posicion), 0) as max_pos
					from SRelacionado
					where profundidad = 1
					  and id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.padre#">
				</cfquery>
				<cfset Arguments.posicion = buscar_posicion.max_pos + 10>
			</cfif>
			
			<cfquery datasource="asp">
				insert into SRelacionado( id_padre, id_hijo, posicion, es_submenu, es_link, ruta, profundidad, BMfecha, BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.padre#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_item#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.posicion#">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="no">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="no">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(Arguments.posicion,'00000')#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="1">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
			</cfquery>
			
			<cfquery datasource="asp">
				insert into SRelacionado( id_padre, id_hijo, posicion, es_submenu, es_link, ruta, profundidad, BMfecha, BMUsucodigo )
				select id_padre, <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_item#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.posicion#">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="yes">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="no">,
						 {fn concat( ruta, <cfqueryparam cfsqltype="cf_sql_varchar" value="/#NumberFormat(Arguments.posicion,'00000')#"> )}, <!---ruta || <cfqueryparam cfsqltype="cf_sql_varchar" value="/#NumberFormat(Arguments.posicion,'00000')#">,--->
						 profundidad + 1,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				from SRelacionado
				where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.padre#">
				  and profundidad >= 1
			</cfquery>
		<cfelse>
			<cfquery datasource="asp">
				insert into SRelacionado( id_padre, id_hijo, posicion, es_submenu, es_link, ruta, profundidad, BMfecha, BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_item#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_item#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="no">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="no">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value=".">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="0">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
			</cfquery>
		</cfif>
		
		<!--- esta grabando mal la posicion, por eso llamamos el resecuenciar --->
		<cfset resecuenciar() >
		
		<cfreturn nuevo_item >
	</cffunction>

	<cffunction name="resecuenciar" >
		<cfquery name="data" datasource="asp">
			select id_padre, id_hijo, posicion
			from SRelacionado
			where profundidad = 1
			order by id_padre, posicion, ruta
		</cfquery>
		<cfoutput query="data" group="id_padre">
			<cfset numero = 0 >
			<cfoutput>
				<cfset numero = numero + 10 >
				<cfif data.posicion neq numero >
					<cfquery datasource="asp">
						update SRelacionado
						set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#numero#">,
						    ruta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(numero,'00000')#">
						where id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_padre#">
						  and id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_hijo#">
						  and profundidad = 1
					</cfquery>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cffunction>
	
	<cffunction name="reorganizar" hint="reconstruye el árbol" >
		<!--- borra los registros con profundidad mayor a 1 --->
		<cfquery datasource="asp">
			delete from SRelacionado where profundidad > 1
		</cfquery>
		
		<!--- establece la ruta para los registros con profundidad igual a 1 --->
		<cfquery name="data" datasource="asp">
			select id_padre, id_hijo, posicion, ruta
			from SRelacionado
			where profundidad = 1
		</cfquery>
		<cfoutput query="data">
			<cfif ruta neq NumberFormat(data.posicion,'00000')>
				<cfquery datasource="asp">
					update SRelacionado
					set ruta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(data.posicion,'00000')#">
					where id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_padre#">
					  and id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_hijo#">
					  and profundidad = 1
				</cfquery>
			</cfif>
		</cfoutput>

		<cfloop from="1" to="15" index="i" >
			<cfquery datasource="asp">
				insert SRelacionado( id_padre, id_hijo, posicion, es_submenu, es_link, ruta, profundidad, BMfecha, BMUsucodigo )
				select 	a.id_padre, 
						b.id_hijo, 
						b.posicion, 
						b.es_submenu, 
						b.es_link, 
						a.ruta||'/'||b.ruta, 
						#i#+1, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from SRelacionado a, SRelacionado b 
				where a.id_hijo=b.id_padre
				and a.profundidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				and b.profundidad = 1
			</cfquery>
		</cfloop>

	</cffunction>

	<cffunction name="cambiarpadre" hint="debe invocarse en una transaccion">
		<cfargument name="id_hijo" type="string" default="">
		<cfargument name="id_padre" type="string" default="">
		<cfargument name="posicion" type="string" >
	
		<cfquery datasource="asp">
			delete from SRelacionado
			where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_hijo#">
			  and id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_padre#">
			  and profundidad > 1
		</cfquery>
		
		<cfquery datasource="asp">
			update SRelacionado
			set id_padre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_padre#">
			, posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.posicion#">
			, ruta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(Arguments.posicion,'00000')#">
			where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.id_hijo#">
			  and profundidad = 1
		</cfquery>
		
		<cfset reorganizar()>
		<cfset resecuenciar()>
	</cffunction>

</cfcomponent>