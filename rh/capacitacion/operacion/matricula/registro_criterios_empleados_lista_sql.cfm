<cfparam name="FORM.RHRCid" type="numeric">
<cfparam name="FORM.CHK" type="string" default="">
<cfset params = ''>

<cfif isdefined('form.Filtro_DEidentificacion') and LEN(TRIM(Filtro_DEidentificacion))>
	<cfset params = params & '&Filtro_DEidentificacion=#form.Filtro_DEidentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_NombreCompleto') and LEN(TRIM(Filtro_NombreCompleto))>
	<cfset params = params & '&Filtro_NombreCompleto=#form.Filtro_NombreCompleto#'>
</cfif>
<cfif isdefined('form.HFiltro_DEidentificacion') and LEN(TRIM(HFiltro_DEidentificacion))>
	<cfset params = params & '&HFiltro_DEidentificacion=#form.HFiltro_DEidentificacion#'>
</cfif>
<cfif isdefined('form.HFiltro_NombreCompleto') and LEN(TRIM(HFiltro_NombreCompleto))>
	<cfset params = params & '&HFiltro_NombreCompleto=#form.HFiltro_NombreCompleto#'>
</cfif>

<cfif isdefined("FORM.BTNELIMINAR") and FORM.BTNELIMINAR eq 1>
	<cfquery name="ABC_ELIM_MASIVO" datasource="#SESSION.DSN#">
		delete from RHDRelacionCap
		where DEid in ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#" list="yes"> )
		  and RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.RHRCid#">
	</cfquery>
<cfelseif isdefined("FORM.BTNGENERAREMPL") and FORM.BTNGENERAREMPL eq 1>
	<!--- Dentro está contemplado esta ejecución especial del proceso de generación --->
	<cfinclude template="registro_criterios_empleados_sql.cfm">
<cfelseif isdefined("FORM.BTNGENERAREMPLS") and FORM.BTNGENERAREMPLS eq 1>
	<cfset FORM.DEIDLIST = FORM.CHK>
	<!--- Dentro está contemplado esta ejecución especial del proceso de generación --->
	<cfinclude template="registro_criterios_empleados_sql.cfm">
</cfif>
<cflocation url="index.cfm?RHRCid=#FORM.RHRCid#&SEL=3#params#">
