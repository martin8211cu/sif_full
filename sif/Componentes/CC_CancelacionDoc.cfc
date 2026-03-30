<cfcomponent>

	<cffunction name='Cancelacion' access='public' output='true'>
		<cfargument name='Ecodigo' 			type='numeric' 	required='true'     default="#Session.Ecodigo#">		
		<cfargument name='debug' 			type="boolean" 	required='false' 	default='false'>
		<cfargument name='conexion' 		type='string' 	required='false' 	default="#Session.DSN#">
		<cfargument name='Ddocumento' 		type='string' 	required='false'>
		<cfargument name='CCTcodigo' 		type='string' 	required='false'>
		<cfargument name='HDid' 		    type='numeric' 	required='false'>

			
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select Ccuenta, coalesce(FCid,0) as FCid, coalesce(ETnumero,0) as ETnumero,
            coalesce(id_direccionFact,0) as id_direccionFact, Dfecha, Mcodigo, Dtipocambio,
            SNcodigo, Ocodigo
			  from HDocumentos
			 where Ecodigo 		= #arguments.Ecodigo#
			   and HDid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.HDid#">
		</cfquery>
        
		<cfif rsSQL.recordcount EQ 0>
			<cfthrow message="Documento CxC no existe: #arguments.CCTCodigo# - #arguments.Ddocumento#">
		</cfif>
        
        <cfset Ccuenta          = rsSQL.Ccuenta>
        <cfset caja             = rsSQL.FCid>
        <cfset transaccion      = rsSQL.ETnumero>
        <cfset id_direccionFact = rsSQL.id_direccionFact>
        <cfset Dfecha           = rsSQL.Dfecha>
        <cfset Mcodigo          = rsSQL.Mcodigo>
        <cfset TCambio          = rsSQL.Dtipocambio>
        <cfset SNcodigo         = rsSQL.SNcodigo>
        <cfset Ocodigo          = rsSQL.Ocodigo>
  		
        <cfif isdefined('SNcodigo') and len(trim(SNcodigo)) gt 0> 
            <cfquery name="rsSNid" datasource="#session.dsn#">
                select SNid from SNegocios 
                where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
                and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#">
            </cfquery>
            
             <cfif isdefined('rsSNid') and rsSNid.recordcount gt 0 and len(trim(rsSNid.SNid)) gt 0> 
               <cfset LvarSNid =  rsSNid.SNid> 
             <cfelse>
                <cfthrow message="No se pudo obtener el ID del socio de negocios para el socio codigo:  #SNcodigo#">  
             </cfif> 
        </cfif>
    
		<!---***********************************************************************--->
		<!---******** INICIA PROCESO  CANCELACION DE DOCUMENTOS             ********--->
		<!---******** SE CREARA UNA NUEVA TRANSACCION DE TIPO               ********--->
		<!---******** NOTA DE CREDITO. SE TOMARA LA INFORMACION DE          ********--->
		<!---******** HDOCUMENTOS Y HDDOCUMENTOS PARA INSERTAR EN           ********--->
        <!---******** DOCUMENTOS Y DDOCUMENTOS.                             ********--->
		<!---******** SE BUSCAN LAS TRANSACCIONES PARA EL CASO DE QUE       ********---> 
		<!---******** VENGAN POR FACTURACION PARA INSERTAR EN               ********--->
		<!---******** ETRANSACCIONES Y DTRANSACCIONES.                      ********--->
		<!---******** Lo unico que cambia es CCTcodigo el cual es           ********--->
		<!---******** sustituido por tipo Nota de Credito                   ********--->
		<!---***********************************************************************--->
		
		<cfset llave =-1>
		<cftransaction>
        	
			<cfquery name="rsTran" datasource="#session.DSN#">
                select FCid,ETnumero
                from ETransacciones et
                where et.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                and et.ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#transaccion#">
                and et.FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#caja#">
                and et.ETestado  = 'C'
                and not exists (select 1 
                				from ETransacciones
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                				and ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#transaccion#">
				                and FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#caja#">
                                and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"    value="NC">)
            </cfquery>
            
           <cfif rsTran.recordcount gt 0>
            	<cfquery name="rsETnumero" datasource="#arguments.conexion#">	
                    select coalesce(max(ETnumero),0)+1 as ETnumero from ETransacciones 
                    where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
                </cfquery>
                
                <cfquery name="insertEncabezado" datasource="#arguments.conexion#">
                    insert into ETransacciones(
                        FCid, ETnumero, Ecodigo, Ocodigo, SNcodigo, Mcodigo,
                        ETtc, CCTcodigo, Ccuenta, Tid, FACid, ETfecha, ETtotal,  
                        ETestado, Usucodigo, Ulocalizacion, Usulogin, ETporcdes, 
                        ETmontodes, ETimpuesto, ETnumext, ETnombredoc, ETobs, ETdocumento,
                        ETserie, IDcontable, ETimpresa, CFid
                    )
                    select FCid, #rsETnumero.ETnumero#, Ecodigo, Ocodigo, SNcodigo, Mcodigo,
                    ETtc, 'NC', Ccuenta, Tid, FACid, ETfecha, ETtotal,
                    ETestado, #session.usucodigo#, Ulocalizacion, '#Session.usuario#', ETporcdes,
                    ETmontodes, ETimpuesto, ETnumext, ETnombredoc, ETobs, ETdocumento,
                    ETserie, IDcontable, ETimpresa, CFid
                    from ETransacciones
                    where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
                    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTran.FCid#">
                    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTran.ETnumero#">
                </cfquery>
                
                <cfquery name="insertDetalle" datasource="#arguments.conexion#">
                    insert into DTransacciones(
                        FCid, ETnumero, Ecodigo, DTtipo, Aid, Alm_Aid, Ccuenta,
                        Ccuentades, Cid, FVid, Dcodigo, DTfecha, DTcant, DTpreciou,
                        DTdeslinea, DTtotal, DTborrado, DTdescripcion, DTdescalterna,
                        DTlineaext, DTcodigoext, CFid, DTreclinea, Ocodigo, CFcuenta,
                        DTimpuesto,	Icodigo

                    )
                    select FCid, #rsETnumero.ETnumero#, Ecodigo, DTtipo, Aid, Alm_Aid, Ccuenta,
                    Ccuentades, Cid, FVid, Dcodigo, DTfecha, DTcant, DTpreciou,
                    DTdeslinea, DTtotal, DTborrado, DTdescripcion, DTdescalterna,
                    DTlineaext, DTcodigoext, CFid, DTreclinea, Ocodigo, CFcuenta,
                    DTimpuesto,	Icodigo
                    from DTransacciones
                    where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
                    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTran.FCid#">
                    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTran.ETnumero#">
                </cfquery>
            <cfelse>
            	<cfquery name="insertEncabezado" datasource="#arguments.conexion#">
                    insert into Documentos(
                        Ecodigo, CCTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo,
						Ccuenta, Rcodigo, Icodigo, Dtipocambio, Dtotal, Dsaldo, Dfecha,
						Dvencimiento, DfechaAplicacion, Dtcultrev, Dusuario, Dtref, Ddocref,
                        Dmontoretori, Dretporigen, Dreferencia, DEidVendedor, DEidCobrador,
						id_direccionFact, id_direccionEnvio, CFid, DEdiasVencimiento, DEordenCompra,
						DEnumReclamo, DEobservacion, DEdiasMoratorio,  
                        EDtipocambioVal, EDtipocambioFecha,	EDid, CDCcodigo, TESRPTCid, TESRPTCietu
                    )
                    select 
                    Ecodigo, 'NC', Ddocumento, Ocodigo, SNcodigo, Mcodigo,
					Ccuenta, Rcodigo, Icodigo, Dtipocambio, Dtotal, Dsaldo, Dfecha,
					Dvencimiento, DfechaAplicacion, Dtcultrev, #Session.usucodigo#,Dtref,Ddocref,
					Dmontoretori, Dretporigen, Dreferencia, DEidVendedor, DEidCobrador,
					id_direccionFact, id_direccionEnvio, CFid, DEdiasVencimiento, DEordenCompra,
					DEnumReclamo, DEobservacion, DEdiasMoratorio, 
                    EDtipocambioVal,EDtipocambioFecha, EDid, CDCcodigo, TESRPTCid, TESRPTCietu
                    from HDocumentos
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                      and HDid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.HDid#">
                </cfquery>
                
                <cfquery name="insertDetalle" datasource="#arguments.conexion#">
                    insert into DDocumentos(
                        Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, DDlinea, Ccuenta,
						Alm_Aid, Dcodigo, DDtotal, DDcodartcon, DDtipo, DDcantidad, DDpreciou, DDdesclinea,
						DDcostolin, DDescripcion, DDdescalterna, Icodigo, CFid, OCTid, OCIid, DDid, DocrefIM,
						CCTcodigoIM, cantdiasmora, ContractNo, OCid, EDid, Ocodigo, DcuentaT, DesTransitoria
                    )
                    select Ecodigo, 'NC', Ddocumento, CCTRcodigo, DRdocumento, DDlinea, Ccuenta,
					Alm_Aid, Dcodigo, DDtotal, DDcodartcon, DDtipo, DDcantidad, DDpreciou, DDdesclinea,
					DDcostolin, DDescripcion, DDdescalterna, Icodigo, CFid, OCTid, OCIid, DDid, DocrefIM
					CCTcodigoIM, cantdiasmora, ContractNo, OCid, EDid, Ocodigo, DcuentaT, DesTransitoria
                    from HDDocumentos
                    where Ecodigo = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">
                      and HDid	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.HDid#">
                </cfquery>    
			</cfif>
            
			<!---**** SE BUSCAN LOS PAGOS ASOCIADOS AL DOCUMENTO, SI EXISTEN SE CREA UN ANTICIPO ****--->
            <cfquery name="rsPagosDoc" datasource="#arguments.conexion#">
            	select sum(Dtotalloc) as MontoNC from BMovimientos 
                where DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
 				and CCTRcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
                and Ecodigo       = <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">	               
            </cfquery>
           
            <cfif rsPagosDoc.recordcount gt 0>
            	<cfquery name="CuentaE" datasource="#Session.DSN#">
                    select Pvalor  as Ccuenta
                    from Parametros 
                    where Pcodigo = 650
                        and Ecodigo = #session.Ecodigo#
            	</cfquery>
				<cfif isdefined('CuentaE') and CuentaE.recordcount eq 0>
                  <cfthrow message="No se ha definido una cuenta de dep&oacute;sitos en tr&aacute;nsito en par&aacute;metros adicionales!">
                </cfif>
                <cfset LvarCcuenta = CuentaE.Ccuenta>
            
                <cfquery name="rsTranNCre" datasource="#arguments.conexion#">
                    select Pvalor
                    from Parametros 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                     and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="575">
                </cfquery>
                <cfif not isdefined("rsTranNCre.Pvalor") and len(trim(rsTranNCre.Pvalor)) eq 0>
                    <cfthrow message="No se ha definido la Transacci&oacute;n de Notas de Cr&eacute;dito en parametros adicionales!">
                </cfif>
                
                <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select Pvalor as CCTcodigo
                    from Parametros 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                     and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="2930">
                </cfquery> 
                <cfif not isdefined("rsTransfer.CCTcodigo") and len(trim(rsTransfer.CCTcodigo)) eq 0>
                    <cfthrow message="No se ha definido la Transacci&oacute;n de Pago para Cancelaci&oacute;n de Documentos en parametros adicionales!">
                </cfif>
                
                <cfset LvarPcodigo = trim(arguments.Ddocumento)&"_NC">
                <cfinvoke method="InsertaPago" returnvariable="LvarPago" 
                    CCTcodigo     ="#rsTransfer.CCTcodigo#" 
                    Mcodigo       ="#Mcodigo#" 
                    Pcodigo       ="#LvarPcodigo#"
                    Ptipocambio   ="#TCambio#" 
                    Observaciones ="Cobro generado desde cancelacion" 
                    Ocodigo       ="#Ocodigo#" 
                    Ccuenta       ="#LvarCcuenta#" 
                    SNcodigo      ="#SNcodigo#" 
                    Ptotal        ="#rsPagosDoc.MontoNC#">
            	</cfinvoke>
            	
                <cfif isdefined("LvarPago") and LvarPago eq true>
                    <cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_AltaAnticipo" returnvariable="LineAnticipo">
                        <cfinvokeargument name="Conexion" 	    value="#arguments.conexion#">
                        <cfinvokeargument name="Ecodigo"        value="#arguments.Ecodigo#">
                        <cfinvokeargument name="CCTcodigo"      value="#rsTransfer.CCTcodigo#">
                        <cfinvokeargument name="Pcodigo"       	value="#LvarPcodigo#">
                        <cfif isdefined('id_direccionFact') and len(trim(id_direccionFact))>
                            <cfinvokeargument name="id_direccion"   value="#id_direccionFact#">
                        </cfif>
                        <cfinvokeargument name="NC_CCTcodigo"   value="#rsTranNCre.Pvalor#">
                        <cfinvokeargument name="NC_Ddocumento"  value="#LvarPcodigo#">
                        <cfinvokeargument name="NC_Ccuenta"     value="#Ccuenta#">
                        <cfinvokeargument name="NC_fecha"       value="#Dfecha#">
                        <cfinvokeargument name="NC_total"       value="#rsPagosDoc.MontoNC#">
                        <cfinvokeargument name="NC_RPTCietu"    value="2">
                        <cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
                    </cfinvoke>
                </cfif>
                <cfinvoke 		 component= "sif.Componentes.PRES_Presupuesto"	 method	= "CreaTablaIntPresupuesto"  Conexion = "#session.dsn#" returnvariable="IntPresup"/> 
                <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#" method="CreaIntarc" CrearPresupuesto="false" returnvariable="INTARC"/>             
            	<cfinvoke component="sif.fa.operacion.CostosAuto" Conexion="#session.dsn#" method="CreaCostos" returnvariable="Tb_Calculo"/>
                
				<cfif isdefined("LineAnticipo") and LineAnticipo gt 0>
                    <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
                                Ecodigo 	 = "#session.Ecodigo#"
                                CCTcodigo	 = "#rsTransfer.CCTcodigo#"
                                Pcodigo		 = "#LvarPcodigo#"
                                usuario  	 = "#session.usulogin#"
                                SNid         = "#LvarSNid#" 
                                Tb_Calculo   = "#Tb_Calculo#"
                                debug		 = "false"
                                PintaAsiento = "false"
                                transaccionActiva = "true"
                                INTARC="#INTARC#"/>
                </cfif>   
                <cfquery name="rsInt" datasource="#session.dsn#">
                    select * from #INTARC#
                </cfquery>                        
                
                <cfquery name="rsDel" datasource="#session.dsn#">
                    delete from #INTARC#
                </cfquery>
                        
                <cfquery name="rsIntPres" datasource="#session.dsn#">
                    delete from #IntPresup#
                </cfquery>
                                    
                <cfquery name="rsDel" datasource="#session.dsn#">
                    delete from #INTARC#
                </cfquery>
            </cfif>
            
            <cfquery name="rsUpdDocumentos" datasource="#session.dsn#">
            	update HDocumentos set Danulado = 1
			 	where Ecodigo 		= #arguments.Ecodigo#
			   	and HDid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.HDid#">
            </cfquery>
		</cftransaction>
	</cffunction>
    
  <!----Funciona Insertar Encabezados el documento de cobro----->  
  <cffunction name="InsertaPago" access="public" returntype="any">
       <cfargument name='CCTcodigo'     type="string"    required="yes">
       <cfargument name='Pcodigo'       type="string"    required="yes">		 
       <cfargument name='Mcodigo'       type='numeric'   required="yes">		
       <cfargument name='Ptipocambio'   type="numeric"   required="yes">
       <cfargument name='Ptotal'        type="numeric"   required="yes">		
       <cfargument name='Observaciones' type="string"    required="yes">	
       <cfargument name='Ocodigo'       type="string"    required="yes">
       <cfargument name='SNcodigo'      type="string"    required="yes">
       <cfargument name='Ccuenta'       type='numeric'   required="yes">	   
       <cfargument name='Preferencia'   type='string'    required="no" default="null">
       
       	           
       <cfquery datasource="#Session.DSN#" name="rsInsertP">
           insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado, 
                            Ccuenta, Ptotal, Pfecha, Pobservaciones, Ocodigo, SNcodigo,
                           Pusuario,Preferencia)
           values 
           (
               #Session.Ecodigo#,
               <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">,
               <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">,
               <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
               <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Ptipocambio#">,
               0,
               <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaE.Ccuenta#">,
               <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Ptotal#">,
               <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 					
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Preferencia#">                    
           )                  
       </cfquery>		
        
       <cfquery datasource="#Session.DSN#" name="rsPagosValida">
           select count(1) as lineas from  Pagos where 
           Ecodigo=  #Session.Ecodigo# and 
           CCTcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#"> and 
           Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">				                                 
       </cfquery>	            
       <cfset LvarMyId  =  rsPagosValida.lineas>
        
       <cfif isdefined('LvarMyId') and LvarMyId gt 0>
       	<cfreturn true>
       <cfelse>
       	<cfreturn false>
       </cfif>                                            
  </cffunction> 
  
</cfcomponent>
