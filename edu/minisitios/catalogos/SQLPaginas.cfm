<cfif not isdefined("form.Nuevo")>

	<cffunction name="menu" access="public" returntype="numeric">
		<!--- RESULTADO --->
		<!---  Actualiza latabla de Menu --->
		<cfargument name="MSPcodigo" type="any" required="true"   default="">
		<cfargument name="MSMmenu"   type="any"  required="false" default="-1">
		<cfargument name="tipo"   	 type="any"  required="true"  default="1"> <!--- 0=asigna menu, 1=pone null el menu  --->
	
		<cfquery name="updMenu" datasource="sdc">
			update MSMenu
			set MSPcodigo =  <cfif tipo eq 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#"><cfelse>null</cfif>
			where Scodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">

			<cfif tipo eq 0 >
				and MSMmenu =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#MSMmenu#">
			<cfelse>
				and MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
			</cfif>  
		</cfquery>
	
		<cfreturn 1 >
	</cffunction>
	
	<cffunction name="homepage" access="public" returntype="numeric">
		<!--- RESULTADO --->
		<!---  Actualiza la pagina de inicio o la pone en null --->
		<cfargument name="MSPcodigo" type="any" required="true" default="">
		<cfargument name="tipo" type="any" required="true" default="1">
	
		<cfquery name="updSitio" datasource="sdc">
			update Sitio
			set MSPcodigo = <cfif tipo eq 0 ><cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#"><cfelse>null</cfif>
			where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
			<cfif tipo eq 1 >
				and MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
			</cfif>
			
		</cfquery>
	
		<cfreturn 1 >
	</cffunction>

	<cftransaction>
		
		<cftry>
			<cfif isdefined("form.Alta")> <!--- opcion --->
					<cfquery name="insert_Paginas" datasource="sdc">
						set nocount on
						insert MSPagina (Scodigo, MSPcodigo, MSCcategoria, MSPplantilla, MSPtitulo, MSPumod, MSPfmod ) 
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MSCcategoria#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPplantilla#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPtitulo#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
								 getdate()
							   )	
						set nocount off	   
					</cfquery>
					
					<!--- modifica MSMenu--->
					<cfif isdefined("form.MSMmenu") and len(trim(form.MSMmenu)) gt 0 >
						<cfset resultado = menu(form.MSPcodigo, form.MSMmenu, 0) >	
					</cfif>
					
					<!--- modifica el sitio --->
					<cfif isdefined("form.homepage")>
						<cfset resultado = homepage(form.MSPcodigo, 0) >
					<cfelse>
						<cfset resultado = homepage(form.MSPcodigo, 1) >
					</cfif>
					
					<!--- Proceso de la plantilla, lo que hay que hacer es insertar en MSPaginaArea--->
					<cfset area      = "area" & form.MSPplantilla >
					<cfset listaArea = Evaluate(area) >
					<cfset cont      = 1 > 
					<cfloop list="#listaArea#" index="i">
						<cfquery name="rsArea" datasource="sdc">
							set nocount on
							insert MSPaginaArea (Scodigo, MSPcodigo, MSPAarea, MSPAnombre, MSCcontenido)
							values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">,
									 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">,
									#cont#,
								    '#i#',
								    null)
							set nocount off	
						</cfquery>
						<cfset cont = cont+1 >
					</cfloop>
					
					<cfset modo="ALTA">
	
				<cfelseif isdefined("Form.Baja")>
					<!--- quita las referencias de esta pagna en MSMenu --->	
					<cfset resultado = menu(form.MSPcodigo, '-1', 1) >	
					
					<!---  quita las referencias en Sitio a esta pagina --->
					<cfset resultado = homepage(form.MSPcodigo, 1) >
					
					<!--- --->
					<cfquery name="rsDeleteArea" datasource="sdc">
        				delete MSPaginaArea
						where MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
						  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
					</cfquery>

					<cfquery name="delete_Paginas" datasource="sdc">
						set nocount on
						delete MSPagina
						where MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
						  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
						set nocount off  
					</cfquery>					  
	
					<cfset modo="ALTA">
	
				<cfelseif isdefined("Form.Cambio")>
					<cfquery name="update_Paginas" datasource="sdc">
						set nocount on
						update MSPagina
						set MSPtitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPtitulo#">,
							MSCcategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MSCcategoria#">,
							MSPplantilla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPplantilla#">,
							MSPumod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
							MSPfmod = getdate()
						where MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
						  and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
						set nocount off
					</cfquery>
					
					<!--- modifica MSMenu--->
					<cfset resultado = menu(form.MSPcodigo, '-1', 1) >	
					<cfif isdefined("form.MSMmenu") and len(trim(form.MSMmenu)) gt 0 >
						<cfset resultado = menu(form.MSPcodigo, form.MSMmenu, 0) >	
					</cfif>
					
					<!--- modifica el sitio --->
					<cfif isdefined("form.homepage")>
						<cfset resultado = homepage(form.MSPcodigo, 0) >
					<cfelse>
						<cfset resultado = homepage(form.MSPcodigo, 1) >
					</cfif>
					
					<!--- Proceso de la plantilla, lo que hay que hacer es insertar/modificar en MSPaginaArea y borrar las areas que no aplican--->
					<cfset area      = "area" & form.MSPplantilla >
					<cfset listaArea = Evaluate(area) >
					<cfset cont      = 1 > 
					<cfloop list="#listaArea#" index="i">
						<cfquery name="rsArea" datasource="sdc">
							set nocount on	
							update MSPaginaArea
							set MSPAnombre = '#i#'
							where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
							  and MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
							  and MSPAarea = #cont#
							if @@rowcount = 0
								insert MSPaginaArea (Scodigo, MSPcodigo, MSPAarea, MSCcontenido, MSPAnombre)
								values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">, 
								        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">,
								        #cont#,
										null, 
										'#i#'
								)
							set nocount off	
						</cfquery>
						<cfset cont = cont+1 >
					</cfloop>
					<!--- borra las areas que me sobraron ej: si habia una plantilla con 3 areas y la cambie por una de 2, deberia
					      tener solo las dos areas de la nueva, las demas las borro --->
					<cfquery name="rsDeleteAreas" datasource="sdc">
						delete MSPaginaArea
            			where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Scodigo#">
            			  and MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MSPcodigo#">
            			  and MSPAarea > (#cont# - 1)
					</cfquery>
					
					<cfset modo="CAMBIO">
				</cfif> <!--- opcion --->

		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>
</cfif>

<cfoutput>
<form action="Paginas.cfm" method="post" name="sql">
	<input name="Scodigo" type="hidden" value="<cfif isdefined("Scodigo")>#Scodigo#</cfif>">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("modo") and modo neq 'ALTA'>
		<input name="MSPcodigo" type="hidden" value="<cfif isdefined("form.MSPcodigo")>#form.MSPcodigo#</cfif>">
	</cfif>	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>