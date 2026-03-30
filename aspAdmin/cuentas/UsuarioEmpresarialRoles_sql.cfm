<cfset action = "/cfmx/aspAdmin/cuentas/UsuarioEmpresarialRoles_conlis.cfm">

<cfset errorAltaRol = "">
<cfset errorRol = false>

<!--- Este ciclo est[a afuera de la transacci[on porque puede realizar consultas con Conexion cache distinto
al utilizaco dentro de la transacci[on, y por lo cual no se permiten consultas en una transaccion a varias
bases de datos. Todo para consultar el n[umero de referencia del empleado seleccionado  --->
<cfif isdefined("form.btnAgregar") and isdefined("form.chk")>
	<cfoutput>
		<cfset ArrayRolesConRef = ArrayNew(1)>
		<cfloop index="dato" list="#form.chk#">
			<cfset myArrayTemporal = ListToArray(#dato#,'|')>
			
			<cfset myArrayDatos = ListToArray(#myArrayTemporal[1]#,'~')>
				<cfif myArrayDatos[5] NEQ '0'>
					<cfset codEmpresa = myArrayDatos[2]>
					<cfset codSistema = myArrayDatos[3]>
					<cfset myArrayDatos[6] = getReferencia(codEmpresa,codSistema,form.identifEmpleado,myArrayDatos[4])>
					<cfset ArrayRolesConRef[ArrayLen(ArrayRolesConRef) + 1] = myArrayDatos>
				</cfif>
		</cfloop>
	</cfoutput>
</cfif>

<cfset modo="CAMBIO">
	<cftransaction>
		<cftry> 
			<cfoutput>
				<cfif isdefined("Form.btnBorrarRol") and form.btnBorrarRol NEQ '0' and isdefined('form.IdRolBorrar') and form.IdRolBorrar NEQ ''>
					<cfquery name="Q_Empresa" datasource="#session.DSN#">
							Select Ecodigo
							from UsuarioPermiso
							where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdRolBorrar#">
					</cfquery>
					
					<cfif isdefined('Q_Empresa') and Q_Empresa.recordCount GT 0>
						<cfquery name="Q_PermEmpresa" datasource="#session.DSN#">
							select count(*) as cantPerm
							from UsuarioPermiso
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Q_Empresa.Ecodigo#">
								and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
								and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
								and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">																																			
						</cfquery>

						<cfif isdefined('Q_PermEmpresa') and Q_PermEmpresa.recordCount GT 0>
							<cfquery name="quitar_Permisos" datasource="#session.DSN#">
								set nocount on
									update UsuarioPermiso
									set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
										BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
										BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
										BMfechamod = getDate()
									where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdRolBorrar#">								
								
									delete UsuarioPermiso
									where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IdRolBorrar#">
								set nocount off
							</cfquery>																							
							<cfif Q_PermEmpresa.cantPerm EQ 1 and not isdefined('form.newAction')>	<!--- Borra la EmpresaUsuario porque ya no tiene mas permisos para esa empresa --->
								<cfquery name="quitar_Empresa" datasource="#session.DSN#">
									set nocount on
										update UsuarioEmpresa
										set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
											BMUlocalizacion = <cfqueryparam cfsqltype="cf_sql_char"    value="#session.Ulocalizacion#">,
											BMUsulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
											BMfechamod = getDate()
										where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Q_Empresa.Ecodigo#">
											and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
											and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
											and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
									
										delete UsuarioEmpresa
										where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Q_Empresa.Ecodigo#">
											and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
											and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
											and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
									set nocount off
								</cfquery>
							</cfif>
						</cfif>
					</cfif>	
					
					<cfset action = "/cfmx/aspAdmin/cuentas/CuentaPrincipal_tabs.cfm">	
				<cfelseif  isdefined("form.btnAgregar") and isdefined("form.chk")>
					<cfoutput>
						<cfloop index="dato" list="#form.chk#">
							<cfset myArrayTemp = ListToArray(#dato#,'|')>
							<cfset myArray = ListToArray(#myArrayTemp[1]#,'~')>
							<cfif ArrayLen(myArray) GT 0>
								<cfset codEmpresa = myArray[2]>
								
								<cfquery name="ExisteEmpresa" datasource="#session.DSN#">
									Select count(*) as existe
									from UsuarioEmpresa
									where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
									  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
									  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">											
									  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">											  																				
								</cfquery>
								
								<cfif isdefined('ExisteEmpresa') and ExisteEmpresa.recordCount GT 0 and ExisteEmpresa.existe GT 0>
									<cfif myArray[5] NEQ '0'>	<!--- Calculamos el numero de referencia del empleado para la empresa --->
										<cfset valNumReferencia = getValorRef(myArray)>

										<cfif valNumReferencia NEQ -1>	<!--- El usuaro no se encuentra registrado como empleado de la empresa --->
											<cfquery name="AltaPermiso" datasource="#session.DSN#">
												set nocount on
													insert into UsuarioPermiso (Usucodigo, Ulocalizacion, cliente_empresarial,
													  Ecodigo, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin,BMfechamod,
													  int_referencia,num_referencia)
													values (
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArray[1]#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
														getDate(),
														<cfif myArray[5] EQ 'N'>
															0,
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#valNumReferencia#">
														<cfelseif myArray[5] EQ 'I'>												
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#valNumReferencia#">,																													
															0
														</cfif>
														)
												set nocount on										
											</cfquery>
										</cfif>
									<cfelse>
										<cfquery name="AltaPermiso" datasource="#session.DSN#">
											set nocount on
												insert into UsuarioPermiso (Usucodigo, Ulocalizacion, cliente_empresarial,
												  Ecodigo, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin,BMfechamod,
												  int_referencia,num_referencia)
												values (
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArray[1]#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
													getDate(),
													0,
													0
												)
											set nocount on										
										</cfquery>																													
									</cfif>
								<cfelse>
									<cfif myArray[5] NEQ '0'>	<!--- Calculamos el numero de referencia del empleado para la empresa --->
										<cfset valNumReferencia = getValorRef(myArray)>
	
										<cfif valNumReferencia NEQ -1>	<!--- El usuaro no se encuentra registrado como empleado de la empresa --->
											<cfquery name="AltaEmpresa" datasource="#session.DSN#">
												set nocount on
												  insert UsuarioEmpresa (Usucodigo,Ulocalizacion, cliente_empresarial, Ecodigo,
													BMUsucodigo, BMUlocalizacion, BMUsulogin)
												  values (
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)								
												set nocount on										
											</cfquery>	
																				
											<cfquery name="AltaPermiso" datasource="#session.DSN#">
												set nocount on
													insert into UsuarioPermiso (Usucodigo, Ulocalizacion, cliente_empresarial,
													  Ecodigo, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin,BMfechamod,
													  int_referencia,num_referencia)
													values (
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArray[1]#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
														<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
														getDate(),
														<cfif myArray[5] EQ 'N'>
															0,
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#valNumReferencia#">
														<cfelseif myArray[5] EQ 'I'>												
															<cfqueryparam cfsqltype="cf_sql_numeric" value="#valNumReferencia#">,
															0
														</cfif>
														)
												set nocount on										
											</cfquery>
										</cfif>
									<cfelse>
										<cfquery name="AltaEmpresa" datasource="#session.DSN#">
											set nocount on
											  insert UsuarioEmpresa (Usucodigo,Ulocalizacion, cliente_empresarial, Ecodigo,
												BMUsucodigo, BMUlocalizacion, BMUsulogin)
											  values (
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">)								
											set nocount on										
										</cfquery>
																		
										<cfquery name="AltaPermiso" datasource="#session.DSN#">
											set nocount on
												insert into UsuarioPermiso (Usucodigo, Ulocalizacion, cliente_empresarial,
												  Ecodigo, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin,BMfechamod,
												  int_referencia,num_referencia)
												values (
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#codEmpresa#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArray[1]#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
													getDate(),
													0,
													0
												)
											set nocount on										
										</cfquery>																													
									</cfif>
								</cfif>							
							</cfif>
						</cfloop>
					</cfoutput>
					
				</cfif>
			</cfoutput>	
 		<cfcatch type="any">
			<cftransaction action="rollback"/>
			<cfinclude template="../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>	

	<cfif errorRol>
		<script language="JavaScript" type="text/javascript">
			alert('<cfoutput>#errorAltaRol#</cfoutput>')
		</script>
	</cfif>

	<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql"> 
		<input name="bandera" type="hidden" value="1">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">				
		<input name="ppInactivo" type="hidden" value="<cfif isdefined("form.ppInactivo")><cfoutput>#form.ppInactivo#</cfoutput></cfif>">					
		<input name="ppTipo" type="hidden" value="<cfif isdefined("form.ppTipo")><cfoutput>#form.ppTipo#</cfoutput></cfif>">							
		<input name="ecodigo2" type="hidden" value="<cfif isdefined("form.ecodigo2")><cfoutput>#form.ecodigo2#</cfoutput></cfif>">									
		<input name="Usucodigo" type="hidden" value="<cfif isdefined("form.Usucodigo")><cfoutput>#form.Usucodigo#</cfoutput></cfif>">							
		<cfif isdefined('form.Nombre') and form.Nombre NEQ ''>
			<input name="Nombre" type="hidden" value="<cfoutput>#form.Nombre#</cfoutput>">											
		</cfif>
		<input name="Ulocalizacion" type="hidden" value="<cfif isdefined("form.Ulocalizacion")><cfoutput>#form.Ulocalizacion#</cfoutput></cfif>">					
		<input name="cliente_empresarial" type="hidden" value="<cfif isdefined("form.cliente_empresarial")><cfoutput>#form.cliente_empresarial#</cfoutput></cfif>">							
	</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


 <!--- Obtiene el numero de referencia del empleado --->
<cffunction name="getReferencia" returntype="numeric">
	<cfargument name="empresa" type="numeric" required="true"> 
	<cfargument name="sistema" type="string" required="true"> 
	<cfargument name="identifEmpleado" type="string" required="false">
	<cfargument name="nombreEmpresa" type="string" required="true">	
	<cfset varRet = -1>
	<cfset txtError = "">
	
	<cfif Len(trim(identifEmpleado)) GT 0>
		<cfquery name="rs" datasource="#session.DSN#">
			select rol,query_referencia
			from Rol
			where referencia in ('N','I')
				and rol=<cfqueryparam cfsqltype="cf_sql_char" value="rh.usuario">
		</cfquery>
	
		<cfif isdefined('rs') and rs.recordCount GT 0>
			<cfset varSQL = "">
			<cfquery name="rsEmpresaID" datasource="#session.DSN#">
				Select consecutivo,nombre_cache
				from EmpresaID
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#empresa#">
					and sistema=<cfqueryparam cfsqltype="cf_sql_char" value="#sistema#">
			</cfquery>	
	
			<cfif isdefined('rsEmpresaID') and rsEmpresaID.recordCount GT 0>
				<cfset errorQueryEmpleado = false>			
				<cfset varSQL = Replace(rs.query_referencia, "~empresa~", "#rsEmpresaID.consecutivo#", "one")>
				<cfset varSQL = Replace(varSQL, "~identif~", "'#identifEmpleado#'", "one")>

				<cfif Len(trim(rsEmpresaID.nombre_cache)) NEQ 0>
					<cftry>
							<cfquery name="rsEmpleado" datasource="#trim(rsEmpresaID.nombre_cache)#">
								#PreserveSingleQuotes(varSQL)#
							</cfquery>
						<cfcatch type="any">
							<cfset errorQueryEmpleado = true>
							<cfset txtError = cfcatch.Message>							
						</cfcatch>					
					</cftry>
				</cfif>

				<cfif errorQueryEmpleado EQ false>
					<cfif isdefined('rsEmpleado') and rsEmpleado.recordCount GT 0>
						<cfset varRet = rsEmpleado.DEid>
					<cfelse>
						<cfset errorRol = true>
						<cfset errorAltaRol = errorAltaRol & "El usuario actualmente seleccionado no se encuentra registrado como empleado para la empresa " & nombreEmpresa & "\n">
					</cfif>			
				</cfif>
			</cfif>	
		</cfif>
	<cfelse>
		<cfset errorRol = true>
		<cfset errorAltaRol = errorAltaRol & "El usuario actualmente seleccionado  no posee número de identificación \n">	
	</cfif>

	<cfreturn #varRet#>
</cffunction>

 <!--- Obtiene el numero de referencia del empleado --->
<cffunction name="getValorRef" returntype="numeric">
	<cfargument name="ArrayRol" type="array" required="true"> 

	<cfset valReferencia = -1>
	
	<cfif isdefined('ArrayRolesConRef') and ArrayLen(ArrayRolesConRef) GT 0>
		<cfloop index="valIndex" from="1" to="#ArrayLen(ArrayRolesConRef)#">
			<cfif ArrayRolesConRef[valIndex][1] EQ ArrayRol[1] 
				and ArrayRolesConRef[valIndex][2] EQ ArrayRol[2] 
				and ArrayRolesConRef[valIndex][3] EQ ArrayRol[3]
				and ArrayRolesConRef[valIndex][6] NEQ '*'>
					<cfset valReferencia = ArrayRolesConRef[valIndex][6]>
					<cfbreak> 
			</cfif>
		</cfloop>
	</cfif>

	<cfreturn #valReferencia#>
</cffunction>