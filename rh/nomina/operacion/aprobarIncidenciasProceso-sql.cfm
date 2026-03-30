
<cfset navegacion = '?pagenum_lista=#url.pageNum_lista#' >
<!--- filtro fecha --->
<cfif isdefined("url.filtro_fecha") and len(trim(url.filtro_fecha))>
	<cfset navegacion = navegacion & '&filtro_fecha=#url.filtro_fecha#' >
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

<cfif isdefined("url.btnAprobar") and isdefined("url.chk")>

	<!--- Averiguar rol. -1=Ninguno, 0=Usuario, 1=Jefe, 2=Administrador --->
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="getRol" returnvariable="rol"/>
	
	<cfif rol EQ 3>
		<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	</cfif>
	
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

	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="ApruebaIncidencia">
		<cfinvokeargument name="Iid" value="#url.chk#">
		<cfinvokeargument name="usaPresupuesto" value="#usaPresupuesto#">
	</cfinvoke>
	

<cfelseif isdefined("url.btnRechazar") and btnRechazar EQ 1 and isdefined("url.chk")>
	<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
	
	<cfinvoke component="rh.Componentes.RH_IncidenciasProceso" method="RechazaIncidencia">
		<cfinvokeargument name="Iid" value="#url.chk#">
		<cfinvokeargument name="Ijustificacion" value="#url.Ijustificacion#">
	</cfinvoke>
	
</cfif>

<cflocation url="aprobarIncidenciasProceso.cfm#navegacion#">