   <!--- <cf_dumptable var ="#DatosEmpleado#">--->
   
<cfquery datasource="#session.DSN#" name="rsReporte"> 
	select * from #DatosEmpleado#
    order by DEidentificacion
</cfquery>

	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TituloReporte" Default="Reporte Detalle de PTU" returnvariable="LB_TituloReporte"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Identificacion"		Default="Identificacion" 	returnvariable="LB_Identificacion"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre (s)" 	returnvariable="LB_Nombre"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido Paterno" returnvariable="LB_Apellido1"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido Materno" returnvariable="LB_Apellido2"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaIngreso"Default="Fecha Ingreso"	returnvariable="LB_FechaIngreso"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaBaja"	Default="Fecha Baja" returnvariable="LB_FechaBaja"/>
   	<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalDias"	Default="Total de Dias considerados para PTU" returnvariable="LB_TotalDias"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalFaltas"	Default="Total de Faltas" returnvariable="LB_TotalFaltas"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TotalIncapa"	Default="Total de Incapacidades" returnvariable="LB_TotalIncapa"/>
    <cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SueldoAnual"	Default="Sueldo Anual" returnvariable="LB_SueldoAnual"/>
<cf_htmlReportsHeaders irA="repPTU.cfm"
FileName="Reporte_detalle_Planilla.xls"
title="#LB_TituloReporte#">
<cf_templatecss>
<table width="100%" border="1" cellpadding="0" cellspacing="0" align="center">
<cfoutput>
<tr>
	<td colspan="100%">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td>	
				<cf_EncReporte
					Titulo="#LB_TituloReporte#"
					Color="##E3EDEF"
					filtro1="Desde:#lsdateformat(form.FechaDesde,'dd/mm/yyyy')# al #lsdateformat(form.FechaHasta,'dd/mm/yyyy')#">
			</td>
		</tr>
		</table>
	</td>
 </tr>

 <tr>
  	<td  class="tituloListas" valign="top" ><strong>#LB_Identificacion#</strong>&nbsp;&nbsp;</td> 
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaIngreso#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_FechaBaja#</strong>&nbsp;</td> 
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalDias#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalFaltas#</strong>&nbsp;</td>
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalIncapa#</strong>&nbsp;</td>   
    <td  class="tituloListas" valign="top" align="right"><strong>#LB_SueldoAnual#</strong>&nbsp;</td>
 </tr>
 </cfoutput>
  
 <cfoutput query="rsReporte">
 <tr>
        <td nowrap align="right">#rsReporte.DEidentificacion#</td>
        <td nowrap>#rsReporte.ApPa#</td>
        <td nowrap>#rsReporte.ApMa#</td>
        <td nowrap>#rsReporte.Nombre#</td>            
        <td nowrap align="right">#DateFormat(rsReporte.FeAlta,"dd/mm/yyyy")#</td>
        <td nowrap align="right">#DateFormat(rsReporte.FeFini,"dd/mm/yyyy")#</td>
        <td nowrap align="right">#rsReporte.DiasTra#</td>
        <td nowrap align="right">#rsReporte.DiasFal#</td>
        <td nowrap align="right">#rsReporte.DiasInc#</td>
        <td nowrap align="right">#rsReporte.SueldoAnual#</td>
  </tr>
</cfoutput>    
 
<tr><td colspan="10" align="center"><strong><cf_translate key="LB_FinDelReporte"> --Fin Del Reporte-- </cf_translate></strong></td></tr>
</table>
