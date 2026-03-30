<cfset modo = "ALTA">
<!-----Modo alta---->
<cfinvoke Key="LB_ElCodigoDeCategoriaYaExiste" Default="El c&oacute;digo de categor&iacute;a ya existe." returnvariable="LB_ElCodigoDeCategoriaYaExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfif isdefined("Form.Alta")>				
	<cftransaction>				
		<!---Validar que el código digitado no exista---->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select CodCategoria from CategoriaNoticias
			where CodCategoria = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CodCategoria#">			
		</cfquery>
		<cfif rsVerifica.RecordCount EQ 0>
			<cfquery datasource="#session.dsn#">
				insert into CategoriaNoticias (CodCategoria, 
										DescCategoria, 
										BMUsucodigo, 										 
										BMfechaalta,
										Ecodigo,
										CEcodigo)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.CodCategoria#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.DescCategoria#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						)
			</cfquery>
		<cfelse>
			<cf_throw message="#LB_ElCodigoDeCategoriaYaExiste#" errorcode="5030">
		</cfif>						
	</cftransaction>
<!----Modo BAJA---->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from CategoriaNoticias
		where IdCategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdCategoria#">
	</cfquery>			
<!----Modo CAMBIO----->
<cfelseif IsDefined("form.Cambio")>
	<!---Validar que el código digitado no exista---->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select CodCategoria from CategoriaNoticias
		where CodCategoria = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CodCategoria#">			
			and IdCategoria != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdCategoria#">
	</cfquery>
	<cfif isdefined("rsVerifica") and rsVerifica.RecordCount EQ 0>	
		<cf_dbtimestamp datasource="#session.dsn#"
			table="CategoriaNoticias"
			redirect="CategoriaNoticias.cfm"
			timestamp="#form.ts_rversion#"
			field1="IdCategoria"
			type1="numeric"
			value1="#form.IdCategoria#">	
		
		<cfquery datasource="#session.dsn#">
			update 	CategoriaNoticias
			set 	CodCategoria = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.CodCategoria#">,
					DescCategoria = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.DescCategoria#">
			where IdCategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdCategoria#">
		</cfquery>
	<cfelse>
		<cf_throw message="#LB_ElCodigoDeCategoriaYaExiste#" errorcode="5025">
	</cfif><!---Fin de si ya existe el código de la categoría---->
</cfif>
<cfoutput>
<cfset param = ''>
<cfif isdefined("form.Cambio")>
	<cfset param = param & "?IdCategoria=#form.IdCategoria#">
</cfif>
<cflocation url="CategoriaNoticias.cfm#param#">
</cfoutput>
