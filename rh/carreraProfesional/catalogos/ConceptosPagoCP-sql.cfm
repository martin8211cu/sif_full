<cfset params = ''>
<cfif isdefined('form.Nuevo')><cfset params = params & '&Nuevo=Nuevo'></cfif>
<cfif not isdefined("Form.Nuevo")>
<cftransaction>
	<cftry>
		<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
			
			<!--- valores default --->
			<cfif isdefined("Form.CInorenta")><cfset norenta = 1><cfelse><cfset norenta = 0></cfif>
			<cfif isdefined("Form.CInocargas")><cfset nocargas = 1><cfelse><cfset nocargas = 0></cfif>
			<cfif isdefined("Form.CInodeducciones")><cfset nodeducciones = 1><cfelse><cfset nodeducciones = 0></cfif>
			<cfif isdefined("Form.CInoanticipo")><cfset noanticipo = 1><cfelse><cfset noanticipo = 0></cfif>
			
			<!--- comportamiento especial para estos bits --->	
			<cfif isdefined("form.CInorealizado") or isdefined("form.CIredondeo")>
				<cfset norenta       = 1 >
				<cfset nocargas      = 1 >
				<cfset nodeducciones = 1 >
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
					 CInodeducciones, CInoanticipo, CItipo, CIcantmin, CIcantmax, CIvacaciones, CIcuentac, 		
					 CIafectasalprom,CInocargasley, CIafectacomision, CItipoexencion, CIexencion, Ccuenta, Cformato,CISumarizarLiq,CIMostrarLiq,CInopryrenta,
					 CIclave, CIcodigoext, CInomostrar, CIcarreracp, Usucodigo, Ulocalizacion)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CIcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CIdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_float" value="#Form.CIfactor#">,
					1,
					<cfif isdefined("Form.CInorealizado")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.CIredondeo")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#norenta#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#nocargas#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#nodeducciones#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#noanticipo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CItipo#">,
					1.00,
					999999999.99,
					<cfif isDefined("Form.CIvacaciones")>1<cfelse>0</cfif>,
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
					,1	
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
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
			<cfset params = 'modo='& modo>
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
			<cfset modo="BAJA">
			<cfset params = 'modo='& modo>
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#Session.DSN#"
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

					CInorealizado = <cfif isdefined("Form.CInorealizado")>1<cfelse>0</cfif>,
					CIredondeo = <cfif isdefined("Form.CIredondeo")>1<cfelse>0</cfif>,
					CInorenta = <cfqueryparam cfsqltype="cf_sql_bit" value="#norenta#">,
					CInocargas = <cfqueryparam cfsqltype="cf_sql_bit" value="#nocargas#">,
					CInodeducciones = <cfqueryparam cfsqltype="cf_sql_bit" value="#nodeducciones#">,
					CInoanticipo = <cfqueryparam cfsqltype="cf_sql_bit" value="#noanticipo#">,
					CItipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CItipo#">,

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
				<cfif isdefined("Form.CIredondeo")>
					<cfquery name="ABC_CIncidentesUpdateR2" datasource="#Session.DSN#">
						update CIncidentes 
						set CIredondeo = 0 
						where not CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
 			<cfset modo="CAMBIO">	
			<cfset params = 'modo='& modo & '&CIid=' & form.CIid> 			  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<cfoutput>
	<cfif isdefined("Form.FCIcodigo") and Len(Trim(Form.FCIcodigo)) NEQ 0>
		<cfset params = params  & '&FCIcodigo=' & form.FCIcodigo> 
	</cfif>
	<cfif isdefined("Form.FCIdescripcion") and Len(Trim(Form.FCIdescripcion)) NEQ 0>
		<cfset params = params  & '&FCIdescripcion=' & form.FCIdescripcion> 
	</cfif>
	<cfif isdefined("Form.fMetodo") and Len(Trim(Form.fMetodo)) gt 0>
		<cfset params = params  & '&fMetodo=' & form.fMetodo> 
	</cfif>
	<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina)) gt 0>
		<cfset params = params  & '&Pagina=' & form.Pagina> 
	</cfif>
	<cflocation url="ConceptosPagoCP.cfm?#params#">
</cfoutput>
