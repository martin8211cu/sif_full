<cfif isdefined("form.Cambio") and Form.Cambio EQ 1>
	<cfif isdefined('form.Habilitado')>
		<cfinvoke component="saci.comp.ISBvendedor"
			method="hab_inhabilitarVendedor" 
			Vid="#form.VEN#"
			Habilitado="#form.Habilitado#"
		/>
	</cfif>
</cfif>

<cflocation url="vendedor.cfm">