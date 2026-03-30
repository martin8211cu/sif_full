<cfparam name="url.HYERVid" type="numeric" default="0">
<cfif url.HYERVid is 0 ><cflocation url="SalarioBaseVsPuntos.cfm"></cfif>

<cfquery datasource="#session.dsn#" name="hdr">
	select HYERVdescripcion
	from HYERelacionValoracion
	where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))) as RHPcodigoext,
			p.RHPcodigo, 
			p.RHPdescpuesto puesto, 
			y.ptsTotal puntos, 
			avg(d.DLTmonto) salariobase
	from LineaTiempo lt, DLineaTiempo d, ComponentesSalariales c, HYDRelacionValoracion y, RHPuestos p
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and getdate() between lt.LTdesde and lt.LThasta
	  and d.LTid = lt.LTid
	  and c.CSid = d.CSid
	  and c.CSsalariobase = 1
	  and c.Ecodigo = lt.Ecodigo
	  and y.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and y.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
	  and y.RHPcodigo = lt.RHPcodigo
	  and p.RHPcodigo = lt.RHPcodigo
	  and p.Ecodigo = lt.Ecodigo
	group by coalesce(ltrim(rtrim(p.RHPcodigoext)),ltrim(rtrim(p.RHPcodigo))),p.RHPcodigo, p.RHPdescpuesto, y.ptsTotal
	order by y.ptsTotal asc, salariobase desc
</cfquery>
	<cfoutput>
			<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" >
			<tr>
				<td colspan="2" align="center">
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
						<cf_translate key="LB_DiagramaDispersionDelSalariosBase">Diagrama Dispersi&oacute;n del Salarios Base</cf_translate>
					</strong>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
						#hdr.HYERVdescripcion#
					</strong>
				</td>
			</tr>
			<cfif data.RecordCount gt 0>
				<tr>
					<td valign="top" align="center">
						<cfquery name="tope" dbtype="query">
							select max(puntos) as maxpuntos, max(salariobase) as maxsalariobase
							from data
						</cfquery>
						
						<cfparam name="width" default="500">
						<cfparam name="height" default="300">
						
						<cfchart format="flash" chartWidth="#width#" chartHeight="#height#" tipstyle="mouseover"
							xaxistitle="Puntos HAY" yaxistitle="Salarios"  showlegend="no"
							url="SalarioBaseVsPuntos2-graph.cfm?HYERVid=#url.HYERVid#&RHPcodigo=$SERIESLABEL$"
							gridLines="4" show3d="no" scalefrom="0" scaleto="#tope.maxsalariobase*1.2#" xAxisType="scale">
							<cfloop query="data">
								<!---<cfchartseries type="scatter" serieslabel="#puesto# (#Trim(RHPcodigo)#)"--->
								<cfchartseries type="scatter" serieslabel="#Trim(RHPcodigo)#"
								markerstyle="#ListGetAt('circle,diamond,letterx,mcross,rcross,rectangle,snow,triangle',Data.CurrentRow Mod 8 + 1)#">
									<cfchartdata item="#puntos#" value="#salariobase#">
								</cfchartseries>
							</cfloop>
						</cfchart> 
					</td>
					<td valign="top" align="center">
						
						<table width="100%"  border="0" cellspacing="0" cellpadding="1">
							<tr>
								<td class="tituloListas" colspan="2"><cf_translate key="LB_Puesto">Puesto</cf_translate>&nbsp;</td>
								<td class="tituloListas"><cf_translate key="LB_Puntos">Puntos</cf_translate>&nbsp;</td>
								<td class="tituloListas" align="right"><cf_translate key="LB_SalarioBase">Salario Base</cf_translate>&nbsp;</td>
							</tr>
							<cfquery name="_data" dbtype="query">
								select RHPcodigoext,RHPcodigo, puesto, puntos, salariobase
								from data
								order by 1
							</cfquery>
						
							<cfloop query="_data">
								<tr class='<cfif CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0;cursor:hand" onClick='location.href="SalarioBaseVsPuntos2-graph.cfm?HYERVid=#url.HYERVid#&RHPcodigo=#_data.RHPcodigo#";' >
									<td>#trim(_data.RHPcodigoext)#&nbsp;</td>
									<td>#_data.puesto#&nbsp;</td>
									<td align="right">#_data.puntos#&nbsp;</td>
									<td align="right">#NumberFormat(_data.salariobase,',0.00')#&nbsp;</td>
								</tr>
							</cfloop>
						</table>
					</td>
				</tr>
			<cfelse>
				<tr><td colspan="2" align="center">
					<span>
						<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
							<cf_translate key="LB_NoHayDatos">No hay datos</cf_translate>
						</strong>
					</span>
					</td>
				</tr>
			</cfif>
			
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2" align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Regresar"/>
					<input type="button" name="Regresar" value="#BTN_Regresar#" tabindex="1" onClick="javascript:location.href='SalarioBaseVsPuntos.cfm';">
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	
	</cfoutput>