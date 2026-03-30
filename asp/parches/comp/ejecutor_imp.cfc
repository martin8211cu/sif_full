<cfcomponent extends="ejecutor">
	
	<cffunction name="ejecuta" hint="Ejecuta un archivo SQL">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="ruta" type="string" required="yes">
		<!--- <cfargument name="datasource" type="string"> --->
		
		<cfset This.inicio(num_tarea, 'Archivo: ' & Arguments.ruta & ', datasource: ' & Arguments.datasource)>
		
		<cfinvoke component="parche" method="dirparches" returnvariable="dirparches"/>
		<cfinvoke component="path" method="concat" dir="#dirparches#" file="#session.instala.nombre#" returnvariable="dirparches"/>
		<cfinvoke component="path" method="concat" dir="#dirparches#" file="importador" returnvariable="dirparches"/>
		<cfinvoke component="path" method="concat" dir="#dirparches#" file="importador.xml" returnvariable="fullpath"/>
		
		<cfif Not FileExists (fullpath)>
			<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
				'Archivo no existe, ignorando tarea: ' & fullpath)>
		<cfelse>
			<cftry>
				<cfset form.included = 1>
				<cffile action="read" file="#fullpath#" variable="filecontents">
				<cfinclude template="/sif/importar/Importar2.cfm">
				<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.DEBUG,
					'Importando definiciones de: ' & ValueList(session.importar_enc.EIcodigo) )>
				<cfset form.eiid=ValueList(session.importar_enc.eiid)>
				<cfinclude template="/sif/importar/Importar3.cfm">
			<cfcatch type="any">
					<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
						'Error en importación: ' & cfcatch.Message & ' ' & cfcatch.Detail)>
				</cfcatch>
			</cftry>
		</cfif>
		<cfset This.fin(num_tarea)>
		
	</cffunction>
</cfcomponent>
