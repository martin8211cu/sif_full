<!---<cfdump var="#url#">
<cf_dump var="#form#">--->

<cfif isdefined('url.CFid') and len(trim(url.CFid)) gt 0 and not isdefined ('form.CFid')>
	<cfset form.CFid=#url.CFid#>
</cfif>
<cfif isdefined('url.GEAfechaPagar') and len(trim(url.GEAfechaPagar)) gt 0 and not isdefined ('form.GEAfechaPagar')>
	<cfset form.GEAfechaPagar=#url.GEAfechaPagar#>
</cfif>

<cfset LvarSAporEmpleadoCFM = "solicitudesAnticipo.cfm">
<!---Formulado por: en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=#session.Ecodigo#
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->

<cfif isdefined ('form.modo')  >
	<cfquery name="rsTipo" datasource="#session.dsn#">
		select GEAtipoviatico
			from GEanticipo 
			where GEAid=#form.GEAid#
			and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfset tipo=#rsTipo.GEAtipoviatico#>
	
	<cfif form.modo EQ 'ALTA' >
		<cfset GEAid=#form.GEAid#>
		<cfset calcular=true>
		<cfset GECVid=#form.GECVid#>
		<cfset fecha1DateTime=#form.GEADfechaini#>
		<cfset fecha2DateTime=#form.GEADfechafin#>
		<cfset horaini=#form.GEADhoraini#>
		<cfset horafin=#form.GEADhorafin#>
		<cfset aplicaTodos=0>
		
	<cfelseif form.modo EQ 'BAJA' >
		<cfquery datasource="#session.dsn#">
			delete from GEanticipoDet
				where GEAid=#form.GEAid#
				and GEPVid=#form.GEPVID#
		</cfquery>	
		
		<cfquery name="rsViatico" datasource="#session.dsn#">
			select GEPVaplicaTodos from GEPlantillaViaticos
				where GEPVid=#form.GEPVID#
		</cfquery>
		<cfif #rsViatico.GEPVaplicaTodos# eq 0>
			<cfquery datasource="#session.dsn#"> 
				delete from GEanticipoDet 
					where GEPVid in (select GEPVid from GEPlantillaViaticos
									where GEPVaplicaTodos ='1'
									and Ecodigo=#session.Ecodigo#
									)
					and GEAid=#form.GEAid#
			</cfquery>
			
			<cfquery name="rsCant" datasource="#session.dsn#">
				select GEAid from GEanticipoDet
				where GEAid=#form.GEAid#
			</cfquery>	
		
			<cfif rsCant.recordCount gt 0>
				<cfset fnRecalcularAplicanTodos(#form.GEAid#)>
			</cfif>	
		</cfif>	
		
		<cfset sbUpdateTotal()>	
		<cflocation url="SolAntViatico_form.cfm?GEAid=#form.GEAid#&tipo=#tipo#&calcular=false&GEAfechaPagar=#form.GEAfechaPagar#&LvarSAporEmpleadoCFM=#LvarSAporEmpleadoCFM#&CFid=#form.CFid#">
	</cfif>
<cfelse>

	<cfquery name="rsTipo" datasource="#session.dsn#">
		select GEAtipoviatico
			from GEanticipo 
			where GEAid=#GEAid#
			and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfset tipo=#rsTipo.GEAtipoviatico#>
	<cfquery name="rsRecalcular" datasource="#session.dsn#">
		select GEPVid from GEanticipoDet
		where GEAid=#url.GEAid#
		and GEPVid IS NOT NULL
		
	</cfquery>
	<cfif  rsRecalcular.recordcount gt 0>
		<cflocation url="SolAntViatico_form.cfm?GEAid=#url.GEAid#&tipo=#tipo#&calcular=false&GEAfechaPagar=#form.GEAfechaPagar#&LvarSAporEmpleadoCFM=#url.LvarSAporEmpleadoCFM#&CFid=#form.CFid#">
	</cfif>

	<cfset GEAid="#url.GEAid#">
	<cfset calcular="#url.calcular#">
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select GEAdesde, GEAhasta, GEAhoraini, GEAhorafin
			from GEanticipo 
			where GEAid=#GEAid#
			and Ecodigo=#session.Ecodigo#
	</cfquery>
	 <cfset fecha1DateTime=#rsDatos.GEAdesde#>
	 <cfset fecha2DateTime=#rsDatos.GEAhasta#>
	 <cfset horaini=#rsDatos.GEAhoraini#>
	 <cfset horafin=#rsDatos.GEAhorafin#>
	 <cfset aplicaTodos=1>
 </cfif>
 
 
<cfset p1=0> <!---variable para guardar el valor de la plantilla del viatico--->
<cfset p2=0> <!---en caso de que se traslape las fechas de las plantillas, entonces aqui se guarda la otra plantilla--->
<!---el proceso es el siguiente: la plantilla en el catalogo de plantillas, tiene definida una fecha de inicio y fin por lo cual para el año 09 la platilla ligada al alimento puede
valer 1000 colones, y para el año 10 valer 2000 colones.  Por este motivo si un empleado salio desde el 21/12/09 y llega el 08/01/10  hay que hacer un calculo para la fecha del 21 al 31 del 09
por 1000 por dia... y otro calculo desde el 01 al 08 del 10 por 2000 colones por dia. Por eso se definen 2 p (plantillas) en caso de que las fechas mezclen 2 plantillas --->

<cfif calcular >
	<cfloop condition="len(trim(#p1#))" >
	
		<cfset monto = 0>
	
		<cfquery name="rsPlantilla1" datasource="#session.dsn#">
			select  min(GEPVid ) as p1
				from GEPlantillaViaticos
				where Ecodigo = #session.Ecodigo#
				   and  GEPVaplicaTodos = '#aplicaTodos#'
				   and GEPVtipoviatico = '#tipo#'
				   <cfif isdefined ('form.modo')>
				   and GECVid=#GECVid#
				   and #lsparsedatetime(fecha1DateTime)#
				   <cfelse>
				   and '#fecha1DateTime#' 
				   </cfif>
				   between GEPVfechaini and GEPVfechafin
				   and GEPVid > #p1#
		</cfquery>
		
		<cfif not len(trim(#p2#))>
			<cfset p2=#ultimoP2#>
		</cfif>
		
		<cfquery name="rsPlantilla2" datasource="#session.dsn#">
			select  min(GEPVid ) as p2
				from GEPlantillaViaticos
				where Ecodigo = #session.Ecodigo#
				 and  GEPVaplicaTodos = '#aplicaTodos#'
				 and GEPVtipoviatico = '#tipo#'
				 <cfif isdefined ('form.modo')>
				 and GECVid=#GECVid#
				   and #lsparsedatetime(fecha2DateTime)#
				 <cfelse>
				 and '#fecha2DateTime#' 
				 </cfif>
				 between GEPVfechaini and GEPVfechafin
				 and GEPVid > #p2#
		</cfquery>
		
		<cfset p1=#rsPlantilla1.p1#>
		<cfif not len(trim(#rsPlantilla2.p2#))>
			<cfset ultimoP2=#p2#>
		</cfif>
		<cfset p2= #rsPlantilla2.p2#>	
		 
		<cfif len(trim(#p1#)) >
			<cfif p1 eq p2 or not len(trim(#p2#)) >
			
			<!---se hace el calculo del monto para una sola plantilla con fechas y horas originales'--->
				<cfquery name="rsPlantillaUnica" datasource="#session.dsn#">
					select	GEPVhoraini as GEPVhoraini, 
							GEPVhorafin as GEPVhorafin,
							GEPVfechafin
							from GEPlantillaViaticos
							where Ecodigo = #session.Ecodigo#
							and GEPVid = #p1#
				</cfquery>
				<cfset	monto = 0>
				<cfset GEPVhoraini="#rsPlantillaUnica.GEPVhoraini#">
				<cfset GEPVhorafin="#rsPlantillaUnica.GEPVhorafin#">
				
				 <cfquery name="rsDiferenciaFechaFinal" datasource="#session.dsn#">
					select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha2DateTime#')#, #LSParseDateTime('#rsPlantillaUnica.GEPVfechafin#')#"> as diasDiferenciaFechaFinal
					from dual
				</cfquery>
				
				
				<cfif #rsDiferenciaFechaFinal.diasDiferenciaFechaFinal# gte 0>  
					 <cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
						select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1DateTime#')#, #LSParseDateTime('#fecha2DateTime#')#"> as diasDiferencia
						from dual
					</cfquery>
					
					<cfset diasDif= #rsDiferenciaDias.diasDiferencia#>
					<cfset fechaGuardar1=#fecha1DateTime#>
					<cfset fechaGuardar2=#fecha2DateTime#>
				<cfelse>
					 <cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
						select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1DateTime#')#, #LSParseDateTime('#rsPlantillaUnica.GEPVfechafin#')#"> as diasDiferencia
						from dual
					</cfquery>
					<cfset diasDif= #rsDiferenciaDias.diasDiferencia#+1>
					<cfset fechaGuardar1=#fecha1DateTime#>
					<cfset fechaGuardar2=#rsPlantillaUnica.GEPVfechafin#>
				</cfif>
				
				
				
				
				<cfif #GEPVhoraini# neq 0>
					<cfset	dias = diasDif-1>
					
					<cfif #diasDif# eq 0><!---si es el mismo dia--->
						<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
							select  GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
									 and GEPVhoraini <= #horafin#
									 and GEPVhorafin >= #horaini#
						</cfquery>
						<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
							<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
						</cfif>
					<cfelse>	
						<cfquery name="rsHoraInicio" datasource="#session.dsn#">
							 select	 GEPVmonto
									 from GEPlantillaViaticos
									 where Ecodigo = #session.Ecodigo#
									 and GEPVid = #p1#
									 and GEPVhorafin >= #horaini#
						</cfquery>
						<cfif len(trim(#rsHoraInicio.GEPVmonto#))>
							<cfset  monto=#rsHoraInicio.GEPVmonto#+monto>
						</cfif>

						<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
							select  GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
									 and GEPVhoraini <= #horafin#
						</cfquery>
						<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
							<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
						</cfif> 
					</cfif>
					<cfif dias gte 0>
						<cfquery name="rsMontoDias" datasource="#session.dsn#">	
							select  GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
						</cfquery>
						<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>	
					</cfif>
				<cfelse> <!---si la hora eq 0--->
					<cfset	dias = diasDif>	
					<cfquery name="rsMontoDias" datasource="#session.dsn#">	
						select  GEPVmonto  
								from GEPlantillaViaticos
								where Ecodigo = #session.Ecodigo#
								and GEPVid = #p1#
					</cfquery>
					<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>
				</cfif>	
				
				<cfset plantilla=#p1#> 
				<cfset fnInsertar()>
				<cfset sbUpdateTotal()>	
	
			<cfelse> <!---si p1 diferente de p2--->
			 <!---se hace el calculo del monto para  plantilla p1 con fecha y hora inicio originales y fecha fin  = GEPVfecha fin  y hora fin = x1440'--->
				<cfset monto=0>
				<cfquery name="rsFechaHoraFinM" datasource="#session.dsn#"> 
					select GEPVhoraini, 
							GEPVhorafin, 
							GEPVfechafin
						from GEPlantillaViaticos
						where Ecodigo = #session.Ecodigo#
						and GEPVid = #p1#
				</cfquery>
				<cfset GEPVhoraini="#rsFechaHoraFinM.GEPVhoraini#">
				<cfset GEPVhorafin="#rsFechaHoraFinM.GEPVhorafin#">
				<cfset horafinm=1440>
				<cfset fecha2m="#rsFechaHoraFinM.GEPVfechafin#">
				
				<!---se saca los dias de dif con respecto a la fecha2m modificada, la cual me indica cuando termina el periodo de esa plantilla--->
				 <cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
					select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1DateTime#')#, #LSParseDateTime('#fecha2m#')#"> as diasDiferencia
						from dual
				</cfquery>
				<cfset fechaGuardar1=#fecha1DateTime#>
				<cfset fechaGuardar2=#fecha2m#>
				
				<cfset diasDif= "#rsDiferenciaDias.diasDiferencia#">
					
				<cfif #GEPVhoraini# neq 0>
					<cfset	dias = diasDif-1>
					
					<cfif #diasDif# eq 0>
						<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
							select  GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
									 and GEPVhoraini <= #horafin#
									 and GEPVhorafin >= #horaini#
						</cfquery>
						<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
							<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
						</cfif>
					<cfelse>	
						<cfquery name="rsHoraInicio" datasource="#session.dsn#"> 
							 select GEPVmonto
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
									and GEPVhorafin >= #horaini#
						</cfquery>
						<cfif len(trim(#rsHoraInicio.GEPVmonto#))>	
							<cfset  monto=#rsHoraInicio.GEPVmonto#+monto>
						</cfif>		
						<cfquery name="rsHoraFinal" datasource="#session.dsn#"> 			
							select 	 GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
									 and GEPVhoraini <= #horafinm#
						</cfquery>
						<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
							<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>
						</cfif>	 
					</cfif>
						
					<cfif dias gt 0>			 
						<cfquery name="rsMontoDias" datasource="#session.dsn#"> 	
								select GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo = #session.Ecodigo#
										and GEPVid = #p1#
						</cfquery>
						<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>	
					</cfif>	
					
				<cfelse><!---si la hora eq 0--->	
					<cfquery name="rsMontoDias" datasource="#session.dsn#">
							select  GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p1#
					</cfquery>
					<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>					
				</cfif>			   
	
				<cfset plantilla=#p1#> 
				<cfset fnInsertar()>
				<cfset sbUpdateTotal()>	
			
		 <!---    se hace el calculo del monto para la plantilla p2 con fecha y hora fin originales y fecha ini = GEPVfechain  y hora ini  = 1'--->
				<cfif  len(trim(#p2#))>
					<cfquery name="rsFechaHoraIniM" datasource="#session.dsn#">
						select GEPVhoraini, 
								GEPVhorafin, 
								GEPVfechaini
							from GEPlantillaViaticos
							where Ecodigo = #session.Ecodigo#
							and  GEPVid = #p2#
					</cfquery>
					<cfset GEPVhoraini="#rsFechaHoraIniM.GEPVhoraini#">
					<cfset GEPVhorafin="#rsFechaHoraIniM.GEPVhorafin#">
					<cfset fecha1m="#rsFechaHoraIniM.GEPVfechaini#">	
					<cfset horainim=1>	
					<cfset  monto=0>
					
					<!---se saca los dias de dif con respecto a la fecha1m modificada, la cual me indica cuando empieza el periodo de esa plantilla--->
					<cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
						select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1m#')#, #LSParseDateTime('#fecha2DateTime#')#"> as diasDiferencia
							from dual
					</cfquery>
					<cfset fechaGuardar1=#fecha1m#>
					<cfset fechaGuardar2=#fecha2DateTime#>
					<cfset diasDif= "#rsDiferenciaDias.diasDiferencia#">
					
					<cfif #GEPVhoraini# neq 0>
						<cfset	dias = diasDif-1>
						
						<cfif #diasDif# eq 0>
							<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo = #session.Ecodigo#
										and GEPVid = #p1#
										 and GEPVhoraini <= #horafin#
										 and GEPVhorafin >= #horaini#
							</cfquery>
							<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
								<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
							</cfif>
						<cfelse>
							<cfquery name="rsHoraInicioP2" datasource="#session.dsn#">
								 select  GEPVmonto
										 from GEPlantillaViaticos
										 where Ecodigo = #session.Ecodigo#
										 and GEPVid = #p2#
										 and GEPVhorafin >= #horainim#
							</cfquery>
							<cfif len(trim(#rsHoraInicioP2.GEPVmonto#))>
								<cfset  monto=#rsHoraInicioP2.GEPVmonto#+monto>	
							</cfif>
							<cfquery name="rsHoraFinalP2" datasource="#session.dsn#">			
								select   GEPVmonto  
										from GEPlantillaViaticos
										 where Ecodigo = #session.Ecodigo#
										and GEPVid = #p2#
										 and GEPVhoraini <= #horafin#
							</cfquery>
							<cfif len(trim(#rsHoraFinalP2.GEPVmonto#))>
								<cfset  monto=#rsHoraFinalP2.GEPVmonto#+monto>	
							</cfif> 
						</cfif>	
						<cfif dias gt 0>
							<cfquery name="rsMontoDiasP2" datasource="#session.dsn#">			 
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo = #session.Ecodigo#
										and GEPVid = #p2#
							</cfquery>
							<cfset  monto=dias*#rsMontoDiasP2.GEPVmonto#+monto>		
						</cfif>		   
					<cfelse>
						<cfquery name="rsMontoDiasP2" datasource="#session.dsn#">
							select GEPVmonto 
									from GEPlantillaViaticos
									where Ecodigo = #session.Ecodigo#
									and GEPVid = #p2#
						</cfquery>
						<cfset  monto=dias*#rsMontoDiasP2.GEPVmonto#+monto>			   
			
					</cfif>
				</cfif><!---si no viene vacio p2--->
				<cfset plantilla=#p2#> 
				<cfset fnInsertar()>	
				<cfset sbUpdateTotal()>	
				
			</cfif>	 <!---p1 eq p2 --->
		</cfif> <!---p1 neq null--->
	</cfloop>
	<cfset fnRecalcularAplicanTodos(#GEAid#)>
	<cflocation url="SolAntViatico_form.cfm?GEAid=#GEAid#&tipo=#tipo#&calcular=false&GEAfechaPagar=#form.GEAfechaPagar#&LvarSAporEmpleadoCFM=#LvarSAporEmpleadoCFM#&CFid=#form.CFid#">
</cfif>

<cffunction name="sbUpdateTotal" output="false" access="private">
	<cfquery datasource="#session.dsn#">
		update GEanticipo
 		   set GEAtotalOri = 
					coalesce(
					( 
						select sum(GEADmonto)
						  from GEanticipoDet
						 where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
					)
					, 0)
		  where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#" null="#Len(GEAid) Is 0#">
		  and Ecodigo = #session.Ecodigo#
	</cfquery>
</cffunction>

<cffunction name="fnInsertar" access="private" output="false" >
	<cfquery name="rsConcepto" datasource="#session.dsn#">
		select GECid
			from GEPlantillaViaticos
			where GEPVid=#plantilla#
			and Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfquery name="rsHoras" datasource="#session.dsn#">
		select GEAhoraini,GEAhorafin
			from GEanticipo
			where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
			and Ecodigo = #session.Ecodigo#
	</cfquery>
				
	<cfquery name="rsMcodPlantilla" datasource="#session.dsn#">
		select  Mcodigo
			from GEPlantillaViaticos 	
			where GEPVid = #plantilla#
			and Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfquery name="rsMcodActicipo" datasource="#session.dsn#">
		select  Mcodigo, GEAmanual 
		from GEanticipo 	
			where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
			and Ecodigo = #session.Ecodigo#
	</cfquery>
	
	
	<cfquery name="rsTC" datasource="#session.dsn#">
		select 
			coalesce(TCventa,1) as venta, 
			g.Mcodigo as McodigoPlantilla
		from GEPlantillaViaticos g
			left outer join Htipocambio htc
					on htc.Mcodigo = g.Mcodigo
					and #now()# between htc.Hfecha and htc.Hfechah  		
			where g.GEPVid = #plantilla#
			and g.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom> 
		<cfquery name="rsGEconceptoGasto" datasource="#session.dsn#">
			select Cid
				from GEconceptoGasto
				where GECid=#rsConcepto.GECid#
		</cfquery>
		
		<cfquery name="rsCFidAnticipo" datasource="#session.dsn#">
			select CFid
				from GEanticipo
				where GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<!---<cfquery name="rsPCGDidPlanCompras" datasource="#session.dsn#">
			select PCGDid,PCGcuenta
				from PCGDplanCompras
				where CFid=#rsCFidAnticipo.CFid#
				and   Cid=#rsGEconceptoGasto.Cid#
				and Ecodigo = #session.Ecodigo#
		</cfquery>
		
		<cfif rsPCGDidPlanCompras.recordcount eq 0>
			<cf_errorCode	code = "51669" msg = "No se pudo hacer la relacion entre el plan de compras, centro funcional del encabezado y el concepto de gasto">
		</cfif>		--->
	</cfif>
	
	<cfif isdefined ('rsHoras.GEAhoraini') and len(trim(#rsHoras.GEAhoraini#))>
		<cfset GEPVhoraini= #rsHoras.GEAhoraini#>
	<cfelse>
		<cfset GEPVhoraini=0>
	</cfif>	
	<cfif isdefined ('rsHoras.GEAhoraini') and len(trim(#rsHoras.GEAhoraini#))>
		<cfset GEPVhorafin= #rsHoras.GEAhorafin#>
	<cfelse>
		<cfset GEPVhorafin= 0>
	</cfif>	
	<cftransaction>
	<cfset lvarMonto1 = #rsTC.venta#/#rsMcodActicipo.GEAmanual#>
	<cfquery datasource="#session.dsn#" name="insertadetalle">
		insert into GEanticipoDet (
			GEAid,
			GEPVid,
			GECid,
			BMUsucodigo,
			GEADmonto,
			GEADtipocambio,
			GEADfechaini,
			GEADfechafin,
			GEADhoraini,
			GEADhorafin,
			GEADmontoviatico,
			<!---<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and len(trim(#rsPCGDidPlanCompras.PCGDid#))> 
			PCGDid,
			</cfif>--->	
			Linea,
			McodigoPlantilla
			)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#plantilla#">,
			#rsConcepto.GECid#,
			#session.Usucodigo#,
			<cfif rsMcodPlantilla.Mcodigo eq rsMcodActicipo.Mcodigo>
				#monto#,
			<cfelse>	
				round((#lvarMonto1#)*#monto#,2),
			</cfif>	
			#rsTC.venta#,
			<cfif isdefined ('form.modo')>
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fechaGuardar1)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fechaGuardar2)#">,
			 <cfelse>
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#(fechaGuardar1)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#(fechaGuardar2)#">,
			</cfif>
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#horaini#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#horafin#">,
			#monto#,
			<!---<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and len(trim(#rsPCGDidPlanCompras.PCGDid#))> 
			#rsPCGDidPlanCompras.PCGDid#,
			</cfif>--->
			0,
			#rsTC.McodigoPlantilla#
			)
			<cf_dbidentity1 datasource="#session.dsn#" name="insertadetalle">
	</cfquery>
			<cf_dbidentity2 datasource="#session.dsn#" name="insertadetalle" returnvariable="LvarTESSADid1">
			<cfset #GEADid#=#LvarTESSADid1#>						
	</cftransaction>
	
	<cfquery datasource="#session.dsn#">
			update GEanticipo
				set GEAtotalOri = 
				coalesce(
				( select sum(GEADmonto)
				from GEanticipoDet
				where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#">
				)
				, 0)
			where GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GEAid#" null="#Len(GEAid) Is 0#">
			and Ecodigo = #session.Ecodigo#
	</cfquery>
	<!---CREA CUENTA FINANCIERA--->		
	<!---Mascara para la cuenta financiera--->		
	
	<!---si NO es por plan de compras arma la cuenta como siempre lo ha hecho--->	
	<cfif rsUsaPlanCuentas.Pvalor neq LvarParametroPlanCom> 		

		<cfquery name="rsCtas" datasource="#session.DSN#">
			select sad.GEADid, cf.CFcuentac, cg.GECcomplemento
			from GEanticipo sa
				inner join CFuncional cf
				on cf.CFid = sa.CFid
					inner join GEanticipoDet sad
					on sad.GEAid = sa.GEAid
						inner join GEconceptoGasto cg
						on cg.GECid = sad.GECid
			where sa.GEAid = #GEAid#
		</cfquery>				
		<cfobject component="sif.Componentes.AplicarMascara" name="LvarOBJ">				
			<cfloop query="rsCtas">
				<cfset LvarCFformato = LvarOBJ.AplicarMascara(rsCtas.CFcuentac, rsCtas.GECcomplemento)>
					<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" 
					method="fnGeneraCuentaFinanciera" 
					returnvariable="LvarError">
					<cfinvokeargument name="Lprm_CFformato" 		value="#trim(LvarCFformato)#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
					<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
					</cfinvoke>
						<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
							<cfset mensaje="ERROR">
									<cfquery name="borraDetalle" datasource="#session.dsn#">
										delete from GEanticipoDet where GEADid=#LvarTESSADid1#
									</cfquery>			
								<cfthrow message="#LvarError#">									
						</cfif>
					<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.CFcuenta>
						<cfquery datasource="#session.DSN#">
								update GEanticipoDet 
								set CFcuenta = #LvarCFcuenta#
								where GEADid = #GEADid#
						</cfquery>
			</cfloop>
				
	<cfelse><!---si es por plan de compras arma la cuenta de este otro modo--->			
	<!---CREA CUENTA FINANCIERA para plan de compras--->		
		<!---Mascara para la cuenta financiera--->	
				
		<!---<cfquery name="rsCFormato" datasource="#session.DSN#">
			select a.CFformato
			from PCGcuentas a							
			where a.PCGcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPCGDidPlanCompras.PCGcuenta#">
			 and a.Ecodigo = #session.ecodigo#
		</cfquery>								
		<cfset fecha = #dateFormat(now(),"yyyy-mm-dd")#>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="rsCta">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>
			<cfinvokeargument name="Lprm_CFformato" value="#rsCFormato.CFformato#"/>
			<cfinvokeargument name="Lprm_fecha" 	value="#fecha#"/>
		</cfinvoke>
		<cfif NOT listfind('OLD,NEW', rsCta)>
			<cfthrow message="#rsCta#">
		</cfif>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnObtieneCFcuenta" returnvariable="rsCta">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>
			<cfinvokeargument name="Lprm_CFformato" value="#rsCFormato.CFformato#"/>
			<cfinvokeargument name="Lprm_fecha" 	value="#fecha#"/>
		</cfinvoke>
		<cfset LvarCFcuenta = rsCta.CFcuenta>
		<cfquery datasource="#session.DSN#">
				update GEanticipoDet 
				set CFcuenta = #LvarCFcuenta#
				where GEADid = #GEADid#
		</cfquery>--->
	</cfif>	<!---termina de armar las cuentas--->
</cffunction>

<!---FUNCION PARA RECALCULAR LOS VIATICOS Q APLICAN PARA TODOS--->
<cffunction name="fnRecalcularAplicanTodos" output="false" access="private">
<cfargument type="numeric" name="GELid">

<!---para ver si es la primera vez q se hace--->
<cfquery datasource="#session.dsn#" name="rsRegistros"> 
	select count(1) as registros 
	from GEanticipoDet 
	where GEPVid not in (select GEPVid from GEPlantillaViaticos
						where GEPVaplicaTodos ='1'
						and Ecodigo=#session.Ecodigo#
						)
	and GEAid=#GEAid#
</cfquery>

<cfif #rsRegistros.registros# neq 0> 

	<!---se eliminan los que aplican para todos ya que se van a recalcular--->
	<cfquery datasource="#session.dsn#"> 
		delete from GEanticipoDet 
			where GEPVid in (select GEPVid from GEPlantillaViaticos
							where GEPVaplicaTodos ='1'
							and Ecodigo=#session.Ecodigo#
							)
			and GEAid=#GEAid#				
	</cfquery>
	
	<cfset aplicaTodos=1>
	<cfset p1=0>
	<cfset p2=0>
	 <!---loop para calcular las plantillas que aplican para todos--->
	<cfloop condition="len(trim(#p1#))" >
		<cfset monto = 0>
		
		<!---trae los ids de las plantillas que no aplican para todos--->
		<cfquery datasource="#session.dsn#" name="NoAplicaTodos"> 
			select g.GEADid from GEanticipoDet g 
				where GEPVid in (select GEPVid from GEPlantillaViaticos
								where GEPVaplicaTodos ='0'
								and Ecodigo=#session.Ecodigo#
								)
				and GEAid=#form.GEAid#
				order by g.GEADfechaini desc
		</cfquery>
		<!---se seleccionan fechas y horas minimas y maximas para hacer el calculos de los viaticos que aplican para todos --->
		<cfquery name="rsMinReg" datasource="#session.dsn#">
			select 
				GEADfechaini,
				min  (GEADhoraini) as hora
				from GEanticipoDet
				where GEADfechaini= (select 
									 min  (GEADfechaini)
									from GEanticipoDet
									where GEAid=#GEAid#
									)
				and GEAid=#GEAid# 					
			group by GEADfechaini
		</cfquery>
		
		<cfquery name="rsMaxReg" datasource="#session.dsn#">
			select 
				GEADfechafin,
				max  (GEADhorafin) as hora
				from GEanticipoDet
				where GEADfechafin= (select 
									 max  (GEADfechafin)
									from GEanticipoDet
									where GEAid=#GEAid#
									)
				and GEAid=#GEAid#					
			group by GEADfechafin
		</cfquery>
		
		<cfset fecha1DateTime=#rsMinReg.GEADfechaini#>
		<cfset fecha2DateTime=#rsMaxReg.GEADfechafin#>
		<cfset horaini=#rsMinReg.hora#>
		<cfset horafin=#rsMaxReg.hora#>
		
		<cfquery name="rsPlantilla1" datasource="#session.dsn#">
			select  min(GEPVid ) as p1
				from GEPlantillaViaticos
				where Ecodigo =#session.Ecodigo#
				   and  GEPVaplicaTodos = '#aplicaTodos#'
				   and GEPVtipoviatico = '#tipo#'
				   and '#fecha1DateTime#' 
				   between GEPVfechaini and GEPVfechafin
				   and GEPVid > #p1#
		</cfquery>
		
		<cfif not len(trim(#p2#))>
			<cfset p2=#ultimoP2#>
		</cfif>
		
		<cfquery name="rsPlantilla2" datasource="#session.dsn#">
			select  min(GEPVid ) as p2
				from GEPlantillaViaticos
				where Ecodigo =#session.Ecodigo#
				 and  GEPVaplicaTodos = '#aplicaTodos#'
				 and GEPVtipoviatico = '#tipo#'
				 and '#fecha2DateTime#' 
				 between GEPVfechaini and GEPVfechafin
				 and GEPVid > #p2#
		</cfquery>
		
		<cfset p1=#rsPlantilla1.p1#>
		<cfif not len(trim(#rsPlantilla2.p2#))>
			<cfset ultimoP2=#p2#>
		</cfif>
		<cfset p2= #rsPlantilla2.p2#>	
		
		<cfloop query="NoAplicaTodos">
			<cfquery name="rsMinReg" datasource="#session.dsn#">
				select 
					GEADfechaini,
					GEADhoraini as hora
					from GEanticipoDet
					where GEADid=#GEADid#
					and GEAid=#GEAid# 					
			</cfquery>
			
			<cfquery name="rsMaxReg" datasource="#session.dsn#">
				select 
					GEADfechafin,
					GEADhorafin as hora
					from GEanticipoDet
					where GEADid=#GEADid#
					and GEAid=#GEAid#					
			</cfquery>
			<!---se vuelven a crear estas variables para que vayan con las fechas de cada plantilla que no aplica a todos--->	
			<cfset fecha1DateTime=#rsMinReg.GEADfechaini#>
			<cfset fecha2DateTime=#rsMaxReg.GEADfechafin#>
			<cfset horaini=#rsMinReg.hora#>
			<cfset horafin=#rsMaxReg.hora#>	
			
			<cfif len(trim(#p1#)) >
				<cfif p1 eq p2 or not len(trim(#p2#)) >
				
					<!---se hace el calculo del monto para una sola plantilla con fechas y horas originales'--->
					<cfquery name="rsPlantillaUnica" datasource="#session.dsn#">
						select	GEPVhoraini as GEPVhoraini, 
								GEPVhorafin as GEPVhorafin,
								GEPVfechafin
								from GEPlantillaViaticos
								where Ecodigo =#session.Ecodigo#
								and GEPVid = #p1#
					</cfquery>
					<cfset GEPVhoraini="#rsPlantillaUnica.GEPVhoraini#">
					<cfset GEPVhorafin="#rsPlantillaUnica.GEPVhorafin#">
					
					<cfquery name="rsDiferenciaFechaFinal" datasource="#session.dsn#">
						select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha2DateTime#')#, #LSParseDateTime('#rsPlantillaUnica.GEPVfechafin#')#"> as diasDiferenciaFechaFinal
						from dual
					</cfquery>
					<cfif #rsDiferenciaFechaFinal.diasDiferenciaFechaFinal# gte 0>
					
						<cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
							select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1DateTime#')#, #LSParseDateTime('#fecha2DateTime#')#"> as diasDiferencia
							from dual
						</cfquery>
						<cfset diasDif= #rsDiferenciaDias.diasDiferencia#>
						<cfset fechaGuardar1=#fecha1DateTime#>
						<cfset fechaGuardar2=#fecha2DateTime#>
					<cfelse>
						<cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
							select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1DateTime#')#, #LSParseDateTime('#rsPlantillaUnica.GEPVfechafin#')#"> as diasDiferencia
							from dual
						</cfquery>
						<cfset diasDif= #rsDiferenciaDias.diasDiferencia#+1>
						<cfset fechaGuardar1=#fecha1DateTime#>
						<cfset fechaGuardar2=#rsPlantillaUnica.GEPVfechafin#>
					</cfif>
					
					<cfif #GEPVhoraini# neq 0>
						<cfset	dias = diasDif-1>
						<cfif #diasDif# eq 0>
							<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo = #session.Ecodigo#
										and GEPVid = #p1#
										 and GEPVhoraini <= #horafin#
										 and GEPVhorafin >= #horaini#
							</cfquery>
							<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
								<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
							</cfif>
						<cfelse>
							
							<cfquery name="rsHoraInicio" datasource="#session.dsn#">
								 select	 GEPVmonto
										 from GEPlantillaViaticos
										 where Ecodigo =#session.Ecodigo#
										 and GEPVid = #p1#
										 and GEPVhorafin >= #horaini#
							</cfquery>
							<cfif len(trim(#rsHoraInicio.GEPVmonto#))>
								<cfset  monto=#rsHoraInicio.GEPVmonto#+monto>
							</cfif>
							
							<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo =#session.Ecodigo#
										and GEPVid = #p1#
										 and GEPVhoraini <= #horafin#
							</cfquery>
							<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
								<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
							</cfif> 
						</cfif>	
						
						<cfif dias gte 0>
							<cfquery name="rsMontoDias" datasource="#session.dsn#">	
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo =#session.Ecodigo#
										and GEPVid = #p1#
							</cfquery>
							<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>	
						</cfif>
					<cfelse> <!---si la hora eq 0--->
						<cfset	dias = diasDif>	
						<cfquery name="rsMontoDias" datasource="#session.dsn#">	
							select  GEPVmonto  
									from GEPlantillaViaticos
									where Ecodigo =#session.Ecodigo#
									and GEPVid = #p1#
						</cfquery>
						<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>
					</cfif>	
					
					<cfset plantilla=#p1#> 
						
				<cfelse> <!---si p1 diferente de p2--->
					<!---se hace el calculo del monto para  plantilla p1 con fecha y hora inicio originales y fecha fin  = GEPVfecha fin  y hora fin = x1440'--->
					<cfquery name="rsFechaHoraFinM" datasource="#session.dsn#"> 
						select GEPVhoraini, 
								GEPVhorafin, 
								GEPVfechafin
							from GEPlantillaViaticos
							where Ecodigo =#session.Ecodigo#
							and GEPVid = #p1#
					</cfquery>
					<cfset GEPVhoraini="#rsFechaHoraFinM.GEPVhoraini#">
					<cfset GEPVhorafin="#rsFechaHoraFinM.GEPVhorafin#">
					<cfset horafinm=1440>
					<cfset fecha2m="#rsFechaHoraFinM.GEPVfechafin#">
					
					<!---se saca los dias de dif con respecto a la fecha2m modificada, la cual me indica cuando termina el periodo de esa plantilla--->
					<cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
						select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1DateTime#')#, #LSParseDateTime('#fecha2m#')#"> as diasDiferencia
							from dual
					</cfquery>
					<cfset fechaGuardar1=#fecha1DateTime#>
					<cfset fechaGuardar2=#fecha2m#>
					
					<cfset diasDif= "#rsDiferenciaDias.diasDiferencia#">
						
					<cfif #GEPVhoraini# neq 0>
						<cfset	dias = diasDif-1>
						<cfif #diasDif# eq 0>
							<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo = #session.Ecodigo#
										and GEPVid = #p1#
										 and GEPVhoraini <= #horafin#
										 and GEPVhorafin >= #horaini#
							</cfquery>
							<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
								<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
							</cfif>
							
						<cfelse>
						
							<cfquery name="rsHoraInicio" datasource="#session.dsn#"> 
								 select GEPVmonto
										from GEPlantillaViaticos
										where Ecodigo =#session.Ecodigo#
										and GEPVid = #p1#
										and GEPVhorafin >= #horaini#
							</cfquery>
							<cfif len(trim(#rsHoraInicio.GEPVmonto#))>	
								<cfset  monto=#rsHoraInicio.GEPVmonto#+monto>
							</cfif>		
							<cfquery name="rsHoraFinal" datasource="#session.dsn#"> 			
								select 	 GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo =#session.Ecodigo#
										and GEPVid = #p1#
										 and GEPVhoraini <= #horafinm#
							</cfquery>
							<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
								<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>
							</cfif>	 
						</cfif>	
						<cfif dias gt 0>			 
							<cfquery name="rsMontoDias" datasource="#session.dsn#"> 	
									select GEPVmonto  
											from GEPlantillaViaticos
											where Ecodigo =#session.Ecodigo#
											and GEPVid = #p1#
							</cfquery>
							<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>	
						</cfif>	
						
					<cfelse><!---si la hora eq 0--->	
						<cfquery name="rsMontoDias" datasource="#session.dsn#">
								select  GEPVmonto  
										from GEPlantillaViaticos
										where Ecodigo =#session.Ecodigo#
										and GEPVid = #p1#
						</cfquery>
						<cfset  monto=dias*#rsMontoDias.GEPVmonto#+monto>					
					</cfif>			   
					
					<cfset plantilla=#p1#> 
								
			 		<!---    se hace el calculo del monto para la plantilla p2 con fecha y hora fin originales y fecha ini = GEPVfechain  y hora ini  = 1'--->
					<cfif  len(trim(#p2#))>
						<cfquery name="rsFechaHoraIniM" datasource="#session.dsn#">
							select GEPVhoraini, 
									GEPVhorafin, 
									GEPVfechaini
								from GEPlantillaViaticos
								where Ecodigo =#session.Ecodigo#
								and  GEPVid = #p2#
						</cfquery>
						<cfset GEPVhoraini="#rsFechaHoraIniM.GEPVhoraini#">
						<cfset GEPVhorafin="#rsFechaHoraIniM.GEPVhorafin#">
						<cfset fecha1m="#rsFechaHoraIniM.GEPVfechaini#">	
						<cfset horainim=1>	
						
						<!---se saca los dias de dif con respecto a la fecha1m modificada, la cual me indica cuando empieza el periodo de esa plantilla--->
						<cfquery name="rsDiferenciaDias" datasource="#session.dsn#">
							select <cf_dbfunction name="datediff" args="#LSParseDateTime('#fecha1m#')#, #LSParseDateTime('#fecha2DateTime#')#"> as diasDiferencia
								from dual
						</cfquery>
						<cfset fechaGuardar1=#fecha1m#>
						<cfset fechaGuardar2=#fecha2DateTime#>
						<cfset diasDif= "#rsDiferenciaDias.diasDiferencia#">
						
						<cfif #GEPVhoraini# neq 0>
							<cfset	dias = diasDif-1>
							
							<cfif #diasDif# eq 0>
								<cfquery name="rsHoraFinal" datasource="#session.dsn#">	
									select  GEPVmonto  
											from GEPlantillaViaticos
											where Ecodigo = #session.Ecodigo#
											and GEPVid = #p1#
											 and GEPVhoraini <= #horafin#
											 and GEPVhorafin >= #horaini#
								</cfquery>
								<cfif len(trim(#rsHoraFinal.GEPVmonto#))>
									<cfset  monto=#rsHoraFinal.GEPVmonto#+monto>	
								</cfif>
							<cfelse>
								<cfquery name="rsHoraInicioP2" datasource="#session.dsn#">
									 select  GEPVmonto
											 from GEPlantillaViaticos
											 where Ecodigo =#session.Ecodigo#
											 and GEPVid = #p2#
											 and GEPVhorafin >= #horainim#
								</cfquery>
								<cfif len(trim(#rsHoraInicioP2.GEPVmonto#))>
									<cfset  monto=#rsHoraInicioP2.GEPVmonto#+monto>	
								</cfif>
								<cfquery name="rsHoraFinalP2" datasource="#session.dsn#">			
									select   GEPVmonto  
											from GEPlantillaViaticos
											 where Ecodigo =#session.Ecodigo#
											and GEPVid = #p2#
											 and GEPVhoraini <= #horafin#
								</cfquery>
								<cfif len(trim(#rsHoraFinalP2.GEPVmonto#))>
									<cfset  monto=#rsHoraFinalP2.GEPVmonto#+monto>	
								</cfif> 
							</cfif>	
							<cfif dias gt 0>
								<cfquery name="rsMontoDiasP2" datasource="#session.dsn#">			 
									select  GEPVmonto  
											from GEPlantillaViaticos
											where Ecodigo =#session.Ecodigo#
											and GEPVid = #p2#
								</cfquery>
								<cfset  monto=dias*#rsMontoDiasP2.GEPVmonto#+monto>		
							</cfif>		   
						<cfelse>
							<cfquery name="rsMontoDiasP2" datasource="#session.dsn#">
								select GEPVmonto 
										from GEPlantillaViaticos
										where Ecodigo =#session.Ecodigo#
										and GEPVid = #p2#
							</cfquery>
							<cfset  monto=dias*#rsMontoDiasP2.GEPVmonto#+monto>			   
						
						</cfif>
					</cfif><!---si no viene vacio p2--->
					<cfset plantilla=#p2#> 
									
				</cfif>	 <!---p1 eq p2 --->
			</cfif> <!---p1 neq null--->
		</cfloop> <!---loop de no aplica a todos--->
		
		
		<!---aqui es donde inserta cada plantilla que aplica para todos eje desayuno almuerzo cena y si pone dentro de la condicion porque estaba ingresando 2 veces la cena--->
		<cfif #p1# neq 0 and len(trim(#p1#))>
			<!---se saca la ultima fecha y hora--->
			<cfquery name="rsMaxReg" datasource="#session.dsn#">
				select 
					GEADfechafin,
					GEADhorafin as hora
					from GEanticipoDet
					where GEADid=#NoAplicaTodos.GEADid#
					and GEAid=#GEAid#					
			</cfquery>
			<!---se vuelven a crear estas variables para que inserte con la  fecha y hora Fin maxima--->	
			<cfset GEPVhorafin=#rsMaxReg.hora#>
			<cfset fechaGuardar2=#rsMaxReg.GEADfechafin#>
			<cfset fnInsertar()>
		</cfif>	
		 
	</cfloop> <!---mientras p1 neq null--->
</cfif> <!---si hay almenos un registro---> 
 
</cffunction>