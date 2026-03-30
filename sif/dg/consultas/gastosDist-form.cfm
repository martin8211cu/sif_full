<cfif isdefined("url.DGGDcodigo") and not isdefined("form.DGGDcodigo") >
	<cfset form.DGGDcodigo = url.DGGDcodigo >
</cfif>
<cfif isdefined("url.DGGDcodigo2") and not isdefined("form.DGGDcodigo2") >
	<cfset form.DGGDcodigo2 = url.DGGDcodigo2 >
</cfif>

<cfif form.DGGDcodigo gt form.DGGDcodigo2>
	<cfset tmp = form.DGGDcodigo >
	<cfset form.DGGDcodigo = form.DGGDcodigo2 >
	<cfset form.DGGDcodigo2 = tmp >	
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select a.DGGDid, a.DGGDcodigo#_Cat#' - '#_Cat#a.DGGDdescripcion as codigo, a.DGCDid, a.DGCid, a.Criterio

	from DGGastosDistribuir a	
	where 1 = 1 

	<cfif isdefined("form.DGGDcodigo") and len(trim(form.DGGDcodigo)) and isdefined("form.DGGDcodigo2") and len(trim(form.DGGDcodigo2))>
		and a.DGGDcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDcodigo#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDcodigo2#">
	<cfelseif isdefined("form.DGGDcodigo") and len(trim(form.DGGDcodigo))>
		and a.DGGDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDcodigo#">
	<cfelseif isdefined("form.DGGDcodigo2") and len(trim(form.DGGDcodigo2))>
		and a.DGGDcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGGDcodigo2#">
	</cfif>	
</cfquery>



<cf_templatecss>

<cfoutput>
<br>
<table width="100%" cellpadding="0" cellspacing="0" align="center">

	<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Listado de Gastos por Distribuir</strong></td></tr>

	<!---
	<tr><td align="center"><strong>Centro Funcional:</strong>&nbsp;01 - Tienda Limon </td></tr>
	<tr><td align="center"><strong>Categor&iacute;a:</strong> &nbsp;Todas</td></tr>
	<tr><td align="center"><strong>Clasificaci&oacute;n:</strong> &nbsp;Todas</td></tr>
	--->
</table>
<br>
</cfoutput>

<table width="98%" align="center" cellpadding="2" cellspacing="0">
	<cfoutput query="data">
		<cfset vGasto = data.DGGDid >
		<tr bgcolor="##CCCCCC">
			<td colspan="2"><strong>Gasto por Distribuir: #data.codigo#</strong></td>
		</tr>

		<tr >
			<td colspan="2">
				<table width="95%" align="right">
					<cfif len(trim(data.DGCDid))>
						<cfquery name="rsCriterio" datasource="#session.DSN#">
							select DGCDid, DGCDcodigo, DGCDdescripcion
							from DGCriteriosDistribucion
							where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCDid#">
						</cfquery>

						<tr>
							<td width="1%" nowrap="nowrap"><strong>Criterio de Distribuci&oacute;n:</strong>&nbsp;</td>
							<td>#rsCriterio.DGCDcodigo# - #rsCriterio.DGCDdescripcion#</td>
						</tr>
					<cfelse>
						<cfquery name="rsConceptos" datasource="#session.DSN#">
							select DGCid, DGCcodigo, DGdescripcion
							from DGConceptosER
							where DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCid#">
						</cfquery>

						<tr>
							<td width="1%" nowrap="nowrap"><strong>Concepto de Estado de Resultados:</strong>&nbsp;</td>
							<td>#rsConceptos.DGCcodigo# - #rsConceptos.DGdescripcion#</td>
							<td width="1%" nowrap="nowrap"><strong>Criterio:</strong>&nbsp;</td>
							<td>	<cfif data.Criterio eq 30 >Presupuesto Acumulado
									<cfelseif data.Criterio eq 40>Real Acumulado
									<cfelseif data.Criterio eq 50>Presupuesto Mes
									<cfelseif data.Criterio eq 60>Real Mes
									</cfif>
							</td>
						</tr>
					</cfif>
				</table>
			</td>
		</tr>


		
<!--- bgcolor="#D7D7D7" bgcolor="#E5E5E5"--->
		<cfquery name="data_deptos" datasource="#session.DSN#">
			select 
				  rtrim(b.DGGDcodigo)#_Cat#' - '#_Cat#b.DGGDdescripcion as gasto, 
				  a.PCDcatid, 
				  rtrim(c.PCDvalor) #_Cat#' - '#_Cat# c.PCDdescripcion as PCDdescripcion, 
				  a.PCEcatid
			
			from DGDeptosGastosDistribuir a
			
			inner join DGGastosDistribuir b
			on b.DGGDid=a.DGGDid
			and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
			
			inner join PCDCatalogo c
			on c.PCDcatid=a.PCDcatid
			
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
			  and a.DGGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vGasto#" >
	
			order by b.DGGDcodigo, c.PCDvalor
		</cfquery>
		
			<tr>
				<td colspan="5">
					<table width="95%" align="right" cellpadding="0" style="border: 1px solid ##B8B8B8;" >
						<tr>
							<td colspan="4" bgcolor="##D7D7D7" style=" padding:2; border-bottom: 1px solid ##B8B8B8;"><strong>Departamentos asociados</strong></td>
						</tr>
						<cfif data_deptos.recordcount gt 0 >
							<cfloop query="data_deptos">
								<tr>
									<tr >
										<td></td>
										<td colspan="4" style="padding:2px;">#trim(data_deptos.PCDdescripcion)#</td>
									</tr>
								</tr>
							</cfloop>
						<cfelse>
							<tr>
								<tr>
									<td colspan="2" style="padding-left:10px;"><i>No existen Departamentos asociados al Gasto por Distribuir</i></td>
								</tr>
							</tr>										
						</cfif> 	
						
					</table>
				</td>
			</tr>
			
			<cfquery name="data_actividad" datasource="#session.DSN#">
				select a.DGAid,b.DGAcodigo, b.DGAdescripcion, a.ValorFactor 
				from DGGastosActividad a
				
				inner join DGActividades b
				on b.DGAid=a.DGAid
				
				inner join DGGastosDistribuir c
				on  c.DGGDid = a.DGGDid
				
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
				  and a.DGGDid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vGasto#" >
				order by b.DGAcodigo, b.DGAdescripcion
			</cfquery>
		
			
			<tr><td colspan="5"  >
			<br>
				<table width="95%" align="right" style="border: 1px solid ##B8B8B8;" >
					<tr>
						<td colspan="4" bgcolor="##D7D7D7" style=" padding:2; border-bottom: 1px solid ##B8B8B8;"><strong>Actividades asociados</strong></td>
					</tr>
					<cfif data_actividad.recordcount gt 0 >
						<cfloop query="data_actividad">
							<tr>
								<tr>
									<td colspan="4" style="padding-left:10px;">#trim(data_actividad.DGAcodigo)# - #trim(data_actividad.DGAdescripcion)#  </td>
								</tr>
							</tr>
						</cfloop>
					<cfelse>
						<tr>
							<tr>
								<td colspan="2" style="padding-left:10px;"><i>No existen Actividades asociados al Gasto por Distribuir</i></td>
							</tr>
						</tr>										
					</cfif> 	
				</table>
			</td></tr>		
			
			<TR><TD>&nbsp;</TD></TR>			

	</cfoutput>
	<cfif data.recordcount eq 0>
		<TR><TD>&nbsp;</TD></TR>
		<TR><TD colspan="5" align="center">--- No se encontraron registros ---</TD></TR>
		<TR><TD>&nbsp;</TD></TR>	
	<cfelse>
		<TR><TD>&nbsp;</TD></TR>
		<TR><TD colspan="5" align="center">--- Fin del reporte ---</TD></TR>
		<TR><TD>&nbsp;</TD></TR>	
	</cfif>
</table>
