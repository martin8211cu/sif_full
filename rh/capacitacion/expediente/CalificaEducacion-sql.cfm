<cfset modoCalifEdu = "ALTA">
<cfset params = ''>
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsVerificaUltima" datasource="#session.DSN#">
			select 1
			from RHEmpleadoCalificaEd
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHECEaplicada = 0
		</cfquery>
		
		<cfif not rsVerificaUltima.RecordCount>
			<cfquery name="insertCalificacion" datasource="#session.DSN#">
				insert into RHEmpleadoCalificaEd(DEid, Ecodigo, RHCEDid, RHECEnota, RHECEfdesde, RHECEaplicada, BMUsucodigo, BMfechaalta)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEDid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECEnota#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">				
				)
			</cfquery>
		<cfelse>
			<cfinvoke key="MSG_Error" default="Ya existe un registro de nota sin aplicar." returnvariable="MSG_Error" component="sif.Componentes.Translate" method="Translate"/>
			<cf_throw message="#MSG_Error#" errorcode="10025">
		</cfif>
	<cfelseif isdefined('form.Baja')>
		<cfquery name="deleteCalificacion" datasource="#session.DSN#">
			delete from RHEmpleadoCalificaEd
			where RHECEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHECEid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	<cfelseif isdefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHEmpleadoCalificaEd"
			redirect="educacion.cfm"
			timestamp="#form.ts_rversion#"				
			field1="Ecodigo" type1="integer" value1="#session.Ecodigo#"
			field2="RHECEid"  type2="numeric" value2="#form.RHECEid#">
		<cfquery name="updateCalificacion" datasource="#session.DSN#">
			update RHEmpleadoCalificaEd
			set RHCEDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCEDid#">,
				RHECEnota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECEnota#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				BMfechaalta = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where RHECEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHECEid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modoCalifEdu = "CAMBIO">
	<cfelseif isdefined('form.Aplicar')>
		<!--- MODIFICA EL ESTADO DE LA CALIFICACION, SI YA EXISTE UNA CALIFICACIÓN PREVIA, ENTONCES LE ACTUALIZA EL ESTADO Y LA FECHA HASTA --->
		<!--- BUSCAR EL ULTIMO REGISTRO DE CALIFICACIO --->
		<cfquery name="rsUltimaCalificacion" datasource="#session.DSN#">
			select RHECEid,RHECEfhasta
			from RHEmpleadoCalificaEd
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHECEaplicada = 1
			  and RHECEfdesde = (select max(RHECEfdesde)
								from RHEmpleadoCalificaEd
								where DEid = RHEmpleadoCalificaEd.DEid
								  and Ecodigo = RHEmpleadoCalificaEd.Ecodigo
								  and RHECEaplicada = 1)
		</cfquery>
		<cfif rsUltimaCalificacion.RecordCount>
			<!--- ACTUALIZA EL REGISTRO ANTERIOR --->
			<cfset Lvar_Fhasta = DateAdd('d',-1,Now())>
			<cfif Lvar_Fhasta LT rsUltimaCalificacion.RHECEfhasta><cfset Lvar_Fhasta = Now()></cfif>
			<cfquery name="UpdateAplica" datasource="#session.DSN#">
				update RHEmpleadoCalificaEd
				set RHECEfhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_Fhasta#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				where RHECEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsUltimaCalificacion.RHECEid#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery> 
		</cfif>
		<cfquery name="UpdateAplica" datasource="#session.DSN#">
			update RHEmpleadoCalificaEd
			set RHECEfdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				RHECEaplicada = 1,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				BMfechaalta = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
			where RHECEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHECEid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery> 
	</cfif>
	</cftransaction>
</cfif>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "modoCalifEdu=" & modoCalifEdu>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "DEid=" & form.DEid>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "tab=" & 4>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "o=" & 3>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "sel=" & 1>
<cfif isdefined("form.Cambio")>
<cfset params = params & iif(len(trim(params)),DE("&"),DE("?")) &  "RHECEid=" & form.RHECEid>
</cfif>
<cflocation url="expediente.cfm#params#">