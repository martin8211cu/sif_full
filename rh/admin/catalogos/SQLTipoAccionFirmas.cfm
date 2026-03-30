<cfinvoke component="sif.Componentes.Translate"	
method="Translate"	
Key="La_informacion_ya_fue_registrada"	
Default="La informaci&oacute;n ya fue registrada"
returnvariable="MG_YaExiste"/>

<cfparam name="action" default="TipoAccionFirmas.cfm">
<cfparam name="modo" default="ALTA">


<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js">
<cfif not isdefined("form.btnNuevo")>
	<!--- Agregar Firma al Tipo de Acción --->
	<cfif isdefined("form.Alta") >
		<cfset Paso = 1 >

		<cfquery name="rsVerifica" datasource="#session.DSN#">
			Select * 
				from RHFirmasAccion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
					and  RHTid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#"> 
					and RHFtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHFtipo#">
					<cfif form.RHFtipo EQ 1 >
						and RHFautorizador = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHFautorizador#">
					</cfif> 
					<cfif form.RHFtipo EQ 2 >
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
					</cfif> 
					<cfif form.RHFtipo EQ 5 >
						and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
					</cfif>
			</cfquery> 
			<cfif isdefined("rsVerifica") and rsVerifica.RecordCount eq 0>
				<cfquery datasource="#session.DSN#">
						insert into RHFirmasAccion (
												RHTid,
												Ecodigo,
												RHFtipo,
												RHFautorizador,
												DEid,
												CFid,
												RHFOrden,
												BMusumod)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHFtipo#">,
							
							<cfif isdefined('form.RHFautorizador') and LEN(TRIM(form.RHFautorizador))>
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHFautorizador#">,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined('form.CFid') and LEN(TRIM(form.CFid))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
							<cfelse>
								null,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHFOrden#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
				</cfquery>
			<cfelse>	
				<cf_throw message="#MG_YaExiste#" errorcode="2145">
			</cfif>
			

		
	<cfelseif isdefined("form.Cambio")>
		<!--- modifica Firma al Tipo de Acción --->
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHFirmasAccion"
			redirect="ipoAccionFirmas.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHFid" 
			type1="numeric" 
			value1="#form.RHFid#">
		<cfquery name="ABC_ConceptosExp" datasource="#Session.DSN#">
			<!--- Cambio del encabezado --->				
			update RHFirmasAccion set 
				RHFtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHFtipo#">,
				<cfif isdefined('form.RHFautorizador') and LEN(TRIM(form.RHFautorizador)) and  Form.RHFtipo  eq 1>
					RHFautorizador = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHFautorizador#">,
				<cfelse>
					RHFautorizador =null,
				</cfif>
				<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid)) and  Form.RHFtipo  eq 2>
					DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
				<cfelse>
					DEid = null,
				</cfif>
				<cfif isdefined('form.CFid') and LEN(TRIM(form.CFid)) and  Form.RHFtipo  eq 5>
					CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
				<cfelse>
					CFid = null,
				</cfif>
				RHFOrden = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHFOrden#">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			 and RHFid =  <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
		</cfquery>	
		<cfset modo = 'CAMBIO'>
	<!--- Borrar una firma del tipo de la acción --->
	<cfelseif isdefined("form.Baja")>

			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="RHFirmasAccion">		
						<cfinvokeargument name="nombreCampo" value="BMusumod">
						<cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo# and RHFid = #form.RHFid#">
			</cfinvoke>
			<cfquery datasource="#session.DSN#">
				delete from RHFirmasAccion
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHFid =  <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo = 'ALTA'>
	</cfif>
	</cfif>	
	<cfset args="">
	<cfif isdefined('modo') and LEN(TRIM(modo))>
	<cfset args = args & "?modo=#modo#&RHTid=#form.RHTid#">
	</cfif>
	<cfif modo eq 'CAMBIO'>
		<cfset args = args & "&RHFid=#form.RHFid#">
	</cfif>
	<cfif isdefined('form.PageNum') and LEN(TRIM(form.PageNum))>
		<cfset args = args & "&PageNum=#form.PageNum#">	
	</cfif>
	<cflocation url="#action##args#">
	
