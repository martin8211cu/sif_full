<cfset params="">
<cfset action = "incidencias.cfm">

<cfif not isdefined("form.Nuevo")>
		<cfset modo="CAMBIO">
		<cfif isdefined("Form.Alta")>
<!--- 			<cftransaction>				
				
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select
						d.PQcodigo, d.PQnombre,
						c.Contratoid, c.Vid, 
						e.AGid, 1 as paso	 
					from 
						ISBcuenta a
						inner join ISBpersona b
						on  b.Pquien = a.Pquien
																			
						inner join ISBproducto c
						on  a.CTid = c.CTid
						and CTcondicion = '0'	
																	
						inner join ISBpaquete d
						on  d.PQcodigo = c.PQcodigo
						and  d.PQcodigo = <cfqueryparam value="#form.PQcodigo#" cfsqltype="cf_sql_char">
						and  d.Habilitado = 1
					
						inner join ISBvendedor e
						on e.Vid = c.Vid
						and e.AGid = <cfqueryparam value="#session.saci.agente.id#" cfsqltype="cf_sql_numeric"><!------>
					where 
						a.CTid = <cfqueryparam value="#form.CTid#" cfsqltype="cf_sql_numeric">
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					order by  a.CUECUE
				</cfquery>
				
				<cfif rsDatos.RecordCount GT 0>
					<cfinvoke component="saci.comp.ISBagenteIncidencia" returnvariable="returnId" method="Alta"  >
						<cfinvokeargument name="Iid" value="#form.Iid#">
						<cfinvokeargument name="AGid" value="#rsDatos.AGid#">
						<cfinvokeargument name="CTid" value="#form.CTid#">
						<cfinvokeargument name="Contratoid" value="#rsDatos.Contratoid#">
						<cfinvokeargument name="IEstado" value="#form.IEstado#">
						<cfinvokeargument name="INobsCrea" value="#form.INobsCrea#">
					</cfinvoke>
				</cfif>
				
				<cfif isdefined("returnId")and len(trim(returnId))>
					<cfset form.INid = "#returnId#">
				<cfelse>
					<cfset form.INid = "">	
				</cfif>

			</cftransaction>
			
			<cfset modo="ALTA"> --->
			
		<cfelseif isdefined("Form.Cambio")>	
			<cftransaction>
				
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select
						d.PQcodigo, d.PQnombre,
						c.Contratoid, c.Vid, 
						e.AGid
					from 
						ISBcuenta a
						inner join ISBpersona b
						on  b.Pquien = a.Pquien
																			
						inner join ISBproducto c
						on  a.CTid = c.CTid
						and CTcondicion = '0'	
																	
						inner join ISBpaquete d
						on  d.PQcodigo = c.PQcodigo
						and  d.PQcodigo = <cfqueryparam value="#form.PQcodigo#" cfsqltype="cf_sql_char">
						and  d.Habilitado = 1
					
						inner join ISBvendedor e
						on e.Vid = c.Vid
					where 
						a.CTid = <cfqueryparam value="#form.CTid#" cfsqltype="cf_sql_numeric">
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					order by  a.CUECUE
				</cfquery>
				
				<cfif rsDatos.RecordCount GT 0>
					<cfinvoke component="saci.comp.ISBagenteIncidencia"
						method="CambioCorrige" >
						<cfinvokeargument name="INid" value="#form.INid#">
						<cfinvokeargument name="Iid" value="#form.Iid#">
						<cfinvokeargument name="AGid" value="#rsDatos.AGid#">
						<cfinvokeargument name="CTid" value="#form.CTid#">
						<cfinvokeargument name="Contratoid" value="#rsDatos.Contratoid#">
						<cfinvokeargument name="IEstado" value="#form.IEstado#">
						<cfinvokeargument name="INobsCorrige" value="#form.INobsCorrige#">
						<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
					</cfinvoke>
				</cfif>	
				<cfset modo="ALTA">
			</cftransaction>
		<cfelseif isdefined("Form.Baja")>			
			<cftransaction>
				<cfinvoke component="saci.comp.ISBagenteIncidencia"
					method="Baja" >
					<cfinvokeargument name="INid" value="#form.INid#">
				</cfinvoke>
				<cfset modo = "ALTA">
			</cftransaction>
		</cfif>
<cfelse> 
	<cfset modo = "ALTA">
</cfif>

<cfif not isdefined("form.Nuevo") and not isdefined("form.Baja")>
	<cfset params= params & "&INid=#Form.INid#&CTid=#form.CTid#">
	<cflocation url="incidencias.cfm?Pagina=#Form.Pagina#&Filtro_Inombre=#Form.Filtro_Inombre#&HFiltro_Inombre=#Form.Filtro_Inombre#&Filtro_IEstado=#Form.Filtro_IEstado#&HFiltro_IEstado=#Form.Filtro_IEstado#&Filtro_INobsCrea=#Form.Filtro_INobsCrea#&HFiltro_INobsCrea=#Form.Filtro_INobsCrea##params#">
<cfelse>
	<cfset params= "&CTid=#form.CTid#">
	<cflocation url="incidencias.cfm?Pagina=#Form.Pagina#&Filtro_Inombre=#Form.Filtro_Inombre#&HFiltro_Inombre=#Form.Filtro_Inombre#&Filtro_IEstado=#Form.Filtro_IEstado#&HFiltro_IEstado=#Form.Filtro_IEstado#&Filtro_INobsCrea=#Form.Filtro_INobsCrea#&HFiltro_INobsCrea=#Form.Filtro_INobsCrea##params#">
</cfif>
