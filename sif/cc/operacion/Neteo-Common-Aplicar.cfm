
<cfif isdefined("form.Aplicarneteo")>
	<cfif isdefined("url.idDocumentoNeteo")>
		<cfset form.chk = url.idDocumentoNeteo>
	<cfelseif isdefined("form.idDocumentoNeteo")>
		<cfset form.chk = form.idDocumentoNeteo>
	</cfif>
	<cfif isdefined("form.chk")>
		<cfset ids = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(ids)#" index="id">
			<cfinvoke 
				component="sif.Componentes.CC_AplicaDocumentoNeteo" 
				method="CC_AplicaDocumentoNeteo" 
				returnvariable="resultado"
				idDocumentoNeteo="#ids[id]#"
				/>
		</cfloop>
	</cfif>
</cfif>
<cflocation url="Neteo-Lista#form.TipoNeteo#.cfm">