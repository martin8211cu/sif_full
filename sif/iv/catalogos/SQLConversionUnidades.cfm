<!--- Fin del <cfif not isdefined("Form.Nuevo")> --->
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into ConversionUnidades (Ecodigo, Ucodigo, Ucodigoref, CUfactor, CUconvarticulo, Usucodigo, fechaalta)
					values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ucodigo#" >,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ucodigoref#" >,
							<cfqueryparam cfsqltype="cf_sql_float"   value="#Form.CUfactor#" >,
							<cfif isdefined("Form.CUconvarticulo")>1<cfelse>0</cfif>,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> 
					)	
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		</cftransaction>
		
		<cfif isdefined('insert')>
			<cfset form.CUlinea = insert.identity>
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from ConversionUnidades
			where CUlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CUlinea#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="ConversionUnidades"
						redirect="ConversionUnidades.cfm"
						timestamp="#form.ts_rversion#"				
						field1="CUlinea" 
						type1="numeric" 
						value1="#form.CUlinea#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.Ecodigo#">

		<cfquery name="update" datasource="#Session.DSN#">
			update ConversionUnidades 
			set	CUfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CUfactor#" >,
				CUconvarticulo = <cfif isdefined("Form.CUconvarticulo")>1<cfelse>0</cfif>
			where CUlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CUlinea#" >
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
		</cfquery>
	</cfif>
</cfif>
<!--- Fin del <cfif not isdefined("Form.Nuevo")> --->

<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.CUlinea') and form.CUlinea NEQ ''>
		<cfset params= params&'&CUlinea='&form.CUlinea>	
	</cfif>
	<cfif isdefined('form.Ucodigo') and form.Ucodigo NEQ ''>
		<cfset params= params&'&Ucodigo='&form.Ucodigo>	
	</cfif>
	<cfif isdefined('form.Ucodigoref') and form.Ucodigoref NEQ ''>
		<cfset params= params&'&Ucodigoref='&form.Ucodigoref>	
	</cfif>		
</cfif>

<cfif isdefined('form.filtro_descripcion') and form.filtro_descripcion NEQ ''>
	<cfset params= params&'&filtro_descripcion='&form.filtro_descripcion>	
	<cfset params= params&'&hfiltro_descripcion='&form.filtro_descripcion>		
</cfif>
<cfif isdefined('form.filtro_descripcionRef') and form.filtro_descripcionRef NEQ ''>
	<cfset params= params&'&filtro_descripcionRef='&form.filtro_descripcionRef>	
	<cfset params= params&'&hfiltro_descripcionRef='&form.filtro_descripcionRef>		
</cfif>
<cfif isdefined('form.filtro_CUfactor') and form.filtro_CUfactor NEQ ''>
	<cfset params= params&'&filtro_CUfactor='&form.filtro_CUfactor>	
	<cfset params= params&'&hfiltro_CUfactor='&form.filtro_CUfactor>		
</cfif>

<cflocation url="ConversionUnidades.cfm?Pagina=#Form.Pagina##params#">