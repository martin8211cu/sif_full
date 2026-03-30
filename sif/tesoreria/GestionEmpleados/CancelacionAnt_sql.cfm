<!---<cf_dump var = "#CanComision#">--->

<cf_dbfunction name="OP_concat" returnvariable="_CAT">
<cfset LvarTipo='ANTICIPO'>
<cfset FormaPago = "#url.FormaPago#">
<cfset CanComision = "#url.CanComision#">



<cftransaction>
	<cftry>

    		<cfquery name="rsAnticipo" datasource="#session.dsn#">
					select 	a.CCHTid,a.TESSPid as TESSPid,coalesce(GEAtotalOri,0) as GEAtotalOri,c.GEAid, a.GEAnumero, GEADmonto, GEADutilizado,
                    	GEAmanual,a.CCHid, a.CPNAPnum, a.Mcodigo, a.GECid as GECid_comision, a.Ecodigo, GEAfechaSolicitud, GECnumero, 
                        'CANC.ANT-'#_CAT# <cf_dbfunction name="to_char" args="a.GEAnumero"> as Documento, a.CFcuenta,GEAdescripcion,GEAfechaPagar
				 	 from GEanticipo a
						inner join GEanticipoDet c
						on c.GEAid=a.GEAid
						inner join GEcomision co
						on co.GECid = a.GECid
					 where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">	
				</cfquery>


    <cfquery name="rsCajaChica" datasource="#session.dsn#">
        select d.CCHcodigo, d.CCHid, a.CCHTid, d.CCHtipo
        from  CCHTransaccionesProceso a
            inner join CCHica d
                inner join CFuncional cf
                on cf.CFid=d.CFid
            on 	d.CCHid=a.CCHid									
        where a.CCHTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAnticipo.CCHTid#">

	</cfquery>

 <cfif rsAnticipo.TESSPid  NEQ '' and FormaPago EQ 0>


 				 <cfquery name = "rsEstatusSol" datasource="#session.dsn#">
                 
					select b.TESSPestado as Estado,b.TESSPid from GEanticipo a
					inner join TESsolicitudPago b
					on a.TESSPid = b.TESSPid
					where a.GEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
                
                </cfquery>
               
			<cfif rsEstatusSol.Estado EQ 2>
       
				  <cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
                  <cfset LobjControl.CreaTablaIntPresupuesto (#session.dsn#,false,false,true)/>
			
				  <cfif rsAnticipo.CPNAPnum NEQ "0">  
                        <cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP">
                        <cfinvokeargument name="SPid" value="#rsAnticipo.TESSPid#">
                        <cfinvokeargument name="fechaPagoDMY" value="#LSDateFormat(rsAnticipo.GEAfechaPagar,'dd/mm/yyyy')#">
                        <cfinvokeargument name="generarOP" value="false">
                        <cfinvokeargument name="NAP" value="-1">
                        <cfinvokeargument name="GEAid" 	value="#rsAnticipo.GEAid#">		
                        <cfinvokeargument name="PRES_Origen" 		value="TEAE">
                        <cfinvokeargument name="PRES_Documento" 	value="#rsAnticipo.GEAnumero#">
                        <cfinvokeargument name="PRES_Referencia" 	value="GE.ANT,CANCELA">
                        <cfinvokeargument name="Cancela"		 	value = "#url.LvarCancela#">
                        </cfinvoke>
                    </cfif>
                    
                    <cfquery datasource="#session.dsn#">
                        update TESsolicitudPago
                        set TESSPestado 	= 13,
                        TESSPmsgRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">,
                        UsucodigoRechazo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        TESSPfechaRechazo 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        where TESid 		= #session.Tesoreria.TESid#
                        and TESSPid 		= #rsAnticipo.TESSPid#
                	</cfquery>
                
					<!---Actualiza el estado de las transacciones En proceso--->
                    <cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
                        <cfinvokeargument name="CCHTid"    value="#rsAnticipo.CCHTid#"/>
                        <cfinvokeargument name="CCHTestado" value="CANCELADO"/>
                        <cfinvokeargument name="CCHtipo" value="ANTICIPO"/>
                        <cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
                        <cfinvokeargument name="CCHTrelacionada"    value="#url.GEAid#"/>
                    </cfinvoke>

					<!--- Actulización del estado del Anticipo--->
                    <cfquery name="rsActualizaAnticipo" datasource="#session.DSN#">
                        update GEanticipo set 
                                    GEAestado =7,<!---Cancelado RVD--->
                                    GEAmsgRechazo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">
                        where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
                        and Ecodigo=#session.Ecodigo#
                    </cfquery>
          
				<cfif CanComision EQ 1>
                    <cfquery name="rsActualizaComision" datasource="#session.DSN#">
                    update GEcomision set 
                           GECestado = 6<!---Cancelada por Anticipo no pagado--->
                           where GECid = #rsAnticipo.GECid_comision#
                    and Ecodigo=#session.Ecodigo#
                    </cfquery>
              	</cfif>
             
	<cfelseif rsEstatusSol.Estado EQ 10 or rsEstatusSol.Estado EQ 11 or  rsEstatusSol.Estado EQ 110>


         <!---  <cftransaction>--->
            	<cfquery name="rsSolicitudOP" datasource="#session.dsn#">
					select a.TESSPid,a.TESOPid,a.TESSPestado,b.TESOPestado,a.NAP,d.CPNAPdocumentoOri,a.TESSPnumero,a.EcodigoOri,
                    d.CPNAPmoduloOri, b.TESMPcodigo,b.TESCFDnumFormulario,b.CBidPago,
                    (select CPNAPnum from CPNAP where Ecodigo=a.EcodigoOri and CPNAPmoduloOri = 'TEAE'
                    and CPNAPdocumentoOri=rtrim(convert (varchar(255),a.TESSPnumero))) as NAPRev,b.TESCFLid
                    from TESsolicitudPago a
                    inner join TESordenPago b
                    on a.TESOPid = b.TESOPid
                    inner join TESdetallePago c
                    on b.TESOPid = c.TESOPid
                    inner join CPNAP d
                    on a.NAP = d.CPNAPnum
					where a.TESSPid = #rsAnticipo.TESSPid#
                                
                </cfquery>
                
				<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
                <cfset LobjControl.CreaTablaIntPresupuesto (#session.dsn#,false,false,true)/>

  	<cfif trim(rsSolicitudOP.TESMPcodigo) EQ 'TRM'>

  

                <cfquery  datasource="#session.dsn#">
					update TESordenPago
	                set TESOPestado	= 13,
                    TESOPmsgRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">,
                    UsucodigoCancelacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    TESOPfechaCancelacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				    where TESid		= #session.Tesoreria.TESid#
				    and TESOPid		= #rsSolicitudOP.TESOPid#
				</cfquery>
                
                <cfquery datasource="#session.dsn#">
                   update TESsolicitudPago
                    set TESSPestado 	= 13,
                    TESSPmsgRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">,
					UsucodigoRechazo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    TESSPfechaRechazo 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                    where TESid 		= #session.Tesoreria.TESid#
                    and TESSPid 		= #rsAnticipo.TESSPid#
                </cfquery>
                
                <cfquery datasource="#session.dsn#">
                    update TESdetallePago
                    set TESDPestado 	= 13
                    where TESid 		= #session.Tesoreria.TESid#
                    and TESOPid 		= #rsSolicitudOP.TESOPid#
                </cfquery>
                
	 <cfelse>
  
  
        	
				<cfif isdefined("rsSolicitudOP.TESCFDnumFormulario") and isdefined("rsSolicitudOP.TESCFLid")>

                     <cfquery datasource="#session.DSN#">
                        update TEScontrolFormulariosD
                          set TESCFDestado = 3, 
                          TESCFDmsgAnulacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">,
                          UsucodigoAnulacion	= #session.Usucodigo#,
                          TESCFDfechaAnulacion	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                        where  TESid				= #session.Tesoreria.TESid#
                        and CBid					= #rsSolicitudOP.CBidPago#
                        and TESMPcodigo			= '#rsSolicitudOP.TESMPcodigo#'
                        and TESCFDnumFormulario	= #rsSolicitudOP.TESCFDnumFormulario#
                    </cfquery>
            
               <!---  ACTUALIZA LOS REGISTROS DEL FORMULARIO EN LA BITACORA DE FORMULARIOS --->
                    <cfquery datasource="#session.DSN#">
                        update TEScontrolFormulariosB
                           set TESCFBultimo = 0
                         where  TESid				= #session.Tesoreria.TESid#
                           and CBid					= #rsSolicitudOP.CBidPago#
                           and TESMPcodigo			= '#rsSolicitudOP.TESMPcodigo#'
                           and TESCFDnumFormulario	= #rsSolicitudOP.TESCFDnumFormulario#
                    </cfquery>
                
            
                    <cfquery datasource="#session.dsn#">
                        insert into TEScontrolFormulariosB
                            (
                                TESid, CBid, TESMPcodigo,TESCFDnumFormulario, 
                                TESCFBfecha, TESCFEid, TESCFLUid, TESCFBultimo, UsucodigoCustodio, TESCFBfechaGenera, UsucodigoGenera, BMUsucodigo
                            )
                        select 	 TESid, CBid, TESMPcodigo,TESCFDnumFormulario,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
                                 (select min(TESCFEid) from TESCFestados where TESid = #session.Tesoreria.TESid# and TESCFEanulado = 1),
                                 <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                                 1,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                                 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                          from TEScontrolFormulariosD
                         where TESid			   = #session.Tesoreria.TESid#
                          and CBid					= #rsSolicitudOP.CBidPago#
                           and TESMPcodigo			= '#rsSolicitudOP.TESMPcodigo#'
                           and TESCFDnumFormulario	= #rsSolicitudOP.TESCFDnumFormulario#
                    </cfquery>
				
            </cfif>

        
        <!--- MODIFICAR ESTADO DE LA ORDEN DE COMPRA Y LA SOLICITUD DE LA  ORDEN --->
	<cfquery datasource="#session.dsn#">
		update TESsolicitudPago
		   set TESSPestado 	= 13,	
               TESSPmsgRechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">,
	           UsucodigoRechazo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
               TESSPfechaRechazo = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		   where TESid = #session.Tesoreria.TESid#
		   and TESOPid = #rsSolicitudOP.TESOPid#
		   and TESSPestado 	in (10,11,110)
	</cfquery>	
        
    <cfquery datasource="#session.dsn#">
		update TESdetallePago 
		   set TESDPestado	= 13	
	       where TESid 		= #session.Tesoreria.TESid#
		   and TESOPid 		=  #rsSolicitudOP.TESOPid#
		   and TESDPestado 	in (10,11,110)
    </cfquery>
               
    <cfquery datasource="#session.dsn#">
		update TESordenPago
		   set TESOPestado	= 13,	
			   TESOPmsgRechazo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">,
               UsucodigoCancelacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
               TESOPfechaCancelacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
               TESTLid = null,
               TESCFLid = null,
               TESCFDnumFormulario = null
	       where TESid 		= #session.Tesoreria.TESid#
		   and TESOPid 		= #rsSolicitudOP.TESOPid#
		   and TESOPestado 	in (10,11,110)
	</cfquery>	
  
        
 </cfif>
        
        
                
            <cfif rsSolicitudOP.NAP NEQ "0">
            
                <cfinvoke component="sif.tesoreria.Componentes.TESaplicacion" method="sbAprobarSP">
                    <cfinvokeargument name="SPid" value="#rsSolicitudOP.TESSPid#">
                    <cfinvokeargument name="fechaPagoDMY" value="#LSDateFormat(rsAnticipo.GEAfechaPagar,'dd/mm/yyyy')#">
                    <cfinvokeargument name="generarOP" value="false">
                    <cfinvokeargument name="NAP" value="-1">
                    <cfinvokeargument name="GEAid" 	value="#rsAnticipo.GEAid#">		
                    <cfinvokeargument name="PRES_Origen" value="TEAE">
                    <cfinvokeargument name="PRES_Documento" value="#rsAnticipo.GEAnumero#">
                    <cfinvokeargument name="PRES_Referencia" value="GE.ANT,CANCELA">
                    <cfinvokeargument name="Cancela"value = "#url.LvarCancela#">
           		</cfinvoke>
            
    		<!---Actualiza el estado de las transacciones En proceso--->
                <cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
                    <cfinvokeargument name="CCHTid"    value="#rsAnticipo.CCHTid#"/>
                    <cfinvokeargument name="CCHTestado" value="CANCELADO"/>
                    <cfinvokeargument name="CCHtipo" value="ANTICIPO"/>
                    <cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
                    <cfinvokeargument name="CCHTrelacionada"    value="#url.GEAid#"/>
                </cfinvoke>

				<!--- Actulización del estado del Anticipo--->
               <cfquery name="rsActualizaAnticipo" datasource="#session.DSN#">
                   update GEanticipo 
                     set  GEAestado = 7,<!---Cancelado RVD--->
                          GEAmsgRechazo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">
                     where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
                     and Ecodigo=#session.Ecodigo#
               </cfquery>
        
        <cfif CanComision EQ 1>
               <cfquery name="rsActualizaComision" datasource="#session.DSN#">
                   update GEcomision 
                     set  GECestado = 6<!---Cancelada por Anticipo no pagado--->
                     where GECid = #rsAnticipo.GECid_comision#
                     and Ecodigo=#session.Ecodigo#
               </cfquery>
		</cfif>
			
    
                
            </cfif>
                	
<!---
            </cftransaction>--->
            
            
	 </cfif>
                
              
        
<cfelse>
<!---<cf_dump var = "Por Caja">--->

        <cfinvoke 	component="sif.tesoreria.Componentes.TESCajaChicaPresupuesto" method="CancelaAnticipo"returnVariable = "LvarNAP">
            <cfinvokeargument name="GEAid"       value="#rsAnticipo.GEAid#"/>	
            <cfinvokeargument name="CCHtipoCaja" value="#rsCajaChica.CCHtipo#"/>	
            <cfinvokeargument name="Comision"    value="#rsAnticipo.GECnumero#"/>	
        </cfinvoke>	


        <cfinvoke 	component="sif.tesoreria.Componentes.TEScajaChica" 	method="TranProceso" returnvariable="LvarCCHTidProc">
            <cfinvokeargument name="Mcodigo" 			value="#rsAnticipo.Mcodigo#"/>
            <cfif rsAnticipo.CFcuenta NEQ "">
                <cfinvokeargument name="CFcuenta" 			value="#rsAnticipo.CFcuenta#"/>
            </cfif>
            <cfinvokeargument name="CCHTid"  		    value="#rsAnticipo.CCHTid#"/>
            <cfinvokeargument name="CCHTdescripcion" 	value="#rsAnticipo.GEAdescripcion#"/>
            <cfinvokeargument name="CCHTmonto"	 		value="#rsAnticipo.GEAtotalOri#"/>
            <cfinvokeargument name="CCHTestado" 		value="CANCELADO"/>
            <cfinvokeargument name="CCHTtipo" 			value="ANTICIPO"/>
        </cfinvoke>
    

              
        <cfquery name = "Transacciones" datasource="#session.DSN#">
           select a.CCHTid, b.CCHTCid from CCHTransaccionesProceso a
           inner join CCHTransaccionesCProceso b
           on a.CCHTid = b.CCHTid
           and b.CCHTCrelacionada = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
        </cfquery>

		<!---Actualiza el estado de las transacciones En proceso--->
		<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="CambiaEstadoTP">
			<cfinvokeargument name="CCHTid"    value="#rsAnticipo.CCHTid#"/>
			<cfinvokeargument name="CCHTestado" value="CANCELADO"/>
			<cfinvokeargument name="CCHtipo" value="ANTICIPO"/>
            <cfinvokeargument name="CCHTtrelacionada"   value="ANTICIPO"/>
			<cfinvokeargument name="CCHTrelacionada"    value="#url.GEAid#"/>
		</cfinvoke>
		
		<cfinvoke 	component="sif.tesoreria.Componentes.TESCustodio" method="CambiaEstadoTCP">
			<cfinvokeargument name="CCHTCestado"        value="CANCELADO"/>
			<cfinvokeargument name="CCHTtipo"       	value="ANTICIPO"/>
			<cfinvokeargument name="CCHTCconfirmador"	value="#session.usucodigo#"/>
			<cfinvokeargument name="CCHTCrelacionada"   value="#url.GEAid#"/>
			<cfinvokeargument name="CCHTCid"         	value="#Transacciones.CCHTCid#"/>
		</cfinvoke>


    
        <cfquery name="updTA" datasource="#session.dsn#">
			update CCHTransaccionesAplicadas
            set CCHTAestado = 'CANCELADO',
            CCHTAmsjrechazo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">
            where CCHTAtranRelacionada = #rsAnticipo.CCHTid#
            and CCHid = #rsAnticipo.CCHid#
        </cfquery>


		<!--- Actulización del estado del Anticipo--->
        <cfquery name="rsActualiza" datasource="#session.DSN#">
            update GEanticipo 
               set 	GEAestado = 7,<!---Cancelado RVD--->
                    GEAmsgRechazo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.GEAmsgRechazo#">
             where GEAid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.GEAid#">
               and Ecodigo=#session.Ecodigo#
        </cfquery>
        
		<cfif CanComision EQ 1>
            <cfquery name="rsActualizaComision" datasource="#session.DSN#">
                update GEcomision
                   set GECestado = 6<!---Cancelada por Anticipo no pagado--->
                where GECid = #rsAnticipo.GECid_comision#
                and Ecodigo=#session.Ecodigo#
            </cfquery>
		</cfif>
        
  </cfif>
        
        


        <cfcatch type="database">
 			<cftransaction action="rollback">
           <cfabort showerror="#cfcatch.detail#"><!---NativeErrorCode o detail--->
          </cfcatch>
        </cftry>
     </cftransaction>
<cflocation url="CancelacionAnticipo.cfm">

