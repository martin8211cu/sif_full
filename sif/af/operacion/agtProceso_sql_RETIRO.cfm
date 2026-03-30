<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>

<!--- FILTROS DE LA LISTA --->
<cfif not isdefined('params')>
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
</cfif>
<cfset IDtrans = 5>
<!---SQL de retiro--->
<cfset session.debug = false>
<cfif session.debug>
	SQL de retiro modo debug.<br>
	<cfdump var="#Form#">
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_RETIRO.cfm">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_RETIRO.cfm">Generar RETIRO</a>
</cfif>

<cfif isdefined("Alta")>
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaRelacion"
			returnvariable="rsResultadosRA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfinvokeargument name="AFRmotivo" value="#form.AFRmotivo#">
		<cfinvokeargument name="AGTPrazon" value="#form.AGTPrazon#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
	<cfset AGTPid = rsResultadosRA>
</cfif>

<cfif isdefined("Cambio") or isdefined("CambioDet")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="AGTProceso"
			redirect="agtProceso_genera_RETIRO#LvarPar#.cfm"
			timestamp="#form.ts_rversion#"
			field1="AGTPid,numeric,#form.AGTPid#" 
			field2="Ecodigo,numeric,#session.ecodigo#" 
			field3="IDtrans,numeric,#IDtrans#"
			>
	<cfquery datasource="#session.dsn#">
		update AGTProceso
		set AGTPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AGTPdescripcion#">
		, AFRmotivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFRmotivo#">
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
<!---************************ASOCIAR*****************************--->
<!---**Las validaciones se Realizan en el componente de retiros**--->
<cfif isdefined("btnAsociar")>
		<cfif session.debug>
			Asociando...<br>
		</cfif>
		<cfinvoke component="sif.Componentes.AF_RetiroActivos" method="AltaActivo"
				returnvariable="rsResultadosRA">
			<cfinvokeargument name="AGTPid" value="#form.AGTPid#">
			<cfinvokeargument name="ADTPrazon" value="#form.ADTPrazon#">
			<cfinvokeargument name="Aid" value="#form.Aid#">
			<cfinvokeargument name="debug" value="#session.debug#">
		</cfinvoke>
		<cfset AGTPid = form.AGTPid>
		<cfset ADTPlinea = #rsResultadosRA#>
</cfif>

<cfif isdefined("CambioDet")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="ADTProceso"
			redirect="agtProceso_genera_RETIRO#LvarPar#.cfm"
			timestamp="#form.ts_rversiondet#"
			field1="AGTPid,numeric,#form.AGTPid#" 
			field2="ADTPlinea,numeric,#form.ADTPlinea#" 
			field3="Ecodigo,numeric,#session.ecodigo#" 
			field4="IDtrans,numeric,#IDtrans#"
			>
	<cfif isdefined("Form.TAmontolocventa") and isdefined("Form.TipoCuentaR") and form.TipoCuentaR EQ 1>
    	<cfif not isdefined("form.SNcodigo") OR len(trim(form.SNcodigo)) EQ 0>
        	<cfabort showerror="Error Cuenta Cliente: No se ha definido el Cliente">
        </cfif>
        <cfif not isdefined("form.CCTcodigo") OR len(trim(form.CCTcodigo)) EQ 0>
        	<cfabort showerror="Error Cuenta Cliente: No se ha definido la Transacción de CxC">
        </cfif>
    </cfif>
    <cfquery datasource="#session.dsn#">
		update ADTProceso
		set ADTPrazon = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ADTPrazon#">
		<cfif isdefined("Form.TAmontolocventa") and len(trim(Form.TAmontolocventa))
			and isdefined("Form.Icodigo") and len(trim(Form.Icodigo)) 
			and isdefined("Form.TipoCuentaR") and len(trim(form.TipoCuentaR))>
			, TAmontolocventa = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocventa,',','','all')#">
			, Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(ListGetAt(form.Icodigo,1,'|'))#">
            , TipoCuentaRetiro = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TipoCuentaR#">
        <cfif isdefined("Form.TipoCuentaR") and form.TipoCuentaR EQ 1>
            , SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
            , CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
        </cfif>
		<cfelseif isdefined("Form.TAmontolocadq") and len(trim(Form.TAmontolocadq))
			and isdefined("Form.TAmontolocmej") and len(trim(Form.TAmontolocmej))
			and isdefined("Form.TAmontolocrev") and len(trim(Form.TAmontolocrev))
			and isdefined("Form.TAmontodepadq") and len(trim(Form.TAmontodepadq))
			and isdefined("Form.TAmontodepmej") and len(trim(Form.TAmontodepmej))
			and isdefined("Form.TAmontodeprev") and len(trim(Form.TAmontodeprev))>
			, TAmontolocadq = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocadq,',','','all')#">
			, TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocmej,',','','all')#">
			, TAmontolocrev = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontolocrev,',','','all')#">
			
			, TAmontodepadq = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontodepadq,',','','all')#">
			, TAmontodepmej = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontodepmej,',','','all')#">
			, TAmontodeprev = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.TAmontodeprev,',','','all')#">
		</cfif>
		where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
		and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADTPlinea#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
		and IDtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDtrans#">
	</cfquery>	
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

<cfif isdefined("btnAplicar")>
	<cfif isdefined("form.chk")>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfinvoke component="sif.Componentes.AF_ContabilizarRetiro" method="AF_ContabilizarRetiro" 
					returnvariable="rsResultadosRT">
				<cfinvokeargument name="AGTPid" value="#datos[idx]#">
				<cfinvokeargument name="debug" value="#session.debug#">
			</cfinvoke>
		</cfloop>
	</cfif>
</cfif>

<cfif isdefined("Aplicar")>
	
	<!--- Verifica que el activo no este dento de la Cola --->
	<cfquery name="rsExisteActivoEnCola" datasource="#session.dsn#">
	Select 1 
	from ADTProceso a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
	  and exists (	Select 1
					from CRColaTransacciones b
					where b.Ecodigo = a.Ecodigo
					  and b.Aid	    = a.Aid
					  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				 )
	</cfquery>

	<cfif rsExisteActivoEnCola.recordcount gt 0>
		<cf_errorCode	code = "50096" msg = "No es posible aplicar el retiro, ya que algunos de los Activos Fijos que están dentro de la relación, se encuentran dentro de la Cola de Procesos!">
	</cfif>	
	
	<cfinvoke component="sif.Componentes.AF_ContabilizarRetiro" method="AF_ContabilizarRetiro" 
			returnvariable="rsResultadosRT">
		<cfinvokeargument name="AGTPid" value="#form.AGTPid#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
	<cfset AGTPid = 0>
</cfif>

<cfif session.debug>
	<a href="../MenuAF.cfm">Activos Fijos</a> | <a href="agtProceso_REVALUACION.cfm">Lista de Grupos de Transacciones</a> | <a href="agtProceso_genera_REVALUACION.cfm">Generar Revaluacion</a><br>
	<cfabort>
</cfif>

<cfif isdefined("importar")>
	<cflocation url="agtProceso_genera_RETIRO#LvarPar#.cfm?AGTPid=#AGTPid#&#params#&btnImportar=1">
</cfif>

<cfif isdefined("AGTPid") and AGTPid GT 0>
	<cfif isdefined("ADTPlinea") and ADTPlinea GT 0 and not isdefined("form.NuevoDet")>
		<!--- Se modifica el detalle. Queda en el mantenimiento. --->
		<cflocation url="agtProceso_genera_RETIRO#LvarPar#.cfm?AGTPid=#AGTPid#&ADTPlinea=#ADTPlinea#&#params#">
	<cfelseif not isdefined("form.Nuevo")>
		<!--- Se preciona nuevo en el detalle. Se regresa a la lista original. --->
		<cflocation url="agtProceso_genera_RETIRO#LvarPar#.cfm?AGTPid=#AGTPid#&#params#">
	<cfelse>
		<cflocation url="agtProceso_genera_RETIRO#LvarPar#.cfm?#params#">
	</cfif>	
<cfelse>
	<cflocation url="agtProceso_RETIRO#LvarPar#.cfm?#params#">
</cfif>



