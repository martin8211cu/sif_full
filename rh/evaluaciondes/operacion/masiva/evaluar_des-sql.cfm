<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
<cfquery name="PREGUNTAS" datasource="#session.DSN#">
	select pc.PCid,
		   pc.PCcodigo,
		   pc.PCnombre,
		   pcp.PPparte,
		   pcp.PCPmaxpreguntas,
		   pcp.PCPdescripcion,
		   pp.PPid,	
		   pp.PPnumero, 
		   pp.PPpregunta,
		   pp.PPmantener,
		   pp.PPtipo,
		   pp.PPrespuesta,
		   pc.PCtiempototal,
		   pp.PPorden,
		   coalesce(pp.PPorientacion,0) as PPorientacion
	from PortalCuestionario pc
	inner join PortalCuestionarioParte pcp
	on pc.PCid=pcp.PCid
	inner join PortalPregunta pp
	on pp.PCid=pcp.PCid
	and pp.PPparte=pcp.PPparte
	and pp.PPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	where pc.PCid in (#form.listaPCid#)
	order by  pp.PPorden
</cfquery>



<cfsetting requesttimeout="36000">
<cfif isdefined("Form._next")>
	<cfset form.posicion = form.posicion + 1>
<cfelseif isdefined("Form._back")>
	<cfset form.posicion = form.posicion - 1>
</cfif>
<cfif isdefined("Form._next") or isdefined("Form._back") or isdefined("Form.guardar")>
	<!--- <cftransaction> --->
		<cfset arreglo  = listtoarray(form.DEid_LIST)>
		<cfset DEid		 = -1>
		<cfset Usucodigo = -1>
		<cfset PCUid  	 = -1>
		<cfset PCid  	 = -1>
		<cfset PPid  	 = -1>
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cfif arreglo[i] neq -1>
				<cfset DEid          = arreglo[i]>
				<cfset rsevaluando 	 = sec.getUsuarioByRef(DEid, session.EcodigoSDC, 'DatosEmpleado')>
				<cfset Usucodigo     = rsevaluando.Usucodigo>
				
				<!--- ***************************** --->
				<!--- Busca si existe un registro   --->
				<!--- en portalcuentionario         --->
				<!--- ***************************** --->
				<cfquery datasource="#session.DSN#" name="RScuestionario">
					select PCUid from PortalCuestionarioU 
					where DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">
					 and Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">
					 and Usucodigoeval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigoeval#">
					and DEideval      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">
				</cfquery>
				<cfif RScuestionario.recordCount eq 0>
					<cfquery datasource="#session.DSN#" name="cuestionario">
						insert into PortalCuestionarioU( Usucodigo, DEid, Usucodigoeval, DEideval, PCUreferencia, Ecodigo, CEcodigo, Usulogin, PCUfecha, BMfecha, BMUsucodigo )
						select 	 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Usucodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigoeval#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEideval#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEEid#">, 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						from dual
						<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion = 'NO'>
					</cfquery>	
					<cf_dbidentity2 datasource="#session.DSN#" name="cuestionario" verificar_transaccion = 'NO'>
					<cfset PCUid = cuestionario.identity>		
				<cfelse>
					<cfset PCUid = RScuestionario.PCUid>
				</cfif>
				
				<cfloop query="PREGUNTAS">
					<cfset PCid  	 = PREGUNTAS.PCid>
					<cfset PPid  	 = PREGUNTAS.PPid>
					<cfquery datasource="#session.DSN#" name="RSPortalPreguntaU">
						select PCUid from PortalPreguntaU 
						where PCUid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">
						and PCid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
						and PPid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PPid#">
					</cfquery>
					
					<cfif RSPortalPreguntaU.recordCount eq 0>
						<!--- ***************************** --->
						<!--- inserta las preguntas         --->
						<!--- del o los cuestionarios       --->
						<!--- ***************************** --->
						 <cfquery datasource="#session.DSN#">
							insert into PortalPreguntaU(PCUid, PCid, PPid, Ecodigo, CEcodigo, BMfecha, BMUsucodigo)
							select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">,
									PCid, 
									PPid, 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							from PortalPregunta
							where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
						</cfquery>
					</cfif>


					<cfquery name="RSdata" datasource="#session.DSN#">
						select pc.PCid, pp.PPid, pp.PPtipo
						from PortalCuestionario pc
						inner join PortalPregunta pp
						on pc.PCid=pp.PCid
						where pc.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
						  and pp.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">	
						  and pp.PPtipo != 'E'
						order by PPparte, PPnumero, PPtipo
					</cfquery>

					
					<cfloop query="RSdata">
						<cfset pregunta = RSdata.PPid >
						<cfquery name="respuesta" datasource="#session.DSN#">
							select pr.PRid, pr.PRvalor
							from PortalRespuesta pr
							where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
							  and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
						</cfquery>
						
						<cfquery name="Tienerespuesta" datasource="#session.DSN#">
							select PCUid
							from PortalRespuestaU 
							where  PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">
							   and PCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
							   and PPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
						</cfquery>
						
						<cfif Tienerespuesta.recordCount GT 0> 
							<cfquery datasource="#session.DSN#">
								delete from PortalRespuestaU  
								where  PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">
								   and PCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
								   and PPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
							</cfquery>
						</cfif>
						<!--- ***************************** --->
						<!--- carga de respuestas segun     --->
						<!--- el tipo de pregunta           --->
						<!--- ***************************** --->
					
						<cfif RSdata.PPtipo eq 'U' >
							<cfloop query="respuesta">
								<cfset name = "p_#DEid#_#pregunta#" >
								<cfset LvarPRvalor = respuesta.PRvalor >	
								<cfif isdefined("form.#name#") and form['#name#'] eq respuesta.PRid >

									<cfquery datasource="#session.DSN#">
										insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, Ecodigo, CEcodigo, PRUvalor, BMfecha, BMUsucodigo )
										values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#name#']#">,
												<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPRvalor#">,
												<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
												<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
									</cfquery>
								</cfif>	
							</cfloop>
						<cfelseif RSdata.PPtipo eq 'M'>
							<cfloop query="respuesta">
								<cfset LvarPRvalor = respuesta.PRvalor >	
								<cfset name = "CHK_#DEid#_#pregunta#" >
								<cfif isdefined("form.#name#") >
									<cfset RespuestaM  = listtoarray(form['#name#'])>
									<cfloop from="1" to ="#arraylen(RespuestaM)#" index="X">
										<cfif RespuestaM[X] eq respuesta.PRid>
											<cfquery datasource="#session.DSN#">
												insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, Ecodigo, CEcodigo, PRUvalor, BMfecha, BMUsucodigo )
												values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#RespuestaM[X]#">,
														<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPRvalor#">,
														<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
														<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
											</cfquery>
										</cfif>
									</cfloop>	
								</cfif>
							</cfloop>
						
						<cfelseif RSdata.PPtipo eq 'D'>
							<cfset name = "p_#DEid#_#pregunta#" >
							<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
								<cfquery datasource="#session.DSN#">
									update PortalPreguntaU
									set PCUtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">
									where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">
									  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
									  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
								</cfquery>
							</cfif>
							
						<cfelseif listcontains('V,O',RSdata.PPtipo)>
							<cfif respuesta.recordcount gt 0 >
								<cfloop query="respuesta">
									<cfset name = "p_#DEid#_#pregunta#_#respuesta.PRid#" >
									<cfset LvarPRvalor = respuesta.PRvalor >	
									<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
										<cfquery datasource="#session.DSN#">
											insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, PRUvalorresp,Ecodigo, CEcodigo, PRUvalor, BMfecha, BMUsucodigo )
											values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#respuesta.PRid#">,
													<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">,
													<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPRvalor#">,
													<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
										</cfquery>
									</cfif>
								</cfloop>
							<cfelse>
								<cfset name = "p_#DEid#_#pregunta#">
								<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
									<cfquery datasource="#session.DSN#">
										update PortalPreguntaU
										set PCUtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">
										where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCUid#">
										  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PCid#">
										  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
					</cfloop>
				</cfloop> 
			</cfif>
		</cfloop>
	<!--- </cftransaction> --->
</cfif>

<!--- <cf_dump var="#Form#"> --->
<cfoutput>
	<form action="evaluar_masivo.cfm" method="post" name="sql">
			<input type="hidden" name="RHEEid" value="#form.RHEEid#">
			<input type="hidden" name="DEideval" value="#form.DEideval#">
			<input type="hidden" name="DEid_LIST" value="#form.DEid_LIST#">
			<input type="hidden" name="PCid" value="#form.PCid#">
			<input type="hidden" name="RHPcodigo" value="#form.RHPcodigo#">
			<input type="hidden" name="posicion" value="#form.posicion#">
			<input type="hidden" name="ultimo" value="#form.ultimo#">
	</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>