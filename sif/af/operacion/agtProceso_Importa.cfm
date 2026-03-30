<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 3-6-2006.
		Motivo: se pinta el botÃ³n de regresar, se agrega el importador de Cambio CategorÃ­a Clase.
 --->
 
 <cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = '_JA'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = '_Aux'>
</cfif>
<cf_templateheader title="	Activos Fijos">
	  <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importador">
		
		<!--- pone el valor a CFid y  IDtrans q seranenviadas por session--->
		<cfif isdefined("url.IDtrans") and isdefined("url.CFid")and len(trim(url.IDtrans)) NEQ 0  and len(trim(url.CFid)) NEQ 0>
			<cfset session.IDtrans = url.IDtrans>
			<cfset session.CFid = url.CFid>
		</cfif>
		
			<center>
				<table width="100%">
					
					<!--- Importacion de Retiros --->
					<cfif isdefined("url.IDtrans") and isdefined("url.number") and url.IDtrans EQ 5  and url.number EQ 1>
				
						<tr>
							<td align="right" valign="top" width="60%" >
								<cf_sifFormatoArchivoImpr EIcodigo = 'AFRET' tabindex="1">
							</td>
							<td align="center" valign="top" width="40%" >
								<cf_sifimportar EIcodigo="AFRET" mode="in" tabindex="1"/>
							</td>
						</tr>
						<tr>
							<td colspan="2"align="center" valign="top">
                            	<cfoutput>
									<input type="button" name="btnRegresar" value="Regresar"  onclick="javascript: location.href='agtProceso_RETIRO#LvarPar#.cfm'" ><!---  onclick="javascript: location.href='agtProceso_listaGrupos.cfm?IDtrans=5&number=1'" --->
                                </cfoutput>
							</td>
						</tr>	
						
					</cfif>
						
					<!--- Importacion de Mejoras --->
					<cfif isdefined("url.IDtrans") and isdefined("url.number") and url.IDtrans EQ 2  and url.number EQ 1>
						<tr>
							<td align="right" valign="top" width="60%" >
								<cf_sifFormatoArchivoImpr EIcodigo = 'AFMEJ' tabindex="1">
							</td>
							<td align="center" valign="top" width="40%" >
								<cf_sifimportar EIcodigo="AFMEJ" mode="in" tabindex="1"/>
							</td>
						</tr>
						<tr>
							<td colspan="2"align="center" valign="top">
                            	<cfoutput>
									<input type="button" name="btnRegresar" value="Regresar"  onclick="javascript: location.href='agtProceso_MEJORA#LvarPar#.cfm'" ><!--- onclick="javascript: location.href='agtProceso_listaGrupos.cfm?IDtrans=2&number=1'" --->
                                </cfoutput>
							</td>
						</tr>	
					</cfif>
						
					<!--- Importacion de Categora Clase--->
					<cfif isdefined("url.IDtrans") and isdefined("url.number") and url.IDtrans EQ 6  and url.number EQ 1>
						<tr>
							<td align="right" valign="top" width="60%" >
								<cf_sifFormatoArchivoImpr EIcodigo = 'AFCATCL' tabindex="1">
							</td>
							<td align="center" valign="top" width="40%" >
								<cf_sifimportar EIcodigo="AFCATCL" mode="in" tabindex="1"/>
							</td>
						</tr>
						<tr>
							<td colspan="2"align="center" valign="top">
								<input type="button" name="btnRegresar" value="Regresar" onclick="javascript: location.href='agtProceso_CAMCATCLAS.cfm'"> <!---onclick="javascript: location.href='transfcatclas.cfm?IDtrans=6&number=1'" --->
							</td>
						</tr>
					</cfif>
					<!--- Importacion de Cambio Tipo --->
					<cfif isdefined("url.IDtrans") and url.IDtrans EQ 7>
					
						<tr>
							<td align="right" valign="top" width="60%" >
								<cf_sifFormatoArchivoImpr EIcodigo = 'AFCAMTIP' tabindex="1">
							</td>
							<td align="center" valign="top" width="40%" >
                            	
								<cf_sifimportar EIcodigo="AFCAMTIP" mode="in" tabindex="1">
                                	<cfif isdefined('url.AGTPid')>
	                               		<cf_sifimportarparam name="AGTPid" value="#url.AGTPid#">
                                    </cfif>
								</cf_sifimportar>
							</td>
						</tr>
						<tr>
							<td colspan="2"align="center" valign="top">
								<input type="button" name="btnRegresar" value="Regresar"  onclick="javascript: location.href='transfTipo.cfm?IDtrans=7&number=1'"> 
							</td>
						</tr>
					</cfif>
					
					
				</table>
			</center>
	
		<cf_web_portlet_end>
	<cf_templatefooter>

