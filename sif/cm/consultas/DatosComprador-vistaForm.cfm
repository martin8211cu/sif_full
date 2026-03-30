<!--- Validación de parámetros necesarios en el Reporte --->
<cfif isdefined("url.CMCid") and not isdefined("form.CMCid")>
	<cfset form.CMCid = Url.CMCid>
</cfif>

<!--- Consultas para pintar los datos del Reporte --->
<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >
<cfquery name="rsComprador" datasource="#session.dsn#">
	select 	a.CMCid, 
			a.CMCcodigo, 
			a.CMCnombre, 
			case a.CMCestado when 1 then '#checked#' else '#unchecked#' end as CMCestado, 
			case a.CMCdefault when 1 then '#checked#' else '#unchecked#' end as CMCdefault,
			case a.CMTStarticulo when 1 then '#checked#' else '#unchecked#' end as CMTStarticulo,
			case a.CMTSservicio when 1 then '#checked#' else '#unchecked#' end as CMTSservicio,
			case a.CMTSactivofijo when 1 then '#checked#' else '#unchecked#' end as CMTSactivofijo,
			a.CMTStarticulo as CMTStarticulo1,
			a.CMTSservicio as CMTSservicio1,
			a.CMTSactivofijo as CMTSactivofijo1
	from CMCompradores a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<!--- and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#"> --->	
</cfquery>

<cfoutput>
<cfinclude template="AREA_HEADER.cfm"><br>
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td nowrap class="tituloListas" colspan="5" ><strong>&nbsp;#rsComprador.CMCcodigo# - #rsComprador.CMCnombre#</strong></td>
			<td nowrap class="tituloListas" align="right">#rsComprador.CMCestado#&nbsp;</td>
			<td nowrap class="tituloListas" ><strong>Activo</strong></td>
			<td nowrap class="tituloListas" align="right">#rsComprador.CMCdefault#&nbsp;</td>
			<td nowrap class="tituloListas" ><strong>Comprador Default</strong></td>
		</tr>
		<tr>
			<td nowrap colspan="9">
				<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td nowrap class="listaCorte">&nbsp;</td>
						<td nowrap colspan="5" class="listaCorte"><strong>Registro de Orden de Compra Manual</strong></td>
					</tr>
					<tr>
						<td nowrap width="5%">&nbsp;</td>
						<td nowrap colspan="5">
							<table width="100%" cellpadding="2" cellspacing="0" border="0">
								<tr valign="baseline">
									<td nowrap width="10%">&nbsp;</td>
									<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black;" width="5%"><strong>Estado</strong></td>
									<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>Tipo de Orden Compra</strong></td>
								</tr>
								<tr>
									<td nowrap width="10%">&nbsp;</td>
									<cfif #rsComprador.CMTStarticulo1# EQ 0 and #rsComprador.CMTSservicio1# EQ 0 and #rsComprador.CMTSactivofijo1# EQ 0>
										<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#checked#&nbsp;</td>
									<cfelse>
										<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#rsComprador.CMTStarticulo#&nbsp;</td>
									</cfif>
									<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>&nbsp;&nbsp;Art&iacute;culo</strong></td>
								</tr>
								<tr>
									<td nowrap width="10%">&nbsp;</td>
									<cfif #rsComprador.CMTStarticulo1# EQ 0 and #rsComprador.CMTSservicio1# EQ 0 and #rsComprador.CMTSactivofijo1# EQ 0>
										<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#checked#&nbsp;</td>
									<cfelse>
										<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#rsComprador.CMTSservicio#&nbsp;</td>
									</cfif>
									<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>&nbsp;&nbsp;Servicio</strong></td>
								</tr>
								<tr>
									<td nowrap width="10%">&nbsp;</td>
									<cfif #rsComprador.CMTStarticulo1# EQ 0 and #rsComprador.CMTSservicio1# EQ 0 and #rsComprador.CMTSactivofijo1# EQ 0>
										<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#checked#&nbsp;</td>
									<cfelse>
										<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#rsComprador.CMTSactivofijo#&nbsp;</td>
									</cfif>
									<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>&nbsp;&nbsp;Activo Fijo</strong></td>
								</tr>
							</table>
						</td>
					</tr>
				    <tr><td nowrap colspan="6">&nbsp;</td></tr>
					<tr>
						<td nowrap class="listaCorte">&nbsp;</td>
						<td nowrap colspan="5" class="listaCorte"><strong>Especializaci&oacute;n del Comprador</strong></td>
					</tr>
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap colspan="5" align="center">
							<cfquery name="rsEspecializacion" datasource="#session.dsn#">
								select b.CMTScodigo, b.CMTSdescripcion 
								from CMCompradores a 
									inner join CMTiposSolicitud b
										on a.Ecodigo = b.Ecodigo
										and a.Usucodigo = b.Usucodigo 
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									<!--- and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#"> --->
							</cfquery>

							<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
								
								<cfif rsEspecializacion.RecordCount GT 0>
									<tr valign="baseline">
										<td nowrap width="10%">&nbsp;</td>
										<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black;"><strong>C&oacute;digo</strong></td>
										<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" ><strong>Descripci&oacute;n</strong></td>
									</tr>

									<cfloop query="rsEspecializacion">
										<tr>
											<td nowrap width="10%">&nbsp;</td>
											<td nowrap style="padding-right: 5px; border-bottom: 1px solid black;" 
												class="<cfif rsEspecializacion.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
												&nbsp;#rsEspecializacion.CMTScodigo#
											</td>
											<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" 
												class="<cfif rsEspecializacion.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
												&nbsp;#rsEspecializacion.CMTSdescripcion#
											</td>
										</tr>
									</cfloop>
								<cfelse>
									<tr><td nowrap colspan="3">&nbsp;</td></tr>
									<tr>
										<td nowrap colspan="2" align="center">
											<strong> --- El Comprador no tiene restricci&oacute;n en la especializaci&oacute;n de Compra --- </strong>
										</td>
									</tr>
								</cfif>
							</table>
						</td>
					</tr>
  					<tr><td nowrap colspan="6">&nbsp;</td></tr> 
					<tr>
						<td nowrap class="listaCorte">&nbsp;</td>
						<td nowrap colspan="5" class="listaCorte"><strong>Monto M&aacute;ximo permitido por Compras</strong></td>
					</tr>
					<tr>
						<td nowrap>&nbsp;</td>
						<td nowrap colspan="5">
							<cfquery name="rsMoneda" datasource="#session.dsn#">
								select b.Mnombre, a.CMCmontomax  
								from CMCompradores a 
									inner join Monedas b
										on a.Ecodigo = b.Ecodigo
										and a.Mcodigo = b.Mcodigo 
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									<!--- and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#"> --->
							</cfquery>

							<table width="100%" cellpadding="2" cellspacing="0" border="0">
								<tr valign="baseline">
									<td nowrap width="10%">&nbsp;</td>
									<td nowrap width="15%" class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black;" align="right"><strong>Monto M&aacute;ximo</strong></td>
									<td nowrap class="listaCorte" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>Tipo de Moneda</strong></td>
								</tr>
								<cfloop query="rsMoneda">
									<tr>
										<td nowrap width="10%">&nbsp;</td>
										<td nowrap width="15%" style="padding-right: 5px; border-bottom: 1px solid black;" 
											class="<cfif rsMoneda.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" align="right">
											&nbsp;#LSCurrencyFormat(rsMoneda.CMCmontomax,'none')#
										</td>
										<td nowrap style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" 
											class="<cfif rsMoneda.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>">
											&nbsp;#rsMoneda.Mnombre#
										</td>
									</tr>
								</cfloop>
							</table>
						</td>
					</tr>

				</table>
			</td>
		</tr>
		
		<tr><td colspan="9" nowrap>&nbsp;</td></tr>
		<tr>
			<td colspan="9" nowrap align="center" class="listaCorte">
				<strong>&nbsp;--- Fin de la Consulta ---&nbsp;</strong>
			</td>
		</tr>
	</table>
</cfoutput>
