	<cfquery name="datos" datasource="#session.DSN#">
		select CFid, CFcodigo, CFdescripcion, sum(horas) as horas
		from #datos#
		
		<cfif isdefined("form._CFid") and len(trim(form._CFid))>
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._CFid#">
		</cfif>
		
		group by CFid, CFcodigo, CFdescripcion
		order by CFcodigo 
	</cfquery>

	<br />
	<table width="90%" cellpadding="3" cellspacing="0" align="center">
		<tr><td align="center" style="font-size:18px;"><strong style="font-size:18; "><cfoutput>#session.Enombre#</cfoutput></strong></td></tr>
		<tr><td align="center" style="font-size:14;"><strong style="font-size:14;"><cfoutput>#nombre_proceso#</cfoutput></strong></td></tr>
		<cfif isdefined("form.CFid") and len(rtrim(form.CFid))>
			<tr><td align="center" ><strong style="font-size:14;"><cfoutput>#LB_Centro_Funcional#</cfoutput>:&nbsp;</strong><cfoutput>#trim(rs_centrofuncional.CFcodigo)#-#rs_centrofuncional.CFdescripcion#</cfoutput></td></tr>
		<cfelse>
			<tr><td align="center" ><strong style="font-size:14;"><cfoutput>#LB_Centro_Funcional#</cfoutput>:&nbsp;</strong>Todos</td></tr>
		</cfif>
	</table>
	<br />
		
	<table width="95%" cellpadding="3" border="0" align="center">
		<tr>
			<td valign="top" width="60%" align="center">
				<table width="100%" cellpadding="3" cellspacing="0" align="center">
					<tr bgcolor="#CCCCCC" >
						<td bgcolor="#CCCCCC"><strong><cfoutput>#LB_Centro_Funcional#</cfoutput></strong></td>
						<td bgcolor="#CCCCCC"><strong><cfoutput>#LB_Horas#</cfoutput></strong></td>
					</tr>
					<cfoutput query="datos">
						<tr onclick="javascript:location.href='horascap.cfm?reporte=1&_CFid=#datos.CFid##parametros#'" style="cursor:pointer;" title="#LB_Consultar_Empleados#" >
							<td>#trim(datos.CFcodigo)#-#datos.CFdescripcion#</td>
							<td>#LSNumberFormat(datos.horas, ',9.00')#</td>
						</tr>
						<!---
						<tr bgcolor="##CCCCCC"><td colspan="3"><strong>#trim(datos.CFcodigo)#-#datos.CFdescripcion#</strong></td></tr>
						<tr bgcolor="##f5f5f5">
							<td><strong>Identificaci&oacute;n</strong></td>
							<td><strong>Empleado</strong></td>
							<td><strong>Horas</strong></td>
						</tr>
						<cfoutput>
							<tr>
								<td>#datos.DEidentificacion#</td>
								<td>#datos.DEapellido1# #datos.DEapellido2# #datos.DEnombre#</td>
								<td>#LSNumberFormat(datos.horas, ',9.00')#</td>
							</tr>
						</cfoutput>
						--->
					</cfoutput>
					
					<cfif datos.recordcount gt 0 >
						<tr><td colspan="2" align="center">--- <cfoutput>#LB_Fin_del_Reporte#</cfoutput> ---</td></tr>
					<cfelse>
						<tr><td colspan="2" align="center">--- <cfoutput>#LB_No_hay_datos#</cfoutput> ---</td></tr>
					</cfif>
					
				</table>
			</td>
			<cfif datos.recordcount gt 2 >
				<td valign="top" align="center">
					<!--- varia el largo del grafico, segun la cantidad de regisrtos --->
					<cfif datos.recordcount gt 2 and datos.recordcount lte 20>
						<cfset size = 350 >
					<cfelseif datos.recordcount gt 20 and datos.recordcount lte 40>
						<cfset size = 500 >
					<cfelseif datos.recordcount gt 40 and datos.recordcount lte 60>
						<cfset size = 750 >
					<cfelse >
						<cfset size = 1200 >
					</cfif>
	
					<cfchart title="#LB_titulo_grafico#" backgroundcolor="f5f5f5" chartheight="#size#" >
						<cfchartseries type="horizontalbar" >
							<cfloop query="datos">
								<cfchartdata item="#datos.CFcodigo#" value="#datos.horas#" >
							</cfloop>
						</cfchartseries>
					</cfchart>
				</td>
			</cfif>
		</tr>
	</table>
	
	

	
