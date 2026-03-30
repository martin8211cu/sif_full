<cf_templatecss>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Adelanto_de_Cesantia" Default="Adelanto de Cesant&iacute;a" returnvariable="LB_Titulo"/>
<cf_htmlReportsHeaders 
	irA="adelantoCesantia-filtro.cfm"
	FileName="adelantoCesantia_#session.Usucodigo#.xls"
	method="url"
	title="#LB_Titulo#">

<cfquery datasource="#session.DSN#" name="data">
	select 	de.DEapellido1, 
			de.DEapellido2, 
			de.DEnombre, 
			de.DEidentificacion, 
			EVfantig as fechaIngreso,			
			d.RHPdescpuesto as puesto,	
			e.CFdescripcion as Departamento,
			cl.RHCLfechaliqAnterior as fechaRige,		
			cl.RHCLfechaliq as fechaCorte,
			<!----((coalesce(<cf_dbfunction name="date_part" args="DD,cl.RHCLfechaliq">,0)) - (coalesce(<cf_dbfunction name="date_part" args="DD,cl.RHCLfechaliqAnterior">,0)))as Dias,
			((coalesce(<cf_dbfunction name="date_part" args="MM,cl.RHCLfechaliq">,0)) - (coalesce(<cf_dbfunction name="date_part" args="MM,cl.RHCLfechaliqAnterior">,0))) as Meses,
			((coalesce(<cf_dbfunction name="date_part" args="YY,cl.RHCLfechaliq">,0)) - (coalesce(<cf_dbfunction name="date_part" args="YY,cl.RHCLfechaliqAnterior">,0))) as Annos,---->
			coalesce(cl.RHCLsalarioPromedio,0) as importe,
			coalesce(cl.RHCLcantidadDias,0) as cantidad, 
			coalesce(cl.RHCLmontoCesantia,0) as total,
			coalesce(cl.RHCLmontoInteres,0) as intereses,
			(coalesce(cl.RHCLmontoCesantia,0)+coalesce(cl.RHCLmontoInteres,0)) as TotalPagar,
			cl.RHCLid
	from RHCesantiaLiquidacion cl
		inner join DatosEmpleado de
			on de.DEid = cl.DEid
		inner join EVacacionesEmpleado a
			on cl.DEid = a.DEid
		inner join LineaTiempo b
			on cl.DEid = b.DEid
			and RHCLfechaliq between b.LTdesde and b.LThasta
		inner join RHPlazas c
			on b.RHPid = c.RHPid	
			and b.Ecodigo = c.Ecodigo
		inner join RHPuestos d
			on c.RHPpuesto = d.RHPcodigo
			and c.Ecodigo = d.Ecodigo
		inner join CFuncional e
			on c.CFid = e.CFid
	where cl.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and cl.RHCLaprobada = 1
	<cfif isdefined("url.RHCLid") and len(trim(url.RHCLid))>
		and cl.RHCLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCLid#">
	</cfif>
</cfquery>
<cfset Annos = 0>
<cfset Meses = 0>
<cfset Dias = 0>
<cfif len(trim(data.fechaRige)) and len(trim(data.fechaCorte))>
	<cfset Annos = DateDiff('yyyy', data.fechaRige, data.fechaCorte)>
	<cfset Meses = DateDiff('m', DateAdd('yyyy', Annos, data.fechaRige), data.fechaCorte)>
	<cfset Dias = DateDiff('d', DateAdd('m', Meses, DateAdd('yyyy', Annos, data.fechaRige)), data.fechaCorte)>
</cfif>
<cfoutput>
<table width="95%" align="center" cellpadding="2" cellspacing="0" border="0">
	<cfif data.recordcount gt 0>
		<tr>
			<td colspan="2" align="center"><strong style="font-size:20px;">#session.Enombre#</strong></td>
		</tr>
		<tr>
			<td colspan="2" align="center"><strong style="font-size:15px;"><cf_translate key="LB_AdelantoDeCesantia">Adelanto de Cesantia</cf_translate></strong></td>
		</tr>
		<tr>
			<td align="right" colspan="2">#LSDateFormat(now(),'dd/mm/yyyy')#</td>
		</tr>
		<!---Datos empleado--->
		<tr>
			<td width="23%" nowrap="nowrap"><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Nombre">Nombre</cf_translate>:&nbsp;</strong></td>
			<td width="77%">#data.DEnombre#&nbsp;#data.DEapellido1#&nbsp;#data.DEapellido2#&nbsp;</td>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:&nbsp;</strong></td>
			<td>#data.DEidentificacion#</td>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate key="LB_FechaDeIngreso">Fecha de Ingreso</cf_translate>:&nbsp;</strong></td>
			<td>#LSDateFormat(data.fechaIngreso,'dd/mm/yyyy')#</td>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</strong></td>
			<td>#data.puesto#</td>
		</tr>
		<tr>
			<td nowrap><strong><cf_translate key="LB_Departamento">Departamento</cf_translate>:&nbsp;</strong></td>
			<td>#data.Departamento#</td>
		</tr>
		<!---Fechas calculo--->
		<tr>
			<td valign="top"><strong><cf_translate key="LB_FechaDeCalculo">Fecha de C&aacute;lculo</cf_translate>:&nbsp;</strong></td>
			<td>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="11%" nowrap><strong><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate>:&nbsp;</strong></td>
						<td width="89%">#LSDateFormat(data.fechaRige,'dd/mm/yyyy')#</td>
					</tr>
					<tr>
						<td nowrap><strong><cf_translate key="LB_FechaCorte">Fecha Corte</cf_translate>:&nbsp;</strong></td>
						<td>#LSDateFormat(data.fechaCorte,'dd/mm/yyyy')#</td>
					</tr>
				</table>
			</td>
		</tr>		
		<!---Antiguedad---->
		<tr>
			<td valign="top"><strong><cf_translate key="LB_Antiguedad">Antig&uuml;edad</cf_translate>:&nbsp;</strong></td>
			<td>
				<table width="40%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="30%"><strong><cf_translate key="LB_Annos">Años</cf_translate>&nbsp;</strong></td>
						<td width="35%"><strong><cf_translate key="LB_Meses">Meses</cf_translate>&nbsp;</strong></td>
						<td width="35%"><strong><cf_translate key="LB_Dias">D&iacute;as</cf_translate>&nbsp;</strong></td>
					</tr>
					<tr>
						<td width="30%">#Annos#</td>
						<td width="35%">#Meses#</td>
						<td width="35%">#Dias#</td>
					</tr>
			  </table>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<!---Detalle del pago--->
		<tr>
			<td><strong><cf_translate key="LB_DetalleDePago">Detalle de Pago</cf_translate>&nbsp;</strong></td>
			<td>
				<table width="79%" height="20" cellpadding="0" cellspacing="0">
					<tr>
						<td width="36%" align="right" style=" border-bottom:1px solid black;"><cf_translate key="LB_Importe">Importe</cf_translate></td>
						<td width="26%" align="right" style=" border-bottom:1px solid black;"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
						<td width="38%" align="right" style=" border-bottom:1px solid black;"><cf_translate key="LB_Total">Total</cf_translate></td>
					</tr>
			  </table>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong><cf_translate key="LB_AdelantoDeCesantia">Adelanto de Cesant&iacute;a</cf_translate></strong></td>
			<td>
				<table width="79%" cellpadding="0" cellspacing="0">	
					<tr>
						<td align="right" width="36%">#LSNumberFormat(data.importe, ',9.00')#</td>
						<td align="right" width="26%">#LSNumberFormat(data.cantidad, ',9.00')#</td>
						<td align="right" width="38%">#LSNumberFormat(data.total, ',9.00')#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cf_translate key="LB_Intereses">Intereses</cf_translate></strong></td>
			<td>
				<table width="79%" cellpadding="0" cellspacing="0">	
					<tr>
						<td align="right" width="36%">&nbsp;</td>
						<td align="right" width="26%">&nbsp;</td>
						<td align="right" width="38%">#LSNumberFormat(data.intereses, ',9.00')#</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong><cf_translate key="LB_TotalAPagar">Total a Pagar</cf_translate></strong></td>
			<td>
				<table width="79%" cellpadding="0" cellspacing="0">	
					<tr>
						<td align="right" width="36%" style="border-top:1px solid black;">&nbsp;</td>
						<td align="right" width="64%" style="border-top:1px solid black;">#LSNumberFormat(data.TotalPagar, ',9.00')#</td>
					</tr>
				</table>
			</td>
		</tr>
	<cfelse>
		<tr><td colspan="5" align="center">---<cf_translate xmlfile="/rh/generales.xml" key="MSG_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ---</td></tr>		
	</cfif>
</table>
</cfoutput>
<script type="text/javascript" language="javascript1.2">
	function funcBoleta(prn_llave){
		var params = ''
		var width = 800;
		var height = 575;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;		
		var nuevo = window.open('/cfmx/rh/indicadores/accidentabilidad/ind-accidentabilidad.cfm'+params,'GraficoAccidentabilidad','menubar=yes,resizable=yes,scrollbars=yes,top='+top+',left='+left+',height='+height+',width='+width);
	}
</script>