<cffunction name="FuncCopiar">
	<cfargument name="REidOrigen" required="yes" type="numeric">
	<cfargument name="REiddestino" required="yes" type="numeric">
	<!--- Indicaciones ----->
	
	<cfquery  name="RS_RHRegistroEvaluacion" datasource="#session.DSN#">
		select REindicaciones  from  RHRegistroEvaluacion
		where REid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REidOrigen#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update RHRegistroEvaluacion set 
			REindicaciones = '#RS_RHRegistroEvaluacion.REindicaciones#'
		where REid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REiddestino#">
	</cfquery>
	<!--- Conceptos ----->
	<cfquery datasource="#session.DSN#">
		insert into RHIndicadoresRegistroE(	Ecodigo, 
											REid, 
											IAEid, 
											TEcodigo, 
											IREsobrecien, 
											IREpesop, 
											IREpesojefe,
											IREevaluajefe, 
											IREevaluasubjefe, 
											BMfechaalta, 
											BMUsucodigo)											
		select 	a.Ecodigo, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REiddestino#">,
				a.IAEid, 
				a.TEcodigo, 
				a.IREsobrecien, 
				a.IREpesop, 
				a.IREpesojefe,
				a.IREevaluajefe, 
				a.IREevaluasubjefe, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		from RHIndicadoresRegistroE a
		where a.REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REidorigen#">
		  and not exists ( select 1
		  				   from RHIndicadoresRegistroE
						   where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REiddestino#">
						     and IAEid = a.IAEid )
	</cfquery>
	<!--- Grupos --->
	<cfquery name="rsGrupos" datasource="#session.DSN#">
		select 	GREid,
				GREnombre
		from RHGruposRegistroE
		where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REidorigen#">			
	</cfquery>
	<cfloop query="rsGrupos">
		<!----Inserta grupo----->
		<cfquery name="insertGrupos" datasource="#session.DSN#">
			insert into RHGruposRegistroE(REid, GREnombre, Ecodigo, BMfechaalta, BMUsucodigo)
			values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.REiddestino#">,
					<cfif len(trim(rsGrupos.GREnombre))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsGrupos.GREnombre#">,
					<cfelse>
						null,
					</cfif> 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
			<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertGrupos" verificar_transaccion="false">
		<cfif len(trim(insertGrupos.identity))>
			<!---Inserta cfuncionales de c/grupo---->
			<cfquery datasource="#session.DSN#">
				insert into RHCFGruposRegistroE(GREid, CFid, Ecodigo, BMfechaalta, BMUsucodigo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertGrupos.identity#">,
						CFid, 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				from RHCFGruposRegistroE a						
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.GREid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrupos.GREid#">
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cfset params = '' >
	<cfif isdefined("form.Alta")>
		<cftransaction>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHRegistroEvaluacion(	Ecodigo, 
												TEcodigo, 
												REdescripcion, 
												REdesde, 
												REhasta, 
												REdias, 
												REevaluacionbase, 
												REaplicajefe, 
												REaplicaempleado, 
												REavisara, 
												REestado, 
												BMfechaalta, 
												BMUsucodigo )
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#len(trim(form.TEcodigo)) eq 0#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.REdescripcion#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedatetime(form.REdesde)#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.REhasta)#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.REdias#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REevaluacionbase#" null="#len(trim(form.REevaluacionbase)) eq 0#">
				
				,<cfif isdefined("form.REaplicajefe")>1<cfelse>0</cfif>
				,<cfif isdefined("form.REaplicaempleado")>1<cfelse>0</cfif>

				, <cfif isdefined("form.REavisara") and len(trim(form.REavisara))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REavisara#" null="#len(trim(form.REavisara)) eq 0#"><cfelse>0</cfif>
				, 0
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">				
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<cfset params = '?REid=#insert.identity#'>
		
		<cfif len(trim(form.REevaluacionbase)) and len(trim(insert.identity))>
			<cfset FuncCopiar(form.REevaluacionbase, insert.identity)>
		</cfif>		
		</cftransaction>
		
	<cfelseif isdefined("form.Cambio")>
		<cfquery datasource="#Session.DSN#">
			update RHRegistroEvaluacion
			set	TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#len(trim(form.TEcodigo)) eq 0#">,
				REdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.REdescripcion#">,
				REdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedatetime(form.REdesde)#">,
				REhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.REhasta)#">,
				REdias = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.REdias#">,
				REevaluacionbase = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REevaluacionbase#" null="#len(trim(form.REevaluacionbase)) eq 0#">,
				<cfif form.Estado NEQ 1>
				REaplicajefe = <cfif isdefined("form.REaplicajefe")>1<cfelse>0</cfif>,
				REaplicaempleado = <cfif isdefined("form.REaplicaempleado")>1<cfelse>0</cfif>,
				</cfif>
				REavisara = <cfif isdefined("form.REavisara") and len(trim(form.REavisara))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REavisara#" null="#len(trim(form.REavisara)) eq 0#"><cfelse>0</cfif>
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
		</cfquery>
		<cfif not isdefined("form.REaplicajefe") and form.Estado NEQ 1>
			<!----Actualizar los DEidjefe cuando se quita el check ---->		
			<cfquery datasource="#session.DSN#">
				update RHEmpleadoRegistroE
					set DEidjefe = null
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
			</cfquery>
		</cfif>
		<!----============== La copia es válida solo en modo alta ==============
		<cfif trim(form.REevaluacionbase) neq trim(form._REevaluacionbase) and len(trim(form.REevaluacionbase)) >
			<cfset FuncCopiar(form.REevaluacionbase, form.REid)>
		</cfif>
		---->
		<cfset params = '?REid=#form.REid#'>
		<cfset params = params & '&Estado=#form.Estado#'>

	<cfelseif isdefined("form.Baja")>
		<cfquery datasource="#Session.DSN#">
			delete from RHIndicadoresRegistroE		
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from RHConceptosDelEvaluador		
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from RHRegistroEvaluadoresE		
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfquery datasource="#Session.DSN#">
			delete from RHRegistroEvaluacion		
			where REid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.REid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cflocation url="registro_evaluacion.cfm">
	</cfif>

<cflocation url="registro_evaluacion.cfm#params#">
