<!--- <cf_dump var="#form#"> --->
<cfset params = "">
<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CIntercompany(Ecodigo, Ecodigodest, CFcuentacxp, CFcuentacxc, Cconceptodest, Ocodigo, CIporcentaje, Usucodigo, fechaalta)
			values(<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.Ecodigodest#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.CFcuentacxp#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.CFcuentacxc#" cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.Cconceptodest#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
					null,
					<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					)
		</cfquery>		   
		<cfset params = params & '&Ecodigodest=#form.Ecodigodest#'>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select Ecodigodest, Edescripcion
			from CIntercompany a
			inner join Empresas e
			   on e.Ecodigo = a.Ecodigodest
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by Edescripcion
		</cfquery>
		<cfset row = 1>
		<cfif rsPagina.RecordCount LT 500>
			<cfloop query="rsPagina">
				<cfif rsPagina.Ecodigodest EQ form.Ecodigodest>
					<cfset row = rsPagina.currentrow>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset form.Pagina = Ceiling(row / form.MaxRows)>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from CIntercompany
			where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
			  and  Ecodigodest = <cfqueryparam value="#form.Ecodigodest2#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfquery name="rsPagina" datasource="#session.DSN#">
			select Ecodigodest
			from CIntercompany 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by Ecodigodest
		</cfquery>
		<cfif  Ceiling(rsPagina.RecordCount/form.MaxRows) lt form.Pagina and form.Pagina GT 1>
			<cfset form.Pagina  = rsPagina.RecordCount/form.MaxRows>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>

		<cf_dbtimestamp 
			datasource="#session.dsn#"
			table="CIntercompany"
			redirect="CtasInterCia.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
			field2="Ecodigodest" 
			type2="integer" 
			value2="#form.Ecodigodest2#"
		>
	
		<cfquery name="update" datasource="#Session.DSN#">
			update CIntercompany set
					Ecodigodest = <cfqueryparam value="#form.Ecodigodest#" cfsqltype="cf_sql_integer">,
					CFcuentacxp = <cfqueryparam value="#form.CFcuentacxp#" cfsqltype="cf_sql_numeric">,
					CFcuentacxc = <cfqueryparam value="#form.CFcuentacxc#" cfsqltype="cf_sql_numeric">,
					Cconceptodest = <cfqueryparam value="#form.Cconceptodest#" cfsqltype="cf_sql_integer">,
					Ocodigo = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">
			where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
				  and  Ecodigodest = <cfqueryparam value="#form.Ecodigodest2#" cfsqltype="cf_sql_integer">
		</cfquery> 
		<cfset params = params & '&Ecodigodest=#form.Ecodigodest#'>
	</cfif>
</cfif>
<cflocation url="CtasInterCia.cfm?Pagina=#form.Pagina##params#">
