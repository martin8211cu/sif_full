<cfquery name="rsPaqSel" datasource="#session.DSN#">
	select PQcodigo,PQdescripcion
	from ISBpaquete
	where PQcodigo = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PQcodigo_n#"> 
		and Ecodigo = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>

<cfoutput>
	<cf_web_portlet_start tipo="box">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="cfmenu_menu">
		  <tr>
			<td colspan="2"><strong>Opciones Seleccionadas</strong><hr></td>
		  </tr>
		  <tr>
			<td width="17%" align="right"><strong>Paquete:</strong></td>
			<td width="79%">&nbsp;&nbsp;
				<cfif isdefined('rsPaqSel') and rsPaqSel.recordCount GT 0>
					#rsPaqSel.PQcodigo#&nbsp;#rsPaqSel.PQdescripcion#
				<cfelse>
					&nbsp;
				</cfif>
			</td>
		  </tr>
		  
			<cfif form.adser GTE 3><!--- Logines --->
			  <tr>
				<td align="right" valign="top"><strong>Login(es):</strong></td>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
																
						<cfloop from="1" to="#maxServicios.cantidad#" index="iLogin">
							<cfif isdefined("form.login_#iLogin#") and len(trim(form["login_#iLogin#"]))>
								<cfset servXlogin = "">
								<cfloop query="rsServiciosDisponibles">
									<cfif isdefined("form.chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLogin#") and len(trim(form["chk_#Trim(rsServiciosDisponibles.TScodigo)#_#iLogin#"]))>
										<cfif Len(trim(servXlogin)) GT 0>
											<cfset servXlogin = servXlogin & "," & rsServiciosDisponibles.descripcion>
										<cfelse>
											<cfset servXlogin = rsServiciosDisponibles.descripcion>
										</cfif>										
									</cfif>
								</cfloop>							
								<tr>
									<td width="0%">&nbsp;
										
									</td>						
									<td width="13%" valign="top">
										#form['login_#iLogin#']#
									</td>
									<td width="2%">&nbsp;&nbsp;</td>
									<td width="85%">
										#servXlogin#
									</td>							
								</tr>						
							</cfif>
						</cfloop>			
					</table>		
				</td>
			  </tr>
				<cfif form.adser GTE 4 >
					<cfquery name="rsPaqSel" datasource="#session.DSN#">
						select CUECUE
						from ISBcuenta
						where CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid_n#"> 		
					</cfquery>			
				  <tr>
					<td align="right" valign="top"><strong>Cuenta:</strong></td>
					<td>
						<cfif isdefined('rsPaqSel') and rsPaqSel.recordCount GT 0>
							&nbsp;&nbsp;#rsPaqSel.CUECUE#
						<cfelse>
							&nbsp;&nbsp;
						</cfif>
					</td>
				  </tr>	
			  </cfif>
			</cfif>
		</table>
	<cf_web_portlet_end>
</cfoutput>