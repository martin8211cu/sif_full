<cf_templateheader title="Reasignaci&oacute;n de Ordenes de Compra - Env&iacute;o de Correo ">
		<cfinclude template="../../Utiles/sifConcat.cfm">
		<!--- Consultas para mostrar los datos de la Orden de Compra --->
		<cfquery name="rsOrden" datasource="#session.DSN#">
			select 	a.EOnumero,
					a.SNcodigo,
					a.EOfecha,
					a.Observaciones,
					a.EOtotal,	
					rtrim(b.SNidentificacion)#_Cat#' - '#_Cat#b.SNnombre as SNnombre,
					c.Mnombre,
					c.Msimbolo,
					rtrim(a.CMTOcodigo)#_Cat#' - '#_Cat#d.CMTOdescripcion as CMTOdescripcion,
					e.BMCfecha
			from EOrdenCM a
					inner join SNegocios b
						on a.Ecodigo = b.Ecodigo
						and a.SNcodigo = b.SNcodigo
					inner join Monedas c
						on a.Ecodigo = c.Ecodigo
						and a.Mcodigo = c.Mcodigo
					inner join CMTipoOrden d
						on a.Ecodigo = d.Ecodigo
						and a.CMTOcodigo = d.CMTOcodigo
					left outer join BMComprador e
								on a.Ecodigo = e.Ecodigo
								and a.EOidorden = e.EOidorden			
								and e.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
				and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EOidorden#">	
		</cfquery>
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reasignaci&oacute;n de Ordenes de Compra -  Envio de Correo'>
			<cfinclude template="/home/menu/pNavegacion.cfm">
	
			<cfoutput>
				<form action="reasignarOrden.cfm" name="form1" id="form1" method="get">
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
												Reasignaci&oacute;n de Ordenes de Compra.
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
				<cfinclude template="reasignarOrden-Aviso.cfm">
			</cfoutput>
		
		<cf_web_portlet_end>
	<cf_templatefooter>