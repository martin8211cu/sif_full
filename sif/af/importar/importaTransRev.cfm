<cfset acheck = false>	<!--- Verifica Lineas en blanco --->
<cfset bcheck = false>  <!--- Verifica que todas las placas sean vlidas --->
<cfset ccheck = false>	<!--- Verifica que todos los activos tengan saldos para el periodo-mes--->
<cfset dcheck = false>	<!--- Verifica que no existan activos retirados --->
<cfset fcheck = true>	<!--- Verifica que todas las placas existan solo una vez en el archivo --->
<cfset gcheck = true>	<!--- Verifica que las placas no se encuentren en una transaccion de revaluacin pendiente u aplicada para el periodo-mes --->
<cfset hcheck = true>	<!--- Valida que exista uno o mas encabezados de Transacciones de Revaluacin por archivo---->

<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as value 
	 from Parametros p1 
	where Ecodigo =  #session.Ecodigo#  
	and Pcodigo = 50
</cfquery>
<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select p1.Pvalor as value 
	 from Parametros p1 
	where Ecodigo =  #session.Ecodigo#  
	and Pcodigo = 60
</cfquery>
<!--- Obtiene la Moneda Local --->
<cfquery name="rsMoneda" datasource="#session.DSN#">
	select Mcodigo as value
	from Empresas 
	where Ecodigo =  #session.Ecodigo# 
</cfquery>

<cf_dbtemp name="ErrImportRev01" returnvariable="ERRORES" datasource="#session.DSN#">
	<cf_dbtempcol name="Motivo" type="varchar(200)"  mandatory="yes">
	<cf_dbtempcol name="Valor"  type="varchar(50)"   mandatory="yes">
</cf_dbtemp>

<cfset VPER = rsPeriodo.value>
<cfset VMES = rsMes.value>

<!--- Verifica lineas en Blanco --->
<cfquery name="rsLnsBlancas" datasource="#session.DSN#">
Select count(1) as tot
from #table_name# 
where AGTPdescripcion is null
  or Aplaca is null
  or TAmontolocadq is null
  or TAmontolocmej is null
  or TAmontolocrev is null
  or TAmontodepadq is null
  or TAmontodepmej is null
  or TAmontodeprev is null
  or TAfecha is null
</cfquery>

<cfif rsLnsBlancas.tot GT 0>
	<cfset tot=rsLnsBlancas.tot>
	<cfquery name="rsActValidos" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	Select 'Existen lineas en el archivo que estan incompletas o en blanco','#tot#'
	</cfquery>	
	<cfset acheck = false>
</cfif>


<!--- Verifica que todas las placas sean válidas --->
<cfquery name="rsActValidos" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	select 'La placa no corresponde a un activo existente' as Motivo,  x.Aplaca
	from #table_name# x
	where not exists (select a.Aplaca 
					  from Activos a 
					  where a.Ecodigo =  #session.Ecodigo# 
				        and a.Aplaca = x.Aplaca)
</cfquery>

<!--- Verifica que todas las placas sean de activos revaluables --->
<cfquery name="rsActValidos" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	Select 'La placa pertenece a un activo que no es revaluable' as Motivo,  x.Aplaca
	from #table_name# x
	where exists (	Select 1
					from Activos a			
							inner join AClasificacion ac
								 on ac.ACid = a.ACid
								and ac.ACcodigo = a.ACcodigo
								and ac.Ecodigo = a.Ecodigo
								and ac.ACrevalua = 'N'
					where a.Ecodigo =  #session.Ecodigo# 
				        and a.Aplaca = x.Aplaca)
</cfquery>

<!--- Verifica que todos los activos tengan saldos para el periodo-mes--->
<cfquery name="rsSaldosAct" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	select 'El activo no tiene saldos para el periodo-mes indicado: (#VPER#-#VMES#)' as Motivo, a.Aplaca
	from #table_name# a
			inner join Activos b
				on a.Aplaca = b.Aplaca
				and b.Ecodigo =  #session.Ecodigo# 
	where b.Astatus = 0
	  and not exists(Select 1
					 from AFSaldos c
					 where c.Aid = b.Aid
					   and c.Ecodigo = b.Ecodigo
					   and c.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VPER#">
					   and c.AFSmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#VMES#">)
</cfquery>

<!--- Verifica que todos los activos esten vivos para el periodo-mes--->
<cfquery name="rsActRetirados" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	select 'El activo se encuentra retirado' as Motivo,  a.Aplaca as Placa_Activo
	from #table_name# a
			inner join Activos b
				on a.Aplaca = b.Aplaca
				and b.Ecodigo =  #session.Ecodigo# 
	where b.Astatus = 60
</cfquery>

<!--- Verifica que todas las placas existan solo una vez en el archivo --->
<cfquery name="rsPlacasRepetidas" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	select 'La placa se encuentra ms de una vez en el archivo' as Motivo,  Aplaca as Placa_Activo
	from #table_name# 
	group by Aplaca
	having count(1) > 1	
</cfquery>

<!--- Verifica que las placas no se encuentren en una transaccion de revaluacin pendiente u aplicada para el periodo-mes --->
<cfquery name="rsRevPendiente" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	select 'El activo ya se encuentra incluido dentro de una transaccin de revaluacin pendiente de aplicar para el periodo-mes (#VPER#-#VMES#)' as Motivo,  a.Aplaca as Placa_Activo
	from #table_name# a
			inner join Activos b
				on a.Aplaca = b.Aplaca
				and b.Ecodigo =  #session.Ecodigo# 
	where exists (Select 1		
				  from ADTProceso c
				  where c.Aid = b.Aid
					and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VPER#">
					and c.TAmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#VMES#">
					and c.IDtrans = 3)
</cfquery>

<cfquery name="rsRevPendiente" datasource="#session.DSN#">
	Insert into #ERRORES#(Motivo,Valor)
	select 'El activo ya fue revaluado en este periodo-mes (#VPER#-#VMES#)' as Motivo,  a.Aplaca as Placa_Activo
	from #table_name# a
			inner join Activos b
				on a.Aplaca = b.Aplaca
				and b.Ecodigo =  #session.Ecodigo# 
	where exists (Select 1		
				  from TransaccionesActivos c
				  where c.Aid = b.Aid
					and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#VPER#">
					and c.TAmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#VMES#">
					and c.IDtrans = 3)
</cfquery>

<!--- ************************************************************************************** --->
<!--- ************* VERIFICA QUE LAS PLACAS NO TENGAN TRANSACCIONES PENDIENTES ************* --->
<!--- ************************************************************************************** --->

	<!--- Verifica si la placa esta en una transaccion pendiente de MEJORA--->
	<cfquery name="rsRevisaPendMejoras" datasource="#session.DSN#">
		Select count(1) as Cantidad
		from #table_name# a
				inner join Activos b
					on a.Aplaca = b.Aplaca
					and b.Ecodigo =  #session.Ecodigo# 
		where exists(Select 1
					 from ADTProceso c
					 where c.Aid = b.Aid
					   and c.Ecodigo = b.Ecodigo
					   and c.IDtrans = 2
					   and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VPER#">
					   and c.TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VMES#">)
	</cfquery>  
	
	<!--- Verifica si la placa esta en una transaccion pendiente de DEPRECIACION--->							
	<cfquery name="rsRevisaPendDepreciacion" datasource="#session.DSN#">
		Select count(1) as Cantidad
		from #table_name# a
				inner join Activos b
					on a.Aplaca = b.Aplaca
					and b.Ecodigo =  #session.Ecodigo# 
		where exists(Select 1
					 from ADTProceso c
					 where c.Aid = b.Aid
					   and c.Ecodigo = b.Ecodigo
					   and c.IDtrans = 4
					   and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VPER#">
					   and c.TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VMES#">)
	</cfquery>  

	<!--- Verifica si la placa esta en una transaccion pendiente de RETIROS--->			
	<cfquery name="rsRevisaPendRetiros" datasource="#session.DSN#">
		Select count(1) as Cantidad
		from #table_name# a
				inner join Activos b
					on a.Aplaca = b.Aplaca
					and b.Ecodigo =  #session.Ecodigo# 
		where exists(Select 1
					 from ADTProceso c
					 where c.Aid = b.Aid
					   and c.Ecodigo = b.Ecodigo
					   and c.IDtrans = 5
					   and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VPER#">
					   and c.TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VMES#">)
	</cfquery>  								
	
	<!--- Verifica si la placa esta en una transaccion pendiente de Traslados--->			
	<cfquery name="rsRevisaPendTraslados" datasource="#session.DSN#">
		Select count(1) as Cantidad
		from #table_name# a
				inner join Activos b
					on a.Aplaca = b.Aplaca
					and b.Ecodigo =  #session.Ecodigo# 
		where exists(Select 1
					 from ADTProceso c
					 where c.Aid = b.Aid
					   and c.Ecodigo = b.Ecodigo
					   and c.IDtrans = 8
					   and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VPER#">
					   and c.TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VMES#">)
	</cfquery>  								
	
	<!--- Verifica si la placa esta en una transaccion pendiente de CAmbio de Categoria-Clase --->			
	<cfquery name="rsRevisaPendCatCls" datasource="#session.DSN#">
		Select count(1) as Cantidad
		from #table_name# a
				inner join Activos b
					on a.Aplaca = b.Aplaca
					and b.Ecodigo =  #session.Ecodigo# 
		where exists(Select 1
					 from ADTProceso c
					 where c.Aid = b.Aid
					   and c.Ecodigo = b.Ecodigo
					   and c.IDtrans = 6
					   and c.TAperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VPER#">
					   and c.TAmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#VMES#">)	
	</cfquery>  								
	
	<cfif 	(rsRevisaPendMejoras.Cantidad gt 0) or
			(rsRevisaPendDepreciacion.Cantidad gt 0) or 
			(rsRevisaPendRetiros.Cantidad gt 0) or
			(rsRevisaPendTraslados.Cantidad gt 0) or 
			(rsRevisaPendCatCls.Cantidad gt 0)>
	
		<cfset tot = 0>
		<cfset tot = tot + rsRevisaPendMejoras.Cantidad>
		<cfset tot = tot + rsRevisaPendDepreciacion.Cantidad>
		<cfset tot = tot + rsRevisaPendRetiros.Cantidad>
		<cfset tot = tot + rsRevisaPendTraslados.Cantidad>
		<cfset tot = tot + rsRevisaPendCatCls.Cantidad>
		<cfquery name="rsTransPendiente" datasource="#session.DSN#">
			Insert into #ERRORES#(Motivo,Valor)
			select 'Existen activos que tienen transacciones pendientes de aplicar' as Motivo, '#tot#' as Total_Activos
		</cfquery>
	
	</cfif>

<!--- ************************************************************************************** --->
<!--- ************************************************************************************** --->

<cfquery name="hayERR" datasource="#session.DSN#">
Select count(1) as hayerrores
from #ERRORES#
</cfquery>

<cfif hayERR.hayerrores eq 0>
<!--- 
<cfif acheck and bcheck and ccheck and dcheck and echeck and fcheck and gcheck and hcheck>
--->
	<!--- Toma todos los datos a insertar y los pone en rs--->
	<cfquery name="rs" datasource="#session.DSN#">
		select distinct t.AGTPdescripcion
		from #table_name# t, Activos a
		where a.Ecodigo =  #session.Ecodigo# 
		  and t.Aplaca = a.Aplaca
		order by t.AGTPdescripcion
	</cfquery>

														
	<cfset descripcionAct = "">
	<cfset AGTPid = 0>
	<cfset session.debug = false>
		
	<cfloop query="rs">
									
		<!--- Verifica si es la primera linea para crear encabezado o viene un encabezado nuevo --->
		<cfif (rs.CurrentRow EQ 1) or (descripcionAct NEQ rs.AGTPdescripcion)>
										
			<!--- Insertar el encabezado --->
			<cfinvoke 	component		= "sif.Componentes.OriRefNextVal"
					method		= "nextVal"
					returnvariable	= "LvarNumDoc"
					ORI			= "AFRE"
					REF			= "RE"
			/>

			<!---Inserta Grupo de transacciones de Revaluacin--->
			<cfquery name="idquery" datasource="#session.DSN#">
				insert into AGTProceso
				(Ecodigo, 
					IDtrans, 
					AGTPdocumento, 
					AGTPdescripcion,
					AGTPperiodo, 
					AGTPmes, 
					Usucodigo,
					AGTPfalta,
					AGTPipregistro,
					AGTPestadp,
					AGTPecodigo)
				values(
					 #session.Ecodigo# ,<!----- Ecodigo--->
					3,<!----- IDtrans--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarNumDoc#">, <!----- AGTPdocumento--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.AGTPdescripcion#">,<!----- AGTPdescripcion--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#VPER#">,<!----- AGTPperiodo--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#VMES#">,<!----- AGTPmes--->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,<!----- Usucodigo--->
					<cf_dbfunction name="now">,<!----- AGTPfalta--->
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#">,<!----- AGTPipregistro--->
					0,<!----- AGTPestadp--->
					 #session.Ecodigo# <!----- AGTPecodigo--->
					)
					<cf_dbidentity1 verificar_transaccion="false" datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 verificar_transaccion="false" datasource="#session.DSN#" name="idquery">	
			
			
			<cfset AGTPid = idquery.identity>
			<cfset descripcionAct = rs.AGTPdescripcion>
			
		</cfif>
									
		<!--- Verifica la existencia de encabezado para crear detalles --->
		<cfif isdefined("AGTPid") and AGTPid NEQ 0>
										
			<!--- Insertar el detalle --->
			<cfquery name="rsInsertaActivos" datasource="#session.DSN#">
				insert into ADTProceso
					(Ecodigo, 
					AGTPid, 
					Aid, 
					IDtrans, 
					CFid, 
					TAfalta, 
					TAfechainidep, 
					TAvalrescate, 
					TAvutil, 
					TAfechainirev, 
					TAperiodo, 
					TAmes, 
					TAfecha, 
					Usucodigo, 
					TAmeses, <!----- Cantidad de Meses a Revaluar, En realidad se calcula con base en la diferencia mese entre la ultima revaluacion y esta revaluacion--->
					TAmontolocadq, <!----- revaluacion del valor de adquisicion (TAmontolocadq)--->
					TAmontooriadq,<!----- revaluacion del valor de adquisicion (TAmontooriadq)--->
					TAmontolocmej, <!----- revaluacion del valor de mejoras (TAmontolocmej)--->
					TAmontoorimej, <!----- revaluacion del valor de mejoras (TAmontoorimej)--->
					TAmontolocrev, <!----- revaluacion del valor de revaluacion (TAmontolocrev)--->
					TAmontoorirev, <!----- revaluacion del valor de revaluacion (TAmontoorirev)--->
					TAmontodepadq,
					TAmontodepmej,
					TAmontodeprev,
					TAvaladq,
					TAvalmej,
					TAvalrev,
					TAdepacumadq,
					TAdepacummej,
					TAdepacumrev,
					TAsuperavit, <!----- revaluacion - revaluacion de la depreciacion--->
					AFIindice,
					Mcodigo,
					TAtipocambio
					)		
				select
						b.Ecodigo, 
						#AGTPid#, 
						b.Aid, 
						3 as IDtrans, 
						c.CFid, 
						<cf_dbfunction name="now"> as TAfalta, 
						b.Afechainidep, 
						b.Avalrescate, 
						c.AFSvutiladq, 
						b.Afechainirev, 
						c.AFSperiodo, 
						c.AFSmes, 
						a.TAfecha, 
						#session.Usucodigo#, 
						1 as TAmeses, <!----- Cantidad de Meses a Revaluar, En realidad se calcula con base en la diferencia mese entre la ultima revaluacion y esta revaluacion--->
						a.TAmontolocadq, <!----- revaluacion del valor de adquisicion (TAmontolocadq)--->
						0.00, <!----- revaluacion del valor de adquisicion (TAmontooriadq)--->
						a.TAmontolocmej, <!----- revaluacion del valor de mejoras (TAmontolocmej)--->
						0.00, <!----- revaluacion del valor de mejoras (TAmontoorimej)--->
						a.TAmontolocrev, <!----- revaluacion del valor de revaluacion (TAmontolocrev)--->
						0.00, <!----- revaluacion del valor de revaluacion (TAmontoorirev)--->
						a.TAmontodepadq,
						a.TAmontodepmej,
						a.TAmontodeprev,
						c.AFSvaladq,
						c.AFSvalmej,
						c.AFSvalrev,
						c.AFSdepacumadq,
						c.AFSdepacummej,
						c.AFSdepacumrev,
						a.TAsuperavit, <!----- revaluacion - revaluacion de la depreciacion--->
						0 as AFIindice,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.value#">,1
					from #table_name# a
							inner join Activos b
								 on a.Aplaca = b.Aplaca
								and b.Ecodigo =	 #session.Ecodigo# 			
							inner join AFSaldos c
								 on c.Aid 	  	 = b.Aid
								and c.Ecodigo 	 = b.Ecodigo 
								and c.AFSperiodo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#VPER#">
								and c.AFSmes 	 = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#VMES#">
					where AGTPdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rs.AGTPdescripcion#">
			</cfquery>	

		</cfif>
		
	</cfloop>
			
<cfelse>
	<cfquery name="ERR" datasource="#session.DSN#">
	Select Motivo, Valor
	from #ERRORES#
	order by Valor
	</cfquery>
</cfif>