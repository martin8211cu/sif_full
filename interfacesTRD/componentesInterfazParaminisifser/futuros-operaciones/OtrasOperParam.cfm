<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Futuros Otras Operaciones'>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="ProcOtrasOper.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>Datos del Proceso</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td></td>
						<td>
							<p align="center"> Seleccione su Operación </p>
						</td>
						<td></td>
					</tr>
					<tr> <td> <p> <br /> </p> </td> </tr>
					<tr>
						<td align="center">
						<input type="radio" name="TipoOper" value="0" checked="checked" tabindex="1">	
						<strong>Transferencias</strong></td>
						<td align="center">
						<input type="radio" name="TipoOper" value="1" tabindex="1">	
						<strong>Intereses</strong></td>
						<td align="center">
						<input type="radio" name="TipoOper" value="2" tabindex="1">	
						<strong>Comisiones</strong></td>
					</tr>
					<tr> <td> <p> <br /> </p> </td> </tr>
				</table>
				<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center" >
					<tr>
						<tr>
							<td>
								<p align="right"> Periodo a Procesar </p>
							</td>
						</tr>
						<tr> <td> <p> <br /> </p> </td> </tr>
						<td align="right"><strong>Fecha&nbsp;Desde:</strong></td>
						<td align="left" >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Hasta:</strong></td>
						<td>
							<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
								<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
				<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center" >	
					<tr><td align="center" colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
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
<script language="javascript" type="text/javascript">
	objForm.FechaI.required=true;
	objForm.FechaI.description='Fecha Desde';
	objForm.FechaF.required=true;
	objForm.FechaF.description='Fecha Hasta';
</script>

