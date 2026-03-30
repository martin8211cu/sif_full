<cfcomponent>
  <cffunction name="ALTA" access="public" output="true" returntype="numeric">
	<cfargument name="Ecodigo" 			type="numeric" 	required="no" default="#session.Ecodigo#">
	<cfargument name="Usucodigo" 		type="numeric" 	required="no" default="#session.Usucodigo#">
	<cfargument name="IPregistro" 		type="string" 	required="no" default="#session.sitio.ip#">
	<cfargument name="Conexion" 		type="string" 	required="no" default="#session.dsn#">
	<cfargument name="Periodo" 		    type="numeric"  required="no" default="0" >
	<cfargument name="Mes" 				type="numeric"  required="no" default="0">
	<cfargument name="AGTPdescripcion" 	type="string"   required="no" default="Depreciación Por Actividad"><!--- Descripción de la transacción --->
	<cfargument name="FOcodigo" 		type="numeric"  required="no" default="-1"><!--- Filtro por Oficina --->
	<cfargument name="FDcodigo" 		type="numeric"  required="no" default="-1"><!--- Filtro por Departamento --->
	<cfargument name="FCFid" 			type="numeric"  required="no" default="-1"><!--- Filtro por Centro  --->
	<cfargument name="FACcodigo" 		type="numeric"  required="no" default="-1"><!--- Filtro por Categoria --->
	<cfargument name="FACid" 			type="numeric"  required="no" default="-1"><!--- Filtro por Clase --->
	<cfargument name="FAFCcodigo" 		type="numeric"  required="no" default="-1"><!--- Filtro por Tipo --->
	<cfargument name="AplacaDesde" 		type="string" 	required="no" default="">
	<cfargument name="AplacaHasta" 		type="string" 	required="no" default="">
	
	<cfargument name="CantidadUnidades" type="numeric"  required="no" default="1">  <!---Cantidad de Unidades --->

	<!---==========Asegurarse de que la información sobre las conexiones este disponible==========--->
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo" refresh="no" datasource="#Arguments.Conexion#" />
	<cfif not StructKeyExists(Application.dsinfo, Arguments.conexion)>
		<cf_errorCode	code = "50599"
						msg  = "Datasource no definido: @errorDat_1@"
						errorDat_1="#HTMLEditFormat(Arguments.Conexion)#"
		>
	</cfif>
	<!---==========Obtiene el Periodo y Mes de Auxiliares========================================--->
	<cfif Arguments.Periodo neq 0>
		<cfset rsPeriodo.value = Arguments.Periodo>
	<cfelse>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.value"/>
	</cfif>
	<cfif Arguments.Mes neq 0>
		<cfset rsMes.value = Arguments.Mes>
	<cfelse>
		<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux"     returnvariable="rsMes.value"/>
	</cfif>
	<!--- Obtiene la Moneda Local --->
	<cfquery name="rsMoneda" datasource="#arguments.conexion#">
		select Mcodigo as value
		from Empresas 
		where Ecodigo = #Arguments.Ecodigo#
	</cfquery>
	<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
	<cfset rsFechaAux.value = CreateDate(rsPeriodo.value, rsMes.value, 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("h",23,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("n",59,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("s",59,rsFechaAux.value)>
	
	<!---=======Prepara los filtros antes de la consulta para hacerla mas clara==============--->
	<cfset filtroa="">
	<cfset filtrob="">
	<cfset filtrocf="">
	<!--- Filtro por centro funcional--->
	<cfif Arguments.FCFid gte 0>
	      <cfset filtroa = filtroa & " and a.CFid = " & Arguments.FCFid>
	</cfif>
	<!--- Filtro por categoría--->
	<cfif Arguments.FACcodigo gte 0>
	       <cfset filtrob = filtrob & " and b.ACcodigo = " & Arguments.FACcodigo>
    </cfif>
	<!--- Filtro por clase--->
	<cfif Arguments.FACid gte 0>
	          <cfset filtrob = filtrob & " and b.ACid = " & Arguments.FACid>
	</cfif>
	<!--- Filtro por tipo--->
	<cfif Arguments.FAFCcodigo gte 0>
	     <cfset filtrob = filtrob & " and b.AFCcodigo = " & Arguments.FAFCcodigo>
    </cfif>
	<!--- Join con centro funcional para filtrar --->
	<cfif Arguments.FOcodigo  gte 0 or Arguments.FDcodigo gte 0>
		<cfset filtrocf = filtrocf & " inner join CFuncional cf on a.CFid = cf.CFid ">
	</cfif> 
	<!--- Filtro por oficina---> 
	<cfif Arguments.FOcodigo gte 0>
	     <cfset filtrocf = filtrocf & " and cf.Ocodigo = " & Arguments.FOcodigo>
		 <cfset filtroa = filtroa & " and a.Ocodigo = " & Arguments.FOcodigo>
   </cfif>
   <!--- Filtro por departamento--->
	<cfif Arguments.FDcodigo gte 0>
		<cfset filtrocf = filtrocf & " and cf.Dcodigo = " & Arguments.FDcodigo>
   </cfif>
   <!---Filtro por placa Origen--->
   <cfif isdefined('Arguments.AplacaDesde') and len(trim(Arguments.AplacaDesde)) GT 0>
   		<cfset filtroa = filtroa & " and b.Aplaca >= '" & Arguments.AplacaDesde & "'">
   </cfif>
   <!---Filtro por placa Fin--->
   <cfif isdefined('Arguments.AplacaHasta') and len(trim(Arguments.AplacaHasta)) GT 0>
   		<cfset filtroa = filtroa & " and b.Aplaca <= '"& Arguments.AplacaHasta& "'">
   </cfif>
	<!---==========Inicio Calculo de la Depreciación=================================================--->
 <cftransaction>
		<cfinvoke component="sif.Componentes.OriRefNextVal" method="nextVal" returnvariable="LvarNumDoc" ORI="AFDP" REF="DP"/>
		
	<!---==========Inserta Grupo de transacciones de depreciación======================================--->
	<cfquery name="idquery" datasource="#arguments.conexion#">
		insert into AGTProceso(
			Ecodigo,		IDtrans, 
			AGTPdocumento,	AGTPdescripcion,
			AGTPperiodo, 	AGTPmes, 
			Usucodigo,		AGTPfalta,
			AGTPipregistro,	AGTPestadp,
			AGTPecodigo, 	AGTPmanual)
		values(
			#Arguments.Ecodigo#,		4,
			#LvarNumDoc#,				'#Arguments.AGTPdescripcion#',
			#rsPeriodo.value#,			#rsMes.value#,
			#Arguments.usucodigo#,		<cf_dbfunction name="now">,
		   '#Arguments.ipregistro#',	2,<!---(AGTPestadp = 2) Estado pendiente de aplicar--->
			#Arguments.Ecodigo#,		2 <!-----(AGTPmanual = 2)Indica que se trata de una Dep. Por Actividad--->
			)
			<cf_dbidentity1 datasource="#arguments.conexion#">
	</cfquery>
			<cf_dbidentity2 datasource="#arguments.conexion#" name="idquery">

	<cfquery datasource="#arguments.conexion#">
		insert into ADTProceso(
			Ecodigo, AGTPid, Aid, IDtrans, CFid, TAfalta, 
			TAfechainidep, 
			TAvalrescate, 
			TAvutil, 
			TAsuperavit, 
			TAfechainirev,
			TAperiodo, 
			TAmes, 
			TAfecha,
			Usucodigo
			,TAmeses 	   <!--- Cantidad de unidades a Depreciar (TAmeses)    --->
			
			,TAmontolocadq <!--- depreciacion del valor de adquisicion (TAmontolocadq) --->
			,TAmontolocmej <!--- depreciacion del valor de mejoras (TAmontolocmej) --->
			,TAmontolocrev <!--- depreciacion del valor de revaluacion (TAmontolocrev) --->
			
			,TAmontooriadq <!--- depreciacion del valor de adquisicion (TAmontooriadq) --->
			,TAmontoorimej <!--- depreciacion del valor de mejoras (TAmontoorimej) --->
			,TAmontoorirev <!--- depreciacion del valor de revaluacion (TAmontoorirev) --->
			
			,TAmontodepadq
			,TAmontodepmej
			,TAmontodeprev

			,TAvaladq
			,TAvalmej
			,TAvalrev
			
			,TAdepacumadq
			,TAdepacummej
			,TAdepacumrev
			
			,Mcodigo
			,TAtipocambio
			)
			select 
				a.Ecodigo, 		    	   <!---Empresa--->
				#idquery.identity#, 	   <!---Id Encabezado---> 
				a.Aid, 					   <!---id del Activo--->
				4, 						   <!---Id de la transaccion (4 depreciacion)--->
				a.CFid, 				   <!---Centro Funcional--->
				<cf_dbfunction name="now">,<!---Fecha del Registro--->
				b.Afechainidep, 		   <!---Fecha Inicio depreciacion--->
				b.Avalrescate, 			   <!---Valor de rescate--->
				a.AFSsaldovutiladq, 	   <!---Saldo de Vida Util de adquisición--->
				0.00, 					   <!---Superavit--->
				b.Afechainirev,			   <!---Fecha Inicio Revaluación--->
				#rsPeriodo.value#,         <!---Periodo---> 
				#rsMes.value#,             <!---Mees---> 
				<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsFechaAux.value#">,      <!---Ultimo dia del periodo-Mes Auxiliar--->
				#Arguments.usucodigo#,     <!---Usuario que genero la transaccion--->
				#Arguments.CantidadUnidades#<!---Cantidad de unidades a Depreciar --->
				
				<!---Depreciacion de Adquision - Mejora  - reevaluacion--->
				,case when (a.AFSvaladq - b.Avalrescate - a.AFSdepacumadq > 0) then round((a.AFSvaladq - b.Avalrescate-a.AFSdepacumadq )/AFSsaldovutiladq * #Arguments.CantidadUnidades# ,2) else (0.00) end 
				,case when (a.AFSvalmej -    0.00		- a.AFSdepacummej > 0) then round((a.AFSvalmej -    0.00  -a.AFSdepacummej     )/AFSsaldovutiladq * #Arguments.CantidadUnidades# ,2) else (0.00) end
				,case when (a.AFSvalrev -    0.00       - a.AFSdepacumrev > 0) then round((a.AFSvalrev -    0.00  -a.AFSdepacumrev     )/AFSsaldovutiladq * #Arguments.CantidadUnidades# ,2) else (0.00) end
				
				<!---Depreciacion de Adquision - Mejora  - reevaluacion--->
				,0.00 
				,0.00 
				,0.00 
				
				,0.00
				,0.00
				,0.00

				,AFSvaladq
				,AFSvalmej
				,AFSvalrev
				
				,AFSdepacumadq
				,AFSdepacummej
				,AFSdepacumrev
				
				,#rsMoneda.value#
				,1
			from AFSaldos a
				inner join Activos b 
					on b.Ecodigo = a.Ecodigo
					and b.Aid = a.Aid
					and <cf_dbfunction name="to_date00" args="b.Afechainidep"> <= <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsFechaAux.value#">
					and b.Astatus = 0 				<!---estado activo--->
					#filtrob#						<!---filtro por categoria / clase--->
				inner join ACategoria c 
					on c.Ecodigo = b.Ecodigo
					and c.ACcodigo = b.ACcodigo
					and c.ACmetododep = 3			<!---Metodo Depreacion por Actividad--->
				#filtrocf#							<!---filtro por oficina / departamento--->
			where a.AFSperiodo = #rsPeriodo.value#
			  and a.AFSmes = #rsMes.value#
			  and a.AFSdepreciable = 1				<!---Clasificación depreciable. Se asigna en la Adquisición, puede cambiar en el manteniemiento de AClasificacion o en el de ClasificacionCFuncional--->
			  and a.Ecodigo = #arguments.Ecodigo#
			  and a.AFSsaldovutiladq > 0
				#preservesinglequotes(filtroa)#							<!---filtro por centro funcional--->
				<!---Que no tenga Transacciones de depreciación Aplicadas para este Periodo-Mes--->
				and not exists(
					select 1 
					from TransaccionesActivos t
					where t.Aid = a.Aid
					  and t.IDtrans = 4
					  and t.TAperiodo = #rsPeriodo.value#
					  and t.TAmes = #rsMes.value#
				)
				<!---Que no tenga Transacciones pendientes de Aplicadar--->
				and not exists(
					select 1 
					from ADTProceso tp 
					where tp.Aid = a.Aid
				)
				<!---Que tenga un Documento de Responsabilidad a la fecha--->
				and exists(
					select 1
					from AFResponsables afr
					where afr.Aid = a.Aid
					and <cf_dbfunction name="now"> between afr.AFRfini and afr.AFRffin
				)
		</cfquery>
		<cfquery name="ActivosAdepreciar" datasource="#session.dsn#">
			select count(1) cantidad from ADTProceso where AGTPid = #idquery.identity#
		</cfquery>
		<cfif ActivosAdepreciar.cantidad EQ 0>
			<cfthrow message="No existen Activos a considerar en la depreciación por Actividad.">
		</cfif>
	</cftransaction>
		<cfreturn #idquery.identity#>
</cffunction>
</cfcomponent>


