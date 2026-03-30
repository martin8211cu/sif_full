<cfif isdefined("url.action")>
	<cfset estado_nuevo = 20 >

	<cfif url.action eq 'cerrar'>
		<cfset estado_nuevo = 30 >
	</cfif>

	<cftry>
		<cfset resultado = 1 >

		<cfinvoke component="rh.admintalento.Componentes.RH_PublicarRelacion" method="init" returnvariable="publicar" />		

		<cfif url.action neq 'eliminar'>
			<cfif estado_nuevo EQ 30><!---Si es finalizar/cerrar la instancia---->
				<cfquery name="rsRelacionM" datasource="#session.DSN#">
					select a.RHRSid 
					from RHDRelacionSeguimiento a
						inner join RHRelacionSeguimiento b
							on a.RHRSid = b.RHRSid
					where a.RHDRid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">				
				</cfquery>
				<cfinvoke component="rh.admintalento.Componentes.RH_FinalizarRelacion" method="init" returnvariable="cerrar"/>			
				<cfset cerrar.funcCierraPublicacion(rsRelacionM.RHRSid,url.id)>
			</cfif>
			<cfset publicar.cambiarEstadoInstancia(url.id, estado_nuevo) >
		<cfelse>
			<cfset publicar.eliminarInstancia(url.id) >
		</cfif>	

	<cfcatch type="any"	>
		<cfset resultado = 0 >
	</cfcatch>
	</cftry>
	<!--- 1: proceso correcto; 0: error en proceso--->
	<cfoutput>#resultado#</cfoutput>
</cfif>