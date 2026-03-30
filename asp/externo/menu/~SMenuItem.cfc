<!---
	completarPosicion
	traeNombre
--->

<cfcomponent>
	<cffunction name="completarPosicion" returntype="string" >
		<cfargument name="posicion" type="string" default="">
		<cfset LvarPosicion = RepeatString('0',5-len(trim(arguments.posicion))) & trim(arguments.posicion) >
		<cfreturn LvarPosicion >
	</cffunction>

	<cffunction name="traeNombre" returntype="string" >
		<cfargument name="id_item" type="string" default="">
		<cfquery name="dataNombre" datasource="asp" maxrows="1">
			<!---
			select etiqueta_item as id_item
			from SMenuItem
			where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_item#">
			--->
			select posicion
			from SRelacionado
			where id_hijo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_item#">
			and profundidad=1
		</cfquery>
		<cfif len(trim(dataNombre.posicion))>
			<cfinvoke component="SMenuItem" method="completarPosicion" posicion="#dataNombre.posicion#" returnvariable="LvarPosicion" >
		<cfelse>
			<cfset LvarPosicion = '00001' >
		</cfif>	
		<cfreturn LvarPosicion >
	</cffunction>

	<cffunction name="setpos" >
		<cfargument name="id_item" type="string" required="yes">
		<cfargument name="posicion" type="string" default="1">
		<!--- Pone la posicion para todos los registros donde el item parace como hijo --->
		<cfquery datasource="asp" >
			update SRelacionado
			set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.posicion#">
			where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_item#">
		</cfquery>
	</cffunction>
	
	<cffunction name="obtienePosicion" returntype="string" >
		<cfargument name="id_padre" type="string" default="">
		<cfargument name="posicion" type="string" default="1">

		<!--- obtiene padre del item y profundidad del padre --->
		<cfquery name="dataPadre" datasource="asp">
			select id_hijo as id_padre, max(profundidad) as profundidad
			from SRelacionado
			where id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_padre#">
			group by id_hijo
		</cfquery>
		
		<!--- Consulta el orden para los hijos del padre --->
		<cfquery name="dataOrden" datasource="asp">
			select posicion
			from SRelacionado 
			where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_padre#">
			  and profundidad = 1
			  and posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.posicion#">
		</cfquery>
		<!--- determina la posicion del item --->
		<cfif dataOrden.recordCount gt 0 or arguments.posicion eq 1>
			<cfquery name="dataOrden" datasource="asp">
				select coalesce(max(posicion),0) as posicion
				from SRelacionado 
				where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id_padre#">
				  and profundidad = 1
			</cfquery>
			<cfif len(trim(dataOrden.posicion))>
				<cfset LvarPosicion = dataOrden.posicion + 10 >
			<cfelse>	
				<cfset LvarPosicion = 10 >
			</cfif>
		<cfelse>
			<cfset LvarPosicion = arguments.posicion >
		</cfif>

		<cfreturn LvarPosicion >
	</cffunction>

	<cffunction name="insertar" returntype="numeric" hint="debe invocarse en una transaccion">
		<cfargument name="etiqueta" type="string">
		<cfargument name="estereotipo" type="string" default="item">
		<cfargument name="SScodigo" type="string" default="">
		<cfargument name="SMcodigo" type="string" default="">
		<cfargument name="SPcodigo" type="string" default="">
		<cfargument name="id_pagina" type="string" default="">
		<cfargument name="padre" type="string" default="">
		<cfargument name="posicion" type="string" default="0">
		
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
			<cfinvoke component="SMenuItem" method="obtienePosicion" id_padre="#Arguments.padre#" posicion="#arguments.posicion#" returnvariable="LvarPosicion" >
			<cfinvoke component="SMenuItem" method="completarPosicion" posicion="#LvarPosicion#" returnvariable="LvarItemRuta" >
			<cfinvoke component="SMenuItem" method="ligar" padre="#Arguments.padre#" hijo="#nuevo_item#" profundidad="1" ruta="#LvarItemRuta#">
		<cfelse>
			<cfset LvarPosicion = 1 >
			<cfinvoke component="SMenuItem" method="ligar" padre="#nuevo_item#" hijo="#nuevo_item#" profundidad="0" >
		</cfif>
		
		<!--- posicion --->
		<cfinvoke component="SMenuItem" method="setpos" id_item="#nuevo_item#" posicion="#LvarPosicion#" >
		
		<!--- resecuenciar --->
		<!---<cfinvoke component="SMenuItem" method="resecuenciar" >--->

		<cfreturn nuevo_item >
	</cffunction>

	<cffunction name="resecuenciar" >
		<cfquery name="data" datasource="asp">
			select id_item, id_hijo, posicion
			from SRelacionado
			where profundidad = 1
			order by id_item, posicion, ruta
		</cfquery>
		
		<cfoutput query="data" group="id_item">
			<cfset numero = 0 >
			<cfoutput>
				<cfset numero = numero + 10 >
				<cfif data.posicion neq numero >
					<cfinvoke component="SMenuItem" method="completarPosicion" posicion="#data.posicion#" returnvariable="LvarItemRuta" >
					<cfquery datasource="asp">
						update SRelacionado
						set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#numero#">,
						    ruta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarItemRuta#">
						where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_item#">
						  and id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_hijo#">
					</cfquery>
				</cfif>
			</cfoutput>
		</cfoutput>
	</cffunction>
	
	<cffunction name="reorganizar" >
		<!--- borra los registros con profundidad mayor a 1 --->
		<cfquery datasource="asp">
			delete SRelacionado where profundidad > 1
			-- quitar
			and id_item >= 8935
		</cfquery>
		
		<!--- establece la ruta para los registros con profundidad igual a 1 --->
		<cfquery name="data" datasource="asp">
			select id_item, id_hijo, posicion
			from SRelacionado
			where profundidad = 1

			-- quitar
			and id_item >= 8935

		</cfquery>
		<cfoutput query="data">
			<cfinvoke component="SMenuItem" method="completarPosicion" posicion="#data.posicion#" returnvariable="LvarItemRuta" >
			<cfquery datasource="asp">
				update SRelacionado
				set ruta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarItemRuta#">
				where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_item#">
				  and id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_hijo#">
				  and profundidad = 1
				  
			-- quitar
			and id_item >= 8935
			</cfquery>
		</cfoutput>

		<cfloop from="1" to="15" index="i" >
			<cftry>
			<cfquery datasource="asp">
				insert SRelacionado( id_item, id_hijo, posicion, es_submenu, es_link, ruta, profundidad, BMfecha, BMUsucodigo )
				select 	a.id_item, 
						b.id_hijo, 
						b.posicion, 
						b.es_submenu, 
						b.es_link, 
						a.ruta||'/'||b.ruta, 
						#i#+1, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from SRelacionado a, SRelacionado b 
				where a.id_hijo=b.id_item
				and a.profundidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				and b.profundidad = 1
				
				-- quitar
				and a.id_item >= 8466
				and b.id_item >= 8466
				
			</cfquery>
			<cfcatch type="any">
				<cfdump var="#cfcatch.detail#">
				<cfdump var="#i#">
				<cfabort>
			</cfcatch>	
			</cftry>

		</cfloop>
<cfabort>
XXXX TERMINE

	</cffunction>

	<cffunction name="cambiarpadre" hint="debe invocarse en una transaccion">
		<cfargument name="id_item" type="string" default="">
		<cfargument name="id_padre" type="string" default="">
		<cfargument name="posicion" type="string" default="1">
	
		<!--- posicion --->
		<cfinvoke component="SMenuItem" method="setpos" id_item="#id_item#" posicion="#arguments.posicion#" >
		<cfinvoke component="SMenuItem" method="completarPosicion" posicion="#arguments.posicion#" returnvariable="LvarItemRuta" >

		<!--- pone nuevo padre al item --->
		<cfinvoke component="SMenuItem" method="ligar"
			padre="#arguments.id_padre#" 
			hijo="#arguments.id_item#" 
			profundidad="1" 
			ruta="#LvarItemRuta#">
			
		<!--- resecuenciar --->
		<cfinvoke component="SMenuItem" method="resecuenciar" >

		<!--- reorganiza el arbol --->
		<cfinvoke component="SMenuItem" method="reorganizar" >
	
	</cffunction>

	<cffunction name="ligar">
		<cfargument name="padre"       type="numeric" required="yes">
		<cfargument name="hijo"        type="numeric" required="yes">
		<cfargument name="posicion"    type="numeric" default="1">
		<cfargument name="es_submenu"  type="boolean" default="yes">
		<cfargument name="es_link"     type="boolean" default="no">
		<cfargument name="profundidad" type="numeric" default="1">
		<cfargument name="ruta"        type="string"  default=".">
		<cfargument name="buscar_ancestros" type="boolean" default="yes">
	
		<cfquery name="rsExiste" datasource="asp">
			select 1
			from SRelacionado
			where id_item = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.padre#">
			  and id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.hijo#">
		</cfquery>
	
		<cfif rsExiste.recordCount eq 0>
			<cfquery datasource="asp">
				insert SRelacionado( id_item, id_hijo, posicion, es_submenu, es_link, ruta, profundidad, BMfecha, BMUsucodigo )
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.padre#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.hijo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.posicion#">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="#Arguments.es_submenu#">,
						 <cfqueryparam cfsqltype="cf_sql_bit"     value="#Arguments.es_link#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.ruta#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.profundidad#">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
			</cfquery>
		</cfif>
	
		<cfif Arguments.buscar_ancestros and Arguments.padre neq Arguments.hijo>
			<cfquery datasource="asp" name="ancestros">
				select id_item, id_hijo, ruta, profundidad
				from SRelacionado
				where es_submenu = 1
				  and id_hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.padre#">
				  and profundidad >= 1
			</cfquery>
			<cfloop query="ancestros">
				<cfinvoke component="SMenuItem" method="ligar" 
					buscar_ancestros="no" 
					padre="#ancestros.id_item#" 
					hijo="#Arguments.hijo#" 
					profundidad="#ancestros.profundidad + 1#"
					ruta="#ancestros.ruta#/#Arguments.ruta#" >
			</cfloop>
		</cfif>
	</cffunction>

</cfcomponent>