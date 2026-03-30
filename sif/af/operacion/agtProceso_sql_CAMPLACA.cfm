<cfsetting requesttimeout="36000">
<cfset IDtrans = 10>
<cfset session.debug = false>

<!--- Agrega Encabezado --->
<cfif isdefined("form.alta")>
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_CAMPLACA" method="AF_CAMPLACAACT"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfinvokeargument name="debug" value="false">
	</cfinvoke>
	<cflocation url="agtProceso_genera_CAMPLACA.cfm?AGTPid=#rsResultadosDA#">

<!--- Agrega registros a la relacin en la que me encuentro actualmente. --->	
<cfelseif isdefined("btnAgregar")>
	
	<cfquery name="rsPeriodo" datasource="#session.DSN#"> <!--- Periodo--->
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 50
	</cfquery>
	<cfquery name="rsMes" datasource="#session.DSN#">  <!--- Mes --->
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 60
	</cfquery>
	
	<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el ltimo da del mes --->
	<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	
	<cfquery name="rsMoneda" datasource="#session.DSN#"><!--- Obtiene la Moneda Local --->
		select Mcodigo as value
		from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>	

	<cfset LvarPeriodo = rsPeriodo.value>
	<cfset LvarMes     = rsMes.value>
	<cfset LvarMoneda  = rsMoneda.value>
	
	<!--- Verifica que ambas placas tengan valor --->
	<cfif (trim(form.aplacaini) eq "") or (trim(form.New_Aplaca) eq "")>
		<cf_errorCode	code = "50091" msg = "Tanto la placa origen como la placa destino deben ser suministradas">
	</cfif>
	
	<cfquery name="ActivoOrigen" datasource="#session.DSN#">
		select Aid from Activos where Aplaca = '#form.aplacaini#' and Ecodigo = #session.Ecodigo#
	</cfquery>
		
	<!--- VALIDACIONES DE LA PLACA ORIGEN--->
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	  Aid="#ActivoOrigen.Aid#"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Saldos" 	  Aid="#ActivoOrigen.Aid#" validamontos="false"/>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Revaluacion"  Aid="#ActivoOrigen.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Depreciacion" Aid="#ActivoOrigen.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Mejora" 	  Aid="#ActivoOrigen.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Retiro" 	  Aid="#ActivoOrigen.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_CambioCatCls" Aid="#ActivoOrigen.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Traslado"     Aid="#ActivoOrigen.Aid#"/> 
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Cola"         Aid="#ActivoOrigen.Aid#"/> 	
		
		<!--- VALIDACIONES DE LA PLACA DESTINO--->
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_ExisteAF" 	 Aplaca="#form.New_Aplaca#" DebeExistir= "False"/>
	    <cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnValida_Transito" 	 Aplaca="#form.New_Aplaca#"/>

		<!--- Verifica que la placa nueva no exista en TransaccionesActivos, como parte de algn cambio --->	
		<cfquery  datasource="#session.DSN#" name="CatTA">
			Select count(1) as existe
				from TransaccionesActivos
			where IDtrans = 10
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and (	AplacaAnt 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.New_Aplaca#">
				 or AplacaNueva = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.New_Aplaca#">)
		</cfquery>
		
		<cfif CatTA.existe gt 0>
			<cf_errorCode	code = "50092" msg = "No es posible agregar la transaccion de cambio de placa, debido a que la nueva placa ya haba sido utilizada por un activo en el pasado">
		</cfif>		
		
	<cfquery  datasource="#session.DSN#">
		insert into ADTProceso 
		(
			Ecodigo, 
			AGTPid, 
			Aid, 
			IDtrans, 
			CFid, 
			TAperiodo, 
			TAmes, 
			TAfecha, 
			TAfalta, 
			TAmontooriadq, 
			TAmontolocadq, 
			TAmontoorimej, 
			TAmontolocmej, 
			TAmontoorirev, 
			TAmontolocrev, 
			Mcodigo,
			TAtipocambio, 
			Usucodigo, 
			BMUsucodigo,
			AplacaAnt,
			AplacaNueva
		)		
		select
			#session.Ecodigo#,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPID#">,
			a.Aid,
			10,
			af.CFid,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPeriodo#"> as TAperiodo_de_auxiliares,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMes#">     as TAmes_de_auxiliares,
			#rsFechaAux.value# as TAfecha_de_auxiliares,
			#now()# as TAfalta,
			af.AFSvaladq,
			af.AFSvaladq,
			af.AFSvalmej,
			af.AFSvalmej,
			af.AFSvalrev,
			af.AFSvalrev,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarMoneda#"> as Mcodigo,
			1.00 as TAtipocambio,
			#session.Usucodigo# as Usucodigo,
			#session.Usucodigo# as BMUsucodigo,
			a.Aplaca,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#form.New_Aplaca#"> as newAFCcodigo
		from Activos a
			inner join 	AFSaldos af	
					 on af.Aid = a.Aid
					and af.AFSperiodo 	= #LvarPeriodo#
					and af.AFSmes 		= #LvarMes#
		where a.Ecodigo = #session.Ecodigo#
		  and a.Astatus = 0
		<cfif isdefined("form.aplacaini") and len(trim(form.aplacaini))>
			and lower(a.Aplaca) = '#Lcase(trim(form.aplacaini))#'
		</cfif>	
		and not exists (
			select x.Aid
			from ADTProceso x
			where x.Ecodigo = a.Ecodigo
			  and x.Aid = a.Aid
			  and x.IDtrans = 10
			  and x.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
		)
	</cfquery>

	<cflocation url="agtProceso_genera_CAMPLACA.cfm?AGTPid=#form.AGTPid#&#params#">

<!--- Cambiar tipos a los regitros con check . --->
<cfelseif isdefined("form.btnCambiar") and isdefined("form.chk") and len(trim(form.chk))>
	<cfquery name="rsRegistros" datasource="#session.DSN#">
		Select  AGTPid,ADTPlinea,Aid,AplacaNueva  
		from  ADTProceso
		where IDtrans = 10
		and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
		and ADTPlinea in(#form.chk#)
	</cfquery>
	<cfif rsRegistros.RecordCount gt 0>
		<cfloop query="rsRegistros">
			<cfinvoke component="sif.Componentes.AF_CambioPlacaActivo"	 
			method="AF_CambioPlacaActivo" 
			returnvariable="finalizadoOk"
			AGTPid="#rsRegistros.AGTPid#"
			Aid="#rsRegistros.Aid#" 
			AplacaNueva="#rsRegistros.AplacaNueva#"/>
			<cfif finalizadoOk>
				<!--- si pudo realizar el cambio elimina la linea --->
				<cfquery name="rsBorralinea" datasource="#session.DSN#">
					delete from  ADTProceso 
					where IDtrans = 10 
					and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
					and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegistros.ADTPlinea#">
				</cfquery>
			</cfif>
		</cfloop>
		<!--- busca si quedo alguna linea pendiente de cambiar --->
		<cfquery name="rsRegistros" datasource="#session.DSN#">
			Select  ADTPlinea
			from  ADTProceso
			where IDtrans = 10 
			and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
		</cfquery>
		<cfif rsRegistros.RecordCount eq 0>
			<!---Actualiza estado a AGTProceso--->
			<cfquery name="rsUpdateAGTProceso" datasource="#session.DSN#">
				Update AGTProceso
				set AGTPestadp = 4,
				AGTPfaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				AGTPipaplica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
				Usuaplica = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			</cfquery>
			<cflocation url="transfPlaca.cfm">
		<cfelse>
			<cflocation url="agtProceso_genera_CAMPLACA.cfm?AGTPid=#form.AGTPid#&#params#">
		</cfif>	
	</cfif>
<!--- cambiar todos los regitros --->	
<cfelseif isdefined("form.btnCambiarTodo")>
	<cfquery name="rsRegistros" datasource="#session.DSN#">
		Select  AGTPid,ADTPlinea,Aid,AplacaNueva  
		from  ADTProceso
		where IDtrans = 10 
		and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
	</cfquery>
	<cfif rsRegistros.RecordCount gt 0>
		<cfloop query="rsRegistros">
			<cfinvoke component="sif.Componentes.AF_CambioPlacaActivo"	 
			method="AF_CambioPlacaActivo" 
			returnvariable="finalizadoOk"
			AGTPid="#rsRegistros.AGTPid#"
			Aid="#rsRegistros.Aid#"
			AplacaNueva="#rsRegistros.AplacaNueva#"/>
			<cfif finalizadoOk>
				<!--- si pudo realizar el cambio elimina la linea --->
				<cfquery name="rsBorralinea" datasource="#session.DSN#">
					delete from ADTProceso 
					where IDtrans = 10 
					and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
					and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegistros.ADTPlinea#">
				</cfquery>
			</cfif>
		</cfloop>
		<!--- busca si quedo alguna linea pendiente de cambiar --->
		<cfquery name="rsRegistros" datasource="#session.DSN#">
			Select  ADTPlinea
			from  ADTProceso
			where IDtrans = 10 
			and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
		</cfquery>
		<cfif rsRegistros.RecordCount eq 0>
			<!---Actualiza estado a AGTProceso--->
			<cfquery name="rsUpdateAGTProceso" datasource="#session.DSN#">
				Update AGTProceso
				set AGTPestadp = 4,
				AGTPfaplica = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				AGTPipaplica = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
				Usuaplica = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPid#">
			</cfquery>
			<cflocation url="transfPlaca.cfm">
		<cfelse>
			<cflocation url="agtProceso_genera_CAMPLACA.cfm?AGTPid=#form.AGTPid#&#params#">
		</cfif>	
	</cfif>
<!--- Borrar regitros con check --->
<cfelseif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(form.chk))>
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarADTPlinea = #item#>
		<cfquery datasource="#session.DSN#">
			delete from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and ADTPlinea = #LvarADTPlinea#
		</cfquery>
	</cfloop>
	<cflocation url="agtProceso_genera_CAMPLACA.cfm?AGTPid=#form.AGTPid#&#params#">
<!--- Borrar todos los regitros --->	
<cfelseif isdefined("form.btnEliminarTodo")>
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
	</cfif>
	<cflocation url="agtProceso_genera_CAMPLACA.cfm?AGTPid=#form.AGTPid#&#params#">
<cfelse>
	<cflocation url="transfPlaca.cfm">
</cfif>


<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
	<cfargument name="lValue" required="yes" type="any">
	<cfargument name="IValueIfNull" required="yes" type="any">
	<cfif len(trim(lValue))>
		<cfreturn lValue>
	<cfelse>
		<cfreturn lValueIfNull>
	</cfif>
</cffunction>

