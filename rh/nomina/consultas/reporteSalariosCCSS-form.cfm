<cfsetting requesttimeout="36000">

<cfif isdefined("url.mes") and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("url.periodo") and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("url.GrupoPlanilla") and not isdefined("form.GrupoPlanilla")>
	<cfset form.GrupoPlanilla = url.GrupoPlanilla >
</cfif>
<cfif isdefined("url.masivo") and not isdefined("form.masivo")>
	<cfset form.masivo = url.masivo >
</cfif>

<cfset meses = ''>

<cfif form.mes EQ 1 >
	<cfset meses = 'Enero'>
<cfelseif form.mes EQ 2 >
	<cfset meses = 'Febrero'>
<cfelseif form.mes EQ 3 >
	<cfset meses = 'Marzo'>
<cfelseif form.mes EQ 4 >
	<cfset meses = 'Abril'>
<cfelseif form.mes EQ 5 >
	<cfset meses = 'Mayo'>
<cfelseif form.mes EQ 6 >
	<cfset meses = 'Junio'>
<cfelseif form.mes EQ 7 >
	<cfset meses = 'Julio'>
<cfelseif form.mes EQ 8 >
	<cfset meses = 'Agosto'>
<cfelseif form.mes EQ 9 >
	<cfset meses = 'Septiembre'>
<cfelseif form.mes EQ 10 >
	<cfset meses = 'Octubre'>
<cfelseif form.mes EQ 11 >
	<cfset meses = 'Noviembre'>
<cfelseif form.mes EQ 12 >
	<cfset meses = 'Diciembre'>
</cfif>

<!---
<cfquery name="data" datasource="#Session.DSN#">
	set nocount on
	exec rh_ReporteCCSS_GC1 
	  @periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	, @mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	, @Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	, @masivo = <cfif form.masivo>1<cfelse>0</cfif>
	<cfif len(trim(form.GrupoPlanilla))>
		, @GrupoPlanillas = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.GrupoPlanilla#">
	<cfelse>
		, @GrupoPlanillas = null
	</cfif>
	set nocount off
</cfquery>
--->

<cfinvoke component="rh.Componentes.RH_ReporteCCSS_GC1" method="rh_ReporteCCSS_GC1" returnvariable="data">
	<cfinvokeargument name="periodo" value="#form.periodo#">
	<cfinvokeargument name="mes" value="#form.mes#">
	<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
	<cfif form.masivo >
		<cfinvokeargument name="masivo" value="1">
	<cfelse>
		<cfinvokeargument name="masivo" value="0">
	</cfif>
	<cfif len(trim(form.GrupoPlanilla))>
		<cfinvokeargument name="GrupoPlanillas" value="#form.GrupoPlanilla#">
	</cfif>
</cfinvoke>

<cfset LvarFileName = "ReporteSalarioCCSS#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfif isdefined("form.nube")> 
    <cf_htmlReportsHeaders 
        title="Reporte Salario CCSS" 
        filename="#LvarFileName#"
        irA="/cfmx/rh/Cloud/Reportes/reporteSalariosCCSS-Filtro.cfm" 
        >
<cfelse>
    <cf_htmlReportsHeaders 
        title="Reporte Salario CCSS" 
        filename="#LvarFileName#"
        irA="reporteSalariosCCSS-Filtro.cfm" 
        >
</cfif>
    
    
<cfif not isdefined("form.btnDownload")>
    <cf_templatecss>
</cfif>	

<cfinvoke key="LB_ReporteDelDetalleDeSalarios" default="Reporte del Detalle de Salarios" returnvariable="LB_ReporteDelDetalleDeSalarios" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Periodo" default="<b>Per&iacute;odo</b>" returnvariable="LB_Periodo" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Mes" default="<b>Mes</b>" returnvariable="LB_Mes" component="sif.Componentes.Translate"  method="Translate"/>

<cfif data.recordCount GT 0 >
	<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td>
				<cfset filtro1 = LB_Periodo&':#form.periodo#  #LB_Mes#:#meses#'>
				<cf_EncReporte
					Titulo="#LB_ReporteDelDetalleDeSalarios#"
					Color="##E3EDEF"
					filtro1="#filtro1#"
				>
			</td>
		</tr>
	</table>
	<!----==================== REPORTE ANTERIOR ====================
	<table width="99%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr><td colspan="3" align="center" ><strong><font size="3">#Session.Enombre#</font></strong></td></tr>
		<tr><td nowrap colspan="3">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><strong><font size="3"><cf_translate  key="LB_ReporteDelDetalleDeSalarios">Reporte del Detalle de Salarios</cf_translate></font></strong></td></tr>
		<tr><td colspan="3" align="center"><font size="2"><strong><cf_translate  key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong>#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;<strong><cf_translate  key="LB_Hora">Hora</cf_translate>:&nbsp;</strong>#TimeFormat(now(),'medium')#</font></td></tr>
		<tr><td colspan="3" align="center"><font size="2"><strong><cf_translate  key="LB_Periodo">Per&iacute;odo</cf_translate>:&nbsp;</strong>#form.periodo#&nbsp;<strong> <cf_translate  key="LB_Mes">Mes</cf_translate>:&nbsp;</strong>#meses#</font></td></tr>
	</table>
	----->
	</cfoutput>

	<cfif isdefined("form.masivo") and form.masivo eq 0 >
		<table width="99%" cellpadding="4" cellspacing="0" align="center">
			<cfoutput query="data" group="numpat" >
				<cfset total_actual = 0 >
				<cfset total_anterior = 0 >
				<cfset total_concambios = 0 >
				<cfset total_sincambios = 0 >
				<cfset total_empleados = 0 >
				<cfset total_empleadosconcambio = 0 >
				<cfset total_empleadossincambio = 0 >
				<tr>
					<td bgcolor="##CCCCCC" colspan="5" style="mso-number-format:'\@';"><strong><cf_translate  key="LB_NumeroOrdenPatronal">N&uacute;mero Orden Patronal</cf_translate>: #data.numpat#</strong></td>
				</tr>
				<tr>
					<td class="tituloListas" ><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
					<td class="tituloListas" ><cf_translate  key="LB_Identificacion">Nombre</cf_translate></td>
					<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_SalarioActual">Salario Actual</cf_translate></td>
					<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_SalarioAnterior">Salario Anterior</cf_translate></td>
					<td class="tituloListas" align="center" nowrap ><cf_translate  key="LB_IndicadorDeCambio">Indicador de Cambio</cf_translate></td>
				</tr>
				<cfoutput>
					<cfset total_actual = total_actual + data.actual >
					<cfset total_anterior = total_anterior + data.anterior >
					<cfset total_empleados = total_empleados + 1 >
					
					<cfif trim(data.mensaje) eq 'CON CAMBIO REPORTADO'>
						<cfset total_concambios = total_concambios + data.actual >
						<cfset total_empleadosconcambio = total_empleadosconcambio + 1 >
					<cfelse>
						<cfset total_sincambios = total_sincambios + data.actual >
						<cfset total_empleadossincambio = total_empleadossincambio + 1 >
					</cfif>
					
	
					<tr style="border-bottom:1px solid black; ">
						<td style="border-bottom:1px solid black; ">#data.cedula#</td>
						<td style="border-bottom:1px solid black; ">#data.nombre#</td>
						<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.actual,',9.00')#</td>
						<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.anterior,',9.00')#</td>
						<td style="border-bottom:1px solid black; " align="center" nowrap >#data.mensaje#</td>
					</tr>
				</cfoutput>
					<tr>
						<td><strong><cf_translate  key="LB_Total">Total</cf_translate>:</strong></td>
						<td></td>
						<td align="right"><strong>#LSNumberFormat(total_actual,',9.00')#</strong></td>
						<td align="right"><strong>#LSNumberFormat(total_anterior,',9.00')#</strong></td>
						<td></td>
					</tr>
	
					<tr>
						<td colspan="5">
							<table width="40%" cellpadding="3" cellspacing="0">
								<tr>
									<td nowrap><strong><cf_translate  key="LB_TotalEmpleados">Total empleados</cf_translate>:</strong></td>
									<td align="right" nowrap><strong>#LSNumberFormat(total_empleados,',9')#</strong></td>
								</tr>		
								<tr>
									<td nowrap><strong><cf_translate  key="LB_TotalEmpleadosConCambio">Total empleados con cambio</cf_translate>:</strong></td>
									<td align="right" nowrap><strong>#LSNumberFormat(total_empleadosconcambio,',9')#</strong></td>
								</tr>		
								<tr>
									<td nowrap><strong><cf_translate  key="LB_TotalDeSalariosConCambio">Total de Salarios con cambio</cf_translate>:</strong></td>
									<td align="right" nowrap><strong>#LSNumberFormat(total_concambios,',9.00')#</strong></td>
								</tr>		
								<tr>
									<td nowrap><strong><cf_translate  key="LB_TotalEmpleadosSinCambio">Total empleados sin cambio</cf_translate>:</strong></td>
									<td align="right" nowrap><strong>#LSNumberFormat(total_empleadossincambio,',9')#</strong></td>
								</tr>		
								<tr>
									<td nowrap><strong><cf_translate  key="LB_TotalEmpleadosSinCambio">TotalDeSalariosSinCambio</cf_translate>:</strong></td>
									<td align="right" nowrap><strong>#LSNumberFormat(total_sincambios,',9.00')#</strong></td>
								</tr>		
							</table>		
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="5" align="center">-- <cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate>--</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cfelse>
		<table width="99%" cellpadding="4" cellspacing="0" align="center">
			<tr>
				<td class="tituloListas" ><cf_translate  key="LB_NumeroPatronal">N&uacute;mero Patronal</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_MontoPatActual">Monto<br>Pat. Actual</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_MontoPatAnterior">Monto<br> Pat. Anterior</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_TotalConCambios">Total<br> con Cambios</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_TotalSinCambios">Total<br> sin Cambios</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_EmpleadosConCambios">Empleados<br> con cambios</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_EmpleadosSinCambios">Empleados<br> sin cambios</cf_translate></td>
				<td class="tituloListas" align="right" nowrap ><cf_translate  key="LB_TotalEmpleados">Total<br> empleados</cf_translate></td>
			</tr>
			<cfoutput query="data" >
				<tr style="border-bottom:1px solid black;">
					<td  style="mso-number-format:'\@';	border-bottom:1px solid black;" >#data.patron#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.patact,',9.00')#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.patant,',9.00')#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.totcamb,',9.00')#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.totscamb,',9.00')#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.totempcam,',9')#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.totempncam,',9')#</td>
					<td style="border-bottom:1px solid black; " align="right" nowrap >#LSNumberFormat(data.totemp,',9')#</td>
				</tr>
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="8" align="center">-- <cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate>--</td></tr>
			<tr><td>&nbsp;</td></tr>

		</table>
	</cfif>
<cfelse>
	<cfoutput>
	<table width="99%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr>
			<td>
				<cfset filtro1 = LB_Periodo&':#form.periodo#  #LB_Mes#:#meses#'>
				<cf_EncReporte
					Titulo="#LB_ReporteDelDetalleDeSalarios#"
					Color="##E3EDEF"
					filtro1="#filtro1#"
				>
			</td>
		</tr>
	</table>
	<!----==================== REPORTE ANTERIOR ====================
	<table width="99%" align="center" border="0" cellspacing="2" cellpadding="0">
		<tr><td colspan="3" align="center" ><strong><font size="3">#Session.Enombre#</font></strong></td></tr>
		<tr><td nowrap colspan="3">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><strong><font size="3"><cf_translate  key="LB_ReporteDelDetalleDeSalarios">Reporte del Detalle de Salarios</cf_translate></font></strong></td></tr>
		<tr><td colspan="3" align="center"><font size="2"><strong><cf_translate  key="LB_Fecha">Fecha</cf_translate>:&nbsp;</strong>#LSDateFormat(now(),'dd/mm/yyyy')#&nbsp;<strong><cf_translate  key="LB_Hora">Hora</cf_translate>:&nbsp;</strong>#TimeFormat(now(),'medium')#</font></td></tr>
		<tr><td colspan="3" align="center"><font size="2"><strong><cf_translate  key="LB_Periodo">Per&iacute;odo</cf_translate>:&nbsp;</strong>#form.periodo#&nbsp;<strong><cf_translate  key="LB_Mes">Mes</cf_translate>:&nbsp;</strong>#meses#</font></td></tr>
	</table>
	---->
	</cfoutput>

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="3" align="center" >
				<strong>-- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> --</strong>
			</td>
		</tr>
		<tr><td colspan="3" align="center" >&nbsp;</td></tr>
	</table>
</cfif>
