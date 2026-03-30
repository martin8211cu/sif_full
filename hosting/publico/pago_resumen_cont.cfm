<cfif isdefined("url.MEDdonacion")>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 
			MEDproyecto, MEDfecha, MEDmoneda, MEpersona,
			MEDimporte, MEDforma_pago, MEDtctipo, MEDtcnumero, 
			MEDtcvence, MEDdescripcion, MEDtcnombre, MEDtcdigito, 
			MEDtcdireccion1, MEDtcdireccion2, MEDtcciudad, MEDtcestado, 
			MEDtcpais, MEDtczip, coalesce (MEDaut_num, 'No disponible') as MEDaut_num
		from MEDDonacion
		where MEDdonacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.MEDdonacion#">
	</cfquery>
	
	<cfset entidad = "">	
	<cfif len(trim(rsDatos.MEpersona)) gt 0 >
		<cfquery name="rsEntidad" datasource="#session.DSN#">
			select * from MEPersona
			where MEpersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.MEpersona#">
		</cfquery>
		<cfset entidad = rsEntidad.Pnombre >
	</cfif>
	
	<cfoutput>
	<table width="98%" align="center" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">
		<tr><td align="center">
			<b><font size="2">La transacción ha sido completada con éxito.</font></b><br>
			<cfif len(trim(rsDatos.MEpersona)) gt 0>
				<b>Hemos recibido el siguiente pago a nombre de #entidad#.</b>
			<cfelse>	
				<br><b>Su donacion ha sido registrada de manera an&oacute;nima.</b><br>
			</cfif>
		</td></tr>
		<tr><td align="center"><b>El detalle del Pago es el siguiente:</b></td></tr>

		<tr><td align="center">
			<table border="0" width="50%" align="center" cellpadding="3" cellspacing="3" >
				<tr>
					<td align="left"><b><cfif rsDatos.MEDforma_pago neq 'S'>Monto<cfelse>Cantidad</cfif></b></td>
					<td nowrap align="right" >#LSNumberFormat(rsDatos.MEDimporte,',9.00')# #rsDatos.MEDmoneda#</td>
				</tr>
				
				<cfif rsDatos.MEDforma_pago eq 'T' >
					<tr>
						<td nowrap align="left"><b>Forma de Pago</b></td>
						<td nowrap align="right">Tarjeta</td>
					</tr>

					<tr>
						<td align="left"><b>No. Tarjeta</b> </td>	
						<td nowrap align="right">
							
								<cfif trim(rsDatos.MEDtcnumero GT 4)>
									#repeatstring('X', max(8,len(trim(rsDatos.MEDtcnumero))-4))##right(trim(rsDatos.MEDtcnumero), 4)#
								<cfelse>
									#trim(rsDatos.MEDtcnumero)#
								</cfif>
						</td>
					</tr>
					
					<tr>
						<td nowrap align="left"><b>Nombre como aparece en la Tarjeta</b></td>
						<td nowrap align="right">
							#rsDatos.MEDtcnombre#
						</td>
					</tr>

					<tr>
						<td align="left"><b>Vencimiento</b></td>
						<td nowrap align="right">
							#rsDatos.MEDtcvence#
						</td>
					</tr>
					<tr>
						<td nowrap align="left"><b>Dígito Verificador</b></td>
						<td align="right" nowrap>
							#rsDatos.MEDtcdigito#
						</td>
					</tr>

					<tr>
						<td nowrap align="left"><strong>N&uacute;mero de autorizaci&oacute;n</strong> </td>
						<td align="right" nowrap>#rsDatos.MEDaut_num#</td>
					</tr>
					<tr>
						<td nowrap align="left"><b>Direcci&oacute;n 1</b></td>
						<td align="right" nowrap>
							#rsDatos.MEDtcdireccion1#
						</td>
					</tr>
					
					<tr>
						<td nowrap align="left"><b>Direcci&oacute;n 2</b></td>
						<td align="right" nowrap>
							#rsDatos.MEDtcdireccion2#
						</td>
					</tr>

					<tr>
						<td nowrap align="left"><b>Ciudad</b></td>
						<td align="right" nowrap>
							#rsDatos.MEDtcciudad#
						</td>
					</tr>
					
					<tr>
						<td nowrap align="left"><b>Estado</b></td>
						<td align="right" nowrap>
							<cfif len(trim(rsDatos.MEDtcestado)) gt 0>#rsDatos.MEDtcestado#<cfelse>-</cfif>
						</td>
					</tr>
					
					<tr>
						<td nowrap align="left"><b>Código Postal</b></td>
						<td align="right" nowrap>
							<cfif len(trim(rsDatos.MEDtczip)) gt 0>#rsDatos.MEDtczip#</cfif>
						</td>
					</tr>
					
				</cfif>

			</table>
		</td></tr>

		<tr><td align="center" nowrap><b><font size="1">Muchas gracias por contribuir a nuestro esfuerzo de anunciar la Buena Nueva!!</font></b></td></tr>
		<tr><td>&nbsp;</td></tr>
		<cfif not isdefined("info")>
		<tr><td align="center"><input type="button" name="regresar" value="Regresar" onClick="location.href='/'"></td></tr>
		<tr><td>&nbsp;</td></tr>
		</cfif>
	</table>
	</cfoutput>

</cfif>