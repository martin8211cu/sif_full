<cfcomponent extends="ejecutor">
	
	<cffunction name="ejecuta" hint="Ejecuta un archivo SQL">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="ruta" type="string" required="yes">
		<!--- <cfargument name="datasource" type="string"> --->
		
		<cfset This.inicio(num_tarea, 'Archivo: ' & Arguments.ruta & ', datasource: ' & Arguments.datasource)>
		
		<cfinvoke component="parche" method="dirparches" returnvariable="src_dir"/>
		<cfinvoke component="path" method="concat" dir="#src_dir#" file="#session.instala.nombre#" returnvariable="src_dir"/>
		<cfinvoke component="path" method="concat" dir="#src_dir#" file="fuentes" returnvariable="src_dir"/>
		<cfinvoke component="path" method="concat" dir="#src_dir#" file="#Arguments.ruta#" returnvariable="src_dir"/>
		<cfset dst_dir = ExpandPath('/' & Arguments.ruta)>
		
		<cfif Not DirectoryExists (src_dir)>
			<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
				'Directorio origen no existe, no se realiza la copia: ' & src_dir)>
		<cfelse>
			<cfset file_separator = CreateObject("java", "java.lang.System").getProperty('file.separator')>
			<cftry>
				<cfif Not DirectoryExists(dst_dir)>
					<cfdirectory action="create" directory="#dst_dir#">
				</cfif>
				<cfdirectory action="list" name="listing" sort="asc" directory="#src_dir#" recurse="yes">
				<cfoutput query="listing" group="Directory">
					<cfset path = Mid(Directory, Len(src_dir)+2, Len(Directory))>
					<cfset Directory2 = dst_dir & file_separator & path>
					<cfif Not DirectoryExists (Directory2)>
						<cfdirectory action="create" directory="#Directory2#">
					</cfif>
					<cfoutput>
						<cfif Type Is 'File'>
							<cftry>
								<cffile action="copy" source="#Directory & file_separator & Name#" destination="#Directory2 & file_separator & Name#" mode="644">
							<cfcatch type="any">
								<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
									'Error en importación: ' & cfcatch.Message & ' ' & cfcatch.Detail)>
							</cfcatch>
							</cftry>

						</cfif>
					</cfoutput>
				</cfoutput>
			<cfcatch type="any">
				<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
					'Error en importación: ' & cfcatch.Message & ' ' & cfcatch.Detail)>
			</cfcatch>
			</cftry>
		</cfif>
		<cfset This.fin(num_tarea)>
		
	</cffunction>
	
</cfcomponent>
