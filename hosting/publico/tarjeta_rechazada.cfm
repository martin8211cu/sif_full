<cfparam name="url.tarjeta">

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Su tarjeta ha sido denegada </cf_templatearea>
<cf_templatearea name="body">
	<cfset navBarItems = ArrayNew(1)>
	<cfset navBarLinks = ArrayNew(1)>
	<cfset navBarStatusText = ArrayNew(1)>
		
	<cfset ArrayAppend(navBarItems,'Donaciones')>
	<cfset ArrayAppend(navBarLinks,'/cfmx/hosting/publico/donacion.cfm')>
	<cfset ArrayAppend(navBarStatusText,'Menú de Donaciones')>
	<cfset Regresar = "/cfmx/hosting/publico/donacion_registro.cfm">
	<cfinclude template="pNavegacion.cfm">

	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	
	<br>

	<cfquery name="rsDatos" datasource="#session.DSN#">
		select 
			MEDtctipo, MEDtcnumero, 
			MEDtcvence, MEDtcnombre, MEDtcdigito, 
			MEDtcdireccion1, MEDtcdireccion2, MEDtcciudad, MEDtcestado, 
			MEDtcpais, MEDtczip
		from MEDTarjetas
		where MEDtcid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tarjeta#">
	</cfquery>	

	<cfoutput>
	<table width="98%" align="center" style="border-top-width:1px; border-top-style:solid; border-top-color:##999999; border-left-width:1px; border-left-style:solid; border-left-color:##999999; border-right-width:1px; border-right-style:solid; border-right-color:##999999; border-bottom-width:1px; border-bottom-style:solid; border-bottom-color:##999999;">
		<tr>
		  <td align="center">
			<b><font size="+1">La transacción ha sido denegada.</font></b><br>
			<b><font color="red">Su donaci&oacute;n no se ha podido procesar debido a que la autorizaci&oacute;n de la tarjeta que nos proporcion&oacute; fue denegada.</font></b>

		</td>
		</tr>
		<tr><td align="center"><b>El detalle del rechazo es el siguiente:</b></td></tr>

		<tr><td align="center">
			<table border="0" width="50%" align="center" cellpadding="3" cellspacing="3" >
				<tr>
					<td align="left"><b>Monto de la donaci&oacute;n </b></td>
					<td nowrap align="right" >#LSNumberFormat(url.monto,',9.00')# #url.moneda#</td>
				</tr>
				
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

			</table>
		</td></tr>

		<tr><td align="center" nowrap><b><font size="1">Muchas gracias por contribuir a nuestro esfuerzo de anunciar la Buena Nueva!!</font></b></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><input type="button" name="regresar" value="Reintentar" onClick="location.href='<cfif isdefined("url.redir")>pago_registro.cfm<cfelse>donacion_registro.cfm</cfif>'"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>

</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
</cf_template>
