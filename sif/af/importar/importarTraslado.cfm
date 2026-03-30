<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbtemp name="TempTrasAct_v1" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" 		type="varchar(255)" 	mandatory="yes">
	<cf_dbtempcol name="ErrorNum" 		type="integer" 			mandatory="yes">
	<cf_dbtempcol name="DatoIncorrecto" type="varchar(255)" 	mandatory="no">
</cf_dbtemp>
<!---
		Activos Origen 
			1.	valida periodo Auxilar
			2.	valida Mes Auxilar
			3.	Valida que el Activos Origen exista
			4.	Valida que el Activo  Origen no este retirado
			5.	Valida que el Activo  Origen tenga Saldos
			6.	Valida que el Activo  Origen No tenga transacciones pendientes de aplicar
		Activos Destino Existentes
			7.	Valida que el Activo Destino no este retirado 
			8.	Valida que el Activo Destino tenga saldos.
			9.	Valida que el Activo Destino no tenga transacciones pendientes de aplicar
			10.	Valida que el Activo Origen y el Activo Destino sean Distintos
		Activos no Existentes
			11.	Valida que el Activo Destino no sea un Activo en transito.
			12.	Valida que el Activo Destino no este recibiendo un traslado.
		Otros
			13. Placa Origen o Destino vacias
			14. Montos del translados no vacios
			15. Valida que el porcentaje o el monto del traslado sobrepase el 100%
			16. Valida que la descripcion y la razon sean distintos a vacio
			17. Valida que la placa destino no este repetida en el Archivo
----->
<!---Eliminamos Espacios en blanco--->
<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set PLACAOrigen = rtrim(ltrim(PLACAOrigen))
	where <cf_dbfunction name="length"  args="PLACAOrigen"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(PLACAOrigen))">   
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set PLACADestino = rtrim(ltrim(PLACADestino))
	where <cf_dbfunction name="length"  args="PLACAOrigen"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(PLACADestino)) "> 
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set DESCTraslado = rtrim(ltrim(DESCTraslado))
	where  <cf_dbfunction name="length"  args="DESCTraslado"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(DESCTraslado))">    
</cfquery>
<cfquery datasource="#Session.DSN#">
	update #table_name#
	 set RAZONTraslado = rtrim(ltrim(RAZONTraslado))
	where <cf_dbfunction name="length"  args="RAZONTraslado"> <> <cf_dbfunction name="length"  args="rtrim(ltrim(RAZONTraslado))">     
</cfquery>
<!---Validacion 1.--->
	<cfquery name="rsPeriodo" datasource="#Session.DSN#">
		select Pvalor as value
		from Parametros
		where Ecodigo =  #session.Ecodigo# 
			and Pcodigo = 50
			and Mcodigo = 'GN'
	</cfquery>
	<cfif rsPeriodo.recordcount EQ 0>
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
			select 'El periodo de Axiliares no esta definido', 1,'Periodo'
	</cfif>
<!---Validacion 2.--->
	<cfquery name="rsMes" datasource="#Session.DSN#">
		select Pvalor as value
		from Parametros
		where Ecodigo =  #session.Ecodigo# 
			and Pcodigo = 60
			and Mcodigo = 'GN'
	</cfquery>
	<cfif rsMes.recordcount EQ 0>
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
			select 'El Mes de Axiliares no esta definido', 2,'Periodo'
	</cfif>	
<!---Validacion 3.--->
	<cfquery name="rsCheck3" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		  select 'La placa Origen ' #_Cat# PLACAOrigen #_Cat# 'no existe.',3, PLACAOrigen
		    from #table_name# b
		  where <cf_dbfunction name="length"  args="PLACAOrigen">  > 0 
			and PLACAOrigen is not null 
			and not exists (select 1 
							  from Activos a 
							where rtrim(a.Aplaca) = b.PLACAOrigen
							  and a.Ecodigo =  #session.Ecodigo# 
								)
	</cfquery>	
<!---Validacion 4.--->
	<cfquery name="rsCheck4" datasource="#Session.Dsn#">
	insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		Select 'El archivo de importaci&oacute;n contiene la placa Origen: ' #_Cat# PLACAOrigen #_Cat# ' que esta retirada',4,PLACAOrigen
			from #table_name# a	
				inner join Activos b
					on rtrim(b.Aplaca) = a.PLACAOrigen
					and b.Astatus = 60
					and b.Ecodigo =  #session.Ecodigo# 
				inner join TransaccionesActivos c
					on c.Ecodigo = b.Ecodigo 
					and c.Aid = b.Aid	
					and c.IDtrans = 5
	</cfquery>
<!---Validacion 5.--->
	<cfquery name="rsCheck5" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select 'El archivo de importaci&oacute;n contiene el Activo origen:' #_Cat# PLACAOrigen #_Cat# ' el cual no posee Saldos en el actual Periodo Mes', 5,PLACAOrigen
		from #table_name# a
			inner join Activos c 
				on rtrim(c.Aplaca) = a.PLACAOrigen
				and c.Astatus = 0
				and c.Ecodigo =  #session.Ecodigo# 
		where not exists ( select 1
							from AFSaldos b 
								where b.Aid = c.Aid
								and b.Ecodigo = c.Ecodigo
								and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">
								and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.value#">
						 )
	</cfquery>
<!---Validacion 6.--->
	<cfquery name="rsCheck6" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)		
			select 'El archivo de importaci&oacute;n contiene la Placa Origen: ' #_Cat# d.PLACAOrigen #_Cat# ' se encuentra en una transaccion de ' #_Cat# c.AFTdes #_Cat# ' Pendiente de Aplicar!', 6, d.PLACAOrigen
				from Activos a
					inner join ADTProceso b
						on a.Aid = b.Aid
						and a.Ecodigo = b.Ecodigo
				inner join AFTransacciones c
					on b.IDtrans = c.IDtrans
				inner join #table_name# d
					on d.PLACAOrigen = rtrim(a.Aplaca)
				where a.Astatus = 0
					and a.Ecodigo =  #session.Ecodigo# 
	</cfquery>
	<cfquery name="ExisteActivoDestino" datasource="#Session.DSN#">
		select *
			from Activos a
				inner join #table_name# b
					on rtrim(a.Aplaca) = b.PLACADestino 
	</cfquery>
<cfif ExisteActivoDestino.recordcount GT 0> 
<!---Validacion 7.--->
 	<cfquery name="rsCheck7" datasource="#Session.Dsn#">
	insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		Select 'El archivo de importaci&oacute;n contiene la placa Destino: ' #_Cat# PLACADestino #_Cat# ' que esta retirada',7,PLACADestino
			from #table_name# a	
				inner join Activos b
					on rtrim(b.Aplaca) = a.PLACADestino
					and b.Astatus = 60
					and b.Ecodigo =  #session.Ecodigo# 
				inner join TransaccionesActivos c
					on c.Ecodigo = b.Ecodigo 
					and c.Aid = b.Aid	
					and c.IDtrans = 5
	</cfquery>
<!---Validacion 8.--->
	<cfquery name="rsCheck8" datasource="#Session.Dsn#">				
	insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select 'El archivo de importaci&oacute;n contiene el Activo Destino:' #_Cat# PLACADestino #_Cat# ' el cual no posee Saldos en el actual Periodo Mes', 8,PLACADestino
		from #table_name# a
			inner join Activos c 
				on rtrim(c.Aplaca) = a.PLACADestino
				and c.Astatus = 0
				and c.Ecodigo =  #session.Ecodigo# 
		where not exists ( select 1
							from AFSaldos b 
								where b.Aid = c.Aid
								and b.Ecodigo = c.Ecodigo
								and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">
								and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.value#">
						 )
	 </cfquery>
<!---Validacion 9.---> 
	 <cfquery name="rsCheck9" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)		
			select 'El archivo de importaci&oacute;n contiene la Placa Destino: ' #_Cat# d.PLACADestino #_Cat# ' se encuentra en una transaccion de ' #_Cat# c.AFTdes #_Cat# ' Pendiente de Aplicar!', 9, d.PLACADestino
				from Activos a
					inner join ADTProceso b
						on a.Aid = b.Aid
						and a.Ecodigo = b.Ecodigo
				inner join AFTransacciones c
					on b.IDtrans = c.IDtrans
				inner join #table_name# d
					on d.PLACADestino = rtrim(a.Aplaca)
				where a.Astatus = 0
					and a.Ecodigo =  #session.Ecodigo# 
	</cfquery>
<!---Validacion 10.--->
	<cfquery name="rsCheck10" datasource="#Session.Dsn#">
             insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
                select 'La placa Origen ' #_Cat# PLACAOrigen #_Cat# ' y la placa Destino ' #_Cat# PLACADestino #_Cat# 'son iguales.',10, PLACAOrigen
                    from #table_name# b
                       where rtrim(ltrim(PLACAOrigen)) = rtrim(ltrim(PLACADestino))
     </cfquery>         
<cfelse>
<!---Validacion 11.--->
<cfquery name="rsCheck11" datasource="#session.dsn#">
	insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select 'La placa Destino ' #_Cat# a.PLACADestino #_Cat# 'esta en tránsito.',11, a.PLACADestino
			from #table_name# a	
				inner join CRDocumentoResponsabilidad b
					on a.PLACADestino = rtrim(b.CRDRplaca)
				where b.Ecodigo =  #session.Ecodigo# 
</cfquery>


<!---Validacion 12.--->	
  <cfquery name="rsCheck12" datasource="#Session.Dsn#">
   	insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)                  
        select 'El archivo de importaci&oacute;n contiene la Placa Destino: ' #_Cat# a.PLACADestino #_Cat# ' se encuentra recibiendo un traslado Pendiente de Aplicar!', 12, a.PLACADestino
			from #table_name# a	
				inner join ADTProceso b
					on a.PLACADestino = rtrim(b.Aplacadestino) 
					where Ecodigo=  #session.Ecodigo# 
					and IDtrans   = 8
		</cfquery>


</cfif>
<!---Validacion 13.--->	
	<cfquery name="rsCheck13" datasource="#Session.Dsn#">
			insert into #ERRORES_TEMP# (Mensaje, ErrorNum)
			  select 'El archivo de importaci&oacute;n contiene Placas Origen o Destino con valores vacios ',13
			from #table_name#
			where (<cf_dbfunction name="length"  args="PLACAOrigen">  <= 0 
				or <cf_dbfunction name="length"  args="PLACAOrigen"> <= 0 
				or PLACAOrigen is null 
				or PLACADestino is null)
	</cfquery>
<!---Validacion 14.--->
	<cfquery name="rsCheck14" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
			select 'En el archivo de importaci&oacute;n la placa Origen ' #_Cat# PLACAOrigen #_Cat# ' tiene el Porcentaje de Traslado vacio o el valor no es válido ',14,PLACAOrigen 
			from #table_name#
			  where coalesce(<cf_dbfunction name="to_float" args="PORCTraslado">,0) = 0 
				and coalesce(<cf_dbfunction name="to_float" args="MONTOTrasladoAdq">,0) = 0 
				and coalesce(<cf_dbfunction name="to_float" args="MONTOTrasladoMej">,0) = 0 
				and coalesce(<cf_dbfunction name="to_float" args="MONTOTrasladoRev">,0) = 0
	</cfquery>
<!---Validacion 15.--->
	<cfquery name="rsCheck15" datasource="#Session.Dsn#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
			select 'El archivo de importaci&oacute;n contiene el Activo origen ' #_Cat# PLACAOrigen #_Cat# ' el cual tiene el Total de Montos o Porcentajes mayor al 100% de su existencia',
					15,PLACAOrigen	
			from #table_name# a
				inner join Activos c 
					on rtrim(c.Aplaca) = a.PLACAOrigen
					and c.Ecodigo =  #session.Ecodigo# 
				inner join AFSaldos b 
					on b.Aid = c.Aid
					and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">
					and b.AFSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.value#">
					and b.Ecodigo = c.Ecodigo
				where 
				coalesce((coalesce(a.PORCTraslado,0) * coalesce(b.AFSvaladq,0) / 100),  coalesce(a.MONTOTrasladoAdq,0)) > AFSvaladq or
				coalesce((coalesce(a.PORCTraslado,0) * coalesce(b.AFSvalmej,0) / 100),  coalesce(a.MONTOTrasladoMej,0)) > AFSvalmej or
				coalesce((coalesce(a.PORCTraslado,0) * coalesce(b.AFSvalrev,0) / 100),  coalesce(a.MONTOTrasladoRev,0)) > AFSvalrev
	</cfquery>
<!---Validacion 16.--->
	<cfquery name="rsCheck16" datasource="#Session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje, ErrorNum, DatoIncorrecto)
		select 'La placa Origen ' #_Cat# PLACAOrigen #_Cat# ' del archivo de importaci&oacute;n tiene la Descripcion o la Razón con valores vacios',16, PLACAOrigen
		from #table_name#
		where (<cf_dbfunction name="length"  args="DESCTraslado"> <= 0 
			or <cf_dbfunction name="length"  args="RAZONTraslado"><= 0
			or DESCTraslado is null 
			or RAZONTraslado is null)
	</cfquery>
<!---Validacion 17.--->
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
			Select 'la placa destino: ' #_Cat# PLACADestino #_Cat# ' esta mas de una vez en el Archivo',17
				from #table_name#
			group by PLACADestino
			having count(1) > 1
		</cfquery>	
<!---Mostrar Errore--->
<cfquery name="err" datasource="#session.dsn#">
	select ErrorNum as Error, Mensaje, DatoIncorrecto 
	from #ERRORES_TEMP#
	order by Error
</cfquery>

<cfif (err.recordcount) EQ 0>
<!---Fecha Auxiliares--->
	<cfset rsFechaAux.value = CreateDate(rsPeriodo.value, rsMes.value, 01)>
	<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
	<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
<!--- Moneda --->
	<cfquery name="rsMoneda" datasource="#session.dsn#">
		select Mcodigo as value
		from Empresas 
		where Ecodigo =  #session.Ecodigo# 
	</cfquery>
<!---Proceso de Encabezados--->	
	<cfquery name="RS_Registros" datasource="#session.dsn#">
		select distinct x.DESCTraslado, x.RAZONTraslado
		from #table_name# x
	</cfquery>
	<cfoutput query="RS_Registros">
		
		<cfinvoke component	= "sif.Componentes.OriRefNextVal"
				method = "nextVal"
				returnvariable	= "LvarNumDoc"
				ORI	= "AFTR"
				REF	= "TR"
		/>
		<cfquery name="RS_Insertar_Registros" datasource="#session.dsn#">
			insert into AGTProceso ( 
				Ecodigo,
				IDtrans,
				AGTPdescripcion,
				AGTPrazon,
				AGTPperiodo,
				AGTPmes,
				Usucodigo,
				AGTPfalta,
				AGTPipregistro,
				AGTPestadp,
				AGTPecodigo,
				FOcodigo,
				FDcodigo,
				FCFid,
				FACcodigo,
				FACid,
				AGTPfechaprog,
				AGTPdocumento
			)
			values (
			 #session.Ecodigo# ,
			8,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#RS_Registros.DESCTraslado#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#RS_Registros.RAZONTraslado#">,
			#rsPeriodo.value#,
			#rsMes.value#,
			#session.Usucodigo#,
			<cf_dbfunction name="now">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,
			0,
			 #session.Ecodigo# ,
			null,
			null,
			null,
			null,
			null,
			null,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNumDoc#"> )
			<cf_dbidentity1 datasource="#session.dsn#" verificar_transaccion="false">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="RS_Insertar_Registros" verificar_transaccion="false">
<!---Proceso de lineas de detalle--->
		<cfquery name="RS_Insertar_Registros2" datasource="#session.dsn#">
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
				ADTPrazon, 
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
				TAtipocambio,
				Aiddestino,
				Aplacadestino
				)  
				select
				#session.Ecodigo# ,
				#RS_Insertar_Registros.identity#,
				b.Aid,
				8,
				a.CFid,
				<cf_dbfunction name="now">,
				b.Afechainidep,
				b.Avalrescate,
				a.AFSsaldovutiladq, 
				0.00,
				b.Afechainirev,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#RS_Registros.RAZONTraslado#">,
				#rsPeriodo.value#, 
				#rsMes.value#, 
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsFechaAux.value#">,
				#session.Usucodigo#,
				0,

				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSvaladq,0) / 100
					ELSE 
						coalesce(tr.MONTOTrasladoAdq,0)
				END 
				, 0.00,
				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSvalmej,0) / 100
					ELSE 
						coalesce(tr.MONTOTrasladoMej,0)
				END
				, 0.00,
				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSvalrev,0) / 100
					ELSE 
						coalesce(tr.MONTOTrasladoRev,0)
				END
				, 0.00,

				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSdepacumadq,0) / 100
					ELSE 
						CASE WHEN coalesce(a.AFSvaladq, 0) <= 0 THEN
							0.00
						ELSE
							coalesce(coalesce(tr.MONTOTrasladoAdq,0) * 100 / coalesce(a.AFSvaladq,0),0) * coalesce(a.AFSdepacumadq,0) / 100
						END
				END
				,
				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSdepacummej,0) / 100
					ELSE 
						CASE WHEN coalesce(a.AFSvalmej,0) <= 0 THEN
							0.00
						ELSE
							coalesce(coalesce(tr.MONTOTrasladoMej,0) * 100 / coalesce(a.AFSvalmej,0),0) * coalesce(a.AFSdepacummej,0) / 100
						END
				END
				,
				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSdepacumrev,0) / 100
					ELSE 
						CASE WHEN coalesce(a.AFSvalrev,0) <= 0 THEN
							0.00
						ELSE
							coalesce(coalesce(tr.MONTOTrasladoRev,0) * 100 / coalesce(a.AFSvalrev,0),0) * coalesce(a.AFSdepacumrev,0) / 100
						END
				END
				,
				a.AFSvaladq,
				a.AFSvalmej,
				a.AFSvalrev,

				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSdepacumadq,0) / 100
					ELSE 
						CASE WHEN coalesce(a.AFSvaladq,0) <= 0 THEN
							0.00
						ELSE
							coalesce(coalesce(tr.MONTOTrasladoAdq,0) * 100 / coalesce(a.AFSvaladq,0),0) * coalesce(a.AFSdepacumadq,0) / 100
						END
				END
				,
				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSdepacummej,0) / 100
					ELSE 
						CASE WHEN coalesce(a.AFSvalmej,0) <= 0 THEN
							0.00
						ELSE
							coalesce(coalesce(tr.MONTOTrasladoMej,0) * 100 / coalesce(a.AFSvalmej,0),0) * coalesce(a.AFSdepacummej,0) / 100
						END
				END
				,
				CASE
					WHEN tr.PORCTraslado > 0 THEN
						coalesce(tr.PORCTraslado,0) * coalesce(a.AFSdepacumrev,0) / 100
					ELSE 
						CASE WHEN coalesce(a.AFSvalrev,0) <= 0 THEN
							0.00
						ELSE
							coalesce(coalesce(tr.MONTOTrasladoRev,0) * 100 / coalesce(a.AFSvalrev,0),0) * coalesce(a.AFSdepacumrev,0) / 100
						END
				END
				,
				#rsMoneda.value#,
				1.00,
			
				<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				tr.PLACADestino

				from #table_name# tr
					inner join Activos b
						on rtrim(b.Aplaca) = tr.PLACAOrigen
						and b.Ecodigo =  #session.Ecodigo# 
						and b.Astatus = 0
					inner join AFSaldos a on b.Aid = a.Aid
						and a.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPeriodo.value#">
						and a.AFSmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMes.value#">
						and a.Ecodigo =  #session.Ecodigo# 
				where tr.DESCTraslado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RS_Registros.DESCTraslado#"> and
					tr.RAZONTraslado = <cfqueryparam cfsqltype="cf_sql_varchar" value="#RS_Registros.RAZONTraslado#">
					
		</cfquery>
	</cfoutput>
</cfif>