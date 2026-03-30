
<cfset params="tab=#form.tab#&persona=#form.persona#&">
<cfif isdefined('form.Aceptar')>
	<cfquery datasource="#Session.Edu.DSN#" name="rsEEM">
		select distinct convert(varchar,a.EEMcodigo) as EEMcodigo , a.EEMcardinalidad, a.EEMvalores
		from EstudianteExpedienteMetadato a
		order by case when a.EEMcardinalidad = 'N' then 1 else 0 end, a.EEMorden 
	</cfquery>
	<cfloop query="rsEEM"> 
		<cfif rsEEM.EEMcardinalidad NEQ "N">
			<cfset campo = "form.campo_#rsEEM.EEMcodigo#">
			<cfset id = "form.id_campo_#rsEEM.EEMcodigo#">
			<cfif isdefined(id)>
				<cfset idValor = Evaluate(id)>
			</cfif>
			<cfif isdefined(campo)>
				<cfset contValor = Evaluate(campo)>
			</cfif>
			<cfif isdefined(id) and Len(Trim(idValor)) NEQ 0>
				<cfquery name="rsInsertEEA" datasource="#session.Edu.DSN#">
					insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
					'0',
					getdate(), 
					'Modifica ' + a.EEMdescripcion + ': de ' + 
					(case when a.EEMvalores='0,1' then (case b.EEDvalor when '0' then 'No' else 'Sí' end) else b.EEDvalor end) + ' a ' +
					<cfif rsEEM.EEMvalores EQ '0,1'>
						<cfif isdefined(campo)>
							'SI'
						<cfelse>
							'NO'	
						</cfif>
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
					</cfif>						 
					 , 
					 'M',
					 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
					 from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b 
					 where a.EEMcodigo = #rsEEM.EEMcodigo#
					   and b.EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
					   and b.EEMcodigo = #rsEEM.EEMcodigo#
					   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
					   and b.EEDvalor != <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
				</cfquery>
				<cfquery name="rsUpdateEED" datasource="#session.Edu.DSN#">
					update EstudianteExpedienteDato
					set EEDvalor =  
					<cfif rsEEM.EEMvalores EQ '0,1'>
						<cfif isdefined(campo)>'1',<cfelse>'0',</cfif>
					<cfelse>
						<cfif len(trim(contValor)) neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,<cfelse>' ',</cfif>
					</cfif>
					  EEDfecha = getdate(),
					  EEDusuario = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					  and EEMcodigo = #rsEEM.EEMcodigo#
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
					  and EEDvalor != <cfif rsEEM.EEMvalores EQ '0,1'>
										<cfif isdefined(campo)>'1'<cfelse>'0'</cfif>
									  <cfelse>
										<cfif len(trim(contValor)) neq 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"><cfelse>' '</cfif>
									  </cfif>
				</cfquery>
			<cfelseif isdefined(campo) and Len(Trim(contValor)) NEQ 0>
				
				<cfquery name="rsInsertEEA" datasource="#Session.Edu.DSN#">
					insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
					'0',
					getdate(), 
					'Establece ' + a.EEMdescripcion + ': a ' + 
					(case when a.EEMvalores='0,1' then (case <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> when '0' then 'Si' end) else <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> end) 
					, 
					 'M',
					 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
					 from EstudianteExpedienteMetadato a
					 where a.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEEM.EEMcodigo#">
				</cfquery>
				<cfquery name="rsInsertEED" datasource="#session.Edu.DSN#">
					insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
					values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEEM.EEMcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
						<cfif rsEEM.EEMvalores NEQ '0,1'>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
						<cfelse>
							<cfif isdefined(campo)>'1',<cfelse>'0',</cfif>
						</cfif>
					  getdate(),
					   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
					  )
				</cfquery>   
			</cfif>
		<cfelse>
			<!--- Hacer query que busque cuantos registros tiene el tipo consultado --->
			<cfquery datasource="#Session.Edu.DSN#" name="rsCONS_EED">
				select convert(varchar,EEDcodigo) as EEDcodigo,
				convert(varchar,EEMcodigo) as EEMcodigo,
				EEDvalor, 
				EEDfecha, 
				EEDusuario
				from EstudianteExpedienteDato 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  and EEMcodigo = #rsEEM.EEMcodigo#
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">		  
			</cfquery>
			
			<!--- - Hacer loop según cantidad , concatenar i, para saber el nombre del campo pintado  --->
			 <!---  - Copiar el código de arriba para hacer los cambios necesarios a la cardinalidad --->
			<cfif rsCONS_EED.RecordCount NEQ 0>
				<cfset i = 0>
				<cfloop query="rsCONS_EED">
					<cfset i = i + 1>
					<cfset campo = "form.campo_#rsCONS_EED.EEMcodigo#_#i#">
					<cfset id = "form.id_campo_#rsCONS_EED.EEMcodigo#_#i#">
					<cfif isdefined(campo)>
						<cfset contValor = Evaluate(campo)>
					</cfif>
					<cfif isdefined(id)>
						<cfset idValor = Evaluate(id)>		
					</cfif>
					<!--- desde aqui --->
					<cfif isdefined(id) and Len(Trim(idValor)) NEQ 0 and Len(Trim(contValor)) NEQ 0>
						<cfquery name="rsInsertEEA" datasource="#Session.Edu.DSN#">
							insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
							select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
							'0',
							getdate(), 
							'Modifica ' + a.EEMdescripcion + ': de ' + 
							(case when a.EEMvalores='0,1' then (case b.EEDvalor when '0' then 'No' else 'Sí' end) else b.EEDvalor end) + ' a ' +
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">, 
							 'M',
							 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							 from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b 
							 where a.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
							   and b.EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
							   and b.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
							   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
							   and b.EEDvalor != <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
						</cfquery>
						<cfquery name="rsUpdateEED" datasource="#session.Edu.DSN#">
							update EstudianteExpedienteDato
							set EEDvalor =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
							  EEDfecha = getdate(),
							  EEDusuario = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							  and EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
							  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
							  and EEDvalor !=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
						</cfquery>
					<cfelseif isdefined(campo) and Len(Trim(contValor)) NEQ 0>
						<cfquery name="rsInsertEEA" datasource="#Session.Edu.DSN#">
							insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
							select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
							'0',
							getdate(), 
							'Establece ' + a.EEMdescripcion + ': a ' + 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">, 
							 'M',
							 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							 from EstudianteExpedienteMetadato a
							 where a.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
						</cfquery>
						<cfquery name="rsInsertEED" datasource="#session.Edu.DSN#">
							insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
								getdate(),
							   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							  )
						</cfquery>   
					<cfelseif isdefined(campo) and len(trim(contValor)) EQ 0>	
						<cfquery name="rsDeleteEEA" datasource="#Session.Edu.DSN#">
							insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
							select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
							'0',
							getdate(), 
							'Elimina ' + a.EEMdescripcion + ': ' + 									 
							 (case when a.EEMvalores='0,1' then (case b.EEDvalor when '0' then 'NO' else 'SI' end) else  b.EEDvalor end) , 
							 'M',
							 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							 from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b 
							 where a.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
							   and b.EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
							   and b.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
							   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
						</cfquery>
						<cfquery name="rsDeleteEED" datasource="#session.Edu.DSN#">
							delete EstudianteExpedienteDato
							where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							  and EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
							  and EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
							  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
						</cfquery>	  
					</cfif>
					<!--- hasta aqui --->
				</cfloop>
				<!---  - Al terminar el loop, preguntar si el elemento nuevo trae algo , y si trae hacer insert, 
				  sino  no hacer nada 
				  ESTO ES PARA ELEMENTOS CON POR LO MENOS UN TIPO --->
				<cfif isdefined("form.campo_#rsEEM.EEMcodigo#") >
					<cfset Newcampo = "form.campo_#rsEEM.EEMcodigo#">
					<cfset contValor = Evaluate(Newcampo)>
					<cfif len(trim(contValor)) neq 0>
						<cfquery name="rsInsertEEA" datasource="#Session.Edu.DSN#">
							insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
							select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
							'0',
							getdate(), 
							'Establece ' + a.EEMdescripcion + ': ' + 
							 (case when a.EEMvalores='0,1' then (case <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> when '0' then 'NO' else 'SI' end) else <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> end) , 
							 'M',
							 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							 from EstudianteExpedienteMetadato a
							 where a.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCONS_EED.EEMcodigo#">
						</cfquery>
						<cfquery name="rsInsertEED" datasource="#session.Edu.DSN#">
							insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEEM.EEMcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
							  getdate(),
							   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							  )
						</cfquery>
					</cfif>
				</cfif> 
			<cfelse>
			<!---  - Al terminar el loop, preguntar si el elemento nuevo trae algo , y si trae hacer insert, 
				  sino  no hacer nada 
				  ESTO ES PARA ELEMENTOS TOTALMENTE NUEVOS --->
				<cfif isdefined("form.campo_#rsEEM.EEMcodigo#") >
					<cfset Newcampo = "form.campo_#rsEEM.EEMcodigo#">
					<cfset contValor = Evaluate(Newcampo)>
					<cfif len(trim(contValor)) neq 0>
						<cfquery name="rsInsertEEA" datasource="#Session.Edu.DSN#">
							insert EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
							select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
							'0',
							getdate(), 
							'Establece ' + a.EEMdescripcion + ': ' + 
							 (case when a.EEMvalores='0,1' then (case <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> when '0' then 'NO' else 'SI' end) else <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> end) , 
							 'M',
							 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							 from EstudianteExpedienteMetadato a
							 where a.EEMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEEM.EEMcodigo#">
						</cfquery>
						<cfquery name="rsInsertEED" datasource="#session.Edu.DSN#">
							insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
							values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEEM.EEMcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
							  getdate(),
							   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
							  )
						</cfquery>
					</cfif>
				</cfif> 
			</cfif>
		</cfif>
	</cfloop>
</cfif>

<cflocation url="alumno.cfm?Pagina=#form.Pagina#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
