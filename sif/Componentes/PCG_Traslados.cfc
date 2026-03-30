<cfcomponent>
	<cffunction name="ALTATraslado"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	 		type="string"  required="no">
		<cfargument name="Ecodigo" 		 		type="numeric" required="no">
		<cfargument name="Usucodigo" 	 		type="numeric" required="no">
		<cfargument name="FPEEid_origen" 		type="numeric" required="yes">
		<cfargument name="FPEEid_destino" 		type="numeric" required="false" default="#Arguments.FPEEid_origen#">
		<cfargument name="RSpredefined" 		type="query"   required="false">
		<cfargument name="FPEEestado" 			type="string"  required="no" default="2,3,4">
				  
<!---================Creacion de las Variables que no vienen definidas================--->
		<cfif not isdefined('Arguments.Conexion') or NOT LEN(TRIM(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or NOT LEN(TRIM(Arguments.Ecodigo))>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') or NOT LEN(TRIM(Arguments.Usucodigo))>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>
		<cf_dbfunction name="OP_concat"	datasource="#Arguments.Conexion#" returnvariable="_Cat">
<!---===============Validacion y obtencion de datos de la estimacion Origen Enviada===========--->
		<cfquery name="rsEEO" datasource="#Arguments.Conexion#">
			select a.CPPid, a.CFid , b.CFdescripcion, b.Ocodigo, c.CPPanoMesDesde /100 CPCano, c.CPPanoMesDesde - c.CPPanoMesDesde /100 *100 CPCmes,CPPanoMesDesde
				from FPEEstimacion a
					inner join CFuncional b
						on a.CFid = b.CFid 
					inner join CPresupuestoPeriodo c
						on c.CPPid = a.CPPid
			where FPEEid = #Arguments.FPEEid_origen#
		</cfquery>
		<cfif rsEEO.RecordCount EQ 0>
			<cfthrow message="La Estimacion Origen enviada es Incorrecta (FPEEid = #Arguments.FPEEid_origen#)">
		</cfif>
<!---===============Validacion y obtencion de datos de la estimacion Destino Enviada===========--->
		<cfquery name="rsEED" datasource="#Arguments.Conexion#">
			select a.CPPid, a.CFid , b.CFdescripcion, b.Ocodigo, c.CPPanoMesDesde /100 CPCano, c.CPPanoMesDesde - c.CPPanoMesDesde /100 *100 CPCmes,CPPanoMesDesde
				from FPEEstimacion a
					inner join CFuncional b
						on a.CFid = b.CFid 
					inner join CPresupuestoPeriodo c
						on c.CPPid = a.CPPid
			where FPEEid = #Arguments.FPEEid_destino#
		</cfquery>
		<cfif rsEED.RecordCount EQ 0>
			<cfthrow message="La Estimacion Destino enviada es Incorrecta (FPEEid = #Arguments.FPEEid#)">
		</cfif>
<!---============Valida que las dos Estimaciones sean del mismo periodo Presupuestal========--->
	<cfif rsEEO.CPPid NEQ rsEED.CPPid>
		<cfthrow message="Las Estimaciones perteneces a Períodos Presupuestales Distintos">
	<cfelse>
		<cfset LvarCPPid = rsEEO.CPPid>
	</cfif>
<!---==Se obtienen el siguiente Documento para se usado en el traslado===--->
		<cfquery name="rsNumeroDoc" datasource="#Arguments.Conexion#">
			select rtrim(CPDEnumeroDocumento) as CPDEnumeroDocumento
			from CPDocumentoE
			where CPDEid = (
				select max(CPDEid)
				  from CPDocumentoE
				where Ecodigo 		    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and CPDEtipoDocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="T">
			)
		</cfquery>
		<cfif rsNumeroDoc.recordCount EQ 0>
			<cfset numero = 1>
		<cfelse>
			<cfset numero = rsNumeroDoc.CPDEnumeroDocumento + 1>
		</cfif>
<!---==============Verifica cuales cuentas no existen en Presupuesto===================--->
		<cfquery name="rsCtasInexistentes" datasource="#Arguments.Conexion#">
			select Distinct b.CPformato, CF.Ocodigo,
				case d.Ctipo 
					when 'A' then 1 			 <!---=Cuentas de Activos, control Restringido=====================--->
					when 'G' then 1 			 <!---=Cuenta de Gasto, control Restringido=======================---->
					else 0 end as CVPtipoControl <!---=Cuenta de Pasivo, Capitar, Ingreso, Orden, control Abierto=---->
				from FPDEstimacion a
					inner join PCGcuentas b
						 on a.PCGcuenta = b.PCGcuenta
					inner join FPEEstimacion EE
						on EE.FPEEid = a.FPEEid
					inner join CFuncional CF
						on CF.CFid = EE.CFid 
					inner join CtasMayor d
						 on d.Ecodigo =  b.Ecodigo
						and d.Cmayor  = <cf_dbfunction name="sPart" args="b.CPformato,1,4" datasource="#Arguments.Conexion#">
			where a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_origen#">
			and b.CPcuenta is null
			
			union
			
			select Distinct b.CPformato, CF.Ocodigo,
				case d.Ctipo 
					when 'A' then 1 			 <!---=Cuentas de Activos, control Restringido=====================--->
					when 'G' then 1 			 <!---=Cuenta de Gasto, control Restringido=======================---->
					else 0 end as CVPtipoControl <!---=Cuenta de Pasivo, Capitar, Ingreso, Orden, control Abierto=---->
				from FPDEstimacion a
					inner join PCGcuentas b
						 on a.PCGcuenta = b.PCGcuenta
					inner join FPEEstimacion EE
						on EE.FPEEid = a.FPEEid
					inner join CFuncional CF
						on CF.CFid = EE.CFid 
					inner join CtasMayor d
						 on d.Ecodigo =  b.Ecodigo
						and d.Cmayor  = <cf_dbfunction name="sPart" args="b.CPformato,1,4" datasource="#Arguments.Conexion#">
			where a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_destino#">
			and b.CPcuenta is null
		</cfquery>
<!---======Creación de la fecha con la que se va a validar la cuenta Presupuestal=====--->
		<cfquery name="rsFecha" datasource="#Arguments.Conexion#">
			select case 
				when <cf_dbfunction name="now"> < CPPfechaDesde then CPPfechaDesde 
				when <cf_dbfunction name="now"> > CPPfechaHasta then CPPfechaHasta 
				else <cf_dbfunction name="now"> end as value
				from CPresupuestoPeriodo
			where CPPid = #LvarCPPid#
		</cfquery>
<!---===Verifica el formato de una Cuenta de Presupuesto y si no existe lo Genera, o lo incluye en el Período de Presupuesto--->
			<cfloop query="rsCtasInexistentes">
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCPformato" returnvariable="LvarMSG">
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#">
					<cfinvokeargument name="Lprm_CPformato" 		value="#rsCtasInexistentes.CPformato#">
					<cfinvokeargument name="Lprm_Ocodigo" 			value="#rsCtasInexistentes.Ocodigo#">
					<cfinvokeargument name="Lprm_Fecha" 			value="#rsFecha.value#">
					<cfinvokeargument name="Lprm_CPPid" 			value="#LvarCPPid#">
					<cfinvokeargument name="Lprm_CVPtipoControl" 	value="#rsCtasInexistentes.CVPtipoControl#">
					<cfinvokeargument name="Lprm_CVPcalculoControl" value="3"><!---1-Mensual,2-Acumulado,3-Total--->
					<cfinvokeargument name="Lprm_TransaccionActiva" value="true">
					<cfinvokeargument name="Lprm_debug" 			value="false">
					<cfinvokeargument name="Lprm_DSN" 				value="#Arguments.Conexion#">
				</cfinvoke>
				<cfif LvarMSG NEQ "NEW" and LvarMSG NEQ "OLD">
					<cfthrow message="#LvarMSG#">
				</cfif>
			</cfloop>
			<cfquery datasource="#Arguments.Conexion#" name="rsCPcuenta">	
				select c.CPcuenta,  b.PCGcuenta
					from FPDEstimacion a
						inner join PCGcuentas b
							on a.PCGcuenta = b.PCGcuenta
						inner join CPresupuesto c
							on c.CPVid 		= b.CPVid
							and c.Ecodigo 	= b.Ecodigo
							and c.Cmayor 	= <cf_dbfunction name="sPart" args="b.CPformato,1,4">
							and c.CPformato = b.CPformato
				where a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_origen#">
			      and b.CPcuenta is null
				  
				  union 
				  
			  	select c.CPcuenta,  b.PCGcuenta
					from FPDEstimacion a
						inner join PCGcuentas b
							on a.PCGcuenta = b.PCGcuenta
						inner join CPresupuesto c
							on c.CPVid 		= b.CPVid
							and c.Ecodigo 	= b.Ecodigo
							and c.Cmayor 	= <cf_dbfunction name="sPart" args="b.CPformato,1,4">
							and c.CPformato = b.CPformato
				where a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_destino#">
				  and b.CPcuenta is null
			</cfquery>
			<cfloop query="rsCPcuenta">
				<cfquery datasource="#Arguments.Conexion#">	
					update PCGcuentas set CPcuenta = #rsCPcuenta.CPcuenta# where PCGcuenta = #rsCPcuenta.PCGcuenta#
				</cfquery>	
			</cfloop>
<!---======Verifica que todas las cuentas que no existian se hallan creado y Actualizado correctamente==--->
		<cfquery datasource="#Arguments.Conexion#" name="rsCPcuenta">	
			select b.PCGcuenta, b.CFformato
				from FPDEstimacion a
					inner join PCGcuentas b
						on a.PCGcuenta = b.PCGcuenta
			where a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_origen#">
			  and b.CPcuenta is null
			  
			  union 
			  
			select b.PCGcuenta, b.CFformato
				from FPDEstimacion a
					inner join PCGcuentas b
						on a.PCGcuenta = b.PCGcuenta
			where a.FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_destino#">
			  and b.CPcuenta is null
		</cfquery>
		<cfif rsCPcuenta.recordcount GT 0>
			<cfthrow message="No se puedo recuperar la cuenta presupuestal de #rsCPcuenta.recordcount# Cuentas">
		</cfif>
<!---===========Crea el query general con los datos de la estimacion y del Plan de compras=============--->
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CreateQueryGeneral" returnvariable="rsQueryGeneral">
			<cfinvokeargument name="CPPid" 		value="#LvarCPPid#">
			<cfinvokeargument name="FPEEestado" value="#Arguments.FPEEestado#">
			<cfinvokeargument name="Table" 		value="#Request.temp_EFP#">
			<cfinvokeargument name="DropTable" 	value="false">
		</cfinvoke>
		<cfif not isdefined('Arguments.RSpredefined')>
			<cfquery dbtype="query" name="rsTraslado">
				select CPcuenta, Ocodigo, PCGDid, FPDEid,
					(IngresosEstimacion-  
					IngresosPlan) +
					(EgresosEstimacion -  
					EgresosPlan) as CPDDmonto
					
				from rsQueryGeneral
				where FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_origen#">
				
				union 
				
				select  CPcuenta, Ocodigo, PCGDid, FPDEid,
					(IngresosEstimacion-  
				    IngresosPlan) +
					(EgresosEstimacion -  
					EgresosPlan) as CPDDmonto
					
				from rsQueryGeneral
				where FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_destino#">
				
			</cfquery>
		<cfelse>
			<cfquery dbtype="query" name="rsTraslado">
				select rsQueryGeneral.CPcuenta, rsQueryGeneral.Ocodigo, rsQueryGeneral.PCGDid, rsQueryGeneral.FPDEid,
					RSpredefined.MontoTranfer as CPDDmonto
				from rsQueryGeneral, RSpredefined
				where RSpredefined.FPEEid   = rsQueryGeneral.FPEEid
				 and RSpredefined.FPEPid    = rsQueryGeneral.FPEPid
				 and RSpredefined.FPDElinea = rsQueryGeneral.FPDElinea
				 and rsQueryGeneral.FPEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_origen#">
			
				
				union 
				
				select rsQueryGeneral.CPcuenta, rsQueryGeneral.Ocodigo, rsQueryGeneral.PCGDid, rsQueryGeneral.FPDEid,
					   RSpredefined.MontoTranfer as CPDDmonto
				from rsQueryGeneral, RSpredefined
				where RSpredefined.FPEEid    = rsQueryGeneral.FPEEid
				  and RSpredefined.FPEPid    = rsQueryGeneral.FPEPid
				  and RSpredefined.FPDElinea = rsQueryGeneral.FPDElinea
				  and rsQueryGeneral.FPEEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPEEid_destino#">
				
			</cfquery>
		</cfif>
		
<!---==============Obtiene datos del Usuario==================================--->
		 <cfquery name="rsFrom" datasource="#Arguments.Conexion#">
			select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, Pemail1 as correo
			from Usuario a 
				inner join DatosPersonales b 
					 on a.datos_personales = b.datos_personales
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Usucodigo#">
		 </cfquery>
		 <cfif rsFrom.recordcount eq 0 or len(trim(rsFrom.nombre)) eq 0 or len(trim(rsFrom.correo)) eq 0>
			<cf_errorCode	code = "50503" msg = "ERROR AL ENVIAR MAILS: Información personal incompleta.">
		 </cfif>
		 <cfset Lvar_nombrefrom = rsFrom.nombre>
		 <cfset Lvar_correofrom = rsFrom.correo>	
		 <cfset desc = mid('Variacion PCG de #rsEEO.CFdescripcion# al #rsEED.CFdescripcion#',1,80)>
<!---==================Crear el encabezado del Traslado===============================================--->
			<cfquery name="ABC_DocsTraslado" datasource="#Arguments.Conexion#">
				insert into CPDocumentoE (Ecodigo, CPPid, CPDEfechaDocumento, CPCano, CPCmes, CPDEfecha, CPDEtipoDocumento, CPDEnumeroDocumento, CPDEdescripcion, Usucodigo, CFidOrigen, CFidDestino, CPDEtipoAsignacion, CPDEaplicado)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">, 
					<cfqueryparam cfsqltype="cf_sql_date"    value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy', rsFecha.value)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', rsFecha.value)#">,
					<cfqueryparam cfsqltype="cf_sql_date"    value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	 value="T">,
					<cfqueryparam cfsqltype="cf_sql_char" 	 value="#numero#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#desc#" len = 80>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEEO.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEED.CFid#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	 value="2">, <!---Asignacion manual de Montos--->
					0
				)
				<cf_dbidentity1 datasource="#Arguments.Conexion#">
			</cfquery>
			<cf_dbidentity2 datasource="#Arguments.Conexion#" name="ABC_DocsTraslado">
			<cfset CPDEid = ABC_DocsTraslado.identity>
<!---============Creación de cada uno de los detalles del Traslado=============================--->
			<cfloop query="rsTraslado">
				<cfquery name="rsNextDetail" datasource="#Arguments.Conexion#">
					select coalesce(max(CPDDlinea), 0)+1 as linea
					 from CPDocumentoD
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
				</cfquery>
				<cfif rsTraslado.CPDDmonto LT 0>
					<cfset CPDDtipo = -1><!--- Origen --->
				<cfelse>
					<cfset CPDDtipo = 1><!--- Destino --->
				</cfif>
				<cfset CPDDmontoT = rsTraslado.CPDDmonto * CPDDtipo>
				<cfif CPDDmonto NEQ 0>
					<cfquery datasource="#Arguments.Conexion#">
						insert into CPresupuestoControl (Ecodigo,CPPid,CPCano,CPCmes,CPCanoMes,CPcuenta,Ocodigo,BMUsucodigo)
						select #Arguments.Ecodigo#,#LvarCPPid#,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#DatePart('yyyy', rsFecha.value)#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#DatePart('m', rsFecha.value)#">,
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#DateFormat(rsFecha.value, 'yyyymm')#">,
							#rsTraslado.CPcuenta#,#rsTraslado.Ocodigo#,#Arguments.Usucodigo#
						from dual
						where not exists( select 1
											from CPresupuestoControl x
										  where x.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
										    and x.CPPid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCPPid#">
										    and x.CPCano 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy', rsFecha.value)#">
										    and x.CPCmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('m', rsFecha.value)#">
										    and x.CPcuenta 	= #rsTraslado.CPcuenta#
										    and x.Ocodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTraslado.Ocodigo#">
										)
					</cfquery>
<!---==============Inserta cada una de las lineas del traslado=============--->
					<cfquery name="ABC_DocsTraslado" datasource="#Arguments.Conexion#">
							insert INTO CPDocumentoD (Ecodigo, CPDEid, CPDDlinea, CPDDtipo, CPPid, CPCano, CPCmes, CPcuenta, CPDDmonto, CPDDsaldo, Ocodigo, PCGDid, FPDEid)
							select 
								a.Ecodigo, 
								a.CPDEid, 
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsNextDetail.linea#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#CPDDtipo#">,
								a.CPPid, 
								a.CPCano,
								a.CPCmes,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsTraslado.CPcuenta#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CPDDmontoT#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#CPDDmontoT#">,
								b.Ocodigo,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsTraslado.PCGDid#" null="#len(trim(rsTraslado.PCGDid)) eq 0#">,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsTraslado.FPDEid#" null="#len(trim(rsTraslado.FPDEid)) eq 0#">
							from CPDocumentoE a
								inner join CFuncional b
									on a.Ecodigo 	 = b.Ecodigo
								   <cfif CPDDtipo EQ 1>
									and a.CFidDestino = b.CFid
									<cfelse>
									and a.CFidOrigen = b.CFid
									</cfif>
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
							
							and exists(
								select 1
								from CPresupuestoControl x
								where x.Ecodigo = a.Ecodigo
								  and x.CPPid = a.CPPid
								  and x.CPCano = a.CPCano
								  and x.CPCmes = a.CPCmes
								  and x.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTraslado.CPcuenta#">
								  and x.Ocodigo = b.Ocodigo
							)
					</cfquery>
				</cfif>
			</cfloop>
			
<!---==========Valida el Monto Origen o Liberacion================================== --->					 
		 <cfquery name="rsSQLError" datasource="#Arguments.Conexion#">
			select CPDDmonto
			from CPDocumentoD 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			and CPDDtipo = -1
			and CPDDmonto <= 0
		 </cfquery>
		 <cfif rsSQLError.recordcount and rsSQLError.CPDDmonto LTE 0>
			<cf_errorCode	code = "50500" msg = "ERROR AL SOLICITAR LA APROBACION DEL TRASLADO: Monto Origen del traslado incorrecto.">
		 </cfif>
<!---======Se pasan los montos para el Email===========--->
		  <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select sum(CPDDmonto) monto
			from CPDocumentoD 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			and CPDDtipo = -1
		 </cfquery>
		 <cfset Lvar_MontoOrigen = rsSQL.monto>
<!---==========Valida el Monto Destino o Asignación===================================--->					 			
		 <cfquery name="rsSQLError" datasource="#Arguments.Conexion#">
			select CPDDmonto
			from CPDocumentoD 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			and CPDDtipo = 1
			and CPDDmonto <= 0
		 </cfquery>
		 <cfif rsSQLError.recordcount and rsSQLError.CPDDmonto LTE 0>
			<cf_errorCode	code = "50501" msg = "ERROR AL SOLICITAR LA APROBACION DEL TRASLADO: Monto Destino del traslado incorrecto.">
		 </cfif>
<!---======Se pasan los montos para el Email===========--->
		  <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select sum(CPDDmonto) monto
			from CPDocumentoD 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			and CPDDtipo = 1
		 </cfquery>
		 
		 
		 
		 <cfset Lvar_MontoDestino = rsSQL.monto>
<!---================Valida que los montos sean Igual==================================--->		 
		 <cfif Lvar_MontoOrigen neq Lvar_MontoDestino>
			 <cfquery name="a" datasource="#Arguments.Conexion#">
				select *
				from CPDocumentoE 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			 </cfquery>
			  <cfquery name="b" datasource="#Arguments.Conexion#">
				select *
				from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			 </cfquery>
			  <cfquery name="c" datasource="#Arguments.Conexion#">
				select *
				from CPresupuestoControl 
				where Ecodigo = #a.Ecodigo#
				and CPPid = #a.CPPid#
				and CPCano = #a.CPCano#
				and CPCmes = #a.CPCmes#
				<!---and CPcuenta = #b.CPcuenta# 
				and Ocodigo = --->
			 </cfquery>
			<cf_errorCode	code = "50502"
							msg  = "ERROR AL SOLICITAR LA APROBACION DEL TRASLADO: El monto origen y destino son diferentes: Origen @errorDat_1@ - Destino @errorDat_2@"
							errorDat_1="#LSNumberFormat(Lvar_MontoOrigen,',9.00')#"
							errorDat_2="#LSNumberFormat(Lvar_MontoDestino,',9.00')#"
			>
		 </cfif>
<!---====================Información del traslado=======================================--->
			 <cfquery name="rsTrasladoE" datasource="#Arguments.Conexion#">
				select CPDEnumeroDocumento as NOTRASLADO
					, a.CFidOrigen
					, a.CFidDestino
					, b.CFcodigo #_Cat# ' - ' #_Cat# b.CFdescripcion as CFOrigen
					, c.CFcodigo #_Cat# ' - ' #_Cat# c.CFdescripcion as CFDestino
				from CPDocumentoE a
					left outer join CFuncional b
						on a.CFidOrigen = b.CFid
					left outer join CFuncional c
						on a.CFidDestino = c.CFid
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
			 </cfquery>
			 <cfif rsTrasladoE.recordcount eq 0 or len(trim(rsTrasladoE.NOTRASLADO)) eq 0 or len(trim(rsTrasladoE.CFidOrigen)) eq 0 or len(trim(rsTrasladoE.CFidDestino)) eq 0>
				<cf_errorCode	code = "50504" msg = "ERROR AL ENVIAR MAILS: Informacion del Traslado incompleta.">
			 </cfif>
			 <cfset Lvar_CFOrigen 	= rsTrasladoE.CFidOrigen>
			 <cfset Lvar_CFDestino 	= rsTrasladoE.CFidDestino>
			 <cfset NOTRASLADO 		= rsTrasladoE.NOTRASLADO>	
<!---=======Busca el CFReponsables=======--->
				<cfset LvarOrigen = ",#Lvar_CFOrigen#">
				<cfset LvarCFidresp = Lvar_CFOrigen>
				<cfloop condition="LvarCFidresp NEQ ''">
					<cfquery name="rsCForigen" datasource="#Arguments.Conexion#">
						select CFidresp
						  from CFuncional
						 where Ecodigo=#Arguments.Ecodigo#
						   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
					</cfquery>
					<cfset LvarCFidresp = rsCForigen.CFidresp>
					<cfset LvarOrigen = "#LvarOrigen#,#LvarCFidresp#">
				</cfloop>

				<cfset LvarCFidresp = rsTrasladoE.CFidDestino>
				<cfloop condition="LvarCFidresp NEQ '' AND find(',#LvarCFidresp#,',LvarOrigen) EQ 0">
					<cfquery name="rsCFdestino" datasource="#Arguments.Conexion#">
						select CFidresp
						  from CFuncional
						 where Ecodigo=#Arguments.Ecodigo#
						   and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
					</cfquery>
					<cfset LvarCFidresp = rsCFdestino.CFidresp>
				</cfloop>
<!---======Insert la Cadena de autorización de los Documentos de Presupuesto=====--->
				<cfquery datasource="#Arguments.Conexion#">
					insert into CPDocumentoA
					(CPDEid, CFid)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
						,#LvarCFidresp#
					)
				</cfquery>
<!---====Coloca el Encabezado Documentos de Transacciones de Presupuesto como Enviado a aprobar======--->				
				<cfquery datasource="#Arguments.Conexion#">
					update CPDocumentoE
					   set CPDEenAprobacion = 1
						 , CPDEfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
						 , Usucodigo = #Arguments.Usucodigo#
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPDEid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				</cfquery>
 <!---====================Obtiene aprobadores==============================--->
				 <cfquery name="rsAprobadores" datasource="#Arguments.Conexion#">
					select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, 
						Pemail1 as correo
					from CPSeguridadUsuario a 
						left outer join Usuario b 
							inner join DatosPersonales c 
							on b.datos_personales = c.datos_personales 
						on a.Usucodigo = b.Usucodigo
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
					and CPSUaprobacion = 1
				 </cfquery>
				 <cfif rsAprobadores.recordCount EQ 0>
					<cfquery name="rsAprobadores" datasource="#Arguments.Conexion#">
						select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, 
							Pemail1 as correo, 
							CFuresponsable, CFcodigo
						from CFuncional a 
							left outer join Usuario b 
								inner join DatosPersonales c 
								on b.datos_personales = c.datos_personales 
							on a.CFuresponsable = b.Usucodigo
						where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
					</cfquery>
					<cfif len(trim(rsAprobadores.CFuresponsable)) eq 0>
					 	<cf_errorCode	code = "50505"
					 					msg  = "ERROR AL ENVIAR MAILS: No hay Aprobadores definidos en el Centro Funcional '@errorDat_1@' al que se le asignó la aprobación del Traslado"
					 					errorDat_1="#rsAprobadores.CFcodigo#"
					 	>
					</cfif>
					 <cfquery datasource="#Arguments.Conexion#">
						insert into CPSeguridadUsuario
							(Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion)
							values (#Arguments.Ecodigo# , #LvarCFidResp#, #rsAprobadores.CFuresponsable#, 1,1,1,1,1)
					 </cfquery>
				 </cfif>
<!---=================Genera el correo a los aprobadores=======================--->
				 <cfsavecontent variable="MAILTOAPROBADORES">
					<cfinclude template="../presupuesto/operacion/mailtoaprobadores.cfm">
				 </cfsavecontent>
				 <cfloop query="rsAprobadores">
				 	<cfif rsAprobadores.correo NEQ "">
						<cfquery datasource="#Arguments.Conexion#">
							insert into SMTPQueue 
								(SMTPremitente, SMTPdestinatario, SMTPasunto,
								SMTPtexto, SMTPhtml)
							 values(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAprobadores.correo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACION DEL TRASLADO PRESUPUESTARIO #NOTRASLADO#">,
								<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOAPROBADORES#">,
								1)
						</cfquery>
					</cfif>
				</cfloop>
<!---==================Genera el correo al registrador ===================--->
		<cfsavecontent variable="MAILTOREGISTRADOR">
			<cfinclude template="../presupuesto/operacion/mailtoregistrador.cfm">
		</cfsavecontent>
		<cfquery datasource="#Arguments.Conexion#">
			insert into SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			 values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="ASIGNACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADOR#">,
				1)
		</cfquery>
		<cfreturn CPDEid>
	</cffunction>
<!---====Creación de los traslados Masivos, producto del Equilibrio entre entre variones Hacia Arriba y variaciones hacia abajo======--->
	<cffunction name="ALTATrasladoMasivo"  access="public">
		<cfargument name="Conexion" 	 	type="string"  	required="no">
		<cfargument name="Ecodigo" 		 	type="numeric" 	required="no">
		<cfargument name="Usucodigo" 	 	type="numeric" 	required="no">
		<cfargument name="CPPid" 			type="numeric" 	required="yes">
		<cfargument name="FPEEestado" 		type="string" 	required="no" default="2,3,4">
		<cfparam name="Unbalanced" 			default="">
<!---================Creacion de las Variables que no vienen definidas================--->
		<cfif not isdefined('Arguments.Conexion') or NOT LEN(TRIM(Arguments.Conexion))>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo') or NOT LEN(TRIM(Arguments.Ecodigo))>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo') or NOT LEN(TRIM(Arguments.Usucodigo))>
			<cfset Arguments.Usucodigo = session.Usucodigo>
		</cfif>	

<!---======Se valida el Balance de los Niveles de Equilibrio=========--->
		<cfloop query="Request.NivelEquilibrio">
			<cfif Request.NivelEquilibrio.Equilibrio NEQ 0.00>
				<cfset Unbalanced &= Request.NivelEquilibrio.PCDdescripcion &'-'>
			</cfif>
		</cfloop>
		<cfif LEN(TRIM(Unbalanced))>
			<cfthrow message="Los Siguiente Niveles de Finaciamiento no esta Balanceados #mid(Unbalanced,1,len(Unbalanced)-1)#">
		</cfif>

<!---====Inserta todas las Estimaciones que participaron en las variaciones ============--->
		<cfquery dbtype="query" name="preInsert">	
			select FPEEid,FPEPid,FPDElinea,PCDcatid, 
				   EgresosEstimacion - EgresosPlan Monto,
				   'O' Tipo,
				   CFid,
				   PCGcuenta
				from Request.query
			where EgresosEstimacion - EgresosPlan < 0
			
			union 
			
			select FPEEid,FPEPid,FPDElinea,PCDcatid, 
				   EgresosEstimacion - EgresosPlan Monto,
				   'D' Tipo,
				   CFid,
				   PCGcuenta
				from Request.query
			where EgresosEstimacion - EgresosPlan > 0
		 </cfquery>
		 <cfloop query="preInsert">
		 	<cfquery datasource="#Arguments.Conexion#">
				insert into #Request.temp# (FPEEid,FPEPid,FPDElinea,PCDcatid, Monto, Tipo, CFid, PCGcuenta)
				values
				(#preInsert.FPEEid#,#preInsert.FPEPid#,#preInsert.FPDElinea#,#preInsert.PCDcatid#,#preInsert.Monto#,'#preInsert.Tipo#',#preInsert.CFid#,#preInsert.PCGcuenta#)
			</cfquery>
		 </cfloop>
		 
		 <cfquery datasource="#Arguments.Conexion#" name="Pendientes">
		 	select count(1) cantidad from #Request.temp# where Monto <> 0.00
		 </cfquery>

		<cfloop condition="#Pendientes.cantidad# GT 0">
			<cfif Pendientes.cantidad EQ 0>
				<cfbreak>
			</cfif>
<!--- Inserta en la tabla temporal para sacar los maximos montos--->
			<cfquery name = "MaxInsert" datasource="#Arguments.Conexion#">
				insert into #Request.Max# (FPEEid, CFid, Tipo, Monto)
				select FPEEid, CFid, Tipo, sum(ABS(Monto)) as Monto 
					from #Request.temp#
				where Monto <> 0.00 
				group by FPEEid, CFid ,Tipo
			</cfquery>
<!---Se busca el Centro Funcional Origen, va ser el Mayor Origen--->
			<cfquery datasource="#Arguments.Conexion#" name="MaxOrigen" maxrows="1">	
				select max(Monto) Monto from #Request.Max# where Tipo = 'O'
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#" name="Origen" maxrows="1">	
				select Monto, FPEEid , CFid
					from #Request.Max# 
				where Tipo = 'O'
				group by FPEEid, CFid, Monto
				having Monto = #MaxOrigen.Monto#
			</cfquery>
<!---Se busca si hay un Centrol Funcional Destino con ese Monto--->
			<cfquery datasource="#Arguments.Conexion#" name="Destino" maxrows="1">
				select Monto, FPEEid , CFid 
					from #Request.Max# 
				where Tipo = 'D' 
				group by Monto, FPEEid, CFid 
				having Monto = #Origen.Monto# 
			</cfquery>
<!---Si no Hay un centro Funcional con el Monto a Origen, se tomar el mayor Monto Destino--->
			<cfif Destino.recordcount EQ 0>
				<cfquery datasource="#Arguments.Conexion#" name="MaxDestino" maxrows="1">	
					select coalesce(max(Monto),0) Monto from #Request.Max# where Tipo = 'D'
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#" name="Destino" maxrows="1">	
					select Monto, FPEEid , CFid
					from #Request.Max# 
					where Tipo = 'D'
					group by FPEEid, CFid, Monto
					having Monto = #MaxDestino.Monto#
				</cfquery>
			</cfif>
<!---Calculo cuando el Monto Origen es menor al Monto destino--->
			<cfif Origen.Monto LT Destino.Monto>
				<cfset ActiveQuery = true>
				<cfset MontoTranfer = Origen.Monto>
				<cfquery datasource="#Arguments.Conexion#" name="CurrentDestino">
					select FPEEid, FPEPid, FPDElinea, Monto from #Request.temp# where FPEEid = #Destino.FPEEid# and CFid = #Destino.CFid# and Tipo = 'D' and Monto <> 0.00  order by Monto
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#" name="CurrentOrigen">
					select FPEEid, FPEPid, FPDElinea, ABS(Monto) as Monto from #Request.temp# where FPEEid = #Origen.FPEEid# and CFid = #Origen.CFid# and Tipo = 'O' and Monto <> 0.00 
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#">	
					update #Request.temp# set 
						MontoTranfer = Monto, 
						Activa       = 1
					where FPEEid 	 = #Origen.FPEEid# 
					  	and CFid 	 = #Origen.CFid# 
						and Tipo 	 = 'O'
						and Monto 	 <> 0.00 
				</cfquery>	
				<cfset MontoPendiente = Origen.Monto>
				<cfloop query="CurrentDestino">
					<cfif MontoPendiente EQ 0.00>
						<cfbreak>
					</cfif>
					<cfif MontoPendiente GTE CurrentDestino.Monto>
						<cfquery datasource="#Arguments.Conexion#">	
							update #Request.temp# set 
								MontoTranfer = Monto, 
								Activa       = 1 
							where FPEEid     = #CurrentDestino.FPEEid#
							  and FPEPid     = #CurrentDestino.FPEPid#
							  and FPDElinea  = #CurrentDestino.FPDElinea#
							  and Monto 	 <> 0.00 
						</cfquery>	
						<cfset MontoPendiente = MontoPendiente - CurrentDestino.Monto>
					<cfelse>
						<cfquery datasource="#Arguments.Conexion#">	
							update #Request.temp# set 
								MontoTranfer = #MontoPendiente#, 
								Activa       = 1 
							where FPEEid     = #CurrentDestino.FPEEid#
							  and FPEPid     = #CurrentDestino.FPEPid#
							  and FPDElinea  = #CurrentDestino.FPDElinea#
							  and Monto 	 <> 0.00 
						</cfquery>
						<cfset MontoPendiente = 0.00>
					</cfif>	
				</cfloop>
<!---Calculo cuando el Monto Origen es mayor al Monto Destino--->
			<cfelseif Origen.Monto GT Destino.Monto>
				<cfset ActiveQuery = true>
				<cfset MontoTranfer = Destino.Monto>
				<cfquery datasource="#Arguments.Conexion#" name="CurrentOrigen">
					select FPEEid, FPEPid, FPDElinea, ABS(Monto) as Monto from #Request.temp# where FPEEid = #Origen.FPEEid# and CFid = #Origen.CFid# and Tipo = 'O' and Monto <> 0.00 order by Monto
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#" name="CurrentDestino">
					select FPEEid, FPEPid, FPDElinea, ABS(Monto) as Monto from #Request.temp# where FPEEid = #Destino.FPEEid# and CFid = #Destino.CFid# and Tipo = 'D' and Monto <> 0.00 
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#">	
					update #Request.temp# set 
						MontoTranfer = Monto, 
						Activa       = 1
					where FPEEid 	 = #Destino.FPEEid# 
						and CFid 	 = #Destino.CFid# 
						and Tipo 	 = 'D'
						and Monto 	 <> 0.00 
				</cfquery>	
				<cfset MontoPendiente = Destino.Monto>
				<cfloop query="CurrentOrigen">
					<cfif MontoPendiente EQ 0>
						<cfbreak>
					</cfif>
					<cfif MontoPendiente GTE CurrentOrigen.Monto>
						<cfquery datasource="#Arguments.Conexion#">	
							update #Request.temp# set 
								MontoTranfer = Monto, 
								Activa       = 1
							where FPEEid     = #CurrentOrigen.FPEEid#
							  and FPEPid     = #CurrentOrigen.FPEPid#
							  and FPDElinea  = #CurrentOrigen.FPDElinea#
							  and Monto 	 <> 0.00 
						</cfquery>	
						<cfset MontoPendiente = MontoPendiente - CurrentOrigen.Monto>
					<cfelse>
						<cfquery datasource="#Arguments.Conexion#">	
							update #Request.temp# set 
								MontoTranfer = -#MontoPendiente#, 
								Activa 		 = 1
							where FPEEid     = #CurrentOrigen.FPEEid#
							  and FPEPid     = #CurrentOrigen.FPEPid#
							  and FPDElinea  = #CurrentOrigen.FPDElinea#
							  and Monto 	 <> 0.00 
						</cfquery>
						<cfset MontoPendiente = 0>
					</cfif>	
				</cfloop>
<!---Cuando los montos son Iguales no hace Falta pasar la Query, ya que lo va a hacer por el total de los montos--->				
			<cfelse>
				<cfset ActiveQuery = true>
				<cfquery datasource="#Arguments.Conexion#" name="CurrentOrigen">
					select FPEEid, FPEPid, FPDElinea, ABS(Monto) as Monto from #Request.temp# where FPEEid = #Origen.FPEEid# and CFid = #Origen.CFid# and Tipo = 'O' and Monto <> 0
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#" name="CurrentDestino">
					select FPEEid, FPEPid, FPDElinea, ABS(Monto) as Monto from #Request.temp# where FPEEid = #Destino.FPEEid# and CFid = #Destino.CFid# and Tipo = 'D' and Monto <> 0
				</cfquery>
				<cfquery datasource="#Arguments.Conexion#">	
					update #Request.temp# set 
						MontoTranfer = Monto, 
						Activa       = 1
					where FPEEid	 = #Destino.FPEEid# and
						CFid		 = #Destino.CFid# 
						and Tipo 	 = 'D' 
						and Monto 	 <> 0
				</cfquery>	
				<cfquery datasource="#Arguments.Conexion#">	
					update #Request.temp# set 
						MontoTranfer = Monto, 
						Activa       = 1
					where FPEEid 	 = #Origen.FPEEid#
						and CFid     = #Origen.CFid# 
						and Tipo 	 = 'O' 
						and Monto 	 <> 0
				</cfquery>	
			</cfif>
<!---crea el query con las cuentas y los montos a aplicar--->
			<cfquery name="RSpredefined" datasource="#Arguments.Conexion#">
				select FPEEid, FPEPid, FPDElinea, MontoTranfer, Activa from #Request.temp# where Activa = 1
			</cfquery>
<!---se invoca la creacion del Traslado de Dos en Dos --->
			<cfquery datasource="#Arguments.Conexion#">
				delete from #Request.temp_EFP#
			</cfquery>
			<cfinvoke component="sif.Componentes.PCG_Traslados" method="ALTATraslado">
					<cfinvokeargument name="FPEEid_origen"  value="#Origen.FPEEid#">
					<cfinvokeargument name="FPEEid_destino" value="#Destino.FPEEid#">
				<cfif ActiveQuery>
					<cfinvokeargument name="RSpredefined" 			value="#RSpredefined#">
				</cfif>
					<cfinvokeargument name="FPEEestado" value="#Arguments.FPEEestado#">
			</cfinvoke>
<!---cambia los Estados de trabajo para trabajar con el proximo Centro Funcional--->
			<cfquery datasource="#Arguments.Conexion#">
				update #Request.temp#  set Activa = 0
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update #Request.temp#  set Monto = Monto - MontoTranfer
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update #Request.temp#  set MontoTranfer = 0
			</cfquery>
<!---Valida que ya no hallan cuentas que procesar--->			
			 <cfquery datasource="#Arguments.Conexion#" name="Pendientes">
				select count(1) as cantidad from #Request.temp# where Monto <> 0
			 </cfquery>
			 <cfquery datasource="#Arguments.Conexion#">
				delete from #Request.Max#
			 </cfquery>
			 <cfif not isdefined('alto')>
			 	<cfset alto = true>
			 </cfif>
		</cfloop>
		<!--- Elimina tablas temporales--->
		<cfquery datasource="#Arguments.Conexion#">
			drop table #Request.temp#
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			drop table #Request.Max#
		</cfquery>
		<cfquery datasource="#Arguments.Conexion#">
			drop table #Request.temp_EFP#
		</cfquery>
		
	</cffunction>
<!---=================fnRechazarTraslado: rechaza los traslados de un periodo presupuestal=======--->
	<cffunction name="fnRechazarTraslado"  	access="public" returntype="void">
		<cfargument name="CPDEid" 			type="numeric" 	required="yes">
		<cfargument name="CPDEmsgrechazo" 	type="string" 	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="Usucodigo" 		type="string" 	required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">		
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo =session.Usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select CFid
			  from CPDocumentoA
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
		</cfquery>
		
		<cfset LvarCFidresp = rsSQL.CFid>
		<cfquery datasource="#Arguments.Conexion#">
			update CPDocumentoA
			   set CPDArechazado	= 1
				 , CPDAfechaAprueba	= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				 , UsucodigoAprueba	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			  and UsucodigoAprueba is null
		</cfquery>
		<cfquery name="updDoc" datasource="#Arguments.Conexion#">
			update CPDocumentoE
			   set CPDErechazado	= 1
				 , CPDEenAprobacion = 0
				 , CPDEmsgRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CPDEmsgrechazo#">
				 , CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				 , UsucodigoAprueba = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<!--- 
			ENVIAR MAILS:
			1. REGISTRADOR:
				A.	Enviar mail a :
					select Usucodigo from CPDocumentoE
					where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
					and Ecodigo = #Session.Ecodigo#
						"El trasalado se ha rechazado por el CFid=#LvarCFidresp# por fulanito"
		--->
		<!--- Obtiene datos del Usuario --->
		<cf_dbfunction name="OP_concat"	datasource="#Arguments.Conexion#" returnvariable="_Cat">
		<cfquery name="rsFrom" datasource="#Arguments.Conexion#">
			select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, Pemail1 as correo
			from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
		<cfset Lvar_nombrerechazo = rsFrom.nombre>
		<cfquery name="rsCFrechazo" datasource="#Arguments.Conexion#">
			select CFcodigo #_Cat# ' ' #_Cat# CFdescripcion as CFrechazo
			from CFuncional 
			where Ecodigo = #Session.Ecodigo#
			and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
		</cfquery>
		<cfset Lvar_CFrechazo = rsCFrechazo.CFrechazo>
		<cfif rsFrom.recordcount eq 0 or len(trim(rsFrom.nombre)) eq 0 or len(trim(rsFrom.correo)) eq 0>
			<cf_errorCode	code = "50503" msg = "ERROR AL ENVIAR MAILS: Información personal incompleta.">
		</cfif>
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select sum(CPDDmonto) as Monto
			from CPDocumentoD 
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and CPDDtipo = -1
		</cfquery>
		<cfset Lvar_MontoOrigen = rsSQL.Monto>
		<!--- información del registrador --->
		<cfquery name="rsRegistrador" datasource="#Arguments.Conexion#">
			select a.Usucodigo,Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, 
				Pemail1 as correo, CPDEnumeroDocumento as NOTRASLADO, CPPid
			from CPDocumentoE a
				left outer join Usuario b 
					inner join DatosPersonales c 
					on b.datos_personales = c.datos_personales 
				on a.Usucodigo = b.Usucodigo
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<!--- Genera el correo al registrador --->
		<cfsavecontent variable="MAILTOREGISTRADORRECHAZO">
			<!--- TEXTO DEL MAIL--->
			<cfinclude template="../presupuesto/operacion/mailtoregistradorrechazo.cfm">
			<!--- /TEXTO DEL MAIL--->
		</cfsavecontent>
		<!--- Envía el correo al registrador --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into SMTPQueue 
				(SMTPremitente, SMTPdestinatario, SMTPasunto,
				SMTPtexto, SMTPhtml)
			 values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsFrom.correo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRegistrador.correo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="RECHAZO DEL TRASLADO PRESUPUESTARIO #rsRegistrador.NOTRASLADO#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADORRECHAZO#">,
				1)
		</cfquery>
		<!--- /ENVIAR MAILS --->
	</cffunction>
	
<!---=================fnAprobarTraslado: aprueba los traslados de un periodo presupuestal=======--->
	<cffunction name="fnAprobarTraslado"  	access="public" returntype="void">
		<cfargument name="CPDEid" 			type="numeric" 	required="yes">
		<cfargument name="Ecodigo" 			type="numeric" 	required="no">
		<cfargument name="Usucodigo" 		type="string" 	required="no">
		<cfargument name="Conexion" 		type="string"  	required="no">		
		
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo =session.Usucodigo>
		</cfif>
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cf_dbfunction name="OP_concat"	datasource="#Arguments.Conexion#" returnvariable="_Cat">
		<!--- Chequear que al menos haya una partida origen y una partida destino --->
		<cfquery name="rsPartOrigen" datasource="#Arguments.Conexion#">
			select count(1) as cant from CPDocumentoD
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and CPDDtipo = -1
		</cfquery>
		<cfquery name="rsPartDestino" datasource="#Arguments.Conexion#">
			select count(1) as cant from CPDocumentoD
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and CPDDtipo = 1
		</cfquery>
		<cfif not (rsPartOrigen.cant GT 0 and rsPartDestino.cant GT 0)>
			<cf_errorCode	code = "50506" msg = "Debe haber al menos una partidad Origen y una partida Destino">
		</cfif>
			
		<!--- Si el tipo de asignacion es por porcentaje, asegurarse de que el porcentaje sume 100 --->
	
		<!--- Chequear que los montos en partidas origen y destino sean iguales --->
		<cfquery name="rsPartOrigen" datasource="#Arguments.Conexion#">
			select coalesce(sum(CPDDmonto), 0.00) as total from CPDocumentoD
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and CPDDtipo = -1
		</cfquery>
		<cfquery name="rsPartDestino" datasource="#Arguments.Conexion#">
			select coalesce(sum(CPDDmonto), 0.00) as total from CPDocumentoD
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and CPDDtipo = 1
		</cfquery>
		<cfif rsPartOrigen.total NEQ rsPartDestino.total>
			<cf_errorCode	code = "50507" msg = "La suma del monto en partidas origen debe ser igual a suma del monto en partidas destino">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			insert into #Request.intPresupuesto# (
				ModuloOrigen,
				NumeroDocumento,
				NumeroReferencia,
				FechaDocumento,
				AnoDocumento,
				MesDocumento,
				
				NumeroLinea, 
				CPPid, 
				CPCano, 
				CPCmes,
				CPcuenta, 
				Ocodigo,
				TipoMovimiento,
				
				Mcodigo,
				MontoOrigen, 
				TipoCambio, 
				Monto,
				
				NAPreferencia,
				LINreferencia,
				PCGDid,
				PCGDcantidad
			)
			
			select 'PRCO' as ModuloOrigen,
				   a.CPDEnumeroDocumento as NumeroDocumento,
				   case a.CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'TE' then 'Traslado Ext.' else '' end as NumeroReferencia,
				   a.CPDEfechaDocumento as FechaDocumento,
				   a.CPCano as AnoDocumento,
				   a.CPCmes as MesDocumento,
				   
				   b.CPDDlinea as NumeroLinea,
				   b.CPPid,
				   b.CPCano,
				   b.CPCmes,
				   b.CPcuenta,
				   b.Ocodigo,
				   case a.CPDEtipoDocumento when 'R' then 'RP' when 'L' then 'RP' when 'T' then 'T' when 'TE' then 'TE' else '' end as TipoMovimiento,
				   
				   c.Mcodigo,
				   (b.CPDDmonto * CPDDtipo) as MontoOrigen,
				   1.00 as TipoCambio,
				   (b.CPDDmonto * CPDDtipo) as Monto,
				   
				   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as NAPreferencia,
				   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as LINreferencia,
				   b.PCGDid,
				   case PCGDxCantidad when 0 then 1 else round(b.CPDDmonto/d.DPDEcosto,2) end * CPDDtipo as PCGDcantidad
			from CPDocumentoE a 
				inner join CPDocumentoD b 
					on b.Ecodigo = a.Ecodigo 
				   and b.CPDEid = a.CPDEid
				inner join CPresupuestoPeriodo c
					on c.Ecodigo = b.Ecodigo and c.CPPid = b.CPPid
				inner join FPDEstimacion d
					on d.FPDEid = b.FPDEid
				inner join FPEPlantilla EP
					on EP.FPEPid = d.FPEPid
			where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfquery name="rsEncabezado" datasource="#Arguments.Conexion#">
			select CPDEnumeroDocumento, 
				   CPDEfechaDocumento, 
				   case CPDEtipoDocumento when 'R' then 'Provisión' when 'L' then 'Liberación' when 'T' then 'Traslado' when 'TE' then 'Traslado Ext.' else '' end as NumeroReferencia,
				   CPCano, 
				   CPCmes
			from CPDocumentoE
			where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarNAP = Request.LobjControl.ControlPresupuestario('PRCO', rsEncabezado.CPDEnumeroDocumento, rsEncabezado.NumeroReferencia, rsEncabezado.CPDEfechaDocumento, rsEncabezado.CPCano, rsEncabezado.CPCmes)>
		<cfif LvarNAP LT 0>
			<!--- Generó NRP, se hizo ROLLBACK de la transaction y inicia una nueva transaction ---->
			<cfquery name="updDoc" datasource="#Arguments.Conexion#">
				update CPDocumentoE
				   set NRP = #-LvarNAP#
					 , CPDEenAprobacion = 0
					 , CPDEmsgRechazo = 'Rechazo en Control Presupuestario: NRP=#-LvarNAP#'
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				delete from CPDocumentoA
				 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				   and UsucodigoAprueba is null
			</cfquery>
			<!--- ENVIAR MAILS ---->
			<!--- enviar correo al registrador --->
			 <!--- obtiene monto origen --->
			 <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select sum(CPDDmonto) as Monto
				from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				and CPDDtipo = -1
			 </cfquery>
			 <cfset Lvar_MontoOrigen = rsSQL.Monto>
			 <!--- Obtiene datos del Usuario --->
			 <cfquery name="rsFrom" datasource="#Arguments.Conexion#">
				select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, Pemail1 as correo
				from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			 </cfquery>
			 <cfset Lvar_nombrefrom = rsFrom.nombre>
			 <cfset Lvar_correofrom = rsFrom.correo>
			 <!--- consulta el registrador --->
			 <cfquery name="rsRegistrador" datasource="#Arguments.Conexion#">
				select a.Usucodigo, a.CFidDestino, Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, Pemail1 as correo
				from CPDocumentoE a inner join Usuario b inner join DatosPersonales c on b.datos_personales = c.datos_personales on a.Usucodigo = b.Usucodigo
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			 </cfquery>
			 <cfset Lvar_registradornombre = rsRegistrador.nombre>
			 <cfset Lvar_registradorcorreo = rsRegistrador.correo>
			 <cfset Lvar_cfdestino = rsRegistrador.CFidDestino>
			 <!--- Genera el correo al registrador que aprueba --->
			<cfsavecontent variable="MAILTOREGISTRADORNRP">
				<!--- TEXTO DEL MAIL--->
				<cfinclude template="../presupuesto/operacion/mailtoregistradornrp.cfm">
				<!--- /TEXTO DEL MAIL--->
			</cfsavecontent>
			<!--- Envía el correo al registrador que aprueba --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into SMTPQueue 
					(SMTPremitente, SMTPdestinatario, SMTPasunto,
					SMTPtexto, SMTPhtml)
				 values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_registradorcorreo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="RECHAZO DEL TRASLADO PRESUPUESTARIO POR NRP">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADORNRP#">,
					1)
			</cfquery>
			<!--- /ENVIAR MAILS ---->
			<!--- Parar la ejecucion con un cfthrow o un cflocation ---->
            <cfthrow message="Generó NRP=#-LvarNAP#">
		<cfelse>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select CFid
				  from CPDocumentoA
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and UsucodigoAprueba is null
			</cfquery>
			<cfset LvarCFidresp = rsSQL.CFid>
			<cfquery datasource="#Arguments.Conexion#">
				update CPDocumentoA
				   set CPDAaplicado		= 1
					 , CPDAfechaAprueba	= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					 , UsucodigoAprueba	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and UsucodigoAprueba is null
			</cfquery>
			<cfquery name="updDoc" datasource="#Arguments.Conexion#">
				update CPDocumentoE
				   set NAP = #LvarNAP#
					 , CPDEenAprobacion = 0
					 , CPDEaplicado 	= 1
					 , CPDEfechaAprueba = <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					 , UsucodigoAprueba = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
			<!--- 
				ENVIAR MAILS:
				1. REGISTRADOR:
					A.	Enviar mail a :
						select Usucodigo, CFidDestino from CPDocumentoE
						where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
						and Ecodigo = #Session.Ecodigo#
							"El trasalado fue aprobado por el CFid=#LvarCFidresp# por fulanito"
				2. APROBADORES del CFdestino:
						select Usucodigo from CPSeguridadUsuario where CFid=#rsSQL.CFidDestino# and CPSUaprobacion = 1
					A. 	Si no hay Aprobadores en CFid=#rsSQL.CFidDestino#:  
							Se agrega el Responsable del CFid=#rsSQL.CFidDestino# como Aprobador
						fin
						select Usucodigo from CPSeguridadUsuario where CFid=#rsSQL.CFidDestino# and CPSUaprobacion = 1
					B.	Enviar Mails a los Aprobadores en CFid=#LvarCFidresp#:
							"Le llegó plata al CFdestino"
			 --->
			 <!--- enviar correo al registrador --->
			 <!--- obtiene monto origen --->
			 <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select sum(CPDDmonto) as Monto
				from CPDocumentoD 
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				and CPDDtipo = -1
			 </cfquery>
			 <cfif rsSQL.recordcount eq 0 or len(trim(rsSQL.Monto)) eq 0 or rsSQL.Monto LTE 0.00>
				<cf_errorCode	code = "50508" msg = "ERROR EN LA APROBACION DEL TRASLADO: Monto Origen del traslado incorrecto.">
			 </cfif>
			 <cfset Lvar_MontoOrigen = rsSQL.Monto>
			 <!--- Obtiene datos del Usuario --->
			 <cfquery name="rsFrom" datasource="#Arguments.Conexion#">
				select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, Pemail1 as correo
				from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			 </cfquery>
			 <cfset Lvar_nombrefrom = rsFrom.nombre>
			 <cfset Lvar_correofrom = rsFrom.correo>
			 <!--- Obtiene CentroFuncional aprueba --->
			 <cfquery name="rsCFaprueba" datasource="#Arguments.Conexion#">
				select CFcodigo #_Cat# ' ' #_Cat# CFdescripcion as CFaprueba
				from CFuncional 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFidresp#">
			 </cfquery>
			 <cfset Lvar_CFaprueba = rsCFaprueba.CFaprueba>
			 <!--- consulta el registrador --->
			 <cfquery name="rsRegistrador" datasource="#Arguments.Conexion#">
				select a.Usucodigo, a.CFidDestino, Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, Pemail1 as correo
				from CPDocumentoE a inner join Usuario b inner join DatosPersonales c on b.datos_personales = c.datos_personales on a.Usucodigo = b.Usucodigo
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			 </cfquery>
			 <cfset Lvar_registradornombre = rsRegistrador.nombre>
			 <cfset Lvar_registradorcorreo = rsRegistrador.correo>
			 <cfset Lvar_cfdestino = rsRegistrador.CFidDestino>
			 <!--- consulta el Documento --->
			 <cfquery name="rsTrasladoE" datasource="#Arguments.Conexion#">
				select CPDEnumeroDocumento as NOTRASLADO
					, a.CFidOrigen
					, a.CFidDestino
					, b.CFcodigo #_Cat# ' - ' #_Cat# b.CFdescripcion as CFOrigen
					, c.CFcodigo #_Cat# ' - ' #_Cat# c.CFdescripcion as CFDestino
				from CPDocumentoE a
					left outer join CFuncional b
						on a.CFidOrigen = b.CFid
					left outer join CFuncional c
						on a.CFidDestino = c.CFid
				where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CPDEid#">
			 </cfquery>
			 <cfif rsTrasladoE.recordcount eq 0 or len(trim(rsTrasladoE.NOTRASLADO)) eq 0 or len(trim(rsTrasladoE.CFidOrigen)) eq 0 or len(trim(rsTrasladoE.CFidDestino)) eq 0>
				<cf_errorCode	code = "50504" msg = "ERROR AL ENVIAR MAILS: Informacion del Traslado incompleta.">
			 </cfif>
			 <cfset Lvar_CFOrigen = rsTrasladoE.CFOrigen>
			 <cfset Lvar_CFDestino = rsTrasladoE.CFDestino>
			 <cfset NOTRASLADO = rsTrasladoE.NOTRASLADO>
			 <!--- Genera el correo al registrador que aprueba --->
			<cfsavecontent variable="MAILTOREGISTRADORAPRUEBA">
				<!--- TEXTO DEL MAIL--->
				<cfinclude template="../presupuesto/operacion/mailtoregistradoraprueba.cfm">
				<!--- /TEXTO DEL MAIL--->
			</cfsavecontent>
			<!--- Envía el correo al registrador que aprueba --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into SMTPQueue 
					(SMTPremitente, SMTPdestinatario, SMTPasunto,
					SMTPtexto, SMTPhtml)
				 values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_registradorcorreo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO# (ORIGEN)">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOREGISTRADORAPRUEBA#">,
					1)
			</cfquery>
			<!--- Envía el correo a los aprobadores del destino --->
			<!--- Obtiene aprobadores --->
			 <cfquery name="rsAprobadores" datasource="#Arguments.Conexion#">
				select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, 
					Pemail1 as correo
				from CPSeguridadUsuario a 
					left outer join Usuario b 
						inner join DatosPersonales c 
						on b.datos_personales = c.datos_personales 
					on a.Usucodigo = b.Usucodigo
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrasladoE.CFidDestino#">
				and CPSUaprobacion = 1
			 </cfquery>
			 <cfif rsAprobadores.recordCount EQ 0>
				<cfquery name="rsAprobadores" datasource="#Arguments.Conexion#">
					select Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as nombre, 
						Pemail1 as correo, 
						CFuresponsable, CFcodigo
					from CFuncional a 
						left outer join Usuario b 
							inner join DatosPersonales c 
							on b.datos_personales = c.datos_personales 
						on a.CFuresponsable = b.Usucodigo
					where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTrasladoE.CFidDestino#">
					  and CFuresponsable is not null
				</cfquery>
				<cfif rsAprobadores.recordCount EQ 0>
					<cfset LvarNotificarDestino = true>
					<cfquery datasource="#session.dsn#">
						insert into CPSeguridadUsuario
							(Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion)
							values (#Arguments.Ecodigo# , #rsTrasladoE.CFidDestino#, #rsAprobadores.CFuresponsable#, 1,1,1,1,1)
					</cfquery>
				</cfif>
			 </cfif>
			 <!--- Genera el correo a los aprobadores --->
			 <cfsavecontent variable="MAILTOAPROBADORESAPROBADO">
				<!--- TEXTO DEL MAIL--->
				<cfinclude template="../presupuesto/operacion/mailtoaprobadoresaprobado.cfm">
				<!--- /TEXTO DEL MAIL--->
			 </cfsavecontent>
			<!--- Envía el correo a al Destino --->
			<cfif rsAprobadores.recordCount EQ 0>
				<!--- Si no hay aprobadores en el DESTINO se lo envia al ORIGEN --->
				<cfquery datasource="#Arguments.Conexion#">
					insert into SMTPQueue 
						(SMTPremitente, SMTPdestinatario, SMTPasunto,
						SMTPtexto, SMTPhtml)
					 values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_registradorcorreo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO# (No se pudo enviar al Destino)">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOAPROBADORESAPROBADO#">,
						1)
				</cfquery>
			<cfelse>
				<cfquery name="rsParametro" datasource="#Arguments.Conexion#">
					select Pvalor
					from Parametros
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
					  and Pcodigo = 735
					  <!--- Enviar Correo de Aprobado al Centro Funcional Destino --->
				</cfquery>
				<cfif rsParametro.Pvalor neq "0">
					<cfset LvarRegistrador = rsRegistrador.correo>
					<cfloop query="rsAprobadores">
						<cfif rsAprobadores.correo NEQ "">
							<cfif rsAprobadores.correo NEQ LvarRegistrador>
								<cfquery datasource="#session.dsn#">
									insert into SMTPQueue 
										(SMTPremitente, SMTPdestinatario, SMTPasunto,
										SMTPtexto, SMTPhtml)
									 values(
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_correofrom#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsAprobadores.correo#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="APROBACIÓN DEL TRASLADO PRESUPUESTARIO #NOTRASLADO# (DESTINO)">,
										<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MAILTOAPROBADORESAPROBADO#">,
										1)
								</cfquery>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
		<!--- /ENVIAR MAILS --->
		</cfif>
		<!---<cfif LvarNAP LT 0>
			<cflocation url="/cfmx/sif/presupuesto/consultas/ConsNRP.cfm?ERROR_NRP=#abs(LvarNAP)#">
		</cfif>--->
	</cffunction>
	
	<!--- Crear la tablas y querys temporales--->
	<cffunction name="fnCrearTablasTemporales" access="public">
		<cfargument name="CPPid" 					type="numeric" required="yes">
		<cfargument name="FPEEestado" 				type="string"  required="yes">
		<cfargument name="Conexion" 				type="string"  required="no" default="#session.dsn#">
		<cfargument name="CreateQuery" 				type="boolean" required="no" default="true">
		<cfargument name="CreateNivelEquilibrio" 	type="boolean" required="no" default="true">
		<cfargument name="CreateTableTemp" 			type="boolean" required="no" default="true">
		<cfargument name="CreateTableMax" 			type="boolean" required="no" default="true">
		<cfargument name="CreateTableTemp_EFP" 		type="boolean" required="no" default="true">
		
		<cfif Arguments.CreateNivelEquilibrio>
			<cfset Arguments.CreateQuery = true>
		</cfif>
		
		<cfif Arguments.CreateQuery>
			<!--- Obtención de los querys Iniciales --->
			<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CreateQueryGeneral" returnvariable="query">
				<cfinvokeargument name="CPPid" 			value="#Arguments.CPPid#">
				<cfinvokeargument name="FPEEestado" 	value="#Arguments.FPEEestado#">
				<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">
			</cfinvoke>
			<cfset Request.query = query>
		</cfif>
		
		<cfif Arguments.CreateNivelEquilibrio>
			<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="GetNiveles" returnvariable="NivelEquilibrio">
				<cfinvokeargument name="CPPid" 			value="#Arguments.CPPid#">
				<cfinvokeargument name="FPO" 			value="false">
				<cfinvokeargument name="query"			value="#Request.query#">
				<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">
			</cfinvoke>
			<cfset Request.NivelEquilibrio = NivelEquilibrio>
		</cfif>
		
		<!--- Crea la tabla Temporal de trabajo --->
		<cfif Arguments.CreateTableTemp>
			<cf_dbtemp name="temp_BulkTransfer_v1" returnvariable="temp" datasource="#Arguments.Conexion#">
				<cf_dbtempcol name="FPEEid"   			type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="FPEPid"   			type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="FPDElinea"   		type="numeric"	  		mandatory="yes">
				
				<cf_dbtempcol name="PCDcatid"   		type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="Monto"   			type="money"  			mandatory="yes">
				<cf_dbtempcol name="Tipo"   			type="char(1)"  		mandatory="yes">
				<cf_dbtempcol name="CFid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="PCGcuenta"   		type="numeric"  		mandatory="yes">
				
				<cf_dbtempcol name="MontoTranfer"   	type="money"  			mandatory="yes" default="0.00">
				<cf_dbtempcol name="Activa"   			type="bit"  			mandatory="yes" default="0">
				
				<cf_dbtempkey cols="FPEEid,FPEPid,FPDElinea">
			</cf_dbtemp>
			<cfset Request.temp = temp>
		</cfif>
		
		<!---======Crea la tabla Temporal de trabajo para los montos de transferencias============--->
		<cfif Arguments.CreateTableMax>
			<cf_dbtemp name="temp_MaxOrigen_v1" returnvariable="Max" datasource="#Arguments.Conexion#">
				<cf_dbtempcol name="FPEEid"   			type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="CFid"   			type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="Monto"   			type="money"  			mandatory="yes">
				<cf_dbtempcol name="Tipo"   			type="char(1)"  		mandatory="yes">
				<cf_dbtempkey cols="FPEEid,CFid,Tipo">
			</cf_dbtemp>
			<cfset Request.Max = Max>
		</cfif>
		
		<!---===========Tabla para el query general con los datos de la estimacion y del Plan de compras=============--->
		<cfif Arguments.CreateTableTemp_EFP>
			<cf_dbtemp name="temp_EquilibrioFP_v1" returnvariable="temp_EFP" datasource="#Arguments.Conexion#">
				<cf_dbtempcol name="PCDcatid"   		type="numeric"	  		mandatory="yes">
				<cf_dbtempcol name="PCDdescripcion"   	type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="IngresosEstimacion" type="money"  			mandatory="yes">
				<cf_dbtempcol name="EgresosEstimacion"  type="money"  			mandatory="yes">
				<cf_dbtempcol name="IngresosPlan"   	type="money"  			mandatory="yes" default="0.00">
				<cf_dbtempcol name="EgresosPlan"   		type="money"  			mandatory="yes" default="0.00">
				<cf_dbtempcol name="FPCCtipo"   		type="char(1)"  		mandatory="yes">
				<cf_dbtempcol name="CFid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="CFdescripcion"   	type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="FPEEid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="FPEEestado"   		type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="FPAEid"   			type="numeric"  		mandatory="yes">
				<cf_dbtempcol name="FPAEDescripcion"   	type="varchar(255)"  	mandatory="yes">
				<cf_dbtempcol name="CPcuenta"   		type="numeric"  		mandatory="no">
	
				<cf_dbtempcol name="FPEPid"   			type="numeric"  		mandatory="no">
				<cf_dbtempcol name="FPDElinea"   		type="numeric"  		mandatory="no">
				<cf_dbtempcol name="FPDEid"   			type="numeric"  		mandatory="no">
				
				<cf_dbtempcol name="Ocodigo"   			type="numeric"  		mandatory="no">
				<cf_dbtempcol name="PCGDid"   			type="numeric"  		mandatory="no">
				<cf_dbtempcol name="FPTVTipo"   		type="numeric"  		mandatory="no">
				<cf_dbtempcol name="PCGcuenta"   		type="numeric"  		mandatory="yes">
			</cf_dbtemp>
			<cfset Request.temp_EFP = temp_EFP>
		</cfif>
	</cffunction>
</cfcomponent>