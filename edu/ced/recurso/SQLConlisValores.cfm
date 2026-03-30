<cfset action = "ConlisValores.cfm">
<cfif not isdefined("form.Nuevo")>
		<cfset modo="CAMBIO">
		
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsAlta" datasource="#Session.Edu.DSN#">
				if not exists ( select 1 from MAValorAtributo a
					where a.id_atributo = <cfqueryparam value="#Form.id_tipo2#" cfsqltype="cf_sql_numeric">
					  and rtrim(ltrim(a.contenido)) = <cfqueryparam value="#Form.contenido#" cfsqltype="cf_sql_varchar">
				)
				begin
					declare @cont int
					select @cont = isnull(max(a.orden_valor),0)+10 
					from MAValorAtributo a, MAAtributo b
					where a.id_atributo = <cfqueryparam value="#Form.id_tipo2#" cfsqltype="cf_sql_numeric">
					  and b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
					  and a.id_atributo = b.id_atributo 
					  
					insert MAValorAtributo (id_atributo, contenido, orden_valor)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo2#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.contenido#">,
								<cfif len(trim(#Form.orden_valor#)) NEQ 0 >
									<cfqueryparam value="#Form.orden_valor#" cfsqltype="cf_sql_integer">
								<cfelse>
									@cont	
								</cfif>
								)
					select @@identity as id
					set nocount off
				end
				else
					select 1
					<cfset modo="ALTA">
			</cfquery>	
		
		<!--- Caso 1.1: Cambia Encabezado --->
		<cfelseif isdefined("Form.Cambio")>	
			<cfquery name="rsCambio" datasource="#Session.Edu.DSN#">
				declare @cont int
				select @cont = isnull(max(a.orden_valor),0)+10 
				from MAValorAtributo a, MAAtributo b
				where a.id_atributo = <cfqueryparam value="#Form.id_tipo2#" cfsqltype="cf_sql_numeric">
				  and b.CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_integer">
				  and id_valor != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_valor2#">
				  and a.id_atributo = b.id_atributo 
				  
				update MAValorAtributo
				set contenido = <cfqueryparam value="#form.contenido#" cfsqltype="cf_sql_varchar">,
					<cfif len(trim(#Form.orden_valor#)) NEQ 0 >
						orden_valor = <cfqueryparam value="#Form.orden_valor#" cfsqltype="cf_sql_integer">
					<cfelse>
						orden_valor = @cont	
					</cfif>
				where id_atributo = <cfqueryparam value="#form.id_tipo2#" cfsqltype="cf_sql_numeric">
				  and id_valor=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_valor2#">
				  
			 	update MAAtributoDocumento
				set valor = <cfqueryparam value="#form.contenido#" cfsqltype="cf_sql_varchar">
				where id_atributo = <cfqueryparam value="#form.id_tipo2#" cfsqltype="cf_sql_numeric">
				  and id_valor=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_valor2#">
			 </cfquery>
			<cfset modo="ALTA">
		<!--- Caso 2: Borrar un Encabezado del Tipo de MAAtributo --->
		<cfelseif isdefined("Form.Baja")>			
			<cfif isdefined("Form.id_tipo2") AND Form.id_tipo2 NEQ "" >
				<cfquery name="rsCambio" datasource="#Session.Edu.DSN#">
					delete MAValorAtributo 
					where id_atributo = <cfqueryparam value="#form.id_tipo2#" cfsqltype="cf_sql_numeric">
				  	  and id_valor=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_valor2#">
					  
					<cfset action = "ConlisValores.cfm">
					<cfset modo = "ALTA">
				</cfquery>
			</cfif>
		</cfif>
		
<cfelse> 
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("Form.Alta")>
	<cfset form.id_valor2 = "#rsAlta.id#">
</cfif>

<cfset params="">
<cfif not isdefined("form.Nuevo") and not isdefined("form.Baja")>
	<!--- crea los parametros que van a ser enviados por la URL--->
	<cfset params= "&id_tipo="&#Form.id_tipo2#&"&id_valor="&#Form.id_valor2#&"&nombre="&#Form.nombre#>
	<cflocation url="ConlisValores.cfm?Pagina=#Form.Pagina#&Filtro_contenido2=#Form.Filtro_contenido2#&HFiltro_contenido2=#Form.Filtro_contenido2#&Filtro_orden_val=#Form.Filtro_orden_val#&HFiltro_orden_val=#Form.Filtro_orden_val##params#">
<cfelse>
	<cfset params= "&id_tipo="&#Form.id_tipo2#&"&nombre="&#Form.nombre#>
	<cflocation url="ConlisValores.cfm?Pagina=#Form.Pagina#&Filtro_contenido2=#Form.Filtro_contenido2#&HFiltro_contenido2=#Form.Filtro_contenido2#&Filtro_orden_val=#Form.Filtro_orden_val#&HFiltro_orden_val=#Form.Filtro_orden_val##params#">
</cfif>
