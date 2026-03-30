<cfif isdefined('form.Liberar')>
	<cftransaction>
       
		<cfinvoke component="sif.Componentes.garantia"
			method="ALTA_LIBERACION"
			COEGid="#form.COEGid#"
			COLGObservacion="#form.observaciones#"
			COLGFecha="#now()#"
			COLGUsucodigo="#session.Usucodigo#"
			COEGVersion="#form.COEGVersion#"
			COLGTipoMovimiento="1" <!--- Liberacion --->
			returnvariable="LvarId"
		/>
		<cfinvoke component="sif.Componentes.garantia"
			method="CAMBIO_GARANTIA"
			COEGid="#form.COEGid#"
			COEGVersion="#form.COEGVersion#"
			COEGEstado="6" <!--- Estado En proceso Liberación  --->
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaLiberacionGarantia.cfm">
<cfelseif isdefined('form.Ejecutar')>
	<cftransaction>

		<cfinvoke component="sif.Componentes.garantia"
			method="ALTA_LIBERACION"
			COEGid="#form.COEGid#"
			COLGObservacion="#form.observaciones#"
			COLGFecha="#now()#"
			COLGUsucodigo="#session.Usucodigo#"
			COEGVersion="#form.COEGVersion#"
			COLGTipoMovimiento="2"<!--- Ejecución --->
			returnvariable="LvarId"
		/>
		<cfinvoke component="sif.Componentes.garantia"
			method="CAMBIO_GARANTIA"
			COEGid="#form.COEGid#"
			COEGVersion="#form.COEGVersion#"
			COEGEstado="3" <!--- En proceso de Ejecución  --->
			returnvariable="LvarId"
		/>
	</cftransaction>
	<cflocation url="listaEjecucionGarantia.cfm">
</cfif>	