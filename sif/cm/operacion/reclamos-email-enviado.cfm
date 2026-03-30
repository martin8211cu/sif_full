<cf_templateheader title="Envío de Reclamos Aplicados">
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select 	a.SNcodigorec, 
				a.EDRnumero, 
				(b.DRcantorig - b.DRcantrec) * c.DDRpreciou as Monto,
				d.SNnombre  
		from 	EReclamos a 
				inner join DReclamos b
					on a.Ecodigo = b.Ecodigo
					and a.ERid = b.ERid
				inner join DDocumentosRecepcion c
					on b.Ecodigo = c.Ecodigo
					and b.DDRlinea = c.DDRlinea
				inner join SNegocios d
					on a.SNcodigo = d.SNcodigo
					and a.Ecodigo = d.Ecodigo	
		where a.ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERid#">
			and c.DDRgenreclamo = 1
	</cfquery>
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Órdenes de Compra '>
		<cfinclude template="/home/menu/pNavegacion.cfm">

		<cfoutput>
			<form action="reclamos-lista.cfm" name="form1" id="form1" method="get">
				<table width="99%" align="center" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td nowrap>
							<fieldset><legend><strong>Reclamos - Envío de Correos.&nbsp;</strong></legend>	
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
											#HTMLEditFormat(rsSocio.SNnombre)# &lt;#HTMLEditFormat(url.email)#&gt;
										</td>
									</tr>
									<tr>
										<td nowrap><strong>Cc:</strong></td>
										<td nowrap>&nbsp;</td>
										<td nowrap><cfif isdefined("url.Ccemail") and len(trim(url.Ccemail)) NEQ 0>&lt;#HTMLEditFormat(url.Ccemail)#&gt;</cfif></td>
									</tr>
									<tr>
										<td nowrap><strong>Asunto:</strong></td>
										<td nowrap>&nbsp;</td>
										<td nowrap>
											N&uacute;mero de Reclamo #HTMLEditFormat(rsSocio.EDRnumero)# por #NumberFormat(rsSocio.Monto,',0.00')#
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
			<cfinclude template="reclamos-detalle.cfm">
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>