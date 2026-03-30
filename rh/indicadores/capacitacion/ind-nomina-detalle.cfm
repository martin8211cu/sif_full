<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datosDetalle" datasource="#session.DSN#">
	select 	periodo, mes, llave, 
			total_hrs_extra, total_hrs_efectivas, 
			total_salarios,total_empleados
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
						irA="ind-nomina.cfm"
						FileName="indNomina.xls"					
						title="#LB_IndNomina#"
						param="#parametrosr#">
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td align="center"><strong style="font-size:16px; font-variant:small-caps;"><cf_translate key="LB_DetalleDeDatosDelIndicadorDeNomina">Detalle de Datos del Indicador de N&oacute;mina</cf_translate></strong></td>			
	</tr>
	<tr>
		<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr style="background-color:FFFFCC;">
					<td width="13%"><strong><cf_translate key="LB_Mes">Mes</cf_translate></strong></td>
					<td width="14%"><strong><cf_translate key="LB_CantHorasExtra">Cant.Horas Extra</cf_translate></strong></td>
					<td width="17%" align="center"><strong><cf_translate key="LB_HrsEfectivas">Cant.Horas Efectivas</cf_translate></strong></td>
					<td width="44%" align="right"><strong><cf_translate key="LB_MontoSalarios">Mto. Salarios</cf_translate></strong></td>
					<td width="12%" align="center"><strong><cf_translate key="LB_Cant.Empleados">Cant.Empleados</cf_translate></strong></td>
				</tr>
				<cfoutput query="rs_datosDetalle" group="periodo">
					<tr style="background-color:F1F1F1"><td colspan="6" style=" border-bottom:1px solid black;">
						<strong><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;#periodo#</strong>
					</td></tr>
					<cfoutput>
						<tr>
							<td class="borde" style="border-left:1px solid black;">&nbsp;#listgetat(lista_meses, rs_datosDetalle.mes)#</td>
							<td class="borde">&nbsp;#LSNumberFormat(total_hrs_extra, ',9.00')#</td>
							<td class="borde">&nbsp;#LSNumberFormat(total_hrs_efectivas, ',9.00')#</td>
							<td class="borde" align="right">#LSNumberFormat(total_salarios, ',9.00')#</td>
							<td class="borde" align="center">#LSNumberFormat(total_empleados, ',9.00')#</td>
						</tr>
					</cfoutput>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>