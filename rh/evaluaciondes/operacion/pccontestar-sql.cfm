
<cftransaction>
<!--- ======================================================================================= --->
<cfif isdefined("form.PCUid") and len(trim(form.PCUid))>
	<cfquery datasource="#session.DSN#">
		delete from PortalRespuestaU
		where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from PortalPreguntaU
		where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		delete from PortalCuestionarioU
		where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
	</cfquery>
</cfif>
<!--- ======================================================================================= --->

<!--- Crea de nuevo el cuestionario y sus preguntas --->
<cfquery datasource="#session.DSN#" name="cuestionario">
	insert into PortalCuestionarioU( Usucodigo, DEid, Usucodigoeval, DEideval, PCUreferencia, Ecodigo, CEcodigo, Usulogin, PCUfecha, BMfecha, BMUsucodigo )
	select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">, 
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
	<cf_dbidentity1 datasource="#session.DSN#">
</cfquery>	
<cf_dbidentity2 datasource="#session.DSN#" name="cuestionario">
<cfset form.PCUid = cuestionario.identity >

<cfloop from="1" to="#totalPCid#" index="i">
	<cfset LvarPCid = form['PCid_#i#'] >
			<cfquery datasource="#session.DSN#">
				insert into PortalPreguntaU(PCUid, PCid, PPid, Ecodigo, CEcodigo, BMfecha, BMUsucodigo)
				select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">, 
						PPid, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from PortalPregunta
				where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
			</cfquery>
			
			<cfquery name="data" datasource="#session.DSN#">
				select pc.PCid, pp.PPid, pp.PPtipo
				from PortalCuestionario pc
				
				inner join PortalPregunta pp
				on pc.PCid=pp.PCid
				
				where pc.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
				  and pp.PPtipo != 'E'
				
				order by PPparte, PPnumero, PPtipo
			</cfquery>
			<cfoutput query="data">
				<cfset pregunta = data.PPid >
				<cfquery name="respuesta" datasource="#session.DSN#">
					select pr.PRid, pr.PRvalor
					from PortalRespuesta pr
					where pr.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
					  and pr.PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
				</cfquery>
			
				<cfif data.PPtipo eq 'U' >
					<cfloop query="respuesta">
						<cfset name = "p_#pregunta#" >
						<cfset LvarPRvalor = respuesta.PRvalor >	
						<cfif isdefined("form.#name#") and form['#name#'] eq respuesta.PRid >
							<cfquery datasource="#session.DSN#">
								insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, Ecodigo, CEcodigo, PRUvalor, BMfecha, BMUsucodigo )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#name#']#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_float" value="#LvarPRvalor#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
							</cfquery>
						</cfif>
					</cfloop>
				
				<cfelseif data.PPtipo eq 'M'>
					<cfloop query="respuesta">
						<cfset LvarPRvalor = respuesta.PRvalor >	
						<cfset name = "p_#pregunta#_#respuesta.PRid#" >
						<cfif isdefined("form.#name#") >
							<cfquery datasource="#session.DSN#">
								insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, Ecodigo, CEcodigo, PRUvalor, BMfecha, BMUsucodigo )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#name#']#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
										<cfqueryparam cfsqltype="cf_sql_float" value="#LvarPRvalor#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
							</cfquery>
						</cfif>
					</cfloop>
				
				<cfelseif data.PPtipo eq 'D'>
					<cfset name = "p_#pregunta#" >
					<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
						<cfquery datasource="#session.DSN#">
							update PortalPreguntaU
							set PCUtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">
							where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
							  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
							  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
						</cfquery>
					</cfif>
					
				<cfelseif listcontains('V,O',data.PPtipo)>
					<cfif respuesta.recordcount gt 0 >
						<cfloop query="respuesta">
							<cfset name = "p_#pregunta#_#respuesta.PRid#" >
							<cfset LvarPRvalor = respuesta.PRvalor >	
							<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
								<cfquery datasource="#session.DSN#">
									insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, PRUvalorresp,Ecodigo, CEcodigo, PRUvalor, BMfecha, BMUsucodigo )
									values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#respuesta.PRid#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
											<cfqueryparam cfsqltype="cf_sql_float" value="#LvarPRvalor#" null="#not isnumeric(LvarPRvalor)#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
								</cfquery>
							</cfif>
						</cfloop>
					<cfelse>
						<cfset name = "p_#pregunta#" >
						<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
							<cfquery datasource="#session.DSN#">
								update PortalPreguntaU
								set PCUtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">
								where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
								  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
								  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">
							</cfquery>
						</cfif>
					</cfif>
				</cfif>
			</cfoutput>
</cfloop>


</cftransaction>
<!---  1 POR HABILIDADES,3 POR CONOCIMIENTOS, 4 POR HABILIDADES Y CONOCIMIENTOS  --->
<cfset parametros = '' >
<cfif form.tipo_evaluacion EQ 1>
	<cfset parametros = '&PCid=-1' >
<cfelseif form.tipo_evaluacion eq 2 and isdefined("LvarPCid") >
	<cfset parametros = '&PCid=#LvarPCid#' >
<cfelseif form.tipo_evaluacion EQ 3>
	<cfset parametros = '&PCid=0' >
<cfelseif form.tipo_evaluacion EQ 4>
	<cfset parametros = '&PCid=-2' >
</cfif>
<cflocation url="evaluar_des.cfm?RHEEid=#form.RHEEid#&tipo=#form.tipo#&DEid=#form.DEid#&DEideval=#form.DEideval#&RHPcodigo=#form.RHPcodigo##parametros#">