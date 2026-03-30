<cfparam name="action" default="rh.cfm">

<!--- Por el momento y para la Demo se va a dejar fijo el CEcodigo de la session porque 
se presentaron errores de perdida de la session para cuando se hacia un cambio --->
<cfparam name="Session.CEcodigo" default="13">

<!--- <cfdump var="#form#">
 <cfdump var="#url#">  
<cfdump var="#Session#">--->

<cfif isdefined("form.btnAgregar") or isdefined("form.btnCambiar") or isdefined("form.btnBorrar") or isdefined("form.btnAgregarEncar")>
	<cfset tmp = "" >		<!--- comtenido binario de la imagen --->
	<cfset ts = "null">
	<cfif isdefined("Form.Pfoto") and #form.Pfoto# NEQ "">
		<cftry>
			<!--- Seccion del Upload= Copia la imagen a un folder del servidor servidor --->
			<cffile action="Upload" fileField="form.Pfoto" destination="#GetTempDirectory()#" nameConflict="Overwrite" accept="image/*"> 
			<!--- lee la imagen de la carpeta del servidor y la almacena en la variable tmp --->
			<cffile action="readbinary"  file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#" variable="tmp" > 
	
			<cffile action="delete" file="#GetTempDirectory()##cffile.ClientFileName#.#cffile.ClientFileExt#">
		
			<!--- Formato para sybase --->
				<cfset Hex=ListtoArray("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F")>
		
				<cfif not isArray(tmp)>
					<cfset ts = "">
				</cfif>
				<cfset miarreglo=#ListtoArray(ArraytoList(#tmp#,","),",")#>
				<cfset miarreglo2=ArrayNew(1)>
				<cfset temp=ArraySet(miarreglo2,1,8,"")>
		
				<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
					<cfif miarreglo[i] LT 0>
						<cfset miarreglo[i]=miarreglo[i]+256>
					</cfif>
				</cfloop>
		
				<cfloop index="i" from="1" to=#ArrayLen(miarreglo)#>
					<cfif miarreglo[i] LT 10>
						<cfset miarreglo2[i] = "0" & #toString(Hex[(miarreglo[i] MOD 16)+1])#>
					<cfelse>
						<cfset miarreglo2[i] = #trim(toString(Hex[(miarreglo[i] \ 16)+1]))# & #trim(toString(Hex[(miarreglo[i] MOD 16)+1]))#>
					</cfif>
				</cfloop>
				<cfset temp = #ArrayPrepend(miarreglo2,"0x")#>
				<cfset ts = #ArraytoList(miarreglo2,"")#>
			<!--- --->	
			<!--- --------------------------------------------------------------------- --->
		<cfcatch type="any">
<!--- 			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort> --->
		</cfcatch>
		</cftry>		
	</cfif>		

	<cftry>
		<cfquery name="ABC_RH" datasource="#Session.DSN#">
			set nocount on
			
			<!--- Caso 1: Agregar --->
			<cfif isdefined("Form.btnAgregar")>
					insert PersonaEducativo 
					(CEcodigo, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Pfoto, Pemail1validado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
							convert( datetime, <cfqueryparam value="#form.Pnacimiento#" cfsqltype="cf_sql_varchar">, 103 ),																				
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
							#ts#,0)							

					select @@identity as id
				<cfset action = "rh.cfm">
				<cfset modo="CAMBIO">
				
			<!--- Caso 2: Cambio --->
			<cfelseif isdefined("Form.btnCambiar") and isdefined("form.persona") and #form.persona# NEQ "">
				update PersonaEducativo set
					CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
					Pnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					Papellido1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
					Papellido2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
					Ppais=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					TIcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,
					Pid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					Pnacimiento=convert( datetime, <cfqueryparam value="#form.Pnacimiento#" cfsqltype="cf_sql_varchar">, 103 ),
					Psexo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
					Pemail1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					Pemail2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					Pdireccion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					Pcasa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					<cfif isdefined("Form.Pfoto") and #form.Pfoto# NEQ "">
						Pfoto=#ts#,					
					</cfif>
					Pemail1validado=0
				where persona= <cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">

				<cfset action = "rh.cfm">								
				<cfset modo="CAMBIO">
										
			<!--- Caso 3: Borrar --->
			<cfelseif isdefined("Form.btnBorrar")>			
				<cfif isdefined("Form.persona") AND #Form.persona# NEQ "" >
					delete Asistente 
					where persona=<cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">					
					
					delete Staff 
					where persona=<cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">					

					delete Director 
					where persona=<cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">					

					<!--- Borrado de tablas referentes a Estudiante --->
						<!--- Borra todos los encargados asociados a él como estudiante --->
					delete EncargadoEstudiante
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and Ecodigo in (select Ecodigo from Alumnos where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">) 

					<!--- se borra como encargado de todas las relaciones de encargados por estudiante --->
					delete EncargadoEstudiante
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					and EEcodigo in (Select EEcodigo from Encargado where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">) 

					delete Alumnos 
					where  CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						and persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
						
					delete Estudiante 
					where  persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
					
					<!--- Borrado de Encargado --->
					delete Encargado 
					where persona=<cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">										
					
					<!--- Borrado de la persona --->					
					delete PersonaEducativo 
					where persona=<cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">				
					<cfset modo="ALTA">									
				</cfif>								
			</cfif>
			
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelse> 
	<cfset action = "rh.cfm" >
	<cfset modo   = "ALTA" >
</cfif>

<cfif isdefined("form.btnAgregar") or isdefined("form.btnCambiar")>
	<cfif isdefined("form.persona") AND #form.persona# EQ "" >
		<cfset #form.persona# = "#ABC_RH.id#">
		
		<cfif #form.persona# NEQ "" and (isdefined("form.Splaza") or isdefined("form.Acodigo") or isdefined("form.EEcodigo") or isdefined("form.Dcodigo") or isdefined("form.Ecodigo"))>
			<!--- Control de tablas Director - Asistente - Staff - Encargado --->
			<cftry>
				<cfquery name="ABC_Relaciones" datasource="#Session.DSN#">
					set nocount on
					
					<cfif isdefined("form.Splaza") >			<!--- ALTA de Staff --->
						insert Staff 
						(CEcodigo, persona, autorizado)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">, 1)
					</cfif>
					
					<cfif isdefined("form.Acodigo") >			<!--- ALTA de Asistente --->
						insert Asistente 
						(CEcodigo, persona)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">)			
					</cfif>
					
					<cfif isdefined("form.EEcodigo") >			 <!--- ALTA de Encargado --->
						insert Encargado (persona)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">)					
					</cfif>					
					
					<cfif isdefined("form.Dcodigo") >			<!--- ALTA de Director	---> 
						insert Director	(persona,Ncodigo)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">)			
					</cfif>
					
					set nocount off			
				</cfquery>	
			<cfcatch type="any">
				<cfinclude template="../../errorPages/BDerror.cfm">
				<cfabort>
			</cfcatch>
			</cftry>
		</cfif>
	<cfelse>	
		<!--- Control de tablas Director - Asistente - Staff - Encargado --->
		<cftry>
			<cfquery name="ABC_Relaciones" datasource="#Session.DSN#">
				set nocount on
				
				<cfif isdefined("form.Splaza")>
					<cfif #form.Splaza# NEQ "">			<!--- CAMBIO de Staff --->
						update Staff set persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
						where Splaza=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">
					<cfelse>							<!--- ALTA de Staff --->
						insert Staff (CEcodigo, persona, autorizado)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">, 1)
					</cfif>
				<cfelse>									<!--- BAJA de Staff --->
					delete Staff 
					where  CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						and persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">			
				</cfif>
				
				<cfif isdefined("form.Acodigo")>			
					<cfif #form.Acodigo# NEQ "">			<!--- CAMBIO de Asistente --->
						update Asistente set 
							CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
							persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
						where Acodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Acodigo#">			
					<cfelse>								<!--- ALTA de Asistente --->
						insert Asistente (CEcodigo, persona)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">)				
					</cfif>			
				<cfelse>									<!--- BAJA de Asistente --->
					delete Asistente 
					where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						and persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">			
				</cfif>		
			
			
				<cfif isdefined("form.EEcodigo") >			 <!--- ALTA de Encargado --->
					<cfif #form.EEcodigo# EQ "">	<!--- Si el EEcodigo viene con un valor habria que hacer un CAMBIO
															pero por el momento no hay ningun campo para cambiar, entonces no se realiza --->
						insert Encargado (persona)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">)					
					</cfif>
				<cfelse>	 
												 <!--- BAJA de Encargado --->
						<!--- se borra como encargado de todas las relaciones de encargados por estudiante --->
						delete EncargadoEstudiante
						where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						and EEcodigo in (Select EEcodigo from Encargado where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">) 

						delete Encargado 
						where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
				</cfif>
				
				
				<cfif isdefined("form.Dcodigo") >			
					<cfif #form.Dcodigo# NEQ "">			<!--- CAMBIO de Director --->
						update Director set Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">
						where Dcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Dcodigo#">
					<cfelse> 								<!--- ALTA de Director --->
						insert Director	(persona,Ncodigo)
						values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">)				
					</cfif>
				<cfelse>									<!--- BAJA de Director 	--->
						delete Director 
						where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">			
				</cfif>
							
				set nocount off
			</cfquery>	
		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cfif>
</cfif>


<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="persona"   type="hidden" value="<cfif isdefined("Form.persona")>#form.persona#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	
	<!--- Campos para el boton de buscar --->
	<cfif isdefined("form.btnBuscar") > 
		<input name="Busca" type="hidden" value="1">
		<input name="Pnombre" type="hidden" value="<cfif isdefined("Form.Pnombre")>#Form.Pnombre#</cfif>">	
		<input name="Papellido1" type="hidden" value="<cfif isdefined("Form.Papellido1")>#Form.Papellido1#</cfif>">		
		<input name="Papellido2" type="hidden" value="<cfif isdefined("Form.Papellido2")>#Form.Papellido2#</cfif>">			
		<input name="Pid" type="hidden" value="<cfif isdefined("Form.Pid")>#Form.Pid#</cfif>">				
		<input name="Pdireccion" type="hidden" value="<cfif isdefined("Form.Pdireccion")>#Form.Pdireccion#</cfif>">					
		<input name="Pcasa" type="hidden" value="<cfif isdefined("Form.Pcasa")>#Form.Pcasa#</cfif>">							
		<input name="Pemail1" type="hidden" value="<cfif isdefined("Form.Pemail1")>#Form.Pemail1#</cfif>">																			
		<input name="Pemail2" type="hidden" value="<cfif isdefined("Form.Pemail2")>#Form.Pemail2#</cfif>">																			
	<cfelse>
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
	</cfif>		
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>