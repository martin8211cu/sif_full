<cfinvoke key="MSG_LaAccionNoTieneConceptosDePagoParaAgregar" default="La Acción no tiene conceptos para agregar"	 returnvariable="MSG_LaAccionNoTieneConceptosDePagoParaAgregar" component="sif.Componentes.Translate" method="Translate"/>
<cfset param = ''>
<cfif not isdefined('form.btnNuevo')>
	<cftransaction>
		<cfif isdefined('form.btnGuardar') or isdefined('form.btnAplicar')>
			<!--- MODIFICA DATOS DEL ENCABEZADO --->
			<cfquery name="UpdateACP" datasource="#session.DSN#">
				update RHAccionesCarreraP
				set RHACPObserv = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechaalta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
			<cfset param = '?RHACPlinea=' & form.RHACPlinea>	
			<cfif isdefined('form.btnAplicar')>
				<cfquery name="VerificaDatos" datasource="#session.DSN#">
					select 1
					from DRHAccionesCarreraP
					where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
				</cfquery>
				<cfif isdefined("VerificaDatos") and VerificaDatos.RecordCount>
					<!--- LLAMA EL COMPONENTE PARA APLICAR LA ACCION --->
						<cfinvoke component="rh.carreraProfesional.Componentes.CPAplicaAccion" method="AplicaAccion"
							datasource="#session.dsn#"
							ecodigo = "#Session.Ecodigo#"
							rhacplinea = "#Form.RHACPlinea#"
							usucodigo = "#Session.Usucodigo#"/>
					<!--- MODIFICA EL ESTADO DE LA ACCION COMO APLICADA --->
					<cfquery name="UpdateAccion" datasource="#session.DSN#">
						update RHAccionesCarreraP
						set Estado = 30
						where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
					</cfquery>	
				<cfelse>
					<cfthrow message="<cfoutput>#MSG_LaAccionNoTieneConceptosDePagoParaAgregar#</cfoutput>">
				</cfif>	
			</cfif>	
		<cfelseif isdefined('form.btnRechazar')>
			<!--- MODIFICA EL ESTADO DE LA ACCIÓN COMO RECHAZADA --->
			<cfquery name="UpdateAccion" datasource="#session.DSN#">
				update RHAccionesCarreraP
				set Estado = 20
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
		</cfif>
	</cftransaction>
</cfif>
<cfif isdefined('btnGuardar')>
	<cflocation url="CPAprobacion.cfm#param#">
<cfelse>
	<cflocation url="CPAprobacion-lista.cfm">
</cfif>