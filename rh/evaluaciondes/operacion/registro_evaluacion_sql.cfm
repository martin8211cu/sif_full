<cfset params = "">
<cfset modoreturn = "ALTA">
<cfif isdefined("url.params") and not isdefined("form.params") and len(trim(url.params)) gt 0><cfset form.params = url.params></cfif>
<cfif isdefined("form.params") and len(trim(form.params)) gt 0><cfset params = form.params></cfif>
<!--- Los valores estado y tipo eval pueden ser actualizados individualmente por get --->
<cfif isdefined("url.UpdEstado") and not isdefined("form.UpdEstado") and len(trim(url.UpdEstado)) gt 0><cfset form.UpdEstado = url.UpdEstado></cfif>
<cfif isdefined("url.RHEEid") and not isdefined("form.RHEEid") and len(trim(url.RHEEid)) gt 0><cfset form.RHEEid = url.RHEEid></cfif>
<cfif isdefined("url.ts_rversion") and not isdefined("form.ts_rversion") and len(trim(url.ts_rversion)) gt 0><cfset form.ts_rversion = url.ts_rversion></cfif>
<cfif isdefined("url.RHEEestado") and not isdefined("form.RHEEestado") and len(trim(url.RHEEestado)) gt 0><cfset form.RHEEestado = url.RHEEestado></cfif>
<!--- Los demás valores solo son actualizados por post --->
<cfparam name="form.RHEEid" default="-1" type="numeric">
<cfparam name="form.RHEEfdesde" default="#LSDateFormat(Now())#" type="string">
<cfif isdefined("form.RHEEfhasta") and len(trim(form.RHEEfhasta)) eq 0><cfset form.RHEEfhasta = "01/01/6100"></cfif>
<cfparam name="form.RHEEfhasta" default="#LSDateFormat(Now())#" type="string">
<cfparam name="form.RHEEestado" default="0" type="numeric"><!--- 0 = En Proceso, 1 = Asignando Empleados, 2 = Lista ---><!--- TIENE MÉTODO PROPIO --->
<cfparam name="form.RHEEtipoeval" default="1" type="string"><!--- 1 = Porcentaje, 2 = Puntaje, T = Tabla ---><!--- TIENE MÉTODO PROPIO --->
<cfparam name="form.TEcodigo" default="-1" type="numeric">
<cfif isdefined("form.Alta") or isdefined("form.Cambio")><!--- Requeridos en estas acciones --->
	<!--- <cfparam name="form.RHPcodigo" type="string"> --->
	<cfparam name="form.RHEEdescripcion" type="string">
</cfif>

<cftransaction>
	<cfif isdefined("form.Alta")>
		<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
			insert into RHEEvaluacionDes (Ecodigo, Usucodigo, RHEEdescripcion, RHEEfecha, RHEEfdesde, RHEEfhasta, RHEEestado, RHEEtipoeval, TEcodigo, PCid,
										RHEEMostrarTitulo,Aplica,AplicaPara,CFid,Porc_dist)
			values(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEdescripcion#">
				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHEEfdesde)#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.RHEEfhasta)#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEestado#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHEEtipoeval#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#(form.TEcodigo lte 0) or (form.RHEEtipoeval neq 'T')#">
				<!--- <cfif isdefined("form.PCid") and len(trim(form.PCid)) and form.PCid EQ 'N'>
					,null
				<cfelseif isdefined("form.PCid") and len(trim(form.PCid)) and form.PCid NEQ 'N'> --->
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
				<!--- </cfif> 	 --->
				,<cfif isdefined("form.RHEEMostrarTitulo")>'S'<cfelse>'N'</cfif>
				,<cfif isdefined("form.Aplica")>#form.Aplica#<cfelse>null</cfif>
				,<cfif isdefined("form.AplicaPara")>#form.AplicaPara#<cfelse>2</cfif><!--- por defecto colaboradores---->
				,<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>#form.CFid#<cfelse>null</cfif>
				,<cfif isdefined("form.porc") and len(trim(form.porc)) gt 0>#form.porc#<cfelse>null</cfif>
			)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 name="ABC_Evaluacion" datasource="#Session.DSN#" returnvariable="LvarRHEEid">
		<cfset modoreturn = "CAMBIO">

	<cfelseif isdefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHEEvaluacionDes"
			redirect="registro_evaluacion.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHEEid"
			type1="numeric"
			value1="#form.RHEEid#"
			>		
		<cfquery name="SituacionEvaluacion" datasource="#Session.DSN#">
        		Select RHEEestado as Estado
                from RHEEvaluacionDes
                Where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
                    
		<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
			update RHEEvaluacionDes
			set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, RHEEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEdescripcion#">
				, RHEEfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.RHEEfdesde)#">
				, RHEEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(form.RHEEfhasta)#">
                <!--- Evita que se modifique el Cuestionario de Una Evaluacion Habilitada --->
		        <cfif  SituacionEvaluacion.Recordcount GT 0 and SituacionEvaluacion.Estado NEQ 2>                
					, RHEEestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHEEestado#">	
					,PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">                    
					, RHEEtipoeval = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHEEtipoeval#">                    
					,CFid=<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>#form.CFid#<cfelse>null</cfif>
					,Porc_dist=<cfif isdefined("form.porc") and len(trim(form.porc)) gt 0>#form.porc#<cfelse>null</cfif>
					,Aplica=<cfif isdefined("form.Aplica")>#form.Aplica#<cfelse>null</cfif>
					,AplicaPara=<cfif isdefined("form.AplicaPara")>#form.AplicaPara#<cfelse>null</cfif><!--- por defecto colaboradores---->
					, TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#(form.TEcodigo lte 0) or (form.RHEEtipoeval neq 'T')#">                    
                 </cfif>
				<cfif isdefined("form.RHEEMostrarTitulo")>
					,RHEEMostrarTitulo ='S'
				<cfelse>
					,RHEEMostrarTitulo ='N'
				</cfif>
				, TEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEcodigo#" null="#(form.TEcodigo lte 0) or (form.RHEEtipoeval neq 'T')#">
				,PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
				,Aplica=<cfif isdefined("form.Aplica")>#form.Aplica#<cfelse>null</cfif>
				,CFid=<cfif isdefined("form.CFid") and len(trim(form.CFid)) gt 0>#form.CFid#<cfelse>null</cfif>
				,Porc_dist=<cfif isdefined("form.porc") and len(trim(form.porc)) gt 0>#form.porc#<cfelse>null</cfif>
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modoreturn = "CAMBIO">

	<cfelseif isdefined("form.Baja")>
		<cfquery name="rs_existe" datasource="#Session.DSN#">
			select RHEEid from RHDEvaluacionDes
				where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif rs_existe.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_MensajeDeError"
				Default="Esta relaci&oacute;n no puede ser eliminada, ya fue evaluada por al menos un evaluador, en este caso no es permitido eliminarla"
				returnvariable="LB_MensajeDeError"/>
			<cf_throw message="#LB_MensajeDeError#" errorcode="8010">
		<cfelse>
			<cfquery name="rs_estado" datasource="#Session.DSN#">
				select RHEEestado from RHEEvaluacionDes
				where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
				and RHEEestado <= 2
			</cfquery>
			<cfif rs_existe.recordCount GT 0>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_MensajeDeError2"
					Default="Esta relaci&oacute;n no puede ser eliminada, el estado de la transacción es inv&aacute;lido para eliminarla."
					returnvariable="LB_MensajeDeError"/>
				<cf_throw message="#LB_MensajeDeError2#" errorcode="8020">
			<cfelse>
				<cfquery  datasource="#Session.DSN#">
					delete from RHNotasEvalDes
					where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery  datasource="#Session.DSN#">
					delete from RHEvaluadoresDes
					where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery  datasource="#Session.DSN#">
					delete from RHListaEvalDes
					where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery  datasource="#Session.DSN#">
					delete from RHEEvaluacionDes
					where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>
		</cfif>
		<cfset modoreturn = "ALTA">
	<cfelseif isdefined("form.UpdEstado")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHEEvaluacionDes"
			redirect="registro_evaluacion.cfm"
			timestamp="#form.ts_rversion#"
			field1="RHEEid"
			type1="numeric"
			value1="#form.RHEEid#"
			>
		<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
			Update RHEEvaluacionDes
			set RHEEestado = <cfqueryparam value="#form.RHEEestado#" cfsqltype="cf_sql_integer">
			where RHEEid = <cfqueryparam value="#form.RHEEid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modoreturn = "ALTA">
	</cfif>
</cftransaction>
<cfif modoreturn eq "CAMBIO">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=CAMBIO">
	<cfif isdefined("LvarRHEEid") and len(trim(LvarRHEEid)) gt 0>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHEEid="  &  LvarRHEEid>
	<cfelseif isdefined("form.RHEEid") and len(trim(form.RHEEid)) gt 0 and form.RHEEid neq -1>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHEEid="  &  form.RHEEid>
	</cfif>
<cfelseif isdefined("form.Nuevo")>
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=ALTA">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "btnNuevo=Nuevo">
</cfif>
<cflocation url="registro_evaluacion.cfm#params#">
