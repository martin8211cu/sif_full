<!---   <cf_dump var="#form#"> --->
<cfset params = "">
<cfif isdefined('form.filtro_DEidentificacion')>
	<cfset params = params & '&filtro_DEidentificacion=#form.filtro_DEidentificacion#'>
</cfif>
<cfif isdefined('form.filtro_Nombre')>
	<cfset params = params & '&filtro_Nombre=#form.filtro_Nombre#'>
</cfif>
<cfif isdefined('form.filtro_corte')>
	<cfset params = params & '&filtro_corte=#form.filtro_corte#'>
</cfif>
<cfif isdefined('form.filtro_DEidentificacion')>
	<cfset params = params & '&hfiltro_DEidentificacion=#form.filtro_DEidentificacion#'>
</cfif>
<cfif isdefined('form.filtro_Nombre')>
	<cfset params = params & '&hfiltro_Nombre=#form.filtro_Nombre#'>
</cfif>
<cfif isdefined('form.filtro_corte')>
	<cfset params = params & '&hfiltro_corte=#form.filtro_corte#'>
</cfif>

<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
		<cfif isdefined("form.ALTA")>
			<cfquery name="existe" datasource="#session.DSN#">
				select 1 
				from RolEmpleadoSNegocios
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				  and RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.RESNtipoRol#">		
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfif existe.recordcount eq 0 >
				<cfquery name="InsRolEmpleadoSNegocios" datasource="#session.DSN#">
					insert INTO RolEmpleadoSNegocios( Ecodigo, DEid, RESNtipoRol, BMUsucodigo )
					values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.RESNtipoRol#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
				</cfquery>
				<cfquery name="rsPagina" datasource="#session.DSN#">
					select a.DEid, b.Ecodigo, b.RESNtipoRol
					from DatosEmpleado a 
					inner join RolEmpleadoSNegocios b 
					   on a.DEid = b.DEid 
					  and a.Ecodigo = b.Ecodigo 
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  <cfif isdefined('form.filtro_DEidentificacion') and LEN(TRIM(form.filtro_DEidentificacion))>
					  and upper(DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.filtro_DEidentificacion#">
					  </cfif>
					  <cfif isdefined('form.filtro_Nombre') and LEN(TRIM(form.filtro_nombre))>
					  and upper <cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(form.filtro_Nombre)#%">
					   
					  </cfif>
					  <cfif isdefined('form.filtro_RESNtipoRol') and form.filtro_RESNtipoRol NEQ -1>
					  and RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.filtro_RESNtipoRol#">
					  </cfif>
					  order by RESNtipoRol
				</cfquery>
				<cfset row = 1>
				<cfif rsPagina.RecordCount LT 500>
					<cfloop query="rsPagina">
						<cfif rsPagina.DEid EQ form.DEid 
							and rsPagina.Ecodigo EQ session.Ecodigo 
							and rsPagina.RESNtipoRol EQ form.RESNtipoRol>
							<cfset row = rsPagina.currentrow>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
				<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfelse>
				<cf_errorCode	code = "50161" msg = "El empleado ya tiene asignado ese rol. Proceso cancelado.">
				<cfabort>
			</cfif>
			<cfset params = params & '&DEid=#form.DEid#&RESNtipoRol=#form.RESNtipoRol#'>
		<cfelseif isdefined("Form.CAMBIO")>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="RolEmpleadoSNegocios"
							redirect="RolEmpleadoCxC.cfm"
							timestamp="#form.ts_rversion#"
							field1="DEid" type1="integer" value1="#form.empantiguo#"
							field2="RESNtipoRol" type2="integer" value2="#form.rolantiguo#"
							field3="Ecodigo" type3="integer" value3="#session.Ecodigo#"> 
			<cfquery name="UpdRolEmpleadoSNegocios" datasource="#session.DSN#">
				update RolEmpleadoSNegocios
				set DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">,
					RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.RESNtipoRol#">
				where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.empantiguo#">
					and RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.rolantiguo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset params = params & '&DEid=#form.DEid#&RESNtipoRol=#form.RESNtipoRol#'>
		<cfelseif isdefined("Form.BAJA")>
			<cfquery name="DelRolEmpleadoSNegocios" datasource="#session.DSN#">
				delete from RolEmpleadoSNegocios
				where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.empantiguo#">
					and RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.rolantiguo#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
	</cfif>
	</cftransaction>
</cfif>
<cflocation url="RolEmpleadoCxC.cfm?Pagina=#form.Pagina##params#" >

