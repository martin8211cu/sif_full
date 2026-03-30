	<cfif isdefined("url.TipoNeteo")>
		<cfset form.TipoNeteo = #url.TipoNeteo#>
	</cfif>

	<cfif isdefined("form.btnAplicar") OR (isDefined("form.botonSel") AND #form.botonSel# EQ "btnAplicar")>
	  <cfset ids = ArrayNew(1)>
		<cfif isdefined("form.chk")>
				<cfset ids = ListToArray(form.chk)>

				<cfloop from="1" to="#ArrayLen(ids)#" index="id">
					<cfset pipe = Find("|",#ids[id]#)>
					<cfset vIdDoctoNeteo = Mid(#ids[id]#,1,#pipe#-1)>

					<cfinvoke component="sif.Componentes.CC_AplicaDocumentoNeteo"
						method="CC_AplicaDocumentoNeteo"
						returnvariable="resultado"
						idDocumentoNeteo="#vIdDoctoNeteo#"
					/>
				</cfloop>
		</cfif>
	</cfif>
<cflocation url="Neteo-Lista#form.TipoNeteo#.cfm">