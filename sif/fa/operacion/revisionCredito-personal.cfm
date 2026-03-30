<cfquery name="rsPersonal" datasource="#session.DSN#">
	select 	CDid,
			CDnombre||' '||CDapellido1||' '||CDapellido2 as NombreCliente,
			CDidentificacion,
			CDcasa,
			CDcelular,
			CDdireccion1,
			CDsexo,
			CDcivil,
			CDingreso,
			CDtrabajo,
			CDoficina,
			CDfax,
			CDdireccion2,
			CDemail,
			CDlimitecredito,
			CDlimitecredito - CDcreditoutilizado as Disponible	 
	from ClienteDetallista 
	where CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDid#">
</cfquery>

<cfoutput>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" style="background-color:##eee;border:1px solid ##999; padding:4px; border-bottom: 2px solid ##333; border-right: 2px solid ##333">
	<tr>
		<td>
			<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
				<tr>
					<td nowrap align="right"><strong>Cliente:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.NombreCliente#</td>
					<td nowrap align="right"><strong>C&eacute;dula:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDidentificacion#</td>
					<td nowrap align="right"><strong>Ingreso:</strong>&nbsp;</td>
					<td nowrap>#LSCurrencyFormat(rsPersonal.CDingreso,'none')#</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Direcci&oacute;n:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDdireccion1#</td>
					<td nowrap align="right"><strong>Tel&eacute;fono:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDcasa#</td>
					<td nowrap align="right"><strong>Sexo:</strong>&nbsp;</td>
					<td nowrap><cfif rsPersonal.CDsexo EQ 'M'>Masculino<cfelse>Femenino</cfif></td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>E-mail:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDemail#</td>
					<td nowrap align="right"><strong>Celular:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDcelular#</td>
					<td nowrap align="right">&nbsp;</td>
					<td nowrap>&nbsp;</td>
				</tr>
				<tr>
					<td nowrap>&nbsp;</td>
					<td nowrap colspan="5"><font color="##0000CC"><strong>Datos del Centro de Trabajo del Cliente</strong></font></td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Empresa:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDtrabajo#</td>
					<td nowrap align="right"><strong>Tel&eacute;fono:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDoficina#</td>
					<td nowrap align="right"><strong><font size="3">L&iacute;mite de Cr&eacute;dito:</font></strong>&nbsp;</td>
					<td nowrap><strong><font size="3" color="##0000CC">#LSCurrencyFormat(rsPersonal.CDlimitecredito,'none')#</font></strong></td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Direcci&oacute;n:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDdireccion2#</td>
					<td nowrap align="right"><strong>Fax:</strong>&nbsp;</td>
					<td nowrap>#rsPersonal.CDfax#</td>
					<td nowrap align="right"><strong><font size="3">Cr&eacute;dito Disponible:</font></strong>&nbsp;</td>
					<td nowrap><strong><font size="3" color="##0000CC">#LSCurrencyFormat(rsPersonal.Disponible,'none')#</font></strong></td>
				</tr>
			</table>	
		</td>	
	</tr>	
</table>
</cfoutput>

