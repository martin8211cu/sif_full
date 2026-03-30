<!--- ABL: Integracion de Tesoreria PMI-CIM--->
<!--- La Integracion de Tesoreria, procesa todos lo pagos con cheque y cancelaciones y los envia a unas tablas intermedias para su proceso en el sistema de Tesoreria de PMI --->
<!--- La Interfaz solo funciona con versiones de Coldfusion 8.0 en adelante --->
<!--- Elaboró: Maria de los Angeles Blanco López 10 de Enero del 2011--->


<cfcomponent extends="Interfaz_Base">
	<cffunction name="Ejecuta" access="public" returntype="string" output="no">
    	<cfargument name="Disparo" required="no" type="boolean" default="false">
		<!--- Rutina para Obtener Parametros a Ocupar --->
		<cfset ParImp = true>
		<!--- Crear un Parametro Ver 2.0 --->
		<cfset ParBorrado = false>
		
		 <!---Obtiene los caches para la busqueda de las ordenes de compra --->
        <cfquery datasource="asp" name="rscaches">
            select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
            from Empresa e
                join Caches c
                on e.Cid = c.Cid and e.Ereferencia is not null
                and e.Ereferencia = 22
        </cfquery>
		
				<cfset RegistrosTes = CargarRegistrosTesoreria(rscaches)>	
				<cfset RegistrosTes = ValidaEquivalencias(rscaches)>	
				<cfset ValidaDatos = EnviaRegistrosTesoreria()>			
	</cffunction>		
		
    <cffunction name="CargarRegistrosTesoreria">
	   <cfargument name="rscaches" required="yes" type="query">
	   <cfset caches = #Arguments.rscaches#> 
	   <cfsilent>	  
	   <cfloop query="caches"> <!--- Caches loop --->
	   		<!---Invocar al GC para liberar memoria--->
            <cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
            <cfset javaRT.gc()><!--- invoca el GC --->
		
			<!---LEE LOS CHEQUES ENTREGADOS --->
			<cfquery  name="rsCTesoreria" datasource="#caches.Ccache#">
				select OP.TESOPid, OP.EcodigoPago, OP.TESOPfechaPago, OP.TESCFLid, OP.UsucodigoGenera, 
                TB.TESCFDnumFormulario,B.Iaba, CB.CBcodigo, OP.TESOPtotalPago, OP.Miso4217Pago, OP.TESOPtipoCambioPago,
                TB.TESCFBobservacion, U.Usulogin, BE.TESBeneficiarioId, BE.TESBeneficiario, TB.TESCFBfechaGenera,
				OP.SNid, SN.SNnombre
				from TEScontrolFormulariosB TB
			    inner join TEScontrolFormulariosD TD on TB.TESid = TD.TESid and TB.CBid = TD.CBid and TB.TESMPcodigo = 										 				TD.TESMPcodigo and TB.TESCFDnumFormulario  = TD.TESCFDnumFormulario
	  			inner join TESordenPago OP on OP.TESOPid = TD.TESOPid
				----inner join TESdetallePago DP on OP.TESOPid = DP.TESOPid
				left join SNegocios SN on OP.SNid = SN.SNid and OP.EcodigoPago = SN.Ecodigo
       			inner join TESCFestados TE on TB.TESid = TE.TESid and TB.TESCFEid = TE.TESCFEid 
				and TE.TESCFEcodigo in ('IMP')
		        inner join TESmedioPago TM   
			   		inner join TEStipoMedioPago TP on TM.TESTMPtipo = TP.TESTMPtipo and TP.TESTMPdescripcion 
			   		like 'CHK = Cheque Impreso o Manual' 
       			on TB.TESid = TM.TESid and TB.TESMPcodigo = TM.TESMPcodigo and TB.CBid = TM.CBid
	   			inner join CuentasBancos CB on CB.CBid = TB.CBid
	   			inner join Bancos B on B.Bid = CB.Bid
				inner join Usuario U on TB.BMUsucodigo = U.Usucodigo
				left join TESbeneficiario BE on BE.TESBid = OP.TESBid 
				where TB.Integracion = 0 
				and OP.Integracion = 1
			</cfquery>
	   		
			<cfif rsCTesoreria.recordcount GT 0>
			<cfloop query="rsCTesoreria"> <!---Extraccion--->
				<cftry>
				
				<!---Se validan los detalles--->			
				<cfset varCEcodigo = getCEcodigo(rsCTesoreria.EcodigoPago)>

				<cfquery name="rsUsuario" datasource="#caches.Ccache#">
					select Usucodigo, Usulogin
					from Usuario
        		    where Usucodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCTesoreria.UsucodigoGenera#">
            		and CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCEcodigo#">
				</cfquery>
				
				<cfif rsUsuario.recordcount GT 0>
					<cfset UsuInterfaz = rsUsuario.Usulogin>
				<cfelse>
					<cfthrow message="No se ha podido obtener el código de Usuario">
				</cfif>	
				
				<!---Obtener el ID maximo de la tabla--->
				<cfquery name="rsMaxID" datasource="sifinterfaces">
					select isnull(max(ID), 0) + 1 as Maximo 
					from Cheques_SOIN
				</cfquery> 
               
			    <cfset Maximo = #rsMaxID.Maximo#>
				
				<cfquery datasource="sifinterfaces">
                 SET ANSI_WARNINGS OFF
   				</cfquery>
                <cfquery datasource="sifinterfaces">
					insert into Cheques_SOIN	
					          (ID,
           					   Num_Cheque,
			   				   Beneficiario_Cheque,
                               Ecodigo,
            				   Cuenta_Banco,
           					   Id_Orden,
           					   Monto_Cheque,
           					   Fecha_Emision,
                               Moneda,
           					   Sistema,
           					  <!--- Numero_NAP,--->
							   Usuario,
           					   Estatus)    
						values
							  (<cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">,
							  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCTesoreria.TESCFDnumFormulario#">, 
							  <cfif rsCTesoreria.TESBeneficiario NEQ ''>
							  	<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCTesoreria.TESBeneficiario#">,
							  <cfelse>
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCTesoreria.SNnombre#">, 
							  </cfif>
							  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCTesoreria.EcodigoPago#">,
							  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCTesoreria.CBcodigo#">,	
							  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCTesoreria.TESOPid#">,	
							  round(#rsCTesoreria.TESOPtotalPago#,2),
							  <cfqueryparam cfsqltype="cf_sql_date" value="#rsCTesoreria.TESOPfechaPago#">,	
						      <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCTesoreria.Miso4217Pago#">,
							  'SOIN_CIM',
							  <cfqueryparam cfsqltype="cf_sql_varchar" value="#UsuInterfaz#">,		
							  30)
				</cfquery>
                <cfquery datasource="sifinterfaces">
                SET ANSI_WARNINGS ON
				</cfquery>
				
				<cfquery datasource="#caches.Ccache#">
				 	update TEScontrolFormulariosB set Integracion = 1
					from TEScontrolFormulariosB TB
					inner join TEScontrolFormulariosD TD on TB.TESid = TD.TESid and TB.CBid = TD.CBid 
					and TB.TESMPcodigo = TD.TESMPcodigo and TB.TESCFDnumFormulario  = TD.TESCFDnumFormulario
					where TD.TESOPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsCTesoreria.TESOPid#">
				</cfquery>
				
				<!---Actualiza los registros insertados---->
				<cfquery datasource="sifinterfaces">
					update Cheques_SOIN set Estatus = 31 
					where Estatus = 30 and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">
				</cfquery>
			
			<cfcatch>
			<!---- Elimina registros que causaron error---->
			<cfif isdefined("Maximo")>
				<cfquery datasource="sifinterfaces">
					delete Cheques_SOIN where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Maximo#">
				</cfquery>
				
				<cfquery datasource="#caches.Ccache#">
				 	update TEScontrolFormulariosB set Integracion = 0  
					from TEScontrolFormulariosB TB
					inner join TEScontrolFormulariosD TD on TB.TESid = TD.TESid and TB.CBid = TD.CBid 
					and TB.TESMPcodigo = TD.TESMPcodigo and TB.TESCFDnumFormulario  = TD.TESCFDnumFormulario
					where TD.TESOPid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#rsCTesoreria.TESOPid#">
				</cfquery>
			</cfif>
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
		</cfloop> <!---Encabezados--->
		</cfif>
       <!--- </cfif>--->
        </cfloop> <!---Caches--->
		</cfsilent>
	  </cffunction> 
	  
	
	<!---Actualiza las equivalencias de las Ordenes de Pago Registradas---->		
	<cffunction name="ValidaEquivalencias"> 
	<cfsilent>
	  
		<!---Consulta el encabezado---->
		<cfquery name="rsCountReg" datasource="sifinterfaces">
			select ID, Ecodigo, Cuenta_Banco, Moneda, Usuario, Estatus
			from Cheques_SOIN 
			where Estatus = 31		
		</cfquery>
		
		<cfif isdefined("rsCountReg") and rsCountReg.recordcount GT 0>
		<cfloop query="rsCountReg">
			<cftransaction action="begin">
			<cftry>
					
			<cfset EcodigoP = #rsCountReg.Ecodigo#>
												
			<!--- Busca equivalencia con el codigo externo de Empresa --->
 			<cfquery datasource="sifinterfaces" name="rsEquivalenciaEmp">
               select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF  
               from SIFLD_Equivalencia
               where SIScodigo = 'ICTS'  
                   and CATcodigo = 'CADENA'
                   and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoP#">
            </cfquery>
		   
		    <cfif rsEquivalenciaEmp.recordcount EQ 0>
		   		<cfthrow message="No existe equivalencia para la empresa">
			<cfelse>
				<cfquery datasource="sifinterfaces">
				update Cheques_SOIN 
				set Ecodigo = convert(integer,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivalenciaEmp.EQUcodigoOrigen#">) 
				where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCountReg.ID#">
				</cfquery>				
			</cfif>		
			
			<!--- Busca equivalencia para la Cuenta Bancaria --->
		   	 <cfquery datasource="sifinterfaces" name="rsEquivalenciaCtaBanco">
             	select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF  
                from SIFLD_Equivalencia
                where SIScodigo = 'TBS'  
                   and CATcodigo = 'CTA_BANCO'
                   and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoP#">
                   and ltrim(rtrim(EQUcodigoSIF)) = ltrim(rtrim(<cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsCountReg.Cuenta_Banco#">))
           	 </cfquery>
		   
		   <cfif rsEquivalenciaCtaBanco.recordcount EQ 0>
		   		<cfthrow message="No existe equivalencia para la cuenta de banco #rsCountReg.Cuenta_Banco# del Cheque">
			<cfelse>
				<cfquery datasource="sifinterfaces">
					update Cheques_SOIN set Cuenta_Banco = <cfqueryparam cfsqltype="cf_sql_varchar" 
					value="#rsEquivalenciaCtaBanco.EQUcodigoOrigen#"> 
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCountReg.ID#">
				</cfquery>
			</cfif>	
			
			 <!--- Busca equivalencia con el codigo externo de Moneda --->
			   <cfquery datasource="sifinterfaces" name="rsEquivalenciaMon">
    	           select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF, EQUidSIF  
        	       from SIFLD_Equivalencia
            	   where SIScodigo = 'ICTS'  
                   and CATcodigo = 'MONEDA'
                   and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#EcodigoP#">
                   and EQUcodigoSIF = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#rsCountReg.Moneda#">
	           </cfquery>
		   
			   <cfif rsEquivalenciaMon.recordcount EQ 0>
		   			<cfthrow message="No existe equivalencia para la moneda del Cheque">
			   <cfelse>
					<cfquery datasource="sifinterfaces">
					   update Cheques_SOIN 
					   set Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivalenciaMon.EQUcodigoOrigen#">   	                   where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCountReg.ID#">
					</cfquery>
				</cfif>			
		
			<!---Se actualiza el registro de la tabla intermedia--->
			<cfquery datasource="sifinterfaces">
					update Cheques_SOIN 
					set Estatus = 4
					where Estatus = 31 and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCountReg.ID#">
			</cfquery>		
			
			<cftransaction action="commit"/> 
		<cfcatch>
	  		<cftransaction action="rollback"/> 	  		
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
		
			<cfquery datasource="sifinterfaces">
                 insert into SIFLD_Errores 
                        	(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, 																																                             MsgErrorPila, Ecodigo, Usuario)
	                        select 'TS_Cheques', 'Cheques_SOIN', ID,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="698">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Usuario#">
                        from Cheques_SOIN
                        where Estatus in (31)  
                        and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCountReg.ID#">
             	 </cfquery>
			  
			 	 <cfquery datasource="sifinterfaces">
					update Enc_Ordenes_Pago_SOIN set Estatus = 33 
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCountReg.ID#">
				</cfquery>
			</cfcatch>
			</cftry>
			</cftransaction>
		</cfloop>	
		</cfif>	  <!---Encabezado--->
	</cfsilent>
	</cffunction>
	
	<cffunction name="EnviaRegistrosTesoreria"> 
	<cfsilent>
		<!---Lee los registros a insertar--->
		<cfquery name="rsCheques" datasource="sifinterfaces">
			select 	ID, Num_Cheque, Beneficiario_Cheque, Ecodigo, Cuenta_Banco,Id_Orden, Moneda, Monto_Cheque,
           		    Fecha_Emision, Moneda, Sistema, Usuario, Estatus
			from Cheques_SOIN <!---E
			inner join Det_Ordenes_Pago_SOIN D on E.ID = D.ID--->
			where Estatus = 4
		</cfquery>
		
		<cfif rsCheques.recordcount GT 0>
		<cfloop query="rsCheques">
			<cftry>
						
				<cfquery datasource="tesoreria">
				SET ANSI_WARNINGS OFF
					insert into PmiEntradasSoinCimCheques
								(num_cheque,
  								 cheque_nombre_largo,
  								 compania_prop_id,
  								 cuenta_bancaria_id,
  								 documento_soin_id,
  								 monto_cheque,
  								 fecha_emision,
  			   					 cheque_status,
  								 moneda,
  								 sistema_id,
  								 nap_sistema_id,
  								 agrup_numero_nap)
						  values (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.Num_Cheque#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCheques.Beneficiario_Cheque#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.Ecodigo#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.Cuenta_Banco#">,
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.Id_Orden#">,
								  <cfqueryparam cfsqltype="cf_sql_money" value="#rsCheques.Monto_Cheque#">,
								  <cfqueryparam cfsqltype="cf_sql_date" value="#rsCheques.Fecha_Emision#">,
								  'AC',
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCheques.Moneda#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCheques.Sistema#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCheques.Sistema#">,
								  0) <!---agrup_numero_nap---->
					SET ANSI_WARNINGS ON
				</cfquery>
				
				<cfquery datasource="tesoreria">
					exec sp_SendPmiEntradaCheques  
				</cfquery>
				
             	<cfquery datasource="sifinterfaces"> 
					update Cheques_SOIN 
					set Estatus = 2
					where Estatus = 4 
					and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.ID#">			
				</cfquery>
				
				<cfcatch>
	  		<!---Borrar los registros de la Orden--->
			<cfquery datasource="tesoreria">
				delete PmiEntradasSoinCimCheques
				where documento_soin_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.Id_Orden#">
				and compania_prop_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.Ecodigo#">
			</cfquery>
					
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
		
			<cfquery datasource="sifinterfaces">
			
                 insert into SIFLD_Errores 
                        	(Interfaz, Tabla, ID_Documento, MsgError, MsgErrorDet, MsgErrorSQL, MsgErrorParam, 																																                             MsgErrorPila, Ecodigo, Usuario)
	                        select 'Cheques_SOIN', 'Cheques_SOIN', ID,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Mensaje#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Detalle#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#SQL#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PARAM#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PILA#">,				 
                            <cfqueryparam cfsqltype="cf_sql_integer" value="698">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Usuario#">
                        from Cheques_SOIN
                        where Estatus in (4)  
                        and ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.ID#">
             	 </cfquery>
			  
			 	 <cfquery datasource="sifinterfaces">
					update Enc_Ordenes_Pago_SOIN set Estatus = 6 
					where ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCheques.ID#">
				</cfquery>
			</cfcatch>
			</cftry>
		</cfloop>
		</cfif>					
	</cfsilent>
	</cffunction>	
</cfcomponent>