<!---<cfdump var="#url#"><cf_dump var="#form#">--->
<cfset LvarSAporEmpleadoCFM = "LiquidacionAnticiposViaticos_form.cfm">
<cfif isdefined ('form.modo')  >
	<cfquery name="rsTipo" datasource="#session.dsn#">
		select GEAtipoviatico
			from GEliquidacion 
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> 
	</cfquery>
	<cfset tipo=#rsTipo.GEAtipoviatico#>
	
	<cfif form.modo EQ 'ALTA' >
		<cfset GEAid=#form.GEAid#>
		<cfset calcular=true>
		<cfset GECVid=#form.GECVid#>
		<cfset fecha1DateTime=#form.GEADfechaini#>
		<cfset fecha2DateTime=#form.GEADfechafin#>
		<cfif  len(trim(#form.GEADhoraini#))>
			<cfset horaini=#form.GEADhoraini#>
		<cfelse>
			<cfset horaini=0>
		</cfif>	
		<cfif  len(trim(#form.GEADhorafin#))>
			<cfset horafin=#form.GEADhorafin#>
		<cfelse>
			<cfset horafin=0>
		</cfif>	
		<cfset aplicaTodos=0>
				
	<cfelseif form.modo EQ 'BAJA' >
		<cfset LvarId= #form.linea#>	
		<cfset arrPid = ListToArray(#form.GEPVID#)/>
		<cfset arrGELVid = ListToArray(#form.GELVid#)/>
		<cfset arrGECid = ListToArray(#form.GECid#)/>
		
		<cfquery datasource="#session.dsn#">
			delete from GEliquidacionViaticos
				where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> 
				<cfif #arrPid[LvarId]# neq 0>
					and GEPVid=#arrPid[LvarId]#
				</cfif> 
				<cfif #form.GEAid# neq -1> <!---Si no es liquidacion directa---> 
					and GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
				</cfif>
				and GECid=#arrGECid[LvarId]#
				and GELVid=#arrGELVid[LvarId]#
		</cfquery>	
		
		<cfquery name="rsViatico" datasource="#session.dsn#">
			select GEPVaplicaTodos from GEPlantillaViaticos
				where GEPVid=#arrPid[LvarId]#
		</cfquery>
		<cfif #rsViatico.GEPVaplicaTodos# eq 0>
			<cfquery datasource="#session.dsn#"> 
				delete from GEliquidacionViaticos 
					where GEPVid in (select GEPVid from GEPlantillaViaticos
									where GEPVaplicaTodos ='1'
									and Ecodigo=#session.Ecodigo#
									)
					and GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> 
			</cfquery>
			
			<cfquery name="rsCant" datasource="#session.dsn#">
				select GELid from GEliquidacionViaticos
				where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> 
			</cfquery>	
		
			<cfif rsCant.recordCount gt 0>
				<cfset fnRecalcularAplicanTodos(#form.GELid#)>
			</cfif>	
		</cfif>	
		<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GEAid=#form.GEAid#&GELid=#form.GELid#&tipo=#tipo#&calcular=false&LvarSAporEmpleadoCFM=#LvarSAporEmpleadoCFM#">
	</cfif>
	<cfif isdefined('form.CAMBIO')>
          <cfset arrGELVid = ListToArray(#form.GELVid#)/>		
          <cfset arrGEPVID = ListToArray(#form.GEPVID#)/>
		  <cfset arrmontoReal = ListToArray(#form.montoReal#)/>
		  <cfset arrGECid = ListToArray(#form.GECid#)/>
		  <cfset arrGELVmonto = ListToArray(#form.GELVmonto#)/>
		  <cfloop index = "x" from = "1" to = "#arrayLen(arrGEPVID)#">
			 	<cfquery name="rsUpdate" datasource="#session.dsn#">
					update GEliquidacionViaticos 
					set GEPVmontoGastMV = #arrmontoReal[x]# ,
					GELVmonto=#arrGELVmonto[x]#
					where  GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> 
						and GELVid=#arrGELVid[x]#
					<cfif #arrGEPVID[x]# neq 0>
						and GEPVid = #arrGEPVID[x]#	
					</cfif>
					<cfif #form.GEAid# neq -1> <!---Si no es liquidacion directa---> 
						and GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
					</cfif>	 	
					and GECid=#arrGECid[x]#  
				 </cfquery>		 
		  </cfloop>		
		  <cflocation url="LiquidacionAnticiposViaticos_form.cfm?GEAid=#form.GEAid#&GELid=#form.GELid#&tipo=#tipo#&calcular=false&LvarSAporEmpleadoCFM=#LvarSAporEmpleadoCFM#">
	</cfif>
	<cfif isdefined('form.baja')>
		<cfquery name="elimina" datasource="#session.dsn#">
			delete from GEliquidacionAnts  
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
			<cfif #form.GEAid# neq -1> <!---Si no es liquidacion directa--->  	
				and GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#"> 
			</cfif>
		</cfquery>
		<cfquery name="elimina2" datasource="#session.dsn#">
			delete from GEliquidacionViaticos 
			where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#"> 	
			<cfif #form.GEAid# neq -1> <!---Si no es liquidacion directa---> 
				and GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#"> 
			</cfif>	
		</cfquery>

		<cfinvoke 	component="sif.tesoreria.Componentes.TESgastosEmpleado" 	
					method="sbTotalesLiquidacion" 
					GELid = "#form.GELid#" 		
					tipo  = "Gastos"
		/>
		
		<cflocation url="LiquidacionAnticipos.cfm?GELid=#form.GELid#">
	</cfif>
	<cfif isdefined('form.REGRESAR')>
		<cflocation url="LiquidacionAnticipos.cfm?GELid=#form.GELid#">
	</cfif>
	
<cfelse>

	<cfquery name="rsTipo" datasource="#session.dsn#">
		select GEAtipoviatico
			from GEanticipo 
			where GEAid=#GEAid#
	</cfquery>
	<cfset tipo=#rsTipo.GEAtipoviatico#>
	<cfquery name="rsRecalcular" datasource="#session.dsn#">
		select GEPVid from GEanticipoDet
		where GEAid=#url.GEAid#
		
	</cfquery>
	<cfif  len(trim(#rsRecalcular.GEPVid#))>
		<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GEAid=#url.GEAid#&GELid=#form.GELid#&tipo=#tipo#&calcular=false&LvarSAporEmpleadoCFM=#url.LvarSAporEmpleadoCFM#">
	</cfif>

	<cfset GEAid="#url.GEAid#">
	<cfset calcular="#url.calcular#">
	<cfquery name="rsDatos" datasource="#session.dsn#">
		select GEAdesde, GEAhasta, GEAhoraini, GEAhorafin
			from GEanticipo 
			where GEAid=#GEAid#
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
				where Ecodigo =#session.Ecodigo#
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
				where Ecodigo =#session.Ecodigo#
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
							where Ecodigo =#session.Ecodigo#
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
				<cfset fnInsertar()>
					
			<cfelse> <!---si p1 diferente de p2--->
			 <!---se hace el calculo del monto para  plantilla p1 con fecha y hora inicio originales y fecha fin  = GEPVfecha fin  y hora fin = x1440'--->
				<cfset monto=0>
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
				<cfset fnInsertar()>
							
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
				<cfset fnInsertar()>	
								
			</cfif>	 <!---p1 eq p2 --->
		</cfif> <!---p1 neq null--->
	</cfloop>
	<cfset fnRecalcularAplicanTodos(#form.GELid#)>
	
	<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GEAid=#GEAid#&GELid=#form.GELid#&tipo=#tipo#&calcular=false&LvarSAporEmpleadoCFM=#LvarSAporEmpleadoCFM#">
</cfif>

<cffunction name="fnInsertar" access="private" output="false" >
	<cfquery name="rsConcepto" datasource="#session.dsn#">
		select GECid
			from GEPlantillaViaticos
			where GEPVid=#plantilla#
	</cfquery>
	<!---Trae el tipo de cambio de --->	
	<cfquery name="rsTC" datasource="#session.dsn#">
		select coalesce(a.GEADtipocambio,-1) as venta, a.McodigoPlantilla as Mcodigoanti, g.Mcodigo as McodigoPlantilla
			from  GEanticipoDet a 
			inner join 	GEPlantillaViaticos g
				on a.GEPVid=g.GEPVid
				and a.McodigoPlantilla=g.Mcodigo
			where a.GEAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">
	</cfquery>
	
	<cfif rsTC.venta eq -1 or len(trim(#rsTC.venta#)) eq 0>
		<cfquery name="rsTC" datasource="#session.dsn#">
			select coalesce(TCcompra,1) as compra, coalesce(TCventa,1) as venta, g.Mcodigo as McodigoPlantilla
				from GEPlantillaViaticos g
				left outer join Htipocambio htc
						on htc.Mcodigo = g.Mcodigo
						and #now()# between htc.Hfecha and htc.Hfechah  		
				where g.GEPVid = #plantilla#
		</cfquery>
	</cfif>
	
	<cftransaction>
		<cfquery datasource="#session.dsn#" name="insertadetalle">
			insert into GEliquidacionViaticos (
				GELid,
				GEAid,
				GEPVid,
				GECid,
				GELVmontoOri,
				GEPVmontoGastMV,
				GELVtipoCambio,
				GELVmonto,
				GELVfechaIni,
				GELVfechaFin,
				GELVhoraIni,
				GELVhorafin,
				BMUsucodigo
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">,
				<cfif #form.GEAid# eq -1>
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GEAid#">,
				</cfif>	
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#plantilla#">,
				#rsConcepto.GECid#,
				#monto#,
				#monto#,
				#rsTC.venta#,
				#rsTC.venta#*#monto#,
				<cfif isdefined ('form.modo')>
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fechaGuardar1)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fechaGuardar2)#">,
				 <cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#(fechaGuardar1)#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#(fechaGuardar2)#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#horaini#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#horafin#">,			
				#session.Usucodigo#
				)
				<cf_dbidentity1 datasource="#session.dsn#" name="insertadetalle">
		</cfquery>
		<cf_dbidentity2 datasource="#session.dsn#" name="insertadetalle" returnvariable="LvarTESSADid1">
		<cfset #GELVid#=#LvarTESSADid1#>						
	</cftransaction>
</cffunction>

<!---FUNCION PARA RECALCULAR LOS VIATICOS Q APLICAN PARA TODOS--->
<cffunction name="fnRecalcularAplicanTodos" output="false" access="private">
<cfargument type="numeric" name="GELid">


<!---se eliminan los que aplican para todos ya que se van a recalcular--->
<cfquery datasource="#session.dsn#"> 
	delete from GEliquidacionViaticos 
		where GEPVid in (select GEPVid from GEPlantillaViaticos
						where GEPVaplicaTodos ='1'
						and Ecodigo=#session.Ecodigo#
						)
		and GELid=#GELid#				
</cfquery>



 <cfset aplicaTodos=1>
 <cfset p1=0>
 <cfset p2=0>

 
 <!---loop para calcular las plantillas que aplican para todos--->
<cfloop condition="len(trim(#p1#))" >
		<cfset monto = 0>
		
		<!---trae los ids de las plantillas que no aplican para todos--->
		<cfquery datasource="#session.dsn#" name="NoAplicaTodos"> 
			select GELVid from GEliquidacionViaticos  
				where GEPVid in (select GEPVid from GEPlantillaViaticos
								where GEPVaplicaTodos ='0'
								and Ecodigo=#session.Ecodigo#
								)
				and GELid=#GELid#
				order by GELVfechaIni desc
		</cfquery>
	
		<!---se seleccionan fechas y horas minimas y maximas para hacer el calculos de los viaticos que aplican para todos --->
		<cfquery name="rsMinReg" datasource="#session.dsn#">
			select 
				GELVfechaIni,
				min  (GELVhoraIni) as hora
				from GEliquidacionViaticos
				where GELVfechaIni= (select 
									 min  (GELVfechaIni)
									from GEliquidacionViaticos
									where GELid=#GELid#
									)
				and GELid=#GELid# 					
			group by GELVfechaIni
		</cfquery>
		
		<cfquery name="rsMaxReg" datasource="#session.dsn#">
			select 
				GELVfechaFin,
				max  (GELVhorafin) as hora
				from GEliquidacionViaticos
				where GELVfechaFin= (select 
									 max  (GELVfechaFin) 
									from GEliquidacionViaticos
									where GELid=#GELid#
									)
				and GELid=#GELid#					
			group by GELVfechaFin
		</cfquery>
			
		 <cfset fecha1DateTime=#rsMinReg.GELVfechaIni#>
		 <cfset fecha2DateTime=#rsMaxReg.GELVfechaFin#>
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
					GELVfechaIni,
					GELVhoraIni as hora
					from GEliquidacionViaticos
					where GELid=#GELid#					
					and GELVid=#GELVid# 					
			</cfquery>
			
			<cfquery name="rsMaxReg" datasource="#session.dsn#">
				select 
					GELVfechaFin,
					GELVhorafin as hora
					from GEliquidacionViaticos
					where GELid=#GELid#					
					and GELVid=#GELVid#					
			</cfquery>
			<!---se vuelven a crear estas variables para que vayan con las fechas de cada plantilla que no aplica a todos--->	
			<cfset fecha1DateTime=#rsMinReg.GELVfechaIni#>
			<cfset fecha2DateTime=#rsMaxReg.GELVfechaFin#>
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
					<!---<cfset	monto = 0>--->
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
					<!---<cfset fnInsertar()>--->
						
				<cfelse> <!---si p1 diferente de p2--->
				 <!---se hace el calculo del monto para  plantilla p1 con fecha y hora inicio originales y fecha fin  = GEPVfecha fin  y hora fin = x1440'--->
					<!---<cfset monto=0>--->
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
					<!---<cfset fnInsertar()>--->
								
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
						<!---<cfset  monto=0>--->
						
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
					<!---<cfset fnInsertar()>--->	
									
				</cfif>	 <!---p1 eq p2 --->
			</cfif> <!---p1 neq null--->
		</cfloop><!---aplica a todos--->	
		
		<!---aqui es donde inserta cada plantilla que aplica para todos eje desayuno almuerzo cena y si pone dentro de la condicion porque estaba ingresando 2 veces la cena--->
		<cfif #p1# neq 0 and len(trim(#p1#))>
			<!---se saca la ultima fecha y hora--->
			<cfquery name="rsMaxReg" datasource="#session.dsn#">
				select 
					GELVfechaFin,
					GELVhorafin as hora
					from GEliquidacionViaticos
					where GELid=#GELid#					
					and GELVid=#NoAplicaTodos.GELVid#
			</cfquery>
			<!---se vuelven a crear estas variables para que inserte con la  fecha y hora Fin maxima--->	
			<cfset GEPVhorafin=#rsMaxReg.hora#>
			<cfset fechaGuardar2=#rsMaxReg.GELVfechaFin#>
			<cfset fnInsertar()>
		</cfif>
		
		
	</cfloop>
 
 
</cffunction>

