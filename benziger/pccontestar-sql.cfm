<!--- ======================================================================================= --->
<cfif isdefined("form.PCUid") and len(trim(form.PCUid))>
	<cfquery datasource="sifcontrol">
		delete PortalRespuestaU
		where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
	</cfquery>
	<cfquery datasource="sifcontrol">
		delete PortalPreguntaU
		where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
	</cfquery>
	<cfquery datasource="sifcontrol">
		delete PortalCuestionarioU
		where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">
	</cfquery>
</cfif>

<!--- ======================================================================================= --->
<cftransaction>
<!--- Crea de nuevo el cuestionario y sus preguntas --->
<cfquery datasource="sifcontrol" name="cuestionario">
	insert into PortalCuestionarioU( Usucodigo, DEid, Usucodigoeval, DEideval, Ecodigo, CEcodigo, Usulogin, PCUfecha, BMfecha, BMUsucodigo, BUid )
	select 	0, 
			0,
			0,
			0,
			0,
			0,
			'0',
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BUid#"> 
	<cf_dbidentity1 datasource="sifcontrol">
</cfquery>	
<cf_dbidentity2 datasource="sifcontrol" name="cuestionario">
<cfset form.PCUid = cuestionario.identity >

<cfloop from="1" to="#totalPCid#" index="i">
	<cfset LvarPCid = form['PCid_#i#'] >
			<cfquery datasource="sifcontrol">
				insert into PortalPreguntaU(PCUid, PCid, PPid, BMfecha, BMUsucodigo)
				select 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">, 
						PPid, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						0
				from PortalPregunta
				where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">
			</cfquery>
			
			<cfquery name="data" datasource="sifcontrol">
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
				<cfquery name="respuesta" datasource="sifcontrol">
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
							<cfquery datasource="sifcontrol">
								insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, PRUvalor, BMfecha, BMUsucodigo )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#name#']#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPRvalor#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										0 )
							</cfquery>
						</cfif>
					</cfloop>
				
				<cfelseif data.PPtipo eq 'M'>
					<cfloop query="respuesta">
						<cfset LvarPRvalor = respuesta.PRvalor >	
						<cfset name = "p_#pregunta#_#respuesta.PRid#" >
						<cfif isdefined("form.#name#") >
							<cfquery datasource="sifcontrol">
								insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, PRUvalor, BMfecha, BMUsucodigo )
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['#name#']#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPRvalor#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										0 )
							</cfquery>
						</cfif>
					</cfloop>
				
				<cfelseif data.PPtipo eq 'D'>
					<cfset name = "p_#pregunta#" >
					<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
						<cfquery datasource="sifcontrol">
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
								<cfquery datasource="sifcontrol">
									insert into PortalRespuestaU( PCUid, PCid, PPid, PRid, PRvalorresp, PRUvalor, BMfecha, BMUsucodigo )
									values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCUid#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPCid#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#pregunta#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#respuesta.PRid#">,
											<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['#name#']#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPRvalor#">,
											<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
								</cfquery>
							</cfif>
						</cfloop>
					<cfelse>
						<cfset name = "p_#pregunta#" >
						<cfif isdefined("form.#name#") and len(trim(form['#name#']))>
							<cfquery datasource="sifcontrol">
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

<cflocation url="pccontestar.cfm?BUid=#form.BUid#&PCcodigo=#form.PCcodigo#">