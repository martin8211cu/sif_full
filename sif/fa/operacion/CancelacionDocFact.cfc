<!--- Modificacion: Se agregan los campos TESRPTCid, TESRPTCietu
	Justificacion: Se modifica componente para tomar en cuenta el Concepto de cobro por cambio de IETU
	Fecha: 07/07/2009 
	Realizo: ABG --->
<cfcomponent>

	<cffunction name='Cancelacion' access='public' output='true'>
		<cfargument name='Ecodigo' 			type='numeric' 	required='true'     default="#Session.Ecodigo#">		
		<cfargument name='debug' 			type="boolean" 	required='false' 	default='false'>
		<cfargument name='conexion' 		type='string' 	required='false' 	default="#Session.DSN#">
		<cfargument name='PeriodoActual' 	type='numeric' 	required='false' 	default="-1">
		<cfargument name='MesActual' 		type='numeric' 	required='false' 	default="-1">
		<cfargument name='Ddocumento' 		type='string' 	required='false'>
		<!---******** REQUERIDOS PARA REVERSION CXC  ********--->
		<cfargument name='CCTcodigo' 		type='string' 	required='false'>
		<cfargument name='CCTcodigoCan' 	type='string' 	required='false'>
		
	
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
		
	<!--- Este es el codigo para CxC --->
		<cfquery name="Tipotrans" datasource="#arguments.conexion#">
			select b.CCTcodigoRef,b.CCTcodigoCan 
			from Documentos d
				inner join FAPreFacturae a
					inner join FAPFTransacciones b
					on a.Ecodigo = b.Ecodigo 
					and a.PFTcodigo = b.PFTcodigo
				on d.Ecodigo = a.Ecodigo
				and d.Ddocumento = a.DdocumentoREF
				and d.CCTcodigo = b.CCTcodigoCan
				and a.TipoDocumentoREF = 2
			where 
			d.Ecodigo = #arguments.Ecodigo#
			and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
			and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTCodigo#">
		</cfquery>
			
		<cfif not isdefined("arguments.CCTcodigoCan")>
			<cfset arguments.CCTcodigoCan = Tipotrans.CCTCodigoCan >
		</cfif>
			
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as cantidad
			  from Documentos
			 where Ecodigo 		= #arguments.Ecodigo#
			   and CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTCodigo#">
			   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfthrow message="Documento CxC no existe: #arguments.CCTCodigo# - #arguments.Ddocumento#">
		</cfif>

		<!---******************************************--->
		<!---******** VALIDACION DE ARGUMENTOS ********--->
		<!---******************************************--->
		<cfif isdefined("arguments.PeriodoActual")  and arguments.PeriodoActual eq -1>
			<cfquery name="rsPeriodo" datasource="#arguments.conexion#">
				select convert(integer,p1.Pvalor) as value from Parametros p1 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#"> 
				and Pcodigo = 50
			</cfquery>
			<cfset arguments.PeriodoActual = rsPeriodo.value>
		</cfif>
		<cfif isdefined("arguments.MesActual")  and arguments.MesActual eq -1>
			<cfquery name="rsMes" datasource="#arguments.conexion#">
				select convert(integer,p1.Pvalor)as value from Parametros p1 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#"> 
				and Pcodigo = 60
			</cfquery>	
			<cfset arguments.MesActual = rsMes.value>
		</cfif>
		
		<cfset LvarPrimeroMesAux = createDate (Arguments.PeriodoActual,Arguments.MesActual,1)>
		<cfset LvarUltimoMesAux = createDate (Arguments.PeriodoActual,Arguments.MesActual,DaysInMonth(LvarPrimeroMesAux))>

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
		<!---******** sustituido por por el  CCTcodigoCan                   ********--->
		<!---***********************************************************************--->

		<cfset llave =-1>
		<cftransaction>
			<cfquery name="rsTotalL" datasource="#arguments.conexion#">
            	select sum(DDtotal) as DDtotal
                from HDDocumentos 
                where Ecodigo = #arguments.Ecodigo#
				and   CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
				and   Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
            </cfquery>
            <cfif isdefined("rsTotalL") and rsTotalL.DDtotal NEQ "">
            	<cfset varTotalL = rsTotalL.DDtotal>
            <cfelse>
            	<cfset varTotalL = 0>
            </cfif>
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
					BMUsucodigo,
                    TESRPTCid, 
                    TESRPTCietu
				)
				select 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">,
					Ocodigo,                       
					<cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigoCan#">,
					Ddocumento,
					SNcodigo,
					Mcodigo,                    
					Dtipocambio,
					Icodigo,
					Ccuenta,
					Rcodigo,
					(#varTotalL# + coalesce(
						(select sum(coalesce(MontoCalculado,0)) from ImpDocumentosCxC
						  where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
						  and Documento   = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#"> 
						  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">)
					,0)) - Dtotal,
					0,
					coalesce(
						(select sum(coalesce(MontoCalculado,0)) from ImpDocumentosCxC
						  where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
						  and Documento   = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#"> 
						  and Ecodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">)
					,0),
					Dtotal,
					case when Dfecha > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
						then 
							 Dfecha 
						else 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#">
						end,
					Dtref,
					Ddocref,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usulogin#">,
					0,
					case when Dvencimiento > <cfqueryparam cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#"> 
						then 
							 Dvencimiento
						else 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LvarPrimeroMesAux#">
						end,
					0,
					null,
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
					EDtipocambioFecha,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    TESRPTCid, 
                    TESRPTCietu
				from Documentos a	
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">
					and  a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
					and  a.Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">  
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
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#llave#">,
					DDtipo,
					case when DDtipo = 'S' then DDcodartcon end,			<!--- Cid --->
					case when DDtipo in ('A','O') then DDcodartcon end,		<!--- Aid --->	
                    Ccuenta,
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
					CFid,
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
				and   CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigoCan#">
				and   Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
			</cfquery>
			<cf_dump var="#regposteado#">
		</cfif>

		<!---***********************************************************************--->
		<!---******** UNA VEZ POSTEADOS                                     ********--->
		<!---******** SE CARGAN LAS TABLAS EFavor,DFavor                    ********--->
		<!---******** Y se postea para hacer la aplicacion de doc. afavor   ********--->
		<!---***********************************************************************--->
		<cfquery name="rsVerifica" datasource="#arguments.conexion#">
			select CCTtipo 
            from CCTransacciones 
            where Ecodigo = #arguments.Ecodigo#
            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigoCan#">
        </cfquery>
        	
		<cfif rsVerifica.CCTtipo eq 'D'> <!--- tipo de documentos original (No Fac) --->
			<!--- Documento Nuevo es a favor --->
			<cfset LvarCCTcodigo 	= arguments.CCTcodigoCan>

			<!--- Documento Viejo es normal --->
			<cfset LvarCCTcodigoRef	= arguments.CCTCodigo>
		<cfelse>
			<!--- Documento Viejo es a favor --->
			<cfset LvarCCTcodigo	= arguments.CCTCodigo>

			<!--- Documento Nuevo es normal --->
			<cfset LvarCCTcodigoRef	= arguments.CCTcodigoCan>
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
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
				CFid,
				#Session.Usucodigo#
		  	from Documentos a	
			where a.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#arguments.Ecodigo#">
			and a.CCTcodigo	= <cfqueryparam cfsqltype="cf_sql_char"	value="#LvarCCTcodigo#">
			and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
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
					Ccuenta,
					Mcodigo,
					Dtotal,
					Dtotal,
					1, 
					CFid,
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
					and   CCTcodigo = '#arguments.CCTcodigoCan#'
					and   Ddocumento= '#arguments.Ddocumento#'
				</cfquery>
				<cfquery name="insertDFavor" datasource="#arguments.conexion#">
					select * from DFavor
					where Ecodigo = #arguments.Ecodigo#
					and   CCTcodigo = '#arguments.CCTcodigoCan#'
					and   Ddocumento= '#arguments.Ddocumento#'
					and   CCTRcodigo= '#arguments.CCTcodigo#'
					and   DRdocumento= '#arguments.Ddocumento#'
				</cfquery>
				Encabezado EFavor <br>
				<cfdump var="#insertEFavor#">
				Encabezado DFavor <br>
				<cfdump var="#insertEFavor#">
			</cfif> 
            <!--- Invoca el componente de posteo --->
			<cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC"
			  method = "CC_PosteoDocsFavorCxC"
				Ecodigo    = "#arguments.Ecodigo#"
				CCTcodigo  = "#LvarCCTcodigo#"
				Ddocumento = "#arguments.Ddocumento#"
				debug      = "NO"
				usuario    = "#Session.usuario#"
				Usucodigo  = "#Session.usucodigo#"
				fechaDoc   = 'S'
			/>
	</cffunction>
</cfcomponent>
