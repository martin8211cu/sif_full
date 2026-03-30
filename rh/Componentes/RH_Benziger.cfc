<cfcomponent>

<!--- ================================================================================ --->
<!--- ================================================================================ --->
<!--- GENERACION DE ARCHIVO DE RESULTADOS SIN CONEXION (NO ES EMPLEADO) 				--->
<!--- ================================================================================ --->
<!--- ================================================================================ --->		
	
	<cffunction name="traerValorPreguntaPersona" returntype="string" access="private">
		<cfargument name="PCUid" required="yes" type="numeric">
		<cfargument name="PCid" required="yes" type="numeric">
		<cfargument name="PPid" required="yes" type="numeric">
		<cfargument name="BUid" required="yes" type="numeric">
		
		<cfquery name="respuesta" datasource="sifcontrol">
			select PCUtexto
			from PortalPreguntaU ppu
			
			inner join PortalCuestionarioU pcu
			on ppu.PCUid=pcu.PCUid
			and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			and pcu.BUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BUid#">
			
			where ppu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			  and ppu.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
			  and ppu.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">	
		</cfquery>
	
		<cfreturn respuesta.PCUtexto >
	</cffunction>
	
	<cffunction name="traerValorRespuestaPersona" returntype="string" access="private">
		<cfargument name="PCUid" required="yes" type="numeric">
		<cfargument name="PCid" required="yes" type="numeric">
		<cfargument name="PPid" required="yes" type="numeric">
		<cfargument name="PRid" required="yes" type="numeric">
		<cfargument name="BUid" required="yes" type="numeric">
		<cfargument name="tipo" required="yes" type="string">	<!--- Para saber si devuelve PRvalorresp o PRid ---> 
		
		<cfquery name="respuesta" datasource="sifcontrol">
			select pru.PRid, pru.PRvalorresp
			from PortalRespuestaU pru
			
			inner join PortalPreguntaU ppu
			on pru.PCUid=ppu.PCUid
			and pru.PCid=ppu.PCid
			and pru.PPid=ppu.PPid
			
			inner join PortalCuestionarioU pcu
			on ppu.PCUid=pcu.PCUid
			and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			and pcu.BUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BUid#">		
			
			where pru.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			  and pru.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
			  and pru.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">
			  and pru.PRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PRid#">
		</cfquery>
	
		<cfif tipo eq 'PRid'>
			<cfreturn respuesta.PRid >
		<cfelse>
			<cfreturn respuesta.PRvalorresp >
		</cfif>
	</cffunction>

	<cffunction name="procesar_persona" access="public" output="true" >
		<cfargument name="PCid" 	required="yes" type="numeric">
		<cfargument name="PCUid" 	required="yes" type="numeric">
		<cfargument name="BUid" 	required="yes" type="numeric">
	
		<!--- datos generales --->
		<cfquery name="data_persona" datasource="sifcontrol">
			select 	BUnombre as nombre, 
					BUapellido1 as apellido1, 
					BUapellido2 as apellido2, 
					BUfecha as fecha, 
					BUcompanyname as empresa, 
					BUidentificacion as identificacion, 
					BUbuAddress as empresa_direccion, 
					BUbuphone as empresa_telefono, 
					BUbuemail as empresa_email, 
					BUphone as telefono, 
					BUaddress as direccion, 
					BUemail as email
			from BenzigerUsuario
			where BUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BUid#">
		</cfquery>
		<cfset resultado = '' >
		<cfset resultado = resultado & 'edFirstName=#data_persona.nombre##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edLastName=#data_persona.apellido1##chr(13)##chr(10)#'>
		<cfset resultado = resultado & 'edCompanyName=#data_persona.empresa##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edBusinessAddress=#data_persona.empresa_direccion##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edBusinessPhone=#data_persona.empresa_telefono##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edBusinessEmail=#data_persona.empresa_email##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'deDate=#LSDateFormat(data_persona.empresa_email, 'yyyymmdd')##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edHomeAddress#data_persona.direccion##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edHomePhone=#data_persona.telefono##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edHomeEmail=#data_persona.email##chr(13)##chr(10)#' >

		<cfquery name="data" datasource="sifcontrol">
			select 	pp.PCid, 
					pp.PPid, 
					pp.PPparte, 
					pp.PPnumero, 
					pp.PPtipo, 
					pp.PPvalor, 
					pp.PPrespuesta
			from PortalPregunta pp
			
			where pp.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
			and pp.PPtipo!='E'
			
			order by pp.PPparte, pp.PPnumero
		</cfquery>

		<cfloop query="data">
			<cfset vPPparte = data.PPparte >
			<cfset vPPnumero = data.PPnumero >
			<cfset vPPid = data.PPid >
			<cfset vPPtipo = data.PPtipo >
		
				<cfquery name="datarespuestas" datasource="sifcontrol">
					select pr.PPid, 
						   pr.PCid,
						   pp.PPparte as parte,
						   pp.PPtipo, 
						   pp.PPrespuesta, 
						   pr.PRid,
						   pr.PRvalor, 
						   pr.PRtexto,
						   pr.PRorden 
					from PortalCuestionario pc
					
					inner join PortalPregunta pp
					on pc.PCid=pp.PCid
			
					left outer join PortalRespuesta pr
					on pp.PPid=pr.PPid
			
					where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PCid#">
					  and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPPid#">
					  and pp.PPtipo != 'E'
					order by pr.PRorden
				</cfquery>
		
				<cfif listcontains('V,O', vPPtipo)>
					<cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
				</cfif>

				<cfif listcontains('U,M', vPPtipo) >
					<cfloop query="datarespuestas">
						<cfset salida = '' >
						<cfset contestada = traerValorRespuestaPersona(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, arguments.BUid, 'PRid') >

						<cfif isdefined("contestada") and len(trim(contestada))>
							<!--- la pregunta 6 de la parte 1, es un radio button pero su formato es de checkbox --->
							<cfif vPPtipo eq 'U' and not (vPPparte eq 1 and vPPnumero eq 6) >
								<cfset salida = 'rbP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=1' >
							<cfelse>
								<cfset salida = 'cbP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=1' >							
							</cfif>
						</cfif>
						<cfif isdefined("salida") and len(trim(salida))>
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>
					</cfloop>
			
				<cfelseif vPPtipo eq 'D'>
						<cfset salida = '' >				
						<cfset contestada = traerValorPreguntaPersona(arguments.PCUid, arguments.PCid, vPPid, arguments.BUid) >
						<cfif isdefined("contestada") and len(trim(contestada))>
							<cfset salida = 'mmP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>

				<cfelseif vPPtipo eq 'V'>
					<cfif datarespuestas.recordcount gt 0 >
						<cfif ArrayLen(valores)>
							<cfloop query="datarespuestas">
								<cfset contestada = traerValorRespuestaPersona(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, arguments.BUid, 'PRvalorresp') >
								<cfif isdefined("contestada") and len(trim(contestada))>
									<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
									<cfset resultado = resultado& salida&chr(13)&chr(10) >
								</cfif>
							</cfloop>
						<cfelse>
							<cfloop query="datarespuestas">
								<cfset contestada = traerValorPreguntaPersona(arguments.PCUid, arguments.PCid, vPPid, arguments.BUid ) >
								<cfif isdefined("contestada") and len(trim(contestada))>
									<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
									<cfset resultado = resultado& salida&chr(13)&chr(10) >
								</cfif>
							</cfloop>
						</cfif>
					<cfelse>
						<cfset contestada = traerValorPreguntaPersona(arguments.PCUid, arguments.PCid, vPPid, arguments.BUid ) >
						<cfif isdefined("contestada") and len(trim(contestada))>
							<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>
					</cfif>

				<cfelseif vPPtipo eq 'O'>
					<cfloop query="datarespuestas">
						<cfset contestada = traerValorRespuestaPersona(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, arguments.BUid, 'PRvalorresp') >
						<cfif isdefined("contestada") and len(trim(contestada))>
							<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>
					</cfloop>
				</cfif>
		</cfloop>
		
		<!--- ============================================================================================= --->
		<!--- Nombre para archivos .dat y .zip  --->
		<!--- ============================================================================================= --->		
		<cfset archivo = replace(data_persona.identificacion, '|', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '/', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, ':', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '*', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '?', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '"', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '>', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '<', '', 'all') >

		<!--- ============================================================================================= --->
		<!--- Generacion de Archivo DAT --->
		<!--- ============================================================================================= --->		
		<cfset fullpath = "#expandpath('/rh/evaluaciondes/benziger/resultados/#archivo#')#" >
		<cfset zipfile = "#expandpath('/rh/evaluaciondes/benziger/resultados/#archivo#/#archivo#.zip')#" >
		<cfset datafile = "#expandpath('/rh/evaluaciondes/benziger/resultados/#archivo#/#archivo#.dat')#" >

		<!---<cfset fullpath = fullpath & '\#archivo#' >--->
		<cfif Not DirectoryExists(fullpath)><cfdirectory action="create" directory="#fullpath#"></cfif>
		<cffile action="write" nameconflict="overwrite" file="#datafile#" output="#resultado#" charset="utf-8">
		
		<!--- ============================================================================================= --->
		<!--- Generacion de Archivo ZIP --->
		<!--- ============================================================================================= --->		
		<cfinvoke component="asp.parches.comp.jar" method="jar"
			fullpath="#fullpath#"
			zipfile="#zipfile#" />

		<!--- Borra archivo --->
		<cffile action="delete" file="#datafile#" >
		<cfheader name="Content-Disposition"	value="attachment;filename=#archivo#.zip">
		<cfcontent file="#zipfile#" type="application/x-zip-compressed" deletefile="yes" >
		<!--- Borra directorio--->
		<cfif DirectoryExists(fullpath)><cfdirectory action="delete" directory="#fullpath#"></cfif>
		
	</cffunction>
<!--- ================================================================================ --->
<!--- ================================================================================ --->		


<!--- ================================================================================ --->
<!--- ================================================================================ --->
<!--- GENERACION DE ARCHIVO DE RESULTADOS SI ES EMPLEADO 							   --->
<!--- ================================================================================ --->
<!--- ================================================================================ --->		
<!---
	<cffunction name="traerValorPregunta">
		<cfargument name="PCUid" required="yes" type="numeric">
		<cfargument name="PCid" required="yes" type="numeric">
		<cfargument name="PPid" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="yes" type="numeric">
		<cfargument name="Usucodigoeval" required="yes" type="numeric">
		
		<cfquery name="respuesta" datasource="#session.DSN#">
			select PCUtexto
			from PortalPreguntaU ppu
			
			inner join PortalCuestionarioU pcu
			on ppu.PCUid=pcu.PCUid
			and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			and pcu.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
			and pcu.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigoeval#">
			
			where ppu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			  and ppu.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
			  and ppu.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">	
		</cfquery>
	
		<cfreturn respuesta.PCUtexto >
	</cffunction>
	
	<cffunction name="traerValorRespuesta">
		<cfargument name="PCUid" required="yes" type="numeric">
		<cfargument name="PCid" required="yes" type="numeric">
		<cfargument name="PPid" required="yes" type="numeric">
		<cfargument name="PRid" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="yes" type="numeric">
		<cfargument name="Usucodigoeval" required="yes" type="numeric">
		<cfargument name="tipo" required="yes" type="string">	<!--- Para saber si devuelve PRvalorresp o PRid ---> 
		
		<cfquery name="respuesta" datasource="#session.DSN#">
			select pru.PRid, pru.PRUvalorresp
			from PortalRespuestaU pru
			
			inner join PortalPreguntaU ppu
			on pru.PCUid=ppu.PCUid
			and pru.PCid=ppu.PCid
			and pru.PPid=ppu.PPid
			
			inner join PortalCuestionarioU pcu
			on ppu.PCUid=pcu.PCUid
			and pcu.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			and pcu.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigo#">
			and pcu.Usucodigoeval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Usucodigoeval#">
			
			where pru.PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCUid#">
			  and pru.PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
			  and pru.PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PPid#">
			  and pru.PRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PRid#">
		</cfquery>
	
		<cfif tipo eq 'PRid'>
			<cfreturn respuesta.PRid >
		<cfelse>
			<cfreturn respuesta.PRUvalorresp >
		</cfif>
	</cffunction>

	<cffunction name="procesar_persona" access="public" output="true" >
		<cfargument name="DSN" 			required="yes" type="string">
		<cfargument name="Ecodigo"	required="yes" type="string">
		<cfargument name="EcodigoSDC"	required="yes" type="string">
		<cfargument name="PCid" 		required="yes" type="numeric">
		<cfargument name="PCUid" 		required="yes" type="numeric">
		<cfargument name="DEid" 		required="yes" type="numeric">
	
		<!--- Datos de usuario --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset form.DEideval = arguments.DEid >
		<cfset rsevaluando = sec.getUsuarioByRef(arguments.DEid, arguments.EcodigoSDC, 'DatosEmpleado')>
		<cfset LvarUsucodigo     = rsevaluando.Usucodigo >
		<cfset LvarUsucodigoeval = LvarUsucodigo >
		
		<!--- datos generales --->
		<cfquery name="data_persona" datasource="#arguments.dsn#">
			, DEnombre, DEapellido1, DEapellido2, DEdireccion, DEtelefono1, DEtelefono2, DEemail, DEfechanac
			select 	DEnombre as nombre, 
					DEapellido1 as apellido1, 
					DEapellido2 as apellido2, 
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as fecha, 
					BUcompanyname as empresa, 
					DEidentificacion as identificacion, 
					BUbuAddress as empresa_direccion, 
					BUbuphone as empresa_telefono, 
					BUbuemail as empresa_email, 
					coalesce(DEtelefono1, DEtelefono2) as telefono, 
					DEdireccion as direccion, 
					DEemail as email
			from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
		</cfquery>


		<cfset resultado = '' >
		<cfset resultado = resultado & 'edFirstName=#data_persona.nombre##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edLastName=#data_persona.apellido1##chr(13)##chr(10)#'>
		<cfset resultado = resultado & 'edCompanyName=#data_persona.empresa##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edBusinessAddress=#data_persona.empresa_direccion##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edBusinessPhone=#data_persona.empresa_telefono##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edBusinessEmail=#data_persona.empresa_email##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'deDate=#LSDateFormat(data_persona.empresa_email, 'yyyymmdd')##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edHomeAddress#data_persona.direccion##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edHomePhone=#data_persona.telefono##chr(13)##chr(10)#' >
		<cfset resultado = resultado & 'edHomeEmail=#data_persona.email##chr(13)##chr(10)#' >

		<cfquery name="data" datasource="sifcontrol">
			select 	pp.PCid, 
					pp.PPid, 
					pp.PPparte, 
					pp.PPnumero, 
					pp.PPtipo, 
					pp.PPvalor, 
					pp.PPrespuesta
			from PortalPregunta pp
			
			where pp.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PCid#">
			and pp.PPtipo!='E'
			
			order by pp.PPparte, pp.PPnumero
		</cfquery>

		<cfloop query="data">
			<cfset vPPparte = data.PPparte >
			<cfset vPPnumero = data.PPnumero >
			<cfset vPPid = data.PPid >
			<cfset vPPtipo = data.PPtipo >
		
				<cfquery name="datarespuestas" datasource="sifcontrol">
					select pr.PPid, 
						   pr.PCid,
						   pp.PPparte as parte,
						   pp.PPtipo, 
						   pp.PPrespuesta, 
						   pr.PRid,
						   pr.PRvalor, 
						   pr.PRtexto,
						   pr.PRorden 
					from PortalCuestionario pc
					
					inner join PortalPregunta pp
					on pc.PCid=pp.PCid
			
					left outer join PortalRespuesta pr
					on pp.PPid=pr.PPid
			
					where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PCid#">
					  and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPPid#">
					  and pp.PPtipo != 'E'
					order by pr.PRorden
				</cfquery>
		
				<cfif listcontains('V,O', vPPtipo)>
					<cfset valores = listtoarray(listsort(data.PPrespuesta,'text')) >
				</cfif>

				<cfif listcontains('U,M', vPPtipo) >
					<cfloop query="datarespuestas">
						<cfset salida = '' >
						<cfset contestada = traerValorRespuestaPersona(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, arguments.BUid, 'PRid') >
						<!---<cfset contestada = traerValorRespuesta(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, LvarUsucodigo, LvarUsucodigoeval, 'PRid') >--->

						<cfif isdefined("contestada") and len(trim(contestada))>
							<!--- la pregunta 6 de la parte 1, es un radio button pero su formato es de checkbox --->
							<cfif vPPtipo eq 'U' and not (vPPparte eq 1 and vPPnumero eq 6) >
								<cfset salida = 'rbP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=1' >
							<cfelse>
								<cfset salida = 'cbP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=1' >							
							</cfif>
						</cfif>
						<cfif isdefined("salida") and len(trim(salida))>
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>
					</cfloop>
			
				<cfelseif vPPtipo eq 'D'>
						<cfset salida = '' >				
						<cfset contestada = traerValorPreguntaPersona(arguments.PCUid, arguments.PCid, vPPid, arguments.BUid) >
						<cfif isdefined("contestada") and len(trim(contestada))>
							<cfset salida = 'mmP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>

				<cfelseif vPPtipo eq 'V'>
					<cfif datarespuestas.recordcount gt 0 >
						<cfif ArrayLen(valores)>
							<cfloop query="datarespuestas">
								<cfset contestada = traerValorRespuestaPersona(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, arguments.BUid, 'PRvalorresp') >
								<cfif isdefined("contestada") and len(trim(contestada))>
									<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
									<cfset resultado = resultado& salida&chr(13)&chr(10) >
								</cfif>
							</cfloop>
						<cfelse>
							<cfloop query="datarespuestas">
								<cfset contestada = traerValorPreguntaPersona(arguments.PCUid, arguments.PCid, vPPid, arguments.BUid ) >
								<cfif isdefined("contestada") and len(trim(contestada))>
									<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
									<cfset resultado = resultado& salida&chr(13)&chr(10) >
								</cfif>
							</cfloop>
						</cfif>
					<cfelse>
						<cfset contestada = traerValorPreguntaPersona(arguments.PCUid, arguments.PCid, vPPid, arguments.BUid ) >
						<cfif isdefined("contestada") and len(trim(contestada))>
							<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>
					</cfif>

				<cfelseif vPPtipo eq 'O'>
					<cfloop query="datarespuestas">
						<cfset contestada = traerValorRespuestaPersona(arguments.PCUid, arguments.PCid, vPPid, datarespuestas.PRid, arguments.BUid, 'PRvalorresp') >
						<cfif isdefined("contestada") and len(trim(contestada))>
							<cfset salida = 'edP#vPPparte#_Q#vPPnumero#_A#datarespuestas.currentrow-1#=#contestada#' >
							<cfset resultado = resultado& salida&chr(13)&chr(10) >
						</cfif>
					</cfloop>
				</cfif>
		</cfloop>
		
		<!--- ============================================================================================= --->
		<!--- Nombre para archivos .dat y .zip  --->
		<!--- ============================================================================================= --->		
		<cfset archivo = replace(data_persona.identificacion, '|', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '/', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, ':', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '*', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '?', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '"', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '>', '', 'all') >
		<cfset archivo = replace(data_persona.identificacion, '<', '', 'all') >

		<!--- ============================================================================================= --->
		<!--- Generacion de Archivo DAT --->
		<!--- ============================================================================================= --->		
		<cfset fullpath = "#expandpath('/rh/evaluaciondes/benziger/resultados/#archivo#')#" >
		<cfset zipfile = "#expandpath('/rh/evaluaciondes/benziger/resultados/#archivo#/#archivo#.zip')#" >
		<cfset datafile = "#expandpath('/rh/evaluaciondes/benziger/resultados/#archivo#/#archivo#.dat')#" >

		<!---<cfset fullpath = fullpath & '\#archivo#' >--->
		<cfif Not DirectoryExists(fullpath)><cfdirectory action="create" directory="#fullpath#"></cfif>
		<cffile action="write" nameconflict="overwrite" file="#datafile#" output="#resultado#" charset="utf-8">
		
		<!--- ============================================================================================= --->
		<!--- Generacion de Archivo ZIP --->
		<!--- ============================================================================================= --->		
		<cfinvoke component="asp.parches.comp.jar" method="jar"
			fullpath="#fullpath#"
			zipfile="#zipfile#" />

		<!--- Borra archivo --->
		<cffile action="delete" file="#fullpath#\#archivo#.dat" >
		<cfheader name="Content-Disposition"	value="attachment;filename=#archivo#.zip">
		<cfcontent file="#zipfile#" type="application/x-zip-compressed" deletefile="yes" >
		<!--- Borra directorio--->
		<cfif DirectoryExists(fullpath)><cfdirectory action="delete" directory="#fullpath#"></cfif>
		
	</cffunction>
--->

	
</cfcomponent>