<cfif isdefined("form.chk") and len(trim(form.chk)) >
	<cfset ListaAplicar = form.chk >
	<!--- CODIGO PARA APLICACION DE IMPORTACION DE ASIENTOS CONTABLES --->
	<cfloop list="#ListaAplicar#" index="ECIid">
		<cfinvoke component="sif.Componentes.CG_AplicaImportacionAsiento" method="CG_AplicaImportacionAsiento">
			<cfinvokeargument name="ECIid" value="#ECIid#">
		</cfinvoke>
	</cfloop>
</cfif>

<cflocation url="DCImportacionMasiva-lista.cfm">