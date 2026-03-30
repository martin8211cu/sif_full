<cfcomponent>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<!---                                         Comprobar existencia de configuracion                                                   --->
<cffunction name="verificacion" access="public">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count (1) as cantidad from CCHconfig 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsSQL.cantidad eq 0>
		<cfthrow message="No se han configurado los parametros de caja chica">
	</cfif>
</cffunction>

<!---                                                  Importes                                                                        --->
<cffunction name="importes" access="public" returntype="boolean">
	<cfargument name="CCHid" 			 		 type="numeric" 	required="yes"> 
	<cfargument name="CCHTid" 			 		 type="numeric" 	required="yes"> 
	<cfargument name="CCHImontoasignado"  		 type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIanticipos"       		 type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIgastos"    	  		 type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIreintegroEnProceso"    type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIdeposito"              type="numeric" 	required="no" default="0.00"> 
	<cfquery name="inImportes" datasource="#session.dsn#">
		insert into CCHImportes 
			(Ecodigo,
			CCHid,
			CCHTid,
			CCHImontoasignado,
			CCHIanticipos,
			CCHIgastos,
			CCHIreintegroEnProceso)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHImontoasignado#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIanticipos#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIgastos#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIreintegroEnProceso#">
		)
	</cfquery>
	<cfset varReturn=true>	
	<cfreturn #varReturn#>
</cffunction>

<!---                                              Actualizar Importes                                                                      --->
<cffunction name="UP_importes" access="public">
	<cfargument name="CCHid" 			 		 type="numeric" 	required="yes"> 
	<cfargument name="CCHTid" 			 		 type="numeric" 	required="yes"> 
	<cfargument name="CCHImontoasignado"  		 type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIanticipos"       		 type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIgastos"    	  		 type="numeric" 	required="no" default="0.00"> 
	<cfargument name="CCHIreintegroEnProceso"    type="numeric" 	required="no" default="0.00">

	<cfquery name="rsSQLI" datasource="#session.dsn#">
		select CCHImontoasignado,CCHIanticipos,CCHIgastos,CCHIreintegroEnProceso from CCHImportes where CCHid=#arguments.CCHid#
	</cfquery>
	
	<cfif rsSQLI.recordcount gt 0>
		<cfset asignado=#rsSQLI.CCHImontoasignado#>
		<cfset anticipos=#rsSQLI.CCHIanticipos#>
		<cfset gastos=#rsSQLI.CCHIgastos#>
		<cfset reintegro=#rsSQLI.CCHIreintegroEnProceso#>
	<cfelse>
		<cfset asignado=0>
		<cfset anticipos=0>
		<cfset gastos=0>
		<cfset reintegro=0>
	</cfif>
<!---
	<cfif rsSQLI.CCHImontoasignado eq 0.00 and rsSQLI.CCHIanticipos eq 0.00 and rsSQLI.CCHIgastos eq 0.00 and arguments.CCHIreintegroEnProceso eq 0.00>
		<cfquery name="upImportes" datasource="#session.dsn#">
			update CCHImportes set
				CCHImontoasignado=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHImontoasignado#">,
				CCHIanticipos=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIanticipos#">,
				CCHIgastos=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIgastos#">,
				CCHIreintegroEnProceso=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIreintegroEnProceso#">
			where CCHid=#arguments.CCHid#
		</cfquery>
	</cfif>--->
	
	<cfif arguments.CCHImontoasignado neq 0>
		<cfquery name="upImportes" datasource="#session.dsn#">
			update CCHImportes set
				CCHImontoasignado=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHImontoasignado#">
			where CCHid=#arguments.CCHid#
		</cfquery>
	</cfif>
<!---	<cfif arguments.CCHIanticipos gt 0>
		<cfquery name="upImportes" datasource="#session.dsn#">
			update CCHImportes set
				CCHIanticipos=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIanticipos#">
			where CCHid=#arguments.CCHid#
		</cfquery>
	</cfif>
	<cfif arguments.CCHIgastos gt 0>
		<cfquery name="upImportes" datasource="#session.dsn#">
			update CCHImportes set
				CCHIgastos=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.CCHIgastos#">
			where CCHid=#arguments.CCHid#
		</cfquery>
	</cfif>--->

	<cfset reintegroT= reintegro + Arguments.CCHIreintegroEnProceso>

	<cfif arguments.CCHIreintegroEnProceso neq 0>
		<cfquery name="upImportes" datasource="#session.dsn#">
			update CCHImportes set
				CCHIreintegroEnProceso=<cfqueryparam cfsqltype="cf_sql_money" value="#reintegroT#">
			where CCHid=#arguments.CCHid#
		</cfquery>
	</cfif>
</cffunction>


<!---                                              Creacion de Reintegro                                                                      --->
<cffunction name="CreaReintegro" access="public" returntype="boolean">
<cfargument name="CCHid" 				 type="numeric" 	required="yes">
<cfargument name="CCHTtipo"       		 type="string" 		required="yes" > 
<cfargument name="ImporteA"    	  		 type="numeric" 	required="no" >
<cfargument name="ImporteL"    	  		 type="numeric" 	required="no" >  
<cfargument name="Id_anticipo"	 		 type="numeric" 	required="no" default="-1"> 
<cfargument name="Id_liquidacion"  		 type="numeric" 	required="no"  default="-1">
<cfargument name="ImporteD"    	  		 type="numeric" 	required="no"  default="0">   


	<cfquery name="PorMax" datasource="#session.dsn#">
		select CCHmax,CCHmin from CCHica where CCHid= #arguments.CCHid#
	</cfquery>

	<cfquery name="rsSQLI" datasource="#session.dsn#">
		select CCHImontoasignado,CCHIanticipos,CCHIgastos,CCHIreintegroEnProceso,coalesce(CCHIdeposito,0) as CCHIdeposito from CCHImportes where CCHid=#arguments.CCHid#
	</cfquery>
		
	<cfset disponible= MDisponible(arguments.CCHid)>
	<cfset asignado=rsSQLI.CCHImontoasignado>
	<cfset anticipos=rsSQLI.CCHIanticipos>
	<cfset gastos=rsSQLI.CCHIgastos>
	<cfset reintegro=rsSQLI.CCHIreintegroEnProceso>
	<cfset deposito=rsSQLI.CCHIdeposito>
	
<!---Aprobacion liquidacion--->
<cfif arguments.Id_liquidacion gt 0>
	<cfif arguments.CCHTtipo eq 'GASTOS'>

		<cfset montoT= (ImporteL+ImporteD)-ImporteA>
		
		<cfquery name="rsBusMonto" datasource="#session.dsn#">
			select coalesce(sum(CCHTAmonto),0) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #arguments.CCHid#
		</cfquery>
		
		<cfquery name="Importe" datasource="#session.dsn#">
			select CCHImontoasignado from CCHImportes where CCHid= #arguments.CCHid#
	   </cfquery>
		
			
			<cfset total=rsBusMonto.disponible>
			<cfset porcentajeMin= replace(total,',','','ALL') *100/ replace(Importe.CCHImontoasignado,',','','ALL')>


			<cfquery name="rsCCHi" datasource="#session.dsn#">
				select c.CCHresponsable,s.DEemail,c.CCHcodigo,c.CCHdescripcion
				from CCHica c
				inner join DatosEmpleado s
				on s.DEid=c.CCHresponsable
				where CCHid=#arguments.CCHid#
			</cfquery>
		
			<cfquery name="rsReintegro" datasource="#session.dsn#">
				select CCHCreintegro from CCHconfig where Ecodigo=#session.Ecodigo#
			</cfquery>
				min<cfdump var="#porcentajeMin#">
					max<cfdump var="#PorMax.CCHmin#">
			<cfif porcentajeMin gt PorMax.CCHmin>
					<!---Aqui E-mail--->					
					<cfset email_subject = "Recordatorio de Reintegro Caja Chica:#rsCCHi.CCHcodigo#-#rsCCHi.CCHdescripcion#">
					<cfset email_from = "Administrador del Portal">
					<cfset email_to = '#rsCCHi.DEemail#'>
					<cfset email_cc = ''>
	
					<cfsavecontent variable="email_body">
						<html>
							<head></head>
							<body>
								<cfinclude template="/sif/tesoreria/GestionEmpleados/Reintegro-mail.cfm">
							</body>
						</html>
					</cfsavecontent>
	
					<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
					</cfquery>
			</cfif>
			
				<cfquery name="PorMin" datasource="#session.dsn#">
					select CCHmin from CCHica where CCHid= #arguments.CCHid#
				</cfquery>
				
				<cfquery name="Importe" datasource="#session.dsn#">
					select CCHImontoasignado from CCHImportes where CCHid= #arguments.CCHid#
				</cfquery>

			<cfquery name="rsAnti" datasource="#session.dsn#">
				select GEAid from GEliquidacionAnts where GELid=#arguments.Id_liquidacion#
			</cfquery>	

			<cfset totalA=anticipos-(arguments.ImporteA+arguments.ImporteD)>
			<cfset totalL=gastos+arguments.ImporteL>
			<cfset totalD=deposito-arguments.ImporteD>
			<cfset tot=disponible-arguments.ImporteL>
		<cfif montoT gte 0>
				<cfset t = disponible-montoT>

				<cfif disponible-montoT gt 0>	
					<cfif porcentajeMin lt 100>
							
						<cfset LvarReturn='true'>

							<cfif porcentajeMin gte PorMin.CCHmin>				
									<cfif rsReintegro.CCHCreintegro gt 0>
										<cfdump var="#LvarReturn#">
										<cfset LvarReturn='true'>
										<cfset ReintegroA(arguments.CCHid)>					
									</cfif>	
							</cfif>							
					<cfelse>
						<cfset LvarReturn='false'>
					</cfif>
				<cfelse>
					<cfset LvarReturn='false'>	
				</cfif>
		<cfelse>
			<cfset LvarReturn='false'>	
		</cfif>
	</cfif>	
</cfif>

<cfreturn #LvarReturn#>
</cffunction>


<!---                                              Movimientos Importes                                                                      --->
<cffunction name="ApruebaImporte" access="public" returntype="boolean">
<cfargument name="CCHid" 				 type="numeric" 	required="yes">
<cfargument name="CCHTtipo"       		 type="string" 		required="yes" > 
<cfargument name="ImporteA"    	  		 type="numeric" 	required="no" >
<cfargument name="ImporteL"    	  		 type="numeric" 	required="no" >  
<cfargument name="Id_anticipo"	 		 type="numeric" 	required="no" default="-1"> 
<cfargument name="Id_liquidacion"  		 type="numeric" 	required="no"  default="-1">
<cfargument name="ImporteD"    	  		 type="numeric" 	required="no"  default="0">   

	<cfquery name="rsSQLI" datasource="#session.dsn#">
		select CCHImontoasignado,CCHIanticipos,CCHIgastos,CCHIreintegroEnProceso,coalesce(CCHIdeposito,0) as CCHIdeposito from CCHImportes where CCHid=#arguments.CCHid#
	</cfquery>
		
	<cfset disponible= MDisponible(arguments.CCHid)>
	<cfset asignado=rsSQLI.CCHImontoasignado>
	<cfset anticipos=rsSQLI.CCHIanticipos>
	<cfset gastos=rsSQLI.CCHIgastos>
	<cfset reintegro=rsSQLI.CCHIreintegroEnProceso>
	<cfset deposito=rsSQLI.CCHIdeposito>
		
	<!---Aprobacion anticipos--->	
	<cfquery name="PorMax" datasource="#session.dsn#">
		select CCHmax,CCHmin from CCHica where CCHid= #arguments.CCHid#
	</cfquery>
	
	<cfquery name="Importe" datasource="#session.dsn#">
		select CCHImontoasignado from CCHImportes where CCHid= #arguments.CCHid#
	</cfquery>
	
	<cfset porcentaje= replace(arguments.ImporteA,',','','ALL') *100/ replace(disponible,',','','ALL')>	
	
	<cfif arguments.CCHTtipo eq 'ANTICIPO'>
		<cfif porcentaje lte PorMax.CCHmax>			
			<cfset total=anticipos+arguments.ImporteA>
			<cfset disponible= MDisponible(#arguments.CCHid#)>
			
			<cfif disponible-arguments.ImporteA gt 0>
				<cfquery name="upAnt" datasource="#session.dsn#">
					update CCHImportes set CCHIanticipos=#total# where CCHid=#arguments.CCHid#
				</cfquery>
				<cfset LvarReturn='true'>
			<cfelse>
				<cfset LvarReturn='false'>
			</cfif>
			<cfreturn #LvarReturn#>
		<cfelse>
			<cfthrow message="No se puede aprobar esta transaccion porque el monto solicitado sobrepasa el porcentaje máximo de solicitudes">
		</cfif>
	</cfif>

<!---Aprobacion liquidacion--->
<cfif arguments.Id_liquidacion gt 0>
	<cfif arguments.CCHTtipo eq 'GASTOS'>
		<cfset montoT= (ImporteL+ImporteD)-ImporteA>
		<cfdump var="#montoT#">
		<cfquery name="rsBusMonto" datasource="#session.dsn#">
			select coalesce(sum(CCHTAmonto),0) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #arguments.CCHid#
		</cfquery>
		
		<cfdump var="#rsBusMonto#">
		<cfif montoT gt 0>		
			<cfset total=rsBusMonto.disponible+montoT+ImporteL>
			<cfset porcentajeMin= replace(total,',','','ALL') *100/ replace(Importe.CCHImontoasignado,',','','ALL')>
		<cfelse>
			<cfset total=rsBusMonto.disponible+ImporteL>
			<cfset porcentajeMin= replace(total,',','','ALL') *100/ replace(Importe.CCHImontoasignado,',','','ALL')>
		</cfif>
%<cfdump var="#porcentajeMin#">
			<cfquery name="rsCCHi" datasource="#session.dsn#">
				select c.CCHresponsable,s.DEemail,c.CCHcodigo,c.CCHdescripcion
				from CCHica c
				inner join DatosEmpleado s
				on s.DEid=c.CCHresponsable
				where CCHid=#arguments.CCHid#
			</cfquery>
		
			<cfquery name="rsReintegro" datasource="#session.dsn#">
				select CCHCreintegro from CCHconfig where Ecodigo=#session.Ecodigo#
			</cfquery>			
			
			<cfquery name="PorMin" datasource="#session.dsn#">
				select CCHmin from CCHica where CCHid= #arguments.CCHid#
			</cfquery>
			
			<cfquery name="Importe" datasource="#session.dsn#">
				select CCHImontoasignado from CCHImportes where CCHid= #arguments.CCHid#
			</cfquery>

			<cfquery name="rsAnti" datasource="#session.dsn#">
				select GEAid from GEliquidacionAnts where GELid=#arguments.Id_liquidacion#
			</cfquery>	

			<cfset totalA=anticipos-(arguments.ImporteA)>
			<cfset totalL=gastos+arguments.ImporteL>
			<cfset totalD=deposito-arguments.ImporteD>
			<cfset tot=disponible-arguments.ImporteL>

		<cfif montoT gte 0>
				<cfset t = disponible-montoT>
				f<cfdump var="#t#"></br>
				<cfif disponible-montoT gt 0>
				<cfdump var="#porcentajeMin#"></br>
					<cfif porcentajeMin lte 100>	
					
						<cfquery name="upAnt" datasource="#session.dsn#">
							update CCHImportes set 
							CCHIanticipos=#totalA#,
							CCHIgastos	=#totalL#,
							CCHIdeposito=#totalD#
							where CCHid=#arguments.CCHid#
						</cfquery>					
						<cfset LvarReturn='true'>
														
					<cfelse>
						<cfset LvarReturn='false'>
					</cfif>
				<cfelse>
					<cfset LvarReturn='false'>	
				</cfif>
		<cfelse>
			<cfset LvarReturn='false'>	
		</cfif>
	</cfif>	
</cfif>
<cfreturn #LvarReturn#>
</cffunction>

<!---                                              REINTEGRO AUTOMATICO                                                                      --->
<cffunction name="ReintegroA" access="public">
<cfargument name="CCHid"           type="numeric"          required="yes">

	<cfquery name="rsCaja" datasource="#session.dsn#">
		select Mcodigo,CFcuenta,CCHresponsable,CFid from CCHica where CCHid= #arguments.CCHid#
	</cfquery>
	
	<cfset fecha = now()>
		<cfquery name="totRr" datasource="#session.dsn#">
		select * from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #arguments.CCHid# 
		and BMfecha <= #fecha#
	</cfquery>
	
	<cfquery name="totR" datasource="#session.dsn#">
		select coalesce(sum(CCHTAmonto),0) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #arguments.CCHid# 
		and BMfecha <= #fecha#
	</cfquery>
	<cfif totR.disponible gt 0>
		<cfset x=TranProceso (rsCaja.Mcodigo,rsCaja.CFcuenta,'Reintegro Automatico','EN PROCESO',totR.disponible,rsCaja.CCHresponsable,'REINTEGRO',arguments.CCHid)>
	
		<cfquery name="rsCod" datasource="#session.dsn#">
			select CCHcod from CCHTransaccionesProceso where CCHTid=#x#
		</cfquery>
		
		<cfset CambiaEstadoTP (x,'EN APROBACION CCH','REINTEGRO')>
		
		<cfset id = crearSP(8,rsCaja.CCHresponsable,now(),rsCaja.Mcodigo,totR.disponible,rsCaja.CFid,rsCaja.CFcuenta,'Reintegro Automatico',rsCod.CCHcod,x,x,'Reintegro Aut')>
		
		<cfset  CambiaEstadoTP (x,'EN APROBACION TES','REINTEGRO',id,'Solicitud Pago')>
	</cfif>
</cffunction>

<!---                                                             Funciones contables del reintegro                                                                                  
1)-reserva                                                    
2)+ gasto                                                     
3) contabilidad DB gastos                                     
4) contabilidad CR bancos                                 --->
                                                                                                                                                  
<cffunction name="sbReintegroContaPre" access="public">
<cfargument name="CCHid"     type="numeric"    required="yes">
<cfargument name="fecha"     type="date"       required="yes">
<cfargument name="TESOPid"   type="numeric"    required="yes">
<cfargument name="TESSPid"   type="numeric"    required="yes">
<cfargument name="LvarSigno" type="numeric"    required="no" >

<cfreturn>
<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" >
<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn,'no','yes')/>

<cfinclude template="../../Utiles/sifConcat.cfm">

		<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
		</cfquery>
	
		<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
		</cfquery>
		
<!--- 1)-Reserva--->		
			<cfquery datasource="#session.DSN#" name="mmm">
					insert into #request.intPresupuesto#
					(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					CFcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia
				)
				select 
					'CCH',
					<cf_dbfunction name="to_char" args="ta.CCHTAtranRelacionada" > as TESLnumero,
					'Reintegro' ,
					<cf_dbfunction name="to_date" args="ta.BMfecha" > as GELfecha,	
					#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
					#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
					x.CFcuenta, 
					f.Ocodigo, 
					x.Mcodigo, 
					-CASE 
					when x.GELGtotalOri>= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELGtotalOri),2)
							when x.GELGtotalOri< 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELGtotalOri),2)
					else -round(abs(x.GELGtotalOri),2)
					END as INTMOE, 
					x.GELGtipoCambio,
					-CASE 
					when x.GELGtotalOri >= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELGtotalOri) * x.GELGtipoCambio,2)
					when x.GELGtotalOri < 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELGtotalOri) * x.GELGtipoCambio,2)
					else -round(abs(x.GELGtotalOri) * x.GELGtipoCambio,2)
					END as INTMON, 
					'RC' as Tipo, 
					le.CPNAPnum,
					x.Linea				
					from GEliquidacionGasto x
						inner join GEliquidacion le
							inner join CCHTransaccionesProceso c
								inner join CCHTransaccionesAplicadas ta               
								on ta.CCHTAtranRelacionada=c.CCHTid
								and ta.CCHTtipo='GASTO'     
							on c.CCHTrelacionada=le.GELid  
						on le.GELid = x.GELid 
						inner join CFuncional f
						on f.CFid = x.CFid
							inner join CFinanciera cf
								inner join CtasMayor cm
								on cm.Ecodigo = cf.Ecodigo
								and cm.Cmayor = cf.Cmayor
							on cf.CFcuenta = x.CFcuenta	
					where ta.Ecodigo=#session.Ecodigo# 
					and ta.CCHTtipo='GASTO' 
					and ta.CCHTAreintegro < 0 
					and ta.BMfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#">		
					<!---where  x.GELid =<cfqueryparam value="#Arguments.GELid#" cfsqltype="cf_sql_numeric">--->
			</cfquery>

<!---2)Ejecuta el gasto--->
				<cfquery datasource="#session.DSN#" name="nnn">
					insert into #request.intPresupuesto#
					(
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					CFcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento,
					NAPreferencia,
					LINreferencia
				)
				select 
					'CCH',
					<cf_dbfunction name="to_char" args="ta.CCHTAtranRelacionada" > as TESLnumero,
					'Reintegro' ,
					<cf_dbfunction name="to_date" args="ta.BMfecha" > as GELfecha,	
					#rsPeriodoAuxiliar.Pvalor# as Periodo, <!--- AnoDocumento --->
					#rsMesAuxiliar.Pvalor# as Mes, <!--- as MesDocumento --->
					x.CFcuenta, 
					f.Ocodigo, 
					x.Mcodigo, 
					CASE 
					when x.GELGtotalOri>= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELGtotalOri),2)
							when x.GELGtotalOri< 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELGtotalOri),2)
					else -round(abs(x.GELGtotalOri),2)
					END as INTMOE, 
					x.GELGtipoCambio,
					CASE 
					when x.GELGtotalOri >= 0 AND cm.Ctipo IN ('A','G') 
						then round(abs(x.GELGtotalOri) * x.GELGtipoCambio,2)
					when x.GELGtotalOri < 0 AND cm.Ctipo NOT IN ('A','G') 
						then round(abs(x.GELGtotalOri) * x.GELGtipoCambio,2)
					else -round(abs(x.GELGtotalOri) * x.GELGtipoCambio,2)
					END as INTMON, 
					'E' as Tipo	,
						le.CPNAPnum,
					x.Linea		
						from GEliquidacionGasto x
						inner join GEliquidacion le
							inner join CCHTransaccionesProceso c
								inner join CCHTransaccionesAplicadas ta               
								on ta.CCHTAtranRelacionada=c.CCHTid
								and ta.CCHTtipo='GASTO'     
							on c.CCHTrelacionada=le.GELid  
						on le.GELid = x.GELid 
						inner join CFuncional f
						on f.CFid = x.CFid
							inner join CFinanciera cf
								inner join CtasMayor cm
								on cm.Ecodigo = cf.Ecodigo
								and cm.Cmayor = cf.Cmayor
							on cf.CFcuenta = x.CFcuenta	
					where ta.Ecodigo=#session.Ecodigo# 
					and ta.CCHTtipo='GASTO' 
					and ta.CCHTAreintegro < 0 
					and ta.BMfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#">	
			</cfquery>


	<!---**Ejecutar el presupuesto--->
		<cfquery name="rsSQL" datasource="#session.DSN#" maxrows="1">
			select	ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento
			  from #request.intPresupuesto#
		</cfquery>
<cfquery name="rsSQL" datasource="#session.DSN#" maxrows="1">
select	*
  from #request.intPresupuesto#
</cfquery>
<cf_dump var="#rsSQL#">
		<cfset LvarNAP = LobjControl.ControlPresupuestario	
										(	
											rsSQL.ModuloOrigen,
											rsSQL.NumeroDocumento,
											rsSQL.NumeroReferencia,
											rsSQL.FechaDocumento,
											rsSQL.AnoDocumento,
											rsSQL.MesDocumento,
											session.DSN,
											session.Ecodigo
										)>

		<cfif LvarNAP lt 0 >
			<cfquery datasource="#session.dsn#">
				update TESsolicitudPago 
					set NRP = #abs(LvarNAP)#
				 where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESSPid#">
				   and EcodigoOri = #session.Ecodigo#
			</cfquery>
			<cftransaction action="commit" />
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>

<!---3)Gastos DB --->
		<!---inserta datos en intarc--->
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# 
				( 
					INTORI, INTREL, 
					INTDOC, INTREF, 
					INTFEC, Periodo, Mes, Ocodigo, 
					INTTIP, INTDES, 
					CFcuenta, Ccuenta, 
					Mcodigo, INTMOE, INTCAM, INTMON
				)
			select 
					'CCH',1,
					'REINTEGRO',<cf_dbfunction name="to_char" args="ta.CCHTAtranRelacionada">,
					'#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsMesAuxiliar.Pvalor#, cf.Ocodigo,
					'D',
					'Reintegro.' #_Cat# <cf_dbfunction name="to_char" args="d.GELGnumeroDoc"> #_Cat# ': ' #_Cat# d.GELGdescripcion,
					d.CFcuenta, 0, 
					d.Mcodigo, 
					d.GELGtotalOri, 				
					d.GELGtipoCambio, 
					round(d.GELGtotalOri*d.GELGtipoCambio,2)	
					
						from GEliquidacionGasto d
							inner join GEliquidacion le
								inner join CCHTransaccionesAplicadas ta
								on ta.CCHTtipo='GASTOS'
								and ta.CCHTAtranRelacionada= le.GELid
									inner join CFuncional cf
									on cf.CFid=le.CFid
							on le.GELid=d.GELid
						where ta.Ecodigo=#session.Ecodigo# 
						and ta.CCHTtipo='GASTOS' 
						and ta.CCHTAreintegro < 0 
						and ta.BMfecha < '2008-12-17'<!---<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fecha#>	--->
		</cfquery>
	
	
	<!---- GENERA EL ASIENTO CONTABLE --->		
	<cfquery datasource="#session.dsn#" name="rsAsientos">
		select distinct op.EcodigoPago, dp.EcodigoOri
		  from TESordenPago op
		  	inner join TESdetallePago dp
			 	 on dp.TESid	= op.TESid
				and dp.TESOPid	= op.TESOPid
		 where op.TESid		= #session.Tesoreria.TESid#
		   and op.TESOPid	= #arguments.TESOPid#
		UNION
		select 			op.EcodigoPago, op.EcodigoPago 
		  from TESordenPago op
		 where op.TESid		= #session.Tesoreria.TESid#
		   and op.TESOPid	= #arguments.TESOPid#
	</cfquery>
	
	<cfquery name="rsOficina" datasource="#session.dsn#">
		select cb.Ocodigo
		  from TESordenPago op
			inner join CuentasBancos cb
				 on cb.CBid = op.CBidPago
		 where op.TESid		= #session.Tesoreria.TESid#
		   and op.TESOPid	= #arguments.TESOPid#
	</cfquery>
	<cfquery name="rsTESOP" datasource="#session.dsn#">
		select TESOPfechaPago,
			case when op.TESCFDnumFormulario is not null 
				<cfif LvarAnulacion>
					then 'XC:'
					else 'XT:'
				<cfelse>
					then 'PC:'
					else 'PT:'
				</cfif> 
				end #_Cat# cb.CBcodigo as ReferenciaOP,
		substring(
					<cfif LvarAnulacion>
						case 
							when op.TESOPestado = 13 then
								'TES:Anulación OP.' 
								#_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
								#_Cat#	case when op.TESCFDnumFormulario is not null 
										then ':CK.' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario"> 
										else ':TR.' #_Cat# (select td.TESTDreferencia from TEStransferenciasD td where td.TESTDid = op.TESTDid)
									end
							else
								'TES:Anulación ' 
								#_Cat#	case when op.TESCFDnumFormulario is not null 
										then 'CK.' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario"> 
										else 'TR.' #_Cat# (select td.TESTDreferencia from TEStransferenciasD td where td.TESTDid = op.TESTDid)
									end
								#_Cat# ':OP.' 
								#_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
						end
					<cfelse>
						'TES:Emisión OP.' 
						#_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> 
						#_Cat# ':'
						#_Cat# 	case when op.TESCFDnumFormulario is not null 
								then 'CK.' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario"> 
								else 'TR.' #_Cat# (select td.TESTDreferencia from TEStransferenciasD td where td.TESTDid = op.TESTDid)
							end
					</cfif>
						#_Cat# ':a ' #_Cat# rtrim(op.TESOPbeneficiario) #_Cat# ' ' #_Cat# rtrim(coalesce(op.TESOPbeneficiarioSuf,' '))
					,1,100) as DescripcionOPC,
					case when op.TESCFDnumFormulario is not null 
						then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario"> 
						else (select td.TESTDreferencia from TEStransferenciasD td where td.TESTDid = op.TESTDid)
					end as DocumentoOP					
		  from TESordenPago op
			inner join CuentasBancos cb
				 on cb.CBid = op.CBidPago
		 where op.TESid		= #session.Tesoreria.TESid#
		   and op.TESOPid	= #arguments.TESOPid#
	</cfquery>
	
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo" value="#rsAsientos.EcodigoOri#"/>
			<cfinvokeargument name="Eperiodo" value="#rsPeriodoAuxiliar.Pvalor#"/>
			<cfinvokeargument name="Emes" value=" #rsMesAuxiliar.Pvalor#"/>
			<cfinvokeargument name="Efecha" value="#rsTESOP.TESOPfechaPago#"/>
			<cfinvokeargument name="Oorigen" value="TEOP"/>
			<cfinvokeargument name="Ocodigo" value="#rsOficina.Ocodigo#"/>
			<cfinvokeargument name="Edocbase" value="#rsTESOP.DocumentoOP#"/>
			<cfinvokeargument name="Ereferencia" value="#rsTESOP.ReferenciaOP#"/>						
			<cfinvokeargument name="Edescripcion" value="#rsTESOP.DescripcionOPC#"/>
			<cfinvokeargument name="NAP"		value="#LvarNAP#"/>
			<cfinvokeargument name="CPNAPIid"	value="0"/>
		</cfinvoke>

</cffunction>
<!---                                              Deposito en Proceso                                                                      --->
<cffunction name="DProceso" access="public">
<cfargument name="CCHid"           type="numeric"          required="yes">
<cfargument name="CCHImporteD"     type="numeric"        required="yes">

	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHImontoasignado,CCHIanticipos,CCHIgastos,CCHIreintegroEnProceso,CCHIdeposito from CCHImportes where CCHid=#arguments.CCHid#
	</cfquery>
		
		<cfset disponible= MDisponible(arguments.CCHid)>
		<cfset asignado=rsSQL.CCHImontoasignado>
		<cfset anticipos=rsSQL.CCHIanticipos>
		<cfset gastos=rsSQL.CCHIgastos>
		<cfset reintegro=rsSQL.CCHIreintegroEnProceso>
		<cfset deposito=rsSQL.CCHIdeposito+CCHImporteD>
		
		
	<cfquery name="rsUp" datasource="#session.dsn#">
		update CCHImportes set CCHIdepositos = deposito where CCHid=#arguments.CCHid#
	</cfquery>
	
</cffunction>

<!---                                              Confirmacion de Custodio                                                                   --->
<cffunction name="ConfirmaCust" access="public">
	<cfargument name="CCHTid"     type="numeric"     required="yes"> 
	<cfargument name="CCHTAid"    type="numeric"     required="yes"> 
	<cfargument name="CCHtipo"    type="any"         required="yes">
	
	
	<cfquery name="upTran" datasource="#session.dsn#">
		update CCHTransaccionesAplicadas set CCHTCid = #arguments.CCHTAid# where CCHTAtranRelacionada = #arguments.CCHTid# and CCHTtipo='#arguments.CCHtipo#'
	</cfquery>

</cffunction>

<!---                                              Confirma el monto del disponible                                                                      --->
<cffunction name="ConfirmaImporte" access="public" returntype="boolean">
	<cfargument name="CCHid" 				 type="numeric" 	required="yes">
	<cfargument name="CCHTtipo"       		 type="string" 		required="yes" > 
	<cfargument name="ImporteA"    	  		 type="numeric" 	required="no" >
	<cfargument name="ImporteL"    	  		 type="numeric" 	required="no" >  
	<cfargument name="Id_anticipo"	 		 type="numeric" 	required="no"> 
	<cfargument name="Id_liquidacion"  		 type="numeric" 	required="no" >
	<cfargument name="ImporteD"    	  		 type="numeric" 	required="no" >   
	
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHImontoasignado,CCHIanticipos,CCHIgastos,CCHIreintegroEnProceso from CCHImportes where CCHid=#arguments.CCHid#
	</cfquery>
		
		<cfset disponible= MDisponible(arguments.CCHid)>
		<cfset asignado=rsSQL.CCHImontoasignado>
		<cfset anticipos=rsSQL.CCHIanticipos>
		<cfset gastos=rsSQL.CCHIgastos>
		<cfset reintegro=rsSQL.CCHIreintegroEnProceso>
	
	<cfquery name="PorMax" datasource="#session.dsn#">
		select CCHmax,CCHmin from CCHica where CCHid= #arguments.CCHid#
	</cfquery>
	
	<cfquery name="Importe" datasource="#session.dsn#">
		select CCHImontoasignado from CCHImportes where CCHid= #arguments.CCHid#
	</cfquery>
	
	<cfset total= arguments.ImporteA - (ImporteL +ImporteD) >
	<cfif total gt 0 >
	
	<cfset porcentaje= replace(arguments.total,',','','ALL') *100/ replace(disponible,',','','ALL')>	

	<cfif arguments.CCHTtipo eq 'LIQUIDACION'>
		<cfif porcentaje lte PorMax.CCHmax>			
				<cfquery name="rsAnti" datasource="#session.dsn#">
					select GELAtotal,GEAid from GEliquidacionAnts where GELid=#arguments.Id_liquidacion#
				</cfquery>	
				<cfloop query="rsAnti">
					<cfquery name="rsTotal" datasource="#session.dsn#">
						select sum(GELAtotal) as total from GEliquidacionAnts where GEAid=#rsAnti.GEAid#
					</cfquery>
					<cfset rsTotLiq =rsTotal.total>
					<cfquery name="rsTAnti" datasource="#session.dsn#">
						select GEAtotalOri,GEAnumero from GEanticipo where GEAid=#rsAnti.GEAid#
					</cfquery>
					<cfset rsTotAnt= rsTAnto.GEAtotalOri>
						<cfif rsTotLiq gt rsTAnti>
							<cfthrow message="No se puede Aprobar porque el Anticipo #rsTAnti.GEAnumero# esta liquidando mas del monto original">
						</cfif>			
				</cfloop>
					
					<cfset totalA=anticipos-arguments.ImporteA>
					<cfset totalL=gastos+arguments.ImporteL>			
				
					<cfif disponible-arguments.ImporteL gt 0>
						<cfset LvarReturn='true'>
					<cfelse>
						<cfset LvarReturn='false'>
					</cfif>
					<cfreturn #LvarReturn#>
		<cfelse>
			<cfthrow message="Sobrepasa el porcentaje asignado">
	</cfif>
</cfif>
</cfif>
</cffunction>

<!---                                              Disponible Importes                                                                      --->
<cffunction name="MDisponible" access="public" returntype="numeric">
<cfargument name="CCHid" 				 type="numeric" 	required="yes">
	 <cfquery name="rsSQL" datasource="#session.dsn#">
		select CCHImontoasignado,coalesce(CCHIanticipos,0) as CCHIanticipos,coalesce(CCHIgastos,0) as CCHIgastos,
		coalesce(CCHIreintegroEnProceso,0) as CCHIreintegroEnProceso,coalesce(CCHIdeposito,0) as CCHIdeposito 
		from CCHImportes where CCHid=#arguments.CCHid#
		</cfquery>
		<cfif rsSQL.recordcount gt 0>
			<cfset asignado=#rsSQL.CCHImontoasignado#>
			<cfset anticipos=#rsSQL.CCHIanticipos#>
			<cfset gastos=#rsSQL.CCHIgastos#>
			<cfset devoluciones=#rsSQL.CCHIdeposito#>
			<cfset reintegro=#rsSQL.CCHIreintegroEnProceso#>
			<cfset disponible= asignado -(anticipos + gastos + reintegro+devoluciones)>
			<cfreturn #disponible#>
		<cfelse>
			<cfthrow message="La caja actual no tiene montos asignados">
		</cfif>
</cffunction>


<!---                                        Insertar a Seguimientos de Transacciones                                                       --->
<cffunction name="SeguimientoT" access="public">
<cfargument name="CCHTid" 				 type="numeric" 	required="yes">
<cfargument name="CCHTestado"   		 type="any" 		required="yes">
<cfargument name="CCHtipo" 				 type="any" 		required="yes">
<cfargument name="CCHTrelacionada"		 type="any" 		required="no" default=" ">
<cfargument name="CCHTtrelacionada"		 type="any" 		required="no" default=" ">

<cfif isdefined ('CCHTtrelacionada') and isdefined('CCHTtrelacionada') and len(trim(CCHTrelacionada)) gt 0 and len(trim(CCHTtrelacionada)) gt 0>
	<cfquery name="rsSQLS" datasource="#session.dsn#">
			insert into STransaccionesProceso(
				CCHTid, 
				CCHTestado, 
				CCHTfecha, 
				BMUsucodigo, 
				CCHTtipo,
				CCHTrelacionada,
				CCHTtrelacionada
				)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHTid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTestado#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHtipo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHTrelacionada#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTtrelacionada#">
				)
		</cfquery>
		<cfquery name="up" datasource="#session.dsn#">
			update CCHTransaccionesProceso set CCHTrelacionada=#arguments.CCHTrelacionada# where CCHTid=#arguments.CCHTid# and Ecodigo=#session.Ecodigo#
		</cfquery>
<cfelse>
	<cfquery name="rsSQLS" datasource="#session.dsn#">
		insert into STransaccionesProceso(
			CCHTid, 
			CCHTestado, 
			CCHTfecha, 
			BMUsucodigo, 
			CCHTtipo
			)
		values(
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHTid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTestado#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHtipo#">
			)
	</cfquery>
</cfif>
</cffunction>


<!---                                                     Insertar a Transacciones en Proceso                                              --->
<cffunction name="TranProceso" access="public" returntype="numeric">
	<cfargument name="Mcodigo" 				 type="numeric" 	required="yes">
	<cfargument name="CFcuenta"		 		 type="numeric" 	required="no">
	<cfargument name="CCHTdescripcion"		 type="any" 		required="yes">
	<cfargument name="CCHTestado"			 type="string" 		required="yes">
	<cfargument name="CCHTmonto"			 type="numeric" 	required="yes">
	<cfargument name="CCHTidCustodio"		 type="numeric" 	required="no">
	<cfargument name="CCHTtipo"		 		 type="string" 		required="yes">
	<cfargument name="CCHid"		 		 type="numeric" 	required="no">
	<cfargument name="CCHTrelacionada"		 type="any" 		required="no" default=" ">
	<cfargument name="CCHTtrelacionada"		 type="any" 		required="no" default=" ">

	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
        <cfquery name="rsCod" datasource="#session.dsn#">
                select coalesce(max(CCHcod),0) + 1 as id
                from CCHTransaccionesProceso
                where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>	
        
        <!---<cftransaction>--->
        <cfquery name="inSQL1" datasource="#session.dsn#">
            insert into CCHTransaccionesProceso(		
                Ecodigo,
                Mcodigo,
                CFcuenta,
                CCHTdescripcion,
                CCHTestado,
                CCHTmonto,
                CCHTCid ,
                BMUsucodigo,
                BMfecha,
                CCHTtipo,
                CCHid,
                CCHcod 
                )
            values(
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
            <cfif isdefined ('arguments.CFcuenta') and len(trim(arguments.CFcuenta)) gt 0>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CFcuenta#">,
            <cfelse>
                null,
            </cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTestado#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#replace(arguments.CCHTmonto,',','','ALL')#">,
            <cfif isdefined ('arguments.CCHTidCustodio')>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHTidCustodio#">,
            <cfelse>
                null,
            </cfif>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.CCHTtipo#">	,
            <cfif isdefined ('arguments.CCHid')>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCHid#">,
            <cfelse>
                0,
            </cfif>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCod.id#">
                )
                <cf_dbidentity1 datasource="#session.dsn#" name="inSQL1" verificar_transaccion= "false">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="inSQL1" returnvariable="LvarCCHTidProc" verificar_transaccion= "false">
	</cflock>
	<cfset varReturn=#LvarCCHTidProc#>	
	<cfset seguimientoT (LvarCCHTidProc,arguments.CCHTestado,arguments.CCHTtipo,arguments.CCHTrelacionada,arguments.CCHTtrelacionada)>
	<cfreturn #varReturn#>
	<!---</cftransaction>--->
</cffunction>


<!---                                                    Creacion de Solicitudes de Pago(Apertura, Aumento , Reintegro)                     --->
<cffunction name="crearSP" access="public" returntype="numeric">
	<cfargument name="CCHtipo" 			type="numeric" 	required="yes"> 
	<cfargument name="TESBid"    		type="numeric" 	required="yes"> 
	<cfargument name="CCHfechaPagar" 	type="date"    	required="yes"> 
	<cfargument name="Mcodigo" 	 		type="numeric" 	required="yes"> 
	<cfargument name="CCHtotalOri" 		type="numeric"  required="yes"> 		
	<cfargument name="CFid"   			type="numeric" 	required="yes"> 
	<cfargument name="CFcuenta"  		type="any"		required="yes"> 
	<cfargument name="CCHdescripcion"   type="string"  	required="no" default=""> 
	<cfargument name="CCHcod"  			type="any"  required="yes"> 
	<cfargument name="CCHtransaccion"   type="numeric"  required="yes"> 
	<cfargument name="CCHtran" 			type="numeric"  required="yes">
	<cfargument name="CCHreferencia" 	type="any"  	required="yes">
	<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">

	<cfquery name="empleado" datasource="#session.dsn#">
		select count(1) as cantidad  from TESbeneficiario where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
	</cfquery>
	
	<cfquery name="datos" datasource="#session.dsn#">
		select 
			DEid,
			DEidentificacion,
			DEnombre,
			DEapellido1,
			DEapellido2,
			DEtelefono1,
			DEemail 					
			from 
			DatosEmpleado 
		where 
			DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
	</cfquery>
		
	
	<cfif empleado.cantidad EQ 0>			
		<cfquery name="inserta" datasource="#session.dsn#">
			insert into TESbeneficiario
				(CEcodigo,
				TESBeneficiarioId,
				TESBeneficiario,
				TESBtelefono,
				TESBemail,
				DEid)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value=" #datos.DEidentificacion#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#datos.DEnombre# #datos.DEapellido1##datos.DEapellido2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEtelefono1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEemail#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
			)
		</cfquery>
	<cfelse>
			<cfquery datasource="#session.DSN#">
				update TESbeneficiario 
				set 
				TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value=" #datos.DEidentificacion#">,
				<cfif len(trim(datos.DEnombre)) eq 0 and len(trim(datos.DEapellido1)) eq 0  and len(trim(datos.DEapellido2)) eq 0>
				TESBeneficiario = NULL,
				<cfelse>
					TESBeneficiario = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.DEnombre# #datos.DEapellido1##datos.DEapellido2#">,
				</cfif>
				
				<cfif len(trim(datos.DEtelefono1)) eq 0 >
					TESBtelefono = NULL,
				<cfelse>
					TESBtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEtelefono1#">,
				</cfif>
					
				<cfif len(trim(datos.DEemail)) eq 0 >
					TESBemail = NULL
				<cfelse>
					TESBemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEemail#">
				</cfif>
				where 
				DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
			</cfquery>
	</cfif>		
	
	<cfquery name="beneficiario" datasource="#session.dsn#">
			select 
				TESBid 
			from 
				TESbeneficiario 
			where 
				DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
	</cfquery>
	
		<cfset estado='1'>
		<cfset estadoE='EN APROBACION TES'>
	
	<cfquery name="TCsug" datasource="#session.dsn#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		  and Mcodigo=#Mcodigo#
	</cfquery>

	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
		<cfquery name="Solicitud" datasource="#session.dsn#">
			select coalesce(max(TESSPnumero),0) + 1 as id
			from TESsolicitudPago
			where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
				
        <cfquery datasource="#session.dsn#" name="insSolApr">
            insert into TESsolicitudPago(
                TESid,
                CFid,
                EcodigoOri,
                TESSPnumero,
                TESSPtipoDocumento, 
                TESSPestado, 
                TESBid,
                TESSPfechaPagar, 
                McodigoOri, 
                TESSPtotalPagarOri, 
                TESSPfechaSolicitud,
                UsucodigoSolicitud, 
                BMUsucodigo,
                CBid,
                TESSPtipoCambioOriManual
                )
            values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Tesoreria.TESid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CFid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Solicitud.id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CCHtipo#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,  
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#beneficiario.TESBid#">,
                <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#CCHtotalOri#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(CFcuenta)#"	null="#rtrim(CFcuenta) EQ ""#">,
                    <cfif TCsug.recordcount eq 0>
                        1
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#TCsug.TCcompra#">
                    </cfif>
            )
            <cf_dbidentity1 datasource="#session.dsn#" name="insSolApr" verificar_transaccion= "false">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion= "false">
        <!---</cftransaction>--->
	</cflock>
				<cfset TESSPid=#LvarTESSPid#>
				
							
	
							<!---OBTENCION DEL TESSPid DE LA NUEVA SOLICITUD, PARA REFERENCIAR EL DETALLE--->	
									<cfquery name="resulset" datasource="#session.dsn#">
										select TESSPid from TESsolicitudPago where TESSPnumero=#Solicitud.id#
									</cfquery>
							<!---SELECCION DEL CODIGO DE LA OFICINA--->
									<cfquery name="CFuncional" datasource="#session.dsn#">
										select Ocodigo from CFuncional where CFid=#CFid#
									</cfquery>
							<!---SELECCIONAR EL ISO DE LA MONEDA--->
									<cfquery name="sigMoneda" datasource="#session.dsn#">
										select Miso4217
										from Monedas
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
									</cfquery>
					
							<!--- DETALLE DE LA SOLICITUD DE PAGO EN ESTADO 1--->	
									<cfquery datasource="#session.dsn#">
										insert into TESdetallePago 
											(
												TESDPestado,
												EcodigoOri,
												TESid,
												CFid,
												TESSPid,
												TESDPtipoDocumento,
												TESDPidDocumento,
												TESDPdocumentoOri,
												TESDPreferenciaOri,
												TESDPfechaVencimiento,
												TESDPfechaSolicitada,
												TESDPfechaAprobada,
												Miso4217Ori,
												TESDPmontoVencimientoOri,
												TESDPmontoSolicitadoOri,
												TESDPmontoAprobadoOri,
												OcodigoOri,
												CFcuentaDB,
												TESDPdescripcion,
												TESDPmoduloOri)			
										values (
												<cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,  
												<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Tesoreria.TESid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#CFid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">, 
												<cfqueryparam cfsqltype="cf_sql_integer" value="#CCHtipo#">,												
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#CCHtran#">, 
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHcod#" >,
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHreferencia#" >,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam cfsqltype="cf_sql_char" 	   value="#sigMoneda.Miso4217#" >,
												<cfqueryparam cfsqltype="cf_sql_money" value="#CCHtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_money" value="#CCHtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_money" value="#CCHtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"    value="#arguments.CFcuenta#">,
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHdescripcion#" >,
												<cfqueryparam cfsqltype="cf_sql_char" 	   value='CCH'>)
										</cfquery>
											<cfset varReturn=#TESSPid#>	
		
		
		<cfquery datasource="#session.dsn#">
			update CCHTransaccionesProceso set CCHTestado='EN APROBACION TES' where CCHTid=#CCHtransaccion# and Ecodigo=#session.Ecodigo#
		</cfquery>
			<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
		<cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
			<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP"			
			SPid 		 =	"#TESSPid#"
			fechaPagoDMY =	""
			generarOP 	 =	"false"			
			PRES_Origen		= "TECH"
			PRES_Documento	= "#CCHcod#"
			PRES_Referencia	= "GE.CajaChica"
		>
	<cfreturn #varReturn#>
</cffunction>

<!---                                                    Creacion de Solicitudes de Pago(Reintegro)                     --->
<cffunction name="crearSPreintegro" access="public" returntype="numeric">
	<cfargument name="CCHid" 			type="numeric" 	required="yes"> 
	<cfargument name="CCHtipo" 			type="numeric" 	required="yes"> 
	<cfargument name="TESBid"    		type="numeric" 	required="yes"> 
	<cfargument name="CCHfechaPagar" 	type="date"    	required="yes"> 
	<cfargument name="Mcodigo" 	 		type="numeric" 	required="yes"> 
	<cfargument name="CCHtotalOri" 		type="numeric"  required="yes"> 		
	<cfargument name="CFid"   			type="numeric" 	required="yes"> 
	<cfargument name="CFcuenta"  		type="any"		required="yes"> 
	<cfargument name="CCHdescripcion"   type="string"  	required="no" default=""> 
	<cfargument name="CCHcod"  			type="any"  required="yes"> 
	<cfargument name="CCHtransaccion"   type="numeric"  required="yes"> 
	<cfargument name="CCHtran" 			type="numeric"  required="yes">
	<cfargument name="CCHreferencia" 	type="any"  	required="yes">
	<cfargument name="CCHTid" 			type="numeric"  	required="no">
	<cfinclude template="../Solicitudes/TESid_Ecodigo.cfm">

<cfif isdefined ('arguments.CCHTid') and len(trim(arguments.CCHTid)) gt 0>
	<cfset CCHTid=#arguments.CCHTid#>
<cfelse>
	<cfset CCHTid=0>
</cfif>

	<!---<cfquery name="rsBus" datasource="#session.dsn#">
		select sum(CCHTAmonto) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro < 0 and CCHid= #arguments.CCHid#
	</cfquery>--->
	
	<cfquery name="empleado" datasource="#session.dsn#">
		select count(1) as cantidad  from TESbeneficiario where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
	</cfquery>

	<cfquery name="datos" datasource="#session.dsn#">
		select 
			DEid,
			DEidentificacion,
			DEnombre,
			DEapellido1,
			DEapellido2,
			DEtelefono1,
			DEemail 					
			from 
			DatosEmpleado 
		where 
			DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
	</cfquery>
			
	
	<cfif empleado.cantidad EQ 0>			
		<cfquery name="inserta" datasource="#session.dsn#">
			insert into TESbeneficiario
				(CEcodigo,
				TESBeneficiarioId,
				TESBeneficiario,
				TESBtelefono,
				TESBemail,
				DEid)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value=" #datos.DEidentificacion#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#datos.DEnombre# #datos.DEapellido1##datos.DEapellido2#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEtelefono1#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEemail#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
			)
		</cfquery>
	<cfelse>
			<cfquery datasource="#session.DSN#">
				update TESbeneficiario 
				set 
				TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value=" #datos.DEidentificacion#">,
				<cfif len(trim(datos.DEnombre)) eq 0 and len(trim(datos.DEapellido1)) eq 0  and len(trim(datos.DEapellido2)) eq 0>
				TESBeneficiario = NULL,
				<cfelse>
					TESBeneficiario = <cfqueryparam cfsqltype="cf_sql_char" value="#datos.DEnombre# #datos.DEapellido1##datos.DEapellido2#">,
				</cfif>
				
				<cfif len(trim(datos.DEtelefono1)) eq 0 >
					TESBtelefono = NULL,
				<cfelse>
					TESBtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEtelefono1#">,
				</cfif>
					
				<cfif len(trim(datos.DEemail)) eq 0 >
					TESBemail = NULL
				<cfelse>
					TESBemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.DEemail#">
				</cfif>
				where 
				DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
			</cfquery>
	</cfif>		
	
	<cfquery name="beneficiario" datasource="#session.dsn#">
			select 
				TESBid 
			from 
				TESbeneficiario 
			where 
				DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#TESBid#">
	</cfquery>
	
		<cfset estado='1'>
		<cfset estadoE='EN APROBACION TES'>
	
	<cfquery name="TCsug" datasource="#session.dsn#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		  and Mcodigo=#Mcodigo#
	</cfquery>

	<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">		
		<cfquery name="Solicitud" datasource="#session.dsn#">
			select coalesce(max(TESSPnumero),0) + 1 as id
			from TESsolicitudPago
			where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>	
		
		<!---<cftransaction>--->
        <cfquery datasource="#session.dsn#" name="insSolApr">
            insert into TESsolicitudPago(
                TESid,
                CFid,
                EcodigoOri,
                TESSPnumero,
                TESSPtipoDocumento, 
                TESSPestado, 
                TESBid,
                TESSPfechaPagar, 
                McodigoOri, 
                TESSPtotalPagarOri, 
                TESSPfechaSolicitud,
                UsucodigoSolicitud, 
                BMUsucodigo,
                CBid,
                TESSPtipoCambioOriManual
                )
            values (
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Tesoreria.TESid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CFid#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#Solicitud.id#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#CCHtipo#">, 
                <cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,  
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#beneficiario.TESBid#">,
                <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#CCHtotalOri#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rtrim(CFcuenta)#"	null="#rtrim(CFcuenta) EQ ""#">,
                    <cfif TCsug.recordcount eq 0>
                        1
                    <cfelse>
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#TCsug.TCcompra#">
                    </cfif>
            )
            <cf_dbidentity1 datasource="#session.dsn#" name="insSolApr" verificar_transaccion= "false">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="insSolApr" returnvariable="LvarTESSPid" verificar_transaccion= "false">
        <!---</cftransaction>--->
	</cflock>
				<cfset TESSPid=#LvarTESSPid#>
				
							
	
							<!---SELECCION DEL CODIGO DE LA OFICINA--->
									<cfquery name="CFuncional" datasource="#session.dsn#">
										select Ocodigo from CFuncional where CFid=#CFid#
									</cfquery>
							<!---SELECCIONAR EL ISO DE LA MONEDA--->
									<cfquery name="sigMoneda" datasource="#session.dsn#">
										select Miso4217
										from Monedas
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
									</cfquery>
									
							<cfif CCHTid gt 0>
								<cfquery name="rsLineas" datasource="#session.dsn#">
									select a.CCHTAtranRelacionada,o.CCHTrelacionada from CCHTransaccionesAplicadas a
											inner join CCHTransaccionesProceso o
											on a.CCHTAtranRelacionada=o.CCHTid
									 where a.CCHTtipo='GASTO' and a.CCHTAreintegro =#CCHTid# and a.CCHid= #arguments.CCHid#
								</cfquery>
							<cfelse>
								<cfquery name="rsLineas" datasource="#session.dsn#">
									select o.CCHTrelacionada 
									  from CCHTransaccionesAplicadas a
											inner join CCHTransaccionesProceso o
											on a.CCHTAtranRelacionada=o.CCHTid
									where a.CCHTtipo='GASTO' and a.CCHTAreintegro < 0 and a.CCHid= #arguments.CCHid#
								</cfquery>
							</cfif>		
						
							<cfloop query="rsLineas">
								<cfquery name="rsGEL" datasource="#session.dsn#">
									select lg.CFcuenta,lg.GELGtotalOri,lg.CFid, l.CPNAPnum, lg.Linea
									  from GEliquidacionGasto lg
									   inner join GEliquidacion l 
									  	on l.GELid = lg.GELid
									 where lg.GELid=#rsLineas.CCHTrelacionada#
								</cfquery>
					
					<cfloop query="rsGEL">
							<!--- DETALLE DE LA SOLICITUD DE PAGO EN ESTADO 1--->	
									<cfquery datasource="#session.dsn#" name="xxx">
										insert into TESdetallePago 
											(
												TESDPestado,
												EcodigoOri,
												TESid,
												CFid,
												TESSPid,
												TESDPtipoDocumento,
												TESDPidDocumento,
												TESDPdocumentoOri,
												TESDPreferenciaOri,
												TESDPfechaVencimiento,
												TESDPfechaSolicitada,
												TESDPfechaAprobada,
												Miso4217Ori,
												TESDPmontoVencimientoOri,
												TESDPmontoSolicitadoOri,
												TESDPmontoAprobadoOri,
												OcodigoOri,
												CFcuentaDB,
												TESDPdescripcion,
												TESDPmoduloOri
												)			
										values (
												<cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,  
												<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Tesoreria.TESid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsGEL.CFid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">, 
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CCHtipo#">,												
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#CCHtran#">, 
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHcod#">,
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHreferencia#" >,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam cfsqltype="cf_sql_char" 	   value="#sigMoneda.Miso4217#" >,
												<cfqueryparam cfsqltype="cf_sql_money" value="#rsGEL.GELGtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_money" value="#rsGEL.GELGtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_money" value="#rsGEL.GELGtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"    value="#rsGEL.CFcuenta#">,
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHdescripcion#" >,
												<cfqueryparam cfsqltype="cf_sql_char" 	   value='CCH'>
												)
										</cfquery>
									<cfquery datasource="#session.dsn#" name="xxx">
										insert into TESdetallePago 
											(
												TESDPestado,
												EcodigoOri,
												TESid,
												CFid,
												TESSPid,
												TESDPtipoDocumento,
												TESDPidDocumento,
												TESDPdocumentoOri,
												TESDPreferenciaOri,
												TESDPfechaVencimiento,
												TESDPfechaSolicitada,
												TESDPfechaAprobada,
												Miso4217Ori,
												TESDPmontoVencimientoOri,
												TESDPmontoSolicitadoOri,
												TESDPmontoAprobadoOri,
												OcodigoOri,
												CFcuentaDB,
												TESDPdescripcion,
												TESDPmoduloOri,

												CFcuentaDB_SP,
												NAPref_SP,
												LINref_SP
												)			
										values (
												<cfqueryparam cfsqltype="cf_sql_integer" value="#estado#">,  
												<cfqueryparam cfsqltype="cf_sql_integer"   value="#session.Ecodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Tesoreria.TESid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsGEL.CFid#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESSPid#">, 
												<cfqueryparam cfsqltype="cf_sql_varchar" value="#CCHtipo#">,												
												<cfqueryparam cfsqltype="cf_sql_numeric"   value="#CCHtran#">, 
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHcod#">,
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHreferencia#" >,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
												<cfqueryparam cfsqltype="cf_sql_char" 	   value="#sigMoneda.Miso4217#" >,
												-<cfqueryparam cfsqltype="cf_sql_money" value="#rsGEL.GELGtotalOri#">,
												-<cfqueryparam cfsqltype="cf_sql_money" value="#rsGEL.GELGtotalOri#">,
												-<cfqueryparam cfsqltype="cf_sql_money" value="#rsGEL.GELGtotalOri#">,
												<cfqueryparam cfsqltype="cf_sql_integer"   value="#CFuncional.Ocodigo#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"    value="#rsGEL.CFcuenta#">,
												<cfqueryparam cfsqltype="cf_sql_varchar"   value="#CCHdescripcion#" >,
												<cfqueryparam cfsqltype="cf_sql_char" 	   value='CCH'>,
												<cfqueryparam cfsqltype="cf_sql_numeric"    value="-1">,
												<cfqueryparam cfsqltype="cf_sql_numeric"    value="#rsGEL.CPNAPnum#">,
												<cfqueryparam cfsqltype="cf_sql_numeric"    value="#rsGEL.Linea#">
												)
										</cfquery>
									</cfloop>
									</cfloop>
								
											<cfset varReturn=#TESSPid#>	
		<cfquery datasource="#session.dsn#">
			update CCHTransaccionesProceso set CCHTestado='EN APROBACION TES' where CCHTid=#CCHtransaccion# and Ecodigo=#session.Ecodigo#
		</cfquery>
			<cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP"			
				SPid 		 =	"#TESSPid#"
				fechaPagoDMY =	""
				generarOP 	 =	"false"
				PRES_Origen		= "TECH"
				PRES_Documento	= "#CCHcod#"
				PRES_Referencia	= "GE.CajaChica"
			>
	<cfreturn #varReturn#>
</cffunction>

<!---                                                      Modificacion de Transacciones en Proceso                                         --->
<cffunction name="modificarTP" access="public">
	<cfargument name="CCHTid" 			type="numeric" 	required="yes"> 
	<cfargument name="CCHTtipo" 		type="string" 	required="yes"> 
	<cfargument name="CCHTmontoA" 		type="numeric" 	required="yes"> 
	<cfargument name="CCHTdescripcion"	type="any" 		required="yes"> 
	<cfargument name="CCHid"			type="numeric"	required="yes"> 

	<cfquery name="rsMod" datasource="#session.dsn#">
		update CCHTransaccionesProceso set
			CCHTtipo='#arguments.CCHTtipo#',
			CCHTmonto=#arguments.CCHTmontoA#,
			CCHTdescripcion='#arguments.CCHTdescripcion#',
			CCHid=#CCHid#
		where CCHTid= #arguments.CCHTid#
	</cfquery>
</cffunction>

<!---                                                      Modificacion Estado de Transacciones en Proceso                                  --->
<cffunction name="CambiaEstadoTP" access="public">
	<cfargument name="CCHTid" 				type="numeric" 		required="yes"> 
	<cfargument name="CCHTestado"			type="any"			required="yes"> 
	<cfargument name="CCHtipo" 				 type="any" 		required="yes">
	<cfargument name="CCHTrelacionada"		 type="any" 		required="no" default=" ">
	<cfargument name="CCHTtrelacionada"		 type="any" 		required="no" default=" ">

	<cfquery name="rsMod" datasource="#session.dsn#">
		update CCHTransaccionesProceso set
			CCHTestado='#arguments.CCHTestado#'
		where CCHTid= #arguments.CCHTid#
	</cfquery>
		<cfset seguimientoT (arguments.CCHTid,arguments.CCHTestado,arguments.CCHtipo,arguments.CCHTrelacionada,arguments.CCHTtrelacionada)>
</cffunction>

<!---                                                      Inserta a Transacciones Aplicadas                                                --->
<cffunction name="TAplicadas" access="public" returntype="numeric">
	<cfargument name="CCHid"		 		 type="numeric" 	required="yes">
	<cfargument name="Mcodigo" 				 type="numeric" 	required="yes">
	<cfargument name="TESSPid" 				 type="any" 	required="no">
	<cfargument name="CCHTdescripcion"		 type="any" 		required="yes">
	<cfargument name="CCHTestado"			 type="string" 		required="yes">
	<cfargument name="CCHTmonto"			 type="numeric" 	required="yes">
	<cfargument name="CCHTidCustodio"		 type="numeric" 	required="yes">
	<cfargument name="Sufijo"		 		 type="any" 		required="yes">
	<cfargument name="CCHTid"		 		 type="numeric" 	required="yes">
	<cfargument name="CCHTtipo"		 		 type="any"		 	required="yes">
	<cfargument name="CCHTAdep"		 		 type="any" 		required="no">
	<cfargument name="CCHTAsoporte"		 	 type="any" 		required="no">
	<cfargument name="CBid" 				 type="numeric" 	required="no">
	<cfargument name="CCHTAreintegro" 		 type="numeric" 	required="no" default="-1">
	<cfargument name="CCHTrelacionada"		 type="any" 		required="no" default=" ">
	<cfargument name="CCHTtrelacionada"		 type="any" 		required="no" default=" ">
	
			<cfquery name="inTA" datasource="#session.dsn#">
				insert into CCHTransaccionesAplicadas(
						CCHid,         
						Mcodigo,
						TESSPid,
						CCHTAdescrip,
						CCHTAestado,
						CCHTAmonto,
						CCHTAtranRelacionada,
						CCHTAprobador,			
						Ecodigo,				
						BMUsucodigo,
						BMfecha,
						CCHTtipo,
						CBid,	
						CCHTAdep,
						CCHTAsoporte,
						CCHTAreintegro
				)
				values(
						<cfqueryparam value="#arguments.CCHid#" cfsqltype="cf_sql_numeric" >,
						<cfqueryparam value="#arguments.Mcodigo#" cfsqltype="cf_sql_numeric" > ,
					<cfif isdefined('arguments.TESSPid') and len(trim(arguments.TESSPid)) gt 0 >
						<cfqueryparam value="#arguments.TESSPid#" cfsqltype="cf_sql_numeric" > ,
					<cfelse>
						null,
					</cfif>
						<cfqueryparam value="#arguments.CCHTdescripcion#" cfsqltype="cf_sql_varchar" > ,
						<cfqueryparam value="#arguments.CCHTestado#" cfsqltype="cf_sql_varchar" > ,
						<cfqueryparam value="#arguments.CCHTmonto#" cfsqltype="cf_sql_money" > ,
						<cfqueryparam value="#arguments.CCHTid#" cfsqltype="cf_sql_numeric" > ,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric" >,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric" > ,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric" >,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_date" >,
						<cfqueryparam value="#arguments.CCHTtipo#" cfsqltype="cf_sql_varchar" > ,
						<cfif isdefined ('arguments.CBid') and len(trim(arguments.CBid)) gt 0>				
							<cfqueryparam value="#arguments.CBid#" cfsqltype="cf_sql_numeric" > ,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined ('arguments.CCHTAdep') and len(trim(arguments.CCHTAdep)) gt 0>	
							<cfqueryparam value="#arguments.CCHTAdep#" cfsqltype="cf_sql_varchar" > ,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined ('arguments.CCHTAsoporte') and len(trim(arguments.CCHTAsoporte)) gt 0>	
							<cfqueryparam value="#arguments.CCHTAsoporte#" cfsqltype="cf_sql_numeric" > ,			
						<cfelse>
							null,
						</cfif>
						<cfqueryparam value="#arguments.CCHTAreintegro#" cfsqltype="cf_sql_numeric" > 
						)
						<cf_dbidentity1 datasource="#session.DSN#" name="inTA" verificar_transaccion="no">
					</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="inTA" returnvariable="LvarCCHTAid" verificar_transaccion="no">
	
<cfset varReturn=#LvarCCHTAid#>	
<!---		<cfset seguimientoT (arguments.CCHTid,arguments.CCHTestado,arguments.CCHTtipo,arguments.CCHTrelacionada,arguments.CCHTtrelacionada)>
--->
<cfreturn #varReturn#>
</cffunction>


<!---                                                                 Cambio para Emision                                                    --->
<cffunction name="sbOP_MovimientosFondeoCCh" access="public">
	<cfargument name="TESOPid" 		type="numeric" 	required="NO">
	<cfargument name="referencia"	type="any" 		required="NO">
	<cfargument name="rsAsientos" 	type="query" 	required="yes">
	<cfargument name="IDcontable" 	type="numeric" 	required="yes">

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESSPtipoDocumento,TESSPid,TESSPtotalPagarOri from TESsolicitudPago where TESOPid=#arguments.TESOPid#
	</cfquery>
	
	<cfif rsSQL.TESSPtipoDocumento eq  8>
		<cfquery name="rsSQL1" datasource="#session.dsn#">
			select min(CCHTid) as CCHTid from STransaccionesProceso where CCHTrelacionada=#rsSQL.TESSPid#
		</cfquery>
		
		<cfquery name="rsSQL2" datasource="#session.dsn#">
			select CCHTtipo,CCHid,Mcodigo,CCHTdescripcion from CCHTransaccionesProceso where CCHTid=#rsSQL1.CCHTid#
		</cfquery>	
		
		<cfquery name="rsCaja" datasource="#session.dsn#">
			select CCHresponsable from CCHica where CCHid=#rsSQL2.CCHid#
		</cfquery>
		
		<!---APERTURA--->
			<cfif isdefined('rsSQL2.CCHTtipo') and len(trim(rsSQL2.CCHTtipo)) gt 0 and rsSQL2.CCHTtipo eq 'APERTURA'>
			
				<cfset seguimientoT(rsSQL1.CCHTid, 'EMITIDO', rsSQL2.CCHTtipo,arguments.TESOPid,'Orden de Pago')>
				
					<cfquery name="rsMonto" datasource="#session.dsn#">
						select TESOPtotalPago from TESordenPago where TESOPid=#arguments.TESOPid#
					</cfquery>
										
				<cfset UP_importes (rsSQL2.CCHid,rsSQL1.CCHTid,rsSQL.TESSPtotalPagarOri)>
				
					<cfquery name="upEstado" datasource="#session.dsn#">
						update CCHTransaccionesProceso set CCHTestado='EMITIDO' where CCHTid=#rsSQL1.CCHTid#
					</cfquery>
					
					<cfquery name="upEstadoc" datasource="#session.dsn#">
						update CCHica set CCHestado='ACTIVA' where CCHid=#rsSQL2.CCHid#
					</cfquery>				
					
				<cfset x =  TAplicadas (rsSQL2.CCHid,rsSQL2.Mcodigo,rsSQL.TESSPid,rsSQL2.CCHTdescripcion,'APLICADO',rsSQL.TESSPtotalPagarOri,rsCaja.CCHresponsable,'T_Apertura',rsSQL1.CCHTid,rsSQL2.CCHTtipo)>
			</cfif>
		
		<!---REINTEGRO--->
			<cfif isdefined('rsSQL2.CCHTtipo') and len(trim(rsSQL2.CCHTtipo)) gt 0 and rsSQL2.CCHTtipo eq 'REINTEGRO'>
				<cfset CambiaEstadoTP(rsSQL1.CCHTid,'EMITIDO','REINTEGRO')>
				<cfset seguimientoT(rsSQL1.CCHTid, 'EMITIDO', rsSQL2.CCHTtipo,arguments.TESOPid,'Orden de Pago')>
				<cfset x =  TAplicadas (rsSQL2.CCHid,rsSQL2.Mcodigo,rsSQL.TESSPid,rsSQL2.CCHTdescripcion,'APLICADO',rsSQL.TESSPtotalPagarOri,rsCaja.CCHresponsable,'T_reintegro',rsSQL1.CCHTid,rsSQL2.CCHTtipo)>
				
				<cfquery name="rsFec" datasource="#session.dsn#">
					select BMfecha as fecha from CCHTransaccionesProceso where CCHTid=#rsSQL1.CCHTid#
				</cfquery>
							
				<cfquery name="rsBus" datasource="#session.dsn#">
					select CCHTAid from CCHTransaccionesAplicadas where Ecodigo=#session.Ecodigo# and CCHTtipo='GASTOS' and CCHTAreintegro < 0 
					and BMfecha < <cfqueryparam value="#rsFec.fecha#" cfsqltype="cf_sql_date">
				</cfquery>
				
				<!---Operaciones Presupuesto--->
				<cfquery name="rsOP" datasource="#session.dsn#">
					select TESOPid from TESsolicitudPago where TESSPid=#rsSQL.TESSPid#
				</cfquery>
				<cfset sbReintegroContaPre(rsSQL2.CCHid,rsFec.fecha,rsOP.TESOPid,rsSQL.TESSPid)>
				
				<cfloop query="rsBus">
					<cfquery name="upReintegro" datasource="#session.dsn#">
						update CCHTransaccionesAplicadas set CCHTAreintegro=#rsSQL1.CCHTid# where CCHTAid=#rsBus.CCHTAid#
					</cfquery>
				</cfloop>
				<cfset UP_importes (rsSQL2.CCHid,rsSQL1.CCHTid,0,0,0,-rsSQL.TESSPtotalPagarOri)>				
			</cfif>
		
		<!---AUMENTO--->
			<cfif isdefined('rsSQL2.CCHTtipo') and len(trim(rsSQL2.CCHTtipo)) gt 0 and rsSQL2.CCHTtipo eq 'AUMENTO'>
				<cfquery name="upEstado" datasource="#session.dsn#">
					update CCHTransaccionesProceso set CCHTestado='EMITIDO' where CCHTid=#rsSQL1.CCHTid#
				</cfquery>
				<cfset seguimientoT(rsSQL1.CCHTid, 'EMITIDO', rsSQL2.CCHTtipo,arguments.TESOPid,'Orden de Pago')>
				<cfset x =  TAplicadas (rsSQL2.CCHid,rsSQL2.Mcodigo,rsSQL.TESSPid,rsSQL2.CCHTdescripcion,'APLICADO',rsSQL.TESSPtotalPagarOri,rsCaja.CCHresponsable,'T_disminusion',rsSQL1.CCHTid,rsSQL2.CCHTtipo)>
				<cfquery name="rsMonto" datasource="#session.dsn#">
					select CCHImontoasignado from CCHImportes where CCHid=#rsSQL2.CCHid# 
				</cfquery>
				<cfset montoA=#rsMonto.CCHImontoasignado#>
				<cfset montoV=#rsSQL.TESSPtotalPagarOri#>
				<cfset montoT=#rsMonto.CCHImontoasignado#+#rsSQL.TESSPtotalPagarOri#>
				
				<cfquery name="upImportes" datasource="#session.dsn#">
					update CCHImportes set
					CCHImontoasignado=#montoT#
					where CCHid=#rsSQL2.CCHid#
				</cfquery>
			</cfif>
		
	</cfif>
</cffunction>


<!---                                                      Cambio para Aplicar Disminucion o Deposito                                            --->
<cffunction name="sbOP_MovimientosDisminucionCCh" access="public">
	<cfargument name="CCHTid" 		type="numeric" 	required="yes">
	
	<cfquery name="rsSQL2" datasource="#session.dsn#">
			select CCHTtipo,CCHid,Mcodigo,CCHTdescripcion from CCHTransaccionesProceso where CCHTid=#arguments.CCHTid#
	</cfquery>
		
	<cfquery name="rsSQLX" datasource="#session.dsn#">
		select sum(CCHDtotal) as montoTotal, sum(CCHDtotalOri) as totalCaja 
		from CCHdepositos where CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">
	</cfquery>
	

	<cfquery name="rsCaja" datasource="#session.dsn#">
			select CCHresponsable from CCHica where CCHid=#rsSQL2.CCHid#
		</cfquery>
		
	<cfset CambiaEstadoTP(arguments.CCHTid,'CONFIRMADO',rsSQL2.CCHTtipo,arguments.CCHTid,'Depósitos de Transaccion')>


	<cfset x =  TAplicadas (rsSQL2.CCHid,rsSQL2.Mcodigo,'',rsSQL2.CCHTdescripcion,'APLICADO',rsSQLX.totalCaja,rsCaja.CCHresponsable,'T_Disminucion',arguments.CCHTid,rsSQL2.CCHTtipo)>
	
	<cfquery name="rsMonto" datasource="#session.dsn#">
		select CCHImontoasignado from CCHImportes where CCHid=#rsSQL2.CCHid# 
	</cfquery>
	<cfset montoA=#rsMonto.CCHImontoasignado#>
	<!---<cfset montoV=#rsSQL.TESSPtotalPagarOri#>--->
	<cfset montoT=#rsMonto.CCHImontoasignado#-#rsSQLX.totalCaja#>
	
	<cfquery name="upImportes" datasource="#session.dsn#">
		update CCHImportes set
		CCHImontoasignado=#montoT#
		where CCHid=#rsSQL2.CCHid#
	</cfquery>
		
	<cfif rsSQL2.CCHTtipo eq 'CIERRE'>
		<cfquery name="rsDesactiva" datasource="#session.dsn#">
			update CCHica set CCHestado='INACTIVA' where CCHid=#rsSQL2.CCHid#
		</cfquery>
	</cfif>
</cffunction>

<!---                                        Ejecucion de Depositos en caso de Disminucion o cierre                                             --->
<cffunction name="sbContabilidadDeposito"  access="public">
<cfargument name="CCHTid" type="numeric" required="yes">
<cftransaction>
	
	<cfquery name="rsMesAuxiliar" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="60">
	</cfquery>

	<cfquery name="rsPeriodoAuxiliar" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="50">
	</cfquery>

	<cfquery name="TCsug" datasource="#session.dsn#">
		select tc.Mcodigo, tc.TCcompra, tc.TCventa
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
		and Mcodigo=(select Mcodigo from CCHica where CCHid=(select CCHid from CCHTransaccionesProceso where CCHTid=#arguments.CCHTid#))
	</cfquery>

	<cfif TCsug.recordcount eq 0>
		<cfset tipoC=1>
	<cfelse>
		<cfset tipoC=#TCsug.TCcompra#>
	</cfif>

	<!---inserta datos en intarc--->
	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" >

	<!---credito caja chica--->
	<cfquery name="rsTC" datasource="#session.dsn#">
		select sum(CCHDtotal) as montoTotal, sum(CCHDtotalOri) as totalCaja 
		from CCHdepositos where CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">
	</cfquery>
	
	
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
			INTORI,INTREL,
			INTDOC,INTREF,
			INTFEC,Periodo, Mes, Ocodigo,
			INTTIP, INTDES, 
			CFcuenta, Ccuenta, 
			Mcodigo, INTMOE, INTCAM, INTMON
			)
		select 
			'TECH',1,
			<cf_dbfunction name="to_char" args="a.CCHcod">,'Transaccion' #LvarCNCT# <cf_dbfunction name="to_char" args="a.CCHcod">,
			'#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsMesAuxiliar.Pvalor#, cf.Ocodigo,
			'C',
			'Transaccion.' #LvarCNCT# <cf_dbfunction name="to_char" args="a.CCHTtipo">  #LvarCNCT# ':' #LvarCNCT# a.CCHTdescripcion,
			d.CFcuenta, 0, 
			d.Mcodigo, 
			#rsTC.montoTotal#, 
			#tipoC#, 
			#rsTC.totalCaja#					
				from  CCHTransaccionesProceso a
					inner join CCHica d
						inner join CFuncional cf
						on cf.CFid=d.CFid
					on 	d.CCHid=a.CCHid									
				where a.CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">
	</cfquery>
	<!---Debitos de banco--->
	<cfquery datasource="#session.dsn#">
		insert into #INTARC# 
			( 
			INTORI,INTREL,
			INTDOC,INTREF,
			INTFEC,Periodo, Mes, Ocodigo,
			INTTIP, INTDES, 
			CFcuenta, Ccuenta, 
			Mcodigo, INTMOE, INTCAM, INTMON
			)
		select 
			'TECH',1,
			<cf_dbfunction name="to_char" args="a.CCHcod">,'Transaccion',
			'#DateFormat(now(),"YYYYMMDD")#', #rsPeriodoAuxiliar.Pvalor#, #rsMesAuxiliar.Pvalor#, cf.Ocodigo,
			'D',
			'Transaccion.'  #LvarCNCT# <cf_dbfunction name="to_char" args="a.CCHTtipo">   #LvarCNCT# ':'  #LvarCNCT# a.CCHTdescripcion,
			null,c.Ccuenta,  
			c.Mcodigo, 
			x.CCHDtotal,
			x.CCHDtipoCambio, 
			round(x.CCHDtotal*x.CCHDtipoCambio,2)
			
				from CCHdepositos x
					inner join CuentasBancos c
					on x.CBid=c.CBid
					inner join CCHTransaccionesProceso a
						inner join CCHica d
							inner join CFuncional cf
							on cf.CFid=d.CFid
						on 	d.CCHid=a.CCHid
					on a.CCHTid=x.CCHTid				
				where x.CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">
	</cfquery>
	<cfquery name="rsSQL1" datasource="#session.dsn#">
		select cf.Ocodigo,a.BMfecha from CCHdepositos x
			inner join CCHTransaccionesProceso a
				inner join CCHica d
					inner join CFuncional cf
					on cf.CFid=d.CFid
				on 	d.CCHid=a.CCHid
				and a.CCHTid=#Arguments.CCHTid#
			on a.CCHTid=x.CCHTid				
		where x.CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">
	</cfquery>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select INTFEC,INTREF from #intarc#
	</cfquery>

	<cfset LvarDescripcion='Pago CCH: #rsSQL.INTREF#'>
	<!--- 5) Ejecutar el Genera Asiento --->
	<cfinvoke component="sif.componentes.CG_GeneraAsiento" returnvariable="retIDcontable" method="GeneraAsiento"
		Oorigen 		= "TECH"
		Eperiodo		= "#rsPeriodoAuxiliar.Pvalor#"
		Emes			= "#rsMesAuxiliar.Pvalor#"
		Efecha			= "#now()#"
		Edescripcion	= "#LvarDescripcion#"
		Edocbase		= "#rsSQL.INTREF#"
		Ereferencia		= "#rsSQL.INTREF#"
		usuario 		= "#session.Usucodigo#"
		Ocodigo 		= "#rsSQL1.OCODIGO#"
		Usucodigo 		= "#session.Usucodigo#"
		debug			= "false"
	/>
	<cfset IDcon=#retIDcontable#>


	<!---Inserto a MLibros--->			
	<cfquery name="rsOPs" datasource="#session.dsn#">
		select d.Ecodigo,d.CBid,d.CCHDreferencia,d.BTid,d.CCHDid,d.CCHDfecha,h.CCHresponsable
			from CCHdepositos d
				inner join CCHTransaccionesProceso l
				inner join CCHica h
				inner join CFuncional f
				on f.CFid=h.CFid
				on h.CCHid=l.CCHid
				on l.CCHTid=d.CCHTid
				inner join CuentasBancos c
				inner join CContables cc
				inner join CtasMayor m
				on m.Ecodigo=cc.Ecodigo
				and m.Cmayor=cc.Cmayor
				on cc.Ccuenta=c.Ccuenta
				on c.CBid=d.CBid
			where d.CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CCHTid#">		
	</cfquery>

	<cfif rsOPs.recordCount EQ 0>
		<cfreturn>
	</cfif>
	<cfset LvarMLids = "">
		<cfloop query="rsOPs">
			<cfquery name="rsName" datasource="#session.dsn#">
				select TESBeneficiario from TESbeneficiario where DEid=#rsOPs.CCHresponsable#
			</cfquery>
			
			<cfset LvarBTid = fnVerificaMLibrosTraeBT (rsOPs.Ecodigo, rsOPs.CBid,rsOPs.CCHDreferencia,rsOPs.BTid)>
			<cfquery datasource="#session.dsn#" name="insert">
				insert into	MLibros
					(
					Ecodigo, 
					Bid, 
					BTid, 
					CBid, 
					Mcodigo, 
					MLfechamov, 
					MLfecha, 
					MLreferencia, 
					MLdocumento, 
					MLdescripcion, 
					MLconciliado, 
					MLtipocambio, 
					MLmonto, 
					MLmontoloc, 
					MLperiodo, 
					MLmes, 
					MLtipomov, 
					IDcontable,
					MLusuario				
					)
				select
					d.Ecodigo, 
					c.Bid,
					d.BTid,
					d.CBid, 
					d.Mcodigo,  
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#rsOPs.CCHDfecha#">,
					'Depósito CCH',
					d.CCHDreferencia,					
					substring('CCH.Transaccion,'  #LvarCNCT# <cf_dbfunction name="to_char" args="l.CCHcod"> #LvarCNCT# ' : a '  #LvarCNCT# '#rsName.TESBeneficiario#',1,65), 
					'S',
					d.CCHDtipoCambio, 
					d.CCHDtotal,
					d.CCHDtotalOri, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPeriodoAuxiliar.Pvalor#">, 
					<cfqueryparam cfsqltype="cf_sql_integer" value=" #rsMesAuxiliar.Pvalor#">, 
					'D',
					#IDcon#	,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usulogin#">					
						from CCHdepositos d
							inner join CCHTransaccionesProceso l
								inner join CCHica h
									inner join CFuncional f
									on f.CFid=h.CFid
								on h.CCHid=l.CCHid
							on l.CCHTid=d.CCHTid
							inner join CuentasBancos c
								inner join CContables cc
									inner join CtasMayor m
									on m.Ecodigo=cc.Ecodigo
									and m.Cmayor=cc.Cmayor
								on cc.Ccuenta=c.Ccuenta
							on c.CBid=d.CBid
						where d.CCHDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOPs.CCHDid#">	
				<cf_dbidentity1 datasource="#session.DSN#" name="insert" verificar_transaccion="no">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" verificar_transaccion="no" returnvariable="LvarMLid">
			<cfset LvarMLids = LvarMLids & LvarMLid & ",">
		</cfloop>
		<cfset sbOP_MovimientosDisminucionCCh(Arguments.CCHTid)>
	</cftransaction>
</cffunction>

<!---                                        Verificar si el deposito no existe ya en el sistema                                             --->
<cffunction name="fnVerificaMLibrosTraeBT" output="false" access="private" returntype="void">
	<cfargument name="Ecodigo"  type="numeric" required="yes">
	<cfargument name="CBid"     type="numeric" required="yes">
	<cfargument name="MLdoc"    type="string" required="yes">
	<cfargument name="BTid"     type="numeric" required="yes">
	
	<cfquery name="rsMLibros" datasource="#session.dsn#">
		select count(1) as cantidad
		  from MLibros
		 where MLdocumento 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MLdoc#">
		   and BTid			= #Arguments.BTid#
		   and CBid 		= #Arguments.CBid#
	</cfquery>
	
	<cfif rsMLibros.cantidad GT 0>
		<cfquery name="rsBTran" datasource="#session.dsn#">
			select BTcodigo, BTdescripcion
			  from BTransacciones 
			 where BTid = #Arguments.BTid#
		</cfquery>
		<cfthrow message="El Documento '#Arguments.MLdoc#' con Transacción '#rsBTran.BTcodigo#=#rsBTran.BTdescripcion#' ya está registrado en Libros Bancarios">
	</cfif>
</cffunction>

</cfcomponent>
