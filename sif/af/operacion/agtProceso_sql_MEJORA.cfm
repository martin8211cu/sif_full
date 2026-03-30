<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<!---Proceso para importar mayo 2008 MCZ--->
<cfif isdefined ("form.Importar")>
	<cflocation url="agtProceso_importa_mejora#LvarPar#.cfm?AGTPid=#form.AGTPid#" addtoken="no">
</cfif>

<cfset IDtrans = 2>
<cfset session.debug = false>
<cfif session.debug>
	SQL de mejora modo debug.<br>
	<cfdump var="#Form#">
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_MEJORA.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_MEJORA.cfm">Generar MEJORA</a>
</cfif>

<cfif isdefined("Alta")>
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_MejoraActivos" method="AltaRelacion"
			returnvariable="rsResultadosRA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfinvokeargument name="AGTPrazon" value="#form.AGTPrazon#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
	<cfset AGTPid = rsResultadosRA>
</cfif>

<cfif isdefined("Cambio") or isdefined("CambioDet")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="AGTProceso"
			redirect="agtProceso_genera_MEJORA#LvarPar#.cfm"
			timestamp="#form.ts_rversion#"
			field1="AGTPid,numeric,#form.AGTPid#" 
			field2="Ecodigo,numeric,#session.ecodigo#" 
			field3="IDtrans,numeric,#IDtrans#"
			>
	<cfquery datasource="#session.dsn#">
		update AGTProceso
		set AGTPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AGTPdescripcion#">
		, AGTPrazon = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AGTPrazon#">
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
		and AGTPestadp < 4
	</cfquery>
	<cfset AGTPid = form.AGTPid>
</cfif>

<cfif isdefined("Baja")>
	<cfquery name="rsDelete0" datasource="#session.dsn#">
		select count(1) as Registros
		from ADTProceso 
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery name="rsCheckToDelete" datasource="#session.dsn#">
		select 1
		from AGTProceso 
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
		and AGTPestadp < 4
	</cfquery>
	<cfif (rsCheckToDelete.RecordCount eq 1)>
		<cfquery datasource="#session.dsn#">
			delete 
			from ADTProceso
			where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
		</cfquery>
		<!--- Estado = 5 > Borrado --->
		<cfquery name="rsDelete2" datasource="#session.dsn#">
			update AGTProceso
			set AGTPestadp = 5, 
				AGTPfecborrado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				AGTPusuborrado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				AGTPregborrado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDelete0.Registros#">
			where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and IDtrans = <cfqueryparam cfsqltype="cf_sql_integer" value="#IDtrans#">
		</cfquery>
	</cfif>
	<cfset AGTPid = 0>
</cfif>

<!---*********************ASOCIAR********************************--->
<!---*Las validaciones del Activos se realizan en el componente**--->
<cfif isdefined("btnAsociar")>
		<cfinvoke component="sif.Componentes.AF_MejoraActivos" method="AltaActivo" returnvariable="rsResultadosRA">
			<cfinvokeargument name="AGTPid" value="#form.AGTPid#">
			<cfinvokeargument name="ADTPrazon" value="#form.ADTPrazon#">
			<cfinvokeargument name="Aid" value="#form.Aid#">
			<cfinvokeargument name="debug" value="#session.debug#">
		</cfinvoke>
		<cfset AGTPid = form.AGTPid>
		<cfset ADTPlinea = #rsResultadosRA#>
</cfif>

<cfif isdefined("CambioDet")>
	
	<!--- Valida que en caso de ser negativa la vida util, el monto sea cero y no exeda mas de la vida util actual--->	
	<cfset error=0>
	<cfset LvarVutil = replace(form.TAvutil,',','','all')>
	<cfif LvarVutil lt 0 and replace(form.TAmontolocmej,',','','all') gt 0>
		<cfset error=1>
	</cfif>
	<cfif LvarVutil lt 0 and error eq 0>
	
		<!--- OBTIENE EL PERIODO-MES DEL AUXILIAR --->
		<cfquery name="rsPeriodo" datasource="#session.dsn#">
			select Pvalor as value
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 50
				and Mcodigo = 'GN'
		</cfquery>
	
		<cfquery name="rsMes" datasource="#session.dsn#">
			select Pvalor as value
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 60
				and Mcodigo = 'GN'
		</cfquery>	
		
		<cfif rsPeriodo.recordcount gt 0 and rsMes.recordcount gt 0>
			<cfset LvarPerAux = rsPeriodo.value>
			<cfset LvarMesAux = rsMes.value>		
		<cfelse>
			<cf_errorCode	code = "50094" msg = "No fue posible obtener el periodo-mes del auxiliar.">
		</cfif>		
	
		<cfquery name="rsVutil" datasource="#session.dsn#">
		Select AFSsaldovutiladq
		from ADTProceso a
				inner join AFSaldos b
					 on a.Aid = b.Aid
					and a.Ecodigo = b.Ecodigo
					and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerAux#">
					and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">
					
		where a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		  and a.ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		  and a.IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		</cfquery>
		
		<cfif rsVutil.recordcount gt 0>
			<cfif (rsVutil.AFSsaldovutiladq + LvarVutil) lt 1>
				<cfset error=1>
			</cfif>
		</cfif>		
		
	</cfif>

	<cf_dbtimestamp datasource="#session.dsn#"
			table="ADTProceso"
			redirect="agtProceso_genera_MEJORA#LvarPar#.cfm"
			timestamp="#form.ts_rversiondet#"
			field1="AGTPid,numeric,#form.AGTPid#" 
			field2="ADTPlinea,numeric,#form.ADTPlinea#" 
			field3="Ecodigo,numeric,#session.ecodigo#" 
			field4="IDtrans,numeric,#IDtrans#"
			>	
	<cfif error eq 0>

		<cfquery datasource="#session.dsn#">
			update ADTProceso
			set ADTPrazon = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ADTPrazon#">
			, TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocmej,',','','all')#">
			, TAvutil = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAvutil,',','','all')#">
			where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
		</cfquery>
	
	<cfelse>
		<script>
			alert("Error, Verifique lo siguiente:\n 1. Si la vida útil es negativa el monto debe ser cero.\n 2. Que el valor de la vida útil negativa no exeda el valor de la vida útil actual del Activo.")
			history.go(-1)
		</script>
		<cfabort>
	</cfif>
	
</cfif>

<cfif isdefined("BajaDet")>
	<cfquery datasource="#session.dsn#">
		delete from ADTProceso
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
	</cfquery>
	<cfset ADTPlinea = 0>
</cfif>
<!---*****************APLICAR LA MEJORA**************************--->
<!---************************************************************--->
<cfif isdefined("btnAplicar")>
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfinvoke component="sif.Componentes.AF_ContabilizarMejora" method="AF_ContabilizarMejora" 
					returnvariable="rsResultadosRT">
				<cfinvokeargument name="AGTPid" value="#datos[idx]#">
				<cfinvokeargument name="debug" value="#session.debug#">
			</cfinvoke>
		</cfloop>
	</cfif>
</cfif>

<cfif isdefined("Aplicar")>
	<cfinvoke component="sif.Componentes.AF_ContabilizarMejora" method="AF_ContabilizarMejora" 
			returnvariable="rsResultadosRT">
		<cfinvokeargument name="AGTPid" value="#form.AGTPid#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
	<cfset AGTPid = 0>
</cfif>

<cfif session.debug>
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_MEJORA.cfm?#params#">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_MEJORA.cfm?#params#">Generar MEJORA</a>
	<cfabort>
</cfif>

<cfset params = ''>
<cfif isdefined('form.Filtro_AGTPdescripcion')>
	<cfset params = params & 'Filtro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset params = params & '&Filtro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPfalta')>
	<cfset params = params & '&Filtro_AGTPfalta=#form.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPmesDesc')>
	<cfset params = params & '&Filtro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPperiodo')>
	<cfset params = params & '&Filtro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPdescripcion')>
	<cfset params = params & '&HFiltro_AGTPdescripcion=#form.HFiltro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPestadoDesc')>
	<cfset params = params & '&HFiltro_AGTPestadoDesc=#form.HFiltro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPfalta')>
	<cfset params = params & '&HFiltro_AGTPfalta=#form.HFiltro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPmesDesc')>
	<cfset params = params & '&HFiltro_AGTPmesDesc=#form.HFiltro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPperiodo')>
	<cfset params = params & '&HFiltro_AGTPperiodo=#form.HFiltro_AGTPperiodo#'>
</cfif>

<cfif isdefined("AGTPid") and AGTPid GT 0>
	<cfif isdefined("ADTPlinea") and ADTPlinea GT 0 and not isdefined("form.NuevoDet")>
		<cflocation url="agtProceso_genera_MEJORA#LvarPar#.cfm?AGTPid=#AGTPid#&ADTPlinea=#ADTPlinea#&#params#">
	<cfelseif not isdefined("form.Nuevo")>
		<cflocation url="agtProceso_genera_MEJORA#LvarPar#.cfm?AGTPid=#AGTPid#&#params#">
	<cfelse>
		<cflocation url="agtProceso_genera_MEJORA#LvarPar#.cfm?#params#">
	</cfif>
<cfelse>
	
	<cflocation url="agtProceso_MEJORA#LvarPar#.cfm?#params#">
</cfif>

