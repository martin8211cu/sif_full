<cfif isDefined("Form.filtrar")>	
	<cfif isdefined('Form.sncodigo') and len(trim('Form.sncodigo'))>
		<cfset sncod = replace("#Form.sncodigo#", ",","")>	
	</cfif>
</cfif>

<cfif isdefined('Form.sncodigo') and len(trim('Form.sncodigo'))>
	<cfparam name="Form.sncodigo" default="#Form.sncodigo#">		
</cfif>
<cfif isdefined('Form.mesd')>	
	<cfparam name="Form.mesd" default="#Form.mesd#">	
</cfif>

<!--- Asignacion del nombre del mesD --->
<cfif '#form.mesd#' eq '1'>
	<cfset mesnd = "Enero">
</cfif>
<cfif '#form.mesd#' eq 2>
	<cfset mesnd = "Febrero">
</cfif>
<cfif '#form.mesd#' eq 3>
	<cfset mesnd = "Marzo">
</cfif>
<cfif '#form.mesd#' eq 4>
	<cfset mesnd = "Abril">
</cfif>
<cfif '#form.mesd#' eq 5>
	<cfset mesnd = "Mayo">
</cfif>
<cfif '#form.mesd#' eq 6>
	<cfset mesnd = "Junio">
</cfif>
<cfif '#form.mesd#' eq 7>
	<cfset mesnd = "Julio">
</cfif>
<cfif '#form.mesd#' eq 8>
	<cfset mesnd = "Agosto">
</cfif>
<cfif '#form.mesd#' eq 9>
	<cfset mesnd = "Septiembre">
</cfif>
<cfif '#form.mesd#' eq 10>
	<cfset mesnd = "Octubre">
</cfif>
<cfif '#form.mesd#' eq 11>
	<cfset mesnd = "Noviembre">
</cfif>
<cfif '#form.mesd#' eq 12>
	<cfset mesnd = "Diciembre">
</cfif>

<!--- Asignacion del nombre del mesH --->
<cfif '#form.mesh#' eq '1'>
	<cfset mesnh = "Enero">
</cfif>
<cfif '#form.mesh#' eq 2>
	<cfset mesnh = "Febrero">
</cfif>
<cfif '#form.mesh#' eq 3>
	<cfset mesnh = "Marzo">
</cfif>
<cfif '#form.mesh#' eq 4>
	<cfset mesnh = "Abril">
</cfif>
<cfif '#form.mesh#' eq 5>
	<cfset mesnh = "Mayo">
</cfif>
<cfif '#form.mesh#' eq 6>
	<cfset mesnh = "Junio">
</cfif>
<cfif '#form.mesh#' eq 7>
	<cfset mesnh = "Julio">
</cfif>
<cfif '#form.mesh#' eq 8>
	<cfset mesnh = "Agosto">
</cfif>
<cfif '#form.mesh#' eq 9>
	<cfset mesnh = "Septiembre">
</cfif>
<cfif '#form.mesh#' eq 10>
	<cfset mesnh = "Octubre">
</cfif>
<cfif '#form.mesh#' eq 11>
	<cfset mesnh = "Noviembre">
</cfif>
<cfif '#form.mesh#' eq 12>
	<cfset mesnh = "Diciembre">
</cfif>



<cfif isdefined('Form.periodod')>
	<cfparam name="Form.periodod" default="#Form.periodod#">
</cfif>
<cfif isdefined('Form.mesh')>
	<cfparam name="Form.mesh" default="#Form.mesh#">
</cfif>
<cfif isdefined('Form.periodoh')>
	<cfparam name="Form.periodoh" default="#Form.periodoh#">
</cfif>
<cfset mesd = Form.mesd>
<cfset mesh = Form.mesh>
<cfset periodod = Form.periodod>
<cfset periodoh = Form.periodoh>

<cfif form.tip eq 1>
    <cfinvoke component="sif.cg.reportes.RpteDIOTSQL" method="ConsultaTablaReporte" returnvariable="rsRPTdiot">
<cfelse>
	<cfinvoke component="sif.cg.reportes.RpteDIOTSQL" method="ConsultaDetallada" returnvariable="rsRPTdiot">
</cfif>

<!---<cfdump var="#rsRPTdiot#">--->


<style type="text/css">
	.style0 {text-align: center; text-transform: uppercase; font-size: 16px; text-shadow: Black; font-weight: bold; }
	.style1 {text-align: center; text-transform: uppercase; font-size: 14px; text-shadow: Black; font-weight: bold; }
	.style2 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style3 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style4 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black;}
	.style5 {text-align: left;   text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
</style>
<br>
<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
		<tr>
			<td class="style0">#Session.Enombre#</td>
		</tr>
		<tr>
			<td class="style1">Reporte DIOT</td>
		</tr>
		<tr>
			<td class="style2">			
			Desde: #mesnd#/#Form.periodod# -- Hasta: #mesnh#/#Form.periodoh#		
			</td>
		</tr>
		<tr>
			<td class="style2">			
			Tipo:<cfif form.tip eq 1>Resumido<cfelse>Detallado</cfif>		
			</td>
		</tr>				
	</table>
</cfoutput>
<br>


<br>
<cfoutput>

<br/>
<table>
	<tr>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Socio</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Tipo de Tercero</td>	
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Tipo de Operaci&oacute;n</td>	
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Identificaci&oacute;n (RFC)</td>	
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Numero de ID Fiscal</td>	
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Pa&iacute;s</td>	
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Nacionalidad</td>
	<cfif form.tip eq 2>			
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Documento</td>	
	</cfif>		
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Valor de Actos Pagados al 15 o 16 de IVA</td>	
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Valor de Actos Pagados al 10 o 11 de IVA</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Monto del IVA No Acreditable</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Valor de los Actos Pagados por IVA Exento Servicios Personales o Extranjeros</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Valor de los Actos Pagados por IVA 0%</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">Valor de los Actos Pagados por IVA Excento Actividades</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">IVA Trasladado (Pagado) 15 o 16</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">IVA Trasladado (Pagado) 10 o 11</td>
		<td class="tituloListas" style="text-shadow: Black; font-weight: bold;">IVA Correspondiente a las Devoluciones</td>	
	</tr>
	<cfloop query="rsRPTdiot">
		<tr>
			<td style="border-bottom: 1px solid black; " >#rsRPTdiot.SNnombre#</td>
			<td style="border-bottom: 1px solid black; " >#rsRPTdiot.DIOTcodigo#</td>
			<td style="border-bottom: 1px solid black; " >#rsRPTdiot.DIOTopcodigo#</td>
			<td style="border-bottom: 1px solid black; " >#rsRPTdiot.SNidentificacion#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IdFisc#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.Ppais#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.Nacional#</td>
		<cfif form.tip eq 2>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.Documento#</td> 
		</cfif>	
        	<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVAOtros#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVABienesServicios#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVAPagado#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVAExeBienesServicios#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVAcero#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVAExentoOtros#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVAotrosPagados#</td>
			<td style="border-bottom: 1px solid black; " align="center">#rsRPTdiot.IVABienesServiciosPagados#</td>
            <td style="border-bottom: 1px solid black; " align="center">0.00</td>
		</tr>
	</cfloop>

</table>	
</cfoutput>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="style4"> ------------------ Fin del Reporte ------------------ </td>
	</tr>
</table>
