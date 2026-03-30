<!---Modificado por: Yessica
Se agregaron las líneas (10-12)--->
<cfset action = "AFexcepciones.cfm">
<cfset params = "">

<cfif IsDefined("form.AFIperiodo") and Len(Trim(form.AFIperiodo))>
	<cfset params = AddParam(params,'AFIperiodo',form.AFIperiodo)>
</cfif>

<cfif IsDefined("form.AFImes") and Len(Trim(form.AFImes))>
	<cfset params = AddParam(params,'AFImes',form.AFImes)>
</cfif>

<cfif IsDefined("form.ACcodigoCat") and Len(Trim(form.ACcodigoCat))>
<cfset params = AddParam(params,'ACcodigoCat',form.ACcodigoCat)>
</cfif>

<cfif IsDefined("form.ACidClas") and Len(Trim(form.ACidClas))>
<cfset params = AddParam(params,'ACidClas',form.ACidClas)>
</cfif>

<cfif IsDefined("form.Ocodigo") and Len(Trim(form.Ocodigo))>
<cfset params = AddParam(params,'Ocodigo',form.Ocodigo)>
</cfif>

<cfif IsDefined("form.filter") and Len(Trim(form.filter))>
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
		insert into AFIndicesExc (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario,BMUsucodigo,Ocodigo)
		select 
			Ecodigo, 
			ACcodigo, 
			ACid, 
			<cf_jdbcquery_param value="#form.AFIperiodo#" cfsqltype="cf_sql_integer">,
			<cf_jdbcquery_param value="#form.AFImes#" cfsqltype="cf_sql_integer">,
			<cf_jdbcquery_param value="#form.AFIindice#" cfsqltype="cf_sql_float">,
			<cf_dbfunction name="to_date" args="#now()#">,
			<cf_jdbcquery_param value="#Session.Usuario#" cfsqltype="cf_sql_varchar">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cf_jdbcquery_param value="#form.Ocodigo#" cfsqltype="cf_sql_integer">
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
		delete from AFIndicesExc
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			</cfif>
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			</cfif>
			<cfif isdefined ("form.Ocodigo") and len(trim(form.Ocodigo))>
				and  Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>
	</cfquery>		
	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into AFIndicesExc (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario,BMUsucodigo,Ocodigo)
		select 
					Ecodigo, 
					ACcodigo,
					ACid,
					<cf_jdbcquery_param value="#form.AFIperiodo#" cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.AFImes#" cfsqltype="cf_sql_integer">,
					<cf_jdbcquery_param value="#form.AFIindice#" cfsqltype="cf_sql_float">,
					<cf_dbfunction name="to_date" args="#now()#">,
					<cf_jdbcquery_param value="#Session.Usuario#" cfsqltype="cf_sql_varchar">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cf_jdbcquery_param value="#form.Ocodigo#" cfsqltype="cf_sql_integer">
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
		delete from AFIndicesExc
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
			<cfif isdefined ("form.ACcodigoCat") and len(trim(form.ACcodigoCat))>
				and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigoCat#">
			</cfif>
			<cfif isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
				and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACidClas#">
			</cfif>
			<cfif isdefined ("form.Ocodigo") and len(trim(form.Ocodigo))>
				and  Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
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
						delete from AFIndicesExc
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							and AFIperiodo = <cfqueryparam value="#LvarAFIperiodo[1]#" cfsqltype="cf_sql_integer">
							and AFImes = <cfqueryparam value="#LvarAFImes[1]#" cfsqltype="cf_sql_integer">
							and  ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarACcodigoCat[1]#">
							and  ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarACidClas[1]#">
							<cfif isdefined ("form.Ocodigo") and len(trim(form.Ocodigo))>
								and  Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
							</cfif>
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
		insert into AFIndicesExc (Ecodigo, ACcodigo, ACid, AFIperiodo, AFImes, AFIindice, AFIfecha, AFIusuario,BMUsucodigo,Ocodigo)
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
			<cf_dbfunction name="to_date" args="#now()#">,,
			<cfif isdefined("Session.Usuario")><cfqueryparam value="#Session.Usuario#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
			,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			,<cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
		)	
	</cfquery>
	<cfset params = AddParam(params,'AFImes',form.AFImes)>
<cfelseif isdefined("form.ImportarIndice")>
	<cflocation url="../importar/importaIndicesExcepciones.cfm">

<!---Cambia Individual  de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.Cambio")>

	<cfif isdefined("form.ACcodigoCat") and len(trim(form.ACcodigoCat)) and isdefined ("form.ACidClas") and len(trim(form.ACidClas))>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="AFIndicesExc"
			redirect="AFexcepciones.cfm"
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
			table="AFIndicesExc"
			redirect="AFexcepciones.cfm"
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
		update AFIndicesExc set
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
			
			<cfif isdefined ("form.Ocodigo") and len(trim(form.Ocodigo))>
				and  Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>
	</cfquery>	  
	<cfset params = AddParam(params,'AFImes',form.AFImes)>
<!---Baja Individual  de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.Baja")>
	<cfquery name="rstemp" datasource="#session.dsn#">
		delete from AFIndicesExc
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
			
			<cfif isdefined ("form.Ocodigo") and len(trim(form.Ocodigo))>
				and  Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			</cfif>
			
			and AFIperiodo = <cfqueryparam value="#Form.AFIperiodo#" cfsqltype="cf_sql_integer">
			and AFImes = <cfqueryparam value="#Form.AFImes#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset params = AddParam(params,'AFImes',form.AFImes)>
<cfelseif isdefined("form.RegresarIndice")>
	<cfset action = "AFIndices.cfm">
	<cfset params = "">
</cfif>

<cfset params = trim(params)>

<cflocation url="#action##params#">