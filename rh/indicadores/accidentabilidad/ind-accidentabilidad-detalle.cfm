<!----Datos para las fórmulas del indicador---->
<cfquery name="rs_datosDetalle" datasource="#session.DSN#">
	select 	periodo,mes,llave,total_trabajadores,total_hrs_capacitacion,total_dias_perdidos,
			cant_accidentes_area1,cant_accidentes_area2,cant_accidentes_area3,
			cant_dperdidos_area1,cant_dperdidos_area2,cant_dperdidos_area3,
			empleados_area1,empleados_area2,empleados_area3,
			hrs_capacitacion_area1,hrs_capacitacion_area2,hrs_capacitacion_area3,
			hrs_trabajadas_area1,hrs_trabajadas_area2,hrs_trabajadas_area3
	from #tbl_principal#
	order by periodo, mes
</cfquery>
<cfquery name="rsArea1" datasource="#session.DSN#">
	select *
	from AreaIndEncabezado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CodArea	='A1'
	order by CodArea	
</cfquery>
<cfquery name="rsArea2" datasource="#session.DSN#">
	select *
	from AreaIndEncabezado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CodArea	='A2'
	order by CodArea	
</cfquery>
<cfquery name="rsArea3" datasource="#session.DSN#">
	select *
	from AreaIndEncabezado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CodArea	='A3'
	order by CodArea	
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
						irA="ind-accidentabilidad.cfm"
						FileName="indAccidentabilidad.xls"					
						title="#LB_IndAccidentabilidad#"
						param="#parametrosr#">
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td align="center"><strong style="font-size:16px; font-variant:small-caps;"><cf_translate key="LB_DetalleDeDatosDelIndicadorDeAccidentabilidad">Detalle de Datos del Indicador de Accidentabilidad</cf_translate></strong></td>			
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
	  <td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" align="center">
				<tr>
					<td colspan="13">
						<table width="100%">
							<cfoutput>
							<tr><td nowrap><strong><cf_translate key="LB_AreaNo1">AreaNo.1</cf_translate></strong>:&nbsp;#rsArea1.CodArea#&nbsp;-&nbsp;#rsArea1.DescArea#</td></tr>							
							<tr><td><strong><cf_translate key="LB_AreaNo2">Area No.2</cf_translate></strong>:&nbsp;#rsArea2.CodArea#&nbsp;-&nbsp;#rsArea2.DescArea#</td></tr>					
							<td><strong><cf_translate key="LB_AreaNo3">Area No.3</cf_translate></strong>:&nbsp;#rsArea3.CodArea#&nbsp;-&nbsp;#rsArea3.DescArea#</td>
							</cfoutput>
						</table>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3" align="center" class="borde" style="border-left:1px solid black; border-top:1px solid black;" bgcolor="#CCCCCC">
						<strong><cf_translate key="LB_Cant.Accidentes">Cant.Accidentes</cf_translate></strong>
					</td>
					<td colspan="3" align="center" class="borde" style="border-top:1px solid black;" bgcolor="#CCCCCC"><strong><cf_translate key="LB_DiasPerdidos">D&iacute;as Perdidos</cf_translate></strong></td> 
					<td colspan="3" align="center" class="borde" style="border-top:1px solid black;" bgcolor="#CCCCCC"><strong><cf_translate key="LB_Empleados">Empleados</cf_translate></strong></td> 
					<td colspan="3" align="center" class="borde" style="border-top:1px solid black;" bgcolor="#CCCCCC"><strong><cf_translate key="LB_HrsCapacitacion">Hrs.Capacitaci&oacute;n</cf_translate></strong></td> 
					<td colspan="3" align="center" class="borde" style="border-top:1px solid black;" bgcolor="#CCCCCC"><strong><cf_translate key="LB_HrsTrabajadas">Hrs.Trabajadas</cf_translate></strong></td> 
				</tr>
				<tr style="background-color:FFFFCC;">
					<td width="8%"><strong><cf_translate key="LB_Mes">Mes</cf_translate></strong></td>
					<td width="5%" align="center" class="borde" style="border-left:1px solid black;"><strong><cf_translate key="LB_AreaNo1">Area <br>No.1</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo2">Area <br>No.2</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo3">Area <br>No.3</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo1">Area <br>No.1</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo2">Area <br>No.2</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo3">Area <br>No.3</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo1">Area <br>No.1</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo2">Area <br>No.2</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo3">Area <br>No.3</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo1">Area <br>No.1</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo2">Area <br>No.2</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo3">Area <br>No.3</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo1">Area <br>No.1</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo2">Area <br>No.2</cf_translate></strong></td>
					<td width="5%" align="center" class="borde"><strong><cf_translate key="LB_AreaNo3">Area <br>No.3</cf_translate></strong></td>
				</tr>
				<cfoutput query="rs_datosDetalle" group="periodo">
					<tr style="background-color:F1F1F1"><td colspan="16" style=" border-bottom:1px solid black;">
						<strong><cf_translate key="LB_Periodo">Periodo</cf_translate>:&nbsp;#periodo#</strong>
					</td></tr>
					<cfoutput>
						<tr>
							<td class="borde" style="border-left:1px solid black;" width="8%">&nbsp;#listgetat(lista_meses, rs_datosDetalle.mes)#</td>
							<td class="borde" width="5%">&nbsp;#LSNumberFormat(cant_accidentes_area1, ',9.00')#</td>
							<td class="borde" width="5%">&nbsp;#LSNumberFormat(cant_accidentes_area2, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(cant_accidentes_area3, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(cant_dperdidos_area1, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(cant_dperdidos_area2, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(cant_dperdidos_area3, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(empleados_area1, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(empleados_area2, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(empleados_area3, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(hrs_capacitacion_area1, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(hrs_capacitacion_area2, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(hrs_capacitacion_area3, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(hrs_trabajadas_area1, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(hrs_trabajadas_area2, ',9.00')#</td>
							<td class="borde" align="center" width="5%">#LSNumberFormat(hrs_trabajadas_area3, ',9.00')#</td>
						</tr>
					</cfoutput>
				</cfoutput>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>