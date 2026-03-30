<cf_templateheader title="Compras - Consulta Seguimiento de Solicitudes Detallada">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Seguimiento de Solicitudes Detallada General'>
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select a.ESidsolicitud, a.ESnumero, a.ESobservacion
					from ESolicitudCompraCM a
							
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">						

						<cfif isdefined("form.ESnumero1") and len(trim(form.ESnumero1)) and (isdefined("form.ESnumero2") and len(trim(form.ESnumero2))) >
							<cfif form.ESnumero1  GT form.ESnumero2>
								and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#">
								and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#">
							<cfelseif form.ESnumero1 EQ form.ESnumero2>
								and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#">
							<cfelse>
									and a.ESnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#">
									and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#">
							</cfif>
						</cfif>
						
						<cfif isdefined("form.ESnumero1") and len(trim(form.ESnumero1)) and not (isdefined("form.ESnumero2") and len(trim(form.ESnumero2))) >
								and a.ESnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero1#">
						</cfif>
						
						<cfif isdefined("form.ESnumero2") and len(trim(form.ESnumero2)) and not (isdefined("form.ESnumero1") and len(trim(form.ESnumero1))) >
								and a.ESnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESnumero2#">
						</cfif>
						<cfif isdefined("form.fCMTScodigo") and len(trim(form.fCMTScodigo)) >
							and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fCMTScodigo#">
						</cfif>
						
						<cfif isdefined("form.LEstado") and len(trim(form.LEstado)) >
							and a.ESestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstado#">
						</cfif>
					
						<cfif isdefined("Form.fCFid") and len(trim(Form.fCFid)) >
								and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.fCFid#">
						</cfif>		
						
                        <cfif isdefined("Form.CMSid") and len(trim(Form.CMSid)) >
								and a.CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMSid#">
						</cfif>
                        
						<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
							<cfif form.fechaD EQ form.fechaH>
								and a.ESfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
							<cfelse>
								and a.ESfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
							</cfif>
						</cfif>
		
						<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
							and a.ESfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
							<!---and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsMayorFecha.fechaMayor)#">--->
						</cfif>
		
						<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
							and a.ESfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
							<!---and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsMayorFecha.fechaMayor)#">--->
						</cfif>
				</cfquery>
				
				<cfif rsDatos.RecordCount EQ 0>
			  		<cfset form.ESnumero1 = ''>
					<cf_errorCode	code = "50276" msg = "El número de Solicitud no existe">	
			  	<!---<cflocation url="SeguimientoSolicitudes-lista.cfm">--->
				</cfif>
				
				<cfif isdefined("rsDatos") and rsDatos.RecordCount NEQ 0>
					<cfset form.ESidsolicitud = ValueList(rsDatos.ESidsolicitud)>					
				<cfelse>
					<cfset form.ESidsolicitud = 0>
				</cfif>				
<!----
			</cfif>			
---->			
									
			<cfoutput>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td><cfinclude template="../../portlets/pNavegacionCM.cfm"></td></tr>						
						<tr><td>&nbsp;</td></tr>
						<tr><td><cf_rhimprime datos="/sif/cm/consultas/SegSolDetGen-Imprime.cfm" paramsuri="&ESidsolicitud=#form.ESidsolicitud#"></td></tr>
						<tr><td><cfinclude template="SegSolDet-Imprime.cfm"></td></tr>	 		
					</table>						
			</cfoutput>						
		<cf_web_portlet_end>
	<cf_templatefooter>


