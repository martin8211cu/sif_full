<cfparam name="url.HYERVid" type="numeric" default="0">
<cfif url.HYERVid is 0 ><cflocation url="SalarioBaseVsPuntos.cfm"></cfif>

<cfquery datasource="#session.dsn#" name="hdr">
	select HYERVdescripcion
	from HYERelacionValoracion
	where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
select {fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})} as Nombre, 
	 p.RHPdescpuesto, avg(d.DLTmonto) salariobase
from LineaTiempo lt, DLineaTiempo d, ComponentesSalariales c, HYDRelacionValoracion y,
	 RHPuestos p, RHTPuestos t, DatosEmpleado de
where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and getdate() between lt.LTdesde and lt.LThasta
  and d.LTid = lt.LTid
  and c.CSid = d.CSid
  and c.CSsalariobase = 1
  and c.Ecodigo = lt.Ecodigo
  and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and y.HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
  and y.RHPcodigo = lt.RHPcodigo
  and p.RHPcodigo = lt.RHPcodigo
  and p.Ecodigo = lt.Ecodigo
  and t.RHTPid = p.RHTPid
  and de.DEid = lt.DEid
  and de.Ecodigo = lt.Ecodigo
  and t.RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHTPid#">
group by {fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})}, 
	p.RHPdescpuesto
order by RHPdescpuesto, salariobase desc

</cfquery>


	
	<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" >
		<tr>
			<td colspan="2" align="center" class="tituloProceso">
		  		<!--- <strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">  --->
				<cf_translate key="LB_DiagramaDeDispersionDeSalariosBaseParaPuesto">Diagrama de Dispersi&oacute;n de Salarios Base para Puesto</cf_translate><cfoutput>#RHTPdescripcion# </cfoutput>
				<!--- </strong> --->
			</td>
		</tr>
		<tr><td colspan="2" align="center" class="tituloProceso"><cfoutput>#hdr.HYERVdescripcion#</cfoutput></td></tr>
		<cfif data.RecordCount gt 0>
			<tr>
				<td valign="top" align="center">
					<cfquery name="tope" dbtype="query">
						select  max(salariobase) as maxsalariobase
						from data
					</cfquery>

					<cfparam name="width" default="400">
					<cfparam name="height" default="300">
					<cfchart format="PNG" chartWidth="#width#" chartHeight="#height#" tipstyle="mouseover"
					xaxistitle="Puesto" yaxistitle="Salarios"   showlegend="no"
						gridLines="4" show3d="no" scalefrom="0" scaleto="#tope.maxsalariobase*1.2#">
						<cfoutput query="data" >
							<cfchartseries type="scatter" paintstyle="light" 
								markerstyle="diamond" serieslabel="#Nombre#">
								<cfchartdata item="#RHPdescpuesto#" value="#salariobase#">
							</cfchartseries>
						</cfoutput>
					</cfchart> 
				</td>
		   		<td valign="top" align="center">
					<table width="100%"  border="0" cellspacing="0" cellpadding="1">
						<cfoutput query="data" group="RHPdescpuesto">
							<tr>
								<td class="tituloListas" colspan="2">#RHPdescpuesto#&nbsp;</td>
								<td class="tituloListas" align="right"><cf_translate key="LB_SalarioBase">Salario Base</cf_translate>&nbsp;</td>
							</tr>
							<cfoutput>
							<tr class='<cfif data.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0" >
								<td class='<cfif data.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0" >&nbsp;</td>
								<td  class='<cfif data.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0" align="left">#Nombre#</td>
								<td  class='<cfif data.CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0" align="right">#NumberFormat(salariobase,',0.00')#&nbsp;</td>
							</tr>
							</cfoutput> 
						</cfoutput>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr><td colspan="2" align="center"><span class="tituloProceso"><cf_translate key="LB_NoHayDatos">No hay datos</cf_translate></span></td></tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfoutput>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Regresar"
					Default="Regresar"
					XmlFile="/rh/generales.xml"
					returnvariable="BTN_Regresar"/>
				<input type="button" name="Regresar" tabindex="1" value="#BTN_Regresar#" onClick="javascript:location.href='SalarioBaseVsTipos-graph.cfm?HYERVid=#URLEncodedFormat(url.HYERVid)#';">
				</cfoutput>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	 