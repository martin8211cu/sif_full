<cfif not isdefined("Request.Translate")>
	<cffunction name="Translate" displayname="Translate" output="false" hint="Translate">
		<cfargument name="Etiqueta" default="" type="string" required="true">
		<cfargument name="default" default="" type="string" required="true">
		<cfargument name="File" default="" type="string" required="false">
		<cfargument name="Idioma" default="" type="String" required="false">
	
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="#Arguments.Etiqueta#"
			Default="#Arguments.default#"
			XmlFile="#Arguments.File#"
			returnvariable="Traduccion"/>
			
			<cfreturn #Traduccion#>
	</cffunction>
	<cfset Request.Translate = Translate>
</cfif>