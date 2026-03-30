<!---================ VARIABLES DE TRADUCCION ================---->
<cfinvoke Key="LB_IndicadoresCapacitacion" Default="Indicador de Capacitaci&oacute;n" returnvariable="LB_IndCapacitacion" component="sif.Componentes.Translate" method="Translate"/>
<!---================================================---->
<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datosDetalle" datasource="#session.DSN#">
	select 	periodo, mes, llave, total_empleados, 
			total_horas_programadas, total_horas_reales, 
			total_gasto_capacitacion,total_emp_capacitados
	from #tbl_principal#
	order by periodo, mes
</cfquery>
<style>
	.borde{
		border-right:1px solid black;
		border-bottom:1px solid black;
	}
</style>
<cfset parametros = "?Detalle=1">
<cfset parametrosr = "">
<cfif isdefined("url.CFid") and len(trim(url.CFid))>
	<cfset parametros= parametros & "&CFid=#url.CFid#"> 
	<cfset parametrosr= parametrosr & "&CFid=#url.CFid#"> 
</cfif>
<cfif isdefined("url.dependencias")>
	<cfset parametros= parametros & "&dependencias=#url.dependencias#"> 
	<cfset parametrosr= parametrosr & "&dependencias=#url.dependencias#"> 
</cfif>
<cfquery name="rs_idiomas" datasource="#session.DSN#">
	select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
	from Idiomas a
		inner join VSidioma b
		on b.Iid = a.Iid
		and b.VSgrupo = 1
	where Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.idioma#">
	order by <cf_dbfunction name="to_number" args="b.VSvalor">			
</cfquery>
<cfset lista_meses = valuelist(rs_idiomas.m) >
<cfif listlen(lista_meses) neq 12 >
	<cfset lista_meses = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre' >
</cfif>
<table width="90%" cellpadding="0" cellspacing="0" border="0" align="center">		
	<tr>
		<td>
			<cfoutput>
				<cf_htmlReportsHeaders 
						irA="ind-capacitacion.cfm"
						FileName="tasaRotacion.xls"					
						title="#LB_IndCapacitacion#"
						param="#parametrosr#">
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td align="center"><strong style="font-size:16px; font-variant:small-caps;"><cf_translate key="LB_DetalleDeDatosDelIndicadorDeCapacitacion">Detalle de Datos del Indicador de Capacitaci&oacute;n</cf_translate></strong></td>			
	</tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr style="background-color:FFFFCC;">
					<td width="10%"><strong><cf_translate key="LB_Mes">Mes</cf_translate></strong></td>
					<td width="11%"><strong><cf_translate key="LB_CantEmpleados">Cant.Empleados</cf_translate></strong></td>
					<td width="16%" align="center"><strong><cf_translate key="LB_EmpleadosCapacitados">Empleados Capacitados</cf_translate></strong></td>
					<td width="17%" align="center"><strong><cf_translate key="LB_HorasReales">Horas Reales</cf_translate></strong></td>
					<td width="15%" align="center"><strong><cf_translate key="LB_HorasProgramadas">Horas Programadas</cf_translate></strong></td>
					<td width="31%" align="right"><strong><cf_translate key="LB_GastoDeCapacitacion">Gasto de la Capacitaci&oacute;n</cf_translate></strong></td>
				</tr>
				<cfoutput query="rs_datosDetalle" group="periodo">
					<tr style="background-color:F1F1F1"><td colspan="6" style=" border-bottom:1px solid black;">
						<strong><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;#periodo#</strong>
					</td></tr>
					<cfoutput>
						<tr>
							<td class="borde" style="border-left:1px solid black;">&nbsp;#listgetat(lista_meses, rs_datosDetalle.mes)#</td>
							<td class="borde">&nbsp;#LSNumberFormat(total_empleados, ',9.00')#</td>
							<td class="borde">&nbsp;#LSNumberFormat(total_emp_capacitados, ',9.00')#</td>
							<td class="borde" align="center">#LSNumberFormat(total_horas_reales, ',9.00')#</td>
							<td class="borde" align="center">#LSNumberFormat(total_horas_programadas, ',9.00')#</td>
							<td align="right" class="borde">#LSNumberFormat(total_gasto_capacitacion, ',9.00')#</td>
						</tr>
					</cfoutput>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>