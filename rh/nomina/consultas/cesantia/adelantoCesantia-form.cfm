<cf_htmlReportsHeaders 
	irA="adelantoCesantia-filtro.cfm"
	FileName="adelantoCesantia_#session.Usucodigo#.xls"
	method="url"
	title="#LB_Titulo#">

<cfquery datasource="#session.DSN#" name="data">
	select 	cl.RHCLid,
			cl.DEid, 
			de.DEidentificacion, 
			de.DEapellido1, 
			de.DEapellido2, 
			de.DEnombre, 
			cl.RHCLfechaliq as fecha, 
			cl.RHCLmontoCesantia as cesantia, 
			cl.RHCLmontoInteres as interes,
			cl.RHCLsalarioPromedio as promedio,
			cl.RHCLcantidadDias as dias

	from RHCesantiaLiquidacion cl, DatosEmpleado de

	where cl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and cl.RHCLaprobada = 1
	  and de.DEid = cl.DEid

	<cfif isdefined("url.desde") and len(trim(url.desde)) and isdefined("url.hasta") and len(trim(url.hasta))>
		and cl.RHCLfechaliq between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	<cfelseif isdefined("url.desde") and len(trim(url.desde))>
		and cl.RHCLfechaliq >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.desde)#">
	<cfelseif isdefined("url.hasta") and len(trim(url.hasta))>
		and cl.RHCLfechaliq <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.hasta)#">
	</cfif>

	 <cfif isdefined("url.DEid") and len(trim(url.DEid)) >
	 	and cl.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	 </cfif>
	
	order by de.DEidentificacion, cl.RHCLfechaliq	
</cfquery>

<table width="95%" align="center" cellpadding="2" cellspacing="0">
	<cfif data.recordcount gt 0>
		<tr bgcolor="#EAEAEA">
			<td style="padding-left:10px;"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
			<td nowrap="nowrap"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Nombre">Nombre</cf_translate></strong></td>
			<td align="center"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Fecha">Fecha</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key="LB_Salario_Promedio">Salario Promedio</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key="LB_Cantidad_de_Dias">Cantidad de d&iacute;as</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key="LB_Cesantia">Cesant&iacute;a</cf_translate></strong></td>
			<td align="right"><strong><cf_translate key="LB_Intereses">Inter&eacute;ses</cf_translate></strong></td>
			<td align="right">&nbsp;</td>			
		</tr>

		<cfoutput query="data" >
			<tr>
				<td valign="top" style="padding-left:10px;">#data.DEidentificacion#</td>
				<td valign="top" nowrap="nowrap">#data.DEapellido1# #data.DEapellido2#, #data.DEnombre#</td>
				<td valign="top"  align="center">#LSDateFormat(data.fecha, 'dd/mm/yyyy')#</td>

				<td valign="top"  align="right">#LSNumberFormat(data.promedio, ',9.00')#</td>
				<td valign="top"  align="right">#LSNumberFormat(data.dias, ',9.00')#</td>

				<td valign="top"  align="right">#LSNumberFormat(data.cesantia, ',9.00')#</td>
				<td valign="top"  align="right">#LSNumberFormat(data.interes, ',9.00')#</td>
				<td valign="top"  align="right">
					<a href="javascript: funcBoleta(#data.RHCLid#)"><img src="/cfmx/rh/imagenes/Description.gif" border="0"></a>
				</td>				
			</tr>
		</cfoutput>	
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="7" align="center">-<cf_translate xmlfile="/rh/generales.xml" key="MGS_FinDelReporte">Fin del reporte</cf_translate> -</td></tr>
	<cfelse>
		<tr><td colspan="7" align="center">---<cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ---</td></tr>		
	</cfif>
</table>
<script type="text/javascript" language="javascript1.2">
	function funcBoleta(prn_llave){
		var params = ''
		var width = 1000;
		var height = 575;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;	
		params = '?RHCLid='+prn_llave;
		var nuevo = window.open('/cfmx/rh/nomina/consultas/cesantia/adelantoCesantia-boleta.cfm'+params,'LiquidacionCesantia','menubar=yes,resizable=yes,scrollbars=yes,top='+top+',left='+left+',height='+height+',width='+width);
	}
</script>