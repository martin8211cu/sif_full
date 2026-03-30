<cfset params="">
<cfif not isdefined("form.Nuevo")>
		
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			
			<cfquery name="rsExiste" datasource="#Session.Edu.DSN#">
				select 1 as existe from MateriaTipo   
				where Upper(rtrim(ltrim(MTdescripcion))) = <cfqueryparam value="#Ucase(rtrim(ltrim(form.MTdescripcion)))#" cfsqltype="cf_sql_varchar">
				and CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
			</cfquery>
			
			<cfif rsExiste.existe neq 1>
				<cfquery name="rsAgrega" datasource="#Session.Edu.DSN#">
					insert MateriaTipo ( CEcodigo, MTdescripcion )
					values( <cfqueryparam value="#Session.Edu.CEcodigo#"   cfsqltype="cf_sql_numeric">, 
						<cfqueryparam value="#form.MTdescripcion#" cfsqltype="cf_sql_varchar">)
			
					<cfset modo="ALTA">
					
					<cf_dbidentity1 conexion="#Session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 conexion="#Session.Edu.DSN#" name="rsAgrega">
				<cfset params=params&"&MTcodigo="&rsAgrega.identity>
			<cfelse>
				<cfthrow message="Error: Ya existe un Tipo de Materia con esa descripci&oacute;n">
			</cfif>	
		</cftransaction>	

	<cfelseif isdefined("form.Baja")>
		<cfquery name="rsBorra" datasource="#Session.Edu.DSN#">
			set nocount on
			delete MateriaTipo
			where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
			  and MTcodigo = <cfqueryparam value="#form.MTcodigo#" cfsqltype="cf_sql_numeric">
			<!--- <cfset modo="ALTA"> --->
			set nocount off
		</cfquery>
		 
	
	<cfelseif isdefined("form.Cambio")>
		<cfquery name="rsModifica" datasource="#Session.Edu.DSN#">
			set nocount on
			update MateriaTipo 
			set MTdescripcion = <cfqueryparam value="#rtrim(ltrim(form.MTdescripcion))#" cfsqltype="cf_sql_varchar">
			where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
			   and MTcodigo = <cfqueryparam value="#form.MTcodigo#" cfsqltype="cf_sql_numeric">
			<cfset modo="ALTA">
			set nocount off
		</cfquery>
		<cfset params=params&"&MTcodigo="&Form.MTcodigo>
	</cfif>
	
</cfif>

<cfif not isdefined("form.Nuevo") and not isdefined("form.Baja")>
	<cflocation url="MateriaTipo.cfm?Pagina=#Form.Pagina#&Filtro_MTdescripcion=#Form.Filtro_MTdescripcion#&HFiltro_MTdescripcion=#Form.Filtro_MTdescripcion##params#">
<cfelse>
		<cflocation url="MateriaTipo.cfm?Pagina=#Form.Pagina#&Filtro_MTdescripcion=#Form.Filtro_MTdescripcion#&HFiltro_MTdescripcion=#Form.Filtro_MTdescripcion#">
</cfif>

