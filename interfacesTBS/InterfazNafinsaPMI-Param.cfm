<!--- 
	Creado por: Maria de los Angeles Blanco López
		Fecha: 20 Julio 2011
 --->

<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte NAFINSA'>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="interfazNafinsaPMI-sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top">
			<fieldset><legend>Datos a procesar</legend>
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="1">&nbsp;</td></tr>
					<tr>
						<td align="right"><strong>Fecha&nbsp;Vencimiento:</strong></td>
						<td >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
					</tr>				
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="6"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<cfset session.ListaReg = "">
