<!--- Validación de parámetros necesarios en el Reporte --->
<cfif isdefined("url.CMCcodigo1") and not isdefined("form.CMCcodigo1")>
	<cfset form.CMCcodigo1 = Url.CMCcodigo1>
</cfif>

<cfif isdefined("url.CMCcodigo2") and not isdefined("form.CMCcodigo2")>
	<cfset form.CMCcodigo2 = Url.CMCcodigo2>
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
		<cfif isdefined("form.CMCcodigo1") and trim(form.CMCcodigo1) NEQ "" and isdefined("form.CMCcodigo2") and trim(form.CMCcodigo2) NEQ "">
			and a.CMCcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMCcodigo1#">	
				and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMCcodigo2#">	
		<cfelseif isdefined("form.CMCcodigo1") and trim(form.CMCcodigo1) NEQ "" and isdefined("form.CMCcodigo2") and trim(form.CMCcodigo2) EQ "">
			and a.CMCcodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMCcodigo1#">	
		<cfelseif isdefined("form.CMCcodigo1") and trim(form.CMCcodigo1) EQ "" and isdefined("form.CMCcodigo2") and trim(form.CMCcodigo2) NEQ "">	
			and a.CMCcodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CMCcodigo2#">
		</cfif>
	order by a.CMCcodigo
</cfquery>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<cfloop query="rsComprador">
			<cfif currentRow NEQ 1>
				<tr class="pageEnd"><td colspan="9" nowrap>&nbsp;</td></tr>
			</cfif>
			<tr><td colspan="9" nowrap>&nbsp;</td></tr>
			<tr><td colspan="9" nowrap align="center"><strong>Datos del Comprador por Rango</strong></td></tr>
			<tr><td colspan="9" nowrap><hr></td></tr>
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
							<td nowrap>&nbsp;</td>
							<td nowrap colspan="5"><strong>Registro de Orden de Compra Manual</strong></td>
						</tr>
						<tr>
							<td nowrap width="5%">&nbsp;</td>
							<td nowrap colspan="5">
								<table width="100%" cellpadding="2" cellspacing="0" border="0">
									<tr valign="baseline">
										<td nowrap width="10%">&nbsp;</td>
										<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;" width="5%">Estado</td>
										<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>Tipo de Orden Compra</strong></td>
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
											<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#checked#&nbsp;</td>
										<cfelse>
											<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;" align="right" width="5%">#rsComprador.CMTSservicio#&nbsp;</td>
										</cfif>
										<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>&nbsp;&nbsp;Servicio</strong></td>
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
							<td nowrap>&nbsp;</td>
							<td nowrap colspan="5"><strong>Especializaci&oacute;n del Comprador</strong></td>
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
										and a.CMCid = #rsComprador.CMCid#
								</cfquery>

								<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
									<cfif rsEspecializacion.RecordCount GT 0>
										<tr valign="baseline">
											<td nowrap width="10%">&nbsp;</td>
											<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;">C&oacute;digo</td>
											<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;" >Descripci&oacute;n</td>
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
												 --- El Comprador no tiene restricci&oacute;n en la especializaci&oacute;n de Compra --- 
											</td>
										</tr>
									</cfif>
								</table>
							</td>
						</tr>
  						<tr><td nowrap colspan="6">&nbsp;</td></tr> 
						<tr>
							<td nowrap>&nbsp;</td>
							<td nowrap colspan="5"><strong>Monto M&aacute;ximo permitido por Compras</strong></td>
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
										and a.CMCid = #rsComprador.CMCid#
								</cfquery>

								<table width="100%" cellpadding="2" cellspacing="0" border="0">
									<tr valign="baseline">
										<td nowrap width="10%">&nbsp;</td>
										<td nowrap width="15%" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black;" align="right">Monto M&aacute;ximo</td>
										<td nowrap class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;"><strong>Tipo de Moneda</strong></td>
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
		</cfloop>
	</cfoutput>
</cfsavecontent>

<cfoutput>
	<cfinclude template="AREA_HEADER.cfm">
	<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
		#encabezado1#
		<tr><td colspan="9" nowrap>&nbsp;</td></tr>
		<tr><td colspan="9" nowrap align="center" class="listaCorte"><strong>--- Fin de la Consulta ---</strong></td></tr>
	</table>
</cfoutput>
