<!---  <cf_dump var="#form#"> --->
<cfset Gvar_action = "tablaEvaluac.cfm">
<cfset Gvar_params = "">

<cffunction access="private" description="Agregar parámetros para enviar por get." name="ParamsAppend">
	<cfargument name="name" required="yes" type="string">
	<cfargument name="value" required="yes" type="string">
	<cfif len(trim(Gvar_params)) eq 0>
		<cfset Gvar_params = ListAppend(Gvar_params, "?sql=1", "&")>
	</cfif>
	<cfset Gvar_params = ListAppend(Gvar_params, name&"="&value, "&")>
</cffunction>

<cffunction access="private" description="Cambiar Action del SQL" name="SetAction">
	<cfargument name="action" required="yes" type="string">
	<cfset Gvar_action = action>
</cffunction>

		
<!--- Caso 1: Agregar Encabezado --->
<cfif isdefined("Form.Alta")>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#Session.Edu.DSN#">
			insert EvaluacionValoresTabla (CEcodigo, EVTnombre,EVTtipo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EVTnombre#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.EVTtipo#">
							)
			<cf_dbidentity1 conexion="#Session.Edu.DSN#">
		</cfquery>
		<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="rsInsert">
	</cftransaction>
	<cfset ParamsAppend("EVTcodigo", rsInsert.Identity)>
	<!---<cfset modo="CAMBIO">--->
	
<!--- Caso 1.1: Cambia Encabezado --->
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsEvaluacionValoresTabla" datasource="#Session.Edu.DSN#">
		update EvaluacionValoresTabla
		set EVTnombre = <cfqueryparam value="#form.EVTnombre#" cfsqltype="cf_sql_varchar">,
			EVTtipo=<cfqueryparam value="#form.EVTtipo#" cfsqltype="cf_sql_char">
		where EVTcodigo = <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	<cfset ParamsAppend("EVTcodigo", form.EVTcodigo)>	
<!--- Caso 2: Borrar un Encabezado de Tablas de Evaluacion --->
<cfelseif isdefined("Form.Baja")>			
	<cfif isdefined("Form.EVTcodigo") AND Form.EVTcodigo NEQ "">
		<cfquery name="rsEvaluacionValores" datasource="#Session.Edu.DSN#">
			delete EvaluacionValores
			where EVTcodigo=<cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="rsEvaluacionValoresTabla" datasource="#Session.Edu.DSN#">	
			delete EvaluacionValoresTabla 
			where EVTcodigo=<cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">				
			<cfset modo="ALTA">
		</cfquery>
	</cfif>
	<cfset setAction("listaTablaEvaluac.cfm")>
	

<!--- Caso 3: Agregar Detalle de Tablas de Evaluacion y opcionalmente modificar el encabezado --->
<cfelseif isdefined("Form.AltaDet")>
	<cfquery name="rsValida" datasource="#Session.Edu.DSN#">
		select 1 from EvaluacionValores 
		where EVTcodigo = <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		  and EVequivalencia = <cfqueryparam value="#form.EVequivalencia#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsValida.recordcount gt 0>
		<cfthrow message="Error, La equivalencia ya existe, Proceso Cancelado"/>
	</cfif>
	<cfquery name="rsEvaluacionValores" datasource="#Session.Edu.DSN#">
		insert EvaluacionValores (EVTcodigo, EVvalor, EVdescripcion, EVequivalencia)
		values (<cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#form.EVvalor#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#form.EVdescripcion#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#form.EVequivalencia#" cfsqltype="cf_sql_numeric">)
	</cfquery>	
	
	
	<!--- Modificar Encabezado --->
	<cfquery name="rsEvaluacionValoresTabla" datasource="#Session.Edu.DSN#">
		update EvaluacionValoresTabla
		set EVTnombre = <cfqueryparam value="#form.EVTnombre#" cfsqltype="cf_sql_varchar">,
			EVTtipo=<cfqueryparam value="#form.EVTtipo#" cfsqltype="cf_sql_char">
		where EVTcodigo = <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfset ParamsAppend("EVTcodigo", form.EVTcodigo)>
	<cfset ParamsAppend("EVvalor", form.EVvalor)>
	<cfquery name="rsPagina2" datasource="#Session.Edu.DSN#">
		SELECT count(1) as Cont
		FROM EvaluacionValoresTabla 
		WHERE EVTcodigo = #form.EVTcodigo#
	</cfquery>
	<cfset Form.pagina2 = Ceiling(rsPagina2.Cont / form.MaxRows2)>
	
<!--- Caso 4: Modificar Detalle de Tabla de Evaluacion y modificar el encabezado --->			
<cfelseif isdefined("Form.CambioDet")>
	<cfquery name="rsEvaluacionValores" datasource="#Session.Edu.DSN#">
		update EvaluacionValores
		set EVdescripcion   = <cfqueryparam value="#form.EVdescripcion#" cfsqltype="cf_sql_varchar">, 
			EVequivalencia  = <cfqueryparam value="#form.EVequivalencia#" cfsqltype="cf_sql_numeric">
		where EVTcodigo     = <cfqueryparam value="#form.EVTcodigo#"    cfsqltype="cf_sql_numeric">
		  and EVvalor   	= <cfqueryparam value="#form.EVvalor#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<!--- Modificar Encabezado --->
	<cfquery name="rsEvaluacionValoresTabla" datasource="#Session.Edu.DSN#">	
		update EvaluacionValoresTabla
		set EVTnombre = <cfqueryparam value="#form.EVTnombre#" cfsqltype="cf_sql_varchar">,
			EVTtipo=<cfqueryparam value="#form.EVTtipo#" cfsqltype="cf_sql_char">
		where EVTcodigo = <cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
	<cfset ParamsAppend("EVTcodigo", form.EVTcodigo)>
	<cfset ParamsAppend("EVvalor", form.EVvalor)>		
	
<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
<cfelseif isdefined("Form.BajaDet")>
	<cfquery name="rsEvaluacionValores" datasource="#Session.Edu.DSN#">			
		delete EvaluacionValores
		where EVTcodigo=<cfqueryparam value="#form.EVTcodigo#" cfsqltype="cf_sql_numeric">
		and EVvalor=<cfqueryparam value="#form.EVvalor#" cfsqltype="cf_sql_varchar">				
	</cfquery>
	<cfset ParamsAppend("EVTcodigo", form.EVTcodigo)>					

<cfelseif isdefined("Form.NuevoDet")>
	<cfset ParamsAppend("EVTcodigo", form.EVTcodigo)>
	
<cfelseif isdefined("Form.Lista")>
	<cfset setAction("listaTablaEvaluac.cfm")>
	
</cfif>					
	

<!--- Actualizacion de los montos de minimo y maximo solo en ALTA o CAMBIO de Detalle --->
	<cfif isdefined("Form.Cambio") or isdefined("Form.AltaDet") or isdefined("Form.CambioDet") or isdefined("Form.BajaDet")>
			<cfif form.EVTtipo EQ "1"> <!--- Hacia arriba --->
				<cfquery name="updEvaluacionValores" datasource="#Session.Edu.DSN#">
					update EvaluacionValores
					   set EVminimo = (
							  select convert(numeric(6,3),isnull(max(Ant.EVequivalencia)+0.001,0))
								from EvaluacionValores Ant
							   where Ant.EVTcodigo = ev.EVTcodigo
								 and Ant.EVequivalencia < ev.EVequivalencia
						   ),
						   EVmaximo = EVequivalencia
					  from EvaluacionValores ev
					 where ev.EVTcodigo      = <cfqueryparam value="#form.EVTcodigo#"    cfsqltype="cf_sql_numeric">
				</cfquery>			
				<cfquery name="updEvaluacionValores" datasource="#Session.Edu.DSN#">
					update EvaluacionValores
					   set EVmaximo = 100
					   from EvaluacionValores ev
					  where ev.EVTcodigo      = <cfqueryparam value="#form.EVTcodigo#"    cfsqltype="cf_sql_numeric">
						and ev.EVequivalencia = (
							 select max(May.EVequivalencia)
							   from EvaluacionValores May
							  where May.EVTcodigo = ev.EVTcodigo
							)			
				</cfquery>
			<cfelseif form.EVTtipo EQ "2"> <!--- Hacia Abajo --->
				<cfquery name="updEvaluacionValores" datasource="#Session.Edu.DSN#">
					update EvaluacionValores
					   set EVmaximo = (
							 select convert(numeric(6,3),isnull(min(Ant.EVequivalencia)-0.001,100))
							   from EvaluacionValores Ant
							  where Ant.EVTcodigo = ev.EVTcodigo
								and Ant.EVequivalencia > ev.EVequivalencia
						   ),
						   EVminimo = EVequivalencia
					   from EvaluacionValores ev
					  where ev.EVTcodigo      = <cfqueryparam value="#form.EVTcodigo#"    cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery name="updEvaluacionValores" datasource="#Session.Edu.DSN#">
					update EvaluacionValores
					   set EVminimo = 0
					   from EvaluacionValores ev
					  where ev.EVTcodigo      = <cfqueryparam value="#form.EVTcodigo#"    cfsqltype="cf_sql_numeric">
						and ev.EVequivalencia = (
							 select min(May.EVequivalencia)
							   from EvaluacionValores May
							  where May.EVTcodigo = ev.EVTcodigo
							)	
				</cfquery>
			<cfelseif form.EVTtipo EQ "0"> <!--- El mas cercano --->
				<cfquery name="updEvaluacionValores" datasource="#Session.Edu.DSN#">
					update EvaluacionValores
					  set EVminimo = (
							 select convert(numeric(6,3),isnull((max(Ant.EVequivalencia)+ev.EVequivalencia)/2,0))
							   from EvaluacionValores Ant
							  where Ant.EVTcodigo = ev.EVTcodigo
								and Ant.EVequivalencia < ev.EVequivalencia
						  ),
						  EVmaximo = (
							 select convert(numeric(6,3),isnull((min(Ant.EVequivalencia)+ev.EVequivalencia)/2-0.0001,100))
							   from EvaluacionValores Ant
							  where Ant.EVTcodigo = ev.EVTcodigo
								and Ant.EVequivalencia > ev.EVequivalencia
						  )
					  from EvaluacionValores ev
					 where ev.EVTcodigo      = <cfqueryparam value="#form.EVTcodigo#"    cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>
	</cfif>

<cfset ParamsAppend("Pagina", form.Pagina)>
<cfset ParamsAppend("Filtro_EVTnombre", form.Filtro_EVTnombre)>
<cfset ParamsAppend("HFiltro_EVTnombre", form.Filtro_EVTnombre)>

<cfset ParamsAppend("Pagina2", form.Pagina2)>
<cfset ParamsAppend("Filtro_Descripcion", form.Filtro_Descripcion)>
<cfset ParamsAppend("Filtro_Valor", form.Filtro_Valor)>
<cfset ParamsAppend("Filtro_Equivalencia", form.Filtro_Equivalencia)>
<cfset ParamsAppend("Filtro_Minimo", form.Filtro_Minimo)>
<cfset ParamsAppend("Filtro_Maximo", form.Filtro_Maximo)>

<cflocation url="#Gvar_action##Gvar_params#">

