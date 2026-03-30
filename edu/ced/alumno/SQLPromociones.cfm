<cfif isdefined("form.ALTA") or isdefined("form.CAMBIO") or isdefined("form.BAJA")>
		
		<cfif isdefined("form.ALTA") or isdefined("form.CAMBIO") >
			<cfquery datasource="#Session.Edu.DSN#" name="rsPEcodigo">
				select PEcodigo
				from SubPeriodoEscolar
				where SPEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">
			</cfquery>
			<cfset varPEcodigo = rsPEcodigo.PEcodigo>
		</cfif>	
		
		<!--- Caso 1: Agregar --->
		<cfif isdefined("Form.ALTA")>
			<cfquery name="rsAlta" datasource="#Session.Edu.DSN#">
				if not exists ( select 1 from Promocion
									where Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
									and Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gcodigo#">
									and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varPEcodigo#">
									and SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">
									and PRano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRano#">
					)
					begin				
						insert Promocion (Gcodigo, Ncodigo, PRano, SPEcodigo, PEcodigo, PRdescripcion)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRano#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#varPEcodigo#">,
								<cfif isdefined("form.PRdescripcion") and #form.PRdescripcion# NEQ "">
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRdescripcion#">)
								<cfelse>
									'Promoci&oacute;n #form.PRano#')											
								</cfif>

						select @@identity as id
												
					end
					else 
					begin
						select -1 as id
					end
			</cfquery>
			<cfif not isdefined("rsAlta.id") or rsAlta.id eq -1>
				<cfset Request.Error.Url = "formPromociones.cfm?Pagina=#form.pagina#&Filtro_Ndescripcion=#Form.Filtro_Ndescripcion#&Filtro_Gdescripcion=#Form.Filtro_Gdescripcion#&Filtro_PRdescripcion=#Form.Filtro_PRdescripcion#&Filtro_PRano=#Form.Filtro_PRano#&Filtro_PRactivo=#Form.Filtro_PRactivo#">
				<cfthrow message="Error: Ya existe una promoción con la misma descripción que digito">	
			</cfif>
			
		<!--- Caso 2: Cambio --->
		<cfelseif isdefined("Form.CAMBIO") and isdefined("form.PRcodigo") and len(trim(form.PRcodigo)) NEQ "">	
			<cftransaction>
				<cfquery name="rsCambio" datasource="#Session.Edu.DSN#">
					if not exists ( select 1 from Promocion
									where Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
									and Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gcodigo#">
									and SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">
									and PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varPEcodigo#">								
									and PRano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRano#">
									and PRcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRcodigo#">
					)
					begin			
						update Promocion set
							Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Gcodigo#">,
							Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">,					
							PRano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRano#">,
							SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SPEcodigo#">,
							PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varPEcodigo#">, 
							<cfif isdefined("form.PRdescripcion") and #form.PRdescripcion# NEQ "">
								PRdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PRdescripcion#">
							<cfelse>				
								PRdescripcion = 'Promoci&oacute;n #form.PRano#'
							</cfif>					
						where PRcodigo= <cfqueryparam value="#form.PRcodigo#" cfsqltype="cf_sql_numeric">
					end
				</cfquery>
			</cftransaction>
			
		<!--- Caso 4: Borrar --->
		<cfelseif isdefined("Form.BAJA")>			
			<cfif isdefined("Form.PRcodigo") AND #Form.PRcodigo# NEQ "" >
				<cftransaction>
				<cfquery name="rsCambio" datasource="#Session.Edu.DSN#">
				delete Promocion 
				where PRcodigo=<cfqueryparam value="#form.PRcodigo#" cfsqltype="cf_sql_numeric">				
				</cfquery>
				</cftransaction>
			</cfif>
		</cfif>
</cfif>

<!--- Toma el id que se acaba de agregar --->
<cfif isdefined("rsAlta.id")and isdefined("form.ALTA")>
	<cfset form.PRcodigo = rsAlta.id>
</cfif>		

<cfset params= "Pagina="&form.pagina&"&Filtro_Ndescripcion="&Form.Filtro_Ndescripcion&"&Filtro_Gdescripcion="&Form.Filtro_Gdescripcion&"&Filtro_PRdescripcion="&Form.Filtro_PRdescripcion&"&Filtro_PRano="&Form.Filtro_PRano&"&Filtro_PRactivo="&Form.Filtro_PRactivo>
<cfset params= params&"&HFiltro_Ndescripcion="&Form.Filtro_Ndescripcion&"&HFiltro_Gdescripcion="&Form.Filtro_Gdescripcion&"&HFiltro_PRdescripcion="&Form.Filtro_PRdescripcion&"&HFiltro_PRano="&Form.Filtro_PRano&"&HFiltro_PRactivo="&Form.Filtro_PRactivo>

<cfif isdefined("Form.CAMBIO")>
	<cflocation url="formPromociones.cfm?PRcodigo=#form.PRcodigo#&#params#">
<cfelseif isdefined("Form.ALTA")>
	<cflocation url="formPromociones.cfm?PRcodigo=#form.PRcodigo#&#params#">
<cfelseif isdefined("form.BAJA")>
	<cflocation url="promociones.cfm?#params#">
<cfelseif isdefined("form.NUEVO")>
	<cflocation url="formPromociones.cfm?#params#">
<cfelseif isdefined("form.LISTA")>
	<cflocation url="promociones.cfm?#params#">
</cfif>
