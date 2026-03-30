<!--- 
Creado por Jose Gutierrez 
	07/03/2018
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','Reporte de Promociones')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Filtros del Reporte')>
<cfset LB_FechaDesde	= t.Translate('LB_FechaDesde','Fecha desde')>
<cfset LB_FechaHasta	= t.Translate('LB_FechaHasta','Fecha hasta')>
<cfset LB_FechaEn	= t.Translate('LB_FechaDesde','Fecha en')>

<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>


<cf_templateheader title="#LB_TituloH#">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_TituloH#'>


 

<cfinclude template="../../../sif/Utiles/sifConcat.cfm">
<form name="form1" action="reportePromociones_sql.cfm?p=0" method="post">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td align="center">
			<fieldset>
				<b>#LB_DatosReporte#</b>
			</fieldset>
			<table  width="50%" cellpadding="2" cellspacing="0" border="0">
				<tr align="center">
					<td>
						<table>
							<tr><td>&nbsp;</td></tr>
							<tr align="center">
								<td colspan="2">
									Promociones cuya fecha de inicio y fin<br>se encuentran dentro del rango:
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr align="center">
								<td><strong>#LB_FechaDesde#:&nbsp;</strong></td>
								<td>
									<cfset fechaDes = LSDateFormat(Now(),'dd/mm/yyyy')>
									<cf_sifcalendario form="form1" value="" name="fechaDesde" tabindex="1">
								</td>
							</tr>
							<tr  align="center">
								<td><strong>#LB_FechaHasta#:&nbsp;</strong></td>
								<td>
									<cfset fechaHas = LSDateFormat(Now(),'dd/mm/yyyy')>
									<cf_sifcalendario form="form1" value="#fechaHas#" name="fechaHasta" tabindex="1">
								</td>
							</tr>
						</table>
					</td>
					<td>
						<table>
							<tr valign="center">
								<td colspan="2">
									Promociones vigentes en el d&iacute;a de:
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr  align="center">
								<td> <strong>#LB_FechaEn#:&nbsp;</strong> </td>
								<td>
									<cfset fechaEn = LSDateFormat(Now(),'dd/mm/yyyy')>
									<cf_sifcalendario form="form1" value="#fechaEn#" name="fechaEn" tabindex="1">
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td >&nbsp;</td>
				</tr>
				<tr align="center">
					<td>
						<cf_botones values="Generar" names="GenerarA"  tabindex="1">
					</td>
					<td>
						<cf_botones values="Generar" names="GenerarB"  tabindex="1">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</form>
<cf_web_portlet_end>			

<cf_templatefooter>

 </cfoutput>


