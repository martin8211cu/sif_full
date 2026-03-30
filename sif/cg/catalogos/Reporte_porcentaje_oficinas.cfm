<!---<cf_templatecss>
<cf_htmlReportsHeaders 
	irA="inconsistencias.cfm"
	FileName="Inconsistencias.xls"
	title="Reporte de Inconsistencias">--->

<cf_templatecss>
<cfquery name="rsSQL" datasource="#session.dsn#">
	select * from OficinasxClasificacion where Ocodigo=#url.Ocodigo# and PCCDclaid=#url.PCCDclaid#
</cfquery>
<cfquery name="rsclaid" datasource="#session.dsn#">
	select  PCCDdescripcion  from  PCClasificacionD where PCCDclaid=#PCCDclaid#
</cfquery>
<cfquery name="rsclaidE" datasource="#session.dsn#">
	select  PCCEdescripcion  from  PCClasificacionE where PCCEclaid=#PCCEclaid#
</cfquery>
<cfquery name="rsofi" datasource="#session.dsn#">
	select  Odescripcion from  Oficinas where Ocodigo=#url.Ocodigo#
</cfquery>
<cfquery name="rsemp" datasource="#session.dsn#">
	select  Edescripcion from  Empresas where Ecodigo=#session.ecodigo#
</cfquery>
<cfoutput>
<cf_web_portlet_start border="true" titulo="Reporte Detallado de Porcentaje de Oficina" skin="info1">
<table width="100%" cellpadding="1" cellspacing="1" border="0" id="tablabotones">
		<tr >
		<td align="center"><strong>#rsemp.Edescripcion#</strong></td>
	</tr>
	<tr>
		<td align="center"><strong>Fecha:&nbsp;</strong>#LSDateFormat(Now(),"DD/MM/YYYY")#</td>
	</tr>
	<tr>
		<td align="center"><strong>Clasificaci&oacute;n:&nbsp;</strong>#rsclaidE.PCCEdescripcion#</td>
	</tr>
	<tr>
		<td align="center"><strong>Detalle Clasif:&nbsp;</strong>#rsclaid.PCCDdescripcion#</td>
	</tr>
	<tr>
		<td align="center"><strong>Oficina:&nbsp;</strong>#rsofi.Odescripcion#</td>
	</tr>
	<tr>
		<td align="center"><strong>Descripci&oacute;n del Porcentaje por Oficina</strong></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<cfif rsSQL.recordcount eq 0>
		<tr><td align="center">
				<font color="990033"><strong>--No se gereraron resultados--</strong></font>
		</td></tr>
	<cfelse>
		<tr>
			<table width="100%" border="1" cellpadding="0" cellspacing="0">
				<tr bgcolor="CCCCCC" align="center">
					<td><strong>Peri&oacute;do</strong></td>
					<td><strong>Mes</strong></td>
					<td><strong>Porcentaje</strong></td>
				</tr>
				<cfloop query="rsSQL">
					<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="center">				
							<td>#rsSQL.CGCperiodo#</td>
							<td>#rsSQL.CGCmes#</td>
							<td>#rsSQL.CGCporcentaje#%</td>				
					</tr>
				</cfloop>
			</table>	
			<tr>
					<td colspan="6" align="center">
						****Fin de Linea****
					</td>
				</tr>
		</tr>
	</cfif>
	</table>
	<cf_web_portlet_end>	
</cfoutput>

