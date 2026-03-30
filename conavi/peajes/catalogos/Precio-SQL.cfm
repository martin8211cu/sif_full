<!---<cf_dump var="#form#" >--->
<cfif isdefined('form.ALTA')>
	<cfinvoke component="conavi.Componentes.Precio"
		method="ALTA"
		Pid="#form.Pid#"
		PVid="#form.PVid#"
		Mcodigo="#form.monedas#" 
		PPrecio="#form.PPrecio#" 
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="Precio.cfm?modo=CAMBIO&ID_PPreciov=#LvarId#">
	
<cfelseif isdefined('form.CAMBIO')>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="PPrecio"
		redirect="Precio.cfm?modo=CAMBIO&ID_PPreciov=#form.ID_PPreciov#"
		timestamp="#form.ts_rversion#"
		field1="ID_PPreciov" 
		type1="numeric" 
		value1="#form.ID_PPreciov#">
	<cfinvoke component="conavi.Componentes.Precio"
		method="CAMBIO"
		ID_PPreciov="#form.ID_PPreciov#"
		Pid="#form.Pid#"
		PVid="#form.PVid#"
		Mcodigo="#form.monedas#" 
		PPrecio="#replace(form.PPrecio,',','','ALL')#" 
		BMUsucodigo="#form.BMUsucodigo#"
		returnvariable="LvarId"
	/>
	<cflocation url="Precio.cfm?modo=CAMBIO&ID_PPreciov=#LvarId#">
	
<cfelseif isdefined('form.BAJA')>
	<cfinvoke component="conavi.Componentes.Precio"
		method="BAJA"
		ID_PPreciov="#form.ID_PPreciov#"
		returnvariable="LvarId"
	/>		
	<cflocation url="Precio.cfm?modo=ALTA">
<cfelse>
	<cflocation url="Precio.cfm?modo=ALTA">
</cfif>
