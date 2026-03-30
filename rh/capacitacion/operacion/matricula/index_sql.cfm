<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_Esta_matrícula_no_se_puede_eliminar_Debe_aplicarla_o_rechazarla"
	Default="Esta matrícula no se puede eliminar.  Debe aplicarla o rechazarla."
	returnvariable="MG_Esta_matrícula_no_se_puede_eliminar_Debe_aplicarla_o_rechazarla"/>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_Esta_matrícula_no_se_puede_eliminar_ya_fue_procesada"
	Default="Esta matrícula no se puede eliminar ya fue procesada"
	returnvariable="MG_Esta_matrícula_no_se_puede_eliminar_ya_fue_procesada"/>

<cfset params = "">
<cfset modoreturn = "ALTA">
<cfif isdefined("url.params") and not isdefined("form.params") and len(trim(url.params)) gt 0><cfset form.params = url.params></cfif>
<cfif isdefined("form.params") and len(trim(form.params)) gt 0><cfset params = form.params></cfif>
<!--- Los valores estado y tipo eval pueden ser actualizados individualmente por get --->
<cfif isdefined("url.UpdEstado") and not isdefined("form.UpdEstado") and len(trim(url.UpdEstado)) gt 0><cfset form.UpdEstado = url.UpdEstado></cfif>
<cfif isdefined("url.RHRCid") and not isdefined("form.RHRCid") and len(trim(url.RHRCid)) gt 0><cfset form.RHRCid = url.RHRCid></cfif>
<cfif isdefined("url.ts_rversion") and not isdefined("form.ts_rversion") and len(trim(url.ts_rversion)) gt 0><cfset form.ts_rversion = url.ts_rversion></cfif>
<cfif isdefined("url.RHRCestado") and not isdefined("form.RHRCestado") and len(trim(url.RHRCestado)) gt 0><cfset form.RHRCestado = url.RHRCestado></cfif>
<!--- Los demás valores solo son actualizados por post --->
<cfparam name="form.RHRCid" default="-1" type="numeric">
<cfparam name="form.RHRCfecha" default="#LSDateFormat(Now())#" type="string">
<cfif isdefined("form.RHEEfhasta") and len(trim(form.RHEEfhasta)) eq 0><cfset form.RHEEfhasta = "01/01/6100"></cfif>

<cfparam name="form.RHEEfhasta" default="#LSDateFormat(Now())#" type="date">

<cfparam name="form.RHRCestado" default="0" type="numeric"><!--- 0 = En Proceso, 1 = Asignando Empleados, 2 = Lista ---><!--- TIENE MÉTODO PROPIO --->
<cfparam name="form.RHEEtipoeval" default="1" type="string"><!--- 1 = Porcentaje, 2 = Puntaje, T = Tabla ---><!--- TIENE MÉTODO PROPIO --->
<cfparam name="form.TEcodigo" default="-1" type="numeric">
<cfparam name="form.Mcodigo" default="">
<cfparam name="form.RHCid" default="">
<cfif isdefined("form.Alta") or isdefined("form.Cambio")><!--- Requeridos en estas acciones --->
	<!--- <cfparam name="form.RHPcodigo" type="string"> --->
	<cfparam name="form.RHRCdescripcion" type="string">
</cfif>

	<cfif isdefined("form.Alta")>
		<!---
			averiguar quién soy, pero hacerlo fuera de la transacción
		--->
		<cfinvoke component="home.Componentes.Seguridad" returnvariable="datosemp"
			method="getUsuarioByCod" tabla="DatosEmpleado"
			Usucodigo="#session.Usucodigo#" Ecodigo="#session.EcodigoSDC#"
			/>
		<cfif datosemp.RecordCount and Len(datosemp.llave)>
			<cfquery datasource="#session.dsn#" name="empleado">
				select lt.DEid, p.CFid
				from LineaTiempo lt
					join RHPlazas p
						on p.RHPid = lt.RHPid
						and p.Ecodigo = lt.Ecodigo
				where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between lt.LTdesde and lt.LThasta
				  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datosemp.llave#">
			</cfquery>
		</cfif>
	</cfif>
<cftransaction>
	<cfif isdefined("form.Alta")>
		<cfif not isdefined('empleado') or empleado.RecordCount lte 0>
			<cfset DEid = 0>
			<cfset CFid = 0>
		<cfelse>
			<cfset DEid = empleado.DEid>
			<cfset CFid = empleado.CFid>
		</cfif>


		<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
			insert into RHRelacionCap (Mcodigo, RHCid, RHRCdescripcion, Ecodigo,
				Usucodigosol, DEidsol, CFidsol, RHRCjustificacion,
				RHRCfecha, RHRCestado, BMfecha, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRCdescripcion#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#CFid#">
				, <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHRCjustificacion#">

				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHRCfecha)#">
				, 30 <!--- 30=revision administrativa --->
				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="ABC_Evaluacion">
		<cfset modoreturn = "CAMBIO">

	<cfelseif isdefined("form.Cambio")>
		<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
			update RHRelacionCap
			set Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" null="#Len(form.Mcodigo) Is 0#">,
			    RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#" null="#Len(form.RHCid) Is 0#">,
				RHRCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRCdescripcion#">,
			    RHRCjustificacion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHRCjustificacion#">,
			    RHRCfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHRCfecha)#">,
			    BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
		</cfquery>
		<cfset modoreturn = "CAMBIO">

	<cfelseif isdefined("form.Baja")>
		<cfquery datasource="#session.dsn#" name="estado">
			select RHRCestado
			from RHRelacionCap
			where RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif estado.RecordCount>
			<cfif ListFind('0,30', estado.RHRCestado)>
				<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
					delete from RHDRelacionCap
					where RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
					delete from RHRelacionCap
					where RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			<cfelseif estado.RHRCestado eq '10'>
				<cf_throw message="#MG_Esta_matrícula_no_se_puede_eliminar_Debe_aplicarla_o_rechazarla#" errorcode="10055">
			<cfelse>
				<cf_throw message="#MG_Esta_matrícula_no_se_puede_eliminar_ya_fue_procesada#" errorcode="10060">
			</cfif>
		</cfif>
		<cfset modoreturn = "ALTA">
	<cfelseif isdefined("form.UpdEstado")>
		<cfquery name="ABC_Evaluacion" datasource="#Session.DSN#">
			update RHRelacionCap
			set RHRCestado = <cfqueryparam value="#form.RHRCestado#" cfsqltype="cf_sql_integer">
			where RHRCid = <cfqueryparam value="#form.RHRCid#" cfsqltype="cf_sql_numeric">
			and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
		</cfquery>
		<cfset modoreturn = "ALTA">

	</cfif>
</cftransaction>

<cfif modoreturn eq "CAMBIO">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=CAMBIO">
	<cfif isdefined("ABC_Evaluacion.identity") and len(trim(ABC_Evaluacion.identity)) gt 0>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHRCid="  &  ABC_Evaluacion.identity>
	<cfelseif isdefined("form.RHRCid") and len(trim(form.RHRCid)) gt 0 and form.RHRCid neq -1>
		<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "RHRCid="  &  form.RHRCid>
	</cfif>
<cfelseif isdefined("form.Nuevo")>
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "modo=ALTA">
	<cfset params = params  &  iif(len(trim(params)) gt 0,DE('&'),DE('?'))  &  "btnNuevo=Nuevo">
</cfif>
<cflocation url="index.cfm#params#">
