<cfif not isdefined("Request.fncualmes")>
	<cffunction name="fncualmes" returntype="string">
		<cfargument name="mes" type="numeric">
		<cfquery name="rsMeses" datasource="sifControl">
				select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
				from Idiomas a, VSidioma b 
				where a.Icodigo = '#Session.Idioma#'
				and b.VSgrupo = 1
				and a.Iid = b.Iid
				order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
		</cfquery>
		<cfloop query="rsMeses">
			<cfif rsMeses.Pvalor is mes>
				<cfreturn rsMeses.Pdescripcion>
			</cfif>
		</cfloop>
	</cffunction>
	<cfset Request.fncualmes = "fncualmes">
</cfif>
