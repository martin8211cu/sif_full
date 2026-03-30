<cfif isdefined("Form.Aprobar")>
	<cfquery name="rsDetalleRHPreLiquidacionPersonal" datasource="#session.DSN#">
		select RHPLPfsalida
			from RHPreLiquidacionPersonal 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            	and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
	</cfquery>
    
	<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnGetLF" returnvariable="rsLF">
		<cfinvokeargument name="RHPLPid" value="#form.RHPLPid#">
        <cfinvokeargument name="DEid" value="#form.DEid#">
	</cfinvoke>
 

	<cfif rsLF.recordcount gt 0>
		<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnValidaModificaciones" returnvariable="datosHanCambiado">
			<cfinvokeargument name="RHPLPid" value="#form.RHPLPid#">
			<cfinvokeargument name="DEid" value="#form.DEid#">
			<cfinvokeargument name="Fecha" value="#rsDetalleRHPreLiquidacionPersonal.RHPLPfsalida#">
		</cfinvoke>
		<cfif datosHanCambiado>
			<cfthrow message="Los datos del paso 2 han sido modificados y no se han guardado, debe de Guardar los datos para aprobar la Liquidación.">
		</cfif>
	<cfelse>
		<cfthrow message="El paso 2 es necesario para la liquidación y este no ha sido proceso, debe de Guardar los datos generados por este para aprobar la Liquidación.">
	</cfif>

	<!---ljimenez Actuliza el estado de la preliquidacion para dejarlo en firme y no se pueda reutilizar--->

    <cfquery name="updLiquidacion" datasource="#Session.DSN#">
        update RHPreLiquidacionPersonal
        set RHPLPestado = 1,
        RHPLPfecha = RHPLPfsalida
        where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
    </cfquery>
		
	<cflocation url="PreliquidacionProceso.cfm">
</cfif>