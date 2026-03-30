<!---<cf_dump var="#form#" >--->
<cfparam name="form.GEPVaplicaTodos" default="0">
<cfif isdefined('form.ALTA')>
	<cfinvoke component="sif.tesoreria.GestionEmpleados.catalogoPlantillaViaticos"
		method="ALTA"
		Mcodigo="#form.monedas#" 
		GEPVmonto="#replace(form.GEPVmonto,',','','ALL')#" 
		
		GECid="#form.GECid#"
		GECVid="#form.GECVid#"
		GEPVcodigo="#form.GEPVcodigo#" 
		GEPVtipoviatico="#form.GEPVtipoviatico#" 
		GEPVdescripcion="#form.GEPVdescripcion#"
		GEPVaplicaTodos="#form.GEPVaplicaTodos#"
		GEPVhoraini="#form.GEPVhoraini#" 
		GEPVhorafin="#form.GEPVhorafin#" 
		GEPVfechaini="#form.GEPVfechaini#" 
		GEPVfechafin="#form.GEPVfechafin#" 
		
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
		
	/>
	<cflocation url="catalogoPlantillaViaticos.cfm?modo=CAMBIO&GEPVid=#LvarId#">
	
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="GEPlantillaViaticos"
		redirect="catalogoPlantillaViaticos.cfm?modo=CAMBIO&GEPVid=#form.GEPVid#"
		timestamp="#form.ts_rversion#"
		field1="GEPVid" 
		type1="numeric" 
		value1="#form.GEPVid#">
	<cfinvoke component="sif.tesoreria.GestionEmpleados.catalogoPlantillaViaticos"
		method="CAMBIO"
		GEPVid="#form.GEPVid#"
		Mcodigo="#form.monedas#" 
		GEPVmonto="#replace(form.GEPVmonto,',','','ALL')#" 
		
		GECid="#form.GECid#"
		GECVid="#form.GECVid#"
		GEPVcodigo="#form.GEPVcodigo#" 
		GEPVtipoviatico="#form.GEPVtipoviatico#" 
		GEPVdescripcion="#form.GEPVdescripcion#"
		GEPVaplicaTodos="#form.GEPVaplicaTodos#"
		GEPVhoraini="#form.GEPVhoraini#" 
		GEPVhorafin="#form.GEPVhorafin#" 
		GEPVfechaini="#form.GEPVfechaini#" 
		GEPVfechafin="#form.GEPVfechafin#" 
		
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="catalogoPlantillaViaticos.cfm?modo=CAMBIO&GEPVid=#LvarId#">
	
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="sif.tesoreria.GestionEmpleados.catalogoPlantillaViaticos"
		method="BAJA"
		GEPVid="#form.GEPVid#"
		returnvariable="LvarId"
	/>		
	<cflocation url="catalogoPlantillaViaticos.cfm?modo=ALTA">
<cfelse>
	<cflocation url="catalogoPlantillaViaticos.cfm?modo=ALTA">
</cfif>
