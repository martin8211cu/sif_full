<!--- Consultas para llenar el Vale de Adquisicion --->
<!--- Categorias --->
<cfquery name="rsCategorias" datasource="#Session.dsn#">
	select ACcodigo, ACdescripcion, ACmascara
	from ACategoria 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVale.ACcodigo#">
</cfquery>

<!--- Clases se llenan automáticamente cuando cambia la categoria. --->
<cfquery name="rsClases" datasource="#Session.dsn#">
	select a.ACcodigo, a.ACid, a.ACdescripcion, a.ACdepreciable, a.ACrevalua
	from AClasificacion a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.ACid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVale.ACid#">
</cfquery>

<cfif (isdefined('rsVale')) 
		and (rsVale.recordCount) 
		and (len(trim(rsVale.AFMid))) 
		and (len(trim(rsVale.AFMMid)))>
	<cfquery name="rsMarcaMod" datasource="#Session.dsn#">
		Select ma.AFMid
			, AFMMid
			, AFMcodigo
			, AFMdescripcion
			, AFMMcodigo
			, AFMMdescripcion
		from AFMarcas ma,
			AFMModelos mo
		where ma.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ma.AFMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVale.AFMid#">
			and mo.AFMMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVale.AFMMid#">
			and ma.Ecodigo=mo.Ecodigo
			and ma.AFMid=mo.AFMid
	</cfquery>	
</cfif>

<!--- form --->
<form action="vales_adquisicion_sql.cfm" method="post" name="form1">

<!--- Tabla 1 --->
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td rowspan="100" width="5%">&nbsp;</td>
		<td class="subTitulo" nowrap width="80%">
			<strong>Adquisici&oacute;n de Activos</strong>
		</td>
		<td rowspan="100" width="5%">&nbsp;</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr><!--- Datos Generales del Activo --->
		<td width="80%">
			<!---I--->
			<table width="100%"  border="0" cellspacing="4" cellpadding="0">
				<tr>
					<td nowrap><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></td>
					<td>
						#rsVale.AFAdescripcion#
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Marca&nbsp;:&nbsp;</strong></td>
					<td rowspan="2">
						<cf_sifmarcamod	query="#rsMarcaMod#" modificable="false">
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Modelo&nbsp;:&nbsp;</strong></td>
					<!--- Definido por tag de marca / modelo <td>&nbsp;</td> --->
				</tr>
				<tr>
					<td nowrap><strong>Catagor&iacute;a&nbsp;:&nbsp;</strong></td>
					<td>
						#rsCategorias.ACdescripcion#
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Clase&nbsp;:&nbsp;</strong></td>
					<td>
						#rsClases.ACdescripcion#
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Serie&nbsp;:&nbsp;</strong></td>
					<td>
						#rsVale.AFAserie#
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Inicio Depreciaci&oacute;n&nbsp;:&nbsp;</strong></td>
					<td>
						#LSDateformat(rsVale.AFAfechainidep,'dd/mm/yyyy')#
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Inicio Revaluaci&oacute;n&nbsp;:&nbsp;</strong></td>
					<td>
						#LSDateformat(rsVale.AFAfechainirev,'dd/mm/yyyy')#
					</td>
				</tr>
				<tr>
					<td nowrap><strong>Monto&nbsp;:&nbsp;</strong></td>
					<td>
						#lscurrencyformat(rsVale.AFAmonto,'none')#
					</td>
				</tr>
				<!---Línea en Blanco--->
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						<!--- Datos de la Factura SI LOS HAY --->
						<fieldset><legend>Datos de la Factura</legend>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
								<tr>
									<td><strong>Documento&nbsp;:&nbsp;</strong></td>
									<td>
										#rsVale.AFAdocumento#
									</td>
								</tr>
								<tr>
									<td><strong>Socio&nbsp;:&nbsp;</strong></td>
									<td>
									<cfif len(rsVale.SNcodigo)>
										<cfquery name="rsSocio" datasource="#session.dsn#">
											select SNnumero, SNcodigo, SNnombre
											from SNegocios
											where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVale.SNcodigo#">
										</cfquery>
										#rsSocio.SNnumero# #rsSocio.SNnombre#
										</cfif>
									</td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
				<!---Línea en Blanco---><tr><td colspan="2">&nbsp;</td></tr>
				<tr><td colspan="2">
					<p style="text-transform:uppercase; color:##FF0000" align="center"> <strong>Esta adquisici&oacute;n se encuentra en espera de ser aprobada.</strong> </p>
				</td></tr>
				<!---Línea en Blanco---><tr><td colspan="2">&nbsp;</td></tr>
			</table>
			<!---F--->
		</td>
	</tr>

<!--- Fin de la Tabla 1 --->
</table></cfoutput>

<!--- Fin del Form1--->
</form>