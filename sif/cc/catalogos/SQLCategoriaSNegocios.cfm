
<cffunction name="datos" returntype="query">
	<cfargument name="padre" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select CSNpath
		from CategoriaSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.padre#">
	</cfquery>
	<cfreturn data >
</cffunction>

<cffunction name="_nivel" returntype="boolean">
	<cfargument name="nivel" required="yes" type="numeric">
	<cfquery name="data" datasource="#session.DSN#">
		select coalesce(Pvalor, '1') as Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 640
	</cfquery>

	<cfif (nivel+1) gt data.Pvalor>
		<cfreturn false>
	<cfelse>
		<cfreturn true>
	</cfif>
</cffunction>

<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfset nivel = 0 >
		<cfset path  = RepeatString("0", 5-len(trim(form.CSNcodigo)) ) & "#trim(form.CSNcodigo)#" >
		<cfif isdefined("Form.Alta") or isdefined("form.CAMBIO")>
			<cfif isdefined("form.CSNidPadre") and len(trim(form.CSNidPadre))>
				<cfset _datos = datos(form.CSNidPadre) >
				<cfset CSNnivel= #ListLen(_datos.CSNpath,'/')#>
				<cfset nivel = CSNnivel>
				<cfset path  = trim(_datos.CSNpath) & "/" & trim(path) >
				<cfif not _nivel(nivel) >
					<cf_errorCode	code = "50162" msg = "Ha excedido el nivel máximo para la Clasificación de Categorías de Socios de Negocios.">
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined("Form.Alta")>
			<cfquery name="insCategorias" datasource="#Session.DSN#">			
				insert into CategoriaSNegocios( Ecodigo, CSNidPadre, CSNcodigo, CSNdescripcion, CSNpath, BMUsucodigo)
				values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfif isdefined("form.CSNidPadre") and len(trim(form.CSNidPadre))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSNidPadre#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(form.CSNcodigo))#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSNdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="rsConsulta" datasource="#session.DSN#">
				select 1 
				from CategoriaSNegocios  
				where  CSNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSNid#">
			</cfquery>
			<cfif isdefined("rsConsulta") and rsConsulta.RecordCount GT 0>
				<cf_errorCode	code = "50163" msg = "No puede borrar una categoría padre.">
			<cfelse>
				<cfquery name="delCategorias" datasource="#Session.DSN#">
					delete from CategoriaSNegocios
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and CSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CSNid#">
				</cfquery>
				<cfset modo="ALTA">
			</cfif>
		<cfelseif isdefined("Form.Cambio")>
			<cftransaction>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="CategoriaSNegocios" 
					redirect="CategoriaSNegocios.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#Session.Ecodigo#"
					field2="CSNid,numeric,#form.CSNid#">

					<cfquery name="updCategorias" datasource="#Session.DSN#">
						update CategoriaSNegocios 
						set CSNidPadre = <cfif isdefined("form.CSNidPadre") and len(trim(form.CSNidPadre))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CSNidPadre#"><cfelse>null</cfif>,
							CSNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CSNdescripcion#">,
							CSNpath 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path#">,
							CSNcodigo 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Ucase(form.CSNcodigo))#">,
						 	BMUsucodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and CSNid   = <cfqueryparam value="#Form.CSNid#" cfsqltype="cf_sql_numeric">
					</cfquery>
	
					<!--- Reordenamiento del arbolito --->	
					<!--- solo si cambia padre o codigo --->
					<cfif (form.CSNidPadre neq form._CSNidPadre) or (trim(form.CSNcodigo) neq trim(form._CSNcodigo)) >
                    	<cfinclude template="../../Utiles/sifConcat.cfm">
						<cfquery name="update_path" datasource="#session.DSN#" >
							update CategoriaSNegocios
							set CSNpath 	=  right('00000' #_Cat# ltrim(rtrim(CSNcodigo)), 5),
								BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
		
						<cfset nivel  = 0 >	
						<cfloop from="0" to="99" index="i">
							<cf_dbupdate table="CategoriaSNegocios" datasource="#session.DSN#">
								<cf_dbupdate_join table="CategoriaSNegocios p">
									on CategoriaSNegocios.CSNidPadre = p.CSNid
									and CategoriaSNegocios.Ecodigo = p.Ecodigo
								</cf_dbupdate_join>
								
								<cf_dbupdate_set name='CSNpath' 
									expr="p.CSNpath #_Cat# '/' #_Cat# right ('00000' #_Cat# rtrim(ltrim(CategoriaSNegocios.CSNcodigo)), 5)" />
								
								<cf_dbupdate_where>
									where CategoriaSNegocios.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
									  and p.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
								</cf_dbupdate_where>						
							</cf_dbupdate>

							<cfquery datasource="#session.dsn#" name="rsSeguir">
								select count(1) as cantidad
								from CategoriaSNegocios 
								where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							</cfquery>
							
							<cfif rsSeguir.cantidad eq 0>
								<cfbreak>
							</cfif>
							<cfset nivel = nivel + 1 >
							
							<cfif nivel gt 100 >
								<cfthrow detail="Error">
							</cfif>
						</cfloop>
					</cfif><!--- reordenamiento --->
					
					<!--- <cfquery name="rsvalidar" datasource="#session.DSN#">
						select max(CCnivel) as nivelMaximo
						from CategoriaSNegocios
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>

					<cfif rsvalidar.Recordcount gt 0 and len(trim(rsvalidar.nivelMaximo))>
						<cfif not _nivel(rsvalidar.nivelMaximo) >
							<cftransaction action="rollback">
							<cf_errorCode	code = "50016" msg = "Ha excedido el nivel máximo para la Clasificación de Servicios.">
						</cfif>
					</cfif> --->

				</cftransaction>
				<cfset modo="CAMBIO">
			</cfif>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfset params = ''>
<cfif isdefined("form.CAMBIO")>
	<cfset params = "?arbol_pos=#form.CSNid#" >
</cfif>
<cflocation url="CategoriaSNegocios.cfm#params#">

