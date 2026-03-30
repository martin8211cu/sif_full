<cfif isdefined("form.btnGuardar")>
	<cfset ins_Personas = structnew() >
	
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("DATO_", i) NEQ 0>
			<cfset structinsert(ins_Personas, i, Mid(i, 6, Len(i))) >
		

<!--- 			<cfquery name="UpdCalificacionesAreas" datasource="#session.DSN#">
				update RHCalificaAreaConcursante 
				set RHCAONota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.peso_'&linea)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHCAOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.RHCAOid_'&linea)#">
			</cfquery> --->
		</cfif>
	</cfloop>

<cfdump var="#ins_Personas#">
<cfdump var="#form#">


<cfabort>


	<cfset instancia = CreateObject("Component", "/home/tramites/componentes/tramites")>
	<cfset id_instancia = instancia.obtener_instancia(form.id_persona, form.id_tramite) >

	<!--- Estructura para manejo de existencia de instancias de requisito y de expediente --->
	<cfset ins_requisito = structnew() >
	<cfset exp_requisito = structnew() >
	<cfif len(trim(form.id_requisito))>
	<cfdump var="#form.id_requisito#">
		<cfloop list="#form.id_requisito#" index="i">
			<cfquery name="instancia_req" datasource="#session.tramites.dsn#">
				select id_instancia, id_expediente
				from TPInstanciaRequisito
				where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_instancia#" >
				  and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				  and completado = 0
			</cfquery>

			<cfquery name="existe" datasource="#session.tramites.dsn#">
				select id_expediente
				from TPExpediente
				where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
				and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
			</cfquery>
			<!--- Ya existe el expediente, solo modificar el dato --->
			<cfset expediente = '' >
			<cfif existe.recordcount gt 0 >
				<cfset expediente = existe.id_expediente >
			<cfelse>
				<cftransaction>
				<cfquery name="existe" datasource="#session.tramites.dsn#">
					insert into TPExpediente(id_persona, id_requisito, cap_funcionario, cap_ventanilla, cap_fecha, monto_pagado, BMUsucodigo, BMfechamod, revisado)
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_funcionario#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_ventanilla#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							0 )
					<cf_dbidentity1 datasource="#session.tramites.dsn#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.tramites.dsn#" name="existe">
				<cfset expediente = existe.identity >
				</cftransaction>
			</cfif>

			<cfset structinsert(ins_requisito, i, instancia_req.id_instancia) >
			<cfset structinsert(exp_requisito, i, expediente ) >
		
			<cfquery datasource="#session.tramites.dsn#">
				update TPInstanciaRequisito
				set completado = <cfqueryparam cfsqltype="cf_sql_bit" value="#isdefined('form.completado_'&i)#">
				where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_instancia#">
				and id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
			</cfquery>
		</cfloop>
		
		<!--- Insert/Update de datos --->
		<cfloop list="#form.id_dato#" index="i">
			<cfset requisito = form['id_requisito_#i#'] >
			<cfdump var="#exp_requisito#">
			<cfquery name="tipo" datasource="#session.tramites.dsn#">
				select tipo_dato
				from TPDatoRequisito
				where id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>
			<cfquery name="existe" datasource="#session.tramites.dsn#">
				select 	dr.id_dato, 
						dr.id_requisito, 
						( select de.id_expediente
						  from TPDatoExpediente de
				
						 inner join TPExpediente e
						 on e.id_expediente = de.id_expediente
						 and e.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#"> 
						 and e.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#requisito#">
						 <!---and e.id_expediente = 51--->
						 where de.id_dato = dr.id_dato ) as id_expediente
				from TPDatoRequisito dr
				
				where dr.id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>

<!---
PERSONA: <cfdump var="#form.id_persona#"><br>
REQUISITO: <cfdump var="#requisito#"><br>
EXPEDIENTE: <cfdump var="#exp_requisito['#requisito#']#"><br>
DATO: <cfdump var="#i#"><br>
			<cfabort>
--->			
			
			<cfif len(trim(existe.id_expediente)) >
				<cfquery datasource="#session.tramites.dsn#">
					update TPDatoExpediente
					
					<cfif tipo.tipo_dato eq 'B'>
						set valor = <cfif isdefined("form.dato_#i#")>'1'<cfelse>'0'</cfif>
					<cfelse>
						set valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['dato_#i#']#">
					</cfif>
					
					where id_dato = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
					and id_expediente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existe.id_expediente#">
				</cfquery>
			<cfelse>
				<cfquery datasource="#session.tramites.dsn#">
					insert into TPDatoExpediente( id_dato, id_expediente, valor, BMUsucodigo, BMfechamod )
					values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#exp_requisito['#existe.id_requisito#']#">,
							<cfif tipo.tipo_dato eq 'B'>
								<cfif isdefined("form.dato_#i#")>'1'<cfelse>'0'</cfif>,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['dato_#i#']#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfif>	

<!--- <cfquery name="id" datasource="#session.tramites.dsn#">
	select identificacion_persona, id_tipoident
	from TPPersona
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
</cfquery> --->

<cfset params="">
<cfoutput>
	<cfif isdefined('form.RHRCfdesde') and form.RHRCfdesde NEQ ''>
		<cfif params EQ ''>
			<cfset params = "?RHRCfdesde=#form.RHRCfdesde#">
		<cfelse>
			<cfset params = params & "&RHRCfdesde=#form.RHRCfdesde#">
		</cfif>
	</cfif>
	<cfif isdefined('form.id_requisito') and form.id_requisito NEQ ''>
		<cfif params EQ ''>
			<cfset params = "?id_requisito=#form.id_requisito#">
		<cfelse>
			<cfset params = params & "&id_requisito=#form.id_requisito#">
		</cfif>
	</cfif>
	<cfif isdefined('form.id_agenda') and form.id_agenda NEQ ''>
		<cfif params EQ ''>
			<cfset params = "?id_agenda=#form.id_agenda#">
		<cfelse>
			<cfset params = params & "&id_agenda=#form.id_agenda#">
		</cfif>
	</cfif>			
</cfoutput>

<cflocation url="/cfmx/home/tramites/Operacion/expediente/reg_agenda-form.cfm#params#">
