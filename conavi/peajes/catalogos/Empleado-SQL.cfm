<!---<cf_dump var="#form#" >--->
<cfif isdefined('form.ALTA')>
	<cfinvoke component="conavi.Componentes.Empleado"
		method="ALTA"
		DEid="#form.DEid#"
		Pid="#form.Pid#"
		PEfechaini="#form.PEfechaini#" 
		PEfechafin="#form.PEfechafin#" 
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="Empleado.cfm?modo=CAMBIO&ID_PEmpleado=#LvarId#">
	
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PEmpleado"
		redirect="Empleado.cfm?modo=CAMBIO&ID_PEmpleado=#form.ID_PEmpleado#"
		timestamp="#form.ts_rversion#"
		field1="ID_PEmpleado" 
		type1="numeric" 
		value1="#form.ID_PEmpleado#">
	<cfinvoke component="conavi.Componentes.Empleado"
		method="CAMBIO"
		ID_PEmpleado="#form.ID_PEmpleado#"
		DEid="#form.DEid#"
		Pid="#form.Pid#"
		PEfechaini="#form.PEfechaini#" 
		PEfechafin="#form.PEfechafin#" 
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="Empleado.cfm?modo=CAMBIO&ID_PEmpleado=#LvarId#">
	
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="conavi.Componentes.Empleado"
		method="BAJA"
		ID_PEmpleado="#form.ID_PEmpleado#"
		returnvariable="LvarId"
	/>		
	<cflocation url="Empleado.cfm?modo=ALTA">
<cfelse>
	<cflocation url="Empleado.cfm?modo=ALTA">
</cfif>
