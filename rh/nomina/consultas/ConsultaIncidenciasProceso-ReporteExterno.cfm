<!---<cfquery name="rstemp" datasource="#session.DSN#">
	select distinct cf2.CFid,a.Iid
	from Incidencias a
	inner join LineaTiempo lt
	on lt.DEid = a.DEid
	inner join RHPlazas pl
	on lt.RHPid = pl.RHPid
	inner join CFuncional cf2
	on pl.CFid =cf2.CFid
	where a.CFid is null
</cfquery>

<cfloop query="rstemp">
	<cfset id = rstemp.Iid>
	<cfquery  datasource="#session.DSN#">
		update Incidencias
		set CFid = #rstemp.CFid#
		where Iid= #rstemp.Iid#
	</cfquery>
</cfloop>

<cfquery name="rstemp" datasource="#session.DSN#">
	select distinct cf2.CFid,a.Iid
	from HIncidencias a
	inner join LineaTiempo lt
	on lt.DEid = a.DEid
	inner join RHPlazas pl
	on lt.RHPid = pl.RHPid
	inner join CFuncional cf2
	on pl.CFid =cf2.CFid
	where a.CFid is null
</cfquery>

<cfloop query="rstemp">
	<cfset id = rstemp.Iid>
	<cfquery  datasource="#session.DSN#">
		update HIncidencias
		set CFid = #rstemp.CFid#
		where Iid= #rstemp.Iid#
	</cfquery>
</cfloop>--->

<!---Cuando es consultado desde la pantalla de visualizacion del Estado de Incidencias--->
<cfif isdefined("url.ConsultaExterna")>
	<cfset form.group_by = 1>

	<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) >
		<cfset form.CFid = url.CFpk>
	</cfif>
	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<cfset form.DEid = url.DEid>
	</cfif>
	<cfif isdefined("url.filtro_CIid") and len(trim(url.filtro_CIid))>
		<cfset form.CIid = url.filtro_CIid>
	</cfif>
	<cfif isdefined("url.filtro_fechaI") and len(trim(url.filtro_fechaI))>
		<cfset form.Fdesde = url.filtro_fechaI>
	<cfelse>
		<cfset form.Fdesde = LSDateformat(now(),'dd/mm/yyyy')>
	</cfif>
	<cfif isdefined("url.filtro_fechaF") and len(trim(url.filtro_fechaF))>
		<cfset form.Fhasta = url.filtro_fechaF>
	</cfif>
	<cfif isdefined('url.filtro_estado') and url.filtro_estado eq 0 >									<!---filtro ingresadas--->
		<cfset form.estado = 0>
	<cfelseif  isdefined('url.filtro_estado') and listFindNoCase('1,4',url.filtro_estado,',') >			<!---filtro pendiente--->
		<cfset form.estado = 1>
	<cfelseif  isdefined('url.filtro_estado') and listFindNoCase('3,6,7',url.filtro_estado,',')>		<!---filtro apruebados--->
		<cfset form.estado = 2>
	<cfelseif  isdefined('url.filtro_estado') and listFindNoCase('2,5,8',url.filtro_estado,',')>		<!---filtro rechazados--->
		<cfset form.estado = 3>
	</cfif>

	<cfset vIrA= "../operacion/EstadoIncidenciasProceso.cfm">
	
</cfif>
<!---
Casos filtro_estado: 
0 = filtro incidencias ingresadas; 
1 = filtro pendiente de aprobar por el jefe; 
2 = filtro rechazado por el jefe; 
3 = filtro apruebado por jefe; 
4 = filtro pendiente de aprobar por el admin; 
5 = filtro rechazado por el admin; 
6 = filtro apruebado por el admin; 
7 = aprobado con presupuesto;
8 = aprobado por el admin pero rechazado por el presupuesto;
--->		