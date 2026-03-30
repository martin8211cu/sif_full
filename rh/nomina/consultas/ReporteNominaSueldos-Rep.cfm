<cfinvoke key="LB_Resumen_de_sueldos" default="Resumen de sueldos" returnvariable="LB_Resumen_de_sueldos" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke key="LB_NumeroEmpleado" default="Num.Empleado" returnvariable="LB_NumeroEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_DiasTrabajo" default="Dias Trab" returnvariable="LB_DiasTrabajo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_RegistroFederalContribuyentes" default="RFC" returnvariable="LB_RegistroFederalContribuyentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ClaveUnicaRegistroPoblacion" default="CURP" returnvariable="LB_ClaveUnicaRegistroPoblacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Jornada" default="Jornada" returnvariable="LB_Jornada" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_SDI" default="SDI" returnvariable="LB_SDI" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_FechaAlta" default="Fecha Alta" returnvariable="LB_FechaAlta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Sueldo" default="Sueldo" returnvariable="LB_Sueldo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TotalIncidencias" default="Total Incidencias" returnvariable="LB_TotalIncidencias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TotalEspecie" default="Total Pagado" returnvariable="LB_TotalPagado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TotalPercepciones" default="Total Percepciones" returnvariable="LB_TotalPercepciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_NetoEspecie" default="Neto Especie" returnvariable="LB_NetoEspecie" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TotalCargas" default="Total Cargas" returnvariable="LB_TotalCargas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_TotalISPT" default="Total ISPT" returnvariable="LB_TotalISPT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Subsidio" default="Total Subsidio" returnvariable="LB_Total_Subsidio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Otras_Deducciones" default="Otras Deducciones" returnvariable="LB_Otras_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total_Ded" default="Total Ded" returnvariable="LB_Total_Ded" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke key="LB_Total_Efectivo" default="Total Efectivo" returnvariable="LB_Total_Efectivo" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SalarioDiario"		Default="Salario Diario" 	returnvariable="LB_SalarioDiario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre"		Default="Nombre" 	returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido1"	Default="Apellido1" returnvariable="LB_Apellido1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Apellido2"	Default="Apellido2" returnvariable="LB_Apellido2"/>


<cfset LvarFileName = "ResumenDePagos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">

<cfoutput>
<cf_htmlReportsHeaders 
	title="#LB_Resumen_de_sueldos#" 
	filename="#LvarFileName#"
	irA="ReporteNominaSueldos-filtro.cfm">
	
<cfset filtro_1 = "RFC: #rsNomina.RCDescripcion#">
<cfset filtro_2 = "Tipo Nomina: #rsNomina.TDESCRIPCION#">
<cfset filtro_3 = "Periodo: #LSDateFormat(rsNomina.RCdesde,'dd/mm/yyyy')# al #LSDateFormat(rsNomina.RChasta,'dd/mm/yyyy')#">

<table width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td>
			<table width="98%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>
					<cf_EncReporte
						Titulo="#LB_Resumen_de_sueldos#"
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
		<table border="0" width="100%" cellpadding="2" cellspacing="3" align="center">
        
             <tr>
                <td  class="tituloListas" valign="top"><strong>#LB_NumeroEmpleado#</strong>&nbsp;&nbsp;</td>
                <td  class="tituloListas" valign="top"><strong>#LB_Apellido1#</strong>&nbsp;&nbsp;</td>
                <td  class="tituloListas" valign="top"><strong>#LB_Apellido2#</strong>&nbsp;&nbsp;</td>
                <td  class="tituloListas" valign="top"><strong>#LB_Nombre#</strong>&nbsp;&nbsp;</td> 
                <td  class="tituloListas" valign="top"><strong>#LB_DiasTrabajo#</strong>&nbsp;&nbsp;</td>
                <td  class="tituloListas" valign="top" align="center"><strong>#LB_RegistroFederalContribuyentes#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="center"><strong>#LB_ClaveUnicaRegistroPoblacion#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="center"><strong>#LB_Jornada#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_SalarioDiario#</strong>&nbsp;</td>
                
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_SDI#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="center"><strong>#LB_FechaAlta#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_Sueldo#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalIncidencias#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_NetoEspecie#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalPercepciones#</strong>&nbsp;</td>
               <!--- <td  class="tituloListas" valign="top" align="right"><strong>#LB_NetoEspecie#</strong>&nbsp;</td>--->
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalCargas#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalISPT#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_Total_Subsidio#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_Otras_Deducciones#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_Total_Ded#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_TotalPagado#</strong>&nbsp;</td>
                <td  class="tituloListas" valign="top" align="right"><strong>#LB_Total_Efectivo#</strong>&nbsp;</td>
            </tr>

            <cfquery name="rsSalida" datasource="#session.DSN#">
                select *        
                from #salidaDNomina#        
                order by Ape1,Ape2,Nombre
            </cfquery>

            <cfloop query="rsSalida">
            <tr>
                <td nowrap>#rsSalida.Identificacion#</td>
                <td nowrap>#rsSalida.Ape1#</td>
                <td nowrap>#rsSalida.Ape2#</td>
                <td nowrap>#rsSalida.Nombre#</td>
                <td nowrap align="center">#LSCurrencyformat(rsSalida.DiasTrab,'none')#</td>
                <td nowrap>#rsSalida.RFC#</td>
                <td nowrap>#rsSalida.CURP#</td>
                <td nowrap>#rsSalida.Jornada#</td>
                <td nowrap align="right">#LSCurrencyformat((rsSalida.SalarioRef/30),'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.SDI,'none')#</td>
                <td nowrap align="center">#LSDateFormat(rsSalida.FechaAlta,'dd/mm/yyyy')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.SalarioB,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotIncidencias,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.NetoEspecie,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotPercepciones,'none')#</td>
                <!---<td nowrap align="right">#LSCurrencyformat(rsSalida.NetoEspecie,'none')#</td>--->
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotCargas,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotISPT,'none')#</td>
               	<td nowrap align="right">#LSCurrencyformat(rsSalida.TotSubsidio,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotOtrasDeducc,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotDeducciones,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.TotPagado,'none')#</td>
                <td nowrap align="right">#LSCurrencyformat(rsSalida.NetoEfectivo,'none')#</td>
            </tr>
			</cfloop>
		</table>
		</td>
	</tr>
</table>
</cfoutput>