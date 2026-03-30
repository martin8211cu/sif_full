<cfsetting requesttimeout="36000">
<!---SQL de Cambio Categoría Clase.--->
<cfset IDtrans = 7>
<cfset session.debug = false>
<cfif isdefined("form.alta")>
<!--- Agrega Encabezado--->
	<cfif session.debug>
		Generando...<br>
	</cfif>
	<cfinvoke component="sif.Componentes.AF_CAMTIPO" method="AF_CAMTIPOACT"
			returnvariable="rsResultadosDA">
		<cfinvokeargument name="AGTPdescripcion" value="#form.AGTPdescripcion#">
		<cfinvokeargument name="debug" value="false">
	</cfinvoke>
	<cflocation url="agtProceso_genera_CAMTIPO.cfm?AGTPid=#rsResultadosDA#">
<cfelseif isdefined("btnAgregar")>
<!--- Agrega registros a la relación en la que me encuentro actualmente. --->
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
	<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	<!--- Obtiene la Moneda Local --->
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo as value
		from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>	

	<cfset LvarPeriodo = rsPeriodo.value>
	<cfset LvarMes     = rsMes.value>
	<cfset LvarMoneda  = rsMoneda.value>

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
			AFCcodigoAnt, 
			AFCcodigoNuevo
		)		
		select
			#session.Ecodigo#,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPID#">,
			a.Aid,
			7,
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
			a.AFCcodigo,
			<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.AFCcodigo#">as newAFCcodigo
		from Activos a
			inner join 	AFSaldos af	
					 on af.Aid = a.Aid
					and af.AFSperiodo 	= #LvarPeriodo#
					and af.AFSmes 		= #LvarMes#
		where a.Ecodigo = #session.Ecodigo#
		  and a.Astatus = 0
		<cfif isdefined("form.aplacaini") and len(trim(form.aplacaini))>
			and lower(a.Aplaca) >= '#Lcase(trim(form.aplacaini))#'
		</cfif>
		<cfif isdefined("form.aplacafin") and len(trim(form.aplacafin))>
			and lower(a.Aplaca) <= '#Lcase(trim(form.aplacafin))#'
		</cfif>
		<cfif isdefined("form.ACcodigo1") and len(trim(form.ACcodigo1))>
			and a.ACcodigo >= #form.ACcodigo1#
		</cfif>
		<cfif isdefined("form.ACcodigo2") and len(trim(form.ACcodigo2))>
			and a.ACcodigo <= #form.ACcodigo2#
		</cfif>
		<cfif isdefined("form.ACid1") and len(trim(form.ACid1))>
			and a.ACid >= #form.ACid1#
		</cfif>
		<cfif isdefined("form.ACid2") and len(trim(form.ACid2))>
			and a.ACid <= #form.ACid2#
		</cfif>		
		and not exists (
			select x.Aid
			from ADTProceso x
			where x.Ecodigo = a.Ecodigo
			  and x.Aid = a.Aid
			  and x.IDtrans = 7
			  and x.AGTPid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
		)
	</cfquery>

	<cflocation url="agtProceso_genera_CAMTIPO.cfm?AGTPid=#form.AGTPid#&#params#">

<!--- Cambiar tipos a los regitros con check . --->
<cfelseif isdefined("form.btnCambiar") and isdefined("form.chk") and len(trim(form.chk))>
	<cfquery name="rsRegistros" datasource="#session.DSN#">
		Select  ADTPlinea,Aid,AFCcodigoNuevo  
		from  ADTProceso
		where IDtrans = 7 
		and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
		and ADTPlinea in(#form.chk#)
	</cfquery>
	<cfif rsRegistros.RecordCount gt 0>
		<cfloop query="rsRegistros">
			<cfinvoke component="sif.Componentes.AF_CambioTipoActivo"	 
			method="AF_CambioTipoActivo" 
			returnvariable="finalizadoOk"
			Aid="#rsRegistros.Aid#" 
			AFCcodigo="#rsRegistros.AFCcodigoNuevo#"/>
			<cfif finalizadoOk>
				<!--- si pudo realizar el cambio elimina la linea --->
				<cfquery name="rsBorralinea" datasource="#session.DSN#">
					delete from ADTProceso 
					where IDtrans = 7 
					and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
					and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegistros.ADTPlinea#">
				</cfquery>
			</cfif>
		</cfloop>
		<!--- busca si quedo alguna linea pendiente de cambiar --->
		<cfquery name="rsRegistros" datasource="#session.DSN#">
			Select  ADTPlinea
			from  ADTProceso
			where IDtrans = 7 
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
			<cflocation url="transfTipo.cfm">
		<cfelse>
			<cflocation url="agtProceso_genera_CAMTIPO.cfm?AGTPid=#form.AGTPid#&#params#">
		</cfif>	
	</cfif>
<!--- cambiar todos los regitros --->	
<cfelseif isdefined("form.btnCambiarTodo")>
	<cfquery name="rsRegistros" datasource="#session.DSN#">
		Select  ADTPlinea,Aid,AFCcodigoNuevo  
		from  ADTProceso
		where IDtrans = 7 
		and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
	</cfquery>
	<cfif rsRegistros.RecordCount gt 0>
		<cfloop query="rsRegistros">
			<cfinvoke component="sif.Componentes.AF_CambioTipoActivo"	 
			method="AF_CambioTipoActivo" 
			returnvariable="finalizadoOk"
			Aid="#rsRegistros.Aid#" 
			AFCcodigo="#rsRegistros.AFCcodigoNuevo#"/>
			<cfif finalizadoOk>
				<!--- si pudo realizar el cambio elimina la linea --->
				<cfquery name="rsBorralinea" datasource="#session.DSN#">
					delete from ADTProceso 
					where IDtrans = 7 
					and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AGTPID#">
					and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegistros.ADTPlinea#">
				</cfquery>
			</cfif>
		</cfloop>
		<!--- busca si quedo alguna linea pendiente de cambiar --->
		<cfquery name="rsRegistros" datasource="#session.DSN#">
			Select  ADTPlinea
			from  ADTProceso
			where IDtrans = 7 
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
			<cflocation url="transfTipo.cfm">
		<cfelse>
			<cflocation url="agtProceso_genera_CAMTIPO.cfm?AGTPid=#form.AGTPid#&#params#">
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
	<cflocation url="agtProceso_genera_CAMTIPO.cfm?AGTPid=#form.AGTPid#&#params#">
	
<!--- Importador--->
<cfelseif isdefined ("form.btnImportar")>
	<cflocation url="agtProceso_Importa.cfm?IDtrans=#IDtrans#&modo=#form.modo#&AGTPid=#form.AGTPid#">
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
	<cflocation url="agtProceso_genera_CAMTIPO.cfm?AGTPid=#form.AGTPid#&#params#">
<cfelse>
	<cflocation url="transfTipo.cfm">
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