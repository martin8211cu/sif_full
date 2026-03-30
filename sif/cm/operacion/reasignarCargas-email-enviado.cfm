<cf_templateheader title="Reasignaci&oacute;n de Cargas de Trabajo - Env&iacute;o de Correo ">
	<cfinclude template="../../Utiles/sifConcat.cfm">
		<!--- Consultas para mostrar los datos de la Solicitud de Compra --->
		<cfquery name="rsSolicitud" datasource="#session.DSN#">
			select 	a.ESnumero, 
					a.ESfecha,
					a.ESobservacion,
					a.EStotalest,
					rtrim(a.CMTScodigo)#_Cat#' - '#_Cat#b.CMTSdescripcion as CMTSdescripcion,
					a.CFid,
					c.CFdescripcion,
					d.Mnombre,
					d.Msimbolo,
					e.BMCfecha 
			from ESolicitudCompraCM a
					inner join CMTiposSolicitud b
						on a.Ecodigo = b.Ecodigo
						and a.CMTScodigo = b.CMTScodigo
					inner join CFuncional c	
						on a.Ecodigo = c.Ecodigo
						and a.CFid = c.CFid
					inner join Monedas d
						on a.Ecodigo = d.Ecodigo
						and a.Mcodigo = d.Mcodigo
					left outer join BMComprador e
						on a.Ecodigo = e.Ecodigo
						and a.ESidsolicitud = e.ESidsolicitud
			where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESidsolicitud#">
		</cfquery>
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reasignaci&oacute;n Cargas de Trabajo -  Envio de Correo'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
	
			<cfoutput>
				<form action="reasignarCargas.cfm" name="form1" id="form1" method="get">
					<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td nowrap>
								<fieldset><legend><strong>Envío de Correo a Compradores&nbsp;</strong></legend>	
									<table width="90%" align="center">
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<img src="reclamos-email.gif" width="37" height="12"> &nbsp;&nbsp; El correo ha sido enviado satisfactoriamente. 
											</td>
										</tr>
										<tr>
											<td nowrap><strong>De:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# </td></tr>
										</tr>
										<tr>
											<td nowrap><strong>Para:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												#HTMLEditFormat(url.nameBuyerTo)# &lt;#HTMLEditFormat(url.email)#&gt;
											</td>
										</tr>
										<tr>
											<td nowrap><strong>Cc:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap><cfif isdefined("url.Ccemail") and len(trim(url.Ccemail)) NEQ 0>#HTMLEditFormat(url.nameBuyerCc)# &lt;#HTMLEditFormat(url.Ccemail)#&gt;</cfif></td>
										</tr>
										<tr>
											<td nowrap><strong>Asunto:</strong></td>
											<td nowrap>&nbsp;</td>
											<td nowrap>
												Reasignaci&oacute;n de Cargas de Trabajo.
											</td>
										</tr>
										<tr>
											<td colspan="3" class="subTitulo tituloListas">
												<input type="submit" value="Continuar" name="btnEnviar">
											</td>
										</tr>
									</table>
								</fieldset>
							</td>
						</tr>
					</table>
				</form>
				<cfinclude template="reasignarCargas-Aviso.cfm">
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>