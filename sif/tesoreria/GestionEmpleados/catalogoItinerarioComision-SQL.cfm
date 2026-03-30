<!---<cf_dump var="#form#" >--->
<cfif isdefined('form.ALTA')>
	<cfinvoke component="sif.tesoreria.GestionEmpleados.catalogoItinerarioComision"
		method="ALTA"
        
		GECid="#form.GECid#"
		GECIorigen="#form.GECIorigen#"
		GECIdestino="#form.GECIdestino#" 
		GECIhotel="#form.GECIhotel#" 
		GECIfsalida="#form.GECIfsalida#"
		GECIhinicio="#form.GECIhinicio#"
		GECIhfinal="#form.GECIhfinal#" 
		GECIlineaAerea="#form.GECIlineaAerea#" 
		GECInumeroVuelo="#form.GECInumeroVuelo#" 
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
		
	/>
	<cflocation url="catalogoItinerarioComision.cfm?modo=CAMBIO&GECIid=#LvarId#&GECid=#form.GECid#">
	
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="GECitinerario"
		redirect="catalogoItinerarioComision.cfm?modo=CAMBIO&GECIid=#form.GECIid#"
		timestamp="#form.ts_rversion#"
		field1="GECIid" 
		type1="numeric" 
		value1="#form.GECIid#">

	<cfinvoke component="sif.tesoreria.GestionEmpleados.catalogoItinerarioComision"
		method="CAMBIO"
        
		GECIid="#form.GECIid#"
		GECid="#form.GECid#"
		GECIorigen="#form.GECIorigen#"
		GECIdestino="#form.GECIdestino#" 
		GECIhotel="#form.GECIhotel#" 
		GECIfsalida="#form.GECIfsalida#"
		GECIhinicio="#form.GECIhinicio#"
		GECIhfinal="#form.GECIhfinal#" 
		GECIlineaAerea="#form.GECIlineaAerea#" 
		GECInumeroVuelo="#form.GECInumeroVuelo#"		
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="catalogoItinerarioComision.cfm?modo=CAMBIO&GECIid=#LvarId#&GECid=#form.GECid#">
	
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="sif.tesoreria.GestionEmpleados.catalogoItinerarioComision"
		method="BAJA"
		GECIid="#form.GECIid#"
		returnvariable="LvarId"
	/>		
	<cflocation url="catalogoItinerarioComision.cfm?modo=ALTA&GECid=#form.GECid#">
<cfelse>
	<cflocation url="catalogoItinerarioComision.cfm?modo=ALTA&GECid=#form.GECid#">
</cfif>
