<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.btnAsociar")>
		<cfif isdefined("Form.borrados") and Len(Trim(Form.borrados))>
			<cfset ArticulosaCambiar= ListToArray(Form.borrados)> <!--- Articulos desmarcados --->
			<cfloop from="1" to="#ArrayLen(ArticulosaCambiar)#" index="i">
				<cfset cambiados = ListToArray(ArticulosaCambiar[i],'|')>
				<!---  Cambiar el estado del Artículo 0 = No activo, 1 = Activo --->
				<cfquery name="CambioArtxpista" datasource="#Session.DSN#">
					update Artxpista set Estado = 0
					where  Pista_id = <cfqueryparam value="#form.Pista_id#" cfsqltype="cf_sql_numeric"> 
					  and  Ecodigo 	= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and  Aid 		= <cfqueryparam value="#cambiados[1]#" cfsqltype="cf_sql_numeric"> 
					  and  Alm_Aid 	= <cfqueryparam value="#cambiados[2]#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined("Form.chk") and Len(Trim(Form.chk))>
			<cfset articulos = ListToArray(Form.chk)>
			<cfset ArticulosaIncluir = ListToArray(Form.chk)>
			<cfloop from="1" to="#ArrayLen(articulos)#" index="i">
				<cfset datos = ListToArray(articulos[i],'|')>		
				<!--- Validar si existe el Articulo en Artxpista --->
				<cfquery name="Existe" datasource="#Session.DSN#">
					select 1 from Artxpista 
					where  Pista_id = <cfqueryparam value="#form.Pista_id#" cfsqltype="cf_sql_numeric"> 
					  and  Ecodigo 	= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and  Aid 		= <cfqueryparam value="#datos[1]#" cfsqltype="cf_sql_numeric"> 
					  and  Alm_Aid 	= <cfqueryparam value="#datos[2]#" cfsqltype="cf_sql_numeric"> 
				</cfquery>
				<cfif isdefined("Existe") and Existe.RecordCount NEQ 0>
					<cfquery name="UpdArtxpista" datasource="#Session.DSN#">
						update Artxpista set Estado = 1
						where  Pista_id = <cfqueryparam value="#form.Pista_id#" cfsqltype="cf_sql_numeric"> 
						  and  Ecodigo 	= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and  Aid 		= <cfqueryparam value="#datos[1]#" cfsqltype="cf_sql_numeric"> 
						  and  Alm_Aid 	= <cfqueryparam value="#datos[2]#" cfsqltype="cf_sql_numeric"> 
					</cfquery>
				<cfelse>
					<cfquery name="insert" datasource="#Session.DSN#">
						insert into Artxpista (Ecodigo, Aid, Pista_id, Alm_Aid, BMUsucodigo, Estado)
						values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
								 <cfqueryparam value="#datos[1]#" cfsqltype="cf_sql_numeric">,
								 <cfqueryparam value="#form.Pista_id#" cfsqltype="cf_sql_numeric">,
								 <cfqueryparam value="#datos[2]#" cfsqltype="cf_sql_numeric">,
								 <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
								 ,1)
					</cfquery>		
				</cfif>
				<cfif not isdefined("form.Pista_id") and isdefined("datos") and len(trim(datos)) NEQ 0 >
					<cfset form.Pista_id = datos[3]>
				</cfif>
				<cfif not isdefined("form.Aid") and isdefined("datos") and len(trim(datos)) NEQ 0 >
					<cfset form.Aid = datos[2]>
				</cfif>
			</cfloop>   
		</cfif>
	</cfif>
</cfif>


<cfset params="">
<cfif isdefined('form.btnFiltrar') and form.btnFiltrar NEQ ''>
	<cfset params= params&'&btnFiltrar='&form.btnFiltrar>	
</cfif>
<cfif isdefined('form.Pista_id') and form.Pista_id NEQ ''>
	<cfset params= params&'&Pista_id='&form.Pista_id>	
</cfif>
<cfif isdefined('form.Aid') and form.Aid NEQ ''>
	<cfset params= params&'&Aid='&form.Aid>	
</cfif>
<cfif isdefined('form.fAcodigo') and form.fAcodigo NEQ ''>
	<cfset params= params&'&fAcodigo='&form.fAcodigo>	
</cfif>
<cfif isdefined('form.fADescripcion') and form.fADescripcion NEQ ''>
	<cfset params= params&'&fADescripcion='&form.fADescripcion>	
</cfif>

<cflocation url="ArtXPista.cfm?Pagina=#Form.Pagina##params#">