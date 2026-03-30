<cfparam name="param" 		  default="">
<!---►►►Eliminación de una Version◄◄◄--->
<cfif isdefined('form.BTNEliminar')>
	<cftransaction>
		<cfquery datasource="#session.DSN#">
			delete from RHDLiquidacionRenta				
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>
        <cfquery datasource="#session.DSN#">
			delete from RHRentaOrigenes				
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>	
		<cfquery datasource="#session.DSN#">
			delete from RHLiquidacionRenta				
			 where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>
        <cfset param = "&DEid="&form.DEid>
     </cftransaction>
<!---►►►Guarda los Datos Modificados de la version◄◄◄--->     
<cfelseif isdefined('form.BTNGuardar')>			
		<cfquery datasource="#session.DSN#" name="rsOrigenes">
            select RHROid 
                from RHRentaOrigenes 
            where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
        </cfquery>
		<cfif isdefined('Autorizacion')>	
			<cftransaction>
                <cfquery name="updateProyeccion" datasource="#session.DSN#">
                        update RHLiquidacionRenta
                        set RentaImponible	 = #Replace(Evaluate('form.RentaImpAut'),',','','all')#, 
                            ImpuestoAnualDet = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.ImpAnualDeterminadoAut'),',','','all')#">,  
                            CreditoIVA 		 = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.AutorizadoCreditoFiscal'),',','','all')#">,
                            RentaAnual 		 = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.ImpDeterminadoAut'),',','','all')#">, 					
                            RentaRetenida 	 = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.RentaRetenidaAut'),',','','all')#">,  
                            ImpuestoRetener  = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.ImpRetenAut'),',','','all')#">,  
                            RetenidoExceso 	 = 0
                        where RHRentaId      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
                </cfquery>											
                <cfquery name="rsActCreditoAut" datasource="#session.DSN#">	
                        update RHDLiquidacionRenta
                            set MontoAutorizado = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.AutorizadoCreditoFiscal'),',','','all')#">
                        where RHRentaId    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
                          and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CreditoFiscal_RHCRPTid#">										
                </cfquery>
                <cfloop query="rsOrigenes">
                	<cfquery datasource="#session.DSN#">	
                        update RHRentaOrigenes
                            set RentaNetaAut = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.rentaOtrasA#rsOrigenes.RHROid#'),',','','all')#">,
								BMfechaalta  = <cf_dbfunction name="now">,
								BMUsucodigo  = #session.Ecodigo#
                        where RHROid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrigenes.RHROid#">										
               	 	</cfquery>
                </cfloop>
             </cftransaction>
            <cfset param = "&RHRentaId="&form.RHRentaId&"&DEid="&form.DEid>
		<cfelse>					
			<cftransaction>
				<cfquery datasource="#session.DSN#">							
				   update RHLiquidacionRenta
                     set RentaImponible 	= <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.RentaImpEmp'),',','','all')#">, 
						 ImpuestoAnualDet 	= <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.ImpAnualDeterminadoEmp'),',','','all')#">,  
						 CreditoIVA 		= <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.EmpleadoCreditoFiscal'),',','','all')#">,
						 RentaAnual 		= <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.ImpDeterminadoEmp'),',','','all')#">, 					
						 RentaRetenida 		= <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.RentaRetenidaEmp'),',','','all')#">,  
						 ImpuestoRetener 	= <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.ImpRetenEmp'),',','','all')#">,  						
						 RetenidoExceso 	= 0					
					where RHRentaId         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
				</cfquery>		
				<cfquery name="rsInsertaCreditoFiscal" datasource="#session.DSN#">
					update RHDLiquidacionRenta
					  set MontoEmpleado = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.EmpleadoCreditoFiscal'),',','','all')#">
					where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
					  and RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CreditoFiscal_RHCRPTid#">						
				</cfquery>
                <cfloop query="rsOrigenes">
                	<cfquery datasource="#session.DSN#">	
                        update RHRentaOrigenes
                            set RentaNetaEmp = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('form.rentaOtrasE#rsOrigenes.RHROid#'),',','','all')#">,
								BMfechaalta  = <cf_dbfunction name="now">,
								BMUsucodigo  = #session.Ecodigo#
                        where RHROid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOrigenes.RHROid#">										
               	 	</cfquery>
                </cfloop>		
			</cftransaction>																																		
				<cfset param = "&RHRentaId="&form.RHRentaId&"&DEid="&form.DEid>			
		</cfif>	
<!---►►►Aplica la version◄◄◄--->  								
<cfelseif isdefined('form.btnEnviar_a_Autorizacion')>
			<cftransaction>	
				<cfquery name="UpdateLiquida" datasource="#session.DSN#">
					update RHLiquidacionRenta
					set Estado = 10,				    
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
						BMfechaalta = <cf_dbfunction name="now">
					where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
				</cfquery>	
			</cftransaction>	
<!---►►►Finaliza la version de liquidacion de renta◄◄◄--->  					
<cfelseif isdefined('form.BTNFinalizar')>
		<cftransaction>
            <cfquery name="UpdateLiquida" datasource="#session.DSN#">
                update RHLiquidacionRenta
                set RentaAnual 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RentaAnual#">,  			
                    RentaRetenida 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('form.RentaRetenidaAut'),',','','all')#">,  				
                    RetenidoExceso 	 = 0,				
                    RentaImponible 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('form.RentaImpAut'),',','','all')#">,   				
                    ImpuestoAnualDet = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('form.ImpAnualDeterminadoAut'),',','','all')#">, 				 
                    CreditoIVA 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(Evaluate('form.AutorizadoCreditoFiscal'),',','','all')#">,
                    Estado 			 = 30,				
                    BMUsucodigo 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                    BMfechaalta 	 = <cf_dbfunction name="now">
                where RHRentaId   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
            </cfquery>
		</cftransaction>
		<!--- ENCONTRAR EN TIPOS DE DEDUCCION LA DE RENTA --->						
		<cfquery name="rsTDeduccionRenta" datasource="#session.DSN#">
			select TDid
			 from TDeduccion
			where TDrenta > 0
			  and Ecodigo = #Session.Ecodigo#
		</cfquery>
		<cfif rsTDeduccionRenta.RecordCount GT 0>
            <cfquery name="rsTDeduccionRentaEmp" datasource="#session.DSN#">
                select 1 
                 from DeduccionesEmpleado
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTDeduccionRenta.TDid#">
                  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.EIRdesde)#"> between Dfechaini and Dfechafin
                    or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.EIRHasta)#"> between Dfechaini and Dfechafin)
            </cfquery>						
			<cfif rsTDeduccionRentaEmp.RecordCount GT 0>					
				<cfset diaAnt = DATEADD('d', -1, now()) >
				<cfset diaAntFormateada = LSDateFormat(diaAnt,"dd/mm/yyyy") >
												
				<cfquery name="rsActualizaAntRenta" datasource="#session.DSN#">
						update DeduccionesEmpleado
						set Dfechafin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(diaAntFormateada)#"> ,
						Dactivo= 0
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTDeduccionRenta.TDid#">
						  and (<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.EIRdesde)#"> between Dfechaini and Dfechafin
						    or <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.EIRHasta)#"> between Dfechaini and Dfechafin)
				</cfquery>																					
			</cfif>
			<!--- BUSCAR EL SOCIO DE NEGOCIOS RELACIONADO CON LA RENTA --->
			<cfquery name="rsCuentaRenta" datasource="#session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and Pcodigo = 140
			 </cfquery>	 

			<cfif rsCuentaRenta.RecordCount GT 0>	
					
					<cfquery name="rsSocioNegocio" datasource="#session.DSN#">
						select a.SNcodigo as SNcodigo
						from SNegocios a
                        	inner join CContables b
                            	on b.Ccuenta = a.SNcuentacxp
						where a.SNcuentacxp= #rsCuentaRenta.Pvalor#
					</cfquery>	
					
					<cfif rsSocioNegocio.RecordCount EQ 1>
												
						<cfset SNcodigo = #rsSocioNegocio.SNcodigo# >
						<cfset Ddescripcion = "Dedduccion de Renta">
						<cfset fechaAhora =  LSDateFormat(now(),"dd/mm/yyyy")>
						
						<cfquery name="ABC_Insdeducciones" datasource="#Session.DSN#">
							insert Into DeduccionesEmpleado ( DEid, Ecodigo, SNcodigo, TDid, Ddescripcion, Dmetodo, Dvalor, Dfechaini, Dfechafin, 
														 Dmonto, Dtasa, Dsaldo, Dmontoint, Destado, Usucodigo, Ulocalizacion, Dactivo, 
														 Dcontrolsaldo )
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#SNcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTDeduccionRenta.TDid#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Ddescripcion#">,
								1,								
								<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('RetencionNomAut'),',','','all')#">,																
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(fechaAhora)#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="01/01/6100">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('RetencionNomAut'),',','','all')#">,										
								0,
								<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(Evaluate('ImpRetenEmp'),',','','all')#">,										
								0,
								1, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">,
								1,								
								1
							)	
						</cfquery>
					<cfelseif  rsSocioNegocio.RecordCount GT 2>											
						   <cfthrow message="Transacción Cancelada. Existe más de un Socio de Negocio realcionado a la cuenta contable de renta, Proceso Cancelado!">		
					<cfelseif  rsSocioNegocio.RecordCount EQ 0>
							<cfthrow message="Transacción Cancelada. No existe un Socio de Negocio relacionado a la cuenta contable de renta, Proceso Cancelado!">			   											   
					</cfif>		   
			<cfelse>
				<cfthrow message="Transacción Cancelada. No existe una cuenta contable asociada a la renta, En parametrización asocie la cuenta respectiva para la renta Proceso Cancelado!">								
			</cfif>
	<cfelse>
	<cfthrow message="Transacción Cancelada.Está definiendo una deducción de tipo renta, pero no hay ningún tipo de deduccion de tipo renta en el sistema, Proceso Cancelado!">
						
	</cfif>
<cfelseif isdefined('form.BTNRechazar')>
	<!--- SE ACTUALIZA EL ESTADO DE LA LIQUIDACIÓN PARA ENVIARLA A VERIFICAR --->
	<cftransaction>
		<cfquery name="UpdateLiquida" datasource="#session.DSN#">
			update RHLiquidacionRenta
			set Estado = 20,				
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				BMfechaalta = <cf_dbfunction name="now">
			where RHRentaId   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRentaId#">
		</cfquery>
	</cftransaction>
</cfif>
<cfif isdefined('form.Autorizacion')>
	<cflocation addtoken="no" url="/cfmx/rh/nomina/liquidacionRenta/ProyeccionRentaA.cfm?Autorizacion=true#param#">	
<cfelse>
	<cflocation addtoken="no" url="ProyeccionRenta.cfm?Autorizacion=false#param#">	
</cfif>