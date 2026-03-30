<cfquery name="rsLista" datasource="#session.DSN#">
	select a.ETLCid,DIRECCION_POR_SENAS ,PROVINCIA,CANTON ,DISTRITO  
	from EmpresasTLC a
	inner join EmpresasNuevoXLS b
		on a.ETLCpatrono = NUM_PATRONAL_CEDULA
	where ETLCdireccionEmp  is  null	
</cfquery>
<cfdump var="#rsLista.recordCount#">

<cfset llave = 0>
<cfset direccion = 0>
<cfloop query="rsLista">
		<cfset llave = rsLista.ETLCid>
			<cftransaction>
			<cfquery name="RSinsert" datasource="asp">
				insert into Direcciones (Ppais,direccion1,direccion2,ciudad,estado,BMUsucodigo,BMfechamod)
				values (
					'CR',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLista.DIRECCION_POR_SENAS#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLista.PROVINCIA#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLista.CANTON#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsLista.DISTRITO#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				)	
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="RSinsert">
			<cfif isdefined('RSinsert')>
				<cfset direccion = RSinsert.identity>
			</cfif>
			</cftransaction>

			<cfif isdefined('direccion') and direccion neq 0>
				<cfquery name="update" datasource="#session.DSN#">
					update EmpresasTLC 
						set  ETLCdireccionEmp =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#direccion#">
						where ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">
				</cfquery>
			</cfif>	
			<cfset direccion =0>
		
</cfloop>