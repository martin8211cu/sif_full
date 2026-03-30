<cftry>
	<!---►►►►►►form.ERNid Estara definida cuando se aplica desde dentro de la lista, chk
				se presentara cuando se aplica desde la lista y puede contener mas de un ERNid, 
				los check unicamente apareceran cuando se trabaja con banco Virtual◄◄◄◄◄--->
	<cfif isDefined("Form.Verificar") or isDefined("Form.RHModificar")>
		<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
		<cfset form.chk = form.ERNid >
	</cfif>
	<!---►►►►►►Proceso de Verificacion de la nomina◄◄◄◄◄--->
	<cfif isDefined("Form.Verificar") or isdefined("form.btnMarcar_como_Verificada")>
		<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
		<cfloop list="#form.chk#" index="LvarERNid">
			<cftransaction>
            	<cfinvoke component="rh.Componentes.RH_RelacionCalculo" method="VerificaNomina">
                	<cfinvokeargument name="ERNid" 	   	   value="#LvarERNid#">
                    <cfif (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_con_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.sin_RH_con_Banco_Virtual)>
                   	 	<cfinvokeargument name="ERNestado" value="3">
                    <cfelse>
                    	<cfinvokeargument name="ERNestado" value="4">
                    </cfif>
                    <cfif (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_sin_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.sin_RH_sin_Banco_Virtual)>
						<cfinvokeargument name="DRNestado" value="1">
                    </cfif>
                </cfinvoke>
			</cftransaction>
		</cfloop>
	<!---►►►►►Modificación◄◄◄◄◄--->
	<cfelseif isDefined("Form.Modificar") >
		<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
		<cfquery name="rsERNominaConsulta" datasource="#Session.DSN#">
			Select 1 as cantidad
				from ERNomina 
			 where Ecodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and ERNid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
			   and ERNcapturado = 1
		</cfquery>
		
		<cfif isdefined("rsOperRNominaConuslta") and rsOperRNominaConuslta.RecordCount GT 0>
			 <cfquery name="rsERNominaUpdate" datasource="#Session.DSN#">
				Update ERNomina 
				set ERNestado = 1
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
			</cfquery>
		</cfif>
	<!---►►►►►Devolver al registro de nomina◄◄◄◄◄--->
	<cfelseif isDefined("Form.RHModificar") or isdefined("form.btnDevolver_a_Sistema_de_Nomina") >
		<cfloop list="#form.chk#" index="LvarERNid">
			<cftransaction>
				<!--- Se devuelve a nulo el campo CPfcalculo del calendarios de pagos. Cuando se vuelva a aplicar se vuelve a calcular ese campo --->
				<cfquery name="rsRCalculoNominaUpdate" datasource="#Session.DSN#">
					update CalendarioPagos
					  set CPfcalculo = null
					 where CPid = coalesce((select RCNid
											 from ERNomina
											where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
											  and RCNid = CalendarioPagos.CPid ), 0)
				</cfquery>
				
				<cfquery name="rsRCalculoNominaUpdate" datasource="#Session.DSN#">
					update RCalculoNomina
						set RCestado = 0 
					where exists(select 1 
								   from ERNomina b
								  where b.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
									and b.RCNid = RCalculoNomina.RCNid )
				</cfquery>

				<!---Elimina DRIncidencias, DDeducPagos, DRNomina, ERNomina--->
				<cfquery name="rsDDeducPagosDelete" datasource="#Session.DSN#">			
					delete from DDeducPagos  
					where exists ( select 1
									from DRNomina
									 where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
									 and DDeducPagos.DRNlinea = DRNomina.DRNlinea )
				</cfquery>
				<cfquery name="rsDRIncidenciasDelete" datasource="#Session.DSN#">
					delete from DRIncidencias
					where exists ( 	select 1
									from DRNomina
									where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
									and DRIncidencias.DRNlinea = DRNomina.DRNlinea )
				</cfquery>					
				<cfquery name="rsDRNominaDelete" datasource="#Session.DSN#">
					delete from DRNomina 
					where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
				</cfquery>
				<cfquery name="rsERNominaDelete" datasource="#Session.DSN#">
					delete from ERNomina 
					where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarERNid#">
				</cfquery>
			</cftransaction>
		</cfloop>
	</cfif>
<cfcatch type="any">
	<cfinclude template="/sif/errorPages/BDerror.cfm">
</cfcatch>
</cftry>
<cflocation url="/cfmx/rh/pago/operacion/listaVNomina.cfm">