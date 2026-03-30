<cfparam name="url.pageNum_lista" default="1">
<cfset navegacion = '?pagenum_lista=#url.pageNum_lista#' >

<!--- filtro fecha --->
<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
	<cfset navegacion = navegacion & '&filtro_fechaI=#url.filtro_fechaI#' >
</cfif>
<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
	<cfset navegacion = navegacion & '&filtro_fechaF=#url.filtro_fechaF#' >
</cfif>
<!--- filtro concepto --->
<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
	<cfset navegacion = navegacion & '&filtro_CIid=#url.filtro_CIid#' >
</cfif>

<!--- filtro empleado --->
<cfif isdefined("url.DEid") and len(trim(url.DEid))>
	<cfset navegacion = navegacion & '&DEid=#url.DEid#' >
</cfif>
<!--- filtro empleado --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<cfset navegacion = navegacion & '&CFpk=#url.CFpk#' >
</cfif>
<!--- filtro centro funcional  --->
<cfif isdefined("url.dependencias") and len(trim(url.dependencias))>
	<cfset navegacion = navegacion & '&dependencias=#url.dependencias#' >
</cfif>

<!--- filtro de estado --->	
<cfif isdefined("url.filtro_estado")>
	<cfset navegacion = navegacion & '&filtro_estado=#url.filtro_estado#' >
</cfif>

<cfif isdefined("url.Accion") and trim(url.Accion) EQ 'BTNAprobar' >
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	
	<!--- empresa usa presupuesto --->
	<cfset usaPresupuesto = false >
	<cfquery name="rs_pres" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo = 540
	</cfquery>
	<cfif trim(rs_pres.Pvalor) eq 1 >
		<cfset usaPresupuesto = true >
	</cfif>
	
	<!---se selecciona el rol por el cual se va a hacer pasar el Administrador de incidencias para aprobar ya sea como jefe o como administrador--->	
	<cfif isdefined("url.codAccion") and len(trim(url.codAccion))>
		
		<cfset rolApp=0>
		<cfif url.codAccion EQ 1>
			<cfset rolApp=1>			<!---como Jefe--->
		<cfelseif url.codAccion EQ 4 or url.codAccion EQ 17>
			<cfset rolApp=2>			<!---como Admin--->
		</cfif>
	</cfif>
	
	<!---<cf_dump var="#rolApp#">--->
	
	<cfif isdefined("rolApp")>
		
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="ApruebaIncidencia"><!---aprueba como jefe--->
			<cfinvokeargument name="Iid" value="#url.Iid#">
			<cfinvokeargument name="usaPresupuesto" value="#usaPresupuesto#">
			<cfinvokeargument name="rol" value="1">
		</cfinvoke>
		
		<cfif rolApp NEQ 1>
		<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="ApruebaIncidencia"><!---aprueba como admin--->
			<cfinvokeargument name="Iid" value="#url.Iid#">
			<cfinvokeargument name="usaPresupuesto" value="#usaPresupuesto#">
			<cfinvokeargument name="rol" value="2">
		</cfinvoke>
		</cfif>
	</cfif>
	
<cfelseif isdefined("url.Accion") and trim(url.Accion) EQ 'BTNRechazar'>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="RechazaIncidenciaFinal">
		<cfinvokeargument name="Iid" value="#url.Iid#">
		<cfinvokeargument name="Ijustificacion" value="#url.Ijustificacion#">
	</cfinvoke>
	
</cfif>

<cflocation url="RegistroIncidenciasProceso.cfm#navegacion#">