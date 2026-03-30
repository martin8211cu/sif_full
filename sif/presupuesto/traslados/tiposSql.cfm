<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
		<cfquery name="insConceptos" datasource="#Session.DSN#">			
			insert into CPtipoTraslado (Ecodigo, CPTTcodigo, CPTTdescripcion, CPTTtipo, CPTTaprobacion, CPTTtipoCta)
			values (				
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo# "> , 
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTTcodigo#">)),
				 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPTTdescripcion#">)), 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTTtipo#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Form.CPTTaprobacion)#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Form.CPTTtipoCta)#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="insConceptos">	
		<cfset params=params&"&CPTTid="&insConceptos.identity>	
		</cftransaction>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delConceptos" datasource="#Session.DSN#">
			delete from CPtipoTraslado
			where Ecodigo = <cfqueryparam value="#session.Ecodigo# " cfsqltype="cf_sql_integer">
			  and CPTTid = <cfqueryparam value="#Form.CPTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelseif isdefined("Form.AddValidacion")>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CPTTverificaciones
			  from CPtipoTraslado
			where Ecodigo = <cfqueryparam value="#session.Ecodigo# " cfsqltype="cf_sql_integer">
			  and CPTTid = <cfqueryparam value="#Form.CPTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset LvarVerifica_tipos  = listFirst(rsSQL.CPTTverificaciones,"|")>
		<cfset LvarVerifica_valors = listLast(rsSQL.CPTTverificaciones,"|")>

		<cfparam name="form.CPTTverificacionTipo" type="integer">
		<cfif abs(form.CPTTverificacionTipo) EQ 1 OR abs(form.CPTTverificacionTipo) EQ 2>
			<cfset LvarValor = 0>
		<cfelseif form.CPTTverificacionTipo EQ 3>
			<cfset LvarValor = form.CPTTverificacionValorGO>
		<cfelseif abs(form.CPTTverificacionTipo) EQ 7>
			<cfset LvarValor = form.CPTTverificacionValorGOT>
		<cfelseif form.CPTTverificacionTipo EQ 4>
			<cfset LvarValor = form.CPTTverificacionValorNIV>
		<cfelseif form.CPTTverificacionTipo EQ 5>
			<cfset LvarValor = form.CPTTverificacionValorCAT>
		<cfelseif form.CPTTverificacionTipo EQ 6>
			<cfset LvarValor = form.CPTTverificacionValorCLA>
		<cfelse>
			<cfset LvarValor = "*">
		</cfif>
		
		<cfif trim(LvarValor) EQ "">
			<cfthrow message="Valor para el tipo de Verificación no puede quedar en blanco">
		<cfelseif NOT isnumeric(LvarValor)>
			<cfthrow message="Valor para el tipo de Verificación debe ser numerico #LvarValor#">
		</cfif>
		
		<cfset LvarVerifica_tipos  = listAppend(LvarVerifica_tipos, form.CPTTverificacionTipo)>
		<cfset LvarVerifica_valors  = listAppend(LvarVerifica_valors, LvarValor)>

		<cfset LvarCPTTverificaciones = LvarVerifica_tipos & "|" & LvarVerifica_valors>
		<cfquery name="updConceptos" datasource="#Session.DSN#">
			update CPtipoTraslado set 
				CPTTverificaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCPTTverificaciones#">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo# " cfsqltype="cf_sql_integer">
			  and CPTTid = <cfqueryparam value="#Form.CPTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelseif isdefined("url.delValidacion")>
		<cfset form.pagina = url.pagina>
		<cfset form.CPTTid = url.CPTTid>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select CPTTverificaciones
			  from CPtipoTraslado
			where Ecodigo = <cfqueryparam value="#session.Ecodigo# " cfsqltype="cf_sql_integer">
			  and CPTTid = <cfqueryparam value="#url.CPTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset LvarVerifica_tipos  = listFirst(rsSQL.CPTTverificaciones,"|")>
		<cfset LvarVerifica_valors = listLast(rsSQL.CPTTverificaciones,"|")>

		<cfset LvarVerifica_tipos  = listDeleteAt(LvarVerifica_tipos, url.r)>
		<cfset LvarVerifica_valors  = listDeleteAt(LvarVerifica_valors, url.r)>

		<cfset LvarCPTTverificaciones = LvarVerifica_tipos & "|" & LvarVerifica_valors>
		<cfquery name="updConceptos" datasource="#Session.DSN#">
			update CPtipoTraslado set 
				CPTTverificaciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCPTTverificaciones#">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo# " cfsqltype="cf_sql_integer">
			  and CPTTid = <cfqueryparam value="#url.CPTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPtipoTraslado" 
			redirect="tipos.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#session.Ecodigo# "
			field2="CPTTid,numeric,#form.CPTTid#">

		<cfset LvarCPTTverificaciones = "">
		
		<cfset LvarCPTTtramites = "">
		<cfif Form.CPTTaprobacion EQ 1 and isdefined("form.CPTTtramites")>
			<cfset LvarCPTTtramites = form.CPTTtramites>
		<cfelseif Form.CPTTaprobacion EQ 1 and isdefined("form.CPTTtramites_trms")>
			<cfset LvarID_tramite = listFirst(form.CPTTtramites_trms)>
		<cfelseif Form.CPTTaprobacion EQ 2 and isdefined("form.CPTTtramites_ofis") and isdefined("form.CPTTtramites_trms")>
			<cfset LvarTramites1 = "">
			<cfset LvarTramites2 = "">
			<cfset LvarTramites_ofis = listToArray(form.CPTTtramites_ofis)>
			<cfset LvarTramites_trms = listToArray(form.CPTTtramites_trms)>
			<cfloop index="i" from="1" to="#arrayLen(LvarTramites_ofis)#">
				<cfif LvarTramites_trms[i] NEQ 0>
					<cfset LvarTramites1 = listAppend(LvarTramites1, LvarTramites_ofis[i])>
					<cfset LvarTramites2 = listAppend(LvarTramites2, LvarTramites_trms[i])>
				</cfif>
			</cfloop>
			<cfset LvarCPTTtramites = LvarTramites1 & "|" & LvarTramites2>
		</cfif>
		<cfquery name="updConceptos" datasource="#Session.DSN#">
			update CPtipoTraslado set 
				CPTTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTTcodigo#">,
				CPTTdescripcion=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPTTdescripcion#">, 
				CPTTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTTtipo#">,
				CPTTaprobacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Form.CPTTaprobacion)#">,
				CPTTtramites = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCPTTtramites#">,
				CPTTtipoCta=<cfqueryparam cfsqltype="cf_sql_integer" value="#trim(Form.CPTTtipoCta)#">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo# " cfsqltype="cf_sql_integer">
			  and CPTTid = <cfqueryparam value="#Form.CPTTid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>
</cfif>

<cfif not isdefined('form.Nuevo') and not isdefined('form.Baja') >
	<cfif isdefined('form.CPTTid') and form.CPTTid NEQ ''>
		<cfset params= params&'&CPTTid='&form.CPTTid>	
	</cfif>
</cfif>
<cfif isdefined('form.filtro_CPTTcodigo') and form.filtro_CPTTcodigo NEQ ''>
	<cfset params= params&'&filtro_CPTTcodigo='&form.filtro_CPTTcodigo>	
	<cfset params= params&'&hfiltro_CPTTcodigo='&form.filtro_CPTTcodigo>		
</cfif>
<cfif isdefined('form.filtro_CPTTdescripcion') and form.filtro_CPTTdescripcion NEQ ''>
	<cfset params= params&'&filtro_CPTTdescripcion='&form.filtro_CPTTdescripcion>	
	<cfset params= params&'&hfiltro_CPTTdescripcion='&form.filtro_CPTTdescripcion>		
</cfif>
<cfif isdefined('form.filtro_CPTTtipo') and form.filtro_CPTTtipo NEQ ''>
	<cfset params= params&'&filtro_CPTTtipo='&form.filtro_CPTTtipo>	
	<cfset params= params&'&hfTipo='&form.filtro_CPTTtipo>		
</cfif>

<cflocation url="tipos.cfm?Pagina=#Form.Pagina##params#">
