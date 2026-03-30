<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into Pistas (Ecodigo, Ocodigo, Codigo_pista, Descripcion_pista, Pestado, BMUsucodigo)
			
				values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.Codigo_pista#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.Descripcion_pista#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.Pestado#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					   )
						<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insert"> 
		</cftransaction>
		  
		<cfif isdefined('insert')>
			<cfset form.Pista_id = insert.identity>		
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from Pistas
			where  Pista_id = <cfqueryparam value="#form.Pista_id#" cfsqltype="cf_sql_numeric"> 
			  and  Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="rsOcodigo" datasource="#session.dsn#">
			select Ocodigo
			from Oficinas 
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Oficodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Oficodigo#">		
		</cfquery>
		
		<cfif rsOcodigo.RecordCount EQ 0>
			<script language="javascript1.2" type="text/javascript">alert('El código de oficina digitado no existe')</script>
			<!----<cf_errorCode	code = "50393" msg = "El código de oficina digitado no existe">---->
		<cfelse>			
			<cfset form.Ocodigo = rsOcodigo.Ocodigo>			
			<cf_dbtimestamp datasource="#session.dsn#"
							table="Pistas"
							redirect="Pista.cfm"
							timestamp="#form.ts_rversion#"
							field1="Pista_id" 
							type1="numeric" 
							value1="#form.Pista_id#"
							field2="Ecodigo" 
							type2="numeric" 
							value2="#session.Ecodigo#"
							>
					
			<cfquery name="update" datasource="#Session.DSN#">
				update Pistas set
					   Codigo_pista   = <cfqueryparam value="#Form.Codigo_pista#" cfsqltype="cf_sql_varchar">,
					   Descripcion_pista   = <cfqueryparam value="#Form.Descripcion_pista#" cfsqltype="cf_sql_varchar">,
					   Pestado   = <cfqueryparam value="#Form.Pestado#" cfsqltype="cf_sql_integer">,
					   Ocodigo = <cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">
				where  Pista_id  = <cfqueryparam value="#form.Pista_id#" cfsqltype="cf_sql_numeric">
				  and  Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery> 		
		</cfif>
	</cfif>
</cfif>


<cfset params="">
<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.Pista_id') and form.Pista_id NEQ ''>
		<cfset params= params&'&Pista_id='&form.Pista_id>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_Codigo_pista') and form.filtro_Codigo_pista NEQ ''>
	<cfset params= params&'&filtro_Codigo_pista='&form.filtro_Codigo_pista>	
	<cfset params= params&'&hfiltro_Codigo_pista='&form.filtro_Codigo_pista>		
</cfif>
<cfif isdefined('form.filtro_Descripcion_pista') and form.filtro_Descripcion_pista NEQ ''>
	<cfset params= params&'&filtro_Descripcion_pista='&form.filtro_Descripcion_pista>	
	<cfset params= params&'&hfiltro_Descripcion_pista='&form.filtro_Descripcion_pista>		
</cfif>
<cfif isdefined('form.filtro_Pestado') and form.filtro_Pestado NEQ ''>
	<cfset params= params&'&filtro_Pestado='&form.filtro_Pestado>	
	<cfset params= params&'&hfiltro_Pestado='&form.filtro_Pestado>		
</cfif>
<cflocation url="Pista.cfm?Pagina=#Form.Pagina##params#">

