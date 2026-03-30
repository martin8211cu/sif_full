<cfset modo = "ALTA">

<!--- Fin del <cfif not isdefined("Form.Nuevo")> --->
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into ConversionUnidadesArt (Aid, Ucodigo, Ecodigo, CUAfactor, Usucodigo, fechaalta)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CUAUcodigo#" >,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#Form.CUAfactor#" >,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> 
				)	
		</cfquery>
		
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from ConversionUnidadesArt
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CUAUcodigo#">
		</cfquery>
		
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ConversionUnidadesArt"
						redirect="ConversionUnidadesArticulo.cfm"
						timestamp="#form.ts_rversion#"				
						field1="Aid" 
						type1="numeric" 
						value1="#form.Aid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.Ecodigo#"
						field3="Ucodigo" 
						type3="char" 
						value3="#form.CUAUcodigo#"
					>

		<cfquery name="update" datasource="#Session.DSN#">
			update ConversionUnidadesArt 
			set	CUAfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CUAfactor#" >
			where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CUAUcodigo#" >
		</cfquery>
		
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja')>
	<cfif isdefined('form.CUAUcodigo') and form.CUAUcodigo NEQ ''>
		<cfset params= params&'&CUAUcodigo='&form.CUAUcodigo>	
	</cfif>
</cfif>
<cfif isdefined("form.Pagina2") and len(trim(form.Pagina2))>
	<cfset params= params&'&Pagina2='&form.Pagina2>		
</cfif>
<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>
	<cfset params= params&'&filtro_Acodigo='&form.filtro_Acodigo>	
	<cfset params= params&'&hfiltro_Acodigo='&form.filtro_Acodigo>		
</cfif>
<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>
	<cfset params= params&'&filtro_Acodalterno='&form.filtro_Acodalterno>	
	<cfset params= params&'&hfiltro_Acodalterno='&form.filtro_Acodalterno>	
</cfif>
<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>
	<cfset params= params&'&filtro_Adescripcion='&form.filtro_Adescripcion>	
	<cfset params= params&'&hfiltro_Adescripcion='&form.filtro_Adescripcion>	
</cfif>

<cfif isdefined('form.Regresar')>
	<cflocation url="articulos-lista.cfm?Pagina=#Form.Pagina##params#">
<cfelse>
	<cflocation url="ConversionUnidadesArticulo.cfm?Aid=#form.Aid#&Pagina=#Form.Pagina##params#">
</cfif>
