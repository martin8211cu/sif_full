

<cfif not isdefined("Form.Nuevo")>
<cftransaction>
	<cftry>
		<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
			
			<!--- valores default --->
			<cfif isdefined("Form.CInorenta")><cfset norenta = 1><cfelse><cfset norenta = 0></cfif>
			<cfif isdefined("Form.CInocargas")><cfset nocargas = 1><cfelse><cfset nocargas = 0></cfif>
			<cfif isdefined("Form.CInodeducciones")><cfset nodeducciones = 1><cfelse><cfset nodeducciones = 0></cfif>
			<cfif isdefined("Form.CInoanticipo")><cfset noanticipo = 1><cfelse><cfset noanticipo = 0></cfif>
			<cfset tipo = form.CItipo >
			
			<!--- comportamiento especial para estos bits --->	
			<cfif isdefined("form.CInorealizado") or isdefined("form.CIredondeo")>
				<cfset norenta       = 1 >
				<cfset nocargas      = 1 >
				<cfset nodeducciones = 1 >
				<cfset tipo          = 2 >
			</cfif>
		</cfif>

		<cfif isdefined("Form.Alta")>

			<cfset vFormato = '' >
			<cfif isdefined("form.Cmayor") and len(trim(form.Cmayor))>
				<cfset vFormato = vFormato & trim(form.Cmayor) >
			</cfif>
			<cfif isdefined("form.Cformato") and len(trim(form.Cformato))>
				<cfset vFormato = trim(vFormato) & '-'& trim(form.Cformato) >
			</cfif>
			

			<cfquery name="ABC_TiposIncidenciaInsert" datasource="#Session.DSN#">			
				insert into CIncidentes 
					(Ecodigo, CIcodigo, CIdescripcion, CIfactor, CInegativo, CInorealizado, CIredondeo, CInorenta, CInocargas, 
					 CInodeducciones, CInoanticipo, CItipo, CIcantmin, CIcantmax, CIvacaciones, Usucodigo, Ulocalizacion, CIcuentac, 		
					 CIafectasalprom,CInocargasley, CIafectacomision, CItipoexencion, CIexencion, Ccuenta, Cformato,CISumarizarLiq,CIMostrarLiq,CInopryrenta,
					 CIclave, CIcodigoext, CInomostrar, CIafectacostoHE,CImodFechaReg,CImodNominaSP,CItipoAjuste,CIdiasAjuste,CIafectaSBC,CIlimitaconcepto,CItipolimite , CItipometodo ,CImontolimite ,CIidexceso)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CIcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CIdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIfactor#">,
					<cfif isdefined("Form.CInegativo")>-1<cfelse>1</cfif>,
		
					<cfif isdefined("Form.CInorealizado")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.CIredondeo")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#norenta#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#nocargas#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#nodeducciones#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#noanticipo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#tipo#">,
		
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIcantmin#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIcantmax#">,
					<cfif isDefined("Form.CIvacaciones")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CIcuentac#">,
					<cfif isdefined("form.CIafectasalprom")>1<cfelse>0</cfif>,
					<cfif isdefined("form.CInocargasley")>1<cfelse>0</cfif>,
					<cfif isdefined("form.CIafectacomision")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CItipoexencion#">,
					<cfif Form.CItipoexencion EQ 1>
						<cfqueryparam cfsqltype="cf_sql_money" value="#Form.CIexencion1#">,
					<cfelseif Form.CItipoexencion EQ 2>
						<cfqueryparam cfsqltype="cf_sql_money" value="#Form.CIexencion2#">,
					<cfelse>
						0.00,
					</cfif>
					<cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.Cformato") and len(trim(form.Cformato)) and isdefined("form.Cmayor") and len(trim(form.Cmayor)) >
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#vFormato#">
					<cfelse>
						null
					</cfif>	
					<cfif isDefined("Form.CISumarizarLiq")>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif isDefined("Form.CIMostrarLiq")>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif isDefined("Form.CInopryrenta")>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif isdefined('form.CIclave') and LEN(TRIM(form.CIclave))>
						,<cfqueryparam cfsqltype="cf_sql_char" value="#form.CIclave#">
					<cfelse>
						,null
					</cfif>
					<cfif isdefined('form.CIcodigoext') and LEN(TRIM(form.CIcodigoext))>
						,<cfqueryparam cfsqltype="cf_sql_char" value="#form.CIcodigoext#">
					<cfelse>
						,null
					</cfif>
					<cfif isdefined('form.CInomostrar') and LEN(TRIM(form.CInomostrar))>
						,1
					<cfelse>
						,0
					</cfif>
					<cfif isdefined("form.CIafectacostoHE") and len(trim(form.CIafectacostoHE)) and form.CItipo EQ 2>
						,1
					<cfelse>
						,0
					</cfif>
                    <cfif Form.CItipo EQ 3>
                    	<cfif isdefined('form.CImodFechaReg') and LEN(TRIM(form.CImodFechaReg))>
                            ,1
                        <cfelse>
                            ,0
                        </cfif>
                        <cfif isdefined('form.CImodNominaSP') and LEN(TRIM(form.CImodNominaSP))>
                            ,1
                        <cfelse>
                            ,0
                        </cfif>
                        <cfif isdefined('form.CItipoAjuste') and LEN(TRIM(form.CItipoAjuste))>
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CItipoAjuste#">
                        <cfelse>
                            ,null
                        </cfif>
                        <cfif isdefined('form.CIdiasAjuste') and LEN(TRIM(form.CIdiasAjuste))>
                            ,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIdiasAjuste#">
                        <cfelse>
                            ,null
                        </cfif>
					<cfelse>
                        ,null
                        ,null
                        ,null
                        ,null
                    </cfif>
					,<cfif isdefined("form.CIafectaSBC")>1<cfelse>0</cfif>
					
					<cfif isDefined("Form.CIlimitesConcepto")>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,<cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					
					<cfif isDefined("Form.CIperiodo")>
					  ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIperiodo#">
					<cfelse>
					  ,null
					</cfif>
					
				
					
					<cfif isDefined("Form.CIimporte")>
					  ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIimporte#">
					<cfelse>
					  ,null
					</cfif>
					
					
					
					<cfif isDefined("Form.CIimporte")>
						<cfswitch expression="#Form.CIimporte#" >
						
						<cfcase value="0">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.monto1#">
						</cfcase>
						
						<cfcase value="1">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.monto2#">
						</cfcase>
						
						<cfcase value="2">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.monto3#">
						</cfcase>
						
						<cfcase value="4">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCvsmg#">
						</cfcase>
						
						<cfdefaultcase> 
						,null
						</cfdefaultcase>					
						</cfswitch>
					<cfelse>
					  ,null
					</cfif>
						
					<cfif isDefined("Form.CIimporte")>			
						<cfswitch expression="#Form.CIimporte#" >					
						<cfcase value="0">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid1#">
						</cfcase>
						
						<cfcase value="1">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid2#">
						</cfcase>
						
						<cfcase value="2">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid3#">
						</cfcase>
						
						<cfcase value="4">
						 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid4#">
						</cfcase>
						
						<cfdefaultcase> 
						,null
						</cfdefaultcase>					
						</cfswitch>
					<cfelse>
					  ,null
					</cfif>
											
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>				
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_TiposIncidenciaInsert">
			<!--- Forza Integridad de Concepto de Pagos No Realizados. Si es verdadero debe ser el único en la tabla, y además,
			debe actualizar el parámetro respectivo en la tabla de parámetros.--->
			<cfif isdefined("Form.CInorealizado") or isdefined("Form.CIredondeo") >
				<cfset CIid = ABC_TiposIncidenciaInsert.identity>
			</cfif>
			<cfif isdefined("Form.CInorealizado")>
				<cfquery name="ABC_TiposIncidenciaUpdate" datasource="#Session.DSN#">	
					update CIncidentes 
					set CInorealizado = 0 
					where not CIid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#CIid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfquery name="ConsultaTI" datasource="#session.DSN#">
					select 1 
					from RHParametros 
					where Pcodigo = 100 
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfif isdefined("ConsultaTI") and (ConsultaTI.RecordCount GT 0)>
					<cfquery name="ABC_RHParamUpdate" datasource="#Session.DSN#">						
						update RHParametros 
						set Pvalor = <cf_dbfunction name= "to_char" args="#CIid#">
						where Pcodigo = 100 
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				<cfelse>
					<cfquery name="ABC_RHParamInsert" datasource="#Session.DSN#">
						insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
						values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							100, 
							'Concepto de Pago para Pagos no realizados', 
							<cf_dbfunction name= "to_char" args="#CIid#">)						
					</cfquery>
				</cfif>
			</cfif>
			<cfif isdefined("Form.CIredondeo")>
				<cfquery name="ABC_CIncidentesUpdateR" datasource="#Session.DSN#">			
					update CIncidentes 
					set CIredondeo = 0 
					where CIid <> <cfqueryparam cfsqltype="cf_sql_integer" value="#CIid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
			</cfif>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="ABC_CIncidentesDDelete" datasource="#Session.DSN#">
				delete from CIncidentesD where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
			</cfquery>
			<cfquery name="ABC_CIncidentesDelete" datasource="#Session.DSN#">	
				delete from CIncidentes 
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
		<!--- Forza Integridad de Concepto de Pagos No Realizados. Si es verdadero debe actualizar el 
			  parámetro respectivo en la tabla de parámetros, dejandolo en nulo. --->
			<cfif isdefined("Form.CInorealizado")>
				<cfquery name="ConsultaTI2" datasource="#session.DSN#">
					select 1 
					from RHParametros 
					where Pcodigo = 100 
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>			
				<cfif isdefined("ConsultaTI2") and (ConsultaTI2.RecordCount GT 0)>
					<cfquery name="ABC_RHParamUpdate2" datasource="#Session.DSN#">						
						update RHParametros 
						set Pvalor = ''
						where Pcodigo = 100 
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>	
				</cfif>			
			</cfif>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>	
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CIncidentes"
				redirect="TiposIncidencia-form.cfm"
				timestamp="#form.ts_rversion#"
				field1="CIid,numeric,#Form.CIid#">

				<cfset vFormato = '' >
				<cfif isdefined("form.Cmayor") and len(trim(form.Cmayor))>
					<cfset vFormato = vFormato & trim(form.Cmayor) >
				</cfif>
				<cfif isdefined("form.Cformato") and len(trim(form.Cformato))>
					<cfset vFormato = trim(vFormato) & '-'& trim(form.Cformato) >
				</cfif>

			<cfquery name="ABC_CIncidentesUpdate" datasource="#Session.DSN#">	
				update CIncidentes set 
					CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CIcodigo#">,
					CIdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CIdescripcion#">,
					CIfactor = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIfactor#">,
					CInegativo = <cfif isdefined("Form.CInegativo")>-1<cfelse>1</cfif>,

					CInorealizado = <cfif isdefined("Form.CInorealizado")>1<cfelse>0</cfif>,
					CIredondeo = <cfif isdefined("Form.CIredondeo")>1<cfelse>0</cfif>,
					CInorenta = <cfqueryparam cfsqltype="cf_sql_bit" value="#norenta#">,
					CInocargas = <cfqueryparam cfsqltype="cf_sql_bit" value="#nocargas#">,
					CInodeducciones = <cfqueryparam cfsqltype="cf_sql_bit" value="#nodeducciones#">,
					CInoanticipo = <cfqueryparam cfsqltype="cf_sql_bit" value="#noanticipo#">,
					CItipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#tipo#">,

					CIcantmin = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIcantmin#">,
					CIcantmax = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIcantmax#">,
					CIvacaciones = <cfif isDefined("Form.CIvacaciones")>1<cfelse>0</cfif>,
					CIcuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CIcuentac#">,
					CIafectasalprom = <cfif isdefined("form.CIafectasalprom")>1<cfelse>0</cfif>,
					CInocargasley = <cfif isdefined("form.CInocargasley")>1<cfelse>0</cfif>,
					CIafectacomision = <cfif isdefined("form.CIafectacomision")>1<cfelse>0</cfif>,
					CItipoexencion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CItipoexencion#">,
					<cfif Form.CItipoexencion EQ 1>
						CIexencion = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CIexencion1#">,
					<cfelseif Form.CItipoexencion EQ 2>
						CIexencion = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.CIexencion2#">,
					<cfelse>
						CIexencion = 0.00,
					</cfif>
					Ccuenta = <cfif isdefined("form.Ccuenta") and len(trim(form.Ccuenta))>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">,
							<cfelse>
								null,
							</cfif>
					Cformato = <cfif isdefined("form.Cformato") and len(trim(form.Cformato)) and isdefined("form.Cmayor") and len(trim(form.Cmayor)) >
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#vFormato#">
							<cfelse>
								null
							</cfif>	
					<cfif isDefined("Form.CISumarizarLiq")>
					  ,CISumarizarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,CISumarizarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif isDefined("Form.CIMostrarLiq")>
					  ,CIMostrarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,CIMostrarLiq = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
					<cfif isDefined("Form.CInopryrenta")>
					  ,CInopryrenta = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  ,CInopryrenta = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>		
					,CIclave = <cfif isdefined('form.CIclave') and LEN(TRIM(form.CIclave))>
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.CIclave#">
							   <cfelse>
								null
							   </cfif>
					,CIcodigoext = <cfif isdefined('form.CIcodigoext') and LEN(TRIM(form.CIcodigoext))>
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.CIcodigoext#">
							   	   <cfelse>
									null
							   	   </cfif>
					,CInomostrar = <cfif isdefined('form.CInomostrar') and LEN(TRIM(form.CInomostrar))>
									1
								<cfelse>
									0
								</cfif>	
					,CIafectacostoHE = <cfif isdefined("form.CIafectacostoHE") and len(trim(form.CIafectacostoHE)) and form.CItipo EQ 2>
											1
										<cfelse>
											0
										</cfif>			

						<cfif Form.CItipo EQ 3>
							<cfif isdefined('form.CImodFechaReg') and LEN(TRIM(form.CImodFechaReg))>
                                ,CImodFechaReg=1
                            <cfelse>
                                ,CImodFechaReg=0
                            </cfif>
                            <cfif isdefined('form.CImodNominaSP') and LEN(TRIM(form.CImodNominaSP))>
                                ,CImodNominaSP=1
                            <cfelse>
                                ,CImodNominaSP=0
                            </cfif>
                            <cfif isdefined('form.CItipoAjuste') and LEN(TRIM(form.CItipoAjuste))>
                                ,CItipoAjuste=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CItipoAjuste#">
							<cfelse>
                            	, CItipoAjuste=null                                
                            </cfif>
                            <cfif isdefined('form.CIdiasAjuste') and LEN(TRIM(form.CIdiasAjuste))>
                                ,CIdiasAjuste=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIdiasAjuste#">
                            <cfelse>
                            	, CIdiasAjuste=null
							</cfif>
                    </cfif>
					,CIafectaSBC = <cfif isdefined("form.CIafectaSBC")>1<cfelse>0</cfif>
					
					,CIlimitaconcepto = <cfif isDefined("Form.CIlimitesConcepto")>
					  <cfqueryparam cfsqltype="cf_sql_integer" value="1">
					<cfelse>
					  <cfqueryparam cfsqltype="cf_sql_integer" value="0">
					</cfif>
										
                   ,CItipolimite= <cfif isDefined("Form.CIperiodo")>
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIperiodo#">
					<cfelse>
					  null
					</cfif>
					
					
					,CItipometodo= <cfif isDefined("Form.CIimporte")>
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIimporte#">
					<cfelse>
					  null
					</cfif>
					
					<cfif isdefined("form.CIimporte")>
						,CImontolimite= <cfswitch expression="#Form.CIimporte#" >					
						<cfcase value="0">						
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.monto1#">
						</cfcase>					
						<cfcase value="1">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.monto2#">
						</cfcase>					
						<cfcase value="2">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.monto3#">
						</cfcase>					
						<cfcase value="4">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DCvsmg#">
						</cfcase>					
						<cfdefaultcase> 
						null
						</cfdefaultcase>					
						</cfswitch>					
					
					</cfif>
					
					<cfif isdefined("form.CIimporte")>
						,CIidexceso= <cfswitch expression="#Form.CIimporte#" >					
						<cfcase value="0">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid1#">
						</cfcase>					
						<cfcase value="1">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid2#">
						</cfcase>					
						<cfcase value="2">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid3#">
						</cfcase>					
						<cfcase value="4">
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid4#">
						</cfcase>					
						<cfdefaultcase> 
						null
						</cfdefaultcase>					
						</cfswitch>
								
					</cfif>
					
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
			</cfquery>
			<!--- Forza Integridad de Concepto de Pagos No Realizados. Si es verdadero debe ser el único en la tabla, y además,
			debe actualizar el parámetro respectivo en la tabla de parámetros.--->
			<cfif isdefined("Form.CInorealizado")>
				<cfquery name="ABC_CIncidentesUpdate" datasource="#Session.DSN#">
					update CIncidentes 
					set CInorealizado = 0 
					where not CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfquery name="ConsultaTI3" datasource="#session.DSN#">
					select 1 
					from RHParametros 
					where Pcodigo = 100 
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>			
				<cfif isdefined("ConsultaTI3") and (ConsultaTI2.RecordCount GT 0)>
					<cfquery name="ABC_RHParamUpdate3" datasource="#Session.DSN#">						
						update RHParametros 
						set Pvalor = <cf_dbfunction name="to_char" args="#Form.CIid#">
						where Pcodigo = 100 
						 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>	
				<cfelse>
					<cfquery name="ABC_RHParamInsert3" datasource="#Session.DSN#">
						insert into RHParametros (Ecodigo, Pcodigo, Pdescripcion, Pvalor)
						values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							100, 
							'Concepto de Pago para Pagos no realizados', 
							<cf_dbfunction name= "to_char" args="#CIid#">)						
					</cfquery>					
				</cfif>			
			</cfif>
<!--- 					update RHParametros 
					set Pvalor = convert(varchar,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">) 
					where Pcodigo = 100 
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				else
					insert RHParametros 
						(Ecodigo, Pcodigo, Pdescripcion, Pvalor)
					values 
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						100, 
						'Concepto de Pago para Pagos no realizados', 
						convert(varchar,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">))
 --->			

				<cfif isdefined("Form.CIredondeo")>
					<cfquery name="ABC_CIncidentesUpdateR2" datasource="#Session.DSN#">
						update CIncidentes 
						set CIredondeo = 0 
						where not CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
 			<cfset modo="CAMBIO">				  				  
			<!---<cfelse>
				 select 1 --->
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>

<cfoutput>
<form action="TiposIncidencia.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	<cfelse>
		<cfif isdefined("ABC_TiposIncidencia.CIid")>
			<input name="CIid" type="hidden" value="<cfif isdefined("ABC_TiposIncidencia.CIid")>#ABC_TiposIncidencia.CIid#</cfif>">
		<cfelse>
			<input name="CIid" type="hidden" value="<cfif isdefined("Form.CIid") and not isDefined("Form.Baja")>#Form.CIid#</cfif>">		
		</cfif>	
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.FCIcodigo") and Len(Trim(Form.FCIcodigo)) NEQ 0>
		<input type="hidden" name="FCIcodigo" value="#form.FCIcodigo#" >
	</cfif>
	
	<cfif isdefined("Form.FCIdescripcion") and Len(Trim(Form.FCIdescripcion)) NEQ 0>
		<input type="hidden" name="FCIdescripcion" value="#form.FCIdescripcion#" >
	</cfif>
	
	<cfif isdefined("Form.fMetodo") and Len(Trim(Form.fMetodo)) gt 0>
		<input type="hidden" name="fMetodo" value="#form.fMetodo#" >
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
