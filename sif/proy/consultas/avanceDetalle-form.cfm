<cffunction name="presupuesto" returntype="numeric">
	<cfargument name="PRJAid" required="yes" type="numeric">
	<cfargument name="PRJid" required="yes" type="numeric">
	<cfargument name="PRJRid" required="yes" type="numeric">

	<cfquery name="rs" datasource="#session.DSN#">
		select sum(PRJPRcostoUnitModificado*PRJARcantidadModificada) as ppto
		from PRJActividadRecurso a, PRJProyectoRecurso c
		where a.PRJAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJAid#">
		and a.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
		and a.PRJRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJRid#">
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
	select a.PRJid, a.PRJAid, a.PRJRid, b.PRJRcodigo, b.PRJRdescripcion, b.Ucodigo, a.PRJARcantidadEstimada, a.PRJARcostoReal
	from PRJActividadRecurso a, PRJRecurso b
	where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and a.PRJAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
	  and a.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
	  and a.PRJRid=b.PRJRid
</cfquery>

<cfquery datasource="#session.DSN#" name="pry">
	select PRJcodigo, PRJdescripcion
	from PRJproyecto
	where PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
</cfquery>

<cfquery datasource="#session.DSN#" name="act">
	select PRJAcodigo, PRJAdescripcion, PRJAporcentajeAvance
	from PRJActividad
	where PRJAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJAid#">
	  and PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRJid#">
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
			<tr><td colspan="2" align="center"><strong><font size="3">Consulta de Actividades y Recursos por Proyecto</font></strong></td>
			<tr><td colspan="2" align="center"><strong><font size="3">Proyecto: #pry.PRJcodigo# - #pry.PRJdescripcion#</font></strong></td>
			<tr><td colspan="2" align="center"><strong><font size="3">Actividad: #act.PRJAcodigo# - #act.PRJAdescripcion#</font></strong></td>
			<tr><td colspan="2" align="center"><strong><font size="3">Avance: #act.PRJAporcentajeAvance# %</font></strong></td>
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
				<td colspan="2" align="left" width="1%" nowrap><strong>Recurso</strong></td>
				<td align="right"><strong>Unidad</strong></td>
				<td align="right"><strong>Cantidad</strong></td>
				<td align="right"><strong>Monto Presupuestado</strong></td>
				<td align="right"><strong>Gastado</strong></td>
			</tr>
		
			<cfset grafico = QueryNew("recurso,monto,desc,ord")>

			<cfif data.RecordCount gt 0>
				<cfset total_presupuesto = 0 >
				<cfset total_gastado = 0 >
				<cfoutput>
					<cfloop query="data">
						<cfset vtotal_presupuesto = 0 >
						<cfset vtotal_gastado = 0 >

						<cfset ppto = presupuesto(data.PRJAid, data.PRJid, data.PRJRid ) >
						<tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
							<td <cfif data.PRJARcostoReal gt ppto>class="color"</cfif> nowrap>#data.PRJRcodigo#</td>
							<td <cfif data.PRJARcostoReal gt ppto>class="color"</cfif> nowrap>#data.PRJRdescripcion#</td>
							<td <cfif data.PRJARcostoReal gt ppto>class="color"</cfif> align="right">#data.Ucodigo#</td>
							<td <cfif data.PRJARcostoReal gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(data.PRJARcantidadEstimada,'none')#</td>
							<td <cfif data.PRJARcostoReal gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(ppto,'none')#</td>
							<td <cfif data.PRJARcostoReal gt ppto>class="color"</cfif> align="right">#LSCurrencyFormat(data.PRJARcostoReal,'none')#</td>
						</tr>
						<cfset total_presupuesto = total_presupuesto+ ppto >
						<cfset total_gastado = total_gastado+data.PRJARcostoReal >

						<cfset vtotal_presupuesto = ppto >
						<cfset vtotal_gastado = data.PRJARcostoReal >

						<cfset fila = QueryAddRow(grafico, 1)>
						<cfset tmp  = QuerySetCell(grafico, "recurso", PRJRdescripcion ) >
						<cfset tmp  = QuerySetCell(grafico, "monto", vtotal_presupuesto) >
						<cfset tmp  = QuerySetCell(grafico, "desc", "presupuestado") >
						<cfset tmp  = QuerySetCell(grafico, "ord", "1") >

						<cfset fila = QueryAddRow(grafico, 1)>
						<cfset tmp  = QuerySetCell(grafico, "recurso", PRJRdescripcion ) >
						<cfset tmp  = QuerySetCell(grafico, "monto", vtotal_gastado) >
						<cfset tmp  = QuerySetCell(grafico, "desc", "gastado") >
						<cfset tmp  = QuerySetCell(grafico, "ord", "2") >
					</cfloop>
				</cfoutput>
	
				<cfoutput>
				<tr class="topline">
					<td class="topline" colspan="4"><strong>Total:</strong></td>
					<td class="topline" align="right"><strong>#LSCurrencyFormat(total_presupuesto, 'none')#</strong></td>
					<td class="topline" align="right"><strong>#LSCurrencyFormat(total_gastado, 'none')#</strong></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr class="tituloListas">
					<td colspan="6" align="center" width="1%" nowrap><strong>No se encontraron registros</strong></td>
				</tr>
			</cfif>

			<tr><td>&nbsp;</td></tr>
			<cfoutput>
			<form style="margin:0;" name="form1" action="consAvance.cfm" method="post">			
				<input type="hidden" name="PRJid" value="#form.PRJid#">
				<tr><td colspan="6" align="center"><input type="submit" name="Regresar" value="Regresar"></td></tr>
			</form>
			</cfoutput>
			<tr><td>&nbsp;</td></tr>			

		</table>
	</td></tr>

	<tr><td>&nbsp;</td></tr>

	<cfif data.RecordCount gt 0>
		<cfquery name="xxx" dbtype="query">
			select * from grafico order by ord
		</cfquery>
		<tr><td align="center">
			<table width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr><td align="center" >
					<cfchart format="flash" chartWidth="500" chartHeight="300"
							  gridLines=3 show3d="yes" seriesPlacement="stacked" rotated="no"  >
				
						<cfoutput query="xxx" group="desc" >
							<cfchartseries type="bar" seriesLabel="#desc#" paintstyle="shade" >
							
							<cfoutput>
								<cfchartdata item="#recurso#" value="#monto#"  >
							</cfoutput>
							
							</cfchartseries>
						</cfoutput>	
				
					</cfchart>
				</td></tr>
			</table>
		</td></tr>
		
	</cfif>
</table>
