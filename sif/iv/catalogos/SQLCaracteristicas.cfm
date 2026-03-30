<cfoutput>
	<cfif isdefined("Form.Cambio")>
		<cfset hasta = form.total - 1>
		<cfif hasta gt 0 >
			<cftransaction>
			
			<cfquery name="delete" datasource="#session.DSN#">
				delete from ArticulosValor
				where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
			</cfquery>
		
			<cfloop from="0" to="#hasta#" index="i">
				<cfquery name="insert" datasource="#session.DSN#">
					insert into ArticulosValor( Aid, CDcodigo, CVcodigo, Valor )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['CDcodigo_#i#']#">,
							 <cfif isdefined("form.CVcodigo_#i#") and Len( form['CVcodigo_'&i])>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['CVcodigo_#i#']#">
							<cfelse>null</cfif>,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['valor_#i#']#">  )
				</cfquery>
			</cfloop>
			
			</cftransaction>
		</cfif>
	</cfif>
	
	<cfset params="">
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
		<cflocation url="Caracteristicas.cfm?Aid=#form.Aid#&Pagina=#Form.Pagina##params#">
	</cfif>
</cfoutput>