<!---<cf_dump var ="#form#">---->
<cfset action = "AFIndices.cfm">
<cfset params = "">

<cfif IsDefined("form.AFIperiodo")>
	<cfset params = AddParam(params,'AFIperiodo',form.AFIperiodo)>
</cfif>

<cfif IsDefined("form.ACcodigoCat")>
<cfset params = AddParam(params,'ACcodigoCat',form.ACcodigoCat)>
</cfif>

<cfif IsDefined("form.ACidClas")>
<cfset params = AddParam(params,'ACidClas',form.ACidClas)>
</cfif>
<cfif IsDefined("form.filter")>
	<cfset params = AddParam(params,'filter',form.filter)>
</cfif>
<cffunction name="AddParam" returntype="string">
	<cfargument name="params" type="string" required="yes">
	<cfargument name="paramname" type="string" required="yes">
	<cfargument name="paramvalue" type="string" required="yes">
	<cfset separador = iif(len(trim(arguments.params)),DE('&'),DE('?'))>
	<cfset nuevoparam = arguments.paramname & '=' & arguments.paramvalue>
	<cfreturn arguments.params & separador & nuevoparam>
</cffunction>
<!--- SQL de AFIndices *** Índices de Revaluación --->
<!---Alta de Un Índice *** Implica dar de Alta un Índice para todas las Categorías Clases de la Compañía --->
<cfif isdefined("form.AltaIndice")>

	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into AFIndices (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario)
		select 
			Ecodigo, 
			ACcodigo, 
			ACid, 
			<cf_jdbcquery_param value="#form.AFIperiodo#" cfsqltype="cf_sql_integer">,
			<cf_jdbcquery_param value="#form.AFImes#" 	cfsqltype="cf_sql_integer">,
			<cf_jdbcquery_param value="#form.AFIindice#" 	cfsqltype="cf_sql_float">,
			<cf_dbfunction name="to_date" args="#now()#">,
			<cf_jdbcquery_param value="#Session.Usuario#" 	cfsqltype="cf_sql_varchar">

		from AClasificacion
		where Ecodigo = #Session.Ecodigo#
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
				and  ACcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			</cfif>
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACid = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			</cfif>
	</cfquery>
<!---Cambia de Un Índice *** Implica Cambia un Índice para todas las Categorías Clases de la Compañía e inserta las que no existen --->
<cfelseif isdefined("form.CambioIndice")>
	 <cfquery name="rstemp" datasource="#session.dsn#">
		delete from AFIndices
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			</cfif>
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			</cfif>
	</cfquery>		
	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into AFIndices (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario)
		select 
					Ecodigo, 
					ACcodigo,
					ACid,
					<cf_jdbcquery_param value="#form.AFIperiodo#" cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.AFImes#" cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.AFIindice#" cfsqltype="cf_sql_float">,
					<cf_dbfunction name="to_date" args="#now()#">,
					<cf_jdbcquery_param value="#Session.Usuario#" cfsqltype="cf_sql_varchar">
		from AClasificacion
		where Ecodigo = #Session.Ecodigo#
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
				and  ACcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			</cfif>
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACid = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			</cfif>
	</cfquery>
	
	<cfset params = "">
<!---Baja de Un Índice *** Implica dar de Baja un Índice para todas las Categorías Clases de la Compañía (si no viene la categoría / clase)--->
<cfelseif isdefined("form.BajaIndice")>
	<cfquery name="rstemp" datasource="#session.dsn#">
		delete from AFIndices
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			</cfif>
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			</cfif>
	</cfquery>
<!--- ******************************************************************************************************** --->		
<!--- Elimina multi-selección desde la lista --->
<cfelseif isdefined("form.BotonSel") and form.BotonSel eq "btnEliminar">
	<cftransaction action="begin">
	<cfloop collection="#Form#" item="i">
		
		<cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
			<cfset MM_columns = ListToArray(form[i],",")>
			
			<cfif isdefined('MM_columns') and ArrayLen(MM_columns) GT 0>
				<cfset j = ArrayLen(MM_columns)>
				
				<cfloop index = "k" from = "1" to = #j#>
					<cfset LvarLista = ListToArray(MM_columns[k],"|")>
					<cfset LvarACcodigoCat = ListToArray(LvarLista[1],"|")>
					 <cfset LvarACidClas = ListToArray(LvarLista[3],"|")>
					 <cfset LvarAFIperiodo = ListToArray(LvarLista[4],"|")>
					 <cfset LvarAFImes = ListToArray(LvarLista[5],"|")>
					
					
					<cfquery datasource="#session.dsn#">
						delete from AFIndices
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and AFIperiodo = <cfqueryparam value="#LvarAFIperiodo[1]#" cfsqltype="cf_sql_integer">
							and AFImes = <cfqueryparam value="#LvarAFImes[1]#" cfsqltype="cf_sql_integer">
							and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarACcodigoCat[1]#">
							and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarACidClas[1]#">
					</cfquery>
					
					<cfset j = j - 1>
				</cfloop>
				
				
			</cfif>
		</cfif>
		
	</cfloop>
	
	</cftransaction>
	
<!--- ******************************************************************************************************** --->	
	
<!---Alta Individual de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.Alta")>
	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into AFIndices (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario)
		values(
			<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,

			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
			  	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ACcodigo#" >,
			</cfif>
			
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">,
			<cfelse>
				<cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">,
			</cfif>
			
			<cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">,
			<cfqueryparam value="#Form.AFIindice#" cfsqltype="cf_sql_float">,
			<cf_dbfunction name="to_date" args="#now()#">,
			<cfif isdefined("Session.Usuario")><cfqueryparam value="#Session.Usuario#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
		)	
	</cfquery>
	<cfset params = AddParam(params,'AFImes',form.AFImes)>
<!---Cambia Individual  de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.Cambio")>

	<cfif isdefined("form.ACcodigoCat") and len(trim(form.ACcodigoCat)) and isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="AFIndices"
			redirect="AFIndices.cfm"
			timestamp="#form.ts_rversion#"
			
			field1="Ecodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
	
			field2="ACid" 
			type2="integer" 
			value2="#form.ACidClas#"
	
			field3="ACcodigo" 
			type3="integer" 
			value3="#form.ACcodigoCat#"
			
			field4="AFIperiodo" 
			type4="integer" 
			value4="#form.AFIperiodo#"
	
			field5="AFImes" 
			type5="integer" 
			value5="#form.AFImes#"
		>	
		
	<cfelse>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="AFIndices"
			redirect="AFIndices.cfm"
			timestamp="#form.ts_rversion#"
			
			field1="Ecodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
	
			field2="ACid" 
			type2="integer" 
			value2="#form.ACid#"
	
			field3="ACcodigo" 
			type3="integer" 
			value3="#form.ACcodigo#"
			
			field4="AFIperiodo" 
			type4="integer" 
			value4="#form.AFIperiodo#"
	
			field5="AFImes" 
			type5="integer" 
			value5="#form.AFImes#"
		>
	</cfif>

	<cfquery name="rstemp" datasource="#Session.DSN#">
		update AFIndices set
			AFIindice = <cfqueryparam value="#Form.AFIindice#" cfsqltype="cf_sql_float">
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat)) and isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
				and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			<cfelseif isdefined("form.ACcodigoCat") and len(trim(form.ACcodigoCat)) and isdefined ("form.ACidClas") and len(trim(form.ACidClas)) eq 0>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			<cfelse>
				and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
				and ACid = <cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">
			</cfif>
			
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
			and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
	</cfquery>	  
	<cfset params = AddParam(params,'AFImes',form.AFImes)>
<!---Baja Individual  de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.Baja")>
	<cfquery name="rstemp" datasource="#session.dsn#">
		delete from AFIndices
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat)) and isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
				and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			<cfelseif isdefined("form.ACcodigoCat") and len(trim(form.ACcodigoCat)) and isdefined ("form.ACidClas") and len(trim(form.ACidClas)) eq 0>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			<cfelse>
				and ACcodigo = <cfqueryparam value="#Form.ACcodigo#" cfsqltype="cf_sql_integer">
				and ACid = <cfqueryparam value="#Form.ACid#" cfsqltype="cf_sql_integer">
			</cfif>
			
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset params = AddParam(params,'AFImes',form.AFImes)>

<cfelseif IsDefined("form.ExcepcionesIndice")>
	
	
	<!----  Modificacion por Berman! 02/01/2007
		-	Se define el nuevo action y los nuevos parametros para la pantalla de excepciones!!!
		- <cf_dump var ="#form#">
	---->
	<cfset action = "AFexcepciones.cfm">
	<cfset params = "">
	
	<cfset sugerir = 0>
	
	<cfif IsDefined("form.AFIperiodo")>
		<cfset params = AddParam(params,'AFIperiodo',form.AFIperiodo)>
	</cfif>
	
	<cfif IsDefined("form.AFImes")>
		<cfset params = AddParam(params,'AFImes',form.AFImes)>
	</cfif>
	
	<cfif IsDefined("form.ACcodigoCat") and Len(Trim(form.ACcodigoCat))>
		<cfset params = AddParam(params,'ACcodigoCat',form.ACcodigoCat)>
		<cfset sugerir = 1>
	</cfif>
	
	<cfif IsDefined("form.ACidClas") and Len(Trim(form.ACidClas))>
		<cfset params = AddParam(params,'ACidClas',form.ACidClas)>
		<cfset sugerir = 2>
	</cfif>
	
	<cfif sugerir eq 2>
		<cfset params = AddParam(params,'sugerir','Y')>
	</cfif>
</cfif>

<cfset params = trim(params)>

<cflocation url="#action##params#">