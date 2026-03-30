<cffunction name="presupuesto" returntype="numeric">
	<cfargument name="PRJAid" required="yes" type="numeric">
	<cfargument name="PRJid" required="yes" type="numeric">

	<cfquery name="rs" datasource="#session.DSN#">
		select sum(PRJPRcostoUnitModificado*PRJARcantidadModificada) as ppto
		from PRJActividadRecurso a, PRJProyectoRecurso c
		where a.PRJAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJAid#">
		and a.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
		and a.PRJid=c.PRJid
		and a.PRJRid=c.PRJRid
	</cfquery>
	<cfset monto = 0>
	<cfif rs.RecordCount gt 0 and len(trim(rs.ppto))>
		<cfset monto = rs.ppto>
	</cfif>
	<cfreturn monto>
</cffunction>

<cfquery name="data" datasource="#session.DSN#">
	select 	b.PRJid,
			PRJcodigo, 
			PRJdescripcion, 
			PRJAid, 
			PRJAcodigo, 
			PRJAdescripcion,
			PRJAporcentajeAvance as avance, 
			PRJAcostoActual as gastado, 
			case when PRJAcostoActual = 0 or PRJAporcentajeAvance = 0 then 0 else PRJAcostoActual*100/PRJAporcentajeAvance end as proyectado
	from PRJproyecto a, PRJActividad b
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.PRJid=b.PRJid
	and a.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
	order by PRJcodigo, PRJAcodigo
</cfquery>

<cfquery datasource="#session.DSN#" name="pry">
	select PRJcodigo, PRJdescripcion
	from PRJproyecto
	where PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
</cfquery>

<style type="text/css">
	.color{
		color:#FF0000;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>


<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<!--- encabezado --->
	<tr><td>&nbsp;</td></tr>
	<tr><td>
		<cfoutput>
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr><td colspan="2" align="center"><strong><font size="3">Consulta de Avance de Proyectos</font></strong></td>
			<tr><td colspan="2" align="center"><strong><font size="3">Proyecto: #pry.PRJcodigo# - #pry.PRJdescripcion#</font></strong></td>
			</tr>
		</table> 
		</cfoutput>
	</td></tr>

	<!--- consulta --->
	<tr><td>&nbsp;</td></tr>
	<tr><td>
		<table width="100%" cellpadding="2" cellspacing="0">
			<cfset cortepry = ''>	
			<tr class="tituloListas">
				<td colspan="2" align="left" width="1%" nowrap><strong>Actividad</strong></td>
				<td align="right"><strong>Monto Presupuestado</strong></td>
				<td align="right"><strong>% Avance</strong></td>
				<td align="right"><strong>Proyectado</strong></td>
				<td align="right"><strong>Gastado</strong></td>
			</tr>
		
			<cfif data.RecordCount gt 0>
				<cfset total_presupuesto = 0 >
				<cfset total_avance = 0 >
				<cfset total_gastado = 0 >
				<cfset total_proyectado = 0 >	
				<cfoutput>
				<form style="margin:0;" name="form1" action="consAvanceDetalle.cfm" method="post">
					<input type="hidden" value="#form.PRJid#" name="PRJid">
					<input type="hidden" value="" name="PRJAid">
					<cfloop query="data">
						<cfset ppto = presupuesto(data.PRJAid, data.PRJid) >
						<tr title="Consultar recursos para la actividad #data.PRJAdescripcion#" style="cursor:hand;" class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" onclick="javascript: document.form1.PRJAid.value = #data.PRJAid#; document.form1.submit();">
							<td <cfif data.gastado gt ppto>class="color"</cfif> nowrap>#data.PRJAcodigo#</td>
							<td <cfif data.gastado gt ppto>class="color"</cfif> nowrap>#data.PRJAdescripcion#</td>
							<td <cfif data.gastado gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(ppto, 'none')#</td>
							<td <cfif data.gastado gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(data.avance,'none')# %</td>
							<td <cfif data.gastado gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(data.proyectado,'none')#</td>
							<td <cfif data.gastado gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(data.gastado,'none')#</td>
						</tr>
						<cfset total_presupuesto = total_presupuesto+ ppto >
						<cfset total_gastado = total_gastado+data.gastado >
						<cfset total_proyectado = total_proyectado+data.proyectado >	
						<cfset cortepry = data.PRJcodigo >	
					</cfloop>
				</form>
				</cfoutput>
	
				<cfoutput>
				<tr class="topline">
					<td class="topline" colspan="2"><strong>Total:</strong></td>
					<td class="topline" align="right"><strong>#LSCurrencyFormat(total_presupuesto, 'none')#</strong></td>
					<td class="topline" >&nbsp;</td>
					<td class="topline" align="right"><strong>#LSCurrencyFormat(total_gastado, 'none')#</strong></td>
					<td class="topline" align="right"><strong>#LSCurrencyFormat(total_proyectado, 'none')#</strong></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr class="tituloListas">
					<td colspan="6" align="center" width="1%" nowrap><strong>No se encontraron registros</strong></td>
				</tr>
			</cfif>
		</table>
	</td></tr>

	<tr><td>&nbsp;</td></tr>

	<cfif data.RecordCount gt 0>
		<!--- grafico--->
		<cfset grafico = QueryNew("desc, monto")>
		<cfset fila = QueryAddRow(grafico, 1)>
		<cfset tmp  = QuerySetCell(grafico, "desc", 'Presupuesto' ) >
		<cfset tmp  = QuerySetCell(grafico, "monto", total_presupuesto) >
	
		<cfset fila = QueryAddRow(grafico, 1)>
		<cfset tmp  = QuerySetCell(grafico, "desc", 'Proyectado' ) >
		<cfset tmp  = QuerySetCell(grafico, "monto", total_proyectado) >
	
		<cfset fila = QueryAddRow(grafico, 1)>
		<cfset tmp  = QuerySetCell(grafico, "desc", 'Gastado' ) >
		<cfset tmp  = QuerySetCell(grafico, "monto", total_gastado) >
	
		<tr><td align="center">
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr><td align="center" >
					<cfchart format="flash"
							 chartWidth=500
							 chartHeight=200
							 scaleFrom=0 
							 scaleTo=10 
							 gridLines=3 
							 labelFormat="number"
							 xAxisTitle=""
							 yAxisTitle="Monto"
							 show3D="yes"
							 yOffset="0.2" >
	
						<cfchartseries  type="bar"
										query="grafico" 
										valueColumn="monto" 
										itemColumn="desc" paintstyle="shade"/>
					</cfchart>
	
				</td></tr>
			</table>
		</td></tr>
	</cfif>
</table>
