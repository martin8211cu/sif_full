
<cfinvoke key="LB_Resumen_de_Conceptos" default="Resumen de Conceptos" returnvariable="LB_Resumen_de_Conceptos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Totales_Percepciones" default="Totales de Percepciones" returnvariable="LB_Totales_Percepciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Deducciones" default="Deducciones" returnvariable="LB_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Especie" default="Total En Especie" returnvariable="LB_Total_Especie" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Percepciones" default="Total Percepciones" returnvariable="LB_Total_Percepciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Deducciones" default="Total Deducciones" returnvariable="LB_Total_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Efectivo" default="Total Efectivo" returnvariable="LB_Total_Efectivo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NetoPagado" default="Neto Pagado" returnvariable="LB_NetoPagado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Gravable" default="Total Gravable" returnvariable="LB_Total_Gravable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Subsidio_Empleo" default="Total Subsidio Empleo" returnvariable="LB_Total_Subsidio_Empleo" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalarioBase"		Default="Salario Base" 	returnvariable="LB_SalarioBase"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ValesDespensa"		Default="Vales de despensa" 	returnvariable="LB_ValesDespensa"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_AusenciasFaltas"		Default="Ausencias / Faltas" 	returnvariable="LB_AusenciasFaltas"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SubsidioSalario"		Default="Subsidio Salario" 	returnvariable="LB_SubsidioSalario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ISPT"				Default="ISPT" 	returnvariable="LB_ISPT"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_IMSS"				Default="IMSS" 	returnvariable="LB_IMSS"/>

<cfset LvarFileName = "ResumenDeConceptos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">


<cfoutput>
    <cf_htmlReportsHeaders
        title="#LB_Resumen_de_Conceptos#"
        filename="#LvarFileName#"
        irA="ResumenPagosNomina-filtro.cfm">

<cfset filtro_1 = "RFC: #rsNomina.RCDescripcion#">
<cfset filtro_2 = "Tipo Nomina: #rsNomina.TDESCRIPCION#">
<cfset filtro_3 = "Periodo: #LSDateFormat(rsNomina.RCdesde,'dd/mm/yyyy')# al #LSDateFormat(rsNomina.RChasta,'dd/mm/yyyy')#">

<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			<table width="98%" cellpadding="0" cellspacing="0" align="center">
				<tr><td colspan="4">
                    <cf_EncReporte
						Titulo="#LB_Resumen_de_Conceptos#"
						Color="##E3EDEF"
						filtro1="#filtro_1#"
						filtro2="#filtro_2#"
						filtro3="#filtro_3#"
					>
				</td></tr>
			</table>
		</td>
	</tr>


	<tr>
    	<td>
		<table border="0" width="50%" cellpadding="2" cellspacing="3" align="center" style="font-size:12px">
             <tr class="tituloListas"><td colspan="4" align="center"><strong>#LB_Totales_Percepciones#</strong></td></tr>
             <tr >
             	<td>#LB_SalarioBase#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.SalarioBase),'none')#</td>
             </tr>
             <!--- <tr >
             	<td >#LB_ValesDespensa#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.ValesDespensa),'none')#</td>
             </tr> --->
             <cfquery name="rsPercepciones" dbtype="query">
                  select CIdescripcion, SUM(MtoIncidencia) AS MtoIncidencia
                  from rsPercepciones
                  GROUP BY CIdescripcion
                  ORDER BY CIdescripcion
             </cfquery>

             <cfloop query="rsPercepciones">
             	<tr >
                    <td >#rsPercepciones.CIdescripcion#</td>
                    <td nowrap align="right">#LSCurrencyformat((rsPercepciones.MtoIncidencia),'none')#</td>
                 </tr>
             </cfloop>

             <tr >
             	<td align="right" ><strong>#LB_Total_Especie#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotEspecie),'none')#</td>
             </tr>

             <tr class="tituloListas">
             	<td align="right" ><strong>#LB_Total_Percepciones#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotPercepciones),'none')#</td>
             </tr>


             <tr height="25"></tr>
             <tr  class="tituloListas"><td colspan="4" align="center"><strong>#LB_Deducciones#</strong></td></tr>
             <!--- <tr class="tituloListas">
             	<td >#LB_AusenciasFaltas#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.MtoFalta),'none')#</td>
             </tr> --->

             <tr class="tituloListas">
             	<td >#LB_ISPT#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.ISPT),'none')#</td>
             </tr>

             <!--- <tr class="tituloListas">
             	<td >#LB_SubsidioSalario#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotSubsidio),'none')#</td>
             </tr> --->


<!---             <cfloop query="rsCargas">
             	<tr class="tituloListas">
                    <td >#rsCargas.DCdescripcion#</td>
                    <td nowrap align="right">#LSCurrencyformat((rsCargas.MtoCarga),'none')#</td>
                 </tr>
             </cfloop>--->
             <tr class="tituloListas">
                <td >#LB_IMSS#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotCargas),'none')#</td>
             </tr>

             <cfloop query="rsDeducciones">
             	<tr class="tituloListas">
                    <td >#rsDeducciones.TDdescripcion#</td>
                    <td nowrap align="right">#LSCurrencyformat((rsDeducciones.MtoDeduc),'none')#</td>
                 </tr>
             </cfloop>
             <tr class="tituloListas">
             	<td align="right"><strong>#LB_Total_Deducciones#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotDeducciones),'none')#</td>
             </tr>


             <tr height="25"></tr>
             <tr class="tituloListas">
             	<td align="right"><strong>#LB_Total_Efectivo#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotEfectivo),'none')#</td>
             </tr>

             <tr class="tituloListas">
             	<td align="right"><strong>#LB_NetoPagado#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.NetoPagado),'none')#</td>
             </tr>

             <tr class="tituloListas">
             	<td align="right"><strong>#LB_Total_Gravable#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotGravable),'none')#</td>
             </tr>

             <tr class="tituloListas">
             	<td align="right"><strong>#LB_Total_Subsidio_Empleo#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotSubsidio),'none')#</td>
             </tr>

             <tr class="tituloListas">
             	<td align="right"><strong>#LB_Total_Especie#</strong></td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.TotEspecie),'none')#</td>
             </tr>

		</table>
		</td>
	</tr>
</table>
</cfoutput>
