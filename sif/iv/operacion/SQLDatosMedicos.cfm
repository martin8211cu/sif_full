<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="now"		returnvariable="hoy">
<cfif isdefined("form.btnFiltrar") >
	<cfquery datasource="#Session.DSN#" name="rsEEM">
		select distinct <cf_dbfunction name="to_char"args="a.EEMcodigo"> as EEMcodigo , a.EEMcardinalidad, a.EEMvalores
		from EstudianteExpedienteMetadato a
		order by case when a.EEMcardinalidad = 'N' then 1 else 0 end, a.EEMorden 
	</cfquery>
</cfif>
<cfif isdefined("rsEEM")>

	<cftry>
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
					<cfquery datasource="#Session.DSN#" name="rsUPD_EED">
						insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
						select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
						'0',
						#hoy#, 
						'Modifica ' #_Cat# a.EEMdescripcion #_Cat# ': de ' #_Cat# 
						(case when a.EEMvalores='0,1' then (case b.EEDvalor when '0' then 'No' else 'Sí' end) else b.EEDvalor end) #_Cat# ' a ' #_Cat#
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
					
					<cfquery datasource="#Session.DSN#">
						update EstudianteExpedienteDato
						set EEDvalor =  
						<cfif rsEEM.EEMvalores EQ '0,1'>
							<cfif isdefined(campo)>
								'1',
							<cfelse>
								'0',	
							</cfif>
						<cfelse>
							<cfif len(trim(contValor)) neq 0>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
							<cfelse>
							 	' ', 	
							</cfif>
						</cfif>
						  EEDfecha = #hoy#,
						  EEDusuario = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
						where CEcodigo =  #Session.CEcodigo# 
						  and EEMcodigo = #rsEEM.EEMcodigo#
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
						  and EEDvalor !=  
						<cfif rsEEM.EEMvalores EQ '0,1'>
							<cfif isdefined(campo)>
								'1'
							<cfelse>
								'0'	
							</cfif>
						<cfelse>
							<cfif len(trim(contValor)) neq 0>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
							<cfelse>
							 	' ' 	
							</cfif>
						</cfif>
					</cfquery>
	
					
				<cfelseif isdefined(campo) and Len(Trim(contValor)) NEQ 0>
					
					<cfquery datasource="#Session.DSN#" name="rsINS_EED">
						insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
						select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
						'0',
						#hoy#, 
						'Establece ' #_Cat# a.EEMdescripcion #_Cat# ': a ' #_Cat# 
						(case when a.EEMvalores='0,1' then (case <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> when '0' then 'Si' end) else <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> end) 
						, 
						 'M',
						 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
						 from EstudianteExpedienteMetadato a
						 where a.EEMcodigo = #rsEEM.EEMcodigo#
					</cfquery>
					
					<cfquery datasource="#Session.DSN#">	   
						insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
						values(#rsEEM.EEMcodigo#, 
							 #Session.CEcodigo# ,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
							<cfif rsEEM.EEMvalores NEQ '0,1'>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
							<cfelse>
								<cfif isdefined(campo)>
									'1',
								<cfelse>
									'0',	
								</cfif>
							</cfif>
						  #hoy#,
						   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
						  )
					</cfquery>   
					
				</cfif>
			<cfelse>
				<!--- Hacer query que busque cuantos registros tiene el tipo consultado --->
				<cfquery datasource="#Session.DSN#" name="rsCONS_EED">
					select <cf_dbfunction name="to_char"	args="EEDcodigo"> as EEDcodigo,
					       <cf_dbfunction name="to_char"	args="EEMcodigo"> as EEMcodigo,
					EEDvalor, 
					EEDfecha, 
					EEDusuario
					from EstudianteExpedienteDato 
					where CEcodigo =  #Session.CEcodigo# 
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
							<cfquery datasource="#Session.DSN#" name="rsUPD_EED">
								insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
								select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
								'0',
								#hoy#, 
								'Modifica ' #_Cat# a.EEMdescripcion #_Cat# ': de ' #_Cat# 
								(case when a.EEMvalores='0,1' then (case b.EEDvalor when '0' then 'No' else 'Sí' end) else b.EEDvalor end) #_Cat# ' a ' #_Cat#
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">, 
								 'M',
								 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								 from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b 
								 where a.EEMcodigo = #rsCONS_EED.EEMcodigo#
								   and b.EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
								   and b.EEMcodigo = #rsCONS_EED.EEMcodigo#
								   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
								   and b.EEDvalor != <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
							  </cfquery>
							  
							  <cfquery datasource="#Session.DSN#">
								update EstudianteExpedienteDato
								set EEDvalor =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
								  EEDfecha = #hoy#,
								  EEDusuario = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								where CEcodigo =  #Session.CEcodigo# 
								  and EEMcodigo = #rsCONS_EED.EEMcodigo#
								  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
								  and EEDvalor !=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">
							</cfquery>
						<cfelseif isdefined(campo) and Len(Trim(contValor)) NEQ 0>
							<cfquery datasource="#Session.DSN#" name="rsINS_EED">
								insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
								select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
								'0',
								#hoy#, 
								'Establece ' #_Cat# a.EEMdescripcion #_Cat# ': a ' #_Cat# 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">, 
								 'M',
								 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								 from EstudianteExpedienteMetadato a
								 where a.EEMcodigo = #rsCONS_EED.EEMcodigo#
							</cfquery>
							
							<cfquery datasource="#Session.DSN#">
								insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
								values(#rsCONS_EED.EEMcodigo#, 
									 #Session.CEcodigo# ,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
								  	#hoy#,
								   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								  )
							</cfquery>   
						<cfelseif isdefined(campo) and len(trim(contValor)) EQ 0>	
							<cfquery datasource="#Session.DSN#" name="rsDEL_EED">
								insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
								select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
								'0',
								#hoy#, 
								'Elimina ' #_Cat# a.EEMdescripcion #_Cat# ': ' #_Cat# 									 
								 (case when a.EEMvalores='0,1' then (case b.EEDvalor when '0' then 'NO' else 'SI' end) else  b.EEDvalor end) , 
								 'M',
								 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								 from EstudianteExpedienteMetadato a, EstudianteExpedienteDato b 
								 where a.EEMcodigo = #rsCONS_EED.EEMcodigo#
								   and b.EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
								   and b.EEMcodigo = #rsCONS_EED.EEMcodigo#
								   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
						      </cfquery>
							  
							  <cfquery datasource="#Session.DSN#">
								delete from EstudianteExpedienteDato
								where CEcodigo =  #Session.CEcodigo# 
								  and EEDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#idValor#">
								  and EEMcodigo = #rsCONS_EED.EEMcodigo#
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
							<cfquery datasource="#Session.DSN#" name="rsINS_EED">
								insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
								select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
								'0',
								#hoy#, 
								'Establece ' #_Cat# a.EEMdescripcion #_Cat# ': ' #_Cat# 
								 (case when a.EEMvalores='0,1' then (case <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> when '0' then 'NO' else 'SI' end) else <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> end) , 
								 'M',
								 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								 from EstudianteExpedienteMetadato a
								 where a.EEMcodigo = #rsCONS_EED.EEMcodigo#
							</cfquery>	 
							
							<cfquery datasource="#Session.DSN#">
								insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
								values(#rsEEM.EEMcodigo#, 
									 #Session.CEcodigo# ,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
								  #hoy#,
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
							<cfquery datasource="#Session.DSN#" name="rsINS_EED">
								insert into EstudianteExpedienteAnotacion (Ecodigo, EEAtipo, EEAfecha, EEAtexto, EEAcategoria, EEAusuario) 
								select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">, 
								'0',
								#hoy#, 
								'Establece ' #_Cat# a.EEMdescripcion #_Cat# ': ' #_Cat# 
								 (case when a.EEMvalores='0,1' then (case <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> when '0' then 'NO' else 'SI' end) else <cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#"> end) , 
								 'M',
								 <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								 from EstudianteExpedienteMetadato a
								 where a.EEMcodigo = #rsEEM.EEMcodigo#
							</cfquery>
							
							<cfquery datasource="#Session.DSN#">
								insert into EstudianteExpedienteDato (EEMcodigo, CEcodigo, Ecodigo, EEDvalor, EEDfecha, EEDusuario)
								values(#rsEEM.EEMcodigo#, 
									 #Session.CEcodigo# ,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#contValor#">,
								  #hoy#,
								   <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Session.Usuario#">
								  )
							</cfquery>
						
						</cfif>
					</cfif> 
				</cfif>
			</cfif>
		</cfloop>
		<!--- <cfabort> --->
		<cfcatch type="any">
			<cfinclude template="file:///D|/errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<form action="file:///D|/Temp/alumno.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="persona" type="hidden" value="<cfif isdefined("Form.persona")><cfoutput>#Form.persona#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	<input name="o" type="hidden" value="<cfif isdefined("form.o") and form.o NEQ ""><cfoutput>#form.o#</cfoutput></cfif>">	
	<input name="Ecodigo" type="hidden" value="<cfif isdefined("form.Ecodigo") and form.Ecodigo NEQ ""><cfoutput>#form.Ecodigo#</cfoutput></cfif>">	
	<!--- Campos del filtro para la lista de alumnos --->
	<cfif isdefined("Form.fRHnombre")>
		<input type="hidden" name="fRHnombre" value="<cfoutput>#Form.fRHnombre#</cfoutput>">
	</cfif>		   
	<cfif isdefined("Form.FNcodigo")>
		 <input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
	</cfif>		
	<cfif isdefined("Form.filtroRhPid")>
		 <input type="hidden" name="filtroRhPid" value="<cfoutput>#Form.filtroRhPid#</cfoutput>">
	</cfif>		
	<cfif isdefined("Form.FGcodigo")>
		<input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.NoMatr")>
		<input type="hidden" name="NoMatr" value="<cfoutput>#Form.NoMatr#</cfoutput>">
	</cfif>		  		  
	<cfif isdefined("Form.FAretirado")>
		<input type="hidden" name="FAretirado" value="<cfoutput>#Form.FAretirado#</cfoutput>">
	</cfif>		
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>