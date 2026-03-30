<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 


<!---creo la tabla temporal--->
<cfquery  name="rsImportador" datasource="#session.dsn#">
	select * from #table_name# 
</cfquery>

<!---Llamo al archivo txt--->
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

	<!---Variables--->
	<cfquery name="rsAid" datasource="#session.dsn#">
		select Aid 
		from Activos 
		where Aplaca='#rsImportador.Aplaca#'
		and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset Aidactivo= rsAid.Aid>
	
	
	<cfquery name="rsPeriodo" datasource="#session.dsn#">
		select Pvalor
		from Parametros 
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 50
	</cfquery>
	
	<cfquery name="rsMes" datasource="#session.dsn#">
		select Pvalor
		from Parametros 
		where Ecodigo = #session.Ecodigo#
		and Pcodigo = 60
	</cfquery>
	
	<cfquery name="rsMoneda" datasource="#session.dsn#">
		select Mcodigo as value
		from Empresas 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
			
	<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
	<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.Pvalor,01), fnIsNull(rsMes.Pvalor,01), 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
	
	<!---Validar archivo de texto--->
	<!--- Existencia de lineas blancas en el archivo de texto--->

	<cfif  len(trim(rsImportador.Aplaca)) eq 0 or len(trim(rsImportador.Avutil)) eq 0 or len(trim(rsImportador.TAmontolocmej)) eq 0>
		<cfquery name="ERR" datasource="#session.DSN#"><!--- Valida que la vida util no sea menor que cero--->
			insert into #errores# (Error)
			values ('Error! Existen Columnas en el archivo que estan en blanco')
		</cfquery>
	</cfif>
	
	<!---Validacion #1: Existencia del Activo--->
	<cfif isdefined("rsAid") and rsAid.recordcount eq 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error! El activo no existe')
		</cfquery>
	</cfif>
	
	<cfif len(trim(Aidactivo)) neq 0>
		<!---Validacion #2: Estado del activo--->		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Aid
			from Activos
			where Aid = #Aidactivo#	
				and Astatus = 0 	<!--- 0 es activo --->		
		</cfquery>					
			
		<cfif isdefined("rsSQL") and rsSQL.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! La placa #rsImportador.Aplaca# está inactiva')
			</cfquery>
		</cfif>	
		
		<!---Validacion #3: Periodo y mes--->			
		<cfquery name="rsSQL" datasource="#session.dsn#">
				select a.Aid
				from Activos a
					inner join AFSaldos s
						on s.Aid = a.Aid 
				       and s.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Pvalor#"> 
				       and s.AFSmes		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Pvalor#">
					   and s.Ecodigo    = a.Ecodigo
				where 
				a.Astatus =0 
				and a.Aid = #Aidactivo#					
		</cfquery>
		<cfif isdefined("rsSQL") and rsSQL.recordcount eq 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! El Activo con la placa #rsImportador.Aplaca# no tiene Saldos para el Periódo #rsPeriodo.Pvalor# y mes #rsMes.Pvalor#! Proceso Cancelado!')
			</cfquery>
		</cfif>	
		
		<!---Validacion #4 : Monto de vida util--->		
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			select s.AFSsaldovutiladq 
			from AFSaldos s
				inner join Activos a
				on a.Aid=s.Aid
				<!---and a.Astatus=0 --->
			where
				s.Aid= #Aidactivo#
				and s.AFSperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Pvalor#"> 
				and s.AFSmes=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Pvalor#">		
				and s.Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfset valor=#rsSQL1.AFSsaldovutiladq#>
		
		<cfif rsImportador.Avutil lt 0 and len(trim(rsImportador.Avutil)) gt 0>
			<cfif len(trim(rsImportador.Avutil)) gt 0 and rsSQL1.AFSsaldovutiladq lte abs(rsImportador.Avutil)>
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
					values ('Error! El valor que se desea incluir en vida útil es mayor o igual que el saldo de la vida util del Activo (Placa=#rsImportador.Aplaca#)!. Proceso Cancelado.')
				</cfquery>
			</cfif>	
			
			<cfset AFSsaldovutiladq=rsSQL1.AFSsaldovutiladq>
			<cfset Avutil=rsImportador.Avutil>	
			
			<cfif len(trim(AFSsaldovutiladq)) eq 0>
			<cfset AFSsaldovutiladq=0>
			</cfif>	
			
			<cfif len(trim(Avutil)) eq 0>
			<cfset Avutil=0>
			</cfif>				
			
			<cfset totalVU= #AFSsaldovutiladq#+#Avutil#>					
		</cfif>

		<cfquery name="rsSaldoPendienteDep" datasource="#session.dsn#">
			select AFSvalmej, AFSdepacummej
			from AFSaldos
			where Aid= #Aidactivo#
				and AFSperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Pvalor#"> 
				and AFSmes=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Pvalor#">
				and Ecodigo=#session.Ecodigo#
		</cfquery>
		
		<cfset AFSvalmej=rsSaldoPendienteDep.AFSvalmej>		
		<cfset AFSdepacummej=rsSaldoPendienteDep.AFSdepacummej>		
		<cfset LvarTAmontolocmej=rsImportador.TAmontolocmej>		
		
		<cfif len(trim(rsSaldoPendienteDep.AFSvalmej)) eq 0>
			<cfset AFSvalmej=0>
		</cfif>	
		
		<cfif len(trim(rsSaldoPendienteDep.AFSdepacummej)) eq 0>
			<cfset AFSdepacummej=0>
		</cfif>	
		
		<cfif len(trim(rsImportador.TAmontolocmej)) eq 0>
			<cfset LvarTAmontolocmej=0>
		</cfif>	
		
		<cfset totalT= (AFSvalmej-AFSdepacummej) + LvarTAmontolocmej>
	
		<!---Validacion #5: Monto de incremento--->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select ( coalesce(min(AFSvalmej),0) -  coalesce(min(AFSdepacummej), 0) ) as saldo_pen_dep, count(1) as cantidad
			from AFSaldos
			where Aid= #Aidactivo#
				and AFSperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Pvalor#"> 
				and AFSmes=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Pvalor#">
				and Ecodigo=#session.Ecodigo#
				and (AFSvalmej - AFSdepacummej ) > abs(#LvarTAmontolocmej#)
		</cfquery>

		<cfif rsImportador.TAmontolocmej lt 0>
			<cfif abs(rsSQL.cantidad) eq 0>
				<cfquery name="ERR" datasource="#session.DSN#">
						insert into #errores# (Error)
						values ('Error! El saldo de la mejora debe no puedes ser menor que 0 (Placa: #rsImportador.Aplaca#.  Saldo pendiente a depreciar: #AFSvalmej - AFSdepacummej# + Incremento a importar: #numberformat(LvarTAmontolocmej,',_.__')# = #(AFSvalmej - AFSdepacummej) + LvarTAmontolocmej#)!')
				</cfquery>
			</cfif>
		</cfif>	
	
		<!---Validacion #6: Vida util - monto +Eliminada--->
		
				
		<!---Validacion #8: Existencia del Activo en la misma relacion--->
		<cfquery datasource="#session.dsn#" name="slBusca">
			select count(1) as cantidad
			from AGTProceso e
				inner join ADTProceso  d
					on d.AGTPid = e.AGTPid
			where d.AGTPid = #form.AGTPid#	
			  and d.Aid = #Aidactivo#	   
		</cfquery>
		<cfif slBusca.cantidad gt 0 >
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error, La placa #rsImportador.Aplaca# ya existe en la relación!')
			</cfquery>
		</cfif>

	
		<!---Validacion #9: Existencia del Activo en el archivo de texto--->
			<cfquery datasource="#session.dsn#" name="slBusca">
				select Aplaca, count(1) as cantidad
				from #table_name# 
				where Aplaca = '#rsImportador.Aplaca#'
				group by Aplaca
				having count(1)>1
			</cfquery>
			<cfif slBusca.cantidad gt 0 >
				<cfquery name="ERR" datasource="#session.DSN#">
					insert into #errores# (Error)
					values ('Error! La Placa (#rsImportador.Aplaca#) esta repetida en el archivo!')
				</cfquery>
			</cfif>
			
		<!---Validacion #10: Existencia en Depresición--->
		<cfquery name="rsRevisaPendDepreciacion" datasource="#session.dsn#">
			Select count(1) as total
			from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid     = #Aidactivo#	
			  and IDtrans = 4
		</cfquery>  		
		<cfif rsRevisaPendDepreciacion.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! No es posible asociar el Activo(#rsImportador.Aplaca#), ya que se encuentran dentro de una transaccion de Depreciacion pendiente de aplicar!!')
			</cfquery>
		</cfif>

		<!---Validacion #11: Existencia en Depreciacion--->
		<cfquery name="rsRevisaPendRevaluacion" datasource="#session.dsn#">
			Select count(1) as total
			from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid     = #Aidactivo#	
			  and IDtrans = 3
		</cfquery>  		
		<cfif rsRevisaPendRevaluacion.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! No es posible asociar el Activo(#rsImportador.Aplaca#), ya que se encuentran dentro de una transaccion de Revaluacion pendiente de aplicar!')
			</cfquery>
		</cfif>
		<!---Validacion #12: Existencia en Retiros--->
		<cfquery name="rsRevisaPendRetiros" datasource="#session.dsn#">
			Select count(1) as total
			from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid     = #Aidactivo#	
			  and IDtrans = 5							   
		</cfquery>  	
		<cfif rsRevisaPendRetiros.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! No es posible asociar el Activo(#rsImportador.Aplaca#), ya que se encuentran dentro de una transaccion de Retiro pendiente de aplicar!')
			</cfquery>
		</cfif>
		<!---Validacion #13: Existencia en Mejoras--->
		<cfquery name="rsRevisaPendMej" datasource="#session.dsn#">
			Select count(1) as total
			from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid     = #Aidactivo#	
			  and IDtrans = 2
		</cfquery>
		<cfif rsRevisaPendMej.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! No es posible asociar el Activo(#rsImportador.Aplaca#), ya que tiene otra Mejora anterior pendiente de aplicar!')
			</cfquery>
		</cfif>
		<!---Validacion #14: Existencia en Cambio Categoria Clase--->
		<cfquery name="rsRevisaPendCatClas" datasource="#session.dsn#">
			Select count(1) as total
			from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid     = #Aidactivo#	
			  and IDtrans = 6
		</cfquery>  	
		<cfif rsRevisaPendCatClas.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! No es posible asociar el Activo(#rsImportador.Aplaca#), ya que se encuentran dentro de una transaccion de Cambio Categoria Clase pendiente de aplicar!')
			</cfquery>
		</cfif>
		<!---Validacion #15: Existencia en transaccion pendiente de traslado--->
		<cfquery name="rsRevisaPendTras" datasource="#session.dsn#">
			Select count(1) as total
			from ADTProceso
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Aid     = #Aidactivo#	
			  and IDtrans = 8
		</cfquery> 		
		<cfif rsRevisaPendTras.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error! No es posible asociar el Activo(#rsImportador.Aplaca#), ya que se encuentran dentro de una transaccion de Traslado pendiente de aplicar!')
			</cfquery>
		</cfif>		
	</cfif>

	<cfset session.Importador.SubTipo = "2">	
	<cfif (rsImportador.currentRow mod 179 EQ 0)>
		<cfoutput>
			<!-- Flush:
			#repeatString("*",1024)#
			-->
		</cfoutput>
		<!--- veamos si hay que cancelar el proceso --->
		<cfflush interval="64">
	</cfif>
	
	<cfquery name="rsEncabezado" datasource="#session.dsn#">
		select AGTPrazon,FCFid  
		from AGTProceso 
		where AGTPid=#form.AGTPid#	
	</cfquery>
				
	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	
	<cfif rsErrores.cantidad eq 0>
		<cfset totalVU= #rsSQL1.AFSsaldovutiladq#+#rsImportador.Avutil#>
		<cfquery datasource="#session.dsn#">
			insert into ADTProceso
				(Ecodigo
				,AGTPid
				,Aid
				,IDtrans
				,CFid
				,TAfalta
				,TAfechainidep
				,TAvalrescate
				,TAvutil
				,TAsuperavit
				,TAfechainirev
				,ADTPrazon
				,TAperiodo
				,TAmes
				,TAfecha
				,Usucodigo
				,TAmeses 
				,TAmontolocadq
				,TAmontooriadq 
				,TAmontolocmej
				,TAmontoorimej 
				,TAmontolocrev
				,TAmontoorirev						
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
				#session.Ecodigo#
				,#form.AGTPid# 
				,#Aidactivo#
				,2
				,a.CFid
				,<cf_dbfunction name="now"> as TAfalta
				,b.Afechainidep
				,b.Avalrescate
				,#rsImportador.Avutil#
				,0.00
				,b.Afechainirev
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.AGTPrazon#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.Pvalor#"> 
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.Pvalor#"> 
				,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				,0
				,0.00
				,0.00
				,#rsImportador.TAmontolocmej#
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
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">
				,1
			from AFSaldos a
					inner join Activos b 
					on b.Aid = a.Aid
					
			where 	a.Aid = <cfqueryparam value="#Aidactivo#" cfsqltype="cf_sql_numeric">
					and a.AFSperiodo = <cfqueryparam value="#rsPeriodo.Pvalor#" cfsqltype="cf_sql_numeric">
					and a.AFSmes = <cfqueryparam value="#rsMes.Pvalor#" cfsqltype="cf_sql_numeric">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
					and b.Astatus = 0 	<!--- estado activo --->
						<!---and a.Aid not in (
												select xyz.Aid
												from ADTProceso xyz
													where xyz.Ecodigo = a.Ecodigo
														and xyz.Aid = a.Aid
														and xyz.TAperiodo = a.AFSperiodo
														and xyz.TAmes = a.AFSmes
														and xyz.IDtrans = 2	)--->
		</cfquery>
	</cfif>
</cfloop>		


<cfif rsErrores.cantidad gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
		order by Error
	</cfquery>
	<cfreturn>		
</cfif>

<cfset session.Importador.SubTipo = 3>

<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
	<cfargument name="lValue" required="yes" type="any">
	<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
</cffunction>

