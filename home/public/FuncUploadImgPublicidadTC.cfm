<cfoutput>
	<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
	<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
		<cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
	<cfelse> 
		<cfset vsPath_R = "#vsPath_R#\">
	</cfif>

	<cfif !DirectoryExists("#vsPath_R#Enviar") >
		<cfset DirectoryCreate("#vsPath_R#Enviar")>
	</cfif>
	
	<cfset vsPath_R = "#vsPath_R#Enviar\publicidad.jpg">

	<img src="../../Enviar/publicidad.jpg?guid=#CreateUUID()#" height="100">
	
	
	<cfif isdefined('form.FILETOUPLOAD')>
		<cftry>
			<cfset imagen = imageReadBase64("#form.BINARY_IMG#")>
			<cfimage 
			source="#imagen#"
			destination="#vsPath_R#" 
			overwrite = "true"
			action="write">
			<script>
				//location.href ="FuncUploadImgPublicidadTC.cfm";
			</script>
		<cfcatch>
			<cfrethrow>
			<cfthrow message = "No se pudo cargar el archivo">
		</cfcatch>
		</cftry>
	</cfif>

</cfoutput>
		

