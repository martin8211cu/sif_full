<cfsetting requesttimeout="36000">
<!---SQL de Cambio Categoría Clase.--->
<cfset IDtrans = 6>
<cfset session.debug = false>

<cfif isdefined("form.alta")>
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_CAMCATCLAS" method="AF_CAMCATCLASACT"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfinvokeargument name="debug" value="#session.debug#">
	</cfinvoke>
	<cflocation url="agtProceso_genera_CAMCATCLAS.cfm?AGTPid=#rsResultadosDA#&#params#">

<cfelseif isdefined("btnAgregar")>
	<!--- Periodo--->
	<cfquery name="rsPeriodo" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 50
	</cfquery>

	<!--- Mes --->
	<cfquery name="rsMes" datasource="#session.DSN#">
		select p1.Pvalor as value from Parametros p1 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		and Pcodigo = 60
	</cfquery>

	<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
	<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>
	<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>

	<!--- Obtiene la Moneda Local --->
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo as value
		from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
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
	
			TAvaladq, 
			TAvalmej, 
			TAvalrev, 
	
			TAdepacumadq, 
			TAdepacummej, 
			TAdepacumrev,
	
			TAmontooriadq, 
			TAmontolocadq, 
			TAmontoorimej, 
			TAmontolocmej, 
			TAmontoorirev, 
			TAmontolocrev, 
	
			TAmontodepadq, 
			TAmontodepmej, 
			TAmontodeprev, 
			
			Mcodigo,
			TAtipocambio, 
			Usucodigo, 
			BMUsucodigo, 
			
			ACcodigoori, 
			ACidori, 
			ACcodigodest, 
			ACiddest
			
			, TAvalrescate
			)
			
			select
			#session.Ecodigo#,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPid#">,
			a.Aid,
			6,
			af.CFid,
			
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#"> as TAperiodo_de_auxiliares,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#"> as TAmes_de_auxiliares,
			
			
			#rsFechaAux.value# as TAfecha_de_auxiliares,
			#now()# as TAfalta,
	
			af.AFSvaladq,
			af.AFSvalmej,
			af.AFSvalrev,
			
			af.AFSdepacumadq,
			af.AFSdepacummej,
			af.AFSdepacumrev,
			
			af.AFSvaladq,
			af.AFSvaladq,
			af.AFSvalmej,
			af.AFSvalmej,
			af.AFSvalrev,
			af.AFSvalrev,
											
			AFSdepacumadq,
			AFSdepacummej,
			AFSdepacumrev,
		
			
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#"> as Mcodigo,
			1.00 as TAtipocambio,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as Usucodigo,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as BMUsucodigo,
			af.ACcodigo as ACcodigoori, <!--- --categoria origen de AFsaldos --->
			af.ACid, <!--- --ACidori clase origen de AFSaldos --->
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACCODIGON#"> as ACcodigodest, <!--- --categoria destino digitada por el usuario o importada --->
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.ACIDN#"> as ACiddest <!--- --clase destino digitada por el usuario o importada	 --->
			
			, a.Avalrescate
			
			from Activos a
					inner join 	AFSaldos af	
						on af.Ecodigo = a.Ecodigo	
						and af.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#">
						and af.AFSmes = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#">
						and af.Aid = a.Aid
					inner join AClasificacion ac
						on ac.Ecodigo = a.Ecodigo
						and ac.ACcodigo = a.ACcodigo
						and ac.ACid = a.ACid
						<!--- Clasificación --->
						<cfif isdefined("form.CLASIFICACION1") and len(trim(form.CLASIFICACION1)) and isdefined("form.CLASIFICACION2") and len(trim(form.CLASIFICACION2))>
							and ac.ACcodigodesc between <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CLASIFICACION1#"> 
								and <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CLASIFICACION2#">
						</cfif>
						<cfif isdefined("form.CLASIFICACION1") and len(trim(form.CLASIFICACION1)) and  not isdefined("form.CLASIFICACION2") and not len(trim(form.CLASIFICACION2))>
							and ac.ACcodigodesc >= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CLASIFICACION1#">
						</cfif>
						<cfif isdefined("form.CLASIFICACION2") and len(trim(form.CLASIFICACION2)) and isdefined("form.CLASIFICACION1") and not len(trim(form.CLASIFICACION1))>
							and ac.ACcodigodesc <= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CLASIFICACION2#">
						</cfif>
					inner join ACategoria ab
						on ab.Ecodigo = a.Ecodigo
						and ab.ACcodigo = a.ACcodigo
						<!--- Categorías --->
						<cfif isdefined("form.CATEGORIA1") and len(trim(form.CATEGORIA1)) and isdefined("form.CATEGORIA2") and len(trim(form.CATEGORIA2))>
							and ab.ACcodigodesc between <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CATEGORIA1#"> 
								and <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CATEGORIA2#">
						</cfif>
						<cfif isdefined("form.CATEGORIA1") and len(trim(form.CATEGORIA1)) and  not isdefined("form.CATEGORIA2") and not len(trim(form.CATEGORIA2))>
							and ab.ACcodigodesc >= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CATEGORIA1#">
						</cfif>
						<cfif isdefined("form.CATEGORIA2") and len(trim(form.CATEGORIA2)) and isdefined("form.CATEGORIA1") and not len(trim(form.CATEGORIA1))>
							and ab.ACcodigodesc <= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.CATEGORIA2#">
						</cfif>
			where 1=1
			 and a.Astatus = 0
			 and exists (
						select 1
						from AFSaldos a
						where af.Aid = a.Aid
						  and af.Ecodigo = a.Ecodigo
						  and af.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.value#" >
						  and af.AFSmes = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.value#">
						  )
			  and not exists (
						select 1
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
						  and xyz.Aid = a.Aid
						  and xyz.IDtrans = 6)  <!--- Hay que listar las transacciones que se repiten con los que 
													ya estaban cuando la categoria destino y clasificación destiono
													son diferente que las repetidas de primero --->
			
			  <!--- Que el activo no se encuentre en una transaccion pendiente de mejora--->
			  and not exists (
						select 1
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
						  and xyz.Aid = a.Aid
						  and xyz.IDtrans = 2)
			
			
			  <!--- Que el activo no se encuentre en una transaccion pendiente de revaluacion --->
			  and not exists (
						select 1
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
						  and xyz.Aid = a.Aid
						  and xyz.IDtrans = 3)
						  
			  <!--- Que el activo no se encuentre en una transaccion pendiente de depreciacion --->
			  and not exists (
						select 1
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
						  and xyz.Aid = a.Aid
						  and xyz.IDtrans = 4)
						  
			  <!--- Que el activo no se encuentre en una transaccion pendiente de retiro --->
			  and not exists (
						select 1
						from ADTProceso xyz
						where xyz.Ecodigo = a.Ecodigo
						  and xyz.Aid = a.Aid
						  and xyz.IDtrans = 5)						  						  			
			
			<!--- Placa --->
			<cfif isdefined("form.APLACAINI") and len(trim(form.APLACAINI)) and isdefined("form.APLACAFIN") and len(trim(form.APLACAFIN))>
				and a.Aplaca between <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.APLACAINI#"> 
					and <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.APLACAFIN#">
			</cfif>
			<cfif isdefined("form.APLACAINI") and len(trim(form.APLACAINI)) and  not isdefined("form.APLACAFIN") and not len(trim(form.APLACAFIN))>
				and a.Aplaca >= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.APLACAINI#">
			</cfif>
			<cfif isdefined("form.APLACAFIN") and len(trim(form.APLACAFIN)) and isdefined("form.APLACAINI") and not len(trim(form.APLACAINI))>
				and a.Aplaca <= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#form.APLACAFIN#">
			</cfif>
	</cfquery>
	<cflocation url="agtProceso_genera_CAMCATCLAS.cfm?AGTPid=#form.AGTPid#&#params#">
	
<cfelseif isdefined("btnAplicar")>
	<cfif isdefined("form.chk")
		and len(trim(form.chk)) gt 0>
		<cfset datos = ListToArray(form.chk)>
		<cfloop from="1" to="#ArrayLen(datos)#" index="idx">
			<cfinvoke component="sif.Componentes.AF_ContabilizarTrfClasificacion" 
				method="AF_ContabilizarTrfClasificacion" 
					returnvariable="rsResultadosDA">
				<cfinvokeargument name="AGTPid" value="#datos[idx]#">
				<cfinvokeargument name="debug" value="#session.debug#">
			</cfinvoke>
		</cfloop>
	</cfif>
	<cflocation url="agtProceso_CAMCATCLAS.cfm">

<cfelseif isdefined("btnAplicarForm")>
	<cfif isdefined("form.AGTPid")
		and len(trim(form.AGTPid)) gt 0>
		<cfinvoke component="sif.Componentes.AF_ContabilizarTrfClasificacion"	 
			method="AF_ContabilizarTrfClasificacion" 
			returnvariable="finalizadoOk"
				AGTPid="#form.AGTPid#"/>
	</cfif>
	<cflocation url="agtProceso_CAMCATCLAS.cfm">
	
<cfelseif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(form.chk))>

	<!--- Obtengo el Activo --->
	<cfloop index="item" list="#form.chk#" delimiters=",">
		<cfset LvarADTPlinea = #item#>

		<cfquery datasource="#session.DSN#">
			delete from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and ADTPlinea = #LvarADTPlinea#
		</cfquery>
	</cfloop>

	<cflocation url="agtProceso_genera_CAMCATCLAS.cfm?AGTPid=#form.AGTPid#&#params#">

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

	<cflocation url="agtProceso_CAMCATCLAS.cfm?#params#">
<cfelse>
	<cflocation url="agtProceso_CAMCATCLAS.cfm">
</cfif>