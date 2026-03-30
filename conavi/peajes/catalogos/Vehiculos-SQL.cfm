<!---<cf_dump var="#form#" >--->
<cfif isdefined ('form.oficial') >
	<cfset form.oficial='1'>
<cfelse>
	<cfset form.oficial='0'> 
</cfif>
<cfif isdefined('form.ALTA')>
	<cfinvoke component="conavi.Componentes.Vehiculos"
		method="ALTA"
		PVcodigo="#form.codigo#"
		PVdescripcion="#form.descripcion#"
		PVoficial="#form.oficial#" 
		BMUsucodigo="#form.BMUsucodigo#"
		Ecodigo="#form.Ecodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="Vehiculos.cfm?modo=CAMBIO&PVid=#LvarId#">
	
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PVehiculos"
		redirect="Vehiculos.cfm?modo=CAMBIO&PVid=#form.PVid#"
		timestamp="#form.ts_rversion#"
		field1="PVid" 
		type1="numeric" 
		value1="#form.PVid#"
		field2="Ecodigo" 
		type2="numeric" 
		value2="#form.Ecodigo#">
	<cfinvoke component="conavi.Componentes.Vehiculos"
		method="CAMBIO"
		PVid="#form.PVid#"
		PVcodigo="#form.codigo#"
		PVdescripcion="#form.descripcion#"
		PVoficial="#form.oficial#" 
		BMUsucodigo="#form.BMUsucodigo#"
		Ecodigo="#form.Ecodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="Vehiculos.cfm?modo=CAMBIO&PVid=#LvarId#">
	
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="conavi.Componentes.Vehiculos"
		method="BAJA"
		PVid="#form.PVid#"
		PVcodigo="#form.codigo#"
		Ecodigo="#form.Ecodigo#"
		returnvariable="LvarId"
	/>		
	<cflocation url="Vehiculos.cfm?modo=ALTA">
<cfelse>
	<cflocation url="Vehiculos.cfm?modo=ALTA">
</cfif>
