<cfinvoke Key="MSG_SeleccionArchivo" Default="Debe seleccionar una imagen para guardar" returnvariable="MSG_SeleccionArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfoutput>
	<cfif isdefined("form.Eliminar")>		
		<cfset rootdir = ExpandPath('') >
		<cfset ruta = "#rootdir#/rh/autogestion/Noticias/Imagenes/#form.name#">
		<cfset ruta = replace(ruta,'\','/', 'ALL')>
		<cffile action="delete"	file="#ruta#">
		<cfset parametros = ''>
		<cfif isdefined("form.Noticia") and form.Noticia EQ 1>
			<cfset parametros = '?Noticia=1'>	
			<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia))>
				<cfset parametros = parametros & '&IdNoticia=#form.IdNoticia#' >	
			</cfif> 		
		</cfif>
		<cflocation url="GuardarImagenes.cfm#parametros#">
	<cfelse>
		<cfif isdefined("form.nombre_archivo") and len(trim(form.nombre_archivo))>
			<cftry>
				<!--- Windows acepta slash (/) y backslash(\) como separadores de directorio, 
					  unix solo permite slash(/), por eso usamos unicamente el slash(/) con la 
					  seguridad que los dos SO lo soportan --->
				<cfset error = false >
				<cfset rootdir = ExpandPath('') >
				<cfset ruta = "#rootdir#/rh/autogestion/Noticias/Imagenes">
				<cfset ruta = replace(ruta,'\','/', 'ALL')>
		
				<!--- saca el nombre del archivo --->
				<cfset filename = replace(form.nombre_archivo, '\', '/', 'all') >
				<cfset temp_arreglo = listtoarray(filename, '/') >
				<cfset filename = trim(temp_arreglo[arraylen(temp_arreglo)]) >
				<cfset nombre_arreglo = listtoarray(filename, '.') >
				<!---Define las extensiones aceptadas--->
				<cfset lstExtensiones = ''>
				<cfset lstExtensiones = "JPG,BMP,GIF">
				<cfif  not ListFindNoCase(lstExtensiones, ucase(nombre_arreglo[arraylen(nombre_arreglo)]))>
					<cfset error = true >			
				</cfif>
				
				<cfif not directoryexists(ruta)>
					<cfset error = true >
				</cfif>
		
				<cfif not error >
					<cffile action="upload" destination="#ruta#" nameConflict="overwrite" fileField="form.archivo" >
				</cfif>
				<cfcatch type="any">
					<cfset error = true >
					<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail#">
				</cfcatch>		
			</cftry>	
		<cfelse>
			<cfthrow message="#MSG_SeleccionArchivo#">
		</cfif>
		<cfset parametros = '' >
		<cfif error >
			<cfset parametros = '?error=1' >	
		</cfif>
		<cfif isdefined("form.Noticia") and error>
			<cfset parametros = parametros & '&Noticia=1'>
			<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia))>
				<cfset parametros = parametros & '&IdNoticia=#form.IdNoticia#'>
			</cfif>
		<cfelseif isdefined("form.Noticia") and not error>
			<cfset parametros = parametros & '?Noticia=1'>
			<cfif isdefined("form.IdNoticia") and len(trim(form.IdNoticia))>
				<cfset parametros = parametros & '&IdNoticia=#form.IdNoticia#'>
			</cfif>
		</cfif>
		
		<cflocation url="GuardarImagenes.cfm#parametros#">
	</cfif>
</cfoutput>