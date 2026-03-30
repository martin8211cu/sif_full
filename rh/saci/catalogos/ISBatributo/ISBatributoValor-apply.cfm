<cfset params="">
<cfset action = "ISBatributoValor.cfm">

<cfif not isdefined("form.Nuevo")>
		<cfset modo="CAMBIO">
		
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.Alta")>
			
			<!--- verifica si existe un valor con el mismo nombre que se desea agregar --->
			<cfquery name="rsVerifica" datasource="#Session.DSN#">
				select count(1) as existe from ISBatributoValor a
				where a.Aid = <cfqueryparam value="#Form.id_tipo2#" cfsqltype="cf_sql_numeric">
				and upper(rtrim(ltrim(a.LVnombre))) = <cfqueryparam value="#Ucase(trim(Form.LVnombre))#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif rsVerifica.existe EQ 0>
				
				<!--- Agrega el valor en la tabla --->
				<cftransaction>				
				<cfquery name="rsAlta" datasource="#Session.DSN#">
					insert ISBatributoValor (Aid,LVnombre, Habilitado)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LVnombre#">,
								<cfif isdefined("Form.Habilitado")>1<cfelse>0</cfif>
								)
					<cf_dbidentity1 conexion="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 conexion="#session.DSN#" name="rsAlta">
				
				</cftransaction>
				
				<cfset modo="ALTA">
			<cfelse>
				<!--- En caso de que el valor no se alla podido agregar entonces envia los datos para un mensaje de error --->
					<cfset params= "&Err='Error: Ya existe un valor con ese mismo nombre...'"&"&LVnombreErr="&form.LVnombre>
					<cfif isdefined("Form.Habilitado")>
						<cfset params= params &"&HabilitadoErr=1">
					<cfelse>
						<cfset params= params &"&HabilitadoErr=0">
					</cfif>
			</cfif>
			
		
		<!--- Caso 1.1: Cambia Encabezado --->
		<cfelseif isdefined("Form.Cambio")>	
			
			<!--- verifica si existe un valor con el mismo nombre que se desea agregar --->
			<!--- <cfquery name="rsVerifica" datasource="#Session.DSN#">
				select count(1) as existe from ISBatributoValor a
				where a.Aid = <cfqueryparam value="#Form.id_tipo2#" cfsqltype="cf_sql_numeric">
				and upper(rtrim(ltrim(a.LVnombre))) = <cfqueryparam value="#Ucase(trim(Form.LVnombre))#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif rsVerifica.existe EQ 0> --->
			
				<cfquery name="rsCambio" datasource="#Session.DSN#">
					update ISBatributoValor
					set LVnombre = <cfqueryparam value="#form.LVnombre#" cfsqltype="cf_sql_varchar">,
						<cfif isdefined("Form.Habilitado")>Habilitado =1 <cfelse>Habilitado = 0 </cfif>
					where Aid = <cfqueryparam value="#form.id_tipo2#" cfsqltype="cf_sql_numeric">
					  and LVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LVid2#">
				
				 </cfquery>
				<cfset modo="ALTA">
			<!--- <cfelse>
				<!--- En caso de que el valor no se alla podido modificar entonces envia los datos para un mensaje de error --->
					<cfset params= "&Err='Error: Ya existe un valor con ese mismo nombre...'"&"&LVnombreErr="&form.LVnombre>
					<cfif isdefined("Form.Habilitado")>
						<cfset params= params &"&HabilitadoErr=1">
					<cfelse>
						<cfset params= params &"&HabilitadoErr=0">
					</cfif>
			</cfif> --->
			
		<!--- Caso 2: Borrar un Encabezado del Tipo de ISBatributo --->
		<cfelseif isdefined("Form.Baja")>			
			<cfif isdefined("Form.id_tipo2") AND Form.id_tipo2 NEQ "" >
				<cfquery name="rsCambio" datasource="#Session.DSN#">
					delete ISBatributoValor 
					where Aid = <cfqueryparam value="#form.id_tipo2#" cfsqltype="cf_sql_numeric">
				  	  and LVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LVid2#">
					  
					<cfset action = "ISBatributoValor.cfm">
					<cfset modo = "ALTA">
				</cfquery>
			</cfif>
		<cfelseif isdefined("Url.Filtrar")>
			<cfset Form.id_tipo2 = Form.id_tipo>
		</cfif>
		
<cfelse> 
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("rsAlta") and isdefined("rsAlta.identity") and len(trim(rsAlta.identity))>
	<cfset form.LVid2 = "#rsAlta.identity#">
<cfelseif not isdefined('form.Cambio')>
	<cfset form.LVid2 = "">	
</cfif>

<cfif not isdefined("form.Nuevo") and not isdefined("form.Baja") and not isdefined("form.Baja")>
	<!--- crea los parametros que van a ser enviados por la URL--->
	<cfset params= params & "&id_tipo="&#Form.id_tipo2#&"&LVid="&#Form.LVid2#&"&nombre="&#Form.nombre#>
	<cflocation url="ISBatributoValor.cfm?Pagina=#Form.Pagina#&Filtro_LVnombre2=#Form.Filtro_LVnombre2#&HFiltro_LVnombre2=#Form.Filtro_LVnombre2#&Filtro_Habilit=#Form.Filtro_Habilit#&HFiltro_Habilit=#Form.Filtro_Habilit##params#">
<cfelse>
	<cfset params= params & "&id_tipo="&#Form.id_tipo2#&"&nombre="&#Form.nombre#>
	<cflocation url="ISBatributoValor.cfm?Pagina=#Form.Pagina#&Filtro_LVnombre2=#Form.Filtro_LVnombre2#&HFiltro_LVnombre2=#Form.Filtro_LVnombre2#&Filtro_Habilit=#Form.Filtro_Habilit#&HFiltro_Habilit=#Form.Filtro_Habilit##params#">
</cfif>
