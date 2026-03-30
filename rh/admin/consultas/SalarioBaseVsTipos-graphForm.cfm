<cfparam name="url.HYERVid" type="numeric" default="0">
<cfif url.HYERVid is 0 ><cflocation url="SalarioBaseVsPuntos.cfm"></cfif>

<cfquery datasource="#session.dsn#" name="hdr">
	select HYERVdescripcion
	from HYERelacionValoracion
	where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select  t.RHTPid, t.RHTPdescripcion, p.RHPdescpuesto puesto, 
			avg(d.DLTmonto) salariobase
	from LineaTiempo lt, DLineaTiempo d, ComponentesSalariales c, 
		 HYDRelacionValoracion y, RHPuestos p, RHTPuestos t
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and getdate() between lt.LTdesde and lt.LThasta
	  and d.LTid 	= lt.LTid
	  and c.CSid 	= d.CSid
	  and c.CSsalariobase = 1
	  and c.Ecodigo = lt.Ecodigo
	  and y.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and y.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
	  and y.RHPcodigo = lt.RHPcodigo
	  and p.RHPcodigo = lt.RHPcodigo
	  and p.Ecodigo = lt.Ecodigo
	  and t.RHTPid 	= p.RHTPid
	group by t.RHTPid, t.RHTPdescripcion, p.RHPdescpuesto, y.ptsTotal
	order by RHTPdescripcion, salariobase desc
</cfquery>
	<cfoutput>
	<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" >
		<tr>
		  	<td colspan="2" align="center">
		  		<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<cf_translate key="LB_DiagramaDeDispersionDeSalariosBasePorTipoDePuestos">Diagrama de Dispersi&oacute;n de Salarios Base por Tipo de Puestos</cf_translate>
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
						select  max(salariobase) as maxsalariobase
						from data
					</cfquery>
					
					<cfparam name="width" default="500">
					<cfparam name="height" default="300">
					<cfchart format="PNG" chartWidth="#width#" chartHeight="#height#" tipstyle="mouseover"
						xaxistitle="Tipo de Puesto" yaxistitle="Salarios"   showlegend="no"
						url="SalarioBaseVsTipos2-graph.cfm?HYERVid=#URLEncodedFormat(url.HYERVid)#&RHTP=$ITEMLABEL$"
							gridLines="4" show3d="no" scalefrom="0" scaleto="#tope.maxsalariobase*1.2#">
						<cfloop query="data">
							<cfchartseries type="scatter" paintstyle="light"   markerstyle="diamond" serieslabel="#puesto#">
								<cfchartdata item="#RHTPdescripcion# (#Trim(RHTPid)#)" value="#salariobase#">
							</cfchartseries>
						</cfloop>
					</cfchart> 
				</td>
				<td valign="top" align="center">
					<table width="100%"  border="0" cellspacing="0" cellpadding="1">
						<tr>
							<td class="tituloListas"><cf_translate key="LB_Tipo">Tipo</cf_translate></td>
							<td class="tituloListas"><cf_translate key="LB_Puesto">Puesto</cf_translate>&nbsp;</td>
							<td class="tituloListas" align="right"><cf_translate key="LB_SalarioBase">Salario Base</cf_translate>&nbsp;</td>
						</tr>
						<cfloop query="data">
							<tr class='<cfif CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0;cursor:hand" onClick='location.href="SalarioBaseVsTipos2-graph.cfm?HYERVid=#url.HYERVid#&RHTP=#URLEncodedFormat(RHTPdescripcion & " (" & Trim(RHTPid) & ")")#";'  >
								<td>#RHTPdescripcion#&nbsp;</td>
								<td>#puesto#&nbsp;</td>
								<td align="right">#NumberFormat(salariobase,',0.00')#&nbsp;</td>
							</tr>
						</cfloop>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr><td colspan="2" align="center"><span><cf_translate key="LB_NoHayDatos">No hay datos</cf_translate></span></td></tr>
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
				<input type="button" name="Regresar" value="#BTN_Regresar#" onClick="javascript:location.href='SalarioBaseVsTipos.cfm';" tabindex="1">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	
	</cfoutput>