
<cfset error = false >
<cfset codigo_error = 1 >
<cfif isdefined("form.btnUpload")>
	<cfoutput>
			<cftry>
				<!--- Windows acepta slash (/) y backslash(\) como separadores de directorio, 
					  unix solo permite slash(/), por eso usamos unicamente el slash(/) con la 
					  seguridad que los dos SO lo soportan --->
				<cfset rootdir = ExpandPath('') >
				<cfset ruta = "#rootdir#/repUsuario/#form.sistema#">
				<cfset ruta = replace(ruta,'\','/', 'ALL')>

				<!--- saca el nombre del archivo --->
				<cfset filename = replace(form.nombre_archivo, '\', '/', 'all') >
				<cfset temp_arreglo = listtoarray(filename, '/') >
				<cfset filename = trim(temp_arreglo[arraylen(temp_arreglo)]) >
				<!--- el archivo debe ser tener la extension .cfr --->
				<cfset nombre_arreglo = listtoarray(filename, '.') >
				<cfif arraylen(nombre_arreglo) gt 0 and ucase(nombre_arreglo[arraylen(nombre_arreglo)]) neq 'CFR' >
					<cfset error = true >
					<cfset codigo_error = 2 >
				</cfif>
				<cfif not directoryexists(ruta)>
					<cfset error = true >
				</cfif>

				<cfif not error >
					<cffile action="upload" destination="#ruta#" nameConflict="overwrite" fileField="form.archivo" >
				</cfif>
			<cfcatch type="any">
				<cflog file="upload_reportes_usuario" text="Upload: #cfcatch.Message# #cfcatch.Detail#">
				<cfset error = true >
				<cfset codigo_error = 1 >
				<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail#">
			</cfcatch>
			</cftry>
			
			<cfif not error >
				<cfquery name="datos" datasource="#session.DSN#">
					select RHRURid as id
					from RHRUReportes
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHRURnombre = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(filename)#">
				</cfquery>
	
				<cfif len(trim(datos.id)) gt 0 >
					<cfquery datasource="#session.DSN#">
						update RHRUReportes
						set RHRURcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo#">,
							RHRURdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">,
							RHRURsistema = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#">, 
							RHRURcategoria = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.categoria#">, 
							RHRURfechaModificacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							RHRURlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usulogin#">
						where RHRURid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos.id#">
					</cfquery>
				<cfelse>	
					<cfquery datasource="#session.DSN#">
						insert into RHRUReportes(	Ecodigo,
													RHRURcodigo, 
													RHRURnombre, 
													RHRURdescripcion, 
													RHRURsistema, 
													RHRURcategoria, 
													RHRURfechaCreacion, 
													RHRURfechaModificacion, 
													RHRURlogin,
													RHRURparametros, 
													BMUsucodigo )
						values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.codigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#filename#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.sistema#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.categoria#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usulogin#">,
								<cfif isdefined("form.RHRURparametros")>1<cfelse>0</cfif>,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
					
					</cfquery>
				</cfif>
			</cfif>
	</cfoutput>
</cfif>

<cfset parametros = '' >
<cfif error >
	<cfset parametros = '?error=1&codigo_error=#codigo_error#' >
<cfelse>
	<cfset parametros = '?ok=1' >
</cfif>
	<cflocation url="upload-reporte.cfm#parametros#">
