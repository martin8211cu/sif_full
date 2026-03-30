<cfset params = "">
<cfif isdefined("Form.Alta")>
	<!--- Obtiene el Centro Funcional del Empleado que está registrando el Vale 
		Se obtiene de la siguiente manera:
			a. Si el empleado está nombrado se toma el centro funcional en donde el empleado está nombrado.
			b. Si el empleado no está nombrado se toma el centro funcional de la tabla EmpleadoCFuncional.
	--->
	<!--- a. Busca el nombramiento del empleado en la tabla de linea del tiempo --->
	<cfset LvarCFid = 0>
	<cfif LvarCFid eq 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select b.CFid 
			from LineaTiempo a inner join RHPlazas b on a.RHPid = b.RHPid and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					between a.LTdesde and a.LThasta
		</cfquery>
		<cfif rsCFid.recordcount gt 0 and len(trim(rsCFid.CFid)) gt 0>
			<cfset LvarCFid = rsCFid.CFid>
		</cfif>
	</cfif>
	<!--- b. Busca el Empleado en la tabla EmpleadoCFuncional --->
	<cfif LvarCFid eq 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid 
			from EmpleadoCFuncional 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					between ECFdesde and ECFhasta
		</cfquery>
		<cfif rsCFid.recordcount gt 0 and len(trim(rsCFid.CFid)) gt 0>
			<cfset LvarCFid = rsCFid.CFid>
		</cfif>
	</cfif>
	<cfif LvarCFid eq 0>
		<cf_errorCode	code = "50098" msg = "Error obteniendo el Centro Funcional del Empleado que está registrando el Vale">
	</cfif>	
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into AFAdquisicion
			(Ecodigo, 
			 DEid, 
			 Aid, 
			 ACcodigo, 
			 ACid, 
			 AFMid, 
			 AFMMid, 
			 CFid, 
			 AFAdescripcion, 
			 AFAserie, 
			 AFAmonto, 
			 Usucodigo, 
			 Ulocalizacion, 
			 AFAstatus, 
			 AFAfechainidep, 
			 AFAfechainirev, 
			 AFAfechaalta,
			 SNcodigo, 
			 AFAdocumento)
		values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					null,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAserie#">,
					<cfqueryparam cfsqltype="cf_sql_money"   value="#form.AFAmonto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					'00',
					0,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.AFAfechainidep)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.AFAfechainirev)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"><cfelse>null</cfif>,
					<cfif isdefined("form.AFAdocumento") and len(trim(form.AFAdocumento))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAdocumento#"><cfelse>null</cfif>
		)
	</cfquery>
<cfelseif isdefined("Form.Baja")>
	<cfquery name="rsDelete" datasource="#session.DSN#">
		delete from AFAdquisicion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAid#">
			and AFAstatus = 0
	</cfquery>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="AFAdquisicion"
			redirect="vales_adquisicion.cfm"
			timestamp="#form.ts_rversion#"
			field1="AFAid,numeric,#form.AFAid#" 
			field2="Ecodigo,numeric,#session.ecodigo#" 
			field3="AFAstatus,numeric,0"
			>
	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update AFAdquisicion
		set ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">,
			ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">,
			AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">,
			AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">,
			AFAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAdescripcion#">,
			AFAserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAserie#">,
			AFAmonto = <cfqueryparam cfsqltype="cf_sql_money"   value="#form.AFAmonto#">,
			AFAfechainidep = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.AFAfechainidep)#">,
			AFAfechainirev = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.AFAfechainirev)#">,
			SNcodigo = <cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#"><cfelse>null</cfif>,
			AFAdocumento = <cfif isdefined("form.AFAdocumento") and len(trim(form.AFAdocumento))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AFAdocumento#"><cfelse>null</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAid#">
			and AFAstatus = 0
	</cfquery>
	<cfset params = "?AFAid="&Form.AFAid>
<cfelseif isdefined("Form.Terminar")>
	<cfquery name="rsUpdateStatus" datasource="#session.DSN#">
		update AFAdquisicion 
		set AFAstatus = 10
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AFAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFAid#">	
			and AFAstatus = 0
	</cfquery>
	<cfset params = "?AFAid="&Form.AFAid>
</cfif>
<cflocation url="vales_adquisicion.cfm#params#">

