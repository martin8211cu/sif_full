<cfscript>
	bcheck0 = false; // Chequeo de que hay datos en la tabla temporal
	bcheck1 = false; // Verificar que exista la estacion
	bcheck2 = false; // Verificar que el Almacen Principal exista
	bcheck3 = false; // Verificar que el Almacen Principal exista para la Oficina o  Estacion de Servicio
	bcheck4 = false; // Chequear Validez del Articulo	
	bcheck5 = false; // Verificar que el Articulo exista en el Almacen
	bcheck6 = false; // Verificar que el precio del articulo sea mayor que cero
	bcheck7 = false; // Verificar que el inventario inicial del articulo sea mayor o igual que cero
	bcheck8 = false; // Verificar que las unidades para reabastecer del inventario del deposito principal sea mayor o igual que cero
	bcheck9 = false; // Verificar que si existe una salida de mercaderia del almacen principal para el turno 1, revisar que este Turno 1 exista
	bcheck10 = false; // Verificar que si existe una salida de mercaderia del almacen principal para el turno 2, revisar que este Turno 2 exista
	bcheck11 = false; // Verificar que si existe una salida de mercaderia del almacen principal para el turno 3, revisar que este Turno 3 exista

	bcheck11a = false; // Verificar que si existe una salida de mercaderia del almacen principal para las pistas, revisar que este el articulo tenga asociada una pista de la estacion
	
	bcheck12 = false; // Verificar que el Almacen destino exista, al que se van a realizar los movimientos de productos del deporito principal al de las pistas
	bcheck12a = false; // Verificar que el Almacen destino exista para la Oficina o  Estacion de Servicio
		
	bcheck13 = false; // Verificar que las unidades por devolucion sean mayor o igual que cero
	bcheck13a = false; // Verificar que Almacen destino exista para trasladar el articulo X desde almacen Principal
	
	bcheck14 = false; // Verificar que el inventario Final sea igual que el inventario Fisico
	bcheck15 = false; // Verificar que la suma de las salidas no sea mayor que el inventario inicial + Unidades por compra (abastecimiento)	
	bcheck16 = false; /* Verificar que 
							El Inventario Inicial 
							+ Unidades por compra (abastecimiento)
							- (la suma de las salidas al almacen de las pistas) = 	Inventario Final y al 
																					Inventario fisico
						*/
	bcheck17 = false; // Verificar que si existe un movimiento inter-almacen del almacen principal al de las pistas en el turno 1, exista el documento de referencia
	bcheck17a = false; // Verificar que solo exista un documento de referencia para las salidas de productos al turno 1
	bcheck18 = false; // Verificar que si existe un movimiento inter-almacen del almacen principal al de las pistas en el turno 2, exista el documento de referencia	
	bcheck18a = false; // Verificar que solo exista un documento de referencia para las salidas de productos al turno 2	
	bcheck19 = false; // Verificar que si existe un movimiento inter-almacen del almacen principal al de las pistas en el turno 3, exista el documento de referencia	
	bcheck19a = false; // Verificar que solo exista un documento de referencia para las salidas de productos al turno 3
	bcheck20 = false; // Verificar que solo exista un almacen de Origen
	bcheck21 = false; // Verificar que solo exista un almacen de Destino
</cfscript>

<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0 from #table_name#
</cfquery>

<cfif rsCheck0.Recordcount eq 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select distinct 'No se cargaron datos para importar!' as MSG, 0 as Cantidad_Registros
	</cfquery>		
<cfelse>
	<!--- Chequear Validez de las Estaciones --->
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select Oficodigo
		from #table_name# 
		where (
			select count(1)
			from Oficinas b
			where b.Oficodigo = Oficodigo
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">			
		)< 1
	</cfquery>
	<cfset bcheck1 = rsCheck1.recordCount EQ 0>
	
	<cfif bcheck1>
		<!--- Verificar que el Almacen Principal exista --->
		<cfquery name="rsCheck2" datasource="#Session.DSN#">
			select distinct a.AlmcodigOri
			from #table_name#  a
			where (
				select count(1)
				from Almacen c
				where c.Almcodigo = a.AlmcodigOri
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			)< 1
		</cfquery>
		
		<cfset bcheck2 = rsCheck2.recordCount EQ 0>
	</cfif>		

	<!--- Verificar que el Almacen Principal exista para la Oficina o  Estacion de Servicio --->
	<cfif bcheck2>
		<cfquery name="rsCheck3" datasource="#Session.DSN#">
			select distinct a.AlmcodigOri, a.Oficodigo
			from #table_name# a
			where ( select count(1)
					from Almacen c
					inner join Oficinas ofi
						on ofi.Ecodigo=c.Ecodigo
							and ofi.Ocodigo=c.Ocodigo
							
							
				where c.Almcodigo = a.AlmcodigOri
				and ofi.Oficodigo=a.Oficodigo
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			) < 1
		</cfquery>
		
<!---<cf_dump var="#rsCheck3#">--->		
		<cfset bcheck3 = rsCheck3.recordCount EQ 0>
	</cfif>

	<cfif bcheck3>
		<!--- Chequear Validez del Articulo --->
		<cfquery name="rsCheck4" datasource="#Session.DSN#">
			select distinct a.Acodigo
			from #table_name# a
			where (
				select count(1)
				from Articulos c
				where c.Acodigo = a.Acodigo
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			)< 1
		</cfquery>
		<cfset bcheck4 = rsCheck4.recordCount EQ 0>
	</cfif>

	<cfif bcheck4>
		<!--- Verificar que el Articulo exista en el Almacen --->
		<cfquery name="rsCheck5" datasource="#Session.DSN#">
			select a.Acodigo,a.AlmcodigOri
			from #table_name# a
			where (
				select count(1)
				from Existencias b
					inner join Articulos p
						on p.Ecodigo=b.Ecodigo
							and p.Aid=b.Aid
							
					inner join Artxpista ap
						on ap.Ecodigo=p.Ecodigo
							and ap.Aid=p.Aid
							and ap.Estado=1
								
					inner join Almacen al
						on al.Ecodigo=ap.Ecodigo
							and al.Aid = b.Alm_Aid
							
					inner join Oficinas ofi
						on ofi.Ecodigo=al.Ecodigo
							and ofi.Ocodigo=al.Ocodigo	
													
				
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and p.Acodigo = a.Acodigo
				and al.Almcodigo=a.AlmcodigOri
				and ofi.Oficodigo=a.Oficodigo	
			)< 1
		</cfquery>
			<cfset bcheck5 = rsCheck5.recordCount EQ 0>
	</cfif>

	<cfif bcheck5>
		<!--- Verificar que el precio del articulo sea mayor que cero --->
		<cfquery name="rsCheck6" datasource="#Session.DSN#">
			select Acodigo
			from #table_name#
			where Precio < 0
		</cfquery>
			<cfset bcheck6 = rsCheck6.recordCount EQ 0>
	</cfif>	
		
	<cfif bcheck6>
		<!--- Verificar que el inventario inicial del articulo sea mayor o igual que cero --->
		<cfquery name="rsCheck7" datasource="#Session.DSN#">
			select Acodigo
			from #table_name#
			where invInicial < 0
		</cfquery>
			<cfset bcheck7= rsCheck7.recordCount EQ 0>
	</cfif>	

	<cfif bcheck7>
		<!--- Verificar que las unidades a reabastecer del inventario para el deposito principal sea mayor o igual que cero --->
		<cfquery name="rsCheck8" datasource="#Session.DSN#">
			select Acodigo
			from #table_name#
			where Compra < 0
		</cfquery>
			<cfset bcheck8= rsCheck8.recordCount EQ 0>
	</cfif>	
	
	<cfif bcheck8>
		<!--- Verificar que si existe una salida de mercaderia del almacen principal para el turno 1
				, revisar que este Turno 1 exista  --->
		<cfquery name="rsCheck9" datasource="#Session.DSN#">
			select a.Codigo_turno1
			from #table_name# a
			where cantSalida1 > 0
				and (
					select count(1)
					from Turnos c
					where c.Codigo_turno = a.Codigo_turno1
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				)< 1
		</cfquery>
			<cfset bcheck9= rsCheck9.recordCount EQ 0>
	</cfif>		

	<cfif bcheck9>
		<!--- Verificar que si existe una salida de mercaderia del almacen principal para el turno 2
				, revisar que este Turno 2 exista  --->
		<cfquery name="rsCheck10" datasource="#Session.DSN#">
			select a.Codigo_turno2
			from #table_name# a
			where cantSalida2 > 0
				and (
					select count(1)
					from Turnos c
					where c.Codigo_turno = a.Codigo_turno2
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				)< 1
		</cfquery>
			<cfset bcheck10= rsCheck10.recordCount EQ 0>
	</cfif>	

	<cfif bcheck10>
		<!--- Verificar que si existe una salida de mercaderia del almacen principal para el turno 3
				, revisar que este Turno 3 exista  --->
		<cfquery name="rsCheck11" datasource="#Session.DSN#">
			select a.Codigo_turno3
			from #table_name# a
			where cantSalida3 > 0
				and (
					select count(1)
					from Turnos c
					where c.Codigo_turno = a.Codigo_turno3
					and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				) < 1
		</cfquery>
			<cfset bcheck11= rsCheck11.recordCount EQ 0>
	</cfif>	

	<cfif bcheck11>
		<!--- Verificar que si existe una salida de mercaderia del almacen principal hacia las pistas
				, revisar que el articulo tenga asociada una pista en la estacion --->
		<cfquery name="rsCheck11a" datasource="#Session.DSN#">
			select a.Acodigo,a.AlmcodigoFin,a.cantSalida1,a.cantSalida2,a.cantSalida3
			from #table_name# a
			where (a.cantSalida1 + a.cantSalida2 + a.cantSalida3) > 0
				and (  
					Select count(1)
					from Pistas p
						inner join Oficinas o
							on o.Ecodigo=p.Ecodigo
								and o.Ocodigo=p.Ocodigo							
														

						inner join Artxpista ap
							on ap.Ecodigo=o.Ecodigo
								and ap.Pista_id=p.Pista_id
					
						inner join Articulos ar
							on ar.Ecodigo=ap.Ecodigo
								and ar.Aid=ap.Aid
								
					
						inner join Almacen al
							on al.Ecodigo=ap.Ecodigo
								and al.Aid=ap.Alm_Aid
								and al.Ocodigo=o.Ocodigo
								
								
					where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and p.Pestado=1
						and o.Oficodigo=a.Oficodigo	
						and ar.Acodigo=a.Acodigo
						and al.Almcodigo=a.AlmcodigoFin
				) < 1
		</cfquery>
			<cfset bcheck11a= rsCheck11a.recordCount EQ 0>
	</cfif>	


	<cfif bcheck11a>
		<!--- Verificar que el Almacen destino exista, al que se van a realizar los movimientos de productos del deposito
			principal al de las pistas --->
		<cfquery name="rsCheck12" datasource="#Session.DSN#">
			select distinct a.AlmcodigoFin
			from #table_name# a
			where (
				select count(1)
				from Almacen c
				where c.Almcodigo = a.AlmcodigoFin
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			)< 1
		</cfquery>
		
		<cfset bcheck12 = rsCheck12.recordCount EQ 0>
	</cfif>	
	
	<!--- Verificar que el Almacen Destino exista para la Oficina o  Estacion de Servicio --->
	<cfif bcheck12>
		<cfquery name="rsCheck12a" datasource="#Session.DSN#">
			select distinct a.AlmcodigoFin, a.Oficodigo
			from #table_name# a
			where (
				select count(1)
				from Almacen c
					inner join Oficinas ofi
						on ofi.Ecodigo=c.Ecodigo
							and ofi.Ocodigo=c.Ocodigo
							
				where c.Almcodigo = a.AlmcodigoFin
				and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and ofi.Oficodigo=a.Oficodigo
			)< 1
		</cfquery>
		
		<cfset bcheck12a = rsCheck12a.recordCount EQ 0>
	</cfif>	

	<cfif bcheck12a>
		<!--- Verificar que las unidades por devolucion sean mayor o igual que cero --->
		<cfquery name="rsCheck13" datasource="#Session.DSN#">
			select Devoluciones
			from #table_name#
			where Devoluciones < 0
		</cfquery>
			<cfset bcheck13= rsCheck13.recordCount EQ 0>
	</cfif>	
	
	
	<!--- Verificar que el Almacen Destino exista para trasladar el articulo a la pista X de la Estacion de Servicio --->
	<cfif bcheck13>
		<cfquery name="rsCheck13a" datasource="#Session.DSN#">
			select distinct a.Acodigo, a.AlmcodigoFin
			from #table_name# a
			where (
					Select count(1)
					from Pistas p
						inner join Oficinas o
							on o.Ecodigo=p.Ecodigo
								and o.Ocodigo=p.Ocodigo							
								

						inner join Artxpista ap
							on ap.Ecodigo=o.Ecodigo
								and ap.Pista_id=p.Pista_id
					
						inner join Articulos ar
							on ar.Ecodigo=ap.Ecodigo
								and ar.Aid=ap.Aid
								
					
						inner join Almacen al
							on al.Ecodigo=ap.Ecodigo
								and al.Aid=ap.Alm_Aid
								and al.Ocodigo=o.Ocodigo
								
					
					where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
						and p.Pestado=1			
						and o.Oficodigo=a.Oficodigo	
						and ar.Acodigo=a.Acodigo 
						and al.Almcodigo=a.AlmcodigoFin
			)< 1
		</cfquery>
		
		<cfset bcheck13a = rsCheck13a.recordCount EQ 0>
	</cfif>	

	<cfif bcheck13a>
		<!--- Verificar que las unidades del inventario Final sean iguales que las del inventario Fisico --->
		<cfquery name="rsCheck14" datasource="#Session.DSN#">
			select 
			<cf_dbfunction name="to_char" args="invFinal"> as invFinal,
			<cf_dbfunction name="to_char" args="invFisico"> as invFisico
			from #table_name#
			where 	((invFinal > invFisico) or
					 (invFinal < invFisico))
		</cfquery>
			<cfset bcheck14= rsCheck14.recordCount EQ 0>
	</cfif>		
	
	<cfif bcheck14>
		<!--- Verificar que la suma de las salidas no sea mayor que la suma del inventario inicial mas las compras --->
		<cfquery name="rsCheck15" datasource="#Session.DSN#">
		select (coalesce(cantSalida1,0) + coalesce(cantSalida2,0) + coalesce(cantSalida3,0)) as sumaSalidas
					,(coalesce(invInicial,0) + coalesce(Compra,0)) as sumaUniActuales
			from #table_name#
			where 	((cantSalida1 + cantSalida2 + cantSalida3) >
					(invInicial + Compra))
		</cfquery>
			<cfset bcheck15= rsCheck15.recordCount EQ 0>
	</cfif>			
	
	<cfif bcheck15>
		<!--- Verificar que 							
							El Inventario Inicial 
							+ Unidades por compra (abastecimiento)
							- (la suma de las salidas al almacen de las pistas) = 	Inventario Final y al 
																					Inventario fisico --->
																					
	<cfquery name="rsCheck16" datasource="#Session.DSN#">
			select (invInicial + Compra) - (cantSalida1 + cantSalida2 + cantSalida3) as unidActuales,
					invFinal
			from #table_name#
			where 	(	((invInicial + Compra) - (cantSalida1 + cantSalida2 + cantSalida3) >
						invFinal) or
						((invInicial + Compra) - (cantSalida1 + cantSalida2 + cantSalida3) <
						invFinal)
					)
		</cfquery>
		
			<cfset bcheck16= rsCheck16.recordCount EQ 0>
	</cfif>	
	
	<cfif bcheck16>
		<!--- Verificar que si se hace un movimiento inter-almacen al turno 1 exista el documento de referencia --->
		
		<cf_dbfunction name="to_char" args="cantSalida1" returnvariable ="cantSalida1"> 
		<cfquery name="rsCheck17" datasource="#Session.DSN#">
			select #preservesinglequotes(cantSalida1)# as cantSalida1,
			Acodigo
			from #table_name#
			where cantSalida1 > 0
				and docRefSal1 is null
		</cfquery>
			<cfset bcheck17= rsCheck17.recordCount EQ 0>
	</cfif>		

	<cfif bcheck17>
		<!--- Verificar que si se hace un movimiento inter-almacen al turno 1 el documento de referencia sea el mismo --->
		<cfquery name="rsCheck17a" datasource="#Session.DSN#">
			select distinct docRefSal1,Codigo_turno1  	
			from #table_name#
			where cantSalida1 > 0
				and docRefSal1 is not null
		</cfquery>
			<cfset bcheck17a= rsCheck17a.recordCount EQ 0 or rsCheck17a.recordCount EQ 1>
	</cfif>		

	<cfif bcheck17a>
		<!--- Verificar que si se hace un movimiento inter-almacen al turno 2 exista el documento de referencia --->
		<cf_dbfunction name="to_char" args="cantSalida2" returnvariable ="cantSalida2"> 
		<cfquery name="rsCheck18" datasource="#Session.DSN#">
			select #preservesinglequotes(cantSalida2)# as cantSalida2,
			Acodigo
			from #table_name#
			where cantSalida2 > 0
				and docRefSal2 is null
		</cfquery>
			<cfset bcheck18= rsCheck18.recordCount EQ 0>
	</cfif>	
	
	<cfif bcheck18>
		<!--- Verificar que si se hace un movimiento inter-almacen al turno 2  el documento de referencia sea el mismo  --->
		<cfquery name="rsCheck18a" datasource="#Session.DSN#">
			select distinct docRefSal2,Codigo_turno2  	
			from #table_name#
			where cantSalida2 > 0
				and docRefSal2 is not null
		</cfquery>
			<cfset bcheck18a= rsCheck18a.recordCount EQ 0 or rsCheck18a.recordCount EQ 1>
	</cfif>	
		
	<cfif bcheck18a>
		<!--- Verificar que si se hace un movimiento inter-almacen al turno 3 exista el documento de referencia --->
		<cf_dbfunction name="to_char" args="cantSalida3" returnvariable ="cantSalida3"> 
		<cfquery name="rsCheck19" datasource="#Session.DSN#">
			select 
			#preservesinglequotes(cantSalida3)# as cantSalida3,
			Acodigo
			from #table_name#
			where cantSalida3 > 0
				and docRefSal3 is null
		</cfquery>
			<cfset bcheck19= rsCheck19.recordCount EQ 0>
	</cfif>		

	<cfif bcheck19>
		<!--- Verificar que si se hace un movimiento inter-almacen al turno 3  el documento de referencia sea el mismo  --->
		<cfquery name="rsCheck19a" datasource="#Session.DSN#">
			select distinct docRefSal3,Codigo_turno3  	
			from #table_name#
			where cantSalida3 > 0
				and docRefSal3 is not null
		</cfquery>
			<cfset bcheck19a= rsCheck19a.recordCount EQ 0 or rsCheck19a.recordCount EQ 1>
	</cfif>		
	
	<cfif bcheck19a>
		<!--- Verificar que solo exista un almacen de origen --->
		<cfquery name="rsCheck20" datasource="#Session.DSN#">
			select distinct AlmcodigOri
			from #table_name#
		</cfquery>
			<cfset bcheck20= rsCheck20.recordCount EQ 0 or rsCheck20.recordCount EQ 1>
	</cfif>	
	
	<cfif bcheck20>
		<!--- Verificar que solo exista un almacen destino --->
		<cfquery name="rsCheck21" datasource="#Session.DSN#">
			select distinct AlmcodigoFin
			from #table_name#
		</cfquery>
			<cfset bcheck21= rsCheck21.recordCount EQ 0 or rsCheck21.recordCount EQ 1>
	</cfif>	
			
	<cfif bcheck21>	
		<!--- Todos los datos correctos, inicio de la insercion de informacion a las tablas de trabajo antes de la afectacion del inventario  --->
		<cfquery name="cargaDatos" datasource="#Session.DSN#">
			select coalesce(max(EMAid),0) as maxid
			from EMAlmacen
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		</cfquery>
						
<!----INSERCION DEL ENCABEZADO--->	
		<cftransaction>
		
		<cfquery name="insertEMAlmacen" datasource="#session.dsn#">
			select distinct 
				o.Ecodigo as Ecodigo,
				o.Ocodigo as Ocodigo,
				a.Fecha as Fecha
			from #table_name# a
				inner join Oficinas o
					on o.Oficodigo=a.Oficodigo
					and o.Ecodigo= #Session.Ecodigo#
		</cfquery>
		
		<cfif insertEMAlmacen.recordcount gt 0>
		<cfquery  name="insertEMAlmacen" datasource="#Session.DSN#">
		insert into EMAlmacen 
		(
			Ecodigo, 
			Ocodigo, 
			EMAfecha, 
			EMAobs, 
			EMAestado, 
			BMUsucodigo, 
			BMfechaalta
		)
		
		values
		(
			#insertEMAlmacen.Ecodigo#,
			#insertEMAlmacen.Ocodigo#,
			'#insertEMAlmacen.Fecha#',
			'Importacion de archivo (Control de Inventario Depósito)',
			0,
			#session.Usucodigo#,
			<cf_dbfunction name="now" args= "BMfechaalta">
		)
		 <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertEMAlmacen" verificar_transaccion="false"> 
	</cfif>
	</cftransaction>		
		
						
<!---INSERCION DEL DETALLE--->
			<cfquery name="cargaDatos2" datasource="#Session.DSN#">
				select  coalesce(max(DMAid),0)as maxIdDet
				from DMAlmacen
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
			</cfquery>
			
	<cftransaction>
		<cfquery name="rs_insertDMAlmacen" datasource="#session.dsn#">
			select 
				 b.EMAid as EMAid, 
				 g.Aid as Aid, 
				 h.Aid as Art_Aid,
				 b.Ecodigo as 	Ecodigo,
				 d.invInicial as invInicial,
				 d.Compra as Compra,
				 d.Precio as Precio,
				 d.invFinal as invFinal,
				 d.Devoluciones as Devoluciones,
				 d.invFisico as invFisico,
				 d.Documento as Documento,
				 <cf_dbfunction name="now" args= "BMfechaalta"> as BMfechaalta

			from EMAlmacen b
				inner join Oficinas c
					on c.Ecodigo=b.Ecodigo
						and c.Ocodigo=b.Ocodigo
													
				inner join #table_name# d
					on d.Oficodigo=c.Oficodigo
				
				inner join Almacen g
					on g.Ecodigo=c.Ecodigo
						and g.Almcodigo=d.AlmcodigOri
						
				inner join Articulos h
					on h.Ecodigo=g.Ecodigo
						and h.Acodigo=d.Acodigo
						
			where b.Ecodigo= #Session.Ecodigo#
				and b.EMAid > #cargaDatos.maxid#		
		</cfquery>

		<cfif rs_insertDMAlmacen.recordcount gt 0>
		<cfquery datasource="#Session.DSN#">
			insert into DMAlmacen 
			(
				EMAid, 
				Aid, 
				Art_Aid, 
				Ecodigo, 
				DMAinvIni, 
				DMAcompra, 
				DMAprecio, 
				DMAinvFin, 
				DMAdevol,
				DMAinvFisico,
				DMAdoc, 
				BMUsucodigo, 
				BMfechaalta
			)
		values
		( 
			#rs_insertDMAlmacen.EMAid#,
			#rs_insertDMAlmacen.Aid#,
			#rs_insertDMAlmacen.Art_Aid#,
			#rs_insertDMAlmacen.Ecodigo#,
			#rs_insertDMAlmacen.invInicial#,
			#rs_insertDMAlmacen.Compra#,
			#rs_insertDMAlmacen.Precio#,
			#rs_insertDMAlmacen.invFinal#,
			#rs_insertDMAlmacen.Devoluciones#,
			#rs_insertDMAlmacen.invFisico#,
			'#rs_insertDMAlmacen.Documento#',
			#session.Usucodigo#,	
			'#rs_insertDMAlmacen.BMfechaalta#'
		)
		 <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertDMAlmacen" verificar_transaccion="false"> 
		</cfif>
	</cftransaction>	
					
				<!------	REGISTRO DE SALIDAS DEL DEPOSITO PRINCIPAL HACIA EL ALMACEN DE LAS PISTAS
				  Turno 1--->
		<cftransaction>	
		
		<cfquery name="rs_insertALMPistas" datasource="#session.dsn#">
			select 
					 b.Ecodigo as Ecodigo,
					 det.DMAid as DMAid,
					 t.Turno_id as Turno_id,
					 gFin.Aid as Aid,
					 det.Art_Aid as Art_Aid,
					 d.cantSalida1 as cantSalida1,
					 d.docRefSal1 as docRefSal1,
					 <cf_dbfunction name="now" args= "BMfechaalta"> as BMfechaalta
				from EMAlmacen b
					inner join DMAlmacen det
						on det.Ecodigo=b.Ecodigo
							and det.EMAid=b.EMAid
							and det.DMAid > #cargaDatos2.maxIdDet#
					
					inner join Oficinas c
						on c.Ecodigo=b.Ecodigo
							and c.Ocodigo=b.Ocodigo
														
					inner join #table_name# d
						on d.Oficodigo=c.Oficodigo
							and d.cantSalida1 > 0
						
					inner join Turnos t
						on t.Ecodigo=det.Ecodigo
							and t.Codigo_turno=d.Codigo_turno1
					
					inner join Almacen g
						on g.Ecodigo=t.Ecodigo
							and g.Aid=det.Aid
							and g.Almcodigo=d.AlmcodigOri

					inner join Almacen gFin
						on gFin.Ecodigo=t.Ecodigo
							and gFin.Almcodigo=d.AlmcodigoFin

					inner join Articulos h
						on h.Ecodigo=g.Ecodigo
							and h.Aid=det.Art_Aid
							and h.Acodigo=d.Acodigo							
							
				where b.Ecodigo= #Session.Ecodigo#
					and b.EMAid > #cargaDatos.maxid#
		</cfquery>
		
		<cfif rs_insertALMPistas.recordcount gt 0>	  
		<cfquery datasource="#Session.DSN#">
				insert into ALMPistas 
					(
						Ecodigo, 
						DMAid, 
						Turno_id, 
						Aid, 
						Art_Aid, 
						ALMPcantidad, 
						ALMPdoc, 
						BMUsucodigo, 
						BMfechaalta
					)
				values
				 ( 
					 #rs_insertALMPistas.Ecodigo#,
					 #rs_insertALMPistas.DMAid#,
					 #rs_insertALMPistas.Turno_id#,
					 #rs_insertALMPistas.Aid#,
					 #rs_insertALMPistas.Art_Aid#,
					 #rs_insertALMPistas.cantSalida1#,
					 '#rs_insertALMPistas.docRefSal1#',
					 #session.Usucodigo#,				
					'#rs_insertALMPistas.BMfechaalta#'
				)
		 <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertALMPistas" verificar_transaccion="false"> 
		</cfif>
	</cftransaction>
	
					
<!----- Turno 2--->
	<cftransaction>	
		<cfquery name="rs_insertALMPistas2" datasource="#Session.DSN#">
			select 
				 b.Ecodigo as Ecodigo, 
				 det.DMAid as DMAid,
				 t.Turno_id as Turno_id,
				 gFin.Aid as Aid,
				 det.Art_Aid as Art_Aid,
				 d.cantSalida2 as cantSalida2,
				 d.docRefSal2 as docRefSal2,					
				 <cf_dbfunction name="now" args= "BMfechaalta"> as BMfechaalta
			from EMAlmacen b
				inner join DMAlmacen det
					on det.Ecodigo=b.Ecodigo
						and det.EMAid=b.EMAid
						and det.DMAid > #cargaDatos2.maxIdDet#
				
				inner join Oficinas c
					on c.Ecodigo=b.Ecodigo
						and c.Ocodigo=b.Ocodigo
													
				inner join #table_name# d
					on d.Oficodigo=c.Oficodigo
						and d.cantSalida2 > 0
					
				inner join Turnos t
					on t.Ecodigo=det.Ecodigo
						and t.Codigo_turno=d.Codigo_turno2
				
				inner join Almacen g
					on g.Ecodigo=t.Ecodigo
						and g.Aid=det.Aid
						and g.Almcodigo=d.AlmcodigOri

				inner join Almacen gFin
					on gFin.Ecodigo=t.Ecodigo
						and gFin.Almcodigo=d.AlmcodigoFin							

				inner join Articulos h
					on h.Ecodigo=g.Ecodigo
						and h.Aid=det.Art_Aid
						and h.Acodigo=d.Acodigo								
						
			where b.Ecodigo=#Session.Ecodigo#
				and b.EMAid >#cargaDatos.maxid#				
		</cfquery>

		<cfif rs_insertALMPistas2.recordcount gt 0>
		<cfquery datasource="#Session.DSN#">
			insert into ALMPistas 
				(
					Ecodigo, 
					DMAid, 
					Turno_id, 
					Aid, 
					Art_Aid, 
					ALMPcantidad, 
					ALMPdoc, 
					BMUsucodigo, 
					BMfechaalta
				)
			values( 
				 #rs_insertALMPistas2.Ecodigo#,
				#rs_insertALMPistas2.DMAid#,
				#rs_insertALMPistas2.Turno_id#,
				#rs_insertALMPistas2.Aid#,
				#rs_insertALMPistas2.Art_Aid#,
				#rs_insertALMPistas2.cantSalida2#,
				'#rs_insertALMPistas2.docRefSal2#',					
				#session.Usucodigo#,					
				'#rs_insertALMPistas2.BMfechaalta#'
			)
			 <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
      </cfquery>
          <cf_dbidentity2 datasource="#Session.DSN#" name="insertALMPistas2" verificar_transaccion="false"> 
	 </cfif>
	</cftransaction>		
					<!---Turno 3--->
	<cftransaction>
	
	<cfquery name="rs_insertALMPistas3" datasource="#session.dsn#">
		select 
			 b.Ecodigo,
			 det.DMAid,
			 t.Turno_id,
			 gFin.Aid,
			 det.Art_Aid,
			 d.cantSalida3,
			 d.docRefSal3,	
			 <cf_dbfunction name="now" args= "BMfechaalta"> as BMfechaalta
		from EMAlmacen b
			inner join DMAlmacen det
				on det.Ecodigo=b.Ecodigo
					and det.EMAid=b.EMAid
					and det.DMAid > #cargaDatos2.maxIdDet#
			
			inner join Oficinas c
				on c.Ecodigo=b.Ecodigo
					and c.Ocodigo=b.Ocodigo
												
			inner join #table_name# d
				on d.Oficodigo=c.Oficodigo
					and d.cantSalida3 > 0
				
			inner join Turnos t
				on t.Ecodigo=det.Ecodigo
					and t.Codigo_turno=d.Codigo_turno3
			
			inner join Almacen g
				on g.Ecodigo=t.Ecodigo
					and g.Aid=det.Aid
					and g.Almcodigo=d.AlmcodigOri

			inner join Almacen gFin
				on gFin.Ecodigo=t.Ecodigo
					and gFin.Almcodigo=d.AlmcodigoFin
					
			inner join Articulos h
				on h.Ecodigo=g.Ecodigo
					and h.Aid=det.Art_Aid
					and h.Acodigo=d.Acodigo							
					
		where b.Ecodigo=#Session.Ecodigo#
			and b.EMAid > #cargaDatos.maxid#				
	</cfquery>
	
	 <cfif rs_insertALMPistas3.recordcount gt 0>		
		<cfquery datasource="#Session.DSN#">
				insert into ALMPistas 
					(
						Ecodigo, 
						DMAid, 
						Turno_id, 
						Aid, 
						Art_Aid, 
						ALMPcantidad, 
						ALMPdoc, 
						BMUsucodigo, 
						BMfechaalta
					)
				values
				( 
					#rs_insertALMPistas3.Ecodigo#,
					#rs_insertALMPistas3.DMAid#,
					#rs_insertALMPistas3.Turno_id#,
					#rs_insertALMPistas3.Aid#,
					#rs_insertALMPistas3.Art_Aid#,
					#rs_insertALMPistas3.cantSalida3#,
					'#rs_insertALMPistas3.docRefSal3#',	
					#session.Usucodigo#,			
					'#rs_insertALMPistas3.BMfechaalta#'
				)
 				<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
        </cfquery>
            <cf_dbidentity2 datasource="#Session.DSN#" name="insertALMPistas3" verificar_transaccion="false"> 
		</cfif>
	</cftransaction>	
		
			<cfelse>		
		<cfif not bcheck1>
			<cfquery name="ERR" dbtype="query">
				select distinct 'Código de la Estaci&oacute;n no existe' as MSG, Oficodigo as CODIGO_ESTACION
				from rsCheck1
			</cfquery>
		<cfelseif not bcheck2>		
			<cfquery name="ERR" dbtype="query">
				select distinct 
				'El Almacen Principal de la estaci&oacute;n no existe' as MSG, AlmcodigOri as CODIGO_Almacen
				from rsCheck2
			</cfquery>						
		<cfelseif not bcheck3>
	 		<cfquery name="ERR" dbtype="query">
				select 
				distinct <cf_dbfunction name="concat" args="'El Almacen Principal (' || AlmcodigOri || ') no existe para la estaci&oacute;n de servicio'"  delimiters = "||"> as MSG, 
				Oficodigo as CODIGO_Estacion
				from rsCheck3
			</cfquery>
		<cfelseif not bcheck4>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'El Articulo no existe' as MSG, 
				Acodigo as CODIGO_Articulo
				from rsCheck4
			</cfquery>				
		<cfelseif not bcheck5>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'El Articulo (' || cast(Acodigo as varchar) || ') no existe en el almac&eacute;n.' as MSG, 
				 AlmcodigOri as CODIGO_almacen
				from rsCheck5
			</cfquery>						
		<cfelseif not bcheck6>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'El Precio del Articulo (' || cast(Acodigo as varchar) || ') es menor que cero' as MSG, 
				Precio as PRECIO_Articulo
				from rsCheck6
			</cfquery>						
		<cfelseif not bcheck7>
			<cfquery name="ERR" dbtype="query">
				select distinct 'El Inventario Inicial del Articulo es inv&aacute;lido, es menor que cero' as MSG, Acodigo as CODIGO_Articulo
				from rsCheck7
			</cfquery>						
		<cfelseif not bcheck8>
			<cfquery name="ERR" datasource="#Session.DSN#">
				select distinct 'La cantidad de unidades a reabastecer en el Almac&eacute;n principal es menor que cero' as MSG, AlmcodigOri as CODIGO_almacen
				from #table_name# a
				where Compra < 0
			</cfquery>						
		<cfelseif not bcheck9>
			<cfquery name="ERR" dbtype="query">
				select distinct 'El Turno 1 no existe' as MSG, Codigo_turno1 as CODIGO_Turno1
				from rsCheck9
			</cfquery>				
		<cfelseif not bcheck10>
			<cfquery name="ERR" dbtype="query">
				select distinct 'El Turno 2 no existe.' as MSG, Codigo_turno2 as CODIGO_Turno2
				from rsCheck10
			</cfquery>							
		<cfelseif not bcheck11>
			<cfquery name="ERR" dbtype="query">
				select distinct 'El Turno 3 no existe' as MSG, Codigo_turno3 as CODIGO_Turno3
				from rsCheck11
			</cfquery>				
		<cfelseif not bcheck11a>
			<cfquery name="ERR" dbtype="query">
				select
				distinct 'El Articulo ('|| cast(Acodigo as varchar) || ') no tiene asociada una Pista en la Estaci&oacute;n de Servicio para el almacen final, o la Pista no esta activada ' as MSG, 
				AlmcodigoFin as CODIGO_AlmacenFinal
				from rsCheck11a
			</cfquery>				
		<cfelseif not bcheck12>
			<cfquery name="ERR" dbtype="query">
				select distinct 'El Almac&eacute;n destino para los movimientos interalmac&eacute;n no existe ' as MSG, AlmcodigoFin as CODIGO_AlmacenFinal
				from rsCheck12
			</cfquery>
			
		<cfelseif not bcheck12a>
			<cfquery name="ERR" dbtype="query">
				select distinct 'El Almac&eacute;n destino no pertenece a la Estación de Servicio' as MSG, AlmcodigoFin as CODIGO_AlmacenFinal
				from rsCheck12a
			</cfquery>
		<cfelseif not bcheck13>
			<cfquery name="ERR" dbtype="query">
				select distinct 'Las unidades por devoluci&oacute;n son inv&aacute;lidas (negativas)' as MSG, Devoluciones as DEVOLUCIONES
				from rsCheck13
			</cfquery>	
		<cfelseif not bcheck13a>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'El Articulo ('|| cast(Acodigo as varchar) || ') no esta asociado al Almac&eacute;n destino de las pistas de la Estación de Servicio' as MSG, 
				AlmcodigoFin as CODIGO_AlmacenDestino
				from rsCheck13a
			</cfquery>
		<cfelseif not bcheck14>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Las unidades del inventario Final ('|| cast(invFinal as varchar) || ')	son diferentes a las unidades del inventario Fisico' as MSG, 
				invFisico as INV_FISICO
				from rsCheck14
			</cfquery>			
		<cfelseif not bcheck15>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'La suma de las salidas al almacen de las pistas ('||  cast(sumaSalidas as varchar) || ') son mayores a la suma del inventario inicial  mas las compras' as MSG, 
				sumaUniActuales as UNIDADES_ACTUALES
				from rsCheck15
			</cfquery>
		<cfelseif not bcheck16>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Las unidades actuales en inventario ('|| cast(unidActuales as varchar) || ') son diferentes al inventario final' as MSG, 
				invFinal as INVENTARIO_FINAL
				from rsCheck16
			</cfquery>	
		<cfelseif not bcheck17>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, no existe el documento de referencia para la salida de producto ('|| cast(Acodigo as varchar) || ') del almacen al Turno 1'  as MSG, 
				cantSalida1 as CANTIDAD_SALIDA
				from rsCheck17
			</cfquery>	
		<cfelseif not bcheck17a>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, existen documentos de referencia distintos ('|| cast(docRefSal1 as varchar) || ') para las salidas de productos del almacen al Turno 1' as MSG, 
				Codigo_turno1 as CODIGO_Turno_1
				from rsCheck17a
			</cfquery>				
		<cfelseif not bcheck18>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, no existe el documento de referencia para la salida de producto ('|| cast(Acodigo as varchar) || ') del almacen al Turno 2' as MSG, 
				cantSalida2 as CANTIDAD_SALIDA
				from rsCheck18
			</cfquery>			
		<cfelseif not bcheck18a>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, existen documentos de referencia distintos ('|| cast(docRefSal2 as varchar) || ') para las salidas de productos del almacen al Turno 2' as MSG, 
				Codigo_turno2 as CODIGO_Turno_2
				from rsCheck18a
			</cfquery>																	
		<cfelseif not bcheck19>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, no existe el documento de referencia para la salida de producto ('|| cast(Acodigo as varchar) || ') del almacen al Turno 3' as MSG, 
				cantSalida3 as CANTIDAD_SALIDA
				from rsCheck19
			</cfquery>		
		<cfelseif not bcheck19a>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, existen documentos de referencia distintos ('|| cast(docRefSal3 as varchar) || ') para las salidas de productos del almacen al Turno 3' as MSG, 
				Codigo_turno3 as CODIGO_Turno_3
				from rsCheck19a
			</cfquery>						
		<cfelseif not bcheck20>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, existe mas de un almacen de origen y solo se permite uno' as MSG, 
				AlmcodigOri as CODIGO_Almacen_Origen
				from rsCheck20
			</cfquery>	
		<cfelseif not bcheck21>
			<cfquery name="ERR" dbtype="query">
				select 
				distinct 'Error, existe mas de un almacen destino y solo se permite uno' as MSG, 
				AlmcodigoFin as CODIGO_Almacen_Destino
				from rsCheck21
			</cfquery>							
		</cfif>
	</cfif>
</cfif>
		
