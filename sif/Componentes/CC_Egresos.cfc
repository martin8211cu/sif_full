<!---Bernal 06/08/14
Proceso de asientos
1. Generacion de la factura de CxC
	CxC cliente-Agencia		500
		Ingreso 				500

Caso en que la Agencia se rebaja la comision en el pago de la factura
	2.Pago de la factura con Rebajo de la comision
		Comision (CxP Cliente-Agencia)	100
		Pago (Cuenta Caja/Banco)		400
			CxC cliente - Agencia			500
	3. Generacion del lote de comision
		Comsion (cuenta segun comision y rubro)	100
			CxP Cliente - Agencia					100
	4. Como ya el cliente se rebajo la comision con el pago de la factura el sistema genera automaticamente un documento que cancela la CxP con un asiento nulo
		CxP Cliente-Agencia		100
			CxP Cliente-Agencia		100


Caso en que la Agencia paga la factura sin rebajarse la comision
	2.Pago de la factura sin Rebajo de la comision
		Pago (Cuenta Caja/Banco)	500
			CxC cliente - Agencia		500
	3. Generacion del lote de comision
		Comsion (cuenta segun comision y rubro)	100
			CxP Cliente - Agencia					100
	4.El sistema genera una SP automatica y cuando se paga la SP se genera el asiento
		CxP Cliente-Agencia	100
			Banco				100
 
--->
<cfcomponent>
	<!---Obtienen Montos Totales--->
	<cffunction name="CC_GetTotalesEgresos"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
        <cfargument name="Modulo" 			type="string"  required="no" hint="CC:cuentas por cobrar, FC:facturacion">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getTotalesEgresos" datasource="#Arguments.Conexion#">
			select 
            	(select sum( 
                    	  case when  VolumenGNCheck 		= 1 then VolumenGN 			else 0 end
                        + case when  VolumenGLRCheck 		= 1 then VolumenGLR 		else 0 end
                        + case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		else 0 end
                        + case when  ProntoPagoCheck 		= 1 then ProntoPago 		else 0 end
                        + case when  ProntoPagoClienteCheck = 1 then ProntoPagoCliente 	else 0 end
                        + case when  montoAgenciaCheck 		= 1 then montoAgencia 		else 0 end
                        )  
                        	from COMFacturas comf
                            where comf.PcodigoE 	= a.Pcodigo
                            and   comf.CCTcodigoE	= a.CCTcodigo
                        ) as ComisionesEncabezado 
                     , (select coalesce(sum( DPmontoretdoc),0)  
                        	from DPagos dp
                            where dp.Pcodigo 	= a.Pcodigo
                            and   dp.CCTcodigo	= a.CCTcodigo
                        ) as RetencionesEnc   
                     , (select coalesce(sum( COMDmonto),0)  
                        	from COMDiferencias comd
                            where comd.PcodigoE 	= a.Pcodigo
                            and   comd.CCTcodigoE	= a.CCTcodigo
                        ) as DiferenciaEnc
            
			 from 
             <cfif arguments.Modulo eq "CC">Pagos </cfif> a
			 where a.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			   and rtrim(a.CCTcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			   and rtrim(a.Pcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
		</cfquery>
		<cfreturn getTotalesEgresos>
	</cffunction>
    
	<cffunction name="CC_GetDiferencias"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
        <cfargument name="Modulo" 			type="string"  required="no" hint="CC:cuentas por cobrar, FC:facturacion">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getDiferencias" datasource="#Arguments.Conexion#">
			select coalesce(COMDmonto,0) as COMDmonto , comd.DIFEcodigo, cf.Ccuenta
			 	from 
            	 <cfif arguments.Modulo eq "CC">Pagos </cfif> a
                 inner join COMDiferencias comd
                 	on comd.PcodigoE 	= a.Pcodigo
                	and comd.CCTcodigoE	= a.CCTcodigo
                 inner join DIFEgresos dife 
                 	on dife.DIFEcodigo = comd.DIFEcodigo
                    and dife.Ecodigo =  comd.Ecodigo
                 inner join CFinanciera cf
                 	on cf.CFcuenta = dife.CFcuenta   
			 where a.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			 	and rtrim(a.CCTcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			   	and rtrim(a.Pcodigo) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
            
		</cfquery>
		<cfreturn getDiferencias>
	</cffunction>
    
	<cffunction name="CC_GetComisionesGeneral"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getComisiones" datasource="#Arguments.Conexion#">
			select 
				sum(case when  VolumenGNCheck			= 1 then VolumenGN 			else 0 end) as VolumenGN, 
				sum(case when  VolumenGLRCheck			= 1 then VolumenGLR 		else 0 end) as VolumenGLR,
				sum(case when  VolumenGLRECheck			= 1 then VolumenGLRE 		else 0 end) as VolumenGLRE,
				sum(case when  ProntoPagoCheck			= 1 then ProntoPago 		else 0 end) as ProntoPago,
				sum(case when  ProntoPagoClienteCheck	= 1 then ProntoPagoCliente 	else 0 end) as ProntoPagoCliente, 
				sum(case when  montoAgenciaCheck		= 1 then montoAgencia 		else 0 end) as montoAgencia, 
				Ddocumento, SNcodigoD
			 	from  COMFacturas a
			 where a.Ecodigo                = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			 	and rtrim(a.CCTcodigoE)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			   	and rtrim(a.PcodigoE) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
			group by Ddocumento, SNcodigoD
		</cfquery>
		<cfreturn getComisiones>
	</cffunction>
	
    <cffunction name="CC_GetComisionesDetalladas"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
		<cfargument name="Ddocumento"		type="string"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<cfquery name="getComisiones" datasource="#Arguments.Conexion#">
			select  c.CFid, b.Mcodigo, b.Ocodigo, c.CFComplemento , dp.DPtipocambio
			 	from  COMFacturas a
                inner join DPagos dp
                    on dp.Ddocumento = a.Ddocumento
                inner join Documentos b
                	on b.Ddocumento = a.Ddocumento
                	and b.CCTcodigo =a.CCTcodigoD
                inner join DDocumentos c
                	on c.Ddocumento = b.Ddocumento
                	and c.CCTcodigo =b.CCTcodigo 
				 inner join Conceptos d
                    on d.Cid = c.DDcodartcon
                    and d.Ecodigo = c.Ecodigo
                    and coalesce(Cclasificacion,0) not in (1,2,3)   <!---vales, nacionales, canjes--->                 
			 where a.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
			 	and rtrim(a.CCTcodigoE)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.CCTcodigo)#"> 
			   	and rtrim(a.PcodigoE) 	  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Pcodigo)#"> 
                and rtrim(a.Ddocumento)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(Arguments.Ddocumento)#"> 
                
		</cfquery>
		<cfreturn getComisiones>
	</cffunction>
    
  	<cffunction name="CC_InsertaIntarcComisiones">
        <cfargument name="INTARC"           type="string" required="yes">
		<cfargument name="Conexion" 	    type="string"  required="no">
		<cfargument name="Ecodigo" 	        type="string"  required="no">
		<cfargument name="CCTcodigo" 		type="string"  required="yes">
		<cfargument name="Pcodigo" 			type="string"  required="yes">
        <cfargument name="Modulo" 			type="string"  required="no" hint="CC:cuentas por cobrar, FC:facturacion">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

        <cfset rsComisionesGeneral = CC_GetComisionesGeneral(Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo)>
        
        <cfquery name="rsTraeSNid" datasource="#session.DSN#">
            select a.SNid 
            from SNegocios a
            where a.Ecodigo   = #Arguments.Ecodigo#
              and a.SNcodigo = #rsComisionesGeneral.SNcodigoD#
        </cfquery>
        
        <!---====Moneda local de la Empresa========--->
        <cfquery datasource="#session.DSN#" name="rsMonedaLocal">
            select Mcodigo
            from Empresas
            where Ecodigo = #Arguments.Ecodigo# 
        </cfquery>

        <cfloop query="rsComisionesGeneral">
            
        	<cfset rsComisionesDetalladas = CC_GetComisionesDetalladas(Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,rsComisionesGeneral.Ddocumento)>

            <cfloop query="rsComisionesDetalladas">
            	<!---Agencia--->
		        <cfif rsComisionesGeneral.montoAgencia gt 0 >
					<cfset LvarCidAgeCom  = ObtenerDato(15751).Pvalor>
		            <cfset rsConAgeCom  = ObtenerConceptos(#LvarCidAgeCom#)>  
		            
		            
		            <cfif len(trim(LvarCidAgeCom)) eq 0>
		               <cfthrow message="Falta de configuracion. No se ha definido el Concepto para la Comisi&oacute;n por Agencia en Par&aacute;metros Adicionales. Proceso Cancelado!">
		           	</cfif>

		            <cfif len(trim(rsConAgeCom.Cformato)) eq 0 >
		            	<cfthrow message="No se ha definido ni el complemento ni el formato del concepto codigo:#rsConAgeCom.Ccodigo# descr:#rsConAgeCom.Cdescripcion#
		                favor defina alguno en el catalago de conceptos de servicio">
		            </cfif>
		                 
		        </cfif>
				
				<cfif rsComisionesGeneral.montoAgencia gt 0 >
					
               		<cfset LvarMontoPorLinea = rsComisionesGeneral.montoAgencia / rsComisionesDetalladas.recordcount>
                    <cfset InsertaIntar (#INTARC#,Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,'CC',rsComisionesDetalladas.CFid,
							rsTraeSNid.SNid,rsConAgeCom.Cid, rsConAgeCom.Cformato, #LvarMontoPorLinea#, 'Agencia',<!---rsComisionesDetalladas.Mcodigo---> rsMonedaLocal.Mcodigo, 
							rsComisionesDetalladas.Ocodigo, rsComisionesDetalladas.CFComplemento, rsComisionesDetalladas.DPtipocambio,false )> 
                </cfif>
                <!---Pronto Pago--->
		       
				<cfif rsComisionesGeneral.ProntoPago gt 0 or rsComisionesGeneral.ProntoPagoCliente gt 0>
					<cfset LvarCidPPCom   = ObtenerDato(15752).Pvalor>
		            <cfset rsConPPCom   = ObtenerConceptos(#LvarCidPPCom#)>
		            
		            <cfif len(trim(LvarCidPPCom)) eq 0>
		               <cfthrow message="Falta de configuracion. No se ha definido el Concepto para la Comisi&oacute;n de Pronto Pago en Par&aacute;metros Adicionales. Proceso Cancelado!">
		           	</cfif>
					
					<cfif len(trim(rsConPPCom.Cformato)) eq 0>
		            	<cfthrow message="No se ha definido ni el complemento ni la cuenta del concepto codigo:#rsConPPCom.Ccodigo# descr:#rsConPPCom.Cdescripcion#
		                favor defina alguno en el catalago de conceptos de servicio">
		            </cfif>
		        </cfif>
				
				<cfif rsComisionesGeneral.ProntoPago gt 0 >
               		<cfset LvarMontoPorLinea = rsComisionesGeneral.ProntoPago / rsComisionesDetalladas.recordcount>
                    <cfset InsertaIntar (#INTARC#,Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,'CC',rsComisionesDetalladas.CFid,
							rsTraeSNid.SNid,rsConPPCom.Cid, rsConPPCom.Cformato, #LvarMontoPorLinea#, 'Pronto Pago',<!---rsComisionesDetalladas.Mcodigo---> rsMonedaLocal.Mcodigo, 
							rsComisionesDetalladas.Ocodigo , rsComisionesDetalladas.CFComplemento, rsComisionesDetalladas.DPtipocambio,false)> 
                </cfif>
				<cfif rsComisionesGeneral.ProntoPagoCliente gt 0 >
               		<cfset LvarMontoPorLinea = rsComisionesGeneral.ProntoPagoCliente / rsComisionesDetalladas.recordcount>
                    <cfset InsertaIntar (#INTARC#,Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,'CC',rsComisionesDetalladas.CFid,
							rsTraeSNid.SNid,rsConPPCom.Cid, rsConPPCom.Cformato, #LvarMontoPorLinea#, 'Pronto Pago Cliente',<!---rsComisionesDetalladas.Mcodigo---> rsMonedaLocal.Mcodigo, 
							rsComisionesDetalladas.Ocodigo, rsComisionesDetalladas.CFComplemento, rsComisionesDetalladas.DPtipocambio,true )> 
                </cfif>
                <!---Volumen--->
		        <cfif rsComisionesGeneral.VolumenGN gt 0 or rsComisionesGeneral.VolumenGLR gt 0 or  rsComisionesGeneral.VolumenGLRE gt 0>
					<cfset LvarCidVolCom  = ObtenerDato(15753).Pvalor>
		            <cfset rsConVolCom  = ObtenerConceptos(#LvarCidVolCom#)>
					
					<cfif len(trim(LvarCidVolCom)) eq 0>
		               <cfthrow message="Falta de configuracion. No se ha definido el Concepto para la Comisi&oacute;n por Volumen en Par&aacute;metros Adicionales. Proceso Cancelado!">
		           	</cfif>

					<cfif len(trim(rsConVolCom.Cformato)) eq 0>
		            	<cfthrow message="No se ha definido ni el complemento ni la cuenta del concepto codigo:#rsConVolCom.Ccodigo# descr:#rsConVolCom.Cdescripcion#
		                favor defina alguno en el catalago de conceptos de servicio">
		            </cfif>
		        </cfif>    
		        
				<cfif rsComisionesGeneral.VolumenGN gt 0  >
               		<cfset LvarMontoPorLinea = rsComisionesGeneral.VolumenGN / rsComisionesDetalladas.recordcount>
                    <cfset InsertaIntar (#INTARC#,Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,'CC',rsComisionesDetalladas.CFid,
							rsTraeSNid.SNid,rsConVolCom.Cid, rsConVolCom.Cformato, #LvarMontoPorLinea#, 'Volumen GN',<!---rsComisionesDetalladas.Mcodigo---> rsMonedaLocal.Mcodigo, 
							rsComisionesDetalladas.Ocodigo, rsComisionesDetalladas.CFComplemento, rsComisionesDetalladas.DPtipocambio,false)> 
                </cfif>
				<cfif  rsComisionesGeneral.VolumenGLR gt 0>
               		<cfset LvarMontoPorLinea = rsComisionesGeneral.VolumenGLR / rsComisionesDetalladas.recordcount>
                    <cfset InsertaIntar (#INTARC#,Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,'CC',rsComisionesDetalladas.CFid,
							rsTraeSNid.SNid,rsConVolCom.Cid, rsConVolCom.Cformato, #LvarMontoPorLinea#, 'Volumen GLR',<!---rsComisionesDetalladas.Mcodigo---> rsMonedaLocal.Mcodigo, 
							rsComisionesDetalladas.Ocodigo ,rsComisionesDetalladas.CFComplemento, rsComisionesDetalladas.DPtipocambio,false)> 
                </cfif>
				<cfif rsComisionesGeneral.VolumenGLRE gt 0 >
               		<cfset LvarMontoPorLinea = rsComisionesGeneral.VolumenGLRE / rsComisionesDetalladas.recordcount>
                    <cfset InsertaIntar (#INTARC#,Arguments.Conexion,Arguments.Ecodigo,Arguments.CCTcodigo,Arguments.Pcodigo,'CC',rsComisionesDetalladas.CFid,
							rsTraeSNid.SNid,rsConVolCom.Cid, rsConVolCom.Cformato, #LvarMontoPorLinea#, 'Volumen GLRE',<!---rsComisionesDetalladas.Mcodigo---> rsMonedaLocal.Mcodigo, 
							rsComisionesDetalladas.Ocodigo ,rsComisionesDetalladas.CFComplemento, rsComisionesDetalladas.DPtipocambio,false)> 
                </cfif>
            </cfloop>
        </cfloop>
	</cffunction>
    
  	<cffunction name="InsertaIntar">
        <cfargument name="INTARC"       type="string" required="yes">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="Ecodigo" 	    type="string"  required="no">
		<cfargument name="CCTcodigo" 	type="string"  required="yes">
		<cfargument name="Pcodigo" 		type="string"  required="yes">
        <cfargument name="Modulo" 		type="string"  required="no" hint="CC:cuentas por cobrar, FC:facturacion">
		<cfargument name="CFid" 	    type="numeric" required="yes">
		<cfargument name="SNid" 	    type="numeric" required="yes">
		<cfargument name="Cid" 			type="numeric" required="yes">
		<cfargument name="Cformato"		type="string" required="yes">
		<cfargument name="Monto"		type="numeric" required="yes">
		<cfargument name="Descrip"		type="string" required="yes">
		<cfargument name="Mcodigo"		type="numeric" required="yes">
		<cfargument name="Ocodigo"		type="numeric" required="yes">
		<cfargument name="CFComplemento"type="string"  required="yes" hint="Actividad empresarial. se usa en caso de que no exista el formato del concepto.">
		<cfargument name="DPtipocambio"	type="numeric" required="yes">
		<cfargument name="ArmaCuenta"	type="numeric" required="yes" hint="true si usa el aplicar mascara. Al inicio todos lo usuaban pero por solicitud de nacion solo PPC">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>               
        
        <cfif Arguments.ArmaCuenta>
            <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
            <cfset LvarCFformato = mascara.fnComplementoItem(Arguments.Ecodigo, Arguments.CFid, Arguments.SNid, "Comision", "", Arguments.Cid, "", "",Arguments.CFComplemento)>
                                                            <!---Ecodigo				CFid			SNid	tipoItem  ,Aid,     Cid	  ,  ACcdigo,Acid,    ActEcono--->
            <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                    <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                    <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/> 
                    <cfinvokeargument name="Lprm_Verificar_CFid" 	value="#Arguments.CFid#"/> <!---Usa el control de mascaras por centro funcional y usa la oficina del CF--->                    
            </cfinvoke>
        
            <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
                <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
                    select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                    from CFinanciera a
                        inner join CPVigencia b
                             on a.CPVid     = b.CPVid
                            and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                    where a.Ecodigo   = #Arguments.Ecodigo#
                      and a.CFformato = '#LvarCFformato#'
                </cfquery>
            </cfif>
            <cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
                <cfthrow message="#LvarCFformato# #LvarError#">
            <cfelseif rsTraeCuenta.CFcuenta EQ "">
                <cfthrow message="#LvarCFformato#, No existe Cuenta de Presupuesto">
            </cfif>
        <cfelse>
        	
<!---            <cfquery name="rsSNcuentacxp" datasource="#session.dsn#">
                 select SNcuentacxp
                    from Pagos a
                        inner join SNegocios b
                        on b.SNcodigo =  a.SNcodigo
                        and b.Ecodigo = a.Ecodigo                    	
                where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
            </cfquery>	
			A solicitud de GN, no se va a utilizar la cxp del socio para pago de comisiones, sino la cuenta transitoria que se encuentra en el parametro 15860. 		
			--->
            
            <cfset LvarCcuentaTransitoriaComision = ObtenerDato(15860).Pvalor>
            <cfif not isdefined('LvarCcuentaTransitoriaComision') or  not len(trim(LvarCcuentaTransitoriaComision))>
                 <cf_ErrorCode code="-1" msg="El parametro 'cuenta transitoria para cobro de comisiones', no esta difinido. Se debe de configurar para continuar."> 
            </cfif>
            
            <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
                select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                from CFinanciera a
                    inner join CPVigencia b
                         on a.CPVid     = b.CPVid
                        and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                where a.Ecodigo   = #Arguments.Ecodigo#
                  and a.Ccuenta = #LvarCcuentaTransitoriaComision#
            </cfquery>
        	
        </cfif>    
        
        <cfset LvarPeriodo 	=ObtenerDato(50).Pvalor>
        <cfset LvarMes 		=ObtenerDato(60).Pvalor>
        
        <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
        <cfquery name="rs" datasource="#session.dsn#">
             insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, 
             Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE
             	)
             select 'CCco', 1,'#arguments.Pcodigo#', '#arguments.CCTcodigo#', 
               	<!---round( #arguments.Monto#  / #arguments.DPtipocambio# * a.Ptipocambio ,2), --->
                round( #arguments.Monto# ,2),              
              	'D',
                'Comisiones: ' #_Cat# '#arguments.Descrip#',
                <cf_dbfunction name="to_char"	args="getdate(),112">,
                <!---case when #arguments.DPtipocambio# != a.Ptipocambio then #arguments.DPtipocambio# * a.Ptipocambio else 1.00 end,--->
                1,  <!---tipo cambio xq siempre es en colones--->
                #LvarPeriodo#, #LvarMes#, 
              	#rsTraeCuenta.Ccuenta#,#rsTraeCuenta.CFcuenta# ,
                #Arguments.Mcodigo#, #arguments.Ocodigo#,                  
              round( #arguments.Monto#,2)
                from Pagos a
            where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
        </cfquery>	

	</cffunction>
    
 	
	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
    <cffunction name="ObtenerDato" returntype="query">
        <cfargument name="pcodigo" type="numeric" required="true">	
        <cfquery name="rs" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #Session.Ecodigo#  
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
        </cfquery>
        <cfreturn rs>
    </cffunction>    
    
	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
	<!--- Se usa esta info para armar el CFformato --->
    <cffunction name="ObtenerConceptos" returntype="query">
        <cfargument name="Cid" type="numeric" required="true">	
        <cfquery name="rs" datasource="#Session.DSN#">
            select Cid, coalesce(Cformato,cuentac) as Cformato,  Ccodigo, Cdescripcion

 			from Conceptos
            where Ecodigo = #Session.Ecodigo#  
              and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
        </cfquery>
        <cfreturn rs>
    </cffunction>    
    
</cfcomponent>


