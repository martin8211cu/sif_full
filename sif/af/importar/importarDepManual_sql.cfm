<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="AF_INICIO_ERROR" returnvariable="AF_INICIO_ERROR" datasource="#session.dsn#">
	<cf_dbtempcol name="Aplaca" type="char(20)" mandatory="no">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(40)" mandatory="no">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<!----Function fnisnull---->
<cffunction name="fnIsNull" access="private" returntype="boolean" output="false">
		<cfargument name="lValue" required="yes" type="any">
		<cfargument name="IValueIfNull" required="yes" type="any">
		<cfif len(trim(lValue))>
			<cfreturn lValue>
		<cfelse>
			<cfreturn lValueIfNull>
		</cfif>
	</cffunction>
<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as value 
	from Parametros p1 
	where Ecodigo = #session.Ecodigo# 
	and Pcodigo = 50
</cfquery>
<cfif (rsPeriodo.recordcount eq 0) or (rsPeriodo.recordcount gt 0 and  len(trim(rsPeriodo.value)) eq 0)>
	<cf_errorCode	code = "50078" msg = "No se encontró el periodo de auxiliares, Proceso Cancelado!">
</cfif>
<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select p1.Pvalor as value 
	from Parametros p1 
	where Ecodigo = #session.Ecodigo# 
	and Pcodigo = 60
</cfquery>
<cfif (rsMes.recordcount eq 0) or (rsMes.recordcount gt 0 and 	len(trim(rsMes.value)) eq 0)>
	<cf_errorCode	code = "50079" msg = "No se encontró el mes de auxiliares, Proceso Cancelado!">
</cfif>
<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
		<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
		<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("h",23,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("n",59,rsFechaAux.value)>
		<cfset rsFechaAux.value = DateAdd("s",59,rsFechaAux.value)>		
<!--- Obtiene la Moneda Local --->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select Mcodigo as value
	from Empresas 
	where Ecodigo = #session.Ecodigo#
</cfquery>
<cfif (rsMes.recordcount eq 0) or (rsMes.recordcount gt 0 and 	len(trim(rsMes.value)) eq 0)>
	<cf_errorCode	code = "50080"
					msg  = "No se encontró la moneda para la empresa @errorDat_1@, Proceso Cancelado!"
					errorDat_1="#session.Enombre#"
	>
</cfif>
<!---VALIDACION #0 : Verifica que los datos no estén en nulo --->	
<cfquery datasource="#session.dsn#">
	Update #table_name# 
		set TAmontolocadq = 0.00
		where TAmontolocadq is null
</cfquery>

<cfquery datasource="#session.dsn#">
	Update #table_name# 
		set TAmontolocmej = 0.00
		where TAmontolocmej is null
</cfquery>

<cfquery datasource="#session.dsn#">
	Update #table_name# 
		set TAmontolocrev = 0.00
		where TAmontolocrev is null
</cfquery>
<!---VALIDACION #1 : 400. Aplaca: valida que no sea nulo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select <CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">, {fn concat('400. Existe(n) ',{fn concat(<cf_dbfunction name="to_char" args="count(1)">,' placa(s) en blanco.')})}, <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">, 400
	from #table_name#
	where Aplaca is null
	having count(1) > 0
</cfquery>
<!---VALIDACION #2 : 410. Aplaca: Repetida en el Archivo. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select Aplaca, {fn concat('410. La Placa se encuentra ', {fn concat(<cf_dbfunction name="to_char" args="count(1)">, ' veces en el Archivo')})} as Mensaje, 
	Aplaca as DatoIncorrecto, 410 as ErrorNum
	from #table_name#
	where Aplaca is not null
	group by Aplaca
	having count(1) > 1
</cfquery>
<!---VALIDACION #3 : 420. Aplaca: base de datos exista. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, {fn concat('430. La Placa ', {fn concat(<cf_dbfunction name="to_char" args="a.Aplaca">, ' , no Existe')})} as Mensaje, 
	a.Aplaca as DatoIncorrecto, 430 as ErrorNum
	from #table_name# a
	where not exists
	(
		select 1 
			from Activos b
			where b.Ecodigo = #session.Ecodigo#
			  and b.Aplaca    = a.Aplaca
	)
	</cfquery>
<!---VALIDACION #4 : 430. Aplaca: valida que no este retirado para la empresa. --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, {fn concat('440. El Activo ', {fn concat(<cf_dbfunction name="to_char" args="a.Aplaca">, ' , Esta Retirado')})} as Mensaje, 
	a.Aplaca as DatoIncorrecto, 440 as ErrorNum
	from #table_name# a
	where exists
	(
		select 1 
			from Activos b
			where b.Ecodigo = #session.Ecodigo#
			and b.Aplaca    = a.Aplaca
			and b.Astatus=60
	)
	</cfquery>
<!---VALIDACION #5 :Activo Inconsistente(Mas de un vale vigente)--->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select
			b.Aplaca, '411. El Activo esta inconsistente, tiene mas de un vale vigente' as Mensaje, 
			b.Aplaca  as DatoIncorrecto, 411 as ErrorNum
  	from #table_name# c
		inner join Activos b
		on b.Aplaca = c.Aplaca

		inner join AFResponsables a
		on a.Aid      = b.Aid
	where b.Ecodigo = #session.Ecodigo#
	  and a.Ecodigo = #session.Ecodigo#
	  and #now()# between a.AFRfini and a.AFRffin
	group by b.Aplaca 
	having count(1) >1
</cfquery>
<!---VALIDACION #6 :Activo Inconsistente(Activo repetido en la base de datos)---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '412. El Activo esta inconsistente, la placa esta repetida en la base de datos' as Mensaje, 
	a.Aplaca as DatoIncorrecto, 412 as ErrorNum
  	from #table_name# b
		inner join Activos a
		on a.Aplaca = b.Aplaca
	where a.Ecodigo = #session.Ecodigo#
	group by a.Aplaca 
	having count(1) >1
</cfquery>
<!----VALIDACION #7 :Activo Inconsistente (El Activo se encuentra Activo y en transito a la vez)---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '413. El Activo esta inconsistente, se encuentra Activo y en transito a la vez' as Mensaje, 
	a.Aplaca as DatoIncorrecto, 412 as ErrorNum
  	from #table_name# b
		inner join Activos a
		   on a.Aplaca = b.Aplaca
		inner join CRDocumentoResponsabilidad c
		   on c.CRDRplaca = a.Aplaca         
	where a.Ecodigo = #session.Ecodigo#
</cfquery>
<!-----VALIDACION #8 :Activo no se encuentre en la lista de retiros por ser Aplicados---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '414. El activo se encuentra en una transaccion de retiro desde control de responsables' as Mensaje, 
	a.Aplaca as DatoIncorrecto, 414 as ErrorNum
  	from #table_name# b
		inner join Activos a
		   on a.Aplaca = b.Aplaca
		inner join CRCRetiros c
		   on a.Aid= c.Aid       
		where a.Ecodigo = #session.Ecodigo#
</cfquery>
<!-----VALIDACION #9 :Activo se encuentra en la cola de transaccciones de control de responsables---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '415. El activo se encuentra en la cola de Control de responsables' as Mensaje, 
	a.Aplaca as DatoIncorrecto, 415 as ErrorNum
  	from #table_name# b
		inner join Activos a
		   on a.Aplaca = b.Aplaca
		inner join CRColaTransacciones c
		   on a.Aid= c.Aid       
		where a.Ecodigo = #session.Ecodigo#
</cfquery>
<!-----VALIDACION #10 :Activo se encuentra en una transaccion pendiente de aplicar en activos Fijos---->
<cfquery datasource="#session.dsn#">
 insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, <cf_dbfunction name='concat' args="'416. El activo se encuentra en una transaccion de '+ d.AFTdes + ' pendiente de Aplicar en Activos Fijos'" delimiters='+'> as Mensaje, 
	a.Aplaca as DatoIncorrecto, 416 as ErrorNum
  	from #table_name# b
		inner join Activos a
		   on a.Aplaca = b.Aplaca
		inner join ADTProceso c
		   on a.Aid= c.Aid   
		inner join AFTransacciones d
	 	    on d.IDtrans = c.IDtrans  
		where a.Ecodigo = #session.Ecodigo#
</cfquery>
<!-----VALIDACION #11 :Activo se encuentra en una transaccion de transpaso de responsable pendiente de aplicar---->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '417. El activo se encuentra en una transaccion de traspaso de responsable pendiente de aplicar desde control de responsables' as Mensaje, 
	a.Aplaca as DatoIncorrecto, 417 as ErrorNum
  	from #table_name# b
		inner join Activos a
		   on a.Aplaca = b.Aplaca
		inner join AFResponsables c
		   on a.Aid= c.Aid  
		inner join AFTResponsables d
		   on c.AFRid = d.AFRid
		where a.Ecodigo = #session.Ecodigo#
</cfquery>

<!--- VALIDACION #12 :Verificar que el activo tiene saldos para el periodo-mes --->
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, '419. El Activo, no tiene saldos para el periodo-mes del auxiliar!' as Mensaje, 
		a.Aplaca as DatoIncorrecto, 419 as ErrorNum
	from #table_name# c
			inner join Activos a
			on a.Aplaca = c.Aplaca
	where a.Ecodigo = #session.Ecodigo#
	  and Astatus= 0
	  and 
		(
			select count(1)
			from AFSaldos b
			where a.Aid = b.Aid
			and a.Ecodigo = b.Ecodigo
			and b.AFSperiodo = #rsPeriodo.value#
			and b.AFSmes     = #rsMes.value#	  
		) = 0
</cfquery>
<!---VALIDACION #13 :Verificar que el activo no sea de una categoria de clase no depreciable --->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
		select a.Aplaca, '420. El Activo, pertenece a una categoria-clase no depreciable!' as Mensaje, 
		a.Aplaca as DatoIncorrecto, 420 as ErrorNum
	from #table_name# c
		inner join Activos a
		on a.Aplaca = c.Aplaca
	where a.Ecodigo = #session.Ecodigo#
	and exists (
			select 1
			from AFSaldos b
		   	where a.Aid = b.Aid
		    and a.Ecodigo = b.Ecodigo
			and b.AFSperiodo = #rsPeriodo.value#
	        and b.AFSmes     = #rsMes.value#	
			and b.AFSdepreciable = 0	  
			)
	</cfquery>
<!---VALIDACION #14 : Validar el Valor en libros del Activo (Debe ser mayor que cero si la transacción a importar es positiva) --->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	 select a.Aplaca, '421. El Activo, posee el Valor en libros en Cero!' as Mensaje, 
	 a.Aplaca as DatoIncorrecto, 421 as ErrorNum
	from #table_name# c
		inner join Activos a
		on a.Aplaca = c.Aplaca
		
		inner join AFSaldos b
		on b.Aid = a.Aid
	
	where a.Ecodigo    = #session.ecodigo#
	  and c.TAmontolocadq > 0
	  and b.AFSperiodo = #rsPeriodo.value#
	  and b.AFSmes 	   = #rsMes.value#
	  and ((AFSvaladq + AFSvalmej + AFSvalrev) - (AFSdepacumadq + AFSdepacummej + AFSdepacumrev)) <= 0
</cfquery>
<!---VALIDACION #15 : Validar el Saldo de VU del Activo (Debe ser mayor que cero) --->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	 select a.Aplaca, '422. El Activo, posse el saldo de la vida Util en Cero!' as Mensaje, 
	 a.Aplaca as DatoIncorrecto, 422 as ErrorNum
	from #table_name# c
		inner join Activos a
		on a.Aplaca = c.Aplaca

		inner join AFSaldos b
		on b.Aid = a.Aid
	where a.Astatus=0
	  and c.TAmontolocadq > 0
	  and a.Ecodigo 	 = #session.ecodigo#
	  and b.AFSperiodo   = #rsPeriodo.value#
	  and AFSmes 	     = #rsMes.value#	 
	  and b.AFSsaldovutiladq = 0
</cfquery>	
<!---VALIDACION #16 : Verifica que el activo no este depreciado ya para este mismo periodo-mes--->
<cfquery datasource="#session.dsn#">
    insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select 
		a.Aplaca, '423. El Activo, ya esta depreciado para este mismo periodo-mes!' as Mensaje, 
		a.Aplaca as DatoIncorrecto, 423 as ErrorNum
	from #table_name# c
		inner join Activos a
		on a.Aplaca = c.Aplaca
	where a.Ecodigo = #session.Ecodigo#
	and exists 
			(
			select 1
			from TransaccionesActivos b
				where b.Ecodigo = a.Ecodigo
				and b.Aid     = a.Aid
				and TAperiodo  = #rsPeriodo.value#
				and TAmes      = #rsMes.value#
				and IDtrans    = 4
			)
</cfquery>	


<cfquery datasource="#session.dsn#">
 insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	 select Aplaca, '424. No es posible Realizar la transacción de depreciación porque todos los montos están en cero!' as Mensaje, 
	 <cf_dbfunction name="to_char" args="Aplaca"> as DatoIncorrecto, 424 as ErrorNum
	 from #table_name# 
	 	where TAmontolocadq = <cfqueryparam cfsqltype="cf_sql_money" value="0">
		and TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="0">
		and TAmontolocrev = <cfqueryparam cfsqltype="cf_sql_money" value="0">
</cfquery>

<!---VALIDACION #18 : Verifica depreciación adquisicion --->
<cf_dbfunction name="to_char" args="c.AFSdepacumadq" returnvariable='LvarAFSdepacumadq'>
<cf_dbfunction name="to_char" args="((c.AFSvaladq - b.Avalrescate) - c.AFSdepacumadq)" returnvariable='LvarRestaDepacumadq'>
<cf_dbfunction name="concat" args="'426. El valor de depreciación de adquisición digitado esta fuera del rango permitido (' + #LvarAFSdepacumadq# + ' a ' + #LvarRestaDepacumadq# + ')'" delimiters='+' returnvariable="LvarMensajeADQ"> 

<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	select a.Aplaca, 
    	#PreserveSingleQuotes(LvarMensajeADQ)# as Mensaje, 
	 	a.Aplaca as DatoIncorrecto, 
        426 as ErrorNum
	from #table_name# a
			inner join Activos b
				on a.Aplaca = b.Aplaca
			inner join AFSaldos c
				on  c.Aid 		 = b.Aid
				and c.Ecodigo	 = b.Ecodigo
	where b.Ecodigo  = #session.Ecodigo#
	and c.AFSperiodo = #rsPeriodo.value#
	and c.AFSmes 	 = #rsMes.value#
	and (
		(a.TAmontolocadq > 0 and  ((c.AFSvaladq - b.Avalrescate) - c.AFSdepacumadq) < a.TAmontolocadq ) 
		or 
		(a.TAmontolocadq < 0 and  c.AFSdepacumadq < abs(a.TAmontolocadq))
		)					
</cfquery>	
<!---VALIDACION #19 : Verifica depreciación Mejoras--->	
<cf_dbfunction name="to_char" args="c.AFSdepacummej" returnvariable="LvarAFSdepacummej">
<cf_dbfunction name="to_char" args="(c.AFSvalmej - c.AFSdepacummej)" returnvariable="LvarResta">
<cf_dbfunction name="concat" args="'427. El valor de depreciación de Mejoras digitado esta fuera del rango permitido (' + #LvarAFSdepacummej# +' a ' + #LvarResta# + ')'" delimiters='+' returnvariable="LvarMensajeMEJ"> 

<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	    select a.Aplaca, 
        #PreserveSingleQuotes(LvarMensajeMEJ)# as Mensaje, 
	 	a.Aplaca as DatoIncorrecto, 
        427 as ErrorNum
	from #table_name# a
		inner join Activos b
			on a.Aplaca = b.Aplaca
		inner join AFSaldos c
			on  c.Aid 		 = b.Aid
			and c.Ecodigo	 = b.Ecodigo
	where b.Ecodigo    = #session.Ecodigo#
	  and c.AFSperiodo = #rsPeriodo.value#
	  and c.AFSmes 	   = #rsMes.value#
	  and (
		(a.TAmontolocmej > 0 and  (c.AFSvalmej - c.AFSdepacummej) < a.TAmontolocmej ) 
		 or 
		(a.TAmontolocmej < 0 and   c.AFSdepacummej < abs(a.TAmontolocmej))
		)					
</cfquery>	

<!---VALIDACION #20 : Verifica depreciación Revaluación--->	
<cf_dbfunction name="to_char" args="c.AFSdepacumrev" returnvariable='LvarAFSdepacumrev'>
<cf_dbfunction name="to_char" args="(c.AFSvalrev - c.AFSdepacumrev)" returnvariable='LvarRestarev'>
<cf_dbfunction name="concat" args="'428. El valor de depreciación de Revaluación digitado esta fuera del rango permitido (' + #LvarAFSdepacumrev# + ' a ' + #LvarRestarev# + ')'" delimiters='+' returnvariable="LvarMensajeRev"> 
<cfquery datasource="#session.dsn#">
	insert into #AF_INICIO_ERROR# (Aplaca, Mensaje, DatoIncorrecto, ErrorNum)
	    select a.Aplaca, 
        #PreserveSingleQuotes(LvarMensajeRev)# as Mensaje, 
	 	a.Aplaca as DatoIncorrecto, 
        428 as ErrorNum
	from #table_name# a
		inner join Activos b
			on a.Aplaca = b.Aplaca
		inner join AFSaldos c
			on  c.Aid 		 = b.Aid
			and c.Ecodigo	 = b.Ecodigo
	where b.Ecodigo  = #session.Ecodigo#
	and c.AFSperiodo = #rsPeriodo.value#
	and c.AFSmes 	 = #rsMes.value#
	and (
	 		(a.TAmontolocrev > 0 and  (c.AFSvalrev - c.AFSdepacumrev) < a.TAmontolocrev ) 
		 or 
		 	(a.TAmontolocrev < 0 and   c.AFSdepacumrev < abs(a.TAmontolocrev))
		)					
</cfquery>	

<cfquery name="err" datasource="#session.dsn#">
	select Aplaca, Mensaje
	from #AF_INICIO_ERROR#
	order by Aplaca, ErrorNum
</cfquery>
<!---Inserta las depreciación ---->
<cfif (err.recordcount) EQ 0>
	<cfquery datasource="#Session.Dsn#">
		insert into ADTProceso (
		 Ecodigo,  
		 AGTPid, 	 
		 Aid, 
		 IDtrans, 
		 CFid, 	 
		 TAfalta, 
		 TAfechainidep, 	 
		 TAvalrescate, 
		 TAvutil,  
		 TAsuperavit, 
		 TAfechainirev,
		 TAperiodo, 
		 TAmes,  
		 TAfecha,
		 Usucodigo,
		 TAmeses, 
		 TAmontolocadq, 
		 TAmontooriadq, 
		 TAmontolocmej, 
		 TAmontoorimej, 
		 TAmontolocrev, 
		 TAmontoorirev, 					
		 TAmontodepadq,
		 TAmontodepmej,
		 TAmontodeprev,
		 TAvaladq,
	     TAvalmej,
		 TAvalrev,
						
		 TAdepacumadq,
		 TAdepacummej,
		 TAdepacumrev,
						
		 Mcodigo,
		 TAtipocambio
			)
		select      
		 a.Ecodigo,  
		 #Form.AGTPid# as AGTPid,  
		 a.Aid, 
		 4 as IDtrans, 
		 c.CFid,
		 #now()# as TAfalta, 
		 a.Afechainidep as TAfechainidep,  
		 a.Avalrescate as TAvalrescate, 
		 c.AFSsaldovutiladq as TAvutil, 
		 0.00 as TAsuperavit,
		 a.Afechainirev as TAfechainirev,
		 #rsPeriodo.value# as TAperiodo, 
		 #rsMes.value# as TAmes,
		 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#"> as TAfecha,
		 #Session.Usucodigo#,
		 ( b.TAmontolocadq / (c.AFSvaladq - a.Avalrescate)) * c.AFSvutiladq as TAmeses, 
		 b.TAmontolocadq,
		 0.00,
		 b.TAmontolocmej,
		 0.00,
		 b.TAmontolocrev,
		 0.00,
		 
		 0.00,
		 0.00,
		 0.00,
		 
		 c.AFSvaladq, 
		 c.AFSvalmej, 
		 c.AFSvalrev,

		 c.AFSdepacumadq, 
		 c.AFSdepacummej, 
		 c.AFSdepacumrev, 

		 #rsMoneda.value#,
		 1
		from #table_name# b
			inner join Activos a
				on a.Aplaca = b.Aplaca
			inner join AFSaldos c
				on c.Ecodigo = a.Ecodigo
			   and c.Aid = a.Aid	
		where a.Ecodigo = #session.Ecodigo#
		  and c.AFSperiodo  = #rsPeriodo.value#
		  and c.AFSmes      = #rsMes.value#		
	</cfquery>
</cfif>
