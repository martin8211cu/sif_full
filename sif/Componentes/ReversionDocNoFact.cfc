<cfcomponent>

	<cffunction name='Reversion' access='public' output='true'>
		<cfargument name='Ecodigo' 			type='numeric' 	required='true'     default="#Session.Ecodigo#">		
		<cfargument name='Modulo'			type='string' 	required='true' 	>
		<cfargument name='debug' 			type="boolean" 	required='false' 	default='false'>
		<cfargument name='conexion' 		type='string' 	required='false' 	default="#Session.DSN#">
		<cfargument name='PeriodoActual' 	type='numeric' 	required='false' 	default="-1">
		<cfargument name='MesActual' 		type='numeric' 	required='false' 	default="-1">
		<cfargument name='ReversarTotal'	type='boolean' 	required='false' 	default="true">
		<cfargument name='Ddocumento' 		type='string' 	required='false'>
		<!---******** REQUERIDOS PARA REVERSION CXC  ********--->
		<cfargument name='CCTcodigo' 		type='string' 	required='false'>
		<cfargument name='CCTCodigoRef' 	type='string' 	required='false'>
		<!---******** REQUERIDOS PARA REVERSION CXP  ********--->
		<cfargument name='IDdocumento' 		type='numeric' 	required='false'>	
		<cfargument name='CPTcodigo'		type='string' 	required='false'>
		<cfargument name='CPTCodigoRef'		type='string' 	required='false'>
		<cfargument name='SNcodigo' 		type='numeric' 	required='false'>
        <cfargument name='CFid' 			type='numeric' 	required='false'>
        <cfargument name='CCuenta' 			type='numeric' 	required='false'>
	
		<!--- 
			Fecha Documento Reversion: 		Fecha Documento Original
			Fecha Documento A Favor:		Ultimo dia del Mes Auxiliares

			Tipo Cambio Documento Nuevo de Reversion:	Tipo Cambio Documento Original

			Tipos Cambios Documento a Favor:	detalle.Monto * (detalle.tcUltRev - encabezado.tc)
					
				Encabezado: TIPO DE CAMBIO ULTIMA REVALUACION DEL DOCUMENTO CORRESPONDIENTE
					Documento Original:		Tipo Cambio Ultima Revaluacion DocOri si se revaluo
					Documento Nuevo:		Tipo Cambio Original DocOri porque se acaba de crear
				Detalle:	ES FACTOR DE CONVERSION, 1 por ser la misma moneda

		--->
		
		<cfif NOT arguments.ReversarTotal>
			<!--- Utilizar Cuenta Puente: Parametro 980 = Cuenta contable de balance para reversin de estimacin --->
			<cfquery datasource="#session.dsn#" name="rsSQL">
				select Pvalor
				  from Parametros
				 where Ecodigo =  #Session.Ecodigo# 
				 and Pcodigo = 980
			</cfquery>
			<cfif rsSQL.recordCount eq 0>
				<cf_errorCode	code = "51388" msg = " No se pudo obtener la cuenta contable de balance para reversión de estimación. Proceso Cancelado!">
			<cfelseif rsSQL.recordCount GT 0  and trim(rsSQL.Pvalor) eq ''>
				<cf_errorCode	code = "51388" msg = " No se pudo obtener la cuenta contable de balance para reversión de estimación. Proceso Cancelado!">
			<cfelse>
				<cfset LvarCFcuentaPuente = rsSQL.Pvalor>
				<cfquery datasource="#session.dsn#" name="rsSQL">
					select Ccuenta
					  from CFinanciera
					 where CFcuenta = #LvarCFcuentaPuente#
				</cfquery>
				<cfif rsSQL.recordCount eq 0>
					<cf_errorCode	code = "51388" msg = " No se pudo obtener la Cuenta Financiera de balance para reversión de estimación. Proceso Cancelado!">
				<cfelse>
					<cfset LvarCcuentaPuente = rsSQL.Ccuenta>
				</cfif>
			</cfif>

			<!--- Utilizar DDtipo=Servicio Codigo=REV-EST-Cx Reversion de Estimacin --->
			<cfif isdefined("arguments.Modulo")  and arguments.Modulo eq 'CXC'>
				<cfquery datasource="#session.dsn#" name="rsSQL">
					select Cid
					  from Conceptos
					 where Ecodigo =  #Session.Ecodigo# 
					 and Ccodigo = 'REV-EST-CC'
				</cfquery>
				<cfif rsSQL.Cid EQ "">
					<cfquery datasource="#session.dsn#" name="rsSQL">
						insert into Conceptos
							(
								Ecodigo,
								Ccodigo,
								Cdescripcion,
								Ctipo
							)
						values (
								#session.Ecodigo#,
								'REV-EST-CC',
								'Cuenta de balance para Reversin de Estimacin CxC',
								'I'
							)
						<cf_dbidentity1 name="rsSQL" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" returnvariable="LvarCidPuente">
				<cfelse>
					<cfset LvarCidPuente = rsSQL.Cid>
				</cfif>
			<cfelse>
				<cfquery datasource="#session.dsn#" name="rsSQL">
					select Cid
					  from Conceptos
					 where Ecodigo =  #Session.Ecodigo# 
					 and Ccodigo = 'REV-EST-CP'
				</cfquery>
				<cfif rsSQL.Cid EQ "">
					<cfquery datasource="#session.dsn#" name="rsSQL">
						insert into Conceptos
							(
								Ecodigo,
								Ccodigo,
								Cdescripcion,
								Ctipo
							)
						values (
								#session.Ecodigo#,
								'REV-EST-CP',
								'Cuenta de balance para Reversin de Estimacin CxP',
								'G'
							)
						<cf_dbidentity1 name="rsSQL" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 name="rsSQL" verificar_transaccion="false" returnvariable="LvarCidPuente">
				<cfelse>
					<cfset LvarCidPuente = rsSQL.Cid>
				</cfif>
			</cfif>
		</cfif>
		
	
		<cfif isdefined("arguments.Modulo")  and arguments.Modulo eq 'CXC'>
			
			<cfquery name="Tipotrans" datasource="#arguments.conexion#">
				select CCTtipo,CCTCodigoRef from CCTransacciones
				where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
				and  Ecodigo = #arguments.Ecodigo#				
			</cfquery>
			
			<cfif not isdefined("arguments.CCTCodigoRef")>
				<cfset arguments.CCTCodigoRef = Tipotrans.CCTCodigoRef >
			</cfif>
			
			<cfquery name="rsSQL" datasource="#arguments.conexion#">
				select count(1) as cantidad
				  from Documentos
				 where Ecodigo 		= #arguments.Ecodigo#
				   and CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTCodigo#">
				   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cf_errorCode	code = "51390"
								msg  = "Documento CxC no existe: @errorDat_1@ - @errorDat_2@"
								errorDat_1="#arguments.CCTCodigo#"
								errorDat_2="#arguments.Ddocumento#"
				>
			</cfif>

		<cfelseif isdefined("arguments.Modulo")  and arguments.Modulo eq 'CXP'>
		
			<cfquery name="Tipotrans" datasource="#arguments.conexion#">
				select CPTtipo,CPTCodigoRef 
				from CPTransacciones
				where CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CPTcodigo#">
				and  Ecodigo = #arguments.Ecodigo#				
			</cfquery>
			
			<cfif not isdefined("arguments.CPTCodigoRef")>
				<cfset arguments.CPTCodigoRef = Tipotrans.CPTCodigoRef >
			</cfif>

			<cfif not isdefined("arguments.SNcodigo") OR  not isdefined("arguments.Ddocumento") >
				<cfquery name="Socio" datasource="#arguments.conexion#">
					select SNcodigo,Ddocumento 
					from EDocumentosCP
					where  IDdocumento  = #arguments.IDdocumento#
					and Ecodigo =  #arguments.Ecodigo#
				</cfquery>
				<cfset arguments.SNcodigo = Socio.SNcodigo >
				<cfset arguments.Ddocumento = Socio.Ddocumento >
			</cfif>

			<cfquery name="rsSQL" datasource="#arguments.conexion#">
				select count(1) as cantidad
				  from EDocumentosCP
				 where Ecodigo		= #arguments.Ecodigo#
				   and IDdocumento	= #arguments.IDdocumento#
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cf_errorCode	code = "51391"
								msg  = "Documento CxP no existe: ID = {@errorDat_1@}"
								errorDat_1="#arguments.IDdocumento#"
				>
			</cfif>

		</cfif>

		<!---******************************************--->
		<!---******** VALIDACION DE ARGUMENTOS ********--->
		<!---******************************************--->
		<cfif isdefined("arguments.PeriodoActual")  and arguments.PeriodoActual eq -1>
			<cfquery name="rsPeriodo" datasource="#arguments.conexion#">
				select p1.Pvalor as value 
				 from Parametros p1 
				where Ecodigo = #arguments.Ecodigo# 
				and Pcodigo = 50
			</cfquery>
			<cfset arguments.PeriodoActual = rsPeriodo.value>
		</cfif>
		<cfif isdefined("arguments.MesActual")  and arguments.MesActual eq -1>
			<cfquery name="rsMes" datasource="#arguments.conexion#">
				select p1.Pvalor as value 
				 from Parametros p1 
				where Ecodigo = #arguments.Ecodigo# 
				and Pcodigo = 60
			</cfquery>	
			<cfset arguments.MesActual = rsMes.value>
		</cfif>
		
		<cfset LvarPrimeroMesAux = createDate (Arguments.PeriodoActual,Arguments.MesActual,1)>
		<cfset LvarUltimoMesAux = createDate (Arguments.PeriodoActual,Arguments.MesActual,DaysInMonth(LvarPrimeroMesAux))>

		<cfif isdefined("arguments.Modulo")  and arguments.Modulo eq 'CXC'>
			<!---********************************--->
			<!---******** REVERSION CXC  ********--->
			<!---********************************--->

				
			<!---***********************************************************************--->
			<!---******** INICIA PROCESO  CXC                                   ********--->
			<!---******** SE CREARA UN NUEVO DOC Y DETALLE POR CADA FACTURA QUE ********--->
			<!---******** SEAN DE TIPO ESTIMACION ES UNA COPIA IDENTICA DE      ********--->
			<!---******** Documentos  --> EDocumentosCxC                        ********--->
			<!---******** DDocumentos --> DDocumentosCxC                        ********--->
			<!---******** Lo unico que cambia es CCTcodigo el cual es           ********--->
			<!---******** sustituido por por el  CCTCodigoRef                   ********--->
			<!---***********************************************************************--->

			<cfset llave =-1>
			<cftransaction>
				<cfquery name="selectEncabezado" datasource="#arguments.conexion#">
					select 
						Ocodigo,                       
						'#arguments.CCTCodigoRef#' as CCTcodigo,                    
						Ddocumento as EDdocumento,
						SNcodigo,
						Mcodigo,                    
						Dtipocambio as EDtipocambio,
						Icodigo,
						Ccuenta,
						Rcodigo,                        
						EDdescuento,                    
						0 as EDporcdesc,                     
						coalesce(
							(
								select sum(coalesce(MontoCalculado,0)) 
								  from ImpDocumentosCxC
								 where Ecodigo		= a.Ecodigo
								   and CCTcodigo	= a.CCTcodigo
								   and Documento	= a.Ddocumento
							)
						,0) as EDimpuesto,
						Dtotal as EDtotal,
						case when Dfecha > <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
							then 
								 Dfecha 
							else 
								<cfqueryparam cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#">
							end as EDfecha,
						Dtref as EDtref,
						Ddocref as EDdocref,
						0 as EDselect,
						case when Dvencimiento > <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
							then 
								 Dvencimiento
							else 
								<cfqueryparam cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#">
							end as EDvencimiento,
						0 as Interfaz,
						null as EDreferencia,
						DEidVendedor,                   
						DEidCobrador,
						id_direccionFact,id_direccionEnvio, 
						CFid, 
						DEdiasVencimiento,              
						DEordenCompra,                  
						DEnumReclamo,                   
						DEobservacion,                  
						DEdiasMoratorio,
						EDtipocambioVal,
						EDtipocambioFecha
					from HDocumentos a	
					where a.Ecodigo = #arguments.Ecodigo#
						and  a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
						and  a.Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
				</cfquery>
				<cfquery name="insertEncabezado" datasource="#arguments.conexion#">
					insert into EDocumentosCxC(
						Ecodigo,                        
						Ocodigo,                        
						CCTcodigo,                      
						EDdocumento,                    
						SNcodigo,                       
						Mcodigo,                        
						EDtipocambio,                   
						Icodigo,                        
						Ccuenta,                        
						Rcodigo,                        
						EDdescuento,                    
						EDporcdesc,                     
						EDimpuesto,                     
						EDtotal,                        
						EDfecha,                        
						EDtref,                         
						EDdocref,                       
						EDusuario,                     
						EDselect,                       
						EDvencimiento,                  
						Interfaz,                       
						EDreferencia,                   
						DEidVendedor,                   
						DEidCobrador,                   
						id_direccionFact,               
						id_direccionEnvio,              
						CFid,                           
						DEdiasVencimiento,              
						DEordenCompra,                  
						DEnumReclamo,                   
						DEobservacion,                  
						DEdiasMoratorio,                
						EDtipocambioVal,
						EDtipocambioFecha,
						BMUsucodigo
					)
					VALUES(
						#session.Ecodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.Ocodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectEncabezado.CCTcodigo#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectEncabezado.EDdocumento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.SNcodigo#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.Mcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectEncabezado.EDtipocambio#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectEncabezado.Icodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.Ccuenta#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectEncabezado.Rcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectEncabezado.EDdescuento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectEncabezado.EDporcdesc#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectEncabezado.EDimpuesto#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectEncabezado.EDtotal#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDfecha#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectEncabezado.EDtref#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectEncabezado.EDdocref#"          voidNull>,
					   #session.Usucodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.EDselect#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDvencimiento#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectEncabezado.Interfaz#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectEncabezado.EDreferencia#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.DEidVendedor#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.DEidCobrador#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.id_direccionFact#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.id_direccionEnvio#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.CFid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.DEdiasVencimiento#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectEncabezado.DEordenCompra#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectEncabezado.DEnumReclamo#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectEncabezado.DEobservacion#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.DEdiasMoratorio#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectEncabezado.EDtipocambioVal#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDtipocambioFecha#" voidNull>,
					   #session.Usucodigo#
				)
					  
					<cf_dbidentity1 datasource="#arguments.conexion#" verificar_transaccion ="FALSE">
				</cfquery>
				 <cf_dbidentity2  datasource="#arguments.conexion#" name="insertEncabezado" verificar_transaccion ="FALSE">
				<cfset llave =  insertEncabezado.identity>

				<cfquery name="insertDetalle" datasource="#arguments.conexion#">
					insert into DDocumentosCxC (
						Ecodigo, 
						EDid, 

						DDtipo,
						Cid, 
						Aid, 
						Ccuenta,

						Alm_Aid,
						DDdescripcion, 
						DDdescalterna, 
						Dcodigo, 
						DDcantidad, 
						DDpreciou, 
						DDdesclinea,
						DDporcdesclin,
						DDtotallinea,
						Icodigo,
						CFid,
						DocrefIM,
						CCTcodigoIM,
						cantdiasmora,
						OCid,
						OCTid,
						OCIid,
						BMUsucodigo)
					select 
						#arguments.Ecodigo#,
						#llave#,

						<cfif arguments.ReversarTotal>	<!---******** Reversar Total ********--->
							DDtipo,
							case when DDtipo = 'S' then DDcodartcon end,			<!--- Cid --->
							case when DDtipo in ('A','O') then DDcodartcon end,		<!--- Aid ---> 
							<cfif isdefined("arguments.CCuenta")  and arguments.CCuenta neq 0>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CCuenta#">,
                            <cfelse>
                                Ccuenta,
                            </cfif>    
						<cfelse>						<!---******** Reversar utilizando cuenta puente  ********--->
							'S',
							#LvarCidPuente#,										<!--- Cid --->
							null,													<!--- Aid --->                 
							#LvarCcuentaPuente#,
						</cfif>

						Alm_Aid,                    								<!--- Alm_Aid --->
						DDescripcion,                  
						DDdescalterna,
						Dcodigo,
						DDcantidad,
						DDpreciou,
						DDdesclinea,
						0,
						DDtotal,
						Icodigo,
                        <cfif isdefined("arguments.CFid")  and arguments.Cfid neq 0>
                        	<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CFid#">,
                        <cfelse>
							CFid, 
                        </cfif>
						DocrefIM,
						CCTcodigoIM,
						cantdiasmora,
						OCid,
						OCTid,
						OCIid,
						#Session.Usucodigo#
					from HDDocumentos
					where Ecodigo = #arguments.Ecodigo#
					and   CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
					and   Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
				</cfquery>
				<cftransaction action="commit" />
			</cftransaction>
			<!---***********************************************************************--->
			<!---******** UNA VEZ CREADO ESTOS DOCUMENTOS SE APLICAN            ********--->
			<!---***********************************************************************--->
			<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
						method="PosteoDocumento"
						EDid = "#llave#"
						Ecodigo = "#Session.Ecodigo#"
						usuario = "#Session.usuario#"
						debug = "N"
			/>
			
			<cfif arguments.debug>
				<cfquery name="regposteado" datasource="#arguments.conexion#">
					select * from HDDocumentos
					where Ecodigo = #arguments.Ecodigo#
					and   CCTcodigo = '#arguments.CCTCodigoRef#'
					and   Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
				</cfquery>
				<cf_dump var="#regposteado#">
			</cfif>

			<!---***********************************************************************--->
			<!---******** UNA VEZ POSTEADOS                                     ********--->
			<!---******** SE CARGAN LAS TABLAS EFavor,DFavor                    ********--->
			<!---******** Y se postea para hacer la aplicacion de doc. afavor   ********--->
			<!---***********************************************************************--->
			
			<cfif Tipotrans.CCTtipo eq 'D'> <!--- tipo de documentos original (No Fac) --->
				<!--- Documento Nuevo es a favor --->
				<cfset LvarCCTcodigo 	= arguments.CCTCodigoRef>

				<!--- Documento Viejo es normal --->
				<cfset LvarCCTcodigoRef	= arguments.CCTCodigo>
			<cfelse>
				<!--- Documento Viejo es a favor --->
				<cfset LvarCCTcodigo	= arguments.CCTCodigo>

				<!--- Documento Nuevo es normal --->
				<cfset LvarCCTcodigoRef	= arguments.CCTCodigoRef>
			</cfif>					

			<cfquery name="insertEFavor" datasource="#arguments.conexion#">
				insert into  EFavor (
					Ecodigo, 
					CCTcodigo, 
					Ddocumento, 
					SNcodigo, 
					Mcodigo, 
					EFtipocambio, 
					EFtotal, 
					EFselect, 
					Ccuenta,  
					EFfecha, 
					EFusuario,
					CFid,
					BMUsucodigo)
				select 
					Ecodigo,
					CCTcodigo, 
					Ddocumento,
					SNcodigo,
					Mcodigo,
					coalesce(Dtcultrev,Dtipocambio),
					Dsaldo,
					0,
					Ccuenta,
					<cfqueryparam value="#LvarPrimeroMesAux#" cfsqltype="cf_sql_date">,  <!--- Fecha Primer Dia Mes Aux --->
					'#Session.usuario#',
					CFid,
					#Session.Usucodigo#
				  from Documentos a	
				 where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#arguments.Ecodigo#">
				   and a.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char"		value="#LvarCCTcodigo#">
				   and a.Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char"		value="#arguments.Ddocumento#">
			</cfquery>
			<cfquery name="insertDFavor" datasource="#arguments.conexion#">
				insert into DFavor (
					Ecodigo,
					CCTcodigo,
					Ddocumento,          
					CCTRcodigo,
					DRdocumento,
					SNcodigo,
					DFmonto,
					Ccuenta,          
					Mcodigo,
					DFtotal,
					DFmontodoc,
					DFtipocambio,
					CFid,
					BMUsucodigo)
				select 
					Ecodigo,
					<cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarCCTcodigo#">,
					Ddocumento,
					<cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarCCTcodigoRef#">,
					Ddocumento,
					SNcodigo,
					Dtotal,
					<cfif isdefined("arguments.CCuenta")  and arguments.CCuenta neq 0>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CCuenta#">,
                    <cfelse>
                        Ccuenta,
                    </cfif>    
					Mcodigo,
					Dtotal,
					Dtotal,
					1, 
					<cfif isdefined("arguments.CFid")  and arguments.CFid neq 0>
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.CFid#">,
                    <cfelse>
                        CFid, 
                    </cfif>
					#Session.Usucodigo#
				  from Documentos a	
				 where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#arguments.Ecodigo#">
				   and a.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#LvarCCTcodigo#">
				   and a.Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#arguments.Ddocumento#">
			</cfquery>

			<cfif arguments.debug>
				<cfquery name="insertEFavor" datasource="#arguments.conexion#">
					select * from EFavor
					where Ecodigo = #arguments.Ecodigo#
					and   CCTcodigo = '#arguments.CCTCodigoRef#'
					and   Ddocumento= '#arguments.Ddocumento#'
				</cfquery>
				<cfquery name="insertDFavor" datasource="#arguments.conexion#">
					select * from DFavor
					where Ecodigo = #arguments.Ecodigo#
					and   CCTcodigo = '#arguments.CCTCodigoRef#'
					and   Ddocumento= '#arguments.Ddocumento#'
					and   CCTRcodigo= '#arguments.CCTcodigo#'
					and   DRdocumento= '#arguments.Ddocumento#'
				</cfquery>
				Encabezado EFavor <br>
				<cfdump var="#insertEFavor#">
				Encabezado DFavor <br>
				<cfdump var="#insertEFavor#">
			</cfif> 
            <cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
                        method = "CC_PosteoDocsFavorCxC"
                        Ecodigo    = "#arguments.Ecodigo#"
                        CCTcodigo  = "#LvarCCTcodigo#"
                        Ddocumento = "#arguments.Ddocumento#"
                        usuario    = "#Session.usuario#"
                        Usucodigo  = "#Session.usucodigo#"
                        fechaDoc   = "S"
                        debug      = "NO"
            />
		<cfelseif isdefined("arguments.Modulo")  and arguments.Modulo eq 'CXP'>
			<!---********************************--->
			<!---******** REVERSION CXP  ********--->
			<!---********************************--->
	
			<!---***********************************************************************--->
			<!---******** INICIA PROCESO    CXP                                 ********--->
			<!---******** SE CREARA UN NUEVO DOC Y DETALLE POR CADA FACTURA QUE ********--->
			<!---******** SEAN DE TIPO ESTIMACION ES UNA COPIA IDENTICA DE      ********--->
			<!---******** EDocumentosCP  --> EDocumentosCxP                     ********--->
			<!---******** DDocumentosCP --> DDocumentosCxP                      ********--->
			<!---******** Lo unico que cambia es CCTcodigo el cual es           ********--->
			<!---******** sustituido por por el  CCTCodigoRef                   ********--->
			<!---***********************************************************************--->
			<cftransaction>
				<cfquery name="selectEncabezado" datasource="#arguments.conexion#">
					select 
						'#arguments.CPTCodigoRef#' as CPTcodigo,
						Ddocumento as EDdocumento, 
						Mcodigo,                     
						SNcodigo,
						Icodigo,                        
						Ocodigo,                        
						Ccuenta,                        
						Rcodigo,                        
						CFid,                           
						id_direccion,                   
						Dtipocambio as EDtipocambio, 
						coalesce(
							(
								select sum(coalesce(MontoCalculado,0)) 
								  from ImpDocumentosCxP
								 where IDdocumento	= HEDocumentosCP.IDdocumento
								   and Ecodigo     = HEDocumentosCP.Ecodigo
							)
						,0) as EDimpuesto,
						0 as EDporcdescuento,                
						EDdescuento,                   
						Dtotal as EDtotal,                         
						case when Dfecha > <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
							then 
								Dfecha 
							else 
								<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
							end as EDfecha,	
						EDusuario,
						
						0 as EDselect,
						0 as Interfaz,
						case when Dfecha > <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
							then 
								Dfecha 
							else 
								<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
							end as EDvencimiento,
						Dfechaarribo as EDfechaarribo,
						  
						EDtipocambioVal,
						EDtipocambioFecha,
						TESRPTCid
						                  
					from HEDocumentosCP
					where Ecodigo = #arguments.Ecodigo#
					and  IDdocumento =	#arguments.IDdocumento#
				</cfquery>
				<cfquery name="insertEncabezado" datasource="#arguments.conexion#">
					insert into EDocumentosCxP (
						Ecodigo,                       
						CPTcodigo,                      
						EDdocumento,                    
						Mcodigo,                        
						SNcodigo,                       
						Icodigo,                        
						Ocodigo,                        
						Ccuenta,                        
						Rcodigo,                        
						CFid,                           
						id_direccion,                   
						EDtipocambio,                   
						EDimpuesto,                     
						EDporcdescuento,                
						EDdescuento,                   
						EDtotal,                        
						EDfecha,                        
						EDusuario,                      
						EDselect,                       
						Interfaz,                       
						EDvencimiento,                  
						EDfechaarribo,                  
						EDtipocambioVal,
						EDtipocambioFecha,
						BMUsucodigo,                    
						TESRPTCid                      
					)
					VALUES(
					   #session.Ecodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectEncabezado.CPTcodigo#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectEncabezado.EDdocumento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.Mcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.SNcodigo#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#selectEncabezado.Icodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.Ocodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.Ccuenta#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectEncabezado.Rcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.CFid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.id_direccion#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectEncabezado.EDtipocambio#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectEncabezado.EDimpuesto#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectEncabezado.EDporcdescuento#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectEncabezado.EDdescuento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectEncabezado.EDtotal#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDfecha#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#selectEncabezado.EDusuario#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectEncabezado.EDselect#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectEncabezado.Interfaz#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDvencimiento#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDfechaarribo#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#selectEncabezado.EDtipocambioVal#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectEncabezado.EDtipocambioFecha#" voidNull>,
					   #session.Usucodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectEncabezado.TESRPTCid#"         voidNull>
				)
									
					<cf_dbidentity1 datasource="#arguments.conexion#" > 
				</cfquery>
				<cf_dbidentity2  datasource="#arguments.conexion#" name="insertEncabezado">
				<cfset llave =  insertEncabezado.identity>
	
				<cfquery name="insertDetalle" datasource="#arguments.conexion#">
					insert into DDocumentosCxP  (
						Ecodigo,                        
						IDdocumento,                    

						DDtipo,                         
						Cid,                            
						Aid,                            
						Ccuenta,                        

						Alm_Aid,                        
						Dcodigo,                        
						DOlinea,                        
						CFid,                          
						DDdescripcion,                  
						DDdescalterna,                  
						DDcantidad,                     
						DDpreciou,                      
						DDdesclinea,                    
						DDporcdesclin,                  
						DDtotallinea,                   
						BMUsucodigo,                    
						Icodigo,                        
						Ucodigo,
						
						OCid, OCCid,
						OCTtipo, OCTtransporte, OCTfechaPartida, OCTobservaciones
					)               
					select 
						#arguments.Ecodigo#,
						#llave#,

						<cfif arguments.ReversarTotal>	<!---******** Reversar Total ********--->
							DDtipo,  
							case when DDtipo = 'S' then DDcoditem end,				<!--- Cid --->
							case when DDtipo in ('A','T','O') then DDcoditem end,   <!--- Aid --->                 
							Ccuenta,
						<cfelse>						<!---******** Reversar utilizando cuenta puente  ********--->
							'S',
							#LvarCidPuente#,										<!--- Cid --->
							null,													<!--- Aid --->                 
							#LvarCcuentaPuente#,
						</cfif>

						Aid,                            							<!--- Alm_Aid --->
						Dcodigo,                        
						DOlinea,
						CFid,
						DDescripcion,                  
						DDdescalterna,
						DDcantidad,                     
						DDpreciou,                      
						DDdesclinea,
						0,	
						DDtotallin,
						#Session.Usucodigo#,
						Icodigo,                        
						Ucodigo,
						d.OCid, d.OCCid,
						t.OCTtipo, t.OCTtransporte, t.OCTfechaPartida, t.OCTobservaciones
					  from HDDocumentosCP d
						left join OCtransporte t
							on t.OCTid = d.OCTid
					 where d.Ecodigo		= #arguments.Ecodigo#
					   and d.IDdocumento	= #arguments.IDdocumento#
				</cfquery>
			
				<cftransaction action="commit"/>
			</cftransaction>
		
			<cfinvoke 
				component="sif.Componentes.CP_PosteoDocumentosCxP"
				method="PosteoDocumento"
				IDdoc = "#llave#"
				Ecodigo = "#arguments.Ecodigo#"
				usuario = "#Session.usuario#"
				debug = "N"/>
			<!---***********************************************************************--->
			<!---******** UNA VEZ CREADO ESTOS DOCUMENTOS SE APLICAN            ********--->
			<!---***********************************************************************--->
			
			<cfquery name="llaveposteo" datasource="#arguments.conexion#" >
				select IDdocumento from EDocumentosCP                  
				where SNcodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
				and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Ddocumento#">
				and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CPTcodigoRef#">
				and Ecodigo = #arguments.Ecodigo#
			</cfquery>
			
			
			<!---***********************************************************************--->
			<!---******** UNA VEZ POSTEADOS                                     ********--->
			<!---******** SE CARGAN LAS TABLAS EAplicacionCP,DAplicacionCP      ********--->
			<!---******** Y se postea para hacer la aplicacion de doc. afavor   ********--->
			<!---***********************************************************************--->
			
			<cfif Tipotrans.CPTtipo eq 'C'>
				<!--- Documento Nuevo es a favor --->
				<cfset LvarID 			= llaveposteo.IDdocumento>
				<cfset LvarCPTcodigo	= arguments.CPTcodigoRef>
	
				<!--- Documento Viejo es normal --->
				<cfset LvarIdRef		= arguments.IDdocumento>
				<cfset LvarCPTcodigoRef	= arguments.CPTcodigo>
			<cfelse>
				<!--- Documento Viejo es a favor --->
				<cfset LvarID 			= arguments.IDdocumento>
				<cfset LvarCPTcodigo	= arguments.CPTcodigo>
	
				<!--- Documento Nuevo es normal --->
				<cfset LvarIdRef 		= llaveposteo.IDdocumento>
				<cfset LvarCPTcodigoRef	= arguments.CPTcodigoRef>
			</cfif>
	
			<cfquery name="InsertEAplicacionCP" datasource="#arguments.conexion#" >
				insert into EAplicacionCP 
					(
						ID,
						Ecodigo, 
						CPTcodigo, 
						Ddocumento, 
						SNcodigo, 
						Mcodigo,  
						EAtipocambio, 
						EAtotal, 
						EAselect, 
						EAfecha, 
						EAusuario,
						CFid,
						BMUsucodigo 
					) 
				select 
						IDdocumento, 
						Ecodigo,
						'#LvarCPTcodigo#',
						Ddocumento, 
						SNcodigo,
						Mcodigo,
						coalesce(EDtcultrev,Dtipocambio),
						Dtotal,
						0,
						<cf_jdbcquery_param value="#LvarPrimeroMesAux#" cfsqltype="cf_sql_timestamp">,	 <!--- Fecha Primer Dia Mes Aux --->
						'#Session.usuario#',
						CFid,
						#Session.Usucodigo#
				  from EDocumentosCP
				 where Ecodigo		= #arguments.Ecodigo#
				   and IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#"> 
			</cfquery>
	
			<cfquery name="InsertDAplicacionCP" datasource="#arguments.conexion#">
				insert into DAplicacionCP 
					(
						ID,
						Ecodigo,
						SNcodigo,
						DAidref,
						DAtransref,
						DAdocref,
						DAmonto,
						DAtotal ,
						DAmontodoc,
						DAtipocambio,
						CFid,
						BMUsucodigo 
					)
				select 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarID#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.Ecodigo#">,
						SNcodigo,
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#LvarIdRef#">, 
						<cfqueryparam cfsqltype="cf_sql_char" 		value="#LvarCPTcodigoRef#">,
						Ddocumento,
						Dtotal,
						Dtotal,
						Dtotal,
						1,
						CFid,
						#Session.Usucodigo#
				 from EDocumentosCP
				 where Ecodigo =     #arguments.Ecodigo#
				   and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarId#">
			</cfquery>
	
			 <cfif arguments.debug> 
				la llave2 es : <cfoutput>#llave#</cfoutput><br>
				<cfquery name="insertEncabezado" datasource="#arguments.conexion#">
					select * from EAplicacionCP 
					<cfif Tipotrans.CPTtipo eq 'C'><!--- tipo de documentos original (No Fac) --->
						where ID =	#arguments.IDdocumento# 
					<cfelse>
						where ID =	#llave#
					</cfif>
				</cfquery>
				<cfdump var="#insertEncabezado#">
				 <cfquery name="insertEncabezado" datasource="#arguments.conexion#" >
					select * from DAplicacionCP                 
					<cfif Tipotrans.CPTtipo eq 'C'><!--- tipo de documentos original (No Fac) --->
						where ID =	#arguments.IDdocumento# 
					<cfelse>
						where ID =	#llave#
					</cfif>
					
				</cfquery>
				<cfdump var="#insertEncabezado#"> 
			 </cfif>
			
            <cfinvoke component="sif.Componentes.CP_PosteoDocsFavorCxP"
                        method="CP_PosteoDocsFavorCxP"

                        ID 			= "#LvarID#"
                        Ecodigo 	= "#arguments.Ecodigo#"
                        CPTcodigo 	= "#LvarCPTcodigo#"
                        Ddocumento 	= "#arguments.Ddocumento#"
                        Usucodigo 	= "#Session.Usucodigo#"
                        usuario 	= "#Session.usuario#"
                        fechaDoc 	= "S"
                        debug 		= "N"	
            />
		</cfif>
	</cffunction>
</cfcomponent>


