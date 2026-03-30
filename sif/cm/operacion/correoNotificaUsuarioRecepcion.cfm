<cffunction name="contenidoCorreoUsuarioRecepcion" returntype="string">
	<cfargument name="EDRid" type="numeric" required="yes">			<!--- id del Documento de Recepción --->
	<cfargument name="Pnombre" type="string" required="yes">		<!--- Nombre del Resposable --->
	<cfargument name="TipoCorreo" type="numeric" required="yes">	<!--- 1 = Documento requiere de aprobación de tolerancia, 2 = Documento fue aprobado --->
	<cfargument name="Usucodigo" type="numeric" required="yes">		<!--- Usucodigo del destinatario --->
	<cfargument name="CEcodigo" type="numeric" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfsavecontent variable="_contenido_correo">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
			<head>
				<title>Notificación</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			</head>
			<body>
			
			<cfif arguments.TipoCorreo eq 1>
				<cfquery name="dataCorreoDetalle" datasource="#session.dsn#">
					select distinct dp.Pnombre #_Cat# dp.Papellido1 #_Cat# dp.Papellido2 as Pnombre,
									edr.EDRnumero, edr.EDRfecharec
					from DDocumentosRecepcion ddr
						inner join EDocumentosRecepcion edr
							on edr.EDRid = ddr.EDRid
							and edr.Ecodigo = ddr.Ecodigo

						inner join DOrdenCM docm
							on docm.DOlinea = ddr.DOlinea
							and docm.Ecodigo = ddr.Ecodigo

						inner join EOrdenCM eo
							on eo.EOidorden = docm.EOidorden
							and docm.Ecodigo = docm.Ecodigo

						inner join CMCompradores cmc
							on cmc.CMCid = eo.CMCid
							and cmc.Ecodigo = eo.Ecodigo

						inner join Usuario usu
							on usu.Usucodigo = cmc.Usucodigo

						inner join DatosPersonales dp
							on dp.datos_personales = usu.datos_personales

					where ddr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EDRid#">
						and ddr.DDRaprobtolerancia = 5
				</cfquery>

			<cfelseif arguments.TipoCorreo eq 2>
				<cfquery name="dataCorreoDetalle" datasource="#session.dsn#">
					select case when ddr.DDRaprobtolerancia = 10 then 'Aprobada' else 'Rechazada' end as estado,
							 ddr.DDRlinea, eo.EOnumero, art.Acodigo,
							docm.DOconsecutivo, ddr.DDRgenreclamo,
							edr.EDRnumero, edr.EDRfecharec, docm.DOdescripcion
					from DDocumentosRecepcion ddr
						inner join EDocumentosRecepcion edr
							on edr.EDRid = ddr.EDRid
							and edr.Ecodigo = ddr.Ecodigo
							
						inner join DOrdenCM docm
							on docm.DOlinea = ddr.DOlinea
							and docm.Ecodigo = ddr.Ecodigo
							
							inner join EOrdenCM eo
								on eo.EOidorden = docm.EOidorden
								and docm.Ecodigo = docm.Ecodigo
		
							inner join Articulos art
								on art.Aid = docm.Aid
								and art.Ecodigo = docm.Ecodigo
		
					where ddr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EDRid#">
						and ddr.DDRaprobtolerancia in (10,20)
					order by art.Acodigo
				</cfquery>
			</cfif>
			
			<table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
				
				<!--- Encabezado del correo --->
				<tr bgcolor="##003399">
					<td colspan="2" height="24"></td>
				</tr>
				<tr bgcolor="##999999">
					<td colspan="2"> <strong>Informaci&oacute;n sobre notificaci&oacute;n en Sistema de Compras</strong> </td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td><span class="style2"><strong>De</strong></span></td>
					<td><span class="style7">Sistema de Compras</span></td>
				</tr>
				<tr>
					<td><span class="style7"><strong>Para</strong></span></td>
					<td><span class="style7"><cfoutput>#arguments.Pnombre#</cfoutput></span></td>
				</tr>		
				<tr>
					<td><span class="style8"></span></td>
					<td><span class="style8"></span></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><span class="style7">Informaci&oacute;n sobre notificaci&oacute;n de Sistema de Compras.</span></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<table border="0" cellpadding="2" cellspacing="0" style="border:1px solid ##999999;">
							<tr>
								<td nowrap><span class="style8"><strong>N&uacute;mero de Recepci&oacute;n:&nbsp;</strong></span></td>
								<td align="left"><span class="style8"><cfoutput>#dataCorreoDetalle.EDRnumero#</cfoutput></span></td>
							</tr>
							<tr>
								<td nowrap><span class="style8"><strong>Fecha de Recepci&oacute;n:&nbsp;</strong></span></td>
								<td align="left"><span class="style8"><cfoutput>#LSDateFormat(dataCorreoDetalle.EDRfecharec,"dd/mm/yyyy")#</cfoutput></span></td>
							</tr>
							<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
							<tr>
								<td colspan="2" nowrap>
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<cfif arguments.TipoCorreo eq 1>
												<td>
													<span class="style8">
													Sr(a)/Srta. <cfoutput>#arguments.Pnombre#</cfoutput>, el documento de recepción <cfoutput>#dataCorreoDetalle.EDRnumero#</cfoutput> <br>
													debe ser aprobado por excesos de tolerancia por los siguientes compradores.
													</span>
												</td>
											<cfelseif arguments.TipoCorreo eq 2>
												<td>
													<span class="style8">
													Sr(a)/Srta. <cfoutput>#arguments.Pnombre#</cfoutput>, el documento de recepción <cfoutput>#dataCorreoDetalle.EDRnumero#</cfoutput> <br>
													ya fue verificado por los compradores respectivos. El documento requiere de su aplicación final.
													</span>
												</td>
											</cfif>
										</tr>
									</table>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
							<tr>
								<cfif arguments.TipoCorreo eq 1>
									<td colspan="2" nowrap valign="top"><span class="style8"><strong>Listado de Compradores&nbsp;</strong></span></td>
								<cfelseif arguments.TipoCorreo eq 2>
									<td colspan="2" nowrap valign="top"><span class="style8"><strong>Detalle de las Líneas&nbsp;</strong></span></td>
								</cfif>
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" cellpadding="2" cellspacing="0">
										<tr bgcolor="##F5F5F5">
											<cfif arguments.TipoCorreo eq 1>
												<td nowrap align="left"><span class="style9"><strong>Comprador&nbsp;</strong></span></td>
											<cfelseif arguments.TipoCorreo eq 2>
												<td nowrap align="left"><span class="style9"><strong>O. C.&nbsp;</strong></span></td>
												<td align="right"><span class="style9"><strong>Línea&nbsp;</strong></span></td>
												<td align="left"><span class="style9"><strong>Articulo&nbsp;</strong></span></td>
												<td align="left"><span class="style9"><strong>Descripci&oacute;n&nbsp;</strong></span></td>
												<td align="left"><span class="style9"><strong>Exceso Tolerancia</strong></span></td>
											</cfif>
										</tr>
										<cfoutput>
											<cfloop query="dataCorreoDetalle">
												<tr bgcolor="<cfif not dataCorreoDetalle.CurrentRow mod 2>##FAFAFA</cfif>">
													<cfif arguments.TipoCorreo eq 1>
														<td align="left"><span class="style9">#dataCorreoDetalle.Pnombre#&nbsp;</span></td>
													<cfelseif arguments.TipoCorreo eq 2>
														<td align="left"><span class="style9">#dataCorreoDetalle.EOnumero#&nbsp;</span></td>
														<td align="right"><span class="style9">#dataCorreoDetalle.DOconsecutivo#&nbsp;</span></td>
														<td align="left"><span class="style9">#dataCorreoDetalle.Acodigo#&nbsp;</span></td>
														<td align="left"><span class="style9">#dataCorreoDetalle.DOdescripcion#&nbsp;</span></td>
														<td align="right"><span class="style9">#dataCorreoDetalle.estado#&nbsp;</span></td>
													</cfif>
												</tr>
											</cfloop>
										</cfoutput>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td><span class="style8"></span></td>
					<td><span class="style8"></span></td>
				</tr>
				<cfset hostname = session.sitio.host>
				<cfset Usucodigo = arguments.Usucodigo>
				<cfset CEcodigo = arguments.CEcodigo>
				<!---<cfoutput>
					<tr>
						<td>&nbsp;</td>
						<td align="center">
							<span class="style1">
							Nota: En #hostname# respetamos su privacidad. <br>
							Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>.
							</span>
						</td>
					</tr>
				</cfoutput>--->
			</table>

			</body>
		</html>
 	</cfsavecontent>
	
	<cfreturn _contenido_correo>
</cffunction>