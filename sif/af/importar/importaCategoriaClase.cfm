<cfset bcheck1 = false>	<!--- Placas repetida  --->
<cfset bcheck2 = false>	<!--- Placas existan   --->
<cfset bcheck3 = false>	<!--- Placas activas   --->
<cfset bcheck4 = false>	<!--- Categoría Válida --->
<cfset bcheck5 = false>	<!--- Clase Válida     --->
<cfset bcheck6 = false>	<!--- Relacion Categoría vrs  Clase    --->
<cfset bcheck7 = true>	<!--- validación de saldos de Activo   --->

<cfquery name="rsCheck1" datasource="#session.DSN#">
	select Aplaca 
	from #table_name# 
	group by Aplaca
	having count(1) > 1		
</cfquery>
<cfif rsCheck1.RecordCount EQ 0>
	<cfset bcheck1 = true>
</cfif>

<cfif bcheck1><!--- check1 --->
<!--- hace un select para verificar si todas las placas existen --->
	<cfquery name="rsCheckExiste" datasource="#session.DSN#">
		select x.Aplaca as cantidad
		  from #table_name# x
		where  not exists (Select 1
							 from Activos a 
							where a.Ecodigo =  #session.Ecodigo# 
						   and ltrim(rtrim(a.Aplaca)) = ltrim(rtrim(x.Aplaca)))		
	</cfquery>
	<cfif rsCheckExiste.RecordCount eq 0>
		<cfset bcheck2 = true>
	</cfif>
	
	<cfif bcheck2><!--- check2--->
	
	<!--- hace un select para verificar si todas las placas estan activas --->
	<cfquery name="rsCheckActivo" datasource="#session.DSN#">
		select x.Aplaca as cantidad
		from #table_name# x
		where  not exists (Select 1
							from Activos a 
							where a.Ecodigo =  #session.Ecodigo# 
							  and ltrim(rtrim(a.Aplaca)) = ltrim(rtrim(x.Aplaca))
							  and a.Astatus != 60)				
	</cfquery>
		<cfif rsCheckActivo.RecordCount eq 0>
			<cfset bcheck3 = true>
		</cfif>
		
		<cfif bcheck3><!--- check3--->
		
			<cfquery name="rsCheckCategoria" datasource="#session.DSN#">
				select x.categoria as cantidad
				from #table_name# x
				where  x.categoria  not in (
					select a.ACcodigodesc 
					from ACategoria a 
					where a.Ecodigo =  #session.Ecodigo# )
			</cfquery>
			
			<cfif rsCheckCategoria.RecordCount eq 0>
				<cfset bcheck4 = true>
			</cfif>
			
			<cfif bcheck4><!--- check4--->
				
				<cfquery name="rsCheckClase" datasource="#session.DSN#"><!--- Código Clase Válida---->
					select x.clase as cantidad
					from #table_name# x
					where  x.clase  not in (
						select a.ACcodigodesc 
						from AClasificacion a 
						where a.Ecodigo =  #session.Ecodigo# )
				</cfquery>
				
				<cfif rsCheckClase.RecordCount eq 0>
					<cfset bcheck5 = true>
				</cfif>
				
				<cfif bcheck5><!--- check5--->
					
					<cfquery name="rsCheckRel" datasource="#session.DSN#"><!--- Relación entre clase y categoría---->
						select <cf_dbfunction name="concat" args="ltrim(rtrim(x.categoria)) +','+ ltrim(rtrim(x.clase))" delimiters= "+"> as cantidad
						from #table_name# x
						where <cf_dbfunction name="concat" args="ltrim(rtrim(x.categoria)) +','+ ltrim(rtrim(x.clase))" delimiters="+">
						 not in (
							select <cf_dbfunction name="concat" args="ltrim(rtrim(b.ACcodigodesc)) +','+ ltrim(rtrim(a.ACcodigodesc))" delimiters="+">
							from AClasificacion a , ACategoria b 
							where a.Ecodigo =  #session.Ecodigo# 
								and  a.Ecodigo = b.Ecodigo
								and  b.ACcodigo = a.ACcodigo )
					</cfquery>	
					
					<cfif rsCheckRel.RecordCount eq 0>
						<cfset bcheck6 = true>
					</cfif>	
							
					<cfif bcheck6><!--- check6--->
					
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
					
						<cfquery name="rsCheck7_1" datasource="#session.DSN#"><!--- relacion valida entre placa, periodo, mes---->
							select count(1) as check7
							from #table_name# tt
								inner join Activos ta
								   on tt.Aplaca = ta.Aplaca
								   and ta.Ecodigo =  #session.Ecodigo# where not exists (
										select 1
										from AFSaldos a
										where a.Aid = ta.Aid
										  and a.Ecodigo = ta.Ecodigo
										  and a.AFSperiodo =  #rsPeriodo.value# 
										  and a.AFSmes =  #rsMes.value# 
										  )
						</cfquery>	
						
						<cfquery name="rsCheck7_2" datasource="#session.DSN#"><!--- relacion valida entre placa, periodo, mes---->
							select count(1) as check7
							from #table_name# tt
								inner join Activos ta
								   on tt.Aplaca = ta.Aplaca
								   and ta.Ecodigo =  #session.Ecodigo#
								   where  exists (
										select 1
										from ADTProceso xyz
										where xyz.Ecodigo = ta.Ecodigo
										  and xyz.Aid = ta.Aid
										  and xyz.IDtrans = 6)
						</cfquery>
							
						<cfif rsCheck7_1.check7 GT 0 OR rsCheck7_2.check7 GT 0>
							<cfset bcheck7 = false>
						</cfif>
						
						<cfif bcheck7>
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
							<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes --->
							<cfset rsFechaAux.value = CreateDate(fnIsNull(rsPeriodo.value,01), fnIsNull(rsMes.value,01), 01)>
							<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
							<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
							
							<!--- Obtiene la Moneda Local --->
							<cfquery name="rsMoneda" datasource="#session.DSN#">
								select Mcodigo as value
								from Empresas 
								where Ecodigo =  #session.Ecodigo# </cfquery>
							
							<!--- Procesamiento del archivo --->
							<!--- Obtiene la Descripción --->
							<cfquery name="rsAGTPdescripcion" datasource="#session.DSN#">
								select min(AGTPdescripcion) as AGTPdescripcion
								from #table_name# 
							</cfquery>
							
							
							<cfparam name="session.debug" default="false">
							<cfinvoke component="sif.Componentes.AF_CAMCATCLAS" method="AF_CAMCATCLASACT"
									returnvariable="rsResultadosCAMCATCLAS">
									<cfinvokeargument name="AGTPdescripcion" value="#rsAGTPdescripcion.AGTPdescripcion#">
								<cfinvokeargument name="debug" value="#session.debug#">
							</cfinvoke>
							
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
									
								 (
									select
									 #session.Ecodigo# ,
									#rsResultadosCAMCATCLAS#,
									a.Aid,
									6,
									af.CFid,
									#rsPeriodo.value#  as TAperiodo_de_auxiliares,
									#rsMes.value#  as TAmes_de_auxiliares,
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
								
									#rsMoneda.value# as Mcodigo,
									1.00 as TAtipocambio,
									#session.Usucodigo# as Usucodigo,
									#session.Usucodigo# as BMUsucodigo,
									af.ACcodigo as ACcodigoori, <!--- --categoria origen de AFsaldos --->
									af.ACid, <!--- --ACidori clase origen de AFSaldos --->
									<!--- **tn.categoria as ACcodigodest, ---> <!--- --categoria destino digitada por el usuario o importada --->
									(select min(ac.ACcodigo)
										from ACategoria ac
										where ac.Ecodigo =  #session.Ecodigo# 
											<!--- and ac.ACcodigo = a.ACcodigo --->
											and rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.categoria))
									), <!--- --categoria destino digitada por el usuario o importada --->
									
									<!--- **tn.clase as ACiddest ---> <!--- --clase destino digitada por el usuario o importada	 --->
									(select min(cl.ACid)
										from AClasificacion cl
										where cl.Ecodigo =  #session.Ecodigo# 
											<!---and cl.ACcodigo = a.ACcodigo
											 and cl.ACid = a.ACid --->
											 and ACcodigo = 
											 		(select min(ac.ACcodigo)
														from ACategoria ac
														where ac.Ecodigo =  #session.Ecodigo# 
															<!--- and ac.ACcodigo = a.ACcodigo --->
															and rtrim(ltrim(ac.ACcodigodesc)) = rtrim(ltrim(tn.categoria))
													)
											 and rtrim(ltrim(cl.ACcodigodesc)) = rtrim(ltrim(tn.clase))
									) <!--- --clase destino digitada por el usuario o importada --->
									
									, a.Avalrescate
									from #table_name# tn
											inner join Activos a
												on a.Aplaca = tn.Aplaca
												and a.Ecodigo =  #session.Ecodigo# 
											inner join 	AFSaldos af	
												on af.Aid = a.Aid
													and af.Ecodigo = a.Ecodigo	
													and af.AFSperiodo =  #rsPeriodo.value# 
													and af.AFSmes =  #rsMes.value# 
													and af.Aid = a.Aid
								)
							</cfquery>

							
							<!---<cfinvoke component="sif.Componentes.AF_ContabilizarTrfClasificacion"	 
							method="AF_ContabilizarTrfClasificacion" 
							returnvariable="finalizadoOk"
							AGTPid="#rsResultadosCAMCATCLAS#"/>  --->
							
						<cfelse> <!--- check7--->
							<cfif rsCheck7_1.check7 GT 0 >
								<cfquery name="ERR" datasource="#session.DSN#">
									select 'No existe relación en la tabla saldos entre la Placa del Activo, el Periodo y el Mes' as Motivo,tt.Aplaca as Placa, #rsPeriodo.value# as periodo, #rsMes.value# as mes
									from #table_name# tt
										inner join Activos ta
										   on tt.Aplaca = ta.Aplaca
										   and ta.Ecodigo =  #session.Ecodigo# where not exists (
												select 1
												from AFSaldos a
												where a.Aid = ta.Aid
												  and a.Ecodigo = ta.Ecodigo
												  and a.AFSperiodo =  #rsPeriodo.value# 
												  and a.AFSmes =  #rsMes.value# 
												  )
								</cfquery>							
							</cfif>
							<cfif rsCheck7_2.check7 GT 0>
								<cfquery name="ERR" datasource="#session.DSN#">
									select <cf_dbfunction name="concat" args="'Existe una transacción en proceso para el activo :'+ tt.Aplaca" delimiters="+"> as Motivo
									from #table_name# tt
										inner join Activos ta
										   on tt.Aplaca = ta.Aplaca
										   and ta.Ecodigo =  #session.Ecodigo# where exists (
												select 1
												from ADTProceso xyz
												where xyz.Ecodigo = ta.Ecodigo
												  and xyz.Aid = ta.Aid
												  and xyz.IDtrans = 6)
								</cfquery>
							</cfif>
						</cfif>						
					<cfelse> <!--- check6--->
						<cfquery name="ERR" dbtype="query">
							select <cf_dbfunction name="concat" args="'la siguente categoría y clase no tienen relación :' , rsCheckRel.cantidad">  as Motivo 
							from rsCheckRel
						</cfquery>			
					</cfif> 
				<cfelse> <!--- check5--->
					<cfquery name="ERR" dbtype="query">
						select <cf_dbfunction name="concat" args="'la siguente clase no existe :' , rsCheckClase.cantidad">  as Motivo 
						from rsCheckClase
					</cfquery>			
				</cfif> 				
			<cfelse> <!--- check4--->
				<cfquery name="ERR" dbtype="query">
					select <cf_dbfunction name="concat" args="'la siguente categoría no existe :' , rsCheckCategoria.cantidad">  as Motivo 
					from rsCheckCategoria
				</cfquery>			
			</cfif> 			
		<cfelse> <!--- check3--->
			<cfquery name="ERR" dbtype="query">
				select <cf_dbfunction name="concat" args="'la siguente placa se encuentra inactiva :' , rsCheckActivo.cantidad">  as Motivo 
				from rsCheckActivo
			</cfquery>			
			
		</cfif> 	
	<cfelse> <!--- check2--->
		<cfquery name="ERR" dbtype="query">
			select <cf_dbfunction name="concat" args="'la siguente placa no existe :' , rsCheckExiste.cantidad">  as Motivo 
			from rsCheckExiste
		</cfquery>
	</cfif>
<cfelse> <!--- check1 --->
	<cfquery name="ERR" datasource="#session.dsn#">
			select <cf_dbfunction name="concat" args="'La Placa ' , Aplaca , ' está repetida en el archivo de importación'"> as Motivo 
			from #table_name# 
			group by Aplaca
			having count(1) > 1				
	</cfquery>
</cfif>
