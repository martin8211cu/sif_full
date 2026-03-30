<cfcomponent extends="ejecutor">
	<!--- el buffer no puede ser local, porque el paso de string muy grandes es costoso --->
	<cfset This.buffer = ''>

	<cffunction name="ejecuta_sql">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="datasource" type="string">
		<cfargument name="ruta" type="string" required="yes">
		<cfargument name="lineFrom" type="numeric" required="yes">
		<cfargument name="lineTo" type="numeric" required="yes">
		
			<cfset thesql = This.buffer.toString()>
			<cfif Len(Trim(thesql))>
				<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.DEBUG,
					'Query en líneas ' & Arguments.lineFrom & '-' & Arguments.LineTo, thesql)>
				<cftry>
					<cfquery datasource="#Arguments.datasource#">
						# PreserveSingleQuotes( thesql )#
					</cfquery>
				<cfcatch type="any">
					<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
						cfcatch.Message,
						'Error en query de líneas ' & Arguments.lineFrom & '-' & Arguments.LineTo & ' (datasource ' 
							& Arguments.datasource & '): ' & cfcatch.Message & ' ' & cfcatch.Detail & Chr(13)
							& 'SQL Query:' & Chr(13) & thesql)>
				</cfcatch>
				</cftry>
			</cfif>
	</cffunction>

	<cffunction name="ejecuta" hint="Ejecuta un archivo SQL">
		<cfargument name="num_tarea" type="numeric" required="yes">
		<cfargument name="ruta" type="string" required="yes">
		<cfargument name="datasource" type="string">
		
		<cfset This.buffer = CreateObject("java", "java.lang.StringBuffer").init() >
		
		<cfset This.inicio(num_tarea, 'Archivo: ' & Arguments.ruta & ', datasource: ' & Arguments.datasource)>
		
		<cfinvoke component="parche" method="dirparches" returnvariable="dirparches"/>
		<cfinvoke component="misc" method="dbms2dbmsdir" dbms="#session.instala.dbms#" returnvariable="dbmsdir"/>
		<cfinvoke component="path" method="concat" dir="#dirparches#" file="#session.instala.nombre#" returnvariable="dirparches"/>
		<cfinvoke component="path" method="concat" dir="#dirparches#" file="#dbmsdir#" returnvariable="dirparches"/>
		<cfinvoke component="path" method="concat" dir="#dirparches#" file="#ruta#" returnvariable="fullpath"/>
		
		<cfif Not FileExists(fullpath)>
			<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
				'No existe el archivo ' & fullpath)>
		<cfelse>
			<cfset lineFrom = 1>
			<cfset lineTo = 0>
			<cftry>
				<cfset fileReader = CreateObject("java", "java.io.FileReader").init(fullpath)>
				<cfset fileReader = CreateObject("java", "java.io.LineNumberReader").init(fileReader)>
				<cfloop condition="true">
					<cfset line = fileReader.readLine()>
					<cfif Not IsDefined('line')>
						<cfbreak>
					</cfif>
					<cfif line EQ 'go'>
						<cfset lineTo = fileReader.lineNumber>
						<cfset This.ejecuta_sql(Arguments.num_tarea, Arguments.datasource, Arguments.ruta, lineFrom, lineTo)>
						<cfset lineFrom = lineTo+1>
						<cfset This.buffer = CreateObject("java", "java.lang.StringBuffer").init() >
					<cfelse>
						<cfset This.buffer.append(line).append(Chr(13))>
					</cfif>
				</cfloop>
				<cfcatch type="any">
					<cfoutput>
						<cfset This.logmsg(Arguments.num_tarea, Arguments.ruta, This.WARN,
							cfcatch.Message,
							'Error ejecutando archivo ' & fullpath & ' en datasource ' 
								& Arguments.datasource & ': ' & cfcatch.Message & ' ' & cfcatch.Detail)>
					</cfoutput>
				</cfcatch>
			</cftry>
			<cfset This.ejecuta_sql(Arguments.num_tarea, Arguments.datasource, Arguments.ruta, lineFrom, lineTo)>
			<cfif IsDefined('fileReader')>
				<cfset fileReader.close()>
			</cfif>
		</cfif>
		
		<cfset This.fin(num_tarea)>
		
	</cffunction>
</cfcomponent>
