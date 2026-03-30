<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>
    
<cfif isdefined("btnGenerar")>
	<cf_PleaseWait SERVER_NAME="/cfmx/sif/af/operacion/gtProceso_sql_DepPorActidad#LvarPar#.cfm" >
	<cfif len(trim(form.AGTPdescripcion)) GTE 80>
		<cfset form.AGTPdescripcion = mid(form.AGTPdescripcion,1,75) & '...'>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_DepreciacionPorActividadActivos" method="ALTA" returnvariable="AGTPid">
		<cfif isdefined("form.AGTPdescripcion") and len(trim(form.AGTPdescripcion))>
			<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#"><!---Descripción de la transacción--->
		</cfif>
		<cfif isdefined("form.FOcodigo") and len(trim(form.FOcodigo))>  
			<cfinvokeargument name="FOcodigo"   value="#form.FOcodigo#"><!--- Filtro por Oficina --->
		</cfif>
		<cfif isdefined("form.FDcodigo") and len(trim(form.FDcodigo))>  
			<cfinvokeargument name="FDcodigo" value="#form.FDcodigo#"><!--- Filtro por Departamento --->
		</cfif>
		<cfif isdefined("form.FCFid") and len(trim(form.FCFid))>	  
			<cfinvokeargument name="FCFid"      value="#form.FCFid#"><!--- Filtro por Centro  --->
		</cfif>
		<cfif isdefined("form.FACcodigo") and len(trim(form.FACcodigo))> 
			<cfinvokeargument name="FACcodigo"  value="#form.FACcodigo#"><!--- Filtro por Categoria --->
		</cfif>
		<cfif isdefined("form.FACid") and len(trim(form.FACid))>	  
			<cfinvokeargument name="FACid"      value="#form.FACid#"><!--- Filtro por Clase --->
		</cfif>
		<cfif isdefined("form.FAFCcodigo")and len(trim(form.FAFCcodigo))>
			<cfinvokeargument name="FAFCcodigo" value="#form.FAFCcodigo#"><!--- Filtro por Tipo --->
		</cfif>
		<cfif isdefined("form.AplacaDesde")and len(trim(form.AplacaDesde))>
			<cfinvokeargument name="AplacaDesde" value="#form.AplacaDesde#"><!---Filtro por Placa Origen--->
		</cfif>
		<cfif isdefined("form.AplacaHasta")and len(trim(form.AplacaHasta))>
			<cfinvokeargument name="AplacaHasta" value="#form.AplacaHasta#"><!--- Filtro por Placa Fin --->
		</cfif>
	</cfinvoke>
	<cflocation url="agtProceso_genera_DepPorActidad#LvarPar#.cfm?AGTPid=#AGTPid#">
</cfif>
<cflocation url="agtProceso_DEPRECIACION#LvarPar#.cfm"> 