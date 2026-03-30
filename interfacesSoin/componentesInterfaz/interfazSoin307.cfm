<!---
	El Encabezado recibe la cantidad de documentos a insertar.
	El detalle recibe la cantidad de documentos especificados en el encabezado.
	Verifica que la cantidad de lineas del detalle y del encabezado sean igual.
---->

<cfobject name="session.objInterfazSoin" component="interfacesSoin.Componentes.interfaces">
<cfset session.objInterfazSoin.sbReportarActividad(GvarNI, GvarID)>

<!---Parametro Oficinas --->
	<cfquery name="rsOficina" datasource="#session.DSN#">
		select Pvalor as valor
		from Parametros 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Pcodigo=2900
	</cfquery>
	
<!---Parametro Transacción --->
	<cfquery name="rsTransaccion" datasource="#session.DSN#">
		select Pvalor as valor
		from Parametros 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and Pcodigo=2910
	</cfquery>

<cftransaction isolation="read_uncommitted">
	<cfquery name="rsInputED" datasource="sifinterfaces">
		select 
			IE307.ID, 
			IE307.CANTIDAD_DOCUMENTOS,
			ID307.IMPORTE_TOTAL,
			ID307.ID,  
			ID307.DOCUMENTO_INTERNO, 
			ID307.CODIGO_PROYECTO,   
			ID307.CODIGO_CONTRATO_OC,
			ID307.FECHA_DOCUMENTO,    
			ID307.PERIODO,            
			ID307.USUARIO_QUE_ESTIMA,
			IS307.LINEA_CONTRATO_OC,
			IS307.IMPORTE_LINEA,
			IS307.FUENTE_FINANCIAMIENTO 
		from IE307
		inner join ID307
			on ID307.ID = IE307.ID
		inner join IS307 
			on IS307.ID = ID307.ID
			and IS307.DOCUMENTO_INTERNO = ID307.DOCUMENTO_INTERNO
	 	where IE307.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
	</cfquery>
	<cfif rsInputED.recordCount EQ 0>
		<cfthrow message="No existen datos de Entrada para el ID='#GvarID#' en la Interfaz 307 ">
	</cfif>	
</cftransaction>

<!--- Cantidad de documentos del encabezado = documentos del detalle--->
	<cfquery name="cantDocumento" datasource="sifinterfaces">
		select a.CANTIDAD_DOCUMENTOS as cantidadE,
		(select count(1) from ID307 as b where b.ID = a.ID) as cantidaD
		from IE307 as a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
<!--- Valida que vengan datos --->
	<cfif cantDocumento.cantidadE NEQ cantDocumento.cantidaD>
		<cfthrow message="Error en Interfaz 307. La cantidad de Documentos no coincide con la cantidad del Encabezado. Proceso Cancelado!.">
	</cfif>	
	
<!--- valida que la cantidad del importe del Encb sea igual a la suma de lineas de detalle--->
	<cfquery name="readTotImportED" datasource="sifinterfaces">
		select a.IMPORTE_TOTAL as importeE,
		(select sum(IMPORTE_TOTAL) from ID307 b where b.ID = a.ID) as importeD
		from IE307 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<cfif readTotImportED.importeE NEQ readTotImportED.importeD>
		<cfthrow message="Error en Interfaz 307. La cantidad del Importe del Encabezado no coincide con la suma de importes de los documentos. Proceso Cancelado!.">
	</cfif>
	
<!--- valida que la cantidad del importe del Detalle sea igual a la suma de lineas de Subdetalle--->
	<cfquery name="readTotImportDS" datasource="sifinterfaces">
		select a.IMPORTE_TOTAL as importeD,
		(select sum(IMPORTE_LINEA ) from IS307 b where b.ID = a.ID and b.DOCUMENTO_INTERNO = a.DOCUMENTO_INTERNO) as importeS
		from ID307 a	
		where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	<cfif readTotImportDS.importeD NEQ readTotImportDS.importeS>
		<cfthrow message="Error en Interfaz 307. La cantidad del Importe de las Lineas no coincide con la suma de Importe de documentos. Proceso Cancelado!.">
	</cfif>
	
		<cfquery name="rsData" datasource="sifinterfaces">
				select 
					sn.TESRPTCid,
					b.Ccuenta,
					cm.EOdesc,
					cm.EOnumero,
					cm.EOidorden,
					cm.EOtc,
					cm.Ecodigo, 
					cm.Mcodigo,
					cm.Rcodigo,
					cm.EOfecha,
					cm.SNcodigo,
					cm.Impuesto,
					cm.EOtotal,
					IE307.ID, 
					IE307.CANTIDAD_DOCUMENTOS,
					ID307.IMPORTE_TOTAL,
					ID307.DOCUMENTO_INTERNO, 
					ID307.CODIGO_PROYECTO,   
					ID307.CODIGO_CONTRATO_OC,
					ID307.FECHA_DOCUMENTO,    
					ID307.PERIODO,            
					ID307.USUARIO_QUE_ESTIMA
				from IE307
				inner join ID307
					on ID307.ID = IE307.ID
				inner join <cf_dbdatabase table="EOrdenCM" datasource="#session.dsn#"> as  cm
					on cm.EOnumero = ID307.CODIGO_CONTRATO_OC
					and cm.Ecodigo = #session.Ecodigo#
					
				inner join <cf_dbdatabase table="SNegocios" datasource="#session.dsn#"> sn
					on sn.SNcodigo = cm.SNcodigo
					and sn.Ecodigo = cm.Ecodigo
				left outer join <cf_dbdatabase table="CContables" datasource="#session.dsn#"> b
		  			on b.Ecodigo = sn.Ecodigo 
					and b.Ccuenta=sn.SNcuentacxp					
			 where IE307.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#"><!--- La variable GvarID fué por el Componente de Interfaces previamente a invocar este Componente --->
			</cfquery>
		<cftransaction>		
	<!---Obtiene los valores del detalle de la Orden de Compra--->
		<cfif rsData.recordcount gt 0>
		
			<cfloop query="rsData">
				<cfset LvarDocumento 		= rsData.DOCUMENTO_INTERNO>
				<cfset LvarSNcodigo 			= rsData.SNcodigo>
				<cfset LvarMcodigo 			= rsData.Mcodigo>
				<cfset LvarEOtc 				= rsData.EOtc>
				<cfset LvarRcodigo 			= rsData.Rcodigo>
				<cfset LvarEOdesc 			= rsData.EOdesc>
				<cfset LvarImpuesto 			= rsData.Impuesto>
				<cfset LvarIMPORTE_TOTAL	= rsData.IMPORTE_TOTAL>
				<cfset LvarCcuenta			= rsData.Ccuenta>
				<cfset LvarFechaArribo		= rsData.FECHA_DOCUMENTO>
				<cfset LvarTESRPTCid			= rsData.TESRPTCid>
				
				<cfquery name="rsVerificaD" datasource="sifinterfaces">
					select count(1) as cantidad  from <cf_dbdatabase table="EDocumentosCxP" datasource="#session.dsn#">
					where Ecodigo = #session.Ecodigo# 
						and CPTcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransaccion.valor#">
						and  EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDocumento#"> 
						and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigo#">
				</cfquery>
				
			<!---Inserta Encabezado--->
				<cfif #rsVerificaD.cantidad# EQ 0>
					<cfquery name="rsInsertEDocCP" datasource="sifinterfaces">
							insert into <cf_dbdatabase table="EDocumentosCxP" datasource="#session.dsn#"> 
							(
								Ecodigo, 
								Ocodigo, 	 
								CPTcodigo,	
								EDdocumento, 
								SNcodigo, 
								Mcodigo, 
								EDtipocambio, 
								Ccuenta, 
								Rcodigo, 
								TESRPTCid,
								EDfechaarribo,
								EDdescuento, 
								EDporcdescuento, 
								EDimpuesto, 
								EDtotal,  
								EDfecha,  
								EDusuario,
								BMUsucodigo
							)
							values 
							( 
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOficina.valor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTransaccion.valor#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDocumento#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMcodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_float" 	value="#LvarEOtc#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">,
							 <cfif len(trim(rsData.Rcodigo))><cfqueryparam cfsqltype="cf_sql_char" value="#trim(LvarRcodigo)#"><cfelse><CF_jdbcquery_param cfsqltype="cf_sql_char" value="null"></cfif>,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESRPTCid#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaArribo#">,	
							 0.00,
							 0.00,
							 0.00,
							 #LvarIMPORTE_TOTAL#,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,	
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
							)					
						<cf_dbidentity1 datasource="sifinterfaces" verificar_transaccion="false">
					</cfquery>
					<cf_dbidentity2 datasource="sifinterfaces" name="rsInsertEDocCP" verificar_transaccion="false">
				<cfelse>
					<cfthrow message="El Documento que se desea insertar ya existe!">
				</cfif>
			
				<cfset llave =  rsInsertEDocCP.identity>
				<cfquery name="rsInsertDet" datasource="sifinterfaces">
						insert into <cf_dbdatabase table="DDocumentosCxP" datasource="#session.dsn#"> 
						(			 
							IDdocumento,     
							DDdescripcion, 
							DDcantidad,      
							DDpreciou,        
							DDdesclinea,    
							DDporcdesclin, 
							DDtotallinea,      
							DDtipo,    
							Ecodigo, 
							Dcodigo,
							Aid,
							Alm_Aid,
							Ccuenta,
							DOlinea ,
							CFid, 
							Icodigo,
							BMUsucodigo,
							CFcuenta        
						)
					select 
						#llave#,
						cd.DOdescripcion,
						1,
						IS307.IMPORTE_LINEA,
						0.00, 
						0.00,
						IS307.IMPORTE_LINEA,
						cd.CMtipo,
						#session.Ecodigo#,
						c.Dcodigo,
						cd.Aid,
						cd.Alm_Aid,
						cf.Ccuenta,
						cd.DOlinea,
						<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						<CF_jdbcquery_param cfsqltype="cf_sql_char" value="null">,
						#Session.Usucodigo#,
						cd.CFcuenta
					from IE307
					inner join ID307
						on ID307.ID = IE307.ID
					inner join IS307 
						on IS307.ID = ID307.ID
						and IS307.DOCUMENTO_INTERNO = ID307.DOCUMENTO_INTERNO
					inner join <cf_dbdatabase table="DOrdenCM" datasource="#session.dsn#"> as cd
						on cd.Ecodigo = #session.Ecodigo#
						and cd.EOnumero = ID307.CODIGO_CONTRATO_OC
						and cd.DOconsecutivo =  IS307.LINEA_CONTRATO_OC
					inner join <cf_dbdatabase table="CFuncional" datasource="#session.dsn#"> as c
						on c.CFid = cd.CFid		
					inner join <cf_dbdatabase table="CFinanciera" datasource="#session.dsn#"> as cf
						on cf.CFcuenta = cd.CFcuenta
					inner join <cf_dbdatabase table="Departamentos" datasource="#session.dsn#"> dep
						on dep.Dcodigo = c.Dcodigo
						and dep.Ecodigo = c.Ecodigo							
				 where IE307.ID = #rsData.ID#
				</cfquery>					
			</cfloop>
		<cfelse>
			<cfthrow message="No existe la Orden de Compra">	
		</cfif>	

	<cfquery name="rsVerificaDoc" datasource="sifinterfaces">
		select 
			IE307.ID,
			cm.DOtotal,
			
			coalesce((select sum(DDtotallinea) from <cf_dbdatabase table="DDocumentosCxP" datasource="#session.dsn#"> as cp where cp.DOlinea =  IS307.LINEA_CONTRATO_OC),0)
			+ coalesce((select sum(DDtotallin) from <cf_dbdatabase table="HDDocumentosCP" datasource="#session.dsn#"> as  h where h.DOlinea = IS307.LINEA_CONTRATO_OC ),0)
			+ (select sum(IMPORTE_LINEA) from IS307 int where int.ID = IE307.ID and int.LINEA_CONTRATO_OC = IS307.LINEA_CONTRATO_OC) as total,		
			
			cm.DOconsecutivo,
			ID307.DOCUMENTO_INTERNO,
			ID307.CODIGO_PROYECTO,
			ID307.CODIGO_CONTRATO_OC,
			IS307.LINEA_CONTRATO_OC,
			IS307.IMPORTE_LINEA,
			ID307.IMPORTE_TOTAL
		from  IE307
			inner join ID307
				on ID307.ID = IE307.ID
			inner join IS307 
				on IS307.ID =  ID307.ID
				and  IS307.DOCUMENTO_INTERNO = ID307.DOCUMENTO_INTERNO
			inner join <cf_dbdatabase table="DOrdenCM" datasource="#session.dsn#"> as  cm
				on cm.DOconsecutivo = IS307.LINEA_CONTRATO_OC
				and cm.EOnumero = ID307.CODIGO_CONTRATO_OC
				and cm.Ecodigo = #session.Ecodigo#				
		 where IE307.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#GvarID#">
	</cfquery>
	
		<cfif rsVerificaDoc.recordcount gt 0>
			<cfloop query="rsVerificaDoc">
				<cfif #rsVerificaDoc.total# gt #rsVerificaDoc.DOtotal#>
					<cfset lineasErrores = "">
					<cfset LvarEstado = 'R'>
					<cfset LvarFaltante = (#rsVerificaDoc.DOtotal# - #rsVerificaDoc.total#)>
				<cfelse>
					<cfset LvarEstado = 'A'>
					<cfset LvarFaltante = 0>
				</cfif>
			
				<cfquery  name="rsInsertRegistro"datasource="sifinterfaces">
					insert into OE307
						(
							ID,
							CODIGO_PROYECTO,
							CODIGO_CONTRATO_OC,
							IMPORTE_TOTAL,
							IMPORTE_APROBADO,  
							IMPORTE_DISPONIBLE,
							IMPORTE_FALTANTE,  
							ESTADO,  
							DOCUMENTO_INTERNO,  
							LINEA_CONTRATO_OC
						)
					values 
					  (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaDoc.ID#">,
							<CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaDoc.CODIGO_CONTRATO_OC#">,
							#rsVerificaDoc.IMPORTE_LINEA#,
							0.00,
							coalesce(#rsVerificaDoc.DOtotal#,0),
							#LvarFaltante#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarEstado#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVerificaDoc.DOCUMENTO_INTERNO#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaDoc.LINEA_CONTRATO_OC#">
						)
					</cfquery>
				<cfif #rsVerificaDoc.total# gt #rsVerificaDoc.DOtotal#>
					<cfset lineasErrores &= rsVerificaDoc.LINEA_CONTRATO_OC & ','>
					<cfset lineasErrores = left(lineasErrores, len(lineasErrores)-1)>
					<cfthrow message="El Monto de la Línea (#lineasErrores#) es mayor a lo disponible, Proceso Cancelado!.">
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>