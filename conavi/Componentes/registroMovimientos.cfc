<cfcomponent>

	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="Pid" type="numeric" required="yes">
		<cfargument name="PTid" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="fecha" type="string" required="yes">
		<cfargument name="estado" type="numeric" required="no" default="1">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPETransacciones">
			insert into PETransacciones (
				Pid, PTid, DEid, PETfecha, PETestado, Ecodigo, BMUsucodigo
			)
   			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Pid#">,
            	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PTid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(arguments.fecha)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.estado#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.MBUsucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsPETransacciones">
	    <cfreturn #rsPETransacciones.identity#>
	</cffunction>

	<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="PETid" 		type="numeric" 	required="yes">
		<cfargument name="PTid" 		type="numeric" 	required="yes">
		<cfargument name="DEid" 		type="numeric" 	required="yes">
		<cfargument name="fecha" 		type="date" 	required="yes">
		<cfargument name="Ecodigo" 		type="numeric" 	required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" 	type="numeric" 	required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" 	type="string" 	required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPETransacciones">
			update PETransacciones set 
				Pid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Pid#">,
				PTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PTid#">,
				DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">,
				PETfecha=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.fecha)#">,
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
			where PETid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
	    <cfreturn #arguments.PETid#>
	</cffunction>
	
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#">
			delete from PETransacciones
			where PETid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
				and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #arguments.PETid#>
	</cffunction>
	
	<cffunction name="APLICA" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="estado" type="numeric" required="no" default="2">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
			
			<cf_dbfunction name="OP_concat" returnvariable="_Cat">
		
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
				<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"/>
			</cfinvoke>
			<!--- Verificacamos que existan datos --->
			<cfquery name="rsTemp" datasource="#Arguments.Conexion#">
				select enc.PETfecha Dia,tur.PTcodigo turno, pea.Pcodigo Peaje, pea.CFComplemento Complemento, Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra, 1)),0)) Dinero
				from PPrecio pre
					inner join PVehiculos veh
						on pre.PVid = veh.PVid
					inner join Peaje pea
						on pre.Pid = pea.Pid
					inner join Monedas m
					  on m.Mcodigo = pre.Mcodigo
					inner join PETransacciones enc
						inner join PTurnos tur
							on tur.PTid = enc.PTid 
					  on enc.Pid = pea.Pid
					left outer join Htipocambio htc 
						   on htc.Mcodigo = m.Mcodigo 
						   and htc.Ecodigo = #session.Ecodigo# 
						   and enc.PETfecha  BETWEEN htc.Hfecha and  htc.Hfechah
					inner join PDTVehiculos cat
						on cat.PETid = enc.PETid
						and cat.PVid = veh.PVid
				where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PETid#">
					and veh.PVoficial = '1'
				group by enc.PETfecha,tur.PTcodigo, pea.Pcodigo, pea.CFComplemento, cat.PDTVcantidad, pre.PPrecio 
				order by enc.PETfecha,tur.PTcodigo, pea.Pcodigo, pea.CFComplemento, cat.PDTVcantidad, pre.PPrecio
			</cfquery>
			<!--- Verifica que existan registros en la tabla, de lo contrario no genera asiento pero si aplica el movimiento --->
			<cfif rsTemp.RecordCount Eq 0>
				<cftransaction>
					 <!--- Colaca el resgistro en estado aplicado --->
					<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
						update PETransacciones set
							PETestado = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.estado#">,
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
						where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
					</cfquery>
					<!--- Colaca los depositos en estado de espera para aprobar --->
					<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
						update PDTDeposito set
							PDTDestado = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.estado#">,
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
						where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
					</cfquery>
				</cftransaction>
				<cfreturn #arguments.PETid#>
			<cfelse>
				<!--- Verifica los documentos de deposito --->
				<cfquery name="rsTipoTrans" datasource="#session.DSN#">
					select <cf_dbfunction name="to_integer" args="Pvalor"> as BTid from Parametros where Pcodigo = 1800
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfquery datasource="#Session.DSN#" name="rsPDTDeposito">
					select PDTDid, PDTDdocumento, CBid      
					from PDTDeposito pdtd
					where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PETid#"> and PDTDestado = 1
				</cfquery>
				<cfloop query="rsPDTDeposito">
					<cfquery name="rsInsertar" datasource="#session.DSN#">
						select 1
						from MLibros
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and MLdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsPDTDeposito.PDTDdocumento)#">
							and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoTrans.BTid#">
							and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPDTDeposito.CBid#">
					</cfquery>
					
					<cfquery name="rsInsertarEM" datasource="#session.DSN#">
						select 1
						from EMovimientos
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and EMdocumento=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsPDTDeposito.PDTDdocumento)#">
							and BTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoTrans.BTid#">
							and CBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPDTDeposito.CBid#">						
					</cfquery>			
						
					<cfif rsInsertar.recordcount gt 0 or rsInsertarEM.recordcount gt 0 >
						<cfquery name="transaccion" datasource="#session.DSN#">
							select BTdescripcion 
							from BTransacciones
							where BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTipoTrans.BTid#">
						</cfquery>
						<cfquery name="cuenta" datasource="#session.DSN#">
							select CBdescripcion 
							from CuentasBancos
							where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPDTDeposito.CBid#">
                            	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
						</cfquery>	
						<cfset Request.Error.Backs = 1 >
						<cfthrow message="No se puede aplicar el Movimiento pues ya existem un deposito con mismos datos: <br> -Documento: #rsPDTDeposito.PDTDdocumento# <br> -Transacción: #transaccion.BTdescripcion# <br> -Cuenta Bancaria: #cuenta.CBdescripcion#. <br>El proceso fue cancelado">
					</cfif>
				</cfloop>
				<!--- Obtenemos la Ccuenta de la cuenta general de ingresos, ubicada en parametros  del sistema. --->
				<cfquery name="rsCcuenta" datasource="#Arguments.Conexion#">
					select <cf_dbfunction name="to_integer" args="p.Pvalor"> as Ccuenta 
					from Parametros p
					where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  and Pcodigo = 1850
				</cfquery>
				<!--- Obtenemos el complemento para la cuanta de ingresos--->
				<cfquery name="rsPeajeCuentac"datasource="#Arguments.Conexion#">
					select cuentac 
					from Peaje
					where Pid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.selectPeaje#"> and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				
				<!--- Periodo de Auxiliares --->
				<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
					select Pvalor as periodo from Parametros where Pcodigo = 50
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				
				<!--- Mes de Auxiliares --->
				<cfquery name="rsMes" datasource="#Arguments.Conexion#">
					select Pvalor as mes from Parametros where Pcodigo = 60
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				
				
				<!--- Actividad empresarial --->
				<cfset LvarActividad = #rsTemp.Complemento#>
			
				
				<!--- Datos de la transaccion de movimientos --->
				<cfquery name="rsPETransacciones" datasource="#Arguments.Conexion#">
					select pet.PETid, pet.PETfecha, p.Pcodigo, pt.PTcodigo,  cf.CFid, cf.CFcuentaingreso, p.cuentac
					from PETransacciones pet 
					   inner join Peaje p
							inner join CFuncional cf
								on cf.CFid = p.CFid
						on p.Pid = pet.Pid
					   inner join PTurnos pt
						on pt.PTid = pet.PTid
					where pet.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PETid#"> and pet.Ecodigo = #session.Ecodigo#
					order by p.Pcodigo, pt.PTcodigo, pet.PETfecha
				</cfquery>
				
				<cfset fecha= lsDateFormat(rsPETransacciones.PETfecha,'dd/mm/yyyy')>
				<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
					method			= "nextVal"
					returnvariable	= "LvarDocumento"
				
					Ecodigo			= "#session.Ecodigo#"
					ORI				= "PADE"
					REF				= "#rsPETransacciones.Pcodigo#"
					datasource		= "#arguments.Conexion#"
				/>
				<cfquery name="rsD1" datasource="#Arguments.Conexion#">
					insert into #INTARC# ( 
							INTORI, 			
							INTREL, 			
							INTDOC, 
							INTREF, 			
							INTMON, 			
							INTMOE,				
							INTCAM,
							Mcodigo,
							INTTIP,
							INTDES, 			
							INTFEC,
							Periodo, 			
							Mes, 				
							CFcuenta, 			
							Ccuenta,			 			
							Ocodigo,
							CFid)
									
					select 	'PADE',	<!---  Origen --->		
							0,	<!---  Relacion  --->
							'Reg. Mov. ## '#_Cat# <cf_dbfunction name="to_char" args="#LvarDocumento#">,	<!---  Documento --->
							pea.Pcodigo, <!---  Referencia --->
							Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra, 1)),0)),	<!---  Monto Local --->
							sum(coalesce(cat.PDTVcantidad * pre.PPrecio,0)),	<!---  Monto moneda extranjera --->
							coalesce(TCcompra, 1),	<!---  Tipo de cambio --->
							pre.Mcodigo,	<!---  Moneda --->
							'D',	<!---  Tipo de transaccion C ó D  --->
							'Veh. Oficiales ' #_Cat# ':'  #_Cat# pea.Pcodigo #_Cat# ' - '  #_Cat# tur.PTcodigo #_Cat# ' - '  #_Cat# '#fecha#' ,	<!---  Descripcion --->
							<cf_dbfunction name="date_format" args="enc.PETfecha,yyyymmdd">, <!---  Fecha del asiento --->
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">, <!---  Periodo --->
							<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.mes#">,	<!--- Mes  --->
							<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	<!---  Cuenta Financiera --->
							#rsCcuenta.Ccuenta#,	<!---  Cuenta Contable --->
							o.Ocodigo,	<!---  oficina --->
							cf.CFid	<!---  Centro funcional --->
					from PPrecio pre
						inner join PVehiculos veh
							on pre.PVid = veh.PVid
						inner join Peaje pea
							inner join CFuncional cf
								inner join Oficinas o
									on o.Ocodigo = cf.Ocodigo and o.Ecodigo = cf.Ecodigo
							on cf.CFid = pea.CFid and cf.Ecodigo = pea.Ecodigo
						on pre.Pid = pea.Pid
						inner join Monedas m
						  on m.Mcodigo = pre.Mcodigo
						inner join PETransacciones enc
							inner join PTurnos tur
								on tur.PTid = enc.PTid 
						  on enc.Pid = pea.Pid
						left outer join Htipocambio htc 
							   on htc.Mcodigo = m.Mcodigo 
							   and htc.Ecodigo = 1 
							   and enc.PETfecha  BETWEEN htc.Hfecha and  htc.Hfechah
						inner join PDTVehiculos cat
							on cat.PETid = enc.PETid
							and cat.PVid = veh.PVid
							and cat.PDTVcantidad <> 0
					where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PETid#">
						and veh.PVoficial = '1'
					group by enc.PETid, pre.PPrecio,enc.PETfecha,pre.Mcodigo,o.Ocodigo,cf.CFid,pea.Pcodigo,tur.PTcodigo,TCcompra
					order by enc.PETid, pre.PPrecio,enc.PETfecha,pre.Mcodigo,o.Ocodigo,cf.CFid,pea.Pcodigo,tur.PTcodigo,TCcompra
				</cfquery>
				
				<cfquery name="rs" datasource="#Arguments.Conexion#">
					select * from #INTARC#
				</cfquery>
	            <cfif  len(#LvarActividad#) eq 0>
				  <cfthrow message="No se ha definido la actividad para el peaje, asociado al centro funcional">
				</cfif>						
				<!---  Genera el formatdo de la cuenta --->
				<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
				<cfset LvarFormatoCuenta = mascara.AplicarMascara(rsPETransacciones.CFcuentaingreso,rsPETransacciones.cuentac)>
				<cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,REReplace(LvarActividad,"-","","ALL"), '_')>			
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
					<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
					<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
				</cfinvoke>
								
				<!--- Obtienes las cuentas generadas--->
				<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnObtieneCFcuenta" returnvariable="LvarCuentas">
					<cfinvokeargument name="Lprm_CFformato" 		value="#LvarFormatoCuenta#"/>
					<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
					<cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
					<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
				</cfinvoke>

				<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
						<cf_errorCode	code = "50314"
										msg  = "@errorDat_1@ [@errorDat_2@]"
										errorDat_1="#LvarError#"
										errorDat_2="#LvarFormatoCuenta#"
						>
				<cfelse>
					<cfif not len(trim(LvarCuentas.Ccuenta))>
						<cfthrow message="La cuenta contable no esta definida para la Cformato = #LvarFormatoCuenta#, Proceso cancelado.">
					</cfif>				
				
				<cfquery datasource="#Arguments.Conexion#">
						insert into #INTARC# ( 
								INTORI, 			
								INTREL, 			
								INTDOC, 
								INTREF, 			
								INTMON, 
								INTMOE,		
								INTCAM,
								Mcodigo, 	
								INTTIP, 			
								INTDES,
								INTFEC,
								Periodo, 			
								Mes, 				
								CFcuenta,
								Ccuenta,			
								Ocodigo, 			
								CFid)
						select 	'PADE', 	<!---  Origen --->		
								1, 	<!---  Relacion --->
								'Reg. Mov. ## '#_Cat# <cf_dbfunction name="to_char" args="#LvarDocumento#">, <!---  Documento  --->
								pea.Pcodigo, <!---  Referencia --->
								Sum(coalesce(cat.PDTVcantidad * (pre.PPrecio * coalesce(TCcompra, 1)),0)), <!---  Monto en moneda local  --->
								sum(coalesce(cat.PDTVcantidad * pre.PPrecio,0)), <!---  Monto moneda extrajera --->
								coalesce(TCcompra, 1), <!---  Tipo cambio --->
								pre.Mcodigo, <!---  Moneda --->
								'C', <!---  Tipo de transaccion C ó D --->
								'Veh. Oficiales ' #_Cat# ':'  #_Cat# pea.Pcodigo #_Cat# ' - '  #_Cat# tur.PTcodigo #_Cat# ' - '  #_Cat# '#fecha#', 	 <!---  Descripcion --->
								<cf_dbfunction name="date_format" args="enc.PETfecha,yyyymmdd">, <!---  Fecha del asiento --->
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsPeriodo.periodo#">,<!--- Periodo  --->
								<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsMes.mes#">,<!---  Mes --->
								#LvarCuentas.CFcuenta#,<!---  Cuanta Financiera --->
								#LvarCuentas.Ccuenta#,<!---  Cuanta contable --->
								o.Ocodigo,			<!---  Oficina --->
								cf.CFid <!---  Centro Funcional --->
						from PPrecio pre
							inner join PVehiculos veh
								on pre.PVid = veh.PVid
							inner join Peaje pea
								inner join CFuncional cf
									inner join Oficinas o
										on o.Ocodigo = cf.Ocodigo and o.Ecodigo = cf.Ecodigo
								on cf.CFid = pea.CFid and cf.Ecodigo = pea.Ecodigo
							on pre.Pid = pea.Pid
							inner join Monedas m
							  on m.Mcodigo = pre.Mcodigo
							inner join PETransacciones enc
								inner join PTurnos tur
									on tur.PTid = enc.PTid 
							  on enc.Pid = pea.Pid
							left outer join Htipocambio htc 
								   on htc.Mcodigo = m.Mcodigo 
								   and htc.Ecodigo = 1 
								   and enc.PETfecha  BETWEEN htc.Hfecha and  htc.Hfechah
							inner join PDTVehiculos cat
								on cat.PETid = enc.PETid
								and cat.PVid = veh.PVid
								and cat.PDTVcantidad <> 0
						where enc.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PETid#">
							and veh.PVoficial = '1'
						group by enc.PETid, pre.PPrecio,enc.PETfecha,pre.Mcodigo,o.Ocodigo,cf.CFid,pea.Pcodigo,tur.PTcodigo,TCcompra
						order by enc.PETid, pre.PPrecio,enc.PETfecha,pre.Mcodigo,o.Ocodigo,cf.CFid,pea.Pcodigo,tur.PTcodigo,TCcompra
					</cfquery>
				</cfif>
				
	
				<!---  Se lee el consecutivo del documento si este existe, de lo contrario se crea. --->
				<cfquery name="rsPETnumdocumento" datasource="#Arguments.Conexion#">
					select PETnumdocumento 
					from PETransacciones where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PETid#">
					 and not PETnumdocumento is null 
				</cfquery>
			
				<cftransaction>
					<!--- se obtiene el consecutivo del registro --->
					<cfif rsPETnumdocumento.RecordCount eq 0>
						<cfinvoke	component		= "sif.Componentes.OriRefNextVal"
							method			= "nextVal"
							returnvariable	= "LvarDocumento"
						
							Ecodigo			= "#session.Ecodigo#"
							ORI				= "PADE"
							REF				= "#rsPETransacciones.Pcodigo#-#rsPETransacciones.PTcodigo#"
							datasource		= "#arguments.Conexion#"
						/>
						<!--- Guardamos el consecutivo en el registro, en caso de que de error la proxima vez no se genera sino que se lee de BD --->
						<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
							update PETransacciones set
								PETnumdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarDocumento#">
							where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
						</cfquery>
					<cfelse>
						<cfset LvarDocumento=rsPETnumdocumento.PETnumdocumento>
					</cfif>
				</cftransaction>
				<cftransaction>
					<!--- Genera Asiento Contable --->
					<cfinvoke 	component	= "sif.Componentes.CG_GeneraAsiento" 
								method			= "GeneraAsiento"
								returnvariable	= "IDcontable"
								Ecodigo			= "#session.Ecodigo#"
								Oorigen			= "PADE"
								Edocbase		= "#rsPETransacciones.Pcodigo#-#rsPETransacciones.PTcodigo##LvarDocumento#"
								Ereferencia		= "#rsPETransacciones.Pcodigo#"
								Efecha			= "#rsPETransacciones.PETfecha#"
								Eperiodo		= "#rsPeriodo.periodo#"
								Emes			= "#rsMes.mes#"
								Edescripcion	= "'Veh. Oficiales : #rsPETransacciones.Pcodigo# - #rsPETransacciones.PTcodigo# - #fecha#"
								CPNAPIid		= "0"
								Debug			= "false">
					<!--- Colaca el resgistro en estado aplicado --->
					<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
						update PETransacciones set
							PETestado = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.estado#">,
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
						where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
					</cfquery>
					<!--- Colaca los depositos en estado de espera para aprobar --->
					<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
						update PDTDeposito set
							PDTDestado = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.estado#">,
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
						where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
					</cfquery>
				</cftransaction>
			<cfreturn #arguments.PETid#>
		</cfif>
	</cffunction>
	
	<cffunction name="VERIFICARMOVIMIENTO" access="public" returntype="numeric">
		<cfargument name="PTid" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="fecha" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery name="rsExiste" datasource="#arguments.Conexion#">
			select count(1) as existe from PETransacciones
			where
				Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Pid#"> and
				PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PTid#"> and
				DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#"> and 
				PETfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(arguments.fecha)#"> and 
				Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
		<cfreturn #rsExiste.existe#>
	</cffunction>
	
	<cffunction name="ALTA_PDTVehiculos" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="PVid" type="numeric" required="yes">
		<cfargument name="carril" type="numeric" required="yes" default="null">
		<cfargument name="cantidad" type="numeric" required="no" default="null">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTVehiculos">
			insert into PDTVehiculos (
				PETid, PVid, PDTVcarril, PDTVcantidad, BMUsucodigo
			)
   			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PETid#">,
            	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PVid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.carril#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.cantidad#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.MBUsucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsPDTVehiculos">
	    <cfreturn #rsPDTVehiculos.identity#>
	</cffunction>
	
	<cffunction name="CAMBIO_PDTVehiculos" access="public" returntype="numeric">
		<cfargument name="PDTVid" type="numeric" required="yes">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="cantidad" type="numeric" required="no" default="null">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTVehiculos">
			update PDTVehiculos set
				PDTVcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.cantidad#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.MBUsucodigo#">
			where PDTVid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PDTVid#">
				and PETid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PETid#">
		</cfquery>
	    <cfreturn #arguments.PETid#>
	</cffunction>
	
	<cffunction name="BAJA_PDTVehiculos" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="PDTVcarril" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTVehiculos">
			delete from PDTVehiculos
			where PDTVcarril = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PDTVcarril#">
			and PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
		</cfquery>
	    <cfreturn #arguments.PETid#>
	</cffunction>
	
	
	<cffunction name="BAJA_PDTVehiculosConPet" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTVehiculos">
			delete from PDTVehiculos 
			where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PETid#">
		</cfquery>
	    <cfreturn #arguments.PETid#>
	</cffunction>
	
	<cffunction name="ALTA_PDTCerrado" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="carril" type="numeric" required="yes" default="null">
		<cfargument name="horaini" type="numeric" required="no" default="null">
		<cfargument name="horafin" type="numeric" required="no" default="null">
		<cfargument name="comentario" type="string" required="no" default="null">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTCerrado">
			insert into PDTCerrado (
				PETid, PDTCcarril, PDTChoraini, PDThorafin, PDTCcomentario, BMUsucodigo
			)
   			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PETid#">,
            	<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.carril#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.horaini#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.horafin#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.comentario#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.MBUsucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsPDTCerrado">
	    <cfreturn #rsPDTCerrado.identity#>
	</cffunction>
	
	<cffunction name="CAMBIO_PDTCerrado" access="public" returntype="numeric">
		<cfargument name="PDTCid" type="numeric" required="yes">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="carril" type="numeric" required="yes" default="null">
		<cfargument name="horaini" type="numeric" required="no" default="null">
		<cfargument name="horafin" type="numeric" required="no" default="null">
		<cfargument name="comentario" type="string" required="no" default="null">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTCerrado">
			update PDTCerrado set
				PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">,
				PDTCcarril = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carril#">,
				PDTChoraini = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.horaini#">,
				PDThorafin = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.horafin#">,
				PDTCcomentario = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.comentario#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.MBUsucodigo#">
			where PDTCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PDTCid#">
		</cfquery>
	    <cfreturn #arguments.PDTCid#>
	</cffunction>
	
	<cffunction name="BAJA_PDTCerrado" access="public" returntype="numeric">
		<cfargument name="PDTCid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTCerrado">
			delete from PDTCerrado 
			where PDTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PDTCid#">
		</cfquery>
	    <cfreturn #arguments.PDTCid#>
	</cffunction>
	
	<cffunction name="BAJA_PDTCerradoConPETid" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTCerrado">
			delete from PDTCerrado 
			where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
		</cfquery>
	    <cfreturn #arguments.PETid#>
	</cffunction>
	
	<!---  Valida que no se repitan los cierres. --->
	<cffunction name="VERIFICARCIERRE" access="public" returntype="numeric">
		<cfargument name="PDTCid" type="numeric" required="no">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="carril" type="numeric" required="yes">
		<cfargument name="horaini" type="numeric" required="no" default="0">
		<cfargument name="horafin" type="numeric" required="no" default="0">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery name="rsExiste" datasource="#arguments.Conexion#">
			select count(1) as Existe 
			from PDTCerrado pdt 
				inner join PETransacciones pet on pet.PETid = pdt.PETid and pet.Ecodigo=<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
			where
				pdt.PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#"> and
				pdt.PDTCcarril = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carril#"> and
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horaini#"> between pdt.PDTChoraini and pdt.PDThorafin or
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horafin#"> between pdt.PDTChoraini and pdt.PDThorafin)
				<cfif isdefined('arguments.PDTCid')>
					and pdt.PDTCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PDTCid#">
				</cfif>
		</cfquery>
		<cfreturn #rsExiste.Existe#>
	</cffunction>

	<cffunction name="VERIFICARHORACIERRE" access="public" returntype="numeric">
		<cfargument name="PTid" type="numeric" required="yes">
		<cfargument name="horaini" type="numeric" required="yes" default="0">
		<cfargument name="horafin" type="numeric" required="yes" default="0">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery name="rsPTurnos" datasource="#arguments.Conexion#">
			select PThoraini, PThorafin
			from PTurnos       
			where
				PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PTid#">
		</cfquery>
		<cfquery name="rsPermitido" datasource="#arguments.Conexion#">
			select count(1) as Permitido
			from PTurnos       
			where
				PTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PTid#">
				<!---  Valida que el rango ingresado de horas este dentro del establecido en el turno asignado--->
				<cfif rsPTurnos.PThoraini le rsPTurnos.PThorafin> <!---  Si la hora inicial es menor a la final --->
					and <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horaini#"> between PThoraini and PThorafin
					and <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horafin#"> between PThoraini and PThorafin
				<cfelse><!---  Si la hora inicial es mayor a la final --->
					and (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horaini#"> between PThoraini and 1439<!---Catidad de minutos maximos en un dia--->
					or <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horaini#">  between 0 and PThorafin)
					and (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horafin#"> between PThoraini and 1439<!---Catidad de minutos maximos en un dia--->
					or <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.horafin#">  between 0 and PThorafin)
				</cfif>
		</cfquery>
		<cfreturn #rsPermitido.Permitido#>
	</cffunction>
	
	<cffunction name="ALTA_PDTDeposito" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="CBid" type="numeric" required="yes">
		<cfargument name="Mcodigo" type="numeric" required="yes">
		<cfargument name="BTid" type="numeric" required="yes">
		<cfargument name="monto" type="numeric" required="no" default="0">
		<cfargument name="documento" type="string" required="no" default="">
		<cfargument name="descripcion" type="string" required="no" default="">
		<cfargument name="estado" type="numeric" required="no" default="1">
		<cfargument name="tipoCambio" type="numeric" required="no" default="1">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
			insert into PDTDeposito (PETid, CBid , Mcodigo, BTid, PDTDmonto, PDTDdocumento, PDTDdescripcion, PDTDestado, PDTDtipocambio, BMUsucodigo
			)
   			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.PETid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.CBid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.BTid#">,
				<cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.monto#">,
            	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.documento#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#arguments.descripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.estado#">,
				<cfqueryparam cfsqltype="cf_sql_float" 	value="#arguments.tipoCambio#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.MBUsucodigo#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsPDTDeposito">
	    <cfreturn #rsPDTDeposito.identity#>
	</cffunction>
	
	<cffunction name="CAMBIO_PDTDeposito" access="public" returntype="numeric">
		<cfargument name="PDTDid" type="numeric" required="yes">
		<cfargument name="CBid" type="numeric" required="yes">
		<cfargument name="Mcodigo" type="numeric" required="yes">
		<cfargument name="BTid" type="numeric" required="yes">
		<cfargument name="monto" type="numeric" required="no" default="0">
		<cfargument name="documento" type="string" required="no" default="">
		<cfargument name="descripcion" type="string" required="no" default="">
		<cfargument name="estado" type="numeric" required="no" default="1">
		<cfargument name="tipoCambio" type="numeric" required="no" default="1">
		<cfargument name="MBUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
			update PDTDeposito set
				PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">,
				CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CBid#">,
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
				BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BTid#">,
				PDTDmonto = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.monto#">,
				PDTDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.documento#">,
				PDTDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.descripcion#">,
				PDTDestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.estado#">,
				PDTDtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.tipoCambio#">,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MBUsucodigo#">
			where PDTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PDTDid#">
		</cfquery>
	    <cfreturn #arguments.PDTDid#>
	</cffunction>
	
	<cffunction name="BAJA_PDTDeposito" access="public" returntype="numeric">
		<cfargument name="PDTDid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
			delete from  PDTDeposito
			where PDTDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PDTDid#">
		</cfquery>
	    <cfreturn #arguments.PDTDid#>
	</cffunction>
	
	<cffunction name="BAJA_PDTDepositoConPETid" access="public" returntype="numeric">
		<cfargument name="PETid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfquery datasource="#arguments.Conexion#" name="rsPDTDeposito">
			delete from  PDTDeposito
			where PETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.PETid#">
		</cfquery>
	    <cfreturn #arguments.PETid#>
	</cffunction>
	
</cfcomponent>