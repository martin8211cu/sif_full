<cfparam name="url.HYERVid" type="numeric" default="0">
<cfif url.HYERVid is 0 ><cflocation url="SalarioBaseVsPuntos.cfm"></cfif>

<cfquery datasource="#session.dsn#" name="hdr">
	select HYERVdescripcion
	from HYERelacionValoracion
	where HYERVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.HYERVid#">
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select  {fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})} as Nombre,  
	avg(d.DLTmonto) salariobase
	from LineaTiempo lt, DLineaTiempo d, ComponentesSalariales c, DatosEmpleado de
	where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and getdate() between lt.LTdesde and lt.LThasta
	  and d.LTid = lt.LTid
	  and c.CSid = d.CSid
	  and c.CSsalariobase = 1
	  and c.Ecodigo = lt.Ecodigo
	  and lt.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and de.DEid = lt.DEid
	  and lt.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.RHPcodigo)#">
	  and de.Ecodigo = lt.Ecodigo
	group by {fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})}
	order by salariobase asc
</cfquery>

	<cfoutput>
	<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" >
		<tr>
			<td colspan="2" align="center">
		  		<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<cf_translate key="LB_TablaDeSalariosParaElPuesto">Tabla de Salarios para el Puesto</cf_translate> #trim(puesto_data.RHPcodigo)# - #puesto_data.RHPdescpuesto#
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
				<cfchart format="jpg" chartWidth="#width#" chartHeight="#height#" tipstyle="mouseover"
					xaxistitle="Linea" yaxistitle="Salarios"  showlegend="no"  
					gridLines="4" show3d="no" scalefrom="0" scaleto="#tope.maxsalariobase*1.2#">
					<cfloop query="data">
						<cfchartseries type="line"   serieslabel="#Nombre#" markerstyle="#ListGetAt('circle,diamond,letterx,mcross,rcross,rectangle,snow,triangle',Data.CurrentRow Mod 8 + 1)#">
							<cfchartdata item="#data.CurrentRow#" value="#salariobase#">
						</cfchartseries>
					</cfloop>
				</cfchart> 

			</td>
		    <td valign="top" align="center">
			
				<table width="100%"  border="0" cellspacing="0" cellpadding="1">
					<tr>
						<td class="tituloListas">&nbsp;</td>
						<td class="tituloListas">Nombre&nbsp;</td>
						<td class="tituloListas" align="right">Salario Base&nbsp;</td>
					</tr>
					<cfloop query="data">
						<tr class='<cfif CurrentRow Mod 2>listaPar<cfelse>listaNon</cfif>' style="text-indent:0" >
							<td>#CurrentRow#&nbsp;</td>
							<td>#Nombre#&nbsp;</td>
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
				<input type="button" name="Regresar" value="#BTN_Regresar#" onClick="javascript:location.href='SalarioBaseVsPuntos-graph.cfm?HYERVID=#URLEncodedFormat(url.HYERVid)#';">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	
	</cfoutput>