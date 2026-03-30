<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion  = Session.Dsn>
	<cfset GvarEcodigo   = Session.Ecodigo>	
	<cfset GvarUsuario   = Session.Usuario>
	<cfset GvarUsucodigo = Session.Usucodigo>
	<cfset GvarEnombre   = Session.Enombre>
	<cfset GvarMinFecha  = DateAdd('yyyy',-50,Now())>
	<cfset GvarLinea = 1>
	
    <!---Se crean las tablas temporales de TESordenPago, TESsolicitudPago y TESdetallePago--->
        <cf_dbtemp name="IE711tmp_V3" returnvariable="LvarOP" datasource="#session.DSN#">
            <cf_dbtempcol name="TESOPid"              type="numeric"      mandatory="yes" identity="yes">
            <cf_dbtempcol name="TESid"                type="numeric"      mandatory="yes">
            <cf_dbtempcol name="TESOPnumero"          type="int"          mandatory="no">
            <cf_dbtempcol name="TESOPestado"          type="tinyint"      mandatory="no">
            <cf_dbtempcol name="SNid"                 type="numeric"      mandatory="no">
            <cf_dbtempcol name="SNidP"                type="numeric"      mandatory="no">
            <cf_dbtempcol name="TESOPfechaPago"       type="datetime"     mandatory="no">
            <cf_dbtempcol name="CBidPago"             type="numeric"      mandatory="no">
            <cf_dbtempcol name="EcodigoPago"          type="int"          mandatory="no">
            <cf_dbtempcol name="Miso4217Pago"         type="char(3)"      mandatory="no">
            <cf_dbtempcol name="TESOPtipoCambioPago"  type="float"        mandatory="no">
            <cf_dbtempcol name="TESOPobservaciones"   type="text"         mandatory="no">
            <cf_dbtempcol name="TESOPfechaGeneracion" type="datetime"     mandatory="no">
            <cf_dbtempcol name="UsucodigoGenera"      type="numeric"      mandatory="no">
            <cf_dbtempcol name="TESMPcodigo"          type="char(10)"     mandatory="no">
            <cf_dbtempcol name="Ccuenta"              type="numeric"      mandatory="no">
            <cf_dbtempcol name="TESTPid"              type="numeric"      mandatory="no">
            <cf_dbtempcol name="TESOPbeneficiarioId"  type="varchar(30)"  mandatory="no">
            <cf_dbtempcol name="TESOPbeneficiario"    type="varchar(255)" mandatory="no">
        </cf_dbtemp>	
        
        <cf_dbtemp name="ID711tmp_V3" returnvariable="LvarSP" datasource="#session.DSN#">
            <cf_dbtempcol name="TESSPid"                  type="numeric"  mandatory="yes" identity="yes">
            <cf_dbtempcol name="TESid"                    type="numeric"  mandatory="yes">
            <cf_dbtempcol name="EcodigoOri"               type="int"      mandatory="no">
            <cf_dbtempcol name="TESSPnumero"              type="int"      mandatory="no">
            <cf_dbtempcol name="TESSPtipoDocumento"       type="tinyint"  mandatory="no">
            <cf_dbtempcol name="TESSPestado"              type="tinyint"  mandatory="no">
            <cf_dbtempcol name="SNcodigoOri"              type="int"      mandatory="no">
            <cf_dbtempcol name="TESSPfechaPagar"          type="datetime" mandatory="no">
            <cf_dbtempcol name="McodigoOri"               type="numeric"  mandatory="no">
            <cf_dbtempcol name="TESSPtipoCambioOriManual" type="money"    mandatory="no">
            <cf_dbtempcol name="CFid"                     type="numeric"  mandatory="no">
            <cf_dbtempcol name="TESSPobservaciones"       type="text"     mandatory="no">
            <cf_dbtempcol name="TESSPfechaSolicitud"      type="datetime" mandatory="no">
            <cf_dbtempcol name="UsucodigoSolicitud"       type="numeric"  mandatory="no">
            <cf_dbtempcol name="TESOPid"                  type="numeric"  mandatory="no">
            <cf_dbtempcol name="CBid"                     type="numeric"  mandatory="no">
            <cf_dbtempcol name="TESMPcodigo"              type="char(10)" mandatory="no">
            <cf_dbtempcol name="SNid"                     type="numeric"  mandatory="no">
            <cf_dbtempcol name="TESOPfechaPago"           type="datetime" mandatory="no">
            <cf_dbtempcol name="TESOPobservaciones"       type="text"     mandatory="no">
            <cf_dbtempcol name="TESSPtotalPagarOri"       type="money"    mandatory="no">
        </cf_dbtemp>
        
        <cf_dbtemp name="IS711tmp_V3" returnvariable="LvarDP" datasource="#session.DSN#">
            <cf_dbtempcol name="TESDPid"                  type="numeric"     mandatory="yes" identity="yes">
            <cf_dbtempcol name="TESDPestado"              type="tinyint"     mandatory="yes">
            <cf_dbtempcol name="EcodigoOri"               type="int"         mandatory="no">
            <cf_dbtempcol name="TESid"                    type="numeric"     mandatory="no">
            <cf_dbtempcol name="TESSPid"                  type="numeric"     mandatory="no">
            <cf_dbtempcol name="TESDPtipoDocumento"       type="tinyint"     mandatory="no">
            <cf_dbtempcol name="TESDPmoduloOri"           type="char(4)"     mandatory="no">
            <cf_dbtempcol name="TESDPidDocumento"         type="numeric"     mandatory="no">
            <cf_dbtempcol name="TESDPdocumentoOri"        type="varchar(20)" mandatory="no">
            <cf_dbtempcol name="TESDPreferenciaOri"       type="varchar(25)" mandatory="no">
            <cf_dbtempcol name="SNcodigoOri"              type="int"         mandatory="no">
            <cf_dbtempcol name="TESDPfechaVencimiento"    type="datetime"    mandatory="no">
            <cf_dbtempcol name="TESDPfechaSolicitada"     type="datetime"    mandatory="no">
            <cf_dbtempcol name="Miso4217Ori"              type="char(3)"     mandatory="no">
            <cf_dbtempcol name="TESDPmontoVencimientoOri" type="money"       mandatory="no">
            <cf_dbtempcol name="TESDPmontoSolicitadoOri"  type="money"       mandatory="no">
            <cf_dbtempcol name="TESDPmontoAprobadoOri"    type="money"       mandatory="no">
            <cf_dbtempcol name="TESDPdescripcion"         type="varchar(80)" mandatory="no">
            <cf_dbtempcol name="OcodigoOri"               type="int"         mandatory="no">
            <cf_dbtempcol name="TESOPid"                  type="numeric"     mandatory="no">
            <cf_dbtempcol name="TESDPfechaPago"           type="datetime"    mandatory="no">
            <cf_dbtempcol name="TESDPfechaAprobada"       type="datetime"    mandatory="no">
            <cf_dbtempcol name="TESDPtipoCambioOri"       type="float"       mandatory="no">
            <cf_dbtempcol name="TESDPtipoCambioSP"        type="float"       mandatory="no">
            <cf_dbtempcol name="TESDPmontoAprobadoLocal"  type="money"       mandatory="no">
            <cf_dbtempcol name="EcodigoPago"              type="int"         mandatory="no">
            <cf_dbtempcol name="TESDPfactorConversion"    type="float"       mandatory="no">
            <cf_dbtempcol name="TESDPmontoPago"           type="money"       mandatory="no">
            <cf_dbtempcol name="TESDPmontoPagoLocal"      type="money"       mandatory="no">
            <cf_dbtempcol name="BMUsucodigo"              type="numeric"     mandatory="no">
            <cf_dbtempcol name="Icodigo"                  type="char(5)"     mandatory="no">
            <cf_dbtempcol name="TESSPlinea"               type="int"         mandatory="no">
            <cf_dbtempcol name="CFcuentaDB"               type="numeric"     mandatory="no">
            <cf_dbtempcol name="CFid"                     type="numeric"     mandatory="no">
        </cf_dbtemp>
    
	<cffunction name="process" access="public" returntype="string" output="no">
	 	<!--- Argumentos --->
		<cfargument name="query" required="yes" type="query">
		
    	
        <!---Valida los Registros--->
		<cfoutput query="query" group="SecOrden">
        	<cfif not isdefined("query.GeneraOP") and query.GeneraOP eq "">
            	<cfthrow message="Error Interfaz 711. Se debe indicar el parametro GeneraOP. Proceso Cancelado!">
            </cfif>
            <!---Validacion de la Empresa--->
			<cfif query.EcodigoPago gt 0>
				<cfset EcodigoP  = getValidEmpresa (query.EcodigoPago)>
            <cfelseif query.EcodigoPago eq 0>
                <cfset EcodigoP  = GvarEcodigo>
            </cfif>
            
            <cfif query.EcodigoOri gt 0>
                    <cfset EcodigoO  = getValidEmpresa (query.EcodigoOri)>
                <cfelseif query.EcodigoOri eq 0>
                    <cfset EcodigoO  = GvarEcodigo>
                </cfif>	
                
            <!---Validacion de que la Empresa sea la administradora de la Tesoreria--->
			<cfif isdefined("query.GeneraOP") and query.GeneraOP eq 1>
            	<cfset valid_TESadmin  = getValidTESadmin (query.TEScodigo, EcodigoP)>
            </cfif>
            
            <cfset Valid_Tesoreria = getValidTesoreria(query.TEScodigo)>
            
			<cfset Valid_SNegocios 	= getValidSNegocios(query.SNcodigo, EcodigoO)>
            <!---Realiza esto unicamente si indican que genere la Orden de Pago--->
			<cfif isdefined("query.GeneraOP") and query.GeneraOP eq 1>
        		
            	<!---Crear Fecha en formato correcto--->
                <cftry>
					<cfset fechaOP = CreateDate( mid(query.TESOPfechaPago,1,4), mid(query.TESOPfechaPago,6,2), mid(query.TESOPfechaPago,9,2) )>
                    <cfif mid(query.TESOPfechaPago,5,1) NEQ "-" OR mid(query.TESOPfechaPago,8,1) NEQ "-">
                        <cfthrow>
                    </cfif>
                <cfcatch type="any">
                    <cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD">
                </cfcatch>
                </cftry>    
            	
                <cfset Valid_Fecha        	    = getValidFecha(fechaOP)>
				<cfset Valid_CBPago 			= getValidCBPago(query.CBcodigoPago, Valid_Tesoreria.TESid, EcodigoP)>
                
                <!---Valida el Tipo de Cambio--->
                <!--- Busca Moneda Local --->
                <cfquery name="rsMonedaL" datasource="#GvarConexion#">
                    select m.Miso4217 
                    from Empresas e 
                    inner join Monedas m 
                        on e.Ecodigo = m.Ecodigo and e.Mcodigo = m.Mcodigo
                    where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Valid_CBPago.Ecodigo#">
                </cfquery>
                
                <cfif isdefined("rsMonedaL") and rsMonedaL.Miso4217 NEQ	Valid_CBPago.Miso4217> 
                    <cfset Valid_TipoCambioR	= getValidTipoCambio(Valid_CBPago.Mcodigo,Valid_Fecha,Valid_CBPago.Ecodigo)>
                    <cfset Valid_TipoCambio     = Valid_TipoCambioR.TCventa>
                <cfelse>
                    <cfset Valid_TipoCambio		= 1>
                </cfif>
                            
                <cfset Valid_MedioPago		= getMedioPago(Valid_CBPago.CBid,Valid_Tesoreria.TESid,query.TESMPcodigo)> 
                
                <cfif listFindNoCase('2|3', Valid_MedioPago.TESTMPtipo,'|')> 
                	<cfif not isdefined("query.TESTPcuentab") and query.TESTPcuentab eq "">
                    	<cfthrow message="Error Interfaz 711. Se debe indicar el la cuenta de destino (TESTPcuentab), dado que el medio de pago necesita una. Proceso Cancelado!">
                    </cfif>
                   	<cfset Valid_CtaDes = getCtaDestino(Valid_Tesoreria.TESid, query.TESTPcuentab, Valid_SNegocios.SNidP,Valid_CBPago.Miso4217)>
                    <cfset CtaDes = Valid_CtaDes.TESTPid>
                <cfelse>
                    <cfset CtaDes = "null">
                </cfif> 
            <cfelse>
            	<cfset TESOPid          = "null">
                <cfset Valid_TipoCambio = "null">    
            </cfif>
			
           	<cfquery name="rsTESOP" datasource="#GvarConexion#">
                select coalesce(max(TESOPnumero)+1,1) as SiguienteOP
                  from #LvarOP#
                where TESid = #Valid_Tesoreria.TESid#
			</cfquery>
			
           	<cfif query.GeneraOP eq 1>
            	<cfquery name="InsertaOPagoTemp" datasource="#GvarConexion#">
                    insert into #LvarOP#
                    (TESid       
                    ,TESOPnumero
                    ,TESOPestado 
                    ,SNid                
                    ,SNidP 
                    ,TESOPfechaPago     
                    ,CBidPago             
                    ,EcodigoPago       
                    ,Miso4217Pago     
                    ,TESOPtipoCambioPago     
                    ,TESOPobservaciones        
                    ,TESOPfechaGeneracion
                    ,UsucodigoGenera      
                    ,TESMPcodigo          
                    ,Ccuenta
                    ,TESTPid
                    ,TESOPbeneficiarioId
                    ,TESOPbeneficiario
                    )
                    values 
                    (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Tesoreria.TESid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer"  value="#rsTESOP.SiguienteOP#">,
                    10,
                    <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valid_SNegocios.SNid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valid_SNegocios.SNidP#">,
                    <cfqueryparam cfsqltype="cf_sql_date"     value="#query.TESOPfechaPago#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valid_CBPago.CBid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer"  value="#Valid_CBPago.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char"     value="#Valid_CBPago.Miso4217#">,
                    <cfqueryparam cfsqltype="cf_sql_float"    value="#Valid_TipoCambio#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#query.TESOPobservaciones#">,
                    <cfqueryparam cfsqltype="cf_sql_date"     value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"  value="#GvarUsucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char"     value="#Valid_MedioPago.TESMPcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valid_CBPago.Ccuenta#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"  value="#CtaDes#" null="#CtaDes eq 'null'#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Valid_SNegocios.SNidentificacion#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Valid_SNegocios.SNnombre#">
                    )
                    <cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion ="FALSE">
                </cfquery>	 
                <cf_dbidentity2  datasource="#GvarConexion#" name="InsertaOPagoTemp" verificar_transaccion ="FALSE">
                <cfset TESOPid =  InsertaOPagoTemp.identity>
            <cfelse>
            	<cfquery name="InsertaOPagoTemp" datasource="#GvarConexion#">
                    insert into #LvarOP#
                    (TESid       
                    ,TESOPnumero
                    )
                    values 
                    (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Valid_Tesoreria.TESid#">,
                    <cfqueryparam cfsqltype="cf_sql_integer"  value="#rsTESOP.SiguienteOP#">
                    )
                    <cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion ="FALSE">
                </cfquery>	 
                <cf_dbidentity2  datasource="#GvarConexion#" name="InsertaOPagoTemp" verificar_transaccion ="FALSE">
                <cfset TESOPid =  InsertaOPagoTemp.identity>    	
            </cfif>
               
                <cfif query.GeneraOP eq 1>
                	<cfset set_SolP = setSolicitudesPago(query.ID,query.SecOrden,Valid_Tesoreria.TESid,Valid_SNegocios.SNcodigo,Valid_SNegocios.SNid,
								      TESOPid,Valid_CBPago.CBid,Valid_MedioPago.TESMPcodigo,query.TESOPfechaPago,query.TESOPobservaciones,Valid_TipoCambio,Valid_CBPago.Ecodigo)> 
                <cfelse>
                	<cfset set_SolP = setSolicitudesPago(query.ID,query.SecOrden,Valid_Tesoreria.TESid,Valid_SNegocios.SNcodigo,Valid_SNegocios.SNid,TESOPid)> 
                </cfif>
                
		<cftry>
        <cftransaction>
        	<cfif query.GeneraOP eq 1>
				<!--- Procesa Orden de Pago --->
                <cfquery name="rsTESOPR" datasource="#GvarConexion#">
                    select coalesce(max(TESOPnumero)+1,1) as SiguienteOP
                      from TESordenPago
                    where TESid = #Valid_Tesoreria.TESid#
				</cfquery>
                
                <cfquery name="InsertaOPago" datasource="#GvarConexion#">
                    insert into TESordenPago
                    (TESid       
                    ,TESOPnumero
                    ,TESOPestado 
                    ,SNid                
                    ,SNidP 
                    ,TESOPfechaPago     
                    ,CBidPago             
                    ,EcodigoPago       
                    ,Miso4217Pago     
                    ,TESOPtipoCambioPago     
                    ,TESOPobservaciones        
                    ,TESOPfechaGeneracion
                    ,UsucodigoGenera      
                    ,TESMPcodigo          
                    ,Ccuenta
                    ,TESTPid
                    ,TESOPbeneficiarioId
                    ,TESOPbeneficiario
                    )
                    (select
                    TESid       
                    ,#rsTESOPR.SiguienteOP#
                    ,TESOPestado 
                    ,SNid                
                    ,SNidP 
                    ,TESOPfechaPago     
                    ,CBidPago             
                    ,EcodigoPago       
                    ,Miso4217Pago     
                    ,TESOPtipoCambioPago     
                    ,TESOPobservaciones        
                    ,TESOPfechaGeneracion
                    ,UsucodigoGenera      
                    ,TESMPcodigo          
                    ,Ccuenta
                    ,TESTPid
                    ,TESOPbeneficiarioId
                    ,TESOPbeneficiario
                    from #LvarOP#)
                    <cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion ="FALSE">
                </cfquery>	 
                <cf_dbidentity2  datasource="#GvarConexion#" name="InsertaOPago" verificar_transaccion ="FALSE">
                <cfset TESOPidR =  InsertaOPago.identity>               
            </cfif>
            <cfquery name="rsOPTemp" datasource="#GvarConexion#">
                select TESOPid
                from #LvarOP#  
                where TESOPid = #query.SecOrden#         
            </cfquery>
                
            <cfquery name="rsSPTemp" datasource="#GvarConexion#">
                select TESSPid
                from #LvarSP#
                where TESOPid = #query.SecOrden# 
            </cfquery>
            
            <cfif isdefined("TESOPidR") and TESOPidR gt 0>
            	<cfset LvarTESOPidR = TESOPidR>
            <cfelse>
            	<cfset LvarTESOPidR = "null">
            </cfif>
            
			
         	<cfloop query="rsSPTemp">
                <cfquery name="rsNewSolR" datasource="#GvarConexion#">
                    select coalesce(max(TESSPnumero),0) + 1 as newSol
                    from TESsolicitudPago
                    where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
				</cfquery>
                
                <cfquery name="InsertaSPago" datasource="#GvarConexion#">
                    insert into TESsolicitudPago
                    (TESid    
                     ,EcodigoOri  			
                     ,TESSPnumero
                     ,TESSPtipoDocumento  
                     ,TESSPestado              
                     ,SNcodigoOri           
                     ,TESSPfechaPagar    		
                     ,McodigoOri            
                     ,TESSPtipoCambioOriManual  
                     ,CFid                   
                     ,TESSPobservaciones
                     ,TESSPfechaSolicitud 
                     ,UsucodigoSolicitud    
                     ,TESOPid
                     ,CBid
                     ,TESMPcodigo
                     ,SNid                   
                     ,TESOPfechaPago
                     ,TESOPobservaciones
                     ,TESSPtotalPagarOri
                     )
                     (
                     select TESid    
                     ,EcodigoOri  			
                     ,#rsNewSolR.newSol#
                     ,TESSPtipoDocumento  
                     ,TESSPestado              
                     ,SNcodigoOri           
                     ,TESSPfechaPagar    		
                     ,McodigoOri            
                     ,TESSPtipoCambioOriManual  
                     ,CFid                   
                     ,TESSPobservaciones
                     ,TESSPfechaSolicitud 
                     ,UsucodigoSolicitud    
                     ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESOPidR#" null="#LvarTESOPidR eq 'null'#">
                     ,CBid
                     ,TESMPcodigo
                     ,SNid                   
                     ,TESOPfechaPago
                     ,TESOPobservaciones
                     ,TESSPtotalPagarOri
                     from #LvarSP#
                     where TESSPid = #rsSPTemp.TESSPid#
                     and TESOPid = #query.SecOrden#
                     )
                     <cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion ="FALSE">
            	</cfquery>	 
            	<cf_dbidentity2  datasource="#GvarConexion#" name="InsertaSPago" verificar_transaccion ="FALSE">
            	
				<cfset TESSPidR =  InsertaSPago.identity>
                
                <cfquery name="rsDPTemp" datasource="#GvarConexion#">
                    select TESDPid
                    from #LvarDP# 
                    where  TESSPid = #rsSPTemp.TESSPid#
                    <cfif query.GeneraOP eq 1>
                    	and TESOPid =  #rsOPTemp.TESOPid#       
                    </cfif>
            	</cfquery>
                
                <cfloop query="rsDPTemp">
                	<cfquery datasource="#GvarConexion#">
                        insert into TESdetallePago 
                        (TESDPestado,              
                         EcodigoOri,               
                         TESid,                    
                         TESSPid,                  
                         TESDPtipoDocumento,       
                         TESDPidDocumento,         
                         TESDPmoduloOri,           
                         TESDPdocumentoOri,        
                         TESDPreferenciaOri,       
                         SNcodigoOri,              
                         TESDPfechaVencimiento,    
                         TESDPfechaSolicitada,     
                         Miso4217Ori,              
                         TESDPmontoVencimientoOri, 
                         TESDPmontoSolicitadoOri,  
                         TESDPmontoAprobadoOri,    
                         TESDPdescripcion,         
                         OcodigoOri,               
                         TESOPid,                  
                         TESDPfechaPago, 
                         TESDPfechaAprobada,          
                         TESDPtipoCambioOri,       
                         TESDPtipoCambioSP,		   
                         TESDPmontoAprobadoLocal,  
                         EcodigoPago,              
                         TESDPfactorConversion,    
                         TESDPmontoPago,         
                         TESDPmontoPagoLocal,      
                         BMUsucodigo,             
                         Icodigo,                  
                         TESSPlinea,             
                         CFcuentaDB,  
                         CFid)
                         (
                         select TESDPestado,              
                         EcodigoOri,               
                         TESid,                    
                         #TESSPidR#,                  
                         TESDPtipoDocumento,       
                         TESDPidDocumento,         
                         TESDPmoduloOri,           
                         TESDPdocumentoOri,        
                         TESDPreferenciaOri,       
                         SNcodigoOri,              
                         TESDPfechaVencimiento,    
                         TESDPfechaSolicitada,     
                         Miso4217Ori,              
                         TESDPmontoVencimientoOri, 
                         TESDPmontoSolicitadoOri,  
                         TESDPmontoAprobadoOri,    
                         TESDPdescripcion,         
                         OcodigoOri,               
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESOPidR#" null="#LvarTESOPidR eq 'null'#">,                  
                         TESDPfechaPago, 
                         TESDPfechaAprobada,          
                         TESDPtipoCambioOri,       
                         TESDPtipoCambioSP,		   
                         TESDPmontoAprobadoLocal,  
                         EcodigoPago,              
                         TESDPfactorConversion,    
                         TESDPmontoPago,         
                         TESDPmontoPagoLocal,      
                         BMUsucodigo,             
                         Icodigo,                  
                         TESSPlinea,             
                         CFcuentaDB,  
                         CFid
                         from #LvarDP# 
                         where  TESSPid = #rsSPTemp.TESSPid#
                         	and TESDPid = #rsDPTemp.TESDPid#
                            and TESOPid =  #rsOPTemp.TESOPid#
                         )  
                    </cfquery>	
                </cfloop>
                
                
            	<cfif query.GeneraOP eq 1>
					<cfset suma = "TESDPmontoPago">
                <cfelse>
                    <cfset suma = "TESDPmontoVencimientoOri">
                </cfif>
                
                <cfquery name="reSelectMontDet" datasource="#GvarConexion#">
                    select sum(TESDPmontoVencimientoOri) as montoDet 
                    from TESdetallePago
                    where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#TESSPidR#">
                    
                    and TESid = #Valid_Tesoreria.TESid#
                </cfquery>
               
                <cfif query.GeneraOP eq 1>
                	<cfquery name="reSelectMontDet2" datasource="#GvarConexion#">
                        select sum(TESDPmontoPago) as montoDet 
                        from TESdetallePago
                        where TESOPid   = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESOPidR#">
                        and TESid = #Valid_Tesoreria.TESid#
                    </cfquery>
                    
                    <cfquery name="reUpdateOP" datasource="#GvarConexion#">
                        update TESordenPago 
                        set TESOPtotalPago = #reSelectMontDet2.montoDet#
                        where TESOPid   = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#LvarTESOPidR#">
                        and TESid = #Valid_Tesoreria.TESid#
                    </cfquery>
                </cfif>
                
                <cfquery name="reUpdateSP" datasource="#GvarConexion#">
                    update TESsolicitudPago 
                    set TESSPtotalPagarOri = #reSelectMontDet.montoDet#
                    where TESSPid = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#TESSPidR#">
                    and TESid = #Valid_Tesoreria.TESid#
                </cfquery>    
            
         	</cfloop>
        </cftransaction>
        <cftransaction>
			<cfif query.GeneraOP eq 1>
                <cfquery datasource="sifinterfaces">
                    insert into OE711
                    (ID,SecOrden,TESOPnumero,BMUsucodigo)
                    values
                    (#query.ID#,
                    #query.SecOrden#,
                    #rsTESOPR.SiguienteOP#,
                    #GvarUsucodigo#
                    )
                </cfquery>
            <cfelse>
                <cfquery name="rsSPTemp2" datasource="#GvarConexion#">
                    select TESSPid
                    from #LvarSP#
                    where TESOPid = #query.SecOrden# 
                </cfquery>
                <cfloop query="rsSPTemp2">
                    <cfquery datasource="sifinterfaces">
                        insert into OE711
                        (ID,SecOrden,TESSPnumero,BMUsucodigo)
                        values
                        (#query.ID#,
                        #rsNewSolR.newSol#,
                        #rsNewSolR.newSol#,
                        #GvarUsucodigo#
                        )
                    </cfquery>
                </cfloop>
            </cfif>
        </cftransaction>
		<cfcatch>
				<cfif isdefined("cfcatch.Message")>
					<cfset Mensaje="#cfcatch.Message#">
                <cfelse>
                    <cfset Mensaje="">
                </cfif>
                <cfif isdefined("cfcatch.Detail")>
                    <cfset Detalle="#cfcatch.Detail#">
                <cfelse>
                    <cfset Detalle="">
                </cfif>
                <cfif isdefined("cfcatch.sql")>
                    <cfset SQL="#cfcatch.sql#">
                <cfelse>
                    <cfset SQL="">
                </cfif>
                <cfif isdefined("cfcatch.where")>
                    <cfset PARAM="#cfcatch.where#">
                <cfelse>
                    <cfset PARAM="">
                </cfif>
                <cfif isdefined("cfcatch.StackTrace")>
                    <cfset PILA="#cfcatch.StackTrace#">
                <cfelse>
                    <cfset PILA="">
                </cfif>
                <cfset MensajeError= #Mensaje# & #Detalle#>
				<cfthrow message="#MensajeError#">
		</cfcatch>
		</cftry>
	  </cfoutput>
    </cffunction>
	
	<!---
		Metodo: 
			getValidEmpresa
		Resultado:
			Verifica el codigo de la Empresa enviado sea correcto.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidEmpresa" output="no" returntype="numeric">
		<cfargument name="Ecodigo"   required="yes" type="numeric">
		
        <cfquery name="rsEmpresa" datasource="#GvarConexion#">
			select Ecodigo
            from Empresas 
            WHERE Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
        
		<cfif rsEmpresa.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 711. No se encontro la Empresa con el codigo #Arguments.Ecodigo#, por la tanto no se puede generar la Orden de Pago. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsEmpresa.Ecodigo>
	</cffunction>
    
	<!---
		Metodo: 
			getValidTESadmin
		Resultado:
			Verifica que la Empresa de session sea la administradora de la tesoreria en caso de ser necesario.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidTESadmin" output="no" returntype="query">
		<cfargument name="TEScodigo" required="yes" type="string">
        <cfargument name="Ecodigo"   required="yes" type="numeric">
		
        <cfquery name="rsTesoAdmin" datasource="#GvarConexion#">
			select TESid,TEScodigo,TESdescripcion,Edescripcion
            from Tesoreria t
                inner join Empresas e
                    on e.Ecodigo=t.EcodigoAdm
            WHERE e.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            and t.TEScodigo =  <cfqueryparam cfsqltype="cf_sql_char"    value="#trim(Arguments.TEScodigo)#">
		</cfquery>

		<cfif rsTesoAdmin.recordcount EQ 0 >
	        <cfquery name="rsNombre" datasource="#GvarConexion#">
                select Edescripcion from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
            <cfthrow message="Error en Interfaz 711. La Empresa #rsNombre.Edescripcion#, no es la administradora de la Tesorer&iacute;a, por la tanto no se puede generar la Orden de Pago. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsTesoAdmin>
	</cffunction>
    
    <!---
		Metodo: 
			getValidTesoreria
		Resultado:
			Devuelve el id asociado al codigo de Tesoreria de la Orden de Pago dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidTesoreria" output="no" returntype="query">
		<cfargument name="TEScodigo" required="yes" type="string">
		
        <cfquery name="rsTeso" datasource="#GvarConexion#">
			select TESid
            from Tesoreria
			where TEScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.TEScodigo)#">
		</cfquery>
		<cfif rsTeso.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 711. La Orden de Pago es inv&aacute;lida, El C&oacute;digo de la Tesorer&iacute;a no corresponde con ninguna tesorer&iacute;a en la Empresa. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsTeso>
	</cffunction>
    
      <!---
		Metodo: 
			getValidSNegocios
		Resultado:
			Devuelve el id asociado al codigo de Socio de Negocio de la Orden de Pago dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidSNegocios" output="no" returntype="query">
		<cfargument name="SNcodigo" required="yes" type="numeric">
        <cfargument name="Ecodigo" required="yes" type="numeric">
	
        <cfquery name="rsSNegocios" datasource="#GvarConexion#">
			select SNid, SNcodigo, SNesCorporativo, coalesce(SNidCorporativo,SNid) as SNidP, SNidentificacion, SNnombre
            from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
		</cfquery>
        <cfif rsSNegocios.recordcount EQ 0 >
        	 <cfquery name="rsNombre" datasource="#GvarConexion#">
                select Edescripcion from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
			<cfthrow message="Error en Interfaz 711. La Orden de Pago es inv&aacute;lida, El C&oacute;digo del Socio de Negocio no corresponde con ninguna socio en la Empresa #rsNombre.Edescripcion#. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsSNegocios>
	</cffunction>
	<!---
		Metodo: 
			getValidMcodigo
		Resultado:
			Devuelve el Mcodigo asociado al Miso4217 dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidMcodigo" output="no" returntype="query">
		<cfargument name="Miso4217" required="yes" type="string">
        <cfargument name="Ecodigo" required="yes" type="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select Mcodigo, Miso4217
			from Monedas 
            where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Miso4217)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 711. El C&oacute;digo de la Moneda de la Cuenta no corresponde con ninguna moneda en la Empresa. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>
	
	<!---
		Metodo: 
			getValidFecha
		Resultado:
			Devuelve una Fecha de Documento Valida
	--->
	<cffunction access="private" name="getValidFecha" output="no" returntype="date">
		<cfargument name="Fecha" required="yes" type="date">
		<cfif Arguments.Fecha lt GvarMinFecha or Arguments.Fecha gt DateAdd('yyyy',99,GvarMinFecha)>
			<cfthrow message="Error en Interfaz 711. FechaDocumeno es inv&aacute;lido, La Fecha del Documento no es v&aacute;lida en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn Arguments.Fecha>
	</cffunction>
	
    <!---
		Metodo: 
			getValidCBPago
		Resultado:
			Devuelve el id asociado al codigo de la cuenta de pago dada por la interfaz.
			En caso de error aborta el calculo.
	--->
	<cffunction access="private" name="getValidCBPago" output="no" returntype="query">
    	<cfargument name="CBcodigo" required="yes" type="string">
		<cfargument name="TESid"    required="yes" type="numeric"> 		
		<cfargument name="Ecodigo"  required="yes" type="numeric"> 		
        
        <cfquery name="rsCBpago" datasource="#GvarConexion#">
               select cb.CBid, cb.Ecodigo, cb.Ccuenta, m.Miso4217, cb.Mcodigo
			   from CuentasBancos cb
               inner join Monedas m
               	on m.Mcodigo = cb.Mcodigo
               	and m.Ecodigo = cb.Ecodigo
               inner join TEScuentasBancos tcb
               	on tcb.CBid = cb.CBid
               	and tcb.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESid#">
                and tcb.TESCBactiva = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
               where cb.CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CBcodigo#">
               <!---and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">--->
               and cb.CBesTCE = 0
        </cfquery> 
       
		<cfif rsCBpago.recordcount gt 0>
			<cfreturn rsCBpago>
	    <cfelse>
    	    <cfthrow message="Error Interfaz 711. La cuenta de Pago #Arguments.CBcodigo# no corresponde con ninguna cuenta valida. Proceso Cancelado!">
        </cfif>		
	</cffunction>
    	
	<!---
		Metodo:
			getTipoCambio
		Resultado:
			Obtiene el Tipo de cambio de la moneda indicada en la fecha indicada,
			la moneda esperada es en codigo Miso4217
	--->
	<cffunction access="private" name="getValidTipoCambio" output="no" returntype="query"> 
	  <cfargument name="Mcodigo" required="yes" type="numeric">
	  <cfargument name="Fecha" required="no" type="date" default="#now()#">
      <cfargument name="Ecodigo" required="yes" type="numeric">
	  <cfset var retTC = 1.00>
	  <cfquery name="rsTC" datasource="#GvarConexion#">
		   select 
		   		coalesce(h.TCcompra,1) as TCcompra,
				coalesce(h.TCventa,1)  as TCventa
		   from Htipocambio h
		   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		     and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		     and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		     and h.Hfecha = (
		     select max(h2.Hfecha)
		     from Htipocambio h2
		     where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		       and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		       and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">)
 	 </cfquery>
 	 <cfif isdefined('rsTC') and rsTC.recordCount GT 0>
	 	<cfset retTC = rsTC.TCcompra>
	 </cfif>
 	 <cfreturn rsTC>
  </cffunction>

	<!---
		Metodo:
			getMedioPago
		Resultado:
			Obtiene el Medio de Pago de la cuenta, segun el medio de pago y la cuenta bancaria 
			indicados en la interfaz.
	--->
	<cffunction access="private" name="getMedioPago" output="no" returntype="query">
    	<cfargument name="CBid" required="yes" type="numeric">
        <cfargument name="TESid" required="yes" type="numeric">
        <cfargument name="TESMPcodigo" required="yes" type="string">
		 		
		<cfquery name="rsMedio" datasource="#GvarConexion#">
           select TESMPcodigo, TESTMPtipo
           from TESmedioPago 
           where CBid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CBid#">
            and TESid       = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESid#">
            and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.TESMPcodigo#">
        </cfquery> 
		
		<cfif isdefined("rsMedio") and rsMedio.recordcount EQ 1>
			<cfreturn rsMedio>
	    <cfelse>
        	<cfquery name="rsCuenta" datasource="#GvarConexion#">
               select CBcodigo from CuentasBancos where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CBid#">  
            </cfquery>
            <cfquery name="rsTeso" datasource="#GvarConexion#">
               select TEScodigo from Tesoreria where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESid#">
            </cfquery>
            
    	    <cfthrow message="Error Interfaz 711. El Medio de pago #Arguments.TESMPcodigo# no corresponde con ningun medio de pago 
            v&aacute;lido para la cuenta bancaria #rsCuenta.CBcodigo# y la tesorer&iacute;a #rsTeso.TEScodigo#. Proceso Cancelado!">
        </cfif>		
	</cffunction>		
	
    <!---
		Metodo:
			getCtaDestino
		Resultado:
			Obtiene el id Cuenta de Destino en caso de ser necesaria, segun la cuenta indicada en la interfaz.
	--->
	<cffunction access="private" name="getCtaDestino" output="no" returntype="query">
    	<cfargument name="TESid" required="yes" type="numeric">
        <cfargument name="TESTPcuenta" required="yes" type="string">
        <cfargument name="SNid" required="yes" type="numeric">
        <cfargument name="Miso4217" required="yes" type="string">
		 		
		<cfquery name="rsCtaDestino" datasource="#GvarConexion#">
        	select TESTPid
           	from TEStransferenciaP tp
            inner join SNegocios sn
            on sn.SNid = tp.SNidP
           	where tp.TESTPcuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTPcuenta#">
            	and tp.TESid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESid#">
            	and tp.SNidP     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
                and tp.Miso4217  = <cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.Miso4217#">
        </cfquery> 
		
		<cfif isdefined("rsCtaDestino") and rsCtaDestino.recordcount EQ 1>
			<cfreturn rsCtaDestino>
	    <cfelse>
        	<cfthrow message="Error Interfaz 711. La cuenta de destino #Arguments.TESTPcuenta# no corresponde con ninguna cuenta
            v&aacute;lida para el Socio de Negocio y Tesoreria indicados. Proceso Cancelado!">
        </cfif>		
	</cffunction>
	
	<!------- Valida que el concepto enviado tenga su cuenta correspondiente---->
	<cffunction access="private" name="getValid_Ccuenta" output="no" returntype="query">
		<cfargument name="CFformato"  required="yes" type="string">
        <cfargument name="Ecodigo"    required="yes" type="numeric">
        <cfargument name="Ocodigo"    required="yes" type="numeric">
        <cfargument name="fechaSolic" required="no"  type="date" default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		    
			<cfif len(trim(Arguments.CFformato)) gt 0>
				<!--- Se crea la cuenta financiera --->
                <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato"         value="#Arguments.CFformato#"/>							
                    <cfinvokeargument name="Lprm_Cmayor"            value="#Left(Arguments.CFformato,4)#"/>							
                    <cfinvokeargument name="Lprm_Cdetalle"          value="#mid(Arguments.CFformato,6,100)#"/>
                    <cfinvokeargument name="Lprm_Ocodigo"           value="#Arguments.Ocodigo#"/>
                    <cfinvokeargument name="Lprm_fecha" 			value="#Arguments.fechaSolic#"/>
                    <cfinvokeargument name="Lprm_CrearConPlan"		value="true">
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                    <cfinvokeargument name="Lprm_DSN"               value="#GvarConexion#"/>
                    <cfinvokeargument name="Lprm_Ecodigo"           value="#Arguments.Ecodigo#"/>
                </cfinvoke>
                <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                    <cfthrow message="Error en Interfaz 711. Cuenta #Arguments.CFformato#: #LvarERROR#. Proceso Cancelado!">
                </cfif>
                <cfquery name="rsCFinanciero" datasource="#GvarConexion#">
                    select Ccuenta, CFcuenta
                    from CFinanciera 
                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                        and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CFformato#">
                </cfquery>
                <cfif isdefined("rsCFinanciero") and rsCFinanciero.recordcount EQ 0>
                    <cfquery name="rsNombre" datasource="#GvarConexion#">
                        select Edescripcion from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    </cfquery>	
                    <cfthrow message="Error en Interfaz 711. Cuenta #Arguments.CFformato#: Cuenta Inv&aacute;lida! para la empresa #rsNombre.Edescripcion#. Proceso Cancelado!">
                </cfif>
            </cfif>
		<cfreturn rsCFinanciero>
	</cffunction>
	
    
	<!--- Funcion Para extraer el centro funcional--->
	<cffunction access="private" name="getCentro_Funcional" output="no" returntype="query"> 
  		<cfargument name="CFcodigo" required="yes" type="string">
        <cfargument name="Ecodigo" required="yes" type="numeric">
		   	<cfquery name="rsCFuncional" datasource="#GvarConexion#">
       			select CFid, Ocodigo 
                from CFuncional 
                where CFcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#(Trim(Arguments.CFcodigo))#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
	       	</cfquery>   
            
            <cfif isdefined("rsCFuncional") and rsCFuncional.recordcount EQ 0>
            	<cfquery name="rsNombre" datasource="#GvarConexion#">
                    select Edescripcion from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                </cfquery>
				<cfthrow message="Error Interfaz 711. No se encontro el Centrol Funcional en la empresa #rsNombre.Edescripcion#">
			</cfif>	    
            <cfreturn rsCFuncional>
    </cffunction>
	
    <!---Valida Oficina--->
	<cffunction access="private" name="getValid_Oficina" output="no" returntype="string">
		<cfargument name="Ocodigo" required="yes" type="numeric">
        <cfargument name="Ecodigo" required="yes" type="numeric">
			<cfquery name="rsOficina" datasource="#GvarConexion#">
				select Oficodigo 
                from Oficinas   
                where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
               	and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
			</cfquery>
			
			<cfif isdefined("rsOficina") and rsOficina.recordcount EQ 0>
                <cfthrow message="Error Interfaz 711. No se pudo Obtener oficina Valida para el Centro Funcional definido. Proceso Cancelado!">
            </cfif>
			
			<cfreturn rsOficina.Oficodigo>
	</cffunction>
    
    <!---Insercion de Solicitudes de Pago --->
	<cffunction access="private" name="setSolicitudesPago" output="no" returntype="string">
		<cfargument name="ID"                 required="yes" type="numeric">
        <cfargument name="SecOrden"           required="yes" type="numeric">
        <cfargument name="TESid"              required="yes" type="numeric">
        <cfargument name="SNcodigo"           required="yes" type="numeric">
        <cfargument name="SNid"               required="yes" type="numeric">
        <cfargument name="TESOPid"            required="yes" type="numeric">
        <cfargument name="CBid"               required="no"  type="numeric" default="0">
        <cfargument name="TESMPcodigo"        required="no"  type="string">
        <cfargument name="TESOPfechaPago"     required="no"  type="date"     default="#LSDateFormat(Now(),'dd/mm/yyyy')#">
        <cfargument name="TESOPobservaciones" required="no"  type="string"   default="null"> 
        <cfargument name="Valid_TipoCambio"   required="no"  type="numeric">
        <cfargument name="EcodigoP"           required="no"  type="numeric">      	
			<cfset CBid = Arguments.CBid>
			<cfif Arguments.CBid eq 0>
            	<cfset CBid = "null">
            </cfif>
            
			<!---Obtener todas las solicitud de Pago que pertenecen a la OP --->    
            <cfquery name="rsSolicitudes" datasource="sifinterfaces">
                Select  D.CFcodigo,   
                        D.TESSPtipoDocumento, 
                        D.TESSPfechaPagar,        
                        D.Miso4217, 
                        D.TESPtipoCambioOriManual,   
                        D.TESSPfechaSolicitud,    
                        D.TESSPobservaciones, 
                        D.SecSolicitud,
                        coalesce(D.EcodigoOri,0) as EcodigoOri
                from ID711 D
                where D.SecOrden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SecOrden#">
                and D.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">
            </cfquery>
                       
            <cfif rsSolicitudes.recordcount eq 0>
            	<cfthrow message="Error en Interfaz 711. No existen Solicitudes de Pago definidos para la Orden de Pago #Arguments.SecOrden#. Proceso Cancelado!.">
            </cfif>
            <cfset LvarCPDDids 	= "">
            <cfloop query="rsSolicitudes">
           		 <!---Validacion de la Empresa--->
				<cfif rsSolicitudes.EcodigoOri gt 0>
                    <cfset EcodigoO  = getValidEmpresa (rsSolicitudes.EcodigoOri)>
                <cfelseif rsSolicitudes.EcodigoOri eq 0>
                    <cfset EcodigoO  = GvarEcodigo>
                </cfif>	
 
                <cfquery name="rsNewSolTemp" datasource="#GvarConexion#">
                    select coalesce(max(TESSPnumero),0) + 1 as newSol
                    from #LvarSP#
                    where EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoO#">
                </cfquery>
                
                <cfif rsSolicitudes.TESSPtipoDocumento eq 0> 
                    <cfset Valid_tipoDocumento = rsSolicitudes.TESSPtipoDocumento>	
                <cfelse>
                    <cfthrow message="Error en Interfaz 711. El Tipo de Documento indicado es incorrecto. Proceso Cancelado!.">    
                </cfif>
                
                <!---Crear Fecha en formato correcto--->
                <cftry>
                    <cfset fechaSP = CreateDate( mid(rsSolicitudes.TESSPfechaPagar,1,4), mid(rsSolicitudes.TESSPfechaPagar,6,2), mid(rsSolicitudes.TESSPfechaPagar,9,2) )>
                    <cfif mid(rsSolicitudes.TESSPfechaPagar,5,1) NEQ "-" OR mid(rsSolicitudes.TESSPfechaPagar,8,1) NEQ "-">
                        <cfthrow>
                    </cfif>
                <cfcatch type="any">
                    <cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD">
                </cfcatch>
                </cftry>
                <cfset Valid_FechaSP     	    = getValidFecha(fechaSP)>
                
                <cfif rsSolicitudes.Miso4217 eq "" or not isdefined("rsSolicitudes.Miso4217")>
                    <cfthrow message="Error en la Moneda. Debe indicar un Miso4217">
                </cfif>
                
                <cfset Valid_Mcodigo 			= getValidMcodigo(rsSolicitudes.Miso4217, EcodigoO)>
                
                <cfquery name="rsMonedaL2" datasource="#GvarConexion#">
                    select m.Miso4217 
                    from Empresas e 
                    inner join Monedas m 
                        on e.Ecodigo = m.Ecodigo and e.Mcodigo = m.Mcodigo
                    where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoO#">
                </cfquery>
                
                <cfif isdefined("rsMonedaL2") and rsMonedaL2.Miso4217 EQ Valid_Mcodigo.Miso4217 and rsSolicitudes.TESPtipoCambioOriManual GT 1>
                    <cfthrow message="Error Interfaz 711. Se ha dado un Tipo de cambio diferente de 1 para la moneda Local">
                </cfif>
                
                <cfif (rsSolicitudes.TESPtipoCambioOriManual EQ 0 or rsSolicitudes.TESPtipoCambioOriManual EQ "") and isdefined("rsMonedaL2") and rsMonedaL2.Miso4217 NEQ Valid_Mcodigo.Miso4217> 
                    <cfset Valid_TipoCambioSPR = getValidTipoCambio(Valid_Mcodigo.Mcodigo,Valid_FechaSP,EcodigoO)>
                    <cfset Valid_TipoCambioSP  = Valid_TipoCambioSPR.TCventa>
                <cfelse>
                    <cfset Valid_TipoCambioSP  = rsSolicitudes.TESPtipoCambioOriManual>
                </cfif>
                
                <cfset Valid_CFuncional        = getCentro_Funcional(rsSolicitudes.CFcodigo, EcodigoO)>
                <cfset Valid_Oficina           = getValid_Oficina(Valid_CFuncional.Ocodigo, EcodigoO)>
                 <!---Crear Fecha en formato correcto--->
                <cftry>
                    <cfset fechaSPS = CreateDate( mid(rsSolicitudes.TESSPfechaSolicitud,1,4), mid(rsSolicitudes.TESSPfechaSolicitud,6,2), mid(rsSolicitudes.TESSPfechaSolicitud,9,2) )>
                    <cfif mid(rsSolicitudes.TESSPfechaSolicitud,5,1) NEQ "-" OR mid(rsSolicitudes.TESSPfechaSolicitud,8,1) NEQ "-">
                        <cfthrow>
                    </cfif>
                <cfcatch type="any">
                    <cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD">
                </cfcatch>
                </cftry>
                <cfset Valid_FechaSP2        	   = getValidFecha(fechaSPS)>
                
                
                <cfquery name="InsertaSPagoTemp" datasource="#GvarConexion#">
                    insert into #LvarSP#
                    (TESid    
                     ,EcodigoOri  			
                     ,TESSPnumero
                     ,TESSPtipoDocumento  
                     ,TESSPestado              
                     ,SNcodigoOri           
                     ,TESSPfechaPagar    		
                     ,McodigoOri            
                     ,TESSPtipoCambioOriManual  
                     ,CFid                   
                     ,TESSPobservaciones
                     ,TESSPfechaSolicitud 
                     ,UsucodigoSolicitud    
                     ,TESOPid
                     ,CBid
                     ,TESMPcodigo
                     ,SNid                   
                     ,TESOPfechaPago
                     ,TESOPobservaciones
                     ,TESSPtotalPagarOri
                     )
                     values 
                     (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESid#">,
                     <cfqueryparam cfsqltype="cf_sql_integer"  value="#EcodigoO#">,
                     <cfqueryparam cfsqltype="cf_sql_integer"  value="#rsNewSolTemp.newSol#">,
                     <cfqueryparam cfsqltype="cf_sql_tinyint"  value="#Valid_tipoDocumento#">, 
                     <cfif CBid neq "null">
	                 	10,
                     <cfelse>
                     	2,
                     </cfif>
                     <cfqueryparam cfsqltype="cf_sql_integer"  value="#Arguments.SNcodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_date"     value="#rsSolicitudes.TESSPfechaPagar#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valid_Mcodigo.Mcodigo#">,
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"    value="#rsSolicitudes.TESPtipoCambioOriManual#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Valid_CFuncional.CFid#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar"  value="#rsSolicitudes.TESSPobservaciones#">,
                     <cfqueryparam cfsqltype="cf_sql_date"     value="#rsSolicitudes.TESSPfechaSolicitud#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"  value="#GvarUsucodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.TESOPid#">,
                     <cfif CBid neq "null">
                         <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.CBid#">,
                         <cfqueryparam cfsqltype="cf_sql_char"     value="#Arguments.TESMPcodigo#">,
                     <cfelse>
                         <cfqueryparam cfsqltype="cf_sql_numeric"  value="0" null="#CBid eq 'null'#">,
                         <cfqueryparam cfsqltype="cf_sql_char"     value="0" null="#CBid eq 'null'#">,		
                     </cfif>
                     <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Arguments.SNid#">,
                     <cfqueryparam cfsqltype="cf_sql_date"     value="#Arguments.TESOPfechaPago#" null="#CBid eq 'null'#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar"  value="#Arguments.TESOPobservaciones#">,
                     <cfqueryparam cfsqltype="cf_sql_money"    value="0">
                     )
                     <cf_dbidentity1 datasource="#GvarConexion#" verificar_transaccion ="FALSE">
                </cfquery>	 
                <cf_dbidentity2  datasource="#GvarConexion#" name="InsertaSPagoTemp" verificar_transaccion ="FALSE">
                <cfset TESSPid =  InsertaSPagoTemp.identity>
				
                <cfset LvarCPDDids 	= ListAppend(LvarCPDDids,TESSPid)>
				<!---Llamar a la funcion que inserta los detalles de pago--->
                <cfif CBid eq "null">
                	<cfset set_DetP = setDetallePago(Arguments.ID,Arguments.SecOrden,rsSolicitudes.SecSolicitud,Arguments.TESid,TESSPid,Arguments.SNcodigo,
								      Valid_Mcodigo.Miso4217,Valid_CFuncional.Ocodigo,Valid_TipoCambioSP,Valid_CFuncional.CFid,Arguments.TESOPid,EcodigoO)> 
                <cfelse>
                	<cfset set_DetP = setDetallePago(Arguments.ID,Arguments.SecOrden,rsSolicitudes.SecSolicitud,Arguments.TESid,TESSPid,Arguments.SNcodigo,
								      Valid_Mcodigo.Miso4217,Valid_CFuncional.Ocodigo,Valid_TipoCambioSP,Valid_CFuncional.CFid,Arguments.TESOPid,EcodigoO,
								      Arguments.Valid_TipoCambio,Arguments.EcodigoP)> 
                </cfif>
            </cfloop>
            
            <cfset mensajeSP = "OK">
            <cfreturn mensajeSP>
	</cffunction>
    
	<cffunction access="private" name="setDetallePago" output="no" returntype="string">
		<cfargument name="ID"                 required="yes" type="numeric">
        <cfargument name="SecOrden"           required="yes" type="numeric">
        <cfargument name="SecSolicitud"       required="yes" type="numeric">
        <cfargument name="TESid"              required="yes" type="numeric">
        <cfargument name="TESSPid"            required="yes" type="numeric">
        <cfargument name="SNcodigo"           required="yes" type="numeric">
        <cfargument name="Miso4217"           required="yes" type="string"> 
        <cfargument name="Ocodigo"            required="yes" type="numeric">
        <cfargument name="Valid_TipoCambioSP" required="yes" type="numeric">
        <cfargument name="CFid"               required="yes" type="numeric">
        <cfargument name="TESOPid"            required="yes" type="numeric">
        <cfargument name="EcodigoOri"         required="yes" type="numeric">
		<cfargument name="Valid_TipoCambio"   required="no"  type="numeric" default="0">
        <cfargument name="EcodigoP"           required="no"  type="numeric" default="0">
        	<cfset TC = Arguments.Valid_TipoCambio>
			<cfif Arguments.Valid_TipoCambio eq 0>
            	<cfset TC = "null">
            </cfif>
        	<!---Obtener todas los detalles de Pago que pertenecen a la SP --->    
            <cfquery name="rsDetalles" datasource="sifinterfaces">
                Select  S.TESDPdocumentoOri,    
                        S.TESDPreferenciaOri,        
                        S.TESDPfechaVencimiento,  
                        S.TESDPmontoVencimientoOri,   
                        S.TESDPdescripcion,                                                                 
                        S.CFformato,                                                                                            
                        S.Icodigo
                from IS711 S
                where S.SecOrden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SecOrden#">
                and S.SecSolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SecSolicitud#">
                and S.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">
            </cfquery>
            
			<cfif rsDetalles.recordcount eq 0>
            	<cfthrow message="Error en Interfaz 711. No existen Detalles de Pago definidos para la Solicitud de Pago #Arguments.SecSolicitud#. Proceso Cancelado!.">
            </cfif>
            
        	<cfset GvarLinea = 1> 
            
            <cfloop query="rsDetalles">
            <!---Validaciones para los Documentos del detalle--->
                <cfset Valid_Cuenta        = getValid_Ccuenta(rsDetalles.CFformato, Arguments.EcodigoOri,Arguments.Ocodigo,rsDetalles.TESDPfechaVencimiento)>
                <cfif rsDetalles.TESDPdocumentoOri neq "">
                	<cfset Valid_DPdocumento = rsDetalles.TESDPdocumentoOri>
                <cfelse>
                	<cfthrow message="Error Interfaz 711. El documento dado en el detalle es incorrecto">
                </cfif>
                <cfif rsDetalles.TESDPreferenciaOri neq "">
                	<cfset Valid_DPreferencia = rsDetalles.TESDPreferenciaOri>
                <cfelse>
                	<cfthrow message="Error Interfaz 711. La referencia dada en el detalle es incorrecta">
                </cfif>
                
                <!---Crear Fecha en formato correcto--->
                <cftry>
                    <cfset fechaDP = CreateDate( mid(rsDetalles.TESDPfechaVencimiento,1,4), mid(rsDetalles.TESDPfechaVencimiento,6,2), mid(rsDetalles.TESDPfechaVencimiento,9,2) )>
                    <cfif mid(rsDetalles.TESDPfechaVencimiento,5,1) NEQ "-" OR mid(rsDetalles.TESDPfechaVencimiento,8,1) NEQ "-">
                        <cfthrow>
                    </cfif>
                <cfcatch type="any">
                    <cfthrow message="Error en formato de fecha. Formato esperado: YYYY-MM-DD">
                </cfcatch>
                </cftry>
                <cfset Valid_FechaDP  = getValidFecha(fechaDP)>
                
                <cfset TESDPmontoAprobadoLocal = (rsDetalles.TESDPmontoVencimientoOri * Arguments.Valid_TipoCambioSP)>
                <cfif TC neq "null">
					<cfset TESDPfactorConversion = (Arguments.Valid_TipoCambioSP / Arguments.Valid_TipoCambio)>
               		<cfset TESDPmontoPago = (rsDetalles.TESDPmontoVencimientoOri * (Arguments.Valid_TipoCambioSP / Arguments.Valid_TipoCambio))>
					<cfset TESDPmontoPagoLocal = (rsDetalles.TESDPmontoVencimientoOri * Arguments.Valid_TipoCambioSP)>
                <cfelse>
                	<cfset TESDPfactorConversion = "null">
               		<cfset TESDPmontoPago        = "null">
					<cfset TESDPmontoPagoLocal   = "null">
                </cfif>
                
            <!----Detalle de la cuenta de Banco---->
                <cfquery name="InsertaDPagoTemp" datasource="#GvarConexion#">
                    insert into #LvarDP# 
                    (TESDPestado,              
                     EcodigoOri,               
                     TESid,                    
                     TESSPid,                  
                     TESDPtipoDocumento,       
                     TESDPidDocumento,         
                     TESDPmoduloOri,           
                     TESDPdocumentoOri,        
                     TESDPreferenciaOri,       
                     SNcodigoOri,              
                     TESDPfechaVencimiento,    
                     TESDPfechaSolicitada,     
                     Miso4217Ori,              
                     TESDPmontoVencimientoOri, 
                     TESDPmontoSolicitadoOri,  
                     TESDPmontoAprobadoOri,    
                     TESDPdescripcion,         
                     OcodigoOri,               
                     TESOPid,                  
                     TESDPfechaPago, 
                     TESDPfechaAprobada,          
                     TESDPtipoCambioOri,       
                     TESDPtipoCambioSP,		   
                     TESDPmontoAprobadoLocal,  
                     EcodigoPago,              
                     TESDPfactorConversion,    
                     TESDPmontoPago,         
                     TESDPmontoPagoLocal,      
                     BMUsucodigo,             
                     Icodigo,                  
                     TESSPlinea,             
                     CFcuentaDB,  
                     CFid)  
                     values         
                     (<cfqueryparam cfsqltype="cf_sql_tinyint"  value="11">, 
                     <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.EcodigoOri#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.TESid#">, 
                     <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.TESSPid#">,
                     <cfqueryparam cfsqltype="cf_sql_tinyint"   value="0">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.TESSPid#">,
                     <cfqueryparam cfsqltype="cf_sql_char"      value="TEOP">,
                     <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Valid_DPdocumento#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar"   value="#Valid_DPreferencia#">,
                     <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.SNcodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_date"      value="#rsDetalles.TESDPfechaVencimiento#">,
                     <cfqueryparam cfsqltype="cf_sql_date"      value="#now()#">,
                     <cfqueryparam cfsqltype="cf_sql_char"      value="#Arguments.Miso4217#">,
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#rsDetalles.TESDPmontoVencimientoOri#">,
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#rsDetalles.TESDPmontoVencimientoOri#">, 
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#rsDetalles.TESDPmontoVencimientoOri#">, 
                     <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsDetalles.TESDPdescripcion#">,
                     <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.Ocodigo#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric"   value="#TESOPid#">,
                     <cfqueryparam cfsqltype="cf_sql_date"      value="#rsDetalles.TESDPfechaVencimiento#">, 
                     <cfqueryparam cfsqltype="cf_sql_date"      value="#rsDetalles.TESDPfechaVencimiento#">, 
                     <cfqueryparam cfsqltype="cf_sql_float"     value="#Arguments.Valid_TipoCambioSP#">,        
                     <cfqueryparam cfsqltype="cf_sql_float"     value="#Arguments.Valid_TipoCambio#"      null="#TC eq 'null'#">,    
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#TESDPmontoAprobadoLocal#">,
                     <cfqueryparam cfsqltype="cf_sql_integer"   value="#Arguments.EcodigoP#" null="#TC eq 'null'#">, 
                     <cfqueryparam cfsqltype="cf_sql_float"     value="#TESDPfactorConversion#" null="#TESDPfactorConversion eq 'null'#">,
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#TESDPmontoPago#"        null="#TESDPmontoPago eq 'null'#">, 
                     <cf_jdbcquery_param cfsqltype="cf_sql_money"     value="#TESDPmontoPagoLocal#"   null="#TESDPmontoPagoLocal eq 'null'#">, 
                     <cfqueryparam cfsqltype="cf_sql_numeric"   value="#GvarUsucodigo#">,  
                     <cfqueryparam cfsqltype="cf_sql_char"      value="#rsDetalles.Icodigo#">,  
                     #GvarLinea#,  
                     #Valid_Cuenta.CFcuenta#,
                     <cfqueryparam cfsqltype="cf_sql_numeric"   value="#Arguments.CFid#">)
                </cfquery>	
                <cfset GvarLinea = GvarLinea + 1> 
                </cfloop>
               
                <cfset mensajeDP = "OK">
            	<cfreturn mensajeDP>
	</cffunction>       
</cfcomponent>
