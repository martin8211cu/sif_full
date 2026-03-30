<cfset action = "/cfmx/sif/framework/usuarios/usuariosEmpresariales.cfm">
<cfset modo="CAMBIO">

	<cftransaction>
		<cftry>
			<cfoutput>
					<cfif isdefined("Form.btnQuitar")>
						<cfif isdefined('form.totPermisos') and form.totPermisos GT 0>
							<cfloop index = "LoopCount" from = "1" to = "#form.totPermisos#">
									<cfset ckPerm = "form.permiso_#LoopCount#">	
								
									<cfif isdefined(#Evaluate('ckPerm')#)>
										<cfquery name="Q_Empresa" datasource="#session.DSN#">
												Select Ecodigo
												from UsuarioPermiso
												where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('form.permiso_#LoopCount#')#">
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
														delete UsuarioPermiso
														where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('form.permiso_#LoopCount#')#">
													set nocount off
												</cfquery>																							
												<cfif Q_PermEmpresa.cantPerm EQ 1>	<!--- Borra la EmpresaUsuario porque ya no tiene mas permisos para esa empresa --->
													<cfquery name="quitar_Empresa" datasource="#session.DSN#">
														set nocount on
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
									</cfif>
							</cfloop>
						</cfif>
						
					<cfelseif isdefined("Form.btnAgregar")>
						<cfif isdefined('form.nuevoPermiso') and form.nuevoPermiso NEQ ''>
							<cfset myArray = ListToArray(#form.nuevoPermiso#,'~')>
							<cfif ArrayLen(myArray) GT 0>
								<cfquery name="ExisteEmpresa" datasource="#session.DSN#">
										Select count(*) as existe
										from UsuarioEmpresa
										where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
										  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
										  and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">											
										  and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#myArray[2]#">											  																				
								</cfquery>							
								
								<cfif isdefined('ExisteEmpresa') and ExisteEmpresa.recordCount GT 0 and ExisteEmpresa.existe GT 0>
									<cfquery name="AltaPermiso" datasource="#session.DSN#">
										set nocount on
											insert into UsuarioPermiso (Usucodigo, Ulocalizacion, cliente_empresarial,
											  Ecodigo, rol, BMUsucodigo, BMUlocalizacion, BMUsulogin,BMfechamod,
											  int_referencia,num_referencia)
											values (
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#myArray[2]#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArray[1]#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
												getDate(),
												<cfif isdefined('form.referencia') and form.referencia EQ '0'>
													0,
													0
												<cfelseif isdefined('form.referencia') and form.referencia EQ 'N'>
													0,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_int_referencia#">
												<cfelseif isdefined('form.referencia') and form.referencia EQ 'I'>												
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_int_referencia#">,
													0
												</cfif>
												)
										set nocount on										
									</cfquery>								
								<cfelse>
									<cfquery name="AltaEmpresa" datasource="#session.DSN#">
										set nocount on
										  insert UsuarioEmpresa (Usucodigo,Ulocalizacion, cliente_empresarial, Ecodigo,
											BMUsucodigo, BMUlocalizacion, BMUsulogin)
										  values (
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#myArray[2]#">,
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
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#myArray[2]#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#myArray[1]#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
												getDate(),
												<cfif isdefined('form.referencia') and form.referencia EQ '0'>
													0,
													0
												<cfelseif isdefined('form.referencia') and form.referencia EQ 'N'>
													0,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_int_referencia#">
												<cfelseif isdefined('form.referencia') and form.referencia EQ 'I'>												
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.num_int_referencia#">,
													0
												</cfif>												
												)
										set nocount on										
									</cfquery>																				
								</cfif>
							</cfif>
						</cfif>
					</cfif>
			</cfoutput>	
		<cfcatch type="any">
			<cfinclude template="/aspAdmin/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cftransaction>	

	

	<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<input name="Usucodigo" type="hidden" value="<cfif isdefined("form.Usucodigo")><cfoutput>#form.Usucodigo#</cfoutput></cfif>">			
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
