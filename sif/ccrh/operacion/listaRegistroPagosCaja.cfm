<cf_templateheader title="Lista de Deducciones">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Deducciones'>
			<cfinclude template="../../portlets/pNavegacion.cfm">

				<cfif isdefined("url.DEid") and len(trim(url.DEid)) neq 0>
					<cfset form.DEid=url.DEid >
				</cfif>
				
				<cfif isdefined("url.TDid")and len(trim(url.TDid))NEQ 0>
					<cfset form.TDid=url.TDid >
				</cfif>
				
				<cfif not isdefined("form.DEid")  or len(trim(form.DEid)) EQ 0>
					<cflocation url="registroPagosCajaFiltro.cfm">	
				</cfif>
				
				<cfif isdefined("url.eliminartmp")><!---Eliminar registros del temporal para ese usuario y empleado (elimina para TODAS las deducciones)--->					
					<!---Devolver el valor a el recibo--->
					<cfquery name="rsMtoRestituir" datasource="#session.DSN#">
						select sum(montoAplicado) as mtorestituir,idRecibo
						from ccrhPagoRecibos
						where BMUsucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
						group by idRecibo	
					</cfquery>
					
					<cfloop query="rsMtoRestituir">
						<cfset vn_mtorestituir = rsMtoRestituir.mtorestituir>
						<cfquery datasource="#session.DSN#">
							update PagoPorCaja
								set MontoUtilizado = abs(MontoUtilizado) - <cfqueryparam  cfsqltype="cf_sql_float" value="#vn_mtorestituir#">	
							where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMtoRestituir.idRecibo#">
						</cfquery>
					</cfloop>
					<cfquery datasource="#session.DSN#">
						delete from ccrhPagoRecibos
						where BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">							
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					</cfquery>
				</cfif>

				<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr><td>&nbsp;</td></tr>
					<tr><td><cfinclude template="/sif/portlets/pEmpleado.cfm"></td></tr>
					<tr>
						<td>
							<table width="100%" align="center" class="areaFiltro" cellpadding="0" cellspacing="0">
								<tr><td style="padding:4; "><strong>Seleccione el plan de pagos al que desea registrar un pago.</strong></td></tr>
							</table>
						</td>
					</tr>	
					<tr>
						<td>
							<cfset navegacion = "">
							
							<cfif isdefined("form.DEid") and len(trim(#form.DEid#)) neq 0>
								<cfset navegacion = navegacion & "DEid="&form.DEid>	
							</cfif>
							
							<cfif isdefined("form.TDid")and len(trim(form.TDid))NEQ 0>
								<cfif navegacion NEQ "">
									<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "TDid="&form.TDid>
								<cfelse>	
									<cfset navegacion = navegacion & 'TDid='&form.TDid>
								</cfif> 
							</cfif>
							
							<cfquery name="rsLista" datasource="#session.DSN#">
								select 	a.DEid, a.Did, 
										a.TDid, 
										<cf_dbfunction name="concat" args="b.TDcodigo,'-',b.TDdescripcion"> as TDeduccion,										
										a.Dreferencia, a.Ddescripcion, a.SNcodigo, 
										c.SNnumero, c.SNnombre, a.Dfechaini, Dvalor
										,b.TDdescripcion
										,coalesce((select coalesce(PPsaldoant, 0)
												  from DeduccionesEmpleadoPlan z
												  where z.Did=a.Did
													and z.PPpagado=0
													and  PPnumero = ( select min(PPnumero) 
																	from DeduccionesEmpleadoPlan x 
																	where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																		and x.Did= z.Did
																		and x.PPpagado=0)
												 ),0) as PPsaldoactual  
										
								from DeduccionesEmpleado a
									inner join TDeduccion b
										on a.TDid=b.TDid
										and a.Ecodigo=b.Ecodigo
									
									left outer join SNegocios c
										on a.SNcodigo=c.SNcodigo
										and a.Ecodigo=c.Ecodigo
									
								where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and b.TDfinanciada=1
									
									and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
									<cfif isdefined("form.TDid") and len(trim(form.TDid))>
										and a.TDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
									</cfif>										
									and a.Did in (select distinct Did 
												from DeduccionesEmpleadoPlan
												where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
									and (select coalesce(PPsaldoant, 0)
										  from DeduccionesEmpleadoPlan z
										  where z.Did=a.Did
											and z.PPpagado=0
											and  PPnumero = ( select min(PPnumero) 
															from DeduccionesEmpleadoPlan x 
															where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																and x.Did= z.Did
																and x.PPpagado=0)
										) > 0			
								order by b.TDdescripcion, a.Dfechaini				
							</cfquery>
								
							<cfif rsLista.recordCount eq 1>
								<cfoutput>
								<cfif not isdefined("form.btnRegresar2")>
									<cfset parametros = "?DEid=#rsLista.DEid#&Did=#rsLista.Did#&TDid=#rsLista.TDid#" >
									<cflocation url="registroPagosCaja.cfm#parametros#">
								<cfelse>
									<cflocation url="registroPagosCajaFiltro.cfm">
								</cfif>
								</cfoutput>
							</cfif>

							<cfinvoke 
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="TDeduccion, Dreferencia, Ddescripcion, Dfechaini, PPsaldoactual, Dvalor"/>
								<cfinvokeargument name="etiquetas" value="Tipo Deducci&oacute;n, Referencia, Descripci&oacute;n, Fecha de Inicio, Saldo Actual, Monto Cuota"/>
								<cfinvokeargument name="formatos" value="V,V, V, D, M, M"/>
								<cfinvokeargument name="align" value="left,left, left, left, right, right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="irA" value="registroPagosCaja.cfm"/> 
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="maxrows" value="18"/>
								<cfinvokeargument name="Cortes" value="TDdescripcion"/>								
							</cfinvoke>
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><input type="button" name="Regresar" value="<< Regresar" onclick="location.href='registroPagosCajaFiltro.cfm'"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
	<cf_web_portlet_end>
<cf_templatefooter>		