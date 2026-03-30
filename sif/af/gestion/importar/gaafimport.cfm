<!--- GAAFIMPORT: Importador de Transacciones para Gestión de Activo Fijos --->
<!--- 1. Valida errores de inconsistencia en el archivo --->
<cfset val0 = true><!--- Periodo --->
<cfset val1 = true><!--- Mes --->
<cfset val2 = true><!--- Concepto(Lote) --->
<cfset val3 = true><!--- Documento(Póliza) --->
<cfset val4 = true><!--- Cuenta --->
<cfset val5 = true><!--- Oficina --->
<cfset val6 = true><cfset val6required = false><!--- Categoria --->
<cfset val7 = true><cfset val7required = false><!--- Clase --->
<cfset val8 = true><cfset val8required = false><!--- Marca --->
<cfset val9 = true><cfset val9required = false><!--- Modelo --->
<cfset valA = true><cfset valArequired = false><!--- Centro Funcional --->
<cfset valB = true><cfset valBrequired = false><!--- Tipo --->
<cfset valC = true><cfset valCrequired = false><!--- Empleado Responsable --->
<cfset valD = true><cfset valDrequired = false><!--- Centro de Custodia --->
<cfset valE = true><cfset valErequired = false><!--- Tipo de Documento --->
<cfset valF = true><!--- Mejoras con vida util cero para activos ya depreciados --->
<cfset valG = true><!--- Motivo de Retiros (Solo se valida para el caso de los retiros) --->
<cfset valH = true><!--- Estado de Placas --->
<cfset valI = true><!--- Placas Repetidas --->
<cfset valJ = true><!--- Que cateogoria,clase y centro funcional coincidan con el activo --->
<cfset procesar = false><!--- Primero Valida --->

<!---***************************--->
<!---   Periodo / Mes Contable  --->
<!---***************************--->
<cfquery name="rstemp" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor"> as Periodo
	 from Parametros
	where Ecodigo = #session.Ecodigo#
	 and Pcodigo = 50
</cfquery>
<cfset P_Periodo = rstemp.Periodo>
<cfif len(trim(P_Periodo)) eq 0>
	<cf_errorCode	code = "50057" msg = "Error 40001! No se pudo obtener el periodo. Proceso Cancelado!">
</cfif>
<cfquery name="rstemp" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor"> as Mes
	 from Parametros
	where Ecodigo =  #Session.Ecodigo# 
	 and Pcodigo = 60
</cfquery>
<cfset P_Mes = rstemp.Mes>
<cfif len(trim(P_Mes)) eq 0>
	<cf_errorCode	code = "50058" msg = "Error 40002! No se pudo obtener el Mes. Proceso Cancelado!">
</cfif>
<!---**********************************************************************************************--->
<!---        Completa la informacion de Gestion con la información del vale en transito           --->
<!--- Se respeta la información inicial del archivo, solo se actualiza si los campos están en nulo--->  
<!---*********************************************************************************************--->
<cfquery datasource="#Session.Dsn#">
	UPDATE #table_name#
	set GATvutil = 0
	where GATvutil is null
</cfquery>
<cfquery name="PorActualizar" datasource="#Session.Dsn#">
	select  a.CRDRplaca, f.ACcodigodesc categoria,g.ACcodigodesc clase,h.AFMcodigo,i.AFMMcodigo,a.CRDRserie,j.CFcodigo,k.AFCcodigoclas,de.DEidentificacion,crcc.CRCCcodigo,crtd.CRTDcodigo
	
	from CRDocumentoResponsabilidad a
	 left outer join ACategoria f 
	   on f.Ecodigo   = #Session.Ecodigo# 
	  and f.ACcodigo = a.ACcodigo
			
	 left outer join AClasificacion g 
	   on g.Ecodigo   = #Session.Ecodigo# 
	  and g.ACcodigo = f.ACcodigo 
	  and g.ACid     = a.ACid
		
	  left outer join AFMarcas h 
	    on h.Ecodigo = #Session.Ecodigo# 
	   and h.AFMid  = a.AFMid
		
	  left outer join AFMModelos i 
	     on i.Ecodigo = #Session.Ecodigo# 
		and i.AFMid  = h.AFMid 
		and i.AFMMid = a.AFMMid
		
	   left outer join CFuncional j 
		 on j.Ecodigo  = #Session.Ecodigo# 
		and j.CFid 	  = a.CFid	
		
	   left outer join AFClasificaciones k
		 on k.Ecodigo 	= #Session.Ecodigo# 
		and k.AFCcodigo = a.AFCcodigo
		
	  left outer join DatosEmpleado de
		 on de.Ecodigo = #Session.Ecodigo# 
	    and de.DEid = a.DEid
		
	  left outer join CRCentroCustodia crcc
		 on crcc.Ecodigo = #Session.Ecodigo# 
		and crcc.CRCCid = a.CRCCid
		
	  left outer join CRTipoDocumento crtd
		on crtd.Ecodigo = #Session.Ecodigo# 
	   and crtd.CRTDid = a.CRTDid
	
	where (select count(1) from #table_name# where a.CRDRplaca = GATplaca)>0
		   and a.CRDRestado = 10
	  	   and a.Ecodigo =  #Session.Ecodigo#
</cfquery> 
<cfloop query="PorActualizar">
	<cfquery datasource="#Session.Dsn#">
		update #table_name#
		set ACcodigodesccat  = coalesce(ACcodigodesccat,  '#PorActualizar.categoria#'),
			ACcodigodescclas = coalesce(ACcodigodescclas, '#PorActualizar.clase#'),
			AFMcodigo		 = coalesce(AFMcodigo, 		  '#PorActualizar.AFMcodigo#'),	
			AFMMcodigo		 = coalesce(AFMMcodigo, 	  '#PorActualizar.AFMMcodigo#'),
			GATserie		 = coalesce(GATserie,         '#PorActualizar.CRDRserie#'),
			CFcodigo		 = coalesce(CFcodigo,         '#PorActualizar.CFcodigo#'),	
			AFCcodigoclas	 = coalesce(AFCcodigoclas,    '#PorActualizar.AFCcodigoclas#'),
			DEidentificacion = coalesce(DEidentificacion, '#PorActualizar.DEidentificacion#'),
			CRCCcodigo		 = coalesce(CRCCcodigo,       '#PorActualizar.CRCCcodigo#'),
			CRTDcodigo		 = coalesce(CRTDcodigo,       '#PorActualizar.CRTDcodigo#')
		 where GATplaca      = '#PorActualizar.CRDRplaca#'
	</cfquery>
</cfloop>
<!---**********************************************************************************************--->
<!---        Completa la informacion de Gestion con la información del vale  de respobilidad      --->
<!--- Se respeta la información inicial del archivo, solo se actualiza si los campos están en nulo--->  
<!---*********************************************************************************************--->
<cfquery name="PorActulizar2" datasource="#Session.Dsn#">
	select act.Aplaca,f.ACcodigodesc categoria,g.ACcodigodesc clase,h.AFMcodigo,i.AFMMcodigo,act.Aserie,j.CFcodigo,k.AFCcodigoclas,de.DEidentificacion,crcc.CRCCcodigo,crtd.CRTDcodigo
	from AFResponsables a
		inner join Activos act
			on act.Aid = a.Aid
		   and act.Ecodigo = a.Ecodigo
		
		left outer join ACategoria f 
			on f.Ecodigo   =  #Session.Ecodigo# 
		   and f.ACcodigo = act.ACcodigo
		
		left outer join AClasificacion g 
		     on g.Ecodigo   =  #Session.Ecodigo# 
			and g.ACcodigo = f.ACcodigo 
			and g.ACid     = act.ACid
		
		left outer join AFMarcas h 
			on h.Ecodigo =  #Session.Ecodigo# and h.AFMid  = act.AFMid
		
		left outer join AFMModelos i 
			on i.Ecodigo =  #Session.Ecodigo# and i.AFMid  = h.AFMid 
			and i.AFMMid = act.AFMMid
		
		left outer join CFuncional j 
			on j.Ecodigo  =  #Session.Ecodigo# and j.CFid 	  = a.CFid	
		
		left outer join AFClasificaciones k
			 on k.Ecodigo 	=  #Session.Ecodigo# and k.AFCcodigo = act.AFCcodigo
		
		left outer join DatosEmpleado de
			 on de.Ecodigo =  #Session.Ecodigo# and de.DEid = a.DEid
		
		left outer join CRCentroCustodia crcc
			on crcc.Ecodigo =  #Session.Ecodigo# and crcc.CRCCid = a.CRCCid
		
		left outer join CRTipoDocumento crtd
			on crtd.Ecodigo =  #Session.Ecodigo# and crtd.CRTDid = a.CRTDid
	
	where (select count(1) from #table_name# where act.Aplaca = GATplaca) >0  
	  	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between AFRfini and AFRffin
	  	and a.Ecodigo =  #Session.Ecodigo#
</cfquery>
<cfloop query="PorActulizar2">
	<cfquery datasource="#Session.Dsn#">
		update #table_name#
			set ACcodigodesccat  = coalesce(ACcodigodesccat,  '#PorActulizar2.categoria#'),
			ACcodigodescclas 	 = coalesce(ACcodigodescclas, '#PorActulizar2.clase#'),
			AFMcodigo		 	 = coalesce(AFMcodigo, 		  '#PorActulizar2.AFMcodigo#'),	
			AFMMcodigo		 	 = coalesce(AFMMcodigo, 	  '#PorActulizar2.AFMMcodigo#'),
			GATserie		  	 = coalesce(GATserie, 		  '#PorActulizar2.Aserie#'),
			CFcodigo		 	 = coalesce(CFcodigo,         '#PorActulizar2.CFcodigo#'),	
			AFCcodigoclas		 = coalesce(AFCcodigoclas,    '#PorActulizar2.AFCcodigoclas#'),
			DEidentificacion 	 = coalesce(DEidentificacion, '#PorActulizar2.DEidentificacion#'),
			CRCCcodigo		 	 = coalesce(CRCCcodigo,       '#PorActulizar2.CRCCcodigo#'),
			CRTDcodigo		 	 = coalesce(CRTDcodigo,       '#PorActulizar2.CRTDcodigo#')
		 where GATplaca          = '#PorActulizar2.Aplaca#'
	</cfquery>
</cfloop>
<!--- Marca los vales para que no puedan ser recuperados. --->
<cfquery datasource="#Session.Dsn#">
	update CRDocumentoResponsabilidad
	  set CRDRutilaux = 1
	where (select count(1) from #table_name# where CRDocumentoResponsabilidad.CRDRplaca = GATplaca) > 0
		and CRDRestado = 10
	  	and Ecodigo    = #Session.Ecodigo# 
</cfquery>

<cfquery name="rsval" datasource="#Session.Dsn#">
	select 1
	from #table_name#
</cfquery>
<cfquery name="rsval0" datasource="#Session.Dsn#">
	select 1
	from #table_name# a
	where coalesce(GATperiodo,0) > 0
</cfquery>

<cfif rsval.recordcount neq rsval0.recordcount>
	<cfset val0 = false>
<cfelse>	
	<cfquery name="rsval1" datasource="#Session.Dsn#">
		select 1
		from #table_name# a
		where coalesce(GATmes,0) > 0
	</cfquery>
	
	<cfif rsval.recordcount neq rsval1.recordcount>
		<cfset val1 = false>
	<cfelse>
		<cfquery name="rsval2" datasource="#Session.Dsn#">
			select 1
			from #table_name# a
				inner join ConceptoContableE b 
					on b.Ecodigo = #Session.Ecodigo#
					and b.Cconcepto = a.Cconcepto
		</cfquery>
		<cfif rsval.recordcount neq rsval2.recordcount>
			<cfset val2 = false>
		<cfelse>
			<cfquery name="rsval3" datasource="#Session.Dsn#">
				select 1
				from #table_name# a
					inner join HEContables c 
						on c.Ecodigo = #Session.Ecodigo# 
						and c.Cconcepto = a.Cconcepto 
						and c.Edocumento = a.Edocumento 
						and c.Eperiodo = a.GATperiodo
						and c.Emes = a.GATmes
			</cfquery>
			<cfif rsval.recordcount neq rsval3.recordcount>
				<cfset val3 = false>
			<cfelse>
				<cfquery name="rsval4" datasource="#Session.Dsn#">
					select 1
					from #table_name# a
						inner join CFinanciera d 
							on d.Ecodigo = #Session.Ecodigo# 
							and d.CFformato = a.CFformato
				</cfquery>
				<cfif rsval.recordcount neq rsval4.recordcount>					
					<cfset val4 = false>
				<cfelse>
					<cfquery name="rsval5" datasource="#Session.Dsn#">
						select 1
						from #table_name# a
							inner join Oficinas e 
								on e.Ecodigo = #Session.Ecodigo# 
								and e.Oficodigo = a.Oficodigo
					</cfquery>
					<cfif rsval.recordcount neq rsval5.recordcount>
						<cfset val5 = false>
					<cfelse>
						<cfset val6nulls = 0>
						<cfif not val6required>
							<cfquery name="rsval6nulls" datasource="#Session.Dsn#">
								select 1
								from #table_name# a
								where a.ACcodigodesccat is null
							</cfquery>
							<cfset val6nulls = rsval6nulls.recordcount>
						</cfif>						
						<cfquery name="rsval6" datasource="#Session.Dsn#">
							select 1
							from #table_name# a
								inner join ACategoria f 
									on f.Ecodigo = #Session.Ecodigo# 
									and f.ACcodigodesc = a.ACcodigodesccat
						</cfquery>
						<cfif rsval.recordcount neq (rsval6.recordcount + val6nulls)>
							<cfset val6 = false>
						<cfelse>
							<cfset val7nulls = 0>
							<cfif not val7required>
								<cfquery name="rsval7nulls" datasource="#Session.Dsn#">
									select 1
									from #table_name# a
									where a.ACcodigodescclas is null
								</cfquery>
								<cfset val7nulls = rsval7nulls.recordcount>
							</cfif>	
							<cfquery name="rsval7" datasource="#Session.Dsn#">
								select 1
								from #table_name# a
									inner join ACategoria f 
										on f.Ecodigo = #Session.Ecodigo# 
										and f.ACcodigodesc = a.ACcodigodesccat
									inner join AClasificacion g 
										on g.Ecodigo = #Session.Ecodigo# 
										and g.ACcodigo = f.ACcodigo 
										and g.ACcodigodesc = a.ACcodigodescclas
							</cfquery>
							<cfif rsval.recordcount neq (rsval7.recordcount + val7nulls)>
								<cfset val7 = false>
							<cfelse>
								<cfset val8nulls = 0>
								<cfif not val8required>
									<cfquery name="rsval8nulls" datasource="#Session.Dsn#">
										select 1
										from #table_name# a
										where a.AFMcodigo is null
									</cfquery>
									<cfset val8nulls = rsval8nulls.recordcount>
								</cfif>	
								<cfquery name="rsval8" datasource="#Session.Dsn#">
									select 1
									from #table_name# a
										inner join AFMarcas h 
											on h.Ecodigo = #Session.Ecodigo# 
											and h.AFMcodigo = a.AFMcodigo
								</cfquery>
								<cfif rsval.recordcount neq (rsval8.recordcount + val8nulls)>
									<cfset val8 = false>
								<cfelse>
									<cfset val9nulls = 0>
									<cfif not val9required>
										<cfquery name="rsval9nulls" datasource="#Session.Dsn#">
											select 1
											from #table_name# a
											where a.AFMMcodigo is null
										</cfquery>
										<cfset val9nulls = rsval9nulls.recordcount>
									</cfif>	
									<cfquery name="rsval9" datasource="#Session.Dsn#">
										select 1
										from #table_name# a
											inner join AFMarcas h 
												on h.Ecodigo = #Session.Ecodigo# 
												and h.AFMcodigo = a.AFMcodigo
											inner join AFMModelos i 
												on i.Ecodigo = #Session.Ecodigo# 
												and i.AFMid = h.AFMid 
												and i.AFMMcodigo = a.AFMMcodigo
									</cfquery>
									<cfif rsval.recordcount neq (rsval9.recordcount + val9nulls)>
										<cfset val9 = false>
									<cfelse>
										<cfset valAnulls = 0>
										<cfif not valArequired>
											<cfquery name="rsvalAnulls" datasource="#Session.Dsn#">
												select 1
												from #table_name# a
												where a.CFcodigo is null
											</cfquery>
											<cfset valAnulls = rsvalAnulls.recordcount>
										</cfif>	
										<cfquery name="rsvalA" datasource="#Session.Dsn#">
											select 1
											from #table_name# a
												inner join Oficinas e 
													on e.Ecodigo = #Session.Ecodigo# 
													and e.Oficodigo = a.Oficodigo
												inner join CFuncional j 
													on j.Ecodigo = #Session.Ecodigo# 
													and j.CFcodigo = a.CFcodigo	
													and j.Ecodigo = e.Ecodigo
													and j.Ocodigo = e.Ocodigo
										</cfquery>
										<cfif rsval.recordcount neq (rsvalA.recordcount + valAnulls)>
											<cfset valA = false>
										<cfelse>
											<cfset valBnulls = 0>
											<cfif not valBrequired>
												<cfquery name="rsvalBnulls" datasource="#Session.Dsn#">
													select 1
													from #table_name# a
													where a.AFCcodigoclas is null
												</cfquery>
												<cfset valBnulls = rsvalBnulls.recordcount>
											</cfif>
											<cfquery name="rsvalB" datasource="#Session.Dsn#">
												select 1
												from #table_name# a
													inner join AFClasificaciones x 
														on x.Ecodigo = #Session.Ecodigo# 
														and x.AFCcodigoclas = a.AFCcodigoclas
											</cfquery>
											<cfif rsval.recordcount neq (rsvalB.recordcount + valBnulls)>
												<cfset valB = false>
											<cfelse>
												<cfset valCnulls = 0>
												<cfif not valCrequired>
													<cfquery name="rsvalCnulls" datasource="#Session.Dsn#">
														select 1
														from #table_name# a
														where a.DEidentificacion is null
													</cfquery>
													<cfset valCnulls = rsvalCnulls.recordcount>
												</cfif>
												<cfquery name="rsvalC" datasource="#Session.Dsn#">
													select 1
													 from #table_name# a
													   inner join CFuncional cf
														  on cf.Ecodigo = #Session.Ecodigo# 
														 and cf.CFcodigo = a.CFcodigo
													   inner join DatosEmpleado x 
														  on x.Ecodigo = #Session.Ecodigo# 
														 and x.DEidentificacion = a.DEidentificacion
														 where  (exists (
														              select 1 
																	    from LineaTiempo lt
																		  inner join RHPlazas rhp
																			on rhp.RHPid = lt.RHPid
																	where lt.DEid = x.DEid 
																	 and rhp.CFid = cf.CFid
																	 and <cf_dbfunction name="now"> between LTdesde and LThasta
																)
															or
																exists(
																	select 1 
																	 from EmpleadoCFuncional ecf
																	where ecf.DEid = x.DEid 
																	and ecf.CFid = cf.CFid
																	and <cf_dbfunction name="now"> between ECFdesde and ECFhasta
																)
															)	
												</cfquery>
												<cfif rsval.recordcount neq (rsvalC.recordcount + valCnulls)>
													<cfset valC = false>
												<cfelse>
													<cfset valDnulls = 0>
													<cfif not valDrequired>
														<cfquery name="rsvalDnulls" datasource="#Session.Dsn#">
															select 1
															from #table_name# a
															where a.CRCCcodigo is null
														</cfquery>
														<cfset valDnulls = rsvalDnulls.recordcount>
													</cfif>
													<cfquery name="rsvalD" datasource="#Session.Dsn#">
														select 1
														from #table_name# a
															inner join CFuncional z
																on z.Ecodigo = #Session.Ecodigo# 
																and z.CFcodigo = a.CFcodigo
															inner join CRCentroCustodia y
																on y.Ecodigo = #Session.Ecodigo# 
																and y.CRCCcodigo = a.CRCCcodigo
																where exists
																(
																	select 1 
																	from CRCCCFuncionales x 
																	where y.CRCCid = x.CRCCid
																	and z.CFid = x.CFid
																)
													</cfquery>
													<cfif rsval.recordcount neq (rsvalD.recordcount + valDnulls)>
														<cfset valD = false>														
													<cfelse>
														<cfset valEnulls = 0>
														<cfif not valErequired>
															<cfquery name="rsvalEnulls" datasource="#Session.Dsn#">
																select 1
																from #table_name# a
																where a.CRTDcodigo is null
															</cfquery>
															<cfset valEnulls = rsvalEnulls.recordcount>
														</cfif>
														<cfquery name="rsvalE" datasource="#Session.Dsn#">
															select 1
															from #table_name# a
																inner join CRTipoDocumento x
																	on x.Ecodigo = #Session.Ecodigo# 
																	and x.CRTDcodigo = a.CRTDcodigo
														</cfquery>
														<cfif rsval.recordcount neq (rsvalE.recordcount + valEnulls)>															
															<cfset valE = false>															
														<cfelse>															
															<!--- 
															Si lo que se va a hacer es una mejora sobre un activo depreciable que tiene un 
															saldo de vida util en cero y no viene nada en la columna de vida util, 
															se presenta un error.
															--->
															<cfquery name="rsvalF" datasource="#Session.Dsn#">
																Select 1
																from #table_name# a
																	inner join Activos b
																		 on a.GATplaca = b.Aplaca
																		and b.Ecodigo = #Session.Ecodigo#
																		
																	inner join AFSaldos c
																		 on b.Aid = c.Aid
																		and b.Ecodigo = c.Ecodigo
																		and c.AFSperiodo = #P_Periodo#
																		and c.AFSmes = #P_Mes#
																		
																	inner join AClasificacion d
																		 on d.ACcodigo = c.ACcodigo
																		and d.ACid = c.ACid
																		and d.Ecodigo = #Session.Ecodigo#
																		and d.ACdepreciable = 'S'
																		
																where c.AFSsaldovutiladq = 0
																  	and (a.GATvutil is null or GATvutil = 0)
																  	and c.Ecodigo = #Session.Ecodigo#
															</cfquery>															
															<cfif rsvalF.recordcount gt 0>															
																<cfset valF = false>
															<cfelse>
																<!--- Obtiene la cantidad de Retiros --->
																<cfquery name="rsCantRet" datasource="#Session.Dsn#">
																	Select 1
																	from #table_name# a
																	where a.GATmonto < 0
																</cfquery>
																<!--- Obtiene la cantidad de Retiros que hacen join con Motivos de Retiro --->
																<cfquery name="rsCantRetM" datasource="#Session.Dsn#">
																	Select 1
																	from #table_name# a
																		inner join AFRetiroCuentas b
																			on a.AFRmotivo = b.AFRmotivo
																			and b.Ecodigo = #Session.Ecodigo#
																	where a.GATmonto < 0
																</cfquery>
																<cfif rsCantRet.recordcount neq rsCantRetM.recordcount>
																	<cfset valG	= false>
																<cfelse>
																	<cfquery name="rsvalH" datasource="#Session.Dsn#">
																		Select 1
																		from #table_name# a
																			inner join Activos b
																		 		on a.GATplaca = b.Aplaca
																				and b.Ecodigo = #Session.Ecodigo#
																				and b.Astatus = 60
																	</cfquery>
																	<cfif rsvalH.recordcount gt 0>															
																		<cfset valH = false>
																	<cfelse>																	
																		<cfquery name="rsvalI" datasource="#session.dsn#">
																		Select a.GATplaca, count(1)
																		from #table_name# a
																		where a.GATplaca is not null
																		  and not exists(	 Select 1
																							 from Activos b
																								inner join AFSaldos sa
																									on sa.Aid = b.Aid
																									and sa.Ecodigo = b.Ecodigo
																									and sa.AFSperiodo = #P_Periodo#
																									and sa.AFSmes = #P_Mes#
																							 where b.Aplaca = a.GATplaca
																								 and b.Ecodigo = #session.Ecodigo#) 
																		group by a.GATplaca, a.Cconcepto, a.Edocumento, a.GATperiodo, a.GATmes		
																		having count(1) > 1
																		</cfquery>		
																		
																		<cfif rsvalI.recordcount gt 0>
																			<cfset valI = false>
																		<cfelse>																		
																			<cfquery name="rsvalJ" datasource="#session.dsn#">
																			Select 1
																			from #table_name# a
																					inner join ACategoria ac
																						on ac.ACcodigodesc = a.ACcodigodesccat
																						and ac.Ecodigo = #session.Ecodigo#
																						
																					inner join AClasificacion acl
																						on acl.ACcodigodesc = a.ACcodigodescclas
																						and acl.ACcodigo 	= ac.ACcodigo
																						and acl.Ecodigo 	= #session.Ecodigo#
																						
																					inner join CFuncional cf
																						on cf.CFcodigo = a.CFcodigo
																						and cf.Ecodigo = #session.Ecodigo#	
																						
																			where exists( Select 1
																						  from Activos b
																							 	inner join AFSaldos sa
																										on sa.Aid = b.Aid
																										and sa.Ecodigo = b.Ecodigo
																										and sa.AFSperiodo = #P_Periodo#
																										and sa.AFSmes = #P_Mes#
																							where b.Aplaca = a.GATplaca
																							  and b.Ecodigo = #session.Ecodigo#) 
																			  and not exists( Select 1
																						      from Activos b1
																							 	inner join AFSaldos sa1
																										on sa1.Aid = b1.Aid
																										and sa1.Ecodigo = b1.Ecodigo
																										and sa1.AFSperiodo = #P_Periodo#
																										and sa1.AFSmes = #P_Mes#
																							where b1.Aplaca = a.GATplaca
																							  and b1.Ecodigo = #session.Ecodigo#
																							  and sa1.ACcodigo = ac.ACcodigo
																							  and sa1.ACid = acl.ACid
																							  and sa1.CFid = cf.CFid)
																			</cfquery>		
																			
																			<cfif rsvalJ.recordcount gt 0>
																				<cfset valJ = false>
																			<cfelse>																		
																				<cfset procesar = true>
																			</cfif><!---J--->	
																		</cfif><!---I--->			
																	</cfif><!---H--->	
																</cfif><!---G--->															
															</cfif><!---F--->
														</cfif><!---E--->
													</cfif><!---D--->
												</cfif><!---C--->
											</cfif><!---B--->
										</cfif><!---A--->
									</cfif><!---9--->
								</cfif><!---8--->
							</cfif><!---7--->
						</cfif><!---6--->
					</cfif><!---5--->
				</cfif><!---4--->
			</cfif><!---3--->
		</cfif><!---2--->
	</cfif><!---1--->
</cfif><!---0--->
<!--- 2. Procesa archivo con datos consistentes  --->	

<cfif procesar>
	<!--- 
	Verfica si las fechas de inicio de Depreciación y Revaluación vienen en el archivo
	de otra forma las mismas serán armadas tomando en cuenta los parámetros de sistema.
	Si no vienen en el archivo y los parámetros de sistema están en blanco, se asume la
	misma fecha de adquisicion.
	--->

	<!--- Parametro de Meses de Depresiacion a sumar --->
	<cfquery datasource="#Session.Dsn#" name="rsParamMD">
		Select Pvalor as meses
		from Parametros
		where Ecodigo =  #Session.Ecodigo# and Pcodigo = 940
	</cfquery>
	
	<cfif rsParamMD.recordcount eq 0 or trim(rsParamMD.meses) eq "">
		<cfset MDep = 0>
	<cfelse>
		<cfset MDep = rsParamMD.meses>
	</cfif>
	
	<!--- Parametro de Meses de Revaluacion a sumar --->
	<cfquery datasource="#Session.Dsn#" name="rsParamMR">
		Select Pvalor as meses
		from Parametros
		where Ecodigo =  #Session.Ecodigo# and Pcodigo = 950	
	</cfquery>	

	<cfif rsParamMR.recordcount eq 0 or trim(rsParamMR.meses) eq "">
		<cfset MRev = 0>
	<cfelse>
		<cfset MRev = rsParamMR.meses>
	</cfif>

	<cfif MDep neq 0>
		<cfquery datasource="#Session.Dsn#">
			UPDATE #table_name#
			set GATfechainidep = <cf_dbfunction name="dateadd" args="#MDep#, GATfecha,MM">
			where GATfechainidep is null
		</cfquery>
	</cfif>
	
	<cfif MRev neq 0>
		<cfquery datasource="#Session.Dsn#">
			UPDATE #table_name#
			set GATfechainirev = <cf_dbfunction name="dateadd" args="#MRev#, GATfecha,MM">
			where GATfechainirev is null
		</cfquery>
	</cfif>	
	
	<cfquery datasource="#Session.Dsn#">
		insert into GATransacciones 
			(Ecodigo, Cconcepto, GATperiodo, GATmes, 
				IDcontable, Edocumento, GATfecha, GATdescripcion, CFcuenta, 
				Ocodigo, ACid, ACcodigo, AFMid, 
				AFMMid, GATserie, GATplaca, GATfechainidep, 
				GATfechainirev, CFid, GATmonto, AFCcodigo, GATReferencia, DEid, CRCCid, CRTDid, 
				fechaalta, BMUsucodigo, GATvutil, AFRmotivo, GATestado)
		select #Session.Ecodigo#, b.Cconcepto, a.GATperiodo, a.GATmes, 
				c.IDcontable, c.Edocumento, a.GATfecha, a.GATdescripcion, d.CFcuenta, 
				e.Ocodigo, g.ACid, f.ACcodigo, h.AFMid, 
				i.AFMMid, a.GATserie, a.GATplaca, a.GATfechainidep, 
				a.GATfechainirev, j.CFid, a.GATmonto, k.AFCcodigo, a.GATReferencia, de.DEid, crcc.CRCCid, crtd.CRTDid, 
				<cf_dbfunction name="now">, #Session.Usucodigo#, a.GATvutil, a.AFRmotivo,
				case when a.GATperiodo is not null 
					and a.GATmes is not null  
					and b.Cconcepto is not null  
					and c.Edocumento is not null  
					and a.GATfecha is not null  
					and j.CFid is not null  
					and f.ACcodigo is not null  
					and g.ACid is not null  
					and a.GATplaca is not null  
					and a.GATdescripcion is not null  
					and h.AFMid is not null  
					and i.AFMMid is not null  
					and k.AFCcodigo is not null  
					and a.GATfechainidep is not null  
					and a.GATfechainirev is not null  
					and d.CFcuenta is not null  
					and a.GATmonto is not null  
					and de.DEid is not null
					and crcc.CRCCid is not null
					and crtd.CRTDid is not null
					then 1 else 0 end
		from #table_name# a
			left outer join ConceptoContableE b 
				on b.Ecodigo = #Session.Ecodigo#
				and b.Cconcepto = a.Cconcepto
				
			left outer join HEContables c 
				on c.Ecodigo = #Session.Ecodigo# 
				and c.Cconcepto = a.Cconcepto 
				and c.Edocumento = a.Edocumento 
				and c.Eperiodo = a.GATperiodo
				and c.Emes = a.GATmes
				
			left outer join CFinanciera d 
				on d.Ecodigo = #Session.Ecodigo# 
				and d.CFformato = a.CFformato
				
			left outer join Oficinas e 
				on e.Ecodigo = #Session.Ecodigo# 
				and e.Oficodigo = a.Oficodigo
				
			left outer join ACategoria f 
				on f.Ecodigo = #Session.Ecodigo# 
				and f.ACcodigodesc = a.ACcodigodesccat
				
			left outer join AClasificacion g 
				on g.Ecodigo = #Session.Ecodigo# 
				and g.ACcodigo = f.ACcodigo 
				and g.ACcodigodesc = a.ACcodigodescclas
				
			left outer join AFMarcas h 
				on h.Ecodigo = #Session.Ecodigo# 
				and h.AFMcodigo = a.AFMcodigo
				
			left outer join AFMModelos i 
				on i.Ecodigo = #Session.Ecodigo# 
				and i.AFMid = h.AFMid 
				and i.AFMMcodigo = a.AFMMcodigo
				
			left outer join CFuncional j 
				on j.Ecodigo = #Session.Ecodigo# 
				and j.CFcodigo = a.CFcodigo	
				and j.Ecodigo = e.Ecodigo
				and j.Ocodigo = e.Ocodigo
				
			left outer join AFClasificaciones k
				on k.Ecodigo = #Session.Ecodigo# 
				and k.AFCcodigoclas = a.AFCcodigoclas
				
			left outer join DatosEmpleado de
				on de.Ecodigo = #Session.Ecodigo# 
				and de.DEidentificacion = a.DEidentificacion
				
			left outer join CRCentroCustodia crcc
				on crcc.Ecodigo = #Session.Ecodigo# 
				and crcc.CRCCcodigo = a.CRCCcodigo
				
			left outer join CRTipoDocumento crtd
				on crtd.Ecodigo = #Session.Ecodigo# 
				and crtd.CRTDcodigo = a.CRTDcodigo
	</cfquery>	
<!--- 3. Retorna mensajes de errores en el archivo--->
<cfelse>
<!---Periodo--->
	<cfif not val0>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El Periodo es requerido.' as MSG, count(1) as Periodos_Invalidos_o_Nulos
			from #table_name# a
			where GATperiodo <= 0
		</cfquery>
<!---Mes--->		
	<cfelseif not val1>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El Mes es requerido.' as MSG, count(1) as Meses_Invalidos_o_Nulos
			from #table_name# a
			where GATmes <= 0
		</cfquery>
<!---Concepto contable--->		
	<cfelseif not val2>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El concepto contable (lote) no existe.' as MSG, a.Cconcepto as Concepto_Contable
			from #table_name# a
			where not exists (	select 1 
								from ConceptoContableE b 
								where b.Ecodigo = #Session.Ecodigo#
				  					and b.Cconcepto = a.Cconcepto
							 )
		</cfquery>
		
	<cfelseif not val3>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El documento contable (poliza) no existe para el Concepto / Periodo / Mes indicados.' as MSG, a.Cconcepto as Concepto, a.GATperiodo as Periodo, a.GATmes as Mes, a.Edocumento as Documento_Contable
			from #table_name# a
			where not exists (	select 1
								from HEContables c 
								where c.Ecodigo = #Session.Ecodigo# 
								  	and c.Cconcepto = a.Cconcepto 
								  	and c.Edocumento = a.Edocumento 
								  	and c.Eperiodo = a.GATperiodo
								  	and c.Emes = a.GATmes			
						     )
		</cfquery>
		
	<cfelseif not val4>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'La Cuenta Financiera no existe.' as MSG, a.CFformato as Cuenta_Financiera
			from #table_name# a
			where not exists (	select 1 
								from CFinanciera d 
								where d.Ecodigo = #Session.Ecodigo# 
									and d.CFformato = a.CFformato )
		</cfquery>
		
	<cfelseif not val5>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'La Oficina no existe.' as MSG, a.Oficodigo as Oficina
			from #table_name# a
			where not exists (	select 1 
								from Oficinas e 
								where e.Ecodigo = #Session.Ecodigo# 
									and e.Oficodigo = a.Oficodigo )
		</cfquery>
		
	<cfelseif not val6>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'La Categoria no existe.' as MSG, a.ACcodigodesccat as Categoria
			from #table_name# a
			where not exists (	select 1 
								from ACategoria f 
								where f.Ecodigo = #Session.Ecodigo# 
									and f.ACcodigodesc = a.ACcodigodesccat )
			<cfif not val6required>
				and a.ACcodigodesccat is not null
			</cfif>
		</cfquery>
		
	<cfelseif not val7>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'La Clasificacion no existe para la Categoria indicada.' as MSG, 
				a.ACcodigodesccat as Categoria, 
				a.ACcodigodescclas as Clasificacion
			from #table_name# a
			where not exists (	select 1 
								from ACategoria f 
									inner join AClasificacion g 
										on g.Ecodigo = #Session.Ecodigo# 
										and g.ACcodigo = f.ACcodigo 
										and g.ACcodigodesc = a.ACcodigodescclas
								where f.Ecodigo = #Session.Ecodigo# 
				  					and f.ACcodigodesc = a.ACcodigodesccat )
			<cfif not val7required>
				and a.ACcodigodescclas is not null
			</cfif>
		</cfquery>
		
	<cfelseif not val8>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'La Marca no existe.' as MSG, a.AFMcodigo as Marca
			from #table_name# a
			where not exists (	select 1 
								from AFMarcas h 
								where h.Ecodigo = #Session.Ecodigo# 
									and h.AFMcodigo = a.AFMcodigo )
			<cfif not val8required>
				and a.AFMcodigo is not null
			</cfif>
		</cfquery>
		
	<cfelseif not val9>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El Modelo no existe para la Marca indicada.' as MSG, a.AFMcodigo as Marca, a.AFMMcodigo as Modelo
			from #table_name# a
			where not exists (	select 1 
								from AFMarcas h 
									inner join AFMModelos i 
										on i.Ecodigo = #Session.Ecodigo# 
										and i.AFMid = h.AFMid 
										and i.AFMMcodigo = a.AFMMcodigo
								where h.Ecodigo = #Session.Ecodigo# 
				  					and h.AFMcodigo = a.AFMcodigo )
			<cfif not val9required>
				and a.AFMMcodigo is not null
			</cfif>
		</cfquery>
		
	<cfelseif not valA>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El Centro Funcional no existe para la Oficina definida.' as MSG, a.CFcodigo as Centro_Funcional, a.Oficodigo as Oficina
			from #table_name# a
			where (	select count(1) 
					  from CFuncional j 
						inner join Oficinas e 
						   on j.Ecodigo = e.Ecodigo
						  and j.Ocodigo = e.Ocodigo
					where j.Ecodigo = #Session.Ecodigo# 
					  and j.CFcodigo  = a.CFcodigo	
					  and e.Oficodigo = a.Oficodigo
					) <= 0
			<cfif not valArequired>
				and a.CFcodigo is not null
			</cfif>
		</cfquery>
		
	<cfelseif not valB>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El Tipo no existe' as MSG, a.AFCcodigoclas as Tipo
			from #table_name# a
			where not exists (
				select 1 
				from AFClasificaciones x 
				where x.Ecodigo = #Session.Ecodigo# 
				and x.AFCcodigoclas = a.AFCcodigoclas
			)
			<cfif not valBrequired>
				and a.AFCcodigoclas is not null
			</cfif>
		</cfquery>
		
	<cfelseif not valC>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El responsable no se encuentra dentro de los empleados asociados al centro funcional' as MSG, a.CFcodigo, a.DEidentificacion
			from #table_name# a
				inner join CFuncional cf
				  on cf.CFcodigo = a.CFcodigo
			where cf.Ecodigo = #Session.Ecodigo#  
			  and (select count(1) 
					from DatosEmpleado x 
					where x.Ecodigo = #Session.Ecodigo# 
						and x.DEidentificacion = a.DEidentificacion
						and ( (	select count(1) 
								from LineaTiempo lt
									inner join RHPlazas rhp
										on rhp.RHPid = lt.RHPid
		
								where lt.DEid = x.DEid 
								  and rhp.CFid = cf.CFid
								  and <cf_dbfunction name="now"> between LTdesde and LThasta )>0
							  or
							 (select count(1) 
								from EmpleadoCFuncional ecf
								where ecf.DEid = x.DEid 
									and ecf.CFid = cf.CFid
									and <cf_dbfunction name="now"> between ECFdesde and ECFhasta ) > 0 )	) <= 0
			<cfif not valCrequired>
				and a.DEidentificacion is not null
			</cfif>
		</cfquery>
		
	<cfelseif not valD>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El centro de custodia no está asociado al centro funcional' as MSG, a.CFcodigo, a.CRCCcodigo
			from #table_name# a
				left join CFuncional z
					on z.Ecodigo = #Session.Ecodigo# 
					and z.CFcodigo = a.CFcodigo
			where not exists (	select 1 
								from CRCentroCustodia y
								where y.Ecodigo = #Session.Ecodigo# 
									and y.CRCCcodigo = a.CRCCcodigo
									and exists (	select 1 
													from CRCCCFuncionales x 
													where y.CRCCid = x.CRCCid
														and z.CFid = x.CFid ) )
			<cfif not valCrequired>
				and a.CRCCcodigo is not null
			</cfif>
		</cfquery>
		
	<cfelseif not valE>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El tipo de documento no existe' as MSG, a.CRTDcodigo
			from #table_name# a
			where not exists (	select 1 
								from CRTipoDocumento x
								where x.Ecodigo = #Session.Ecodigo# 
									and x.CRTDcodigo = a.CRTDcodigo )
			<cfif not valCrequired>
				and a.CRTDcodigo is not null
			</cfif>
		</cfquery>
		
	<cfelseif not valF>		
		<cfquery name="ERR" datasource="#Session.Dsn#">
			Select 'Se esta intentando importar una mejora con vida util cero a un Activo ya depreciado' as MSG, a.GATplaca
			from #table_name# a
				inner join Activos b
					on a.GATplaca = b.Aplaca
					and b.Ecodigo = #Session.Ecodigo#
					
				inner join AFSaldos c
					on b.Aid = c.Aid
					and c.Ecodigo = #Session.Ecodigo#
					and c.AFSperiodo = #P_Periodo#
					and c.AFSmes = #P_Mes#

				inner join AClasificacion d
					 on d.ACcodigo 	= c.ACcodigo
					and d.ACid 		= c.ACid
					and d.Ecodigo 	= #Session.Ecodigo#
					and d.ACdepreciable = 'S'

			where c.AFSsaldovutiladq = 0
			  	and (a.GATvutil is null or GATvutil = 0)
			  	and c.Ecodigo = #Session.Ecodigo#
		</cfquery>	
	
	<cfelseif not valG>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			Select 'Se esta importando un retiro, especificando un motivo de retiro no válido' as MSG, a.GATplaca
			from #table_name# a		
			where a.GATmonto < 0
				and not exists ( 	Select 1
								 	from AFRetiroCuentas b
									where a.AFRmotivo = b.AFRmotivo
										and b.Ecodigo = #Session.Ecodigo# )
		</cfquery>
		
	<cfelseif not valH>
		<cfquery name="ERR" datasource="#Session.Dsn#">
		Select 'Se esta intentando importar un Activo con una placa ya retirada' as MSG, a.GATplaca
		from #table_name# a
			inner join Activos b
				on a.GATplaca = b.Aplaca
				and b.Ecodigo = #Session.Ecodigo#
				and b.Astatus = 60
		</cfquery>

	<cfelseif not valI>
		<cfquery name="ERR" datasource="#Session.Dsn#">
		Select 'La placa se encuentra más de una vez en el archivo' as MSG, a.GATplaca as Placa, a.Cconcepto as Concepto, a.Edocumento as Documento, a.GATperiodo as Periodo, a.GATmes as Mes, count(1) as Veces
		from #table_name# a
		where a.GATplaca is not null
		  and not exists(	 Select 1
							 from Activos b
								inner join AFSaldos sa
									on sa.Aid = b.Aid
									and sa.Ecodigo = b.Ecodigo
									and sa.AFSperiodo = #P_Periodo#
									and sa.AFSmes = #P_Mes#
							 where b.Aplaca = a.GATplaca
								 and b.Ecodigo = #session.Ecodigo#) 
		group by a.GATplaca, a.Cconcepto, a.Edocumento, a.GATperiodo, a.GATmes		
		having count(1) > 1		
		</cfquery>
		
	<cfelseif not valJ>
		<cfquery name="ERR" datasource="#session.dsn#">
		Select distinct 'Existen Activos inconsistentes con los datos de Categoria,Clase y Centro Funcional' as MSG, a.GATplaca as Placa, a.ACcodigodesccat as Categoria, a.ACcodigodescclas as Clase, a.CFcodigo as Centro_Funcional
		from #table_name# a			
				inner join ACategoria ac
					on ac.ACcodigodesc = a.ACcodigodesccat
					and ac.Ecodigo = #session.Ecodigo#
					
				inner join AClasificacion acl
					on acl.ACcodigodesc = a.ACcodigodescclas
					and acl.ACcodigo 	= ac.ACcodigo
					and acl.Ecodigo 	= #session.Ecodigo#
					
				inner join CFuncional cf
					on cf.CFcodigo = a.CFcodigo
					and cf.Ecodigo = #session.Ecodigo#	
				
		where exists( Select 1
					  from Activos b
							inner join AFSaldos sa
									on sa.Aid = b.Aid
									and sa.Ecodigo = b.Ecodigo
									and sa.AFSperiodo = #P_Periodo#
									and sa.AFSmes = #P_Mes#
						where b.Aplaca = a.GATplaca
						  and b.Ecodigo = #session.Ecodigo#) 
		  and not exists( Select 1
						  from Activos b1
							inner join AFSaldos sa1
									on sa1.Aid = b1.Aid
									and sa1.Ecodigo = b1.Ecodigo
									and sa1.AFSperiodo = #P_Periodo#
									and sa1.AFSmes = #P_Mes#
						where b1.Aplaca = a.GATplaca
						  and b1.Ecodigo = #session.Ecodigo#
						  and sa1.ACcodigo = ac.ACcodigo
						  and sa1.ACid = acl.ACid
						  and sa1.CFid = cf.CFid)
		</cfquery>				


	</cfif>	
</cfif>


