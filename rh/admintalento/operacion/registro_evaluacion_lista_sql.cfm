<cfset va_pendientes = ''>
<cfinvoke component="rh.admintalento.Componentes.RH_FinalizarRelacion" method="init" returnvariable="cerrar"/>			
<cfloop list="#form.chk#" index="id">	
	<cfif isdefined("form.cerrar")>
		<cfset cerrar.funcCierraPublicacion(id)>
		<cfquery datasource="#session.DSN#">
			update RHRelacionSeguimiento
			set RHRSestado = 30
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
		</cfquery>		
	<cfelseif isdefined("form.publicar")>
		<cfquery datasource="#session.DSN#">
			update RHRelacionSeguimiento
			set RHRSestado = 20
			where RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
		</cfquery>
	<cfelseif isdefined("form.eliminar")>
		<cfquery name="rsPendientes" datasource="#session.DSN#"><!----Hay respuestas pendientes en instancias sin cerrar (publicadas)---->
			select count(1) as pendientes
			from RHDRelacionSeguimiento a
				inner join RHRSEvaluaciones b
					on a.RHDRid = b.RHDRid
					and b.RHRSEestado = 10
			where a.RHRSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
				and a.RHDRestado = 20
		</cfquery>	

		<cfinvoke component="rh.admintalento.Componentes.RH_EliminarRelacion" method="init" returnvariable="eliminar"/>			

		<cfif rsPendientes.pendientes GT 0>
			<cfset va_pendientes = ListAppend(va_pendientes, id)>
		<cfelse>
			<cfset eliminar.funcBorrarTodaRelacion(id)>
		</cfif>
	</cfif>
</cfloop>
<cfif isdefined("va_pendientes") and len(trim(va_pendientes))>
	<cfinclude template="verificacion_eliminado.cfm">
<cfelse>
	<cflocation url="registro_evaluacion.cfm">
</cfif>
