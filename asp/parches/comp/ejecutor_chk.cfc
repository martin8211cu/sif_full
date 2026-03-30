<cfcomponent extends="ejecutor" hint=" Validar checksum de archivos copiados">
	
	<cffunction name="ejecuta" hint="Ejecuta un archivo SQL"  output="false">
		<cfargument name="num_tarea" type="numeric" required="yes">

		<cfset This.inicio(num_tarea, 'Inicio')>

		<cfset archivos = XmlSearch(get_xml(), '//archivo_fuente')>
		<cfloop from="1" to="#ArrayLen(archivos)#" index="i">
			<cfset arc = archivos[i].XmlAttributes>
			<cftry>
				<cfif FileExists ( ExpandPath('/' & arc.nombre ) )>
					<cffile action="readbinary" file="#ExpandPath('/' & arc.nombre )#" variable="contents">
					<cfinvoke component="asp.parches.comp.parche" method="calc_hash_binary"
						filecontents="#contents#" algorithm="MD5" returnvariable="md5"/>
					<cfinvoke component="asp.parches.comp.parche" method="calc_hash_binary"
						filecontents="#contents#" algorithm="SHA1" returnvariable="sha1"/>
					<cfset csum = 'MD5:#md5#;SHA1:#sha1#'>
					<!--- Me trago una comilla, si viene, porque en los primeros parches venía, al inicio, por error --->
					<cfset esperado = Replace(arc.checksum, "'", "")>
					<cfif csum eq esperado>
						<cfset This.logmsg(Arguments.num_tarea, arc.nombre, This.DEBUG,
							'Checksum ok')>
					<cfelse>
						<cfset This.logmsg(Arguments.num_tarea, arc.nombre, This.WARN,
							'Checksum inválido. Esperado: # Replace( esperado, ';', '; ') #, difiere del obtenido: # Replace( csum, ';', '; ' )#')>
					</cfif>
				<cfelse>
					<cfset This.logmsg(Arguments.num_tarea, arc.nombre, This.WARN,
						'Archivo no existe')>
				</cfif>
			<cfcatch type="any">
				<cfset This.logmsg(Arguments.num_tarea, arc.nombre, This.WARN,
					cfcatch.Message & ' ' & cfcatch.Detail)>
			</cfcatch>
			</cftry>
		</cfloop>
		
		<!--- permitir trabajo del gc --->
		<cfset archivos = ''>
		
		<cfset This.fin(num_tarea)>
	</cffunction>

</cfcomponent>
