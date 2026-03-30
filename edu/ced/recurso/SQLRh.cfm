<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 24-1-2006.
		Motivo: Actualizar. Utilización del componente de dbidentity.
 --->

<cfset params="">
<cfset referencias = "">
<cfset roles = "">
<cfset activacion = "">
<cfif not isdefined('form.Nuevo')>
	<!--- Caso 1: Agregar --->
	<cfif isdefined('form.Alta')>
		<cftransaction>
			<cfquery name="rsInsertPE" datasource="#session.Edu.DSN#">
				insert PersonaEducativo (CEcodigo, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pfoto, Pemail1validado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.Pnacimiento#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,
							<cf_dbupload filefield="Pfoto" accept="image/*" datasource="#session.Edu.DSN#">,
							0)							
				<cf_dbidentity1 datasource="#Session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="rsInsertPE">
		</cftransaction>
		<cfset form.persona = rsInsertPE.identity>
		<cfset params = params &"persona="&form.persona>
	
	<!--- Caso 2: Cambio --->
	<cfelseif isdefined('form.Cambio')>
		<cfquery name="rsUpdatePE" datasource="#session.Edu.DSN#">
			update PersonaEducativo set
					CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
					Pnombre		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					Papellido1	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
					Papellido2	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
					Ppais		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					TIcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,
					Pid			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					Pnacimiento	= <cfqueryparam cfsqltype="cf_sql_date"    value="#form.Pnacimiento#">,
					Psexo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
					Pemail1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					Pemail2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					Pdireccion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					Pcasa		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					Poficina	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">,
					Pcelular	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">,
					Pfax		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
					Ppagertel	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,
					Ppagernum	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,
					<cfif isdefined("Form.Pfoto") and form.Pfoto NEQ "">
					Pfoto		= <cf_dbupload filefield="Pfoto" accept="image/*" datasource="#session.Edu.DSN#">,					
					</cfif>
					Pemail1validado=0
				where persona= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<cfset params = params &"persona="&form.persona>
		
	<!--- Caso 3: Borrar --->
	<cfelseif isdefined('form.Baja')>
		<!--- Query para obtener la referencia que se puede utilizar para borrar un Usuario del Framework --->
		<cfquery name="refUser" datasource="#Session.Edu.DSN#">
			select Acodigo as num_referencia, 'edu.asistente' as rol
			from Asistente
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			union
			select Splaza as num_referencia, 'edu.docente' as rol
			from Staff
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			union
			select Dcodigo as num_referencia, 'edu.director' as rol
			from Director
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			union
			select EEcodigo as num_referencia, 'edu.encargado' as rol
			from Encargado
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		
		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="del_usuario_by_ref"
		 returnvariable="UsrDeleted">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="referencia" value="#refUser.num_referencia#"/>
			<cfinvokeargument name="rol" value="#refUser.rol#"/>
		</cfinvoke>
		
		<cfquery datasource="#Session.Edu.DSN#">
			delete Asistente 
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">					
		</cfquery>

		<cfquery datasource="#Session.Edu.DSN#">
			delete Staff 
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">					
		</cfquery>

		<cfquery datasource="#Session.Edu.DSN#">
			delete DirectorNivel
			from DirectorNivel a, Director b 
			where b.persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and a.Dcodigo = b.Dcodigo
		</cfquery>
			
		<cfquery datasource="#Session.Edu.DSN#">
			delete Director 
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">					
		</cfquery>

			<!--- se borra como encargado de todas las relaciones de encargados por estudiante --->
		<cfquery datasource="#Session.Edu.DSN#">
			delete EncargadoEstudiante
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and EEcodigo in (Select EEcodigo from Encargado where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">) 
		</cfquery>

			<!--- Borrado de Encargado --->
		<cfquery datasource="#Session.Edu.DSN#">
			delete Encargado 
			where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">										
		</cfquery>
			
			<!--- Borrado de la persona --->
		<cfquery datasource="#Session.Edu.DSN#">
			delete PersonaEducativo 
			where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<cfset form.persona = ''>
	</cfif>
	
	<!--- Control de tablas Director - Asistente - Staff - Encargado --->
	<cfif not isdefined('form.Baja')>
		<!--- Query para obtener la referencia que se puede utilizar para borrar un Usuario del Framework --->
		<cfquery name="refUser" datasource="#Session.Edu.DSN#">
			select Acodigo as num_referencia, 'edu.asistente' as rol
			from Asistente
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			union
			select Splaza as num_referencia, 'edu.docente' as rol
			from Staff
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			union
			select Dcodigo as num_referencia, 'edu.director' as rol
			from Director
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			union
			select EEcodigo as num_referencia, 'edu.encargado' as rol
			from Encargado
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<cfset upd_referencia = refUser.num_referencia>
		<cfset upd_rol = refUser.rol>
		<cfset dominio_roles = "edu.asistente, edu.encargado, edu.director, edu.docente">
		<!--- STAFF --->
		<cfif isdefined("form.Splaza")>
			<cfif form.Splaza NEQ "">			<!--- CAMBIO de Staff --->
				<cfquery datasource="#Session.Edu.DSN#">
					update Staff 
					   set persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
						   autorizado = <cfif isdefined("form.autorizadodoc")>1<cfelse>0</cfif>
					where Splaza = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Splaza#">
				</cfquery>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(form.Splaza)>
			<cfelse>							<!--- ALTA de Staff --->
				<cftransaction>
				<cfquery name="ABC_RelacionesF" datasource="#Session.Edu.DSN#">
					insert Staff (CEcodigo, persona, autorizado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">, 
							<cfif isdefined("form.autorizadodoc")>
								1
							<cfelse>
								0
							</cfif>)
					<cf_dbidentity1 datasource="#Session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="ABC_RelacionesF">
				</cftransaction>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(ABC_RelacionesF.identity)>
			</cfif>
			
			<cfset roles = roles & Iif(roles NEQ "",DE(","),DE("")) & "edu.docente">
			<cfif isdefined("form.autorizadodoc")>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "1">
			<cfelse>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "0">
			</cfif>
		<cfelse>									<!--- BAJA de Staff --->
			<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
				delete Staff 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			</cfquery>
		</cfif>
		
		<!--- ASISTENTE --->
		<cfif isdefined("form.Acodigo")>			
			<cfif form.Acodigo NEQ "">			<!--- CAMBIO de Asistente --->
				<cfquery name="ABC_RelacionesG1" datasource="#Session.Edu.DSN#">
					update Asistente set 
						persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
						autorizado = <cfif isdefined("form.autorizadoast")>1<cfelse>0</cfif>
					where Acodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Acodigo#">			
				</cfquery>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(form.Acodigo)>
			<cfelse>
				<cftransaction>							<!--- ALTA de Asistente --->
				<cfquery name="ABC_RelacionesG2" datasource="#Session.Edu.DSN#">
					insert Asistente (CEcodigo, persona, autorizado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
							<cfif isdefined("form.autorizadoast")>1<cfelse>0</cfif>)				
					<cf_dbidentity1 datasource="#Session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="ABC_RelacionesG2">
				</cftransaction>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(ABC_RelacionesG2.identity)>
			</cfif>			
			
			<cfset roles = roles & Iif(roles NEQ "",DE(","),DE("")) & "edu.asistente">
			<cfif isdefined("form.autorizadoast")>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "1">
			<cfelse>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "0">
			</cfif>
		<cfelse>								<!--- BAJA de Asistente --->
			<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
				delete Asistente 
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					and persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			</cfquery>
		</cfif>		
		
		
		<!--- ENCARGADO --->
		<cfif isdefined("form.EEcodigo") >			 
			<cfif form.EEcodigo NEQ "">			<!--- CAMBIO de Encargado --->
				<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
					update Encargado 
					   set autorizado = <cfif isdefined("form.autorizadoenc")>1<cfelse>0</cfif>
					where EEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEcodigo#">
				</cfquery>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(form.EEcodigo)>
			<cfelse>
				<cftransaction>								<!--- ALTA de Encargado --->
				<cfquery name="ABC_RelacionesH" datasource="#Session.Edu.DSN#">
					insert Encargado (persona, autorizado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
							<cfif isdefined("form.autorizadoenc")>1<cfelse>0</cfif>)
					<cf_dbidentity1 datasource="#Session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="ABC_RelacionesH">
				</cftransaction>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(ABC_RelacionesH.identity)>
			</cfif>
			<cfset roles = roles & Iif(roles NEQ "",DE(","),DE("")) & "edu.encargado">
			<cfif isdefined("form.autorizadoenc")>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "1">
			<cfelse>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "0">
			</cfif>
		<cfelse>
			<!--- BAJA de Encargado --->
			<!--- se borra como encargado de todas las relaciones de encargados por estudiante --->
			<cfquery datasource="#Session.Edu.DSN#">
				delete EncargadoEstudiante
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and EEcodigo in (Select EEcodigo from Encargado where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">) 
			</cfquery>

			<cfquery datasource="#Session.Edu.DSN#">
				delete Encargado 
				where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			</cfquery>
		</cfif>
		
		
		<!--- DIRECTOR --->
		<cfif isdefined("form.Dcodigo") >
			<cfif form.Dcodigo NEQ "">			<!--- CAMBIO de Director --->
				<cfquery datasource="#Session.Edu.DSN#">
					update Director 
					   set autorizado = <cfif isdefined("form.autorizadodir")>1<cfelse>0</cfif>
					where Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Dcodigo#">
				</cfquery>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(form.Dcodigo)>
			<cfelse>
				<cftransaction> 								<!--- ALTA de Director --->
				<cfquery name="ABC_RelacionesI1" datasource="#Session.Edu.DSN#">
					insert Director	(persona, Ncodigo, autorizado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">,
							<cfif isdefined("form.autorizadodir")>1<cfelse>0</cfif>)			
					<cf_dbidentity1 datasource="#Session.Edu.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="ABC_RelacionesI1">
				</cftransaction>
				<cfquery name="ABC_RelacionesI2" datasource="#Session.Edu.DSN#">
					insert DirectorNivel(Dcodigo, Ncodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_RelacionesI1.identity#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ncodigo#">)
				</cfquery>
				<cfset referencias = referencias & Iif(referencias NEQ "",DE(","),DE("")) & ToString(ABC_RelacionesI1.identity)>
			</cfif>
			
			<cfset roles = roles & Iif(roles NEQ "",DE(","),DE("")) & "edu.director">
			<cfif isdefined("form.autorizadodir")>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "1">
			<cfelse>
				<cfset activacion = activacion & Iif(activacion NEQ "",DE(","),DE("")) & "0">
			</cfif>
		<cfelse>
												<!--- BAJA de Director 	--->
			<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
				delete DirectorNivel
				from DirectorNivel a, Director b 
				where b.persona = <cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">
				and a.Dcodigo = b.Dcodigo
			</cfquery>
			
			<cfquery name="ABC_Relaciones" datasource="#Session.Edu.DSN#">
				delete Director 
				where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			</cfquery>
		</cfif>

		<!--- Actualizacion del Usuario en el Framework --->
		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="upd_usuario"
		 returnvariable="UsrUpdated">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="referencias" value="#referencias#"/>
			<cfinvokeargument name="roles" value="#roles#"/>
			<cfinvokeargument name="activacion" value="#activacion#"/>
			<cfinvokeargument name="Pnombre" value="#form.Pnombre#"/>
			<cfinvokeargument name="Papellido1" value="#form.Papellido1#"/>
			<cfinvokeargument name="Papellido2" value="#form.Papellido2#"/>
			<cfinvokeargument name="Ppais" value="#form.Ppais#"/>
			<cfinvokeargument name="TIcodigo" value="#form.TIcodigo#"/>
			<cfinvokeargument name="Pid" value="#form.Pid#"/>
			<cfinvokeargument name="Pnacimiento" value="#form.Pnacimiento#"/>
			<cfinvokeargument name="Psexo" value="#form.Psexo#"/>
			<cfinvokeargument name="Pemail1" value="#form.Pemail1#"/>
			<cfinvokeargument name="Pemail2" value="#form.Pemail2#"/>
			<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#"/>
			<cfinvokeargument name="Pcasa" value="#form.Pcasa#"/>
			<cfinvokeargument name="Poficina" value="#form.Poficina#"/>
			<cfinvokeargument name="Pcelular" value="#form.Pcelular#"/>
			<cfinvokeargument name="Pfax" value="#form.Pfax#"/>
			<cfinvokeargument name="Ppagertel" value="#form.Ppagertel#"/>
			<cfinvokeargument name="Ppagernum" value="#form.Ppagernum#"/>
			<cfinvokeargument name="Pfoto" value="Pfoto"/>
			<cfinvokeargument name="upd_referencia" value="#upd_referencia#"/>
			<cfinvokeargument name="upd_rol" value="#upd_rol#"/>
			<cfinvokeargument name="dominio_roles" value="#dominio_roles#"/>
		</cfinvoke>
	</cfif>
</cfif>
<cfif isdefined('form.Baja')>
<cflocation url="listaRH.cfm?Pagina=#form.Pagina#&Filtro_RHnombre=#form.Filtro_RHnombre#&Filtro_RhPid=#form.Filtro_RhPid#&Filtro_Tipo=#form.Filtro_Tipo#&Filtro_Pmail1=#form.Filtro_Pmail1#&Filtro_Pcasa=#form.Filtro_Pcasa#&Filtro_Poficina=#form.Filtro_Poficina#&Filtro_Pcelular=#form.Filtro_Pcelular#&Filtro_Pmail2=#form.Filtro_Pmail2#&Filtro_Pagertel=#form.Filtro_Pagertel#&Filtro_Pagernum=#form.Filtro_PagerNum#&Filtro_Pfax=#form.Filtro_Pfax#">
<cfelse>
<cflocation url="rh.cfm?Pagina=#form.Pagina#&Filtro_RHnombre=#form.Filtro_RHnombre#&Filtro_RhPid=#form.Filtro_RhPid#&Filtro_Tipo=#form.Filtro_Tipo#&Filtro_Pmail1=#form.Filtro_Pmail1#&Filtro_Pcasa=#form.Filtro_Pcasa#&Filtro_Poficina=#form.Filtro_Poficina#&Filtro_Pcelular=#form.Filtro_Pcelular#&Filtro_Pmail2=#form.Filtro_Pmail2#&Filtro_Pagertel=#form.Filtro_Pagertel#&Filtro_Pagernum=#form.Filtro_PagerNum#&Filtro_Pfax=#form.Filtro_Pfax#&#params#">
</cfif>